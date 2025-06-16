SELECT
    v.visitor_name,
    v.visitor_surname,
    e.event_id,
    ROUND(AVG((
        ls.performance_score +
        ls.sound_light_quality_score +
        ls.stage_presence_score +
        ls.organization_score +
        ls.total_impression_score
    ) /5 ), 2) AS avg_review_score
FROM
    reviews r
JOIN likert_scale ls ON r.reviews_id = ls.reviews_id
JOIN visitor v ON r.visitor_id = v.visitor_id
JOIN performance p ON r.performance_id = p.performance_id
JOIN event e ON p.event_id = e.event_id
GROUP BY
    r.visitor_id,
    e.event_id
ORDER BY
    avg_review_score DESC;




    


