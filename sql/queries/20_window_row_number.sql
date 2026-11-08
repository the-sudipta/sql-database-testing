-- 20. Window function ROW_NUMBER: the best-selling track of every genre.
-- Tester use: "top 1 per group" checks without fragile sub-queries.
WITH sales AS (
    SELECT g.Name AS Genre, t.Name AS Track, SUM(l.Quantity) AS Units,
           ROW_NUMBER() OVER (PARTITION BY g.GenreId ORDER BY SUM(l.Quantity) DESC, t.TrackId) AS Position
    FROM InvoiceLine l
    JOIN Track t ON t.TrackId = l.TrackId
    JOIN Genre g ON g.GenreId = t.GenreId
    GROUP BY g.GenreId, t.TrackId
)
SELECT Genre, Track, Units
FROM sales
WHERE Position = 1
ORDER BY Genre;
