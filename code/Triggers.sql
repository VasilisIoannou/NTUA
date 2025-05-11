-- Active: 1746819443116@@127.0.0.1@3309@festivaldb

/* Trigger to prevent deletion of festivals */
DELIMITER //

CREATE TRIGGER prevent_festival_deletion
BEFORE DELETE ON festival
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Festivals cannot be deleted from the system';
END//

/* Trigger to prevent deletion of events */
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

    SELECT event_id INTO event_of_performance
    FROM performance
    WHERE performance_id = NEW.performance_id;

    SELECT COUNT(*) INTO ticket_count
    FROM ticket
    WHERE visitor_id = NEW.visitor_id
      AND event_id = event_of_performance
      AND validated = TRUE;

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

CREATE TRIGGER check_event_day
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

    SELECT festival_year INTO v_festival_year
    FROM event
    WHERE event_id = NEW.event_id;

    SELECT bdf.band_year_of_formation INTO v_band_formation_year
    FROM band b
    JOIN band_date_of_formation bdf ON b.band_date_of_formation_id = bdf.band_date_of_formation_id
    WHERE b.band_id = NEW.band_id;

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

CREATE TRIGGER check_band_members_before_performance
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
CREATE TRIGGER check_technician_specialization
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

/* Trigger to automatically set staff_role_id to 1 for technician_specialization */
CREATE TRIGGER auto_set_role_id
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

/* Trigger to assign security staff to stages based on ticket sales. */
CREATE TRIGGER assign_security_if_needed
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    DECLARE ticket_count INT;
    DECLARE security_count INT;
    DECLARE stage_id_val INT;
    DECLARE staff_to_assign INT;

    SELECT e.stage_id INTO stage_id_val
    FROM event e WHERE e.event_id = NEW.event_id;

    SELECT COUNT(*) INTO ticket_count
    FROM ticket t
    JOIN event e ON e.event_id = t.event_id
    WHERE e.stage_id = stage_id_val;

    SELECT COUNT(*) INTO security_count
    FROM stage_staff ss
    JOIN staff s ON s.staff_id = ss.staff_id
    WHERE ss.stage_id = stage_id_val AND s.staff_role_id = 2;

    IF ticket_count + 1 > security_count * 20 THEN

        SELECT s.staff_id INTO staff_to_assign
        FROM staff s
        WHERE s.staff_role_id = 2
          AND s.staff_id NOT IN (
              SELECT ss.staff_id
              FROM stage_staff ss
              JOIN event e1 ON ss.stage_id = e1.stage_id
              JOIN event e2 ON e2.event_id = NEW.event_id
              WHERE e1.festival_year = e2.festival_year
                AND e1.festival_day = e2.festival_day
                AND (
                    (e2.event_start BETWEEN e1.event_start AND e1.event_end) OR
                    (e2.event_end BETWEEN e1.event_start AND e1.event_end) OR
                    (e2.event_start <= e1.event_start AND e2.event_end >= e1.event_end)
                )
          )
          AND s.staff_id NOT IN (
              SELECT staff_id FROM stage_staff WHERE stage_id = stage_id_val
          )
        LIMIT 1;

        IF staff_to_assign IS NOT NULL THEN
            INSERT INTO stage_staff(stage_id, staff_id)
            VALUES (stage_id_val, staff_to_assign);
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add ticket: No available security staff without schedule conflict.';
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

    SELECT e.stage_id INTO stage_id_val
    FROM event e WHERE e.event_id = NEW.event_id;

    SELECT COUNT(*) INTO ticket_count
    FROM ticket t
    JOIN event e ON e.event_id = t.event_id
    WHERE e.stage_id = stage_id_val;

    SELECT COUNT(*) INTO secondary_count
    FROM stage_staff ss
    JOIN staff s ON s.staff_id = ss.staff_id
    WHERE ss.stage_id = stage_id_val AND s.staff_role_id = 3;

    IF ticket_count + 1 > secondary_count * 50 THEN

        SELECT s.staff_id INTO staff_to_assign
        FROM staff s
        WHERE s.staff_role_id = 3
          AND s.staff_id NOT IN (
              SELECT ss.staff_id
              FROM stage_staff ss
              JOIN event e1 ON ss.stage_id = e1.stage_id
              JOIN event e2 ON e2.event_id = NEW.event_id
              WHERE e1.festival_year = e2.festival_year
                AND e1.festival_day = e2.festival_day
                AND (
                    (e2.event_start BETWEEN e1.event_start AND e1.event_end) OR
                    (e2.event_end BETWEEN e1.event_start AND e1.event_end) OR
                    (e2.event_start <= e1.event_start AND e2.event_end >= e1.event_end)
                )
          )
          AND s.staff_id NOT IN (
              SELECT staff_id FROM stage_staff WHERE stage_id = stage_id_val
          )
        LIMIT 1;

        IF staff_to_assign IS NOT NULL THEN
            INSERT INTO stage_staff(stage_id, staff_id)
            VALUES (stage_id_val, staff_to_assign);
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add ticket: No available secondary staff without schedule conflict.';
        END IF;
    END IF;
END;
//

/* Trigger to assign technician to stage when a stage is added */
CREATE TRIGGER assign_technicians_on_stage_insert
AFTER INSERT ON stage
FOR EACH ROW
BEGIN
    DECLARE tech_id INT;
    DECLARE assigned_count INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;

    technician_loop: LOOP
        IF assigned_count >= 2 THEN
            LEAVE technician_loop;
        END IF;

        SELECT s.staff_id INTO tech_id
        FROM staff s
        WHERE s.staff_role_id = 1
          AND s.staff_id NOT IN (
              SELECT ss.staff_id
              FROM stage_staff ss
              JOIN event e1 ON ss.stage_id = e1.stage_id
              JOIN event e2 ON e2.stage_id = NEW.stage_id
              WHERE e1.festival_year = e2.festival_year
                AND e1.festival_day = e2.festival_day
                AND (
                    (e2.event_start BETWEEN e1.event_start AND e1.event_end) OR
                    (e2.event_end BETWEEN e1.event_start AND e1.event_end) OR
                    (e2.event_start <= e1.event_start AND e2.event_end >= e1.event_end)
                )
          )
          AND s.staff_id NOT IN (
              SELECT staff_id FROM stage_staff WHERE stage_id = NEW.stage_id
          )
        LIMIT 1;

        IF tech_id IS NULL THEN
            LEAVE technician_loop;
        END IF;

        INSERT INTO stage_staff(stage_id, staff_id)
        VALUES (NEW.stage_id, tech_id);

        SET assigned_count = assigned_count + 1;
    END LOOP;

    IF assigned_count < 2 THEN
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = CONCAT('Only ', assigned_count, ' technician(s) assigned to stage ', NEW.stage_id, '.');
    END IF;
END;
//

/* Trigger to assign a technician to a stage when they are added to the staff table */
CREATE TRIGGER assign_stage_on_technician_insert
AFTER INSERT ON staff
FOR EACH ROW
BEGIN
    DECLARE stage_to_fill INT;

    IF NEW.staff_role_id = 1 THEN

        SELECT s.stage_id INTO stage_to_fill
        FROM stage s
        LEFT JOIN (
            SELECT ss.stage_id, COUNT(*) AS tech_count
            FROM stage_staff ss
            JOIN staff st ON ss.staff_id = st.staff_id
            WHERE st.staff_role_id = 1
            GROUP BY ss.stage_id
        ) AS tech_counts ON s.stage_id = tech_counts.stage_id
        WHERE IFNULL(tech_counts.tech_count, 0) < 2
          AND NOT EXISTS (
              SELECT 1
              FROM stage_staff ss
              JOIN event e1 ON ss.stage_id = e1.stage_id
              JOIN event e2 ON e2.stage_id = s.stage_id
              WHERE ss.staff_id = NEW.staff_id
                AND e1.festival_year = e2.festival_year
                AND e1.festival_day = e2.festival_day
                AND (
                    (e2.event_start BETWEEN e1.event_start AND e1.event_end) OR
                    (e2.event_end BETWEEN e1.event_start AND e1.event_end) OR
                    (e2.event_start <= e1.event_start AND e2.event_end >= e1.event_end)
                )
          )
        LIMIT 1;

        IF stage_to_fill IS NOT NULL THEN
            INSERT INTO stage_staff(stage_id, staff_id)
            VALUES (stage_to_fill, NEW.staff_id);
        END IF;
    END IF;
END;
//

/* Trigger to check correct festival day and month */
CREATE TRIGGER check_festival_day
BEFORE INSERT ON festival
FOR EACH ROW
BEGIN
    IF NEW.festival_month IN (1, 3, 5, 7, 8, 10, 12) THEN
        IF NEW.festival_day > 31 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The month has only 31 days';
        END IF;
    ELSEIF NEW.festival_month IN (4, 6, 9, 11) THEN
        IF NEW.festival_day > 30 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The month has only 30 days';
        END IF;
    ELSEIF NEW.festival_month = 2 THEN
        IF NEW.festival_day > 28 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'February has only 28 days';
        END IF;
    END IF;
END;
//


/* Trigger to check correct date_issued day and month */
CREATE TRIGGER check_date_issued 
BEFORE INSERT ON date_issued
FOR EACH ROW
BEGIN
    IF NEW.month_issued IN (1, 3, 5, 7, 8, 10, 12) THEN
        IF NEW.day_issued > 31 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The month has only 31 days';
        END IF;
    ELSEIF NEW.month_issued IN (4, 6, 9, 11) THEN
        IF NEW.day_issued > 30 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The month has only 30 days';
        END IF;
    ELSEIF NEW.month_issued = 2 THEN
        IF NEW.day_issued > 28 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'February has only 28 days';
        END IF;
    END IF;
END;
//

CREATE TRIGGER remove_validated_tickets
AFTER UPDATE ON ticket
FOR EACH ROW
BEGIN
    DECLARE v_reselling_ticket_id INT;

    IF NEW.validated = TRUE THEN
        -- Check if the ticket is in the reselling list
        SELECT reselling_ticket_id INTO v_reselling_ticket_id
        FROM reselling_tickets
        WHERE EAN_13 = NEW.EAN_13
        LIMIT 1;

        IF v_reselling_ticket_id IS NOT NULL THEN
            DELETE FROM reselling_tickets 
            WHERE reselling_ticket_id = v_reselling_ticket_id;
        END IF;
    END IF;
END;
//

DELIMITER ;

