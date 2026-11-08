-- 30. Relative date range: invoices in the last 30 days of the data set.
-- Tester use: "last N days" filters; anchored on the newest date so the result never drifts.
SELECT InvoiceId, CustomerId, DATE(InvoiceDate) AS Day, Total
FROM Invoice
WHERE DATE(InvoiceDate) > DATE((SELECT MAX(InvoiceDate) FROM Invoice), '-30 days')
ORDER BY InvoiceDate;
