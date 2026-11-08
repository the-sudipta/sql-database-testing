"""A small ETL job: customer CSV export -> cleaned rows in stg_customers, rejected rows in etl_rejects.

Transformation rules (the specification the ETL tests check):
- names are trimmed and inner spaces collapsed; full_name = "first last"
- e-mail is trimmed and lower-cased; it must look like name@domain.tld
- signup_date DD/MM/YYYY becomes ISO YYYY-MM-DD; impossible dates are rejected
- country_code is case-insensitive and mapped to a country name; unknown codes are rejected
- total_spent "1,250.50" becomes 125050 (integer cents); negative amounts are rejected
- a customer_id seen before in the same file is rejected as a duplicate
"""

import csv
import re
import sqlite3
from datetime import datetime
from pathlib import Path

COUNTRIES = {"BD": "Bangladesh", "IN": "India", "US": "United States", "DE": "Germany"}
EMAIL = re.compile(r"^[^@\s]+@[^@\s]+\.[a-z]{2,}$")

TARGET_DDL = """
CREATE TABLE IF NOT EXISTS stg_customers (
    customer_id INTEGER PRIMARY KEY, full_name TEXT NOT NULL, email TEXT NOT NULL UNIQUE,
    signup_date TEXT NOT NULL, country TEXT NOT NULL, total_spent_cents INTEGER NOT NULL);
CREATE TABLE IF NOT EXISTS etl_rejects (source_row INTEGER NOT NULL, customer_id TEXT, reason TEXT NOT NULL);
"""


class RejectedRowError(ValueError):
    """Raised by a transformation rule; the message is stored as the reject reason."""


def read_source(path: Path) -> list[dict]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def clean_name(first: str, last: str) -> str:
    return " ".join(f"{first} {last}".split())


def clean_email(raw: str) -> str:
    email = raw.strip().lower()
    if not EMAIL.match(email):
        raise RejectedRowError("invalid e-mail")
    return email


def iso_date(raw: str) -> str:
    try:
        return datetime.strptime(raw.strip(), "%d/%m/%Y").date().isoformat()
    except ValueError as error:
        raise RejectedRowError("invalid date") from error


def country_name(code: str) -> str:
    try:
        return COUNTRIES[code.strip().upper()]
    except KeyError as error:
        raise RejectedRowError("unknown country code") from error


def cents(raw: str) -> int:
    amount = round(float(raw.replace(",", "").strip()) * 100)
    if amount < 0:
        raise RejectedRowError("negative amount")
    return amount


def transform(row: dict) -> tuple:
    return (
        int(row["customer_id"]),
        clean_name(row["first_name"], row["last_name"]),
        clean_email(row["email"]),
        iso_date(row["signup_date"]),
        country_name(row["country_code"]),
        cents(row["total_spent"]),
    )


def run(source: Path, connection: sqlite3.Connection) -> dict:
    """Full reload: clears the target tables, loads valid rows, records rejects. Returns the counts."""
    connection.executescript(TARGET_DDL + "DELETE FROM stg_customers; DELETE FROM etl_rejects;")
    seen: set[int] = set()
    for number, row in enumerate(read_source(source), start=1):
        try:
            record = transform(row)
            if record[0] in seen:
                raise RejectedRowError("duplicate customer_id")
            seen.add(record[0])
            connection.execute("INSERT INTO stg_customers VALUES (?, ?, ?, ?, ?, ?)", record)
        except RejectedRowError as reason:
            connection.execute(
                "INSERT INTO etl_rejects VALUES (?, ?, ?)", (number, row["customer_id"], str(reason))
            )
    connection.commit()
    loaded = connection.execute("SELECT COUNT(*) FROM stg_customers").fetchone()[0]
    rejected = connection.execute("SELECT COUNT(*) FROM etl_rejects").fetchone()[0]
    return {"source": len(read_source(source)), "loaded": loaded, "rejected": rejected}
