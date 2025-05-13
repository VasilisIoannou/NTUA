/* Original Query - Default Join Strategy - Nestsed Loop Joins */

EXPLAIN

SELECT DISTINCT
    b.band_name,
    ROUND(AVG(ls.performance_score), 2) AS avg_performance_score,
    ROUND(AVG(ls.stage_presence_score), 2) AS avg_stage_presence_score
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

/* Check Result with [ EXPLAIN ANALYZE ] */

EXPLAIN ANALYZE;

/* Forcing Hash Join */
/* Set the optimizer and the comment /*+ HASH_JOIN(ls r) */ /* suggests the optimizer to use hash joins */

SET optimizer_switch='join_cache_hashed=on';

SELECT DISTINCT
    b.band_name,
    ROUND(AVG(ls.performance_score), 2) AS avg_performance_score,
    ROUND(AVG(ls.stage_presence_score), 2) AS avg_stage_presence_score
FROM
    likert_scale ls
/*+ HASH_JOIN(ls r) */
JOIN reviews r ON ls.reviews_id = r.reviews_id
JOIN performance p ON r.performance_id = p.performance_id
JOIN band b ON b.band_id = p.band_id
GROUP BY 
    b.band_id
ORDER BY
    avg_performance_score DESC,
    avg_stage_presence_score DESC;

/* Hash Joins are effective for large tables with no optimizers */

/* Forcing Merge Join */

/* It works best for pre-sorted join keys */

SET optimizer_switch='index_merge=on';

SELECT DISTINCT
    b.band_name,
    ROUND(AVG(ls.performance_score), 2) AS avg_performance_score,
    ROUND(AVG(ls.stage_presence_score), 2) AS avg_stage_presence_score
FROM
    likert_scale ls
/*+ MERGE_JOIN(ls r) */
JOIN reviews r ON ls.reviews_id = r.reviews_id
JOIN performance p ON r.performance_id = p.performance_id
JOIN band b ON b.band_id = p.band_id
GROUP BY 
    b.band_id
ORDER BY
    avg_performance_score DESC,
    avg_stage_presence_score DESC;

/* Works Best if the reviews.id have INDEXES */

/* Forcing Indexes */


SELECT DISTINCT
    b.band_name,
    ROUND(AVG(ls.performance_score), 2) AS avg_performance_score,
    ROUND(AVG(ls.stage_presence_score), 2) AS avg_stage_presence_score
FROM
    likert_scale ls FORCE INDEX (reviews_id)
JOIN reviews r FORCE INDEX (performance_id) ON ls.reviews_id = r.reviews_id
JOIN performance p FORCE INDEX (band_id) ON r.performance_id = p.performance_id
JOIN band b FORCE INDEX (PRIMARY) ON b.band_id = p.band_id
GROUP BY 
    b.band_id
ORDER BY
    avg_performance_score DESC,
    avg_stage_presence_score DESC;

