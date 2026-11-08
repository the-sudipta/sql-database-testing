-- Small e-commerce schema used for data-quality testing.
-- It is modelled on a "legacy" database: some business rules (positive quantity, valid status,
-- payment = order total ...) are NOT enforced by constraints, so the tests must catch them.
-- Money is stored in whole taka (INTEGER) to avoid floating-point rounding.

PRAGMA foreign_keys = OFF;  -- legacy behaviour: SQLite does not enforce FKs unless asked

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    full_name   TEXT    NOT NULL,
    email       TEXT,               -- should be unique and present, but not enforced
    phone       TEXT,
    city        TEXT,
    created_at  TEXT    NOT NULL    -- ISO date YYYY-MM-DD
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    sku        TEXT    NOT NULL UNIQUE,
    name       TEXT    NOT NULL,
    unit_price INTEGER NOT NULL,
    stock      INTEGER NOT NULL
);

CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY,
    customer_id  INTEGER REFERENCES customers (customer_id),
    order_date   TEXT    NOT NULL,
    status       TEXT    NOT NULL,  -- pending | paid | shipped | delivered | cancelled
    shipped_date TEXT,
    total_amount INTEGER NOT NULL   -- must equal the sum of its order lines
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER REFERENCES orders (order_id),
    product_id    INTEGER REFERENCES products (product_id),
    quantity      INTEGER NOT NULL,
    unit_price    INTEGER NOT NULL
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    order_id   INTEGER REFERENCES orders (order_id),
    amount     INTEGER NOT NULL,
    paid_at    TEXT    NOT NULL,
    method     TEXT    NOT NULL     -- card | bkash | cash
);

CREATE INDEX idx_orders_customer ON orders (customer_id);
CREATE INDEX idx_items_order ON order_items (order_id);
CREATE INDEX idx_payments_order ON payments (order_id);
