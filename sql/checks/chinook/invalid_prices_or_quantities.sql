-- Rule: track and invoice line prices are positive and quantities are at least 1.
-- Returns: source table, id, value.
SELECT 'Track' AS Source, TrackId AS Id, UnitPrice AS Value FROM Track WHERE UnitPrice <= 0
UNION ALL
SELECT 'InvoiceLine.UnitPrice', InvoiceLineId, UnitPrice FROM InvoiceLine WHERE UnitPrice <= 0
UNION ALL
SELECT 'InvoiceLine.Quantity', InvoiceLineId, Quantity FROM InvoiceLine WHERE Quantity < 1;
