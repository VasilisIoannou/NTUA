SELECT 
    CONCAT(v.visitor_name, ' ', v.visitor_surname) AS visitor_name,
    a.artist_name,
    b.band_name,
    SUM(ls.performance_score +  ls.stage_presence_score + ls.total_impression_score) AS total_review_score
FROM 
    reviews r
JOIN 
    likert_scale ls ON r.reviews_id = ls.reviews_id
JOIN 
    visitor v ON r.visitor_id = v.visitor_id
JOIN 
    performance p ON r.performance_id = p.performance_id
JOIN 
    band b ON p.band_id = b.band_id
JOIN
    artist_band ab ON b.band_id = ab.band_id
JOIN
    artist a ON ab.artist_id = a.artist_id
GROUP BY 
    v.visitor_id, a.artist_id, b.band_id
ORDER BY 
    total_review_score DESC
LIMIT 5;

/* Festival Check */

CREATE TRIGGER IF NOT EXISTS check_festival_day
BEFORE INSERT ON festival
FOR EACH ROW
BEGIN
    IF NEW.festival_month = 1 OR NEW.festival_month = 3 OR NEW.festival_month = 5 OR NEW.festival_month = 7 OR NEW.festival_month = 8 OR NEW.festival_month = 10 OR NEW.festival_month = 12 THEN
	IF NEW.festival_day > 31 THEN
		SIGNAL SQLSTATE = '45000';
		SET MESSAGE_TEXT = 'The Month has only 31 days';
	END IF;
    ELSE IF NEW.festival_month = 4 OR NEW.festival_month = 6 OR NEW.festival_month = 9 OR NEW.festival_month = 11 THEN
	IF NEW.festival_day > 30 THEN
		SIGNAL SQLSTATE = '45000';
		SET MESSAGE_TEXT = 'The Month has only 30 days';
	END IF;
    ELSE IF NEW.festival_month = 2 THEN
	IF NEW.festival_day > 28 THEN
		SIGNAL SQLSTATE = '45000';
		SET MESSAGE_TEXT = 'Febuary has only 28 days';
	END IF;
    END IF;
END//


CREATE TRIGGER IF NOT EXISTS check_day_issued
FOR EACH ROW
BEFORE INSERT ON date_issued
BEGIN
    IF NEW.month_issued = 1 OR NEW.month_issued = 3 OR NEW.month_issued = 5 OR NEW.month_issued = 7 OR NEW.month_issued = 8 OR NEW.month_issued = 10 OR NEW.month_issued = 12 THEN
	IF NEW.day_issued > 31 THEN
		SIGNAL SQLSTATE = '45000';
		SET MESSAGE_TEXT = 'The Month has only 31 days';
	END IF;
    ELSE IF NEW.month_issued = 4 OR NEW.month_issued = 6 OR NEW.month_issued = 9 OR NEW.month_issued = 11 THEN
	IF NEW.day_issued > 30 THEN
		SIGNAL SQLSTATE = '45000';
		SET MESSAGE_TEXT = 'The Month has only 30 days';
	END IF;
    ELSE IF NEW.month_issued = 2 THEN
	IF NEW.day_issued > 28 THEN
		SIGNAL SQLSTATE = '45000';
		SET MESSAGE_TEXT = 'Febuary has only 28 days';
	END IF;
    END IF;
END//


CREATE TRIGGER IF NOT EXISTS remove_validated_tickets
AFTER UPDATE ON ticket
FOR EACH ROW
BEGIN
	DECLARE v_reselling_ticket_id;

	IF NEW.validated = TRUE THEN
		-- Find is there the ticket was put in the reselling list
		SELECT reselling_ticket_id INTO v_reselling_ticket_id
		FROM reselling_tickets
		WHERE EAN_13 = NEW.EAN_13
		LIMIT 1;

		IF reselling_ticket_id IS NOT NULL THEN
			DELETE FROM reselling_tickets WHERE reselling_ticket_id = v_reselling_tciket_id
		END IF;
	END IF;
END//
