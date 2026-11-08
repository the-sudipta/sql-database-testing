-- 18. NOT EXISTS: tracks that were never sold.
-- Tester use: find records that no transaction refers to.
SELECT t.TrackId, t.Name
FROM Track t
WHERE NOT EXISTS (SELECT 1 FROM InvoiceLine l WHERE l.TrackId = t.TrackId)
ORDER BY t.TrackId;
