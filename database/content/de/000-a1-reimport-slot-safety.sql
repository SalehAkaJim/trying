-- German A1 re-import slot safety.
-- On a fresh database there are no A1 lessons yet, so this is a no-op.
-- On an idempotency re-import, move current lesson sequence/unit positions out of the
-- historical migration range before older A1 files replay their original slots.
-- The later A1 depth-expansion migration deterministically restores the canonical order.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
UPDATE lessons
SET sequence_index=sequence_index+1000000,
    position_in_unit=CASE WHEN position_in_unit IS NULL THEN NULL ELSE position_in_unit+100000 END
WHERE language_level_id=@level;
COMMIT;
