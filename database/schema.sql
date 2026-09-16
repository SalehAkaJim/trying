-- Language Learning Content Database
-- Canonical target: MySQL 9.0.1
-- Structure only. Educational rows belong in database/content/<language>/<level>.sql.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';

CREATE TABLE IF NOT EXISTS languages (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  name_native VARCHAR(128) NOT NULL,
  name_fa VARCHAR(128) NOT NULL,
  status ENUM('planned','building','review','final','audio_ready') NOT NULL DEFAULT 'planned',
  standalone_audio_voice_name VARCHAR(128) NULL,
  standalone_audio_voice_id VARCHAR(191) NULL,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id), UNIQUE KEY uq_languages_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS language_levels (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  language_id BIGINT UNSIGNED NOT NULL,
  cefr_level ENUM('Pre-A1','A1','A2','B1','B2','C1','C2') NOT NULL,
  status ENUM('unassessed','planning','building','review','final') NOT NULL DEFAULT 'unassessed',
  structure_rationale TEXT NULL,
  coverage JSON NOT NULL,
  notes TEXT NULL,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (id),
  UNIQUE KEY uq_language_levels_language_level (language_id, cefr_level),
  CONSTRAINT fk_language_levels_language FOREIGN KEY (language_id) REFERENCES languages(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS curriculum_targets (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  language_level_id BIGINT UNSIGNED NOT NULL,
  target_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  target_type ENUM('communicative','linguistic','situation','pronunciation','grammar','lexical','review','other') NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NULL,
  required_for_completion BOOLEAN NOT NULL DEFAULT TRUE,
  status ENUM('uncovered','partial','covered','review') NOT NULL DEFAULT 'uncovered',
  metadata JSON NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_curriculum_targets_level_key (language_level_id, target_key),
  KEY idx_curriculum_targets_status (language_level_id, status),
  CONSTRAINT fk_curriculum_targets_level FOREIGN KEY (language_level_id) REFERENCES language_levels(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS sources (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  source_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  title VARCHAR(500) NOT NULL,
  organization_or_author VARCHAR(500) NULL,
  language_code VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  source_type ENUM('course','book','website','corpus','dictionary','grammar_reference','audio_course','other') NOT NULL,
  url TEXT NULL,
  published_or_updated_at VARCHAR(64) NULL,
  modernity_status ENUM('contemporary_verified','maintained_current','historical_or_legacy','needs_currency_review') NOT NULL,
  currency_evidence TEXT NOT NULL,
  license_name VARCHAR(191) NULL,
  license_url TEXT NULL,
  attribution_text TEXT NULL,
  reuse_status ENUM('direct_reuse_allowed','reuse_with_attribution','analysis_only','needs_review') NOT NULL,
  retrieved_at DATE NULL,
  notes TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_sources_key (source_key),
  KEY idx_sources_modernity_reuse (modernity_status, reuse_status),
  CONSTRAINT chk_sources_modernity_reuse CHECK (
    (modernity_status='historical_or_legacy' AND reuse_status='analysis_only') OR
    (modernity_status='needs_currency_review' AND reuse_status IN ('analysis_only','needs_review')) OR
    modernity_status IN ('contemporary_verified','maintained_current')
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS source_items (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  source_id BIGINT UNSIGNED NOT NULL,
  item_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  locator VARCHAR(500) NULL,
  source_text LONGTEXT NULL,
  source_text_hash BINARY(32) NULL COMMENT 'Optional SHA-256 of exact reusable source text',
  notes TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_source_items_key (source_id, item_key),
  CONSTRAINT fk_source_items_source FOREIGN KEY (source_id) REFERENCES sources(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS characters (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  character_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  language_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(191) NOT NULL,
  origin ENUM('source','app_created') NOT NULL,
  gender ENUM('female','male','unspecified','not_applicable') NOT NULL,
  age_band ENUM('child','teen','young_adult','adult','middle_aged','older_adult','unspecified') NOT NULL DEFAULT 'unspecified',
  roles JSON NULL,
  relationship_tags JSON NULL,
  context_notes TEXT NULL,
  voice_profile JSON NULL,
  elevenlabs_voice_id VARCHAR(191) NULL,
  voice_name VARCHAR(191) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_characters_key (character_key),
  CONSTRAINT fk_characters_language FOREIGN KEY (language_id) REFERENCES languages(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS units (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  unit_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  language_level_id BIGINT UNSIGNED NOT NULL,
  sequence_index INT UNSIGNED NULL,
  title_fa VARCHAR(255) NOT NULL,
  grouping_rationale TEXT NOT NULL,
  status ENUM('draft','review','final') NOT NULL DEFAULT 'draft',
  metadata JSON NULL,
  notes TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_units_key (unit_key),
  UNIQUE KEY uq_units_id_level (id, language_level_id),
  UNIQUE KEY uq_units_level_sequence (language_level_id, sequence_index),
  CONSTRAINT chk_units_sequence CHECK (sequence_index IS NULL OR sequence_index>=1),
  CONSTRAINT fk_units_level FOREIGN KEY (language_level_id) REFERENCES language_levels(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS lessons (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  lesson_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  language_level_id BIGINT UNSIGNED NOT NULL,
  unit_id BIGINT UNSIGNED NULL,
  sequence_index INT UNSIGNED NOT NULL,
  position_in_unit INT UNSIGNED NULL,
  title_fa VARCHAR(255) NOT NULL,
  source_title VARCHAR(500) NULL,
  status ENUM('draft','source_checked','cefr_checked','qa','final') NOT NULL DEFAULT 'draft',
  activity_selection_rationale TEXT NULL,
  sequence_rationale TEXT NULL,
  template_signature VARCHAR(500) NULL,
  audio_status ENUM('not_started','blocked_until_language_final','ready') NOT NULL DEFAULT 'blocked_until_language_final',
  notes TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_lessons_key (lesson_key),
  UNIQUE KEY uq_lessons_level_sequence (language_level_id, sequence_index),
  UNIQUE KEY uq_lessons_unit_position (unit_id, position_in_unit),
  CONSTRAINT chk_lessons_sequence CHECK (sequence_index>=1),
  CONSTRAINT fk_lessons_level FOREIGN KEY (language_level_id) REFERENCES language_levels(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_lessons_unit_level FOREIGN KEY (unit_id,language_level_id) REFERENCES units(id,language_level_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS unit_targets (
  unit_id BIGINT UNSIGNED NOT NULL,
  curriculum_target_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (unit_id,curriculum_target_id),
  CONSTRAINT fk_unit_targets_unit FOREIGN KEY (unit_id) REFERENCES units(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_unit_targets_target FOREIGN KEY (curriculum_target_id) REFERENCES curriculum_targets(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS lesson_targets (
  lesson_id BIGINT UNSIGNED NOT NULL,
  curriculum_target_id BIGINT UNSIGNED NOT NULL,
  coverage_role ENUM('introduce','practice','review','assess','support') NOT NULL,
  PRIMARY KEY (lesson_id,curriculum_target_id,coverage_role),
  CONSTRAINT fk_lesson_targets_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_lesson_targets_target FOREIGN KEY (curriculum_target_id) REFERENCES curriculum_targets(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS dialogues (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  dialogue_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  language_level_id BIGINT UNSIGNED NOT NULL,
  scenario TEXT NOT NULL,
  scene_quality_rationale TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_dialogues_key (dialogue_key),
  CONSTRAINT fk_dialogues_level FOREIGN KEY (language_level_id) REFERENCES language_levels(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS dialogue_turns (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  turn_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  dialogue_id BIGINT UNSIGNED NOT NULL,
  position_index INT UNSIGNED NOT NULL,
  speaker_character_id BIGINT UNSIGNED NOT NULL,
  speaker_identity_origin ENUM('source','app_assigned') NOT NULL,
  speaker_gender_evidence ENUM('female','male','unspecified','not_applicable') NULL,
  text_target TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  translation_fa TEXT NOT NULL,
  learner_turn BOOLEAN NOT NULL DEFAULT FALSE,
  audio_status ENUM('not_started','blocked_until_language_final','pending','ready') NOT NULL DEFAULT 'blocked_until_language_final',
  audio_url TEXT NULL,
  elevenlabs_voice_id VARCHAR(191) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_dialogue_turns_key (turn_key),
  UNIQUE KEY uq_dialogue_turns_position (dialogue_id,position_index),
  CONSTRAINT chk_dialogue_turns_position CHECK (position_index>=1),
  CONSTRAINT fk_dialogue_turns_dialogue FOREIGN KEY (dialogue_id) REFERENCES dialogues(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_dialogue_turns_character FOREIGN KEY (speaker_character_id) REFERENCES characters(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS activities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  activity_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  lesson_id BIGINT UNSIGNED NOT NULL,
  position_index INT UNSIGNED NOT NULL,
  activity_type ENUM('conversation_speaking','listen_choose','multiple_choice','choose_response','word_order','fill_blank','matching','listen_repeat','pronunciation_read','grammar_focus','comprehension','true_false','review') NOT NULL,
  instruction_fa TEXT NULL,
  selection_reason TEXT NULL,
  dialogue_id BIGINT UNSIGNED NULL,
  payload JSON NOT NULL,
  transformations JSON NULL,
  audio_status ENUM('not_planned_yet','pending_final_language','ready') NOT NULL DEFAULT 'pending_final_language',
  PRIMARY KEY (id),
  UNIQUE KEY uq_activities_key (activity_key),
  UNIQUE KEY uq_activities_lesson_position (lesson_id,position_index),
  CONSTRAINT chk_activities_position CHECK (position_index>=1),
  CONSTRAINT chk_activities_opening CHECK (position_index<>1 OR activity_type='conversation_speaking'),
  CONSTRAINT fk_activities_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_activities_dialogue FOREIGN KEY (dialogue_id) REFERENCES dialogues(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS activity_targets (
  activity_id BIGINT UNSIGNED NOT NULL,
  curriculum_target_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (activity_id,curriculum_target_id),
  CONSTRAINT fk_activity_targets_activity FOREIGN KEY (activity_id) REFERENCES activities(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_activity_targets_target FOREIGN KEY (curriculum_target_id) REFERENCES curriculum_targets(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS lexemes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  lexeme_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  language_id BIGINT UNSIGNED NOT NULL,
  lexeme_type ENUM('word','phrase') NOT NULL,
  surface VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  normalized_surface VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NULL,
  lemma VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NULL,
  part_of_speech VARCHAR(128) NULL,
  cefr_level ENUM('Pre-A1','A1','A2','B1','B2','C1','C2') NULL,
  translation_fa TEXT NOT NULL,
  usage_note_fa TEXT NULL,
  flashcard_eligible BOOLEAN NOT NULL DEFAULT TRUE,
  audio_status ENUM('blocked_until_language_final','pending','ready') NOT NULL DEFAULT 'blocked_until_language_final',
  audio_url TEXT NULL,
  audio_voice_name VARCHAR(191) NULL,
  audio_voice_id VARCHAR(191) NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_lexemes_key (lexeme_key),
  KEY idx_lexemes_language_surface (language_id,surface(191)),
  KEY idx_lexemes_language_normalized (language_id,normalized_surface(191)),
  CONSTRAINT fk_lexemes_language FOREIGN KEY (language_id) REFERENCES languages(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS lexeme_forms (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  lexeme_form_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  lexeme_id BIGINT UNSIGNED NOT NULL,
  surface VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  normalized_surface VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NULL,
  form_type ENUM('inflected','orthographic_variant','contraction','cliticized','abbreviation','other') NOT NULL,
  features JSON NULL,
  origin ENUM('source_attested','reference_attested','generated') NOT NULL,
  review_status ENUM('pending_review','approved') NOT NULL DEFAULT 'pending_review',
  notes TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_lexeme_forms_key (lexeme_form_key),
  KEY idx_lexeme_forms_lexeme (lexeme_id),
  KEY idx_lexeme_forms_surface (surface(191)),
  KEY idx_lexeme_forms_normalized (normalized_surface(191)),
  CONSTRAINT fk_lexeme_forms_lexeme FOREIGN KEY (lexeme_id) REFERENCES lexemes(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS lesson_lexemes (
  lesson_id BIGINT UNSIGNED NOT NULL,
  lexeme_id BIGINT UNSIGNED NOT NULL,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  role ENUM('introduce','practice','review','support') NOT NULL DEFAULT 'support',
  PRIMARY KEY (lesson_id,lexeme_id),
  CONSTRAINT fk_lesson_lexemes_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_lesson_lexemes_lexeme FOREIGN KEY (lexeme_id) REFERENCES lexemes(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS activity_lexemes (
  activity_id BIGINT UNSIGNED NOT NULL,
  lexeme_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (activity_id,lexeme_id),
  CONSTRAINT fk_activity_lexemes_activity FOREIGN KEY (activity_id) REFERENCES activities(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_activity_lexemes_lexeme FOREIGN KEY (lexeme_id) REFERENCES lexemes(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS grammar_notes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  grammar_note_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  language_level_id BIGINT UNSIGNED NOT NULL,
  title_fa VARCHAR(255) NOT NULL,
  source_text LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  translation_fa LONGTEXT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_grammar_notes_key (grammar_note_key),
  CONSTRAINT fk_grammar_notes_level FOREIGN KEY (language_level_id) REFERENCES language_levels(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS lesson_grammar_notes (
  lesson_id BIGINT UNSIGNED NOT NULL,
  grammar_note_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (lesson_id,grammar_note_id),
  CONSTRAINT fk_lesson_grammar_notes_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_lesson_grammar_notes_note FOREIGN KEY (grammar_note_id) REFERENCES grammar_notes(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS example_sentences (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  example_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  language_level_id BIGINT UNSIGNED NOT NULL,
  text_target TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  translation_fa TEXT NOT NULL,
  notes TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_example_sentences_key (example_key),
  CONSTRAINT fk_example_sentences_level FOREIGN KEY (language_level_id) REFERENCES language_levels(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS grammar_note_examples (
  grammar_note_id BIGINT UNSIGNED NOT NULL,
  example_sentence_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (grammar_note_id,example_sentence_id),
  CONSTRAINT fk_grammar_note_examples_note FOREIGN KEY (grammar_note_id) REFERENCES grammar_notes(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_grammar_note_examples_example FOREIGN KEY (example_sentence_id) REFERENCES example_sentences(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS lexeme_examples (
  lexeme_id BIGINT UNSIGNED NOT NULL,
  example_sentence_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (lexeme_id,example_sentence_id),
  CONSTRAINT fk_lexeme_examples_lexeme FOREIGN KEY (lexeme_id) REFERENCES lexemes(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_lexeme_examples_example FOREIGN KEY (example_sentence_id) REFERENCES example_sentences(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS lexeme_occurrences (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  occurrence_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  owner_type ENUM('dialogue_turn','activity','example_sentence') NOT NULL,
  owner_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  surface VARCHAR(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  start_offset INT UNSIGNED NULL,
  end_offset INT UNSIGNED NULL,
  lexeme_id BIGINT UNSIGNED NOT NULL,
  lexeme_form_id BIGINT UNSIGNED NULL,
  resolution_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  resolution_notes TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_lexeme_occurrences_key (occurrence_key),
  KEY idx_lexeme_occurrences_owner (owner_type,owner_key),
  KEY idx_lexeme_occurrences_lexeme (lexeme_id),
  CONSTRAINT chk_lexeme_occurrence_offsets CHECK (
    (start_offset IS NULL AND end_offset IS NULL) OR
    (start_offset IS NOT NULL AND end_offset IS NOT NULL AND end_offset>start_offset)
  ),
  CONSTRAINT fk_lexeme_occurrences_lexeme FOREIGN KEY (lexeme_id) REFERENCES lexemes(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_lexeme_occurrences_form FOREIGN KEY (lexeme_form_id) REFERENCES lexeme_forms(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS provenance_links (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  entity_type ENUM('language_level','unit','lesson','activity','dialogue','dialogue_turn','character','lexeme','lexeme_form','grammar_note','example_sentence') NOT NULL,
  entity_key VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  source_item_id BIGINT UNSIGNED NOT NULL,
  transformation ENUM('verbatim','persian_translation_added','sentence_tokenized_for_word_order','source_sentence_blank_created','source_items_grouped_for_matching','options_selected_from_source_material','character_metadata_added','cefr_level_assigned_by_app','other') NULL,
  notes TEXT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_provenance_links (entity_type,entity_key,source_item_id,transformation),
  KEY idx_provenance_source_item (source_item_id),
  CONSTRAINT fk_provenance_source_item FOREIGN KEY (source_item_id) REFERENCES source_items(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_lexeme_occurrences_bi$$
CREATE TRIGGER trg_lexeme_occurrences_bi BEFORE INSERT ON lexeme_occurrences FOR EACH ROW
BEGIN
  DECLARE parent_lexeme_id BIGINT UNSIGNED;
  IF NEW.lexeme_form_id IS NOT NULL THEN
    SET parent_lexeme_id=(SELECT lexeme_id FROM lexeme_forms WHERE id=NEW.lexeme_form_id LIMIT 1);
    IF parent_lexeme_id IS NULL OR parent_lexeme_id<>NEW.lexeme_id THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='lexeme_form_id must belong to lexeme_id';
    END IF;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_lexeme_occurrences_bu$$
CREATE TRIGGER trg_lexeme_occurrences_bu BEFORE UPDATE ON lexeme_occurrences FOR EACH ROW
BEGIN
  DECLARE parent_lexeme_id BIGINT UNSIGNED;
  IF NEW.lexeme_form_id IS NOT NULL THEN
    SET parent_lexeme_id=(SELECT lexeme_id FROM lexeme_forms WHERE id=NEW.lexeme_form_id LIMIT 1);
    IF parent_lexeme_id IS NULL OR parent_lexeme_id<>NEW.lexeme_id THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='lexeme_form_id must belong to lexeme_id';
    END IF;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_lessons_bi_final_guard$$
CREATE TRIGGER trg_lessons_bi_final_guard BEFORE INSERT ON lessons FOR EACH ROW
BEGIN
  IF (NEW.unit_id IS NULL AND NEW.position_in_unit IS NOT NULL)
     OR (NEW.unit_id IS NOT NULL AND (NEW.position_in_unit IS NULL OR NEW.position_in_unit<1)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='unit_id and position_in_unit must be set together';
  END IF;
  IF NEW.status='final' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Insert lesson before finalizing; final requires an existing opening activity';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_lessons_bu_final_guard$$
CREATE TRIGGER trg_lessons_bu_final_guard BEFORE UPDATE ON lessons FOR EACH ROW
BEGIN
  DECLARE opening_count INT DEFAULT 0;
  IF (NEW.unit_id IS NULL AND NEW.position_in_unit IS NOT NULL)
     OR (NEW.unit_id IS NOT NULL AND (NEW.position_in_unit IS NULL OR NEW.position_in_unit<1)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='unit_id and position_in_unit must be set together';
  END IF;
  IF NEW.status='final' AND OLD.status<>'final' THEN
    SELECT COUNT(*) INTO opening_count FROM activities
    WHERE lesson_id=NEW.id AND position_index=1 AND activity_type='conversation_speaking';
    IF opening_count<>1 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='A final lesson must begin with conversation_speaking';
    END IF;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_activities_bi_final_guard$$
CREATE TRIGGER trg_activities_bi_final_guard BEFORE INSERT ON activities FOR EACH ROW
BEGIN
  DECLARE lesson_status VARCHAR(32);
  IF NEW.activity_type='conversation_speaking' AND NEW.dialogue_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='conversation_speaking requires dialogue_id';
  END IF;
  SET lesson_status=(SELECT status FROM lessons WHERE id=NEW.lesson_id LIMIT 1);
  IF lesson_status='final' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Reopen a final lesson before changing its activities';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_activities_bd_final_guard$$
CREATE TRIGGER trg_activities_bd_final_guard BEFORE DELETE ON activities FOR EACH ROW
BEGIN
  DECLARE lesson_status VARCHAR(32);
  SET lesson_status=(SELECT status FROM lessons WHERE id=OLD.lesson_id LIMIT 1);
  IF lesson_status='final' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Reopen a final lesson before changing its activities';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_activities_bu_final_guard$$
CREATE TRIGGER trg_activities_bu_final_guard BEFORE UPDATE ON activities FOR EACH ROW
BEGIN
  DECLARE lesson_status VARCHAR(32);
  IF NEW.activity_type='conversation_speaking' AND NEW.dialogue_id IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='conversation_speaking requires dialogue_id';
  END IF;
  SET lesson_status=(SELECT status FROM lessons WHERE id=OLD.lesson_id LIMIT 1);
  IF lesson_status='final' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Reopen a final lesson before changing its activities';
  END IF;
  IF NEW.lesson_id<>OLD.lesson_id THEN
    SET lesson_status=(SELECT status FROM lessons WHERE id=NEW.lesson_id LIMIT 1);
    IF lesson_status='final' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Cannot move an activity into a final lesson';
    END IF;
  END IF;
END$$

DELIMITER ;

CREATE OR REPLACE VIEW v_learner_facing_source_items AS
SELECT si.id AS source_item_id,si.source_id,si.item_key,si.locator,si.source_text,
       s.source_key,s.title AS source_title,s.modernity_status,s.reuse_status,s.retrieved_at
FROM source_items si JOIN sources s ON s.id=si.source_id
WHERE s.modernity_status IN ('contemporary_verified','maintained_current')
  AND s.reuse_status IN ('direct_reuse_allowed','reuse_with_attribution');

CREATE OR REPLACE VIEW v_lexeme_surface_candidates AS
SELECT l.language_id,l.id AS lexeme_id,NULL AS lexeme_form_id,l.surface,l.normalized_surface,'canonical' AS candidate_type
FROM lexemes l
UNION ALL
SELECT l.language_id,lf.lexeme_id,lf.id,lf.surface,lf.normalized_surface,'form'
FROM lexeme_forms lf JOIN lexemes l ON l.id=lf.lexeme_id
WHERE lf.review_status='approved';

CREATE OR REPLACE VIEW v_language_level_structure_counts AS
SELECT ll.id AS language_level_id,ll.language_id,ll.cefr_level,
       COALESCE(u.c,0) AS unit_count,COALESCE(le.c,0) AS lesson_count,
       COALESCE(a.c,0) AS activity_count,COALESCE(dt.c,0) AS dialogue_turn_count
FROM language_levels ll
LEFT JOIN (SELECT language_level_id,COUNT(*) c FROM units GROUP BY language_level_id) u ON u.language_level_id=ll.id
LEFT JOIN (SELECT language_level_id,COUNT(*) c FROM lessons GROUP BY language_level_id) le ON le.language_level_id=ll.id
LEFT JOIN (SELECT l.language_level_id,COUNT(*) c FROM activities a JOIN lessons l ON l.id=a.lesson_id GROUP BY l.language_level_id) a ON a.language_level_id=ll.id
LEFT JOIN (SELECT d.language_level_id,COUNT(*) c FROM dialogue_turns t JOIN dialogues d ON d.id=t.dialogue_id GROUP BY d.language_level_id) dt ON dt.language_level_id=ll.id;

CREATE OR REPLACE VIEW v_invalid_learner_facing_source_links AS
SELECT p.id AS provenance_link_id,p.entity_type,p.entity_key,p.source_item_id,
       s.source_key,s.modernity_status,s.reuse_status
FROM provenance_links p
JOIN source_items si ON si.id=p.source_item_id
JOIN sources s ON s.id=si.source_id
WHERE p.entity_type IN ('lesson','activity','dialogue','dialogue_turn','lexeme','lexeme_form','grammar_note','example_sentence')
  AND (s.modernity_status NOT IN ('contemporary_verified','maintained_current')
       OR s.reuse_status NOT IN ('direct_reuse_allowed','reuse_with_attribution'));