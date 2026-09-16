#!/usr/bin/env python3
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[1]
FA = re.compile(r'[\u0600-\u06FF]')

REPLACEMENTS = [
    ('German Pre-A1', 'سطح پیش از A1 آلمانی'),
    ('text/audio', 'متن/صوت'),
    ('image-free', 'بدون تصویر'),
    ('learner-facing', 'نمایش‌داده‌شده به زبان‌آموز'),
    ('source-backed', 'منبع‌دار'),
    ('descriptorمحور', 'توصیفگرمحور'),
    ('descriptorهای', 'توصیفگرهای'),
    ('descriptor', 'توصیفگر'),
    ('interaction', 'تعامل'),
    ('writing', 'نوشتن'),
    ('listening', 'شنیدن'),
    ('speaking', 'گفتار'),
    ('reading', 'خواندن'),
    ('reception', 'دریافت'),
    ('retrieval', 'بازیابی'),
    ('activity', 'فعالیت'),
    ('gap', 'خلأ'),
    ('starter', 'آغازکننده'),
    ('pipeline', 'فرایند'),
    ('assets', 'فایل‌ها'),
    ('assetها', 'فایل‌ها'),
    ('asset', 'فایل'),
    ('slot', 'جای‌گذاری شخصی'),
    ('lexeme', 'مدخل واژگانی'),
    ('scope', 'دامنه'),
    ('text-only', 'فقط متنی'),
    ('audio', 'صوت'),
    ('final', 'نهایی'),
    ('pending', 'در انتظار تولید'),
    ('review', 'مرور'),
    ('turn', 'نوبت'),
    ('mode', 'شیوه'),
    ('context', 'بافت'),
    ('QA', 'کنترل کیفیت'),
]

EDITORIAL_KEYS = {
    'structureRationale','groupingRationale','activitySelectionRationale','sequenceRationale',
    'selectionReason','scenario','sceneQualityRationale','contextNotes','notes','instructionFa',
    'translationFa','usageNoteFa','titleFa','contextFa','promptFa','descriptionFa','partOfSpeechFa',
    'rationale','conversationVoiceStyle','sourceTitleFa','locatorFa','titleFa'
}
EDITORIAL_LIST_KEYS = {'learningTargets','scopeExclusions','requiredGaps','strengths','remainingWeaknesses'}


def clean_text(text):
    if not isinstance(text, str):
        return text
    out = text
    for old, new in REPLACEMENTS:
        out = re.sub(r'(?<![A-Za-z])' + re.escape(old) + r'(?![A-Za-z])', new, out, flags=re.I)
    return out


def clean_editorial(value, parent_key=None):
    if isinstance(value, dict):
        for k, v in list(value.items()):
            if k in EDITORIAL_KEYS and isinstance(v, str):
                value[k] = clean_text(v)
            elif k in EDITORIAL_LIST_KEYS and isinstance(v, list):
                value[k] = [clean_text(x) if isinstance(x, str) else x for x in v]
            elif k == 'coverage' and isinstance(v, dict):
                for group, items in v.items():
                    if isinstance(items, list):
                        v[group] = [clean_text(x) if isinstance(x, str) else x for x in items]
            else:
                clean_editorial(v, k)
    elif isinstance(value, list):
        for item in value:
            clean_editorial(item, parent_key)


def write_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# Canonical semantic-label expansion.
tax_path = ROOT / 'config/fa-taxonomy.json'
tax = json.loads(tax_path.read_text(encoding='utf-8'))
d = tax['domains']
d.setdefault('character_role', {}).update({
    'learner': 'زبان‌آموز', 'conversation_partner': 'شریک مکالمه'
})
d.setdefault('relationship_tag', {}).update({
    'friend': 'دوست', 'coworker': 'همکار', 'family': 'عضو خانواده', 'stranger': 'ناآشنا', 'classmate': 'هم‌کلاسی'
})
d.setdefault('voice_clarity', {}).update({'high': 'شفافیت بالا'})
d.setdefault('voice_stress_level', {}).update({'low': 'کم', 'very_low': 'بسیار کم'})
d.setdefault('voice_aggressiveness', {}).update({'none': 'بدون لحن تهاجمی'})
d.setdefault('voice_tone_consistency', {}).update({'high': 'بالا', 'medium_high': 'نسبتاً بالا'})
d.setdefault('voice_age_impression', {}).update({
    'child':'کودک','teen':'نوجوان','young_adult':'جوان','adult':'بزرگسال',
    'middle_aged':'میانسال','older_adult':'سالمند','neutral':'خنثی'
})
d.setdefault('voice_gender_impression', {}).update({'female':'زنانه','male':'مردانه','neutral':'خنثی'})
d.setdefault('activity_interaction', {}).update({'read_aloud_exchange':'گفت‌وگوی نوبتیِ خواندن و گفتن'})
d.setdefault('grammar_feature_tense', {}).update({'present':'حال'})
d.setdefault('grammar_feature_mood', {}).update({'indicative':'اخباری','subjunctive_II':'وجه شرطی دوم'})
d.setdefault('grammar_feature_number', {}).update({'singular':'مفرد','plural':'جمع'})
d.setdefault('grammar_feature_person', {}).update({'1':'اول‌شخص','2':'دوم‌شخص','3':'سوم‌شخص'})
write_json(tax_path, tax)

# Current authoring migration.
for path in (ROOT / 'content').rglob('*.json'):
    data = json.loads(path.read_text(encoding='utf-8'))
    clean_editorial(data)
    parts = path.parts
    if 'sources' in parts:
        # Exact bibliographic title/locator remain untouched; Persian companions are mandatory.
        data['titleFa'] = clean_text(data.get('titleFa') or data.get('notes') or 'منبع آموزشی')
        loc = data.get('locator')
        if loc is not None:
            data['locatorFa'] = clean_text(data.get('locatorFa') or (loc if FA.search(loc) else data.get('notes') or 'محل دقیق در منبع'))
        if isinstance(data.get('currencyEvidence'), str):
            data['currencyEvidence'] = clean_text(data['currencyEvidence'])
        if isinstance(data.get('notes'), str):
            data['notes'] = clean_text(data['notes'])
    if 'lessons' in parts:
        if data.get('sourceTitle') is not None:
            data['sourceTitleFa'] = clean_text(data.get('sourceTitleFa') or data.get('titleFa') or 'عنوان فارسی درس')
    if 'characters' in parts:
        vp = data.get('voiceProfile') or {}
        age = vp.get('ageImpression')
        if age == 'young adult':
            vp['ageImpression'] = 'young_adult'
        elif age == 'middle aged':
            vp['ageImpression'] = 'middle_aged'
        elif age == 'older adult':
            vp['ageImpression'] = 'older_adult'
    write_json(path, data)

# Content READMEs are product/content memory and must also be Persian.
readme_de = ROOT / 'content/de/README.md'
if readme_de.exists():
    readme_de.write_text('''# محتوای آلمانی\n\nمحتوای آلمانی به‌صورت پویا و بر اساس نیازهای پوشش آموزشی ساخته می‌شود. هیچ تعداد از پیش تعیین‌شده‌ای برای واحد، درس، فعالیت، نوبت مکالمه یا مرور وجود ندارد.\n\nتولید محتوا از سطح `Pre-A1` و ارتباط‌های مناسب زبان‌آموز کاملاً مبتدی شروع می‌شود. تمام متن آلمانیِ نمایش‌داده‌شده به زبان‌آموز باید به منبع قابل استفاده و قابل ردیابی در `content/de/sources/` متصل باشد.\n''', encoding='utf-8')
readme_level = ROOT / 'content/de/pre-a1/README.md'
if readme_level.exists():
    readme_level.write_text('''# سطح Pre-A1 آلمانی\n\nاین سطح برای زبان‌آموزی طراحی شده که از صفر شروع می‌کند.\n\nمحتوا با ارتباط‌های فوری و قابل‌فهم مانند `Hallo!` و `Guten Morgen!` شروع می‌شود و سپس بر اساس پوشش CEFR، پیشرفت آموزشی، منبع قابل استفاده و کنترل کیفیت گسترش پیدا می‌کند.\n\nهیچ تعداد ثابتی برای درس یا واحد وجود ندارد. این سطح فقط زمانی نهایی می‌شود که ارزیابی پایان سطح نشان دهد خلأ آموزشی مهمی در دامنهٔ فعلی محصول باقی نمانده است.\n''', encoding='utf-8')

# JSON Schemas: direct Persian companions.
source_schema_path = ROOT / 'schemas/source.schema.json'
ss = json.loads(source_schema_path.read_text(encoding='utf-8'))
if 'titleFa' not in ss['required']:
    ss['required'].append('titleFa')
ss['properties']['titleFa'] = {'type':'string','minLength':1,'pattern':'[\\u0600-\\u06FF]','description':'عنوان/برچسب فارسی برای نمایش انسانی منبع.'}
ss['properties']['locatorFa'] = {'type':['string','null'],'minLength':1,'pattern':'[\\u0600-\\u06FF]','description':'توضیح فارسی محل دقیق یا بخش استفاده‌شده از منبع.'}
ss.setdefault('allOf', []).append({
    'if': {'properties': {'locator': {'type':'string'}}, 'required':['locator']},
    'then': {'required':['locatorFa']}
})
write_json(source_schema_path, ss)

lesson_schema_path = ROOT / 'schemas/lesson.schema.json'
ls = json.loads(lesson_schema_path.read_text(encoding='utf-8'))
ls['properties']['sourceTitleFa'] = {'type':['string','null'],'minLength':1,'pattern':'[\\u0600-\\u06FF]','description':'معادل یا برچسب فارسی برای sourceTitle.'}
ls.setdefault('allOf', []).append({
    'if': {'properties': {'sourceTitle': {'type':'string'}}, 'required':['sourceTitle']},
    'then': {'required':['sourceTitleFa']}
})
write_json(lesson_schema_path, ls)

char_schema_path = ROOT / 'schemas/character.schema.json'
cs = json.loads(char_schema_path.read_text(encoding='utf-8'))
cs['properties']['voiceProfile']['properties']['ageImpression'] = {
    'type':['string','null'],
    'enum':['child','teen','young_adult','adult','middle_aged','older_adult','neutral',None]
}
write_json(char_schema_path, cs)

# Permanent strict validator.
validator = r'''#!/usr/bin/env python3
import json, pathlib, re, sys
ROOT = pathlib.Path(__file__).resolve().parents[1]
CONTENT = ROOT / 'content'
FA = re.compile(r'[\u0600-\u06FF]')
LATIN = re.compile(r"[A-Za-z][A-Za-z0-9_-]*")
EDITORIAL_KEYS = {
 'structureRationale','groupingRationale','activitySelectionRationale','sequenceRationale','selectionReason',
 'scenario','sceneQualityRationale','contextNotes','notes','instructionFa','translationFa','usageNoteFa',
 'titleFa','contextFa','promptFa','descriptionFa','partOfSpeechFa','rationale','conversationVoiceStyle',
 'sourceTitleFa','locatorFa','currencyEvidence'
}
EDITORIAL_LIST_KEYS={'learningTargets','scopeExclusions','requiredGaps','strengths','remainingWeaknesses'}
TARGET_KEYS={'surface','lemma','textTarget','sourceText','promptTarget','audioTextTarget','patternTarget','exampleSourceText','blankedText','sourceTitle'}
ALLOWED={'CEFR','MySQL','SQL','JSON','API','URL','ElevenLabs','OGL','CC','BY','SA','Pre','A1','A2','B1','B2','C1','C2','Wikibooks','Wiktionary','Oak','National','Academy','LIBRA','Mia','Iris','Lori','Hope'}
errors=[]
tax=json.loads((ROOT/'config/fa-taxonomy.json').read_text(encoding='utf-8'))['domains']

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
print(f'Strict Persian coverage passed for {len(files)} JSON files and content READMEs.')
'''
(ROOT/'scripts/validate_persian_coverage.py').write_text(validator, encoding='utf-8')

# Strengthen existing source validator.
source_validator_path = ROOT/'scripts/validate_source_localization.py'
source_validator = source_validator_path.read_text(encoding='utf-8')
source_validator = source_validator.replace("    evidence = data.get('currencyEvidence')\n    notes = data.get('notes')", "    evidence = data.get('currencyEvidence')\n    notes = data.get('notes')\n    title_fa = data.get('titleFa')\n    locator = data.get('locator')\n    locator_fa = data.get('locatorFa')")
source_validator = source_validator.replace("    if not isinstance(notes, str) or not notes.strip() or not FA.search(notes):\n        errors.append(f'{path}: notes must be assistant-authored Persian prose')", "    if not isinstance(notes, str) or not notes.strip() or not FA.search(notes):\n        errors.append(f'{path}: notes must be assistant-authored Persian prose')\n    if not isinstance(title_fa, str) or not title_fa.strip() or not FA.search(title_fa):\n        errors.append(f'{path}: titleFa is required and must be Persian')\n    if locator is not None and (not isinstance(locator_fa, str) or not locator_fa.strip() or not FA.search(locator_fa)):\n        errors.append(f'{path}: locator requires locatorFa in Persian')")
source_validator_path.write_text(source_validator, encoding='utf-8')

# MySQL schema companions.
schema_path=ROOT/'database/schema.sql'
schema=schema_path.read_text(encoding='utf-8')
if 'title_fa VARCHAR(500)' not in schema:
    schema=re.sub(r'(CREATE TABLE IF NOT EXISTS sources \(.*?\n\s*title VARCHAR\(500\) NOT NULL,)', r'\1\n  title_fa VARCHAR(500) NULL,', schema, count=1, flags=re.S)
if 'locator_fa VARCHAR(500)' not in schema:
    schema=re.sub(r'(CREATE TABLE IF NOT EXISTS sources \(.*?\n\s*url VARCHAR\([^\n]+\),)', r'\1\n  locator VARCHAR(500) NULL,\n  locator_fa VARCHAR(500) NULL,', schema, count=1, flags=re.S)
    schema=re.sub(r'(CREATE TABLE IF NOT EXISTS source_items \(.*?\n\s*locator VARCHAR\(500\) NULL,)', r'\1\n  locator_fa VARCHAR(500) NULL,', schema, count=1, flags=re.S)
if 'source_title_fa VARCHAR(500)' not in schema:
    schema=re.sub(r'(CREATE TABLE IF NOT EXISTS lessons \(.*?\n\s*source_title VARCHAR\(500\) NULL,)', r'\1\n  source_title_fa VARCHAR(500) NULL,', schema, count=1, flags=re.S)
schema_path.write_text(schema, encoding='utf-8')

# Generate stable-key localization synchronization blocks for every language-level SQL file.
def q(value):
    if value is None: return 'NULL'
    return "'" + str(value).replace('\\','\\\\').replace("'","''") + "'"
def j(value):
    return q(json.dumps(value, ensure_ascii=False, separators=(',',':')))

for sql_path in (ROOT/'database/content').rglob('*.sql'):
    rel=sql_path.relative_to(ROOT/'database/content')
    if len(rel.parts) < 2: continue
    lang=rel.parts[0]
    level_slug=sql_path.stem
    level_dir=ROOT/'content'/lang/level_slug
    level_path=level_dir/'level.json'
    if not level_path.exists(): continue
    level=json.loads(level_path.read_text(encoding='utf-8'))
    sources={}
    for p in (ROOT/'content'/lang/'sources').glob('*.json'):
        x=json.loads(p.read_text(encoding='utf-8')); sources[x['id']]=x
    lessons={}
    for p in (level_dir/'lessons').glob('*.json'):
        x=json.loads(p.read_text(encoding='utf-8')); lessons[x['id']]=x
    units={}
    for p in (level_dir/'units').glob('*.json'):
        x=json.loads(p.read_text(encoding='utf-8')); units[x['id']]=x
    dialogues={}
    for p in (level_dir/'dialogues').glob('*.json'):
        x=json.loads(p.read_text(encoding='utf-8')); dialogues[x['id']]=x
    characters={}
    for p in (ROOT/'content'/lang/'characters').glob('*.json'):
        x=json.loads(p.read_text(encoding='utf-8')); characters[x['id']]=x
    forms={}
    for p in (ROOT/'content'/lang/'lexeme_forms').glob('*.json'):
        x=json.loads(p.read_text(encoding='utf-8')); forms[x['id']]=x
    marker='-- BEGIN GENERATED PERSIAN LOCALIZATION SYNC'
    text=sql_path.read_text(encoding='utf-8')
    if marker in text: text=text.split(marker)[0].rstrip()+"\n"
    lines=['',marker,'START TRANSACTION;']
    for sid in level.get('sourceRefs') or []:
        s=sources.get(sid)
        if not s: continue
        lines.append(f"UPDATE sources SET title_fa={q(s.get('titleFa'))}, locator={q(s.get('locator'))}, locator_fa={q(s.get('locatorFa'))}, currency_evidence={q(s.get('currencyEvidence'))}, notes={q(s.get('notes'))} WHERE source_key={q(sid)};")
    lines.append(f"UPDATE source_items si JOIN sources s ON s.id=si.source_id SET si.locator_fa=si.notes WHERE s.language_code={q(lang)} AND si.locator IS NOT NULL;")
    lines.append(f"UPDATE language_levels ll JOIN languages la ON la.id=ll.language_id SET ll.status={q(level.get('status'))}, ll.audio_status={q(level.get('audioStatus'))}, ll.structure_rationale={q(level.get('structureRationale'))}, ll.coverage=CAST({j(level.get('coverage'))} AS JSON), ll.completion_assessment=CAST({j(level.get('completionAssessment'))} AS JSON), ll.notes={q(level.get('notes'))} WHERE la.code={q(lang)} AND ll.cefr_level={q(level.get('level'))};")
    for uid in level.get('unitRefs') or []:
        u=units.get(uid)
        if u: lines.append(f"UPDATE units SET title_fa={q(u.get('titleFa'))}, grouping_rationale={q(u.get('groupingRationale'))}, status={q(u.get('status'))}, notes={q(u.get('notes'))} WHERE unit_key={q(uid)};")
    for lid in level.get('lessonRefs') or []:
        l=lessons.get(lid)
        if not l: continue
        design=l.get('activityDesign') or {}
        lines.append(f"UPDATE lessons SET title_fa={q(l.get('titleFa'))}, source_title={q(l.get('sourceTitle'))}, source_title_fa={q(l.get('sourceTitleFa'))}, status={q(l.get('status'))}, activity_selection_rationale={q(design.get('activitySelectionRationale'))}, sequence_rationale={q(design.get('sequenceRationale'))}, template_signature={q(design.get('templateSignature'))}, audio_status={q(l.get('audioStatus'))} WHERE lesson_key={q(lid)};")
        for a in l.get('activities') or []:
            lines.append(f"UPDATE activities SET instruction_fa={q(a.get('instructionFa'))}, selection_reason={q(a.get('selectionReason'))}, audio_status={q(a.get('audioStatus'))}, audio_text_target={q(a.get('audioTextTarget'))} WHERE activity_key={q(a.get('id'))};")
    for did,dg in dialogues.items():
        if any((a.get('dialogueRef')==did) for l in lessons.values() for a in l.get('activities',[])):
            lines.append(f"UPDATE dialogues SET scenario={q(dg.get('scenario'))}, opening_initiator={q(dg.get('openingInitiator'))}, scene_quality_rationale={q(dg.get('sceneQualityRationale'))} WHERE dialogue_key={q(did)};")
    for cid,c in characters.items():
        lines.append(f"UPDATE characters SET roles=CAST({j(c.get('roles') or [])} AS JSON), relationship_tags=CAST({j(c.get('relationshipTags') or [])} AS JSON), context_notes={q(c.get('contextNotes'))}, voice_profile=CAST({j(c.get('voiceProfile') or {})} AS JSON) WHERE character_key={q(cid)};")
    for fid,f in forms.items():
        lines.append(f"UPDATE lexeme_forms SET features=CAST({j(f.get('features') or {})} AS JSON), notes={q(f.get('notes'))} WHERE lexeme_form_key={q(fid)};")
    lines += ['COMMIT;','-- END GENERATED PERSIAN LOCALIZATION SYNC','']
    sql_path.write_text(text+'\n'.join(lines), encoding='utf-8')

# MySQL QA: companion columns and their Persian values must exist.
mysql_path=ROOT/'scripts/validate_mysql_content.sh'
mysql=mysql_path.read_text(encoding='utf-8')
if 'invalid_persian_companions=' not in mysql:
    extra=r'''
invalid_persian_companions="$(compact_query "SELECT (SELECT COUNT(*) FROM sources WHERE title_fa IS NULL OR title_fa='') + (SELECT COUNT(*) FROM sources WHERE locator IS NOT NULL AND (locator_fa IS NULL OR locator_fa='')) + (SELECT COUNT(*) FROM source_items WHERE locator IS NOT NULL AND (locator_fa IS NULL OR locator_fa='')) + (SELECT COUNT(*) FROM lessons WHERE source_title IS NOT NULL AND (source_title_fa IS NULL OR source_title_fa=''));")"
echo "invalid Persian companion fields=$invalid_persian_companions"
test "$invalid_persian_companions" = "0"
mysql_cmd -e "SELECT HEX(txt) FROM (SELECT title_fa txt FROM sources UNION ALL SELECT locator_fa FROM sources WHERE locator_fa IS NOT NULL UNION ALL SELECT locator_fa FROM source_items WHERE locator_fa IS NOT NULL UNION ALL SELECT source_title_fa FROM lessons WHERE source_title_fa IS NOT NULL) x;" > /tmp/persian_companion_hex.tsv
python - <<'PY'
import pathlib,re,sys
fa=re.compile(r'[\u0600-\u06FF]')
bad=[]
for raw in pathlib.Path('/tmp/persian_companion_hex.tsv').read_text(encoding='ascii').splitlines():
    raw=raw.strip()
    if raw:
        text=bytes.fromhex(raw).decode('utf-8')
        if not fa.search(text): bad.append(text)
if bad:
    print('Non-Persian companion fields in MySQL:'); print('\n'.join(bad)); sys.exit(1)
print('MySQL Persian companion-field check passed.')
PY
'''
    mysql=mysql.replace('echo "Cross-language MySQL validation passed."',extra+'\necho "Cross-language MySQL validation passed."')
    # Include companion fields in the existing prose audit too.
    mysql=mysql.replace('    SELECT currency_evidence FROM sources', '    SELECT title_fa FROM sources\n    UNION ALL SELECT locator_fa FROM sources WHERE locator_fa IS NOT NULL\n    UNION ALL SELECT currency_evidence FROM sources')
    mysql=mysql.replace('    UNION ALL SELECT notes FROM source_items WHERE notes IS NOT NULL', '    UNION ALL SELECT notes FROM source_items WHERE notes IS NOT NULL\n    UNION ALL SELECT locator_fa FROM source_items WHERE locator_fa IS NOT NULL')
    mysql=mysql.replace('    UNION ALL SELECT title_fa FROM lessons', '    UNION ALL SELECT title_fa FROM lessons\n    UNION ALL SELECT source_title_fa FROM lessons WHERE source_title_fa IS NOT NULL')
    mysql_path.write_text(mysql, encoding='utf-8')

# Durable policy text.
policy_path=ROOT/'docs/LOCALIZATION_POLICY.md'
policy=policy_path.read_text(encoding='utf-8')
section='''\n\n## Strict Persian coverage\n- A Persian field is not valid merely because it contains one Persian character; untranslated English prose/jargon mixed into assistant-authored Persian text is a QA failure.\n- Exact target-language strings, official names and standardized identifiers may remain in their original form, but human-facing companions must be Persian.\n- `sourceTitle` requires `sourceTitleFa`; source `title` has `titleFa`; source `locator` requires `locatorFa`.\n- Character roles, voice-profile values, activity interaction modes and grammatical feature values are semantic codes and must resolve through the canonical Persian taxonomy.\n- Content README files under `content/` are Persian durable project/content memory.\n'''
if '## Strict Persian coverage' not in policy: policy_path.write_text(policy.rstrip()+section+'\n',encoding='utf-8')
qa_path=ROOT/'docs/QA_RULES.md'; qa=qa_path.read_text(encoding='utf-8')
if 'mixed untranslated English jargon' not in qa:
    qa=qa.replace('- authored learner/curriculum/editorial prose that should be Persian is English-only;', '- authored learner/curriculum/editorial prose that should be Persian is English-only;\n- mixed untranslated English jargon remains inside assistant-authored Persian prose;\n- source/lesson human-readable original-language fields lack their required Persian companion;')
    qa_path.write_text(qa,encoding='utf-8')

print('Persian coverage migration completed.')
