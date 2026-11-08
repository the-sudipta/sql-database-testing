-- Rule: status is one of the allowed values (domain check).
-- Returns: order_id, status.
SELECT order_id, status
FROM orders
WHERE status NOT IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')
ORDER BY order_id;
