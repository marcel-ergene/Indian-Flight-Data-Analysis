SELECT *
FROM airlines
;


-- Data Cleaning ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Spalten "flight_code", "flight_number", "id" und "flight_code_test" löschen
ALTER TABLE airlines
DROP COLUMN flight_code
;

ALTER TABLE airlines
DROP COLUMN flight_number
;

ALTER TABLE airlines
DROP COLUMN flight_code_test
;

ALTER TABLE airlines
DROP COLUMN id
;

SELECT *
FROM airlines
;

-- Spalte "flight" löschen, da es für die Analyse nicht zu gebrauchen ist
ALTER TABLE airlines
DROP COLUMN flight
;



-- Exploratory Data Analysis
-- wieviele Flüge hat jede airline hinter sich? Absteigend
-- welche ist die beliebteste airline in Indien
SELECT
	airline,
    COUNT(airline) AS flight_count,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM airlines),2) AS flight_count_percent
FROM airlines
GROUP BY airline
ORDER BY flight_count DESC
;


-- wieviele Flüge kommen aus den einzlenen Städten und wieviele Flüge kommen in die einzelnen Städte an (ranked) ----------------------------------------------------------------------------
-- wieviele Flüge kommen aus den einzelenen Städten?
SELECT
	source_city,
    COUNT(source_city) AS departure_num
FROM airlines
GROUP BY source_city
ORDER BY departure_num DESC
;

-- wieviele Flüge kommen in den einzelnen städten an?
SELECT
    destination_city,
    COUNT(destination_city) AS destination_num
FROM airlines
GROUP BY destination_city
ORDER BY destination_num DESC
;

-- direkter Vergleich
SELECT *
FROM
	(SELECT source_city, COUNT(source_city) AS departure_num, DENSE_RANK() OVER(ORDER BY COUNT(source_city) DESC) AS departure_rank
    FROM airlines
    GROUP BY source_city
    ORDER BY departure_num DESC) a
JOIN
	(SELECT destination_city, COUNT(destination_city) AS arrival_num, DENSE_RANK() OVER(ORDER BY COUNT(destination_city) DESC) AS arrival_rank
    FROM airlines
    GROUP BY destination_city) b
ON source_city = destination_city
;

-- Welche airline sind in welchen Städten am häufigsten vertreten? -Die Top 1 in jeder Stadt --------------------------------------------------------------------------------------------------
WITH cte AS
(
SELECT
	DISTINCT airline,
    source_city,
    COUNT(airline) AS airline_num,
    DENSE_RANK() OVER(PARTITION BY source_city ORDER BY COUNT(airline) DESC) AS ranked
FROM airlines
GROUP BY airline, source_city
ORDER BY source_city, airline_num DESC
)
SELECT
	DISTINCT airline,
    source_city,
	airline_num
FROM cte
WHERE ranked = 1
;

-- Welche Flugrouten sind am beliebtesten? (hin- und rückflug kombiniert) -----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	GREATEST(source_city, destination_city) AS source_city,
    LEAST(destination_city, source_city) AS destination_city,
    COUNT(*) AS flight_num
FROM airlines
GROUP BY 1, 2
ORDER BY flight_num DESC
;

-- Wann starten die Flüge am meisten und wann kommen diese an?-------------------------------------------------------------------------------------------
-- wann starten die flüge am häufigsten?
SELECT
	departure_time,
    COUNT(*) AS departure_num,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM airlines), 2) AS departure_percent
FROM airlines
GROUP BY departure_time
ORDER BY departure_num DESC
;

-- airline-spezifisch: wann starten die flüge am häufigsten?
SELECT
	airline,
	departure_time,
    COUNT(*) AS departure_num,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(PARTITION BY airline), 2) AS departure_percent
FROM airlines
GROUP BY departure_time, airline
ORDER BY airline, departure_num DESC
;

-- wann landen die Flieger am häufigsten?
SELECT
    arrival_time,
    COUNT(*) AS arrival_num,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM airlines), 2) AS arrival_percent
FROM airlines
GROUP BY arrival_time
ORDER BY arrival_num DESC;

-- airline-spezifisch: wann landen die Flieger am häufigsten?
SELECT
	airline,
	arrival_time,
    COUNT(*) AS arrival_num,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(PARTITION BY airline), 2) AS arrival_percent
FROM airlines
GROUP BY arrival_time, airline
ORDER BY airline, arrival_num DESC
;

-- wieviele stops macht jede airline? ----------------------------------------------------------------------------------------------------------
SELECT
	airline,
    stops,
    COUNT(*) AS stops_count,
    ROUND((COUNT(*) * 100) / SUM(COUNT(*)) OVER(PARTITION BY airline), 2) AS stops_percent
FROM airlines
GROUP BY airline, stops
ORDER BY airline,stops_count DESC
;

SELECT
    stops,
    COUNT(*) AS stops_count,
    ROUND((COUNT(*) * 100) / (SELECT COUNT(*) FROM airlines), 2) AS stops_percent
FROM airlines
GROUP BY stops
ORDER BY stops_count DESC
;

-- Welche Klasse wird am meisten gewählt? ---------------------------------------------------------------------------------------------------------
SELECT
	class,
    COUNT(*) AS class_count,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM airlines), 2) AS class_percent
FROM airlines
GROUP BY class
ORDER BY class_count DESC
;

-- airline-spezifisch: Welche Klasse wird am meisten gewählt?
SELECT
	airline,
	class,
    COUNT(*) AS class_count,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(PARTITION BY airline), 2) AS class_percent
FROM airlines
GROUP BY airline, class
ORDER BY airline, class_count DESC
;

-- wie lange dauern die Flüge durchschnittlich bei jeder route?
SELECT
	DISTINCT GREATEST(source_city, destination_city) AS city_a,
    LEAST(destination_city, source_city) AS city_b,
    ROUND(AVG(duration), 2) AS avg_duration_in_h
FROM airlines
GROUP BY GREATEST(source_city, destination_city), LEAST(destination_city, source_city)
ORDER BY avg_duration_in_h
;

-- hängt die Dauer der Flugroute von der airline ab?
SELECT
	DISTINCT airline,
    source_city,
    destination_city,
    ROUND(AVG(duration), 2) AS avg_duration_in_h
FROM airlines
GROUP BY airline, source_city, destination_city
ORDER BY source_city, destination_city, avg_duration_in_h
;

WITH cte2 AS
(
WITH cte AS
(
SELECT
	DISTINCT airline,
    source_city,
    destination_city,
    ROUND(AVG(duration), 2) AS avg_duration_in_h,
    DENSE_RANK() OVER(PARTITION BY source_city, destination_city ORDER BY ROUND(AVG(duration), 2)) AS ranked
FROM airlines
GROUP BY airline, source_city, destination_city
ORDER BY source_city, destination_city, avg_duration_in_h
)
SELECT *,
    COUNT(airline) OVER(PARTITION BY airline) AS count_fastest_airline
FROM cte
WHERE ranked = 1
)
SELECT
	airline,
    count_fastest_airline,
    (SELECT COUNT(DISTINCT source_city,
    destination_city) FROM airlines) AS routes_num
FROM cte2
GROUP BY airline
ORDER BY count_fastest_airline DESC
;
    
-- hängt die Dauer der Flugroute von der Klasse ab?

WITH cte AS
(
SELECT
    DISTINCT class,
    source_city,
    destination_city,
    ROUND(AVG(duration), 2) AS avg_duration_in_h,
    DENSE_RANK() OVER(PARTITION BY source_city, destination_city ORDER BY ROUND(AVG(duration), 2)) AS ranked
FROM airlines
GROUP BY class, source_city, destination_city
ORDER BY source_city, destination_city, avg_duration_in_h
)
SELECT
	class,
    COUNT(ranked)
FROM cte
WHERE ranked = 1
GROUP BY class
;

-- wie lange dauern die Flüge mit den stops? (im Durchschnitt)
SELECT
	stops,
    ROUND(AVG(duration), 2) AS avg_duration
FROM airlines
GROUP BY stops
;

-- Wie hoch sind die Ticket-Preise? ----------------------------------------------------------------------------------------------------------------------
-- Ticket-Preis im Durchschnitt (alle airlines)
SELECT
	ROUND(AVG(price), 2) AS avg_price
FROM airlines
;
-- der höchste, niedrigste und durchschnittliche Ticket-Preis pro airline
SELECT 
	airline,
    MAX(price) AS highest_price,
    DENSE_RANK() OVER(ORDER BY MAX(price) DESC) AS rank_highest_price,
    MIN(price) As lowest_price,
    DENSE_RANK() OVER(ORDER BY MIN(price)) AS rank_lowest_price,
    ROUND(AVG(price), 2) AS avg_price,
    DENSE_RANK() OVER(ORDER BY AVG(price)) AS rank_avg_price
FROM airlines
GROUP BY airline
;

-- hängt der Preis von der Klasse ab?
-- Preis pro Klasse (alle airlines)
SELECT
	class,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY class
;

-- Preis pro Klasse airline-spezifisch
SELECT
	airline,
	class,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY airline, class
ORDER BY airline
;

-- Welche Flugrouten sind teurer bzw. billiger?

SELECT
	GREATEST(source_city, destination_city) AS city_a,
    LEAST(destination_city, source_city) As city_b,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY GREATEST(source_city, destination_city), LEAST(destination_city, source_city)
ORDER BY avg_price
;

-- airline-spezifisch: welche Route ist billiger/teurer?
SELECT
	airline,
	GREATEST(source_city, destination_city) AS city_a,
    LEAST(destination_city, source_city) As city_b,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY airline, GREATEST(source_city, destination_city), LEAST(destination_city, source_city)
ORDER BY GREATEST(source_city, destination_city), LEAST(destination_city, source_city), avg_price
;

-- wie hängt der Preis mit der Spalte "days_left" zusammen? wird es höher je weniger Tage verbleiben bis zum Start?
SELECT
	days_left,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY days_left
ORDER BY avg_price
;

SELECT
	airline,
	days_left,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY airline, days_left
ORDER BY airline, avg_price
;

-- hängt der Preis von den Städten ab, wo der Flieger startet?
SELECT
	airline,
	source_city,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY airline, source_city
ORDER BY airline, avg_price DESC
;

SELECT
	source_city,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY source_city
ORDER BY avg_price DESC
;

-- ist der Preis von der Startzeit abhängig?
SELECT 
	airline,
	departure_time,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY airline, departure_time
ORDER BY airline, avg_price DESC
;

SELECT 
	departure_time,
    ROUND(AVG(price), 2) AS avg_price
FROM airlines
GROUP BY departure_time
ORDER BY avg_price DESC
;