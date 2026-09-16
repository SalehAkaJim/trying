#!/usr/bin/env bash
set -euo pipefail

DB="language_content_test"
MYSQL_IMAGE="mysql:9.0.1"

mysql_cmd() {
  docker run --rm --network host "$MYSQL_IMAGE" mysql -N -s -h127.0.0.1 -uroot -proot "$DB" "$@"
}

mysql_file() {
  local file="$1"
  docker run --rm -i --network host "$MYSQL_IMAGE" mysql -h127.0.0.1 -uroot -proot "$DB" < "$file"
}

compact_query() {
  mysql_cmd -e "$1" | tr -d '\r[:space:]'
}

version="$(docker run --rm --network host "$MYSQL_IMAGE" mysql -N -s -h127.0.0.1 -uroot -proot -e "SELECT VERSION();" | tr -d '\r[:space:]')"
test "$version" = "9.0.1"
echo "MySQL runtime: $version"

# Schema itself must be idempotent.
mysql_file database/schema.sql
mysql_file database/schema.sql

# Every language × level SQL file is discovered automatically.
mapfile -t content_files < <(find database/content -type f -name '*.sql' | sort)
test "${#content_files[@]}" -gt 0
printf 'Content SQL files:\n%s\n' "${content_files[@]}"

mapfile -t audio_sql_files < <(find database/audio -type f -name '*.sql' 2>/dev/null | sort || true)

for file in "${content_files[@]}"; do
  echo "Applying $file"
  mysql_file "$file"
done

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

count_signature="SELECT CONCAT_WS(':',
 (SELECT COUNT(*) FROM languages),
 (SELECT COUNT(*) FROM language_levels),
 (SELECT COUNT(*) FROM curriculum_targets),
 (SELECT COUNT(*) FROM sources),
 (SELECT COUNT(*) FROM source_items),
 (SELECT COUNT(*) FROM characters),
 (SELECT COUNT(*) FROM units),
 (SELECT COUNT(*) FROM lessons),
 (SELECT COUNT(*) FROM dialogues),
 (SELECT COUNT(*) FROM dialogue_turns),
 (SELECT COUNT(*) FROM activities),
 (SELECT COUNT(*) FROM lexemes),
 (SELECT COUNT(*) FROM lexeme_forms),
 (SELECT COUNT(*) FROM lexeme_occurrences),
 (SELECT COUNT(*) FROM provenance_links),
 (SELECT COUNT(*) FROM taxonomy_labels));"
before="$(compact_query "$count_signature")"

for file in "${content_files[@]}"; do
  echo "Reapplying $file"
  mysql_file "$file"
done
for file in "${audio_sql_files[@]}"; do echo "Reapplying audio mapping $file"; mysql_file "$file"; done
after="$(compact_query "$count_signature")"
echo "Before: $before"
echo "After:  $after"
test "$before" = "$after"

# Authoring level manifests and DB lesson counts must be identical.
python - <<'PY' > /tmp/expected_levels.tsv
import json, pathlib
rows=[]
for path in pathlib.Path('content').glob('*/*/level.json'):
    data=json.loads(path.read_text(encoding='utf-8'))
    rows.append((data['languageId'], data['level'], len(data.get('lessonRefs', []))))
for row in sorted(rows):
    print('\t'.join(map(str, row)))
PY

mysql_cmd -e "
  SELECT lang.code,ll.cefr_level,COUNT(l.id)
  FROM language_levels ll
  JOIN languages lang ON lang.id=ll.language_id
  LEFT JOIN lessons l ON l.language_level_id=ll.id
  GROUP BY lang.code,ll.cefr_level
  ORDER BY lang.code,FIELD(ll.cefr_level,'Pre-A1','A1','A2','B1','B2','C1','C2');
" > /tmp/actual_levels.tsv

python - <<'PY'
import pathlib, sys
def read(path):
    out={}
    for line in pathlib.Path(path).read_text(encoding='utf-8').splitlines():
        if line.strip():
            lang, level, count=line.split('\t')
            out[(lang, level)]=int(count)
    return out
expected=read('/tmp/expected_levels.tsv')
actual=read('/tmp/actual_levels.tsv')
if expected != actual:
    print('Authoring/MySQL level mismatch')
    print('Expected:', expected)
    print('Actual:  ', actual)
    sys.exit(1)
print('Authoring/MySQL manifests are synchronized:', expected)
PY

# Dialogue starter is canonical relational data in MySQL and must match authoring JSON.
python - <<'PY' > /tmp/expected_dialogue_starters.tsv
import json, pathlib
rows=[]
for path in pathlib.Path('content').glob('*/*/dialogues/*.json'):
    data=json.loads(path.read_text(encoding='utf-8'))
    rows.append((data['id'], data['openingInitiator']))
for row in sorted(rows):
    print('\t'.join(row))
PY
mysql_cmd -e "SELECT dialogue_key,opening_initiator FROM dialogues ORDER BY dialogue_key;" > /tmp/actual_dialogue_starters.tsv

python - <<'PY'
import pathlib, sys
def read(path):
    out={}
    for line in pathlib.Path(path).read_text(encoding='utf-8').splitlines():
        if line.strip():
            key, value=line.split('\t')
            out[key]=value
    return out
expected=read('/tmp/expected_dialogue_starters.tsv')
actual=read('/tmp/actual_dialogue_starters.tsv')
if expected != actual:
    print('Authoring/MySQL dialogue starter mismatch')
    print('Expected:', expected)
    print('Actual:  ', actual)
    sys.exit(1)
print(f'Dialogue starter synchronization passed for {len(expected)} dialogues.')
PY

missing_openings="$(compact_query "SELECT COUNT(*) FROM lessons l LEFT JOIN activities a ON a.lesson_id=l.id AND a.position_index=1 WHERE a.id IS NULL OR a.activity_type<>'conversation_speaking' OR a.dialogue_id IS NULL;")"
invalid_turns="$(compact_query "SELECT COUNT(*) FROM (SELECT a.id,COUNT(t.id)c FROM activities a JOIN dialogue_turns t ON t.dialogue_id=a.dialogue_id WHERE a.position_index=1 AND a.activity_type='conversation_speaking' GROUP BY a.id HAVING c<4 OR c>12)x;")"
invalid_first_ten="$(compact_query "WITH ranked_levels AS (SELECT ll.id,ll.language_id,CASE ll.cefr_level WHEN 'Pre-A1' THEN 0 WHEN 'A1' THEN 1 WHEN 'A2' THEN 2 WHEN 'B1' THEN 3 WHEN 'B2' THEN 4 WHEN 'C1' THEN 5 WHEN 'C2' THEN 6 END AS level_rank FROM language_levels ll), beginner_rank AS (SELECT language_id,MIN(level_rank) AS level_rank FROM ranked_levels GROUP BY language_id), beginner_levels AS (SELECT r.id FROM ranked_levels r JOIN beginner_rank b ON b.language_id=r.language_id AND b.level_rank=r.level_rank) SELECT COUNT(*) FROM (SELECT l.id,COUNT(t.id)c FROM lessons l JOIN beginner_levels bl ON bl.id=l.language_level_id JOIN activities a ON a.lesson_id=l.id AND a.position_index=1 AND a.activity_type='conversation_speaking' JOIN dialogue_turns t ON t.dialogue_id=a.dialogue_id WHERE l.sequence_index<=10 GROUP BY l.id HAVING c<>4)x;")"

# MySQL owns structural starter semantics only. The Persian learner-start wording rule is
# intentionally enforced by scripts/validate_project_contracts.py using Unicode-aware Python.
invalid_starters="$(compact_query "SELECT COUNT(*) FROM (SELECT d.opening_initiator initiator,t.learner_turn FROM activities a JOIN dialogues d ON d.id=a.dialogue_id JOIN dialogue_turns t ON t.dialogue_id=a.dialogue_id AND t.position_index=1 WHERE a.position_index=1 AND a.activity_type='conversation_speaking')x WHERE initiator NOT IN ('app','learner') OR (initiator='learner' AND learner_turn<>1) OR (initiator='app' AND learner_turn<>0);")"
invalid_payload_starters="$(compact_query "SELECT COUNT(*) FROM activities a JOIN dialogues d ON d.id=a.dialogue_id WHERE a.position_index=1 AND a.activity_type='conversation_speaking' AND JSON_EXTRACT(a.payload,'$.openingInitiator') IS NOT NULL AND JSON_UNQUOTE(JSON_EXTRACT(a.payload,'$.openingInitiator'))<>d.opening_initiator;")"
invalid_sources="$(compact_query "SELECT COUNT(*) FROM v_invalid_learner_facing_source_links;")"
invalid_pos="$(compact_query "SELECT COUNT(*) FROM lexemes l LEFT JOIN taxonomy_labels t ON t.domain_code='part_of_speech' AND t.value_code=l.part_of_speech WHERE l.part_of_speech IS NOT NULL AND (t.label_fa IS NULL OR l.part_of_speech_fa IS NULL OR l.part_of_speech_fa<>t.label_fa);")"

echo "missing openings=$missing_openings invalid lengths=$invalid_turns invalid first-ten=$invalid_first_ten invalid starters=$invalid_starters payload starter drift=$invalid_payload_starters invalid sources=$invalid_sources invalid POS labels=$invalid_pos"
test "$missing_openings" = "0"
test "$invalid_turns" = "0"
test "$invalid_first_ten" = "0"
test "$invalid_starters" = "0"
test "$invalid_payload_starters" = "0"
test "$invalid_sources" = "0"
test "$invalid_pos" = "0"

invalid_ready_audio="$(compact_query "SELECT COUNT(*) FROM v_audio_generation_manifest WHERE audio_status='ready' AND audio_is_current<>1;")"
premature_ready_audio="$(compact_query "SELECT COUNT(*) FROM v_audio_generation_manifest WHERE audio_status='ready' AND level_status<>'final';")"
invalid_level_audio_ready="$(compact_query "SELECT COUNT(*) FROM language_levels ll JOIN languages lang ON lang.id=ll.language_id WHERE ll.audio_status='ready' AND EXISTS (SELECT 1 FROM v_audio_generation_manifest m WHERE m.language_code=lang.code AND m.cefr_level=ll.cefr_level AND m.audio_is_current<>1);")"
echo "audio invalid-ready=$invalid_ready_audio premature-ready=$premature_ready_audio invalid-level-ready=$invalid_level_audio_ready"
test "$invalid_ready_audio" = "0"
test "$premature_ready_audio" = "0"
test "$invalid_level_audio_ready" = "0"

expected_taxonomy="$(python - <<'PY'
import json
values=json.load(open('config/fa-taxonomy.json',encoding='utf-8'))['domains']
print(sum(len(v) for v in values.values()))
PY
)"
actual_taxonomy="$(compact_query "SELECT COUNT(*) FROM taxonomy_labels;")"
echo "taxonomy expected=$expected_taxonomy actual=$actual_taxonomy"
test "$expected_taxonomy" = "$actual_taxonomy"

# All assistant-authored/support prose stored in MySQL must contain Persian text.
mysql_cmd -e "
  SELECT HEX(txt) FROM (
    SELECT name_fa txt FROM languages
    UNION ALL SELECT structure_rationale FROM language_levels WHERE structure_rationale IS NOT NULL
    UNION ALL SELECT notes FROM language_levels WHERE notes IS NOT NULL
    UNION ALL SELECT title FROM curriculum_targets
    UNION ALL SELECT description FROM curriculum_targets WHERE description IS NOT NULL
    UNION ALL SELECT currency_evidence FROM sources
    UNION ALL SELECT notes FROM sources WHERE notes IS NOT NULL
    UNION ALL SELECT notes FROM source_items WHERE notes IS NOT NULL
    UNION ALL SELECT context_notes FROM characters WHERE context_notes IS NOT NULL
    UNION ALL SELECT title_fa FROM units
    UNION ALL SELECT grouping_rationale FROM units
    UNION ALL SELECT notes FROM units WHERE notes IS NOT NULL
    UNION ALL SELECT title_fa FROM lessons
    UNION ALL SELECT activity_selection_rationale FROM lessons WHERE activity_selection_rationale IS NOT NULL
    UNION ALL SELECT sequence_rationale FROM lessons WHERE sequence_rationale IS NOT NULL
    UNION ALL SELECT notes FROM lessons WHERE notes IS NOT NULL
    UNION ALL SELECT scenario FROM dialogues
    UNION ALL SELECT scene_quality_rationale FROM dialogues WHERE scene_quality_rationale IS NOT NULL
    UNION ALL SELECT translation_fa FROM dialogue_turns
    UNION ALL SELECT instruction_fa FROM activities WHERE instruction_fa IS NOT NULL
    UNION ALL SELECT selection_reason FROM activities WHERE selection_reason IS NOT NULL
    UNION ALL SELECT translation_fa FROM lexemes
    UNION ALL SELECT usage_note_fa FROM lexemes WHERE usage_note_fa IS NOT NULL
    UNION ALL SELECT part_of_speech_fa FROM lexemes WHERE part_of_speech_fa IS NOT NULL
    UNION ALL SELECT notes FROM lexeme_forms WHERE notes IS NOT NULL
    UNION ALL SELECT title_fa FROM grammar_notes
    UNION ALL SELECT translation_fa FROM grammar_notes
    UNION ALL SELECT translation_fa FROM example_sentences
    UNION ALL SELECT notes FROM example_sentences WHERE notes IS NOT NULL
    UNION ALL SELECT resolution_notes FROM lexeme_occurrences WHERE resolution_notes IS NOT NULL
    UNION ALL SELECT notes FROM provenance_links WHERE notes IS NOT NULL
  ) editorial;
" > /tmp/editorial_hex.tsv

python - <<'PY'
import pathlib, re, sys
fa=re.compile(r'[\u0600-\u06FF]')
rows=[]
for raw in pathlib.Path('/tmp/editorial_hex.tsv').read_text(encoding='ascii').splitlines():
    raw=raw.strip()
    if raw:
        rows.append(bytes.fromhex(raw).decode('utf-8'))
bad=[row for row in rows if not fa.search(row)]
if bad:
    print('Non-Persian editorial/support rows stored in MySQL:')
    print('\n'.join(bad))
    sys.exit(1)
print(f'Persian MySQL prose check passed for {len(rows)} rows.')
PY

echo "Cross-language MySQL validation passed."
