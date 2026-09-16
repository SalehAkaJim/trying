#!/usr/bin/env python3
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
ALIASES={
    'source_backed_pairs_grouped':'source_items_grouped_for_matching',
    'source_sentence_blanked':'source_sentence_blank_created',
}
changed=0
for path in (ROOT/'content').glob('*/*/lessons/*.json'):
    data=json.loads(path.read_text(encoding='utf-8'))
    dirty=False
    for activity in data.get('activities',[]):
        old=activity.get('transformations') or []
        new=[ALIASES.get(x,x) for x in old]
        if new!=old:
            activity['transformations']=new
            dirty=True
    if dirty:
        path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        changed+=1
print(f'Normalized transformation codes in {changed} lesson files.')
