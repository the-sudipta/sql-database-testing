-- 21. Window function RANK: customers ranked by total spend (ties share a rank).
-- Tester use: verify leaderboards and "top customer" widgets.
SELECT c.CustomerId, c.FirstName || ' ' || c.LastName AS Customer, ROUND(SUM(i.Total), 2) AS Spent,
       RANK() OVER (ORDER BY SUM(i.Total) DESC) AS SpendRank
FROM Customer c
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId
ORDER BY SpendRank, c.CustomerId;
