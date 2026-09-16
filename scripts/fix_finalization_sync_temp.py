#!/usr/bin/env python3
from pathlib import Path

root = Path(__file__).resolve().parents[1]
changed = 0
for sql_path in (root / 'database/content').rglob('*.sql'):
    text = sql_path.read_text(encoding='utf-8')
    marker = '-- BEGIN GENERATED PERSIAN LOCALIZATION SYNC'
    end_marker = '-- END GENERATED PERSIAN LOCALIZATION SYNC'
    if marker not in text:
        continue
    before, tail = text.split(marker, 1)
    if end_marker not in tail:
        raise SystemExit(f'{sql_path}: missing localization sync end marker')
    body, after = tail.split(end_marker, 1)

    reopen_level = "UPDATE language_levels SET status='review' WHERE id=@level AND status='final';\n"
    reopen_lessons = "UPDATE lessons SET status='qa' WHERE language_level_id=@level AND status='final';\n"
    if reopen_level not in body:
        body = body.replace('START TRANSACTION;\n', 'START TRANSACTION;\n' + reopen_level + reopen_lessons, 1)

    body = body.replace("SET ll.status='final',", "SET ll.status='review',")
    body = body.replace(", status='final', activity_selection_rationale=", ", status='qa', activity_selection_rationale=")

    refinalize = "UPDATE lessons SET status='final' WHERE language_level_id=@level;\nUPDATE language_levels SET status='final' WHERE id=@level;\n"
    if refinalize not in body:
        body = body.replace('COMMIT;\n', refinalize + 'COMMIT;\n', 1)

    new_text = before + marker + body + end_marker + after
    if new_text != text:
        sql_path.write_text(new_text, encoding='utf-8')
        changed += 1

print(f'Patched {changed} content SQL file(s).')
