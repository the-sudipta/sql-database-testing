-- 17. Correlated subquery: invoices larger than the average invoice of the same customer.
-- Tester use: compare each row with its own group.
SELECT i.InvoiceId, i.CustomerId, i.Total
FROM Invoice i
WHERE i.Total > (SELECT AVG(i2.Total) FROM Invoice i2 WHERE i2.CustomerId = i.CustomerId)
ORDER BY i.CustomerId, i.InvoiceId;
