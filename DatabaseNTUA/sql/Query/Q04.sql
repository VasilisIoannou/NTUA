SELECT DISTINCT
    b.band_name,
    ROUND(AVG(ls.performance_score),2)AS avg_performance_score,
    ROUND(AVG(ls.stage_presence_score),2) AS avg_stage_presence_score
FROM
    likert_scale ls
JOIN reviews r ON ls.reviews_id = r.reviews_id
JOIN performance p ON r.performance_id = p.performance_id
JOIN band b ON b.band_id = p.band_id
GROUP BY 
    b.band_id
ORDER BY
    avg_performance_score DESC,
    avg_stage_presence_score DESC;


