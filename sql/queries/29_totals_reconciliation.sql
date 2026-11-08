-- 29. Totals reconciliation: invoice header totals vs. the sum of their lines, per year.
-- Tester use: the two numbers must match exactly; any difference is a defect.
WITH header AS (
    SELECT STRFTIME('%Y', InvoiceDate) AS Year, SUM(Total) AS HeaderTotal
    FROM Invoice GROUP BY Year
), lines AS (
    SELECT STRFTIME('%Y', i.InvoiceDate) AS Year, SUM(l.UnitPrice * l.Quantity) AS LineTotal
    FROM InvoiceLine l JOIN Invoice i ON i.InvoiceId = l.InvoiceId GROUP BY Year
)
SELECT h.Year, ROUND(h.HeaderTotal, 2) AS HeaderTotal, ROUND(l.LineTotal, 2) AS LineTotal,
       ROUND(h.HeaderTotal - l.LineTotal, 2) AS Difference
FROM header h JOIN lines l ON l.Year = h.Year
ORDER BY h.Year;
