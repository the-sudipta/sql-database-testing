-- Rule: paid, shipped and delivered orders are fully paid (sum of payments = order total),
-- and pending or cancelled orders have no payments.
-- Returns: order_id, status, total_amount, paid amount.
SELECT o.order_id, o.status, o.total_amount, COALESCE(SUM(p.amount), 0) AS paid
FROM orders o
LEFT JOIN payments p ON p.order_id = o.order_id
GROUP BY o.order_id, o.status, o.total_amount
HAVING (o.status IN ('paid', 'shipped', 'delivered') AND COALESCE(SUM(p.amount), 0) <> o.total_amount)
    OR (o.status IN ('pending', 'cancelled') AND COALESCE(SUM(p.amount), 0) <> 0)
ORDER BY o.order_id;
