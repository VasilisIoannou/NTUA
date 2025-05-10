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
/* View to find all the staff that are not assigned to any stage */
CREATE OR REPLACE VIEW unassigned_secondary_staff AS
SELECT
    s.staff_id,
    s.staff_name,
    s.staff_email,
    s.staff_phone
FROM
    staff s
WHERE
    s.staff_role_id = 3
    AND s.staff_id NOT IN (
        SELECT ss.staff_id
        FROM stage_staff ss
    );

/* View to find all the staff that are not assigned to any stage per festival day */
CREATE OR REPLACE VIEW unassigned_secondary_staff_per_day AS
SELECT 
    d.day AS festival_day,
    s.staff_id,
    s.staff_name,
    s.staff_email,
    s.staff_phone
FROM 
    staff s
CROSS JOIN (
    SELECT DISTINCT festival_day AS day FROM event
) d
WHERE 
    s.staff_role_id = 3
    AND NOT EXISTS (
        SELECT 1
        FROM stage_staff ss
        JOIN event e ON ss.stage_id = e.stage_id
        WHERE e.festival_day = d.day
          AND ss.staff_id = s.staff_id
    );



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
/* View to find the staff that is needed per festival day */
CREATE OR REPLACE VIEW required_staff_per_festival_day AS
SELECT
    f.festival_year,
    e.festival_day,
    CEIL(COUNT(t.EAN_13) * 0.05) AS required_security_staff,
    CEIL(COUNT(t.EAN_13) * 0.02) AS required_secondary_staff
FROM
    ticket t
JOIN event e ON t.event_id = e.event_id
JOIN festival f ON e.festival_year = f.festival_year
GROUP BY
    f.festival_year,
    e.festival_day
ORDER BY
    f.festival_year,
    e.festival_day;


--13--
/* View to find all artists who have performed in 3 or more continents */
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
/* View to find the genres that have performed the same number of times in two consecutive festivals */
CREATE OR REPLACE VIEW consistent_genres_two_years AS
WITH genre_performances AS (
    SELECT
        f.festival_year,
        g.genre_name,
        COUNT(*) AS performance_count
    FROM
        performance p
    JOIN event e ON e.event_id = p.event_id
    JOIN festival f ON f.festival_year = e.festival_year
    JOIN band b ON b.band_id = p.band_id
    JOIN band_subgenre bs ON bs.band_id = b.band_id
    JOIN subgenre sg ON sg.subgenre_id = bs.subgenre_id
    JOIN genre g ON g.genre_id = sg.genre_id
    GROUP BY
        f.festival_year, g.genre_name
    HAVING COUNT(*) >= 3
),
matched_years AS (
    SELECT
        g1.genre_name,
        g1.festival_year AS year1,
        g2.festival_year AS year2,
        g1.performance_count
    FROM
        genre_performances g1
    JOIN genre_performances g2
        ON g1.genre_name = g2.genre_name
        AND g1.festival_year = g2.festival_year - 1
        AND g1.performance_count = g2.performance_count
)
SELECT
    genre_name,
    year1 AS first_year,
    year2 AS second_year,
    performance_count
FROM
    matched_years
ORDER BY
    genre_name, year1;











