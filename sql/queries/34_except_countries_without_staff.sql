-- 34. EXCEPT: customer countries where the company has no employee.
-- Tester use: set difference between two lists (in A but not in B).
SELECT Country FROM Customer
EXCEPT
SELECT Country FROM Employee
ORDER BY Country;
