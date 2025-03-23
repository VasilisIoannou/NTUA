CREATE DATABASE festivalDB;

CREATE TABLE guy(
    guy_id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(255),
    email VARCHAR(255),
    frog_id int,
    PRIMARY KEY( guy_id ),
    FOREIGN KEY( frog_id ) REFERENCES frogs(frog_id)
)

CREATE TABLE frogs(
    frog_id int NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (frog_id)
)

DROP TABLE Kati;