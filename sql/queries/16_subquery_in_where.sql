-- 16. Subquery with IN: customers who bought at least one Rock track.
-- Tester use: select test data that meets a condition defined in another table.
SELECT CustomerId, FirstName, LastName
FROM Customer
WHERE CustomerId IN (
    SELECT i.CustomerId
    FROM Invoice i
    JOIN InvoiceLine l ON l.InvoiceId = i.InvoiceId
    JOIN Track t ON t.TrackId = l.TrackId
    JOIN Genre g ON g.GenreId = t.GenreId
    WHERE g.Name = 'Rock'
)
ORDER BY CustomerId;
