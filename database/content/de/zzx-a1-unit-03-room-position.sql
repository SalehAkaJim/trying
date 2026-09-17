-- German A1 Unit 3 — room position and simple property lesson. Base content preserves generated audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-home-and-nearby' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes)
VALUES('src-wikibooks-de-lesson-009-room-position','Deutschkurs für Anfänger/Lektion 009','موقعیت و ویژگی سادهٔ اتاق و وسایل','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_009','Item 419 and 419a: right/left, front/back and simple properties of room, house and objects.','بخش‌های ۴۱۹ و ۴۱۹ الف؛ راست و چپ، جلو و عقب و ویژگی سادهٔ خانه و وسایل.','2021-04-02','contemporary_verified','صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ بررسی شد. آخرین ویرایش صفحه ۲ آوریل ۲۰۲۱ است؛ جمله‌های انتخاب‌شده فقط الگوهای پایه و پایدار آلمانی معیار برای راست و چپ، جلو و عقب و ویژگی‌های ساده‌اند و در بازبینی فعلی همچنان طبیعی و قابل‌استفاده‌اند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 009','reuse_with_attribution','2026-09-17','استفاده فقط به بخش‌های ۴۱۹ و ۴۱۹ الف محدود است. هدف، موقعیت سادهٔ پنجره و صندلی و یک ویژگی سادهٔ خانه است؛ هیچ نمونهٔ قدیمی یا نامرتبط دیگر از صفحه وارد درس نمی‌شود.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-room-position' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@src,'srcitem-de-a1-window-right-q','419','بخش ۴۱۹','Ist das Fenster rechts?',UNHEX(SHA2('Ist das Fenster rechts?',256)),'پرسش موقعیت پنجره.'),
(@src,'srcitem-de-a1-window-left-a','419','پاسخ ۴۱۹','Nein, es ist links.',UNHEX(SHA2('Nein, es ist links.',256)),'پاسخ موقعیت پنجره.'),
(@src,'srcitem-de-a1-chair-back-q','419','بخش ۴۱۹','Steht der Stuhl hinten?',UNHEX(SHA2('Steht der Stuhl hinten?',256)),'پرسش موقعیت صندلی.'),
(@src,'srcitem-de-a1-chair-front-a','419','پاسخ ۴۱۹','Nein, er steht vorn.',UNHEX(SHA2('Nein, er steht vorn.',256)),'پاسخ موقعیت صندلی.'),
(@src,'srcitem-de-a1-house-small','419a','بخش ۴۱۹ الف','Ist das Haus klein? - Ja, es ist klein.',UNHEX(SHA2('Ist das Haus klein? - Ja, es ist klein.',256)),'ویژگی سادهٔ خانه.'),
(@src,'srcitem-de-a1-lamp-new','419','پاسخ ۴۱۹','Ist die Lampe alt? - Nein, sie ist neu.',UNHEX(SHA2('Ist die Lampe alt? - Nein, sie ist neu.',256)),'ویژگی سادهٔ چراغ.'),
(@src,'srcitem-de-a1-word-fenster','419','بخش ۴۱۹','Fenster',UNHEX(SHA2('Fenster',256)),'واژهٔ پنجره.'),
(@src,'srcitem-de-a1-word-haus','419a','بخش ۴۱۹ الف','Haus',UNHEX(SHA2('Haus',256)),'واژهٔ خانه.'),
(@src,'srcitem-de-a1-word-rechts','419','بخش ۴۱۹','rechts',UNHEX(SHA2('rechts',256)),'واژهٔ موقعیت.'),
(@src,'srcitem-de-a1-word-links','419','پاسخ ۴۱۹','links',UNHEX(SHA2('links',256)),'واژهٔ موقعیت.'),
(@src,'srcitem-de-a1-word-hinten','419','بخش ۴۱۹','hinten',UNHEX(SHA2('hinten',256)),'واژهٔ موقعیت.'),
(@src,'srcitem-de-a1-word-vorn','419','پاسخ ۴۱۹','vorn',UNHEX(SHA2('vorn',256)),'واژهٔ موقعیت.'),
(@src,'srcitem-de-a1-word-klein','419a','بخش ۴۱۹ الف','klein',UNHEX(SHA2('klein',256)),'واژهٔ ویژگی.')
ON DUPLICATE KEY UPDATE source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-fenster',@de,'word','Fenster','Fenster','Fenster','noun','اسم','A1','پنجره','از اجزای پایهٔ اتاق و خانه است.',TRUE,'blocked_until_level_final'),
('lex-de-haus',@de,'word','Haus','Haus','Haus','noun','اسم','A1','خانه','برای اشاره به خانه در توصیف سادهٔ محل زندگی استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-rechts',@de,'word','rechts','rechts','rechts','adverb','قید','A1','سمت راست / در سمت راست','برای بیان موقعیت ساده در محیط نزدیک استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-links',@de,'word','links','links','links','adverb','قید','A1','سمت چپ / در سمت چپ','برای بیان موقعیت ساده در محیط نزدیک استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-hinten',@de,'word','hinten','hinten','hinten','adverb','قید','A1','عقب / در قسمت عقب','برای بیان موقعیت ساده در محیط نزدیک استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-vorn',@de,'word','vorn','vorn','vorn','adverb','قید','A1','جلو / در قسمت جلو','برای بیان موقعیت ساده در محیط نزدیک استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-klein',@de,'word','klein','klein','klein','adjective','صفت','A1','کوچک','برای توصیف سادهٔ اندازهٔ خانه یا شیء استفاده می‌شود.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);
SET @x_fenster := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-fenster');
SET @x_haus := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-haus');
SET @x_rechts := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-rechts');
SET @x_links := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-links');
SET @x_hinten := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hinten');
SET @x_vorn := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-vorn');
SET @x_klein := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-klein');
SET @x_stuhl := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-stuhl');
SET @x_lampe := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-lampe');
SET @t_home := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-home' LIMIT 1);
SET @t_home_sit := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-home' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-room-position',@level,@unit,6,2,'پنجره کدام طرف است؟','Ist das Fenster rechts? / Steht der Stuhl hinten?','آیا پنجره سمت راست است؟ / آیا صندلی عقب قرار دارد؟','draft','گفت‌وگوی آغازین دو محور مکانی راست و چپ و جلو و عقب را وارد می‌کند؛ سپس ویژگی کوچک بودن خانه تشخیص داده می‌شود، پرسش موقعیت صندلی بازسازی می‌شود و در پایان چهار قید مکانی به معنی درست وصل می‌شوند.','درس از فهم موقعیت در بافت به تشخیص ویژگی، بازیابی فعال پرسش و تثبیت شبکهٔ واژگان مکانی می‌رود و الگوی آن با درس قبلی متفاوت است.','conversation_speaking>multiple_choice>word_order>matching','blocked_until_level_final','درس دوم واحد خانه؛ موقعیت و یک ویژگی ساده را با بخش‌های محدود و بازبینی‌شدهٔ منبع پوشش می‌دهد.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-room-position');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES(@lesson,@t_home,'practice'),(@lesson,@t_home_sit,'practice'),(@lesson,@t_core,'introduce'),(@lesson,@t_questions,'practice');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES(@lesson,@x_fenster,TRUE,'introduce'),(@lesson,@x_haus,TRUE,'introduce'),(@lesson,@x_rechts,TRUE,'introduce'),(@lesson,@x_links,TRUE,'introduce'),(@lesson,@x_hinten,TRUE,'introduce'),(@lesson,@x_vorn,TRUE,'introduce'),(@lesson,@x_klein,TRUE,'introduce'),(@lesson,@x_stuhl,FALSE,'practice'),(@lesson,@x_lampe,FALSE,'review');
INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES('dlg-de-a1-room-position',@level,'آیریس در یک اتاق دربارهٔ جای پنجره و صندلی از پاول سؤال می‌کند و او موقعیت درست را پاسخ می‌دهد.','app','دو جفت پرسش و پاسخ بخش ۴۱۹ دربارهٔ موقعیت اشیای یک محیط بدون بازنویسی در یک صحنه قرار گرفته‌اند. سؤال صندلی از صورت پرسشی خود تمرین و پاسخ آن از بخش پاسخ همان تمرین گرفته شده است.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dialogue := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-room-position');
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-room-position-1',@dialogue,1,@iris,'app_assigned','unspecified','Ist das Fenster rechts?','آیا پنجره سمت راست است؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-room-position-2',@dialogue,2,@paul,'app_assigned','unspecified','Nein, es ist links.','نه، سمت چپ است.',TRUE,'blocked_until_level_final'),
('turn-de-a1-room-position-3',@dialogue,3,@iris,'app_assigned','unspecified','Steht der Stuhl hinten?','آیا صندلی عقب قرار دارد؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-room-position-4',@dialogue,4,@paul,'app_assigned','unspecified','Nein, er steht vorn.','نه، جلو قرار دارد.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-room-position-conversation',@lesson,1,'conversation_speaking','آیریس دربارهٔ جای پنجره و صندلی می‌پرسد؛ موقعیت درست را جواب بده.','دو جفت پرسش و پاسخ منبع‌دار، دو تضاد مکانی پایه را در یک صحنهٔ اتاق تمرین می‌کنند.',@dialogue,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('other','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-home-small-choice',@lesson,2,'multiple_choice','کدام جملهٔ منبع می‌گوید خانه کوچک است؟','ویژگی سادهٔ خانه از میان سه جملهٔ منبع‌دار با موضوع‌های متفاوت تشخیص داده می‌شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Ist das Haus klein? - Ja, es ist klein.','translationFa','آیا خانه کوچک است؟ بله، کوچک است.','correct',TRUE),JSON_OBJECT('textTarget','Ist die Lampe alt? - Nein, sie ist neu.','translationFa','آیا چراغ قدیمی است؟ نه، نو است.','correct',FALSE),JSON_OBJECT('textTarget','Ist das Fenster rechts? - Nein, es ist links.','translationFa','آیا پنجره سمت راست است؟ نه، سمت چپ است.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-chair-position-order',@lesson,3,'word_order','پرسش دربارهٔ جای صندلی را دوباره بساز.','پرسش مکانی گفت‌وگو پس از فهم آن به بازیابی فعال منتقل می‌شود.',NULL,JSON_OBJECT('sourceText','Steht der Stuhl hinten?','sourceTextFa','آیا صندلی عقب قرار دارد؟','tokens',JSON_ARRAY('Steht','der','Stuhl','hinten?'),'answer',JSON_ARRAY('Steht','der','Stuhl','hinten?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'),
('act-de-a1-position-words-matching',@lesson,4,'matching','هر موقعیت را به معنی درستش وصل کن.','چهار قید مکانی موجود در همان بخش منبع به‌صورت شبکهٔ دو تضاد تثبیت می‌شوند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','rechts','leftFa','سمت راست','right','سمت راست','rightFa','سمت راست'),JSON_OBJECT('left','links','leftFa','سمت چپ','right','سمت چپ','rightFa','سمت چپ'),JSON_OBJECT('left','hinten','leftFa','عقب','right','عقب','rightFa','عقب'),JSON_OBJECT('left','vorn','leftFa','جلو','right','جلو','rightFa','جلو'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-a1-room-position-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-a1-home-small-choice');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-a1-chair-position-order');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-a1-position-words-matching');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES(@a1,@t_home),(@a1,@t_home_sit),(@a2,@t_home),(@a2,@t_core),(@a3,@t_questions),(@a3,@t_home),(@a4,@t_home),(@a4,@t_core);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a1,@x_fenster),(@a1,@x_stuhl),(@a1,@x_rechts),(@a1,@x_links),(@a1,@x_hinten),(@a1,@x_vorn),(@a2,@x_haus),(@a2,@x_klein),(@a2,@x_lampe),(@a2,@x_fenster),(@a2,@x_links),(@a3,@x_stuhl),(@a3,@x_hinten),(@a4,@x_rechts),(@a4,@x_links),(@a4,@x_hinten),(@a4,@x_vorn);
SET @si_wq := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-window-right-q');
SET @si_wa := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-window-left-a');
SET @si_cq := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-chair-back-q');
SET @si_ca := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-chair-front-a');
SET @si_house := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-house-small');
SET @si_lamp := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-lamp-new');
SET @si_fenster := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-fenster');
SET @si_haus := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-haus');
SET @si_rechts := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-rechts');
SET @si_links := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-links');
SET @si_hinten := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-hinten');
SET @si_vorn := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-vorn');
SET @si_klein := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-klein');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-room-position-1',@si_wq,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-room-position-2',@si_wa,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-room-position-3',@si_cq,'verbatim','پرسش عین صورت تمرین منبع است.'),
('dialogue_turn','turn-de-a1-room-position-4',@si_ca,'verbatim','پاسخ عین بخش پاسخ منبع است.'),
('lexeme','lex-de-fenster',@si_fenster,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-haus',@si_haus,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-rechts',@si_rechts,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-links',@si_links,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-hinten',@si_hinten,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-vorn',@si_vorn,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-klein',@si_klein,'verbatim','صورت واژه در منبع ثبت شده است.'),
('activity','act-de-a1-home-small-choice',@si_house,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-home-small-choice',@si_lamp,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-home-small-choice',@si_wq,'options_selected_from_source_material','بخش پرسش گزینهٔ مقایسه‌ای از منبع است.'),
('activity','act-de-a1-chair-position-order',@si_cq,'sentence_tokenized_for_word_order','پرسش عین منبع برای مرتب‌سازی بخش‌بندی شده است.');
UPDATE language_levels SET coverage=JSON_SET(coverage,'$.gaps[2]','توالی آموزشی اولیه ثبت شده است؛ دو واحد نخست به بازبینی رسیده‌اند و واحد سوم خانه و محیط نزدیک دو درس منبع‌دار دارد و باید از نظر کفایت پوشش ارزیابی شود.'),notes='A1 همچنان در مرحلهٔ ساخت تدریجی است. دو واحد نخست در بازبینی‌اند. واحد سوم خانه و محیط نزدیک اکنون دو درس منبع‌دار دارد و وسایل پایه، مالکیت ساده، راست و چپ و جلو و عقب و یک ویژگی سادهٔ خانه را پوشش می‌دهد؛ قدم بعد ارزیابی شکاف ضروری این واحد است.' WHERE id=@level;
COMMIT;
