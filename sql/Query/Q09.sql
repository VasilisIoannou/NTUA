WITH attendance_counts AS (
    SELECT
        v.visitor_id,
        v.visitor_name,
        v.visitor_surname,
        f.festival_year,
        COUNT(DISTINCT t.event_id) AS events_attended
    FROM ticket t
    JOIN visitor v ON t.visitor_id = v.visitor_id
    JOIN event e ON t.event_id = e.event_id
    JOIN festival f ON e.festival_year = f.festival_year
    WHERE t.validated = TRUE
    GROUP BY v.visitor_id, v.visitor_name, v.visitor_surname, f.festival_year
    HAVING COUNT(DISTINCT t.event_id) > 3
),
grouped_attendance AS (
    SELECT 
        festival_year,
        events_attended,
        COUNT(*) 
    FROM attendance_counts
    GROUP BY festival_year, events_attended
    HAVING COUNT(*) > 1
)
SELECT 
    ac.visitor_id,
    ac.visitor_name,
    ac.visitor_surname,
    ac.festival_year,
    ac.events_attended
FROM attendance_counts ac
JOIN grouped_attendance ga
  ON ac.festival_year = ga.festival_year
 AND ac.events_attended = ga.events_attended
ORDER BY ac.events_attended, ac.festival_year, ac.visitor_surname, ac.visitor_name;


