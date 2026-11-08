-- 32. Date functions: invoices per weekday (0 = Sunday).
-- Tester use: extract parts of dates to compare with time-based reports.
SELECT CAST(STRFTIME('%w', InvoiceDate) AS INTEGER) AS Weekday, COUNT(*) AS Invoices
FROM Invoice
GROUP BY Weekday
ORDER BY Weekday;
