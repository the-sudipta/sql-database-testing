"""ETL validation: data/etl/customers_export.csv -> stg_customers (+ etl_rejects).

Classic checks a tester runs after a load: row counts reconcile, totals (checksums) reconcile, every
transformation rule is applied, rejected rows carry the right reason, no duplicates, re-runs are idempotent.
"""

import csv
from pathlib import Path

import pytest

from qa_db import etl
from qa_db.databases import ROOT

pytestmark = pytest.mark.etl

SOURCE = ROOT / "data" / "etl" / "customers_export.csv"

EXPECTED_REJECTS = [
    (6, "1006", "invalid e-mail"),
    (8, "1008", "invalid date"),
    (9, "1009", "unknown country code"),
    (10, "1002", "duplicate customer_id"),
    (13, "1012", "invalid e-mail"),
    (14, "1013", "negative amount"),
]


@pytest.fixture
def loaded(etl_target):
    counts = etl.run(SOURCE, etl_target)
    return etl_target, counts


def source_row_count(path: Path) -> int:
    with path.open(newline="", encoding="utf-8") as handle:
        return sum(1 for _ in csv.DictReader(handle))


def test_row_counts_reconcile(loaded):
    _, counts = loaded
    assert counts == {"source": source_row_count(SOURCE), "loaded": 9, "rejected": 6}
    assert counts["loaded"] + counts["rejected"] == counts["source"]


def test_rejected_rows_have_the_right_reason(loaded):
    connection, _ = loaded
    rejects = connection.execute(
        "SELECT source_row, customer_id, reason FROM etl_rejects ORDER BY source_row"
    )
    assert rejects.fetchall() == EXPECTED_REJECTS


def test_amount_checksum_reconciles_with_independent_calculation(loaded):
    connection, _ = loaded
    rejected_rows = {row for row, _, _ in EXPECTED_REJECTS}
    with SOURCE.open(newline="", encoding="utf-8") as handle:
        expected = sum(
            round(float(r["total_spent"].replace(",", "")) * 100)
            for n, r in enumerate(csv.DictReader(handle), start=1)
            if n not in rejected_rows
        )
    target = connection.execute("SELECT SUM(total_spent_cents) FROM stg_customers").fetchone()[0]
    assert target == expected == 1_949_659


@pytest.mark.parametrize(
    ("customer_id", "expected"),
    [
        (1001, ("Rahim Uddin", "rahim.uddin@example.com", "2026-01-03", "Bangladesh", 125_050)),
        (1003, ("Karim Hasan", "karim.hasan@example.com", "2026-01-09", "Bangladesh", 0)),
        (1007, ("Tanvir Ahmed", "tanvir.ahmed@example.com", "2026-01-31", "Bangladesh", 7_500)),
        (1010, ("Sabbir Hossain", "sabbir.hossain@example.com", "2026-03-10", "Bangladesh", 1_200_000)),
        (1011, ("Lena Fischer", "lena.fischer@example.com", "2026-03-11", "Germany", 64_010)),
    ],
)
def test_transformation_rules_are_applied(loaded, customer_id, expected):
    connection, _ = loaded
    row = connection.execute(
        "SELECT full_name, email, signup_date, country, total_spent_cents "
        "FROM stg_customers WHERE customer_id = ?",
        (customer_id,),
    ).fetchone()
    assert row == expected


def test_target_has_no_duplicates_or_blank_fields(loaded):
    connection, _ = loaded
    duplicates = connection.execute(
        "SELECT email FROM stg_customers GROUP BY LOWER(email) HAVING COUNT(*) > 1"
    ).fetchall()
    blanks = connection.execute(
        "SELECT customer_id FROM stg_customers WHERE TRIM(full_name) = '' OR full_name LIKE '%  %'"
    ).fetchall()
    assert (duplicates, blanks) == ([], [])


def test_reload_is_idempotent(loaded):
    connection, first = loaded
    checksum_before = connection.execute(
        "SELECT SUM(total_spent_cents), COUNT(*) FROM stg_customers"
    ).fetchone()
    second = etl.run(SOURCE, connection)
    checksum_after = connection.execute(
        "SELECT SUM(total_spent_cents), COUNT(*) FROM stg_customers"
    ).fetchone()
    assert (second, checksum_after) == (first, checksum_before)
