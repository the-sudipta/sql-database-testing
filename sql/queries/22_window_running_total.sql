-- 22. Running total with SUM() OVER: cumulative revenue of 2013 by day.
-- Tester use: check cumulative charts and balances.
SELECT DATE(InvoiceDate) AS Day, ROUND(SUM(Total), 2) AS DayRevenue,
       ROUND(SUM(SUM(Total)) OVER (ORDER BY DATE(InvoiceDate)), 2) AS RunningRevenue
FROM Invoice
WHERE STRFTIME('%Y', InvoiceDate) = '2013'
GROUP BY Day
ORDER BY Day;
