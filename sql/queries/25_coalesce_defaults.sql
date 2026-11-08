-- 25. COALESCE / NULLIF: show a default for missing company, state and fax.
-- Tester use: check how the UI should display empty values.
SELECT CustomerId, FirstName, LastName,
       COALESCE(NULLIF(TRIM(Company), ''), '(private customer)') AS Company,
       COALESCE(State, '-') AS State,
       COALESCE(Fax, 'no fax') AS Fax
FROM Customer
ORDER BY CustomerId;
