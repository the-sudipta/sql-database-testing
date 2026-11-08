"""Runs every data-quality check and writes reports/data-quality-report.md.

For the shop schema it runs each check twice - on the clean seed and on the copy with defects.sql - so the
report shows that each seeded defect is detected and that the clean data passes.
"""

import sys
import tempfile
from datetime import UTC, datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from qa_db.databases import build_shop, connect_chinook  # noqa: E402
from qa_db.sql_files import check_files, header_comment, run_file  # noqa: E402

OUT = ROOT / "reports" / "data-quality-report.md"


def rule_text(path: Path) -> str:
    return header_comment(path).split("Returns:")[0].replace("Rule:", "").strip()


def shop_rows(clean, defects) -> list[str]:
    lines = []
    for check in check_files("shop"):
        clean_rows = run_file(clean, check).rows
        found = run_file(defects, check).first_column
        verdict = "PASS" if not clean_rows and found else "CHECK"
        lines.append(f"| `{check.stem}` | {rule_text(check)} | {len(clean_rows)} | {found} | {verdict} |")
    return lines


def chinook_rows(chinook) -> list[str]:
    lines = []
    for check in check_files("chinook"):
        count = len(run_file(chinook, check).rows)
        verdict = "PASS" if count == 0 else "FAIL"
        lines.append(f"| `{check.stem}` | {rule_text(check)} | {count} | {verdict} |")
    return lines


def main() -> None:
    with tempfile.TemporaryDirectory() as tmp:
        clean = build_shop(Path(tmp) / "clean.db")
        defects = build_shop(Path(tmp) / "defects.db", with_defects=True)
        shop = shop_rows(clean, defects)
        clean.close()
        defects.close()
    report = [
        "# Data Quality Report",
        "",
        f"Generated {datetime.now(UTC):%Y-%m-%d %H:%M} UTC by `scripts/data_quality_report.py`.",
        "",
        "## E-commerce schema: seeded defects are detected",
        "",
        "Each check is run on the clean seed and on the copy with `sql/defects/defects.sql`.",
        "A check passes when the clean data has 0 violations and the defect copy returns the seeded rows.",
        "",
        "| Check | Rule | Violations (clean) | Rows found (with defects) | Result |",
        "|---|---|---|---|---|",
        *shop,
        "",
        "## Chinook sample database",
        "",
        "| Check | Rule | Violations | Result |",
        "|---|---|---|---|",
        *chinook_rows(connect_chinook()),
        "",
    ]
    OUT.write_text("\n".join(report), encoding="utf-8")
    print(f"written {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
