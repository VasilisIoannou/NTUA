CREATE OR REPLACE VIEW avg_review_score_visitor_per_event AS
SELECT
    r.visitor_id,
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
JOIN performance p ON r.performance_id = p.performance_id
JOIN event e ON p.event_id = e.event_id
GROUP BY
    r.visitor_id,
    e.event_id
ORDER BY
    avg_review_score DESC;

/* Forcing Hash Joints */
/* Note: For MaraiDB 10.5+ */

SET optimizer_switch='hash_join=on';
EXPLAIN ANALYZE
SELECT
    r.visitor_id,
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
/*+ HASH_JOIN(r ls) HASH_JOIN(r p) HASH_JOIN(p e) */
JOIN likert_scale ls ON r.reviews_id = ls.reviews_id
JOIN performance p ON r.performance_id = p.performance_id
JOIN event e ON p.event_id = e.event_id
GROUP BY
    r.visitor_id,
    e.event_id
ORDER BY
    avg_review_score DESC;

/* Forcing Merge Joins */

SET optimizer_switch='merge_sort_join=on';
EXPLAIN ANALYZE
SELECT
    r.visitor_id,
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
/*+ MERGE_JOIN(r ls) MERGE_JOIN(r p) MERGE_JOIN(p e) */
JOIN likert_scale ls ON r.reviews_id = ls.reviews_id
JOIN performance p ON r.performance_id = p.performance_id
JOIN event e ON p.event_id = e.event_id
GROUP BY
    r.visitor_id,
    e.event_id
ORDER BY
    avg_review_score DESC;

/* Forcing Indexes */


EXPLAIN ANALYZE
SELECT
    r.visitor_id,
    e.event_id,
    ROUND(AVG((
        ls.performance_score +
        ls.sound_light_quality_score +
        ls.stage_presence_score +
        ls.organization_score +
        ls.total_impression_score
    ) /5 ), 2) AS avg_review_score
FROM
    reviews r FORCE INDEX (idx_reviews_id)
JOIN likert_scale ls FORCE INDEX (PRIMARY) ON r.reviews_id = ls.reviews_id
JOIN performance p FORCE INDEX (idx_performance_id) ON r.performance_id = p.performance_id
JOIN event e FORCE INDEX (PRIMARY) ON p.event_id = e.event_id
GROUP BY
    r.visitor_id,
    e.event_id
ORDER BY
    avg_review_score DESC;
