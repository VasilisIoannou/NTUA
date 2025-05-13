SELECT
    f.festival_year,
    pm.payment_method_name,
    SUM(t.ticket_price) AS total_earnings
FROM
    festival f
JOIN event e ON e.festival_year = f.festival_year
JOIN ticket t ON t.event_id = e.event_id
JOIN payment_method pm ON pm.payment_method_id = t.payment_method_id
GROUP BY
    f.festival_year,
    pm.payment_method_name
ORDER BY
    f.festival_year,
    pm.payment_method_name;


