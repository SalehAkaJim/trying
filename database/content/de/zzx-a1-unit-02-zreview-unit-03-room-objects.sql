-- German A1: close Unit 2 for review, open Unit 3 and build its first sourced lesson.
-- Base content never overwrites generated audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @unit2 := (SELECT id FROM units WHERE unit_key='de-a1-unit-family-and-close-people' LIMIT 1);
UPDATE units SET status='review',notes='بازبینی پوشش انجام شد. دو درس موجود پدر، مادر، برادر و خواهر و اطلاعات سادهٔ نام، سن، محل زندگی و شغل را پوشش می‌دهند. در این مرحله شکاف ضروری مستقلی برای ساخت درس سوم پیدا نشد؛ واحد در بازبینی قرار می‌گیرد.' WHERE id=@unit2 AND status <> 'final';

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes)
VALUES('src-wikibooks-de-lesson-007-room-objects','Deutschkurs für Anfänger/Lektion 007','اتاق و وسایل سادهٔ داخل آن','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_007','Items 271, 274/274a and selected safe vocabulary from 280: room, table, lamp, chair and simple ownership questions and answers.','بخش‌های ۲۷۱ و ۲۷۴ و پاسخ تکمیلی ۲۷۴، همراه چند واژهٔ سالم از بخش ۲۸۰؛ اتاق و وسایل ساده و پرسش و پاسخ مالکیت.','2025-01-04','contemporary_verified','صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ بررسی شد؛ آخرین ویرایش ثبت‌شدهٔ صفحه ۴ ژانویهٔ ۲۰۲۵ است. برای این رکورد فقط جفت‌های روشن و مستقیم پرسش و پاسخ دربارهٔ اتاق و وسایل آن و واژه‌های سالم همان بخش‌ها استفاده می‌شوند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 007','reuse_with_attribution','2026-09-17','رکورد جداگانه برای واحد خانه و محیط نزدیک. استفاده به بخش‌های مشخص دربارهٔ اتاق، میز، چراغ و صندلی محدود شده است و نمونه‌های مشکوک یا دارای خطای ضمیر از بخش‌های دیگر صفحه وارد محتوای آموزشی نمی‌شوند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes)
VALUES('de-a1-unit-home-and-nearby',@level,3,'خانه و محیط نزدیک','پس از معرفی خود و افراد نزدیک، دامنهٔ A1 به محیط فوری زندگی گسترش می‌یابد. این واحد از اشیای ملموس و پرسش‌های کوتاه شروع می‌کند و سپس می‌تواند به اتاق، ویژگی و محل قرارگیری وسایل برسد؛ ترتیب از شناخت ساده به توصیف محدود حرکت می‌کند.','draft',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-wikibooks-de-lesson-007-room-objects'),'learningTargets',JSON_ARRAY('تشخیص واژگان پرتکرار اتاق و وسایل ساده','فهم پرسش و پاسخ کوتاه دربارهٔ شناسایی یا تعلق وسیله','فهم اطلاعات ساده دربارهٔ اتاق و وسایل در ادامهٔ واحد','اتصال واژگان خانه به بافت واقعی محل زندگی')),'درس نخست دربارهٔ اتاق و وسایل پایه با تمرکز بر میز و چراغ ساخته می‌شود. مرحلهٔ بعد باید ویژگی سادهٔ اتاق و موقعیت وسایل را با منبع قابل‌بازاستفاده پوشش دهد.')
ON DUPLICATE KEY UPDATE sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=IF(status IN ('review','final'),status,VALUES(status)),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-home-and-nearby' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);
SET @t_home := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-home' LIMIT 1);
SET @t_home_sit := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-home' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);
SET @t_register := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-pronouns-register' LIMIT 1);
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES(@unit,@t_home),(@unit,@t_home_sit),(@unit,@t_core),(@unit,@t_questions),(@unit,@t_register);

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@src,'srcitem-de-a1-room-table-q','274a','پاسخ تکمیلی ۲۷۴','Ist das Ihr Tisch?',UNHEX(SHA2('Ist das Ihr Tisch?',256)),'پرسش مالکیت میز.'),
(@src,'srcitem-de-a1-room-table-a','274a','پاسخ تکمیلی ۲۷۴','Ja, das ist mein Tisch.',UNHEX(SHA2('Ja, das ist mein Tisch.',256)),'پاسخ مالکیت میز.'),
(@src,'srcitem-de-a1-room-lamp-q','274a','پاسخ تکمیلی ۲۷۴','Ist das Ihre Lampe?',UNHEX(SHA2('Ist das Ihre Lampe?',256)),'پرسش مالکیت چراغ.'),
(@src,'srcitem-de-a1-room-lamp-a','274a','پاسخ تکمیلی ۲۷۴','Ja, das ist meine Lampe.',UNHEX(SHA2('Ja, das ist meine Lampe.',256)),'پاسخ مالکیت چراغ.'),
(@src,'srcitem-de-a1-room-room-a','274','پاسخ ۲۷۴','Ja, das ist unser Zimmer.',UNHEX(SHA2('Ja, das ist unser Zimmer.',256)),'پاسخ منبع‌دار دربارهٔ اتاق.'),
(@src,'srcitem-de-a1-room-word-zimmer','271/274','بخش‌های ۲۷۱ و ۲۷۴','Zimmer',UNHEX(SHA2('Zimmer',256)),'واژهٔ اتاق.'),
(@src,'srcitem-de-a1-room-word-tisch','274','بخش ۲۷۴','Tisch',UNHEX(SHA2('Tisch',256)),'واژهٔ میز.'),
(@src,'srcitem-de-a1-room-word-lampe','274','بخش ۲۷۴','Lampe',UNHEX(SHA2('Lampe',256)),'واژهٔ چراغ.'),
(@src,'srcitem-de-a1-room-word-stuhl','280','بخش ۲۸۰','Stuhl',UNHEX(SHA2('Stuhl',256)),'واژهٔ صندلی.')
ON DUPLICATE KEY UPDATE source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-zimmer',@de,'word','Zimmer','Zimmer','Zimmer','noun','اسم','A1','اتاق','برای اشاره به یک اتاق در محل زندگی یا ساختمان استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-tisch',@de,'word','Tisch','Tisch','Tisch','noun','اسم','A1','میز','از وسایل پایهٔ اتاق و خانه است.',TRUE,'blocked_until_level_final'),
('lex-de-lampe',@de,'word','Lampe','Lampe','Lampe','noun','اسم','A1','چراغ / لامپ','از وسایل پایهٔ اتاق و خانه است.',TRUE,'blocked_until_level_final'),
('lex-de-stuhl',@de,'word','Stuhl','Stuhl','Stuhl','noun','اسم','A1','صندلی','از وسایل پایهٔ اتاق و خانه است.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);
SET @x_zimmer := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-zimmer');
SET @x_tisch := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-tisch');
SET @x_lampe := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-lampe');
SET @x_stuhl := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-stuhl');

INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-room-table-lamp',@level,@unit,5,1,'این میز شماست؟','Ist das Ihr Tisch? / Ist das Ihre Lampe?','آیا این میز شماست؟ / آیا این چراغ شماست؟','draft','درس با دو جفت پرسش و پاسخ دربارهٔ وسایل یک اتاق شروع می‌شود؛ سپس چهار واژهٔ پایهٔ محیط خانه تفکیک می‌شوند، پاسخ درست به پرسش چراغ بازیابی می‌شود و در پایان پرسش میز بازسازی می‌شود.','مسیر از فهم تعامل و تشخیص شیء به تثبیت واژگان، انتخاب پاسخ و بازیابی فعال پرسش می‌رود. مالکیت در بافت جمله باقی می‌ماند و به توضیح انتزاعی دستور زبان تبدیل نمی‌شود.','conversation_speaking>matching>multiple_choice>word_order','blocked_until_level_final','درس نخست واحد خانه و محیط نزدیک؛ متن آلمانی زبان‌آموز فقط از بخش‌های مشخص منبع ثبت‌شده می‌آید.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-room-table-lamp');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES(@lesson,@t_home,'introduce'),(@lesson,@t_home_sit,'introduce'),(@lesson,@t_core,'introduce'),(@lesson,@t_questions,'practice'),(@lesson,@t_register,'practice');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES(@lesson,@x_zimmer,TRUE,'introduce'),(@lesson,@x_tisch,TRUE,'introduce'),(@lesson,@x_lampe,TRUE,'introduce'),(@lesson,@x_stuhl,TRUE,'introduce');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES('dlg-de-a1-room-table-lamp',@level,'آیریس در یک اتاق دو وسیله را به پاول نشان می‌دهد و مؤدبانه می‌پرسد آیا متعلق به او هستند؛ پاول پاسخ می‌دهد.','app','دو جفت پرسش و پاسخ بخش تکمیلی ۲۷۴ منبع بدون بازنویسی کنار هم قرار گرفته‌اند. هر دو دربارهٔ مالکیت وسایل داخل اتاق هستند و خطاب رسمی با رابطهٔ آشنایی مؤدبانهٔ آیریس و پاول سازگار است.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dialogue := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-room-table-lamp');
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-room-objects-1',@dialogue,1,@iris,'app_assigned','unspecified','Ist das Ihr Tisch?','آیا این میز شماست؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-room-objects-2',@dialogue,2,@paul,'app_assigned','unspecified','Ja, das ist mein Tisch.','بله، این میز من است.',TRUE,'blocked_until_level_final'),
('turn-de-a1-room-objects-3',@dialogue,3,@iris,'app_assigned','unspecified','Ist das Ihre Lampe?','آیا این چراغ شماست؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-room-objects-4',@dialogue,4,@paul,'app_assigned','unspecified','Ja, das ist meine Lampe.','بله، این چراغ من است.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);

INSERT INTO lexeme_occurrences(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-a1-room-objects-1','dialogue_turn','turn-de-a1-room-objects-1','Tisch',NULL,NULL,@x_tisch,NULL,'approved','واژهٔ میز در پرسش منبع‌دار.'),
('occ-turn-de-a1-room-objects-2','dialogue_turn','turn-de-a1-room-objects-2','Tisch',NULL,NULL,@x_tisch,NULL,'approved','واژهٔ میز در پاسخ منبع‌دار.'),
('occ-turn-de-a1-room-objects-3','dialogue_turn','turn-de-a1-room-objects-3','Lampe',NULL,NULL,@x_lampe,NULL,'approved','واژهٔ چراغ در پرسش منبع‌دار.'),
('occ-turn-de-a1-room-objects-4','dialogue_turn','turn-de-a1-room-objects-4','Lampe',NULL,NULL,@x_lampe,NULL,'approved','واژهٔ چراغ در پاسخ منبع‌دار.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-room-objects-conversation',@lesson,1,'conversation_speaking','آیریس دربارهٔ میز و چراغ می‌پرسد؛ جواب بده کدام وسیله مال توست.','دو جفت پرسش و پاسخ عین منبع هستند و در یک صحنهٔ واحد اتاق و وسایل آن طبیعی می‌مانند.',@dialogue,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('other','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-room-words-matching',@lesson,2,'matching','هر وسیله را به معنی درستش وصل کن.','چهار واژهٔ پایهٔ محیط اتاق پیش از گسترش توصیف خانه تثبیت می‌شوند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Zimmer','leftFa','اتاق','right','اتاق','rightFa','اتاق'),JSON_OBJECT('left','Tisch','leftFa','میز','right','میز','rightFa','میز'),JSON_OBJECT('left','Lampe','leftFa','چراغ / لامپ','right','چراغ / لامپ','rightFa','چراغ / لامپ'),JSON_OBJECT('left','Stuhl','leftFa','صندلی','right','صندلی','rightFa','صندلی'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-a1-room-lamp-choice',@lesson,3,'multiple_choice','پاسخ درست به پرسش دربارهٔ چراغ کدام است؟','پاسخ درست چراغ در برابر دو پاسخ منبع‌دار مربوط به وسایل دیگر بازیابی می‌شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Ja, das ist meine Lampe.','translationFa','بله، این چراغ من است.','correct',TRUE),JSON_OBJECT('textTarget','Ja, das ist mein Tisch.','translationFa','بله، این میز من است.','correct',FALSE),JSON_OBJECT('textTarget','Ja, das ist unser Zimmer.','translationFa','بله، این اتاق ماست.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-room-table-order',@lesson,4,'word_order','پرسش دربارهٔ میز را دوباره بساز.','پرسش اصلی درس در پایان از تشخیص به بازیابی فعال منتقل می‌شود.',NULL,JSON_OBJECT('sourceText','Ist das Ihr Tisch?','sourceTextFa','آیا این میز شماست؟','tokens',JSON_ARRAY('Ist','das','Ihr','Tisch?'),'answer',JSON_ARRAY('Ist','das','Ihr','Tisch?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-a1-room-objects-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-a1-room-words-matching');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-a1-room-lamp-choice');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-a1-room-table-order');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES(@a1,@t_home),(@a1,@t_home_sit),(@a1,@t_register),(@a2,@t_core),(@a2,@t_home),(@a3,@t_home),(@a4,@t_questions),(@a4,@t_home);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a1,@x_tisch),(@a1,@x_lampe),(@a2,@x_zimmer),(@a2,@x_tisch),(@a2,@x_lampe),(@a2,@x_stuhl),(@a3,@x_lampe),(@a3,@x_tisch),(@a3,@x_zimmer),(@a4,@x_tisch);

SET @si_table_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-table-q');
SET @si_table_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-table-a');
SET @si_lamp_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-lamp-q');
SET @si_lamp_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-lamp-a');
SET @si_room_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-room-a');
SET @si_zimmer := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-word-zimmer');
SET @si_tisch := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-word-tisch');
SET @si_lampe := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-word-lampe');
SET @si_stuhl := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-room-word-stuhl');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-room-objects-1',@si_table_q,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-room-objects-2',@si_table_a,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-room-objects-3',@si_lamp_q,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-room-objects-4',@si_lamp_a,'verbatim','متن هدف عین منبع است.'),
('lexeme','lex-de-zimmer',@si_zimmer,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-tisch',@si_tisch,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-lampe',@si_lampe,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-stuhl',@si_stuhl,'verbatim','صورت واژه در منبع ثبت شده است.'),
('activity','act-de-a1-room-lamp-choice',@si_lamp_a,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-room-lamp-choice',@si_table_a,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-room-lamp-choice',@si_room_a,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-room-table-order',@si_table_q,'sentence_tokenized_for_word_order','پرسش عین منبع برای مرتب‌سازی بخش‌بندی شده است.');

UPDATE language_levels SET coverage=JSON_SET(coverage,'$.gaps[2]','توالی آموزشی اولیه ثبت شده است؛ دو واحد نخست به بازبینی رسیده‌اند و واحد سوم خانه و محیط نزدیک با نخستین درس منبع‌دار در حال ساخت است.'),notes='A1 همچنان در مرحلهٔ ساخت تدریجی است. واحدهای معرفی کامل‌تر و خانواده در بازبینی‌اند. واحد سوم خانه و محیط نزدیک باز شده و نخستین درس آن اتاق، میز، چراغ و صندلی و پرسش و پاسخ ساده دربارهٔ وسایل را پوشش می‌دهد؛ مرحلهٔ بعد ویژگی اتاق و موقعیت وسایل است.' WHERE id=@level;
COMMIT;
