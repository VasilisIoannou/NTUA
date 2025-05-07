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
    
    DECLARE validated_ticket INT;
    DECLARE visitor_to_review INT;
    DECLARE performance_to_review INT;
    DECLARE event_to_review INT;

    SELECT visitor_id INTO visitor_to_review
    FROM reviews
    WHERE visitor_id = NEW.visitor_id;

    SELECT performance_id INTO performance_to_review
    FROM reviews
    WHERE performance_id = NEW.performance_id;

    SELECT event_id INTO event_to_review
    FROM performance
    WHERE performance_id = performance_to_review;

    select validated INTO validated_ticket
    from ticket
    where visitor_id = NEW.visitor_id AND event_id = event_to_review;

    -- Get validated_ticket from ticket

    IF validated_ticket = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ticket is not validated, cannot leave a review';
    END IF;

END//

DELIMITER ;






