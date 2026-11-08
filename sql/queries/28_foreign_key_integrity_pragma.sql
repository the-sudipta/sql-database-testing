-- 28. Foreign key integrity checked by the database engine itself (SQLite pragma).
-- Tester use: let the engine list every row that breaks a declared foreign key.
SELECT * FROM pragma_foreign_key_check;
