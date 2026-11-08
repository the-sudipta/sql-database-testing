-- 38. [shop] Best-selling products by quantity (cancelled orders excluded).
-- Tester use: verify "best sellers" lists.
SELECT p.sku, p.name, SUM(i.quantity) AS units, SUM(i.quantity * i.unit_price) AS revenue
FROM order_items i
JOIN orders o ON o.order_id = i.order_id
JOIN products p ON p.product_id = i.product_id
WHERE o.status <> 'cancelled'
GROUP BY p.product_id
ORDER BY units DESC, revenue DESC;
