#!/usr/bin/env python3
from pathlib import Path
import json

root = Path(__file__).resolve().parents[1]
schema_path = root / 'database/schema.sql'
schema = schema_path.read_text(encoding='utf-8')
needle = "  url TEXT NULL,\n  published_or_updated_at VARCHAR(64) NULL,"
replacement = "  url TEXT NULL,\n  locator VARCHAR(500) NULL,\n  locator_fa VARCHAR(500) NULL,\n  published_or_updated_at VARCHAR(64) NULL,"
if "CREATE TABLE IF NOT EXISTS sources" not in schema:
    raise SystemExit('sources table not found')
if "  locator VARCHAR(500) NULL,\n  locator_fa VARCHAR(500) NULL,\n  published_or_updated_at" not in schema:
    if needle not in schema:
        raise SystemExit('sources url insertion point not found')
    schema = schema.replace(needle, replacement, 1)
schema_path.write_text(schema, encoding='utf-8')

level_path = root / 'content/de/pre-a1/level.json'
level = json.loads(level_path.read_text(encoding='utf-8'))
ca = level.get('completionAssessment') or {}
for key in ('scopeExclusions', 'requiredGaps'):
    vals = ca.get(key)
    if isinstance(vals, list):
        ca[key] = [v.replace('مبنای فعلی فعلی', 'مبنای فعلی') if isinstance(v, str) else v for v in vals]
qr = ca.get('qualityReview') or {}
if isinstance(qr.get('rationale'), str):
    qr['rationale'] = qr['rationale'].replace('مبنای فعلی فعلی', 'مبنای فعلی')
for key in ('strengths','remainingWeaknesses'):
    vals=qr.get(key)
    if isinstance(vals,list):
        qr[key]=[v.replace('مبنای فعلی فعلی','مبنای فعلی') if isinstance(v,str) else v for v in vals]
level_path.write_text(json.dumps(level, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

# The generated localization sync runs after the level has already been finalized by
# the base/finalization extension. Respect the final-content guards: reopen the level
# and its lessons transactionally, apply sync updates, then finalize lessons first and
# the level last. Never weaken the triggers.
for sql_path in (root / 'database/content').rglob('*.sql'):
    text = sql_path.read_text(encoding='utf-8')
    marker = '-- BEGIN GENERATED PERSIAN LOCALIZATION SYNC'
    end_marker = '-- END GENERATED PERSIAN LOCALIZATION SYNC'
    if marker not in text:
        continue
    before, tail = text.split(marker, 1)
    if end_marker not in tail:
        raise SystemExit(f'{sql_path}: localization sync end marker missing')
    body, after = tail.split(end_marker, 1)
    if 'UPDATE language_levels SET status=\'review\' WHERE id=@level AND status=\'final\';' not in body:
        body = body.replace(
            'START TRANSACTION;\n',
            "START TRANSACTION;\nUPDATE language_levels SET status='review' WHERE id=@level AND status='final';\nUPDATE lessons SET status='qa' WHERE language_level_id=@level AND status='final';\n",
            1,
        )
    body = body.replace("SET ll.status='final',", "SET ll.status='review',")
    body = body.replace(", status='final', activity_selection_rationale=", ", status='qa', activity_selection_rationale=")
    final_lines = "UPDATE lessons SET status='final' WHERE language_level_id=@level;\nUPDATE language_levels SET status='final' WHERE id=@level;\n"
    if final_lines not in body:
        body = body.replace('COMMIT;\n', final_lines + 'COMMIT;\n', 1)
    sql_path.write_text(before + marker + body + end_marker + after, encoding='utf-8')

print('Source locator schema and finalization-order fixes applied.')
