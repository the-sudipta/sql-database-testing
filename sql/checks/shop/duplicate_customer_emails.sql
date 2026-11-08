-- Rule: one account per e-mail address; addresses are compared case-insensitively and without spaces.
-- Returns: customer_id and e-mail of every account that shares its address with another account.
SELECT c.customer_id, c.email
FROM customers c
WHERE LOWER(TRIM(c.email)) IN (
    SELECT LOWER(TRIM(email)) FROM customers
    WHERE email IS NOT NULL
    GROUP BY LOWER(TRIM(email))
    HAVING COUNT(*) > 1
)
ORDER BY c.customer_id;
