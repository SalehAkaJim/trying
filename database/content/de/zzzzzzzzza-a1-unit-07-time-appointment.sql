-- German A1 Unit 7 — time ranges, plans and a simple appointment.
-- Base content never overwrites generated audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @mia := (SELECT id FROM characters WHERE character_key='char-de-mia' LIMIT 1);
SET @max := (SELECT id FROM characters WHERE character_key='char-de-max' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wikibooks-de-lesson-021-time-appointment','Deutschkurs für Anfänger/Lektion 021','زمان‌بندی و قرار روزمره','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_021','Selected items 850, 851, 853, 862, 885, 886 and 887: schedule duration, appointment language, invitation, alternate day and clock-time response.','بخش‌های ۸۵۰، ۸۵۱، ۸۵۳، ۸۶۲، ۸۸۵، ۸۸۶ و ۸۸۷؛ بازهٔ زمانی، دعوت، زمان قرار و پاسخ به پیشنهاد.','2021-03-30','contemporary_verified','صفحهٔ زندهٔ ویکی‌بوکس در ۱۸ سپتامبر ۲۰۲۶ دوباره بررسی شد. آخرین ویرایش صفحه ۳۰ مارس ۲۰۲۱ است؛ فقط جمله‌های ساده و پایدار آلمانی معیار دربارهٔ بازهٔ زمانی، دعوت، زمان قرار، موافقت یا رد و برنامهٔ روز بعد انتخاب شدند و در بازبینی فعلی همچنان طبیعی و قابل‌استفاده‌اند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 021','reuse_with_attribution','2026-09-18','استفاده فقط به بخش‌های مشخص ۸۵۰، ۸۵۱، ۸۵۳، ۸۶۲، ۸۸۵، ۸۸۶ و ۸۸۷ محدود است. بخش‌های دیگر صفحه که برای هدف زمان و قرار لازم نیستند وارد محتوای آموزشی نمی‌شوند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-a1-unit-time-plans-appointment',@level,7,'زمان، برنامه و قرار','ساعت ساده در سطح پیشین معرفی شده بود. این واحد از خواندن ساعت فراتر می‌رود و آن را به دو کار ارتباطی واقعی وصل می‌کند: فهم بازهٔ یک برنامه و هماهنگ‌کردن یک دعوت یا قرار ساده.','review',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-wikibooks-de-lesson-021-time-appointment'),'learningTargets',JSON_ARRAY('فهم بازهٔ زمانی برنامه','پرسش تا چه زمانی','دعوت و پیشنهاد روز جایگزین','پاسخ به ساعت مشخص برای قرار')),'بازبینی پوشش انجام شد. درس نخست بازهٔ شروع و پایان و «تا چه زمانی» را پوشش می‌دهد؛ درس دوم دعوت، رد مؤدبانه، پیشنهاد فردا و پاسخ به ساعت مشخص را اضافه می‌کند. برای هدف فعلی زمان، برنامه و قرار شکاف ضروری مستقلی برای درس سوم دیده نشد.')
ON DUPLICATE KEY UPDATE sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=IF(status='final',status,VALUES(status)),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-time-plans-appointment' LIMIT 1);
SET @t_time := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-time-plans' LIMIT 1);
SET @t_sit := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-time-appointment' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_numbers := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-numbers-dates-time' LIMIT 1);
SET @t_prep := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-time-place-prepositions' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);
SET @t_modal := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-modal-request-patterns' LIMIT 1);
SET @t_present := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-present-verbs' LIMIT 1);
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES(@unit,@t_time),(@unit,@t_sit),(@unit,@t_core),(@unit,@t_numbers),(@unit,@t_prep),(@unit,@t_questions),(@unit,@t_modal),(@unit,@t_present);

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@src,'srcitem-de-a1-time-s1','850','بخش ۸۵۰','Wie lange hast du heute Unterricht?',UNHEX(SHA2('Wie lange hast du heute Unterricht?',256)),'پرسش مدت کلاس.'),
(@src,'srcitem-de-a1-time-s2','850','بخش ۸۵۰','Von 7.30 Uhr bis 12.00 Uhr.',UNHEX(SHA2('Von 7.30 Uhr bis 12.00 Uhr.',256)),'پاسخ بازهٔ کلاس.'),
(@src,'srcitem-de-a1-time-s3','850','بخش ۸۵۰','Und bis wann bleibst du dann noch in der Schule?',UNHEX(SHA2('Und bis wann bleibst du dann noch in der Schule?',256)),'پرسش زمان پایان ماندن.'),
(@src,'srcitem-de-a1-time-s4','850','بخش ۸۵۰','Bis 13.00 Uhr bleibe ich noch hier.',UNHEX(SHA2('Bis 13.00 Uhr bleibe ich noch hier.',256)),'جملهٔ نخست پاسخ دربارهٔ زمان ماندن.'),
(@src,'srcitem-de-a1-time-m1q','853','بخش ۸۵۳','Wie lange haben Sie Unterricht?',UNHEX(SHA2('Wie lange haben Sie Unterricht?',256)),'پرسش بازهٔ کلاس.'),
(@src,'srcitem-de-a1-time-m1a','853','پاسخ ۸۵۳','Von 7.30 bis 12.00 Uhr.',UNHEX(SHA2('Von 7.30 bis 12.00 Uhr.',256)),'پاسخ بازهٔ کلاس.'),
(@src,'srcitem-de-a1-time-m2q','853','بخش ۸۵۳','Wie lange arbeitet Herr Müller?',UNHEX(SHA2('Wie lange arbeitet Herr Müller?',256)),'پرسش بازهٔ کار.'),
(@src,'srcitem-de-a1-time-m2a','853','پاسخ ۸۵۳','Von 7.00 Uhr bis 16.00 Uhr.',UNHEX(SHA2('Von 7.00 Uhr bis 16.00 Uhr.',256)),'پاسخ بازهٔ کار.'),
(@src,'srcitem-de-a1-time-m3q','853','بخش ۸۵۳','Wie lange üben Sie am Nachmittag?',UNHEX(SHA2('Wie lange üben Sie am Nachmittag?',256)),'پرسش بازهٔ تمرین.'),
(@src,'srcitem-de-a1-time-m3a','853','پاسخ ۸۵۳','Von 14.00 Uhr bis 16.30 Uhr.',UNHEX(SHA2('Von 14.00 Uhr bis 16.30 Uhr.',256)),'پاسخ بازهٔ تمرین.'),
(@src,'srcitem-de-a1-time-m4q','853','بخش ۸۵۳','Wie lange waren Sie im Kino?',UNHEX(SHA2('Wie lange waren Sie im Kino?',256)),'پرسش بازهٔ سینما.'),
(@src,'srcitem-de-a1-time-m4a','853','پاسخ ۸۵۳','Von 20.00 Uhr bis 21.45 Uhr.',UNHEX(SHA2('Von 20.00 Uhr bis 21.45 Uhr.',256)),'پاسخ بازهٔ سینما.'),
(@src,'srcitem-de-a1-time-short-1230','851','بخش ۸۵۱','Bis 12.30 Uhr.',UNHEX(SHA2('Bis 12.30 Uhr.',256)),'پاسخ کوتاه زمانی.'),
(@src,'srcitem-de-a1-time-short-dayafter','851','بخش ۸۵۱','Bis übermorgen.',UNHEX(SHA2('Bis übermorgen.',256)),'پاسخ کوتاه زمانی.'),
(@src,'srcitem-de-a1-appt-1','887','بخش ۸۸۷','Was machen Sie heute Abend? Darf ich Sie ins Konzert einladen?',UNHEX(SHA2('Was machen Sie heute Abend? Darf ich Sie ins Konzert einladen?',256)),'دعوت برای امشب.'),
(@src,'srcitem-de-a1-appt-invite','887','بخش ۸۸۷','Darf ich Sie ins Konzert einladen?',UNHEX(SHA2('Darf ich Sie ins Konzert einladen?',256)),'جملهٔ دعوت از نوبت نخست.'),
(@src,'srcitem-de-a1-appt-2','887','بخش ۸۸۷','Heute? Das tut mir leid, heute geht es leider nicht.',UNHEX(SHA2('Heute? Das tut mir leid, heute geht es leider nicht.',256)),'رد مؤدبانهٔ دعوت.'),
(@src,'srcitem-de-a1-appt-3','887','بخش ۸۸۷','Und morgen?',UNHEX(SHA2('Und morgen?',256)),'پیشنهاد روز جایگزین.'),
(@src,'srcitem-de-a1-appt-4','887','بخش ۸۸۷','Morgen geht es vielleicht.',UNHEX(SHA2('Morgen geht es vielleicht.',256)),'پاسخ غیرقطعی برای فردا.'),
(@src,'srcitem-de-a1-appt-noon-q','886','بخش ۸۸۶','Warten Sie um 12 Uhr auf mich?',UNHEX(SHA2('Warten Sie um 12 Uhr auf mich?',256)),'پرسش انتظار در ساعت مشخص.'),
(@src,'srcitem-de-a1-appt-noon-a','886','پاسخ ۸۸۶','Es tut mir leid, um 12 Uhr geht es nicht.',UNHEX(SHA2('Es tut mir leid, um 12 Uhr geht es nicht.',256)),'رد زمان مشخص.'),
(@src,'srcitem-de-a1-appt-agree','885','پاسخ ۸۸۵','Ja, ich bin einverstanden.',UNHEX(SHA2('Ja, ich bin einverstanden.',256)),'پاسخ موافقت.'),
(@src,'srcitem-de-a1-appt-termin','862','بخش ۸۶۲','Haben Sie einen Termin?',UNHEX(SHA2('Haben Sie einen Termin?',256)),'پرسش دربارهٔ داشتن قرار.')
ON DUPLICATE KEY UPDATE source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-unterricht',@de,'word','Unterricht','Unterricht','Unterricht','noun','اسم','A1','کلاس / درس','برای پرسیدن مدت و زمان کلاس در برنامهٔ روزانه استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-schule',@de,'word','Schule','Schule','Schule','noun','اسم','A1','مدرسه','در گفت‌وگوی زمان‌بندی برای ماندن در مدرسه تا ساعت مشخص استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-bleiben',@de,'word','bleiben','bleiben','bleiben','verb','فعل','A1','ماندن','برای گفتن اینکه فرد تا زمان مشخصی در یک مکان می‌ماند استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-von',@de,'word','von','von','von','preposition','حرف اضافه','A1','از','در الگوی زمانی «von ... bis ...» برای شروع یک بازه استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-bis',@de,'word','bis','bis','bis','preposition','حرف اضافه','A1','تا','برای بیان پایان یک بازه یا ماندن تا زمان مشخص استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-termin',@de,'word','Termin','Termin','Termin','noun','اسم','A1','قرار / وقت ملاقات','در پرسش منبع‌دار دربارهٔ داشتن قرار استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-duerfen',@de,'word','dürfen','dürfen','dürfen','verb','فعل','A1','اجازه داشتن / می‌توانم؟','در دعوت مؤدبانهٔ منبع‌دار «Darf ich ...?» ظاهر می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-konzert',@de,'word','Konzert','Konzert','Konzert','noun','اسم','A1','کنسرت','در دعوت برای رفتن به کنسرت استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-einladen',@de,'word','einladen','einladen','einladen','verb','فعل','A1','دعوت کردن','برای دعوت مؤدبانهٔ یک نفر به برنامه‌ای مثل کنسرت استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-kino',@de,'word','Kino','Kino','Kino','noun','اسم','A1','سینما','در نمونه‌های قرار و انتظار در یک مکان مشخص استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-warten',@de,'word','warten','warten','warten','verb','فعل','A1','منتظر ماندن','برای پرسیدن دربارهٔ منتظر ماندن در ساعت مشخص استفاده می‌شود.',TRUE,'blocked_until_level_final'),
('lex-de-vielleicht',@de,'word','vielleicht','vielleicht','vielleicht','adverb','قید','A1','شاید','برای پاسخ غیرقطعی به پیشنهاد برنامهٔ فردا استفاده می‌شود.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);

SET @x_unterricht := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-unterricht'); SET @x_schule := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-schule'); SET @x_bleiben := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bleiben'); SET @x_von := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-von'); SET @x_bis := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bis'); SET @x_termin := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-termin'); SET @x_duerfen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-duerfen'); SET @x_konzert := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-konzert'); SET @x_einladen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-einladen'); SET @x_kino := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kino'); SET @x_warten := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-warten'); SET @x_vielleicht := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-vielleicht'); SET @x_uhr := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-uhr'); SET @x_heute := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-heute'); SET @x_abend := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-abend');

INSERT INTO lexeme_forms(lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes) VALUES
('lexform-de-bleiben-bleibst',@x_bleiben,'bleibst','bleibst','inflected',JSON_OBJECT('tense','present','mood','indicative','person','2','number','singular'),'source_attested','approved','صورت دوم‌شخص مفرد در پرسش منبع‌دار آمده است.'),
('lexform-de-bleiben-bleibe',@x_bleiben,'bleibe','bleibe','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','صورت اول‌شخص مفرد در پاسخ منبع‌دار آمده است.'),
('lexform-de-duerfen-darf',@x_duerfen,'darf','darf','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','صورت اول‌شخص مفرد در دعوت منبع‌دار آمده است.')
ON DUPLICATE KEY UPDATE lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);
SET @f_bleibst := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-bleiben-bleibst'); SET @f_bleibe := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-bleiben-bleibe'); SET @f_darf := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-duerfen-darf');

INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-a1-lesson-time-class-schedule',@level,@unit,11,1,'تا چه ساعتی کلاس داری؟','Wie lange hast du heute Unterricht? / Bis wann bleibst du?','امروز چند ساعت کلاس داری؟ / تا چه زمانی می‌مانی؟','draft','گفت‌وگوی اصلی یک بازهٔ کلاس و زمان پایان ماندن را می‌سازد؛ سپس چهار جفت پرسش و پاسخ زمانی وصل می‌شوند، پرسش کلیدی بازسازی می‌شود و در پایان پاسخ ساعت ۱۳ از دو پاسخ زمانی دیگر تشخیص داده می‌شود.','درس از فهم تعامل کامل به تشخیص چند بازه، بازیابی فعال پرسش و سپس تمایز پاسخ زمانی حرکت می‌کند.','conversation_speaking>matching>word_order>multiple_choice','blocked_until_level_final','درس نخست واحد زمان و قرار؛ تمرکز بر بازهٔ زمانی و زمان پایان است.'),
('de-a1-lesson-time-simple-appointment',@level,@unit,12,2,'امشب نمی‌شود؛ فردا چطور؟','Was machen Sie heute Abend? / Und morgen?','امشب چه کار می‌کنید؟ / و فردا؟','draft','گفت‌وگو دعوت امشب و پیشنهاد فردا را پوشش می‌دهد؛ سپس پاسخ مناسب به یک زمان دقیق انتخاب می‌شود، چهار عبارت زمانی و قرار تثبیت می‌شوند و در پایان جملهٔ دعوت بازسازی می‌شود.','درس از فهم پیشنهاد و تغییر برنامه به تشخیص پاسخ ساعت مشخص، تثبیت واژگان زمان و قرار و بازیابی فعال دعوت حرکت می‌کند.','conversation_speaking>choose_response>matching>word_order','blocked_until_level_final','درس دوم واحد زمان و قرار؛ دعوت، تغییر روز و پاسخ به ساعت مشخص را پوشش می‌دهد.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @l1 := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-time-class-schedule'); SET @l2 := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-time-simple-appointment');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES
(@l1,@t_time,'introduce'),(@l1,@t_sit,'introduce'),(@l1,@t_numbers,'practice'),(@l1,@t_prep,'introduce'),(@l1,@t_questions,'practice'),(@l1,@t_present,'practice'),
(@l2,@t_time,'practice'),(@l2,@t_sit,'practice'),(@l2,@t_numbers,'practice'),(@l2,@t_modal,'practice'),(@l2,@t_questions,'practice');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES
(@l1,@x_unterricht,TRUE,'introduce'),(@l1,@x_schule,TRUE,'introduce'),(@l1,@x_bleiben,TRUE,'introduce'),(@l1,@x_von,TRUE,'introduce'),(@l1,@x_bis,TRUE,'introduce'),(@l1,@x_uhr,FALSE,'review'),
(@l2,@x_termin,TRUE,'introduce'),(@l2,@x_duerfen,TRUE,'introduce'),(@l2,@x_konzert,TRUE,'introduce'),(@l2,@x_einladen,TRUE,'introduce'),(@l2,@x_kino,TRUE,'introduce'),(@l2,@x_warten,TRUE,'introduce'),(@l2,@x_vielleicht,TRUE,'introduce'),(@l2,@x_heute,FALSE,'review'),(@l2,@x_abend,FALSE,'review'),(@l2,@x_uhr,FALSE,'review');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-a1-time-class-schedule',@level,'میا از هم‌کلاسی‌اش مکس دربارهٔ مدت کلاس و اینکه تا چه ساعتی در مدرسه می‌ماند می‌پرسد.','app','چهار نوبت آغاز بخش ۸۵۰ بدون بازنویسی حفظ شده‌اند. خطاب «du» با رابطهٔ هم‌کلاسی و غیررسمی میا و مکس سازگار است و یک گفت‌وگوی طبیعی دربارهٔ بازهٔ کلاس و زمان ماندن می‌سازد.'),
('dlg-de-a1-time-simple-appointment',@level,'آیریس پاول را برای امشب به کنسرت دعوت می‌کند. پاول نمی‌تواند و آیریس فردا را پیشنهاد می‌دهد.','app','چهار نوبت بخش ۸۸۷ بدون بازنویسی حفظ شده‌اند و یک دعوت، رد مؤدبانه و پیشنهاد روز جایگزین را به‌صورت طبیعی پوشش می‌دهند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @d1 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-time-class-schedule'); SET @d2 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-time-simple-appointment');

INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-a1-time-schedule-1',@d1,1,@mia,'app_assigned','unspecified','Wie lange hast du heute Unterricht?','امروز چند ساعت کلاس داری؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-time-schedule-2',@d1,2,@max,'app_assigned','unspecified','Von 7.30 Uhr bis 12.00 Uhr.','از ساعت ۷:۳۰ تا ۱۲.',TRUE,'blocked_until_level_final'),
('turn-de-a1-time-schedule-3',@d1,3,@mia,'app_assigned','unspecified','Und bis wann bleibst du dann noch in der Schule?','و بعد تا چه زمانی در مدرسه می‌مانی؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-time-schedule-4',@d1,4,@max,'app_assigned','unspecified','Bis 13.00 Uhr bleibe ich noch hier.','تا ساعت ۱۳ اینجا می‌مانم.',TRUE,'blocked_until_level_final'),
('turn-de-a1-appointment-1',@d2,1,@iris,'app_assigned','unspecified','Was machen Sie heute Abend? Darf ich Sie ins Konzert einladen?','امشب چه کار می‌کنید؟ می‌توانم شما را به کنسرت دعوت کنم؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-appointment-2',@d2,2,@paul,'app_assigned','unspecified','Heute? Das tut mir leid, heute geht es leider nicht.','امروز؟ متأسفم، امروز متأسفانه نمی‌شود.',TRUE,'blocked_until_level_final'),
('turn-de-a1-appointment-3',@d2,3,@iris,'app_assigned','unspecified','Und morgen?','و فردا؟',FALSE,'blocked_until_level_final'),
('turn-de-a1-appointment-4',@d2,4,@paul,'app_assigned','unspecified','Morgen geht es vielleicht.','فردا شاید بشود.',TRUE,'blocked_until_level_final')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-a1-time-schedule-conversation',@l1,1,'conversation_speaking','دربارهٔ مدت کلاس و ساعتی که تا آن زمان می‌مانی جواب بده.','چهار نوبت منبع‌دار بخش ۸۵۰ یک تعامل کامل با «از ... تا ...» و «تا چه زمانی» می‌سازند.',@d1,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('verbatim_dialogue','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-time-ranges-matching',@l1,2,'matching','هر پرسش زمانی را به پاسخ درستش وصل کن.','چهار جفت کامل از بخش ۸۵۳ چند بازهٔ روزمره را بدون ساخت جملهٔ تازه تمرین می‌کنند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Wie lange haben Sie Unterricht?','leftFa','چند ساعت کلاس دارید؟','right','Von 7.30 bis 12.00 Uhr.','rightFa','از ۷:۳۰ تا ۱۲.'),JSON_OBJECT('left','Wie lange arbeitet Herr Müller?','leftFa','آقای مولر چه مدت کار می‌کند؟','right','Von 7.00 Uhr bis 16.00 Uhr.','rightFa','از ساعت ۷ تا ۱۶.'),JSON_OBJECT('left','Wie lange üben Sie am Nachmittag?','leftFa','بعدازظهر چه مدت تمرین می‌کنید؟','right','Von 14.00 Uhr bis 16.30 Uhr.','rightFa','از ساعت ۱۴ تا ۱۶:۳۰.'),JSON_OBJECT('left','Wie lange waren Sie im Kino?','leftFa','چه مدت در سینما بودید؟','right','Von 20.00 Uhr bis 21.45 Uhr.','rightFa','از ساعت ۲۰ تا ۲۱:۴۵.'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-a1-time-bis-wann-order',@l1,3,'word_order','پرسش «تا چه زمانی در مدرسه می‌مانی؟» را دوباره بساز.','پرسش اصلی گفت‌وگو پس از فهم بازهٔ زمانی به بازیابی فعال منتقل می‌شود.',NULL,JSON_OBJECT('sourceText','Und bis wann bleibst du dann noch in der Schule?','sourceTextFa','و بعد تا چه زمانی در مدرسه می‌مانی؟','tokens',JSON_ARRAY('Und','bis','wann','bleibst','du','dann','noch','in','der','Schule?'),'answer',JSON_ARRAY('Und','bis','wann','bleibst','du','dann','noch','in','der','Schule?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'),
('act-de-a1-time-until-choice',@l1,4,'multiple_choice','کدام پاسخ می‌گوید تا ساعت ۱۳ اینجا می‌مانم؟','یک پاسخ کامل گفت‌وگو با دو پاسخ کوتاه زمانی از همان بخش مقایسه می‌شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Bis 13.00 Uhr bleibe ich noch hier.','translationFa','تا ساعت ۱۳ اینجا می‌مانم.','correct',TRUE),JSON_OBJECT('textTarget','Bis 12.30 Uhr.','translationFa','تا ساعت ۱۲:۳۰.','correct',FALSE),JSON_OBJECT('textTarget','Bis übermorgen.','translationFa','تا پس‌فردا.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-appointment-conversation',@l2,1,'conversation_speaking','به دعوت امشب پاسخ بده و پیشنهاد فردا را دنبال کن.','چهار نوبت بخش ۸۸۷ یک دعوت طبیعی، رد مؤدبانه و پیشنهاد روز جایگزین را بدون جمله‌سازی آزاد پوشش می‌دهند.',@d2,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('verbatim_dialogue','persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-a1-appointment-time-response',@l2,2,'choose_response','اگر از تو بپرسند ساعت ۱۲ منتظر می‌مانی، کدام پاسخ منبع‌دار مناسب است؟','پرسش و پاسخ ساعت مشخص از بخش ۸۸۶ با دو پاسخ واقعی دیگر همان صفحه مقایسه می‌شود.',NULL,JSON_OBJECT('promptTarget','Warten Sie um 12 Uhr auf mich?','promptFa','ساعت ۱۲ منتظر من می‌مانید؟','options',JSON_ARRAY(JSON_OBJECT('textTarget','Es tut mir leid, um 12 Uhr geht es nicht.','translationFa','متأسفم، ساعت ۱۲ نمی‌شود.','correct',TRUE),JSON_OBJECT('textTarget','Morgen geht es vielleicht.','translationFa','فردا شاید بشود.','correct',FALSE),JSON_OBJECT('textTarget','Ja, ich bin einverstanden.','translationFa','بله، موافقم.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-a1-appointment-time-phrases',@l2,3,'matching','هر عبارت مربوط به زمان یا قرار را به معنی درستش وصل کن.','چهار عبارت مستقیماً از بخش‌های ۸۶۲، ۸۸۶ و ۸۸۷ گرفته شده‌اند و واژگان کاربردی زمان و قرار را تثبیت می‌کنند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','einen Termin','leftFa','یک قرار / وقت ملاقات','right','یک قرار / وقت ملاقات','rightFa','یک قرار / وقت ملاقات'),JSON_OBJECT('left','heute Abend','leftFa','امشب','right','امشب','rightFa','امشب'),JSON_OBJECT('left','morgen','leftFa','فردا','right','فردا','rightFa','فردا'),JSON_OBJECT('left','um 12 Uhr','leftFa','ساعت ۱۲','right','ساعت ۱۲','rightFa','ساعت ۱۲'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-a1-appointment-invite-order',@l2,4,'word_order','جملهٔ دعوت به کنسرت را دوباره بساز.','دعوت اصلی پس از فهم سناریو و زمان به بازیابی فعال منتقل می‌شود.',NULL,JSON_OBJECT('sourceText','Darf ich Sie ins Konzert einladen?','sourceTextFa','می‌توانم شما را به کنسرت دعوت کنم؟','tokens',JSON_ARRAY('Darf','ich','Sie','ins','Konzert','einladen?'),'answer',JSON_ARRAY('Darf','ich','Sie','ins','Konzert','einladen?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);

SET @a11 := (SELECT id FROM activities WHERE activity_key='act-de-a1-time-schedule-conversation'); SET @a12 := (SELECT id FROM activities WHERE activity_key='act-de-a1-time-ranges-matching'); SET @a13 := (SELECT id FROM activities WHERE activity_key='act-de-a1-time-bis-wann-order'); SET @a14 := (SELECT id FROM activities WHERE activity_key='act-de-a1-time-until-choice'); SET @a21 := (SELECT id FROM activities WHERE activity_key='act-de-a1-appointment-conversation'); SET @a22 := (SELECT id FROM activities WHERE activity_key='act-de-a1-appointment-time-response'); SET @a23 := (SELECT id FROM activities WHERE activity_key='act-de-a1-appointment-time-phrases'); SET @a24 := (SELECT id FROM activities WHERE activity_key='act-de-a1-appointment-invite-order');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES
(@a11,@t_time),(@a11,@t_sit),(@a11,@t_numbers),(@a11,@t_prep),(@a12,@t_time),(@a12,@t_numbers),(@a12,@t_prep),(@a13,@t_time),(@a13,@t_questions),(@a14,@t_time),(@a14,@t_numbers),
(@a21,@t_time),(@a21,@t_sit),(@a21,@t_modal),(@a22,@t_time),(@a22,@t_sit),(@a22,@t_numbers),(@a23,@t_time),(@a23,@t_sit),(@a24,@t_modal),(@a24,@t_sit);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES
(@a11,@x_unterricht),(@a11,@x_schule),(@a11,@x_bleiben),(@a11,@x_von),(@a11,@x_bis),(@a11,@x_uhr),(@a12,@x_von),(@a12,@x_bis),(@a12,@x_uhr),(@a12,@x_kino),(@a13,@x_bis),(@a13,@x_bleiben),(@a13,@x_schule),(@a14,@x_bis),(@a14,@x_bleiben),(@a14,@x_uhr),
(@a21,@x_duerfen),(@a21,@x_konzert),(@a21,@x_einladen),(@a21,@x_vielleicht),(@a21,@x_heute),(@a21,@x_abend),(@a22,@x_warten),(@a22,@x_uhr),(@a22,@x_vielleicht),(@a23,@x_termin),(@a23,@x_heute),(@a23,@x_abend),(@a23,@x_uhr),(@a24,@x_duerfen),(@a24,@x_konzert),(@a24,@x_einladen);

INSERT INTO lexeme_occurrences(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-a1-time-1-unterricht','dialogue_turn','turn-de-a1-time-schedule-1','Unterricht',NULL,NULL,@x_unterricht,NULL,'approved','اتصال واژهٔ کلاس تأیید شده است.'),
('occ-turn-de-a1-time-2-von','dialogue_turn','turn-de-a1-time-schedule-2','Von',NULL,NULL,@x_von,NULL,'approved','آغاز بازهٔ زمانی ثبت شده است.'),
('occ-turn-de-a1-time-2-bis','dialogue_turn','turn-de-a1-time-schedule-2','bis',NULL,NULL,@x_bis,NULL,'approved','پایان بازهٔ زمانی ثبت شده است.'),
('occ-turn-de-a1-time-2-uhr','dialogue_turn','turn-de-a1-time-schedule-2','Uhr',NULL,NULL,@x_uhr,NULL,'approved','اتصال واژهٔ ساعت تأیید شده است.'),
('occ-turn-de-a1-time-3-bis','dialogue_turn','turn-de-a1-time-schedule-3','bis',NULL,NULL,@x_bis,NULL,'approved','پرسش زمان پایان ثبت شده است.'),
('occ-turn-de-a1-time-3-bleibst','dialogue_turn','turn-de-a1-time-schedule-3','bleibst',NULL,NULL,@x_bleiben,@f_bleibst,'approved','صورت دوم‌شخص فعل ماندن متصل است.'),
('occ-turn-de-a1-time-3-schule','dialogue_turn','turn-de-a1-time-schedule-3','Schule',NULL,NULL,@x_schule,NULL,'approved','اتصال مدرسه تأیید شده است.'),
('occ-turn-de-a1-time-4-bis','dialogue_turn','turn-de-a1-time-schedule-4','Bis',NULL,NULL,@x_bis,NULL,'approved','پایان بازهٔ زمانی ثبت شده است.'),
('occ-turn-de-a1-time-4-uhr','dialogue_turn','turn-de-a1-time-schedule-4','Uhr',NULL,NULL,@x_uhr,NULL,'approved','اتصال واژهٔ ساعت تأیید شده است.'),
('occ-turn-de-a1-time-4-bleibe','dialogue_turn','turn-de-a1-time-schedule-4','bleibe',NULL,NULL,@x_bleiben,@f_bleibe,'approved','صورت اول‌شخص فعل ماندن متصل است.'),
('occ-turn-de-a1-appt-1-heute','dialogue_turn','turn-de-a1-appointment-1','heute',NULL,NULL,@x_heute,NULL,'approved','اتصال امروز تأیید شده است.'),
('occ-turn-de-a1-appt-1-abend','dialogue_turn','turn-de-a1-appointment-1','Abend',NULL,NULL,@x_abend,NULL,'approved','اتصال عصر یا شب تأیید شده است.'),
('occ-turn-de-a1-appt-1-darf','dialogue_turn','turn-de-a1-appointment-1','Darf',NULL,NULL,@x_duerfen,@f_darf,'approved','صورت اول‌شخص فعل اجازه داشتن متصل است.'),
('occ-turn-de-a1-appt-1-konzert','dialogue_turn','turn-de-a1-appointment-1','Konzert',NULL,NULL,@x_konzert,NULL,'approved','اتصال کنسرت تأیید شده است.'),
('occ-turn-de-a1-appt-1-einladen','dialogue_turn','turn-de-a1-appointment-1','einladen',NULL,NULL,@x_einladen,NULL,'approved','اتصال فعل دعوت کردن تأیید شده است.'),
('occ-turn-de-a1-appt-4-vielleicht','dialogue_turn','turn-de-a1-appointment-4','vielleicht',NULL,NULL,@x_vielleicht,NULL,'approved','اتصال شاید تأیید شده است.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

SET @s1 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-s1'); SET @s2 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-s2'); SET @s3 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-s3'); SET @s4 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-s4'); SET @m1q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-m1q'); SET @m1a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-m1a'); SET @m2q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-m2q'); SET @m2a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-m2a'); SET @m3q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-m3q'); SET @m3a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-m3a'); SET @m4q := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-m4q'); SET @m4a := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-m4a'); SET @short1 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-short-1230'); SET @short2 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-time-short-dayafter'); SET @ap1 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-1'); SET @api := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-invite'); SET @ap2 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-2'); SET @ap3 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-3'); SET @ap4 := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-4'); SET @noonq := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-noon-q'); SET @noona := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-noon-a'); SET @agree := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-agree'); SET @terminsi := (SELECT id FROM source_items WHERE item_key='srcitem-de-a1-appt-termin');

INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-a1-time-schedule-1',@s1,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-time-schedule-2',@s2,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-time-schedule-3',@s3,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-time-schedule-4',@s4,'verbatim','جملهٔ نخست پاسخ منبع بدون بازنویسی استفاده شده است.'),
('dialogue_turn','turn-de-a1-appointment-1',@ap1,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-appointment-2',@ap2,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-appointment-3',@ap3,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-a1-appointment-4',@ap4,'verbatim','متن هدف عین منبع است.'),
('lexeme','lex-de-unterricht',@s1,'other','واژه از جملهٔ منبع استخراج شده است.'),
('lexeme','lex-de-schule',@s3,'other','واژه از جملهٔ منبع استخراج شده است.'),
('lexeme','lex-de-bleiben',@s3,'other','فعل از جملهٔ منبع استخراج شده است.'),
('lexeme','lex-de-von',@s2,'other','حرف اضافه از بازهٔ منبع استخراج شده است.'),
('lexeme','lex-de-bis',@s2,'other','حرف اضافه از بازهٔ منبع استخراج شده است.'),
('lexeme','lex-de-termin',@terminsi,'other','واژه از پرسش منبع استخراج شده است.'),
('lexeme','lex-de-duerfen',@api,'other','فعل از دعوت منبع استخراج شده است.'),
('lexeme','lex-de-konzert',@api,'other','واژه از دعوت منبع استخراج شده است.'),
('lexeme','lex-de-einladen',@api,'other','فعل از دعوت منبع استخراج شده است.'),
('lexeme','lex-de-kino',@m4q,'other','واژه از پرسش منبع استخراج شده است.'),
('lexeme','lex-de-warten',@noonq,'other','فعل از پرسش منبع استخراج شده است.'),
('lexeme','lex-de-vielleicht',@ap4,'other','قید از پاسخ منبع استخراج شده است.'),
('lexeme_form','lexform-de-bleiben-bleibst',@s3,'other','صورت صرفی از پرسش منبع استخراج شده است.'),
('lexeme_form','lexform-de-bleiben-bleibe',@s4,'other','صورت صرفی از پاسخ منبع استخراج شده است.'),
('lexeme_form','lexform-de-duerfen-darf',@api,'other','صورت صرفی از دعوت منبع استخراج شده است.'),
('activity','act-de-a1-time-ranges-matching',@m1q,'source_items_grouped_for_matching','پرسش نخست از منبع است.'),
('activity','act-de-a1-time-ranges-matching',@m1a,'source_items_grouped_for_matching','پاسخ نخست از منبع است.'),
('activity','act-de-a1-time-ranges-matching',@m2q,'source_items_grouped_for_matching','پرسش دوم از منبع است.'),
('activity','act-de-a1-time-ranges-matching',@m2a,'source_items_grouped_for_matching','پاسخ دوم از منبع است.'),
('activity','act-de-a1-time-ranges-matching',@m3q,'source_items_grouped_for_matching','پرسش سوم از منبع است.'),
('activity','act-de-a1-time-ranges-matching',@m3a,'source_items_grouped_for_matching','پاسخ سوم از منبع است.'),
('activity','act-de-a1-time-ranges-matching',@m4q,'source_items_grouped_for_matching','پرسش چهارم از منبع است.'),
('activity','act-de-a1-time-ranges-matching',@m4a,'source_items_grouped_for_matching','پاسخ چهارم از منبع است.'),
('activity','act-de-a1-time-bis-wann-order',@s3,'sentence_tokenized_for_word_order','پرسش عین منبع برای مرتب‌سازی بخش‌بندی شده است.'),
('activity','act-de-a1-time-until-choice',@s4,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-time-until-choice',@short1,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-time-until-choice',@short2,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-appointment-time-response',@noonq,'options_selected_from_source_material','پرسش عین منبع است.'),
('activity','act-de-a1-appointment-time-response',@noona,'options_selected_from_source_material','گزینهٔ درست عین منبع است.'),
('activity','act-de-a1-appointment-time-response',@ap4,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-appointment-time-response',@agree,'options_selected_from_source_material','گزینهٔ مقایسه‌ای عین منبع است.'),
('activity','act-de-a1-appointment-time-phrases',@terminsi,'source_items_grouped_for_matching','عبارت قرار از پرسش منبع استخراج شده است.'),
('activity','act-de-a1-appointment-time-phrases',@ap1,'source_items_grouped_for_matching','عبارت امشب از منبع استخراج شده است.'),
('activity','act-de-a1-appointment-time-phrases',@ap3,'source_items_grouped_for_matching','عبارت فردا از منبع استخراج شده است.'),
('activity','act-de-a1-appointment-time-phrases',@noonq,'source_items_grouped_for_matching','عبارت ساعت ۱۲ از منبع استخراج شده است.'),
('activity','act-de-a1-appointment-invite-order',@api,'sentence_tokenized_for_word_order','دعوت عین منبع برای مرتب‌سازی بخش‌بندی شده است.');

UPDATE language_levels SET coverage=JSON_SET(coverage,'$.gaps[2]','هفت واحد نخست به بازبینی رسیده‌اند؛ مرحلهٔ بعد مسیر و مکان‌های عمومی است.'),notes='A1 همچنان در مرحلهٔ ساخت تدریجی است. هفت واحد نخست در بازبینی‌اند. مرحلهٔ بعد مسیر و مکان‌های عمومی است؛ زمان، برنامه و قرار با دو درس منبع‌دار بازبینی شده است.' WHERE id=@level;
COMMIT;
