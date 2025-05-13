SELECT DISTINCT
    f.festival_year,
    b.band_name,
    g.genre_name
FROM
    band b
JOIN band_subgenre bs ON b.band_id = bs.band_id
JOIN subgenre sg ON sg.subgenre_id = bs.subgenre_id
JOIN genre g ON g.genre_id = sg.genre_id
JOIN performance p ON p.band_id = b.band_id
JOIN event e ON e.event_id = p.event_id
JOIN festival f ON f.festival_year = e.festival_year
ORDER BY
    f.festival_year,
    b.band_name;


