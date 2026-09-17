-- Reopen Unit 3 lessons before the idempotent Unit 3 upsert runs again.
-- On the first import these rows do not exist, so this is intentionally a no-op.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;
UPDATE lessons
SET status='qa'
WHERE lesson_key IN (
  'de-pre-a1-lesson-food-today',
  'de-pre-a1-lesson-simple-order',
  'de-pre-a1-lesson-need-and-buy'
) AND status='final';
COMMIT;
