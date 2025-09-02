CREATE TABLE airlines (
id INT,
airline VARCHAR(10),
flight_code VARCHAR(15),
flight_number INT,
flight VARCHAR(20),
source_city VARCHAR(30),
departure_time VARCHAR(30),
stops VARCHAR(30),
arrival_time VARCHAR(30),
destination_city VARCHAR(30),
class VARCHAR(30),
duration FLOAT,
days_left INT,
price INT,
flight_code_test VARCHAR(30)
);


SELECT *
FROM airlines;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\airlines_flight_data_clean.csv"
INTO TABLE airlines
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
IGNORE 1 LINES;

SHOW VARIABLES LIKE "secure_file_priv";

CREATE TABLE most_popular_routes AS
SELECT 
	GREATEST(source_city, destination_city) AS source_city,
    LEAST(destination_city, source_city) AS destination_city,
    COUNT(*) AS flight_num,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY 1, 2
ORDER BY flight_num DESC
;

DROP TABLE most_popular_routes;