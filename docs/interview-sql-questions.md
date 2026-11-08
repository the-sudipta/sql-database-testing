# 30 SQL Interview Questions for QA Engineers

Short answers with examples from this repository's schemas.

### Basics

1. **What is the difference between `WHERE` and `HAVING`?**
   `WHERE` filters rows before grouping; `HAVING` filters groups after `GROUP BY`
   (e.g. countries with more than 4 customers: `GROUP BY Country HAVING COUNT(*) > 4`).

2. **`DELETE` vs `TRUNCATE` vs `DROP`?**
   `DELETE` removes chosen rows (can use `WHERE`, can be rolled back); `TRUNCATE` removes all rows quickly
   (MySQL/PostgreSQL); `DROP` removes the whole table and its structure.

3. **Primary key vs unique key?**
   Both prevent duplicates. A table has one primary key and it cannot be NULL; it can have several unique keys,
   which usually allow NULL.

4. **What is a foreign key and how do you test it?**
   A column that must match a key in another table. Test with `LEFT JOIN parent ... WHERE parent.id IS NULL`
   to find orphans, or `PRAGMA foreign_key_check` in SQLite.

5. **Why does `WHERE col = NULL` return nothing?**
   NULL means "unknown", so any comparison with it is unknown. Use `IS NULL` / `IS NOT NULL`.

6. **`COUNT(*)` vs `COUNT(col)`?**
   `COUNT(*)` counts rows; `COUNT(col)` counts non-NULL values. In Chinook, `COUNT(Composer)` is 978 lower than
   `COUNT(*)` on Track.

7. **`UNION` vs `UNION ALL`?**
   `UNION` removes duplicate rows, `UNION ALL` keeps them (and is faster).

8. **What does `DISTINCT` do and when is it a smell?**
   Removes duplicate rows. If you need it to "fix" a join result, the join is probably wrong.

### Joins

9. **Explain INNER, LEFT, RIGHT and FULL joins.**
   INNER: only matches. LEFT: all left rows plus matches (NULLs where none). RIGHT: the mirror. FULL: all rows
   from both sides.

10. **How do you find customers who never placed an order?**
    `customers LEFT JOIN orders ON ... WHERE orders.order_id IS NULL` (query 37).

11. **What is a self join? Example?**
    A table joined to itself, e.g. employees and their managers through `ReportsTo` (query 11).

12. **A join returns more rows than expected. Why?**
    The join key is not unique on one side (one-to-many), or a join condition is missing (Cartesian product).

### Aggregation and subqueries

13. **Find duplicate e-mails.**
    `SELECT LOWER(TRIM(email)), COUNT(*) FROM customers GROUP BY 1 HAVING COUNT(*) > 1` — compare
    case-insensitively, as login systems do.

14. **Second highest invoice total?**
    `SELECT MAX(Total) FROM Invoice WHERE Total < (SELECT MAX(Total) FROM Invoice)` or
    `DENSE_RANK() OVER (ORDER BY Total DESC) = 2`.

15. **What is a correlated subquery?**
    A subquery that uses a value from the outer row and runs per row, e.g. invoices above the customer's own
    average (query 17).

16. **`IN` vs `EXISTS`?**
    Both test membership. `EXISTS` stops at the first match and handles NULLs safely; `NOT IN` returns no rows
    when the subquery contains a NULL.

17. **What is a CTE and why use it?**
    A named temporary result (`WITH x AS (...)`) that makes long checks readable and reusable in one query.

### Window functions

18. **`ROW_NUMBER`, `RANK` and `DENSE_RANK`?**
    All number rows in an order. On ties `ROW_NUMBER` still counts 1,2,3; `RANK` gives 1,1,3; `DENSE_RANK` 1,1,2.

19. **Top product per category?**
    `ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC)` and keep row 1 (query 20).

20. **Running total?**
    `SUM(amount) OVER (ORDER BY day)` (query 22).

### Data testing

21. **How do you verify an order total?**
    Compare the stored header total with `SUM(quantity * unit_price)` of its lines, and with the sum of payments
    for paid orders (checks `order_total_mismatch`, `payment_mismatch`).

22. **What do you check after an ETL load?**
    Row counts (source = loaded + rejected), checksums of amounts, transformation rules on sample rows, rejected
    rows and reasons, duplicates, NULLs in required fields, and that a re-run gives the same result.

23. **How do you prove a data-quality test works?**
    Seed known bad rows (like `defects.sql`) and assert the check returns exactly those rows, while the clean data
    returns none.

24. **How do you test a date filter "last 30 days"?**
    Boundary values: day 30 and 31 back, today, and a future date. In tests, anchor on a fixed date.

25. **Why compare money in cents?**
    Floating-point sums are not exact (0.1 + 0.2 ≠ 0.3); integers or `ROUND(x, 2)` avoid false failures.

26. **How do you check that a UI list matches the database?**
    Run the same filter and sort in SQL and compare count, order and the first/last rows with the screen.

27. **What is referential integrity and what breaks it?**
    Every foreign key points to an existing row. Deleting a parent without cascading, disabled FK enforcement or
    bad imports create orphans.

28. **How do you test a stored procedure or a trigger?**
    Prepare known input rows, call it (or fire the event), then query the affected tables and compare with the
    expected rows; also test invalid input and roll back afterwards.

29. **What is an index and why should a tester care?**
    A structure that speeds up lookups on a column. Slow pages often come from queries on unindexed columns;
    `EXPLAIN` shows whether an index is used.

30. **What is a transaction? What are ACID properties?**
    A group of statements that succeed or fail together. Atomicity, Consistency, Isolation, Durability. In tests,
    wrap setup data in a transaction and roll it back so the database stays clean.
