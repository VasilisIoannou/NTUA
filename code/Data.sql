-- Active: 1742738056874@@127.0.0.1@3306@festivaldb
-- Start client with local-infile enabled
mysql --local-infile=1 -u root -p
-- In MySQL shell:
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'D:/DATA/Uni/6th Semester/Databases/Festival/DatabaseNTUA/CSV Files/visitor.csv'
INTO TABLE `visitor`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'D:/DATA/Uni/6th Semester/Databases/Festival/DatabaseNTUA/CSV Files/ticket.csv'
INTO TABLE `ticket`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/DATA/Uni/6th Semester/Databases/Festival/DatabaseNTUA/CSV Files/coordinates.csv'
INTO TABLE `coordinates`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/DATA/Uni/6th Semester/Databases/Festival/DatabaseNTUA/CSV Files/festival_location.csv'
INTO TABLE `festival_location`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/DATA/Uni/6th Semester/Databases/Festival/DatabaseNTUA/CSV Files/break_duration.csv'
INTO TABLE `break_duration`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;





