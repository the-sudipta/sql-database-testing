-- Rule: every customer has an e-mail with one "@" and a dot in the domain part.
-- Returns: CustomerId, Email.
SELECT CustomerId, Email
FROM Customer
WHERE Email IS NULL
   OR Email NOT LIKE '%_@_%._%'
   OR LENGTH(Email) - LENGTH(REPLACE(Email, '@', '')) <> 1
ORDER BY CustomerId;
