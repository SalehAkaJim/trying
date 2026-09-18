-- German A1 re-import slot safety.
-- On a fresh database there are no A1 lessons yet, so this is a no-op.
-- On an idempotency re-import, move current lesson sequence/unit positions out of the
-- historical migration range before older A1 files replay their original slots.
-- The later A1 depth-expansion migration deterministically restores the canonical order.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';

-- Connection-independent guard for multi-file idempotency replay.
CREATE TABLE IF NOT EXISTS __a1_reimport_guard (
  id TINYINT UNSIGNED PRIMARY KEY,
  is_reimport TINYINT(1) NOT NULL
) ENGINE=InnoDB;

START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

DELETE FROM __a1_reimport_guard;
INSERT INTO __a1_reimport_guard(id,is_reimport)
SELECT 1,CASE WHEN EXISTS(
  SELECT 1 FROM lessons WHERE language_level_id=@level
) THEN 1 ELSE 0 END;

-- Re-import may replay historical activity keys/positions before the final canonical
-- Fix Pass. Reopen current A1 lessons and clear their activity slots so older files
-- can replay without colliding with the newer canonical activity set.
UPDATE lessons
SET status='qa'
WHERE language_level_id=@level AND status='final';

DELETE a
FROM activities a
JOIN lessons l ON l.id=a.lesson_id
WHERE l.language_level_id=@level;

UPDATE lessons
SET sequence_index=sequence_index+1000000,
    position_in_unit=CASE WHEN position_in_unit IS NULL THEN NULL ELSE position_in_unit+100000 END
WHERE language_level_id=@level;
COMMIT;
