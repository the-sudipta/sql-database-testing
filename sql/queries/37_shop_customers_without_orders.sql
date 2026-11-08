-- 37. [shop] Customers who never ordered (LEFT JOIN ... IS NULL).
-- Tester use: test data for "first order" journeys.
SELECT c.customer_id, c.full_name, c.email
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;
