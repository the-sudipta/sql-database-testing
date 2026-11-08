-- 04. LIKE: tracks whose name contains "love" (case-insensitive in SQLite for ASCII).
-- Tester use: verify a text search returns every matching record.
SELECT TrackId, Name
FROM Track
WHERE Name LIKE '%love%'
ORDER BY Name;
