-- Intentional data defects, loaded ON TOP of shop_seed.sql into a separate database copy.
-- Each block is one defect (D-xx) and names the check in sql/checks/shop that must find it.
-- tests/test_shop_defects.py proves every defect is detected and that the clean database has none.

-- D-01  order total does not match its lines (2 x 450 + 1 x 550 = 1450, stored 1500)
--       -> order_total_mismatch.sql
INSERT INTO orders VALUES (101, 6, '2026-04-12', 'pending', NULL, 1500);
INSERT INTO order_items VALUES (101, 101, 1, 2, 450), (102, 101, 10, 1, 550);

-- D-02  order line pointing to an order that does not exist -> orphan_order_items.sql
INSERT INTO order_items VALUES (103, 9999, 2, 1, 1800);

-- D-03  order of a customer that does not exist -> orders_without_customer.sql
INSERT INTO orders VALUES (102, 999, '2026-04-13', 'pending', NULL, 450);
INSERT INTO order_items VALUES (104, 102, 1, 1, 450);

-- D-04  same e-mail registered twice with different letter case -> duplicate_customer_emails.sql
INSERT INTO customers VALUES (101, 'Rahim Uddin', 'Rahim.Uddin@Example.com', '01711000101', 'Dhaka', '2026-04-01');

-- D-05  customer without e-mail -> missing_customer_email.sql
INSERT INTO customers VALUES (102, 'Jamal Mia', NULL, '01711000102', 'Cumilla', '2026-04-02');

-- D-06  order lines with quantity 0 and a negative price (order total still matches) -> invalid_order_lines.sql
INSERT INTO orders VALUES (103, 7, '2026-04-14', 'pending', NULL, -100);
INSERT INTO order_items VALUES (105, 103, 8, 0, 350), (106, 103, 10, 1, -100);

-- D-07  delivered order paid only partly (900 of 1000) -> payment_mismatch.sql
INSERT INTO orders VALUES (104, 8, '2026-04-15', 'delivered', '2026-04-17', 1000);
INSERT INTO order_items VALUES (107, 104, 10, 1, 600), (108, 104, 9, 1, 400);
INSERT INTO payments VALUES (101, 104, 900, '2026-04-15', 'card');

-- D-08  shipped before it was ordered -> shipped_before_ordered.sql
INSERT INTO orders VALUES (105, 2, '2026-04-10', 'shipped', '2026-04-05', 350);
INSERT INTO order_items VALUES (109, 105, 8, 1, 350);
INSERT INTO payments VALUES (102, 105, 350, '2026-04-10', 'bkash');

-- D-09  status with a typo -> invalid_order_status.sql
INSERT INTO orders VALUES (106, 3, '2026-04-16', 'shiped', NULL, 900);
INSERT INTO order_items VALUES (110, 106, 9, 1, 900);

-- D-10  order dated far in the future -> future_order_date.sql
INSERT INTO orders VALUES (107, 4, '2099-01-01', 'pending', NULL, 450);
INSERT INTO order_items VALUES (111, 107, 1, 1, 450);

-- D-11  negative stock -> negative_stock.sql
INSERT INTO products VALUES (101, 'MUG-101', 'Ceramic Mug', 300, -5);

-- D-12  shipped order without a shipped date -> shipped_without_date.sql
INSERT INTO orders VALUES (108, 1, '2026-04-18', 'shipped', NULL, 600);
INSERT INTO order_items VALUES (112, 108, 10, 1, 600);
INSERT INTO payments VALUES (103, 108, 600, '2026-04-18', 'cash');
