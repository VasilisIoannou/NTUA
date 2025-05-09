DELIMITER //

CREATE PROCEDURE insert_visitor_with_ticket(
    IN p_visitor_name VARCHAR(255),
    IN p_visitor_surname VARCHAR(255),
    IN p_visitor_age INT,
    IN p_visitor_email VARCHAR(255),  -- Now optional
    IN p_visitor_phone VARCHAR(255),  -- Now optional
    IN p_EAN_13 BIGINT,
    IN p_ticket_type_name VARCHAR(255),
    IN p_event_id INT,
    IN p_payment_method_id INT
)
BEGIN
    DECLARE v_visitor_id INT;
    DECLARE v_ticket_type_id INT;
    DECLARE v_ticket_price FLOAT;
    DECLARE v_price_exists INT;
    DECLARE v_stage_capacity INT;	
    DECLARE v_sould_count INT; 

    -- Start transaction
    START TRANSACTION;
    
    -- Validate ticket type
    SELECT ticket_type_id INTO v_ticket_type_id 
    FROM ticket_type 
    WHERE ticket_type_name = p_ticket_type_name;
    
    IF v_ticket_type_id IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid ticket type specified';
    END IF;
    
    -- Validate ticket price exists
    SELECT COUNT(*), ticket_price_price INTO v_price_exists, v_ticket_price
    FROM ticket_price
    WHERE ticket_type_id = v_ticket_type_id AND event_id = p_event_id;
    
    IF v_price_exists = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No price defined for this ticket type at the specified event';
    END IF;

    -- VIP capacity check (only if ticket type is VIP)
    IF p_ticket_type_name = 'VIP' THEN
        -- Get stage capacity for this event
        SELECT s.stage_capacity INTO v_stage_capacity
        FROM event e
        JOIN stage s ON e.stage_id = s.stage_id
        WHERE e.event_id = p_event_id;
        
        -- Calculate 10% of capacity
        SET v_max_vip_tickets = FLOOR(v_stage_capacity * 0.1);
        
        -- Count existing VIP tickets for this event
        SELECT COUNT(*) INTO v_vip_tickets_sold
        FROM ticket t
        JOIN ticket_type tt ON t.ticket_type_id = tt.ticket_type_id
        WHERE t.event_id = p_event_id
        AND tt.ticket_type_name = 'VIP';
        
        -- Check if adding one more would exceed limit
        IF v_vip_tickets_sold >= v_max_vip_tickets THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = CONCAT('VIP ticket limit reached (max ', v_max_vip_tickets, ' tickets)');
        END IF;
    END IF;

    --Number of Tickets <= stage capacity

  -- A) Look up the stage’s capacity for this event:
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
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot buy ticket: stage is sold out.';
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

DELIMITER ;

-- Reselling tickets is only available if all tickets are sold per stage
-- I will create a procedure to allow inserting records to resseling_tickets only if the number of tickets == stage capacity 

DELIMITER //

CREATE PROCEDURE insert_reseling_ticket_proc(
   IN p_EAN BIGINT,
   OUT result_message VARCHAR(255)
)
BEGIN
  DECLARE v_event_id INT;
  DECLARE v_number_of_tickets INT;
  DECLARE v_stage_capacity INT;

  -- Find the event_id
  SELECT event_id INTO v_event_id FROM tickets WHERE EAN_13 = p_EAN;
  
  -- Count the tickets
  SELECT COUNT(*) INTO v_number_of_tickets FROM tickets WHERE event_id = v_event_id;

  -- Find the Stage Capacity
  SELECT s.stage_capacity INTO v_stage_capacity
  FROM events e
  JOIN stage s ON e.stage_id = s.stage_id
  WHERE e.event_id = v_event_id;

  -- Check if the stage is sold out 
  IF v_number_of_tickets < v_stage_capacity THEN
    SET result_message = 'Cannot resell - tickets still available for purchase';
  ELSE
    INSERT INTO reseling_tickets (EAN_13) VALUES (p_EAN);
    SET result_message = 'Ticket added to reselling platform';
  END IF;
END //

DELIMITER ;

-- When Inserting a Performance it must check if the Artist in that performance are valid
-- An Artist can not be in the festiuval 3 years in a row
-- Artist -> Band -> Performance -> Event -> festival years
-- Find all the Bands the Artist is in, then find all the Performances the Bands previously found are in and then find all the events the Performances(p)
-- Check the current year (Max(festival_years)) and then search for the 2 previous years if they are in the query
CREATE FUNCTION insert_performance(
    p_performance_type_id INT,
    p_performance_start INT,
    p_performance_end INT,
    p_event_id INT,
    p_band_id INT
) RETURNS BOOLEAN
BEGIN
    DECLARE v_current_year INT;
    DECLARE v_previous_year_1 INT;
    DECLARE v_previous_year_2 INT;
    DECLARE v_artist_id INT;
    DECLARE v_artist_count INT;
    DECLARE v_artist_violation_found BOOLEAN DEFAULT FALSE;
    DECLARE done INT DEFAULT FALSE;

    DECLARE artist_cursor CURSOR FOR 
        SELECT artist_id FROM artist WHERE band_id = p_band_id;
    
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

    --Check Overlapping Performances
    /* Markidis */

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
        FROM artist a
        JOIN band b ON a.band_id = b.band_id
        JOIN performance p ON b.band_id = p.band_id
        JOIN event e ON p.event_id = e.event_id
        WHERE a.artist_id = v_artist_id
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

RETURN TRUE;
END//

