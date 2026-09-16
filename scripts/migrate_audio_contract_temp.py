import json
import pathlib
import re

root = pathlib.Path('.')

def replace_once(text, old, new, label):
    if old not in text:
        raise SystemExit(f'{label} anchor not found')
    return text.replace(old, new, 1)

# Canonical Persian taxonomy.
tax_path = root / 'config/fa-taxonomy.json'
tax = json.loads(tax_path.read_text(encoding='utf-8'))
tax['domains']['audio_status'] = {
    'not_required': 'نیازی به صوت ندارد',
    'blocked_until_level_final': 'متوقف تا نهایی‌شدن سطح',
    'pending': 'در انتظار تولید صوت',
    'ready': 'صوت آماده',
    'stale': 'صوت نیازمند بازتولید',
    'failed': 'تولید صوت ناموفق'
}
tax_path.write_text(json.dumps(tax, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# MySQL schema.
p = root / 'database/schema.sql'
s = p.read_text(encoding='utf-8')
s = s.replace('blocked_until_language_final', 'blocked_until_level_final')
s = s.replace('pending_final_language', 'blocked_until_level_final')
s = s.replace('not_planned_yet', 'not_required')

level_anchor = "  status ENUM('unassessed','planning','building','review','final') NOT NULL DEFAULT 'unassessed',\n  structure_rationale TEXT NULL,"
level_repl = "  status ENUM('unassessed','planning','building','review','final') NOT NULL DEFAULT 'unassessed',\n  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'blocked_until_level_final',\n  structure_rationale TEXT NULL,"
level_block=s[s.index('CREATE TABLE IF NOT EXISTS language_levels'):s.index('CREATE TABLE IF NOT EXISTS curriculum_targets')]
if 'audio_status ENUM' not in level_block:
    s=replace_once(s,level_anchor,level_repl,'language_levels')

s=s.replace("  audio_status ENUM('not_started','blocked_until_level_final','ready') NOT NULL DEFAULT 'blocked_until_level_final',",
            "  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'blocked_until_level_final',",1)

turn_old = "  audio_status ENUM('not_started','blocked_until_level_final','pending','ready') NOT NULL DEFAULT 'blocked_until_level_final',\n  audio_url TEXT NULL,\n  elevenlabs_voice_id VARCHAR(191) NULL,"
turn_new = "  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'blocked_until_level_final',\n  audio_url TEXT NULL,\n  audio_storage_path VARCHAR(1024) NULL,\n  audio_source_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_provider VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_model_id VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_voice_name VARCHAR(191) NULL,\n  audio_voice_id VARCHAR(191) NULL,\n  audio_generated_at DATETIME(6) NULL,"
s=replace_once(s,turn_old,turn_new,'dialogue_turn audio')

act_old = "  transformations JSON NULL,\n  audio_status ENUM('not_required','blocked_until_level_final','ready') NOT NULL DEFAULT 'blocked_until_level_final',"
if act_old not in s:
    act_old = "  transformations JSON NULL,\n  audio_status ENUM('not_required','blocked_until_level_final','pending','ready') NOT NULL DEFAULT 'blocked_until_level_final',"
act_new = "  transformations JSON NULL,\n  audio_text_target TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NULL,\n  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'not_required',\n  audio_url TEXT NULL,\n  audio_storage_path VARCHAR(1024) NULL,\n  audio_source_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_provider VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_model_id VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_voice_name VARCHAR(191) NULL,\n  audio_voice_id VARCHAR(191) NULL,\n  audio_generated_at DATETIME(6) NULL,"
s=replace_once(s,act_old,act_new,'activity audio')

lex_old = "  audio_status ENUM('blocked_until_level_final','pending','ready') NOT NULL DEFAULT 'blocked_until_level_final',\n  audio_url TEXT NULL,\n  audio_voice_name VARCHAR(191) NULL,\n  audio_voice_id VARCHAR(191) NULL,"
lex_new = "  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'blocked_until_level_final',\n  audio_url TEXT NULL,\n  audio_storage_path VARCHAR(1024) NULL,\n  audio_source_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_provider VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_model_id VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_voice_name VARCHAR(191) NULL,\n  audio_voice_id VARCHAR(191) NULL,\n  audio_generated_at DATETIME(6) NULL,"
s=replace_once(s,lex_old,lex_new,'lexeme audio')

ex_anchor = "  text_target TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,\n  translation_fa TEXT NOT NULL,\n  notes TEXT NULL,"
ex_repl = "  text_target TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,\n  translation_fa TEXT NOT NULL,\n  audio_required BOOLEAN NOT NULL DEFAULT FALSE,\n  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'not_required',\n  audio_url TEXT NULL,\n  audio_storage_path VARCHAR(1024) NULL,\n  audio_source_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_provider VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_model_id VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NULL,\n  audio_voice_name VARCHAR(191) NULL,\n  audio_voice_id VARCHAR(191) NULL,\n  audio_generated_at DATETIME(6) NULL,\n  notes TEXT NULL,"
if 'audio_required BOOLEAN' not in s:
    s=replace_once(s,ex_anchor,ex_repl,'example audio')

lex_trigger_anchor = "  END IF;\nEND$$\n\nDROP TRIGGER IF EXISTS trg_lexeme_occurrences_bi$$"
lex_trigger_add = "  END IF;\n  IF NOT (NEW.surface <=> OLD.surface) THEN\n    SET NEW.audio_status='blocked_until_level_final';\n    SET NEW.audio_url=NULL;\n    SET NEW.audio_storage_path=NULL;\n    SET NEW.audio_source_hash=NULL;\n    SET NEW.audio_provider=NULL;\n    SET NEW.audio_model_id=NULL;\n    SET NEW.audio_voice_name=NULL;\n    SET NEW.audio_voice_id=NULL;\n    SET NEW.audio_generated_at=NULL;\n  END IF;\nEND$$\n\nDROP TRIGGER IF EXISTS trg_dialogue_turns_bu_audio_invalidate$$\nCREATE TRIGGER trg_dialogue_turns_bu_audio_invalidate BEFORE UPDATE ON dialogue_turns FOR EACH ROW\nBEGIN\n  IF NOT (NEW.text_target <=> OLD.text_target) OR NEW.speaker_character_id<>OLD.speaker_character_id THEN\n    SET NEW.audio_status='blocked_until_level_final';\n    SET NEW.audio_url=NULL;\n    SET NEW.audio_storage_path=NULL;\n    SET NEW.audio_source_hash=NULL;\n    SET NEW.audio_provider=NULL;\n    SET NEW.audio_model_id=NULL;\n    SET NEW.audio_voice_name=NULL;\n    SET NEW.audio_voice_id=NULL;\n    SET NEW.audio_generated_at=NULL;\n  END IF;\nEND$$\n\nDROP TRIGGER IF EXISTS trg_example_sentences_bu_audio_invalidate$$\nCREATE TRIGGER trg_example_sentences_bu_audio_invalidate BEFORE UPDATE ON example_sentences FOR EACH ROW\nBEGIN\n  IF NOT (NEW.text_target <=> OLD.text_target) OR NEW.audio_required<>OLD.audio_required THEN\n    SET NEW.audio_status=IF(NEW.audio_required,'blocked_until_level_final','not_required');\n    SET NEW.audio_url=NULL;\n    SET NEW.audio_storage_path=NULL;\n    SET NEW.audio_source_hash=NULL;\n    SET NEW.audio_provider=NULL;\n    SET NEW.audio_model_id=NULL;\n    SET NEW.audio_voice_name=NULL;\n    SET NEW.audio_voice_id=NULL;\n    SET NEW.audio_generated_at=NULL;\n  END IF;\nEND$$\n\nDROP TRIGGER IF EXISTS trg_lexeme_occurrences_bi$$"
if 'trg_dialogue_turns_bu_audio_invalidate' not in s:
    s=replace_once(s,lex_trigger_anchor,lex_trigger_add,'audio invalidation triggers')

act_guard_anchor = "  IF NEW.activity_type='conversation_speaking' AND NEW.dialogue_id IS NULL THEN\n    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='conversation_speaking requires dialogue_id';\n  END IF;\n  SET lesson_status=(SELECT status FROM lessons WHERE id=OLD.lesson_id LIMIT 1);"
act_guard_repl = "  IF NEW.activity_type='conversation_speaking' AND NEW.dialogue_id IS NULL THEN\n    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='conversation_speaking requires dialogue_id';\n  END IF;\n  IF NOT (NEW.audio_text_target <=> OLD.audio_text_target) THEN\n    SET NEW.audio_status=IF(NEW.audio_text_target IS NULL,'not_required','blocked_until_level_final');\n    SET NEW.audio_url=NULL;\n    SET NEW.audio_storage_path=NULL;\n    SET NEW.audio_source_hash=NULL;\n    SET NEW.audio_provider=NULL;\n    SET NEW.audio_model_id=NULL;\n    SET NEW.audio_voice_name=NULL;\n    SET NEW.audio_voice_id=NULL;\n    SET NEW.audio_generated_at=NULL;\n  END IF;\n  SET lesson_status=(SELECT status FROM lessons WHERE id=OLD.lesson_id LIMIT 1);"
idx=s.rfind(act_guard_anchor)
if idx<0: raise SystemExit('activity update trigger anchor not found')
s=s[:idx]+s[idx:].replace(act_guard_anchor,act_guard_repl,1)

view_anchor='CREATE OR REPLACE VIEW v_invalid_learner_facing_source_links AS'
audio_view="""CREATE OR REPLACE VIEW v_audio_generation_manifest AS
SELECT 'dialogue_turn' AS owner_type,t.turn_key AS owner_key,lang.code AS language_code,ll.cefr_level,ll.status AS level_status,ll.audio_status AS level_audio_status,
       t.text_target AS audio_text,SHA2(t.text_target,256) AS expected_source_hash,c.voice_name AS expected_voice_name,c.elevenlabs_voice_id AS expected_voice_id,
       t.audio_status,t.audio_url,t.audio_storage_path,t.audio_source_hash,t.audio_provider,t.audio_model_id,t.audio_voice_name,t.audio_voice_id,t.audio_generated_at,
       (t.audio_status='ready' AND t.audio_url IS NOT NULL AND t.audio_storage_path IS NOT NULL AND t.audio_source_hash=SHA2(t.text_target,256)
        AND (c.elevenlabs_voice_id IS NULL OR t.audio_voice_id=c.elevenlabs_voice_id)) AS audio_is_current
FROM dialogue_turns t JOIN dialogues d ON d.id=t.dialogue_id JOIN language_levels ll ON ll.id=d.language_level_id JOIN languages lang ON lang.id=ll.language_id JOIN characters c ON c.id=t.speaker_character_id
UNION ALL
SELECT 'lexeme',l.lexeme_key,lang.code,ll.cefr_level,ll.status,ll.audio_status,l.surface,SHA2(l.surface,256),lang.standalone_audio_voice_name,lang.standalone_audio_voice_id,
       l.audio_status,l.audio_url,l.audio_storage_path,l.audio_source_hash,l.audio_provider,l.audio_model_id,l.audio_voice_name,l.audio_voice_id,l.audio_generated_at,
       (l.audio_status='ready' AND l.audio_url IS NOT NULL AND l.audio_storage_path IS NOT NULL AND l.audio_source_hash=SHA2(l.surface,256) AND (lang.standalone_audio_voice_id IS NULL OR l.audio_voice_id=lang.standalone_audio_voice_id))
FROM lexemes l JOIN languages lang ON lang.id=l.language_id JOIN language_levels ll ON ll.language_id=l.language_id AND ll.cefr_level=l.cefr_level WHERE l.flashcard_eligible=TRUE
UNION ALL
SELECT 'activity',a.activity_key,lang.code,ll.cefr_level,ll.status,ll.audio_status,a.audio_text_target,SHA2(a.audio_text_target,256),lang.standalone_audio_voice_name,lang.standalone_audio_voice_id,
       a.audio_status,a.audio_url,a.audio_storage_path,a.audio_source_hash,a.audio_provider,a.audio_model_id,a.audio_voice_name,a.audio_voice_id,a.audio_generated_at,
       (a.audio_status='ready' AND a.audio_url IS NOT NULL AND a.audio_storage_path IS NOT NULL AND a.audio_source_hash=SHA2(a.audio_text_target,256) AND (lang.standalone_audio_voice_id IS NULL OR a.audio_voice_id=lang.standalone_audio_voice_id))
FROM activities a JOIN lessons le ON le.id=a.lesson_id JOIN language_levels ll ON ll.id=le.language_level_id JOIN languages lang ON lang.id=ll.language_id WHERE a.audio_text_target IS NOT NULL
UNION ALL
SELECT 'example_sentence',e.example_key,lang.code,ll.cefr_level,ll.status,ll.audio_status,e.text_target,SHA2(e.text_target,256),lang.standalone_audio_voice_name,lang.standalone_audio_voice_id,
       e.audio_status,e.audio_url,e.audio_storage_path,e.audio_source_hash,e.audio_provider,e.audio_model_id,e.audio_voice_name,e.audio_voice_id,e.audio_generated_at,
       (e.audio_status='ready' AND e.audio_url IS NOT NULL AND e.audio_storage_path IS NOT NULL AND e.audio_source_hash=SHA2(e.text_target,256) AND (lang.standalone_audio_voice_id IS NULL OR e.audio_voice_id=lang.standalone_audio_voice_id))
FROM example_sentences e JOIN language_levels ll ON ll.id=e.language_level_id JOIN languages lang ON lang.id=ll.language_id WHERE e.audio_required=TRUE;

"""
if 'v_audio_generation_manifest' not in s:
    s=replace_once(s,view_anchor,audio_view+view_anchor,'audio manifest view')
p.write_text(s,encoding='utf-8')

# JSON schema/content status migration.
for path in list((root/'schemas').glob('*.json'))+list((root/'content').rglob('*.json')):
    text=path.read_text(encoding='utf-8').replace('blocked_until_language_final','blocked_until_level_final').replace('pending_final_language','blocked_until_level_final').replace('not_planned_yet','not_required')
    path.write_text(text,encoding='utf-8')

level_schema=root/'schemas/level.schema.json'; obj=json.loads(level_schema.read_text(encoding='utf-8'))
obj['properties']['audioStatus']={'enum':['not_required','blocked_until_level_final','pending','ready','stale','failed'],'default':'blocked_until_level_final'}
if 'audioStatus' not in obj['required']: obj['required'].append('audioStatus')
level_schema.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['lesson.schema.json','lexeme.schema.json']:
    sp=root/'schemas'/name; obj=json.loads(sp.read_text(encoding='utf-8')); obj['properties']['audioStatus']['enum']=['not_required','blocked_until_level_final','pending','ready','stale','failed']; sp.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
ap=root/'schemas/activity.schema.json'; obj=json.loads(ap.read_text(encoding='utf-8')); obj['properties']['audioStatus']['enum']=['not_required','blocked_until_level_final','pending','ready','stale','failed']; obj['properties']['audioTextTarget']={'type':['string','null'],'minLength':1,'default':None,'description':'متن دقیق زبان هدف برای فایل صوتی مستقل این فعالیت. برای فعالیت‌هایی که صوت مستقل ندارند null است.'}; ap.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for lp in (root/'content').glob('*/*/level.json'):
    data=json.loads(lp.read_text(encoding='utf-8')); data.setdefault('audioStatus','blocked_until_level_final'); lp.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

# Base content SQL must preserve generated audio and row identities.
for sql_path in (root/'database/content').rglob('*.sql'):
    text=sql_path.read_text(encoding='utf-8').replace('blocked_until_language_final','blocked_until_level_final').replace('pending_final_language','blocked_until_level_final').replace('not_planned_yet','not_required')
    text=text.replace('elevenlabs_voice_id)', 'audio_voice_id)').replace(',audio_status=VALUES(audio_status)','').replace('audio_status=VALUES(audio_status),','')
    text=re.sub(r"DELETE FROM dialogue_turns WHERE dialogue_id IN \([^;]+\);\n",'',text)
    m=re.search(r"(INSERT INTO dialogue_turns\n\([^\n]+\) VALUES\n)(.*?);\n\n-- Activities",text,re.S)
    if m:
        rows=m.group(2); turn_keys=re.findall(r"^\('([^']+)'",rows,re.M)
        if not turn_keys: raise SystemExit(f'No turn keys parsed in {sql_path}')
        update=("ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);\n")
        quoted=','.join("'"+k.replace("'","''")+"'" for k in turn_keys)
        dvars=','.join(f'@d{i}' for i in range(1,9))
        cleanup=f"DELETE FROM dialogue_turns WHERE dialogue_id IN ({dvars}) AND turn_key NOT IN ({quoted});\n"
        repl=m.group(1)+rows+'\n'+update+cleanup+'\n-- Activities'
        text=text[:m.start()]+repl+text[m.end():]
    sql_path.write_text(text,encoding='utf-8')

# Durable decisions/docs.
dec=root/'docs/PROJECT_DECISIONS.md'; text=dec.read_text(encoding='utf-8')
text=text.replace('## Audio\n- Audio is generated only after the whole target-language curriculum/text/speaker assignments are final.',"""## Audio
- Audio is generated **per CEFR level**, only after that level is `final` and its target-language text plus speaker/voice assignments are frozen.
- Audio/database linkage uses stable semantic keys (`turn_key`, `lexeme_key`, `activity_key`, `example_key`), never environment-specific auto-increment IDs.
- Every generated asset stores URL, repository/storage path, provider, model, voice metadata, generation time and SHA-256 of the exact spoken text.
- Re-importing base content must preserve valid audio metadata and stable row IDs. If canonical spoken text changes, linked audio is invalidated and must be regenerated.
- Generated audio mappings live separately from base content SQL under `database/audio/<language>/<level>.sql`; base content SQL must never own or overwrite generated audio URLs.""")
dec.write_text(text,encoding='utf-8')

auto=root/'docs/AUTOMATION_CONTRACT.md'; text=auto.read_text(encoding='utf-8')
if 'audio-generation manifest' not in text:
    text=text.rstrip()+"\n\n## Audio automation\n- After a CEFR level becomes final, generate audio only from `v_audio_generation_manifest`.\n- Write deterministic assets and a separate stable-key mapping SQL file under `database/audio/<language>/<level>.sql`.\n- Re-run MySQL CI after linking; ready audio must match the current text hash and expected voice.\n"
auto.write_text(text,encoding='utf-8')

(root/'docs/AUDIO_PIPELINE.md').write_text('''# Audio Pipeline

## Scope
Audio is produced after each CEFR level is finalized, not after the whole language. Finalization freezes target-language text and speaker/voice assignments for that level.

## Stable identity
Never attach audio by numeric database IDs. Use `turn_key`, `lexeme_key`, `activity_key`, or `example_key`.

## Canonical generation manifest
`v_audio_generation_manifest` exposes language, level, owner type/key, exact spoken text, SHA-256, expected voice, current audio metadata and whether the asset is current. Generate only for a final level.

## Stored metadata
Persist audio status, public URL, repository/storage path, SHA-256 of exact spoken text, provider, model ID, voice name/ID and generation timestamp.

## Deterministic path
`audio/<language>/<level>/<owner_type>/<owner_key>.mp3`

The public URL may later point to GitHub, a CDN or object storage; `audio_storage_path` preserves provider-independent identity.

## Database mapping
Generated mappings are stored separately under `database/audio/<language>/<level>.sql`. Mapping SQL updates by stable owner key and verifies exact text hash before marking an asset `ready`. Base content SQL must never overwrite generated audio metadata.

## Staleness
If spoken text changes, MySQL invalidates its audio metadata. CI also compares stored hashes and expected voices through the manifest.

## Release state
A content-final level can transition its audio state from `pending` to `ready`. It is audio-ready only when all required manifest rows are current.
''',encoding='utf-8')
idx=root/'docs/PROJECT_RULES_INDEX.md'; text=idx.read_text(encoding='utf-8')
if 'AUDIO_PIPELINE.md' not in text: text=text.rstrip()+"\n- `docs/AUDIO_PIPELINE.md` — قرارداد تولید، اتصال، اعتبارسنجی و بازتولید فایل‌های صوتی پس از نهایی‌شدن هر سطح.\n"
idx.write_text(text,encoding='utf-8')

# Reusable MySQL validator: preserve-link regression and audio invariants.
vp=root/'scripts/validate_mysql_content.sh'; v=vp.read_text(encoding='utf-8')
insert_after="printf 'Content SQL files:\\n%s\\n' \"${content_files[@]}\"\n"
if 'audio_sql_files' not in v: v=v.replace(insert_after,insert_after+"\nmapfile -t audio_sql_files < <(find database/audio -type f -name '*.sql' 2>/dev/null | sort || true)\n")
first_apply="for file in \"${content_files[@]}\"; do\n  echo \"Applying $file\"\n  mysql_file \"$file\"\ndone\n"
if '__ci_audio_preserve__' not in v:
    smoke='''
# Base content re-import must preserve stable IDs and generated audio metadata.
mysql_cmd -e "SELECT turn_key,id FROM dialogue_turns ORDER BY turn_key;" > /tmp/turn_ids_before.tsv
mysql_cmd -e "SELECT lexeme_key,id FROM lexemes ORDER BY lexeme_key;" > /tmp/lexeme_ids_before.tsv
mysql_cmd -e "UPDATE dialogue_turns SET audio_status='stale',audio_url='https://example.invalid/__ci_audio_preserve__.mp3',audio_storage_path='__ci_audio_preserve__',audio_source_hash=SHA2(text_target,256) ORDER BY id LIMIT 1;"
mysql_cmd -e "UPDATE lexemes SET audio_status='stale',audio_url='https://example.invalid/__ci_audio_preserve__.mp3',audio_storage_path='__ci_audio_preserve__',audio_source_hash=SHA2(surface,256) ORDER BY id LIMIT 1;"
for file in "${content_files[@]}"; do mysql_file "$file"; done
mysql_cmd -e "SELECT turn_key,id FROM dialogue_turns ORDER BY turn_key;" > /tmp/turn_ids_after.tsv
mysql_cmd -e "SELECT lexeme_key,id FROM lexemes ORDER BY lexeme_key;" > /tmp/lexeme_ids_after.tsv
cmp /tmp/turn_ids_before.tsv /tmp/turn_ids_after.tsv
cmp /tmp/lexeme_ids_before.tsv /tmp/lexeme_ids_after.tsv
test "$(compact_query "SELECT COUNT(*) FROM dialogue_turns WHERE audio_storage_path='__ci_audio_preserve__';")" = "1"
test "$(compact_query "SELECT COUNT(*) FROM lexemes WHERE audio_storage_path='__ci_audio_preserve__';")" = "1"
mysql_cmd -e "UPDATE dialogue_turns SET audio_status='blocked_until_level_final',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL WHERE audio_storage_path='__ci_audio_preserve__';"
mysql_cmd -e "UPDATE lexemes SET audio_status='blocked_until_level_final',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL WHERE audio_storage_path='__ci_audio_preserve__';"
for file in "${audio_sql_files[@]}"; do echo "Applying audio mapping $file"; mysql_file "$file"; done
'''
    v=v.replace(first_apply,first_apply+smoke)
second_apply="for file in \"${content_files[@]}\"; do\n  echo \"Reapplying $file\"\n  mysql_file \"$file\"\ndone\n"
if 'Reapplying audio mapping' not in v:
    v=v.replace(second_apply,second_apply+'for file in "${audio_sql_files[@]}"; do echo "Reapplying audio mapping $file"; mysql_file "$file"; done\n')
end_marker='expected_taxonomy="$(python - <<\'PY\''
if 'invalid_ready_audio=' not in v:
    checks='''invalid_ready_audio="$(compact_query "SELECT COUNT(*) FROM v_audio_generation_manifest WHERE audio_status='ready' AND audio_is_current<>1;")"
premature_ready_audio="$(compact_query "SELECT COUNT(*) FROM v_audio_generation_manifest WHERE audio_status='ready' AND level_status<>'final';")"
invalid_level_audio_ready="$(compact_query "SELECT COUNT(*) FROM language_levels ll JOIN languages lang ON lang.id=ll.language_id WHERE ll.audio_status='ready' AND EXISTS (SELECT 1 FROM v_audio_generation_manifest m WHERE m.language_code=lang.code AND m.cefr_level=ll.cefr_level AND m.audio_is_current<>1);")"
echo "audio invalid-ready=$invalid_ready_audio premature-ready=$premature_ready_audio invalid-level-ready=$invalid_level_audio_ready"
test "$invalid_ready_audio" = "0"
test "$premature_ready_audio" = "0"
test "$invalid_level_audio_ready" = "0"

'''
    v=v.replace(end_marker,checks+end_marker)
vp.write_text(v,encoding='utf-8')

# Static regression validator.
(root/'scripts/validate_audio_contracts.py').write_text('''from pathlib import Path
import sys
errors=[]
for base in [Path("database"),Path("content"),Path("schemas")]:
    if not base.exists(): continue
    for p in base.rglob("*"):
        if p.is_file() and p.suffix in {".sql",".json",".md",".sh",".py"}:
            text=p.read_text(encoding="utf-8")
            for token in ("blocked_until_language_final","pending_final_language"):
                if token in text: errors.append(f"{p}: legacy audio status {token}")
for p in Path("database/content").rglob("*.sql"):
    text=p.read_text(encoding="utf-8")
    if "DELETE FROM dialogue_turns WHERE" in text: errors.append(f"{p}: destructive dialogue_turn re-import can break audio linkage")
    if "audio_status=VALUES(audio_status)" in text: errors.append(f"{p}: base content must not overwrite generated audio status")
schema=Path("database/schema.sql").read_text(encoding="utf-8")
for required in ["v_audio_generation_manifest","audio_storage_path","audio_source_hash","audio_generated_at","blocked_until_level_final"]:
    if required not in schema: errors.append(f"database/schema.sql missing {required}")
if errors:
    print("Audio contract validation failed:")
    print("\\n".join(errors))
    sys.exit(1)
print("Audio contract validation passed.")
''',encoding='utf-8')
