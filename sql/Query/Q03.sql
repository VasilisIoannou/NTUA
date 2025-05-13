SELECT DISTINCT
    f.festival_year,
    a.artist_stage_name,
    COUNT(p.performance_id) AS warm_up_performances
FROM
    artist a
JOIN artist_band ab ON a.artist_id = ab.artist_id
JOIN band b ON b.band_id = ab.band_id
JOIN performance p ON p.band_id = b.band_id
JOIN event e ON e.event_id = p.event_id
JOIN festival f ON f.festival_year = e.festival_year
WHERE
    p.performance_type_id = 1 AND f.festival_year < 2025
GROUP BY 
    f.festival_year, 
    a.artist_id
HAVING 
    COUNT(p.performance_id) > 2
ORDER BY
    f.festival_year,
    b.band_name;


