-- Language Learning Content Database
-- Canonical target: MySQL 9.0.1
-- Structure only. Educational rows belong in database/content/<language>/<level>.sql.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';

CREATE TABLE IF NOT EXISTS taxonomy_labels (
  domain_code VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  value_code VARCHAR(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  label_fa VARCHAR(255) NOT NULL,
  PRIMARY KEY (domain_code,value_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- BEGIN GENERATED FA TAXONOMY
INSERT INTO taxonomy_labels (domain_code,value_code,label_fa) VALUES
  ('language_status','planned','برنامه‌ریزی‌شده'),
  ('language_status','building','در حال ساخت'),
  ('language_status','review','در حال بازبینی'),
  ('language_status','final','نهایی'),
  ('language_status','audio_ready','صوت آماده'),
  ('cefr_level','Pre-A1','پیش از سطح A1'),
  ('cefr_level','A1','سطح A1'),
  ('cefr_level','A2','سطح A2'),
  ('cefr_level','B1','سطح B1'),
  ('cefr_level','B2','سطح B2'),
  ('cefr_level','C1','سطح C1'),
  ('cefr_level','C2','سطح C2'),
  ('level_status','unassessed','ارزیابی‌نشده'),
  ('level_status','planning','در حال برنامه‌ریزی'),
  ('level_status','building','در حال ساخت'),
  ('level_status','review','در حال بازبینی'),
  ('level_status','final','نهایی'),
  ('curriculum_target_type','communicative','ارتباطی'),
  ('curriculum_target_type','linguistic','زبانی'),
  ('curriculum_target_type','situation','موقعیتی'),
  ('curriculum_target_type','pronunciation','تلفظ'),
  ('curriculum_target_type','grammar','دستور زبان'),
  ('curriculum_target_type','lexical','واژگانی'),
  ('curriculum_target_type','review','مرور'),
  ('curriculum_target_type','other','سایر'),
  ('curriculum_target_status','uncovered','پوشش‌داده‌نشده'),
  ('curriculum_target_status','partial','پوشش جزئی'),
  ('curriculum_target_status','covered','پوشش کامل'),
  ('curriculum_target_status','review','نیازمند مرور'),
  ('source_type','course','دورهٔ آموزشی'),
  ('source_type','book','کتاب'),
  ('source_type','website','وب‌سایت'),
  ('source_type','corpus','پیکرهٔ زبانی'),
  ('source_type','dictionary','واژه‌نامه'),
  ('source_type','grammar_reference','مرجع دستور زبان'),
  ('source_type','audio_course','دورهٔ صوتی'),
  ('source_type','other','سایر'),
  ('modernity_status','contemporary_verified','معاصر و تأییدشده'),
  ('modernity_status','maintained_current','فعال و به‌روز'),
  ('modernity_status','historical_or_legacy','قدیمی یا تاریخی'),
  ('modernity_status','needs_currency_review','نیازمند بررسی به‌روز بودن'),
  ('reuse_status','direct_reuse_allowed','استفادهٔ مستقیم مجاز'),
  ('reuse_status','reuse_with_attribution','استفاده با ذکر منبع'),
  ('reuse_status','analysis_only','فقط برای تحلیل'),
  ('reuse_status','needs_review','نیازمند بررسی'),
  ('character_origin','source','برگرفته از منبع'),
  ('character_origin','app_created','ساختهٔ اپلیکیشن'),
  ('gender','female','زن'),
  ('gender','male','مرد'),
  ('gender','unspecified','نامشخص'),
  ('gender','not_applicable','قابل اعمال نیست'),
  ('age_band','child','کودک'),
  ('age_band','teen','نوجوان'),
  ('age_band','young_adult','جوان'),
  ('age_band','adult','بزرگسال'),
  ('age_band','middle_aged','میانسال'),
  ('age_band','older_adult','سالمند'),
  ('age_band','unspecified','نامشخص'),
  ('unit_status','draft','پیش‌نویس'),
  ('unit_status','review','در حال بازبینی'),
  ('unit_status','final','نهایی'),
  ('lesson_status','draft','پیش‌نویس'),
  ('lesson_status','source_checked','منبع بررسی‌شده'),
  ('lesson_status','cefr_checked','سطح CEFR بررسی‌شده'),
  ('lesson_status','qa','در کنترل کیفیت'),
  ('lesson_status','final','نهایی'),
  ('coverage_role','introduce','معرفی'),
  ('coverage_role','practice','تمرین'),
  ('coverage_role','review','مرور'),
  ('coverage_role','assess','ارزیابی'),
  ('coverage_role','support','پشتیبان'),
  ('speaker_identity_origin','source','برگرفته از منبع'),
  ('speaker_identity_origin','app_assigned','تخصیص‌داده‌شده توسط اپلیکیشن'),
  ('activity_type','conversation_speaking','مکالمهٔ گفتاری'),
  ('activity_type','listen_choose','گوش‌دادن و انتخاب'),
  ('activity_type','multiple_choice','چندگزینه‌ای'),
  ('activity_type','choose_response','انتخاب پاسخ'),
  ('activity_type','word_order','مرتب‌کردن کلمات'),
  ('activity_type','fill_blank','پرکردن جای خالی'),
  ('activity_type','matching','وصل‌کردن موارد مرتبط'),
  ('activity_type','listen_repeat','گوش‌دادن و تکرار'),
  ('activity_type','pronunciation_read','خواندن و تلفظ'),
  ('activity_type','grammar_focus','تمرکز بر دستور زبان'),
  ('activity_type','comprehension','درک مطلب'),
  ('activity_type','true_false','درست یا غلط'),
  ('activity_type','review','مرور'),
  ('opening_initiator','app','اپلیکیشن'),
  ('opening_initiator','learner','زبان‌آموز'),
  ('audio_status','not_required','نیازی به صوت ندارد'),
  ('audio_status','blocked_until_level_final','متوقف تا نهایی‌شدن سطح'),
  ('audio_status','pending','در انتظار تولید صوت'),
  ('audio_status','ready','صوت آماده'),
  ('audio_status','stale','صوت نیازمند بازتولید'),
  ('audio_status','failed','تولید صوت ناموفق'),
  ('lexeme_type','word','واژه'),
  ('lexeme_type','phrase','عبارت'),
  ('part_of_speech','noun','اسم'),
  ('part_of_speech','verb','فعل'),
  ('part_of_speech','adjective','صفت'),
  ('part_of_speech','adverb','قید'),
  ('part_of_speech','pronoun','ضمیر'),
  ('part_of_speech','preposition','حرف اضافه'),
  ('part_of_speech','conjunction','حرف ربط'),
  ('part_of_speech','article','حرف تعریف'),
  ('part_of_speech','determiner','تعیین‌کننده'),
  ('part_of_speech','numeral','عدد'),
  ('part_of_speech','interjection','حرف ندا / عبارت واکنشی'),
  ('part_of_speech','greeting_formula','عبارت سلام و احوال‌پرسی'),
  ('part_of_speech','farewell_formula','عبارت خداحافظی'),
  ('part_of_speech','response_formula','عبارت پاسخ'),
  ('part_of_speech','response_particle','واژهٔ پاسخ'),
  ('part_of_speech','interjection_response_particle','عبارت واکنشی / واژهٔ پاسخ'),
  ('part_of_speech','adverb_response_particle','قید / واژهٔ پاسخ'),
  ('part_of_speech','adjective_response','صفت / پاسخ کوتاه'),
  ('part_of_speech','question_formula','عبارت پرسشی'),
  ('part_of_speech','name_formula','عبارت معرفی نام'),
  ('part_of_speech','politeness_formula','عبارت مؤدبانه'),
  ('part_of_speech','proper_noun','اسم خاص'),
  ('part_of_speech','other','سایر'),
  ('lexeme_form_type','inflected','صرف‌شده'),
  ('lexeme_form_type','orthographic_variant','گونهٔ املایی'),
  ('lexeme_form_type','contraction','شکل کوتاه‌شده'),
  ('lexeme_form_type','cliticized','شکل پی‌بستی'),
  ('lexeme_form_type','abbreviation','مخفف'),
  ('lexeme_form_type','other','سایر'),
  ('lexeme_form_origin','source_attested','ثبت‌شده در منبع'),
  ('lexeme_form_origin','reference_attested','ثبت‌شده در مرجع'),
  ('lexeme_form_origin','generated','تولیدشده'),
  ('review_status','pending_review','منتظر بازبینی'),
  ('review_status','approved','تأییدشده'),
  ('lexeme_role','introduce','معرفی'),
  ('lexeme_role','practice','تمرین'),
  ('lexeme_role','review','مرور'),
  ('lexeme_role','support','پشتیبان'),
  ('occurrence_owner_type','dialogue_turn','نوبت مکالمه'),
  ('occurrence_owner_type','activity','فعالیت'),
  ('occurrence_owner_type','example_sentence','جملهٔ نمونه'),
  ('resolution_status','pending','در انتظار'),
  ('resolution_status','approved','تأییدشده'),
  ('resolution_status','rejected','ردشده'),
  ('provenance_entity_type','language_level','سطح زبان'),
  ('provenance_entity_type','unit','واحد'),
  ('provenance_entity_type','lesson','درس'),
  ('provenance_entity_type','activity','فعالیت'),
  ('provenance_entity_type','dialogue','مکالمه'),
  ('provenance_entity_type','dialogue_turn','نوبت مکالمه'),
  ('provenance_entity_type','character','شخصیت'),
  ('provenance_entity_type','lexeme','واژه یا عبارت'),
  ('provenance_entity_type','lexeme_form','صورت واژه'),
  ('provenance_entity_type','grammar_note','نکتهٔ دستوری'),
  ('provenance_entity_type','example_sentence','جملهٔ نمونه'),
  ('provenance_transformation','verbatim','عیناً از منبع'),
  ('provenance_transformation','persian_translation_added','ترجمهٔ فارسی افزوده شده'),
  ('provenance_transformation','sentence_tokenized_for_word_order','جمله برای مرتب‌سازی کلمات بخش‌بندی شده'),
  ('provenance_transformation','source_sentence_blank_created','از جملهٔ منبع جای خالی ساخته شده'),
  ('provenance_transformation','source_items_grouped_for_matching','موارد منبع برای تطبیق گروه‌بندی شده'),
  ('provenance_transformation','options_selected_from_source_material','گزینه‌ها از محتوای منبع انتخاب شده‌اند'),
  ('provenance_transformation','character_metadata_added','فرادادهٔ شخصیت افزوده شده'),
  ('provenance_transformation','cefr_level_assigned_by_app','سطح CEFR توسط اپلیکیشن تعیین شده'),
  ('provenance_transformation','other','سایر'),
  ('activity_transformation','verbatim_dialogue','گفت‌وگو عیناً از منبع استفاده شده'),
  ('activity_transformation','persian_translation_added','ترجمهٔ فارسی افزوده شده'),
  ('activity_transformation','sentence_tokenized_for_word_order','جمله برای مرتب‌سازی کلمات بخش‌بندی شده'),
  ('activity_transformation','source_sentence_blank_created','از جملهٔ منبع جای خالی ساخته شده'),
  ('activity_transformation','source_items_grouped_for_matching','موارد منبع برای تطبیق گروه‌بندی شده'),
  ('activity_transformation','options_selected_from_source_material','گزینه‌ها از محتوای منبع انتخاب شده‌اند'),
  ('activity_transformation','character_metadata_added','فرادادهٔ شخصیت افزوده شده'),
  ('activity_transformation','cefr_level_assigned_by_app','سطح CEFR توسط اپلیکیشن تعیین شده'),
  ('activity_transformation','other','سایر'),
  ('character_role','learner','زبان‌آموز'),
  ('character_role','conversation_partner','شریک مکالمه'),
  ('relationship_tag','friend','دوست'),
  ('relationship_tag','coworker','همکار'),
  ('relationship_tag','family','عضو خانواده'),
  ('relationship_tag','stranger','ناآشنا'),
  ('relationship_tag','classmate','هم‌کلاسی'),
  ('voice_clarity','high','شفافیت بالا'),
  ('voice_stress_level','low','کم'),
  ('voice_stress_level','very_low','بسیار کم'),
  ('voice_aggressiveness','none','بدون لحن تهاجمی'),
  ('voice_tone_consistency','high','بالا'),
  ('voice_tone_consistency','medium_high','نسبتاً بالا'),
  ('voice_age_impression','child','کودک'),
  ('voice_age_impression','teen','نوجوان'),
  ('voice_age_impression','young_adult','جوان'),
  ('voice_age_impression','adult','بزرگسال'),
  ('voice_age_impression','middle_aged','میانسال'),
  ('voice_age_impression','older_adult','سالمند'),
  ('voice_age_impression','neutral','خنثی'),
  ('voice_gender_impression','female','زنانه'),
  ('voice_gender_impression','male','مردانه'),
  ('voice_gender_impression','neutral','خنثی'),
  ('activity_interaction','read_aloud_exchange','گفت‌وگوی نوبتیِ خواندن و گفتن'),
  ('grammar_feature_tense','present','حال'),
  ('grammar_feature_mood','indicative','اخباری'),
  ('grammar_feature_mood','subjunctive_II','وجه شرطی دوم'),
  ('grammar_feature_number','singular','مفرد'),
  ('grammar_feature_number','plural','جمع'),
  ('grammar_feature_person','1','اول‌شخص'),
  ('grammar_feature_person','2','دوم‌شخص'),
  ('grammar_feature_person','3','سوم‌شخص')
ON DUPLICATE KEY UPDATE label_fa=VALUES(label_fa);
-- END GENERATED FA TAXONOMY

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
  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'blocked_until_level_final',
  structure_rationale TEXT NULL,
  coverage JSON NOT NULL,
  completion_assessment JSON NULL,
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
  title_fa VARCHAR(500) NULL,
  organization_or_author VARCHAR(500) NULL,
  language_code VARCHAR(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  source_type ENUM('course','book','website','corpus','dictionary','grammar_reference','audio_course','other') NOT NULL,
  url TEXT NULL,
  locator VARCHAR(500) NULL,
  locator_fa VARCHAR(500) NULL,
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
  locator_fa VARCHAR(500) NULL,
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
  source_title_fa VARCHAR(500) NULL,
  status ENUM('draft','source_checked','cefr_checked','qa','final') NOT NULL DEFAULT 'draft',
  activity_selection_rationale TEXT NULL,
  sequence_rationale TEXT NULL,
  template_signature VARCHAR(500) NULL,
  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'blocked_until_level_final',
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
  opening_initiator ENUM('app','learner') NOT NULL,
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
  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'blocked_until_level_final',
  audio_url TEXT NULL,
  audio_storage_path VARCHAR(1024) NULL,
  audio_source_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_provider VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_model_id VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_voice_name VARCHAR(191) NULL,
  audio_voice_id VARCHAR(191) NULL,
  audio_generated_at DATETIME(6) NULL,
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
  audio_text_target TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NULL,
  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'not_required',
  audio_url TEXT NULL,
  audio_storage_path VARCHAR(1024) NULL,
  audio_source_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_provider VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_model_id VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_voice_name VARCHAR(191) NULL,
  audio_voice_id VARCHAR(191) NULL,
  audio_generated_at DATETIME(6) NULL,
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
  part_of_speech_fa VARCHAR(191) NULL,
  cefr_level ENUM('Pre-A1','A1','A2','B1','B2','C1','C2') NULL,
  translation_fa TEXT NOT NULL,
  usage_note_fa TEXT NULL,
  flashcard_eligible BOOLEAN NOT NULL DEFAULT TRUE,
  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'blocked_until_level_final',
  audio_url TEXT NULL,
  audio_storage_path VARCHAR(1024) NULL,
  audio_source_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_provider VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_model_id VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_voice_name VARCHAR(191) NULL,
  audio_voice_id VARCHAR(191) NULL,
  audio_generated_at DATETIME(6) NULL,
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
  audio_required BOOLEAN NOT NULL DEFAULT FALSE,
  audio_status ENUM('not_required','blocked_until_level_final','pending','ready','stale','failed') NOT NULL DEFAULT 'not_required',
  audio_url TEXT NULL,
  audio_storage_path VARCHAR(1024) NULL,
  audio_source_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_provider VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_model_id VARCHAR(191) CHARACTER SET ascii COLLATE ascii_bin NULL,
  audio_voice_name VARCHAR(191) NULL,
  audio_voice_id VARCHAR(191) NULL,
  audio_generated_at DATETIME(6) NULL,
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


DROP TRIGGER IF EXISTS trg_language_levels_bi_final_guard$$
CREATE TRIGGER trg_language_levels_bi_final_guard BEFORE INSERT ON language_levels FOR EACH ROW
BEGIN
  IF NEW.status='final' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Insert level before finalizing; final requires targets, lessons and completion audit';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_language_levels_bu_final_guard$$
CREATE TRIGGER trg_language_levels_bu_final_guard BEFORE UPDATE ON language_levels FOR EACH ROW
BEGIN
  DECLARE missing_targets INT DEFAULT 0;
  DECLARE invalid_lessons INT DEFAULT 0;
  DECLARE lesson_count INT DEFAULT 0;
  IF NEW.status='final' AND OLD.status<>'final' THEN
    IF NEW.completion_assessment IS NULL
       OR JSON_UNQUOTE(JSON_EXTRACT(NEW.completion_assessment,'$.cefrCoverageComplete'))<>'true'
       OR JSON_UNQUOTE(JSON_EXTRACT(NEW.completion_assessment,'$.progressionComplete'))<>'true'
       OR JSON_UNQUOTE(JSON_EXTRACT(NEW.completion_assessment,'$.practiceAndRetrievalComplete'))<>'true'
       OR JSON_UNQUOTE(JSON_EXTRACT(NEW.completion_assessment,'$.skillModeCoverageComplete'))<>'true'
       OR COALESCE(JSON_LENGTH(JSON_EXTRACT(NEW.completion_assessment,'$.requiredGaps')),1)<>0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Final level requires a passing completion assessment with zero required gaps';
    END IF;
    IF COALESCE(JSON_LENGTH(JSON_EXTRACT(NEW.coverage,'$.gaps')),1)<>0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Final level coverage.gaps must be empty';
    END IF;
    SELECT COUNT(*) INTO missing_targets FROM curriculum_targets
      WHERE language_level_id=NEW.id AND required_for_completion=TRUE AND status<>'covered';
    IF missing_targets<>0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Final level has required curriculum targets that are not covered';
    END IF;
    SELECT COUNT(*),SUM(status<>'final') INTO lesson_count,invalid_lessons FROM lessons WHERE language_level_id=NEW.id;
    IF lesson_count=0 OR COALESCE(invalid_lessons,0)<>0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='All lessons must be final before the level can become final';
    END IF;
    IF NEW.audio_status NOT IN ('pending','ready','stale','failed') THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Final level audio must transition out of blocked state';
    END IF;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_lexemes_bi_fa_taxonomy$$
CREATE TRIGGER trg_lexemes_bi_fa_taxonomy BEFORE INSERT ON lexemes FOR EACH ROW
BEGIN
  DECLARE expected_label VARCHAR(255);
  IF NEW.part_of_speech IS NULL THEN
    IF NEW.part_of_speech_fa IS NOT NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech_fa must be null when part_of_speech is null';
    END IF;
  ELSE
    SET expected_label=(SELECT label_fa FROM taxonomy_labels WHERE domain_code='part_of_speech' AND value_code=NEW.part_of_speech LIMIT 1);
    IF expected_label IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech requires a Persian taxonomy label';
    END IF;
    IF NEW.part_of_speech_fa IS NULL OR NEW.part_of_speech_fa<>expected_label THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech_fa must match canonical Persian taxonomy label';
    END IF;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_lexemes_bu_fa_taxonomy$$
CREATE TRIGGER trg_lexemes_bu_fa_taxonomy BEFORE UPDATE ON lexemes FOR EACH ROW
BEGIN
  DECLARE expected_label VARCHAR(255);
  IF NEW.part_of_speech IS NULL THEN
    IF NEW.part_of_speech_fa IS NOT NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech_fa must be null when part_of_speech is null';
    END IF;
  ELSE
    SET expected_label=(SELECT label_fa FROM taxonomy_labels WHERE domain_code='part_of_speech' AND value_code=NEW.part_of_speech LIMIT 1);
    IF expected_label IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech requires a Persian taxonomy label';
    END IF;
    IF NEW.part_of_speech_fa IS NULL OR NEW.part_of_speech_fa<>expected_label THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech_fa must match canonical Persian taxonomy label';
    END IF;
  END IF;
  IF NOT (NEW.surface <=> OLD.surface) THEN
    SET NEW.audio_status='blocked_until_level_final';
    SET NEW.audio_url=NULL;
    SET NEW.audio_storage_path=NULL;
    SET NEW.audio_source_hash=NULL;
    SET NEW.audio_provider=NULL;
    SET NEW.audio_model_id=NULL;
    SET NEW.audio_voice_name=NULL;
    SET NEW.audio_voice_id=NULL;
    SET NEW.audio_generated_at=NULL;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_dialogue_turns_bu_audio_invalidate$$
CREATE TRIGGER trg_dialogue_turns_bu_audio_invalidate BEFORE UPDATE ON dialogue_turns FOR EACH ROW
BEGIN
  IF NOT (NEW.text_target <=> OLD.text_target) OR NEW.speaker_character_id<>OLD.speaker_character_id THEN
    SET NEW.audio_status='blocked_until_level_final';
    SET NEW.audio_url=NULL;
    SET NEW.audio_storage_path=NULL;
    SET NEW.audio_source_hash=NULL;
    SET NEW.audio_provider=NULL;
    SET NEW.audio_model_id=NULL;
    SET NEW.audio_voice_name=NULL;
    SET NEW.audio_voice_id=NULL;
    SET NEW.audio_generated_at=NULL;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_example_sentences_bu_audio_invalidate$$
CREATE TRIGGER trg_example_sentences_bu_audio_invalidate BEFORE UPDATE ON example_sentences FOR EACH ROW
BEGIN
  IF NOT (NEW.text_target <=> OLD.text_target) OR NEW.audio_required<>OLD.audio_required THEN
    SET NEW.audio_status=IF(NEW.audio_required,'blocked_until_level_final','not_required');
    SET NEW.audio_url=NULL;
    SET NEW.audio_storage_path=NULL;
    SET NEW.audio_source_hash=NULL;
    SET NEW.audio_provider=NULL;
    SET NEW.audio_model_id=NULL;
    SET NEW.audio_voice_name=NULL;
    SET NEW.audio_voice_id=NULL;
    SET NEW.audio_generated_at=NULL;
  END IF;
END$$

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
  IF NOT (NEW.audio_text_target <=> OLD.audio_text_target) THEN
    SET NEW.audio_status=IF(NEW.audio_text_target IS NULL,'not_required','blocked_until_level_final');
    SET NEW.audio_url=NULL;
    SET NEW.audio_storage_path=NULL;
    SET NEW.audio_source_hash=NULL;
    SET NEW.audio_provider=NULL;
    SET NEW.audio_model_id=NULL;
    SET NEW.audio_voice_name=NULL;
    SET NEW.audio_voice_id=NULL;
    SET NEW.audio_generated_at=NULL;
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

CREATE OR REPLACE VIEW v_audio_generation_manifest AS
SELECT 'dialogue_turn' AS owner_type,t.turn_key AS owner_key,lang.code AS language_code,ll.cefr_level,ll.status AS level_status,ll.audio_status AS level_audio_status,
       t.text_target AS audio_text,SHA2(t.text_target,256) AS expected_source_hash,c.voice_name AS expected_voice_name,c.elevenlabs_voice_id AS expected_voice_id,
       t.audio_status,t.audio_url,t.audio_storage_path,t.audio_source_hash,t.audio_provider,t.audio_model_id,t.audio_voice_name,t.audio_voice_id,t.audio_generated_at,
       (t.audio_status='ready' AND t.audio_url IS NOT NULL AND t.audio_storage_path IS NOT NULL AND t.audio_source_hash=SHA2(t.text_target,256)
        AND (c.elevenlabs_voice_id IS NULL OR t.audio_voice_id=c.elevenlabs_voice_id)) AS audio_is_current
FROM dialogue_turns t JOIN dialogues d ON d.id=t.dialogue_id JOIN language_levels ll ON ll.id=d.language_level_id JOIN languages lang ON lang.id=ll.language_id JOIN characters c ON c.id=t.speaker_character_id
UNION ALL
SELECT 'lexeme',l.lexeme_key,lang.code,ll.cefr_level,ll.status,ll.audio_status,l.surface,SHA2(l.surface,256),lang.standalone_audio_voice_name,lang.standalone_audio_voice_id,
       l.audio_status,l.audio_url,l.audio_storage_path,l.audio_source_hash,l.audio_provider,l.audio_model_id,l.audio_voice_name,l.audio_voice_id,l.audio_generated_at,
       (l.audio_status='ready' AND l.audio_url IS NOT NULL AND l.audio_storage_path IS NOT NULL AND l.audio_source_hash=SHA2(l.surface,256) AND (lang.standalone_audio_voice_id IS NULL OR l.audio_voice_id=lang.standalone_audio_voice_id))
FROM lexemes l JOIN languages lang ON lang.id=l.language_id JOIN language_levels ll ON ll.language_id=l.language_id AND ll.cefr_level=l.cefr_level WHERE l.flashcard_eligible=TRUE
UNION ALL
SELECT 'activity',a.activity_key,lang.code,ll.cefr_level,ll.status,ll.audio_status,a.audio_text_target,SHA2(a.audio_text_target,256),lang.standalone_audio_voice_name,lang.standalone_audio_voice_id,
       a.audio_status,a.audio_url,a.audio_storage_path,a.audio_source_hash,a.audio_provider,a.audio_model_id,a.audio_voice_name,a.audio_voice_id,a.audio_generated_at,
       (a.audio_status='ready' AND a.audio_url IS NOT NULL AND a.audio_storage_path IS NOT NULL AND a.audio_source_hash=SHA2(a.audio_text_target,256) AND (lang.standalone_audio_voice_id IS NULL OR a.audio_voice_id=lang.standalone_audio_voice_id))
FROM activities a JOIN lessons le ON le.id=a.lesson_id JOIN language_levels ll ON ll.id=le.language_level_id JOIN languages lang ON lang.id=ll.language_id WHERE a.audio_text_target IS NOT NULL
UNION ALL
SELECT 'example_sentence',e.example_key,lang.code,ll.cefr_level,ll.status,ll.audio_status,e.text_target,SHA2(e.text_target,256),lang.standalone_audio_voice_name,lang.standalone_audio_voice_id,
       e.audio_status,e.audio_url,e.audio_storage_path,e.audio_source_hash,e.audio_provider,e.audio_model_id,e.audio_voice_name,e.audio_voice_id,e.audio_generated_at,
       (e.audio_status='ready' AND e.audio_url IS NOT NULL AND e.audio_storage_path IS NOT NULL AND e.audio_source_hash=SHA2(e.text_target,256) AND (lang.standalone_audio_voice_id IS NULL OR e.audio_voice_id=lang.standalone_audio_voice_id))
FROM example_sentences e JOIN language_levels ll ON ll.id=e.language_level_id JOIN languages lang ON lang.id=ll.language_id WHERE e.audio_required=TRUE;

CREATE OR REPLACE VIEW v_invalid_learner_facing_source_links AS
SELECT p.id AS provenance_link_id,p.entity_type,p.entity_key,p.source_item_id,
       s.source_key,s.modernity_status,s.reuse_status
FROM provenance_links p
JOIN source_items si ON si.id=p.source_item_id
JOIN sources s ON s.id=si.source_id
WHERE p.entity_type IN ('lesson','activity','dialogue','dialogue_turn','lexeme','lexeme_form','grammar_note','example_sentence')
  AND (s.modernity_status NOT IN ('contemporary_verified','maintained_current')
       OR s.reuse_status NOT IN ('direct_reuse_allowed','reuse_with_attribution'));