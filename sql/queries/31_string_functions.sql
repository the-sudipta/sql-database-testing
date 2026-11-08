-- 31. String functions: display names and e-mail domains.
-- Tester use: check formatting rules (upper case, length limits, domains).
SELECT CustomerId,
       UPPER(LastName) || ', ' || FirstName AS DisplayName,
       LENGTH(FirstName || ' ' || LastName) AS NameLength,
       SUBSTR(Email, INSTR(Email, '@') + 1) AS EmailDomain
FROM Customer
ORDER BY NameLength DESC, CustomerId
LIMIT 10;
