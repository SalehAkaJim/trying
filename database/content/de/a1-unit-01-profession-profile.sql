-- German A1 Unit 1 — profession profile lesson
-- Canonical runtime: MySQL 9.0.1
-- Idempotent learner-content migration. A1 audio remains blocked until the whole level is final.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-extended-introduction' LIMIT 1);
SET @jonas := (SELECT id FROM characters WHERE character_key='char-de-jonas' LIMIT 1);
SET @lena := (SELECT id FROM characters WHERE character_key='char-de-lena' LIMIT 1);

INSERT INTO sources (
  source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,
  published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,
  reuse_status,retrieved_at,notes
) VALUES (
  'src-wikibooks-de-lesson-002-professions',
  'Deutschkurs für Anfänger/Lektion 002',
  'شناسایی افراد و شغل در درس ۰۰۲',
  'Wikibooks contributors','de','course',
  'https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_002',
  'Items 070–079, especially 070 and 072: professions, identifying a person, and asking Was ist er/sie von Beruf?',
  'بخش‌های ۰۷۰ تا ۰۷۹، به‌ویژه ۰۷۰ و ۰۷۲؛ واژه‌های شغل، معرفی یک نفر و پرسیدن شغل او.',
  '2023-12-13','contemporary_verified',
  'صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ دوباره بررسی شد. هرچند آخرین ویرایش صفحه ۱۳ دسامبر ۲۰۲۳ است، الگوهای پایهٔ معرفی شخص، ضمیر سوم‌شخص و پرسیدن شغل در بخش‌های ۰۷۰ تا ۰۷۹ همچنان با آلمانی معیار معاصر سازگارند.',
  'CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/',
  'Wikibooks contributors — Deutschkurs für Anfänger/Lektion 002',
  'reuse_with_attribution','2026-09-17',
  'این رکورد فقط بخش شغل و شناسایی افراد را پوشش می‌دهد تا از رکورد قدیمی‌تر همین صفحه که برای غذا و سفارش استفاده شده جدا بماند. گفت‌وگوی بخش ۰۷۲ هشت نوبت پیوسته دارد و با اطلاعات آشنای مبدأ و مکان شروع می‌شود و به پرسش شغل می‌رسد.'
)
ON DUPLICATE KEY UPDATE
  title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),
  language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),
  locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),
  modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),
  license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),
  reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);

SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@src,'srcitem-de-a1-profession-who','072','بخش ۰۷۲','Wer ist das?',UNHEX(SHA2('Wer ist das?',256)),'پرسش شناسایی فرد.'),
(@src,'srcitem-de-a1-profession-werner','072','بخش ۰۷۲','Das ist Herr Werner.',UNHEX(SHA2('Das ist Herr Werner.',256)),'معرفی آقای ورنر.'),
(@src,'srcitem-de-a1-profession-amerikaner','072','بخش ۰۷۲','Ist er Amerikaner?',UNHEX(SHA2('Ist er Amerikaner?',256)),'پرسش دربارهٔ ملیت.'),
(@src,'srcitem-de-a1-profession-deutscher','072','بخش ۰۷۲','Nein, er ist Deutscher.',UNHEX(SHA2('Nein, er ist Deutscher.',256)),'پاسخ دربارهٔ ملیت.'),
(@src,'srcitem-de-a1-profession-hamburg','072','بخش ۰۷۲','Ist er jetzt in Hamburg?',UNHEX(SHA2('Ist er jetzt in Hamburg?',256)),'پرسش دربارهٔ مکان فعلی.'),
(@src,'srcitem-de-a1-profession-berlin','072','بخش ۰۷۲','Nein, er ist in Berlin.',UNHEX(SHA2('Nein, er ist in Berlin.',256)),'پاسخ دربارهٔ مکان فعلی.'),
(@src,'srcitem-de-a1-profession-question','072','بخش ۰۷۲','Was ist er von Beruf?',UNHEX(SHA2('Was ist er von Beruf?',256)),'پرسش شغل.'),
(@src,'srcitem-de-a1-profession-kraftfahrer-sentence','072','بخش ۰۷۲','Er ist Kraftfahrer.',UNHEX(SHA2('Er ist Kraftfahrer.',256)),'پاسخ شغل آقای ورنر.'),
(@src,'srcitem-de-a1-profession-student-sentence','070','بخش ۰۷۰','Er ist Student.',UNHEX(SHA2('Er ist Student.',256)),'جملهٔ شغلی دانشجوی مرد.'),
(@src,'srcitem-de-a1-profession-studentin-sentence','070','بخش ۰۷۰','Sie ist Studentin.',UNHEX(SHA2('Sie ist Studentin.',256)),'جملهٔ شغلی دانشجوی زن.'),
(@src,'srcitem-de-a1-profession-polizist-sentence','070','بخش ۰۷۰','Er ist Polizist.',UNHEX(SHA2('Er ist Polizist.',256)),'جملهٔ شغلی پلیس مرد.'),
(@src,'srcitem-de-a1-profession-polizistin-sentence','070','بخش ۰۷۰','Sie ist Polizistin.',UNHEX(SHA2('Sie ist Polizistin.',256)),'جملهٔ شغلی پلیس زن.'),
(@src,'srcitem-de-a1-profession-word-student','070','بخش ۰۷۰','Student',UNHEX(SHA2('Student',256)),'واژهٔ شغلی.'),
(@src,'srcitem-de-a1-profession-word-studentin','070','بخش ۰۷۰','Studentin',UNHEX(SHA2('Studentin',256)),'واژهٔ شغلی.'),
(@src,'srcitem-de-a1-profession-word-polizist','070','بخش ۰۷۰','Polizist',UNHEX(SHA2('Polizist',256)),'واژهٔ شغلی.'),
(@src,'srcitem-de-a1-profession-word-polizistin','070','بخش ۰۷۰','Polizistin',UNHEX(SHA2('Polizistin',256)),'واژهٔ شغلی.'),
(@src,'srcitem-de-a1-profession-word-beruf','070/072','بخش‌های ۰۷۰ و ۰۷۲','Beruf',UNHEX(SHA2('Beruf',256)),'واژهٔ شغل.'),
(@src,'srcitem-de-a1-profession-word-kraftfahrer','072','بخش ۰۷۲','Kraftfahrer',UNHEX(SHA2('Kraftfahrer',256)),'واژهٔ راننده.')
ON DUPLICATE KEY UPDATE
  source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
  source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

INSERT INTO lexemes(
  lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,
  cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status
) VALUES
('lex-de-beruf',@de,'word','Beruf','Beruf','Beruf','noun','اسم','A1','شغل / حرفه','در پرسش منبع‌دار «Was ist er von Beruf?» برای پرسیدن شغل یک نفر به کار می‌رود.',TRUE,'blocked_until_level_final'),
('lex-de-student',@de,'word','Student','Student','Student','noun','اسم','A1','دانشجوی مرد','در بخش منبع‌دار شغل‌ها برای معرفی یک دانشجوی مرد استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-studentin',@de,'word','Studentin','Studentin','Studentin','noun','اسم','A1','دانشجوی زن','در بخش منبع‌دار شغل‌ها برای معرفی یک دانشجوی زن استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-polizist',@de,'word','Polizist','Polizist','Polizist','noun','اسم','A1','پلیس مرد','در بخش منبع‌دار شغل‌ها برای معرفی یک پلیس مرد استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-polizistin',@de,'word','Polizistin','Polizistin','Polizistin','noun','اسم','A1','پلیس زن','در بخش منبع‌دار شغل‌ها برای معرفی یک پلیس زن استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-kraftfahrer',@de,'word','Kraftfahrer','Kraftfahrer','Kraftfahrer','noun','اسم','A1','راننده','در گفت‌وگوی منبع‌دار بخش ۰۷۲ به‌عنوان شغل آقای ورنر آمده است.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE
  language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),
  lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),
  translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible),
  audio_status=IF(audio_status='ready',audio_status,VALUES(audio_status));

SET @x_beruf := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-beruf' LIMIT 1);
SET @x_student := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-student' LIMIT 1);
SET @x_studentin := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-studentin' LIMIT 1);
SET @x_polizist := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-polizist' LIMIT 1);
SET @x_polizistin := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-polizistin' LIMIT 1);
SET @x_kraftfahrer := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kraftfahrer' LIMIT 1);

SET @t_personal := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-personal-info' LIMIT 1);
SET @t_work := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-work-school-routine' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);
SET @t_intro := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-introductions' LIMIT 1);

INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES
(@unit,@t_personal),(@unit,@t_work),(@unit,@t_core),(@unit,@t_questions),(@unit,@t_intro);

INSERT INTO lessons(
  lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,
  status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
  'de-a1-lesson-profession-profile',@level,@unit,1,1,'شغلش چیه؟',
  'Wer ist das? / Was ist er von Beruf?','این کیه؟ / شغلش چیه؟','draft',
  'درس با یک گفت‌وگوی هشت‌نوبتی پیوسته شروع می‌شود که اطلاعات آشنای هویت و مکان را به پرسش شغل وصل می‌کند؛ سپس واژه‌های شغلی تفکیک می‌شوند، پرسش شغل بازسازی می‌شود و در پایان پاسخ درست از میان جمله‌های منبع‌دار انتخاب می‌شود.',
  'مسیر از فهم بافت و بازیابی آموخته‌های قبلی به تشخیص واژه، بازسازی پرسش و در نهایت انتخاب پاسخ شغلی می‌رود؛ بنابراین هدف تازه بدون توضیح دستوری انتزاعی تثبیت می‌شود.',
  'conversation_speaking>matching>word_order>multiple_choice','blocked_until_level_final',
  'نخستین درس واقعی A1؛ متن‌های آلمانی زبان‌آموز همگی به بخش‌های ۰۷۰ و ۰۷۲ منبع ثبت‌شده متصل‌اند.'
)
ON DUPLICATE KEY UPDATE
  language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
  title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
  activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),
  audio_status=IF(audio_status='ready',audio_status,VALUES(audio_status)),notes=VALUES(notes);

SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-profession-profile' LIMIT 1);

INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES
(@lesson,@t_personal,'review'),
(@lesson,@t_work,'introduce'),
(@lesson,@t_core,'introduce'),
(@lesson,@t_questions,'practice'),
(@lesson,@t_intro,'practice');

INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES
(@lesson,@x_beruf,TRUE,'introduce'),
(@lesson,@x_student,TRUE,'introduce'),
(@lesson,@x_studentin,TRUE,'introduce'),
(@lesson,@x_polizist,TRUE,'introduce'),
(@lesson,@x_polizistin,TRUE,'introduce'),
(@lesson,@x_kraftfahrer,TRUE,'introduce');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES (
  'dlg-de-a1-profession-profile',@level,
  'یوناس و لنا اطلاعات کوتاه آقای ورنر را مرور می‌کنند؛ اطلاعات آشنای هویت و مکان در پایان به پرسش تازه دربارهٔ شغل می‌رسد.',
  'app',
  'هشت نوبت عیناً از یک بخش پیوستهٔ منبع گرفته شده‌اند. سه جفت نخست اطلاعات آشنای هویت، ملیت و مکان را بازیابی می‌کنند و جفت پایانی هدف تازهٔ شغل را وارد می‌کند؛ بنابراین درس بدون تکرار آموزشی سطح قبلی به A1 پل می‌زند.'
)
ON DUPLICATE KEY UPDATE
  language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),
  scene_quality_rationale=VALUES(scene_quality_rationale);

SET @dialogue := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-profession-profile' LIMIT 1);

INSERT INTO dialogue_turns(
  turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
  text_target,translation_fa,learner_turn,audio_status
) VALUES
('turn-de-a1-profession-1',@dialogue,1,@jonas,'app_assigned','unspecified','Wer ist das?','این کیه؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-profession-2',@dialogue,2,@lena,'app_assigned','unspecified','Das ist Herr Werner.','این آقای ورنر است.',TRUE,'blocked_until_level_final'),
('turn-de-a1-profession-3',@dialogue,3,@jonas,'app_assigned','unspecified','Ist er Amerikaner?','آیا او آمریکایی است؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-profession-4',@dialogue,4,@lena,'app_assigned','unspecified','Nein, er ist Deutscher.','نه، او آلمانی است.',TRUE,'blocked_until_level_final'),
('turn-de-a1-profession-5',@dialogue,5,@jonas,'app_assigned','unspecified','Ist er jetzt in Hamburg?','آیا او الان در هامبورگ است؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-profession-6',@dialogue,6,@lena,'app_assigned','unspecified','Nein, er ist in Berlin.','نه، او در برلین است.',TRUE,'blocked_until_level_final'),
('turn-de-a1-profession-7',@dialogue,7,@jonas,'app_assigned','unspecified','Was ist er von Beruf?','شغل او چیست؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-profession-8',@dialogue,8,@lena,'app_assigned','unspecified','Er ist Kraftfahrer.','او راننده است.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE
  dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),
  speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),
  text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn),
  audio_status=IF(audio_status='ready',audio_status,VALUES(audio_status));

INSERT INTO activities(
  activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,
  transformations,audio_text_target,audio_status
) VALUES
(
  'act-de-a1-profession-conversation',@lesson,1,'conversation_speaking',
  'با یوناس اطلاعات آقای ورنر را مرور کن و تا سؤال شغل پیش برو.',
  'گفت‌وگوی منبع دقیقاً هشت نوبت پیوسته دارد و با دانسته‌های قبلی شروع می‌شود و در دو نوبت پایانی هدف تازهٔ شغل را وارد می‌کند.',
  @dialogue,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),
  JSON_ARRAY('verbatim_dialogue','persian_translation_added','character_metadata_added','cefr_level_assigned_by_app'),NULL,'not_required'
),
(
  'act-de-a1-profession-matching',@lesson,2,'matching',
  'هر شغل را به معنی درستش وصل کن.',
  'چهار واژهٔ شغلیِ عیناً ثبت‌شده در منبع، تفاوت واژگانی و شکل‌های مردانه و زنانه را بدون افزودن مثال ساختگی تثبیت می‌کنند.',
  NULL,
  JSON_OBJECT('pairs',JSON_ARRAY(
    JSON_OBJECT('left','Student','leftFa','دانشجوی مرد','right','دانشجوی مرد','rightFa','دانشجوی مرد'),
    JSON_OBJECT('left','Studentin','leftFa','دانشجوی زن','right','دانشجوی زن','rightFa','دانشجوی زن'),
    JSON_OBJECT('left','Polizist','leftFa','پلیس مرد','right','پلیس مرد','rightFa','پلیس مرد'),
    JSON_OBJECT('left','Polizistin','leftFa','پلیس زن','right','پلیس زن','rightFa','پلیس زن')
  )),
  JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'
),
(
  'act-de-a1-profession-word-order',@lesson,3,'word_order',
  'پرسش شغل را دوباره بساز.',
  'بعد از فهم گفت‌وگو و واژه‌ها، بازسازی پرسش اصلی یادگیری را از تشخیص به بازیابی فعال می‌برد.',
  NULL,
  JSON_OBJECT('sourceText','Was ist er von Beruf?','sourceTextFa','شغل او چیست؟','tokens',JSON_ARRAY('Was','ist','er','von','Beruf?'),'answer',JSON_ARRAY('Was','ist','er','von','Beruf?')),
  JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'
),
(
  'act-de-a1-profession-choice',@lesson,4,'multiple_choice',
  'طبق گفت‌وگو، شغل آقای ورنر چیست؟',
  'مرحلهٔ پایانی پاسخ دقیق گفت‌وگو را در برابر دو جملهٔ شغلی دیگر که آن‌ها هم عیناً در همان منبع آمده‌اند بازیابی می‌کند.',
  NULL,
  JSON_OBJECT('options',JSON_ARRAY(
    JSON_OBJECT('textTarget','Er ist Kraftfahrer.','translationFa','او راننده است.','correct',TRUE),
    JSON_OBJECT('textTarget','Er ist Student.','translationFa','او دانشجوی مرد است.','correct',FALSE),
    JSON_OBJECT('textTarget','Er ist Polizist.','translationFa','او پلیس مرد است.','correct',FALSE)
  )),
  JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE
  lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
  selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),
  audio_text_target=VALUES(audio_text_target),audio_status=VALUES(audio_status);

SET @a_conv := (SELECT id FROM activities WHERE activity_key='act-de-a1-profession-conversation' LIMIT 1);
SET @a_match := (SELECT id FROM activities WHERE activity_key='act-de-a1-profession-matching' LIMIT 1);
SET @a_order := (SELECT id FROM activities WHERE activity_key='act-de-a1-profession-word-order' LIMIT 1);
SET @a_choice := (SELECT id FROM activities WHERE activity_key='act-de-a1-profession-choice' LIMIT 1);

INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES
(@a_conv,@t_personal),(@a_conv,@t_work),(@a_conv,@t_intro),
(@a_match,@t_core),
(@a_order,@t_questions),(@a_order,@t_work),
(@a_choice,@t_work),(@a_choice,@t_core);

INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES
(@a_conv,@x_beruf),(@a_conv,@x_kraftfahrer),
(@a_match,@x_student),(@a_match,@x_studentin),(@a_match,@x_polizist),(@a_match,@x_polizistin),
(@a_order,@x_beruf),
(@a_choice,@x_kraftfahrer),(@a_choice,@x_student),(@a_choice,@x_polizist);

SET @si1 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-who' LIMIT 1);
SET @si2 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-werner' LIMIT 1);
SET @si3 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-amerikaner' LIMIT 1);
SET @si4 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-deutscher' LIMIT 1);
SET @si5 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-hamburg' LIMIT 1);
SET @si6 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-berlin' LIMIT 1);
SET @si7 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-question' LIMIT 1);
SET @si8 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-kraftfahrer-sentence' LIMIT 1);
SET @si_student_sentence := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-student-sentence' LIMIT 1);
SET @si_polizist_sentence := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-polizist-sentence' LIMIT 1);
SET @si_student := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-word-student' LIMIT 1);
SET @si_studentin := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-word-studentin' LIMIT 1);
SET @si_polizist := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-word-polizist' LIMIT 1);
SET @si_polizistin := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-word-polizistin' LIMIT 1);
SET @si_beruf := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-word-beruf' LIMIT 1);
SET @si_kraftfahrer := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-profession-word-kraftfahrer' LIMIT 1);

INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-profession-1',@si1,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-profession-2',@si2,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-profession-3',@si3,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-profession-4',@si4,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-profession-5',@si5,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-profession-6',@si6,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-profession-7',@si7,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-profession-8',@si8,'verbatim','متن هدف عین منبع است.'),
('lexeme','lex-de-beruf',@si_beruf,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-student',@si_student,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-studentin',@si_studentin,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-polizist',@si_polizist,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-polizistin',@si_polizistin,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-kraftfahrer',@si_kraftfahrer,'verbatim','صورت واژه در منبع ثبت شده است.'),
('activity','act-de-a1-profession-word-order',@si7,'sentence_tokenized_for_word_order','پرسش عین منبع برای مرتب‌سازی واژه‌ها بخش‌بندی شده است.'),
('activity','act-de-a1-profession-choice',@si8,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-profession-choice',@si_student_sentence,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-profession-choice',@si_polizist_sentence,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.');

UPDATE language_levels
SET notes='A1 همچنان در مرحلهٔ برنامه‌ریزی و ساخت تدریجی است. سطح پیش از A1 پیش‌نیاز بسته و ثابت باقی می‌ماند. واحد نخست باز است و درس اول آن دربارهٔ شناسایی فرد و پرسیدن شغل، با گفت‌وگوی هشت‌نوبتی منبع‌دار ساخته شده است؛ مرحلهٔ بعد ادامهٔ همین واحد با کار شخصی و زبان‌هایی است که فرد صحبت می‌کند یا یاد می‌گیرد.'
WHERE id=@level;

COMMIT;
