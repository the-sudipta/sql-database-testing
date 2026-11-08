-- 40. [shop] Order status distribution with percentages.
-- Tester use: sanity-check a status dashboard; unexpected statuses show up here immediately.
SELECT status, COUNT(*) AS orders,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 1) AS percent
FROM orders
GROUP BY status
ORDER BY orders DESC;
