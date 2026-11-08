-- 11. SELF JOIN: every employee with the name of their manager.
-- Tester use: check hierarchies (org charts, category trees).
SELECT e.EmployeeId, e.FirstName || ' ' || e.LastName AS Employee, e.Title,
       COALESCE(m.FirstName || ' ' || m.LastName, '(top manager)') AS Manager
FROM Employee e
LEFT JOIN Employee m ON m.EmployeeId = e.ReportsTo
ORDER BY e.EmployeeId;
