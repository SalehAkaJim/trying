-- Normalize audio state after source-backed quality fixes change existing German text.
-- Audio invalidation triggers intentionally set changed targets to blocked_until_level_final.
-- Once the content change is complete, mark those exact assets stale while lessons are open.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
SET @l_phone := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-phone-number' LIMIT 1);
SET @l_price := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-ask-price' LIMIT 1);

DROP TEMPORARY TABLE IF EXISTS _prea1_quality_audio_lesson_status;
CREATE TEMPORARY TABLE _prea1_quality_audio_lesson_status AS
SELECT id AS lesson_id,status AS original_status
FROM lessons
WHERE id IN (@l_phone,@l_price);

UPDATE lessons l
JOIN _prea1_quality_audio_lesson_status s ON s.lesson_id=l.id
SET l.status='qa'
WHERE s.original_status='final';

UPDATE activities
SET audio_status='stale'
WHERE activity_key IN ('act-de-phone-listen','act-de-price-listen')
  AND audio_text_target IS NOT NULL;

UPDATE dialogue_turns
SET audio_status='stale'
WHERE turn_key IN ('turn-de-phone-2','turn-de-toilet-1','turn-de-toilet-2');

UPDATE lessons l
JOIN _prea1_quality_audio_lesson_status s ON s.lesson_id=l.id
SET l.status=s.original_status;

DROP TEMPORARY TABLE _prea1_quality_audio_lesson_status;
COMMIT;
