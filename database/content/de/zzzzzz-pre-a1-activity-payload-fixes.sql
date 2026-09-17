-- Fix incomplete learner-facing payloads in German Pre-A1 activities.
-- Idempotent and safe for both existing databases and fresh imports.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS _prea1_payload_fix_lesson_status;
CREATE TEMPORARY TABLE _prea1_payload_fix_lesson_status AS
SELECT DISTINCT l.id AS lesson_id, l.status AS original_status
FROM lessons l
JOIN activities a ON a.lesson_id=l.id
WHERE a.activity_key IN (
  'act-de-hallo-role-match',
  'act-de-danke-bitte-role-match',
  'act-de-birthday-fill',
  'act-de-pizza-fill-mag',
  'act-de-name-fill-heisse',
  'act-de-simple-choice-fill'
);

UPDATE lessons l
JOIN _prea1_payload_fix_lesson_status b ON b.lesson_id=l.id
SET l.status='qa'
WHERE b.original_status='final';

-- Matching renderer requires both left and right values. Keep Persian companion labels too.
UPDATE activities
SET payload = JSON_SET(
  payload,
  '$.pairs[0].right','شروع گفت‌وگو',
  '$.pairs[0].rightFa','شروع گفت‌وگو',
  '$.pairs[1].right','پایان گفت‌وگو',
  '$.pairs[1].rightFa','پایان گفت‌وگو'
)
WHERE activity_key='act-de-hallo-role-match';

UPDATE activities
SET payload = JSON_SET(
  payload,
  '$.pairs[0].right','تشکر',
  '$.pairs[0].rightFa','تشکر',
  '$.pairs[1].right','پاسخ به تشکر',
  '$.pairs[1].rightFa','پاسخ به تشکر'
)
WHERE activity_key='act-de-danke-bitte-role-match';

-- A fill-blank must provide a real choice. Use two source-backed month options.
UPDATE activities
SET payload = JSON_SET(
  payload,
  '$.sourceText','Ich habe am dreizehnten November Geburtstag.',
  '$.sourceTextFa','تولد من سیزدهم نوامبر است.',
  '$.blankedText','Ich habe am dreizehnten ___ Geburtstag.',
  '$.blankedTextFa','تولد من سیزدهم ___ است.',
  '$.choices',JSON_ARRAY('November','Juli'),
  '$.choicesFa',JSON_ARRAY('نوامبر','ژوئیه'),
  '$.answer','November'
)
WHERE activity_key='act-de-birthday-fill';

-- Keep Persian companion choice labels synchronized for the newer fill-blank activities.
UPDATE activities
SET payload = JSON_SET(payload,'$.choicesFa',JSON_ARRAY('برای «من»','برای «تو»'))
WHERE activity_key='act-de-pizza-fill-mag';

UPDATE activities
SET payload = JSON_SET(payload,'$.choicesFa',JSON_ARRAY('برای «من»','برای «تو»'))
WHERE activity_key='act-de-name-fill-heisse';

UPDATE activities
SET payload = JSON_SET(payload,'$.choicesFa',JSON_ARRAY('می‌خواهی','دوست داری'))
WHERE activity_key='act-de-simple-choice-fill';

UPDATE lessons l
JOIN _prea1_payload_fix_lesson_status b ON b.lesson_id=l.id
SET l.status=b.original_status;

DROP TEMPORARY TABLE _prea1_payload_fix_lesson_status;
COMMIT;
