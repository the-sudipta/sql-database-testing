-- 05. ORDER BY + LIMIT: the ten longest tracks.
-- Tester use: check "top N" lists and sorting.
SELECT TrackId, Name, Milliseconds / 60000.0 AS Minutes
FROM Track
ORDER BY Milliseconds DESC
LIMIT 10;
