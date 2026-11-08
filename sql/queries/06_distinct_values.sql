-- 06. DISTINCT: every billing country that appears on an invoice.
-- Tester use: list the values a dropdown should offer.
SELECT DISTINCT BillingCountry
FROM Invoice
ORDER BY BillingCountry;
