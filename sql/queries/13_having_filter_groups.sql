-- 13. HAVING: countries with more than 4 customers.
-- Tester use: filter on an aggregate (WHERE cannot do this).
SELECT Country, COUNT(*) AS Customers
FROM Customer
GROUP BY Country
HAVING COUNT(*) > 4
ORDER BY Customers DESC;
