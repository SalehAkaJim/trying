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
for key in ('rationale',):
    if isinstance(qr.get(key), str):
        qr[key] = qr[key].replace('مبنای فعلی فعلی', 'مبنای فعلی')
for key in ('strengths','remainingWeaknesses'):
    vals=qr.get(key)
    if isinstance(vals,list):
        qr[key]=[v.replace('مبنای فعلی فعلی','مبنای فعلی') if isinstance(v,str) else v for v in vals]
level_path.write_text(json.dumps(level, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print('Source locator schema fix applied.')
