-- Rule: every order belongs to an existing customer.
-- Returns: order_id, customer_id.
SELECT o.order_id, o.customer_id
FROM orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL
ORDER BY o.order_id;
