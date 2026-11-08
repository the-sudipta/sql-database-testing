-- Clean, consistent seed data (fake people, fake contact details).
-- Every business rule checked in sql/checks/shop holds for this data.

INSERT INTO customers (customer_id, full_name, email, phone, city, created_at) VALUES
    (1, 'Rahim Uddin',    'rahim.uddin@example.com',    '01711000001', 'Dhaka',      '2026-01-03'),
    (2, 'Nusrat Jahan',   'nusrat.jahan@example.com',   '01711000002', 'Chattogram', '2026-01-05'),
    (3, 'Karim Hasan',    'karim.hasan@example.com',    '01711000003', 'Sylhet',     '2026-01-09'),
    (4, 'Ayesha Rahman',  'ayesha.rahman@example.com',  '01711000004', 'Dhaka',      '2026-02-01'),
    (5, 'Tanvir Ahmed',   'tanvir.ahmed@example.com',   '01711000005', 'Khulna',     '2026-02-11'),
    (6, 'Mim Akter',      'mim.akter@example.com',      '01711000006', 'Rajshahi',   '2026-02-20'),
    (7, 'Farhana Islam',  'farhana.islam@example.com',  '01711000007', 'Dhaka',      '2026-03-02'),
    (8, 'Sabbir Hossain', 'sabbir.hossain@example.com', '01711000008', 'Barishal',   '2026-03-15');

INSERT INTO products (product_id, sku, name, unit_price, stock) VALUES
    (1,  'TSH-001', 'Cotton T-Shirt',      450,  120),
    (2,  'JNS-002', 'Denim Jeans',         1800, 40),
    (3,  'PNJ-003', 'Panjabi',             2200, 25),
    (4,  'SAR-004', 'Cotton Saree',        3500, 15),
    (5,  'SHO-005', 'Running Shoes',       4200, 30),
    (6,  'BAG-006', 'Leather Bag',         2600, 12),
    (7,  'WAT-007', 'Analog Watch',        3100, 18),
    (8,  'CAP-008', 'Baseball Cap',        350,  80),
    (9,  'SCF-009', 'Silk Scarf',          900,  35),
    (10, 'BTL-010', 'Steel Water Bottle',  600,  60);

INSERT INTO orders (order_id, customer_id, order_date, status, shipped_date, total_amount) VALUES
    (1,  1, '2026-03-01', 'delivered', '2026-03-03', 2700),
    (2,  2, '2026-03-04', 'delivered', '2026-03-06', 3500),
    (3,  3, '2026-03-08', 'shipped',   '2026-03-10', 5200),
    (4,  1, '2026-03-12', 'paid',      NULL,          1800),
    (5,  4, '2026-03-15', 'cancelled', NULL,          2200),
    (6,  5, '2026-03-18', 'pending',   NULL,          4200),
    (7,  6, '2026-03-20', 'delivered', '2026-03-23', 1150),
    (8,  7, '2026-03-25', 'shipped',   '2026-03-27', 6200),
    (9,  2, '2026-04-01', 'paid',      NULL,          900),
    (10, 4, '2026-04-03', 'delivered', '2026-04-06', 3300),
    (11, 3, '2026-04-07', 'pending',   NULL,          350),
    (12, 5, '2026-04-10', 'delivered', '2026-04-12', 7300);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
    (1,  1,  1, 2, 450),  (2,  1,  2, 1, 1800),
    (3,  2,  4, 1, 3500),
    (4,  3,  3, 1, 2200), (5,  3,  9, 1, 900),  (6,  3,  1, 2, 450), (7, 3, 10, 2, 600),
    (8,  4,  2, 1, 1800),
    (9,  5,  3, 1, 2200),
    (10, 6,  5, 1, 4200),
    (11, 7,  1, 1, 450),  (12, 7,  8, 1, 350),  (13, 7,  8, 1, 350),
    (15, 8,  7, 2, 3100),
    (16, 9,  9, 1, 900),
    (17, 10, 6, 1, 2600), (18, 10, 8, 2, 350),
    (19, 11, 8, 1, 350),
    (20, 12, 5, 1, 4200), (21, 12, 7, 1, 3100);

INSERT INTO payments (payment_id, order_id, amount, paid_at, method) VALUES
    (1,  1,  2700, '2026-03-01', 'card'),
    (2,  2,  3500, '2026-03-04', 'bkash'),
    (3,  3,  5200, '2026-03-08', 'card'),
    (4,  4,  1800, '2026-03-12', 'bkash'),
    (5,  7,  1150, '2026-03-20', 'cash'),
    (6,  8,  3100, '2026-03-25', 'card'),
    (7,  8,  3100, '2026-03-26', 'card'),   -- paid in two instalments
    (8,  9,  900,  '2026-04-01', 'bkash'),
    (9,  10, 3300, '2026-04-03', 'card'),
    (10, 12, 7300, '2026-04-10', 'bkash');
