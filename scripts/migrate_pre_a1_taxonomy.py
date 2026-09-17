#!/usr/bin/env python3
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]
p=ROOT/'config/fa-taxonomy.json'
d=json.loads(p.read_text(encoding='utf-8'))
dom=d['domains']
dom['character_role']['cafe_staff']='کارمند کافه'
dom['relationship_tag']['neighbor']='همسایه'
dom['relationship_tag']['acquaintance']='آشنا'
p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('taxonomy updated')
