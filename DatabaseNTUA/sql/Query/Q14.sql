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
    WHERE f.festival_year < 2025
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


