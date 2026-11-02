# 🗄️ SQL Data Validation Checks

![Python](https://img.shields.io/badge/Python-3.9%2B-3776AB?style=flat-square&logo=python&logoColor=white) ![No dependencies](https://img.shields.io/badge/dependencies-none-2ea44f?style=flat-square) ![Tests](https://img.shields.io/badge/tests-unittest-2ea44f?style=flat-square) ![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)

A set of SQL data-quality checks for an annotation-task database, with a Python runner that reports PASS/FAIL for each check.

## Why this exists

Validating data where it lives (in the database) is faster and more reliable than exporting it to spreadsheets. Each check is a plain SQL query that returns the rows that fail it, so the checks are easy to read, reuse and extend.

## Features

- **Missing values**: tasks with no label
- **Invalid categories**: labels outside the allowed set per project (case-sensitive)
- **Orphan rows**: tasks pointing at annotators that don't exist (LEFT JOIN)
- **Impossible timestamps**: completed before created
- **Speed outliers**: tasks done in under 5 seconds, a common quality red flag
- **Duplicate accounts**: one email shared by several annotators (GROUP BY / HAVING)

## Quick start

No installs needed, just Python 3.9+.

```bash
git clone https://github.com/afra-ozi/sql-data-validation.git
cd sql-data-validation
python run_checks.py
```

## Input

`schema.sql` + `seed.sql` build a demo SQLite database in memory. Point the runner at your own `.db` file to check real data. Add checks to `checks.sql` under a `-- check: <name>` line.

## Sample output

Running `python run_checks.py` on the included sample data:

# SQL data validation report

Checks run: 7 | passed: 1 | failed: 6

## FAIL: tasks with a missing label

| task_id | annotator_id | project |
|---|---|---|
| 104 | 2 | sentiment |

## FAIL: labels outside the allowed set for their project

| task_id | project | label |
|---|---|---|
| 103 | sentiment | Positive |

## FAIL: tasks pointing at an annotator that does not exist (orphan rows)

| task_id | annotator_id |
|---|---|
| 106 | 9 |

## FAIL: completed before it was created

| task_id | created_at | completed_at |
|---|---|---|
| 105 | 2024-05-02 11:00 | 2024-05-02 10:58 |

## FAIL: suspiciously fast tasks (under 5 seconds) that may need a quality review

| task_id | annotator_id | seconds_spent |
|---|---|---|
| 107 | 3 | 2 |

## PASS: annotators with a missing email

## FAIL: email used by more than one annotator

| email | accounts | names |
|---|---|---|
| riya@example.com | 2 | Riya Shah, Imran Ali |

## Tests

```bash
python -m unittest -v test_run_checks
```

## License

MIT
