"""Opens the Chinook database read-only and builds the e-commerce (shop) database from SQL scripts."""

import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "sql"
CHINOOK_PATH = ROOT / "data" / "chinook" / "Chinook_Sqlite.sqlite"
SHOP_SCRIPTS = ("schema/shop_schema.sql", "schema/shop_seed.sql")
DEFECT_SCRIPT = "defects/defects.sql"


def connect_chinook() -> sqlite3.Connection:
    """Read-only connection, so no test can change the reference data."""
    if not CHINOOK_PATH.exists():
        raise FileNotFoundError("Chinook database missing - run: uv run python scripts/download_chinook.py")
    return sqlite3.connect(f"file:{CHINOOK_PATH.as_posix()}?mode=ro", uri=True)


def build_shop(path: Path, with_defects: bool = False) -> sqlite3.Connection:
    """Creates a fresh shop database at `path`: schema + clean seed, plus the seeded defects if asked."""
    path.unlink(missing_ok=True)
    connection = sqlite3.connect(path)
    scripts = [*SHOP_SCRIPTS, DEFECT_SCRIPT] if with_defects else list(SHOP_SCRIPTS)
    for script in scripts:
        connection.executescript((SQL_DIR / script).read_text(encoding="utf-8"))
    connection.commit()
    return connection
