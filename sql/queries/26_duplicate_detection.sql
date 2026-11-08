-- 26. Duplicate detection: customers that share first and last name (possible duplicate accounts).
-- Tester use: GROUP BY the natural key and keep groups with more than one row.
SELECT FirstName, LastName, COUNT(*) AS Accounts, GROUP_CONCAT(CustomerId) AS CustomerIds
FROM Customer
GROUP BY LOWER(FirstName), LOWER(LastName)
HAVING COUNT(*) > 1;
