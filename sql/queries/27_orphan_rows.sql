-- 27. Orphan rows: playlist entries that point to a missing playlist or track.
-- Tester use: referential integrity when foreign keys are not enforced.
SELECT pt.PlaylistId, pt.TrackId
FROM PlaylistTrack pt
LEFT JOIN Playlist p ON p.PlaylistId = pt.PlaylistId
LEFT JOIN Track t ON t.TrackId = pt.TrackId
WHERE p.PlaylistId IS NULL OR t.TrackId IS NULL;
