# SQL Cheat Sheet for Testers

Short patterns I use to check data behind an application. Examples use the Chinook tables and the shop
schema in this repository (SQLite syntax; differences for MySQL/PostgreSQL are noted).

## 1. Look at data

```sql
SELECT * FROM Customer LIMIT 5;                         -- first look at a table
SELECT COUNT(*) FROM Invoice;                           -- how many rows?
SELECT DISTINCT BillingCountry FROM Invoice;            -- which values exist?
PRAGMA table_info(Customer);                            -- columns (MySQL: DESCRIBE, PostgreSQL: \d)
```

## 2. Filter

| Need | Pattern |
|---|---|
| exact value | `WHERE Country = 'Brazil'` |
| list of values | `WHERE Country IN ('USA', 'Canada')` |
| range, both ends included | `WHERE DATE(InvoiceDate) BETWEEN '2010-01-01' AND '2010-03-31'` |
| contains text | `WHERE Name LIKE '%love%'` (`_` = one character) |
| missing value | `WHERE Composer IS NULL` — never `= NULL` |
| empty or missing text | `WHERE TRIM(COALESCE(Company, '')) = ''` |

## 3. Join

```sql
-- INNER JOIN: only rows that match on both sides
SELECT t.Name, al.Title FROM Track t JOIN Album al ON al.AlbumId = t.AlbumId;

-- LEFT JOIN ... IS NULL: rows on the left WITHOUT a match (orphans, "never ordered")
SELECT c.customer_id FROM customers c LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- SELF JOIN: hierarchy in one table
SELECT e.LastName, m.LastName AS Manager FROM Employee e LEFT JOIN Employee m ON m.EmployeeId = e.ReportsTo;
```

## 4. Aggregate

```sql
SELECT BillingCountry, COUNT(*), SUM(Total), AVG(Total), MIN(Total), MAX(Total)
FROM Invoice
GROUP BY BillingCountry
HAVING COUNT(*) > 10          -- HAVING filters groups, WHERE filters rows
ORDER BY SUM(Total) DESC;
```

## 5. Data-quality checks (each returns the BAD rows; empty result = rule holds)

| Check | Query shape |
|---|---|
| Duplicates | `SELECT key, COUNT(*) FROM t GROUP BY key HAVING COUNT(*) > 1` |
| Case-insensitive duplicates | `GROUP BY LOWER(TRIM(email)) HAVING COUNT(*) > 1` |
| Orphans (FK) | `child LEFT JOIN parent ... WHERE parent.id IS NULL` |
| Engine FK check (SQLite) | `PRAGMA foreign_key_check;` |
| Required field | `WHERE col IS NULL OR TRIM(col) = ''` |
| Domain / allowed values | `WHERE status NOT IN ('pending', 'paid', ...)` |
| Range | `WHERE quantity < 1 OR unit_price < 0` |
| Date logic | `WHERE shipped_date < order_date` or `WHERE order_date > DATE('now')` |
| Header = sum of lines | `GROUP BY o.id HAVING o.total <> SUM(i.qty * i.price)` |
| Payments = total | `GROUP BY o.id HAVING SUM(p.amount) <> o.total` |
| Row count after load | `SELECT COUNT(*)` in source and target; source = loaded + rejected |
| Checksum after load | compare `SUM(amount)` (or a hash of key columns) in source and target |

## 6. Subqueries, CTEs and windows

```sql
-- IN / NOT EXISTS
SELECT * FROM Track t WHERE NOT EXISTS (SELECT 1 FROM InvoiceLine l WHERE l.TrackId = t.TrackId);

-- CTE: name a step, then use it
WITH monthly AS (SELECT STRFTIME('%Y-%m', InvoiceDate) AS m, SUM(Total) AS revenue FROM Invoice GROUP BY m)
SELECT * FROM monthly WHERE revenue > 40;

-- Top 1 per group
ROW_NUMBER() OVER (PARTITION BY GenreId ORDER BY units DESC)
-- Ranking with ties
RANK() OVER (ORDER BY spent DESC)
-- Running total
SUM(SUM(Total)) OVER (ORDER BY day)
-- Previous row
LAG(revenue) OVER (ORDER BY month)
```

## 7. Useful functions

| SQLite | MySQL | PostgreSQL | Use |
|---|---|---|---|
| `STRFTIME('%Y-%m', d)` | `DATE_FORMAT(d, '%Y-%m')` | `TO_CHAR(d, 'YYYY-MM')` | month of a date |
| `DATE('now')` | `CURDATE()` | `CURRENT_DATE` | today |
| `DATE(d, '-30 days')` | `DATE_SUB(d, INTERVAL 30 DAY)` | `d - INTERVAL '30 days'` | date arithmetic |
| `a \|\| b` | `CONCAT(a, b)` | `a \|\| b` | join text |
| `INSTR(s, '@')` | `INSTR(s, '@')` | `POSITION('@' IN s)` | find text |
| `GROUP_CONCAT(x)` | `GROUP_CONCAT(x)` | `STRING_AGG(x, ',')` | list values of a group |

## 8. Habits that prevent mistakes

- Run a `SELECT COUNT(*)` with the same `WHERE` before any `UPDATE` or `DELETE`, and use a transaction.
- Compare money in integer cents or with `ROUND(x, 2)` — floating-point sums are not exact.
- Anchor "last N days" on a fixed date in tests so the expected result does not change tomorrow.
- `COUNT(col)` skips NULLs, `COUNT(*)` does not.
- `NOT IN (subquery)` returns nothing if the subquery contains a NULL — prefer `NOT EXISTS`.
