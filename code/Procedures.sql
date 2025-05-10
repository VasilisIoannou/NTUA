-- Active: 1746819443116@@127.0.0.1@3309@festivaldb
DELIMITER //

CREATE PROCEDURE insert_reselling_ticket(
   IN p_EAN BIGINT,
   OUT result_message VARCHAR(255)
)
BEGIN
  DECLARE v_event_id INT;
  DECLARE v_number_of_tickets INT;
  DECLARE v_stage_capacity INT;
  DECLARE v_validated BOOLEAN;

  -- Find the event_id
  SELECT event_id INTO v_event_id FROM ticket WHERE EAN_13 = p_EAN;
  
  -- Count the tickets
  SELECT COUNT(*) INTO v_number_of_tickets FROM ticket WHERE event_id = v_event_id;

  -- Find the Stage Capacity
  SELECT s.stage_capacity INTO v_stage_capacity
  FROM event e
  JOIN stage s ON e.stage_id = s.stage_id
  WHERE e.event_id = v_event_id;

  -- Find if the ticket is NOT VALIDED
  SELECT validated INTO v_validated FROM ticket WHERE EAN_13 = p_EAN; 

  IF v_validated THEN
        signal sqlstate '45000' 
        set message_text = 'You Cant sell a validated ticket'; 
  END IF;

  -- Check if the stage is sold out 
  IF v_number_of_tickets < FLOOR(v_stage_capacity*0.93) THEN
    SET result_message = 'Cannot resell - tickets still available for purchase';
  ELSE
    INSERT INTO reselling_tickets (EAN_13) VALUES (p_EAN);
    SET result_message = CONCAT('Ticket added to reselling platform. Number of Tickets: ', v_number_of_tickets, ' - stage capacity: ', v_stage_capacity);
  END IF;
END //

CREATE PROCEDURE insert_visitor_with_ticket(
    IN p_visitor_name VARCHAR(255),
    IN p_visitor_surname VARCHAR(255),
    IN p_visitor_age INT,
    IN p_visitor_email VARCHAR(255),
    IN p_visitor_phone VARCHAR(255),
    IN p_EAN_13 BIGINT,
    IN p_ticket_type_name VARCHAR(255),
    IN p_event_id INT,
    IN p_payment_method_id INT,
    OUT result_message VARCHAR(255)
)
BEGIN
    DECLARE v_visitor_id INT;
    DECLARE v_ticket_type_id INT;
    DECLARE v_ticket_price FLOAT;
    DECLARE v_price_exists INT;
    DECLARE v_stage_capacity INT;	
    DECLARE v_sold_count INT; 
    DECLARE v_max_stage_capacity INT;
    DECLARE v_max_vip_tickets INT;
    DECLARE v_vip_tickets_sold INT;

    DECLARE v_pass_checks BOOLEAN DEFAULT TRUE;

    -- Variables for EAN-13 check
    DECLARE ean13_str CHAR(13);
    DECLARE ean12_str CHAR(12);
    DECLARE i INT DEFAULT 1;
    DECLARE sum_odd INT DEFAULT 0;
    DECLARE sum_even INT DEFAULT 0;
    DECLARE digit INT;
    DECLARE calculated_check_digit INT;
    DECLARE provided_check_digit INT;

    -- Start transaction
    START TRANSACTION;
    
    -- Validate ticket type
    SELECT ticket_type_id INTO v_ticket_type_id 
    FROM ticket_type 
    WHERE ticket_type_name = p_ticket_type_name;
    
    IF v_ticket_type_id IS NULL THEN
        SET result_message = 'Invalid ticket type specified';
    	SET v_pass_checks = FALSE;
    END IF;
    
    -- Validate ticket price exists
    SELECT COUNT(*), ticket_price_price INTO v_price_exists, v_ticket_price
    FROM ticket_price
    WHERE ticket_type_id = v_ticket_type_id AND event_id = p_event_id;
    
    IF v_price_exists = 0 THEN
        SET result_message = 'No price defined for this ticket type at the specified event';
    	SET v_pass_checks = FALSE;
    END IF;

    -- EAN-13 Validation check
    -- Convert input to string and ensure it has exactly 13 digits
    SET ean13_str = LPAD(p_EAN_13, 13, '0');
    IF CHAR_LENGTH(ean13_str) != 13 THEN
        SET result_message = 'EAN-13 code must be exactly 13 digits long.';
    	SET v_pass_checks = FALSE;
    END IF;

    -- Extract the first 12 digits
    SET ean12_str = LEFT(ean13_str, 12);

    -- Calculate the sum of digits in odd and even positions
    WHILE i <= 12 DO
        SET digit = CAST(SUBSTRING(ean12_str, i, 1) AS UNSIGNED);
        IF MOD(i, 2) = 1 THEN
            SET sum_odd = sum_odd + digit;
        ELSE
            SET sum_even = sum_even + digit;
        END IF;
        SET i = i + 1;
    END WHILE;

    -- Calculate the check digit
    SET calculated_check_digit = (10 - ((sum_odd + sum_even * 3) MOD 10)) MOD 10;

    -- Extract the provided check digit
    SET provided_check_digit = CAST(RIGHT(ean13_str, 1) AS UNSIGNED);

    -- Compare the calculated check digit with the provided one
    IF calculated_check_digit != provided_check_digit THEN
            SET result_message = 'Invalid EAN-13 check digit.';
    	    SET v_pass_checks = FALSE;
    END IF;

    -- VIP capacity check (only if ticket type is VIP)
    IF p_ticket_type_name = 'VIP' THEN
        -- Get stage capacity for this event
        SELECT s.stage_capacity INTO v_stage_capacity
        FROM event e
        JOIN stage s ON e.stage_id = s.stage_id
        WHERE e.event_id = p_event_id;
        
        -- Calculate 10% of capacity
        SET v_max_vip_tickets = FLOOR(v_stage_capacity * 0.1 * 0.93);
        
        -- Count existing VIP tickets for this event
        SELECT COUNT(*) INTO v_vip_tickets_sold
        FROM ticket t
        JOIN ticket_type tt ON t.ticket_type_id = tt.ticket_type_id
        WHERE t.event_id = p_event_id
        AND tt.ticket_type_name = 'VIP';
        
        -- Check if adding one more would exceed limit
        IF v_vip_tickets_sold >= v_max_vip_tickets THEN
            SET result_message = CONCAT('Vip Tickets reach max capacity, current tickets: ', v_vip_tickets_sold, ' - max vip tickets: ', v_max_vip_tickets);
	        SET v_pass_checks = FALSE;        
	    END IF;
    END IF;

    -- A) Look up the stage's capacity for this event:
    SELECT stage_capacity
    INTO v_stage_capacity
    FROM event e
    JOIN stage s 
    ON e.stage_id = s.stage_id
    WHERE e.event_id = p_event_id;

    -- B) Count existing tickets for that same stage:
    SELECT COUNT(*) 
    INTO v_sold_count
    FROM ticket t
    JOIN event ev 
    ON t.event_id = ev.event_id
    WHERE ev.stage_id = (
        SELECT stage_id 
        FROM event 
        WHERE event_id = p_event_id
    );

    -- C) If this new ticket would exceed capacity, abort the insert:
    IF (v_sold_count + 1) > FLOOR(v_stage_capacity * 0.93) THEN
        SET result_message = CONCAT('Tickets sold out, v_sold_count: ', v_sold_count, ' - v_stage_capacity: ', v_stage_capacity);
  	    SET v_pass_checks = FALSE;
    END IF;

    IF NOT v_pass_checks THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = result_message;
    END IF;

    -- Insert visitor data
    INSERT INTO visitor (visitor_name, visitor_surname, visitor_age)
    VALUES (p_visitor_name, p_visitor_surname, p_visitor_age);
    
    -- Get the auto-generated visitor_id
    SET v_visitor_id = LAST_INSERT_ID();
    
    -- Insert visitor contact information
    INSERT INTO visitor_contact (visitor_id, visitor_email, visitor_phone)
    VALUES (v_visitor_id, p_visitor_email, p_visitor_phone);

    -- Insert ticket data
    INSERT INTO ticket (EAN_13, ticket_type_id, visitor_id, event_id, ticket_price, payment_method_id, validated)
    VALUES (p_EAN_13, v_ticket_type_id, v_visitor_id, p_event_id, v_ticket_price, p_payment_method_id, FALSE);
    
    -- Commit the transaction
    COMMIT;
    
    -- Return the new visitor_id and EAN_13 for reference
    SELECT v_visitor_id AS new_visitor_id, p_EAN_13 AS ticket_EAN;
END //

/*
 When Inserting a Performance it must check if the Artist in that performance are valid
 An Artist can not be in the festiuval 3 years in a row
 Artist -> Band -> Performance -> Event -> festival years
 Find all the Bands the Artist is in, then find all the Performances the Bands previously found are in and then find all the events the Performances(p)
 Check the current year (Max(festival_years)) and then search for the 2 previous years if they are in the query
*/

DELIMITER //
/* This procedure performs various checks before inserting a performance*/
CREATE PROCEDURE insert_performance_break(
    p_performance_type_id INT,
    p_performance_start INT,
    p_performance_end INT,
    p_event_id INT,
    p_band_id INT,
    p_break_duration INT
)
BEGIN
    DECLARE v_current_year INT;
    DECLARE v_previous_year_1 INT;
    DECLARE v_previous_year_2 INT;
    DECLARE v_artist_id INT;
    DECLARE v_artist_count INT;
    DECLARE v_artist_violation_found BOOLEAN DEFAULT FALSE;
    DECLARE done INT DEFAULT FALSE;

    DECLARE conflicts INT;
    DECLARE event_conflicts INT;
    DECLARE v_event_start INT;
    DECLARE v_event_end INT;

    DECLARE v_warm_up_id INT;
    DECLARE v_closing_act_id INT;
    DECLARE existing_closing INT;
    DECLARE warm_up_conflict INT;
    DECLARE closing_conflict INT;

    DECLARE artist_cursor CURSOR FOR 
        SELECT artist_id FROM artist_band WHERE band_id = p_band_id;

    -- Handler for when no more rows in cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
   
    -- Basic Checks
    -- First validate performance time constraints
    IF p_performance_start >= p_performance_end THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Performance start time must be before end time';
    END IF;

    IF (p_performance_end - p_performance_start) > 180 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Performance duration cannot exceed 3 hours';
    END IF;

    -- Find Event starnt and end
    SELECT event_start INTO v_event_start FROM event WHERE event_id = p_event_id;
    SELECT event_end INTO v_event_end FROM event WHERE event_id = p_event_id;

    /*Check if the Performances are within Event duration*/
    IF (p_performance_start < v_event_start) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The Performance start can not be before the event start';
    END IF;

    IF (p_performance_end + p_break_duration / 60) > v_event_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The performance + break can not exceed the event duration';
    END IF;


    -- Check for overlapping with other performances and their breaks
    SELECT COUNT(*) INTO conflicts
    FROM performance p
    JOIN event e ON p.event_id = e.event_id
    LEFT JOIN break_duration bd ON bd.event_id = e.event_id AND bd.break_start = p.performance_end
    WHERE e.event_id = p_event_id
    AND (
        p_performance_start < (p.performance_end + IFNULL(bd.break_duration, 0)/60.0)
        AND (p_performance_end + (p_break_duration / 60.0)) > p.performance_start
    );

    IF conflicts > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There is a conflict with an existing performance or break.';
    END IF;

    -- Check Performance type
    SELECT performance_type_id INTO v_warm_up_id FROM performance_type WHERE performance_type_name = 'Warm up';
    SELECT performance_type_id INTO v_closing_act_id FROM performance_type WHERE performance_type_name = 'Closing act';

    -- Warm up check: Must be the first performance
    IF p_performance_type_id = v_warm_up_id THEN
        SELECT COUNT(*) INTO warm_up_conflict
        FROM performance
        WHERE event_id = p_event_id
          AND performance_start < p_performance_start;

        IF warm_up_conflict > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Warm up must be the first performance in the event';
        END IF;
    END IF;

    -- Closing act checks
    IF p_performance_type_id = v_closing_act_id THEN
        -- Check existing Closing act
        SELECT COUNT(*) INTO existing_closing
        FROM performance
        WHERE event_id = p_event_id
          AND performance_type_id = v_closing_act_id;
	IF existing_closing > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Only one Closing act allowed per event';
        END IF;

        -- Check performances after Closing act
        SELECT COUNT(*) INTO closing_conflict
        FROM performance
        WHERE event_id = p_event_id
          AND performance_start > p_performance_start;

        IF closing_conflict > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Closing act must be the last performance in the event';
        END IF;
    END IF;

    -- Get the current festival year from the event
    SELECT festival_year INTO v_current_year
    FROM event
    WHERE event_id = p_event_id;

    -- Calculate previous years
    SET v_previous_year_1 = v_current_year - 1;
    SET v_previous_year_2 = v_current_year - 2;

   -- Must Find all the Artist associated with this performance
   -- An artist can not play 3 years in a row ...

   -- Open cursor
   OPEN artist_cursor;

   -- Loop through artists
   artist_loop: LOOP
        FETCH artist_cursor INTO v_artist_id;
        IF done THEN
        	 LEAVE artist_loop;
        END IF;


        -- Count how many of the previous two years this artist performed
        SELECT COUNT(DISTINCT e.festival_year) INTO v_artist_count
        FROM performance p
        JOIN event e ON p.event_id = e.event_id
        JOIN artist_band ab ON p.band_id = ab.band_id  -- Link to artist via artist_band
        WHERE ab.artist_id = v_artist_id
        AND e.festival_year IN (v_previous_year_1, v_previous_year_2);
        
	-- If artist performed in both previous years, set violation flag
        IF v_artist_count >= 2 THEN
            SET v_artist_violation_found = TRUE;
            LEAVE artist_loop; -- No need to check other artists
        END IF;
    END LOOP artist_loop;
    
    -- Close cursor
    CLOSE artist_cursor;

     -- If any artist violates the constraint, return false
    IF v_artist_violation_found THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Artist cannot perform in the festival for 3 consecutive years';
    END IF;

    -- Check the break duration
    IF p_break_duration < 300 OR p_break_duration > 1800 THEN
	SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'The break should be between 300 and 1800 seconds';
    END IF;

    -- If all checks passed, insert the performance
    INSERT INTO performance (
        performance_type_id,
        performance_start,
        performance_end,
        event_id,
        band_id
    ) VALUES (
        p_performance_type_id,
        p_performance_start,
        p_performance_end,
        p_event_id,
        p_band_id
    );

    -- Insert the break
    INSERT INTO break_duration(break_start,break_duration,event_id)
    VALUES (p_performance_end,p_break_duration,p_event_id);
END//

/* The Below Procedure should Check if the resseling ticket id is valid and if it is ... */
/* ... it should remove the ticket from reselling_ticket TABLE and update the tickets data */

CREATE PROCEDURE reselling_desired_by_id(
    IN p_buyer_id INT,
    IN p_reselling_ticket_id INT,
    OUT result_message VARCHAR(255)
)
BEGIN
   DECLARE v_check_buyer INT;
   DECLARE v_check_reselling_ticket INT;
   
   DECLARE v_EAN_13 BIGINT;
   DECLARE v_visitor_id INT;  

   DECLARE v_valid BOOLEAN DEFAULT TRUE;

   -- Check if Valid buyer id
   SELECT COUNT(*) INTO v_check_buyer FROM buyer WHERE buyer_id = p_buyer_id;
   
   IF v_check_buyer = 0 THEN 
	SET result_message = 'The buyer Id does not exists';
	SET v_valid = FALSE;
   END IF;
   
   -- Check if Valid reselling_ticket_id
   SELECT COUNT(*) INTO v_check_reselling_ticket FROM reselling_tickets WHERE reselling_ticket_id = p_reselling_ticket_id;
   
   IF v_check_reselling_ticket = 0 THEN 
	SET result_message = 'The buyer Id does not exists';
	SET v_valid = FALSE;
   END IF;   
   
   IF v_valid = FALSE THEN	
        signal sqlstate '45000' 
        set message_text = result_message; 
   END IF;

   -- Find the ticket EAN 13
   SELECT EAN_13 INTO v_EAN_13 FROM reselling_tickets WHERE reselling_ticket_id = p_reselling_ticket_id; 
 
   -- Find the visitor id
   SELECT visitor_id INTO v_visitor_id FROM buyer WHERE buyer_id = p_buyer_id; 

   -- Replace the visitor id in the ticket
   UPDATE ticket SET visitor_id = v_visitor_id WHERE EAN_13 = v_EAN_13;

   -- Remove the ticket from the Reselling_ticket
   DELETE FROM reselling_tickets WHERE reselling_ticket_id = p_reselling_ticket_id;
 
   -- Save to ticket_transfer log
   INSERT INTO ticket_transfer(buyer_id,EAN_13) VALUES (p_buyer_id,v_EAN_13);

   SET result_message = 'The ticket was bought successfully!'; 
END//

CREATE PROCEDURE insert_buyer_visitor(
     p_name VARCHAR(255),
     p_surname VARCHAR(255),
     p_age INT
)
BEGIN
     DECLARE v_visitor_id INT;

     INSERT INTO visitor(visitor_name,visitor_surname,visitor_age) VALUES (p_name,p_surname,p_age);
     
     SET v_visitor_id = LAST_INSERT_ID();

     INSERT INTO buyer(visitor_id) VALUES (v_visitor_id);
END//



DELIMITER ;
