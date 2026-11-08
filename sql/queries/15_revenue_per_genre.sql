-- 15. GROUP BY over a JOIN: revenue per genre.
-- Tester use: verify a "sales by category" report.
SELECT g.Name AS Genre, ROUND(SUM(l.UnitPrice * l.Quantity), 2) AS Revenue, SUM(l.Quantity) AS UnitsSold
FROM InvoiceLine l
JOIN Track t ON t.TrackId = l.TrackId
JOIN Genre g ON g.GenreId = t.GenreId
GROUP BY g.Name
ORDER BY Revenue DESC;
