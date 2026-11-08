-- 08. INNER JOIN: track with its album and artist.
-- Tester use: verify that the data shown on a detail page comes from the right related rows.
SELECT t.TrackId, t.Name AS Track, al.Title AS Album, ar.Name AS Artist
FROM Track t
JOIN Album al ON al.AlbumId = t.AlbumId
JOIN Artist ar ON ar.ArtistId = al.ArtistId
WHERE ar.Name = 'AC/DC'
ORDER BY al.Title, t.TrackId;
