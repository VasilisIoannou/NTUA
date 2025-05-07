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






