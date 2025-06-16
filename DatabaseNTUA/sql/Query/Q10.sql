SELECT 
    LEAST(g1.genre_name, g2.genre_name) AS genre_1,
    GREATEST(g1.genre_name, g2.genre_name) AS genre_2,
    COUNT(DISTINCT bs1.band_id) AS band_count
FROM band_subgenre bs1
JOIN subgenre sg1 ON bs1.subgenre_id = sg1.subgenre_id
JOIN genre g1 ON sg1.genre_id = g1.genre_id

JOIN band_subgenre bs2 ON bs1.band_id = bs2.band_id AND bs1.subgenre_id < bs2.subgenre_id
JOIN subgenre sg2 ON bs2.subgenre_id = sg2.subgenre_id
JOIN genre g2 ON sg2.genre_id = g2.genre_id

WHERE EXISTS (
    SELECT 1
    FROM performance p
    JOIN event e ON e.event_id = p.event_id
    JOIN festival f ON f.festival_year = e.festival_year
    WHERE p.band_id = bs1.band_id AND f.festival_year < 2025
)
AND g1.genre_id != g2.genre_id

GROUP BY genre_1, genre_2
ORDER BY band_count DESC
LIMIT 3;
