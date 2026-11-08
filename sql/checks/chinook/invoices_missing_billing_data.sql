-- Rule: every invoice has a date in the expected range, a billing country and a non-negative total.
-- Returns: InvoiceId, InvoiceDate, BillingCountry, Total.
SELECT InvoiceId, InvoiceDate, BillingCountry, Total
FROM Invoice
WHERE InvoiceDate IS NULL
   OR DATE(InvoiceDate) > DATE('now')
   OR BillingCountry IS NULL OR TRIM(BillingCountry) = ''
   OR Total < 0
ORDER BY InvoiceId;
