-- Active: 1746819443116@@127.0.0.1@3309@festivaldb


--1--

/* View to get the total earnings per festival year */
CREATE OR REPLACE VIEW total_festival_earnings_per_year AS
SELECT
    f.festival_year,
    SUM(t.ticket_price) AS total_earnings
FROM
    festival f
JOIN event e ON e.festival_year = f.festival_year
JOIN ticket t ON t.event_id = e.event_id
GROUP BY
    f.festival_year
ORDER BY
    f.festival_year;


/* View to get the total earnings per festival year and payment method */
CREATE OR REPLACE VIEW festival_earnings_per_payment_method AS
SELECT
    f.festival_year,
    pm.payment_method_name,
    SUM(t.ticket_price) AS total_earnings
FROM
    festival f
JOIN event e ON e.festival_year = f.festival_year
JOIN ticket t ON t.event_id = e.event_id
JOIN payment_method pm ON pm.payment_method_id = t.payment_method_id
GROUP BY
    f.festival_year,
    pm.payment_method_name
ORDER BY
    f.festival_year,
    pm.payment_method_name;

/* View to get the total earnings per festival year and ticket type */
CREATE OR REPLACE VIEW festival_earnings_per_ticket_type AS
SELECT
    f.festival_year,
    tt.ticket_type_name,
    SUM(t.ticket_price) AS total_earnings
FROM
    festival f
JOIN event e ON e.festival_year = f.festival_year
JOIN ticket t ON t.event_id = e.event_id
JOIN ticket_type tt ON tt.ticket_type_id = t.ticket_type_id
GROUP BY
    f.festival_year,
    tt.ticket_type_name
ORDER BY
    f.festival_year,
    tt.ticket_type_name;


--2--

/* View to find all the bands that belong to a given genre per year */
CREATE OR REPLACE VIEW genre_bands_per_year AS
SELECT DISTINCT
    f.festival_year,
    b.band_name,
    g.genre_name
FROM
    band b
JOIN band_subgenre bs ON b.band_id = bs.band_id
JOIN subgenre sg ON sg.subgenre_id = bs.subgenre_id
JOIN genre g ON g.genre_id = sg.genre_id
JOIN performance p ON p.band_id = b.band_id
JOIN event e ON e.event_id = p.event_id
JOIN festival f ON f.festival_year = e.festival_year
ORDER BY
    f.festival_year,
    b.band_name;

--3--

/* View to find all the artists that performed more than 2 warmup performances in a festival */
CREATE OR REPLACE VIEW more_than_two_warm_up AS
SELECT DISTINCT
    f.festival_year,
    a.artist_name
FROM
    artist a
JOIN artist_band ab ON a.artist_id = ab.artist_id
JOIN band b ON b.band_id = ab.band_id
JOIN performance p ON p.band_id = b.band_id
JOIN event e ON e.event_id = p.event_id
JOIN festival f ON f.festival_year = e.festival_year
WHERE
    p.performance_type_id = 1
GROUP BY 
    f.festival_year, 
    a.artist_name
HAVING 
    COUNT(p.performance_id) > 2
ORDER BY
    f.festival_year,
    b.band_name;

--4--





--5--

/* View to find the artists who are below 30 years old and have performed the most times in festivals */
CREATE OR REPLACE VIEW most_appearances_by_young_artists AS
SELECT 
    a.artist_name,
    COUNT(DISTINCT f.festival_year) AS festivals_performed
FROM 
    artist a
JOIN artist_band ab ON a.artist_id = ab.artist_id
JOIN band b ON b.band_id = ab.band_id
JOIN performance p ON p.band_id = b.band_id
JOIN event e ON e.event_id = p.event_id
JOIN festival f ON f.festival_year = e.festival_year
WHERE 
    (YEAR(CURDATE()) - a.artist_year_of_birth) < 30
GROUP BY 
    a.artist_name
ORDER BY 
    festivals_performed DESC;


--6--



--7--

/* View to find festival with lowest average experience of technichal staff*/
CREATE OR REPLACE VIEW festival_lowest_avg_experience_tech_staff AS
SELECT 
    f.festival_year,
    AVG(level_of_experience.level_of_experience_id) AS lvl_exp
FROM
    festival f
JOIN event e ON e.festival_year = f.festival_year
JOIN stage s ON e.stage_id = s.stage_id
JOIN stage_staff ss ON s.stage_id = ss.stage_id
JOIN staff st ON ss.staff_id = st.staff_id
JOIN staff_role sr ON st.staff_role_id = sr.staff_role_id
JOIN level_of_experience ON st.level_of_experience = level_of_experience.level_of_experience_id
WHERE
    sr.staff_role_id = 1
GROUP BY
    f.festival_year
ORDER BY
    lvl_exp ASC
LIMIT 1;


--8--




--9--



--10--


--11--
/* View to find all artists who have performed in 5 less festivals than the most performing artist */
CREATE OR REPLACE VIEW artists_more_than_5_less_festivals_than_max AS
WITH artist_festival_counts AS (
    SELECT 
        a.artist_id,
        a.artist_name,
        COUNT(DISTINCT f.festival_year) AS festivals_participated
    FROM 
        artist a
    JOIN artist_band ab ON a.artist_id = ab.artist_id
    JOIN band b ON ab.band_id = b.band_id
    JOIN performance p ON p.band_id = b.band_id
    JOIN event e ON e.event_id = p.event_id
    JOIN festival f ON f.festival_year = e.festival_year
    GROUP BY a.artist_id, a.artist_name
),
max_festival_count AS (
    SELECT MAX(festivals_participated) AS max_festivals
    FROM artist_festival_counts
)
SELECT 
    afc.artist_id,
    afc.artist_name,
    afc.festivals_participated
FROM 
    artist_festival_counts afc
JOIN 
    max_festival_count mfc 
    ON afc.festivals_participated < mfc.max_festivals - 5
ORDER BY 
    afc.festivals_participated DESC;


--12--



--13--
CREATE OR REPLACE VIEW artists_in_3_or_more_continents AS
SELECT 
    a.artist_id,
    a.artist_name,
    COUNT(DISTINCT fl.continent) AS unique_continents
FROM 
    artist a
JOIN artist_band ab ON a.artist_id = ab.artist_id
JOIN band b ON ab.band_id = b.band_id
JOIN performance p ON p.band_id = b.band_id
JOIN event e ON e.event_id = p.event_id
JOIN festival f ON f.festival_year = e.festival_year
JOIN festival_location fl ON f.location_id = fl.location_id
GROUP BY 
    a.artist_id, a.artist_name
HAVING 
    COUNT(DISTINCT fl.continent) >= 3
ORDER BY 
    unique_continents DESC;


--14--









