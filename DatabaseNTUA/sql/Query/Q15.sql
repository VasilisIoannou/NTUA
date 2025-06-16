SELECT 
    CONCAT(v.visitor_name, ' ', v.visitor_surname) AS visitor_name,
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
    event e ON p.event_id = e.event_id
JOIN 
    band b ON p.band_id = b.band_id
WHERE e.festival_year < 2025
GROUP BY 
    v.visitor_id, b.band_id
ORDER BY 
    total_review_score DESC
LIMIT 5;


