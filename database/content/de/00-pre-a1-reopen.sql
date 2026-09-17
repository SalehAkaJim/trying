-- Reopen existing final German Pre-A1 lessons before the base content file is reapplied.
-- First import: no-op because the lessons do not exist yet.
-- Re-import: allows the canonical base migration to update activities without violating
-- the final-lesson activity guard. Later migrations restore the lessons to final.
-- Quality-fix review activities are temporarily moved out of the canonical range so
-- the older base migration can safely restore its historical position 3 before the
-- later quality migration moves the price listening activity back to Lesson 20 and
-- restores review positions 3 and 4.
-- Two audio-bearing activities were intentionally changed by the quality pass. Before
-- the historical base file is reapplied, restore their historical audio text while the
-- lessons are open, then mark them pending in a second update. This prevents the audio
-- invalidation trigger from leaving them blocked when the base file finalizes lessons.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

UPDATE lessons l
JOIN language_levels ll ON ll.id=l.language_level_id
JOIN languages lang ON lang.id=ll.language_id
SET l.status='qa'
WHERE lang.code='de'
  AND ll.cefr_level='Pre-A1'
  AND l.status='final';

UPDATE activities
SET position_index=98
WHERE activity_key='act-de-personal-review-match';

UPDATE activities
SET position_index=99
WHERE activity_key='act-de-personal-review-phone-check';

UPDATE activities
SET audio_text_target='Meine Telefonnummer lautet 789.'
WHERE activity_key='act-de-phone-listen'
  AND NOT (audio_text_target <=> 'Meine Telefonnummer lautet 789.');

UPDATE activities
SET audio_text_target='Die Zeitschrift kostet 7,60 Euro.'
WHERE activity_key='act-de-price-listen'
  AND NOT (audio_text_target <=> 'Die Zeitschrift kostet 7,60 Euro.');

UPDATE activities a
JOIN lessons l ON l.id=a.lesson_id
JOIN language_levels ll ON ll.id=l.language_level_id
JOIN languages lang ON lang.id=ll.language_id
SET a.audio_status='pending'
WHERE lang.code='de'
  AND ll.cefr_level='Pre-A1'
  AND a.activity_key IN ('act-de-phone-listen','act-de-price-listen')
  AND a.audio_text_target IS NOT NULL
  AND a.audio_url IS NULL;

UPDATE activities a
JOIN lessons l ON l.id=a.lesson_id
JOIN language_levels ll ON ll.id=l.language_level_id
JOIN languages lang ON lang.id=ll.language_id
SET a.audio_status='pending'
WHERE lang.code='de'
  AND ll.cefr_level='Pre-A1'
  AND a.audio_text_target IS NOT NULL
  AND a.audio_status='blocked_until_level_final'
  AND a.audio_url IS NULL;

COMMIT;
