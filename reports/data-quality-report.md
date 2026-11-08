# Data Quality Report

Generated 2026-11-08 16:28 UTC by `scripts/data_quality_report.py`.

## E-commerce schema: seeded defects are detected

Each check is run on the clean seed and on the copy with `sql/defects/defects.sql`.
A check passes when the clean data has 0 violations and the defect copy returns the seeded rows.

| Check | Rule | Violations (clean) | Rows found (with defects) | Result |
|---|---|---|---|---|
| `duplicate_customer_emails` | one account per e-mail address; addresses are compared case-insensitively and without spaces. | 0 | [1, 101] | PASS |
| `future_order_date` | an order date is not in the future (compared with today). | 0 | [107] | PASS |
| `invalid_order_lines` | quantity is at least 1 and the unit price is not negative. | 0 | [105, 106] | PASS |
| `invalid_order_status` | status is one of the allowed values (domain check). | 0 | [106] | PASS |
| `missing_customer_email` | every customer has an e-mail address that contains "@". | 0 | [102] | PASS |
| `negative_stock` | stock can be zero but never negative. | 0 | [101] | PASS |
| `order_total_mismatch` | the stored total_amount of an order equals the sum of quantity x unit_price of its lines. | 0 | [101] | PASS |
| `orders_without_customer` | every order belongs to an existing customer. | 0 | [102] | PASS |
| `orphan_order_items` | every order line belongs to an existing order and an existing product (referential integrity). | 0 | [103] | PASS |
| `payment_mismatch` | paid, shipped and delivered orders are fully paid (sum of payments = order total), and pending or cancelled orders have no payments. | 0 | [104] | PASS |
| `shipped_before_ordered` | an order cannot be shipped before it was placed. | 0 | [105] | PASS |
| `shipped_without_date` | shipped and delivered orders have a shipped date; pending, paid and cancelled orders do not. | 0 | [108] | PASS |

## Chinook sample database

| Check | Rule | Violations | Result |
|---|---|---|---|
| `customers_without_valid_support_rep` | a customer support rep is an existing employee with a "Sales" job title. | 0 | PASS |
| `duplicate_customer_emails` | a customer e-mail is used by one customer only (case-insensitive). | 0 | PASS |
| `invalid_customer_emails` | every customer has an e-mail with one "@" and a dot in the domain part. | 0 | PASS |
| `invalid_employee_hierarchy` | ReportsTo points to an existing employee, nobody reports to themselves, exactly one top manager. | 0 | PASS |
| `invalid_prices_or_quantities` | track and invoice line prices are positive and quantities are at least 1. | 0 | PASS |
| `invoice_line_price_differs_from_track` | the price charged on an invoice line equals the catalogue price of the track. | 0 | PASS |
| `invoice_total_mismatch` | Invoice.Total equals the sum of UnitPrice x Quantity of its invoice lines (rounded to cents). | 0 | PASS |
| `invoices_missing_billing_data` | every invoice has a date in the expected range, a billing country and a non-negative total. | 0 | PASS |
| `orphan_invoice_lines` | every invoice line points to an existing invoice and an existing track. | 0 | PASS |
| `tracks_with_broken_references` | every track has an existing album, media type and (when set) genre. | 0 | PASS |
