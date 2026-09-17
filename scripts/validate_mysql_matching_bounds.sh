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
