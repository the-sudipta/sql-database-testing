-- 02. AND / OR / IN: customers from several countries that have a company name.
-- Tester use: combine conditions the way a search screen with several filters does.
SELECT CustomerId, FirstName, LastName, Country, Company
FROM Customer
WHERE Country IN ('USA', 'Canada', 'Brazil')
  AND (Company IS NOT NULL AND TRIM(Company) <> '')
ORDER BY Country, CustomerId;
