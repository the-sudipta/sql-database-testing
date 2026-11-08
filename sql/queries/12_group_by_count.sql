-- 12. GROUP BY + COUNT: number of invoices per billing country.
-- Tester use: compare counts on a dashboard or report with the database.
SELECT BillingCountry, COUNT(*) AS Invoices
FROM Invoice
GROUP BY BillingCountry
ORDER BY Invoices DESC, BillingCountry;
