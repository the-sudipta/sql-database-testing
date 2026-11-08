-- 36. [shop] Revenue by payment method.
-- Tester use: compare with the finance report.
SELECT method, COUNT(*) AS payments, SUM(amount) AS amount
FROM payments
GROUP BY method
ORDER BY amount DESC;
