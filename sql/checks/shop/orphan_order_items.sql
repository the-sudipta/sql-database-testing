-- Rule: every order line belongs to an existing order and an existing product (referential integrity).
-- Returns: order_item_id, order_id, product_id.
SELECT i.order_item_id, i.order_id, i.product_id
FROM order_items i
LEFT JOIN orders o ON o.order_id = i.order_id
LEFT JOIN products p ON p.product_id = i.product_id
WHERE o.order_id IS NULL OR p.product_id IS NULL
ORDER BY i.order_item_id;
