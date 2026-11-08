-- Rule: Invoice.Total equals the sum of UnitPrice x Quantity of its invoice lines (rounded to cents).
-- Returns: InvoiceId, stored total, calculated total.
SELECT i.InvoiceId, i.Total, ROUND(SUM(l.UnitPrice * l.Quantity), 2) AS CalculatedTotal
FROM Invoice i
JOIN InvoiceLine l ON l.InvoiceId = i.InvoiceId
GROUP BY i.InvoiceId, i.Total
HAVING ROUND(i.Total, 2) <> ROUND(SUM(l.UnitPrice * l.Quantity), 2)
ORDER BY i.InvoiceId;
