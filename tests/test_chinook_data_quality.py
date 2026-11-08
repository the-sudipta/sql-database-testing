"""Data-quality checks on the Chinook sample database: every rule must return zero violating rows."""

import pytest

from qa_db.sql_files import check_files, header_comment, run_file

pytestmark = pytest.mark.chinook

EXPECTED_ROW_COUNTS = {
    "Album": 347,
    "Artist": 275,
    "Customer": 59,
    "Employee": 8,
    "Genre": 25,
    "Invoice": 412,
    "InvoiceLine": 2240,
    "MediaType": 5,
    "Playlist": 18,
    "PlaylistTrack": 8715,
    "Track": 3503,
}


@pytest.mark.parametrize("check", check_files("chinook"), ids=lambda p: p.stem)
def test_rule_has_no_violations(chinook, check):
    result = run_file(chinook, check)
    assert result.rows == [], f"{header_comment(check)}\nViolations: {result.rows[:10]}"


@pytest.mark.parametrize(("table", "expected"), EXPECTED_ROW_COUNTS.items())
def test_table_row_count_matches_the_release(chinook, table, expected):
    assert chinook.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0] == expected


@pytest.mark.parametrize(
    ("table", "key"),
    [("Customer", "CustomerId"), ("Invoice", "InvoiceId"), ("Track", "TrackId"), ("Album", "AlbumId")],
)
def test_primary_keys_are_unique_and_not_null(chinook, table, key):
    total, distinct, nulls = chinook.execute(
        f"SELECT COUNT(*), COUNT(DISTINCT {key}), SUM({key} IS NULL) FROM {table}"
    ).fetchone()
    assert (total, nulls) == (distinct, 0)


def test_required_customer_fields_are_filled(chinook):
    missing = chinook.execute(
        "SELECT CustomerId FROM Customer WHERE TRIM(COALESCE(FirstName, '')) = '' "
        "OR TRIM(COALESCE(LastName, '')) = '' OR TRIM(COALESCE(Country, '')) = ''"
    ).fetchall()
    assert missing == []
