-- 23. LAG: month-over-month change in revenue.
-- Tester use: verify growth figures on reports.
WITH monthly AS (
    SELECT STRFTIME('%Y-%m', InvoiceDate) AS Month, ROUND(SUM(Total), 2) AS Revenue
    FROM Invoice
    GROUP BY Month
)
SELECT Month, Revenue,
       LAG(Revenue) OVER (ORDER BY Month) AS PreviousMonth,
       ROUND(Revenue - LAG(Revenue) OVER (ORDER BY Month), 2) AS Change
FROM monthly
ORDER BY Month;
