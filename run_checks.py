"""Run every check in checks.sql against a SQLite database and print a report.

Usage:
    python run_checks.py              # builds an in-memory demo DB from schema.sql + seed.sql
    python run_checks.py my_data.db   # runs the checks against your own SQLite file
"""
import re
import sqlite3
import sys
from pathlib import Path

HERE = Path(__file__).parent


def load_checks(path=HERE / "checks.sql"):
    """Return [(name, sql)] split on '-- check:' markers."""
    text = Path(path).read_text(encoding="utf-8")
    parts = re.split(r"^-- check:\s*(.+)$", text, flags=re.M)
    return [(parts[i].strip(), parts[i + 1].strip()) for i in range(1, len(parts), 2)]


def demo_connection():
    con = sqlite3.connect(":memory:")
    con.executescript((HERE / "schema.sql").read_text(encoding="utf-8"))
    con.executescript((HERE / "seed.sql").read_text(encoding="utf-8"))
    return con


def run(con, checks):
    """Return [(name, column_names, failing_rows)]."""
    results = []
    for name, sql in checks:
        cur = con.execute(sql)
        results.append((name, [d[0] for d in cur.description], cur.fetchall()))
    return results


def report(results):
    failed = sum(1 for _, _, rows in results if rows)
    lines = ["# SQL data validation report", "", f"Checks run: {len(results)} | passed: {len(results) - failed} | failed: {failed}", ""]
    for name, cols, rows in results:
        lines.append(f"## {'PASS' if not rows else 'FAIL'}: {name}")
        if rows:
            lines.append("")
            lines.append("| " + " | ".join(cols) + " |")
            lines.append("|" + "---|" * len(cols))
            lines += ["| " + " | ".join(str(v) for v in r) + " |" for r in rows]
        lines.append("")
    return "\n".join(lines)


if __name__ == "__main__":
    con = sqlite3.connect(sys.argv[1]) if len(sys.argv) > 1 else demo_connection()
    results = run(con, load_checks())
    print(report(results))
    sys.exit(1 if any(rows for _, _, rows in results) else 0)
