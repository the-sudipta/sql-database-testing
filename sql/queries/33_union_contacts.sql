-- 33. UNION: one contact list with customers and employees.
-- Tester use: combine two sources with the same columns (UNION removes duplicates, UNION ALL keeps them).
SELECT 'customer' AS Type, FirstName, LastName, Email, Country FROM Customer
UNION
SELECT 'employee', FirstName, LastName, Email, Country FROM Employee
ORDER BY Type, LastName;
