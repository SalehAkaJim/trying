-- German A1 Unit 8 — asking and following simple directions in public places.
-- Base content never overwrites generated audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wikibooks-german-print-directions','German/Print version — Gespräch 5-2: Der Engländer in Österreich','گفت‌وگوی پرسیدن مسیر شهرداری','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Print_version','Lesson 3.05, Gespräch 5-2 — asking for the Rathaus in St. Pölten and receiving a simple route.','درس ۳.۰۵، گفت‌وگوی ۵-۲؛ پرسیدن مسیر شهرداری سنت پولتن و دریافت راهنمایی ساده.','2024-06-05','contemporary_verified','صفحهٔ زندهٔ ویکی‌بوکس در ۱۸ سپتامبر ۲۰۲۶ بررسی شد؛ آخرین ویرایش صفحه ۵ ژوئن ۲۰۲۴ ثبت شده است. چهار نوبت انتخاب‌شده دربارهٔ پرسیدن مسیر شهرداری، درخواست تکرار و راهنمایی «راست، دور گوشه و مستقیم» در بازبینی فعلی همچنان آلمانی معیار و طبیعی‌اند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Print version','reuse_with_attribution','2026-09-18','فقط چهار نوبت پیوسته از گفت‌وگوی ۵-۲ برای سناریوی پرسیدن مسیر استفاده می‌شود. نام مکان و شهر عین منبع حفظ می‌شوند و هیچ جملهٔ آلمانی آزاد به گفت‌وگو اضافه نمی‌شود.'),
('src-wikivoyage-german-phrasebook-directions','German phrasebook — Directions','عبارت‌های مسیر و مکان‌های عمومی','Wikivoyage contributors','de','website','https://en.wikivoyage.org/wiki/German_phrasebook','Directions section: public-place destinations and left/right/straight-ahead route phrases.','بخش مسیرها؛ مقصدهای عمومی و عبارت‌های چپ، راست و مستقیم.',NULL,'maintained_current','بخش زندهٔ مسیرها در عبارت‌نامهٔ آلمانی ویکی‌ویاژ در ۱۸ سپتامبر ۲۰۲۶ بررسی شد. عبارت‌های مقصدهای عمومی، چپ و راست و مستقیم در نسخهٔ فعلی صفحه حضور دارند و برای کاربرد روزمرهٔ معاصر مناسب‌اند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikivoyage contributors — German phrasebook','reuse_with_attribution','2026-09-18','برای این واحد فقط مقصدهای عمومی Bahnhof، Bushaltestelle، Flughafen و Stadtmitte و عبارت‌های Links abbiegen، Rechts abbiegen و geradeaus استفاده می‌شوند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @sbook := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-print-directions');
SET @svoy := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-directions');

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@sbook,'srcitem-de-a1-dir-d1','Gespräch 5-2','گفت‌وگوی ۵-۲','Danke sehr. Und können Sie mir sagen, wo das Rathaus von St. Pölten ist?',UNHEX(SHA2('Danke sehr. Und können Sie mir sagen, wo das Rathaus von St. Pölten ist?',256)),'پرسش نخست دربارهٔ مکان شهرداری.'),
(@sbook,'srcitem-de-a1-dir-d2','Gespräch 5-2','گفت‌وگوی ۵-۲','Wie bitte?',UNHEX(SHA2('Wie bitte?',256)),'درخواست تکرار.'),
(@sbook,'srcitem-de-a1-dir-d3','Gespräch 5-2','گفت‌وگوی ۵-۲','Wie komme ich zum Rathaus?',UNHEX(SHA2('Wie komme ich zum Rathaus?',256)),'پرسش مستقیم مسیر.'),
(@sbook,'srcitem-de-a1-dir-d4','Gespräch 5-2','گفت‌وگوی ۵-۲','Rechts um die Ecke und dann immer geradeaus – ungefähr ein Kilometer.',UNHEX(SHA2('Rechts um die Ecke und dann immer geradeaus – ungefähr ein Kilometer.',256)),'راهنمایی مسیر.'),
(@svoy,'srcitem-de-a1-dir-bahnhof','Directions','بخش مسیرها','Bahnhof',UNHEX(SHA2('Bahnhof',256)),'نام مکان عمومی.'),
(@svoy,'srcitem-de-a1-dir-bushalt','Directions','بخش مسیرها','...zum Busbahnhof / zur Bushaltestelle?',UNHEX(SHA2('...zum Busbahnhof / zur Bushaltestelle?',256)),'مقصد ایستگاه اتوبوس.'),
(@svoy,'srcitem-de-a1-dir-airport','Directions','بخش مسیرها','...zum Flughafen?',UNHEX(SHA2('...zum Flughafen?',256)),'مقصد فرودگاه.'),
(@svoy,'srcitem-de-a1-dir-center','Directions','بخش مسیرها','...zur Stadtmitte?',UNHEX(SHA2('...zur Stadtmitte?',256)),'مقصد مرکز شهر.'),
(@svoy,'srcitem-de-a1-dir-left','Directions','بخش مسیرها','Links abbiegen.',UNHEX(SHA2('Links abbiegen.',256)),'راهنمایی چپ.'),
(@svoy,'srcitem-de-a1-dir-right','Directions','بخش مسیرها','Rechts abbiegen.',UNHEX(SHA2('Rechts abbiegen.',256)),'راهنمایی راست.'),
(@svoy,'srcitem-de-a1-dir-straight','Directions','بخش مسیرها','geradeaus',UNHEX(SHA2('geradeaus',256)),'راهنمایی مستقیم.')
ON DUPLICATE KEY UPDATE source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-a1-unit-directions-public-places',@level,8,'مسیر و مکان‌های عمومی','پس از خرید، سفارش و هماهنگی زمان، زبان‌آموز به حرکت در محیط عمومی می‌رسد. یک گفت‌وگوی واقعی مسیر همراه با شبکهٔ مکان‌ها و سه جهت پایه، هدف ارتباطی این واحد را بدون نیاز به درس تکراری پوشش می‌دهد.','review',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-wikibooks-german-print-directions','src-wikivoyage-german-phrasebook-directions'),'learningTargets',JSON_ARRAY('پرسیدن مسیر مکان عمومی','فهم راست و چپ و مستقیم','تشخیص مکان‌های عمومی پرتکرار')),'بازبینی پوشش انجام شد. گفت‌وگوی اصلی پرسیدن مسیر، درخواست تکرار و راهنمایی راست و مستقیم را پوشش می‌دهد؛ تمرین‌های تکمیلی چپ و چهار مکان عمومی را اضافه می‌کنند. برای هدف فعلی مسیر و مکان‌های عمومی شکاف ضروری مستقلی برای درس دوم دیده نشد.')
ON DUPLICATE KEY UPDATE sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=IF(status='final',status,VALUES(status)),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-directions-public-places');
SET @t_dir := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-directions');
SET @t_sit := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-directions-public-places');
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary');
SET @t_q := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions');
SET @t_prep := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-time-place-prepositions');
SET @t_reg := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-pronouns-register');
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES(@unit,@t_dir),(@unit,@t_sit),(@unit,@t_core),(@unit,@t_q),(@unit,@t_prep),(@unit,@t_reg);

INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-rathaus',@de,'word','Rathaus','Rathaus','Rathaus','noun','اسم','A1','شهرداری / ساختمان شهرداری','در گفت‌وگوی منبع مقصدی است که مسافر مسیرش را می‌پرسد.',TRUE,'blocked_until_level_final'),
('lex-de-ecke',@de,'word','Ecke','Ecke','Ecke','noun','اسم','A1','گوشه / نبش','در راهنمایی مسیر «دور گوشه» ظاهر می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-bahnhof',@de,'word','Bahnhof','Bahnhof','Bahnhof','noun','اسم','A1','ایستگاه قطار','از مقصدهای پرتکرار بخش مسیرهاست.',TRUE,'blocked_until_level_final'),
('lex-de-bushaltestelle',@de,'word','Bushaltestelle','Bushaltestelle','Bushaltestelle','noun','اسم','A1','ایستگاه اتوبوس','از مقصدهای پرتکرار بخش مسیرهاست.',TRUE,'blocked_until_level_final'),
('lex-de-flughafen',@de,'word','Flughafen','Flughafen','Flughafen','noun','اسم','A1','فرودگاه','از مقصدهای پرتکرار بخش مسیرهاست.',TRUE,'blocked_until_level_final'),
('lex-de-stadtmitte',@de,'word','Stadtmitte','Stadtmitte','Stadtmitte','noun','اسم','A1','مرکز شهر','در بخش مسیرها برای مقصد مرکز شهر آمده است.',TRUE,'blocked_until_level_final'),
('lex-de-abbiegen',@de,'word','abbiegen','abbiegen','abbiegen','verb','فعل','A1','پیچیدن','در عبارت‌های راهنمایی چپ و راست استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-geradeaus',@de,'word','geradeaus','geradeaus','geradeaus','adverb','قید','A1','مستقیم / مستقیم به جلو','برای راهنمایی حرکت مستقیم استفاده می‌شود.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);

SET @x_rathaus=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-rathaus'); SET @x_ecke=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-ecke'); SET @x_bahnhof=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-bahnhof'); SET @x_bushalt=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-bushaltestelle'); SET @x_air=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-flughafen'); SET @x_center=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-stadtmitte'); SET @x_abbiegen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-abbiegen'); SET @x_geradeaus=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-geradeaus'); SET @x_links=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-links'); SET @x_rechts=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-rechts');

INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-a1-lesson-ask-and-follow-directions',@level,@unit,13,1,'چطور به شهرداری برسم؟','Wie komme ich zum Rathaus? / Rechts ... geradeaus','چطور به شهرداری برسم؟ / راست و بعد مستقیم','draft','گفت‌وگوی واقعی پرسیدن مسیر شهرداری را وارد می‌کند؛ سپس چهار مکان عمومی تثبیت می‌شوند، سه جهت پایه از هم تشخیص داده می‌شوند و در پایان پرسش اصلی مسیر بازسازی می‌شود.','درس از فهم یک تعامل کامل به شبکهٔ مکان‌ها، تمایز جهت‌ها و بازیابی فعال پرسش مسیر حرکت می‌کند.','conversation_speaking>matching>multiple_choice>word_order','blocked_until_level_final','یک درس برای پوشش واقعی پرسیدن مسیر، مکان‌های عمومی و جهت‌های پایه کافی است.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-ask-and-follow-directions');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES(@lesson,@t_dir,'introduce'),(@lesson,@t_sit,'introduce'),(@lesson,@t_core,'introduce'),(@lesson,@t_q,'practice'),(@lesson,@t_prep,'practice'),(@lesson,@t_reg,'practice');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES(@lesson,@x_rathaus,TRUE,'introduce'),(@lesson,@x_ecke,TRUE,'introduce'),(@lesson,@x_bahnhof,TRUE,'introduce'),(@lesson,@x_bushalt,TRUE,'introduce'),(@lesson,@x_air,TRUE,'introduce'),(@lesson,@x_center,TRUE,'introduce'),(@lesson,@x_abbiegen,TRUE,'introduce'),(@lesson,@x_geradeaus,TRUE,'introduce'),(@lesson,@x_links,FALSE,'review'),(@lesson,@x_rechts,FALSE,'review');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-a1-ask-and-follow-directions',@level,'پاول در سنت پولتن از آیریس مسیر شهرداری را می‌پرسد. آیریس ابتدا درخواست تکرار می‌کند و سپس مسیر ساده را می‌گوید.','learner','چهار نوبت پیوسته از گفت‌وگوی منبع بدون بازنویسی حفظ شده‌اند: پرسش نخست، درخواست تکرار، پرسش مستقیم‌تر و راهنمایی مسیر. نقش‌های مسافر و فرد محلی فقط به شخصیت‌های برنامه نسبت داده شده‌اند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dialogue := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-ask-and-follow-directions');
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-directions-1',@dialogue,1,@paul,'app_assigned','unspecified','Danke sehr. Und können Sie mir sagen, wo das Rathaus von St. Pölten ist?','خیلی ممنون. می‌توانید به من بگویید شهرداری سنت پولتن کجاست؟',TRUE,'blocked_until_level_final'),
('turn-de-a1-directions-2',@dialogue,2,@iris,'app_assigned','unspecified','Wie bitte?','ببخشید؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-directions-3',@dialogue,3,@paul,'app_assigned','unspecified','Wie komme ich zum Rathaus?','چطور به شهرداری برسم؟',TRUE,'blocked_until_level_final'),
('turn-de-a1-directions-4',@dialogue,4,@iris,'app_assigned','unspecified','Rechts um die Ecke und dann immer geradeaus – ungefähr ein Kilometer.','از گوشه به راست و بعد همیشه مستقیم؛ حدود یک کیلومتر.',FALSE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-directions-conversation',@lesson,1,'conversation_speaking','مسیر شهرداری را بپرس و پاسخ راهنمایی را دنبال کن.','چهار نوبت پیوستهٔ منبع یک موقعیت واقعی پرسیدن مسیر، درخواست تکرار و پاسخ جهت را می‌سازند.',@dialogue,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),JSON_ARRAY('verbatim_dialogue','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-public-places-matching',@lesson,2,'matching','هر مکان عمومی را به معنی درستش وصل کن.','چهار مقصد پرتکرار از بخش مسیرهای ویکی‌ویاژ انتخاب شده‌اند تا واژگان مکان از راهنمایی جهت جداگانه تثبیت شود.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Bahnhof','leftFa','ایستگاه قطار','right','ایستگاه قطار','rightFa','ایستگاه قطار'),JSON_OBJECT('left','Bushaltestelle','leftFa','ایستگاه اتوبوس','right','ایستگاه اتوبوس','rightFa','ایستگاه اتوبوس'),JSON_OBJECT('left','Flughafen','leftFa','فرودگاه','right','فرودگاه','rightFa','فرودگاه'),JSON_OBJECT('left','Stadtmitte','leftFa','مرکز شهر','right','مرکز شهر','rightFa','مرکز شهر'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-a1-direction-choice',@lesson,3,'multiple_choice','کدام عبارت یعنی مستقیم به جلو؟','سه عبارت جهت عین بخش مسیرهای منبع‌اند و تفاوت مستقیم، چپ و راست را می‌سنجند.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','geradeaus','translationFa','مستقیم به جلو','correct',TRUE),JSON_OBJECT('textTarget','Links abbiegen.','translationFa','به چپ بپیچید.','correct',FALSE),JSON_OBJECT('textTarget','Rechts abbiegen.','translationFa','به راست بپیچید.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-directions-question-order',@lesson,4,'word_order','پرسش مسیر شهرداری را دوباره بساز.','پرسش اصلی پس از فهم مسیر و واژگان مکان به بازیابی فعال منتقل می‌شود.',NULL,JSON_OBJECT('sourceText','Wie komme ich zum Rathaus?','sourceTextFa','چطور به شهرداری برسم؟','tokens',JSON_ARRAY('Wie','komme','ich','zum','Rathaus?'),'answer',JSON_ARRAY('Wie','komme','ich','zum','Rathaus?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a1=(SELECT id FROM activities WHERE activity_key='act-de-a1-directions-conversation'); SET @a2=(SELECT id FROM activities WHERE activity_key='act-de-a1-public-places-matching'); SET @a3=(SELECT id FROM activities WHERE activity_key='act-de-a1-direction-choice'); SET @a4=(SELECT id FROM activities WHERE activity_key='act-de-a1-directions-question-order');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES(@a1,@t_dir),(@a1,@t_sit),(@a1,@t_q),(@a2,@t_dir),(@a2,@t_sit),(@a2,@t_core),(@a3,@t_dir),(@a3,@t_core),(@a4,@t_dir),(@a4,@t_q);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a1,@x_rathaus),(@a1,@x_ecke),(@a1,@x_geradeaus),(@a1,@x_rechts),(@a2,@x_bahnhof),(@a2,@x_bushalt),(@a2,@x_air),(@a2,@x_center),(@a3,@x_geradeaus),(@a3,@x_abbiegen),(@a3,@x_links),(@a3,@x_rechts),(@a4,@x_rathaus);

INSERT INTO lexeme_occurrences(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-a1-dir-1-rathaus','dialogue_turn','turn-de-a1-directions-1','Rathaus',NULL,NULL,@x_rathaus,NULL,'approved','اتصال شهرداری تأیید شده است.'),
('occ-turn-de-a1-dir-3-rathaus','dialogue_turn','turn-de-a1-directions-3','Rathaus',NULL,NULL,@x_rathaus,NULL,'approved','اتصال شهرداری تأیید شده است.'),
('occ-turn-de-a1-dir-4-rechts','dialogue_turn','turn-de-a1-directions-4','Rechts',NULL,NULL,@x_rechts,NULL,'approved','اتصال راست تأیید شده است.'),
('occ-turn-de-a1-dir-4-ecke','dialogue_turn','turn-de-a1-directions-4','Ecke',NULL,NULL,@x_ecke,NULL,'approved','اتصال گوشه تأیید شده است.'),
('occ-turn-de-a1-dir-4-geradeaus','dialogue_turn','turn-de-a1-directions-4','geradeaus',NULL,NULL,@x_geradeaus,NULL,'approved','اتصال مستقیم تأیید شده است.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

SET @d1=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-d1'); SET @d2=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-d2'); SET @d3=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-d3'); SET @d4=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-d4'); SET @bh=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-bahnhof'); SET @bs=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-bushalt'); SET @air=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-airport'); SET @ctr=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-center'); SET @left=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-left'); SET @right=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-right'); SET @straight=(SELECT id FROM source_items WHERE item_key='srcitem-de-a1-dir-straight');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-directions-1',@d1,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-directions-2',@d2,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-directions-3',@d3,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-directions-4',@d4,'verbatim','متن هدف عین منبع است.'),
('lexeme','lex-de-rathaus',@d1,'other','واژه از جملهٔ منبع استخراج شده است.'),
('lexeme','lex-de-ecke',@d4,'other','واژه از جملهٔ منبع استخراج شده است.'),
('lexeme','lex-de-geradeaus',@d4,'other','قید از جملهٔ منبع استخراج شده است.'),
('lexeme','lex-de-bahnhof',@bh,'verbatim','واژه عین منبع ثبت شده است.'),
('lexeme','lex-de-bushaltestelle',@bs,'other','واژه از مقصد منبع استخراج شده است.'),
('lexeme','lex-de-flughafen',@air,'other','واژه از مقصد منبع استخراج شده است.'),
('lexeme','lex-de-stadtmitte',@ctr,'other','واژه از مقصد منبع استخراج شده است.'),
('lexeme','lex-de-abbiegen',@left,'other','فعل از عبارت جهت منبع استخراج شده است.'),
('activity','act-de-a1-public-places-matching',@bh,'source_items_grouped_for_matching','مکان عمومی از منبع است.'),
('activity','act-de-a1-public-places-matching',@bs,'source_items_grouped_for_matching','مکان عمومی از منبع است.'),
('activity','act-de-a1-public-places-matching',@air,'source_items_grouped_for_matching','مکان عمومی از منبع است.'),
('activity','act-de-a1-public-places-matching',@ctr,'source_items_grouped_for_matching','مکان عمومی از منبع است.'),
('activity','act-de-a1-direction-choice',@straight,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-direction-choice',@left,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-direction-choice',@right,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-directions-question-order',@d3,'sentence_tokenized_for_word_order','پرسش عین منبع برای مرتب‌سازی بخش‌بندی شده است.');

UPDATE language_levels SET coverage=JSON_SET(coverage,'$.gaps[2]','هشت واحد نخست به بازبینی رسیده‌اند؛ مرحلهٔ بعد درخواست، اجازه و خدمات روزمره است.'),notes='A1 همچنان در مرحلهٔ ساخت تدریجی است. هشت واحد نخست در بازبینی‌اند. مرحلهٔ بعد درخواست، اجازه و خدمات روزمره است؛ مسیر و مکان‌های عمومی با یک گفت‌وگوی واقعی و تمرین مکان‌ها و جهت‌های پایه پوشش داده شده است.' WHERE id=@level;
COMMIT;
