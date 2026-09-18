#!/usr/bin/env python3
import json, pathlib, re, sys
ROOT = pathlib.Path(__file__).resolve().parents[1]
CONTENT = ROOT / 'content'
FA = re.compile(r'[\u0600-\u06FF]')
LATIN = re.compile(r"[A-Za-z][A-Za-z0-9_-]*")
EDITORIAL_KEYS = {
 'structureRationale','groupingRationale','activitySelectionRationale','sequenceRationale','selectionReason',
 'scenario','sceneQualityRationale','contextNotes','notes','instructionFa','translationFa','usageNoteFa',
 'titleFa','contextFa','promptFa','descriptionFa','partOfSpeechFa','rationale','conversationVoiceStyle',
 'sourceTitleFa','locatorFa','currencyEvidence','sourceTextFa','blankedTextFa','patternFa',
 'exampleSourceTextFa','leftFa','rightFa','audioTextTargetFa'
}
EDITORIAL_LIST_KEYS={'learningTargets','scopeExclusions','requiredGaps','strengths','remainingWeaknesses','choicesFa'}
TARGET_KEYS={'surface','lemma','textTarget','sourceText','promptTarget','audioTextTarget','patternTarget','exampleSourceText','blankedText','sourceTitle'}
ALLOWED={'CEFR','MySQL','SQL','JSON','API','URL','ElevenLabs','OGL','CC','BY','SA','Pre','A1','A2','B1','B2','C1','C2','Wikibooks','Wiktionary','Oak','National','Academy','LIBRA','Mia','Iris','Lori','Hope','COERLL','Goethe','Deutsch','im','Blick','telc'}
errors=[]
tax=json.loads((ROOT/'config/fa-taxonomy.json').read_text(encoding='utf-8'))['domains']

PAIR_KEYS={
    'promptTarget':'promptFa',
    'textTarget':'translationFa',
    'sourceText':'sourceTextFa',
    'blankedText':'blankedTextFa',
    'patternTarget':'patternFa',
    'exampleSourceText':'exampleSourceTextFa',
    'left':'leftFa',
    'right':'rightFa',
}

def label(domain, code, where):
    if code is None: return
    value=(tax.get(domain) or {}).get(str(code))
    if not isinstance(value,str) or not FA.search(value):
        errors.append(f'{where}: semantic code {domain}.{code} has no canonical Persian label')

def gather_targets(v, out):
    if isinstance(v,dict):
        for k,x in v.items():
            if k in TARGET_KEYS and isinstance(x,str):
                out.update(LATIN.findall(x))
            gather_targets(x,out)
    elif isinstance(v,list):
        for x in v:gather_targets(x,out)

def check_prose(text, where, target_words):
    if not isinstance(text,str) or not text.strip(): return
    if not FA.search(text):
        errors.append(f'{where}: Persian prose is required')
        return
    cleaned=re.sub(r'«[^»]*»|`[^`]*`|https?://\S+',' ',text)
    bad=[]
    for tok in LATIN.findall(cleaned):
        if tok in ALLOWED or tok in target_words: continue
        if re.fullmatch(r'[A-Z]\d?',tok): continue
        bad.append(tok)
    if bad:
        errors.append(f'{where}: untranslated Latin/English prose tokens: {sorted(set(bad))}')

def needs_translation(text):
    return isinstance(text,str) and bool(text.strip()) and any(ch.isalpha() for ch in text) and not FA.search(text)

def require_fa(value, where):
    if not isinstance(value,str) or not value.strip() or not FA.search(value):
        errors.append(f'{where}: Persian translation is required')

def check_activity_payload_pairs(value, where):
    if isinstance(value,dict):
        for target_key,fa_key in PAIR_KEYS.items():
            target=value.get(target_key)
            if needs_translation(target):
                require_fa(value.get(fa_key),f'{where}.{fa_key} for {target_key}')
        choices=value.get('choices')
        if isinstance(choices,list) and choices and all(isinstance(x,str) for x in choices):
            if any(needs_translation(x) for x in choices):
                choices_fa=value.get('choicesFa')
                if not isinstance(choices_fa,list) or len(choices_fa)!=len(choices):
                    errors.append(f'{where}.choicesFa: Persian translations must match choices length')
                else:
                    for i,(target,fa) in enumerate(zip(choices,choices_fa)):
                        if needs_translation(target): require_fa(fa,f'{where}.choicesFa[{i}]')
        for k,x in value.items():
            check_activity_payload_pairs(x,f'{where}.{k}')
    elif isinstance(value,list):
        for i,x in enumerate(value): check_activity_payload_pairs(x,f'{where}[{i}]')

def walk(v, where, target_words, is_source=False):
    if isinstance(v,dict):
        for k,x in v.items():
            w=f'{where}.{k}'
            if k in EDITORIAL_KEYS and isinstance(x,str): check_prose(x,w,target_words)
            if k in EDITORIAL_LIST_KEYS and isinstance(x,list):
                for i,item in enumerate(x):
                    if isinstance(item,str): check_prose(item,f'{w}[{i}]',target_words)
            if k=='coverage' and isinstance(x,dict):
                for group,items in x.items():
                    if isinstance(items,list):
                        for i,item in enumerate(items):
                            if isinstance(item,str): check_prose(item,f'{w}.{group}[{i}]',target_words)
            walk(x,w,target_words,is_source)
    elif isinstance(v,list):
        for i,x in enumerate(v): walk(x,f'{where}[{i}]',target_words,is_source)

files=[]
for path in CONTENT.rglob('*.json'):
    data=json.loads(path.read_text(encoding='utf-8')); files.append((path,data))
target_words=set()
for _,data in files:gather_targets(data,target_words)

for path,data in files:
    rel=path.relative_to(ROOT)
    walk(data,str(rel),target_words,'sources' in path.parts)
    if 'sources' in path.parts:
        tf=data.get('titleFa')
        if not isinstance(tf,str) or not FA.search(tf): errors.append(f'{rel}: source titleFa is required and must be Persian')
        if data.get('locator') is not None:
            lf=data.get('locatorFa')
            if not isinstance(lf,str) or not FA.search(lf): errors.append(f'{rel}: locator requires Persian locatorFa')
    if 'lessons' in path.parts and data.get('sourceTitle') is not None:
        sf=data.get('sourceTitleFa')
        if not isinstance(sf,str) or not FA.search(sf): errors.append(f'{rel}: sourceTitle requires Persian sourceTitleFa')
    if 'characters' in path.parts:
        for code in data.get('roles') or []: label('character_role',code,rel)
        for code in data.get('relationshipTags') or []: label('relationship_tag',code,rel)
        vp=data.get('voiceProfile') or {}
        for key,domain in [('clarity','voice_clarity'),('stressLevel','voice_stress_level'),('aggressiveness','voice_aggressiveness'),('toneConsistency','voice_tone_consistency'),('ageImpression','voice_age_impression'),('genderImpression','voice_gender_impression')]:
            if vp.get(key) is not None: label(domain,vp.get(key),f'{rel}:voiceProfile.{key}')
    if 'lessons' in path.parts:
        for act in data.get('activities') or []:
            interaction=(act.get('data') or {}).get('interaction')
            if interaction is not None: label('activity_interaction',interaction,f'{rel}:{act.get("id")}.data.interaction')
            check_activity_payload_pairs(act.get('data') or {},f'{rel}:{act.get("id")}.data')
            if needs_translation(act.get('audioTextTarget')):
                require_fa((act.get('data') or {}).get('audioTextTargetFa'),f'{rel}:{act.get("id")}.data.audioTextTargetFa for audioTextTarget')
    if 'lexeme_forms' in path.parts:
        mapping={'tense':'grammar_feature_tense','mood':'grammar_feature_mood','number':'grammar_feature_number','person':'grammar_feature_person'}
        for k,v in (data.get('features') or {}).items():
            if k not in mapping:
                errors.append(f'{rel}: grammatical feature {k!r} has no localization contract')
            else:
                vals=v if isinstance(v,list) else [v]
                for code in vals: label(mapping[k],code,f'{rel}:features.{k}')

# Content markdown is also durable human-facing project content.
for path in CONTENT.rglob('README.md'):
    text=path.read_text(encoding='utf-8')
    if not FA.search(text): errors.append(f'{path.relative_to(ROOT)}: content README must be Persian')

if errors:
    print('Strict Persian coverage validation failed:')
    print('\n'.join(errors))
    sys.exit(1)
print(f'Strict Persian coverage passed for {len(files)} JSON files, learner-facing activity payloads, and content READMEs.')
