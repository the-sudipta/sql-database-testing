-- Rule: a customer support rep is an existing employee with a "Sales" job title.
-- Returns: CustomerId, SupportRepId.
SELECT c.CustomerId, c.SupportRepId
FROM Customer c
LEFT JOIN Employee e ON e.EmployeeId = c.SupportRepId
WHERE e.EmployeeId IS NULL OR e.Title NOT LIKE '%Sales%'
ORDER BY c.CustomerId;
