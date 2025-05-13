SELECT
    f.festival_year,
    e.festival_day,
    CEIL(COUNT(t.EAN_13) * 0.05) AS required_security_staff,
    CEIL(COUNT(t.EAN_13) * 0.02) AS required_secondary_staff,
    COUNT(DISTINCT e.event_id) * 2 AS required_technicians
FROM
    ticket t
JOIN event e ON t.event_id = e.event_id
JOIN festival f ON e.festival_year = f.festival_year
GROUP BY
    f.festival_year,
    e.festival_day
ORDER BY
    f.festival_year,
    e.festival_day;


