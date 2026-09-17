-- Reopen the three Unit 4 lessons before the idempotent Unit 4 upsert runs.
-- On the first import the lessons do not exist yet, so this is a no-op.
-- On re-import it allows activity updates without violating final-lesson guards.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
UPDATE lessons
SET status='qa'
WHERE language_level_id=@level
  AND lesson_key IN (
    'de-pre-a1-lesson-ask-price',
    'de-pre-a1-lesson-find-toilet',
    'de-pre-a1-lesson-need-help'
  )
  AND status='final';
