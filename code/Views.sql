-- Active: 1746819443116@@127.0.0.1@3309@festivaldb

/* View to get the total earnings per festival year */
CREATE OR REPLACE VIEW total_festival_earnings_per_year AS
SELECT
    f.festival_year,
    SUM(t.ticket_price) AS total_earnings
FROM
    festival f
JOIN event e ON e.festival_year = f.festival_year
JOIN ticket t ON t.event_id = e.event_id
GROUP BY
    f.festival_year
ORDER BY
    f.festival_year;


/* View to get the total earnings per festival year and payment method */
CREATE OR REPLACE VIEW festival_earnings_per_payment_method AS
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

/* View to get the total earnings per festival year and ticket type */
CREATE OR REPLACE VIEW festival_earnings_per_ticket_type AS
SELECT
    f.festival_year,
    tt.ticket_type_name,
    SUM(t.ticket_price) AS total_earnings
FROM
    festival f
JOIN event e ON e.festival_year = f.festival_year
JOIN ticket t ON t.event_id = e.event_id
JOIN ticket_type tt ON tt.ticket_type_id = t.ticket_type_id
GROUP BY
    f.festival_year,
    tt.ticket_type_name
ORDER BY
    f.festival_year,
    tt.ticket_type_name;

