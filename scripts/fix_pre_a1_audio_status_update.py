#!/usr/bin/env python3
from pathlib import Path

path = Path('database/content/de/pre-a1.sql')
text = path.read_text(encoding='utf-8')
marker = '-- BEGIN PRE-A1 ACTIVITY COUNT GUARDRAIL SYNC'
if marker not in text:
    raise SystemExit('Pre-A1 guardrail block not found')
head, block = text.split(marker, 1)
needle = ',audio_status=VALUES(audio_status);'
if needle not in block:
    raise SystemExit('Expected audio_status duplicate-update clause not found')
block = block.replace(needle, ';', 1)
if 'audio_status=VALUES(audio_status)' in head + marker + block:
    raise SystemExit('Another forbidden audio_status duplicate-update clause remains')
path.write_text(head + marker + block, encoding='utf-8')
print('Removed base-content audio_status overwrite from Pre-A1 guardrail block.')
