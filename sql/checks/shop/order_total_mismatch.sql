-- Rule: the stored total_amount of an order equals the sum of quantity x unit_price of its lines.
-- Returns: order_id, stored total, calculated total.
SELECT o.order_id, o.total_amount, COALESCE(SUM(i.quantity * i.unit_price), 0) AS calculated_total
FROM orders o
LEFT JOIN order_items i ON i.order_id = o.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> COALESCE(SUM(i.quantity * i.unit_price), 0)
ORDER BY o.order_id;
