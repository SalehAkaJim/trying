-- German Pre-A1 content baseline
-- Canonical runtime: MySQL 9.0.1
-- Requires database/schema.sql to be applied first.
-- This file is intentionally dynamic: it contains only the content currently justified.
-- It does not encode a target lesson, unit, activity, or dialogue-turn count.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';

START TRANSACTION;

-- -----------------------------------------------------------------------------
-- Language and level
-- -----------------------------------------------------------------------------

INSERT INTO languages (
  code, name_native, name_fa, status,
  standalone_audio_voice_name, standalone_audio_voice_id
) VALUES (
  'de', 'Deutsch', 'آلمانی', 'building', NULL, NULL
)
ON DUPLICATE KEY UPDATE
  name_native=VALUES(name_native),
  name_fa=VALUES(name_fa),
  status=VALUES(status),
  standalone_audio_voice_name=VALUES(standalone_audio_voice_name),
  standalone_audio_voice_id=VALUES(standalone_audio_voice_id);

SET @de_id := (SELECT id FROM languages WHERE code='de' LIMIT 1);

INSERT INTO language_levels (
  language_id, cefr_level, status, structure_rationale, coverage, notes
) VALUES (
  @de_id,
  'Pre-A1',
  'building',
  'The level starts with the smallest immediately usable communication for a zero beginner. Structure expands only when uncovered or under-supported targets justify more content; numeric quotas do not drive authoring.',
  JSON_OBJECT(
    'communicativeTargets', JSON_ARRAY(
      'greet someone informally',
      'use a morning greeting',
      'ask about a very familiar food preference',
      'express a very simple positive food preference'
    ),
    'linguisticTargets', JSON_ARRAY(
      'formulaic greeting hallo',
      'formulaic morning greeting guten Morgen',
      'mögen in the present forms mag and magst',
      'familiar noun Pizza'
    ),
    'situations', JSON_ARRAY(
      'simple first greeting',
      'simple morning greeting',
      'simple familiar-food preference exchange'
    ),
    'gaps', JSON_ARRAY(
      'basic yes/no and courtesy expressions',
      'name exchange',
      'simple wellbeing exchange',
      'simple wants and choices',
      'additional recycling and review as evidence shows it is needed'
    )
  ),
  'The lessons in this file are only the content currently built, not a target count for Pre-A1.'
)
ON DUPLICATE KEY UPDATE
  status=VALUES(status),
  structure_rationale=VALUES(structure_rationale),
  coverage=VALUES(coverage),
  notes=VALUES(notes);

SET @de_pre_a1_id := (
  SELECT id FROM language_levels
  WHERE language_id=@de_id AND cefr_level='Pre-A1'
  LIMIT 1
);

-- -----------------------------------------------------------------------------
-- Curriculum targets: coverage drives expansion, never a numeric lesson quota.
-- -----------------------------------------------------------------------------

INSERT INTO curriculum_targets (
  language_level_id, target_key, target_type, title, description,
  required_for_completion, status, metadata
) VALUES
  (@de_pre_a1_id, 'de.pre_a1.greet_informal_hallo', 'communicative',
   'Greet someone informally with hallo',
   'Use the formulaic greeting hallo in a simple first-contact exchange.',
   TRUE, 'partial', JSON_OBJECT('zeroBeginner', TRUE)),
  (@de_pre_a1_id, 'de.pre_a1.greet_morning_guten_morgen', 'communicative',
   'Use guten Morgen as a morning greeting',
   'Use the morning-specific greeting in an immediately understandable context.',
   TRUE, 'partial', JSON_OBJECT('zeroBeginner', TRUE)),
  (@de_pre_a1_id, 'de.pre_a1.distinguish_morning_general_greeting', 'linguistic',
   'Distinguish morning and general greetings',
   'Recognize when guten Morgen is more context-specific than hallo.',
   TRUE, 'partial', JSON_OBJECT('zeroBeginner', TRUE)),
  (@de_pre_a1_id, 'de.pre_a1.understand_pizza_preference_question', 'communicative',
   'Understand a simple pizza preference question',
   'Understand the source-backed question Magst du Pizza?',
   TRUE, 'partial', JSON_OBJECT('zeroBeginner', TRUE)),
  (@de_pre_a1_id, 'de.pre_a1.state_positive_pizza_preference', 'communicative',
   'State a simple positive pizza preference',
   'Use the source-backed statement Ich mag Pizza.',
   TRUE, 'partial', JSON_OBJECT('zeroBeginner', TRUE)),
  (@de_pre_a1_id, 'de.pre_a1.notice_moegen_mag_magst', 'linguistic',
   'Notice mag and magst as forms of mögen',
   'Connect the surface forms mag and magst to the canonical lexeme mögen.',
   FALSE, 'partial', JSON_OBJECT('lexemeFormAware', TRUE))
ON DUPLICATE KEY UPDATE
  target_type=VALUES(target_type),
  title=VALUES(title),
  description=VALUES(description),
  required_for_completion=VALUES(required_for_completion),
  status=VALUES(status),
  metadata=VALUES(metadata);

SET @t_hallo := (SELECT id FROM curriculum_targets WHERE language_level_id=@de_pre_a1_id AND target_key='de.pre_a1.greet_informal_hallo' LIMIT 1);
SET @t_gm := (SELECT id FROM curriculum_targets WHERE language_level_id=@de_pre_a1_id AND target_key='de.pre_a1.greet_morning_guten_morgen' LIMIT 1);
SET @t_gm_distinguish := (SELECT id FROM curriculum_targets WHERE language_level_id=@de_pre_a1_id AND target_key='de.pre_a1.distinguish_morning_general_greeting' LIMIT 1);
SET @t_pizza_q := (SELECT id FROM curriculum_targets WHERE language_level_id=@de_pre_a1_id AND target_key='de.pre_a1.understand_pizza_preference_question' LIMIT 1);
SET @t_pizza_a := (SELECT id FROM curriculum_targets WHERE language_level_id=@de_pre_a1_id AND target_key='de.pre_a1.state_positive_pizza_preference' LIMIT 1);
SET @t_moegen_forms := (SELECT id FROM curriculum_targets WHERE language_level_id=@de_pre_a1_id AND target_key='de.pre_a1.notice_moegen_mag_magst' LIMIT 1);

-- -----------------------------------------------------------------------------
-- Modern, reusable sources only
-- -----------------------------------------------------------------------------

INSERT INTO sources (
  source_key, title, organization_or_author, language_code, source_type, url,
  published_or_updated_at, modernity_status, currency_evidence,
  license_name, license_url, attribution_text, reuse_status, retrieved_at, notes
) VALUES
  (
    'src-wiktionary-de-hallo',
    'Wiktionary: hallo',
    'Wiktionary contributors',
    'de', 'dictionary',
    'https://de.wiktionary.org/wiki/hallo',
    NULL,
    'maintained_current',
    'Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used only for contemporary greeting meaning and lexical identity.',
    'CC BY-SA 4.0',
    'https://creativecommons.org/licenses/by-sa/4.0/',
    'Wiktionary contributors — https://de.wiktionary.org/wiki/hallo',
    'reuse_with_attribution',
    '2026-09-16',
    'Used for the greeting formula hallo and its greeting meaning.'
  ),
  (
    'src-wiktionary-de-guten-morgen',
    'Wiktionary: guten Morgen',
    'Wiktionary contributors',
    'de', 'dictionary',
    'https://de.wiktionary.org/wiki/guten_Morgen',
    NULL,
    'maintained_current',
    'Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for the contemporary morning greeting formula.',
    'CC BY-SA 4.0',
    'https://creativecommons.org/licenses/by-sa/4.0/',
    'Wiktionary contributors — https://de.wiktionary.org/wiki/guten_Morgen',
    'reuse_with_attribution',
    '2026-09-16',
    'Used for the morning greeting guten Morgen.'
  ),
  (
    'src-wiktionary-de-moegen',
    'Wiktionary: mögen',
    'Wiktionary contributors',
    'de', 'dictionary',
    'https://de.wiktionary.org/wiki/m%C3%B6gen',
    NULL,
    'maintained_current',
    'Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for contemporary lexical identity and present-tense forms.',
    'CC BY-SA 4.0',
    'https://creativecommons.org/licenses/by-sa/4.0/',
    'Wiktionary contributors — https://de.wiktionary.org/wiki/m%C3%B6gen',
    'reuse_with_attribution',
    '2026-09-16',
    'Used for lexical identity mögen and approved present-tense forms mag / magst.'
  ),
  (
    'src-wiktionary-de-pizza',
    'Wiktionary: Pizza',
    'Wiktionary contributors',
    'de', 'dictionary',
    'https://de.wiktionary.org/wiki/Pizza',
    NULL,
    'maintained_current',
    'Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for the contemporary noun Pizza.',
    'CC BY-SA 4.0',
    'https://creativecommons.org/licenses/by-sa/4.0/',
    'Wiktionary contributors — https://de.wiktionary.org/wiki/Pizza',
    'reuse_with_attribution',
    '2026-09-16',
    'Used for the familiar food noun Pizza.'
  ),
  (
    'src-libra-de-ich-mag-pizza',
    'Sprachstandsfeststellung Deutsch als Zweitsprache – Zusatzmodul Alphabetisierung',
    'Landesinstitut Brandenburg für Schule und Lehrkräftebildung (LIBRA)',
    'de', 'book',
    'https://bildungsserver.berlin-brandenburg.de/fileadmin/bbb/themen/sprachbildung/Sprachfeststellungpruefung/Sprachstandsfeststellung_DaZ_Alphabetisierung_2025-03-20.pdf',
    '2025-03-20',
    'contemporary_verified',
    'Official 2025 state education material from Brandenburg; current enough to represent contemporary learner-facing German and reviewed at retrieval.',
    'CC BY-SA 4.0',
    'https://creativecommons.org/licenses/by-sa/4.0/',
    'Landesinstitut Brandenburg für Schule und Lehrkräftebildung (LIBRA), Sprachstandsfeststellung Deutsch als Zweitsprache – Zusatzmodul Alphabetisierung, p. 12',
    'reuse_with_attribution',
    '2026-09-16',
    'Official open educational source used verbatim for the zero-beginner statement Ich mag Pizza.'
  ),
  (
    'src-wikibooks-de-magst-du-pizza',
    'Wikibooks example containing Magst du Pizza?',
    'Wikibooks contributors',
    'de', 'book',
    'https://de.wikibooks.org/wiki/Ungarisch/Ungarisch-Lesebuch-h%C3%A4ufigeW%C3%B6rter/012',
    NULL,
    'maintained_current',
    'Live Wikibooks page reviewed in its current state at retrieval; the page is a maintained wiki resource and the cited German example reflects contemporary standard usage.',
    'CC BY-SA 4.0',
    'https://creativecommons.org/licenses/by-sa/4.0/',
    'Wikibooks contributors — https://de.wikibooks.org/wiki/Ungarisch/Ungarisch-Lesebuch-h%C3%A4ufigeW%C3%B6rter/012',
    'reuse_with_attribution',
    '2026-09-16',
    'Only the source-attested German question Magst du Pizza? is reused in the lesson.'
  )
ON DUPLICATE KEY UPDATE
  title=VALUES(title),
  organization_or_author=VALUES(organization_or_author),
  language_code=VALUES(language_code),
  source_type=VALUES(source_type),
  url=VALUES(url),
  published_or_updated_at=VALUES(published_or_updated_at),
  modernity_status=VALUES(modernity_status),
  currency_evidence=VALUES(currency_evidence),
  license_name=VALUES(license_name),
  license_url=VALUES(license_url),
  attribution_text=VALUES(attribution_text),
  reuse_status=VALUES(reuse_status),
  retrieved_at=VALUES(retrieved_at),
  notes=VALUES(notes);

SET @src_hallo := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-hallo' LIMIT 1);
SET @src_gm := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-guten-morgen' LIMIT 1);
SET @src_moegen := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-moegen' LIMIT 1);
SET @src_pizza := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-pizza' LIMIT 1);
SET @src_libra_pizza := (SELECT id FROM sources WHERE source_key='src-libra-de-ich-mag-pizza' LIMIT 1);
SET @src_wb_pizza_q := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-magst-du-pizza' LIMIT 1);

INSERT INTO source_items (
  source_id, item_key, locator, source_text, source_text_hash, notes
) VALUES
  (@src_hallo, 'srcitem-de-hallo-headword', 'German interjection / greeting formula', 'hallo', UNHEX(SHA2('hallo',256)), 'Contemporary greeting lexeme.'),
  (@src_gm, 'srcitem-de-guten-morgen-formula', 'German greeting formula', 'guten Morgen', UNHEX(SHA2('guten Morgen',256)), 'Contemporary morning greeting formula.'),
  (@src_moegen, 'srcitem-de-moegen-lemma', 'German verb lemma', 'mögen', UNHEX(SHA2('mögen',256)), 'Canonical verb lexeme.'),
  (@src_moegen, 'srcitem-de-moegen-mag', 'Present-tense form', 'mag', UNHEX(SHA2('mag',256)), 'Attested present form of mögen.'),
  (@src_moegen, 'srcitem-de-moegen-magst', 'Present-tense form', 'magst', UNHEX(SHA2('magst',256)), 'Attested present form of mögen.'),
  (@src_pizza, 'srcitem-de-pizza-headword', 'German noun', 'Pizza', UNHEX(SHA2('Pizza',256)), 'Contemporary familiar-food noun.'),
  (@src_libra_pizza, 'srcitem-de-ich-mag-pizza', 'p. 12, Alphabetisierung – Vorlesen, Aufgabe 3a', 'Ich mag Pizza.', UNHEX(SHA2('Ich mag Pizza.',256)), 'Exact source-backed learner statement.'),
  (@src_wb_pizza_q, 'srcitem-de-magst-du-pizza', 'German examples under igen, item 8', 'Magst du Pizza?', UNHEX(SHA2('Magst du Pizza?',256)), 'Exact source-backed preference question.')
ON DUPLICATE KEY UPDATE
  locator=VALUES(locator),
  source_text=VALUES(source_text),
  source_text_hash=VALUES(source_text_hash),
  notes=VALUES(notes);

SET @si_hallo := (SELECT id FROM source_items WHERE source_id=@src_hallo AND item_key='srcitem-de-hallo-headword' LIMIT 1);
SET @si_gm := (SELECT id FROM source_items WHERE source_id=@src_gm AND item_key='srcitem-de-guten-morgen-formula' LIMIT 1);
SET @si_moegen := (SELECT id FROM source_items WHERE source_id=@src_moegen AND item_key='srcitem-de-moegen-lemma' LIMIT 1);
SET @si_mag := (SELECT id FROM source_items WHERE source_id=@src_moegen AND item_key='srcitem-de-moegen-mag' LIMIT 1);
SET @si_magst := (SELECT id FROM source_items WHERE source_id=@src_moegen AND item_key='srcitem-de-moegen-magst' LIMIT 1);
SET @si_pizza := (SELECT id FROM source_items WHERE source_id=@src_pizza AND item_key='srcitem-de-pizza-headword' LIMIT 1);
SET @si_ich_mag_pizza := (SELECT id FROM source_items WHERE source_id=@src_libra_pizza AND item_key='srcitem-de-ich-mag-pizza' LIMIT 1);
SET @si_magst_du_pizza := (SELECT id FROM source_items WHERE source_id=@src_wb_pizza_q AND item_key='srcitem-de-magst-du-pizza' LIMIT 1);

-- -----------------------------------------------------------------------------
-- Characters
-- -----------------------------------------------------------------------------

INSERT INTO characters (
  character_key, language_id, name, origin, gender, age_band,
  roles, relationship_tags, context_notes, voice_profile,
  elevenlabs_voice_id, voice_name
) VALUES
  (
    'char-de-learner', @de_id, 'Learner', 'app_created', 'unspecified', 'unspecified',
    JSON_ARRAY('learner'), JSON_ARRAY(),
    'Generic learner role. No demographic assumptions are required for the current scenes.',
    JSON_OBJECT(
      'clarity','high','stressLevel','very_low','aggressiveness','none',
      'toneConsistency','high','ageImpression',NULL,'genderImpression','neutral'
    ),
    NULL, NULL
  ),
  (
    'char-de-mia', @de_id, 'Mia', 'app_created', 'female', 'young_adult',
    JSON_ARRAY('conversation_partner'), JSON_ARRAY(),
    'Recurring friendly conversation partner. Current source utterances contain no evidence that conflicts with this app-assigned identity.',
    JSON_OBJECT(
      'clarity','high','stressLevel','very_low','aggressiveness','none',
      'toneConsistency','high','ageImpression','young adult','genderImpression','female'
    ),
    NULL, NULL
  )
ON DUPLICATE KEY UPDATE
  language_id=VALUES(language_id),
  name=VALUES(name),
  origin=VALUES(origin),
  gender=VALUES(gender),
  age_band=VALUES(age_band),
  roles=VALUES(roles),
  relationship_tags=VALUES(relationship_tags),
  context_notes=VALUES(context_notes),
  voice_profile=VALUES(voice_profile),
  elevenlabs_voice_id=VALUES(elevenlabs_voice_id),
  voice_name=VALUES(voice_name);

SET @char_learner := (SELECT id FROM characters WHERE character_key='char-de-learner' LIMIT 1);
SET @char_mia := (SELECT id FROM characters WHERE character_key='char-de-mia' LIMIT 1);

-- -----------------------------------------------------------------------------
-- Unit and lessons
-- -----------------------------------------------------------------------------

INSERT INTO units (
  unit_key, language_level_id, sequence_index, title_fa,
  grouping_rationale, status, metadata, notes
) VALUES (
  'de-pre-a1-unit-first-steps',
  @de_pre_a1_id,
  1,
  'اولین قدم‌ها',
  'These lessons belong together because they are immediately understandable, low-load first-contact communication for a zero beginner. The grouping is pedagogical; it has no target lesson capacity.',
  'draft',
  JSON_OBJECT('dynamicStructure', TRUE),
  'The unit stays open or closes only when the next coverage decisions justify it, never after a lesson-count threshold.'
)
ON DUPLICATE KEY UPDATE
  language_level_id=VALUES(language_level_id),
  sequence_index=VALUES(sequence_index),
  title_fa=VALUES(title_fa),
  grouping_rationale=VALUES(grouping_rationale),
  status=VALUES(status),
  metadata=VALUES(metadata),
  notes=VALUES(notes);

SET @unit_first_steps := (SELECT id FROM units WHERE unit_key='de-pre-a1-unit-first-steps' LIMIT 1);

INSERT INTO lessons (
  lesson_key, language_level_id, unit_id, sequence_index, position_in_unit,
  title_fa, source_title, status,
  activity_selection_rationale, sequence_rationale, template_signature,
  audio_status, notes
) VALUES
  (
    'de-pre-a1-lesson-hallo', @de_pre_a1_id, @unit_first_steps, 1, 1,
    'سلام!', 'hallo', 'draft',
    'The learner already produces the complete target greeting inside the opening exchange, so no extra activity is added merely to increase lesson size.',
    'Directly perform the communicative target with no pre-teaching screen.',
    'conversation_speaking',
    'blocked_until_language_final',
    NULL
  ),
  (
    'de-pre-a1-lesson-guten-morgen', @de_pre_a1_id, @unit_first_steps, 2, 2,
    'صبح بخیر!', 'guten Morgen', 'draft',
    'After saying the morning greeting, one recognition activity distinguishes its time-specific use from the already-known general greeting.',
    'Use the phrase first in context, then recognize when it fits.',
    'conversation_speaking>multiple_choice',
    'blocked_until_language_final',
    NULL
  ),
  (
    'de-pre-a1-lesson-pizza-like', @de_pre_a1_id, @unit_first_steps, 3, 3,
    'پیتزا دوست دارم', 'Magst du Pizza? / Ich mag Pizza.', 'draft',
    'The source-backed exchange introduces the preference; reconstructing the learner sentence gives one focused retrieval step without adding unrelated language.',
    'First answer a real preference question, then reconstruct the exact answer already encountered.',
    'conversation_speaking>word_order',
    'blocked_until_language_final',
    NULL
  )
ON DUPLICATE KEY UPDATE
  language_level_id=VALUES(language_level_id),
  unit_id=VALUES(unit_id),
  sequence_index=VALUES(sequence_index),
  position_in_unit=VALUES(position_in_unit),
  title_fa=VALUES(title_fa),
  source_title=VALUES(source_title),
  status=VALUES(status),
  activity_selection_rationale=VALUES(activity_selection_rationale),
  sequence_rationale=VALUES(sequence_rationale),
  template_signature=VALUES(template_signature),
  audio_status=VALUES(audio_status),
  notes=VALUES(notes);

SET @lesson_hallo := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-hallo' LIMIT 1);
SET @lesson_gm := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-guten-morgen' LIMIT 1);
SET @lesson_pizza := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-pizza-like' LIMIT 1);

INSERT INTO unit_targets (unit_id, curriculum_target_id) VALUES
  (@unit_first_steps,@t_hallo),
  (@unit_first_steps,@t_gm),
  (@unit_first_steps,@t_gm_distinguish),
  (@unit_first_steps,@t_pizza_q),
  (@unit_first_steps,@t_pizza_a),
  (@unit_first_steps,@t_moegen_forms)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id);

INSERT INTO lesson_targets (lesson_id, curriculum_target_id, coverage_role) VALUES
  (@lesson_hallo,@t_hallo,'introduce'),
  (@lesson_gm,@t_gm,'introduce'),
  (@lesson_gm,@t_gm_distinguish,'practice'),
  (@lesson_pizza,@t_pizza_q,'introduce'),
  (@lesson_pizza,@t_pizza_a,'introduce'),
  (@lesson_pizza,@t_moegen_forms,'support')
ON DUPLICATE KEY UPDATE coverage_role=VALUES(coverage_role);

-- -----------------------------------------------------------------------------
-- Dialogues
-- -----------------------------------------------------------------------------

INSERT INTO dialogues (
  dialogue_key, language_level_id, scenario, scene_quality_rationale
) VALUES
  (
    'dlg-de-pre-a1-hallo', @de_pre_a1_id,
    'Two people meet and exchange the simplest informal greeting.',
    'A reciprocal greeting is a complete communicative act for this first zero-beginner target. Extending it would add material the lesson does not yet need.'
  ),
  (
    'dlg-de-pre-a1-guten-morgen', @de_pre_a1_id,
    'Two people meet in the morning and exchange a morning greeting.',
    'The scene teaches one time-specific greeting and ends naturally after the greeting is returned.'
  ),
  (
    'dlg-de-pre-a1-pizza-like', @de_pre_a1_id,
    'Mia asks about a familiar food and the learner states a simple positive preference.',
    'The question and answer form a complete familiar-preference exchange. Additional turns are not required for the current learning target.'
  )
ON DUPLICATE KEY UPDATE
  language_level_id=VALUES(language_level_id),
  scenario=VALUES(scenario),
  scene_quality_rationale=VALUES(scene_quality_rationale);

SET @dlg_hallo := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-hallo' LIMIT 1);
SET @dlg_gm := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-guten-morgen' LIMIT 1);
SET @dlg_pizza := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-pizza-like' LIMIT 1);

INSERT INTO dialogue_turns (
  turn_key, dialogue_id, position_index, speaker_character_id,
  speaker_identity_origin, speaker_gender_evidence,
  text_target, translation_fa, learner_turn,
  audio_status, audio_url, elevenlabs_voice_id
) VALUES
  ('turn-de-hallo-1', @dlg_hallo, 1, @char_mia, 'app_assigned', 'unspecified', 'Hallo!', 'سلام!', FALSE, 'blocked_until_language_final', NULL, NULL),
  ('turn-de-hallo-2', @dlg_hallo, 2, @char_learner, 'app_assigned', 'unspecified', 'Hallo!', 'سلام!', TRUE, 'blocked_until_language_final', NULL, NULL),
  ('turn-de-gm-1', @dlg_gm, 1, @char_mia, 'app_assigned', 'unspecified', 'Guten Morgen!', 'صبح بخیر!', FALSE, 'blocked_until_language_final', NULL, NULL),
  ('turn-de-gm-2', @dlg_gm, 2, @char_learner, 'app_assigned', 'unspecified', 'Guten Morgen!', 'صبح بخیر!', TRUE, 'blocked_until_language_final', NULL, NULL),
  ('turn-de-pizza-1', @dlg_pizza, 1, @char_mia, 'app_assigned', 'unspecified', 'Magst du Pizza?', 'پیتزا دوست داری؟', FALSE, 'blocked_until_language_final', NULL, NULL),
  ('turn-de-pizza-2', @dlg_pizza, 2, @char_learner, 'app_assigned', 'unspecified', 'Ich mag Pizza.', 'من پیتزا دوست دارم.', TRUE, 'blocked_until_language_final', NULL, NULL)
ON DUPLICATE KEY UPDATE
  dialogue_id=VALUES(dialogue_id),
  position_index=VALUES(position_index),
  speaker_character_id=VALUES(speaker_character_id),
  speaker_identity_origin=VALUES(speaker_identity_origin),
  speaker_gender_evidence=VALUES(speaker_gender_evidence),
  text_target=VALUES(text_target),
  translation_fa=VALUES(translation_fa),
  learner_turn=VALUES(learner_turn),
  audio_status=VALUES(audio_status),
  audio_url=VALUES(audio_url),
  elevenlabs_voice_id=VALUES(elevenlabs_voice_id);

-- -----------------------------------------------------------------------------
-- Activities: counts and patterns differ by pedagogical need.
-- -----------------------------------------------------------------------------

INSERT INTO activities (
  activity_key, lesson_id, position_index, activity_type,
  instruction_fa, selection_reason, dialogue_id,
  payload, transformations, audio_status
) VALUES
  (
    'act-de-hallo-conversation', @lesson_hallo, 1, 'conversation_speaking',
    'به میا سلام کن.',
    'The target itself is a spoken greeting, so the opening exchange is sufficient practice for this first lesson.',
    @dlg_hallo,
    JSON_OBJECT('interaction','read_aloud_exchange'),
    JSON_ARRAY('persian_translation_added','character_metadata_added'),
    'pending_final_language'
  ),
  (
    'act-de-gm-conversation', @lesson_gm, 1, 'conversation_speaking',
    'صبح است؛ به میا صبح بخیر بگو.',
    'The learner should use the greeting in its natural time context before doing recognition practice.',
    @dlg_gm,
    JSON_OBJECT('interaction','read_aloud_exchange','contextFa','صبح است.'),
    JSON_ARRAY('persian_translation_added','character_metadata_added'),
    'pending_final_language'
  ),
  (
    'act-de-gm-choice', @lesson_gm, 2, 'multiple_choice',
    'برای سلام کردن در صبح کدام عبارت مناسب‌تر است؟',
    'This checks the only new distinction introduced by the lesson: a morning-specific greeting versus the already-known general greeting.',
    NULL,
    JSON_OBJECT(
      'promptFa','صبح است.',
      'options',JSON_ARRAY(
        JSON_OBJECT('textTarget','Guten Morgen!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-guten-morgen')),
        JSON_OBJECT('textTarget','Hallo!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-hallo'))
      )
    ),
    JSON_ARRAY('options_selected_from_source_material'),
    'pending_final_language'
  ),
  (
    'act-de-pizza-conversation', @lesson_pizza, 1, 'conversation_speaking',
    'به سؤال میا دربارهٔ پیتزا جواب بده.',
    'A familiar food preference creates an immediately understandable first use of mögen.',
    @dlg_pizza,
    JSON_OBJECT('interaction','read_aloud_exchange'),
    JSON_ARRAY('persian_translation_added','character_metadata_added'),
    'pending_final_language'
  ),
  (
    'act-de-pizza-word-order', @lesson_pizza, 2, 'word_order',
    'جمله‌ای را که همین الان گفتی دوباره بساز.',
    'Reconstructing the exact source sentence reinforces the new preference pattern without introducing new target-language content.',
    NULL,
    JSON_OBJECT(
      'sourceText','Ich mag Pizza.',
      'tokens',JSON_ARRAY('Ich','mag','Pizza.'),
      'answer',JSON_ARRAY('Ich','mag','Pizza.'),
      'tokenLexemeMappings',JSON_ARRAY(
        JSON_OBJECT('token','mag','lexemeId','lex-de-moegen','lexemeFormId','lexform-de-moegen-mag'),
        JSON_OBJECT('token','Pizza.','lexemeId','lex-de-pizza','lexemeFormId',NULL)
      )
    ),
    JSON_ARRAY('sentence_tokenized_for_word_order'),
    'pending_final_language'
  )
ON DUPLICATE KEY UPDATE
  lesson_id=VALUES(lesson_id),
  position_index=VALUES(position_index),
  activity_type=VALUES(activity_type),
  instruction_fa=VALUES(instruction_fa),
  selection_reason=VALUES(selection_reason),
  dialogue_id=VALUES(dialogue_id),
  payload=VALUES(payload),
  transformations=VALUES(transformations),
  audio_status=VALUES(audio_status);

SET @act_hallo_conv := (SELECT id FROM activities WHERE activity_key='act-de-hallo-conversation' LIMIT 1);
SET @act_gm_conv := (SELECT id FROM activities WHERE activity_key='act-de-gm-conversation' LIMIT 1);
SET @act_gm_choice := (SELECT id FROM activities WHERE activity_key='act-de-gm-choice' LIMIT 1);
SET @act_pizza_conv := (SELECT id FROM activities WHERE activity_key='act-de-pizza-conversation' LIMIT 1);
SET @act_pizza_order := (SELECT id FROM activities WHERE activity_key='act-de-pizza-word-order' LIMIT 1);

INSERT INTO activity_targets (activity_id, curriculum_target_id) VALUES
  (@act_hallo_conv,@t_hallo),
  (@act_gm_conv,@t_gm),
  (@act_gm_choice,@t_gm_distinguish),
  (@act_pizza_conv,@t_pizza_q),
  (@act_pizza_conv,@t_pizza_a),
  (@act_pizza_order,@t_pizza_a),
  (@act_pizza_order,@t_moegen_forms)
ON DUPLICATE KEY UPDATE activity_id=VALUES(activity_id);

-- -----------------------------------------------------------------------------
-- Lexemes and forms
-- -----------------------------------------------------------------------------

INSERT INTO lexemes (
  lexeme_key, language_id, lexeme_type, surface, normalized_surface,
  lemma, part_of_speech, cefr_level, translation_fa, usage_note_fa,
  flashcard_eligible, audio_status, audio_url, audio_voice_name, audio_voice_id
) VALUES
  ('lex-de-hallo', @de_id, 'word', 'hallo', 'hallo', 'hallo', 'interjection', 'Pre-A1', 'سلام', 'برای سلام‌کردن دوستانه و عمومی.', TRUE, 'blocked_until_language_final', NULL, NULL, NULL),
  ('lex-de-guten-morgen', @de_id, 'phrase', 'guten Morgen', 'guten morgen', NULL, 'greeting_formula', 'Pre-A1', 'صبح بخیر', 'سلامی برای آغاز روز و صبح.', TRUE, 'blocked_until_language_final', NULL, NULL, NULL),
  ('lex-de-moegen', @de_id, 'word', 'mögen', 'mögen', 'mögen', 'verb', 'Pre-A1', 'دوست داشتن / خوش آمدن', NULL, TRUE, 'blocked_until_language_final', NULL, NULL, NULL),
  ('lex-de-pizza', @de_id, 'word', 'Pizza', 'pizza', 'Pizza', 'noun', 'Pre-A1', 'پیتزا', NULL, TRUE, 'blocked_until_language_final', NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE
  language_id=VALUES(language_id),
  lexeme_type=VALUES(lexeme_type),
  surface=VALUES(surface),
  normalized_surface=VALUES(normalized_surface),
  lemma=VALUES(lemma),
  part_of_speech=VALUES(part_of_speech),
  cefr_level=VALUES(cefr_level),
  translation_fa=VALUES(translation_fa),
  usage_note_fa=VALUES(usage_note_fa),
  flashcard_eligible=VALUES(flashcard_eligible),
  audio_status=VALUES(audio_status),
  audio_url=VALUES(audio_url),
  audio_voice_name=VALUES(audio_voice_name),
  audio_voice_id=VALUES(audio_voice_id);

SET @lex_hallo := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hallo' LIMIT 1);
SET @lex_gm := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-guten-morgen' LIMIT 1);
SET @lex_moegen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-moegen' LIMIT 1);
SET @lex_pizza := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-pizza' LIMIT 1);

INSERT INTO lexeme_forms (
  lexeme_form_key, lexeme_id, surface, normalized_surface,
  form_type, features, origin, review_status, notes
) VALUES
  (
    'lexform-de-moegen-mag', @lex_moegen, 'mag', 'mag', 'inflected',
    JSON_OBJECT('tense','present','mood','indicative','person',JSON_ARRAY('1','3'),'number','singular'),
    'reference_attested', 'approved',
    'Used as first-person singular in the source-backed statement Ich mag Pizza.'
  ),
  (
    'lexform-de-moegen-magst', @lex_moegen, 'magst', 'magst', 'inflected',
    JSON_OBJECT('tense','present','mood','indicative','person','2','number','singular'),
    'reference_attested', 'approved',
    'Used in the source-backed question Magst du Pizza?'
  )
ON DUPLICATE KEY UPDATE
  lexeme_id=VALUES(lexeme_id),
  surface=VALUES(surface),
  normalized_surface=VALUES(normalized_surface),
  form_type=VALUES(form_type),
  features=VALUES(features),
  origin=VALUES(origin),
  review_status=VALUES(review_status),
  notes=VALUES(notes);

SET @form_mag := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-mag' LIMIT 1);
SET @form_magst := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-magst' LIMIT 1);

INSERT INTO lesson_lexemes (lesson_id, lexeme_id, is_primary, role) VALUES
  (@lesson_hallo,@lex_hallo,TRUE,'introduce'),
  (@lesson_gm,@lex_gm,TRUE,'introduce'),
  (@lesson_gm,@lex_hallo,FALSE,'review'),
  (@lesson_pizza,@lex_moegen,TRUE,'introduce'),
  (@lesson_pizza,@lex_pizza,TRUE,'introduce')
ON DUPLICATE KEY UPDATE
  is_primary=VALUES(is_primary),
  role=VALUES(role);

INSERT INTO activity_lexemes (activity_id, lexeme_id) VALUES
  (@act_hallo_conv,@lex_hallo),
  (@act_gm_conv,@lex_gm),
  (@act_gm_choice,@lex_gm),
  (@act_gm_choice,@lex_hallo),
  (@act_pizza_conv,@lex_moegen),
  (@act_pizza_conv,@lex_pizza),
  (@act_pizza_order,@lex_moegen),
  (@act_pizza_order,@lex_pizza)
ON DUPLICATE KEY UPDATE activity_id=VALUES(activity_id);

-- Exact occurrence resolution lets runtime map surface forms without string guessing.
INSERT INTO lexeme_occurrences (
  occurrence_key, owner_type, owner_key, surface,
  start_offset, end_offset, lexeme_id, lexeme_form_id,
  resolution_status, resolution_notes
) VALUES
  ('occ-turn-de-hallo-1-hallo','dialogue_turn','turn-de-hallo-1','Hallo',NULL,NULL,@lex_hallo,NULL,'approved','Canonical lexeme occurrence; punctuation is outside the lexical surface.'),
  ('occ-turn-de-hallo-2-hallo','dialogue_turn','turn-de-hallo-2','Hallo',NULL,NULL,@lex_hallo,NULL,'approved','Canonical lexeme occurrence; punctuation is outside the lexical surface.'),
  ('occ-turn-de-gm-1-guten-morgen','dialogue_turn','turn-de-gm-1','Guten Morgen',NULL,NULL,@lex_gm,NULL,'approved','Canonical phrase occurrence with sentence-initial capitalization.'),
  ('occ-turn-de-gm-2-guten-morgen','dialogue_turn','turn-de-gm-2','Guten Morgen',NULL,NULL,@lex_gm,NULL,'approved','Canonical phrase occurrence with sentence-initial capitalization.'),
  ('occ-turn-de-pizza-1-magst','dialogue_turn','turn-de-pizza-1','Magst',NULL,NULL,@lex_moegen,@form_magst,'approved','Sentence-initial surface form resolves to mögen via magst.'),
  ('occ-turn-de-pizza-1-pizza','dialogue_turn','turn-de-pizza-1','Pizza',NULL,NULL,@lex_pizza,NULL,'approved','Canonical noun occurrence.'),
  ('occ-turn-de-pizza-2-mag','dialogue_turn','turn-de-pizza-2','mag',NULL,NULL,@lex_moegen,@form_mag,'approved','Inflected surface form resolves to mögen via mag.'),
  ('occ-turn-de-pizza-2-pizza','dialogue_turn','turn-de-pizza-2','Pizza',NULL,NULL,@lex_pizza,NULL,'approved','Canonical noun occurrence.'),
  ('occ-act-de-pizza-order-mag','activity','act-de-pizza-word-order','mag',NULL,NULL,@lex_moegen,@form_mag,'approved','Token in word-order activity resolves to mögen via mag.'),
  ('occ-act-de-pizza-order-pizza','activity','act-de-pizza-word-order','Pizza.',NULL,NULL,@lex_pizza,NULL,'approved','Word-order token includes punctuation but resolves to canonical Pizza.')
ON DUPLICATE KEY UPDATE
  owner_type=VALUES(owner_type),
  owner_key=VALUES(owner_key),
  surface=VALUES(surface),
  start_offset=VALUES(start_offset),
  end_offset=VALUES(end_offset),
  lexeme_id=VALUES(lexeme_id),
  lexeme_form_id=VALUES(lexeme_form_id),
  resolution_status=VALUES(resolution_status),
  resolution_notes=VALUES(resolution_notes);

-- -----------------------------------------------------------------------------
-- Provenance
-- -----------------------------------------------------------------------------

INSERT INTO provenance_links (
  entity_type, entity_key, source_item_id, transformation, notes
) VALUES
  -- level / unit evidence
  ('language_level','de-pre-a1',@si_hallo,'other','Current coverage evidence for the first greeting target.'),
  ('language_level','de-pre-a1',@si_gm,'other','Current coverage evidence for the morning greeting target.'),
  ('language_level','de-pre-a1',@si_moegen,'other','Current lexical evidence for mögen.'),
  ('language_level','de-pre-a1',@si_pizza,'other','Current lexical evidence for Pizza.'),
  ('language_level','de-pre-a1',@si_ich_mag_pizza,'other','Current sentence evidence for a simple positive preference.'),
  ('language_level','de-pre-a1',@si_magst_du_pizza,'other','Current sentence evidence for a simple preference question.'),

  ('unit','de-pre-a1-unit-first-steps',@si_hallo,'other','Source evidence used by content currently grouped in this unit.'),
  ('unit','de-pre-a1-unit-first-steps',@si_gm,'other','Source evidence used by content currently grouped in this unit.'),
  ('unit','de-pre-a1-unit-first-steps',@si_ich_mag_pizza,'other','Source evidence used by content currently grouped in this unit.'),
  ('unit','de-pre-a1-unit-first-steps',@si_magst_du_pizza,'other','Source evidence used by content currently grouped in this unit.'),

  -- lessons
  ('lesson','de-pre-a1-lesson-hallo',@si_hallo,'other','Lesson built around the source-backed greeting formula.'),
  ('lesson','de-pre-a1-lesson-guten-morgen',@si_gm,'other','Lesson built around the source-backed morning greeting.'),
  ('lesson','de-pre-a1-lesson-guten-morgen',@si_hallo,'other','Known general greeting used as the comparison option.'),
  ('lesson','de-pre-a1-lesson-pizza-like',@si_magst_du_pizza,'other','Source-backed preference question.'),
  ('lesson','de-pre-a1-lesson-pizza-like',@si_ich_mag_pizza,'other','Source-backed preference statement.'),
  ('lesson','de-pre-a1-lesson-pizza-like',@si_moegen,'other','Canonical lexical identity for mögen.'),
  ('lesson','de-pre-a1-lesson-pizza-like',@si_pizza,'other','Canonical lexical identity for Pizza.'),

  -- dialogues
  ('dialogue','dlg-de-pre-a1-hallo',@si_hallo,'character_metadata_added','Greeting formula placed into a minimal reciprocal scene; capitalization and punctuation are presentational.'),
  ('dialogue','dlg-de-pre-a1-guten-morgen',@si_gm,'character_metadata_added','Morning greeting formula placed into a minimal reciprocal scene; capitalization and punctuation are presentational.'),
  ('dialogue','dlg-de-pre-a1-pizza-like',@si_magst_du_pizza,'character_metadata_added','Source question assigned to Mia without changing target-language wording.'),
  ('dialogue','dlg-de-pre-a1-pizza-like',@si_ich_mag_pizza,'character_metadata_added','Source statement assigned to the learner without changing target-language wording.'),

  -- dialogue turns
  ('dialogue_turn','turn-de-hallo-1',@si_hallo,'other','Source lexical item used as Hallo! with sentence capitalization and punctuation; Persian translation added separately.'),
  ('dialogue_turn','turn-de-hallo-2',@si_hallo,'other','Source lexical item used as Hallo! with sentence capitalization and punctuation; Persian translation added separately.'),
  ('dialogue_turn','turn-de-gm-1',@si_gm,'other','Source formula used as Guten Morgen! with sentence capitalization and punctuation; Persian translation added separately.'),
  ('dialogue_turn','turn-de-gm-2',@si_gm,'other','Source formula used as Guten Morgen! with sentence capitalization and punctuation; Persian translation added separately.'),
  ('dialogue_turn','turn-de-pizza-1',@si_magst_du_pizza,'persian_translation_added','Exact source-backed German question with Persian translation added.'),
  ('dialogue_turn','turn-de-pizza-2',@si_ich_mag_pizza,'persian_translation_added','Exact source-backed German statement with Persian translation added.'),

  -- activities
  ('activity','act-de-hallo-conversation',@si_hallo,'character_metadata_added','Source-backed greeting used in the opening spoken exchange.'),
  ('activity','act-de-gm-conversation',@si_gm,'character_metadata_added','Source-backed morning greeting used in the opening spoken exchange.'),
  ('activity','act-de-gm-choice',@si_gm,'options_selected_from_source_material','Correct option selected from source-backed material.'),
  ('activity','act-de-gm-choice',@si_hallo,'options_selected_from_source_material','Contrast option selected from already source-backed material.'),
  ('activity','act-de-pizza-conversation',@si_magst_du_pizza,'character_metadata_added','Source-backed question used in the opening exchange.'),
  ('activity','act-de-pizza-conversation',@si_ich_mag_pizza,'character_metadata_added','Source-backed answer used in the opening exchange.'),
  ('activity','act-de-pizza-word-order',@si_ich_mag_pizza,'sentence_tokenized_for_word_order','Exact source sentence tokenized without inventing new target-language text.'),

  -- lexemes / forms
  ('lexeme','lex-de-hallo',@si_hallo,'verbatim','Canonical source-backed greeting lexeme.'),
  ('lexeme','lex-de-guten-morgen',@si_gm,'verbatim','Canonical source-backed greeting phrase.'),
  ('lexeme','lex-de-moegen',@si_moegen,'verbatim','Canonical source-backed verb lemma.'),
  ('lexeme','lex-de-pizza',@si_pizza,'verbatim','Canonical source-backed noun.'),
  ('lexeme_form','lexform-de-moegen-mag',@si_mag,'verbatim','Approved source-attested present form of mögen.'),
  ('lexeme_form','lexform-de-moegen-magst',@si_magst,'verbatim','Approved source-attested present form of mögen.')
ON DUPLICATE KEY UPDATE
  notes=VALUES(notes);

COMMIT;

-- Optional QA reads after import:
-- SELECT * FROM v_language_level_structure_counts WHERE language_level_id=@de_pre_a1_id;
-- SELECT * FROM v_invalid_learner_facing_source_links;
-- SELECT * FROM v_lexeme_surface_candidates WHERE language_id=@de_id ORDER BY lexeme_id, lexeme_form_id;
