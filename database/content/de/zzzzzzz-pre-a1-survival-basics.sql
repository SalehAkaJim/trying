-- German Pre-A1 Unit 4: price, finding a toilet, and asking for help.
-- Idempotent extension. Generated audio metadata is never overwritten on re-import.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);

-- Curriculum targets ----------------------------------------------------------
INSERT INTO curriculum_targets
(language_level_id,target_key,target_type,title,description,required_for_completion,status,metadata) VALUES
(@level,'de.pre_a1.ask_price','communicative','پرسیدن و فهم قیمت خیلی ساده','با «Wie viel kostet das?» یا «Was kostet das?» قیمت را بپرسد و یک پاسخ کوتاه با Euro و Cent را بفهمد.',TRUE,'covered',JSON_OBJECT('unit4',TRUE)),
(@level,'de.pre_a1.find_toilet','communicative','پرسیدن محل سرویس بهداشتی','با «Wo ist die Toilette?» محل سرویس بهداشتی را بپرسد و پاسخ کوتاه «Ich weiß nicht.» را بفهمد.',TRUE,'covered',JSON_OBJECT('unit4',TRUE)),
(@level,'de.pre_a1.need_help','communicative','درخواست کمک بسیار کوتاه','با «Ich brauche Hilfe.» نیاز به کمک را مستقیم و کوتاه بیان کند.',TRUE,'covered',JSON_OBJECT('unit4',TRUE))
ON DUPLICATE KEY UPDATE
 target_type=VALUES(target_type),title=VALUES(title),description=VALUES(description),
 required_for_completion=VALUES(required_for_completion),status=VALUES(status),metadata=VALUES(metadata);
SET @t_price := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.ask_price');
SET @t_toilet := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.find_toilet');
SET @t_help := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.need_help');

-- Sources and exact source items ---------------------------------------------
INSERT INTO sources
(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wikibooks-de-lesson-004','Deutschkurs für Anfänger/Lektion 004','منبع نیاز، خرید و قیمت ساده','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_004','Items 131, 134 and 148–150','بخش‌های ۱۳۱، ۱۳۴ و ۱۴۸ تا ۱۵۰؛ نیاز و خرید ساده و پرسش/پاسخ‌های منبع‌دار دربارهٔ قیمت.',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ دوباره بررسی شد؛ الگوهای «brauchen»، «kaufen» و پرسیدن/گفتن قیمت برای کاربرد آموزشی معاصر معتبرند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 004','reuse_with_attribution','2026-09-17','این منبع علاوه بر نیاز و خرید، برای درس پرسیدن و فهم قیمت نیز استفاده می‌شود.'),
('src-wikibooks-de-phrasebook','German/Appendices/Phrasebook','منبع عبارت‌های ضروری روزمره','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Appendices/Phrasebook','Basic survival phrases including “Ich brauche Hilfe”, “Wo ist die Toilette?” and “Ich weiß nicht.”','بخش عبارت‌های پایه؛ «کمک لازم دارم»، «سرویس بهداشتی کجاست؟» و «نمی‌دانم».',NULL,'maintained_current','صفحهٔ زندهٔ Phrasebook در Wikibooks در ۱۷ سپتامبر ۲۰۲۶ بررسی شد؛ عبارت‌های کوتاه درخواست کمک، پرسیدن محل سرویس بهداشتی و بیان «نمی‌دانم» برای موقعیت‌های روزمرهٔ امروزی طبیعی و قابل‌استفاده‌اند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Appendices/Phrasebook','reuse_with_attribution','2026-09-17','منبع سه عبارت بسیار کوتاه و کاربردی برای بخش موقعیت‌های ضروری روزمرهٔ Pre-A1.')
ON DUPLICATE KEY UPDATE
 title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @s4 := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004');
SET @sp := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-phrasebook');

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@s4,'srcitem-de-u4-price-q1','148','بخش ۱۴۸','Wie viel kostet das?',UNHEX(SHA2('Wie viel kostet das?',256)),'پرسش اصلی قیمت.'),
(@s4,'srcitem-de-u4-price-a1','148','بخش ۱۴۸','Das kostet 70 Euro und 92 Cent.',UNHEX(SHA2('Das kostet 70 Euro und 92 Cent.',256)),'پاسخ نمونهٔ قیمت.'),
(@s4,'srcitem-de-u4-price-q2','150','بخش ۱۵۰','Was kostet das?',UNHEX(SHA2('Was kostet das?',256)),'شکل کوتاه‌تر پرسش قیمت.'),
(@s4,'srcitem-de-u4-price-a2','150','بخش ۱۵۰','Das kostet 35 Euro und 15 Cent.',UNHEX(SHA2('Das kostet 35 Euro und 15 Cent.',256)),'پاسخ نمونهٔ دوم قیمت.'),
(@sp,'srcitem-de-u4-toilet','phrasebook','عبارت پایه','Wo ist die Toilette?',UNHEX(SHA2('Wo ist die Toilette?',256)),'پرسش محل سرویس بهداشتی.'),
(@sp,'srcitem-de-u4-dont-know','phrasebook','عبارت پایه','Ich weiß nicht.',UNHEX(SHA2('Ich weiß nicht.',256)),'پاسخ کوتاه «نمی‌دانم».'),
(@sp,'srcitem-de-u4-need-help','phrasebook','عبارت پایه','Ich brauche Hilfe.',UNHEX(SHA2('Ich brauche Hilfe.',256)),'درخواست کمک بسیار کوتاه.')
ON DUPLICATE KEY UPDATE
 source_id=VALUES(source_id),locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
SET @si_price_q1 := (SELECT id FROM source_items WHERE item_key='srcitem-de-u4-price-q1');
SET @si_price_a1 := (SELECT id FROM source_items WHERE item_key='srcitem-de-u4-price-a1');
SET @si_price_q2 := (SELECT id FROM source_items WHERE item_key='srcitem-de-u4-price-q2');
SET @si_price_a2 := (SELECT id FROM source_items WHERE item_key='srcitem-de-u4-price-a2');
SET @si_toilet := (SELECT id FROM source_items WHERE item_key='srcitem-de-u4-toilet');
SET @si_dont_know := (SELECT id FROM source_items WHERE item_key='srcitem-de-u4-dont-know');
SET @si_help := (SELECT id FROM source_items WHERE item_key='srcitem-de-u4-need-help');
SET @si_hose := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-need-hose');

-- Lexemes and form ------------------------------------------------------------
INSERT INTO lexemes
(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-kosten',@de,'word','kosten','kosten','kosten','verb','فعل','Pre-A1','قیمت داشتن / هزینه داشتن','در این سطح فقط برای پرسیدن و گفتن قیمت یک چیز در جمله‌های خیلی کوتاه استفاده می‌شود.',TRUE,'pending'),
('lex-de-euro',@de,'word','Euro','Euro','Euro','noun','اسم','Pre-A1','یورو','برای فهم و گفتن قیمت‌های خیلی ساده استفاده می‌شود.',TRUE,'pending'),
('lex-de-cent',@de,'word','Cent','Cent','Cent','noun','اسم','Pre-A1','سِنت','در قیمت‌های ساده همراه «Euro» به کار می‌رود.',TRUE,'pending'),
('lex-de-toilette',@de,'word','Toilette','Toilette','Toilette','noun','اسم','Pre-A1','سرویس بهداشتی / توالت','در پرسش خیلی سادهٔ «Wo ist die Toilette?» استفاده می‌شود.',TRUE,'pending'),
('lex-de-hilfe',@de,'word','Hilfe','Hilfe','Hilfe','noun','اسم','Pre-A1','کمک','در عبارت کوتاه و کاربردی «Ich brauche Hilfe.» استفاده می‌شود.',TRUE,'pending'),
('lex-de-ich-weiss-nicht',@de,'phrase','Ich weiß nicht.','Ich weiß nicht.',NULL,NULL,NULL,'Pre-A1','نمی‌دانم.','به‌صورت یک عبارت ثابت و بسیار کوتاه برای وقتی پاسخ را نمی‌دانیم استفاده می‌شود.',TRUE,'pending')
ON DUPLICATE KEY UPDATE
 language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);

SET @x_kosten := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kosten');
SET @x_euro := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-euro');
SET @x_cent := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-cent');
SET @x_toilette := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-toilette');
SET @x_hilfe := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hilfe');
SET @x_dont_know := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-ich-weiss-nicht');
SET @x_brauchen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-brauchen');
SET @x_hose := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hose');
SET @x_entschuldigung := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-entschuldigung');
SET @x_ja := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-ja');
SET @x_kein_problem := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kein-problem');

INSERT INTO lexeme_forms
(lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes) VALUES
('lexform-de-kosten-kostet',@x_kosten,'kostet','kostet','inflected',JSON_OBJECT('tense','present','mood','indicative','person','3','number','singular'),'source_attested','approved','در پرسش‌ها و پاسخ‌های قیمت منبع، «kostet» به‌صورت سوم‌شخص مفرد حال استفاده شده است.')
ON DUPLICATE KEY UPDATE
 lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);
SET @f_kostet := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-kosten-kostet');
SET @f_brauche := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-brauchen-brauche');

-- Unit and lessons ------------------------------------------------------------
INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-pre-a1-unit-survival-basics',@level,4,'موقعیت‌های ضروری روزمره','این سه درس بعد از خرید و سفارش، دامنهٔ بقا در موقعیت‌های واقعی را گسترش می‌دهند: اول قیمت، بعد پیدا کردن یک مکان ضروری و در پایان درخواست کمک. همهٔ جمله‌ها کوتاه، کاربردی و منبع‌دار باقی می‌مانند.','final',JSON_OBJECT('dynamicStructure',TRUE),'واحد چهارم Pre-A1 سه موقعیت فوری و کم‌فشار را اضافه می‌کند و همچنان از ساختار بدون تصویر و تمرین‌های کوتاه استفاده می‌کند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=VALUES(status),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit4 := (SELECT id FROM units WHERE unit_key='de-pre-a1-unit-survival-basics');
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES
(@unit4,@t_price),(@unit4,@t_toilet),(@unit4,@t_help);

INSERT INTO lessons
(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-pre-a1-lesson-ask-price',@level,@unit4,20,1,'قیمتش چقدره؟','Wie viel kostet das? / Das kostet ... Euro und ... Cent.','قیمتش چقدره؟ / این ... یورو و ... سنت قیمت دارد.','draft','چهار مرحلهٔ مکالمه، تطبیق دو پرسش با دو قیمت، بازسازی پرسش و تشخیص جملهٔ قیمت، هم فهم و هم بازیابی فعال را پوشش می‌دهد.','اول قیمت در گفت‌وگو شنیده و گفته می‌شود، سپس سؤال/جواب‌ها از هم تفکیک می‌شوند، خود پرسش ساخته می‌شود و در پایان جملهٔ قیمت از جملهٔ خرید تشخیص داده می‌شود.','conversation_speaking>matching>word_order>multiple_choice','pending',NULL),
('de-pre-a1-lesson-find-toilet',@level,@unit4,21,2,'سرویس بهداشتی کجاست؟','Wo ist die Toilette? / Ich weiß nicht.','سرویس بهداشتی کجاست؟ / نمی‌دانم.','draft','چهار مرحله مکالمه، تطبیق دو جفت کوتاه، بازسازی پرسش مکان و تشخیص معنی «نمی‌دانم» را پوشش می‌دهد.','پرسش ابتدا در یک موقعیت واقعی دیده می‌شود، سپس ارتباط دو جفت گفت‌وگو تثبیت می‌شود، خود پرسش ساخته می‌شود و در پایان پاسخ کوتاه از پرسش تشخیص داده می‌شود.','conversation_speaking>matching>word_order>multiple_choice','pending',NULL),
('de-pre-a1-lesson-need-help',@level,@unit4,22,3,'کمک لازم دارم','Ich brauche Hilfe.','من کمک لازم دارم.','draft','چهار مرحله مکالمه، بازسازی جمله، جای‌خالی با دو انتخاب واقعی و تشخیص درخواست کمک از نیاز به کالا را پوشش می‌دهد.','عبارت ابتدا در تعامل دیده و گفته می‌شود، سپس به‌صورت کامل ساخته می‌شود، واژهٔ کلیدی بازیابی می‌شود و در پایان معنای درخواست کمک از نیاز خرید جدا می‌شود.','conversation_speaking>word_order>fill_blank>multiple_choice','pending',NULL)
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @l20 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-ask-price');
SET @l21 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-find-toilet');
SET @l22 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-need-help');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES
(@l20,@t_price,'introduce'),(@l21,@t_toilet,'introduce'),(@l22,@t_help,'introduce');

-- Dialogues and turns ---------------------------------------------------------
INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-pre-a1-ask-price',@level,'آیریس دو بار قیمت را می‌پرسد و پاول با دو قیمت دقیقِ منبع‌دار پاسخ می‌دهد.','learner','دو شکل منبع‌دارِ پرسیدن قیمت و دو پاسخ دقیق، بدون زبان اضافه یک تبادل کوتاه و کاربردی می‌سازند.'),
('dlg-de-pre-a1-find-toilet',@level,'آیریس مودبانه شروع می‌کند، محل سرویس بهداشتی را می‌پرسد و پاول می‌گوید نمی‌داند.','learner','چهار نوبت کوتاه از عبارت‌های پایه و منبع‌دار ساخته شده‌اند و بدون آموزش جهت‌یابی، فقط توانایی ضروریِ پرسیدن محل را تمرین می‌کنند.'),
('dlg-de-pre-a1-need-help',@level,'آیریس مودبانه شروع می‌کند و می‌گوید کمک لازم دارد؛ پاول با یک پاسخ آرام جواب می‌دهد.','learner','سه عبارت آشنا و یک عبارت جدیدِ بسیار کاربردی در چهار نوبت کوتاه ترکیب می‌شوند تا درخواست کمک بدون بار دستوری تازه تمرین شود.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @d20 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-ask-price');
SET @d21 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-find-toilet');
SET @d22 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-need-help');

INSERT INTO dialogue_turns
(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-price-1',@d20,1,@iris,'app_assigned','unspecified','Wie viel kostet das?','این چقدر قیمت دارد؟',TRUE,'pending'),
('turn-de-price-2',@d20,2,@paul,'app_assigned','unspecified','Das kostet 70 Euro und 92 Cent.','این ۷۰ یورو و ۹۲ سنت قیمت دارد.',FALSE,'pending'),
('turn-de-price-3',@d20,3,@iris,'app_assigned','unspecified','Was kostet das?','قیمت این چقدره؟',TRUE,'pending'),
('turn-de-price-4',@d20,4,@paul,'app_assigned','unspecified','Das kostet 35 Euro und 15 Cent.','این ۳۵ یورو و ۱۵ سنت قیمت دارد.',FALSE,'pending'),
('turn-de-toilet-1',@d21,1,@iris,'app_assigned','unspecified','Entschuldigung.','ببخشید.',TRUE,'pending'),
('turn-de-toilet-2',@d21,2,@paul,'app_assigned','unspecified','Ja.','بله.',FALSE,'pending'),
('turn-de-toilet-3',@d21,3,@iris,'app_assigned','unspecified','Wo ist die Toilette?','سرویس بهداشتی کجاست؟',TRUE,'pending'),
('turn-de-toilet-4',@d21,4,@paul,'app_assigned','unspecified','Ich weiß nicht.','نمی‌دانم.',FALSE,'pending'),
('turn-de-help-1',@d22,1,@iris,'app_assigned','unspecified','Entschuldigung.','ببخشید.',TRUE,'pending'),
('turn-de-help-2',@d22,2,@paul,'app_assigned','unspecified','Ja.','بله.',FALSE,'pending'),
('turn-de-help-3',@d22,3,@iris,'app_assigned','unspecified','Ich brauche Hilfe.','من کمک لازم دارم.',TRUE,'pending'),
('turn-de-help-4',@d22,4,@paul,'app_assigned','unspecified','Kein Problem.','مشکلی نیست.',FALSE,'pending')
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);

-- Activities -----------------------------------------------------------------
INSERT INTO activities
(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-price-conversation',@l20,1,'conversation_speaking','دو بار قیمت را بپرس و پاسخ قیمت را با پاول تمرین کن.','دو الگوی منبع‌دار پرسیدن قیمت با دو پاسخ واقعی منبع، کاربرد «kostet»، «Euro» و «Cent» را بدون توضیح سنگین نشان می‌دهند.',@d20,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-price-match',@l20,2,'matching','هر سؤال قیمت را به پاسخ خودش وصل کن.','وجود دو پرسش و دو قیمت باعث می‌شود تمرین واقعاً تطبیقی باشد و فقط یک پاسخ حفظ نشود.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Wie viel kostet das?','leftFa','این چقدر قیمت دارد؟','right','Das kostet 70 Euro und 92 Cent.','rightFa','این ۷۰ یورو و ۹۲ سنت قیمت دارد.'),JSON_OBJECT('left','Was kostet das?','leftFa','قیمت این چقدره؟','right','Das kostet 35 Euro und 15 Cent.','rightFa','این ۳۵ یورو و ۱۵ سنت قیمت دارد.'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-price-question-order',@l20,3,'word_order','پرسش قیمت را دوباره بساز.','بعد از فهم دو نمونه، بازسازی پرسش اصلی آن را از تشخیص به بازیابی فعال منتقل می‌کند.',NULL,JSON_OBJECT('sourceText','Wie viel kostet das?','sourceTextFa','این چقدر قیمت دارد؟','tokens',JSON_ARRAY('Wie','viel','kostet','das?'),'answer',JSON_ARRAY('Wie','viel','kostet','das?'),'tokenLexemeMappings',JSON_ARRAY(JSON_OBJECT('token','kostet','lexemeId','lex-de-kosten','lexemeFormId','lexform-de-kosten-kostet'))),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'),
('act-de-price-sentence-choice',@l20,4,'multiple_choice','کدام جمله یک قیمت را می‌گوید؟','مرحلهٔ پایانی جملهٔ قیمت را از جملهٔ نیاز قبلی جدا می‌کند تا معنی «kostet» در بافت تثبیت شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Das kostet 35 Euro und 15 Cent.','translationFa','این ۳۵ یورو و ۱۵ سنت قیمت دارد.','correct',TRUE),JSON_OBJECT('textTarget','Ich brauche eine Hose.','translationFa','من یک شلوار لازم دارم.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-toilet-conversation',@l21,1,'conversation_speaking','مودبانه شروع کن و بپرس سرویس بهداشتی کجاست.','چهار نوبت کوتاه یک نیاز واقعی را با عبارت‌های کاملاً پایه و منبع‌دار تمرین می‌کند.',@d21,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-toilet-exchange-match',@l21,2,'matching','دو شروع گفت‌وگو را به پاسخ مناسب وصل کن.','دو جفت کوتاه باعث می‌شود «Entschuldigung.»، «Ja.»، پرسش مکان و «Ich weiß nicht.» به‌صورت رابطه‌ای بازیابی شوند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Entschuldigung.','leftFa','ببخشید.','right','Ja.','rightFa','بله.'),JSON_OBJECT('left','Wo ist die Toilette?','leftFa','سرویس بهداشتی کجاست؟','right','Ich weiß nicht.','rightFa','نمی‌دانم.'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-toilet-question-order',@l21,3,'word_order','پرسش مکان را دوباره بساز.','بازسازی پرسش باعث می‌شود زبان‌آموز عبارت کامل را فعالانه بازیابی کند، نه اینکه فقط معنی آن را تشخیص دهد.',NULL,JSON_OBJECT('sourceText','Wo ist die Toilette?','sourceTextFa','سرویس بهداشتی کجاست؟','tokens',JSON_ARRAY('Wo','ist','die','Toilette?'),'answer',JSON_ARRAY('Wo','ist','die','Toilette?')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'),
('act-de-dont-know-choice',@l21,4,'multiple_choice','کدام عبارت یعنی «نمی‌دانم»؟','مرحلهٔ پایانی پاسخ کوتاه را از خود پرسش مکان جدا می‌کند و فهم مستقیم عبارت را می‌سنجد.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Ich weiß nicht.','translationFa','نمی‌دانم.','correct',TRUE),JSON_OBJECT('textTarget','Wo ist die Toilette?','translationFa','سرویس بهداشتی کجاست؟','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-help-conversation',@l22,1,'conversation_speaking','مودبانه شروع کن و خیلی کوتاه بگو کمک لازم داری.','چهار نوبت ساده، عبارت جدید را به عذرخواهی، پاسخ و واکنش آرامی که قبلاً دیده شده‌اند وصل می‌کند.',@d22,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-help-word-order',@l22,2,'word_order','جملهٔ درخواست کمک را دوباره بساز.','بازسازی همان عبارت کوتاه، «brauche» و «Hilfe» را بدون افزودن دستور تازه در یک الگوی قابل‌استفاده تثبیت می‌کند.',NULL,JSON_OBJECT('sourceText','Ich brauche Hilfe.','sourceTextFa','من کمک لازم دارم.','tokens',JSON_ARRAY('Ich','brauche','Hilfe.'),'answer',JSON_ARRAY('Ich','brauche','Hilfe.'),'tokenLexemeMappings',JSON_ARRAY(JSON_OBJECT('token','brauche','lexemeId','lex-de-brauchen','lexemeFormId','lexform-de-brauchen-brauche'),JSON_OBJECT('token','Hilfe.','lexemeId','lex-de-hilfe','lexemeFormId',NULL))),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'),
('act-de-help-fill',@l22,3,'fill_blank','جمله را طوری کامل کن که معنی‌اش «کمک لازم دارم» باشد.','دو انتخاب واقعی و منبع‌دار، «Hilfe» را از کالای آشنای «eine Hose» جدا می‌کند و باگ تمرین تک‌گزینه‌ای را هم تکرار نمی‌کند.',NULL,JSON_OBJECT('sourceText','Ich brauche Hilfe.','sourceTextFa','من کمک لازم دارم.','blankedText','Ich brauche ___.','blankedTextFa','من ___ لازم دارم.','choices',JSON_ARRAY('Hilfe','eine Hose'),'choicesFa',JSON_ARRAY('کمک','یک شلوار'),'answer','Hilfe'),JSON_ARRAY('source_sentence_blank_created','options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-help-meaning-choice',@l22,4,'multiple_choice','کدام جمله یعنی به کمک نیاز داری؟','مقایسهٔ دو جمله با فعل یکسان، توجه را روی معنی «Hilfe» می‌گذارد و تفاوت نیاز فوری با نیاز خرید را روشن می‌کند.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Ich brauche Hilfe.','translationFa','من کمک لازم دارم.','correct',TRUE),JSON_OBJECT('textTarget','Ich brauche eine Hose.','translationFa','من یک شلوار لازم دارم.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);

UPDATE lessons SET status='final' WHERE id IN(@l20,@l21,@l22);

-- Lexeme and target mappings --------------------------------------------------
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES
(@l20,@x_kosten,TRUE,'introduce'),(@l20,@x_euro,TRUE,'introduce'),(@l20,@x_cent,TRUE,'introduce'),(@l20,@x_brauchen,FALSE,'review'),(@l20,@x_hose,FALSE,'review'),
(@l21,@x_toilette,TRUE,'introduce'),(@l21,@x_dont_know,TRUE,'introduce'),(@l21,@x_entschuldigung,FALSE,'review'),(@l21,@x_ja,FALSE,'review'),
(@l22,@x_hilfe,TRUE,'introduce'),(@l22,@x_brauchen,FALSE,'review'),(@l22,@x_hose,FALSE,'review'),(@l22,@x_entschuldigung,FALSE,'review'),(@l22,@x_ja,FALSE,'review'),(@l22,@x_kein_problem,FALSE,'review');

SET @a20_1 := (SELECT id FROM activities WHERE activity_key='act-de-price-conversation');
SET @a20_2 := (SELECT id FROM activities WHERE activity_key='act-de-price-match');
SET @a20_3 := (SELECT id FROM activities WHERE activity_key='act-de-price-question-order');
SET @a20_4 := (SELECT id FROM activities WHERE activity_key='act-de-price-sentence-choice');
SET @a21_1 := (SELECT id FROM activities WHERE activity_key='act-de-toilet-conversation');
SET @a21_2 := (SELECT id FROM activities WHERE activity_key='act-de-toilet-exchange-match');
SET @a21_3 := (SELECT id FROM activities WHERE activity_key='act-de-toilet-question-order');
SET @a21_4 := (SELECT id FROM activities WHERE activity_key='act-de-dont-know-choice');
SET @a22_1 := (SELECT id FROM activities WHERE activity_key='act-de-help-conversation');
SET @a22_2 := (SELECT id FROM activities WHERE activity_key='act-de-help-word-order');
SET @a22_3 := (SELECT id FROM activities WHERE activity_key='act-de-help-fill');
SET @a22_4 := (SELECT id FROM activities WHERE activity_key='act-de-help-meaning-choice');

INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES
(@a20_1,@t_price),(@a20_2,@t_price),(@a20_3,@t_price),(@a20_4,@t_price),
(@a21_1,@t_toilet),(@a21_2,@t_toilet),(@a21_3,@t_toilet),(@a21_4,@t_toilet),
(@a22_1,@t_help),(@a22_2,@t_help),(@a22_3,@t_help),(@a22_4,@t_help);

INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES
(@a20_1,@x_kosten),(@a20_1,@x_euro),(@a20_1,@x_cent),
(@a20_2,@x_kosten),(@a20_2,@x_euro),(@a20_2,@x_cent),
(@a20_3,@x_kosten),
(@a20_4,@x_kosten),(@a20_4,@x_euro),(@a20_4,@x_cent),(@a20_4,@x_brauchen),(@a20_4,@x_hose),
(@a21_1,@x_toilette),(@a21_1,@x_dont_know),(@a21_1,@x_entschuldigung),(@a21_1,@x_ja),
(@a21_2,@x_toilette),(@a21_2,@x_dont_know),(@a21_2,@x_entschuldigung),(@a21_2,@x_ja),
(@a21_3,@x_toilette),
(@a21_4,@x_dont_know),(@a21_4,@x_toilette),
(@a22_1,@x_brauchen),(@a22_1,@x_hilfe),(@a22_1,@x_entschuldigung),(@a22_1,@x_ja),(@a22_1,@x_kein_problem),
(@a22_2,@x_brauchen),(@a22_2,@x_hilfe),
(@a22_3,@x_brauchen),(@a22_3,@x_hilfe),(@a22_3,@x_hose),
(@a22_4,@x_brauchen),(@a22_4,@x_hilfe),(@a22_4,@x_hose);

-- Lexeme occurrences ----------------------------------------------------------
INSERT INTO lexeme_occurrences
(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-price-1-kostet','dialogue_turn','turn-de-price-1','kostet',NULL,NULL,@x_kosten,@f_kostet,'approved','فرم «kostet» به «kosten» متصل است.'),
('occ-turn-de-price-2-kostet','dialogue_turn','turn-de-price-2','kostet',NULL,NULL,@x_kosten,@f_kostet,'approved','فرم «kostet» به «kosten» متصل است.'),
('occ-turn-de-price-2-euro','dialogue_turn','turn-de-price-2','Euro',NULL,NULL,@x_euro,NULL,'approved','اتصال «Euro» تأیید شده است.'),
('occ-turn-de-price-2-cent','dialogue_turn','turn-de-price-2','Cent',NULL,NULL,@x_cent,NULL,'approved','اتصال «Cent» تأیید شده است.'),
('occ-turn-de-price-3-kostet','dialogue_turn','turn-de-price-3','kostet',NULL,NULL,@x_kosten,@f_kostet,'approved','فرم «kostet» به «kosten» متصل است.'),
('occ-turn-de-price-4-kostet','dialogue_turn','turn-de-price-4','kostet',NULL,NULL,@x_kosten,@f_kostet,'approved','فرم «kostet» به «kosten» متصل است.'),
('occ-turn-de-price-4-euro','dialogue_turn','turn-de-price-4','Euro',NULL,NULL,@x_euro,NULL,'approved','اتصال «Euro» تأیید شده است.'),
('occ-turn-de-price-4-cent','dialogue_turn','turn-de-price-4','Cent',NULL,NULL,@x_cent,NULL,'approved','اتصال «Cent» تأیید شده است.'),
('occ-turn-de-toilet-1-entschuldigung','dialogue_turn','turn-de-toilet-1','Entschuldigung',NULL,NULL,@x_entschuldigung,NULL,'approved','اتصال عبارت عذرخواهی تأیید شده است.'),
('occ-turn-de-toilet-2-ja','dialogue_turn','turn-de-toilet-2','Ja',NULL,NULL,@x_ja,NULL,'approved','اتصال «Ja» تأیید شده است.'),
('occ-turn-de-toilet-3-toilette','dialogue_turn','turn-de-toilet-3','Toilette',NULL,NULL,@x_toilette,NULL,'approved','اتصال «Toilette» تأیید شده است.'),
('occ-turn-de-toilet-4-dont-know','dialogue_turn','turn-de-toilet-4','Ich weiß nicht.',NULL,NULL,@x_dont_know,NULL,'approved','عبارت ثابت «Ich weiß nicht.» به lexeme عبارت متصل است.'),
('occ-turn-de-help-1-entschuldigung','dialogue_turn','turn-de-help-1','Entschuldigung',NULL,NULL,@x_entschuldigung,NULL,'approved','اتصال عبارت عذرخواهی تأیید شده است.'),
('occ-turn-de-help-2-ja','dialogue_turn','turn-de-help-2','Ja',NULL,NULL,@x_ja,NULL,'approved','اتصال «Ja» تأیید شده است.'),
('occ-turn-de-help-3-brauche','dialogue_turn','turn-de-help-3','brauche',NULL,NULL,@x_brauchen,@f_brauche,'approved','فرم «brauche» به «brauchen» متصل است.'),
('occ-turn-de-help-3-hilfe','dialogue_turn','turn-de-help-3','Hilfe',NULL,NULL,@x_hilfe,NULL,'approved','اتصال «Hilfe» تأیید شده است.'),
('occ-turn-de-help-4-kein-problem','dialogue_turn','turn-de-help-4','Kein Problem',NULL,NULL,@x_kein_problem,NULL,'approved','اتصال «Kein Problem» تأیید شده است.'),
('occ-act-de-price-question-order-kostet','activity','act-de-price-question-order','kostet',NULL,NULL,@x_kosten,@f_kostet,'approved','فرم «kostet» در تمرین مرتب‌سازی به «kosten» متصل است.'),
('occ-act-de-help-word-order-brauche','activity','act-de-help-word-order','brauche',NULL,NULL,@x_brauchen,@f_brauche,'approved','فرم «brauche» در تمرین مرتب‌سازی به «brauchen» متصل است.'),
('occ-act-de-help-word-order-hilfe','activity','act-de-help-word-order','Hilfe.',NULL,NULL,@x_hilfe,NULL,'approved','اتصال «Hilfe» در تمرین مرتب‌سازی تأیید شده است.')
ON DUPLICATE KEY UPDATE
 owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

-- Provenance -----------------------------------------------------------------
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-price-1',@si_price_q1,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-price-2',@si_price_a1,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-price-3',@si_price_q2,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-price-4',@si_price_a2,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-toilet-3',@si_toilet,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-toilet-4',@si_dont_know,'verbatim','متن هدف از عبارت منبع‌دار گرفته شده است.'),
('dialogue_turn','turn-de-help-3',@si_help,'verbatim','متن هدف از عبارت منبع‌دار گرفته شده است.'),
('activity','act-de-price-match',@si_price_q1,'source_items_grouped_for_matching','سؤال و پاسخ‌های قیمت از آیتم‌های منبع گروه‌بندی شده‌اند.'),
('activity','act-de-price-question-order',@si_price_q1,'sentence_tokenized_for_word_order','پرسش منبع برای مرتب‌سازی واژه‌ها بخش‌بندی شده است.'),
('activity','act-de-price-sentence-choice',@si_price_a2,'options_selected_from_source_material','گزینهٔ درست از متن منبع انتخاب شده است.'),
('activity','act-de-toilet-question-order',@si_toilet,'sentence_tokenized_for_word_order','پرسش منبع برای مرتب‌سازی واژه‌ها بخش‌بندی شده است.'),
('activity','act-de-dont-know-choice',@si_dont_know,'options_selected_from_source_material','گزینهٔ درست از عبارت منبع انتخاب شده است.'),
('activity','act-de-help-word-order',@si_help,'sentence_tokenized_for_word_order','عبارت منبع برای مرتب‌سازی واژه‌ها بخش‌بندی شده است.'),
('activity','act-de-help-fill',@si_help,'source_sentence_blank_created','از عبارت منبع جای خالی ساخته شده است.'),
('activity','act-de-help-meaning-choice',@si_help,'options_selected_from_source_material','گزینهٔ درست از عبارت منبع انتخاب شده است.'),
('lexeme','lex-de-kosten',@si_price_q1,'other','فعل در پرسش منبع‌دار آمده است.'),
('lexeme','lex-de-euro',@si_price_a1,'other','واژهٔ Euro در پاسخ منبع‌دار آمده است.'),
('lexeme','lex-de-cent',@si_price_a1,'other','واژهٔ Cent در پاسخ منبع‌دار آمده است.'),
('lexeme','lex-de-toilette',@si_toilet,'other','واژهٔ Toilette در پرسش منبع‌دار آمده است.'),
('lexeme','lex-de-ich-weiss-nicht',@si_dont_know,'other','عبارت عیناً از Phrasebook گرفته شده است.'),
('lexeme','lex-de-hilfe',@si_help,'other','واژهٔ Hilfe در عبارت منبع‌دار آمده است.'),
('lexeme_form','lexform-de-kosten-kostet',@si_price_q1,'other','فرم صرفی «kostet» از پرسش منبع‌دار استخراج شده است.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-toilet-1',si.id,'verbatim','عبارت عذرخواهی از منبع موجود گرفته شده است.'
FROM source_items si JOIN sources s ON s.id=si.source_id
WHERE s.source_key='src-wiktionary-de-entschuldigung' AND si.source_text IN ('Entschuldigung.','Entschuldigung');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-toilet-2',si.id,'verbatim','پاسخ «Ja» از منبع موجود گرفته شده است.'
FROM source_items si JOIN sources s ON s.id=si.source_id
WHERE s.source_key='src-wiktionary-de-ja' AND si.source_text IN ('Ja.','Ja!','ja','Ja');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-help-1',si.id,'verbatim','عبارت عذرخواهی از منبع موجود گرفته شده است.'
FROM source_items si JOIN sources s ON s.id=si.source_id
WHERE s.source_key='src-wiktionary-de-entschuldigung' AND si.source_text IN ('Entschuldigung.','Entschuldigung');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-help-2',si.id,'verbatim','پاسخ «Ja» از منبع موجود گرفته شده است.'
FROM source_items si JOIN sources s ON s.id=si.source_id
WHERE s.source_key='src-wiktionary-de-ja' AND si.source_text IN ('Ja.','Ja!','ja','Ja');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-help-4',si.id,'verbatim','پاسخ «Kein Problem» از منبع موجود گرفته شده است.'
FROM source_items si JOIN sources s ON s.id=si.source_id
WHERE s.source_key='src-wiktionary-de-kein-problem' AND si.source_text IN ('Kein Problem.','Kein Problem');

-- Level metadata --------------------------------------------------------------
UPDATE language_levels
SET coverage=JSON_SET(
      coverage,
      '$.communicativeTargets',JSON_ARRAY(
        'سلام، خداحافظی، تشکر، پاسخ مؤدبانه و عذرخواهی کوتاه','پرسیدن و گفتن نام','احوال‌پرسی بسیار ساده','پرسیدن و پاسخ‌دادن دربارهٔ علاقه/انتخاب غذای آشنا','پاسخ مثبت و منفی کوتاه','پرسیدن و گفتن محل زندگی و مبدأ','پرسیدن و گفتن سن و فهم عددهای ساده','پرسیدن و گفتن روز، ساعت و زمان روز','پرسیدن و گفتن تاریخ تولد','پرسیدن و گفتن شماره تلفن','پرسیدن سؤال اطلاعاتی بسیار ساده و فهم پاسخ کوتاه','نوشتن اطلاعات شخصی بسیار کوتاه در یک فرم متنی','تشخیص شنیداری یک قیمت ساده','پرسیدن و گفتن غذای موجود و چیزی که فرد می‌خورد','انجام یک سفارش بسیار کوتاه و مؤدبانه','فهم و بیان یک نیاز یا خرید بسیار ساده','پرسیدن و فهم قیمت بسیار ساده','پرسیدن محل سرویس بهداشتی و فهم پاسخ «نمی‌دانم»','درخواست کمک بسیار کوتاه'),
      '$.linguisticTargets',JSON_ARRAY(
        'عبارت‌های ثابت سلام/خداحافظی و ادب','فعل‌های پایهٔ mögen، heißen، wohnen و kommen در کاربردهای منبع‌دار این سطح','عددهای ساده در سن، ساعت، تلفن و قیمت','واژه‌های پایهٔ روز، ساعت، تولد، شماره تلفن و نشانی','الگوهای منبع‌دار معرفی، محل زندگی، سن، تاریخ تولد و شماره تلفن','واژه‌های خیلی پایهٔ غذا و نوشیدنی در جمله‌های کوتاه','الگوهای خیلی سادهٔ essen، brauchen و kaufen در بافت روزمره','فعل kosten و واژه‌های Euro و Cent در قیمت ساده','واژه‌های Toilette و Hilfe و عبارت ثابت Ich weiß nicht در موقعیت‌های ضروری'),
      '$.situations',JSON_ARRAY(
        'آشنایی اولیه','گفت‌وگوی کوتاه صبحگاهی','علاقه و انتخاب غذای آشنا','تشکر و عذرخواهی','اطلاعات شخصی در آشنایی مؤدبانه','پرسش سن','پرسش روز و ساعت','تاریخ تولد','تبادل شماره تلفن','سؤال اطلاعاتی بسیار ساده','فرم متنی اطلاعات شخصی','تشخیص قیمت ساده','پرسیدن دربارهٔ غذای امروز','سفارش خیلی سادهٔ قهوه','بیان نیاز و خرید خیلی ساده','پرسیدن قیمت در خرید','پرسیدن محل سرویس بهداشتی','درخواست کمک کوتاه'),
      '$.gaps',JSON_ARRAY()),
    completion_assessment=JSON_SET(
      completion_assessment,
      '$.reviewedAt','2026-09-17T12:25:00Z',
      '$.practiceAndRetrievalComplete',TRUE,
      '$.skillModeCoverageComplete',TRUE,
      '$.qualityReview.rationale','سه درس جدید، قیمت، پرسیدن محل سرویس بهداشتی و درخواست کمک را با ۱۲ فعالیت کامل و منبع‌دار اضافه می‌کنند؛ همهٔ تمرین‌ها در بازهٔ ۳ تا ۶ هستند و payloadهای تعاملی کامل‌اند.',
      '$.qualityReview.remainingWeaknesses',JSON_ARRAY('دارایی‌های صوتی درس‌های ۲۰ تا ۲۲ هنوز تولید نشده‌اند.')),
    notes='German Pre-A1 اکنون ۲۲ درس در ۴ واحد دارد؛ سه درس جدید دربارهٔ قیمت، محل سرویس بهداشتی و درخواست کمک اضافه شده‌اند و صوت تازه هنوز تولید نشده است.',
    audio_status='stale'
WHERE id=@level;

COMMIT;
