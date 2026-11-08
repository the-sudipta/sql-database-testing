-- 35. [shop] Order reconciliation: stored total, sum of lines and sum of payments side by side.
-- Tester use: the core check of any order system; all three numbers agree for paid orders.
SELECT o.order_id, o.status, o.total_amount,
       (SELECT COALESCE(SUM(quantity * unit_price), 0) FROM order_items i WHERE i.order_id = o.order_id)
           AS lines_total,
       (SELECT COALESCE(SUM(amount), 0) FROM payments p WHERE p.order_id = o.order_id) AS paid
FROM orders o
ORDER BY o.order_id;
