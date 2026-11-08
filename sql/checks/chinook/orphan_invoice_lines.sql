-- Rule: every invoice line points to an existing invoice and an existing track.
-- Returns: InvoiceLineId, InvoiceId, TrackId.
SELECT l.InvoiceLineId, l.InvoiceId, l.TrackId
FROM InvoiceLine l
LEFT JOIN Invoice i ON i.InvoiceId = l.InvoiceId
LEFT JOIN Track t ON t.TrackId = l.TrackId
WHERE i.InvoiceId IS NULL OR t.TrackId IS NULL
ORDER BY l.InvoiceLineId;
