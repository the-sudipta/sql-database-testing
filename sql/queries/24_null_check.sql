-- 24. NULL checks: how many tracks have no composer, per genre.
-- Tester use: measure missing data (= NULL never matches; always use IS NULL).
SELECT g.Name AS Genre, COUNT(*) AS TracksWithoutComposer
FROM Track t
JOIN Genre g ON g.GenreId = t.GenreId
WHERE t.Composer IS NULL
GROUP BY g.Name
ORDER BY TracksWithoutComposer DESC;
