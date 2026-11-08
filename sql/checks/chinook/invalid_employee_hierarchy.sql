-- Rule: ReportsTo points to an existing employee, nobody reports to themselves, exactly one top manager.
-- Returns: EmployeeId, ReportsTo, problem.
SELECT e.EmployeeId, e.ReportsTo, 'manager does not exist' AS Problem
FROM Employee e LEFT JOIN Employee m ON m.EmployeeId = e.ReportsTo
WHERE e.ReportsTo IS NOT NULL AND m.EmployeeId IS NULL
UNION ALL
SELECT EmployeeId, ReportsTo, 'reports to self' FROM Employee WHERE ReportsTo = EmployeeId
UNION ALL
SELECT NULL, NULL, 'not exactly one top manager'
WHERE (SELECT COUNT(*) FROM Employee WHERE ReportsTo IS NULL) <> 1;
