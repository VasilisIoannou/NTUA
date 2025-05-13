-- Active: 1746819443116@@127.0.0.1@3309@festivaldb
-- Active: 1742738056874@@127.0.0.1@3306

-- SUPER DUPER IMPORTANT
-- Check if the foreign keys are in the correct tables
-- One - to many relationships (The many have the FOREIGN KEY)
-- Check ON DELETE CASCADE for the foreign keys


-- READ FIRST
-- Naming convention: 1) use lowercase 2) use _ (underscore) for space
-- Times are stored in minutes after 00:00
-- For example, 12:30 is stored as 12*60 + 30 = 750

CREATE DATABASE IF NOT EXISTS festivalDB;
USE festivalDB;

CREATE TABLE coordinates(
    coordinate_id int AUTO_INCREMENT,
    latitude float,
    longitude float,
    PRIMARY KEY(coordinate_id)
);


CREATE TABLE festival_location(
    location_id int AUTO_INCREMENT,
    location_address varchar(255) NOT NULL,
    city varchar(255) NOT NULL,
    country varchar(255) NOT NULL,
    continent varchar(255) NOT NULL,
    coordinate_id int NOT NULL UNIQUE,
    PRIMARY KEY(location_id),
    FOREIGN KEY(coordinate_id) REFERENCES coordinates(coordinate_id)
);


CREATE TABLE festival(
    festival_year int NOT NULL CHECK (festival_year > 0),
    festival_month int NOT NULL CHECK (festival_month > 0 AND festival_month < 13),
    festival_day int NOT NULL CHECK (festival_day > 0), -- A Trigger will check the festival_day < N
    duration int NOT NULL CHECK (duration > 0),  -- Duration of the festival in days
    location_id int NOT NULL UNIQUE,
    PRIMARY KEY(festival_year),
    FOREIGN KEY(location_id) REFERENCES festival_location(location_id)
);

CREATE TABLE performance_type(
    performance_type_id int AUTO_INCREMENT,
    performance_type_name varchar(255),
    PRIMARY KEY(performance_type_id)
);

INSERT INTO performance_type(performance_type_name) VALUES ('Warm up'), ('Headline'), ('Special guest'), ('Closing act');

CREATE TABLE stage(
    stage_id int AUTO_INCREMENT,
    stage_name varchar(255) NOT NULL,
    stage_capacity int NOT NULL CHECK (stage_capacity > 0),
    festival_location_id INT NOT NULL,
    PRIMARY KEY(stage_id),
    FOREIGN KEY(festival_location_id) REFERENCES festival_location(location_id)
);

CREATE TABLE event(
    event_id int AUTO_INCREMENT,
    event_name varchar(255) NOT NULL,
    festival_year int NOT NULL CHECK (festival_year > 0),
    stage_id int NOT NULL,
    festival_day int NOT NULL CHECK (festival_day > 0),
    -- Duration of the event in minutes duration of performances + break_duration
    -- Instead of storing duration in 1 field, we broke it into 2 attributes (event_start, event_end) 
    -- for better query performance
    event_start int NOT NULL CHECK (event_start >= 0 AND event_start <= 1440),
    event_end int NOT NULL CHECK (event_end >= 0 AND event_end <= 1440),
    PRIMARY KEY(event_id),
    FOREIGN KEY(festival_year) REFERENCES festival(festival_year) ON DELETE CASCADE,
    FOREIGN KEY(stage_id) REFERENCES stage(stage_id) ON DELETE CASCADE
);


CREATE TABLE break_duration(
    break_duration_id int AUTO_INCREMENT,
    -- break_duration is stored in seconds
    break_start int NOT NULL CHECK (break_start >= 0 AND break_start <= 1440),  -- 0 to 24 hours
    break_duration int NOT NULL CHECK (break_duration >= 300 AND break_duration <= 1800),  -- 5 to 30 minutes
    event_id int NOT NULL,
    PRIMARY KEY(break_duration_id),
    FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE
);

CREATE TABLE band_date_of_formation(
    band_date_of_formation_id int AUTO_INCREMENT,
    band_year_of_formation int CHECK (band_year_of_formation > 0),
    band_month_of_formation int CHECK (band_month_of_formation >= 1 AND band_month_of_formation <= 12),
    band_day_of_formation int CHECK (band_day_of_formation >= 1), -- Test with Trigger 
    PRIMARY KEY(band_date_of_formation_id)
);

CREATE TABLE genre(
    genre_id int AUTO_INCREMENT,
    genre_name varchar(255) NOT NULL UNIQUE,
    PRIMARY KEY(genre_id)
);

CREATE TABLE band(
    band_id int AUTO_INCREMENT,
    band_name varchar(255) NOT NULL,
    band_country varchar(255),
    band_members int NOT NULL CHECK (band_members >= 0),
    band_website varchar(255),
    band_date_of_formation_id int,
    PRIMARY KEY(band_id),
    FOREIGN KEY(band_date_of_formation_id) REFERENCES band_date_of_formation(band_date_of_formation_id) ON DELETE CASCADE
);


CREATE TABLE performance(
    performance_id int AUTO_INCREMENT,
    performance_type_id int NOT NULL,
    -- performance_start and performance_end are stored in minutes after 00:00
    performance_start int CHECK (performance_start >= 0 AND performance_start <= 1440),  -- 0 to 24 hours
    performance_end int CHECK(performance_end >= 0),
    CHECK (performance_start < performance_end AND performance_end - performance_start <= 180),  -- 0 to 3 hours
    event_id int ,
    band_id int NOT NULL,
    PRIMARY KEY(performance_id),
    FOREIGN KEY(performance_type_id) REFERENCES performance_type(performance_type_id),
    FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE,
    FOREIGN KEY(band_id) REFERENCES band(band_id) ON DELETE CASCADE,
    INDEX event_id_index(event_id)
);

CREATE TABLE technical_equipment(
    technical_equipment_id int AUTO_INCREMENT,
    equipment_name varchar(255) NOT NULL,
    PRIMARY KEY(technical_equipment_id)
);

--sta dummy data ena stage mporei na eshei panw pou ena technical equipment enw ston kodika parapanw
--sta data en je ta thkio unique enw ston kodika prepei nan mazi unique
CREATE TABLE stage_technical_equipment( 
    stage_id int,
    technical_equipment_id int,
    PRIMARY KEY(stage_id, technical_equipment_id),
    FOREIGN KEY(stage_id) REFERENCES stage(stage_id) ON DELETE CASCADE,
    FOREIGN KEY(technical_equipment_id) REFERENCES technical_equipment(technical_equipment_id) ON DELETE CASCADE
);

CREATE TABLE level_of_experience(
    level_of_experience_id int AUTO_INCREMENT,
    level_of_experience_name varchar(255) NOT NULL,
    PRIMARY KEY(level_of_experience_id)
);

INSERT INTO level_of_experience(level_of_experience_name) VALUES('Beginner'), ('Intermediate'), ('Advanced'), ('Expert'), ('Master');

CREATE TABLE staff_role(
    staff_role_id int AUTO_INCREMENT,
    staff_role_name varchar(255) NOT NULL,
    PRIMARY KEY(staff_role_id)
);

INSERT INTO staff_role(staff_role_name) VALUES('Technician'),('Security'),('Secondary');

CREATE TABLE technician_specialization(
    technician_specialization_id int AUTO_INCREMENT,
    technician_specialization_name varchar(255) NOT NULL,
    staff_role_id int,
    PRIMARY KEY(technician_specialization_id), 
    FOREIGN KEY(staff_role_id) REFERENCES staff_role(staff_role_id) ON DELETE CASCADE
);

CREATE TABLE staff(
    staff_id int AUTO_INCREMENT,
    staff_name varchar(255) NOT NULL,
    staff_role_id int NOT NULL,
    staff_phone varchar(255),
    staff_email varchar(255),
    staff_age int NOT NULL CHECK (staff_age > 0),
    level_of_experience int NOT NULL CHECK (level_of_experience >= 1 AND level_of_experience <= 5),
    PRIMARY KEY(staff_id),
    FOREIGN KEY(staff_role_id) REFERENCES staff_role(staff_role_id),
    FOREIGN KEY(level_of_experience) REFERENCES level_of_experience(level_of_experience_id)
);

CREATE TABLE stage_staff(
    stage_id int,
    staff_id int,
    PRIMARY KEY(stage_id, staff_id),
    FOREIGN KEY(stage_id) REFERENCES stage(stage_id) ON DELETE CASCADE,
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE staff_specialization(
    staff_id int NOT NULL,
    technician_specialization_id int NOT NULL,
    PRIMARY KEY(staff_id, technician_specialization_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE,
    FOREIGN KEY(technician_specialization_id) REFERENCES technician_specialization(technician_specialization_id) ON DELETE CASCADE
);


-- Many to many relationship between band and subgenre
-- A band is connected to its subgenres and from there we can find the genre

CREATE TABLE subgenre(
    subgenre_id int AUTO_INCREMENT,
    subgenre_name varchar(255) NOT NULL,
    genre_id int NOT NULL,
    PRIMARY KEY(subgenre_id),
    FOREIGN KEY(genre_id) REFERENCES genre(genre_id) ON DELETE CASCADE
);

CREATE TABLE band_subgenre(
    band_id int ,
    subgenre_id int,
    PRIMARY KEY(band_id, subgenre_id),
    FOREIGN KEY(band_id) REFERENCES band(band_id) ON DELETE CASCADE,
    FOREIGN KEY(subgenre_id) REFERENCES subgenre(subgenre_id) ON DELETE CASCADE
);

CREATE TABLE artist(
    artist_id int AUTO_INCREMENT,
    artist_name varchar(255) NOT NULL,
    artist_stage_name varchar(255),
    artist_year_of_birth int NOT NULL ,
    artist_website varchar(255),
    PRIMARY KEY(artist_id),
    INDEX artist_year_of_birth_index(artist_year_of_birth)
);

CREATE TABLE artist_band(
    artist_id int NOT NULL,
    band_id int NOT NULL,
    PRIMARY KEY(artist_id, band_id),
    FOREIGN KEY(artist_id) REFERENCES artist(artist_id) ON DELETE CASCADE,
    FOREIGN KEY(band_id) REFERENCES band(band_id) ON DELETE CASCADE
);

-- Store in a string the url of the social media and the name of the site
-- For example, "https://www.facebook.com/artist_name" and "Facebook"
-- We have 2 tables for social media, one for artists and one for bands

-- Na to ksanadoume giati exoume to band_id sto artist
-- kai to artist_id sto band
CREATE TABLE social_media_artist(
    social_media_artist_id int AUTO_INCREMENT,
    artist_id int,
    social_media_name varchar(255),
    social_media_url varchar(255),
    PRIMARY KEY(social_media_artist_id),
    FOREIGN KEY(artist_id) REFERENCES artist(artist_id) ON DELETE CASCADE
);

CREATE TABLE social_media_band(
    social_media_band_id int AUTO_INCREMENT,
    band_id int,
    social_media_name varchar(255),
    social_media_url varchar(255),
    PRIMARY KEY(social_media_band_id),
    FOREIGN KEY(band_id) REFERENCES band(band_id) ON DELETE CASCADE
);

CREATE TABLE payment_method(
    payment_method_id int AUTO_INCREMENT,
    payment_method_name varchar(255) NOT NULL,
    PRIMARY KEY(payment_method_id)
);

INSERT INTO payment_method(payment_method_name) VALUES('Credit card'), ('Debit card'), ('Paypal'), ('Cash');

CREATE TABLE ticket_type(
    ticket_type_id int AUTO_INCREMENT,
    ticket_type_name varchar(255) NOT NULL,
    PRIMARY KEY(ticket_type_id)
);

INSERT INTO ticket_type(ticket_type_name) VALUES('VIP'), ('Regular'), ('Student'), ('Senior Citizen'),('Backstage');

CREATE TABLE visitor(
    visitor_id int AUTO_INCREMENT,
    visitor_name varchar(255) NOT NULL,
    visitor_surname varchar(255) NOT NULL,
    visitor_age int NOT NULL CHECK (visitor_age > 0),
    PRIMARY KEY(visitor_id)
);

CREATE TABLE visitor_contact(
    visitor_contact_id int AUTO_INCREMENT,
    visitor_id int UNIQUE NOT NULL,
    visitor_email varchar(255) NOT NULL,
    visitor_phone varchar(255) NOT NULL,
    PRIMARY KEY(visitor_contact_id),
    FOREIGN KEY(visitor_id) REFERENCES visitor(visitor_id) ON DELETE CASCADE
);

--prepei na kamoume tin timi tou eisitiriou na terkazei me to type tou
CREATE TABLE ticket(
    EAN_13 bigint NOT NULL CHECK (EAN_13 > 0),
    ticket_type_id int NOT NULL,
    visitor_id int NOT NULL,
    event_id int NOT NULL,
    ticket_price float NOT NULL CHECK(ticket_price >= 0),
    payment_method_id int NOT NULL,
    validated boolean NOT NULL,
    PRIMARY KEY(EAN_13),
    FOREIGN KEY(ticket_type_id) REFERENCES ticket_type(ticket_type_id),
    FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE,
    FOREIGN KEY(visitor_id) REFERENCES visitor(visitor_id) ON DELETE CASCADE,
    FOREIGN KEY(payment_method_id) REFERENCES payment_method(payment_method_id),
    UNIQUE KEY(visitor_id, event_id),
    INDEX ticket_price_index(ticket_price)
);

CREATE TABLE ticket_price(
    ticket_price_id int AUTO_INCREMENT,
    ticket_type_id int,
    event_id int,
    ticket_price_price float NOT NULL CHECK(ticket_price_price >= 0), 
    PRIMARY KEY(ticket_price_id),
    FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE,
    FOREIGN KEY(ticket_type_id) REFERENCES ticket_type(ticket_type_id) ON DELETE CASCADE
);

CREATE TABLE buyer(
    buyer_id int AUTO_INCREMENT,
    visitor_id int UNIQUE NOT NULL,
    PRIMARY KEY(buyer_id),
    FOREIGN KEY(visitor_id) REFERENCES visitor(visitor_id) ON DELETE CASCADE
);


CREATE TABLE date_issued(
    date_issued_id int AUTO_INCREMENT,
    year_issued int NOT NULL CHECK (year_issued > 0),
    month_issued int NOT NULL CHECK (month_issued >= 1 AND month_issued <= 12),
    day_issued int NOT NULL CHECK (day_issued >= 1), -- Chekck with Trigger
    PRIMARY KEY(date_issued_id)
);

CREATE TABLE reselling_tickets(
    reselling_ticket_id int AUTO_INCREMENT UNIQUE,
    EAN_13 bigint NOT NULL UNIQUE CHECK (EAN_13 > 0),
    PRIMARY KEY(reselling_ticket_id),
    FOREIGN KEY(EAN_13) REFERENCES ticket(EAN_13) ON DELETE CASCADE,
    INDEX EAN_13_index (EAN_13)
);



CREATE TABLE ticket_transfers(
    buyer_id int NOT NULL,
    EAN_13 BIGINT NOT NULL,
    PRIMARY KEY(buyer_id,EAN_13),
    FOREIGN KEY(buyer_id) REFERENCES buyer(buyer_id) ON DELETE CASCADE,
    FOREIGN KEY(EAN_13) REFERENCES ticket(EAN_13) ON DELETE CASCADE
);


--mporei na xreiazetai ON DELETE CASCADE
--sto er diagram en eshei PK

CREATE TABLE desired_ticket_by_event(
    buyer_id int NOT NULL,
    ticket_type_id int NOT NULL,
    event_id int NOT NULL,
    date_issued_id int NOT NULL,
    PRIMARY KEY(buyer_id,event_id),  
    FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE,
    FOREIGN KEY(ticket_type_id) REFERENCES ticket_type(ticket_type_id), 
    FOREIGN KEY(buyer_id) REFERENCES buyer(buyer_id) ON DELETE CASCADE,
    FOREIGN KEY(date_issued_id) REFERENCES date_issued(date_issued_id) ON DELETE CASCADE
);

CREATE TABLE reviews(
    reviews_id int AUTO_INCREMENT,
    visitor_id int NOT NULL,
    performance_id int NOT NULL,
    PRIMARY KEY(reviews_id),
    FOREIGN KEY(visitor_id) REFERENCES visitor(visitor_id) ON DELETE CASCADE,
    FOREIGN KEY(performance_id) REFERENCES performance(performance_id) ON DELETE CASCADE,
    INDEX visitor_id_index (visitor_id)
);

-- otan en one-on-one en kamnei generate one-on-one
CREATE TABLE likert_scale(
    likert_scale_id int AUTO_INCREMENT,
    reviews_id int NOT NULL,
    performance_score int CHECK(performance_score >= 1 && performance_score <= 5),
    sound_light_quality_score int CHECK(sound_light_quality_score >= 1 && sound_light_quality_score <= 5),
    stage_presence_score int CHECK(stage_presence_score >= 1 && stage_presence_score <= 5),
    organization_score int CHECK(organization_score >= 1 && organization_score <= 5),
    total_impression_score int CHECK(total_impression_score >= 1 && total_impression_score <= 5),
    PRIMARY KEY(likert_scale_id),
    FOREIGN KEY(reviews_id) REFERENCES reviews(reviews_id) ON DELETE CASCADE
);

CREATE TABLE festival_image(
    festival_image_id int AUTO_INCREMENT,
    festival_year int NOT NULL,
    festival_image_description varchar(255),
    festival_image_path varchar(255) NOT NULL,
    PRIMARY KEY(festival_image_id),
    FOREIGN KEY(festival_year) REFERENCES festival(festival_year) ON DELETE CASCADE
);

CREATE TABLE artist_image(
    artist_image_id int AUTO_INCREMENT,
    artist_id int NOT NULL,
    artist_image_description varchar(255),
    artist_image_path varchar(255) NOT NULL,
    PRIMARY KEY(artist_image_id),
    FOREIGN KEY(artist_id) REFERENCES artist(artist_id) ON DELETE CASCADE
);

CREATE TABLE location_image(
    location_image_id int AUTO_INCREMENT,
    location_id int NOT NULL,
    location_image_description varchar(255),
    location_image_path varchar(255) NOT NULL,
    PRIMARY KEY(location_image_id),
    FOREIGN KEY(location_id) REFERENCES festival_location(location_id) ON DELETE CASCADE
);

CREATE TABLE post_performance_image(
    post_performance_image_id int AUTO_INCREMENT,
    performance_id int NOT NULL,
    post_performance_image_description varchar(255),
    post_performance_image_path varchar(255) NOT NULL,
    PRIMARY KEY(post_performance_image_id),
    FOREIGN KEY(performance_id) REFERENCES performance(performance_id) ON DELETE CASCADE
);

CREATE TABLE band_image(
    band_image_id int AUTO_INCREMENT,
    band_id int NOT NULL,
    band_image_description varchar(255),
    band_image_path varchar(255) NOT NULL,
    PRIMARY KEY(band_image_id),
    FOREIGN KEY(band_id) REFERENCES band(band_id) ON DELETE CASCADE
);

CREATE TABLE staff_image(
    staff_image_id int AUTO_INCREMENT,
    staff_id int NOT NULL,
    staff_image_description varchar(255),
    staff_image_path varchar(255) NOT NULL,
    PRIMARY KEY(staff_image_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);


CREATE TABLE event_image(
    event_image_id int AUTO_INCREMENT,
    event_id int NOT NULL,
    event_image_description varchar(255),
    event_image_path varchar(255) NOT NULL,
    PRIMARY KEY(event_image_id),
    FOREIGN KEY(event_id) REFERENCES event(event_id) ON DELETE CASCADE
);

/* ------------------------------------------------------------------------------------------------ */
/*                                       PROCEDURES                                                 */
/* ------------------------------------------------------------------------------------------------ */

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

/* Procedure to add Ticket to existing visitor */
CREATE PROCEDURE insert_ticket_with_existing_visitor( 
    IN p_EAN_13 BIGINT,
    IN p_ticket_type_name VARCHAR(255),
    IN p_event_id INT,
    IN p_payment_method_id INT,
    IN p_visitor_id INT,
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

    DECLARE v_visitor_age INT;

    -- Variables for EAN-13 check
    DECLARE ean13_str CHAR(13);
    DECLARE ean12_str CHAR(12);
    DECLARE i INT DEFAULT 1;
    DECLARE sum_odd INT DEFAULT 0;
    DECLARE sum_even INT DEFAULT 0;
    DECLARE digit INT;
    DECLARE calculated_check_digit INT;
    DECLARE provided_check_digit INT;

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

    -- Senior must be >= 65 years

    -- Find the visitors age
    SELECT visitor_age INTO v_visitor_age
    FROM visitor
    WHERE visitor_id = p_visitor_id;

    IF p_ticket_type_name = 'Senior' AND v_visitor_age < 65 THEN
	ROLLBACK;
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seniors must be 65 years old or older';
    END IF;

    -- Insert ticket data
    INSERT INTO ticket (EAN_13, ticket_type_id, visitor_id, event_id, ticket_price, payment_method_id, validated)
    VALUES (p_EAN_13, v_ticket_type_id, p_visitor_id, p_event_id, v_ticket_price, p_payment_method_id, FALSE);
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

    -- Senior must be >= 65 years
    IF p_ticket_type_name = 'Senior' AND p_visitor_age < 65 THEN
	ROLLBACK;
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seniors must be 65 years old or older';
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
    DECLARE after_closing_conflict INT;

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

    -- Cant Add Performances after Closing Act
    SELECT COUNT(*) INTO after_closing_conflict
    FROM performance
    WHERE event_id = p_event_id AND performance_type_id = v_closing_act_id;

    IF after_closing_conflict > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cant have performances after the Closing Act' ;
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
     p_age INT,
     p_visitor_email VARCHAR(255),
     p_visitor_phone VARCHAR(255)
)
BEGIN
     DECLARE v_visitor_id INT;

     INSERT INTO visitor(visitor_name,visitor_surname,visitor_age) VALUES (p_name,p_surname,p_age);
     
     SET v_visitor_id = LAST_INSERT_ID();

     INSERT INTO buyer(visitor_id) VALUES (v_visitor_id);
     INSERT INTO visitor_contact(visitor_id,visitor_email,visitor_phone) VALUES (v_visitor_id,p_visitor_email,p_visitor_phone);
END//

CREATE PROCEDURE process_ticket_matches()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ean BIGINT;
    DECLARE v_buyer_id INT;
    DECLARE v_visitor_id INT;
    DECLARE v_date_issued_id INT;
    
    -- Cursor to find all matching tickets with buyer priorities
    DECLARE match_cursor CURSOR FOR
        SELECT rt.EAN_13, d.buyer_id, b.visitor_id, d.date_issued_id
        FROM reselling_tickets rt
        JOIN ticket t ON rt.EAN_13 = t.EAN_13
        JOIN desired_ticket_by_event d ON d.event_id = t.event_id AND d.ticket_type_id = t.ticket_type_id
        JOIN buyer b ON d.buyer_id = b.buyer_id
        JOIN date_issued di ON d.date_issued_id = di.date_issued_id

        ORDER BY di.year_issued, di.month_issued, di.day_issued;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Create a temporary table to track processed tickets
    CREATE TEMPORARY TABLE IF NOT EXISTS processed_tickets (
        ean_13 BIGINT PRIMARY KEY
    );
    
    OPEN match_cursor;
    
    match_loop: LOOP
        FETCH match_cursor INTO v_ean, v_buyer_id, v_visitor_id, v_date_issued_id;
        IF done THEN
            LEAVE match_loop;
        END IF;
        
        -- Check if this ticket hasn't been processed yet
        IF NOT EXISTS (SELECT 1 FROM processed_tickets WHERE ean_13 = v_ean) THEN
            -- Update the ticket with new owner
            UPDATE ticket 
            SET visitor_id = v_visitor_id
            WHERE EAN_13 = v_ean;
            
            -- Remove from reselling tickets
            DELETE FROM reselling_tickets WHERE EAN_13 = v_ean;
            
            -- Mark as processed
            INSERT INTO processed_tickets (ean_13) VALUES (v_ean);
 		
	    -- Save to ticket_tranfer log
	    INSERT INTO ticket_transfers(buyer_id,EAN_13) VALUES (v_buyer_id,v_ean);
        END IF;
    END LOOP;
    
    CLOSE match_cursor;
    DROP TEMPORARY TABLE IF EXISTS processed_tickets;
END//

DELIMITER ;


/* ------------------------------------------------------------------------------------------------ */
/*                                       VIEWS                                                      */
/* ------------------------------------------------------------------------------------------------ */

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
      AND e1.festival_year = e2.festival_year
      AND e1.festival_day = e2.festival_day
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

        -- Select available technician who isn't assigned to the same stage
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
        SET MESSAGE_TEXT = 'More technicians need to be assigned to stage.';
    END IF;
END//

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

/* Trigger to check correct date_issued day and month */
CREATE TRIGGER check_band_date_of_formation 
BEFORE INSERT ON band_date_of_formation
FOR EACH ROW
BEGIN
    IF NEW.band_month_of_formation IN (1, 3, 5, 7, 8, 10, 12) THEN
        IF NEW.band_day_of_formation > 31 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The month has only 31 days';
        END IF;
    ELSEIF NEW.band_month_of_formation IN (4, 6, 9, 11) THEN
        IF NEW.band_day_of_formation > 30 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The month has only 30 days';
        END IF;
    ELSEIF NEW.band_month_of_formation = 2 THEN
        IF NEW.band_day_of_formation > 28 THEN
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

/* Date issued of reselling_tickets cannto be after the event */
CREATE TRIGGER IF NOT EXISTS date_issued_check_for_desired_ticket
BEFORE INSERT ON desired_ticket_by_event
FOR EACH ROW
BEGIN
	DECLARE v_festival_year INT;
	DECLARE v_festival_month INT;
	DECLARE v_festival_day INT;

	DECLARE v_event_day INT; 

	DECLARE v_year_issued INT;
	DECLARE v_month_issued INT;
	DECLARE v_day_issued INT;

	DECLARE v_festival_date_in_days INT;
	DECLARE v_date_issued_date_in_days INT;

	-- Find the festival dates
	SELECT f.festival_year, f.festival_month, f.festival_day 
	INTO v_festival_year, v_festival_month, v_festival_day
	FROM festival f
	JOIN event e ON e.festival_year = f.festival_year
	WHERE e.event_id = NEW.event_id;

	-- Find the date of issued
	SELECT year_issued, month_issued, day_issued
	INTO v_year_issued, v_month_issued, v_day_issued
	FROM date_issued di
	WHERE di.date_issued_id = NEW.date_issued_id;

	-- Find the day of the event
	SELECT festival_day
	INTO v_event_day
	FROM event e
	WHERE e.event_id = NEW.event_id;

	-- Find the date in days
	SET v_festival_date_in_days = 365 * v_festival_year + 30 * v_festival_month + v_festival_day; 

	SET v_date_issued_date_in_days = 365 * v_year_issued + 30 * v_month_issued + v_day_issued; 
	-- Check if the date issued is before the day of the festival + event day
	IF v_festival_date_in_days < v_date_issued_date_in_days THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Date Issued cannot be after the event';
	END IF;

END;
//

DELIMITER ;


