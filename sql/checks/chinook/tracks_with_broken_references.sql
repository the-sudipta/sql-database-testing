-- Rule: every track has an existing album, media type and (when set) genre.
-- Returns: TrackId and the three foreign keys.
SELECT t.TrackId, t.AlbumId, t.MediaTypeId, t.GenreId
FROM Track t
LEFT JOIN Album a ON a.AlbumId = t.AlbumId
LEFT JOIN MediaType m ON m.MediaTypeId = t.MediaTypeId
LEFT JOIN Genre g ON g.GenreId = t.GenreId
WHERE (t.AlbumId IS NOT NULL AND a.AlbumId IS NULL)
   OR m.MediaTypeId IS NULL
   OR (t.GenreId IS NOT NULL AND g.GenreId IS NULL)
ORDER BY t.TrackId;
