-- Rule: quantity is at least 1 and the unit price is not negative.
-- Returns: order_item_id, quantity, unit_price.
SELECT order_item_id, quantity, unit_price
FROM order_items
WHERE quantity < 1 OR unit_price < 0
ORDER BY order_item_id;
