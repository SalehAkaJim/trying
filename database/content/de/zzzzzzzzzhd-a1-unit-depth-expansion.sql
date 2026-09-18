-- German A1: deepen every finalized unit to three pedagogically distinct lessons.
-- Review/retrieval lessons reuse existing source-backed dialogues and add no independent audio targets.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

-- Move every current A1 slot out of the target range before deterministic reordering.
UPDATE lessons
SET sequence_index=sequence_index+1000,
    position_in_unit=CASE WHEN position_in_unit IS NULL THEN NULL ELSE position_in_unit+100 END
WHERE language_level_id=@level;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-extended-introduction' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-integrated-introduction-review',@level,@unit,3,3,'یک معرفی کامل‌تر بساز',NULL,NULL,'draft','این درس دو محور قبلی واحد، یعنی شغل و زبان، را در یک مرور یکپارچه دوباره فعال می‌کند و از تشخیص به بازیابی می‌رساند.','ابتدا اطلاعات در مکالمه بازیابی می‌شوند، سپس تفاوت معنایی جمله‌ها سنجیده می‌شود و در پایان پرسش شغل بازسازی می‌شود.','conversation_speaking>multiple_choice>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-integrated-introduction-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-intro-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی شغل و زبان را دوباره اجرا کن و این بار اطلاعات معرفی را یک‌جا دنبال کن.','مکالمهٔ منبع‌دار شغل و زبان برای بازیابی فاصله‌دار دوباره استفاده می‌شود.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-work-and-languages' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-intro-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-intro-review-choice',@lesson,2,'multiple_choice','کدام جمله دربارهٔ شغل است؟','سه جملهٔ منبع‌دار شغل، یادگیری زبان و صحبت‌کردن را از هم جدا می‌کنند.',NULL,CAST('{"options":[{"textTarget":"Nein, ich arbeite als Journalist.","translationFa":"نه، من به‌عنوان روزنامه‌نگار کار می‌کنم.","correct":true},{"textTarget":"Ich lerne Deutsch und Französisch.","translationFa":"من آلمانی و فرانسوی یاد می‌گیرم.","correct":false},{"textTarget":"Ich spreche Englisch und Französisch.","translationFa":"من انگلیسی و فرانسوی صحبت می‌کنم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-intro-review-choice' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-intro-review-order',@lesson,3,'word_order','پرسش شغل را دوباره بساز.','بازسازی پرسش، مرور معرفی را با بازیابی فعال پایان می‌دهد.',NULL,CAST('{"sourceText":"Was ist er von Beruf?","sourceTextFa":"شغل او چیست؟","tokens":["Was","ist","er","von","Beruf?"],"answer":["Was","ist","er","von","Beruf?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-intro-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-family-and-close-people' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-family-profile-review',@level,@unit,6,3,'خانواده را یک‌جا مرور کن',NULL,NULL,'draft','درس سوم واحد، رابطه‌های خانوادگی و اطلاعات شخصی اعضا را از حالت تمرین‌های جدا به یک مرور منسجم تبدیل می‌کند.','گفت‌وگو اطلاعات را فعال می‌کند، تطبیق رابطه‌ها را تثبیت می‌کند و بازسازی پرسش تولید هدایت‌شده را تمرین می‌دهد.','conversation_speaking>matching>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-family-profile-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-family-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی پدر و مادر را دوباره انجام بده و اطلاعات هر نفر را دنبال کن.','صحنهٔ منبع‌دار والدین برای مرور چند نوع اطلاعات خانوادگی استفاده می‌شود.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-family-parents-profile' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-family-review-matching',@lesson,2,'matching','اعضای خانواده را به معنی درست وصل کن.','چهار رابطهٔ خانوادگی پایه پیش از تولید پرسش دوباره فعال می‌شوند.',NULL,CAST('{"pairs":[{"left":"Bruder","leftFa":"برادر","right":"برادر","rightFa":"برادر"},{"left":"Schwester","leftFa":"خواهر","right":"خواهر","rightFa":"خواهر"},{"left":"Mutter","leftFa":"مادر","right":"مادر","rightFa":"مادر"},{"left":"Vater","leftFa":"پدر","right":"پدر","rightFa":"پدر"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-review-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-family-review-order',@lesson,3,'word_order','پرسش نام برادر را دوباره بساز.','پرسش منبع‌دار نام، واژگان خانواده را به یک کاربرد واقعی برمی‌گرداند.',NULL,CAST('{"sourceText":"Wie heißt euer Bruder?","sourceTextFa":"اسم برادرتان چیست؟","tokens":["Wie","heißt","euer","Bruder?"],"answer":["Wie","heißt","euer","Bruder?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-home-and-nearby' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-home-description-review',@level,@unit,9,3,'اتاق و جای وسایل را توصیف کن',NULL,NULL,'draft','این درس نام وسایل و واژگان موقعیت را به یک توصیف کاربردی از فضای نزدیک وصل می‌کند.','از فهم موقعیت در گفت‌وگو به تشخیص جهت‌های داخل فضا و سپس ساخت پرسش مکانی می‌رسد.','conversation_speaking>matching>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-home-description-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-home-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی جای وسایل را دوباره اجرا کن و به موقعیت‌ها دقت کن.','مکالمهٔ منبع‌دار موقعیت، نام وسایل را به توصیف فضا وصل می‌کند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-room-position' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-home-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-home-review-matching',@lesson,2,'matching','هر موقعیت را به معنی درست وصل کن.','چهار قید مکانی منبع‌دار برای توصیف اتاق دوباره بازیابی می‌شوند.',NULL,CAST('{"pairs":[{"left":"rechts","leftFa":"سمت راست","right":"راست","rightFa":"راست"},{"left":"links","leftFa":"سمت چپ","right":"چپ","rightFa":"چپ"},{"left":"hinten","leftFa":"عقب","right":"عقب","rightFa":"عقب"},{"left":"vorn","leftFa":"جلو","right":"جلو","rightFa":"جلو"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-home-review-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-home-review-order',@lesson,3,'word_order','پرسش جای صندلی را دوباره بساز.','بازیابی پرسش موقعیت، مرور واژگان را به کاربرد فعال وصل می‌کند.',NULL,CAST('{"sourceText":"Steht der Stuhl hinten?","sourceTextFa":"آیا صندلی عقب قرار دارد؟","tokens":["Steht","der","Stuhl","hinten?"],"answer":["Steht","der","Stuhl","hinten?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-home-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-daily-routine-work-school' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-daily-routine-day-review',@level,@unit,12,3,'یک روز معمولی را دنبال کن',NULL,NULL,'draft','درس جمع‌بندی واحد، مسیر کار و مدرسه را در چارچوب چهار بخش روز دوباره به هم وصل می‌کند.','از مکالمه به نمای کامل روز و سپس پاسخ متناسب با یک بخش مشخص زمان حرکت می‌کند.','conversation_speaking>matching>choose_response','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-daily-routine-day-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-daily-review-conversation',@lesson,1,'conversation_speaking','روتین صبح و پیش از ظهر را دوباره اجرا کن و ترتیب روز را نگه دار.','گفت‌وگوی منبع‌دار چهارچوب زمانی روز را برای مرور فعال می‌کند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-daily-routine-work' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-daily-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-daily-review-matching',@lesson,2,'matching','هر جمله را به بخش درست روز وصل کن.','چهار پاسخ منبع‌دار نمای کامل صبح تا بعدازظهر را می‌سازند.',NULL,CAST('{"pairs":[{"left":"Morgens trinke ich Kaffee.","leftFa":"صبح‌ها قهوه می‌نوشم.","right":"صبح","rightFa":"صبح"},{"left":"Vormittags arbeite ich im Betrieb.","leftFa":"پیش از ظهرها در محل کار کار می‌کنم.","right":"پیش از ظهر","rightFa":"پیش از ظهر"},{"left":"Mittags esse ich in einem Restaurant.","leftFa":"ظهرها در یک رستوران غذا می‌خورم.","right":"ظهر","rightFa":"ظهر"},{"left":"Nachmittags gehe ich nach Hause.","leftFa":"بعدازظهرها به خانه می‌روم.","right":"بعدازظهر","rightFa":"بعدازظهر"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-daily-review-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-daily-review-response',@lesson,3,'choose_response','برای پرسش بعدازظهر پاسخ مناسب را انتخاب کن.','پاسخ‌های منبع‌دار نشان می‌دهند زبان‌آموز باید بخش درست روز را به پرسش وصل کند.',NULL,CAST('{"promptTarget":"Was machen Sie nachmittags?","promptFa":"بعدازظهرها چه کار می‌کنید؟","options":[{"textTarget":"Nachmittags gehe ich nach Hause.","translationFa":"بعدازظهرها به خانه می‌روم.","correct":true},{"textTarget":"Morgens trinke ich Kaffee.","translationFa":"صبح‌ها قهوه می‌نوشم.","correct":false},{"textTarget":"Mittags esse ich in einem Restaurant.","translationFa":"ظهرها در یک رستوران غذا می‌خورم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-daily-review-response' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-shopping-quantity-payment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-shopping-price-review',@level,@unit,13,1,'قیمت‌ها را سریع پیدا کن',NULL,NULL,'draft','این درس قیمت را به‌عنوان یک زیرمهارت مستقل در خرید تثبیت می‌کند تا تشخیص عدد و ساخت پرسش به‌اندازهٔ کافی تمرین شود.','از قیمت در گفت‌وگو به مقایسهٔ چند قیمت و سپس بازسازی پرسش می‌رسد.','conversation_speaking>matching>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-shopping-price-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-shopping-price-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی خرید را اجرا کن و این بار روی قیمت تمرکز کن.','تراکنش کامل، پرسش قیمت را در بافت واقعی نگه می‌دارد.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-shopping-quantity-payment' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-shopping-price-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-shopping-price-review-matching',@lesson,2,'matching','هر مقدار کالا را به قیمت درست وصل کن.','چهار نمونهٔ منبع‌دار باعث می‌شوند قیمت به یک کالا محدود نماند.',NULL,CAST('{"pairs":[{"left":"300 g Wurst","leftFa":"۳۰۰ گرم سوسیس","right":"5,99 Euro","rightFa":"۵٫۹۹ یورو"},{"left":"250 g Butter","leftFa":"۲۵۰ گرم کره","right":"3,95 Euro","rightFa":"۳٫۹۵ یورو"},{"left":"zwei Flaschen Milch","leftFa":"دو بطری شیر","right":"2,99 Euro","rightFa":"۲٫۹۹ یورو"},{"left":"fünf Eier","leftFa":"پنج تخم‌مرغ","right":"2,67 Euro","rightFa":"۲٫۶۷ یورو"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-shopping-price-review-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-shopping-price-review-order',@lesson,3,'word_order','پرسش قیمت گوشت را دوباره بساز.','پس از خواندن چند قیمت، پرسش اصلی به بازیابی فعال منتقل می‌شود.',NULL,CAST('{"sourceText":"Wie viel kostet dieses Fleisch?","sourceTextFa":"این گوشت چقدر قیمت دارد؟","tokens":["Wie","viel","kostet","dieses","Fleisch?"],"answer":["Wie","viel","kostet","dieses","Fleisch?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-shopping-price-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-shopping-quantity-payment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-shopping-checkout-review',@level,@unit,15,3,'خرید را ببند و پرداخت کن',NULL,NULL,'draft','این درس بخش پایانی تراکنش را جداگانه تثبیت می‌کند: تعیین مقدار، پایان سفارش و پرداخت.','تراکنش کامل فعال می‌شود، سپس نوبت مناسب انتخاب و جملهٔ پرداخت بازیابی می‌شود.','conversation_speaking>choose_response>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-shopping-checkout-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-shopping-checkout-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی خرید را دوباره اجرا کن و این بار روی پایان سفارش و صندوق تمرکز کن.','صحنهٔ کامل، مرحلهٔ بستن سفارش و پرداخت را در جای طبیعی آن نگه می‌دارد.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-shopping-quantity-payment' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-shopping-checkout-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-shopping-checkout-review-response',@lesson,2,'choose_response','فروشنده مقدار را می‌پرسد؛ پاسخ درست را انتخاب کن.','تمایز پاسخ مقدار از «چیز دیگری؟» و پایان سفارش، ترتیب تراکنش را روشن می‌کند.',NULL,CAST('{"promptTarget":"Wie viel möchten Sie?","promptFa":"چه مقدار می‌خواهید؟","options":[{"textTarget":"Bitte 250 Gramm.","translationFa":"لطفاً ۲۵۰ گرم.","correct":true},{"textTarget":"Noch etwas?","translationFa":"چیز دیگری؟","correct":false},{"textTarget":"Danke, das ist alles.","translationFa":"ممنون، همین کافی است.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-shopping-checkout-review-response' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-shopping-checkout-review-order',@lesson,3,'word_order','دستور پرداخت را دوباره بساز.','بازیابی جملهٔ پرداخت مرحلهٔ پایانی خرید را تثبیت می‌کند.',NULL,CAST('{"sourceText":"Bezahlen Sie bitte dort.","sourceTextFa":"لطفاً آنجا پرداخت کنید.","tokens":["Bezahlen","Sie","bitte","dort."],"answer":["Bezahlen","Sie","bitte","dort."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-shopping-checkout-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-expanded-food-order' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-food-preference-review',@level,@unit,16,1,'چی می‌خواهی و چی نه؟',NULL,NULL,'draft','این درس بخش ترجیح را از سفارش چندقلمی جدا می‌کند تا خواستن یک مورد و نخواستن مورد دیگر به‌صورت فعال تمرین شود.','ترجیح ابتدا در بافت دیده می‌شود، سپس تشخیص داده و در پایان بازسازی می‌شود.','conversation_speaking>multiple_choice>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-food-preference-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-food-preference-review-conversation',@lesson,1,'conversation_speaking','سفارش را دوباره اجرا کن و به انتخاب‌ها دقت کن.','گفت‌وگوی سفارش، ترجیح را در یک موقعیت واقعی فعال می‌کند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-expanded-food-order' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-food-preference-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-food-preference-review-choice',@lesson,2,'multiple_choice','کدام جمله می‌گوید قهوه می‌خواهم، اما شیر نمی‌خواهم؟','سه جملهٔ منبع‌دار الگوی ترجیح مثبت و منفی را مقایسه می‌کنند.',NULL,CAST('{"options":[{"textTarget":"Ich möchte Kaffee, aber keine Milch.","translationFa":"قهوه می‌خواهم، اما شیر نمی‌خواهم.","correct":true},{"textTarget":"Ich möchte Kuchen, aber keine Brötchen.","translationFa":"کیک می‌خواهم، اما نان گرد نمی‌خواهم.","correct":false},{"textTarget":"Ich möchte Reis, aber keine Suppe.","translationFa":"برنج می‌خواهم، اما سوپ نمی‌خواهم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-food-preference-review-choice' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-food-preference-review-order',@lesson,3,'word_order','جملهٔ قهوه بدون شیر را دوباره بساز.','بازسازی جمله، تشخیص ترجیح را به تولید هدایت‌شده تبدیل می‌کند.',NULL,CAST('{"sourceText":"Ich möchte Kaffee, aber keine Milch.","sourceTextFa":"قهوه می‌خواهم، اما شیر نمی‌خواهم.","tokens":["Ich","möchte","Kaffee,","aber","keine","Milch."],"answer":["Ich","möchte","Kaffee,","aber","keine","Milch."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-food-preference-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-expanded-food-order' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-food-combinations-review',@level,@unit,18,3,'سفارش را کامل‌تر کن',NULL,NULL,'draft','این درس واحدهای سرو و اضافه‌کردن قلم دوم را جداگانه تثبیت می‌کند تا سفارش چندمرحله‌ای از یک جملهٔ حفظی فراتر برود.','از سفارش کامل به تشخیص ترکیب‌ها و سپس ساخت جملهٔ افزودن نوشیدنی می‌رسد.','conversation_speaking>matching>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-food-combinations-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-food-combinations-review-conversation',@lesson,1,'conversation_speaking','سفارش را دوباره اجرا کن و روی اضافه‌کردن قلم دوم تمرکز کن.','گفت‌وگوی منبع‌دار الگوی سفارش چندمرحله‌ای را در بافت نگه می‌دارد.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-expanded-food-order' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-food-combinations-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-food-combinations-review-matching',@lesson,2,'matching','ترکیب‌های سفارش را به معنی درست وصل کن.','چهار ترکیب منبع‌دار تکه، فنجان و افزودنی‌ها را تثبیت می‌کنند.',NULL,CAST('{"pairs":[{"left":"ein Stück Kuchen","leftFa":"یک تکه کیک","right":"یک تکه کیک","rightFa":"یک تکه کیک"},{"left":"eine Tasse Kaffee","leftFa":"یک فنجان قهوه","right":"یک فنجان قهوه","rightFa":"یک فنجان قهوه"},{"left":"drei Stück Kuchen","leftFa":"سه تکه کیک","right":"سه تکه کیک","rightFa":"سه تکه کیک"},{"left":"eine Tasse Kaffee mit Milch und Zucker","leftFa":"یک فنجان قهوه با شیر و شکر","right":"قهوه با شیر و شکر","rightFa":"قهوه با شیر و شکر"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-food-combinations-review-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-food-combinations-review-order',@lesson,3,'word_order','جملهٔ اضافه‌کردن قهوه را دوباره بساز.','تولید هدایت‌شدهٔ قلم دوم، الگوی سفارش چندمرحله‌ای را تثبیت می‌کند.',NULL,CAST('{"sourceText":"Ich möchte auch noch eine Tasse Kaffee.","sourceTextFa":"یک فنجان قهوه هم می‌خواهم.","tokens":["Ich","möchte","auch","noch","eine","Tasse","Kaffee."],"answer":["Ich","möchte","auch","noch","eine","Tasse","Kaffee."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-food-combinations-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-time-plans-appointment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-time-plans-review',@level,@unit,21,3,'زمان و قرار را جمع‌بندی کن',NULL,NULL,'draft','این درس بازهٔ زمانی و هماهنگی قرار را در یک مرور ترکیبی جمع می‌کند تا زمان فقط به خواندن ساعت محدود نماند.','از گفت‌وگوی قرار به شبکهٔ عبارت‌های زمانی و سپس تولید هدایت‌شدهٔ دعوت حرکت می‌کند.','conversation_speaking>matching>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-time-plans-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-time-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی قرار را دوباره انجام بده و روی زمان جایگزین تمرکز کن.','صحنهٔ منبع‌دار دعوت و تغییر زمان، ساعت را به تصمیم واقعی وصل می‌کند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-time-simple-appointment' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-time-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-time-review-matching',@lesson,2,'matching','هر عبارت را به معنی درست وصل کن.','چهار عبارت منبع‌دارِ زمان و قرار در یک شبکهٔ واحد مرور می‌شوند.',NULL,CAST('{"pairs":[{"left":"einen Termin","leftFa":"یک قرار / وقت ملاقات","right":"قرار","rightFa":"قرار"},{"left":"heute Abend","leftFa":"امشب","right":"امشب","rightFa":"امشب"},{"left":"morgen","leftFa":"فردا","right":"فردا","rightFa":"فردا"},{"left":"um 12 Uhr","leftFa":"ساعت ۱۲","right":"ساعت ۱۲","rightFa":"ساعت ۱۲"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-time-review-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-time-review-order',@lesson,3,'word_order','جملهٔ دعوت به کنسرت را دوباره بساز.','بازسازی دعوت، مرور زمان و قرار را با تولید هدایت‌شده پایان می‌دهد.',NULL,CAST('{"sourceText":"Darf ich Sie ins Konzert einladen?","sourceTextFa":"می‌توانم شما را به کنسرت دعوت کنم؟","tokens":["Darf","ich","Sie","ins","Konzert","einladen?"],"answer":["Darf","ich","Sie","ins","Konzert","einladen?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-time-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-directions-public-places' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-directions-public-places-review',@level,@unit,22,1,'مقصدت کجاست؟',NULL,NULL,'draft','این درس مقصدها را پیش از تمرکز روی توالی جهت‌ها تثبیت می‌کند تا الگوی پرسش مسیر به مکان‌های مختلف منتقل شود.','گفت‌وگوی مسیر، مرور مقصدها و بازسازی پرسش سه مرحلهٔ فهم، گسترش و بازیابی را می‌سازند.','conversation_speaking>matching>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-directions-public-places-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-directions-places-review-conversation',@lesson,1,'conversation_speaking','مسیر شهرداری را دوباره بپرس و این بار روی مقصدها تمرکز کن.','گفت‌وگوی منبع‌دار مسیر، واژگان مکان را در نقش مقصد نگه می‌دارد.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-ask-and-follow-directions' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-directions-places-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-directions-places-review-matching',@lesson,2,'matching','مکان‌های عمومی را به معنی درست وصل کن.','چهار مقصد پرتکرار پایهٔ انتقال مهارت مسیر به مکان‌های مختلف هستند.',NULL,CAST('{"pairs":[{"left":"Bahnhof","leftFa":"ایستگاه قطار","right":"ایستگاه قطار","rightFa":"ایستگاه قطار"},{"left":"Bushaltestelle","leftFa":"ایستگاه اتوبوس","right":"ایستگاه اتوبوس","rightFa":"ایستگاه اتوبوس"},{"left":"Flughafen","leftFa":"فرودگاه","right":"فرودگاه","rightFa":"فرودگاه"},{"left":"Stadtmitte","leftFa":"مرکز شهر","right":"مرکز شهر","rightFa":"مرکز شهر"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-directions-places-review-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-directions-places-review-order',@lesson,3,'word_order','پرسش مسیر شهرداری را دوباره بساز.','پس از مرور مقصدها، پرسش مسیر به بازیابی فعال منتقل می‌شود.',NULL,CAST('{"sourceText":"Wie komme ich zum Rathaus?","sourceTextFa":"چطور به شهرداری برسم؟","tokens":["Wie","komme","ich","zum","Rathaus?"],"answer":["Wie","komme","ich","zum","Rathaus?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-directions-places-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-directions-public-places' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-directions-sequence-review',@level,@unit,24,3,'مسیر را قدم‌به‌قدم دنبال کن',NULL,NULL,'draft','این درس تمرکز را از نام مقصد به دنبال‌کردن توالی جهت‌ها منتقل می‌کند و جملهٔ اصلی مسیر را فعالانه بازیابی می‌کند.','توالی در گفت‌وگو دنبال می‌شود، جهت‌ها از هم جدا می‌شوند و در پایان جهت کلیدی داخل جملهٔ کامل بازیابی می‌شود.','conversation_speaking>multiple_choice>fill_blank','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-directions-sequence-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-directions-sequence-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی مسیر را دوباره اجرا کن و ترتیب حرکت را دنبال کن.','صحنهٔ منبع‌دار این بار برای تمرکز بر راست و سپس مستقیم استفاده می‌شود.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-ask-and-follow-directions' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-directions-sequence-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-directions-sequence-review-choice',@lesson,2,'multiple_choice','کدام عبارت یعنی مستقیم به جلو؟','سه عبارت منبع‌دار تفاوت مستقیم، چپ و راست را می‌سنجند.',NULL,CAST('{"options":[{"textTarget":"geradeaus","translationFa":"مستقیم به جلو","correct":true},{"textTarget":"Links abbiegen.","translationFa":"به چپ بپیچید.","correct":false},{"textTarget":"Rechts abbiegen.","translationFa":"به راست بپیچید.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-directions-sequence-review-choice' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-directions-sequence-review-fill',@lesson,3,'fill_blank','جملهٔ مسیر را با عبارت درست کامل کن.','تکمیل جملهٔ کامل، فهم جهت را در جای واقعی آن می‌سنجد.',NULL,CAST('{"sourceText":"Rechts um die Ecke und dann immer geradeaus – ungefähr ein Kilometer.","sourceTextFa":"سرِ پیچ به راست بپیچید و بعد مستقیم ادامه بدهید؛ حدود یک کیلومتر.","blankedText":"Rechts um die Ecke und dann immer ___ – ungefähr ein Kilometer.","blankedTextFa":"سرِ پیچ به راست بپیچید و بعد ___ ادامه بدهید؛ حدود یک کیلومتر.","choices":["geradeaus","links","rechts"],"choicesFa":["مستقیم","چپ","راست"],"answer":"geradeaus"}' AS JSON),CAST('["source_sentence_blank_created","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-directions-sequence-review-fill' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-requests-services-help' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-services-permission-review',@level,@unit,26,2,'اجازه بگیر و درخواست کن',NULL,NULL,'draft','این درس اجازه گرفتن را به‌عنوان یک کارکرد مستقل خدماتی از تشخیص به تولید می‌رساند.','بافت خدماتی ابتدا فعال می‌شود، سپس کاربرد عبارت تشخیص داده و در پایان همان پرسش بازسازی می‌شود.','conversation_speaking>multiple_choice>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-services-permission-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-services-permission-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی خدماتی را دوباره اجرا کن و روی درخواست مؤدبانه تمرکز کن.','صحنهٔ روشن‌سازی، بافت خدماتی را پیش از تمرین اجازه فعال می‌کند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-clarify-slowly' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-services-permission-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-services-permission-review-choice',@lesson,2,'multiple_choice','کدام عبارت برای اجازه گرفتنِ استفاده از تلفن است؟','سه عبارت منبع‌دار اجازه گرفتن را از پرسش مکان و زبان جدا می‌کنند.',NULL,CAST('{"options":[{"textTarget":"Kann ich Ihr Telefon benutzen?","translationFa":"می‌توانم از تلفن شما استفاده کنم؟","correct":true},{"textTarget":"Wo ist die Toilette, bitte?","translationFa":"سرویس بهداشتی کجاست، لطفاً؟","correct":false},{"textTarget":"Sprechen Sie Englisch?","translationFa":"انگلیسی صحبت می‌کنید؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-services-permission-review-choice' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-services-permission-review-order',@lesson,3,'word_order','پرسش اجازه برای استفاده از تلفن را دوباره بساز.','بازسازی پرسش، تشخیص کاربرد را به تولید هدایت‌شده تبدیل می‌کند.',NULL,CAST('{"sourceText":"Kann ich Ihr Telefon benutzen?","sourceTextFa":"می‌توانم از تلفن شما استفاده کنم؟","tokens":["Kann","ich","Ihr","Telefon","benutzen?"],"answer":["Kann","ich","Ihr","Telefon","benutzen?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-services-permission-review-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-requests-services-help' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-services-help-review',@level,@unit,27,3,'کمک لازم را روشن بگو',NULL,NULL,'draft','درس سوم واحد، بیان نیاز مشخص و راهبرد روشن‌سازی را کنار هم نگه می‌دارد تا زبان‌آموز بتواند تعامل خدماتی را ادامه دهد.','گفت‌وگو راهبرد بقا را فعال می‌کند، سپس نیاز مشخص و واژگان خدماتی بازیابی می‌شوند.','conversation_speaking>choose_response>matching','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-services-help-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-services-help-review-conversation',@lesson,1,'conversation_speaking','اگر چیزی را نفهمیدی، گفت‌وگو را مدیریت کن و درخواست روشن‌سازی بده.','صحنهٔ منبع‌دار راهبرد ادامه‌دادن تعامل در صورت نفهمیدن را فعال می‌کند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-clarify-slowly' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-services-help-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-services-help-review-response',@lesson,2,'choose_response','در پاسخ به «چه چیزی لازم دارید؟» جملهٔ مربوط به کمک را انتخاب کن.','انتخاب پاسخ درست، نیاز مشخص را از جمله‌های نزدیک با کارکرد دیگر جدا می‌کند.',NULL,CAST('{"promptTarget":"Was brauchen Sie?","promptFa":"چه چیزی لازم دارید؟","options":[{"textTarget":"Ich brauche Ihre Hilfe.","translationFa":"به کمک شما نیاز دارم.","correct":true},{"textTarget":"Ich verstehe das nicht.","translationFa":"این را نمی‌فهمم.","correct":false},{"textTarget":"Wo ist die Toilette, bitte?","translationFa":"سرویس بهداشتی کجاست، لطفاً؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-services-help-review-response' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-services-help-review-matching',@lesson,3,'matching','واژه‌های خدماتی را به معنی درست وصل کن.','شبکهٔ چهار واژهٔ خدماتی دامنهٔ کاربرد واحد را تثبیت می‌کند.',NULL,CAST('{"pairs":[{"left":"Hilfe","leftFa":"کمک","right":"کمک","rightFa":"کمک"},{"left":"Telefon","leftFa":"تلفن","right":"تلفن","rightFa":"تلفن"},{"left":"Toilette","leftFa":"سرویس بهداشتی","right":"سرویس بهداشتی","rightFa":"سرویس بهداشتی"},{"left":"Apotheke","leftFa":"داروخانه","right":"داروخانه","rightFa":"داروخانه"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-services-help-review-matching' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-forms-signs-messages' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-forms-signs-message-review',@level,@unit,30,3,'فرم، تابلو و پیام را به هم وصل کن',NULL,NULL,'draft','درس جمع‌بندی واحد سه قالب واقعی بیرون از گفت‌وگوی آزاد را کنار هم می‌آورد: اطلاعات فرم، تابلو و پیام کوتاه.','اطلاعات شخصی در گفت‌وگو فعال می‌شود، سپس خواندن سریع تابلوها و در پایان بازسازی پیام کوتاه تمرین می‌شود.','conversation_speaking>matching>word_order','pending','درس تقویتی و بازیابی است؛ متن آلمانی تازهٔ آزاد تولید نمی‌کند و از مواد منبع‌دار موجود استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-forms-signs-message-review' LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson AND status='final';
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role)
SELECT @lesson,curriculum_target_id,'review' FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-forms-review-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی اطلاعات شخصی را دوباره اجرا کن و به اطلاعات فرم دقت کن.','گفت‌وگوی منبع‌دار اطلاعات لازم برای فرم را پیش از خواندن محیطی فعال می‌کند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-personal-form-review' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-forms-review-conversation' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-forms-review-signs',@lesson,2,'matching','تابلوهای کوتاه را به معنی درست وصل کن.','چهار تابلو باید در پایان A1 به‌صورت سریع و مستقل قابل تشخیص باشند.',NULL,CAST('{"pairs":[{"left":"Offen","leftFa":"باز","right":"باز","rightFa":"باز"},{"left":"Geschlossen","leftFa":"بسته","right":"بسته","rightFa":"بسته"},{"left":"Eingang","leftFa":"ورودی","right":"ورودی","rightFa":"ورودی"},{"left":"Ausgang","leftFa":"خروجی","right":"خروجی","rightFa":"خروجی"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-forms-review-signs' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES('act-de-a1-forms-review-message-order',@lesson,3,'word_order','پیام کوتاه تماس برای بعدازظهر را دوباره بساز.','بازسازی پیام، خواندن محیطی را با نوشتن هدایت‌شده جمع می‌کند.',NULL,CAST('{"sourceText":"Rufen Sie bitte am Nachmittag noch einmal an.","sourceTextFa":"لطفاً بعدازظهر دوباره تماس بگیرید.","tokens":["Rufen","Sie","bitte","am","Nachmittag","noch","einmal","an."],"answer":["Rufen","Sie","bitte","am","Nachmittag","noch","einmal","an."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL;
SET @act := (SELECT id FROM activities WHERE activity_key='act-de-a1-forms-review-message-order' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @act,curriculum_target_id FROM unit_targets WHERE unit_id=@unit;
UPDATE lessons SET status='final',audio_status='pending' WHERE id=@lesson;

UPDATE lessons
SET sequence_index=CASE lesson_key WHEN 'de-a1-lesson-profession-profile' THEN 1 WHEN 'de-a1-lesson-work-and-languages' THEN 2 WHEN 'de-a1-lesson-integrated-introduction-review' THEN 3 WHEN 'de-a1-lesson-family-brother-profile' THEN 4 WHEN 'de-a1-lesson-family-parents-profile' THEN 5 WHEN 'de-a1-lesson-family-profile-review' THEN 6 WHEN 'de-a1-lesson-room-table-lamp' THEN 7 WHEN 'de-a1-lesson-room-position' THEN 8 WHEN 'de-a1-lesson-home-description-review' THEN 9 WHEN 'de-a1-lesson-daily-routine-work' THEN 10 WHEN 'de-a1-lesson-daily-routine-school' THEN 11 WHEN 'de-a1-lesson-daily-routine-day-review' THEN 12 WHEN 'de-a1-lesson-shopping-price-review' THEN 13 WHEN 'de-a1-lesson-shopping-quantity-payment' THEN 14 WHEN 'de-a1-lesson-shopping-checkout-review' THEN 15 WHEN 'de-a1-lesson-food-preference-review' THEN 16 WHEN 'de-a1-lesson-expanded-food-order' THEN 17 WHEN 'de-a1-lesson-food-combinations-review' THEN 18 WHEN 'de-a1-lesson-time-class-schedule' THEN 19 WHEN 'de-a1-lesson-time-simple-appointment' THEN 20 WHEN 'de-a1-lesson-time-plans-review' THEN 21 WHEN 'de-a1-lesson-directions-public-places-review' THEN 22 WHEN 'de-a1-lesson-ask-and-follow-directions' THEN 23 WHEN 'de-a1-lesson-directions-sequence-review' THEN 24 WHEN 'de-a1-lesson-clarify-permission-help' THEN 25 WHEN 'de-a1-lesson-services-permission-review' THEN 26 WHEN 'de-a1-lesson-services-help-review' THEN 27 WHEN 'de-a1-lesson-personal-form-signs' THEN 28 WHEN 'de-a1-lesson-short-phone-message' THEN 29 WHEN 'de-a1-lesson-forms-signs-message-review' THEN 30 ELSE sequence_index END,
    position_in_unit=CASE lesson_key WHEN 'de-a1-lesson-profession-profile' THEN 1 WHEN 'de-a1-lesson-work-and-languages' THEN 2 WHEN 'de-a1-lesson-integrated-introduction-review' THEN 3 WHEN 'de-a1-lesson-family-brother-profile' THEN 1 WHEN 'de-a1-lesson-family-parents-profile' THEN 2 WHEN 'de-a1-lesson-family-profile-review' THEN 3 WHEN 'de-a1-lesson-room-table-lamp' THEN 1 WHEN 'de-a1-lesson-room-position' THEN 2 WHEN 'de-a1-lesson-home-description-review' THEN 3 WHEN 'de-a1-lesson-daily-routine-work' THEN 1 WHEN 'de-a1-lesson-daily-routine-school' THEN 2 WHEN 'de-a1-lesson-daily-routine-day-review' THEN 3 WHEN 'de-a1-lesson-shopping-price-review' THEN 1 WHEN 'de-a1-lesson-shopping-quantity-payment' THEN 2 WHEN 'de-a1-lesson-shopping-checkout-review' THEN 3 WHEN 'de-a1-lesson-food-preference-review' THEN 1 WHEN 'de-a1-lesson-expanded-food-order' THEN 2 WHEN 'de-a1-lesson-food-combinations-review' THEN 3 WHEN 'de-a1-lesson-time-class-schedule' THEN 1 WHEN 'de-a1-lesson-time-simple-appointment' THEN 2 WHEN 'de-a1-lesson-time-plans-review' THEN 3 WHEN 'de-a1-lesson-directions-public-places-review' THEN 1 WHEN 'de-a1-lesson-ask-and-follow-directions' THEN 2 WHEN 'de-a1-lesson-directions-sequence-review' THEN 3 WHEN 'de-a1-lesson-clarify-permission-help' THEN 1 WHEN 'de-a1-lesson-services-permission-review' THEN 2 WHEN 'de-a1-lesson-services-help-review' THEN 3 WHEN 'de-a1-lesson-personal-form-signs' THEN 1 WHEN 'de-a1-lesson-short-phone-message' THEN 2 WHEN 'de-a1-lesson-forms-signs-message-review' THEN 3 ELSE position_in_unit END
WHERE language_level_id=@level
  AND lesson_key IN ('de-a1-lesson-profession-profile','de-a1-lesson-work-and-languages','de-a1-lesson-integrated-introduction-review','de-a1-lesson-family-brother-profile','de-a1-lesson-family-parents-profile','de-a1-lesson-family-profile-review','de-a1-lesson-room-table-lamp','de-a1-lesson-room-position','de-a1-lesson-home-description-review','de-a1-lesson-daily-routine-work','de-a1-lesson-daily-routine-school','de-a1-lesson-daily-routine-day-review','de-a1-lesson-shopping-price-review','de-a1-lesson-shopping-quantity-payment','de-a1-lesson-shopping-checkout-review','de-a1-lesson-food-preference-review','de-a1-lesson-expanded-food-order','de-a1-lesson-food-combinations-review','de-a1-lesson-time-class-schedule','de-a1-lesson-time-simple-appointment','de-a1-lesson-time-plans-review','de-a1-lesson-directions-public-places-review','de-a1-lesson-ask-and-follow-directions','de-a1-lesson-directions-sequence-review','de-a1-lesson-clarify-permission-help','de-a1-lesson-services-permission-review','de-a1-lesson-services-help-review','de-a1-lesson-personal-form-signs','de-a1-lesson-short-phone-message','de-a1-lesson-forms-signs-message-review');
UPDATE units SET grouping_rationale='واحد از معرفی شغل شروع می‌کند، سپس کار و زبان‌ها را به آن اضافه می‌کند و در درس پایانی همهٔ این اطلاعات را در یک معرفی کامل‌تر دوباره بازیابی می‌کند. این مسیر از افزودن مؤلفه‌های تازه به یکپارچه‌سازی آن‌ها می‌رسد.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-extended-introduction' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد ابتدا اطلاعات یک خواهر یا برادر، سپس والدین و در پایان چند نوع اطلاعات خانوادگی را به‌صورت یک پروفایل منسجم کنار هم قرار می‌دهد. مرور پایانی مانع می‌شود واژگان خانواده فقط به فهرست اسامی تبدیل شوند.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-family-and-close-people' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد از شناسایی و مالکیت وسایل ساده به موقعیت آن‌ها در اتاق می‌رسد و در درس جمع‌بندی اشیا و جهت‌های داخل فضا را به یک توصیف کاربردی وصل می‌کند.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-home-and-nearby' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد دو مسیر رایج کار و مدرسه را جداگانه تمرین می‌کند و سپس چهار بخش روز را در یک زنجیرهٔ زمانی کامل بازیابی می‌کند تا زبان‌آموز بتواند یک روز معمولی را دنبال کند.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-daily-routine-work-school' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد ابتدا تشخیص و پرسیدن قیمت را تثبیت می‌کند، سپس تراکنش کامل مقدار و افزودن کالا را تمرین می‌کند و در پایان بستن خرید و پرداخت را جداگانه بازیابی می‌کند.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-shopping-quantity-payment' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد از ترجیح سادهٔ مثبت و منفی به سفارش چندمرحله‌ای می‌رسد و در پایان ترکیب‌های مقدار و افزودن قلم دیگر را تثبیت می‌کند تا سفارش از یک جملهٔ حفظی فراتر برود.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-expanded-food-order' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد بازهٔ زمانی برنامه و هماهنگی قرار را در دو موقعیت جدا تمرین می‌کند و سپس در درس جمع‌بندی، عبارت‌های زمان، پاسخ به ساعت مشخص و دعوت را کنار هم بازیابی می‌کند.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-time-plans-appointment' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد ابتدا مقصدهای عمومی را تثبیت می‌کند، سپس پرسیدن و دنبال‌کردن مسیر را در گفت‌وگو تمرین می‌کند و در پایان توالی جهت‌ها را به‌صورت متمرکز بازیابی می‌کند.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-directions-public-places' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد ابتدا راهبرد روشن‌سازی را در یک گفت‌وگوی خدماتی فعال می‌کند، سپس اجازه گرفتن و بیان نیاز مشخص را جداگانه تمرین می‌کند تا زبان‌آموز چند راه واقعی برای مدیریت موقعیت خدماتی داشته باشد.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-requests-services-help' AND language_level_id=@level;
UPDATE units SET grouping_rationale='واحد فرم و تابلو را در یک درس، پیام تماس را در درس دوم و در پایان هر سه قالب را در یک مرور چندمهارتی به هم وصل می‌کند. هدف این است که خواندن و نوشتن کوتاه A1 به یک قالب محدود نماند.',notes='در بازبینی عمق A1، این واحد به سه درس رسید. تعداد درس‌ها بر اساس پوشش و نیاز به بازیابی انتخاب شده است و در صورت کشف شکاف واقعی می‌تواند در بازهٔ تعریف‌شده گسترش پیدا کند.',status='final' WHERE unit_key='de-a1-unit-forms-signs-messages' AND language_level_id=@level;

UPDATE language_levels
SET structure_rationale='A1 نیازمحور باقی می‌ماند، اما از این سطح به بعد هر واحد نهایی باید بین ۳ تا ۱۲ درس داشته باشد. تعداد دقیق داخل این بازه بر اساس گسترهٔ موضوع، پیش‌نیازها، تنوع مهارتی، بازیابی و کاربرد واقعی تعیین می‌شود؛ نه بر اساس پرکردن سهمیه.',
    coverage=CAST('{"communicativeTargets":["فهم و استفاده از عبارت‌ها و جمله‌های ساده و پرتکرار در موقعیت‌های آشنای روزمره","معرفی خود و دیگران و پرسیدن و پاسخ‌دادن دربارهٔ اطلاعات شخصی پایه","پرسیدن و گفتن اطلاعات ساده دربارهٔ خانواده، افراد آشنا و روابط نزدیک","صحبت ساده دربارهٔ محل زندگی، خانه و محیط نزدیک","پرسیدن و پاسخ‌دادن دربارهٔ کار، مدرسه و کارهای روزمرهٔ پایه","خرید ساده: پرسیدن قیمت، مقدار، نیاز و انتخاب کالا","سفارش و درخواست سادهٔ غذا و نوشیدنی و فهم پاسخ‌های رایج","پرسیدن و فهم زمان، تاریخ، ساعت، برنامه و قرار ساده","پرسیدن و دادن مسیر و اطلاعات مکانی بسیار ساده","درخواست، اجازه، کمک و پاسخ مؤدبانه در موقعیت‌های روزمره","فهم گفت‌وگوهای کوتاه روزمره وقتی آهسته و روشن گفته می‌شوند","فهم اطلاعات اصلی در پیام تلفنی کوتاه و اعلام عمومی ساده","خواندن و فهم متن‌های بسیار کوتاه مانند یادداشت، آگهی، تابلو و اعلان","تکمیل فرم ساده و نوشتن یک پیام شخصی کوتاه دربارهٔ موقعیت روزمره","پرسیدن و پاسخ‌دادن به سؤال‌های روزمره و انجام یک درخواست ساده در گفت‌وگوی کوتاه"],"linguisticTargets":["گسترش واژگان پایه برای شخص، خانواده، خانه، خرید، کار یا مدرسه، غذا، زمان و محیط نزدیک","ساخت جملهٔ سادهٔ خبری و پرسشی با ترتیب واژهٔ پایه در آلمانی","پرسش‌های W و پرسش‌های بله/خیر در موقعیت‌های روزمره","ضمیرهای شخصی و تمایز کاربردی خطاب دوستانه و رسمی","فعل‌های پرتکرار در زمان حال و الگوهای صرفی لازم برای ارتباط A1","منفی‌سازی پایه با الگوهای منبع‌دار مانند nicht و kein پس از ثبت منبع مناسب","اسم، جنس، حرف تعریف و جمع در حد لازم برای واژگان پرتکرار A1","حالت‌های دستوری پایه در حد کاربردهای روزمره و منبع‌دار، بدون آموزش انتزاعیِ زودهنگام","عدد، مقدار، قیمت، تاریخ و ساعت در دامنهٔ روزمرهٔ A1","حروف اضافهٔ بسیار پرتکرار زمان و مکان در عبارت‌های منبع‌دار","افعال وجهی و الگوهای درخواست ساده فقط پس از تثبیت منابع آلمانی قابل‌بازاستفاده","تلفظ قابل‌فهمِ واژه‌ها و جمله‌های کوتاه، با تمرکز بر تفاوت‌های پرتکرار آلمانی که در منابع این سطح ظاهر می‌شوند"],"situations":["معرفی و آشنایی","خانواده و افراد نزدیک","خانه و محل زندگی","کار، مدرسه و روتین روزانه","خرید و پرداخت","کافه، رستوران و سفارش","زمان، تاریخ، برنامه و قرار","خیابان، مسیر و مکان‌های عمومی","درخواست کمک، اجازه و خدمات روزمره","فرم، یادداشت، پیام کوتاه و تماس یا اعلام ساده"],"gaps":[]}' AS JSON),
    completion_assessment=CAST('{"reviewedAt":"2026-09-18T05:05:00Z","cefrCoverageComplete":true,"progressionComplete":true,"practiceAndRetrievalComplete":true,"skillModeCoverageComplete":true,"requiredGaps":[],"qualityReview":{"overallScore":9.2,"dimensionScores":{"cefrCoverage":9.4,"pedagogicalProgression":9.2,"practiceAndRetrieval":9.1,"activityQualityAndVariety":9,"linguisticAccuracyAndNaturalness":9.3,"sourceQualityAndCurrency":9.4,"learnerSupportAndClarity":9.1,"qaIntegrity":9.3},"rationale":"پوشش همهٔ ۳۷ هدف الزامی به شواهد واقعی درس و فعالیت متصل است. پس از بازبینی عمق واحدها، ساختار A1 از ۱۶ درس به ۳۰ درس گسترش یافت تا هر یک از ۱۰ واحد حداقل سه مرحلهٔ آموزشی داشته باشد: معرفی یا کاربرد اصلی، تمرین متمرکز و بازیابی یا یکپارچه‌سازی. درس‌های افزوده‌شده متن آلمانی تازهٔ آزاد تولید نمی‌کنند و از همان مواد منبع‌دار و گفت‌وگوهای تأییدشده برای تمرین فاصله‌دار و انتقال مهارت استفاده می‌کنند.","strengths":["همهٔ هدف‌های الزامی A1 نگاشت واقعی به واحد، درس یا فعالیت دارند.","متن آلمانی زبان‌آموز از منابع قابل‌بازاستفاده و بررسی‌شده می‌آید و متن آزادِ ساخته‌شده به محتوای آموزشی وارد نشده است.","ترتیب فعالیت‌ها عمدتاً از فهم و تشخیص به بازیابی و تولید هدایت‌شده حرکت می‌کند.","گفت‌وگوها از نظر نوع خطاب و رابطهٔ شخصیت‌ها بازبینی و اصلاح شده‌اند.","خواندن، شنیدن، گفتار، فرم، تابلو، پیام کوتاه و تلفظ در سطح توزیع شده‌اند.","هر ۱۰ واحد A1 اکنون سه درس هدفمند دارد و هیچ واحد نهایی زیر حد عمق تعریف‌شده نیست."],"remainingWeaknesses":["تولید نوشتاری در ساختار فعلی برنامه هدایت‌شده است و ورودی آزاد تایپی ندارد.","دارایی‌های صوتی و نگاشت آن‌ها به‌صورت فنی اعتبارسنجی شده‌اند، اما بازبینی شنیداری انسانی برای کنترل لحن، تلفظ و طبیعی‌بودن همهٔ فایل‌ها هنوز انجام نشده است."]},"scopeExclusions":["ورودی آزاد تایپی در ساختار فعلی فعالیت‌ها پشتیبانی نمی‌شود؛ تولید نوشتاری A1 در این نسخه به تکمیل و بازسازی هدایت‌شده محدود است."]}' AS JSON),
    notes='A1 از نظر محتوایی نهایی است: ۱۰ واحد دارد و هر واحد اکنون ۳ درس هدفمند دارد؛ در مجموع ۳۰ درس. همهٔ ۳۷ هدف الزامی بدون شکاف باز پوشش دارند. درس‌های تقویتی تازه از صحنه‌ها و مواد منبع‌دار موجود استفاده می‌کنند و هدف صوتی مستقل تازه‌ای اضافه نمی‌کنند؛ بنابراین وضعیت صوتی بر پایهٔ دارایی‌های فعلی آماده باقی می‌ماند.',
    status='final',
    audio_status='ready'
WHERE id=@level;
COMMIT;
