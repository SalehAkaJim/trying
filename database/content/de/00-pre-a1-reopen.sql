-- Reopen existing final German Pre-A1 lessons before the base content file is reapplied.
-- First import: no-op because the lessons do not exist yet.
-- Re-import: allows the canonical base migration to update activities without violating
-- the final-lesson activity guard. Later migrations restore the lessons to final.
-- Quality-fix review activities are temporarily moved out of the canonical range so
-- the older base migration can safely restore its historical position 3 before the
-- later quality migration moves the price listening activity back to Lesson 20 and
-- restores review positions 3 and 4.

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

COMMIT;
