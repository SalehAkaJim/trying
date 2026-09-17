-- Final Persian companion cleanup for the targeted Pre-A1 quality fixes.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS _prea1_quality_localization_status;
CREATE TEMPORARY TABLE _prea1_quality_localization_status AS
SELECT DISTINCT l.id AS lesson_id,l.status AS original_status
FROM lessons l
JOIN activities a ON a.lesson_id=l.id
WHERE a.activity_key IN ('act-de-wellbeing-fill','act-de-price-sentence-choice','act-de-time-of-day');

UPDATE lessons l
JOIN _prea1_quality_localization_status s ON s.lesson_id=l.id
SET l.status='qa'
WHERE s.original_status='final';

UPDATE activities
SET payload=JSON_SET(
  payload,
  '$.blankedTextFa','حالت ___؟',
  '$.choicesFa',JSON_ARRAY('جزء ثابت عبارت «حالت چطوره؟»','خوب')
)
WHERE activity_key='act-de-wellbeing-fill';

UPDATE activities
SET selection_reason='دو پاسخ قیمتِ بسیار شبیه و هر دو منبع‌دار جای گزینهٔ غلطِ نامرتبط را می‌گیرند تا پاسخ بدون خواندن دقیق عددها قابل حدس نباشد.'
WHERE activity_key='act-de-price-sentence-choice';

UPDATE activities
SET selection_reason='دو عبارت زمان روز مستقیماً از منبع آمده‌اند و واژه‌های «Morgen» و «Abend» نیز به‌عنوان مدخل‌های واژگانی منبع‌دار ثبت شده‌اند.'
WHERE activity_key='act-de-time-of-day';

UPDATE lessons l
JOIN _prea1_quality_localization_status s ON s.lesson_id=l.id
SET l.status=s.original_status;

DROP TEMPORARY TABLE _prea1_quality_localization_status;
COMMIT;
