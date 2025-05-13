SELECT
    s.staff_id,
    s.staff_name,
    s.staff_email,
    s.staff_phone
FROM
    staff s
WHERE
    s.staff_role_id = 3
    AND s.staff_id NOT IN (
        SELECT ss.staff_id
        FROM stage_staff ss
    );


