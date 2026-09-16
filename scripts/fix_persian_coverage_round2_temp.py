#!/usr/bin/env python3
import json, pathlib, re
ROOT=pathlib.Path(__file__).resolve().parents[1]
EDITORIAL_KEYS={'structureRationale','groupingRationale','activitySelectionRationale','sequenceRationale','selectionReason','scenario','sceneQualityRationale','contextNotes','notes','instructionFa','translationFa','usageNoteFa','titleFa','contextFa','promptFa','descriptionFa','partOfSpeechFa','rationale','conversationVoiceStyle','sourceTitleFa','locatorFa','currencyEvidence'}
EDITORIAL_LIST_KEYS={'learningTargets','scopeExclusions','requiredGaps','strengths','remainingWeaknesses'}
REPL=[
 ('Companion Volume','جلد همراه'),('Pre-A1','پیش از A1'),('word order','مرتب‌کردن واژه‌ها'),('fill blank','جای‌خالی'),
 ('matching','تطبیق'),('attribution','ذکر منبع'),('baseline','مبنای فعلی'),('audit','ارزیابی'),('CI','کنترل خودکار'),
 ('Brandenburg','براندنبورگ'),('v3','نسخهٔ ۳')
]
def clean(s):
 if not isinstance(s,str): return s
 for a,b in REPL:
  s=re.sub(r'(?<![A-Za-z])'+re.escape(a)+r'(?![A-Za-z])',b,s,flags=re.I)
 return s
def walk(v):
 if isinstance(v,dict):
  for k,x in list(v.items()):
   if k in EDITORIAL_KEYS and isinstance(x,str): v[k]=clean(x)
   elif k in EDITORIAL_LIST_KEYS and isinstance(x,list): v[k]=[clean(i) if isinstance(i,str) else i for i in x]
   elif k=='coverage' and isinstance(x,dict):
    for g,items in x.items():
     if isinstance(items,list): x[g]=[clean(i) if isinstance(i,str) else i for i in items]
   else: walk(x)
 elif isinstance(v,list):
  for x in v: walk(x)
for p in (ROOT/'content').rglob('*.json'):
 d=json.loads(p.read_text(encoding='utf-8')); walk(d)
 if 'sources' in p.parts:
  d['titleFa']=clean(d.get('titleFa') or d.get('notes') or 'منبع آموزشی')
  if d.get('locator') is not None: d['locatorFa']=clean(d.get('locatorFa') or d.get('notes') or 'محل دقیق در منبع')
 if 'lessons' in p.parts and d.get('sourceTitle') is not None:
  d['sourceTitleFa']=clean(d.get('sourceTitleFa') or d.get('titleFa') or 'عنوان فارسی درس')
 p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Second Persian prose cleanup completed.')
