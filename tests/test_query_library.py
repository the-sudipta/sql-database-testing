"""The tester query library (sql/queries): every query runs, and key queries return the known answers."""

import pytest

from qa_db.sql_files import query_files, run_file

pytestmark = pytest.mark.queries

QUERIES = {path.stem: path for path in query_files()}


def database_for(name, chinook, shop_clean):
    return shop_clean if "_shop_" in name else chinook


def test_library_has_forty_documented_queries():
    assert len(QUERIES) == 40
    for path in QUERIES.values():
        assert path.read_text(encoding="utf-8").startswith("-- "), f"{path.name} has no header comment"


@pytest.mark.parametrize("name", QUERIES)
def test_query_runs(chinook, shop_clean, name):
    result = run_file(database_for(name, chinook, shop_clean), QUERIES[name])
    assert result.columns, f"{name} returned no columns"


def rows(name, chinook, shop_clean):
    return run_file(database_for(name, chinook, shop_clean), QUERIES[name]).rows


def test_brazil_has_five_customers(chinook, shop_clean):
    assert len(rows("01_select_where_customers_in_brazil", chinook, shop_clean)) == 5


def test_first_quarter_2010_has_21_invoices(chinook, shop_clean):
    assert len(rows("03_between_date_range", chinook, shop_clean)) == 21


def test_usa_has_most_invoices(chinook, shop_clean):
    assert rows("12_group_by_count", chinook, shop_clean)[0] == ("USA", 91)


def test_invoice_statistics(chinook, shop_clean):
    assert rows("14_aggregate_statistics", chinook, shop_clean) == [(412, 2328.6, 5.65, 0.99, 25.86)]


@pytest.mark.parametrize(
    "name", ["26_duplicate_detection", "27_orphan_rows", "28_foreign_key_integrity_pragma"]
)
def test_integrity_queries_find_nothing_in_chinook(chinook, shop_clean, name):
    assert rows(name, chinook, shop_clean) == []


def test_yearly_totals_reconcile(chinook, shop_clean):
    differences = [row[3] for row in rows("29_totals_reconciliation", chinook, shop_clean)]
    assert differences == [0.0] * 5


def test_clean_shop_orders_reconcile(chinook, shop_clean):
    for order_id, status, total, lines_total, paid in rows(
        "35_shop_order_reconciliation", chinook, shop_clean
    ):
        assert total == lines_total, f"order {order_id}"
        expected_paid = total if status in ("paid", "shipped", "delivered") else 0
        assert paid == expected_paid, f"order {order_id} ({status})"


def test_only_one_shop_customer_never_ordered(chinook, shop_clean):
    assert [r[0] for r in rows("37_shop_customers_without_orders", chinook, shop_clean)] == [8]
