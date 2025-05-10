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
CREATE TRIGGER prevent_invalid_review_insert
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

CREATE TRIGGER prevent_invalid_review_update
BEFORE UPDATE ON reviews
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
CREATE TRIGGER prevent_artist_stage_conflict_insert
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

CREATE TRIGGER prevent_artist_stage_conflict_update
BEFORE UPDATE ON performance
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
CREATE TRIGGER prevent_event_overlapping_insert
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
        (NEW.event_start BETWEEN e.event_start AND e.event_end) OR
        (NEW.event_end BETWEEN e.event_start AND e.event_end) OR
        (NEW.event_start <= e.event_start AND NEW.event_end >= e.event_end)
    );

    IF conflicts > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is already an event asssigned to this stage during this time.';
    END IF;
END;
//

CREATE TRIGGER prevent_event_overlapping_update
BEFORE UPDATE ON event
FOR EACH ROW
BEGIN
    DECLARE conflicts INT;

    SELECT COUNT(*) INTO conflicts
    FROM event e
    WHERE e.stage_id = NEW.stage_id 
    AND e.festival_year = NEW.festival_year
    AND e.festival_day = NEW.festival_day
    AND(
        (NEW.event_start BETWEEN e.event_start AND e.event_end) OR
        (NEW.event_end BETWEEN e.event_start AND e.event_end) OR
        (NEW.event_start <= e.event_start AND NEW.event_end >= e.event_end)
    );

    IF conflicts > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is already an event asssigned to this stage during this time.';
    END IF;
END;
//

-- Trigger to check event start and end times
CREATE TRIGGER check_event_start_end_insert
BEFORE INSERT ON event
FOR EACH ROW
BEGIN
    IF NEW.event_start >= NEW.event_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Event start time must be before end time.';
    END IF;
END;
//

CREATE TRIGGER check_event_start_end_update
BEFORE UPDATE ON event
FOR EACH ROW
BEGIN
    IF NEW.event_start >= NEW.event_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Event start time must be before end time.';
    END IF;
END;
//

CREATE TRIGGER check_event_day_insert
BEFORE INSERT ON event
FOR EACH ROW
BEGIN
    
    DECLARE conflicts INT;
    
    SELECT COUNT(*) INTO conflicts
    FROM festival f
    WHERE f.duration < NEW.festival_day
    AND f.festival_year = NEW.festival_year;

    IF conflicts > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign an event to a day outside the festival duration.';
    END IF;
END;
//

CREATE TRIGGER check_event_day_update
BEFORE UPDATE ON event
FOR EACH ROW
BEGIN
    
    DECLARE conflicts INT;
    
    SELECT COUNT(*) INTO conflicts
    FROM festival f
    WHERE f.duration < NEW.festival_day
    AND f.festival_year = NEW.festival_year;

    IF conflicts > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot assign an event to a day outside the festival duration.';
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

/* 2.Trigger to automatically decrement band_members when an artist is deleted from a band */
CREATE TRIGGER decrement_band_members
AFTER DELETE ON artist_band
FOR EACH ROW
BEGIN
    UPDATE band
    SET band_members = band_members - 1;
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
CREATE TRIGGER check_band_formation_before_performance_insert
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

CREATE TRIGGER check_band_formation_before_performance_update
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

CREATE TRIGGER check_band_members_before_performance_insert
BEFORE INSERT ON performance
FOR EACH ROW
BEGIN
    DECLARE no_band_members INT;

    SELECT band_members INTO no_band_members
    FROM band
    WHERE band_id = NEW.band_id;

    IF no_band_members = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Band does not have any members';
    END IF; 
END;
//

CREATE TRIGGER check_band_members_before_performance_update
BEFORE UPDATE ON performance
FOR EACH ROW
BEGIN
    DECLARE no_band_members INT;

    SELECT band_members INTO no_band_members
    FROM band
    WHERE band_id = NEW.band_id;

    IF no_band_members = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Band does not have any members';
    END IF; 
END;
//

/* Triggers to call reselling ticket procedure */
CREATE TRIGGER check_matches_reselling_tickets
AFTER INSERT ON reselling_tickets FOR EACH ROW
BEGIN
	CALL process_ticket_matches();
END//


CREATE TRIGGER check_matches_desired_ticket_by_event
AFTER INSERT ON desired_ticket_by_event FOR EACH ROW
BEGIN
	CALL process_ticket_matches();
END//


/* Trigger to ensure that staff specialization is only assigned to technicians */
CREATE TRIGGER check_technician_specialization_insert
BEFORE INSERT ON staff_specialization
FOR EACH ROW
BEGIN
    DECLARE staff_role_id INT;

    SELECT sr.staff_role_id INTO staff_role_id
    FROM staff s
    JOIN staff_role sr ON s.staff_role_id = sr.staff_role_id
    WHERE s.staff_id = NEW.staff_id;

    IF staff_role_id != 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Staff specialization can only be assigned to technicians.';
    END IF;
END//

CREATE TRIGGER check_technician_specialization_update
BEFORE UPDATE ON staff_specialization
FOR EACH ROW
BEGIN
    DECLARE staff_role_id INT;

    SELECT sr.staff_role_id INTO staff_role_id
    FROM staff s
    JOIN staff_role sr ON s.staff_role_id = sr.staff_role_id
    WHERE s.staff_id = NEW.staff_id;

    IF staff_role_id != 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Staff specialization can only be assigned to technicians.';
    END IF;
END//

/* Trigger to automatically set staff_role_id to 1 for technician_specialization */
CREATE TRIGGER auto_set_role_id_insert
BEFORE INSERT ON technician_specialization
FOR EACH ROW
BEGIN
    SET NEW.staff_role_id = 1;
END//

CREATE TRIGGER auto_set_role_id_update
BEFORE UPDATE ON technician_specialization
FOR EACH ROW
BEGIN
    SET NEW.staff_role_id = 1;
END//

/* Trigger to prevent staff overlaping */
DELIMITER //

CREATE TRIGGER prevent_staff_stage_overlap_insert
BEFORE INSERT ON stage_staff
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*) INTO conflict_count
    FROM stage_staff ss
    JOIN event e1 ON e1.stage_id = ss.stage_id
    JOIN event e2 ON e2.stage_id = NEW.stage_id
    WHERE ss.staff_id = NEW.staff_id
      AND e1.festival_year = e2.festival_year
      AND e1.festival_day = e2.festival_day
      AND (
           (e2.event_start BETWEEN e1.event_start AND e1.event_end) OR
           (e2.event_end BETWEEN e1.event_start AND e1.event_end) OR
           (e2.event_start <= e1.event_start AND e2.event_end >= e1.event_end)
          );

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Staff member has a scheduling conflict on a different stage at the same time.';
    END IF;
END//

CREATE TRIGGER prevent_staff_stage_overlap_update
BEFORE UPDATE ON stage_staff
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*) INTO conflict_count
    FROM stage_staff ss
    JOIN event e1 ON e1.stage_id = ss.stage_id
    JOIN event e2 ON e2.stage_id = NEW.stage_id
    WHERE ss.staff_id = NEW.staff_id
      AND e1.festival_year = e2.festival_year
      AND e1.festival_day = e2.festival_day
      AND (
           (e2.event_start BETWEEN e1.event_start AND e1.event_end) OR
           (e2.event_end BETWEEN e1.event_start AND e1.event_end) OR
           (e2.event_start <= e1.event_start AND e2.event_end >= e1.event_end)
          );

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Staff member has a scheduling conflict on a different stage at the same time.';
    END IF;
END//

/* Trigger to call staff assignment procedure */
CREATE TRIGGER assign_security_staff
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    CALL assign_security_staff();
END//

CREATE TRIGGER assign_secondary_staff
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    CALL assign_secondary_staff();
END//

/* This trigger assigns security staff to stages based on ticket sales. If */
CREATE TRIGGER assign_security_if_needed
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    DECLARE ticket_count INT;
    DECLARE security_count INT;
    DECLARE stage_id_val INT;
    DECLARE staff_to_assign INT;
    DECLARE available_staff_count INT;

    -- Get stage_id from the event
    SELECT e.stage_id INTO stage_id_val
    FROM event e WHERE e.event_id = NEW.event_id;

    -- Count existing tickets for this stage
    SELECT COUNT(*) INTO ticket_count
    FROM ticket t
    JOIN event e ON e.event_id = t.event_id
    WHERE e.stage_id = stage_id_val;

    -- Count current security staff on the stage
    SELECT COUNT(*) INTO security_count
    FROM stage_staff ss
    JOIN staff s ON s.staff_id = ss.staff_id
    WHERE ss.stage_id = stage_id_val AND s.staff_role_id = 2;

    -- Count available security staff not assigned to the stage
    SELECT COUNT(*) INTO available_staff_count
    FROM staff s
    WHERE s.staff_role_id = 2
      AND s.staff_id NOT IN (
          SELECT staff_id FROM stage_staff WHERE stage_id = stage_id_val
      );

    -- Check if more security is needed
    IF ticket_count + 1 > security_count * 20 THEN
        -- Find one available security staff not yet on this stage
        SELECT s.staff_id INTO staff_to_assign
        FROM staff s
        WHERE s.staff_role_id = 2
          AND s.staff_id NOT IN (
              SELECT staff_id FROM stage_staff WHERE stage_id = stage_id_val
          )
        LIMIT 1;

        -- If we found one, assign them
        IF staff_to_assign IS NOT NULL THEN
            INSERT INTO stage_staff(stage_id, staff_id)
            VALUES (stage_id_val, staff_to_assign);
        ELSE
            -- If no staff available, issue a warning
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add ticket: This stage needs more security staff. Not enough security staff available to assign to the stage.';
        END IF;
    END IF;
END;
//

/* This trigger assigns secondary staff to stages based on ticket sales */
CREATE TRIGGER assign_secondary_if_needed
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    DECLARE ticket_count INT;
    DECLARE secondary_count INT;
    DECLARE stage_id_val INT;
    DECLARE staff_to_assign INT;
    DECLARE available_staff_count INT;

    -- Get stage_id from the event
    SELECT e.stage_id INTO stage_id_val
    FROM event e WHERE e.event_id = NEW.event_id;

    -- Count existing tickets for this stage
    SELECT COUNT(*) INTO ticket_count
    FROM ticket t
    JOIN event e ON e.event_id = t.event_id
    WHERE e.stage_id = stage_id_val;

    -- Count current secondary staff on the stage
    SELECT COUNT(*) INTO secondary_count
    FROM stage_staff ss
    JOIN staff s ON s.staff_id = ss.staff_id
    WHERE ss.stage_id = stage_id_val AND s.staff_role_id = 3;  -- Role ID for Secondary staff

    -- Count available secondary staff not assigned to the stage
    SELECT COUNT(*) INTO available_staff_count
    FROM staff s
    WHERE s.staff_role_id = 3  -- Secondary staff role ID
      AND s.staff_id NOT IN (
          SELECT staff_id FROM stage_staff WHERE stage_id = stage_id_val
      );

    -- Check if more secondary staff is needed (2% of tickets sold)
    IF ticket_count + 1 > secondary_count * 50 THEN  -- 2% corresponds to 1 staff per 50 tickets
        -- Find one available secondary staff not yet on this stage
        SELECT s.staff_id INTO staff_to_assign
        FROM staff s
        WHERE s.staff_role_id = 3  -- Secondary staff role ID
          AND s.staff_id NOT IN (
              SELECT staff_id FROM stage_staff WHERE stage_id = stage_id_val
          )
        LIMIT 1;

        -- If we found one, assign them
        IF staff_to_assign IS NOT NULL THEN
            INSERT INTO stage_staff(stage_id, staff_id)
            VALUES (stage_id_val, staff_to_assign);
        ELSE
            -- If no staff available, issue a warning
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add ticket: This stage needs more secondary staff. Not enough secondary staff available to assign to the stage.';
        END IF;
    END IF;
END;
//

DELIMITER ;





