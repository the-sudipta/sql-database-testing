-- 10. Multi-table JOIN: what was sold on one invoice, with genre and media type.
-- Tester use: rebuild an invoice from raw tables and compare it with the invoice screen or PDF.
SELECT l.InvoiceLineId, t.Name AS Track, g.Name AS Genre, m.Name AS MediaType, l.UnitPrice, l.Quantity
FROM InvoiceLine l
JOIN Track t ON t.TrackId = l.TrackId
JOIN Genre g ON g.GenreId = t.GenreId
JOIN MediaType m ON m.MediaTypeId = t.MediaTypeId
WHERE l.InvoiceId = 1
ORDER BY l.InvoiceLineId;
