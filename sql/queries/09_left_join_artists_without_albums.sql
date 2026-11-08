-- 09. LEFT JOIN ... IS NULL: artists that have no album.
-- Tester use: find "parent without children" records (often a data or UI edge case).
SELECT ar.ArtistId, ar.Name
FROM Artist ar
LEFT JOIN Album al ON al.ArtistId = ar.ArtistId
WHERE al.AlbumId IS NULL
ORDER BY ar.ArtistId;
