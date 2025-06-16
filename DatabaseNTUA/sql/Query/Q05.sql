SELECT 
    a.artist_stage_name,
    COUNT(DISTINCT f.festival_year) AS festivals_performed
FROM 
    artist a
JOIN artist_band ab ON a.artist_id = ab.artist_id
JOIN band b ON b.band_id = ab.band_id
JOIN performance p ON p.band_id = b.band_id
JOIN event e ON e.event_id = p.event_id
JOIN festival f ON f.festival_year = e.festival_year
WHERE 
    (YEAR(CURDATE()) - a.artist_year_of_birth) < 30 AND f.festival_year < 2025
GROUP BY 
    a.artist_id
ORDER BY 
    festivals_performed DESC;


