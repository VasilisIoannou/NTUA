/* Trigger to prevent deletion of festivals*/
DELIMITER //

CREATE TRIGGER prevent_festival_deletion
BEFORE DELETE ON festival
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Festivals cannot be deleted from the system';
END//

-- Trigger to prevent deletion of events
CREATE TRIGGER prevent_event_deletion
BEFORE DELETE ON event
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Events cannot be deleted from the system';
END//

/* Trigger to prevent invalid reviews */
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
END//

-- This trigger prevents artists from being assigned to multiple stages at the same time
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
END//

-- Trigger to prevent overlapping events
CREATE TRIGGER prevent_event_overlapping
BEFORE INSERT ON event
FOR EACH ROW
BEGIN
    DECLARE conflicts INT;

    SELECT COUNT(*) INTO conflicts
    FROM event e
    WHERE e.stage_id = NEW.stage_id 
    AND e.festival_year = NEW.festival_year
    AND e.festival_day = NEW.festival_day
    AND(
        NEW.event_start BETWEEN e.event_start AND e.event_end
    );

    IF conflicts > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is already an event asssigned to this stage during this time.';
    END IF;
END;
//

-- Trigger to check event start and end times
CREATE TRIGGER check_event_start_end
BEFORE INSERT ON event
FOR EACH ROW
BEGIN
    IF NEW.event_start >= NEW.event_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Event start time must be before end time.';
    END IF;
END;
//

/* Two triggers to manage band_members count */

/* 1.Trigger to set band_members to 0 before inserting a band */
CREATE TRIGGER set_band_members_to_zero
BEFORE INSERT ON band
FOR EACH ROW
BEGIN
    SET NEW.band_members = 0;
END//

/* 2.Trigger to automatically increment band_members when a new artist is added to a band */
CREATE TRIGGER increment_band_members
AFTER INSERT ON artist_band
FOR EACH ROW
BEGIN
    UPDATE band
    SET band_members = band_members + 1
    WHERE band_id = NEW.band_id;
END//

/* Trigger to check staffing requirements after a ticket is sold */
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
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Warning: Add more security staff for this stage.';
    END IF;

    -- Check if secondary staff is less than 2% of total tickets
    IF v_secondary_staff < CEIL(v_total_tickets * 0.02) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Warning: Add more secondary staff for this stage.';
    END IF;
END//

/* Trigger to delete break after performance deletion */
CREATE TRIGGER delete_break_after_performance
AFTER DELETE ON performance
FOR EACH ROW
BEGIN
    DELETE FROM break_duration
    WHERE event_id = OLD.event_id
      AND break_start = OLD.performance_end;
END //


/* Trigger to check band formation year before performance */
CREATE TRIGGER check_band_formation_before_performance
BEFORE INSERT ON performance
FOR EACH ROW
BEGIN
    DECLARE v_festival_year INT;
    DECLARE v_band_formation_year INT;

    -- Get the festival year of the event this performance belongs to
    SELECT festival_year INTO v_festival_year
    FROM event
    WHERE event_id = NEW.event_id;

    -- Get the band's year of formation
    SELECT bdf.band_year_of_formation INTO v_band_formation_year
    FROM band b
    JOIN band_date_of_formation bdf ON b.band_date_of_formation_id = bdf.band_date_of_formation_id
    WHERE b.band_id = NEW.band_id;

    -- Compare formation year with festival year
    IF v_band_formation_year > v_festival_year THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Band cannot perform before its formation year.';
    END IF;


    /* Compare artists' year of birth and festival year*/
    IF EXISTS (
        SELECT 1
        FROM artist a
        JOIN artist_band ab ON a.artist_id = ab.artist_id
        WHERE ab.band_id = NEW.band_id
          AND a.artist_year_of_birth > v_festival_year
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'One or more artists were born after the festival year.';
    END IF;
    
END;
//

DELIMITER ;


