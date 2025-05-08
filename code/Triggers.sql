DELIMITER //

-- Trigger to prevent deletion of festivals
CREATE TRIGGER prevent_festival_deletion
BEFORE DELETE ON festival
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Festivals cannot be deleted from the system';
END//

DELIMITER //


-- Trigger to prevent deletion of events
CREATE TRIGGER prevent_event_deletion
BEFORE DELETE ON event
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Events cannot be deleted from the system';
END//

DELIMITER //

-- Trigger to prevent invalid reviews
DELIMITER //

CREATE TRIGGER prevent_invalid_review
BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN
    DECLARE event_of_performance INT;
    DECLARE ticket_count INT;

    -- Get the event_id related to the performance
    SELECT event_id INTO event_of_performance
    FROM performance
    WHERE performance_id = NEW.performance_id;

    -- Check if the visitor has a validated ticket for that event
    SELECT COUNT(*) INTO ticket_count
    FROM ticket
    WHERE visitor_id = NEW.visitor_id
      AND event_id = event_of_performance
      AND validated = TRUE;

    -- If not, raise an error
    IF ticket_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Visitor cannot review performance. Ticket not validated.';
    END IF;
END;
//

DELIMITER ;

-- Trigger to prevent exceeding stage capacity
DELIMITER //

CREATE TRIGGER check_stage_capacity
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
  DECLARE sold_count  INT;
  DECLARE max_capacity INT;

  -- A) Look up the stage’s capacity for this event:
  SELECT s.stage_capacity
    INTO max_capacity
    FROM event e
    JOIN stage s 
      ON e.stage_id = s.stage_id
   WHERE e.event_id = NEW.event_id;

  -- B) Count existing tickets for that same stage:
  SELECT COUNT(*) 
    INTO sold_count
    FROM ticket t
    JOIN event ev 
      ON t.event_id = ev.event_id
   WHERE ev.stage_id = (
           SELECT stage_id 
             FROM event 
            WHERE event_id = NEW.event_id
         );

  -- C) If this new ticket would exceed capacity, abort the insert:
  IF sold_count + 1 > max_capacity THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot buy ticket: stage is sold out.';
  END IF;
END; //

DELIMITER ;


DELIMITER //

-- This trigger prevents bands from being assigned to multiple stages at the same time
DELIMITER //

CREATE TRIGGER prevent_artist_stage_conflict
BEFORE INSERT ON performance
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*) INTO conflict_count
    FROM performance p
    JOIN event e1 ON p.event_id = e1.event_id
    JOIN event e2 ON NEW.event_id = e2.event_id
    JOIN artist_band ab1 ON ab1.band_id = p.band_id
    JOIN artist_band ab2 ON ab2.band_id = NEW.band_id
    WHERE ab1.artist_id = ab2.artist_id
      AND e1.stage_id != e2.stage_id
      AND (
        NEW.performance_start < p.performance_end AND
        NEW.performance_end > p.performance_start
      );

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Artist is scheduled to perform on another stage at this time.';
    END IF;
END;
//

DELIMITER ;

DELIMITER ;

-- This trigger prevents overlaping performances
CREATE TRIGGER prevent_performance_overlapping
BEFORE INSERT ON performance
FOR EACH ROW
BEGIN
    DECLARE conflicts INT;

    SELECT COUNT(*) INTO conflicts
    FROM performance p
    JOIN event e1 ON p.event_id = e1.event_id
    JOIN event e2 ON NEW.event_id = e2.event_id
    WHERE e1.event_id = e2.event_id
    AND (
        NEW.performance_start BETWEEN p.performance_start AND p.performance_end
    );
    
    IF conflicts > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is already a performance asssigned to this stage during this time.';
    END IF;
END;
//

DELIMITER ;


DELIMITER $$

-- Trigger to check staffing requirements after a ticket is sold
CREATE TRIGGER check_staffing_requirements
AFTER INSERT ON ticket
FOR EACH ROW
BEGIN
    DECLARE v_stage_id INT;
    DECLARE v_total_tickets INT;
    DECLARE v_security_staff INT;
    DECLARE v_secondary_staff INT;

    -- Retrieve the stage_id associated with the event
    SELECT e.stage_id INTO v_stage_id
    FROM event e
    WHERE e.event_id = NEW.event_id;

    -- Count total tickets sold for the event
    SELECT COUNT(*) INTO v_total_tickets
    FROM ticket
    WHERE event_id = NEW.event_id;

    -- Count security staff assigned to the stage
    SELECT COUNT(*) INTO v_security_staff
    FROM stage_staff ss
    JOIN staff s ON ss.staff_id = s.staff_id
    JOIN staff_role sr ON s.staff_role_id = sr.staff_role_id
    WHERE ss.stage_id = v_stage_id AND sr.staff_role_name = 'Security';

    -- Count secondary staff assigned to the stage
    SELECT COUNT(*) INTO v_secondary_staff
    FROM stage_staff ss
    JOIN staff s ON ss.staff_id = s.staff_id
    JOIN staff_role sr ON s.staff_role_id = sr.staff_role_id
    WHERE ss.stage_id = v_stage_id AND sr.staff_role_name = 'Secondary';

    -- Check if security staff is less than 5% of total tickets
    IF v_security_staff < CEIL(v_total_tickets * 0.05) THEN
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Warning: Add more security staff for this stage.';
    END IF;

    -- Check if secondary staff is less than 2% of total tickets
    IF v_secondary_staff < CEIL(v_total_tickets * 0.02) THEN
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = 'Warning: Add more secondary staff for this stage.';
    END IF;
END$$

DELIMITER ;








