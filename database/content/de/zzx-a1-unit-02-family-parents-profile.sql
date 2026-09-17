-- German A1 Unit 2 — parents profile lesson. Base content preserves generated audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-family-and-close-people' LIMIT 1);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@src,'srcitem-de-a1-family-mother-age-q','277','پاسخ تمرین ۲۷۷','Wie alt ist eure Mutter?',UNHEX(SHA2('Wie alt ist eure Mutter?',256)),'پرسش سن مادر.'),
(@src,'srcitem-de-a1-family-mother-age','277','پاسخ تمرین ۲۷۷','Unsere Mutter ist 66 Jahre alt.',UNHEX(SHA2('Unsere Mutter ist 66 Jahre alt.',256)),'پاسخ سن مادر.'),
(@src,'srcitem-de-a1-family-father-age-q','277','پاسخ تمرین ۲۷۷','Wie alt ist euer Vater?',UNHEX(SHA2('Wie alt ist euer Vater?',256)),'پرسش سن پدر.'),
(@src,'srcitem-de-a1-family-father-age','277','پاسخ تمرین ۲۷۷','Unser Vater ist 56 Jahre alt.',UNHEX(SHA2('Unser Vater ist 56 Jahre alt.',256)),'پاسخ سن پدر.'),
(@src,'srcitem-de-a1-family-father-job-q','277','پاسخ تمرین ۲۷۷','Was ist euer Vater?',UNHEX(SHA2('Was ist euer Vater?',256)),'پرسش شغل پدر.'),
(@src,'srcitem-de-a1-family-father-job','277','پاسخ تمرین ۲۷۷','Unser Vater ist Lehrer.',UNHEX(SHA2('Unser Vater ist Lehrer.',256)),'پاسخ شغل پدر.')
ON DUPLICATE KEY UPDATE source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status)
VALUES('lex-de-lehrer',@de,'word','Lehrer','Lehrer','Lehrer','noun','اسم','A1','معلم مرد','در جملهٔ منبع‌دار مربوط به شغل پدر به کار می‌رود.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);
SET @x_mutter := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-mutter');
SET @x_vater := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-vater');
SET @x_bruder := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bruder');
SET @x_schwester := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-schwester');
SET @x_lehrer := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-lehrer');
SET @t_family := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-family' LIMIT 1);
SET @t_family_sit := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-family' LIMIT 1);
SET @t_personal := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-personal-info' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);

INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-family-parents-profile',@level,@unit,4,2,'مادر و پدرتان چند ساله‌اند؟','Wie alt ist eure Mutter? / Wie alt ist euer Vater?','مادرتان چند ساله است؟ / پدرتان چند ساله است؟','draft','گفت‌وگوی آغازین سن مادر و پدر را در همان بافت خانوادگی تثبیت می‌کند؛ سپس پرسش شغل پدر بازسازی می‌شود، پاسخ شغلی از جمله‌های منبع‌دار تشخیص داده می‌شود و در پایان چهار اطلاعات خانوادگی به فرد درست وصل می‌شوند.','درس از فهم سن دو عضو خانواده به بازیابی پرسش شغل، تشخیص پاسخ و یکپارچه‌سازی اطلاعات چند عضو می‌رود؛ بنابراین مهارت‌های آشنای اطلاعات شخصی به شبکهٔ خانوادگی منتقل می‌شوند.','conversation_speaking>word_order>multiple_choice>matching','blocked_until_level_final','درس دوم واحد خانواده؛ مادر و پدر و شغل پدر را با همان بافت جمع منبع پوشش می‌دهد.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-family-parents-profile');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES(@lesson,@t_family,'practice'),(@lesson,@t_family_sit,'practice'),(@lesson,@t_personal,'review'),(@lesson,@t_core,'practice'),(@lesson,@t_questions,'practice');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES(@lesson,@x_mutter,TRUE,'practice'),(@lesson,@x_vater,TRUE,'practice'),(@lesson,@x_bruder,FALSE,'review'),(@lesson,@x_schwester,FALSE,'review'),(@lesson,@x_lehrer,TRUE,'introduce');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES('dlg-de-a1-family-parents-profile',@level,'آیریس در حضور پاول و میا دربارهٔ سن مادر و پدر مشترکشان می‌پرسد و پاول از طرف هر دو پاسخ می‌دهد.','app','دو جفت پرسش و پاسخ سن مادر و پدر عیناً از پاسخ تمرین ۲۷۷ آمده‌اند. همان صحنهٔ خواهر و برادری پاول و میا حفظ می‌شود تا خطاب و پاسخ جمع منبع بدون تغییر طبیعی بماند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dialogue := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-family-parents-profile');
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-family-parents-1',@dialogue,1,@iris,'app_assigned','unspecified','Wie alt ist eure Mutter?','مادرتان چند ساله است؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-family-parents-2',@dialogue,2,@paul,'app_assigned','unspecified','Unsere Mutter ist 66 Jahre alt.','مادر ما ۶۶ ساله است.',TRUE,'blocked_until_level_final'),
('turn-de-a1-family-parents-3',@dialogue,3,@iris,'app_assigned','unspecified','Wie alt ist euer Vater?','پدرتان چند ساله است؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-family-parents-4',@dialogue,4,@paul,'app_assigned','unspecified','Unser Vater ist 56 Jahre alt.','پدر ما ۵۶ ساله است.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);

INSERT INTO lexeme_occurrences(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-a1-family-parents-1','dialogue_turn','turn-de-a1-family-parents-1','Mutter',NULL,NULL,@x_mutter,NULL,'approved','واژهٔ مادر در پرسش منبع‌دار.'),
('occ-turn-de-a1-family-parents-2','dialogue_turn','turn-de-a1-family-parents-2','Mutter',NULL,NULL,@x_mutter,NULL,'approved','واژهٔ مادر در پاسخ منبع‌دار.'),
('occ-turn-de-a1-family-parents-3','dialogue_turn','turn-de-a1-family-parents-3','Vater',NULL,NULL,@x_vater,NULL,'approved','واژهٔ پدر در پرسش منبع‌دار.'),
('occ-turn-de-a1-family-parents-4','dialogue_turn','turn-de-a1-family-parents-4','Vater',NULL,NULL,@x_vater,NULL,'approved','واژهٔ پدر در پاسخ منبع‌دار.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-family-parents-conversation',@lesson,1,'conversation_speaking','آیریس دربارهٔ سن مادر و پدرتان می‌پرسد؛ از طرف خودت و میا جواب بده.','دو جفت پرسش و پاسخ سن عین منبع هستند و با حضور دو خواهر و برادر، خطاب و پاسخ جمع بدون بازنویسی طبیعی می‌ماند.',@dialogue,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('other','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-family-father-job-order',@lesson,2,'word_order','پرسش شغل پدر را دوباره بساز.','پرسش شغل از همان تمرین خانواده می‌آید و اطلاعات کاری آموخته‌شده در واحد قبل را به یک عضو خانواده منتقل می‌کند.',NULL,JSON_OBJECT('sourceText','Was ist euer Vater?','sourceTextFa','شغل پدرتان چیست؟','tokens',JSON_ARRAY('Was','ist','euer','Vater?'),'answer',JSON_ARRAY('Was','ist','euer','Vater?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'),
('act-de-a1-family-father-job-choice',@lesson,3,'multiple_choice','طبق منبع، شغل پدرشان چیست؟','پاسخ درست دربارهٔ شغل پدر در برابر دو جملهٔ خانوادگی منبع‌دار با اطلاعات متفاوت بازیابی می‌شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Unser Vater ist Lehrer.','translationFa','پدر ما معلم است.','correct',TRUE),JSON_OBJECT('textTarget','Unser Bruder heißt Uwe.','translationFa','اسم برادر ما اووه است.','correct',FALSE),JSON_OBJECT('textTarget','Unsere Schwester wohnt in Hamburg.','translationFa','خواهر ما در هامبورگ زندگی می‌کند.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-family-info-matching',@lesson,4,'matching','هر جمله را به اطلاعات درست خانواده وصل کن.','چهار جملهٔ منبع‌دار نام، سن و محل زندگی را میان اعضای خانواده تفکیک می‌کنند و فهم کلی واحد را جمع می‌کنند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Unsere Mutter ist 66 Jahre alt.','leftFa','مادر ما ۶۶ ساله است.','right','سن مادر','rightFa','سن مادر'),JSON_OBJECT('left','Unser Vater ist 56 Jahre alt.','leftFa','پدر ما ۵۶ ساله است.','right','سن پدر','rightFa','سن پدر'),JSON_OBJECT('left','Unser Bruder heißt Uwe.','leftFa','اسم برادر ما اووه است.','right','نام برادر','rightFa','نام برادر'),JSON_OBJECT('left','Unsere Schwester wohnt in Hamburg.','leftFa','خواهر ما در هامبورگ زندگی می‌کند.','right','محل زندگی خواهر','rightFa','محل زندگی خواهر'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-parents-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-father-job-order');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-father-job-choice');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-a1-family-info-matching');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES(@a1,@t_family),(@a1,@t_family_sit),(@a2,@t_questions),(@a2,@t_family),(@a3,@t_family),(@a3,@t_core),(@a4,@t_family),(@a4,@t_personal);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a1,@x_mutter),(@a1,@x_vater),(@a2,@x_vater),(@a3,@x_vater),(@a3,@x_lehrer),(@a3,@x_bruder),(@a3,@x_schwester),(@a4,@x_mutter),(@a4,@x_vater),(@a4,@x_bruder),(@a4,@x_schwester);

SET @si_mother_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-mother-age-q');
SET @si_mother_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-mother-age');
SET @si_father_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-father-age-q');
SET @si_father_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-father-age');
SET @si_job_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-father-job-q');
SET @si_job_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-father-job');
SET @si_name_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-brother-name-a');
SET @si_sister_home := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-family-sister-home');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-family-parents-1',@si_mother_q,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-family-parents-2',@si_mother_a,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-family-parents-3',@si_father_q,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-family-parents-4',@si_father_a,'verbatim','متن هدف عین منبع است.'),
('lexeme','lex-de-lehrer',@si_job_a,'other','واژهٔ شغل از پاسخ منبع‌دار استخراج شده است.'),
('activity','act-de-a1-family-father-job-order',@si_job_q,'sentence_tokenized_for_word_order','پرسش عین منبع برای مرتب‌سازی بخش‌بندی شده است.'),
('activity','act-de-a1-family-father-job-choice',@si_job_a,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-family-father-job-choice',@si_name_a,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-family-father-job-choice',@si_sister_home,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-family-info-matching',@si_mother_a,'source_items_grouped_for_matching','جملهٔ منبع در تطبیق استفاده شده است.'),
('activity','act-de-a1-family-info-matching',@si_father_a,'source_items_grouped_for_matching','جملهٔ منبع در تطبیق استفاده شده است.'),
('activity','act-de-a1-family-info-matching',@si_name_a,'source_items_grouped_for_matching','جملهٔ منبع در تطبیق استفاده شده است.'),
('activity','act-de-a1-family-info-matching',@si_sister_home,'source_items_grouped_for_matching','جملهٔ منبع در تطبیق استفاده شده است.');

UPDATE language_levels SET coverage=JSON_SET(coverage,'$.gaps[2]','توالی آموزشی اولیه ثبت شده است؛ واحد نخست به بازبینی رسیده و واحد دوم خانواده دو درس منبع‌دار دارد و اکنون باید از نظر کفایت پوشش ارزیابی شود.'),notes='A1 همچنان در مرحلهٔ ساخت تدریجی است. واحد نخست در بازبینی است. واحد دوم خانواده اکنون دو درس منبع‌دار دارد و پدر، مادر، برادر، خواهر و اطلاعات سادهٔ نام، سن، محل زندگی و شغل را پوشش می‌دهد؛ قدم بعد ارزیابی شکاف‌های ضروری این واحد پیش از ساخت هر درس اضافه است.' WHERE id=@level;
COMMIT;
