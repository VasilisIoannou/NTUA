SELECT 
    f.festival_year,
    AVG(level_of_experience.level_of_experience_id) AS lvl_exp
FROM
    festival f
JOIN event e ON e.festival_year = f.festival_year
JOIN stage s ON e.stage_id = s.stage_id
JOIN stage_staff ss ON s.stage_id = ss.stage_id
JOIN staff st ON ss.staff_id = st.staff_id
JOIN staff_role sr ON st.staff_role_id = sr.staff_role_id
JOIN level_of_experience ON st.level_of_experience = level_of_experience.level_of_experience_id
WHERE
    sr.staff_role_id = 1
GROUP BY
    f.festival_year
ORDER BY
    lvl_exp ASC
LIMIT 1;


