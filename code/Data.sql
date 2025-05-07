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

