-- German Pre-A1
-- Canonical runtime: MySQL 9.0.1
-- Requires database/schema.sql first.
-- Dynamic curriculum: this file contains only currently justified content.
-- No target count is encoded for units, lessons, activities, or dialogue turns.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

-- Language --------------------------------------------------------------------
INSERT INTO languages (code,name_native,name_fa,status,standalone_audio_voice_name,standalone_audio_voice_id)
VALUES ('de','Deutsch','آلمانی','building',NULL,NULL)
ON DUPLICATE KEY UPDATE name_native=VALUES(name_native),name_fa=VALUES(name_fa),status=VALUES(status);
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);

INSERT INTO language_levels (language_id,cefr_level,status,structure_rationale,coverage,notes)
VALUES (
  @de,'Pre-A1','building',
  'The level starts with the smallest immediately usable communication for a zero beginner. Structure expands only when uncovered or under-supported targets justify more content; numeric quotas do not drive authoring.',
  JSON_OBJECT(
    'communicativeTargets',JSON_ARRAY(
      'greet someone informally','use a morning greeting',
      'ask about a very familiar food preference','express a very simple positive food preference',
      'use ja and recognize nein in a familiar yes/no exchange',
      'exchange a basic thank-you and polite response'
    ),
    'linguisticTargets',JSON_ARRAY(
      'formulaic greeting hallo','formulaic morning greeting guten Morgen',
      'mögen in the present forms mag and magst','familiar noun Pizza',
      'response particles ja and nein','courtesy formulae danke and bitte'
    ),
    'situations',JSON_ARRAY(
      'simple first greeting','simple morning greeting','simple familiar-food preference exchange',
      'familiar yes/no response','simple thank-you exchange'
    ),
    'gaps',JSON_ARRAY(
      'additional courtesy expressions such as Entschuldigung','name exchange',
      'simple wellbeing exchange','simple wants and choices',
      'additional recycling and review as evidence shows it is needed'
    )
  ),
  'The listed lessons are only the content currently built, not a target count for Pre-A1.'
)
ON DUPLICATE KEY UPDATE status=VALUES(status),structure_rationale=VALUES(structure_rationale),coverage=VALUES(coverage),notes=VALUES(notes);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);

-- Curriculum targets ----------------------------------------------------------
INSERT INTO curriculum_targets
(language_level_id,target_key,target_type,title,description,required_for_completion,status,metadata)
VALUES
(@level,'de.pre_a1.greet_informal_hallo','communicative','Greet someone informally with hallo','Use hallo in a simple first-contact exchange.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.greet_morning_guten_morgen','communicative','Use guten Morgen as a morning greeting','Use the morning-specific greeting in an immediately understandable context.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.distinguish_morning_general_greeting','linguistic','Distinguish morning and general greetings','Recognize when guten Morgen is more context-specific than hallo.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.understand_pizza_preference_question','communicative','Understand a simple pizza preference question','Understand the source-backed question Magst du Pizza?',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.state_positive_pizza_preference','communicative','State a simple positive pizza preference','Use the source-backed statement Ich mag Pizza.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.notice_moegen_mag_magst','linguistic','Notice mag and magst as forms of mögen','Connect mag and magst to the canonical lexeme mögen.',FALSE,'partial',JSON_OBJECT('lexemeFormAware',TRUE)),
(@level,'de.pre_a1.answer_yes_with_ja','communicative','Answer positively with ja','Use ja as a short positive answer to a familiar yes/no question.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.recognize_no_with_nein','communicative','Recognize nein as a negative answer','Distinguish nein from ja in a familiar yes/no context.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.thank_with_danke','communicative','Understand danke as basic thanks','Understand danke in a minimal everyday courtesy exchange.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.respond_with_bitte','communicative','Respond to thanks with bitte','Use bitte as the basic polite response to thanks.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE))
ON DUPLICATE KEY UPDATE target_type=VALUES(target_type),title=VALUES(title),description=VALUES(description),required_for_completion=VALUES(required_for_completion),status=VALUES(status),metadata=VALUES(metadata);

SET @t_hallo := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.greet_informal_hallo');
SET @t_gm := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.greet_morning_guten_morgen');
SET @t_gm_diff := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.distinguish_morning_general_greeting');
SET @t_pq := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.understand_pizza_preference_question');
SET @t_pa := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.state_positive_pizza_preference');
SET @t_forms := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.notice_moegen_mag_magst');
SET @t_ja := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.answer_yes_with_ja');
SET @t_nein := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.recognize_no_with_nein');
SET @t_danke := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.thank_with_danke');
SET @t_bitte := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.respond_with_bitte');

-- Sources ---------------------------------------------------------------------
INSERT INTO sources
(source_key,title,organization_or_author,language_code,source_type,url,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes)
VALUES
('src-wiktionary-de-hallo','Wiktionary: hallo','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/hallo',NULL,'maintained_current','Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used only for contemporary greeting meaning and lexical identity.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/hallo','reuse_with_attribution','2026-09-16','Greeting formula hallo.'),
('src-wiktionary-de-guten-morgen','Wiktionary: guten Morgen','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/guten_Morgen',NULL,'maintained_current','Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for the contemporary morning greeting formula.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/guten_Morgen','reuse_with_attribution','2026-09-16','Morning greeting guten Morgen.'),
('src-wiktionary-de-moegen','Wiktionary: mögen','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/m%C3%B6gen',NULL,'maintained_current','Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for contemporary lexical identity and present-tense forms.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/m%C3%B6gen','reuse_with_attribution','2026-09-16','Lexical identity mögen and forms mag / magst.'),
('src-wiktionary-de-pizza','Wiktionary: Pizza','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/Pizza',NULL,'maintained_current','Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for the contemporary noun Pizza.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/Pizza','reuse_with_attribution','2026-09-16','Familiar food noun Pizza.'),
('src-libra-de-ich-mag-pizza','Sprachstandsfeststellung Deutsch als Zweitsprache – Zusatzmodul Alphabetisierung','Landesinstitut Brandenburg für Schule und Lehrkräftebildung (LIBRA)','de','book','https://bildungsserver.berlin-brandenburg.de/fileadmin/bbb/themen/sprachbildung/Sprachfeststellungpruefung/Sprachstandsfeststellung_DaZ_Alphabetisierung_2025-03-20.pdf','2025-03-20','contemporary_verified','Official 2025 state education material from Brandenburg; current enough to represent contemporary learner-facing German and reviewed at retrieval.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Landesinstitut Brandenburg für Schule und Lehrkräftebildung (LIBRA), Sprachstandsfeststellung Deutsch als Zweitsprache – Zusatzmodul Alphabetisierung, p. 12','reuse_with_attribution','2026-09-16','Exact statement Ich mag Pizza.'),
('src-wikibooks-de-magst-du-pizza','Wikibooks example containing Magst du Pizza?','Wikibooks contributors','de','book','https://de.wikibooks.org/wiki/Ungarisch/Ungarisch-Lesebuch-h%C3%A4ufigeW%C3%B6rter/012',NULL,'maintained_current','Live Wikibooks page reviewed in its current state at retrieval; the cited German example reflects contemporary standard usage.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — https://de.wikibooks.org/wiki/Ungarisch/Ungarisch-Lesebuch-h%C3%A4ufigeW%C3%B6rter/012','reuse_with_attribution','2026-09-16','Exact question Magst du Pizza?'),
('src-wiktionary-de-ja','Wiktionary: ja','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/ja',NULL,'maintained_current','Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for the contemporary affirmative response particle ja.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/ja','reuse_with_attribution','2026-09-16','Affirmative response particle ja.'),
('src-wiktionary-de-nein','Wiktionary: nein','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/nein',NULL,'maintained_current','Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for the contemporary negative response particle nein.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/nein','reuse_with_attribution','2026-09-16','Ordinary negative-answer meaning of nein.'),
('src-wiktionary-de-danke','Wiktionary: danke','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/danke',NULL,'maintained_current','Actively maintained German Wiktionary entry reviewed in its current state at retrieval; used for the contemporary basic expression of thanks danke.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/danke','reuse_with_attribution','2026-09-16','Basic expression of thanks danke.'),
('src-wiktionary-de-bitte','Wiktionary: bitte','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/bitte',NULL,'maintained_current','Actively maintained German Wiktionary entry reviewed in its current state at retrieval. This project uses only meanings [1] and [2]; the page maintenance warning concerns meanings [3–5], which are not reused here.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/bitte','reuse_with_attribution','2026-09-16','Used here only as a response to thanks.')
ON DUPLICATE KEY UPDATE title=VALUES(title),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);

SET @s_hallo := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-hallo');
SET @s_gm := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-guten-morgen');
SET @s_moegen := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-moegen');
SET @s_pizza := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-pizza');
SET @s_libra := (SELECT id FROM sources WHERE source_key='src-libra-de-ich-mag-pizza');
SET @s_pq := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-magst-du-pizza');
SET @s_ja := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-ja');
SET @s_nein := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-nein');
SET @s_danke := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-danke');
SET @s_bitte := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-bitte');

INSERT INTO source_items (source_id,item_key,locator,source_text,source_text_hash,notes)
VALUES
(@s_hallo,'srcitem-de-hallo-headword','German greeting formula','hallo',UNHEX(SHA2('hallo',256)),'Contemporary greeting lexeme.'),
(@s_gm,'srcitem-de-guten-morgen-formula','German greeting formula','guten Morgen',UNHEX(SHA2('guten Morgen',256)),'Contemporary morning greeting.'),
(@s_moegen,'srcitem-de-moegen-lemma','German verb lemma','mögen',UNHEX(SHA2('mögen',256)),'Canonical verb.'),
(@s_moegen,'srcitem-de-moegen-mag','Present form','mag',UNHEX(SHA2('mag',256)),'Attested present form.'),
(@s_moegen,'srcitem-de-moegen-magst','Present form','magst',UNHEX(SHA2('magst',256)),'Attested present form.'),
(@s_pizza,'srcitem-de-pizza-headword','German noun','Pizza',UNHEX(SHA2('Pizza',256)),'Contemporary noun.'),
(@s_libra,'srcitem-de-ich-mag-pizza','p. 12, Alphabetisierung – Vorlesen, Aufgabe 3a','Ich mag Pizza.',UNHEX(SHA2('Ich mag Pizza.',256)),'Exact learner statement.'),
(@s_pq,'srcitem-de-magst-du-pizza','German examples under igen, item 8','Magst du Pizza?',UNHEX(SHA2('Magst du Pizza?',256)),'Exact preference question.'),
(@s_ja,'srcitem-de-ja-headword','German affirmative response particle','ja',UNHEX(SHA2('ja',256)),'Affirmative response.'),
(@s_nein,'srcitem-de-nein-headword','German negative response particle','nein',UNHEX(SHA2('nein',256)),'Negative response.'),
(@s_danke,'srcitem-de-danke-headword','German expression of thanks','danke',UNHEX(SHA2('danke',256)),'Basic thanks.'),
(@s_bitte,'srcitem-de-bitte-response','Meaning [2]: response to thanks','bitte',UNHEX(SHA2('bitte',256)),'Basic response to thanks.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

SET @si_hallo := (SELECT id FROM source_items WHERE source_id=@s_hallo AND item_key='srcitem-de-hallo-headword');
SET @si_gm := (SELECT id FROM source_items WHERE source_id=@s_gm AND item_key='srcitem-de-guten-morgen-formula');
SET @si_moegen := (SELECT id FROM source_items WHERE source_id=@s_moegen AND item_key='srcitem-de-moegen-lemma');
SET @si_mag := (SELECT id FROM source_items WHERE source_id=@s_moegen AND item_key='srcitem-de-moegen-mag');
SET @si_magst := (SELECT id FROM source_items WHERE source_id=@s_moegen AND item_key='srcitem-de-moegen-magst');
SET @si_pizza := (SELECT id FROM source_items WHERE source_id=@s_pizza AND item_key='srcitem-de-pizza-headword');
SET @si_stmt := (SELECT id FROM source_items WHERE source_id=@s_libra AND item_key='srcitem-de-ich-mag-pizza');
SET @si_q := (SELECT id FROM source_items WHERE source_id=@s_pq AND item_key='srcitem-de-magst-du-pizza');
SET @si_ja := (SELECT id FROM source_items WHERE source_id=@s_ja AND item_key='srcitem-de-ja-headword');
SET @si_nein := (SELECT id FROM source_items WHERE source_id=@s_nein AND item_key='srcitem-de-nein-headword');
SET @si_danke := (SELECT id FROM source_items WHERE source_id=@s_danke AND item_key='srcitem-de-danke-headword');
SET @si_bitte := (SELECT id FROM source_items WHERE source_id=@s_bitte AND item_key='srcitem-de-bitte-response');

-- Characters ------------------------------------------------------------------
INSERT INTO characters (character_key,language_id,name,origin,gender,age_band,roles,relationship_tags,context_notes,voice_profile,elevenlabs_voice_id,voice_name)
VALUES
('char-de-learner',@de,'Learner','app_created','unspecified','unspecified',JSON_ARRAY('learner'),JSON_ARRAY(),'Generic learner role. No demographic assumptions are required for the current scenes.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression',NULL,'genderImpression','neutral'),NULL,NULL),
('char-de-mia',@de,'Mia','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY(),'Recurring friendly conversation partner. Current source utterances contain no evidence that conflicts with this app-assigned identity.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young adult','genderImpression','female'),NULL,NULL)
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),name=VALUES(name),origin=VALUES(origin),gender=VALUES(gender),age_band=VALUES(age_band),roles=VALUES(roles),relationship_tags=VALUES(relationship_tags),context_notes=VALUES(context_notes),voice_profile=VALUES(voice_profile);
SET @learner := (SELECT id FROM characters WHERE character_key='char-de-learner');
SET @mia := (SELECT id FROM characters WHERE character_key='char-de-mia');

-- Unit and lessons ------------------------------------------------------------
INSERT INTO units (unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes)
VALUES ('de-pre-a1-unit-first-steps',@level,1,'اولین قدم‌ها','These lessons belong together because they are immediately understandable, low-load first-contact communication for a zero beginner. The grouping is pedagogical; it has no target lesson capacity.','draft',JSON_OBJECT('dynamicStructure',TRUE),'The unit stays open or closes only when the next coverage decisions justify it, never after a lesson-count threshold.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=VALUES(status),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-pre-a1-unit-first-steps');

INSERT INTO lessons (lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES
('de-pre-a1-lesson-hallo',@level,@unit,1,1,'سلام!','hallo','draft','The learner already produces the complete target greeting inside the opening exchange, so no extra activity is added merely to increase lesson size.','Directly perform the communicative target with no pre-teaching screen.','conversation_speaking','blocked_until_language_final',NULL),
('de-pre-a1-lesson-guten-morgen',@level,@unit,2,2,'صبح بخیر!','guten Morgen','draft','After saying the morning greeting, one recognition activity distinguishes its time-specific use from the already-known general greeting.','Use the phrase first in context, then recognize when it fits.','conversation_speaking>multiple_choice','blocked_until_language_final',NULL),
('de-pre-a1-lesson-pizza-like',@level,@unit,3,3,'پیتزا دوست دارم','Magst du Pizza? / Ich mag Pizza.','draft','The source-backed exchange introduces the preference; reconstructing the learner sentence gives one focused retrieval step without adding unrelated language.','First answer a real preference question, then reconstruct the exact answer already encountered.','conversation_speaking>word_order','blocked_until_language_final',NULL),
('de-pre-a1-lesson-ja-nein',@level,@unit,4,4,'بله یا نه؟','Magst du Pizza? / ja / nein','draft','The opening reuses a known question so the only productive load is ja; one response-choice activity then introduces the contrast with nein without adding another sentence pattern.','Give a positive answer first, then distinguish the positive and negative responses in the same familiar context.','conversation_speaking>choose_response','blocked_until_language_final',NULL),
('de-pre-a1-lesson-danke-bitte',@level,@unit,5,5,'ممنون! خواهش می‌کنم','danke / bitte','draft','The two-turn exchange already performs the complete courtesy target, so no extra activity is added just to make the lesson longer.','Hear the thanks and immediately give the conventional response.','conversation_speaking','blocked_until_language_final',NULL)
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),audio_status=VALUES(audio_status),notes=VALUES(notes);

SET @l1 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-hallo');
SET @l2 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-guten-morgen');
SET @l3 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-pizza-like');
SET @l4 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-ja-nein');
SET @l5 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-danke-bitte');

INSERT INTO unit_targets (unit_id,curriculum_target_id) VALUES
(@unit,@t_hallo),(@unit,@t_gm),(@unit,@t_gm_diff),(@unit,@t_pq),(@unit,@t_pa),(@unit,@t_forms),(@unit,@t_ja),(@unit,@t_nein),(@unit,@t_danke),(@unit,@t_bitte)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id);

INSERT INTO lesson_targets (lesson_id,curriculum_target_id,coverage_role) VALUES
(@l1,@t_hallo,'introduce'),
(@l2,@t_gm,'introduce'),(@l2,@t_gm_diff,'practice'),
(@l3,@t_pq,'introduce'),(@l3,@t_pa,'introduce'),(@l3,@t_forms,'support'),
(@l4,@t_ja,'introduce'),(@l4,@t_nein,'practice'),
(@l5,@t_danke,'introduce'),(@l5,@t_bitte,'introduce')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id);

-- Dialogues -------------------------------------------------------------------
INSERT INTO dialogues (dialogue_key,language_level_id,scenario,scene_quality_rationale)
VALUES
('dlg-de-pre-a1-hallo',@level,'Two people meet and exchange the simplest informal greeting.','A reciprocal greeting is a complete communicative act for this first zero-beginner target. Extending it would add material the lesson does not yet need.'),
('dlg-de-pre-a1-guten-morgen',@level,'Two people meet in the morning and exchange a morning greeting.','The scene teaches one time-specific greeting and ends naturally after the greeting is returned.'),
('dlg-de-pre-a1-pizza-like',@level,'Mia asks about a familiar food and the learner states a simple positive preference.','The question and answer form a complete familiar-preference exchange. Additional turns are not required for the current learning target.'),
('dlg-de-pre-a1-ja',@level,'Mia repeats a familiar pizza preference question and the learner gives a positive answer.','The known pizza question removes unnecessary lexical load so the learner can focus on the new affirmative response ja.'),
('dlg-de-pre-a1-danke-bitte',@level,'Mia thanks the learner and the learner gives the basic polite response.','Danke and bitte form a complete minimal courtesy exchange. Extending the scene would add language that is not needed for this target.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),scene_quality_rationale=VALUES(scene_quality_rationale);

SET @d1 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-hallo');
SET @d2 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-guten-morgen');
SET @d3 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-pizza-like');
SET @d4 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-ja');
SET @d5 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-danke-bitte');

INSERT INTO dialogue_turns (turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status,audio_url,elevenlabs_voice_id)
VALUES
('turn-de-hallo-1',@d1,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-hallo-2',@d1,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-gm-1',@d2,1,@mia,'app_assigned','unspecified','Guten Morgen!','صبح بخیر!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-gm-2',@d2,2,@learner,'app_assigned','unspecified','Guten Morgen!','صبح بخیر!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-1',@d3,1,@mia,'app_assigned','unspecified','Magst du Pizza?','پیتزا دوست داری؟',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-2',@d3,2,@learner,'app_assigned','unspecified','Ich mag Pizza.','من پیتزا دوست دارم.',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-1',@d4,1,@mia,'app_assigned','unspecified','Magst du Pizza?','پیتزا دوست داری؟',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-2',@d4,2,@learner,'app_assigned','unspecified','Ja!','بله!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-danke-bitte-1',@d5,1,@mia,'app_assigned','unspecified','Danke!','ممنون!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-danke-bitte-2',@d5,2,@learner,'app_assigned','unspecified','Bitte!','خواهش می‌کنم!',TRUE,'blocked_until_language_final',NULL,NULL)
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn),audio_status=VALUES(audio_status),audio_url=VALUES(audio_url),elevenlabs_voice_id=VALUES(elevenlabs_voice_id);

-- Activities ------------------------------------------------------------------
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_status)
VALUES
('act-de-hallo-conversation',@l1,1,'conversation_speaking','به میا سلام کن.','The target itself is a spoken greeting, so the opening exchange is sufficient practice for this first lesson.',@d1,JSON_OBJECT('interaction','read_aloud_exchange'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language'),
('act-de-gm-conversation',@l2,1,'conversation_speaking','صبح است؛ به میا صبح بخیر بگو.','The learner should use the greeting in its natural time context before doing recognition practice.',@d2,JSON_OBJECT('interaction','read_aloud_exchange','contextFa','صبح است.'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language'),
('act-de-gm-choice',@l2,2,'multiple_choice','برای سلام کردن در صبح کدام عبارت مناسب‌تر است؟','This checks the only new distinction introduced by the lesson: a morning-specific greeting versus the already-known general greeting.',NULL,JSON_OBJECT('promptFa','صبح است.','options',JSON_ARRAY(JSON_OBJECT('textTarget','Guten Morgen!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-guten-morgen')),JSON_OBJECT('textTarget','Hallo!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-hallo')))),JSON_ARRAY('options_selected_from_source_material'),'pending_final_language'),
('act-de-pizza-conversation',@l3,1,'conversation_speaking','به سؤال میا دربارهٔ پیتزا جواب بده.','A familiar food preference creates an immediately understandable first use of mögen.',@d3,JSON_OBJECT('interaction','read_aloud_exchange'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language'),
('act-de-pizza-word-order',@l3,2,'word_order','جمله‌ای را که همین الان گفتی دوباره بساز.','Reconstructing the exact source sentence reinforces the new preference pattern without introducing new target-language content.',NULL,JSON_OBJECT('sourceText','Ich mag Pizza.','tokens',JSON_ARRAY('Ich','mag','Pizza.'),'answer',JSON_ARRAY('Ich','mag','Pizza.'),'tokenLexemeMappings',JSON_ARRAY(JSON_OBJECT('token','mag','lexemeId','lex-de-moegen','lexemeFormId','lexform-de-moegen-mag'),JSON_OBJECT('token','Pizza.','lexemeId','lex-de-pizza','lexemeFormId',NULL))),JSON_ARRAY('sentence_tokenized_for_word_order'),'pending_final_language'),
('act-de-ja-conversation',@l4,1,'conversation_speaking','این بار جواب مثبت بده.','Reusing the known pizza question isolates the new response ja.',@d4,JSON_OBJECT('interaction','read_aloud_exchange'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language'),
('act-de-ja-nein-choice',@l4,2,'choose_response','فرض کن پیتزا دوست نداری. کدام جواب مناسب است؟','The learner already understands the question, so the task can focus only on distinguishing ja from nein.',NULL,JSON_OBJECT('promptTarget','Magst du Pizza?','contextFa','پیتزا دوست نداری.','options',JSON_ARRAY(JSON_OBJECT('textTarget','Ja!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-ja')),JSON_OBJECT('textTarget','Nein!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-nein')))),JSON_ARRAY('options_selected_from_source_material'),'pending_final_language'),
('act-de-danke-bitte-conversation',@l5,1,'conversation_speaking','میا تشکر می‌کند؛ جواب بده.','Danke and bitte are best introduced as a complete everyday exchange rather than as isolated flashcards.',@d5,JSON_OBJECT('interaction','read_aloud_exchange'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_status=VALUES(audio_status);

SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-hallo-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-gm-conversation');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-gm-choice');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-pizza-conversation');
SET @a5 := (SELECT id FROM activities WHERE activity_key='act-de-pizza-word-order');
SET @a6 := (SELECT id FROM activities WHERE activity_key='act-de-ja-conversation');
SET @a7 := (SELECT id FROM activities WHERE activity_key='act-de-ja-nein-choice');
SET @a8 := (SELECT id FROM activities WHERE activity_key='act-de-danke-bitte-conversation');

INSERT INTO activity_targets (activity_id,curriculum_target_id) VALUES
(@a1,@t_hallo),(@a2,@t_gm),(@a3,@t_gm_diff),(@a4,@t_pq),(@a4,@t_pa),(@a5,@t_pa),(@a5,@t_forms),(@a6,@t_ja),(@a7,@t_nein),(@a8,@t_danke),(@a8,@t_bitte)
ON DUPLICATE KEY UPDATE activity_id=VALUES(activity_id);

-- Lexemes ---------------------------------------------------------------------
INSERT INTO lexemes (lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status,audio_url,audio_voice_name,audio_voice_id)
VALUES
('lex-de-hallo',@de,'word','hallo','hallo','hallo','interjection','Pre-A1','سلام','برای سلام‌کردن دوستانه و عمومی.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-guten-morgen',@de,'phrase','guten Morgen','guten morgen',NULL,'greeting_formula','Pre-A1','صبح بخیر','سلامی برای آغاز روز و صبح.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-moegen',@de,'word','mögen','mögen','mögen','verb','Pre-A1','دوست داشتن / خوش آمدن',NULL,TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-pizza',@de,'word','Pizza','pizza','Pizza','noun','Pre-A1','پیتزا',NULL,TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-ja',@de,'word','ja','ja','ja','response_particle','Pre-A1','بله','برای پاسخ مثبت و موافقت.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-nein',@de,'word','nein','nein','nein','response_particle','Pre-A1','نه','برای پاسخ منفی و رد کردن.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-danke',@de,'word','danke','danke','danke','interjection_response_particle','Pre-A1','ممنون / متشکرم','برای تشکر کوتاه و روزمره.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-bitte',@de,'word','bitte','bitte','bitte','adverb_response_particle','Pre-A1','خواهش می‌کنم / لطفاً','در این درس به معنی «خواهش می‌کنم» در پاسخ به تشکر استفاده می‌شود.',TRUE,'blocked_until_language_final',NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible),audio_status=VALUES(audio_status);

SET @x_hallo := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hallo');
SET @x_gm := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-guten-morgen');
SET @x_moegen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-moegen');
SET @x_pizza := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-pizza');
SET @x_ja := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-ja');
SET @x_nein := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-nein');
SET @x_danke := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-danke');
SET @x_bitte := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bitte');

INSERT INTO lexeme_forms (lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes)
VALUES
('lexform-de-moegen-mag',@x_moegen,'mag','mag','inflected',JSON_OBJECT('tense','present','mood','indicative','person',JSON_ARRAY('1','3'),'number','singular'),'reference_attested','approved','Used as first-person singular in the source-backed statement Ich mag Pizza.'),
('lexform-de-moegen-magst',@x_moegen,'magst','magst','inflected',JSON_OBJECT('tense','present','mood','indicative','person','2','number','singular'),'reference_attested','approved','Used in the source-backed question Magst du Pizza?')
ON DUPLICATE KEY UPDATE lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);
SET @f_mag := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-mag');
SET @f_magst := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-magst');

INSERT INTO lesson_lexemes (lesson_id,lexeme_id,is_primary,role) VALUES
(@l1,@x_hallo,TRUE,'introduce'),
(@l2,@x_gm,TRUE,'introduce'),(@l2,@x_hallo,FALSE,'review'),
(@l3,@x_moegen,TRUE,'introduce'),(@l3,@x_pizza,TRUE,'introduce'),
(@l4,@x_ja,TRUE,'introduce'),(@l4,@x_nein,TRUE,'introduce'),(@l4,@x_moegen,FALSE,'review'),(@l4,@x_pizza,FALSE,'review'),
(@l5,@x_danke,TRUE,'introduce'),(@l5,@x_bitte,TRUE,'introduce')
ON DUPLICATE KEY UPDATE is_primary=VALUES(is_primary),role=VALUES(role);

INSERT INTO activity_lexemes (activity_id,lexeme_id) VALUES
(@a1,@x_hallo),
(@a2,@x_gm),(@a3,@x_gm),(@a3,@x_hallo),
(@a4,@x_moegen),(@a4,@x_pizza),(@a5,@x_moegen),(@a5,@x_pizza),
(@a6,@x_moegen),(@a6,@x_pizza),(@a6,@x_ja),
(@a7,@x_ja),(@a7,@x_nein),
(@a8,@x_danke),(@a8,@x_bitte)
ON DUPLICATE KEY UPDATE activity_id=VALUES(activity_id);

-- Occurrence resolution -------------------------------------------------------
INSERT INTO lexeme_occurrences (occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes)
VALUES
('occ-turn-de-hallo-1-hallo','dialogue_turn','turn-de-hallo-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','Canonical occurrence; punctuation excluded.'),
('occ-turn-de-hallo-2-hallo','dialogue_turn','turn-de-hallo-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','Canonical occurrence; punctuation excluded.'),
('occ-turn-de-gm-1-gm','dialogue_turn','turn-de-gm-1','Guten Morgen',NULL,NULL,@x_gm,NULL,'approved','Canonical phrase with sentence-initial capitalization.'),
('occ-turn-de-gm-2-gm','dialogue_turn','turn-de-gm-2','Guten Morgen',NULL,NULL,@x_gm,NULL,'approved','Canonical phrase with sentence-initial capitalization.'),
('occ-turn-de-pizza-1-magst','dialogue_turn','turn-de-pizza-1','Magst',NULL,NULL,@x_moegen,@f_magst,'approved','Inflected form resolves to mögen.'),
('occ-turn-de-pizza-1-pizza','dialogue_turn','turn-de-pizza-1','Pizza',NULL,NULL,@x_pizza,NULL,'approved','Canonical noun.'),
('occ-turn-de-pizza-2-mag','dialogue_turn','turn-de-pizza-2','mag',NULL,NULL,@x_moegen,@f_mag,'approved','Inflected form resolves to mögen.'),
('occ-turn-de-pizza-2-pizza','dialogue_turn','turn-de-pizza-2','Pizza',NULL,NULL,@x_pizza,NULL,'approved','Canonical noun.'),
('occ-act-de-pizza-order-mag','activity','act-de-pizza-word-order','mag',NULL,NULL,@x_moegen,@f_mag,'approved','Word-order token resolves to mögen.'),
('occ-act-de-pizza-order-pizza','activity','act-de-pizza-word-order','Pizza.',NULL,NULL,@x_pizza,NULL,'approved','Token includes punctuation but resolves to Pizza.'),
('occ-turn-de-ja-1-magst','dialogue_turn','turn-de-ja-1','Magst',NULL,NULL,@x_moegen,@f_magst,'approved','Recycled inflected form resolves to mögen.'),
('occ-turn-de-ja-1-pizza','dialogue_turn','turn-de-ja-1','Pizza',NULL,NULL,@x_pizza,NULL,'approved','Recycled canonical noun.'),
('occ-turn-de-ja-2-ja','dialogue_turn','turn-de-ja-2','Ja',NULL,NULL,@x_ja,NULL,'approved','Affirmative response particle.'),
('occ-act-de-ja-nein-ja','activity','act-de-ja-nein-choice','Ja!',NULL,NULL,@x_ja,NULL,'approved','Choice option resolves to ja.'),
('occ-act-de-ja-nein-nein','activity','act-de-ja-nein-choice','Nein!',NULL,NULL,@x_nein,NULL,'approved','Choice option resolves to nein.'),
('occ-turn-de-danke-bitte-1-danke','dialogue_turn','turn-de-danke-bitte-1','Danke',NULL,NULL,@x_danke,NULL,'approved','Basic thanks formula.'),
('occ-turn-de-danke-bitte-2-bitte','dialogue_turn','turn-de-danke-bitte-2','Bitte',NULL,NULL,@x_bitte,NULL,'approved','Basic response to thanks.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),start_offset=VALUES(start_offset),end_offset=VALUES(end_offset),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

-- Provenance ------------------------------------------------------------------
INSERT INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
VALUES
('lesson','de-pre-a1-lesson-hallo',@si_hallo,'other','Source-backed greeting lesson.'),
('lesson','de-pre-a1-lesson-guten-morgen',@si_gm,'other','Source-backed morning greeting.'),
('lesson','de-pre-a1-lesson-guten-morgen',@si_hallo,'other','Previously known comparison greeting.'),
('lesson','de-pre-a1-lesson-pizza-like',@si_q,'other','Source-backed question.'),
('lesson','de-pre-a1-lesson-pizza-like',@si_stmt,'other','Source-backed statement.'),
('lesson','de-pre-a1-lesson-ja-nein',@si_q,'other','Known question reused to reduce load.'),
('lesson','de-pre-a1-lesson-ja-nein',@si_ja,'other','Affirmative response source.'),
('lesson','de-pre-a1-lesson-ja-nein',@si_nein,'other','Negative response source.'),
('lesson','de-pre-a1-lesson-danke-bitte',@si_danke,'other','Thanks formula source.'),
('lesson','de-pre-a1-lesson-danke-bitte',@si_bitte,'other','Response-to-thanks source.'),

('dialogue','dlg-de-pre-a1-hallo',@si_hallo,'character_metadata_added','Greeting placed in minimal reciprocal scene.'),
('dialogue','dlg-de-pre-a1-guten-morgen',@si_gm,'character_metadata_added','Morning greeting placed in minimal reciprocal scene.'),
('dialogue','dlg-de-pre-a1-pizza-like',@si_q,'character_metadata_added','Question assigned to Mia.'),
('dialogue','dlg-de-pre-a1-pizza-like',@si_stmt,'character_metadata_added','Statement assigned to learner.'),
('dialogue','dlg-de-pre-a1-ja',@si_q,'character_metadata_added','Known question assigned to Mia.'),
('dialogue','dlg-de-pre-a1-ja',@si_ja,'character_metadata_added','Affirmative response assigned to learner.'),
('dialogue','dlg-de-pre-a1-danke-bitte',@si_danke,'character_metadata_added','Thanks assigned to Mia.'),
('dialogue','dlg-de-pre-a1-danke-bitte',@si_bitte,'character_metadata_added','Polite response assigned to learner.'),

('dialogue_turn','turn-de-hallo-1',@si_hallo,'other','Capitalization/punctuation only; Persian translation added.'),
('dialogue_turn','turn-de-hallo-2',@si_hallo,'other','Capitalization/punctuation only; Persian translation added.'),
('dialogue_turn','turn-de-gm-1',@si_gm,'other','Capitalization/punctuation only; Persian translation added.'),
('dialogue_turn','turn-de-gm-2',@si_gm,'other','Capitalization/punctuation only; Persian translation added.'),
('dialogue_turn','turn-de-pizza-1',@si_q,'persian_translation_added','Exact source-backed question.'),
('dialogue_turn','turn-de-pizza-2',@si_stmt,'persian_translation_added','Exact source-backed statement.'),
('dialogue_turn','turn-de-ja-1',@si_q,'persian_translation_added','Exact known question reused.'),
('dialogue_turn','turn-de-ja-2',@si_ja,'other','Capitalization/punctuation only; Persian translation added.'),
('dialogue_turn','turn-de-danke-bitte-1',@si_danke,'other','Capitalization/punctuation only; Persian translation added.'),
('dialogue_turn','turn-de-danke-bitte-2',@si_bitte,'other','Capitalization/punctuation only; Persian translation added.'),

('activity','act-de-hallo-conversation',@si_hallo,'character_metadata_added','Source-backed opening exchange.'),
('activity','act-de-gm-conversation',@si_gm,'character_metadata_added','Source-backed opening exchange.'),
('activity','act-de-gm-choice',@si_gm,'options_selected_from_source_material','Correct option from source material.'),
('activity','act-de-gm-choice',@si_hallo,'options_selected_from_source_material','Contrast option from source material.'),
('activity','act-de-pizza-conversation',@si_q,'character_metadata_added','Source-backed question.'),
('activity','act-de-pizza-conversation',@si_stmt,'character_metadata_added','Source-backed answer.'),
('activity','act-de-pizza-word-order',@si_stmt,'sentence_tokenized_for_word_order','Exact source sentence tokenized.'),
('activity','act-de-ja-conversation',@si_q,'character_metadata_added','Known source-backed question.'),
('activity','act-de-ja-conversation',@si_ja,'character_metadata_added','Source-backed affirmative response.'),
('activity','act-de-ja-nein-choice',@si_q,'options_selected_from_source_material','Known prompt reused.'),
('activity','act-de-ja-nein-choice',@si_ja,'options_selected_from_source_material','Affirmative option from source.'),
('activity','act-de-ja-nein-choice',@si_nein,'options_selected_from_source_material','Negative option from source.'),
('activity','act-de-danke-bitte-conversation',@si_danke,'character_metadata_added','Source-backed thanks formula.'),
('activity','act-de-danke-bitte-conversation',@si_bitte,'character_metadata_added','Source-backed polite response.'),

('lexeme','lex-de-hallo',@si_hallo,'verbatim','Canonical source-backed lexeme.'),
('lexeme','lex-de-guten-morgen',@si_gm,'verbatim','Canonical source-backed phrase.'),
('lexeme','lex-de-moegen',@si_moegen,'verbatim','Canonical source-backed verb.'),
('lexeme','lex-de-pizza',@si_pizza,'verbatim','Canonical source-backed noun.'),
('lexeme','lex-de-ja',@si_ja,'verbatim','Canonical affirmative response particle.'),
('lexeme','lex-de-nein',@si_nein,'verbatim','Canonical negative response particle.'),
('lexeme','lex-de-danke',@si_danke,'verbatim','Canonical thanks formula.'),
('lexeme','lex-de-bitte',@si_bitte,'verbatim','Canonical response-to-thanks formula.'),
('lexeme_form','lexform-de-moegen-mag',@si_mag,'verbatim','Approved form of mögen.'),
('lexeme_form','lexform-de-moegen-magst',@si_magst,'verbatim','Approved form of mögen.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

COMMIT;
