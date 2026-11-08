-- 07. CASE: group tracks into length buckets.
-- Tester use: derive categories the same way the application does and compare counts.
SELECT CASE
           WHEN Milliseconds < 180000 THEN 'short (< 3 min)'
           WHEN Milliseconds < 300000 THEN 'medium (3-5 min)'
           ELSE 'long (>= 5 min)'
       END AS LengthBucket,
       COUNT(*) AS Tracks
FROM Track
GROUP BY LengthBucket
ORDER BY Tracks DESC;
