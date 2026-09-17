#!/usr/bin/env python3
from pathlib import Path

path = Path('database/content/de/pre-a1.sql')
text = path.read_text(encoding='utf-8')
marker = '-- BEGIN PRE-A1 ACTIVITY COUNT GUARDRAIL SYNC'
end_marker = '-- END PRE-A1 ACTIVITY COUNT GUARDRAIL SYNC'
if marker not in text or end_marker not in text:
    raise SystemExit('Guardrail sync markers not found')
head, rest = text.split(marker, 1)
block, tail = rest.split(end_marker, 1)

reopen = """
-- Reopen only the lessons whose activity sequences are being revised.
UPDATE lessons SET status='qa'
WHERE id IN (@g_l_hallo,@g_l_danke,@g_l_residence,@g_l_object,@g_l_choice);
"""
restore = """
-- Restore finalized status after the activity revision is complete.
UPDATE lessons SET status='final'
WHERE id IN (@g_l_hallo,@g_l_danke,@g_l_residence,@g_l_object,@g_l_choice);
"""

anchor = "SET @g_l_choice=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-choice' LIMIT 1);\n"
if reopen.strip() not in block:
    if anchor not in block:
        raise SystemExit('Lesson-id anchor not found')
    block = block.replace(anchor, anchor + reopen, 1)

commit_anchor = '\nCOMMIT;\n'
if restore.strip() not in block:
    idx = block.rfind(commit_anchor)
    if idx < 0:
        raise SystemExit('Guardrail COMMIT not found')
    block = block[:idx] + '\n' + restore + block[idx:]

path.write_text(head + marker + block + end_marker + tail, encoding='utf-8')
print('Added controlled lesson reopen/finalize around Pre-A1 activity synchronization.')
