-- Rule: a customer e-mail is used by one customer only (case-insensitive).
-- Returns: CustomerId, Email.
SELECT CustomerId, Email
FROM Customer
WHERE LOWER(Email) IN (SELECT LOWER(Email) FROM Customer GROUP BY LOWER(Email) HAVING COUNT(*) > 1)
ORDER BY CustomerId;
