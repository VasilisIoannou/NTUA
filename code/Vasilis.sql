SELECT 
    CONCAT(v.visitor_name, ' ', v.visitor_surname) AS visitor_name,
    a.artist_name,
    b.band_name,
    SUM(ls.performance_score +  ls.stage_presence_score + ls.total_impression_score) AS total_review_score
FROM 
    reviews r
JOIN 
    likert_scale ls ON r.reviews_id = ls.reviews_id
JOIN 
    visitor v ON r.visitor_id = v.visitor_id
JOIN 
    performance p ON r.performance_id = p.performance_id
JOIN 
    band b ON p.band_id = b.band_id
JOIN
    artist_band ab ON b.band_id = ab.band_id
JOIN
    artist a ON ab.artist_id = a.artist_id
GROUP BY 
    v.visitor_id, a.artist_id, b.band_id
ORDER BY 
    total_review_score DESC
LIMIT 5;
