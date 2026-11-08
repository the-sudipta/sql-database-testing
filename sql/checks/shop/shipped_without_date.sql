-- Rule: shipped and delivered orders have a shipped date; pending, paid and cancelled orders do not.
-- Returns: order_id, status, shipped_date.
SELECT order_id, status, shipped_date
FROM orders
WHERE (status IN ('shipped', 'delivered') AND shipped_date IS NULL)
   OR (status IN ('pending', 'paid', 'cancelled') AND shipped_date IS NOT NULL)
ORDER BY order_id;
