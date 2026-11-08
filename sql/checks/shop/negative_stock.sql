-- Rule: stock can be zero but never negative.
-- Returns: product_id, sku, stock.
SELECT product_id, sku, stock
FROM products
WHERE stock < 0
ORDER BY product_id;
