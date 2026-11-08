-- 01. SELECT + WHERE: customers from one country.
-- Tester use: check that a filter returns exactly the expected records.
SELECT CustomerId, FirstName, LastName, City, Email
FROM Customer
WHERE Country = 'Brazil'
ORDER BY CustomerId;
