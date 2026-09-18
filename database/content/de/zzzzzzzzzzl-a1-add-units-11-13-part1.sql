-- German A1 units 11–13, part 1: sources, units, health lessons and first transport lessons.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wikibooks-de-lesson-018-health','Deutschkurs für Anfänger/Lektion 018','سلامت، پزشک، دارو و داروخانه','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_018','Items 747, 748, 751 and 753: doctor consultation, symptoms, prescription/medicine/pharmacy, and no-longer symptoms.','بخش‌های ۷۴۷، ۷۴۸، ۷۵۱ و ۷۵۳؛ علائم بیماری، نسخه و دارو، داروخانه و بیان بهترشدن.',NULL,'contemporary_verified','صفحهٔ زندهٔ ویکی‌بوکس در ۱۸ سپتامبر ۲۰۲۶ بررسی شد. برای A1 فقط پرسش‌ها و پاسخ‌های کوتاه و پایدار دربارهٔ علائم بیماری، دارو، نسخه، داروخانه و بهترشدن انتخاب شده‌اند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 018','reuse_with_attribution','2026-09-18','بخش گفت‌وگوی کامل پزشک از نظر دستوری از A1 گسترده‌تر است؛ در این واحد فقط جمله‌ها و جفت‌های پرسش‌وپاسخ کوتاه بخش‌های ۷۴۸، ۷۵۱ و ۷۵۳ و چند جملهٔ مستقیم از ۷۴۷ استفاده می‌شوند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wikivoyage-german-phrasebook-transport','German phrasebook — Bus and Train','بلیت و حمل‌ونقل عمومی','Wikivoyage contributors','de','website','https://en.wikivoyage.org/wiki/German_phrasebook','Transportation — Bus and Train: ticket requests, destination, stops, departure/arrival, platform, station and stop vocabulary.','بخش حمل‌ونقل، اتوبوس و قطار؛ بلیت، مقصد، توقف، زمان حرکت و رسیدن، سکو و ایستگاه.',NULL,'maintained_current','بخش زندهٔ حمل‌ونقل در عبارت‌نامهٔ آلمانی ویکی‌ویاژ در ۱۸ سپتامبر ۲۰۲۶ بررسی شد. عبارت‌های بلیت، قطار و اتوبوس، زمان حرکت و رسیدن و شمارهٔ سکو در نسخهٔ فعلی صفحه حضور دارند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikivoyage contributors — German phrasebook','reuse_with_attribution','2026-09-18','در مثال‌های دارای جای خالی مقصد، نام «برلین» به‌عنوان مقدار نمونهٔ آموزشی جایگزین می‌شود و این تبدیل در فعالیت یا گفت‌وگو به‌صورت شفاف ثبت می‌شود.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wikibooks-german-print-weather','German/Print version — Weather','هوا، پیش‌بینی و دما','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Print_version','Weather lesson — Common Phrases: current weather, forecast, rain/umbrella and thermometer temperature.','بخش هوا و عبارت‌های رایج؛ هوای فعلی، پیش‌بینی، باران و چتر و دمای دماسنج.','2024-06-05','contemporary_verified','صفحهٔ زندهٔ نسخهٔ چاپی دورهٔ آلمانی ویکی‌بوکس در ۱۸ سپتامبر ۲۰۲۶ بررسی شد. عبارت‌های انتخاب‌شده دربارهٔ هوای فعلی، پیش‌بینی، باران و دما در نسخهٔ فعلی حضور دارند و برای ارتباط روزمره مناسب‌اند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Print version','reuse_with_attribution','2026-09-18','فقط بخش عبارت‌های رایج هوا استفاده می‌شود؛ واژگان تخصصی یا منطقه‌ای هواشناسی وارد مسیر A1 نمی‌شوند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-a1-unit-health-doctor-pharmacy',@level,11,'سلامت، پزشک و داروخانه','واحد از بیان مستقیم علامت شروع می‌کند، سپس مسیر نسخه و داروخانه را پوشش می‌دهد و در پایان به پیگیری حال بیمار و بیان بهترشدن می‌رسد. سه درس سه مرحلهٔ واقعی و مستقل از یک مراجعهٔ سادهٔ پزشکی هستند.','final',CAST('{"sourceRefs":["src-wikibooks-de-lesson-018-health"],"learningTargets":["علائم بسیار رایج بیماری را در پرسش و پاسخ کوتاه بیان و تشخیص دهد.","نسخه، دارو و محل گرفتن دارو را در یک موقعیت سادهٔ پزشکی بفهمد.","با الگوی سادهٔ «دیگر ندارم» بهترشدن یک علامت را بیان کند."]}' AS JSON),'دامنه عمداً به علائم رایج، داروخانه و پیگیری کوتاه محدود شده است و ساختارهای پیچیده‌تر گفت‌وگوی پزشک وارد A1 نمی‌شوند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status='final',metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-health-doctor-pharmacy' AND language_level_id=@level LIMIT 1);
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-everyday-expressions' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-listening-dialogue' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-spoken-questions-requests' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-negation' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-present-verbs' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-services-help' LIMIT 1;

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-a1-unit-public-transport-tickets',@level,12,'بلیت و حمل‌ونقل عمومی','واحد سه گام مستقل سفر با حمل‌ونقل عمومی را پوشش می‌دهد: گرفتن بلیت، انتخاب وسیلهٔ درست و فهم اطلاعات حرکت. این مسیر از خرید خدمت به تصمیم سفر و سپس زمان و سکو می‌رسد.','final',CAST('{"sourceRefs":["src-wikivoyage-german-phrasebook-transport","src-wikivoyage-german-phrasebook-directions","src-wikibooks-de-lesson-024-short-messages"],"learningTargets":["برای یک مقصد ساده بلیت بخواهد و دربارهٔ قیمت بلیت سؤال کند.","قطار یا اتوبوس درست را با پرسش دربارهٔ مقصد و توقف تشخیص دهد.","زمان حرکت یا رسیدن و سکوی حرکت را در پرسش‌های کوتاه بفهمد."]}' AS JSON),'نام برلین فقط به‌عنوان مقدار نمونه در الگوهای جای‌خالی منبع استفاده می‌شود؛ واژگان و ساختارهای اصلی از عبارت‌نامهٔ منبع می‌آیند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status='final',metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-public-transport-tickets' AND language_level_id=@level LIMIT 1);
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-directions' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-time-plans' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-shopping' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-listening-dialogue' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-numbers-dates-time' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-time-place-prepositions' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-directions-public-places' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-shopping' LIMIT 1;

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-a1-unit-weather-temperature',@level,13,'آب‌وهوا و دما','واحد از توصیف هوای فعلی به پیش‌بینی کوتاه و سپس عدد دما می‌رود. سه درس به‌ترتیب وضعیت اکنون، تصمیم روزانه بر اساس پیش‌بینی و خواندن دما را پوشش می‌دهند.','final',CAST('{"sourceRefs":["src-wikibooks-german-print-weather"],"learningTargets":["دربارهٔ هوای فعلی یک شهر سؤال کند و پاسخ ساده را بفهمد.","پیش‌بینی سادهٔ باران یا بدی هوا را بفهمد و توصیهٔ همراه‌داشتن چتر را تشخیص دهد.","دمای مثبت و منفی را در یک پرسش و پاسخ کوتاه بفهمد."]}' AS JSON),'واژگان تخصصی هواشناسی کنار گذاشته شده‌اند و فقط عبارت‌های روزمره و قابل‌استفادهٔ سطح A1 نگه داشته شده‌اند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status='final',metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-weather-temperature' AND language_level_id=@level LIMIT 1);
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-everyday-expressions' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-listening-dialogue' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-spoken-questions-requests' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-numbers-dates-time' LIMIT 1;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id)
SELECT @unit,id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-present-verbs' LIMIT 1;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-health-doctor-pharmacy' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-a1-lesson-health-symptoms',@level,@unit,31,1,'چه مشکلی دارید؟',NULL,NULL,'qa','درس نخست واحد سلامت زبان لازم برای بیان مستقیم یک مشکل جسمی را می‌سازد و دامنه را عمداً به علائم بسیار رایج محدود می‌کند.','از مکالمهٔ کوتاه به تشخیص علامت و سپس بازسازی پاسخ ساده حرکت می‌کند.','conversation_speaking>multiple_choice>word_order','pending','درس تازهٔ منبع‌دار برای گسترش کاربرد روزمرهٔ سطح A1.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),status='qa',activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),audio_status='pending',notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-health-symptoms' LIMIT 1);
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM lesson_targets WHERE lesson_id=@lesson;
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'practice' FROM unit_targets WHERE unit_id=@unit;

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-a1-health-symptoms',@level,'آیریس در نقش پزشک دو بار دربارهٔ مشکل می‌پرسد و پاول دو علامت رایج را کوتاه و مستقیم بیان می‌کند.','app','جفت‌های پرسش و پاسخ از تمرین ۷۵۱ عیناً حفظ شده‌اند و فقط به شخصیت‌های ثابت برنامه نسبت داده شده‌اند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-symptoms' LIMIT 1);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-symptoms-1',@dlg,1,(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),'app_assigned','unspecified','Was fehlt Ihnen?','چه مشکلی دارید؟',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-symptoms-2',@dlg,2,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Ich habe Husten.','سرفه دارم.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-symptoms-3',@dlg,3,(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),'app_assigned','unspecified','Was fehlt Ihnen?','چه مشکلی دارید؟',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-symptoms-4',@dlg,4,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Ich habe Fieber.','تب دارم.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-symptoms-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی کوتاه پزشک و بیمار را اجرا کن و دو علامت را درست بیان کن.','دو جفت پرسش و پاسخ منبع‌دار، الگوی پایهٔ بیان علامت را بدون پیچیدگی اضافی نشان می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-symptoms' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-symptoms-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-symptoms-choice',@lesson,2,'multiple_choice','کدام پاسخ یعنی «تب دارم»؟','سه پاسخ کوتاه باعث می‌شوند زبان‌آموز معنی علامت را مستقیم تشخیص دهد.',NULL,CAST('{"options":[{"textTarget":"Ich habe Fieber.","translationFa":"تب دارم.","correct":true},{"textTarget":"Ich habe Husten.","translationFa":"سرفه دارم.","correct":false},{"textTarget":"Ich habe kein Fieber mehr.","translationFa":"دیگر تب ندارم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-symptoms-choice' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-symptoms-order',@lesson,3,'word_order','پاسخ «سرفه دارم» را بساز.','بازسازی یک پاسخ بسیار کوتاه، الگوی بیان علامت را به بازیابی فعال منتقل می‌کند.',NULL,CAST('{"sourceText":"Ich habe Husten.","sourceTextFa":"سرفه دارم.","tokens":["Ich","habe","Husten."],"answer":["Ich","habe","Husten."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-symptoms-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-health-doctor-pharmacy' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-a1-lesson-health-medicine-pharmacy',@level,@unit,32,2,'دارو را از کجا می‌گیری؟',NULL,NULL,'qa','درس دوم مسیر بعد از تشخیص بیماری را پوشش می‌دهد: دارو چیست و از کجا گرفته می‌شود.','ابتدا مکالمهٔ دارو و داروخانه می‌آید، سپس واژگان دارو تثبیت می‌شوند و در پایان پرسش محل بازسازی می‌شود.','conversation_speaking>matching>word_order','pending','درس تازهٔ منبع‌دار برای گسترش کاربرد روزمرهٔ سطح A1.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),status='qa',activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),audio_status='pending',notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-health-medicine-pharmacy' LIMIT 1);
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM lesson_targets WHERE lesson_id=@lesson;
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'practice' FROM unit_targets WHERE unit_id=@unit;

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-a1-health-medicine-pharmacy',@level,'مکس از پاول دربارهٔ داروهای بیمار و محل گرفتن آن‌ها می‌پرسد و پاول پاسخ‌های کوتاه منبع را می‌دهد.','app','دو جفت پرسش و پاسخ بخش ۷۴۸ بدون بازنویسی متن آلمانی استفاده شده‌اند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-medicine-pharmacy' LIMIT 1);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-medicine-pharmacy-1',@dlg,1,(SELECT id FROM characters WHERE character_key='char-de-max' LIMIT 1),'app_assigned','unspecified','Welche Medikamente bekommt Herr Berger?','آقای برگر چه داروهایی می‌گیرد؟',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-medicine-pharmacy-2',@dlg,2,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Er bekommt Tabletten und Tropfen.','قرص و قطره می‌گیرد.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-medicine-pharmacy-3',@dlg,3,(SELECT id FROM characters WHERE character_key='char-de-max' LIMIT 1),'app_assigned','unspecified','Wo bekommt er sie?','آن‌ها را کجا می‌گیرد؟',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-medicine-pharmacy-4',@dlg,4,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Er bekommt die Medikamente in der Apotheke.','داروها را از داروخانه می‌گیرد.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-medicine-conversation',@lesson,1,'conversation_speaking','دربارهٔ دارو و محل گرفتن آن گفت‌وگو کن.','دو جفت پرسش و پاسخ منبع‌دار، دارو و داروخانه را در یک زنجیرهٔ کاربردی قرار می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-medicine-pharmacy' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-medicine-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-medicine-matching',@lesson,2,'matching','هر واژه را به معنی درستش وصل کن.','سه واژهٔ اصلی این موقعیت بدون افزودن بار دستوری تازه تثبیت می‌شوند.',NULL,CAST('{"pairs":[{"left":"Tabletten","leftFa":"قرص‌ها","right":"قرص","rightFa":"قرص"},{"left":"Tropfen","leftFa":"قطره‌ها","right":"قطره","rightFa":"قطره"},{"left":"Apotheke","leftFa":"داروخانه","right":"محل گرفتن دارو","rightFa":"محل گرفتن دارو"},{"left":"Medikamente","leftFa":"داروها","right":"دارو","rightFa":"دارو"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-medicine-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-medicine-order',@lesson,3,'word_order','پرسش «کجا آن‌ها را می‌گیرد؟» را بساز.','پرسش مکان، زبان‌آموز را از فهم پاسخ به تولید هدایت‌شده می‌رساند.',NULL,CAST('{"sourceText":"Wo bekommt er sie?","sourceTextFa":"آن‌ها را کجا می‌گیرد؟","tokens":["Wo","bekommt","er","sie?"],"answer":["Wo","bekommt","er","sie?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-medicine-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-health-doctor-pharmacy' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-a1-lesson-health-recovery',@level,@unit,33,3,'دیگه بهتر شدی؟',NULL,NULL,'qa','درس سوم یک مهارت مستقل و طبیعی اضافه می‌کند: پیگیری حال بیمار و گفتن اینکه یک علامت دیگر وجود ندارد.','مکالمه الگوی پیگیری را معرفی می‌کند، تشخیص معنای بهترشدن را می‌سنجد و در پایان پاسخ منفی بازسازی می‌شود.','conversation_speaking>choose_response>word_order','pending','درس تازهٔ منبع‌دار برای گسترش کاربرد روزمرهٔ سطح A1.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),status='qa',activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),audio_status='pending',notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-health-recovery' LIMIT 1);
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM lesson_targets WHERE lesson_id=@lesson;
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'practice' FROM unit_targets WHERE unit_id=@unit;

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-a1-health-recovery',@level,'آیریس در پیگیری حال پاول دربارهٔ باقی‌ماندن تب و سرفه می‌پرسد و پاول می‌گوید دیگر آن علائم را ندارد.','app','دو جفت پرسش و پاسخ بخش ۷۵۳ عین منبع نگه داشته شده‌اند و الگوی سادهٔ بهترشدن را نشان می‌دهند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-recovery' LIMIT 1);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-recovery-1',@dlg,1,(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),'app_assigned','unspecified','Haben Sie noch Fieber?','هنوز تب دارید؟',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-recovery-2',@dlg,2,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Nein, ich habe kein Fieber mehr.','نه، دیگر تب ندارم.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-recovery-3',@dlg,3,(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),'app_assigned','unspecified','Haben Sie noch Husten?','هنوز سرفه دارید؟',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-health-recovery-4',@dlg,4,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Nein, ich habe keinen Husten mehr.','نه، دیگر سرفه ندارم.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-recovery-conversation',@lesson,1,'conversation_speaking','در پیگیری حال بیمار بگو آیا تب یا سرفه هنوز ادامه دارد.','دو جفت پرسش و پاسخ منبع‌دار الگوی سادهٔ بهترشدن را نشان می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-recovery' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-recovery-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-recovery-response',@lesson,2,'choose_response','برای پرسش «هنوز تب دارید؟» پاسخ مناسبِ بهترشدن را انتخاب کن.','پاسخ درست باید روشن کند علامت دیگر وجود ندارد.',NULL,CAST('{"promptTarget":"Haben Sie noch Fieber?","promptFa":"هنوز تب دارید؟","options":[{"textTarget":"Nein, ich habe kein Fieber mehr.","translationFa":"نه، دیگر تب ندارم.","correct":true},{"textTarget":"Ich habe Fieber.","translationFa":"تب دارم.","correct":false},{"textTarget":"Ich habe Husten.","translationFa":"سرفه دارم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-recovery-response' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-health-recovery-order',@lesson,3,'word_order','پاسخ «دیگر سرفه ندارم» را بساز.','بازسازی پاسخ منفی، مهارت پیگیری حال را به بازیابی فعال می‌رساند.',NULL,CAST('{"sourceText":"Nein, ich habe keinen Husten mehr.","sourceTextFa":"نه، دیگر سرفه ندارم.","tokens":["Nein,","ich","habe","keinen","Husten","mehr."],"answer":["Nein,","ich","habe","keinen","Husten","mehr."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-health-recovery-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-public-transport-tickets' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-a1-lesson-transport-ticket',@level,@unit,34,1,'یک بلیت برای برلین لطفاً',NULL,NULL,'qa','درس نخست سفر با حمل‌ونقل عمومی از کار واقعیِ خرید خدمت شروع می‌کند: درخواست بلیت برای یک مقصد مشخص.','از مکالمهٔ باجه به واژگان اصلی و سپس بازسازی درخواست بلیت می‌رسد.','conversation_speaking>matching>word_order','pending','درس تازهٔ منبع‌دار برای گسترش کاربرد روزمرهٔ سطح A1.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),status='qa',activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),audio_status='pending',notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-transport-ticket' LIMIT 1);
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM lesson_targets WHERE lesson_id=@lesson;
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'practice' FROM unit_targets WHERE unit_id=@unit;

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-a1-transport-ticket',@level,'پاول در باجهٔ بلیت یک بلیت برای برلین می‌خواهد و تعامل کوتاه را با تشکر پایان می‌دهد.','app','سلام و تشکر از بخش پایهٔ همان عبارت‌نامه و الگوی درخواست بلیت از بخش حمل‌ونقل آمده‌اند؛ فقط جای خالی مقصد با برلین پر شده است.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-transport-ticket' LIMIT 1);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-transport-ticket-1',@dlg,1,(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),'app_assigned','unspecified','Guten Tag.','روز بخیر.',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-transport-ticket-2',@dlg,2,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Bitte eine Fahrkarte nach Berlin.','لطفاً یک بلیت به برلین.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-transport-ticket-3',@dlg,3,(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),'app_assigned','unspecified','Bitte schön!','بفرمایید.',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-transport-ticket-4',@dlg,4,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Danke.','ممنون.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-transport-ticket-conversation',@lesson,1,'conversation_speaking','در باجه بلیت بخواه و گفت‌وگوی کوتاه را کامل کن.','درخواست بلیت در یک تبادل کوتاه سلام، درخواست و تشکر قرار می‌گیرد.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-transport-ticket' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-transport-ticket-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-transport-ticket-matching',@lesson,2,'matching','هر واژه را به معنی درستش وصل کن.','سه واژهٔ پایهٔ سفر با قطار برای ادامهٔ واحد لازم‌اند.',NULL,CAST('{"pairs":[{"left":"Fahrkarte","leftFa":"بلیت","right":"بلیت سفر","rightFa":"بلیت سفر"},{"left":"Bahnhof","leftFa":"ایستگاه قطار","right":"محل قطار","rightFa":"محل قطار"},{"left":"Zug","leftFa":"قطار","right":"وسیلهٔ سفر","rightFa":"وسیلهٔ سفر"},{"left":"Bus","leftFa":"اتوبوس","right":"وسیلهٔ جاده‌ای","rightFa":"وسیلهٔ جاده‌ای"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-transport-ticket-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-transport-ticket-order',@lesson,3,'word_order','درخواست بلیت به برلین را بساز.','عبارت درخواست بلیت به بازیابی مستقیم منتقل می‌شود.',NULL,CAST('{"sourceText":"Bitte eine Fahrkarte nach Berlin.","sourceTextFa":"لطفاً یک بلیت به برلین.","tokens":["Bitte","eine","Fahrkarte","nach","Berlin."],"answer":["Bitte","eine","Fahrkarte","nach","Berlin."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-transport-ticket-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-public-transport-tickets' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-a1-lesson-transport-train-bus',@level,@unit,35,2,'این قطار در برلین توقف می‌کند؟',NULL,NULL,'qa','درس دوم بعد از گرفتن بلیت روی انتخاب وسیلهٔ درست و اطمینان از توقف در مقصد تمرکز می‌کند.','مکالمه پرسش توقف را معرفی می‌کند، واژگان وسیله و ایستگاه را تفکیک می‌کند و در پایان پرسش بازسازی می‌شود.','conversation_speaking>matching>word_order','pending','درس تازهٔ منبع‌دار برای گسترش کاربرد روزمرهٔ سطح A1.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),status='qa',activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),audio_status='pending',notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-transport-train-bus' LIMIT 1);
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM lesson_targets WHERE lesson_id=@lesson;
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'practice' FROM unit_targets WHERE unit_id=@unit;

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-a1-transport-stop',@level,'آیریس کنار قطار به پاول کمک می‌کند؛ پاول می‌پرسد آیا این قطار در برلین توقف دارد.','app','پرسش توقف از الگوی بخش قطار با جایگزینی مقصد برلین ساخته شده و سلام، بله و تشکر از همان عبارت‌نامه‌اند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-transport-stop' LIMIT 1);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-transport-stop-1',@dlg,1,(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),'app_assigned','unspecified','Guten Tag.','روز بخیر.',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-transport-stop-2',@dlg,2,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Hält dieser Zug in Berlin?','این قطار در برلین توقف می‌کند؟',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-transport-stop-3',@dlg,3,(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),'app_assigned','unspecified','Ja.','بله.',FALSE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-transport-stop-4',@dlg,4,(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),'app_assigned','unspecified','Danke.','ممنون.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-transport-stop-conversation',@lesson,1,'conversation_speaking','بپرس آیا این قطار در مقصد موردنظر توقف می‌کند.','پرسش توقف یک نیاز واقعی و مستقل از خرید بلیت است.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-transport-stop' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-transport-stop-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-transport-stop-matching',@lesson,2,'matching','هر واژه را به معنی درستش وصل کن.','واژگان قطار و اتوبوس در یک شبکهٔ سادهٔ حمل‌ونقل تثبیت می‌شوند.',NULL,CAST('{"pairs":[{"left":"Zug","leftFa":"قطار","right":"قطار","rightFa":"قطار"},{"left":"Bus","leftFa":"اتوبوس","right":"اتوبوس","rightFa":"اتوبوس"},{"left":"Bahnhof","leftFa":"ایستگاه قطار","right":"ایستگاه قطار","rightFa":"ایستگاه قطار"},{"left":"Bushaltestelle","leftFa":"ایستگاه اتوبوس","right":"ایستگاه اتوبوس","rightFa":"ایستگاه اتوبوس"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-transport-stop-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-transport-stop-order',@lesson,3,'word_order','پرسش توقف قطار در برلین را بساز.','بازسازی پرسش توقف، مهارت انتخاب مسیر را فعال می‌کند.',NULL,CAST('{"sourceText":"Hält dieser Zug in Berlin?","sourceTextFa":"این قطار در برلین توقف می‌کند؟","tokens":["Hält","dieser","Zug","in","Berlin?"],"answer":["Hält","dieser","Zug","in","Berlin?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required');
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-transport-stop-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

COMMIT;
