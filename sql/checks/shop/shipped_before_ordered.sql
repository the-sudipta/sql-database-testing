-- Rule: an order cannot be shipped before it was placed.
-- Returns: order_id, order_date, shipped_date.
SELECT order_id, order_date, shipped_date
FROM orders
WHERE shipped_date IS NOT NULL AND DATE(shipped_date) < DATE(order_date)
ORDER BY order_id;
