WITH artist_festival_counts AS (
    SELECT 
        a.artist_id,
        a.artist_stage_name,
        COUNT(DISTINCT f.festival_year) AS festivals_participated
    FROM 
        artist a
    JOIN artist_band ab ON a.artist_id = ab.artist_id
    JOIN band b ON ab.band_id = b.band_id
    JOIN performance p ON p.band_id = b.band_id
    JOIN event e ON e.event_id = p.event_id
    JOIN festival f ON f.festival_year = e.festival_year
    WHERE f.festival_year
    GROUP BY a.artist_id, a.artist_name
),
max_festival_count AS (
    SELECT MAX(festivals_participated) AS max_festivals
    FROM artist_festival_counts
)
SELECT 
    afc.artist_id,
    afc.artist_stage_name,
    afc.festivals_participated
FROM 
    artist_festival_counts afc
JOIN 
    max_festival_count mfc 
    ON afc.festivals_participated < mfc.max_festivals - 4
ORDER BY 
    afc.festivals_participated DESC;


