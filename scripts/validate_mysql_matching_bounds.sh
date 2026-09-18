#!/usr/bin/env bash
set -euo pipefail

DB="language_content_test"
MYSQL_IMAGE="mysql:9.0.1"

mysql_cmd() {
  docker run --rm --network host "$MYSQL_IMAGE" mysql -N -s -h127.0.0.1 -uroot -proot "$DB" "$@"
}

compact_query() {
  mysql_cmd -e "$1" | tr -d '\r[:space:]'
}

global_invalid="$(compact_query "
  SELECT COUNT(*)
  FROM activities a
  WHERE a.activity_type='matching'
    AND (
      JSON_TYPE(JSON_EXTRACT(a.payload,'$.pairs')) <> 'ARRAY'
      OR COALESCE(JSON_LENGTH(JSON_EXTRACT(a.payload,'$.pairs')),0) NOT BETWEEN 4 AND 8
    );
")"

pre_a1_invalid="$(compact_query "
  SELECT COUNT(*)
  FROM activities a
  JOIN lessons l ON l.id=a.lesson_id
  JOIN language_levels ll ON ll.id=l.language_level_id
  WHERE a.activity_type='matching'
    AND ll.cefr_level='Pre-A1'
    AND COALESCE(JSON_LENGTH(JSON_EXTRACT(a.payload,'$.pairs')),0) <> 4;
")"

echo "matching invalid-global=$global_invalid invalid-pre-a1=$pre_a1_invalid"
test "$global_invalid" = "0"
test "$pre_a1_invalid" = "0"


# Matching pairMode/script contract mirrors the authoring validator.
mysql_cmd -e "
  SELECT lang.code,l.lesson_key,a.activity_key,HEX(CAST(a.payload AS CHAR CHARACTER SET utf8mb4))
  FROM activities a
  JOIN lessons l ON l.id=a.lesson_id
  JOIN language_levels ll ON ll.id=l.language_level_id
  JOIN languages lang ON lang.id=ll.language_id
  WHERE a.activity_type='matching'
  ORDER BY lang.code,l.lesson_key,a.position_index;
" > /tmp/mysql_matching_payloads.tsv

python - <<'PY'
import json, pathlib, re, sys
fa=re.compile(r'[\u0600-\u06FF]')
errors=[]
checked=0
for raw in pathlib.Path('/tmp/mysql_matching_payloads.tsv').read_text(encoding='ascii').splitlines():
    if not raw.strip():
        continue
    language,lesson,activity,payload_hex=raw.split('\t',3)
    payload=json.loads(bytes.fromhex(payload_hex).decode('utf-8'))
    mode=payload.get('pairMode')
    if mode not in {'target_to_persian','target_to_target'}:
        errors.append(f'{lesson}:{activity}: missing/invalid pairMode {mode!r}')
        continue
    for index,pair in enumerate(payload.get('pairs') or [],1):
        checked += 1
        left=str(pair.get('left') or '')
        right=str(pair.get('right') or '')
        left_fa=str(pair.get('leftFa') or '')
        right_fa=str(pair.get('rightFa') or '')
        if not fa.search(left_fa) or not fa.search(right_fa):
            errors.append(f'{lesson}:{activity}: pair {index} missing Persian companion')
        if language=='de' and fa.search(left):
            errors.append(f'{lesson}:{activity}: pair {index} German left contains Persian')
        if mode=='target_to_persian' and not fa.search(right):
            errors.append(f'{lesson}:{activity}: pair {index} target_to_persian right is not Persian')
        if mode=='target_to_target' and language=='de' and fa.search(right):
            errors.append(f'{lesson}:{activity}: pair {index} target_to_target right contains Persian')
if errors:
    print('MySQL matching pairMode/script contract failed:')
    print('\n'.join(f'- {e}' for e in errors))
    sys.exit(1)
print(f'MySQL matching pairMode/script contract passed for {checked} pairs.')
PY
