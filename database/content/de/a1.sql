
-- ===== FINAL RUNTIME GUARD CONSOLIDATED FROM lesson-target-titles =====
DELIMITER $$
DROP TRIGGER IF EXISTS trg_lessons_bu_final_guard$$
CREATE TRIGGER trg_lessons_bu_final_guard BEFORE UPDATE ON lessons FOR EACH ROW
BEGIN
  DECLARE opening_count INT DEFAULT 0;
  IF (NEW.unit_id IS NULL AND NEW.position_in_unit IS NOT NULL)
     OR (NEW.unit_id IS NOT NULL AND (NEW.position_in_unit IS NULL OR NEW.position_in_unit<1)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='unit_id and position_in_unit must be set together';
  END IF;
  IF NEW.status='final' AND (
       NEW.source_title IS NULL OR TRIM(NEW.source_title)=''
       OR NEW.source_title_fa IS NULL OR TRIM(NEW.source_title_fa)=''
     ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='A final lesson requires target-language source_title and Persian source_title_fa';
  END IF;
  IF NEW.status='final' AND OLD.status<>'final' THEN
    SELECT COUNT(*) INTO opening_count FROM activities
    WHERE lesson_id=NEW.id AND position_index=1 AND activity_type='conversation_speaking';
    IF opening_count<>1 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='A final lesson must begin with conversation_speaking';
    END IF;
  END IF;
END$$
DELIMITER ;
