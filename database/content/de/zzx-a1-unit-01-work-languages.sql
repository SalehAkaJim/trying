-- German A1 Unit 1 — work and languages lesson
-- Runs after character bootstrap. Base content never overwrites generated audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-extended-introduction' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);
SET @src1 := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-1' LIMIT 1);

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes)
VALUES('src-wikibooks-bll-a1-lesson-2','BLL German/A1/Lesson 2','پرسیدن دربارهٔ شغل و زبان‌های در حال یادگیری','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/BLL_German/A1/Lesson_2','Exercises and answers: asking about profession and languages being learned; items around the dialogue snippets in the exercise section.','بخش تمرین‌ها و پاسخ‌ها؛ جفت پرسش و پاسخ دربارهٔ شغل و زبان‌هایی که فرد یاد می‌گیرد.','2025-10-18','contemporary_verified','صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ دوباره بررسی شد. آخرین ویرایش ثبت‌شدهٔ آن ۱۸ اکتبر ۲۰۲۵ است و الگوهای مؤدبانهٔ پرسیدن دربارهٔ شغل و زبان‌های در حال یادگیری با آلمانی معیار معاصر سازگارند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — BLL German/A1/Lesson 2','reuse_with_attribution','2026-09-17','برای درس دوم A1 فقط جفت‌های پرسش و پاسخ مربوط به شغل و زبان‌های در حال یادگیری استفاده می‌شوند. صورت «Fremdenführer(in)» در منبع برای انتخاب جنسیت آمده است؛ در گفت‌وگوی برنامه، شکل مردانهٔ «Fremdenführer» برای پاول انتخاب می‌شود و این تبدیل در provenance ثبت می‌شود.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @src2 := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@src2,'srcitem-de-a1-work-question','exercise answer','پاسخ تمرین شغل','Arbeiten Sie als Fremdenführer(in)?',UNHEX(SHA2('Arbeiten Sie als Fremdenführer(in)?',256)),'منبع شکل مردانه و زنانه را با نشانهٔ اختیاری نشان می‌دهد.'),
(@src2,'srcitem-de-a1-work-answer','exercise answer','پاسخ تمرین شغل','Nein, ich arbeite als Journalist.',UNHEX(SHA2('Nein, ich arbeite als Journalist.',256)),'پاسخ دربارهٔ شغل.'),
(@src2,'srcitem-de-a1-language-question','exercise answer','پاسخ تمرین زبان','Welche Sprachen lernen Sie?',UNHEX(SHA2('Welche Sprachen lernen Sie?',256)),'پرسش دربارهٔ زبان‌های در حال یادگیری.'),
(@src2,'srcitem-de-a1-language-answer','exercise answer','پاسخ تمرین زبان','Ich lerne Deutsch und Französisch.',UNHEX(SHA2('Ich lerne Deutsch und Französisch.',256)),'پاسخ دربارهٔ زبان‌های در حال یادگیری.'),
(@src1,'srcitem-de-a1-speak-languages','extension','بخش تکمیلی','Ich spreche Englisch und Französisch.',UNHEX(SHA2('Ich spreche Englisch und Französisch.',256)),'جملهٔ منبع‌دار دربارهٔ زبان‌هایی که فرد صحبت می‌کند.'),
(@src1,'srcitem-de-a1-learn-german','extension','بخش تکمیلی','Ich lerne Deutsch.',UNHEX(SHA2('Ich lerne Deutsch.',256)),'جملهٔ منبع‌دار دربارهٔ یادگیری آلمانی.')
ON DUPLICATE KEY UPDATE source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-arbeiten',@de,'word','arbeiten','arbeiten','arbeiten','verb','فعل','A1','کار کردن','برای گفتن محل یا نوع کار در معرفی ساده استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-lernen',@de,'word','lernen','lernen','lernen','verb','فعل','A1','یاد گرفتن / یادگیری کردن','برای گفتن زبانی که فرد در حال یادگیری آن است.',TRUE,'blocked_until_level_final'),
('lex-de-sprechen',@de,'word','sprechen','sprechen','sprechen','verb','فعل','A1','صحبت کردن / سخن گفتن','برای گفتن زبان‌هایی که فرد به آن‌ها صحبت می‌کند.',TRUE,'blocked_until_level_final'),
('lex-de-sprache',@de,'word','Sprache','Sprache','Sprache','noun','اسم','A1','زبان','در پرسش زبان به شکل جمع Sprachen آمده است.',TRUE,'blocked_until_level_final'),
('lex-de-journalist',@de,'word','Journalist','Journalist','Journalist','noun','اسم','A1','روزنامه‌نگار مرد','در پاسخ منبع‌دار شغل آمده است.',TRUE,'blocked_until_level_final'),
('lex-de-fremdenfuhrer',@de,'word','Fremdenführer','Fremdenführer','Fremdenführer','noun','اسم','A1','راهنمای گردشگری مرد','شکل مردانهٔ شغل راهنمای گردشگری.',TRUE,'blocked_until_level_final'),
('lex-de-deutsch',@de,'word','Deutsch','Deutsch','Deutsch','noun','اسم','A1','زبان آلمانی','نام زبان آلمانی.',TRUE,'blocked_until_level_final'),
('lex-de-franzosisch',@de,'word','Französisch','Französisch','Französisch','noun','اسم','A1','زبان فرانسوی','نام زبان فرانسوی.',TRUE,'blocked_until_level_final'),
('lex-de-englisch',@de,'word','Englisch','Englisch','Englisch','noun','اسم','A1','زبان انگلیسی','نام زبان انگلیسی.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);

SET @x_arbeiten := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-arbeiten');
SET @x_lernen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-lernen');
SET @x_sprechen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-sprechen');
SET @x_sprache := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-sprache');
SET @x_journalist := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-journalist');
SET @x_fremdenfuhrer := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-fremdenfuhrer');
SET @x_deutsch := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-deutsch');
SET @x_franzosisch := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-franzosisch');
SET @x_englisch := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-englisch');

INSERT INTO lexeme_forms(lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes) VALUES
('lexform-de-arbeiten-arbeite',@x_arbeiten,'arbeite','arbeite','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','اول‌شخص مفرد حال در جملهٔ منبع‌دار.'),
('lexform-de-lernen-lerne',@x_lernen,'lerne','lerne','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','اول‌شخص مفرد حال در جملهٔ منبع‌دار.'),
('lexform-de-sprechen-spreche',@x_sprechen,'spreche','spreche','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','اول‌شخص مفرد حال در جملهٔ منبع‌دار.'),
('lexform-de-sprache-sprachen',@x_sprache,'Sprachen','Sprachen','inflected',JSON_OBJECT('number','plural'),'source_attested','approved','شکل جمع Sprache در پرسش منبع‌دار.')
ON DUPLICATE KEY UPDATE lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);
SET @f_arbeite := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-arbeiten-arbeite');
SET @f_lerne := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-lernen-lerne');
SET @f_spreche := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-sprechen-spreche');
SET @f_sprachen := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-sprache-sprachen');

SET @t_work := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-work-school-routine' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);
SET @t_intro := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-introductions' LIMIT 1);

INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES('de-a1-lesson-work-and-languages',@level,@unit,2,2,'کارت چیه؟ چه زبانی یاد می‌گیری؟','Arbeiten Sie ...? / Welche Sprachen lernen Sie?','چه کاری می‌کنید؟ / چه زبان‌هایی یاد می‌گیرید؟','draft','گفت‌وگوی چهار نوبتی شغل و زبان‌های در حال یادگیری را در یک تعامل مؤدبانه می‌آورد؛ سپس تفاوت صحبت‌کردن، یادگیری و کار با جمله‌های منبع‌دار سنجیده می‌شود و در پایان پرسش زبان بازسازی می‌شود.','درس از تعامل و فهم بافت به تمایز معنایی سه فعل، دسته‌بندی جمله‌ها و بازیابی فعال پرسش حرکت می‌کند؛ بنابراین نسبت به Lesson اول الگوی فعالیت متفاوتی دارد.','conversation_speaking>multiple_choice>matching>word_order','blocked_until_level_final','درس دوم Unit نخست؛ تمام متن‌های آلمانی زبان‌آموز از دو منبع Wikibooks ثبت‌شده می‌آیند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-work-and-languages');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES(@lesson,@t_work,'introduce'),(@lesson,@t_core,'introduce'),(@lesson,@t_questions,'practice'),(@lesson,@t_intro,'practice');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES(@lesson,@x_arbeiten,TRUE,'introduce'),(@lesson,@x_lernen,TRUE,'introduce'),(@lesson,@x_sprechen,TRUE,'introduce'),(@lesson,@x_sprache,TRUE,'introduce'),(@lesson,@x_journalist,TRUE,'introduce'),(@lesson,@x_fremdenfuhrer,FALSE,'practice'),(@lesson,@x_deutsch,TRUE,'introduce'),(@lesson,@x_franzosisch,TRUE,'introduce'),(@lesson,@x_englisch,TRUE,'introduce');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES('dlg-de-a1-work-and-languages',@level,'آیریس در یک آشنایی مؤدبانه از پاول دربارهٔ شغل و زبان‌هایی که یاد می‌گیرد می‌پرسد.','app','دو جفت پرسش و پاسخ از بخش پاسخ‌های منبع در یک سناریوی واحدِ آشنایی مؤدبانه کنار هم قرار گرفته‌اند. تنها تبدیل زبانی، حل نشانهٔ اختیاری «(in)» و انتخاب شکل مردانهٔ Fremdenführer برای پاول است؛ بقیهٔ متن هدف عین منبع است.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dialogue := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-work-and-languages');
INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-work-language-1',@dialogue,1,@iris,'app_assigned','unspecified','Arbeiten Sie als Fremdenführer?','آیا به‌عنوان راهنمای گردشگری کار می‌کنید؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-work-language-2',@dialogue,2,@paul,'app_assigned','unspecified','Nein, ich arbeite als Journalist.','نه، من به‌عنوان روزنامه‌نگار کار می‌کنم.',TRUE,'blocked_until_level_final'),
('turn-de-a1-work-language-3',@dialogue,3,@iris,'app_assigned','unspecified','Welche Sprachen lernen Sie?','چه زبان‌هایی یاد می‌گیرید؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-work-language-4',@dialogue,4,@paul,'app_assigned','unspecified','Ich lerne Deutsch und Französisch.','من آلمانی و فرانسوی یاد می‌گیرم.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);

INSERT INTO lexeme_occurrences(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-a1-work-language-1-arbeiten','dialogue_turn','turn-de-a1-work-language-1','Arbeiten',NULL,NULL,@x_arbeiten,NULL,'approved','صورت پایه در پرسش رسمی.'),
('occ-turn-de-a1-work-language-1-fremdenfuhrer','dialogue_turn','turn-de-a1-work-language-1','Fremdenführer',NULL,NULL,@x_fremdenfuhrer,NULL,'approved','شکل مردانه از نشانهٔ اختیاری منبع انتخاب شده است.'),
('occ-turn-de-a1-work-language-2-arbeite','dialogue_turn','turn-de-a1-work-language-2','arbeite',NULL,NULL,@x_arbeiten,@f_arbeite,'approved','فرم اول‌شخص مفرد.'),
('occ-turn-de-a1-work-language-2-journalist','dialogue_turn','turn-de-a1-work-language-2','Journalist',NULL,NULL,@x_journalist,NULL,'approved','واژهٔ شغل.'),
('occ-turn-de-a1-work-language-3-sprachen','dialogue_turn','turn-de-a1-work-language-3','Sprachen',NULL,NULL,@x_sprache,@f_sprachen,'approved','شکل جمع Sprache.'),
('occ-turn-de-a1-work-language-3-lernen','dialogue_turn','turn-de-a1-work-language-3','lernen',NULL,NULL,@x_lernen,NULL,'approved','صورت پایه در پرسش رسمی.'),
('occ-turn-de-a1-work-language-4-lerne','dialogue_turn','turn-de-a1-work-language-4','lerne',NULL,NULL,@x_lernen,@f_lerne,'approved','فرم اول‌شخص مفرد.'),
('occ-turn-de-a1-work-language-4-deutsch','dialogue_turn','turn-de-a1-work-language-4','Deutsch',NULL,NULL,@x_deutsch,NULL,'approved','نام زبان.'),
('occ-turn-de-a1-work-language-4-franzosisch','dialogue_turn','turn-de-a1-work-language-4','Französisch',NULL,NULL,@x_franzosisch,NULL,'approved','نام زبان.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-work-language-conversation',@lesson,1,'conversation_speaking','با آیریس دربارهٔ شغل و زبان‌هایی که یاد می‌گیری صحبت کن.','دو جفت پرسش و پاسخ منبع‌دار یک گفت‌وگوی کوتاه و مؤدبانه می‌سازند و هدف تازه را بدون توضیح دستوری انتزاعی وارد می‌کنند.',@dialogue,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('dialogue_snippets_combined','optional_gender_marker_resolved','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-speak-learn-work-choice',@lesson,2,'multiple_choice','کدام جمله می‌گوید فرد انگلیسی و فرانسوی صحبت می‌کند؟','سه جملهٔ کامل و منبع‌دار، sprechen را از lernen و arbeiten جدا می‌کنند.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Ich spreche Englisch und Französisch.','translationFa','من انگلیسی و فرانسوی صحبت می‌کنم.','correct',TRUE),JSON_OBJECT('textTarget','Ich lerne Deutsch und Französisch.','translationFa','من آلمانی و فرانسوی یاد می‌گیرم.','correct',FALSE),JSON_OBJECT('textTarget','Nein, ich arbeite als Journalist.','translationFa','نه، من به‌عنوان روزنامه‌نگار کار می‌کنم.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-work-language-matching',@lesson,3,'matching','هر جمله را به کاری که انجام می‌دهد وصل کن.','چهار جملهٔ منبع‌دار نقش کار، یادگیری یک یا چند زبان و صحبت‌کردن به زبان‌ها را از هم جدا می‌کنند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Nein, ich arbeite als Journalist.','leftFa','نه، من به‌عنوان روزنامه‌نگار کار می‌کنم.','right','کار / شغل','rightFa','کار / شغل'),JSON_OBJECT('left','Ich lerne Deutsch und Französisch.','leftFa','من آلمانی و فرانسوی یاد می‌گیرم.','right','یادگیری دو زبان','rightFa','یادگیری دو زبان'),JSON_OBJECT('left','Ich spreche Englisch und Französisch.','leftFa','من انگلیسی و فرانسوی صحبت می‌کنم.','right','صحبت‌کردن به زبان‌ها','rightFa','صحبت‌کردن به زبان‌ها'),JSON_OBJECT('left','Ich lerne Deutsch.','leftFa','من آلمانی یاد می‌گیرم.','right','یادگیری یک زبان','rightFa','یادگیری یک زبان'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-a1-language-question-order',@lesson,4,'word_order','پرسش دربارهٔ زبان‌های در حال یادگیری را دوباره بساز.','در پایان، زبان‌آموز پرسش اصلی را از تشخیص به بازیابی فعال منتقل می‌کند.',NULL,JSON_OBJECT('sourceText','Welche Sprachen lernen Sie?','sourceTextFa','چه زبان‌هایی یاد می‌گیرید؟','tokens',JSON_ARRAY('Welche','Sprachen','lernen','Sie?'),'answer',JSON_ARRAY('Welche','Sprachen','lernen','Sie?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-a1-work-language-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-a1-speak-learn-work-choice');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-a1-work-language-matching');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-a1-language-question-order');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES(@a1,@t_work),(@a1,@t_intro),(@a2,@t_core),(@a3,@t_core),(@a4,@t_questions);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a1,@x_arbeiten),(@a1,@x_lernen),(@a1,@x_sprache),(@a1,@x_journalist),(@a1,@x_fremdenfuhrer),(@a1,@x_deutsch),(@a1,@x_franzosisch),(@a2,@x_sprechen),(@a2,@x_lernen),(@a2,@x_arbeiten),(@a2,@x_englisch),(@a2,@x_franzosisch),(@a2,@x_deutsch),(@a2,@x_journalist),(@a3,@x_sprechen),(@a3,@x_lernen),(@a3,@x_arbeiten),(@a3,@x_englisch),(@a3,@x_franzosisch),(@a3,@x_deutsch),(@a3,@x_journalist),(@a4,@x_sprache),(@a4,@x_lernen);

SET @si_work_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-work-question');
SET @si_work_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-work-answer');
SET @si_lang_q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-language-question');
SET @si_lang_a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-language-answer');
SET @si_speak := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-speak-languages');
SET @si_learn_de := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-learn-german');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-work-language-1',@si_work_q,'optional_gender_marker_resolved','نشانهٔ اختیاری «(in)» به شکل مردانهٔ مناسب پاول حل شده است.'),
('dialogue_turn','turn-de-a1-work-language-2',@si_work_a,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-work-language-3',@si_lang_q,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-work-language-4',@si_lang_a,'verbatim','متن هدف عین منبع است.'),
('lexeme','lex-de-arbeiten',@si_work_a,'other','واژه از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme','lex-de-lernen',@si_lang_a,'other','واژه از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme','lex-de-sprechen',@si_speak,'other','واژه از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme','lex-de-sprache',@si_lang_q,'other','واژه از پرسش منبع‌دار استخراج شده است.'),
('lexeme','lex-de-journalist',@si_work_a,'other','واژه از پاسخ منبع‌دار استخراج شده است.'),
('lexeme','lex-de-fremdenfuhrer',@si_work_q,'optional_gender_marker_resolved','شکل مردانه از صورت اختیاری منبع انتخاب شده است.'),
('lexeme','lex-de-deutsch',@si_lang_a,'other','نام زبان از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme','lex-de-franzosisch',@si_lang_a,'other','نام زبان از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme','lex-de-englisch',@si_speak,'other','نام زبان از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-arbeiten-arbeite',@si_work_a,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-lernen-lerne',@si_lang_a,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-sprechen-spreche',@si_speak,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-sprache-sprachen',@si_lang_q,'other','شکل جمع از پرسش منبع‌دار استخراج شده است.'),
('activity','act-de-a1-language-question-order',@si_lang_q,'sentence_tokenized_for_word_order','پرسش عین منبع برای مرتب‌سازی بخش‌بندی شده است.'),
('activity','act-de-a1-speak-learn-work-choice',@si_speak,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-speak-learn-work-choice',@si_lang_a,'options_selected_from_source_material','یک گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-speak-learn-work-choice',@si_work_a,'options_selected_from_source_material','یک گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-work-language-matching',@si_learn_de,'source_items_grouped_for_matching','یکی از جمله‌های منبع در تطبیق استفاده شده است.');

UPDATE language_levels SET notes='A1 همچنان در مرحلهٔ برنامه‌ریزی و ساخت تدریجی است. سطح پیش از A1 پیش‌نیاز بسته و ثابت باقی می‌ماند. واحد نخست اکنون دو درس منبع‌دار دارد: شناسایی فرد و پرسیدن شغل، و گفت‌وگو دربارهٔ کار شخصی و زبان‌های در حال یادگیری یا صحبت‌کردن. قدم بعد ارزیابی پوشش Unit نخست و سپس تصمیم دربارهٔ عبور به خانواده است.' WHERE id=@level;
COMMIT;
