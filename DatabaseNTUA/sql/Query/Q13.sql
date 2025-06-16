SELECT 
    a.artist_id,
    a.artist_stage_name,
    COUNT(DISTINCT fl.continent) AS unique_continents
FROM 
    artist a
JOIN artist_band ab ON a.artist_id = ab.artist_id
JOIN band b ON ab.band_id = b.band_id
JOIN performance p ON p.band_id = b.band_id
JOIN event e ON e.event_id = p.event_id
JOIN festival f ON f.festival_year = e.festival_year
JOIN festival_location fl ON f.location_id = fl.location_id
WHERE f.festival_year < 2025
GROUP BY 
    a.artist_id, a.artist_name
HAVING 
    COUNT(DISTINCT fl.continent) >= 3
ORDER BY 
    unique_continents DESC;


