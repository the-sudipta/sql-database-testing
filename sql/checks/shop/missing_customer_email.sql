-- Rule: every customer has an e-mail address that contains "@".
-- Returns: customer_id, email.
SELECT customer_id, email
FROM customers
WHERE email IS NULL OR TRIM(email) = '' OR INSTR(email, '@') = 0
ORDER BY customer_id;
