-- Rule: the price charged on an invoice line equals the catalogue price of the track.
-- Returns: InvoiceLineId, TrackId, charged price, catalogue price.
SELECT l.InvoiceLineId, l.TrackId, l.UnitPrice, t.UnitPrice AS CataloguePrice
FROM InvoiceLine l
JOIN Track t ON t.TrackId = l.TrackId
WHERE l.UnitPrice <> t.UnitPrice
ORDER BY l.InvoiceLineId;
