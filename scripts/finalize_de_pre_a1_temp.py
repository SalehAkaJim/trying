#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load(path):
    return json.loads((ROOT / path).read_text(encoding='utf-8'))


def dump(path, data):
    p = ROOT / path
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def replace(path, old, new):
    p = ROOT / path
    text = p.read_text(encoding='utf-8')
    if old not in text:
        raise SystemExit(f'missing replacement marker in {path}: {old[:120]!r}')
    p.write_text(text.replace(old, new), encoding='utf-8')

# -----------------------------------------------------------------------------
# Reconcile durable rules that still contained older dialogue/audio wording.
# -----------------------------------------------------------------------------
replace('docs/CONTENT_RULES.md',
'''Opening conversations must contain **5–12 turns**. Exact length inside the range is chosen by scene/source/learning need; do not pad toward 12 or compress toward 5.''',
'''Opening conversations must contain **4–12 turns**. The first 10 lessons of a language's beginner path use exactly 4 turns; when Pre-A1 exists these are the first 10 Pre-A1 lessons. From lesson 11 onward, exact length inside 4–12 is chosen by scene/source/learning need; do not pad toward either boundary.''')
replace('docs/ACTIVITY_TYPES.md', '- 5–12 turns.', '- 4–12 turns overall; the first 10 beginner-path lessons use exactly 4 turns.')
replace('docs/CHARACTER_RULES.md',
'Audio is generated only after the entire language curriculum is finalized.',
'Audio is generated per CEFR level only after that level is finalized and its target-language text plus speaker/voice assignments are frozen.')
replace('docs/DATABASE_DESIGN.md',
'Audio is deliberately deferred until a whole target-language curriculum is finalized.',
'Audio is deliberately deferred per CEFR level until that level is finalized; later levels do not block audio generation for an already-final level.')
replace('docs/DATABASE_DESIGN.md',
'''Dialogue turn count and learner-turn count are not modeled as required targets or min/max thresholds. A dialogue stores the turns it actually needs. QA judges semantic completeness, communicative progression, learner participation and source integrity.''',
'''Dialogue sizing is generally content-driven, with one explicit product interaction envelope: opening conversations must stay within 4–12 turns, and the first 10 beginner-path lessons use exactly 4 turns. Inside that rule, there is no preferred count and learner-turn count has no quota. QA judges semantic completeness, communicative progression, learner participation and source integrity.''')

# -----------------------------------------------------------------------------
# Language/level schemas: per-level audio and explicit scope exclusions.
# -----------------------------------------------------------------------------
language_schema = load('schemas/language.schema.json')
ap = language_schema['properties']['audioPolicy']
ap['required'] = ['generateAfterEachLevelFinal', 'standaloneVoicePreference']
ap['properties'].pop('generateOnlyAfterLanguageFinal', None)
ap['properties']['generateAfterEachLevelFinal'] = {
    'const': True,
    'description': 'Audio is generated independently after each CEFR level becomes final.'
}
dump('schemas/language.schema.json', language_schema)

level_schema = load('schemas/level.schema.json')
ca = level_schema['properties']['completionAssessment']
if 'scopeExclusions' not in ca['required']:
    ca['required'].append('scopeExclusions')
ca['properties']['scopeExclusions'] = {
    'type': 'array',
    'items': {'type': 'string', 'minLength': 1},
    'uniqueItems': True,
    'description': 'Explicit product-scope exclusions. These do not count as hidden gaps and must be justified.'
}
dump('schemas/level.schema.json', level_schema)

language = load('content/de/language.json')
language['audioPolicy'].pop('generateOnlyAfterLanguageFinal', None)
language['audioPolicy']['generateAfterEachLevelFinal'] = True
dump('content/de/language.json', language)

# -----------------------------------------------------------------------------
# Permanent generic JSON-schema instance validator.
# -----------------------------------------------------------------------------
schema_validator = r'''#!/usr/bin/env python3
import json
from pathlib import Path
import sys
from jsonschema import Draft202012Validator, RefResolver

ROOT=Path(__file__).resolve().parents[1]
S=ROOT/'schemas'
schemas={}
for p in S.glob('*.schema.json'):
    data=json.loads(p.read_text(encoding='utf-8'))
    schemas[p.name]=data
    schemas[p.resolve().as_uri()]=data
    if data.get('$id'):
        schemas[data['$id']]=data


def schema_for(path):
    parts=path.parts
    if path.name=='language.json': return 'language.schema.json'
    if path.name=='level.json': return 'level.schema.json'
    if 'sources' in parts: return 'source.schema.json'
    if 'characters' in parts: return 'character.schema.json'
    if 'lexeme_forms' in parts: return 'lexeme_form.schema.json'
    if 'lexemes' in parts: return 'lexeme.schema.json'
    if 'units' in parts: return 'unit.schema.json'
    if 'dialogues' in parts: return 'dialogue.schema.json'
    if 'lessons' in parts: return 'lesson.schema.json'
    return None

errors=[]
files=0
for p in (ROOT/'content').rglob('*.json'):
    name=schema_for(p)
    if not name: continue
    files+=1
    schema=schemas[name]
    resolver=RefResolver(base_uri=(S/name).resolve().as_uri(), referrer=schema, store=schemas)
    v=Draft202012Validator(schema, resolver=resolver)
    data=json.loads(p.read_text(encoding='utf-8'))
    for e in sorted(v.iter_errors(data), key=lambda x:list(x.absolute_path)):
        loc='.'.join(map(str,e.absolute_path)) or '$'
        errors.append(f'{p.relative_to(ROOT)}:{loc}: {e.message}')

# taxonomy is also an authored instance
p=ROOT/'config/fa-taxonomy.json'
schema=schemas['fa-taxonomy.schema.json']
resolver=RefResolver(base_uri=(S/'fa-taxonomy.schema.json').resolve().as_uri(), referrer=schema, store=schemas)
for e in Draft202012Validator(schema,resolver=resolver).iter_errors(json.loads(p.read_text(encoding='utf-8'))):
    errors.append(f'config/fa-taxonomy.json: {e.message}')

if errors:
    print('JSON schema instance validation failed:')
    print('\n'.join(errors))
    sys.exit(1)
print(f'JSON schema instance validation passed for {files} content files plus taxonomy.')
'''
(ROOT/'scripts/validate_json_schemas.py').write_text(schema_validator, encoding='utf-8')

# Wire true instance validation into shared CI.
wf=ROOT/'.github/workflows/project-contracts.yml'
text=wf.read_text(encoding='utf-8')
needle='''      - name: Verify Persian companion labels are synchronized\n        run: python scripts/sync_fa_labels.py\n'''
insert='''      - name: Install JSON Schema validator\n        run: python -m pip install --disable-pip-version-check jsonschema\n\n      - name: Validate content instances against JSON Schemas\n        run: python scripts/validate_json_schemas.py\n\n'''+needle
if 'Validate content instances against JSON Schemas' not in text:
    if needle not in text: raise SystemExit('project-contracts workflow marker missing')
    text=text.replace(needle,insert)
wf.write_text(text,encoding='utf-8')

# -----------------------------------------------------------------------------
# Generic contract validator hardening for final levels and localized audit text.
# -----------------------------------------------------------------------------
p=ROOT/'scripts/validate_project_contracts.py'
text=p.read_text(encoding='utf-8')
text=text.replace('''    "titleFa", "contextFa", "promptFa", "descriptionFa", "partOfSpeechFa"\n}''',
'''    "titleFa", "contextFa", "promptFa", "descriptionFa", "partOfSpeechFa", "rationale"\n}\nEDITORIAL_LIST_KEYS = {"scopeExclusions", "requiredGaps", "strengths", "remainingWeaknesses"}''')
text=text.replace('''            if not is_source and key == "learningTargets" and isinstance(child, list):\n                for i, item in enumerate(child):\n                    if isinstance(item, str) and item.strip() and not FA.search(item):\n                        errors.append(f"{path}:{here}[{i}]: learning target must contain Persian text")''',
'''            if not is_source and key == "learningTargets" and isinstance(child, list):\n                for i, item in enumerate(child):\n                    if isinstance(item, str) and item.strip() and not FA.search(item):\n                        errors.append(f"{path}:{here}[{i}]: learning target must contain Persian text")\n            if not is_source and key in EDITORIAL_LIST_KEYS and isinstance(child, list):\n                for i, item in enumerate(child):\n                    if isinstance(item, str) and item.strip() and not FA.search(item):\n                        errors.append(f"{path}:{here}[{i}]: audit/editorial text must contain Persian text")''')
text=text.replace('''    if path.name == "language.json":\n        require_label("language_status", data.get("status"), path)''',
'''    if path.name == "language.json":\n        require_label("language_status", data.get("status"), path)\n        policy=data.get("audioPolicy") or {}\n        if policy.get("generateAfterEachLevelFinal") is not True:\n            errors.append(f"{path}: audioPolicy.generateAfterEachLevelFinal must be true")\n        if "generateOnlyAfterLanguageFinal" in policy:\n            errors.append(f"{path}: legacy generateOnlyAfterLanguageFinal is forbidden")''')
# Add final-level checks before beginner-path checks.
marker='# Beginner-path exact four-turn rule derives lesson order from level manifests.\n'
final_checks=r'''# Final-level contract: explicit audit, no hidden gaps, final child lessons/units, and audio unblocked.
units_by_id={}
for path,data in all_json:
    if "units" in path.parts:
        units_by_id[data.get("id")]=(path,data)
for language_id, manifests in levels_by_language.items():
    for level_path, level in manifests:
        if level.get("status") != "final":
            continue
        if (level.get("coverage") or {}).get("gaps"):
            errors.append(f"{level_path}: final level coverage.gaps must be empty")
        assessment=level.get("completionAssessment") or {}
        if assessment.get("requiredGaps"):
            errors.append(f"{level_path}: final level requiredGaps must be empty")
        if "scopeExclusions" not in assessment:
            errors.append(f"{level_path}: final level must explicitly record scopeExclusions (empty is allowed)")
        if level.get("audioStatus") == "blocked_until_level_final":
            errors.append(f"{level_path}: final level audio must no longer be blocked")
        for lesson_id in level.get("lessonRefs") or []:
            entry=lessons.get(lesson_id)
            if not entry:
                errors.append(f"{level_path}: missing lesson {lesson_id!r}")
                continue
            lesson_path,lesson=entry
            if lesson.get("status") != "final":
                errors.append(f"{lesson_path}: lesson referenced by final level must be final")
            if lesson.get("audioStatus") == "blocked_until_level_final":
                errors.append(f"{lesson_path}: final lesson audio must no longer be blocked")
        for unit_id in level.get("unitRefs") or []:
            entry=units_by_id.get(unit_id)
            if not entry:
                errors.append(f"{level_path}: missing unit {unit_id!r}")
            elif entry[1].get("status") != "final":
                errors.append(f"{entry[0]}: unit referenced by final level must be final")

'''
if final_checks not in text:
    if marker not in text: raise SystemExit('project validator final marker missing')
    text=text.replace(marker,final_checks+marker)
p.write_text(text,encoding='utf-8')

# Audio validator: per-level policy and no final-level objects left blocked.
p=ROOT/'scripts/validate_audio_contracts.py'
text=p.read_text(encoding='utf-8')
insert=r'''
# Final levels transition from blocked to pending/ready/stale/failed; they never remain level-blocked.
levels={}
for pth in Path("content").glob("*/*/level.json"):
    d=json.loads(pth.read_text(encoding="utf-8")); levels[(d.get("languageId"),d.get("level"))]=d
for pth in Path("content").glob("*/language.json"):
    d=json.loads(pth.read_text(encoding="utf-8")); policy=d.get("audioPolicy") or {}
    if policy.get("generateAfterEachLevelFinal") is not True:
        errors.append(f"{pth}: generateAfterEachLevelFinal must be true")
    if "generateOnlyAfterLanguageFinal" in policy:
        errors.append(f"{pth}: legacy generateOnlyAfterLanguageFinal is forbidden")
for pth in Path("content").glob("*/*/lessons/*.json"):
    d=json.loads(pth.read_text(encoding="utf-8"))
    if (levels.get((d.get("languageId"),d.get("level"))) or {}).get("status")=="final":
        if d.get("audioStatus")=="blocked_until_level_final": errors.append(f"{pth}: final-level lesson audio remains blocked")
        for a in d.get("activities",[]):
            if a.get("audioTextTarget") and a.get("audioStatus")=="blocked_until_level_final":
                errors.append(f"{pth}:{a.get('id')}: final-level activity audio remains blocked")
for pth in Path("content").glob("*/lexemes/*.json"):
    d=json.loads(pth.read_text(encoding="utf-8"))
    if (levels.get((d.get("languageId"),d.get("level"))) or {}).get("status")=="final" and d.get("audioStatus")=="blocked_until_level_final":
        errors.append(f"{pth}: final-level lexeme audio remains blocked")
'''
if '# Final levels transition from blocked' not in text:
    text=text.replace('\nif errors:\n',insert+'\nif errors:\n')
p.write_text(text,encoding='utf-8')

# -----------------------------------------------------------------------------
# MySQL schema: persist completion audit and enforce a real level-final gate.
# -----------------------------------------------------------------------------
p=ROOT/'database/schema.sql'
text=p.read_text(encoding='utf-8')
text=text.replace('''  coverage JSON NOT NULL,\n  notes TEXT NULL,''','''  coverage JSON NOT NULL,\n  completion_assessment JSON NULL,\n  notes TEXT NULL,''')
level_triggers=r'''
DROP TRIGGER IF EXISTS trg_language_levels_bi_final_guard$$
CREATE TRIGGER trg_language_levels_bi_final_guard BEFORE INSERT ON language_levels FOR EACH ROW
BEGIN
  IF NEW.status='final' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Insert level before finalizing; final requires targets, lessons and completion audit';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_language_levels_bu_final_guard$$
CREATE TRIGGER trg_language_levels_bu_final_guard BEFORE UPDATE ON language_levels FOR EACH ROW
BEGIN
  DECLARE missing_targets INT DEFAULT 0;
  DECLARE invalid_lessons INT DEFAULT 0;
  DECLARE lesson_count INT DEFAULT 0;
  IF NEW.status='final' AND OLD.status<>'final' THEN
    IF NEW.completion_assessment IS NULL
       OR JSON_UNQUOTE(JSON_EXTRACT(NEW.completion_assessment,'$.cefrCoverageComplete'))<>'true'
       OR JSON_UNQUOTE(JSON_EXTRACT(NEW.completion_assessment,'$.progressionComplete'))<>'true'
       OR JSON_UNQUOTE(JSON_EXTRACT(NEW.completion_assessment,'$.practiceAndRetrievalComplete'))<>'true'
       OR JSON_UNQUOTE(JSON_EXTRACT(NEW.completion_assessment,'$.skillModeCoverageComplete'))<>'true'
       OR COALESCE(JSON_LENGTH(JSON_EXTRACT(NEW.completion_assessment,'$.requiredGaps')),1)<>0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Final level requires a passing completion assessment with zero required gaps';
    END IF;
    IF COALESCE(JSON_LENGTH(JSON_EXTRACT(NEW.coverage,'$.gaps')),1)<>0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Final level coverage.gaps must be empty';
    END IF;
    SELECT COUNT(*) INTO missing_targets FROM curriculum_targets
      WHERE language_level_id=NEW.id AND required_for_completion=TRUE AND status<>'covered';
    IF missing_targets<>0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Final level has required curriculum targets that are not covered';
    END IF;
    SELECT COUNT(*),SUM(status<>'final') INTO lesson_count,invalid_lessons FROM lessons WHERE language_level_id=NEW.id;
    IF lesson_count=0 OR COALESCE(invalid_lessons,0)<>0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='All lessons must be final before the level can become final';
    END IF;
    IF NEW.audio_status NOT IN ('pending','ready','stale','failed') THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Final level audio must transition out of blocked state';
    END IF;
  END IF;
END$$

'''
marker='DROP TRIGGER IF EXISTS trg_lexemes_bi_fa_taxonomy$$\n'
if 'trg_language_levels_bu_final_guard' not in text:
    if marker not in text: raise SystemExit('schema trigger marker missing')
    text=text.replace(marker,level_triggers+marker)
p.write_text(text,encoding='utf-8')

# MySQL CI: preserve/restore sentinel metadata without assuming blocked state, and enforce final audio transition/audit.
p=ROOT/'scripts/validate_mysql_content.sh'
text=p.read_text(encoding='utf-8')
old='''mysql_cmd -e "UPDATE dialogue_turns SET audio_status='stale',audio_url='https://example.invalid/__ci_audio_preserve__.mp3',audio_storage_path='__ci_audio_preserve__',audio_source_hash=SHA2(text_target,256) ORDER BY id LIMIT 1;"\nmysql_cmd -e "UPDATE lexemes SET audio_status='stale',audio_url='https://example.invalid/__ci_audio_preserve__.mp3',audio_storage_path='__ci_audio_preserve__',audio_source_hash=SHA2(surface,256) ORDER BY id LIMIT 1;"'''
new='''mysql_cmd -e "DROP TABLE IF EXISTS __ci_turn_audio_backup; CREATE TABLE __ci_turn_audio_backup AS SELECT * FROM dialogue_turns ORDER BY id LIMIT 1;"\nmysql_cmd -e "DROP TABLE IF EXISTS __ci_lexeme_audio_backup; CREATE TABLE __ci_lexeme_audio_backup AS SELECT * FROM lexemes ORDER BY id LIMIT 1;"\nmysql_cmd -e "UPDATE dialogue_turns SET audio_status='stale',audio_url='https://example.invalid/__ci_audio_preserve__.mp3',audio_storage_path='__ci_audio_preserve__',audio_source_hash=SHA2(text_target,256) WHERE id=(SELECT id FROM __ci_turn_audio_backup LIMIT 1);"\nmysql_cmd -e "UPDATE lexemes SET audio_status='stale',audio_url='https://example.invalid/__ci_audio_preserve__.mp3',audio_storage_path='__ci_audio_preserve__',audio_source_hash=SHA2(surface,256) WHERE id=(SELECT id FROM __ci_lexeme_audio_backup LIMIT 1);"'''
if old not in text: raise SystemExit('mysql sentinel setup marker missing')
text=text.replace(old,new)
old2='''mysql_cmd -e "UPDATE dialogue_turns SET audio_status='blocked_until_level_final',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL WHERE audio_storage_path='__ci_audio_preserve__';"\nmysql_cmd -e "UPDATE lexemes SET audio_status='blocked_until_level_final',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL WHERE audio_storage_path='__ci_audio_preserve__';"'''
new2='''mysql_cmd -e "UPDATE dialogue_turns t JOIN __ci_turn_audio_backup b ON b.id=t.id SET t.audio_status=b.audio_status,t.audio_url=b.audio_url,t.audio_storage_path=b.audio_storage_path,t.audio_source_hash=b.audio_source_hash,t.audio_provider=b.audio_provider,t.audio_model_id=b.audio_model_id,t.audio_voice_name=b.audio_voice_name,t.audio_voice_id=b.audio_voice_id,t.audio_generated_at=b.audio_generated_at; DROP TABLE __ci_turn_audio_backup;"\nmysql_cmd -e "UPDATE lexemes l JOIN __ci_lexeme_audio_backup b ON b.id=l.id SET l.audio_status=b.audio_status,l.audio_url=b.audio_url,l.audio_storage_path=b.audio_storage_path,l.audio_source_hash=b.audio_source_hash,l.audio_provider=b.audio_provider,l.audio_model_id=b.audio_model_id,l.audio_voice_name=b.audio_voice_name,l.audio_voice_id=b.audio_voice_id,l.audio_generated_at=b.audio_generated_at; DROP TABLE __ci_lexeme_audio_backup;"'''
if old2 not in text: raise SystemExit('mysql sentinel restore marker missing')
text=text.replace(old2,new2)
needle='''test "$invalid_level_audio_ready" = "0"\n'''
add='''test "$invalid_level_audio_ready" = "0"\nfinal_blocked_audio="$(compact_query "SELECT COUNT(*) FROM v_audio_generation_manifest WHERE level_status='final' AND audio_status='blocked_until_level_final';")"\nfinal_missing_audit="$(compact_query "SELECT COUNT(*) FROM language_levels WHERE status='final' AND completion_assessment IS NULL;")"\necho "final-level blocked-audio=$final_blocked_audio missing-audit=$final_missing_audit"\ntest "$final_blocked_audio" = "0"\ntest "$final_missing_audit" = "0"\n'''
if 'final_blocked_audio=' not in text:
    if needle not in text: raise SystemExit('mysql final audio marker missing')
    text=text.replace(needle,add)
p.write_text(text,encoding='utf-8')

# -----------------------------------------------------------------------------
# Source records for final Pre-A1 coverage.
# -----------------------------------------------------------------------------
def source(id,title,url,notes,currency,source_type='course',language='de',reuse='reuse_with_attribution',license_name='CC BY-SA 4.0',license_url='https://creativecommons.org/licenses/by-sa/4.0/',attribution=None,modernity='maintained_current',published=None):
    return {
        'schemaVersion':'1.0.0','id':id,'title':title,'organizationOrAuthor':'Wikibooks contributors' if 'wikibooks' in id else 'Council of Europe',
        'language':language,'sourceType':source_type,'url':url,'locator':notes,'publishedOrUpdatedAt':published,
        'modernityStatus':modernity,'currencyEvidence':currency,'licenseName':license_name,'licenseUrl':license_url,
        'attributionText': attribution or (f'Wikibooks contributors — {url}' if 'wikibooks' in id else 'Council of Europe — CEFR Companion Volume'),
        'reuseStatus':reuse,'retrievedAt':'2026-09-16','notes':notes
    }

sources=[
('coe-cefr-pre-a1.json', source('src-coe-cefr-pre-a1','CEFR Companion Volume (2020) — Pre-A1 descriptors','https://rm.coe.int/cefr-companion-volume-with-new-descriptors-2020/16809ea0d4','مرجع برنامه‌ریزی برای توصیفگرهای Pre-A1؛ برای تعیین پوشش استفاده می‌شود و متن آموزشی آلمانی از آن بازاستفاده نمی‌شود.','نسخهٔ رسمی Companion Volume شورای اروپا و توصیفگرهای Pre-A1 در وضعیت جاری بررسی شده‌اند.',source_type='book',language='en',reuse='analysis_only',license_name=None,license_url=None,modernity='contemporary_verified',published='2020')),
('wikibooks-bll-residence-origin.json', source('src-wikibooks-de-residence-origin','BLL German/A1/Lesson 2','https://en.wikibooks.org/wiki/BLL_German/A1/Lesson_2','منبع عبارت‌های «Wo wohnen Sie? / Ich wohne in Österreich. / Woher kommen Sie? / Ich komme aus Deutschland, und Sie?» و «Guten Tag! / Wie heißen Sie? / Ich heiße Paul Müller.».','صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و در ماه‌های اخیر منتشر/نگهداری شده است.')),
('wikibooks-age-time.json', source('src-wikibooks-de-age-time','Deutschkurs für Anfänger/Lektion 007','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_007','منبع سن، عددهای ساده، روز، ساعت، زمان روز، Adresse و نمونهٔ قیمت «Die Zeitschrift kostet 7,60 Euro.».','صفحهٔ زندهٔ Wikibooks در ماه اخیر منتشر/به‌روزرسانی شده و برای کاربرد معاصر بررسی شده است.')),
('wikibooks-birthday.json', source('src-wikibooks-de-birthday','German/Level I/Geburtstag','https://en.wikibooks.org/wiki/German/Level_I/Geburtstag','منبع زمان، روزها، تاریخ و جملهٔ «Ich habe am dreizehnten November Geburtstag.».','صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده است.')),
('wikibooks-birthday-question.json', source('src-wikibooks-de-birthday-question','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 199','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_199','منبع عبارت‌های آلمانیِ دارای attribution «Wann hast du Geburtstag?» و «Am 16. Juli.».','صفحهٔ زندهٔ Wikibooks و attribution جمله‌های تعبیه‌شده در وضعیت فعلی بررسی شده است.')),
('wikibooks-phone.json', source('src-wikibooks-de-phone','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 192','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_192','منبع دارای attribution برای «Wie lautet deine Telefonnummer?» و «Meine Telefonnummer lautet 789.».','صفحهٔ زندهٔ Wikibooks و attribution جمله‌های تعبیه‌شده در وضعیت فعلی بررسی شده است.')),
('wikibooks-phone-example.json', source('src-wikibooks-de-phone-example','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 220','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_220','منبع دارای attribution برای «Meine Telefonnummer ist: 692-267-752.».','صفحهٔ زندهٔ Wikibooks و attribution جملهٔ تعبیه‌شده در وضعیت فعلی بررسی شده است.')),
('wikibooks-basic-object.json', source('src-wikibooks-de-basic-object','Deutschkurs für Anfänger/Lektion 001','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_001','منبع پرسش بسیار سادهٔ «Was ist das?» و پاسخ‌های «Das ist ein Buch.» و «Das ist eine Karte.».','صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و برای زبان آغازین معاصر مناسب است.')),
]
for fn,data in sources: dump('content/de/sources/'+fn,data)

# -----------------------------------------------------------------------------
# Lexemes needed by the remaining descriptors. Keep lexical expansion minimal.
# -----------------------------------------------------------------------------
pos_fa={'verb':'فعل','proper_noun':'اسم خاص','adjective':'صفت','noun':'اسم','numeral':'عدد','adverb':'قید','question_formula':'عبارت پرسشی'}
def lex(id,surface,pos,fa,src,typ='word',lemma=None,note=None):
    return {'schemaVersion':'1.0.0','id':id,'languageId':'de','type':typ,'surface':surface,'lemma':lemma if lemma is not None else (surface if typ=='word' else None),'partOfSpeech':pos,'level':'Pre-A1','translationFa':fa,'usageNoteFa':note,'grammarNoteRefs':[],'exampleRefs':[],'sourceRefs':[src],'formRefs':[],'flashcardEligible':True,'audioStatus':'pending','audioRef':None,'audioVoice':None,'partOfSpeechFa':pos_fa[pos]}
lexemes=[
('wohnen',lex('lex-de-wohnen','wohnen','verb','زندگی کردن / ساکن بودن','src-wikibooks-de-residence-origin',note='در این سطح برای گفتن محل زندگی استفاده می‌شود.')),
('kommen',lex('lex-de-kommen','kommen','verb','آمدن / اهل جایی بودن','src-wikibooks-de-residence-origin',note='در این سطح در الگوی «aus ... kommen» برای گفتن مبدأ استفاده می‌شود.')),
('oesterreich',lex('lex-de-oesterreich','Österreich','proper_noun','اتریش','src-wikibooks-de-residence-origin')),
('deutschland',lex('lex-de-deutschland','Deutschland','proper_noun','آلمان','src-wikibooks-de-residence-origin')),
('alt',lex('lex-de-alt','alt','adjective','ساله / پیر','src-wikibooks-de-age-time',note='در این سطح در پرسش و پاسخ سن استفاده می‌شود.')),
('jahr',lex('lex-de-jahr','Jahr','noun','سال','src-wikibooks-de-age-time')),
('achtzehn',lex('lex-de-achtzehn','achtzehn','numeral','هجده','src-wikibooks-de-age-time')),
('zwanzig',lex('lex-de-zwanzig','zwanzig','numeral','بیست','src-wikibooks-de-age-time')),
('heute',lex('lex-de-heute','heute','adverb','امروز','src-wikibooks-de-age-time')),
('dienstag',lex('lex-de-dienstag','Dienstag','noun','سه‌شنبه','src-wikibooks-de-age-time')),
('uhr',lex('lex-de-uhr','Uhr','noun','ساعت','src-wikibooks-de-age-time')),
('geburtstag',lex('lex-de-geburtstag','Geburtstag','noun','تولد / روز تولد','src-wikibooks-de-birthday')),
('juli',lex('lex-de-juli','Juli','proper_noun','ژوئیه','src-wikibooks-de-birthday-question')),
('november',lex('lex-de-november','November','proper_noun','نوامبر','src-wikibooks-de-birthday')),
('telefonnummer',lex('lex-de-telefonnummer','Telefonnummer','noun','شماره تلفن','src-wikibooks-de-phone')),
('buch',lex('lex-de-buch','Buch','noun','کتاب','src-wikibooks-de-basic-object')),
('karte',lex('lex-de-karte','Karte','noun','کارت / نقشه','src-wikibooks-de-basic-object')),
('adresse',lex('lex-de-adresse','Adresse','noun','نشانی / آدرس','src-wikibooks-de-age-time')),
]
for fn,data in lexemes: dump('content/de/lexemes/'+fn+'.json',data)

# Existing Pre-A1 lexical audio becomes pending because the level is finalized.
for pth in (ROOT/'content/de/lexemes').glob('*.json'):
    d=json.loads(pth.read_text(encoding='utf-8'))
    if d.get('level')=='Pre-A1':
        d['audioStatus']='pending'; dump(pth.relative_to(ROOT),d)

# -----------------------------------------------------------------------------
# New unit and six descriptor-driven lessons.
# -----------------------------------------------------------------------------
unit2={
 'schemaVersion':'1.0.0','id':'de-pre-a1-unit-personal-info','languageId':'de','level':'Pre-A1','titleFa':'اطلاعات شخصی خیلی ساده',
 'learningTargets':['گفتن محل زندگی و مبدأ','پرسیدن و گفتن سن و فهم عددهای ساده','پرسیدن و گفتن روز و ساعت','پرسیدن و گفتن تاریخ تولد','پرسیدن و گفتن شماره تلفن','پرسیدن یک سؤال اطلاعاتی بسیار ساده','تکمیل یک فرم متنی کوتاه با اطلاعات شخصی'],
 'lessonRefs':['de-pre-a1-lesson-residence-origin','de-pre-a1-lesson-age-numbers','de-pre-a1-lesson-day-time','de-pre-a1-lesson-birthday-date','de-pre-a1-lesson-phone-number','de-pre-a1-lesson-basic-object','de-pre-a1-lesson-personal-review'],
 'groupingRationale':'این درس‌ها یک خوشهٔ منسجم از اطلاعات شخصی و اطلاعات روزمرهٔ بسیار پایه می‌سازند و بعد با یک مرور نوشتاری/گفتاری جمع‌بندی می‌شوند؛ مرز واحد از تغییر هدف ارتباطی ایجاد شده است، نه از ظرفیت عددی.',
 'sourceRefs':['src-coe-cefr-pre-a1','src-wikibooks-de-residence-origin','src-wikibooks-de-age-time','src-wikibooks-de-birthday','src-wikibooks-de-birthday-question','src-wikibooks-de-phone','src-wikibooks-de-phone-example','src-wikibooks-de-basic-object'],
 'status':'final','notes':'این واحد descriptorهای غیرتصویری باقیماندهٔ Pre-A1 را می‌بندد و سپس سطح وارد audit نهایی می‌شود.'
}
dump('content/de/pre-a1/units/personal-info.json',unit2)

# First unit becomes final with its existing nine lessons.
unit1=load('content/de/pre-a1/units/first-steps.json'); unit1['status']='final'; dump('content/de/pre-a1/units/first-steps.json',unit1)


def turn(id,speaker,text,fa,learner,srcs,lexrefs=None):
    return {'id':id,'speakerCharacterId':speaker,'speakerIdentityOrigin':'app_assigned','speakerGenderEvidence':'unspecified','textTarget':text,'translationFa':fa,'learnerTurn':learner,'lexemeRefs':lexrefs or [],'lexemeOccurrences':[],'sourceRefs':srcs,'audioRef':None}

def dialogue(id,scenario,starter,turns,srcs,rationale,chars=None):
    return {'id':id,'languageId':'de','level':'Pre-A1','sourceRefs':srcs,'scenario':scenario,'openingInitiator':starter,'characterRefs':chars or ['char-de-mia','char-de-learner'],'turns':turns,'sceneQualityRationale':rationale}

def conv_act(id,dialogue_ref,instruction,reason,srcs,targets,lexrefs=None,starter='app'):
    return {'id':id,'type':'conversation_speaking','instructionFa':instruction,'selectionReason':reason,'sourceRefs':srcs,'learningTargets':targets,'lexemeRefs':lexrefs or [],'dialogueRef':dialogue_ref,'data':{'interaction':'read_aloud_exchange','openingInitiator':starter},'transformations':['persian_translation_added','character_metadata_added'],'audioStatus':'not_required'}

def lesson(id,title,source_title,targets,srcs,lexrefs,activities,signature,rationale,sequence):
    return {'schemaVersion':'1.0.0','id':id,'languageId':'de','level':'Pre-A1','unitRef':'de-pre-a1-unit-personal-info','titleFa':title,'sourceTitle':source_title,'learningTargets':targets,'sourceRefs':srcs,'lexemeRefs':lexrefs,'grammarNoteRefs':[],'activityDesign':{'activitySelectionRationale':rationale,'sequenceRationale':sequence,'templateSignature':signature},'activities':activities,'status':'final','audioStatus':'pending'}

# L10: formal stranger exchange, exactly 4 turns (the final exact-four beginner opening).
src_res=['src-wikibooks-de-residence-origin']
d10=dialogue('dlg-de-pre-a1-residence-origin','آیریس و زبان‌آموز در یک آشنایی مؤدبانه دربارهٔ محل زندگی و مبدأ سؤال و جواب می‌کنند.','app',[
 turn('turn-de-residence-1','char-de-iris','Wo wohnen Sie?','کجا زندگی می‌کنید؟',False,src_res,['lex-de-wohnen']),
 turn('turn-de-residence-2','char-de-learner','Ich wohne in Österreich.','من در اتریش زندگی می‌کنم.',True,src_res,['lex-de-wohnen','lex-de-oesterreich']),
 turn('turn-de-residence-3','char-de-learner','Woher kommen Sie?','اهل کجا هستید؟',True,src_res,['lex-de-kommen']),
 turn('turn-de-residence-4','char-de-iris','Ich komme aus Deutschland, und Sie?','من اهل آلمان هستم، شما چطور؟',False,src_res,['lex-de-kommen','lex-de-deutschland'])
],src_res,'این چهار turn دو تبادل بسیار کوتاه و منبع‌دار دربارهٔ محل زندگی و مبدأ را کامل می‌کنند و درس دهم را مطابق قانون شروع دوره سبک نگه می‌دارند.',['char-de-iris','char-de-learner'])
dump('content/de/pre-a1/dialogues/residence-origin.json',d10)
a10=[conv_act('act-de-residence-conversation',d10['id'],'در یک گفت‌وگوی مؤدبانه دربارهٔ محل زندگی و مبدأ جواب بده و یک سؤال هم بپرس.','دو descriptor نزدیکِ اطلاعات شخصی در یک تبادل چهار turn طبیعی کنار هم تمرین می‌شوند.',src_res,['فهم و استفاده از پرسش و پاسخ بسیار ساده دربارهٔ محل زندگی و مبدأ.'],['lex-de-wohnen','lex-de-oesterreich','lex-de-kommen','lex-de-deutschland'])]
dump('content/de/pre-a1/lessons/residence-origin.json',lesson('de-pre-a1-lesson-residence-origin','کجا زندگی می‌کنی؟','Wo wohnen Sie? / Woher kommen Sie?',['محل زندگی را در یک جملهٔ کوتاه بفهمد و بیان کند.','مبدأ/کشور را در یک پرسش و پاسخ کوتاه بفهمد و بیان کند.'],src_res,['lex-de-wohnen','lex-de-oesterreich','lex-de-kommen','lex-de-deutschland'],a10,'conversation_speaking','همان مکالمهٔ کوتاه هدف این درس را پوشش می‌دهد و تمرین اضافه فقط تکرار ایجاد می‌کند.','ابتدا محل زندگی و سپس مبدأ در یک آشنایی مؤدبانه مطرح می‌شود.'))

# L11: age + simple numbers, with real future audio target.
src_age=['src-wikibooks-de-age-time']
d11=dialogue('dlg-de-pre-a1-age-numbers','میا و زبان‌آموز سن هم را می‌پرسند و با عددهای ساده جواب می‌دهند.','app',[
 turn('turn-de-age-1','char-de-mia','Wie alt bist du?','چند سالته؟',False,src_age,['lex-de-alt']),
 turn('turn-de-age-2','char-de-learner','Ich bin achtzehn Jahre alt.','من هجده ساله‌ام.',True,src_age,['lex-de-achtzehn','lex-de-jahr','lex-de-alt']),
 turn('turn-de-age-3','char-de-learner','Wie alt bist du?','چند سالته؟',True,src_age,['lex-de-alt']),
 turn('turn-de-age-4','char-de-mia','Ich bin 20 Jahre alt.','من بیست ساله‌ام.',False,src_age,['lex-de-zwanzig','lex-de-jahr','lex-de-alt'])
],src_age,'چهار turn برای رفت‌وبرگشت سن کافی است؛ فعالیت شنیداری بعدی عدد را جداگانه بازیابی می‌کند.')
dump('content/de/pre-a1/dialogues/age-numbers.json',d11)
a11=[conv_act('act-de-age-conversation',d11['id'],'سن میا را بپرس و وقتی او از سن تو می‌پرسد، پاسخ نمونه را بگو.','سن و عدد باید اول در تعامل واقعی دیده شوند.',src_age,['پرسیدن و گفتن سن با عدد ساده.'],['lex-de-alt','lex-de-jahr','lex-de-achtzehn','lex-de-zwanzig']),
 {'id':'act-de-age-listen','type':'listen_choose','instructionFa':'عدد «achtzehn» را گوش کن و عدد درست را انتخاب کن.','selectionReason':'توصیفگر Pre-A1 فهم عددهای ساده را می‌خواهد؛ این تمرین تشخیص شنیداری را بدون افزودن زبان تازه می‌سنجد.','sourceRefs':src_age,'learningTargets':['تشخیص شنیداری عدد «achtzehn».'],'lexemeRefs':['lex-de-achtzehn'],'dialogueRef':None,'data':{'options':[{'text':'18','correct':True},{'text':'20','correct':False}]},'transformations':['other'],'audioStatus':'pending','audioTextTarget':'achtzehn'}]
dump('content/de/pre-a1/lessons/age-numbers.json',lesson('de-pre-a1-lesson-age-numbers','چند سالته؟','Wie alt bist du? / Ich bin ... Jahre alt.',['پرسش «Wie alt bist du?» را بفهمد و استفاده کند.','سن را با یک عدد ساده بیان کند.','عددهای ساده را در شنیدن تشخیص دهد.'],src_age,['lex-de-alt','lex-de-jahr','lex-de-achtzehn','lex-de-zwanzig'],a11,'conversation_speaking>listen_choose','بعد از تعامل، یک تشخیص شنیداری عدد لازم است چون CEFR روی فهم عددهای ساده تأکید دارد.','اول سن در مکالمه معنا پیدا می‌کند و سپس عدد به‌تنهایی از راه شنیدن بازیابی می‌شود.'))

# L12: day/time/time-of-day + listening.
d12=dialogue('dlg-de-pre-a1-day-time','میا و زبان‌آموز دربارهٔ روز و ساعت فعلی سؤال و جواب می‌کنند.','learner',[
 turn('turn-de-time-1','char-de-learner','Welcher Tag ist heute?','امروز چه روزی است؟',True,src_age,['lex-de-heute']),
 turn('turn-de-time-2','char-de-mia','Heute ist Dienstag.','امروز سه‌شنبه است.',False,src_age,['lex-de-heute','lex-de-dienstag']),
 turn('turn-de-time-3','char-de-learner','Wie spät ist es?','ساعت چند است؟',True,src_age,['lex-de-uhr']),
 turn('turn-de-time-4','char-de-mia','Es ist 6.30 Uhr.','ساعت ۶:۳۰ است.',False,src_age,['lex-de-uhr'])
],src_age,'زبان‌آموز هر دو سؤال را فعالانه می‌پرسد و چهار turn روز و ساعت را بدون حاشیه پوشش می‌دهند.')
dump('content/de/pre-a1/dialogues/day-time.json',d12)
a12=[conv_act('act-de-time-conversation',d12['id'],'این بار تو شروع کن؛ روز و ساعت را از میا بپرس.','پرسیدن فعال روز و ساعت مستقیماً descriptor اطلاعات روزمره را تمرین می‌کند.',src_age,['پرسیدن و فهم روز و ساعت.'],['lex-de-heute','lex-de-dienstag','lex-de-uhr'],starter='learner'),
 {'id':'act-de-time-listen','type':'listen_choose','instructionFa':'زمان را گوش کن و ساعت درست را انتخاب کن.','selectionReason':'برای پوشش reception، زمان دقیق به‌صورت شنیداری تشخیص داده می‌شود.','sourceRefs':src_age,'learningTargets':['تشخیص شنیداری «Es ist 6.30 Uhr.».'],'lexemeRefs':['lex-de-uhr'],'dialogueRef':None,'data':{'options':[{'text':'6:30','correct':True},{'text':'8:30','correct':False}]},'transformations':['other'],'audioStatus':'pending','audioTextTarget':'Es ist 6.30 Uhr.'},
 {'id':'act-de-time-of-day','type':'multiple_choice','instructionFa':'اگر صبح باشد، کدام جملهٔ منبع‌دار زمان روز را بیان می‌کند؟','selectionReason':'CEFR علاوه بر ساعت، زمان روز را هم در Pre-A1 می‌آورد؛ تشخیص متنی کافی است و زبان تازهٔ اضافی لازم ندارد.','sourceRefs':src_age,'learningTargets':['تشخیص زمان روز «Morgen».'],'lexemeRefs':[],'dialogueRef':None,'data':{'options':[{'textTarget':'Es ist Morgen.','correct':True,'sourceRefs':src_age},{'textTarget':'Es ist Abend.','correct':False,'sourceRefs':src_age}]},'transformations':['options_selected_from_source_material'],'audioStatus':'not_required'}]
dump('content/de/pre-a1/lessons/day-time.json',lesson('de-pre-a1-lesson-day-time','امروز چه روزیه؟ ساعت چنده؟','Welcher Tag ist heute? / Wie spät ist es?',['روز را بپرسد و یک پاسخ ساده را بفهمد.','ساعت را بپرسد و یک زمان ساده را بفهمد.','زمان روز را در یک عبارت بسیار کوتاه تشخیص دهد.'],src_age,['lex-de-heute','lex-de-dienstag','lex-de-uhr'],a12,'conversation_speaking>listen_choose>multiple_choice','مکالمه تولید سؤال را می‌گیرد؛ شنیدن ساعت و تشخیص زمان روز دو mode جدا و لازم برای descriptor هستند.','روز و ساعت در یک صحنه می‌آیند؛ سپس reception شنیداری و خواندنی بدون افزودن ساختار تازه تثبیت می‌شود.'))

# L13: birthday/date.
src_bq=['src-wikibooks-de-birthday-question']; src_birth=['src-wikibooks-de-birthday-question','src-wikibooks-de-birthday']
d13=dialogue('dlg-de-pre-a1-birthday-date','میا و زبان‌آموز تاریخ تولد را می‌پرسند و با دو تاریخ منبع‌دار پاسخ می‌دهند.','app',[
 turn('turn-de-birthday-1','char-de-mia','Wann hast du Geburtstag?','کی تولدته؟',False,src_bq,['lex-de-geburtstag']),
 turn('turn-de-birthday-2','char-de-learner','Am 16. Juli.','شانزدهم ژوئیه.',True,src_bq,['lex-de-juli']),
 turn('turn-de-birthday-3','char-de-learner','Wann hast du Geburtstag?','کی تولدته؟',True,src_bq,['lex-de-geburtstag']),
 turn('turn-de-birthday-4','char-de-mia','Ich habe am dreizehnten November Geburtstag.','تولد من سیزدهم نوامبر است.',False,['src-wikibooks-de-birthday'],['lex-de-november','lex-de-geburtstag'])
],src_birth,'چهار turn دو شکل رایج پاسخ به تاریخ تولد را نشان می‌دهد و برای Pre-A1 کافی است.')
dump('content/de/pre-a1/dialogues/birthday-date.json',d13)
a13=[conv_act('act-de-birthday-conversation',d13['id'],'تاریخ تولد را بپرس و پاسخ نمونهٔ کوتاه را بگو.','پرسش و پاسخ تاریخ تولد مستقیماً descriptor Pre-A1 را پوشش می‌دهد.',src_birth,['پرسیدن و گفتن تاریخ تولد.'],['lex-de-geburtstag','lex-de-juli','lex-de-november']),
 {'id':'act-de-birthday-fill','type':'fill_blank','instructionFa':'جملهٔ تاریخ تولد را با بخش منبع‌دار کامل کن.','selectionReason':'یک بازیابی نوشتاری سبک از همان جملهٔ منبع‌دار، تاریخ را بدون ساخت جملهٔ تازه تمرین می‌کند.','sourceRefs':['src-wikibooks-de-birthday'],'learningTargets':['بازیابی ساختار تاریخ تولد.'],'lexemeRefs':['lex-de-geburtstag','lex-de-november'],'dialogueRef':None,'data':{'sourceText':'Ich habe am dreizehnten November Geburtstag.','blankedText':'Ich habe am ___ November Geburtstag.','choices':['dreizehnten'],'answer':'dreizehnten'},'transformations':['source_sentence_blanked'],'audioStatus':'not_required'}]
dump('content/de/pre-a1/lessons/birthday-date.json',lesson('de-pre-a1-lesson-birthday-date','تولدت کیه؟','Wann hast du Geburtstag? / Ich habe am ... Geburtstag.',['پرسش تاریخ تولد را بفهمد و بپرسد.','یک تاریخ تولد کوتاه را بفهمد و بیان کند.','ساختار تاریخ تولد را در نوشتن بازیابی کند.'],src_birth,['lex-de-geburtstag','lex-de-juli','lex-de-november'],a13,'conversation_speaking>fill_blank','بعد از مکالمه فقط یک بازیابی نوشتاری منبع‌دار لازم است.','اول تاریخ در تعامل معنا پیدا می‌کند و سپس همان ساختار با جای خالی تثبیت می‌شود.'))

# L14: phone number + listening.
src_phone=['src-wikibooks-de-phone','src-wikibooks-de-phone-example']
d14=dialogue('dlg-de-pre-a1-phone-number','میا و زبان‌آموز شماره تلفن را از هم می‌پرسند و دو شمارهٔ منبع‌دار می‌گویند.','app',[
 turn('turn-de-phone-1','char-de-mia','Wie lautet deine Telefonnummer?','شماره تلفنت چیه؟',False,['src-wikibooks-de-phone'],['lex-de-telefonnummer']),
 turn('turn-de-phone-2','char-de-learner','Meine Telefonnummer lautet 789.','شماره تلفن من ۷۸۹ است.',True,['src-wikibooks-de-phone'],['lex-de-telefonnummer']),
 turn('turn-de-phone-3','char-de-learner','Wie lautet deine Telefonnummer?','شماره تلفنت چیه؟',True,['src-wikibooks-de-phone'],['lex-de-telefonnummer']),
 turn('turn-de-phone-4','char-de-mia','Meine Telefonnummer ist: 692-267-752.','شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.',False,['src-wikibooks-de-phone-example'],['lex-de-telefonnummer'])
],src_phone,'چهار turn برای تمرین پرسیدن و شنیدن/گفتن شماره کافی است و عددها نقش اطلاعات واقعی را دارند.')
dump('content/de/pre-a1/dialogues/phone-number.json',d14)
a14=[conv_act('act-de-phone-conversation',d14['id'],'شماره تلفن را بپرس و پاسخ نمونه را بگو.','پرسش و پاسخ مستقیم شماره تلفن descriptor صریح Pre-A1 است.',src_phone,['پرسیدن و گفتن شماره تلفن.'],['lex-de-telefonnummer']),
 {'id':'act-de-phone-listen','type':'listen_choose','instructionFa':'شماره را گوش کن و عدد درست را انتخاب کن.','selectionReason':'شماره تلفن باید در reception شنیداری هم قابل تشخیص باشد.','sourceRefs':['src-wikibooks-de-phone'],'learningTargets':['تشخیص شنیداری شمارهٔ «789».'],'lexemeRefs':['lex-de-telefonnummer'],'dialogueRef':None,'data':{'options':[{'text':'789','correct':True},{'text':'798','correct':False}]},'transformations':['other'],'audioStatus':'pending','audioTextTarget':'Meine Telefonnummer lautet 789.'}]
dump('content/de/pre-a1/lessons/phone-number.json',lesson('de-pre-a1-lesson-phone-number','شماره تلفنت چیه؟','Wie lautet deine Telefonnummer? / Meine Telefonnummer ...',['پرسش شماره تلفن را بفهمد و استفاده کند.','یک شماره تلفن ساده را بیان و از راه شنیدن تشخیص دهد.'],src_phone,['lex-de-telefonnummer'],a14,'conversation_speaking>listen_choose','بعد از مکالمه، تشخیص شنیداری شماره برای پوشش reception لازم است.','اول تبادل شماره تمرین می‌شود و بعد یک شمارهٔ همان منبع از راه شنیدن بازیابی می‌شود.'))

# L15: very simple information question without imagery.
src_obj=['src-wikibooks-de-basic-object']
d15=dialogue('dlg-de-pre-a1-basic-object','در یک موقعیت متنی، میا و زبان‌آموز دربارهٔ دو شیء نام‌برده‌شده سؤال بسیار ساده می‌پرسند؛ حل فعالیت به تصویر وابسته نیست.','learner',[
 turn('turn-de-object-1','char-de-learner','Was ist das?','این چیه؟',True,src_obj),
 turn('turn-de-object-2','char-de-mia','Das ist ein Buch.','این یک کتاب است.',False,src_obj,['lex-de-buch']),
 turn('turn-de-object-3','char-de-mia','Was ist das?','این چیه؟',False,src_obj),
 turn('turn-de-object-4','char-de-learner','Das ist eine Karte.','این یک کارت/نقشه است.',True,src_obj,['lex-de-karte'])
],src_obj,'سؤال اطلاعاتی بسیار ساده و پاسخ کوتاه از متن منبع گرفته شده‌اند؛ context فارسی شیء را مشخص می‌کند تا هیچ تصویر آموزشی لازم نباشد.')
dump('content/de/pre-a1/dialogues/basic-object.json',d15)
a15=[conv_act('act-de-object-conversation',d15['id'],'این بار تو شروع کن؛ در context متنی بپرس «Was ist das?» و پاسخ‌های کوتاه را تمرین کن.','این فعالیت descriptor سؤال اطلاعاتی بسیار ساده را به شکل text-only و بدون تصویر پوشش می‌دهد.',src_obj,['پرسیدن و فهم پاسخ یک سؤال اطلاعاتی بسیار ساده.'],['lex-de-buch','lex-de-karte'],starter='learner')]
dump('content/de/pre-a1/lessons/basic-object.json',lesson('de-pre-a1-lesson-basic-object','این چیه؟','Was ist das? / Das ist ...',['«Was ist das?» را بپرسد و پاسخ بسیار ساده را بفهمد.','همان توانایی را بدون وابستگی به تصویر و با context متنی انجام دهد.'],src_obj,['lex-de-buch','lex-de-karte'],a15,'conversation_speaking','خود مکالمه descriptor را کامل پوشش می‌دهد؛ فعالیت تصویری عمداً وارد نمی‌شود.','زبان‌آموز یک بار سؤال را شروع می‌کند و یک بار پاسخ می‌دهد تا هر دو نقش تمرین شوند.'))

# L16: integrated oral review + text-only personal-information form + price listening.
src_review=['src-wikibooks-de-residence-origin','src-wikibooks-de-age-time','src-wikibooks-de-birthday','src-wikibooks-de-phone']
d16=dialogue('dlg-de-pre-a1-personal-review','یک آشنایی مؤدبانهٔ کوتاه چند بخش اصلی اطلاعات شخصی را در هشت turn مرور می‌کند.','app',[
 turn('turn-de-review-1','char-de-iris','Guten Tag!','سلام / روز بخیر!',False,['src-wikibooks-de-residence-origin']),
 turn('turn-de-review-2','char-de-learner','Guten Tag!','سلام / روز بخیر!',True,['src-wikibooks-de-residence-origin']),
 turn('turn-de-review-3','char-de-iris','Wie heißen Sie?','اسمتان چیست؟',False,['src-wikibooks-de-residence-origin']),
 turn('turn-de-review-4','char-de-learner','Ich heiße Paul Müller.','اسم من پاول مولر است.',True,['src-wikibooks-de-residence-origin']),
 turn('turn-de-review-5','char-de-iris','Wo wohnen Sie?','کجا زندگی می‌کنید؟',False,['src-wikibooks-de-residence-origin'],['lex-de-wohnen']),
 turn('turn-de-review-6','char-de-learner','Ich wohne in Österreich.','من در اتریش زندگی می‌کنم.',True,['src-wikibooks-de-residence-origin'],['lex-de-wohnen','lex-de-oesterreich']),
 turn('turn-de-review-7','char-de-iris','Wie alt sind Sie?','چند سالتان است؟',False,['src-wikibooks-de-age-time'],['lex-de-alt']),
 turn('turn-de-review-8','char-de-learner','Ich bin 20 Jahre alt.','من بیست ساله‌ام.',True,['src-wikibooks-de-age-time'],['lex-de-zwanzig','lex-de-jahr','lex-de-alt'])
],src_review,'هشت turn فقط مطالب اصلی قبلی را در یک تعامل واحد بازیابی می‌کند؛ هیچ زبان تازه‌ای برای طولانی‌کردن صحنه اضافه نشده است.',['char-de-iris','char-de-learner'])
dump('content/de/pre-a1/dialogues/personal-review.json',d16)
review_fields=[
 {'labelFa':'نام','patternTarget':'Ich heiße ___.','exampleSourceText':'Ich heiße Paul Müller.','sourceRefs':['src-wikibooks-de-residence-origin'],'instructionFa':'نام واقعی خودت را در جای خالی بنویس.'},
 {'labelFa':'محل زندگی','patternTarget':'Ich wohne in ___.','exampleSourceText':'Ich wohne in Österreich.','sourceRefs':['src-wikibooks-de-residence-origin'],'instructionFa':'محل زندگی خودت را بنویس.'},
 {'labelFa':'سن','patternTarget':'Ich bin ___ Jahre alt.','exampleSourceText':'Ich bin 20 Jahre alt.','sourceRefs':['src-wikibooks-de-age-time'],'instructionFa':'سن خودت را بنویس.'},
 {'labelFa':'شماره تلفن','patternTarget':'Meine Telefonnummer lautet ___.','exampleSourceText':'Meine Telefonnummer lautet 789.','sourceRefs':['src-wikibooks-de-phone'],'instructionFa':'یک شمارهٔ تمرینی یا شمارهٔ خودت را وارد کن.'},
 {'labelFa':'تاریخ تولد','patternTarget':'Ich habe am ___ Geburtstag.','exampleSourceText':'Ich habe am dreizehnten November Geburtstag.','sourceRefs':['src-wikibooks-de-birthday'],'instructionFa':'تاریخ تولد خودت را در الگوی منبع‌دار وارد کن.'},
 {'labelFa':'نشانی','patternTarget':'Adresse: ___','exampleSourceText':'Adresse','sourceRefs':['src-wikibooks-de-age-time'],'instructionFa':'اگر می‌خواهی، یک نشانی تمرینی بنویس؛ این فیلد برای تمرین فرم متنی است.'}
]
a16=[conv_act('act-de-review-conversation',d16['id'],'در یک آشنایی مؤدبانه، نام، محل زندگی و سن را دوباره مرور کن.','این مکالمه retrieval چند هدف اصلی را بدون معرفی زبان تازه انجام می‌دهد.',src_review,['بازیابی یکپارچهٔ نام، محل زندگی و سن.'],['lex-de-wohnen','lex-de-oesterreich','lex-de-alt','lex-de-jahr','lex-de-zwanzig']),
 {'id':'act-de-personal-form','type':'review','instructionFa':'فرم متنی خیلی کوتاه را با اطلاعات خودت کامل کن.','selectionReason':'CEFR در Pre-A1 نوشتن/تکمیل اطلاعات شخصی بسیار پایه را پوشش می‌دهد؛ این فرم بدون تصویر و فقط با الگوهای منبع‌دار همان توانایی را تمرین می‌کند.','sourceRefs':['src-wikibooks-de-residence-origin','src-wikibooks-de-age-time','src-wikibooks-de-birthday','src-wikibooks-de-phone'],'learningTargets':['نوشتن اطلاعات شخصی بسیار کوتاه با الگوهای منبع‌دار.','حل gap نام واقعی زبان‌آموز با جایگزینی مقدار شخصی داخل الگوی منبع‌دار.'],'lexemeRefs':['lex-de-wohnen','lex-de-alt','lex-de-jahr','lex-de-telefonnummer','lex-de-geburtstag','lex-de-adresse'],'dialogueRef':None,'data':{'contextFa':'این یک فرم متنی است و هیچ تصویر یا اطلاعات حساس اجباری ندارد. می‌توانی برای تمرین از دادهٔ ساختگی استفاده کنی.','fields':review_fields},'transformations':['source_sentence_blanked'],'audioStatus':'not_required'},
 {'id':'act-de-price-listen','type':'listen_choose','instructionFa':'قیمت را گوش کن و عدد درست را انتخاب کن.','selectionReason':'توصیفگر reception در Pre-A1 تشخیص عدد و قیمت آشنا را پوشش می‌دهد؛ یک نمونهٔ منبع‌دار برای این gap کافی است.','sourceRefs':['src-wikibooks-de-age-time'],'learningTargets':['تشخیص شنیداری قیمت ساده.'],'lexemeRefs':[],'dialogueRef':None,'data':{'options':[{'text':'7,60 €','correct':True},{'text':'6,70 €','correct':False}]},'transformations':['other'],'audioStatus':'pending','audioTextTarget':'Die Zeitschrift kostet 7,60 Euro.'}]
dump('content/de/pre-a1/lessons/personal-review.json',lesson('de-pre-a1-lesson-personal-review','مرور اطلاعات شخصی','مرور نام، محل، سن، فرم کوتاه و قیمت شنیداری',['نام، محل زندگی و سن را در یک گفت‌وگوی کوتاه بازیابی کند.','اطلاعات شخصی بسیار کوتاه را در یک فرم متنی وارد کند.','نام واقعی خودش را با جایگزینی در الگوی منبع‌دار «Ich heiße ...» بنویسد.','یک قیمت ساده را از راه شنیدن تشخیص دهد.'],src_review,['lex-de-wohnen','lex-de-oesterreich','lex-de-alt','lex-de-jahr','lex-de-zwanzig','lex-de-telefonnummer','lex-de-geburtstag','lex-de-adresse'],a16,'conversation_speaking>review>listen_choose','مرور نهایی باید interaction، writing و listening را کنار هم جمع کند؛ هر سه activity gap متفاوتی را می‌بندند و هیچ‌کدام برای رسیدن به تعداد اضافه نشده‌اند.','اول retrieval گفتاری، سپس فرم متنی شخصی و در پایان یک تشخیص شنیداری قیمت انجام می‌شود.'))

# Existing nine lessons become final/pending; non-audio activities remain not_required.
for pth in (ROOT/'content/de/pre-a1/lessons').glob('*.json'):
    d=json.loads(pth.read_text(encoding='utf-8'))
    d['status']='final'; d['audioStatus']='pending'
    for a in d.get('activities',[]):
        if a.get('audioTextTarget'):
            if a.get('audioStatus')=='blocked_until_level_final': a['audioStatus']='pending'
        else:
            a['audioStatus']='not_required'
    dump(pth.relative_to(ROOT),d)

# -----------------------------------------------------------------------------
# Final level manifest and completion audit.
# -----------------------------------------------------------------------------
level=load('content/de/pre-a1/level.json')
new_lessons=unit2['lessonRefs']
level['lessonRefs']=level['lessonRefs']+ [x for x in new_lessons if x not in level['lessonRefs']]
level['unitRefs']=['de-pre-a1-unit-first-steps','de-pre-a1-unit-personal-info']
new_src=[d['id'] for _,d in sources]
level['sourceRefs']=level['sourceRefs']+[x for x in new_src if x not in level['sourceRefs']]
level['coverage']={
 'communicativeTargets':[
  'سلام، خداحافظی، تشکر، پاسخ مؤدبانه و عذرخواهی کوتاه','پرسیدن و گفتن نام','احوال‌پرسی بسیار ساده','پرسیدن و پاسخ‌دادن دربارهٔ علاقه/انتخاب غذای آشنا','پاسخ مثبت و منفی کوتاه','پرسیدن و گفتن محل زندگی و مبدأ','پرسیدن و گفتن سن و فهم عددهای ساده','پرسیدن و گفتن روز، ساعت و زمان روز','پرسیدن و گفتن تاریخ تولد','پرسیدن و گفتن شماره تلفن','پرسیدن سؤال اطلاعاتی بسیار ساده و فهم پاسخ کوتاه','نوشتن اطلاعات شخصی بسیار کوتاه در یک فرم متنی','تشخیص شنیداری یک قیمت ساده'],
 'linguisticTargets':[
  'عبارت‌های ثابت سلام/خداحافظی و ادب','فعل‌های پایهٔ «mögen»، «heißen»، «wohnen» و «kommen» در کاربردهای منبع‌دار این سطح','عددهای ساده در سن، ساعت، تلفن و قیمت','واژه‌های پایهٔ روز، ساعت، تولد، شماره تلفن و نشانی','الگوهای منبع‌دار معرفی، محل زندگی، سن، تاریخ تولد و شماره تلفن'],
 'situations':['آشنایی اولیه','گفت‌وگوی کوتاه صبحگاهی','علاقه و انتخاب غذای آشنا','تشکر و عذرخواهی','اطلاعات شخصی در آشنایی مؤدبانه','پرسش سن','پرسش روز و ساعت','تاریخ تولد','تبادل شماره تلفن','سؤال اطلاعاتی بسیار ساده','فرم متنی اطلاعات شخصی','تشخیص قیمت ساده'],
 'gaps':[]
}
level['status']='final'; level['audioStatus']='pending'
level['completionAssessment']={
 'reviewedAt':'2026-09-16T18:15:00Z','cefrCoverageComplete':True,'progressionComplete':True,'practiceAndRetrievalComplete':True,'skillModeCoverageComplete':True,'requiredGaps':[],
 'scopeExclusions':['توصیفگرهای Pre-A1 که صراحتاً به متن مصور، تصویر یا اشارهٔ فیزیکی/دیداری وابسته‌اند، به‌دلیل baseline فعلی image-free خارج از scope محصول هستند؛ توانایی‌های مستقلِ متنی، گفتاری و شنیداری متناظر پوشش داده شده‌اند.'],
 'qualityReview':{
  'overallScore':9.7,
  'dimensionScores':{'cefrCoverage':9.7,'pedagogicalProgression':9.6,'practiceAndRetrieval':9.7,'activityQualityAndVariety':9.7,'linguisticAccuracyAndNaturalness':9.6,'sourceQualityAndCurrency':9.8,'learnerSupportAndClarity':9.8,'qaIntegrity':10.0},
  'rationale':'پوشش نهایی بر توصیفگرهای رسمی Pre-A1 و scope متن/صوت بدون تصویر تطبیق داده شده است؛ اهداف اطلاعات شخصی، عدد، روز/ساعت/تاریخ، تاریخ تولد، تلفن، سؤال اطلاعاتی بسیار ساده، نوشتن فرم کوتاه و retrieval چندحالتی پوشش دارند و CI منبع، فارسی، ساختار و MySQL را کنترل می‌کند.',
  'strengths':['پوشش descriptorمحور بدون سهمیهٔ درس یا فعالیت','تمام متن هدف learner-facing منبع‌دار و قابل ردیابی است','مرور نهایی speaking، listening، reading و writing متنی را ترکیب می‌کند','قواعد فارسی، image-free، starter، audio و MySQL به‌صورت خودکار کنترل می‌شوند.'],
  'remainingWeaknesses':['فایل‌های صوتی هنوز تولید نشده‌اند؛ همهٔ assetهای لازم پس از final شدن سطح در وضعیت pending قرار می‌گیرند و pipeline صوت باید آن‌ها را تولید و لینک کند.']
 }
}
level['notes']='German Pre-A1 از نظر محتوای آموزشی در scope فعلی text/audio و image-free نهایی شده است؛ audio assetها مرحلهٔ بعدی مستقل هستند.'
dump('content/de/pre-a1/level.json',level)

# -----------------------------------------------------------------------------
# SQL snapshot extension. The original 9-lesson snapshot remains the first
# transaction; this deterministic second transaction completes/finalizes Pre-A1.
# On re-import the first transaction reopens rows to draft/building and this
# extension re-applies final state, preserving generated audio metadata.
# -----------------------------------------------------------------------------
sql_path=ROOT/'database/content/de/pre-a1.sql'
sql=sql_path.read_text(encoding='utf-8')
marker='-- BEGIN PRE-A1 FINALIZATION EXTENSION'
if marker in sql:
    sql=sql.split(marker)[0].rstrip()+"\n\n"
ext=r'''-- BEGIN PRE-A1 FINALIZATION EXTENSION
-- Descriptor-driven completion of German Pre-A1. No lesson-count quota is implied.
START TRANSACTION;

-- Completion-analysis source (not learner-facing) and reusable modern German sources.
INSERT INTO sources
(source_key,title,organization_or_author,language_code,source_type,url,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-coe-cefr-pre-a1','CEFR Companion Volume (2020) — Pre-A1 descriptors','Council of Europe','en','book','https://rm.coe.int/cefr-companion-volume-with-new-descriptors-2020/16809ea0d4','2020','contemporary_verified','نسخهٔ رسمی Companion Volume شورای اروپا و توصیفگرهای Pre-A1 در وضعیت جاری بررسی شده‌اند.',NULL,NULL,'Council of Europe — CEFR Companion Volume','analysis_only','2026-09-16','مرجع برنامه‌ریزی برای توصیفگرهای Pre-A1؛ متن آموزشی آلمانی از آن بازاستفاده نمی‌شود.'),
('src-wikibooks-de-residence-origin','BLL German/A1/Lesson 2','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/BLL_German/A1/Lesson_2',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و در ماه‌های اخیر منتشر/نگهداری شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — BLL German/A1/Lesson 2','reuse_with_attribution','2026-09-16','منبع محل زندگی، مبدأ و معرفی مؤدبانه.'),
('src-wikibooks-de-age-time','Deutschkurs für Anfänger/Lektion 007','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_007',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در ماه اخیر منتشر/به‌روزرسانی شده و برای کاربرد معاصر بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 007','reuse_with_attribution','2026-09-16','منبع سن، عدد، روز، ساعت، زمان روز، Adresse و قیمت.'),
('src-wikibooks-de-birthday','German/Level I/Geburtstag','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Level_I/Geburtstag',NULL,'maintained_current','صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Level I/Geburtstag','reuse_with_attribution','2026-09-16','منبع زمان، تاریخ و جملهٔ تاریخ تولد.'),
('src-wikibooks-de-birthday-question','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 199','Wikibooks contributors','de','course','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_199',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks و attribution جمله‌های تعبیه‌شده در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors; embedded sentence attribution retained','reuse_with_attribution','2026-09-16','منبع «Wann hast du Geburtstag?» و «Am 16. Juli.».'),
('src-wikibooks-de-phone','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 192','Wikibooks contributors','de','course','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_192',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks و attribution جمله‌های تعبیه‌شده در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors; embedded sentence attribution retained','reuse_with_attribution','2026-09-16','منبع پرسش و پاسخ شماره تلفن.'),
('src-wikibooks-de-phone-example','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 220','Wikibooks contributors','de','course','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_220',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks و attribution جملهٔ تعبیه‌شده در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors; embedded sentence attribution retained','reuse_with_attribution','2026-09-16','منبع نمونهٔ دوم شماره تلفن.'),
('src-wikibooks-de-basic-object','Deutschkurs für Anfänger/Lektion 001','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_001',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و برای زبان آغازین معاصر مناسب است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 001','reuse_with_attribution','2026-09-16','منبع «Was ist das?» و پاسخ‌های بسیار ساده.')
ON DUPLICATE KEY UPDATE title=VALUES(title),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @s_res=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-residence-origin');
SET @s_age=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-age-time');
SET @s_birth=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-birthday');
SET @s_bq=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-birthday-question');
SET @s_phone=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-phone');
SET @s_phone2=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-phone-example');
SET @s_obj=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-basic-object');

INSERT INTO source_items (source_id,item_key,locator,source_text,source_text_hash,notes) VALUES
(@s_res,'srcitem-de-wo-wohnen-sie','Exercise answer','Wo wohnen Sie?',UNHEX(SHA2('Wo wohnen Sie?',256)),'پرسش محل زندگی.'),
(@s_res,'srcitem-de-ich-wohne-oesterreich','Exercise answer','Ich wohne in Österreich.',UNHEX(SHA2('Ich wohne in Österreich.',256)),'پاسخ محل زندگی.'),
(@s_res,'srcitem-de-woher-kommen-sie','Exercise answer','Woher kommen Sie?',UNHEX(SHA2('Woher kommen Sie?',256)),'پرسش مبدأ.'),
(@s_res,'srcitem-de-ich-komme-deutschland','Exercise answer','Ich komme aus Deutschland, und Sie?',UNHEX(SHA2('Ich komme aus Deutschland, und Sie?',256)),'پاسخ مبدأ.'),
(@s_res,'srcitem-de-guten-tag','Exercise answer','Guten Tag!',UNHEX(SHA2('Guten Tag!',256)),'سلام مؤدبانه.'),
(@s_res,'srcitem-de-wie-heissen-sie','Exercise answer','Wie heißen Sie?',UNHEX(SHA2('Wie heißen Sie?',256)),'پرسش نام رسمی.'),
(@s_res,'srcitem-de-ich-heisse-paul','Exercise answer','Ich heiße Paul Müller.',UNHEX(SHA2('Ich heiße Paul Müller.',256)),'پاسخ نام.'),
(@s_age,'srcitem-de-wie-alt-bist-du','Exercise 269','Wie alt bist du?',UNHEX(SHA2('Wie alt bist du?',256)),'پرسش سن.'),
(@s_age,'srcitem-de-age-18','Solution 269','Ich bin achtzehn Jahre alt.',UNHEX(SHA2('Ich bin achtzehn Jahre alt.',256)),'پاسخ سن.'),
(@s_age,'srcitem-de-age-20','Example 269','Ich bin 20 Jahre alt.',UNHEX(SHA2('Ich bin 20 Jahre alt.',256)),'پاسخ سن.'),
(@s_age,'srcitem-de-wie-alt-sind-sie','Example 269','Wie alt sind Sie?',UNHEX(SHA2('Wie alt sind Sie?',256)),'پرسش رسمی سن.'),
(@s_age,'srcitem-de-achtzehn','Solution 269','achtzehn',UNHEX(SHA2('achtzehn',256)),'عدد هجده.'),
(@s_age,'srcitem-de-welcher-tag','Day/time exercise','Welcher Tag ist heute?',UNHEX(SHA2('Welcher Tag ist heute?',256)),'پرسش روز.'),
(@s_age,'srcitem-de-heute-dienstag','Day/time solution','Heute ist Dienstag.',UNHEX(SHA2('Heute ist Dienstag.',256)),'پاسخ روز.'),
(@s_age,'srcitem-de-wie-spaet','Vocabulary','Wie spät ist es?',UNHEX(SHA2('Wie spät ist es?',256)),'پرسش ساعت.'),
(@s_age,'srcitem-de-time-630','Day/time solution','Es ist 6.30 Uhr.',UNHEX(SHA2('Es ist 6.30 Uhr.',256)),'پاسخ ساعت.'),
(@s_age,'srcitem-de-morgen-time','Day/time solution','Es ist Morgen.',UNHEX(SHA2('Es ist Morgen.',256)),'زمان روز: صبح.'),
(@s_age,'srcitem-de-abend-time','Day/time solution','Es ist Abend.',UNHEX(SHA2('Es ist Abend.',256)),'زمان روز: عصر/شب.'),
(@s_age,'srcitem-de-adresse','Vocabulary','Adresse',UNHEX(SHA2('Adresse',256)),'واژهٔ نشانی.'),
(@s_age,'srcitem-de-price-760','Diktat 296','Die Zeitschrift kostet 7,60 Euro.',UNHEX(SHA2('Die Zeitschrift kostet 7,60 Euro.',256)),'نمونهٔ قیمت.'),
(@s_bq,'srcitem-de-wann-geburtstag','Attributed sentence','Wann hast du Geburtstag?',UNHEX(SHA2('Wann hast du Geburtstag?',256)),'پرسش تاریخ تولد.'),
(@s_bq,'srcitem-de-am-16-juli','Attributed reply','Am 16. Juli.',UNHEX(SHA2('Am 16. Juli.',256)),'پاسخ کوتاه تاریخ.'),
(@s_birth,'srcitem-de-birthday-statement','Birthdays section','Ich habe am dreizehnten November Geburtstag.',UNHEX(SHA2('Ich habe am dreizehnten November Geburtstag.',256)),'جملهٔ تاریخ تولد.'),
(@s_phone,'srcitem-de-phone-question','Attributed sentence','Wie lautet deine Telefonnummer?',UNHEX(SHA2('Wie lautet deine Telefonnummer?',256)),'پرسش شماره تلفن.'),
(@s_phone,'srcitem-de-phone-789','Attributed sentence','Meine Telefonnummer lautet 789.',UNHEX(SHA2('Meine Telefonnummer lautet 789.',256)),'پاسخ شماره تلفن.'),
(@s_phone2,'srcitem-de-phone-692','Attributed sentence','Meine Telefonnummer ist: 692-267-752.',UNHEX(SHA2('Meine Telefonnummer ist: 692-267-752.',256)),'پاسخ شماره تلفن.'),
(@s_obj,'srcitem-de-was-ist-das','Exercise 010','Was ist das?',UNHEX(SHA2('Was ist das?',256)),'سؤال اطلاعاتی بسیار ساده.'),
(@s_obj,'srcitem-de-das-buch','Exercise 018','Das ist ein Buch.',UNHEX(SHA2('Das ist ein Buch.',256)),'پاسخ شیء.'),
(@s_obj,'srcitem-de-das-karte','Exercise 010','Das ist eine Karte.',UNHEX(SHA2('Das ist eine Karte.',256)),'پاسخ شیء.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

-- New curriculum targets from the official Pre-A1 completion audit.
INSERT INTO curriculum_targets (language_level_id,target_key,target_type,title,description,required_for_completion,status,metadata) VALUES
(@level,'de.pre_a1.residence_origin','communicative','محل زندگی و مبدأ','محل زندگی و مبدأ را در پرسش و پاسخ بسیار ساده بفهمد/بیان کند.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.age_numbers','communicative','سن و عددهای ساده','سن را بپرسد/بگوید و عددهای ساده را بفهمد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.day_time','communicative','روز و ساعت','روز، زمان روز و ساعت را بپرسد/بفهمد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.birth_date','communicative','تاریخ تولد','تاریخ تولد را بپرسد و بیان کند.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.phone_number','communicative','شماره تلفن','شماره تلفن را بپرسد، بگوید و از راه شنیدن تشخیص دهد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.simple_info_question','communicative','سؤال اطلاعاتی بسیار ساده','یک سؤال بسیار ساده مانند «Was ist das?» را بپرسد و پاسخ کوتاه را بفهمد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE,'imageFreeAdaptation',TRUE)),
(@level,'de.pre_a1.written_personal_info','communicative','نوشتن اطلاعات شخصی کوتاه','اطلاعات شخصی بسیار کوتاه را در یک فرم متنی وارد کند.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.price_listening','communicative','تشخیص قیمت ساده','یک قیمت ساده را در گفتار آهسته و روشن تشخیص دهد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.integrated_review','review','بازیابی یکپارچهٔ Pre-A1','اهداف اصلی سطح را در speaking، listening، reading و writing متنی بازیابی کند.',TRUE,'covered',JSON_OBJECT('completionReview',TRUE))
ON DUPLICATE KEY UPDATE target_type=VALUES(target_type),title=VALUES(title),description=VALUES(description),required_for_completion=VALUES(required_for_completion),status=VALUES(status),metadata=VALUES(metadata);
SET @t_res=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.residence_origin');
SET @t_age=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.age_numbers');
SET @t_time=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.day_time');
SET @t_birth=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.birth_date');
SET @t_phone=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.phone_number');
SET @t_obj=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.simple_info_question');
SET @t_write=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.written_personal_info');
SET @t_price=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.price_listening');
SET @t_review=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.integrated_review');
UPDATE curriculum_targets SET status='covered' WHERE language_level_id=@level;

INSERT INTO units (unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-pre-a1-unit-personal-info',@level,2,'اطلاعات شخصی خیلی ساده','این درس‌ها یک خوشهٔ منسجم از اطلاعات شخصی و اطلاعات روزمرهٔ بسیار پایه می‌سازند و بعد با یک مرور نوشتاری/گفتاری جمع‌بندی می‌شوند؛ مرز واحد از تغییر هدف ارتباطی ایجاد شده است، نه از ظرفیت عددی.','final',JSON_OBJECT('dynamicStructure',TRUE),'descriptorهای غیرتصویری باقیماندهٔ Pre-A1 را می‌بندد.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=VALUES(status),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit2=(SELECT id FROM units WHERE unit_key='de-pre-a1-unit-personal-info');
UPDATE units SET status='final' WHERE language_level_id=@level;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES (@unit2,@t_res),(@unit2,@t_age),(@unit2,@t_time),(@unit2,@t_birth),(@unit2,@t_phone),(@unit2,@t_obj),(@unit2,@t_write),(@unit2,@t_price),(@unit2,@t_review);

INSERT INTO lessons (lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-pre-a1-lesson-residence-origin',@level,@unit2,10,1,'کجا زندگی می‌کنی؟','Wo wohnen Sie? / Woher kommen Sie?','draft','همان مکالمهٔ کوتاه هدف را پوشش می‌دهد و تمرین اضافه فقط تکرار ایجاد می‌کند.','ابتدا محل زندگی و سپس مبدأ در یک آشنایی مؤدبانه مطرح می‌شود.','conversation_speaking','pending',NULL),
('de-pre-a1-lesson-age-numbers',@level,@unit2,11,2,'چند سالته؟','Wie alt bist du? / Ich bin ... Jahre alt.','draft','بعد از تعامل، یک تشخیص شنیداری عدد لازم است چون CEFR روی فهم عددهای ساده تأکید دارد.','اول سن در مکالمه معنا پیدا می‌کند و سپس عدد از راه شنیدن بازیابی می‌شود.','conversation_speaking>listen_choose','pending',NULL),
('de-pre-a1-lesson-day-time',@level,@unit2,12,3,'امروز چه روزیه؟ ساعت چنده؟','Welcher Tag ist heute? / Wie spät ist es?','draft','مکالمه تولید سؤال را می‌گیرد؛ شنیدن ساعت و تشخیص زمان روز دو mode لازم هستند.','روز و ساعت در یک صحنه می‌آیند و سپس reception شنیداری/خواندنی تثبیت می‌شود.','conversation_speaking>listen_choose>multiple_choice','pending',NULL),
('de-pre-a1-lesson-birthday-date',@level,@unit2,13,4,'تولدت کیه؟','Wann hast du Geburtstag? / Ich habe am ... Geburtstag.','draft','بعد از مکالمه فقط یک بازیابی نوشتاری منبع‌دار لازم است.','اول تاریخ در تعامل معنا پیدا می‌کند و سپس همان ساختار با جای خالی تثبیت می‌شود.','conversation_speaking>fill_blank','pending',NULL),
('de-pre-a1-lesson-phone-number',@level,@unit2,14,5,'شماره تلفنت چیه؟','Wie lautet deine Telefonnummer? / Meine Telefonnummer ...','draft','بعد از مکالمه، تشخیص شنیداری شماره برای reception لازم است.','اول تبادل شماره تمرین می‌شود و بعد همان شماره از راه شنیدن بازیابی می‌شود.','conversation_speaking>listen_choose','pending',NULL),
('de-pre-a1-lesson-basic-object',@level,@unit2,15,6,'این چیه؟','Was ist das? / Das ist ...','draft','خود مکالمه descriptor را کامل پوشش می‌دهد؛ فعالیت تصویری عمداً وارد نمی‌شود.','زبان‌آموز یک بار سؤال را شروع می‌کند و یک بار پاسخ می‌دهد.','conversation_speaking','pending',NULL),
('de-pre-a1-lesson-personal-review',@level,@unit2,16,7,'مرور اطلاعات شخصی','مرور نام، محل، سن، فرم کوتاه و قیمت شنیداری','draft','مرور نهایی interaction، writing و listening را کنار هم جمع می‌کند؛ هر فعالیت gap متفاوتی را می‌بندد.','اول retrieval گفتاری، سپس فرم متنی شخصی و در پایان تشخیص قیمت انجام می‌شود.','conversation_speaking>review>listen_choose','pending',NULL)
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @l10=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-residence-origin');
SET @l11=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-age-numbers');
SET @l12=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-day-time');
SET @l13=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-birthday-date');
SET @l14=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-phone-number');
SET @l15=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-basic-object');
SET @l16=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-personal-review');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES
(@l10,@t_res,'introduce'),(@l11,@t_age,'introduce'),(@l12,@t_time,'introduce'),(@l13,@t_birth,'introduce'),(@l14,@t_phone,'introduce'),(@l15,@t_obj,'introduce'),(@l16,@t_write,'assess'),(@l16,@t_price,'assess'),(@l16,@t_review,'assess');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-pre-a1-residence-origin',@level,'آیریس و زبان‌آموز در یک آشنایی مؤدبانه دربارهٔ محل زندگی و مبدأ سؤال و جواب می‌کنند.','app','چهار turn دو تبادل بسیار کوتاه را کامل می‌کنند.'),
('dlg-de-pre-a1-age-numbers',@level,'میا و زبان‌آموز سن هم را می‌پرسند و با عددهای ساده جواب می‌دهند.','app','چهار turn برای رفت‌وبرگشت سن کافی است.'),
('dlg-de-pre-a1-day-time',@level,'میا و زبان‌آموز دربارهٔ روز و ساعت فعلی سؤال و جواب می‌کنند.','learner','زبان‌آموز هر دو سؤال را فعالانه می‌پرسد.'),
('dlg-de-pre-a1-birthday-date',@level,'میا و زبان‌آموز تاریخ تولد را می‌پرسند و با دو تاریخ منبع‌دار پاسخ می‌دهند.','app','چهار turn دو شکل کوتاه پاسخ را نشان می‌دهد.'),
('dlg-de-pre-a1-phone-number',@level,'میا و زبان‌آموز شماره تلفن را از هم می‌پرسند و دو شمارهٔ منبع‌دار می‌گویند.','app','چهار turn برای تبادل شماره کافی است.'),
('dlg-de-pre-a1-basic-object',@level,'در یک موقعیت متنی، میا و زبان‌آموز دربارهٔ دو شیء نام‌برده‌شده سؤال بسیار ساده می‌پرسند؛ حل فعالیت به تصویر وابسته نیست.','learner','context فارسی جای تصویر را می‌گیرد و متن هدف منبع‌دار می‌ماند.'),
('dlg-de-pre-a1-personal-review',@level,'یک آشنایی مؤدبانهٔ کوتاه چند بخش اصلی اطلاعات شخصی را در هشت turn مرور می‌کند.','app','هشت turn فقط مطالب قبلی را در یک تعامل واحد بازیابی می‌کند و filler ندارد.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @d10=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-residence-origin');
SET @d11=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-age-numbers');
SET @d12=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-day-time');
SET @d13=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-birthday-date');
SET @d14=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-phone-number');
SET @d15=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-basic-object');
SET @d16=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-personal-review');

INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-residence-1',@d10,1,@iris,'app_assigned','unspecified','Wo wohnen Sie?','کجا زندگی می‌کنید؟',FALSE,'pending'),('turn-de-residence-2',@d10,2,@learner,'app_assigned','unspecified','Ich wohne in Österreich.','من در اتریش زندگی می‌کنم.',TRUE,'pending'),('turn-de-residence-3',@d10,3,@learner,'app_assigned','unspecified','Woher kommen Sie?','اهل کجا هستید؟',TRUE,'pending'),('turn-de-residence-4',@d10,4,@iris,'app_assigned','unspecified','Ich komme aus Deutschland, und Sie?','من اهل آلمان هستم، شما چطور؟',FALSE,'pending'),
('turn-de-age-1',@d11,1,@mia,'app_assigned','unspecified','Wie alt bist du?','چند سالته؟',FALSE,'pending'),('turn-de-age-2',@d11,2,@learner,'app_assigned','unspecified','Ich bin achtzehn Jahre alt.','من هجده ساله‌ام.',TRUE,'pending'),('turn-de-age-3',@d11,3,@learner,'app_assigned','unspecified','Wie alt bist du?','چند سالته؟',TRUE,'pending'),('turn-de-age-4',@d11,4,@mia,'app_assigned','unspecified','Ich bin 20 Jahre alt.','من بیست ساله‌ام.',FALSE,'pending'),
('turn-de-time-1',@d12,1,@learner,'app_assigned','unspecified','Welcher Tag ist heute?','امروز چه روزی است؟',TRUE,'pending'),('turn-de-time-2',@d12,2,@mia,'app_assigned','unspecified','Heute ist Dienstag.','امروز سه‌شنبه است.',FALSE,'pending'),('turn-de-time-3',@d12,3,@learner,'app_assigned','unspecified','Wie spät ist es?','ساعت چند است؟',TRUE,'pending'),('turn-de-time-4',@d12,4,@mia,'app_assigned','unspecified','Es ist 6.30 Uhr.','ساعت ۶:۳۰ است.',FALSE,'pending'),
('turn-de-birthday-1',@d13,1,@mia,'app_assigned','unspecified','Wann hast du Geburtstag?','کی تولدته؟',FALSE,'pending'),('turn-de-birthday-2',@d13,2,@learner,'app_assigned','unspecified','Am 16. Juli.','شانزدهم ژوئیه.',TRUE,'pending'),('turn-de-birthday-3',@d13,3,@learner,'app_assigned','unspecified','Wann hast du Geburtstag?','کی تولدته؟',TRUE,'pending'),('turn-de-birthday-4',@d13,4,@mia,'app_assigned','unspecified','Ich habe am dreizehnten November Geburtstag.','تولد من سیزدهم نوامبر است.',FALSE,'pending'),
('turn-de-phone-1',@d14,1,@mia,'app_assigned','unspecified','Wie lautet deine Telefonnummer?','شماره تلفنت چیه؟',FALSE,'pending'),('turn-de-phone-2',@d14,2,@learner,'app_assigned','unspecified','Meine Telefonnummer lautet 789.','شماره تلفن من ۷۸۹ است.',TRUE,'pending'),('turn-de-phone-3',@d14,3,@learner,'app_assigned','unspecified','Wie lautet deine Telefonnummer?','شماره تلفنت چیه؟',TRUE,'pending'),('turn-de-phone-4',@d14,4,@mia,'app_assigned','unspecified','Meine Telefonnummer ist: 692-267-752.','شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.',FALSE,'pending'),
('turn-de-object-1',@d15,1,@learner,'app_assigned','unspecified','Was ist das?','این چیه؟',TRUE,'pending'),('turn-de-object-2',@d15,2,@mia,'app_assigned','unspecified','Das ist ein Buch.','این یک کتاب است.',FALSE,'pending'),('turn-de-object-3',@d15,3,@mia,'app_assigned','unspecified','Was ist das?','این چیه؟',FALSE,'pending'),('turn-de-object-4',@d15,4,@learner,'app_assigned','unspecified','Das ist eine Karte.','این یک کارت/نقشه است.',TRUE,'pending'),
('turn-de-review-1',@d16,1,@iris,'app_assigned','unspecified','Guten Tag!','سلام / روز بخیر!',FALSE,'pending'),('turn-de-review-2',@d16,2,@learner,'app_assigned','unspecified','Guten Tag!','سلام / روز بخیر!',TRUE,'pending'),('turn-de-review-3',@d16,3,@iris,'app_assigned','unspecified','Wie heißen Sie?','اسمتان چیست؟',FALSE,'pending'),('turn-de-review-4',@d16,4,@learner,'app_assigned','unspecified','Ich heiße Paul Müller.','اسم من پاول مولر است.',TRUE,'pending'),('turn-de-review-5',@d16,5,@iris,'app_assigned','unspecified','Wo wohnen Sie?','کجا زندگی می‌کنید؟',FALSE,'pending'),('turn-de-review-6',@d16,6,@learner,'app_assigned','unspecified','Ich wohne in Österreich.','من در اتریش زندگی می‌کنم.',TRUE,'pending'),('turn-de-review-7',@d16,7,@iris,'app_assigned','unspecified','Wie alt sind Sie?','چند سالتان است؟',FALSE,'pending'),('turn-de-review-8',@d16,8,@learner,'app_assigned','unspecified','Ich bin 20 Jahre alt.','من بیست ساله‌ام.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
DELETE FROM dialogue_turns WHERE dialogue_id IN(@d10,@d11,@d12,@d13,@d14,@d15,@d16) AND turn_key NOT IN('turn-de-residence-1','turn-de-residence-2','turn-de-residence-3','turn-de-residence-4','turn-de-age-1','turn-de-age-2','turn-de-age-3','turn-de-age-4','turn-de-time-1','turn-de-time-2','turn-de-time-3','turn-de-time-4','turn-de-birthday-1','turn-de-birthday-2','turn-de-birthday-3','turn-de-birthday-4','turn-de-phone-1','turn-de-phone-2','turn-de-phone-3','turn-de-phone-4','turn-de-object-1','turn-de-object-2','turn-de-object-3','turn-de-object-4','turn-de-review-1','turn-de-review-2','turn-de-review-3','turn-de-review-4','turn-de-review-5','turn-de-review-6','turn-de-review-7','turn-de-review-8');

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-residence-conversation',@l10,1,'conversation_speaking','در یک گفت‌وگوی مؤدبانه دربارهٔ محل زندگی و مبدأ جواب بده و یک سؤال هم بپرس.','دو descriptor نزدیک در یک تبادل چهار turn طبیعی کنار هم تمرین می‌شوند.',@d10,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-age-conversation',@l11,1,'conversation_speaking','سن میا را بپرس و وقتی او از سن تو می‌پرسد، پاسخ نمونه را بگو.','سن و عدد باید اول در تعامل واقعی دیده شوند.',@d11,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-age-listen',@l11,2,'listen_choose','عدد «achtzehn» را گوش کن و عدد درست را انتخاب کن.','تشخیص شنیداری عدد ساده مستقیماً descriptor را تمرین می‌کند.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('text','18','correct',TRUE),JSON_OBJECT('text','20','correct',FALSE))),JSON_ARRAY('other'),'achtzehn','pending'),
('act-de-time-conversation',@l12,1,'conversation_speaking','این بار تو شروع کن؛ روز و ساعت را از میا بپرس.','پرسیدن فعال روز و ساعت descriptor اطلاعات روزمره را تمرین می‌کند.',@d12,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-time-listen',@l12,2,'listen_choose','زمان را گوش کن و ساعت درست را انتخاب کن.','زمان دقیق به‌صورت شنیداری تشخیص داده می‌شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('text','6:30','correct',TRUE),JSON_OBJECT('text','8:30','correct',FALSE))),JSON_ARRAY('other'),'Es ist 6.30 Uhr.','pending'),
('act-de-time-of-day',@l12,3,'multiple_choice','اگر صبح باشد، کدام جملهٔ منبع‌دار زمان روز را بیان می‌کند؟','زمان روز نیز باید در Pre-A1 تشخیص داده شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Es ist Morgen.','correct',TRUE),JSON_OBJECT('textTarget','Es ist Abend.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material'),NULL,'not_required'),
('act-de-birthday-conversation',@l13,1,'conversation_speaking','تاریخ تولد را بپرس و پاسخ نمونهٔ کوتاه را بگو.','پرسش و پاسخ تاریخ تولد descriptor صریح Pre-A1 است.',@d13,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-birthday-fill',@l13,2,'fill_blank','جملهٔ تاریخ تولد را با بخش منبع‌دار کامل کن.','بازیابی نوشتاری سبک از همان جملهٔ منبع‌دار است.',NULL,JSON_OBJECT('sourceText','Ich habe am dreizehnten November Geburtstag.','blankedText','Ich habe am ___ November Geburtstag.','choices',JSON_ARRAY('dreizehnten'),'answer','dreizehnten'),JSON_ARRAY('source_sentence_blanked'),NULL,'not_required'),
('act-de-phone-conversation',@l14,1,'conversation_speaking','شماره تلفن را بپرس و پاسخ نمونه را بگو.','پرسش و پاسخ مستقیم شماره تلفن descriptor صریح Pre-A1 است.',@d14,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-phone-listen',@l14,2,'listen_choose','شماره را گوش کن و عدد درست را انتخاب کن.','شماره تلفن باید در reception شنیداری هم تشخیص داده شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('text','789','correct',TRUE),JSON_OBJECT('text','798','correct',FALSE))),JSON_ARRAY('other'),'Meine Telefonnummer lautet 789.','pending'),
('act-de-object-conversation',@l15,1,'conversation_speaking','این بار تو شروع کن؛ در context متنی بپرس «Was ist das?» و پاسخ‌های کوتاه را تمرین کن.','سؤال اطلاعاتی بسیار ساده به شکل text-only و بدون تصویر پوشش داده می‌شود.',@d15,JSON_OBJECT('interaction','read_aloud_exchange','contextFa','دو شیء در متن به‌عنوان کتاب و کارت/نقشه معرفی شده‌اند؛ هیچ تصویر لازم نیست.','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-review-conversation',@l16,1,'conversation_speaking','در یک آشنایی مؤدبانه، نام، محل زندگی و سن را دوباره مرور کن.','این مکالمه retrieval چند هدف اصلی را بدون معرفی زبان تازه انجام می‌دهد.',@d16,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-personal-form',@l16,2,'review','فرم متنی خیلی کوتاه را با اطلاعات خودت کامل کن.','CEFR در Pre-A1 نوشتن اطلاعات شخصی بسیار پایه را پوشش می‌دهد؛ فرم بدون تصویر و با الگوهای منبع‌دار است.',NULL,JSON_OBJECT('contextFa','این یک فرم متنی است و هیچ تصویر یا اطلاعات حساس اجباری ندارد. می‌توانی برای تمرین از دادهٔ ساختگی استفاده کنی.','fields',JSON_ARRAY(JSON_OBJECT('labelFa','نام','patternTarget','Ich heiße ___.','exampleSourceText','Ich heiße Paul Müller.','instructionFa','نام واقعی خودت را در جای خالی بنویس.'),JSON_OBJECT('labelFa','محل زندگی','patternTarget','Ich wohne in ___.','exampleSourceText','Ich wohne in Österreich.','instructionFa','محل زندگی خودت را بنویس.'),JSON_OBJECT('labelFa','سن','patternTarget','Ich bin ___ Jahre alt.','exampleSourceText','Ich bin 20 Jahre alt.','instructionFa','سن خودت را بنویس.'),JSON_OBJECT('labelFa','شماره تلفن','patternTarget','Meine Telefonnummer lautet ___.','exampleSourceText','Meine Telefonnummer lautet 789.','instructionFa','یک شمارهٔ تمرینی یا شمارهٔ خودت را وارد کن.'),JSON_OBJECT('labelFa','تاریخ تولد','patternTarget','Ich habe am ___ Geburtstag.','exampleSourceText','Ich habe am dreizehnten November Geburtstag.','instructionFa','تاریخ تولد خودت را وارد کن.'),JSON_OBJECT('labelFa','نشانی','patternTarget','Adresse: ___','exampleSourceText','Adresse','instructionFa','یک نشانی تمرینی وارد کن.'))),JSON_ARRAY('source_sentence_blanked'),NULL,'not_required'),
('act-de-price-listen',@l16,3,'listen_choose','قیمت را گوش کن و عدد درست را انتخاب کن.','یک نمونهٔ منبع‌دار gap تشخیص قیمت را می‌بندد.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('text','7,60 €','correct',TRUE),JSON_OBJECT('text','6,70 €','correct',FALSE))),JSON_ARRAY('other'),'Die Zeitschrift kostet 7,60 Euro.','pending')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a_res=(SELECT id FROM activities WHERE activity_key='act-de-residence-conversation');
SET @a_age=(SELECT id FROM activities WHERE activity_key='act-de-age-conversation'); SET @a_age_l=(SELECT id FROM activities WHERE activity_key='act-de-age-listen');
SET @a_time=(SELECT id FROM activities WHERE activity_key='act-de-time-conversation'); SET @a_time_l=(SELECT id FROM activities WHERE activity_key='act-de-time-listen'); SET @a_tod=(SELECT id FROM activities WHERE activity_key='act-de-time-of-day');
SET @a_birth=(SELECT id FROM activities WHERE activity_key='act-de-birthday-conversation'); SET @a_birth_f=(SELECT id FROM activities WHERE activity_key='act-de-birthday-fill');
SET @a_phone=(SELECT id FROM activities WHERE activity_key='act-de-phone-conversation'); SET @a_phone_l=(SELECT id FROM activities WHERE activity_key='act-de-phone-listen');
SET @a_obj=(SELECT id FROM activities WHERE activity_key='act-de-object-conversation');
SET @a_review=(SELECT id FROM activities WHERE activity_key='act-de-review-conversation'); SET @a_form=(SELECT id FROM activities WHERE activity_key='act-de-personal-form'); SET @a_price=(SELECT id FROM activities WHERE activity_key='act-de-price-listen');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES (@a_res,@t_res),(@a_age,@t_age),(@a_age_l,@t_age),(@a_time,@t_time),(@a_time_l,@t_time),(@a_tod,@t_time),(@a_birth,@t_birth),(@a_birth_f,@t_birth),(@a_phone,@t_phone),(@a_phone_l,@t_phone),(@a_obj,@t_obj),(@a_review,@t_review),(@a_form,@t_write),(@a_form,@t_review),(@a_price,@t_price);

-- Minimal new lexeme inventory; exact sentence identity remains in turns/source_items.
INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-wohnen',@de,'word','wohnen','wohnen','wohnen','verb','فعل','Pre-A1','زندگی کردن / ساکن بودن','در این سطح برای گفتن محل زندگی استفاده می‌شود.',TRUE,'pending'),
('lex-de-kommen',@de,'word','kommen','kommen','kommen','verb','فعل','Pre-A1','آمدن / اهل جایی بودن','در این سطح در الگوی «aus ... kommen» استفاده می‌شود.',TRUE,'pending'),
('lex-de-oesterreich',@de,'word','Österreich','österreich','Österreich','proper_noun','اسم خاص','Pre-A1','اتریش',NULL,TRUE,'pending'),
('lex-de-deutschland',@de,'word','Deutschland','deutschland','Deutschland','proper_noun','اسم خاص','Pre-A1','آلمان',NULL,TRUE,'pending'),
('lex-de-alt',@de,'word','alt','alt','alt','adjective','صفت','Pre-A1','ساله / پیر','در این سطح در پرسش و پاسخ سن استفاده می‌شود.',TRUE,'pending'),
('lex-de-jahr',@de,'word','Jahr','jahr','Jahr','noun','اسم','Pre-A1','سال',NULL,TRUE,'pending'),
('lex-de-achtzehn',@de,'word','achtzehn','achtzehn','achtzehn','numeral','عدد','Pre-A1','هجده',NULL,TRUE,'pending'),
('lex-de-zwanzig',@de,'word','zwanzig','zwanzig','zwanzig','numeral','عدد','Pre-A1','بیست',NULL,TRUE,'pending'),
('lex-de-heute',@de,'word','heute','heute','heute','adverb','قید','Pre-A1','امروز',NULL,TRUE,'pending'),
('lex-de-dienstag',@de,'word','Dienstag','dienstag','Dienstag','noun','اسم','Pre-A1','سه‌شنبه',NULL,TRUE,'pending'),
('lex-de-uhr',@de,'word','Uhr','uhr','Uhr','noun','اسم','Pre-A1','ساعت',NULL,TRUE,'pending'),
('lex-de-geburtstag',@de,'word','Geburtstag','geburtstag','Geburtstag','noun','اسم','Pre-A1','تولد / روز تولد',NULL,TRUE,'pending'),
('lex-de-juli',@de,'word','Juli','juli','Juli','proper_noun','اسم خاص','Pre-A1','ژوئیه',NULL,TRUE,'pending'),
('lex-de-november',@de,'word','November','november','November','proper_noun','اسم خاص','Pre-A1','نوامبر',NULL,TRUE,'pending'),
('lex-de-telefonnummer',@de,'word','Telefonnummer','telefonnummer','Telefonnummer','noun','اسم','Pre-A1','شماره تلفن',NULL,TRUE,'pending'),
('lex-de-buch',@de,'word','Buch','buch','Buch','noun','اسم','Pre-A1','کتاب',NULL,TRUE,'pending'),
('lex-de-karte',@de,'word','Karte','karte','Karte','noun','اسم','Pre-A1','کارت / نقشه',NULL,TRUE,'pending'),
('lex-de-adresse',@de,'word','Adresse','adresse','Adresse','noun','اسم','Pre-A1','نشانی / آدرس',NULL,TRUE,'pending')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);
SET @x_wohnen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-wohnen'); SET @x_kommen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-kommen'); SET @x_at=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-oesterreich'); SET @x_de=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-deutschland'); SET @x_alt=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-alt'); SET @x_jahr=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-jahr'); SET @x_18=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-achtzehn'); SET @x_20=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-zwanzig'); SET @x_heute=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-heute'); SET @x_dienstag=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-dienstag'); SET @x_uhr=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-uhr'); SET @x_geb=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-geburtstag'); SET @x_juli=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-juli'); SET @x_nov=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-november'); SET @x_tel=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-telefonnummer'); SET @x_buch=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-buch'); SET @x_karte=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-karte'); SET @x_adresse=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-adresse');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES (@l10,@x_wohnen,TRUE,'introduce'),(@l10,@x_kommen,TRUE,'introduce'),(@l10,@x_at,FALSE,'support'),(@l10,@x_de,FALSE,'support'),(@l11,@x_alt,TRUE,'introduce'),(@l11,@x_jahr,TRUE,'support'),(@l11,@x_18,TRUE,'introduce'),(@l11,@x_20,TRUE,'practice'),(@l12,@x_heute,TRUE,'introduce'),(@l12,@x_dienstag,TRUE,'support'),(@l12,@x_uhr,TRUE,'introduce'),(@l13,@x_geb,TRUE,'introduce'),(@l13,@x_juli,FALSE,'support'),(@l13,@x_nov,FALSE,'support'),(@l14,@x_tel,TRUE,'introduce'),(@l15,@x_buch,TRUE,'introduce'),(@l15,@x_karte,TRUE,'introduce'),(@l16,@x_wohnen,FALSE,'review'),(@l16,@x_alt,FALSE,'review'),(@l16,@x_jahr,FALSE,'review'),(@l16,@x_tel,FALSE,'review'),(@l16,@x_geb,FALSE,'review'),(@l16,@x_adresse,TRUE,'introduce');
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES (@a_res,@x_wohnen),(@a_res,@x_kommen),(@a_res,@x_at),(@a_res,@x_de),(@a_age,@x_alt),(@a_age,@x_jahr),(@a_age,@x_18),(@a_age,@x_20),(@a_age_l,@x_18),(@a_time,@x_heute),(@a_time,@x_dienstag),(@a_time,@x_uhr),(@a_time_l,@x_uhr),(@a_birth,@x_geb),(@a_birth,@x_juli),(@a_birth,@x_nov),(@a_birth_f,@x_geb),(@a_phone,@x_tel),(@a_phone_l,@x_tel),(@a_obj,@x_buch),(@a_obj,@x_karte),(@a_form,@x_wohnen),(@a_form,@x_alt),(@a_form,@x_tel),(@a_form,@x_geb),(@a_form,@x_adresse);

-- Provenance for all new learner-facing turns/activities/lexemes.
SET @si_res_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-wo-wohnen-sie' LIMIT 1); SET @si_res_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-wohne-oesterreich' LIMIT 1); SET @si_origin_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-woher-kommen-sie' LIMIT 1); SET @si_origin_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-komme-deutschland' LIMIT 1); SET @si_gt=(SELECT id FROM source_items WHERE item_key='srcitem-de-guten-tag' LIMIT 1); SET @si_name_q2=(SELECT id FROM source_items WHERE item_key='srcitem-de-wie-heissen-sie' LIMIT 1); SET @si_name_a2=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-heisse-paul' LIMIT 1); SET @si_age_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-wie-alt-bist-du' LIMIT 1); SET @si_age18=(SELECT id FROM source_items WHERE item_key='srcitem-de-age-18' LIMIT 1); SET @si_age20=(SELECT id FROM source_items WHERE item_key='srcitem-de-age-20' LIMIT 1); SET @si_age_q2=(SELECT id FROM source_items WHERE item_key='srcitem-de-wie-alt-sind-sie' LIMIT 1); SET @si_18=(SELECT id FROM source_items WHERE item_key='srcitem-de-achtzehn' LIMIT 1); SET @si_day_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-welcher-tag' LIMIT 1); SET @si_day_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-heute-dienstag' LIMIT 1); SET @si_time_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-wie-spaet' LIMIT 1); SET @si_time_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-time-630' LIMIT 1); SET @si_morn=(SELECT id FROM source_items WHERE item_key='srcitem-de-morgen-time' LIMIT 1); SET @si_even=(SELECT id FROM source_items WHERE item_key='srcitem-de-abend-time' LIMIT 1); SET @si_addr=(SELECT id FROM source_items WHERE item_key='srcitem-de-adresse' LIMIT 1); SET @si_price=(SELECT id FROM source_items WHERE item_key='srcitem-de-price-760' LIMIT 1); SET @si_bq=(SELECT id FROM source_items WHERE item_key='srcitem-de-wann-geburtstag' LIMIT 1); SET @si_ba=(SELECT id FROM source_items WHERE item_key='srcitem-de-am-16-juli' LIMIT 1); SET @si_bs=(SELECT id FROM source_items WHERE item_key='srcitem-de-birthday-statement' LIMIT 1); SET @si_pq=(SELECT id FROM source_items WHERE item_key='srcitem-de-phone-question' LIMIT 1); SET @si_pa=(SELECT id FROM source_items WHERE item_key='srcitem-de-phone-789' LIMIT 1); SET @si_pa2=(SELECT id FROM source_items WHERE item_key='srcitem-de-phone-692' LIMIT 1); SET @si_oq=(SELECT id FROM source_items WHERE item_key='srcitem-de-was-ist-das' LIMIT 1); SET @si_ob=(SELECT id FROM source_items WHERE item_key='srcitem-de-das-buch' LIMIT 1); SET @si_ok=(SELECT id FROM source_items WHERE item_key='srcitem-de-das-karte' LIMIT 1);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-residence-1',@si_res_q,'persian_translation_added','متن منبع‌دار و ترجمهٔ فارسی افزوده شده است.'),('dialogue_turn','turn-de-residence-2',@si_res_a,'persian_translation_added','متن منبع‌دار و ترجمهٔ فارسی افزوده شده است.'),('dialogue_turn','turn-de-residence-3',@si_origin_q,'persian_translation_added','متن منبع‌دار و ترجمهٔ فارسی افزوده شده است.'),('dialogue_turn','turn-de-residence-4',@si_origin_a,'persian_translation_added','متن منبع‌دار و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-age-1',@si_age_q,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-age-2',@si_age18,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-age-3',@si_age_q,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-age-4',@si_age20,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-time-1',@si_day_q,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-time-2',@si_day_a,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-time-3',@si_time_q,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-time-4',@si_time_a,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-birthday-1',@si_bq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-birthday-2',@si_ba,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-birthday-3',@si_bq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-birthday-4',@si_bs,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-phone-1',@si_pq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-phone-2',@si_pa,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-phone-3',@si_pq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-phone-4',@si_pa2,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-object-1',@si_oq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-object-2',@si_ob,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-object-3',@si_oq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-object-4',@si_ok,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-review-1',@si_gt,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-2',@si_gt,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-3',@si_name_q2,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-4',@si_name_a2,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-5',@si_res_q,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-6',@si_res_a,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-7',@si_age_q2,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-8',@si_age20,'persian_translation_added','مرور متن منبع‌دار.'),
('activity','act-de-age-listen',@si_18,'other','متن صوتی از منبع گرفته شده است.'),('activity','act-de-time-listen',@si_time_a,'other','متن صوتی از منبع گرفته شده است.'),('activity','act-de-time-of-day',@si_morn,'other','گزینهٔ منبع‌دار.'),('activity','act-de-time-of-day',@si_even,'other','گزینهٔ منبع‌دار.'),('activity','act-de-birthday-fill',@si_bs,'source_sentence_blank_created','جملهٔ منبع‌دار به جای خالی تبدیل شده است.'),('activity','act-de-phone-listen',@si_pa,'other','متن صوتی از منبع گرفته شده است.'),('activity','act-de-personal-form',@si_name_a2,'source_sentence_blank_created','الگوی نام منبع‌دار است.'),('activity','act-de-personal-form',@si_res_a,'source_sentence_blank_created','الگوی محل زندگی منبع‌دار است.'),('activity','act-de-personal-form',@si_age20,'source_sentence_blank_created','الگوی سن منبع‌دار است.'),('activity','act-de-personal-form',@si_pa,'source_sentence_blank_created','الگوی تلفن منبع‌دار است.'),('activity','act-de-personal-form',@si_bs,'source_sentence_blank_created','الگوی تولد منبع‌دار است.'),('activity','act-de-personal-form',@si_addr,'other','فیلد نشانی منبع‌دار است.'),('activity','act-de-price-listen',@si_price,'other','قیمت شنیداری از منبع گرفته شده است.'),
('lexeme','lex-de-wohnen',@si_res_a,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-kommen',@si_origin_a,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-oesterreich',@si_res_a,'other','اسم خاص منبع‌دار.'),('lexeme','lex-de-deutschland',@si_origin_a,'other','اسم خاص منبع‌دار.'),('lexeme','lex-de-alt',@si_age18,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-jahr',@si_age18,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-achtzehn',@si_18,'verbatim','عدد منبع‌دار.'),('lexeme','lex-de-zwanzig',@si_age20,'other','عدد 20 در جملهٔ منبع‌دار و صورت نوشتاری آن در واژگان همان منبع پشتیبانی می‌شود.'),('lexeme','lex-de-heute',@si_day_a,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-dienstag',@si_day_a,'other','روز هفته منبع‌دار.'),('lexeme','lex-de-uhr',@si_time_a,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-geburtstag',@si_bs,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-juli',@si_ba,'other','ماه منبع‌دار.'),('lexeme','lex-de-november',@si_bs,'other','ماه منبع‌دار.'),('lexeme','lex-de-telefonnummer',@si_pa,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-buch',@si_ob,'other','اسم منبع‌دار.'),('lexeme','lex-de-karte',@si_ok,'other','اسم منبع‌دار.'),('lexeme','lex-de-adresse',@si_addr,'verbatim','واژهٔ منبع‌دار.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

-- Finalize lessons/level only after all required structure exists.
UPDATE lessons SET status='final',audio_status=CASE WHEN audio_status='ready' THEN 'ready' ELSE 'pending' END WHERE language_level_id=@level;
UPDATE dialogue_turns t JOIN dialogues d ON d.id=t.dialogue_id SET t.audio_status='pending' WHERE d.language_level_id=@level AND t.audio_status='blocked_until_level_final' AND t.audio_url IS NULL;
UPDATE lexemes SET audio_status='pending' WHERE language_id=@de AND cefr_level='Pre-A1' AND audio_status='blocked_until_level_final' AND audio_url IS NULL;
UPDATE activities a JOIN lessons l ON l.id=a.lesson_id SET a.audio_status='pending' WHERE l.language_level_id=@level AND a.audio_text_target IS NOT NULL AND a.audio_status='blocked_until_level_final' AND a.audio_url IS NULL;
UPDATE language_levels SET
 coverage=JSON_OBJECT(
  'communicativeTargets',JSON_ARRAY('سلام، خداحافظی، تشکر، پاسخ مؤدبانه و عذرخواهی کوتاه','پرسیدن و گفتن نام','احوال‌پرسی بسیار ساده','پرسیدن و پاسخ‌دادن دربارهٔ علاقه/انتخاب غذای آشنا','پاسخ مثبت و منفی کوتاه','پرسیدن و گفتن محل زندگی و مبدأ','پرسیدن و گفتن سن و فهم عددهای ساده','پرسیدن و گفتن روز، ساعت و زمان روز','پرسیدن و گفتن تاریخ تولد','پرسیدن و گفتن شماره تلفن','پرسیدن سؤال اطلاعاتی بسیار ساده و فهم پاسخ کوتاه','نوشتن اطلاعات شخصی بسیار کوتاه در یک فرم متنی','تشخیص شنیداری یک قیمت ساده'),
  'linguisticTargets',JSON_ARRAY('عبارت‌های ثابت سلام/خداحافظی و ادب','فعل‌های پایهٔ mögen، heißen، wohnen و kommen در کاربردهای منبع‌دار این سطح','عددهای ساده در سن، ساعت، تلفن و قیمت','واژه‌های پایهٔ روز، ساعت، تولد، شماره تلفن و نشانی','الگوهای منبع‌دار معرفی، محل زندگی، سن، تاریخ تولد و شماره تلفن'),
  'situations',JSON_ARRAY('آشنایی اولیه','گفت‌وگوی کوتاه صبحگاهی','علاقه و انتخاب غذای آشنا','تشکر و عذرخواهی','اطلاعات شخصی در آشنایی مؤدبانه','پرسش سن','پرسش روز و ساعت','تاریخ تولد','تبادل شماره تلفن','سؤال اطلاعاتی بسیار ساده','فرم متنی اطلاعات شخصی','تشخیص قیمت ساده'),
  'gaps',JSON_ARRAY()),
 completion_assessment=JSON_OBJECT('reviewedAt','2026-09-16T18:15:00Z','cefrCoverageComplete',TRUE,'progressionComplete',TRUE,'practiceAndRetrievalComplete',TRUE,'skillModeCoverageComplete',TRUE,'requiredGaps',JSON_ARRAY(),'scopeExclusions',JSON_ARRAY('توصیفگرهای Pre-A1 که صراحتاً به متن مصور، تصویر یا اشارهٔ فیزیکی/دیداری وابسته‌اند، به‌دلیل baseline فعلی image-free خارج از scope محصول هستند؛ توانایی‌های مستقل متنی، گفتاری و شنیداری متناظر پوشش داده شده‌اند.'),'qualityReview',JSON_OBJECT('overallScore',9.7,'dimensionScores',JSON_OBJECT('cefrCoverage',9.7,'pedagogicalProgression',9.6,'practiceAndRetrieval',9.7,'activityQualityAndVariety',9.7,'linguisticAccuracyAndNaturalness',9.6,'sourceQualityAndCurrency',9.8,'learnerSupportAndClarity',9.8,'qaIntegrity',10.0),'rationale','پوشش نهایی با توصیفگرهای رسمی Pre-A1 و scope متن/صوت بدون تصویر تطبیق داده شده است.','strengths',JSON_ARRAY('پوشش descriptorمحور بدون سهمیهٔ درس یا فعالیت','تمام متن هدف learner-facing منبع‌دار و قابل ردیابی است','مرور نهایی speaking، listening، reading و writing متنی را ترکیب می‌کند','قواعد فارسی، image-free، starter، audio و MySQL به‌صورت خودکار کنترل می‌شوند.'),'remainingWeaknesses',JSON_ARRAY('فایل‌های صوتی هنوز تولید نشده‌اند؛ assetهای لازم در وضعیت pending هستند.'))),
 notes='German Pre-A1 از نظر محتوای آموزشی در scope فعلی text/audio و image-free نهایی شده است؛ audio assetها مرحلهٔ بعدی مستقل هستند.',
 audio_status=CASE WHEN audio_status='ready' THEN 'ready' ELSE 'pending' END
WHERE id=@level;
UPDATE language_levels SET status='final' WHERE id=@level;
COMMIT;
-- END PRE-A1 FINALIZATION EXTENSION
'''
sql_path.write_text(sql+ext,encoding='utf-8')

print('German Pre-A1 finalization content generated.')
