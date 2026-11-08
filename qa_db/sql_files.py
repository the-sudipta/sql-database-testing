"""Loads .sql files from the sql/ folder and runs them."""

import sqlite3
from dataclasses import dataclass
from pathlib import Path

from qa_db.databases import SQL_DIR


@dataclass(frozen=True)
class QueryResult:
    columns: list[str]
    rows: list[tuple]

    @property
    def first_column(self) -> list:
        return [row[0] for row in self.rows]


def run_file(connection: sqlite3.Connection, path: Path) -> QueryResult:
    cursor = connection.execute(path.read_text(encoding="utf-8"))
    columns = [d[0] for d in cursor.description] if cursor.description else []
    return QueryResult(columns, cursor.fetchall())


def check_files(group: str) -> list[Path]:
    """Data-quality checks of a group ("chinook" or "shop"); each returns the violating rows."""
    return sorted((SQL_DIR / "checks" / group).glob("*.sql"))


def query_files() -> list[Path]:
    """The tester query library, numbered 01..40."""
    return sorted((SQL_DIR / "queries").glob("*.sql"))


def header_comment(path: Path) -> str:
    """The leading comment lines of a SQL file (used as the description in reports)."""
    lines = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.startswith("--"):
            break
        lines.append(line.lstrip("- ").strip())
    return " ".join(lines)
