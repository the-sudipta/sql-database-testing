-- 19. CTE (WITH): revenue per month.
-- Tester use: break a complex check into readable steps.
WITH monthly AS (
    SELECT STRFTIME('%Y-%m', InvoiceDate) AS Month, SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY Month
)
SELECT Month, ROUND(Revenue, 2) AS Revenue
FROM monthly
ORDER BY Month;
