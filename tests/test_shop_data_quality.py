"""Business-rule checks on the e-commerce schema.

The clean seed must pass every check. With defects.sql applied, every seeded defect (D-01 .. D-12) must be
found by its check, with exactly the expected rows - which proves the checks really catch bad data.
"""

import pytest

from qa_db.sql_files import check_files, header_comment, run_file

pytestmark = pytest.mark.shop

# check file -> (defect ID, keys the check must return for the defect database)
SEEDED_DEFECTS = {
    "order_total_mismatch": ("D-01", [101]),
    "orphan_order_items": ("D-02", [103]),
    "orders_without_customer": ("D-03", [102]),
    "duplicate_customer_emails": ("D-04", [1, 101]),
    "missing_customer_email": ("D-05", [102]),
    "invalid_order_lines": ("D-06", [105, 106]),
    "payment_mismatch": ("D-07", [104]),
    "shipped_before_ordered": ("D-08", [105]),
    "invalid_order_status": ("D-09", [106]),
    "future_order_date": ("D-10", [107]),
    "negative_stock": ("D-11", [101]),
    "shipped_without_date": ("D-12", [108]),
}

CHECKS = check_files("shop")


def test_every_check_has_a_seeded_defect():
    assert sorted(p.stem for p in CHECKS) == sorted(SEEDED_DEFECTS)


@pytest.mark.parametrize("check", CHECKS, ids=lambda p: p.stem)
def test_clean_data_passes(shop_clean, check):
    result = run_file(shop_clean, check)
    assert result.rows == [], f"{header_comment(check)}\nUnexpected violations: {result.rows}"


@pytest.mark.defects
@pytest.mark.parametrize("check", CHECKS, ids=lambda p: p.stem)
def test_seeded_defect_is_detected(shop_with_defects, check):
    defect_id, expected_keys = SEEDED_DEFECTS[check.stem]
    result = run_file(shop_with_defects, check)
    assert result.first_column == expected_keys, f"{defect_id} not detected as expected: {result.rows}"


def test_engine_foreign_key_check_agrees_with_orphan_checks(shop_with_defects):
    violations = shop_with_defects.execute("PRAGMA foreign_key_check").fetchall()
    orphan_tables = sorted({row[0] for row in violations})
    assert orphan_tables == ["order_items", "orders"]
