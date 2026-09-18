-- German A1 Unit 2 — first family lesson. Runs after character bootstrap and Unit 2 planning.
-- Base content does not overwrite generated audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-family-and-close-people' LIMIT 1);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
SET @max := (SELECT id FROM characters WHERE character_key='char-de-max' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);
SET @mia := (SELECT id FROM characters WHERE character_key='char-de-mia' LIMIT 1);

UPDATE characters SET relationship_tags=JSON_ARRAY('acquaintance','family'),context_notes='پاول مولر ۲۰ ساله است و در محتوای فعلی در اتریش زندگی می‌کند. زبان‌آموز در مرور اطلاعات شخصی نقش پاول را بازی می‌کند. در واحد خانواده، میا خواهر اوست و هر دو دربارهٔ برادر کوچک‌تر مشترکشان پاسخ می‌دهند.' WHERE id=@paul;
UPDATE characters SET relationship_tags=JSON_ARRAY('classmate','friend','family'),context_notes='میا ۲۰ ساله است. تاریخ تولد او سیزدهم نوامبر و شمارهٔ تمرینی او 692-267-752 است. در واحد خانواده، پاول برادر اوست و هر دو دربارهٔ برادر کوچک‌تر مشترکشان پاسخ می‌دهند.' WHERE id=@mia;

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@src,'srcitem-de-a1-family-brother-age-q','277','پاسخ تمرین ۲۷۷','Wie alt ist euer Bruder?',UNHEX(SHA2('Wie alt ist euer Bruder?',256)),'پرسش سن برادر با خطاب جمع.'),
(@src,'srcitem-de-a1-family-brother-age-a','277','پاسخ تمرین ۲۷۷','Unser Bruder ist 19 Jahre alt.',UNHEX(SHA2('Unser Bruder ist 19 Jahre alt.',256)),'پاسخ سن برادر با مالکیت جمع.'),
(@src,'srcitem-de-a1-family-brother-name-q','277','پاسخ تمرین ۲۷۷','Wie heißt euer Bruder?',UNHEX(SHA2('Wie heißt euer Bruder?',256)),'پرسش نام برادر با خطاب جمع.'),
(@src,'srcitem-de-a1-family-brother-name-a','277','پاسخ تمرین ۲۷۷','Unser Bruder heißt Uwe.',UNHEX(SHA2('Unser Bruder heißt Uwe.',256)),'پاسخ نام برادر با مالکیت جمع.'),
(@src,'srcitem-de-a1-family-mother-age','277','پاسخ تمرین ۲۷۷','Unsere Mutter ist 66 Jahre alt.',UNHEX(SHA2('Unsere Mutter ist 66 Jahre alt.',256)),'جملهٔ منبع‌دار دربارهٔ مادر.'),
(@src,'srcitem-de-a1-family-sister-age','277','پاسخ تمرین ۲۷۷','Unsere Schwester ist 33 Jahre alt.',UNHEX(SHA2('Unsere Schwester ist 33 Jahre alt.',256)),'جملهٔ منبع‌دار دربارهٔ خواهر.'),
(@src,'srcitem-de-a1-family-sister-home','277','پاسخ تمرین ۲۷۷','Unsere Schwester wohnt in Hamburg.',UNHEX(SHA2('Unsere Schwester wohnt in Hamburg.',256)),'جملهٔ منبع‌دار دربارهٔ محل زندگی خواهر.'),
(@src,'srcitem-de-a1-family-brother-study','277','پاسخ تمرین ۲۷۷','Unser Bruder studiert in Berlin.',UNHEX(SHA2('Unser Bruder studiert in Berlin.',256)),'جملهٔ منبع‌دار دربارهٔ محل تحصیل برادر.'),
(@src,'srcitem-de-a1-family-father-job','277','پاسخ تمرین ۲۷۷','Unser Vater ist Lehrer.',UNHEX(SHA2('Unser Vater ist Lehrer.',256)),'جملهٔ منبع‌دار دربارهٔ پدر.')
ON DUPLICATE KEY UPDATE source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-bruder',@de,'word','Bruder','Bruder','Bruder','noun','اسم','A1','برادر','برای اشاره به برادر در گفت‌وگوهای سادهٔ خانوادگی استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-schwester',@de,'word','Schwester','Schwester','Schwester','noun','اسم','A1','خواهر','برای اشاره به خواهر در گفت‌وگوهای سادهٔ خانوادگی استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-mutter',@de,'word','Mutter','Mutter','Mutter','noun','اسم','A1','مادر','برای اشاره به مادر در گفت‌وگوهای سادهٔ خانوادگی استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-vater',@de,'word','Vater','Vater','Vater','noun','اسم','A1','پدر','برای اشاره به پدر در گفت‌وگوهای سادهٔ خانوادگی استفاده می‌شود.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);
SET @x_bruder := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bruder');
SET @x_schwester := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-schwester');
SET @x_mutter := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-mutter');
SET @x_vater := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-vater');
SET @t_family := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-family' LIMIT 1);
SET @t_family_sit := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-family' LIMIT 1);
SET @t_personal := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-personal-info' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);

INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-family-brother-profile',@level,@unit,3,1,'برادرتان چند ساله است؟','Wie alt ist euer Bruder? / Wie heißt euer Bruder?','برادرتان چند ساله است؟ / اسم برادرتان چیست؟','draft','درس با دو پرسش واقعی دربارهٔ یک برادر شروع می‌شود؛ سپس واژه‌های اعضای خانواده تفکیک می‌شوند، اطلاعات خواهر در یک پرسش و پاسخ دیگر بازیابی می‌شود و در پایان پرسش نام برادر بازسازی می‌شود.','مسیر از فهم گفت‌وگوی خانوادگی به تشخیص واژه، بازیابی اطلاعات و بازسازی پرسش می‌رود. اطلاعات نام و سن از سطح قبل آشنا هستند و بار تازه روی رابطهٔ خانوادگی و مالکیت در بافت قرار می‌گیرد.','conversation_speaking>matching>multiple_choice>word_order','blocked_until_level_final','درس نخست واحد خانواده. حضور هم‌زمان پاول و میا خطاب جمع و پاسخ جمع منبع را طبیعی می‌کند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-family-brother-profile');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES(@lesson,@t_family,'introduce'),(@lesson,@t_family_sit,'introduce'),(@lesson,@t_personal,'review'),(@lesson,@t_core,'introduce'),(@lesson,@t_questions,'practice');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES(@lesson,@x_bruder,TRUE,'introduce'),(@lesson,@x_schwester,TRUE,'introduce'),(@lesson,@x_mutter,TRUE,'introduce'),(@lesson,@x_vater,TRUE,'introduce');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES('dlg-de-a1-family-brother-profile',@level,'مکس با هم‌کلاسی‌اش میا و برادر او پاول دوستانه صحبت می‌کند و دربارهٔ برادر کوچک‌تر مشترک میا و پاول دو سؤال ساده می‌پرسد؛ پاول از طرف هر دو پاسخ می‌دهد.','app','دو جفت پرسش و پاسخ عیناً از پاسخ تمرین ۲۷۷ گرفته شده‌اند. چون متن منبع خطاب جمع و پاسخ جمع دارد، میا در صحنه کنار پاول حضور دارد و رابطهٔ خانوادگی این دو در دادهٔ شخصیت‌ها ثبت شده است؛ بنابراین هیچ تغییر دستوری یا بازنویسی آلمانی لازم نیست.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dialogue := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-family-brother-profile');
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-family-brother-1',@dialogue,1,@max,'app_assigned','unspecified','Wie alt ist euer Bruder?','برادرتان چند ساله است؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-family-brother-2',@dialogue,2,@paul,'app_assigned','unspecified','Unser Bruder ist 19 Jahre alt.','برادر ما ۱۹ ساله است.',TRUE,'blocked_until_level_final'),
('turn-de-a1-family-brother-3',@dialogue,3,@max,'app_assigned','unspecified','Wie heißt euer Bruder?','اسم برادرتان چیست؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-family-brother-4',@dialogue,4,@paul,'app_assigned','unspecified','Unser Bruder heißt Uwe.','اسم برادر ما اووه است.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);

INSERT INTO lexeme_occurrences(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-a1-family-brother-1','dialogue_turn','turn-de-a1-family-brother-1','Bruder',NULL,NULL,@x_bruder,NULL,'approved','واژهٔ برادر در پرسش منبع‌دار.'),
('occ-turn-de-a1-family-brother-2','dialogue_turn','turn-de-a1-family-brother-2','Bruder',NULL,NULL,@x_bruder,NULL,'approved','واژهٔ برادر در پاسخ منبع‌دار.'),
('occ-turn-de-a1-family-brother-3','dialogue_turn','turn-de-a1-family-brother-3','Bruder',NULL,NULL,@x_bruder,NULL,'approved','واژهٔ برادر در پرسش نام.'),
('occ-turn-de-a1-family-brother-4','dialogue_turn','turn-de-a1-family-brother-4','Bruder',NULL,NULL,@x_bruder,NULL,'approved','واژهٔ برادر در پاسخ نام.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-family-brother-conversation',@lesson,1,'conversation_speaking','آیریس از شما و میا دربارهٔ برادرتان می‌پرسد؛ از طرف هر دو جواب بده.','مخاطب جمع منبع با حضور هم‌زمان پاول و میا در صحنه واقعی می‌شود و پاول می‌تواند پاسخ جمع منبع را بدون تغییر بیان کند.',@dialogue,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('other','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-family-words-matching',@lesson,2,'matching','هر عضو خانواده را به معنی درستش وصل کن.','چهار واژهٔ پرتکرار از همان تمرین خانواده جدا می‌شوند تا پیش از گسترش اطلاعات شخصی، رابطه‌ها روشن باشند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Bruder','leftFa','برادر','right','برادر','rightFa','برادر'),JSON_OBJECT('left','Schwester','leftFa','خواهر','right','خواهر','rightFa','خواهر'),JSON_OBJECT('left','Mutter','leftFa','مادر','right','مادر','rightFa','مادر'),JSON_OBJECT('left','Vater','leftFa','پدر','right','پدر','rightFa','پدر'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-a1-family-sister-choice',@lesson,3,'multiple_choice','طبق جملهٔ منبع، خواهرشان کجا زندگی می‌کند؟','پرسش و پاسخ مربوط به خواهر، واژهٔ خانواده را با اطلاعات آشنای محل زندگی ترکیب می‌کند و دو گزینهٔ مقایسه‌ای نیز عین همان بخش منبع هستند.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Unsere Schwester wohnt in Hamburg.','translationFa','خواهر ما در هامبورگ زندگی می‌کند.','correct',TRUE),JSON_OBJECT('textTarget','Unser Bruder studiert in Berlin.','translationFa','برادر ما در برلین تحصیل می‌کند.','correct',FALSE),JSON_OBJECT('textTarget','Unsere Mutter ist 66 Jahre alt.','translationFa','مادر ما ۶۶ ساله است.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-family-name-order',@lesson,4,'word_order','پرسش نام برادر را دوباره بساز.','در پایان، پرسش آشنای نام با واژهٔ خانوادگی و مالکیت جمع به‌صورت فعال بازیابی می‌شود.',NULL,JSON_OBJECT('sourceText','Wie heißt euer Bruder?','sourceTextFa','اسم برادرتان چیست؟','tokens',JSON_ARRAY('Wie','heißt','euer','Bruder?'),'answer',JSON_ARRAY('Wie','heißt','euer','Bruder?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-brother-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-words-matching');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-sister-choice');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-name-order');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES(@a1,@t_family),(@a1,@t_family_sit),(@a1,@t_personal),(@a2,@t_family),(@a2,@t_core),(@a3,@t_family),(@a3,@t_personal),(@a4,@t_questions),(@a4,@t_family);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a1,@x_bruder),(@a2,@x_bruder),(@a2,@x_schwester),(@a2,@x_mutter),(@a2,@x_vater),(@a3,@x_schwester),(@a3,@x_bruder),(@a3,@x_mutter),(@a4,@x_bruder);

SET @si_age_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-brother-age-q');
SET @si_age_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-brother-age-a');
SET @si_name_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-brother-name-q');
SET @si_name_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-brother-name-a');
SET @si_mother := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-mother-age');
SET @si_sister_home := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-sister-home');
SET @si_brother_study := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-brother-study');
SET @si_father := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-father-job');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-family-brother-1',@si_age_q,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-family-brother-2',@si_age_a,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-family-brother-3',@si_name_q,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-family-brother-4',@si_name_a,'verbatim','متن هدف عین منبع است.'),
('lexeme','lex-de-bruder',@si_age_q,'other','واژهٔ خانواده از پرسش منبع‌دار استخراج شده است.'),
('lexeme','lex-de-schwester',@si_sister_home,'other','واژهٔ خانواده از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme','lex-de-mutter',@si_mother,'other','واژهٔ خانواده از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme','lex-de-vater',@si_father,'other','واژهٔ خانواده از جملهٔ منبع‌دار استخراج شده است.'),
('activity','act-de-a1-family-name-order',@si_name_q,'sentence_tokenized_for_word_order','پرسش عین منبع برای مرتب‌سازی بخش‌بندی شده است.'),
('activity','act-de-a1-family-sister-choice',@si_sister_home,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-family-sister-choice',@si_brother_study,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-family-sister-choice',@si_mother,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.');

UPDATE language_levels SET coverage=JSON_SET(coverage,'$.gaps[2]','توالی آموزشی اولیه ثبت شده است؛ واحد نخست به بازبینی رسیده و واحد دوم خانواده با نخستین درس منبع‌دار در حال ساخت است. تقسیم ادامهٔ هدف‌ها به واحد و درس باید هم‌زمان با تکمیل منابع و بر اساس پیش‌نیاز و بار شناختی ادامه پیدا کند.'),notes='A1 همچنان در مرحلهٔ ساخت تدریجی است. واحد نخست در بازبینی است. واحد دوم خانواده اکنون یک درس منبع‌دار دارد که نام و سن برادر، چهار واژهٔ اصلی خانواده و اطلاعات ساده دربارهٔ خواهر را پوشش می‌دهد؛ قدم بعد گسترش کنترل‌شدهٔ همین واحد به مادر و پدر و دیگر اطلاعات سادهٔ منبع‌دار است.' WHERE id=@level;
COMMIT;
