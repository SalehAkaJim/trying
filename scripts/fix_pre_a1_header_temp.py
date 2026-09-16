#!/usr/bin/env python3
from pathlib import Path
p=Path('database/content/de/pre-a1.sql')
text=p.read_text(encoding='utf-8')
old='-- Current snapshot: 9 source-backed beginner lessons.\n'
new='-- Current snapshot: finalized source-backed German Pre-A1 curriculum.\n'
if old not in text:
    raise SystemExit('stale header marker not found')
p.write_text(text.replace(old,new,1),encoding='utf-8')
print('Updated Pre-A1 SQL header.')
