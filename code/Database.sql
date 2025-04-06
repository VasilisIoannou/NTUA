-- Active: 1742738056874@@127.0.0.1@3306@festivaldb
-- Active: 1742738056874@@127.0.0.1@3306

-- SUPER DUPER IMPORTANT
-- Check if the foreign keys are in the correct tables
-- One - to many relationships (The many have the FOREIGN KEY)
-- Check ON DELETE CASCADE for the foreign keys


-- READ FIRST
-- Naming convention: 1) use lowercase 2) use _ (underscore) for space
-- Times are stored in minutes after 00:00
-- For example, 12:30 is stored as 12*60 + 30 = 750

CREATE DATABASE festivalDB;
USE festivalDB;

CREATE TABLE festival(
    festival_year int NOT NULL CHECK (festival_year > 0),
    duration int NOT NULL CHECK (duration > 0),  -- Duration of the festival in days
    location_id int NOT NULL,
    PRIMARY KEY(festival_year),
    FOREIGN KEY(location_id) REFERENCES festival_location(location_id)
)

CREATE TABLE event(
    event_id int AUTO_INCREMENT,
    event_name varchar(255) NOT NULL,
    festival_year int NOT NULL CHECK (festival_year > 0),
    stage_id int,
    -- Duration of the event in minutes duration of performances + break_duration
    -- Instead of storing duration in 1 field, we broke it into 2 attributes (event_start, event_end) 
    -- for better query performance
    event_start int,
    event_end int,
    break_duration_id int,
    PRIMARY KEY(event_id),
    FOREIGN KEY(festival_year) REFERENCES festival(festival_year), ON DELETE CASCADE
    FOREIGN KEY(stage_id) REFERENCES stage(stage_id), ON DELETE CASCADE
    FOREIGN KEY(break_duration_id) REFERENCES break_duration(break_duration_id)
)

CREATE TABLE break_duration(
    break_duration_id int AUTO_INCREMENT,
    -- break_duration is stored in seconds
    break_duration int NOT NULL CHECK (break_duration >= 300 AND break_duration <= 1800),  -- 5 to 30 minutes
    PRIMARY KEY(break_duration_id)
)

CREATE TABLE festival_location(
    location_id int AUTO_INCREMENT,
    location_address varchar(255) NOT NULL,
    city varchar(255) NOT NULL,
    country varchar(255) NOT NULL,
    continent varchar(255) NOT NULL,
    coordinate_id int NOT NULL,
    PRIMARY KEY(location_id),
    FOREIGN KEY(coordinate_id) REFERENCES coordinates(coordinate_id)
)

CREATE TABLE coordinates(
    coordinate_id int AUTO_INCREMENT,
    latitude float,
    longitude float,
    PRIMARY KEY(coordinate_id)
)

CREATE TABLE performance(
    performance_id int AUTO_INCREMENT,
    performance_type_id int,
    -- performance_start and performance_end are stored in minutes after 00:00
    performance_start int CHECK (performance_start >= 0 AND performance_start <= 1440),  -- 0 to 24 hours
    performance_end int CHECK(performance_end >= 0),
    CHECK (performance_start < performance_end AND performance_start - performance_end <= 180),  -- 0 to 3 hours
    event_id int,
    PRIMARY KEY(performance_id),
    FOREIGN KEY(performance_type_id) REFERENCES performance_type(performance_type_id),
    FOREIGN KEY(event_id) REFERENCES event(event_id)
)

CREATE TABLE performance_type(
    performance_type_id int AUTO_INCREMENT,
    performance_type_name varchar(255),
    PRIMARY KEY(performance_type_id)
)

INSERT INTO performance_type(performance_type_name) VALUES ('Warm up'), ('Headline'), ('Special guest'), ('Closing act');

CREATE TABLE stage(
    stage_id int AUTO_INCREMENT,
    stage_name varchar(255) NOT NULL,
    stage_capacity int NOT NULL CHECK (stage_capacity > 0),
    PRIMARY KEY(stage_id)
)

CREATE TABLE stage_technical_equipment(
    stage_id int,
    technical_equipment_id int,
    PRIMARY KEY(stage_id, technical_equipment_id),
    FOREIGN KEY(stage_id) REFERENCES stage(stage_id),
    FOREIGN KEY(technical_equipment_id) REFERENCES technical_equipment(technical_equipment_id) ON DELETE CASCADE
)

CREATE TABLE technical_equipment(
    technical_equipment_id int AUTO_INCREMENT,
    equipment_name varchar(255) NOT NULL,
    equipment_quantity int NOT NULL CHECK (equipment_quantity > 0),
    PRIMARY KEY(technical_equipment_id)
)

CREATE TABLE staff(
    staff_id int AUTO_INCREMENT,
    staff_name varchar(255) NOT NULL,
    staff_role_id int NOT NULL,
    staff_phone varchar(255),
    staff_email varchar(255),
    staff_age int NOT NULL CHECK (staff_age > 0),
    level_of_experience int NOT NULL CHECK (level_of_experience >= 0 AND level_of_experience < 5),
    PRIMARY KEY(staff_id),
    FOREIGN KEY(staff_role_id) REFERENCES staff_role(staff_role_id)
)

CREATE TABLE level_of_experience(
    level_of_experience_id int AUTO_INCREMENT,
    level_of_experience_name varchar(255) NOT NULL,
    PRIMARY KEY(level_of_experience_id)
)

INSERT INTO level_of_experience(level_of_experience_name) VALUES('Beginner'), ('Intermediate'), ('Advanced'), ('Expert'), ('Master');

CREATE TABLE staff_role(
    staff_role_id int AUTO_INCREMENT,
    staff_role_name varchar(255) NOT NULL,
    PRIMARY KEY(staff_role_id)
)

INSERT INTO staff_role(staff_role_name) VALUES('Technician'),('Security'),('Secondary');

CREATE TABLE role_specialization(
    role_specialization_id int AUTO_INCREMENT,
    role_specialization_name varchar(255) NOT NULL,
    staff_role_id int,
    PRIMARY KEY(role_specialization_id), 
    FOREIGN KEY(staff_role_id) REFERENCES staff_role(staff_role_id) ON DELETE CASCADE
)

CREATE TABLE staff_specialization(
    staff_id int,
    role_specialization_id int,
    PRIMARY KEY(staff_id, role_specialization_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE,
    FOREIGN KEY(role_specialization_id) REFERENCES role_specialization(role_specialization_id) ON DELETE CASCADE
)

CREATE TABLE band(
    band_id int AUTO_INCREMENT,
    band_name varchar(255) NOT NULL,
    band_genre_id int,
    band_country varchar(255),
    band_members int NOT NULL CHECK (band_members > 0),
    PRIMARY KEY(band_id),
    FOREIGN KEY(band_genre_id) REFERENCES band_genre(band_genre_id)
)

CREATE TABLE genre(
    genre_id int AUTO_INCREMENT,
    genre_name varchar(255) NOT NULL,
    PRIMARY KEY(genre_id)
)

--Many to many relationship between band and genre
CREATE TABLE band_genre(
    band_id int AUTO_INCREMENT,
    genre_id int,
    PRIMARY KEY(band_id, genre_id),
    FOREIGN KEY(band_id) REFERENCES band(band_id),
    FOREIGN KEY(genre_id) REFERENCES genre(genre_id)
)

CREATE TABLE subgenre(
    subgenre_id int AUTO_INCREMENT,
    subgenre_name varchar(255) NOT NULL,
    band_genre_id int,
    PRIMARY KEY(subgenre_id),
    FOREIGN KEY(band_genre_id) REFERENCES band_genre(band_genre_id)
)

CREATE TABLE artist(
    artist_id int AUTO_INCREMENT,
    artist_name varchar(255) NOT NULL,
    artist_stage_name varchar(255),
    band_id int,
    PRIMARY KEY(artist_id),
    FOREIGN KEY(band_id) REFERENCES band(band_id)
)
-- Store in a string the url of the social media and the name of the site
-- For example, "https://www.facebook.com/artist_name" and "Facebook"
-- We have 2 tables for social media, one for artists and one for bands
CREATE TABLE social_media_artist(
    social_media_artist_id int AUTO_INCREMENT,
    artist_id int,
    social_media_name varchar(255) NOT NULL,
    social_media_url varchar(255) NOT NULL,
    PRIMARY KEY(social_media_artist_id),
    FOREIGN KEY(artist_id) REFERENCES artist(artist_id),
)

CREATE TABLE social_media_band(
    social_media_band_id int AUTO_INCREMENT,
    band_id int,
    social_media_name varchar(255) NOT NULL,
    social_media_url varchar(255) NOT NULL,
    PRIMARY KEY(social_media_band_id),
    FOREIGN KEY(band_id) REFERENCES band(band_id),
)
CREATE TABLE ticket(
    EAN_13 int,
    ticket_type_id int,
    visitor_id int,
    event_id int,
    ticket_price float NOT NULL CHECK (ticket_price > 0),
    payment_method varchar(255) NOT NULL,
    validated boolean NOT NULL,
    PRIMARY KEY(ticket_id),
    FOREIGN KEY(ticket_type_id) REFERENCES ticket_type(ticket_type_id),
    FOREIGN KEY(event_id) REFERENCES event(event_id),
    FOREIGN KEY(visitor_id) REFERENCES visitor(visitor_id),
    FOREIGN KEY(payment_method) REFERENCES payment_method(payment_method),
)

CREATE TABLE payment_method(
    payment_method_id int AUTO_INCREMENT,
    payment_method_name varchar(255) NOT NULL,
    PRIMARY KEY(payment_method_id)
)

INSERT INTO payment_method(payment_method_name) VALUES('Credit card'), ('Debit card'), ('Paypal'), ('Cash');

CREATE TABLE ticket_type(
    ticket_type_id int AUTO_INCREMENT,
    ticket_type_name varchar(255) NOT NULL,
    PRIMARY KEY(ticket_type_id)
)

INSERT INTO ticket_type(ticket_type_name) VALUES('VIP'), ('Regular'), ('Student'), ('Senior citizen'),('backstage');

CREATE TABLE visitor(
    visitor_id int AUTO_INCREMENT,
    visitor_name varchar(255) NOT NULL,
    visitor_surname varchar(255) NOT NULL,
    visitor_age int NOT NULL CHECK (visitor_age > 0),
    PRIMARY KEY(visitor_id),
)

CREATE TABLE visitor_contact(
    visitor_contact_id int AUTO_INCREMENT,
    visitor_id int NOT NULL,
    visitor_email varchar(255) NOT NULL,
    visitor_phone varchar(255) NOT NULL,
    PRIMARY KEY(visitor_contact_id),
    FOREIGN KEY(visitor_id) REFERENCES visitor(visitor_id)
)

CREATE TABLE buyer{
    buyer_id int AUTO_INCREMENT,
    visitor_id int NOT NULL,
    date_issued int NOT NULL, 
    PRIMARY KEY(buyer_id),
    FOREIGN KEY(visitor_id)
}

CREATE TABLE reseling_tickets{
     reseling_ticket_id int AUTO_INCREMENT,
     EAN_13 int NOT NULL,
     PRIMARY KEY(reseling_ticket_id),
     FOREIGN KEY(EAN_13) REFERENCES ticket(EAN_13)
}

CREATE TABLE desired_by_id{
    buyer_id int NOT NULL,
    reseling_ticket_id int,
    PRIMARY KEY(buyer_id,reseling_ticket) 
}

CREATE TABLE desired_ticket_by_event{
    buyer_id int NOT NULL,
    ticket_type_id int NOT NULL,
    event_id int NOT NULL,
    PRIMARY KEY(buyer_id,ticket_type_id,event_id) 
    FOREIGN KEY(event_id) REFERENCES event(event_id)
    FOREIGN KEY(ticket_type_id) REFERENCES ticket_type(ticket_type_id)
}

CREATE TABLE reviews{
    reviews_id int AUTO_INCREMENT,
    visitor_id int,
    performance_id int
}

CREATE TABLE likert_scale{
    likert_scale_id int,
    review_id int,
    performance_score int CHECK(performance_score >= 1 && performance_score <= 5),
    sound_light_quality_score int CHECK(sound_light_quality_score >= 1 && sound_light_quality_score <= 5),
    stage_presence_score int CHECK(stage_presence_score >= 1 && stage_presence_score <= 5),
    organization_score int CHECK(organization_score >= 1 && organization_score <= 5)
    total_impression_score int CHECK(total_impression_score >= 1 && total_impression_score <= 5)
}

CREATE TABLE festival_image{
    festival_image_id int AUTO_INCREMENT,
    festival_id int NOT NULL,
    festival_image_description varchar(255),
    festival_image_path varchar(255) NOT NULL,
    PRIMARY KEY(festival_image_id),
    FOREIGN KEY(festival_id) REFERENCE festival(festival_id)
}

CREATE TABLE artist_image{
    artist_image_id int AUTO_INCREMENT,
    artist_id int NOT NULL,
    artist_image_description varchar(255),
    artist_image_path varchar(255) NOT NULL,
    PRIMARY KEY(artist_image_id),
    FOREIGN KEY(artist_id) REFERENCE artist(artist_id)
}

CREATE TABLE location_image{
    location_image_id int AUTO_INCREMENT,
    location_id int NOT NULL,
    location_image_description varchar(255),
    location_image_path varchar(255) NOT NULL,
    PRIMARY KEY(location_image_id),
    FOREIGN KEY(location_id) REFERENCE location(location_id)
}

CREATE TABLE post_performance_image(
    post_performance_image_id int AUTO_INCREMENT,
    performance_id int NOT NULL,
    post_performance_image_description varchar(255),
    post_performance_image_path varchar(255) NOT NULL
    PRIMARY KEY(post_performance_image_id),
    FOREIGN KEY(performance_id) REFERENCE performace(performance_id)
)

CREATE TABLE band_image(
    band_image_id int AUTO_INCREMENT,
    band_id int NOT NULL,
    band_image_description varchar(255),
    band_image_path varchar(255) NOT NULL
    PRIMARY KEY(band_image_id),
    FOREIGN KEY(band_id) REFERENCE band(band_id)
)

CREATE TABLE staff_image(
    staff_image_id int AUTO_INCREMENT,
    staff_id int NOT NULL,
    staff_image_description varchar(255),
    staff_image_path varchar(255) NOT NULL
    PRIMARY KEY(staff_image_id),
    FOREIGN KEY(staff_id) REFERENCE staff(staff_id)
)


CREATE TABLE event_image(
    event_image_id int AUTO_INCREMENT,
    event_id int NOT NULL,
    event_image_description varchar(255),
    event_image_path varchar(255) NOT NULL
    PRIMARY KEY(event_image_id),
    FOREIGN KEY(event_id) REFERENCE event(event_id)
)

