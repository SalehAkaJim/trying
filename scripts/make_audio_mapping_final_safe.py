#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re

from audio_pipeline import mapping_sql_path

MARKER = "-- Temporarily reopen final lessons for activity audio metadata updates."
TEMP_TABLE = "_audio_mapping_lesson_status"


def patch_mapping(language: str, level: str) -> str:
    path = mapping_sql_path(language, level)
    if not path.exists():
        raise RuntimeError(f"Audio mapping does not exist: {path}")

    sql = path.read_text(encoding="utf-8")
    if MARKER in sql:
        return str(path)

    activity_keys = re.findall(
        r"^UPDATE activities SET .*? WHERE activity_key=('(?:''|[^'])*') AND SHA2\(audio_text_target,256\)=",
        sql,
        flags=re.MULTILINE,
    )
    if not activity_keys:
        return str(path)

    unique_keys = list(dict.fromkeys(activity_keys))
    keys_sql = ",".join(unique_keys)

    reopen = "\n".join([
        MARKER,
        f"DROP TEMPORARY TABLE IF EXISTS {TEMP_TABLE};",
        f"CREATE TEMPORARY TABLE {TEMP_TABLE} AS",
        "SELECT DISTINCT le.id AS lesson_id, le.status AS original_status",
        "FROM lessons le JOIN activities a ON a.lesson_id=le.id",
        f"WHERE a.activity_key IN ({keys_sql});",
        f"UPDATE lessons le JOIN {TEMP_TABLE} s ON s.lesson_id=le.id",
        "SET le.status='qa'",
        "WHERE s.original_status='final';",
    ])

    restore = "\n".join([
        f"UPDATE lessons le JOIN {TEMP_TABLE} s ON s.lesson_id=le.id",
        "SET le.status=s.original_status",
        "WHERE NOT (le.status <=> s.original_status);",
        f"DROP TEMPORARY TABLE IF EXISTS {TEMP_TABLE};",
    ])

    start = "START TRANSACTION;"
    commit = "COMMIT;"
    if start not in sql or commit not in sql:
        raise RuntimeError(f"Unexpected mapping SQL structure: {path}")

    sql = sql.replace(start, start + "\n" + reopen, 1)
    sql = sql.replace(commit, restore + "\n" + commit, 1)
    path.write_text(sql, encoding="utf-8")
    return str(path)


def main() -> int:
    parser = argparse.ArgumentParser(description="Patch generated audio SQL so activity metadata can be applied to final lessons safely.")
    parser.add_argument("--language", required=True)
    parser.add_argument("--level", required=True)
    args = parser.parse_args()
    print(patch_mapping(args.language, args.level))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
