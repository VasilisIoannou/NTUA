SELECT 
    f.festival_year,
    f.festival_month,
    d.festival_day,
    s.staff_id,
    s.staff_name,
    s.staff_email,
    s.staff_phone
FROM 
    staff s
CROSS JOIN (
    SELECT DISTINCT e.festival_year, e.festival_day
    FROM event e
) d
JOIN festival f ON f.festival_year = d.festival_year
WHERE 
    s.staff_role_id = 3
    AND NOT EXISTS (
        SELECT 1
        FROM stage_staff ss
        JOIN event e ON ss.stage_id = e.stage_id
        WHERE e.festival_year = d.festival_year
          AND e.festival_day = d.festival_day
          AND ss.staff_id = s.staff_id
)
ORDER BY 
    f.festival_year,
    f.festival_month,
    d.festival_day,
    s.staff_name;



