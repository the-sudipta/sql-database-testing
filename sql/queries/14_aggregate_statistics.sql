-- 14. SUM / AVG / MIN / MAX: overall invoice statistics.
-- Tester use: sanity-check totals shown in reports.
SELECT COUNT(*) AS Invoices, ROUND(SUM(Total), 2) AS Revenue, ROUND(AVG(Total), 2) AS AverageInvoice,
       MIN(Total) AS SmallestInvoice, MAX(Total) AS LargestInvoice
FROM Invoice;
