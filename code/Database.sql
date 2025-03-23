-- Active: 1742738056874@@127.0.0.1@3306@festivaldb
-- Active: 1742738056874@@127.0.0.1@3306
CREATE DATABASE festivalDB;

CREATE TABLE guy(
    guy_id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(255),
    email VARCHAR(255),
    PRIMARY KEY( guy_id )
)

CREATE TABLE frogs(
    frog_id int NOT NULL AUTO_INCREMENT,
    guy_id int NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (frog_id),
    FOREIGN KEY( guy_id ) REFERENCES guy(guy_id)
)

DROP TABLE guy;
DROP TABLE frogs;