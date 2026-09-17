-- German A1 Unit 4 — school and afternoon routine lesson; then close Unit 4 for review.
-- Base content never overwrites generated audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-daily-routine-work-school' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @max := (SELECT id FROM characters WHERE character_key='char-de-max' LIMIT 1);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
SET @t_routine := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-work-school-routine' LIMIT 1);
SET @t_routine_sit := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-work-school' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);
SET @t_present := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-present-verbs' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@src,'srcitem-de-a1-routine-school','936','پاسخ ۹۳۶','Vormittags gehe ich in die Schule.',UNHEX(SHA2('Vormittags gehe ich in die Schule.',256)),'پاسخ دربارهٔ مدرسه.'),
(@src,'srcitem-de-a1-routine-afternoon-q','936','بخش ۹۳۶','Was machen Sie nachmittags?',UNHEX(SHA2('Was machen Sie nachmittags?',256)),'پرسش دربارهٔ بعدازظهر.'),
(@src,'srcitem-de-a1-word-schule','936','پاسخ ۹۳۶','Schule',UNHEX(SHA2('Schule',256)),'واژهٔ مدرسه.'),
(@src,'srcitem-de-a1-word-gehen','936','بخش ۹۳۶','gehen',UNHEX(SHA2('gehen',256)),'فعل رفتن.'),
(@src,'srcitem-de-a1-phrase-nach-hause','936','پاسخ ۹۳۶','nach Hause',UNHEX(SHA2('nach Hause',256)),'عبارت رفتن به خانه.')
ON DUPLICATE KEY UPDATE source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-schule',@de,'word','Schule','Schule','Schule','noun','اسم','A1','مدرسه','برای اشارهٔ ساده به مدرسه در برنامهٔ روزانه استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-gehen',@de,'word','gehen','gehen','gehen','verb','فعل','A1','رفتن','برای بیان رفتن به مدرسه، خانه یا یک مکان در روتین روزانه استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-nach-hause',@de,'phrase','nach Hause','nach Hause',NULL,NULL,NULL,'A1','به خانه','در این سطح به‌صورت یک عبارت کاربردی برای برگشتن یا رفتن به خانه یاد گرفته می‌شود.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);
SET @x_schule := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-schule');
SET @x_gehen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-gehen');
SET @x_nach_hause := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-nach-hause');
SET @x_vormittags := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-vormittags');
SET @x_nachmittags := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-nachmittags');
SET @x_machen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-machen');
SET @x_arbeiten := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-arbeiten');
SET @x_betrieb := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-betrieb');
SET @x_essen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-essen');
SET @x_morgens := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-morgens');
SET @x_mittags := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-mittags');
SET @x_trinken := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-trinken');
SET @x_kaffee := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kaffee');
INSERT INTO lexeme_forms(lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes) VALUES
('lexform-de-gehen-gehe',@x_gehen,'gehe','gehe','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','در پاسخ‌های منبع‌دار مربوط به مدرسه و برگشتن به خانه، فعل رفتن به‌صورت اول‌شخص مفرد زمان حال آمده است.')
ON DUPLICATE KEY UPDATE lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);
SET @f_gehe := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-gehen-gehe');
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-a1-lesson-daily-routine-school',@level,@unit,8,2,'مدرسه و برگشت به خانه','Was machen Sie vormittags? / Was machen Sie nachmittags?','پیش از ظهرها چه کار می‌کنید؟ / بعدازظهرها چه کار می‌کنید؟','draft','گفت‌وگوی چهار نوبتی مدرسه و برگشت به خانه را در دو بخش روز وارد می‌کند؛ سپس جملهٔ مدرسه از گزینه‌های منبع‌دار جدا می‌شود، همان جمله بازسازی می‌شود و در پایان زبان‌آموز پاسخ درست پرسش بعدازظهر را انتخاب می‌کند.','درس از تعامل به تمایز معنایی، بازیابی فعال جمله و انتخاب پاسخ مناسب در بافت می‌رود؛ بنابراین پس از درس قبلی به‌جای تکرار تطبیق زمان‌ها روی مدرسه و حرکت روزانه تمرکز می‌کند.','conversation_speaking>multiple_choice>word_order>choose_response','blocked_until_level_final','درس دوم واحد روتین روزانه؛ مدرسه و برگشت به خانه را با جفت‌های عین منبع پوشش می‌دهد.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-daily-routine-school');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES(@lesson,@t_routine,'practice'),(@lesson,@t_routine_sit,'practice'),(@lesson,@t_core,'introduce'),(@lesson,@t_questions,'practice'),(@lesson,@t_present,'practice');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES(@lesson,@x_schule,TRUE,'introduce'),(@lesson,@x_gehen,TRUE,'introduce'),(@lesson,@x_nach_hause,TRUE,'introduce'),(@lesson,@x_vormittags,FALSE,'review'),(@lesson,@x_nachmittags,FALSE,'review'),(@lesson,@x_machen,FALSE,'review'),(@lesson,@x_arbeiten,FALSE,'review'),(@lesson,@x_betrieb,FALSE,'review'),(@lesson,@x_essen,FALSE,'review');
INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-a1-daily-routine-school',@level,'آیریس در یک گفت‌وگوی مؤدبانه از مکس دربارهٔ برنامهٔ پیش از ظهر و بعدازظهر می‌پرسد؛ مکس دربارهٔ رفتن به مدرسه و برگشتن به خانه جواب می‌دهد.','app','دو جفت پرسش و پاسخ بخش ۹۳۶ عیناً حفظ شده‌اند. سن مکس با موقعیت مدرسه سازگار است و خطاب رسمی منبع در قالب یک گفت‌وگوی مؤدبانه طبیعی باقی می‌ماند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dialogue := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-daily-routine-school');
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-daily-routine-school-1',@dialogue,1,@iris,'app_assigned','unspecified','Was machen Sie vormittags?','پیش از ظهرها چه کار می‌کنید؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-daily-routine-school-2',@dialogue,2,@max,'app_assigned','unspecified','Vormittags gehe ich in die Schule.','پیش از ظهرها به مدرسه می‌روم.',TRUE,'blocked_until_level_final'),
('turn-de-a1-daily-routine-school-3',@dialogue,3,@iris,'app_assigned','unspecified','Was machen Sie nachmittags?','بعدازظهرها چه کار می‌کنید؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-daily-routine-school-4',@dialogue,4,@max,'app_assigned','unspecified','Nachmittags gehe ich nach Hause.','بعدازظهرها به خانه می‌روم.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-daily-school-conversation',@lesson,1,'conversation_speaking','به آیریس بگو پیش از ظهر و بعدازظهر چه کار می‌کنی.','دو جفت پرسش و پاسخ منبع‌دار، مدرسه و برگشت به خانه را در یک توالی روزانهٔ کوتاه قرار می‌دهند.',@dialogue,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('verbatim_dialogue','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-school-sentence-choice',@lesson,2,'multiple_choice','کدام جمله می‌گوید فرد پیش از ظهر به مدرسه می‌رود؟','سه پاسخ کامل از همان منبع، مدرسه را از کار و غذا خوردن جدا می‌کنند.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Vormittags gehe ich in die Schule.','translationFa','پیش از ظهرها به مدرسه می‌روم.','correct',TRUE),JSON_OBJECT('textTarget','Vormittags arbeite ich im Betrieb.','translationFa','پیش از ظهرها در محل کار کار می‌کنم.','correct',FALSE),JSON_OBJECT('textTarget','Mittags esse ich in einem Restaurant.','translationFa','ظهرها در یک رستوران غذا می‌خورم.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-school-sentence-order',@lesson,3,'word_order','جملهٔ رفتن به مدرسه را دوباره بساز.','پس از تشخیص معنایی، پاسخ مدرسه به بازیابی فعال منتقل می‌شود.',NULL,JSON_OBJECT('sourceText','Vormittags gehe ich in die Schule.','sourceTextFa','پیش از ظهرها به مدرسه می‌روم.','tokens',JSON_ARRAY('Vormittags','gehe','ich','in','die','Schule.'),'answer',JSON_ARRAY('Vormittags','gehe','ich','in','die','Schule.')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'),
('act-de-a1-afternoon-response-choice',@lesson,4,'choose_response','برای پرسش بعدازظهر، پاسخ درست را انتخاب کن.','زبان‌آموز باید پاسخ متناسب با همان پرسش زمانی را از میان پاسخ‌های واقعی منبع پیدا کند.',NULL,JSON_OBJECT('promptTarget','Was machen Sie nachmittags?','promptFa','بعدازظهرها چه کار می‌کنید؟','options',JSON_ARRAY(JSON_OBJECT('textTarget','Nachmittags gehe ich nach Hause.','translationFa','بعدازظهرها به خانه می‌روم.','correct',TRUE),JSON_OBJECT('textTarget','Morgens trinke ich Kaffee.','translationFa','صبح‌ها قهوه می‌نوشم.','correct',FALSE),JSON_OBJECT('textTarget','Mittags esse ich in einem Restaurant.','translationFa','ظهرها در یک رستوران غذا می‌خورم.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-a1-daily-school-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-a1-school-sentence-choice');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-a1-school-sentence-order');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-a1-afternoon-response-choice');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES(@a1,@t_routine),(@a1,@t_routine_sit),(@a1,@t_questions),(@a1,@t_present),(@a2,@t_routine),(@a2,@t_core),(@a3,@t_routine),(@a3,@t_present),(@a4,@t_routine),(@a4,@t_questions);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a1,@x_machen),(@a1,@x_vormittags),(@a1,@x_nachmittags),(@a1,@x_gehen),(@a1,@x_schule),(@a1,@x_nach_hause),(@a2,@x_vormittags),(@a2,@x_gehen),(@a2,@x_schule),(@a2,@x_arbeiten),(@a2,@x_betrieb),(@a2,@x_essen),(@a3,@x_vormittags),(@a3,@x_gehen),(@a3,@x_schule),(@a4,@x_nachmittags),(@a4,@x_gehen),(@a4,@x_nach_hause),(@a4,@x_morgens),(@a4,@x_trinken),(@a4,@x_kaffee),(@a4,@x_mittags),(@a4,@x_essen);
INSERT INTO lexeme_occurrences(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-a1-school-1-machen','dialogue_turn','turn-de-a1-daily-routine-school-1','machen',NULL,NULL,@x_machen,NULL,'approved','اتصال فعل پرسش تأیید شده است.'),
('occ-turn-de-a1-school-1-vormittags','dialogue_turn','turn-de-a1-daily-routine-school-1','vormittags',NULL,NULL,@x_vormittags,NULL,'approved','اتصال قید زمان تأیید شده است.'),
('occ-turn-de-a1-school-2-vormittags','dialogue_turn','turn-de-a1-daily-routine-school-2','Vormittags',NULL,NULL,@x_vormittags,NULL,'approved','اتصال قید زمان تأیید شده است.'),
('occ-turn-de-a1-school-2-gehe','dialogue_turn','turn-de-a1-daily-routine-school-2','gehe',NULL,NULL,@x_gehen,@f_gehe,'approved','صورت صرفی به فعل رفتن متصل است.'),
('occ-turn-de-a1-school-2-schule','dialogue_turn','turn-de-a1-daily-routine-school-2','Schule',NULL,NULL,@x_schule,NULL,'approved','اتصال واژهٔ مدرسه تأیید شده است.'),
('occ-turn-de-a1-school-3-machen','dialogue_turn','turn-de-a1-daily-routine-school-3','machen',NULL,NULL,@x_machen,NULL,'approved','اتصال فعل پرسش تأیید شده است.'),
('occ-turn-de-a1-school-3-nachmittags','dialogue_turn','turn-de-a1-daily-routine-school-3','nachmittags',NULL,NULL,@x_nachmittags,NULL,'approved','اتصال قید زمان تأیید شده است.'),
('occ-turn-de-a1-school-4-nachmittags','dialogue_turn','turn-de-a1-daily-routine-school-4','Nachmittags',NULL,NULL,@x_nachmittags,NULL,'approved','اتصال قید زمان تأیید شده است.'),
('occ-turn-de-a1-school-4-gehe','dialogue_turn','turn-de-a1-daily-routine-school-4','gehe',NULL,NULL,@x_gehen,@f_gehe,'approved','صورت صرفی به فعل رفتن متصل است.'),
('occ-turn-de-a1-school-4-home','dialogue_turn','turn-de-a1-daily-routine-school-4','nach Hause',NULL,NULL,@x_nach_hause,NULL,'approved','عبارت کاربردی رفتن به خانه به‌صورت یک واحد ثبت شده است.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);
SET @si_q_vormittag := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-routine-late-morning-q');
SET @si_school := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-routine-school');
SET @si_q_afternoon := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-routine-afternoon-q');
SET @si_home := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-routine-afternoon-home');
SET @si_work := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-routine-late-morning-work');
SET @si_mid := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-routine-midday-restaurant');
SET @si_morning := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-routine-morning-coffee');
SET @si_schule := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-schule');
SET @si_gehen := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-word-gehen');
SET @si_nach_hause := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-phrase-nach-hause');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-daily-routine-school-1',@si_q_vormittag,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-daily-routine-school-2',@si_school,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-daily-routine-school-3',@si_q_afternoon,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-daily-routine-school-4',@si_home,'verbatim','متن هدف عین منبع است.'),
('lexeme','lex-de-schule',@si_schule,'verbatim','صورت واژه در منبع ثبت شده است.'),
('lexeme','lex-de-gehen',@si_gehen,'verbatim','صورت پایهٔ فعل در منبع ثبت شده است.'),
('lexeme','lex-de-nach-hause',@si_nach_hause,'verbatim','عبارت عین منبع ثبت شده است.'),
('lexeme_form','lexform-de-gehen-gehe',@si_school,'other','صورت صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('activity','act-de-a1-school-sentence-choice',@si_school,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-school-sentence-choice',@si_work,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-school-sentence-choice',@si_mid,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-school-sentence-order',@si_school,'sentence_tokenized_for_word_order','جملهٔ عین منبع برای مرتب‌سازی بخش‌بندی شده است.'),
('activity','act-de-a1-afternoon-response-choice',@si_q_afternoon,'other','پرسش فعالیت عین منبع است.'),
('activity','act-de-a1-afternoon-response-choice',@si_home,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-afternoon-response-choice',@si_morning,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-afternoon-response-choice',@si_mid,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.');
UPDATE units SET status='review',notes='بازبینی پوشش انجام شد. دو درس موجود صبح، پیش از ظهر، ظهر و بعدازظهر، کار در محل کار، رفتن به مدرسه و برگشت به خانه را پوشش می‌دهند. برنامه و قرار دقیق‌تر در واحد مستقل زمان و برنامه ادامه پیدا می‌کند؛ برای هدف فعلی این واحد شکاف ضروری مستقلی برای درس سوم پیدا نشد.' WHERE id=@unit AND status <> 'final';
UPDATE language_levels SET coverage=JSON_SET(coverage,'$.gaps[2]','چهار واحد نخست به بازبینی رسیده‌اند؛ مرحلهٔ بعد ساخت خرید واقعی‌تر با تمرکز بر کالا، مقدار و پرداخت است.'),notes='A1 همچنان در مرحلهٔ ساخت تدریجی است. چهار واحد نخست در بازبینی‌اند. مرحلهٔ بعد خرید واقعی‌تر است و باید پیش از ساخت درس، منبع قابل‌بازاستفاده برای کالا، مقدار و پرداخت ثبت شود.' WHERE id=@level;
COMMIT;
