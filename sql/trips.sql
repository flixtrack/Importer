SET NAMES 'utf8' COLLATE 'utf8_general_ci';
USE flixtrack;

LOAD DATA LOCAL INFILE './data/trips.txt' INTO TABLE trips CHARACTER SET UTF8 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;
