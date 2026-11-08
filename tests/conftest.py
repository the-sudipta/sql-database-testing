import sqlite3
from collections.abc import Iterator
from pathlib import Path

import pytest

from qa_db.databases import build_shop, connect_chinook


def pytest_html_report_title(report):
    report.title = "SQL Data-Quality Test Report"


@pytest.fixture(scope="session")
def chinook() -> Iterator[sqlite3.Connection]:
    connection = connect_chinook()
    yield connection
    connection.close()


@pytest.fixture(scope="session")
def shop_clean(tmp_path_factory: pytest.TempPathFactory) -> Iterator[sqlite3.Connection]:
    connection = build_shop(tmp_path_factory.mktemp("shop") / "shop_clean.db")
    yield connection
    connection.close()


@pytest.fixture(scope="session")
def shop_with_defects(tmp_path_factory: pytest.TempPathFactory) -> Iterator[sqlite3.Connection]:
    connection = build_shop(tmp_path_factory.mktemp("shop") / "shop_defects.db", with_defects=True)
    yield connection
    connection.close()


@pytest.fixture
def etl_target(tmp_path: Path) -> Iterator[sqlite3.Connection]:
    connection = sqlite3.connect(tmp_path / "etl_target.db")
    yield connection
    connection.close()
