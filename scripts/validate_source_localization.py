#!/usr/bin/env python3
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
FA = re.compile(r'[\u0600-\u06FF]')
errors = []
count = 0

for path in sorted((ROOT / 'content').glob('*/sources/*.json')):
    data = json.loads(path.read_text(encoding='utf-8'))
    count += 1
    evidence = data.get('currencyEvidence')
    notes = data.get('notes')
    title_fa = data.get('titleFa')
    locator = data.get('locator')
    locator_fa = data.get('locatorFa')
    if not isinstance(evidence, str) or not evidence.strip() or not FA.search(evidence):
        errors.append(f'{path}: currencyEvidence must be assistant-authored Persian prose')
    if not isinstance(notes, str) or not notes.strip() or not FA.search(notes):
        errors.append(f'{path}: notes must be assistant-authored Persian prose')
    if not isinstance(title_fa, str) or not title_fa.strip() or not FA.search(title_fa):
        errors.append(f'{path}: titleFa is required and must be Persian')
    if locator is not None and (not isinstance(locator_fa, str) or not locator_fa.strip() or not FA.search(locator_fa)):
        errors.append(f'{path}: locator requires locatorFa in Persian')

if errors:
    print('\n'.join(errors))
    sys.exit(1)

print(f'Source localization passed for {count} source records.')
