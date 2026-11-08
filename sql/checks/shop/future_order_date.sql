-- Rule: an order date is not in the future (compared with today).
-- Returns: order_id, order_date.
SELECT order_id, order_date
FROM orders
WHERE DATE(order_date) > DATE('now')
ORDER BY order_id;
