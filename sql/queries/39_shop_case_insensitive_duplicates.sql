-- 39. [shop] Case-insensitive duplicate e-mails.
-- Tester use: Rahim@Example.com and rahim@example.com are the same person for login and marketing.
SELECT LOWER(TRIM(email)) AS normalised_email, COUNT(*) AS accounts, GROUP_CONCAT(customer_id) AS customer_ids
FROM customers
WHERE email IS NOT NULL
GROUP BY normalised_email
HAVING COUNT(*) > 1;
