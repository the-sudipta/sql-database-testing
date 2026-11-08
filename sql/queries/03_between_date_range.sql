-- 03. BETWEEN on dates: invoices of the first quarter of 2010.
-- Tester use: boundary checks on date filters (first and last day included).
SELECT InvoiceId, CustomerId, DATE(InvoiceDate) AS InvoiceDay, Total
FROM Invoice
WHERE DATE(InvoiceDate) BETWEEN '2010-01-01' AND '2010-03-31'
ORDER BY InvoiceDate, InvoiceId;
