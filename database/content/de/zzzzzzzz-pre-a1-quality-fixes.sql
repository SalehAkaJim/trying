-- German Pre-A1 targeted quality fixes.
-- Keeps source-backed German, improves progression/listening, and marks changed audio stale.
-- Idempotent for fresh imports and re-imports.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);

SET @l_wellbeing := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-wellbeing');
SET @l_choice := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-choice');
SET @l_residence := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-residence-origin');
SET @l_age := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-age-numbers');
SET @l_day := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-day-time');
SET @l_phone := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-phone-number');
SET @l_review := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-personal-review');
SET @l_order := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-order');
SET @l_price := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-ask-price');
SET @l_toilet := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-find-toilet');

-- Reopen only affected final lessons while their activities are changed.
DROP TEMPORARY TABLE IF EXISTS _prea1_quality_fix_lesson_status;
CREATE TEMPORARY TABLE _prea1_quality_fix_lesson_status AS
SELECT id AS lesson_id,status AS original_status
FROM lessons
WHERE id IN (@l_wellbeing,@l_choice,@l_residence,@l_age,@l_day,@l_phone,@l_review,@l_order,@l_price,@l_toilet);

UPDATE lessons l
JOIN _prea1_quality_fix_lesson_status s ON s.lesson_id=l.id
SET l.status='qa'
WHERE s.original_status='final';

-- Source metadata and exact reusable source items -----------------------------
UPDATE sources
SET locator='Basic survival phrases including “Entschuldigung!”, “Bitte?”, “Ich brauche Hilfe”, “Wo ist die Toilette?” and “Ich weiß nicht.”',
    locator_fa='بخش عبارت‌های پایه؛ «ببخشید»، «بفرمایید؟»، «کمک لازم دارم»، «سرویس بهداشتی کجاست؟» و «نمی‌دانم».',
    currency_evidence='صفحهٔ زندهٔ عبارت‌نامه در ویکی‌بوکس در ۱۷ سپتامبر ۲۰۲۶ بررسی شد؛ عبارت‌های کوتاه ادب، درخواست کمک، پرسیدن محل سرویس بهداشتی و بیان «نمی‌دانم» برای موقعیت‌های روزمرهٔ امروزی قابل‌استفاده‌اند.',
    notes='منبع عبارت‌های کوتاه و منبع‌دار برای ادب، درخواست کمک، پرسیدن محل سرویس بهداشتی و گفتن «نمی‌دانم».'
WHERE source_key='src-wikibooks-de-phrasebook';

SET @s_phrase := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-phrasebook');
SET @s_age_time := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-age-time');
SET @s_phone := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-phone');
SET @s_phone_example := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-phone-example');
SET @s_choice := (SELECT id FROM sources WHERE source_key='src-oak-de-was-moechtest-du');
SET @s_order := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002');
SET @s_price := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004');

INSERT IGNORE INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@s_phrase,'srcitem-de-phrase-ent-schuldigung','phrasebook','عبارت پایه','Entschuldigung!',UNHEX(SHA2('Entschuldigung!',256)),'شروع مؤدبانهٔ منبع‌دار.'),
(@s_phrase,'srcitem-de-phrase-bitte-question','phrasebook','عبارت پایه','Bitte?',UNHEX(SHA2('Bitte?',256)),'پاسخ پرسشی مؤدبانهٔ منبع‌دار.'),
(@s_age_time,'srcitem-de-time-morgen','time of day','زمان روز','Es ist Morgen.',UNHEX(SHA2('Es ist Morgen.',256)),'نمونهٔ منبع‌دار زمان روز.'),
(@s_age_time,'srcitem-de-time-abend','time of day','زمان روز','Es ist Abend.',UNHEX(SHA2('Es ist Abend.',256)),'نمونهٔ منبع‌دار زمان روز.');

SET @si_ent := (SELECT id FROM source_items WHERE source_id=@s_phrase AND source_text='Entschuldigung!' LIMIT 1);
SET @si_bitte_q := (SELECT id FROM source_items WHERE source_id=@s_phrase AND source_text='Bitte?' LIMIT 1);
SET @si_toilet := (SELECT id FROM source_items WHERE source_id=@s_phrase AND source_text='Wo ist die Toilette?' LIMIT 1);
SET @si_dont_know := (SELECT id FROM source_items WHERE source_id=@s_phrase AND source_text='Ich weiß nicht.' LIMIT 1);
SET @si_morgen := (SELECT id FROM source_items WHERE source_id=@s_age_time AND source_text='Es ist Morgen.' LIMIT 1);
SET @si_abend := (SELECT id FROM source_items WHERE source_id=@s_age_time AND source_text='Es ist Abend.' LIMIT 1);
SET @si_phone_q := (SELECT id FROM source_items WHERE source_id=@s_phone AND source_text='Wie lautet deine Telefonnummer?' LIMIT 1);
SET @si_phone_full := (SELECT id FROM source_items WHERE source_id=@s_phone_example AND source_text='Meine Telefonnummer ist: 692-267-752.' LIMIT 1);
SET @si_choice_q := (SELECT id FROM source_items WHERE source_id=@s_choice AND source_text='Was möchtest du?' LIMIT 1);
SET @si_order_a := (SELECT id FROM source_items WHERE source_id=@s_order AND source_text='Eine Tasse Kaffee bitte!' LIMIT 1);
SET @si_price_a2 := (SELECT id FROM source_items WHERE source_id=@s_price AND source_text='Das kostet 35 Euro und 15 Cent.' LIMIT 1);

-- Newly explicit source-backed time-of-day lexemes ----------------------------
INSERT INTO lexemes
(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-morgen',@de,'word','Morgen','Morgen','Morgen','noun','اسم','Pre-A1','صبح','در منبع زمان روز، «Morgen» برای بازهٔ صبح آمده است.',TRUE,'pending'),
('lex-de-abend',@de,'word','Abend','Abend','Abend','noun','اسم','Pre-A1','عصر / شب','در منبع زمان روز، «Abend» برای بازهٔ عصر تا شب آمده است.',TRUE,'pending')
ON DUPLICATE KEY UPDATE
 language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);

SET @x_morgen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-morgen');
SET @x_abend := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-abend');
SET @x_bitte := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bitte');
SET @x_ja := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-ja');
SET @x_entschuldigung := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-entschuldigung');
SET @x_toilette := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-toilette');
SET @x_dont_know := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-ich-weiss-nicht');
SET @x_moegen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-moegen');
SET @x_phone := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-telefonnummer');
SET @x_kosten := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kosten');
SET @x_euro := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-euro');
SET @x_cent := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-cent');
SET @x_tasse := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-tasse');
SET @x_kaffee := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kaffee');

INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES
(@l_day,@x_morgen,FALSE,'introduce'),
(@l_day,@x_abend,FALSE,'introduce');

DELETE FROM lesson_lexemes WHERE lesson_id=@l_toilet AND lexeme_id=@x_ja;
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role)
VALUES(@l_toilet,@x_bitte,FALSE,'review');

-- Lesson editorial/runtime metadata -------------------------------------------
UPDATE lessons SET
 activity_selection_rationale='پنج مرحله فهم انتخاب، بازسازی پرسش، تمایز معنایی «möchtest» و «magst»، پاسخ‌دادن و تشخیص شنیداری پرسش خواستن را پوشش می‌دهد.',
 sequence_rationale='تعامل به ساخت پرسش، تمرکز روی تفاوت معنی، پاسخ کاربردی و در پایان تشخیص شنیداری همان پرسش می‌رسد.',
 template_signature='conversation_speaking>word_order>fill_blank>choose_response>listen_choose',
 audio_status='stale'
WHERE id=@l_choice;

UPDATE lessons SET
 activity_selection_rationale='پنج مرحلهٔ مکالمه، تطبیق دو پرسش با دو قیمت، بازسازی پرسش، تشخیص دقیق قیمت و دریافت شنیداری را پوشش می‌دهد.',
 sequence_rationale='اول قیمت در گفت‌وگو شنیده و گفته می‌شود، سپس سؤال/جواب‌ها از هم تفکیک می‌شوند، خود پرسش ساخته می‌شود، دو قیمت منبع‌دار مقایسه می‌شوند و در پایان همان مهارت به شنیدن منتقل می‌شود.',
 template_signature='conversation_speaking>matching>word_order>multiple_choice>listen_choose',
 audio_status='stale'
WHERE id=@l_price;

UPDATE lessons SET
 activity_selection_rationale='پنج مرحله مکالمه، تطبیق دو جفت کوتاه، بازسازی پرسش مکان، تشخیص معنی «نمی‌دانم» و دریافت شنیداری پرسش را پوشش می‌دهد.',
 sequence_rationale='پرسش ابتدا در یک تبادل مؤدبانه و کاملاً منبع‌دار دیده می‌شود، سپس ارتباط دو جفت گفت‌وگو تثبیت می‌شود، خود پرسش ساخته می‌شود، پاسخ کوتاه تشخیص داده می‌شود و در پایان پرسش از راه شنیدن بازیابی می‌شود.',
 template_signature='conversation_speaking>matching>word_order>multiple_choice>listen_choose',
 audio_status='stale'
WHERE id=@l_toilet;

UPDATE lessons SET
 activity_selection_rationale='پنج مرحله مکالمهٔ سفارش، ساخت عبارت، پاسخ به سؤال رسمی، تشخیص نقش کل سفارش و دریافت شنیداری را پوشش می‌دهد.',
 sequence_rationale='تعامل به ساخت سفارش، بازیابی پاسخ، فهم کاربرد عبارت و در پایان تشخیص شنیداری همان سفارش می‌رسد.',
 template_signature='conversation_speaking>word_order>choose_response>true_false>listen_choose',
 audio_status='stale'
WHERE id=@l_order;

UPDATE lessons SET
 activity_selection_rationale='چهار مرحله مرور گفتاری، فرم متنی، تطبیق پرسش‌های شخصی و تشخیص الگوی تلفن را ترکیب می‌کند؛ تمرین قیمت به درس قیمت منتقل شده تا پیش از آموزش «kosten» و «Euro» سنجیده نشود.',
 sequence_rationale='بازیابی گفتاری و نوشتاری با دو مرور کوتاه ساختاری تکمیل می‌شود و هیچ مفهوم آموزش‌نداده‌ای وارد مرور نمی‌شود.',
 template_signature='conversation_speaking>review>matching>true_false'
WHERE id=@l_review;

UPDATE lessons SET
 activity_selection_rationale='چهار مرحله تبادل شماره، دریافت شنیداری، ساخت پاسخ و تشخیص پرسش را با نمونهٔ کامل منبع‌دار پوشش می‌دهد.',
 sequence_rationale='تعامل و شنیدن به تولید ساختاری و سپس تشخیص نقش پرسش می‌رسد.',
 audio_status='stale'
WHERE id=@l_phone;

UPDATE lessons SET audio_status='stale' WHERE id=@l_day;
UPDATE language_levels SET audio_status='stale' WHERE id=@level;

-- Clarify du/Sie at the exact points where the source-backed forms appear.
UPDATE activities SET
 instruction_fa='در این گفت‌وگوی مؤدبانه طرف مقابل با «Sie» خطاب می‌شود؛ دربارهٔ محل زندگی و مبدأ جواب بده و یک سؤال هم بپرس.',
 selection_reason='دو توصیفگر نزدیکِ اطلاعات شخصی در یک تبادل چهار نوبت طبیعی کنار هم تمرین می‌شوند و فرم رسمی موجود در منبع صریحاً برای زبان‌آموز مشخص می‌شود.'
WHERE activity_key='act-de-residence-conversation';

UPDATE activities SET
 instruction_fa='اینجا خطاب دوستانه است: سن میا را با «du» بپرس و وقتی او از سن تو می‌پرسد، پاسخ نمونه را بگو.',
 selection_reason='سن و عدد باید اول در تعامل واقعی دیده شوند و توضیح فارسی مشخص می‌کند چرا این درس از «du» استفاده می‌کند.'
WHERE activity_key='act-de-age-conversation';

UPDATE activities SET
 instruction_fa='این گفت‌وگو رسمی است و آیریس با «Sie» خطاب می‌کند؛ سلام کن و وقتی سفارش را می‌پرسد، یک فنجان قهوه سفارش بده.'
WHERE activity_key='act-de-simple-order-conversation';

-- Fix misleading literal mapping in wellbeing fill ---------------------------
UPDATE activities SET
 instruction_fa='خودِ عبارت آلمانی احوال‌پرسی را کامل کن؛ گزینه‌ها ترجمهٔ کلمه‌به‌کلمه نیستند.',
 selection_reason='جای‌خالی از همان عبارت منبع‌دار ساخته شده و بدون نسبت‌دادن ترجمهٔ کلمه‌به‌کلمهٔ نادرست به «geht''s»، یک بازیابی سبک ایجاد می‌کند.',
 payload=JSON_OBJECT(
   'sourceText','Wie geht''s?',
   'sourceTextFa','حالت چطوره؟',
   'blankedText','Wie ___?',
   'choices',JSON_ARRAY('geht''s','gut'),
   'answer','geht''s'
 )
WHERE activity_key='act-de-wellbeing-fill';

-- Make mögen / möchten meaning distinction explicit and add listening --------
UPDATE activities SET
 instruction_fa='با توجه به معنی انتخاب کن: «möchtest» برای «می‌خواهی» و «magst» برای «دوست داری».',
 selection_reason='دو فرم منبع‌دار کنار هم قرار می‌گیرند تا زبان‌آموز فقط شکل را حفظ نکند و تفاوت «خواستن» و «دوست داشتن» را تشخیص دهد.',
 payload=JSON_SET(payload,'$.choicesFa',JSON_ARRAY('می‌خواهی','دوست داری'))
WHERE activity_key='act-de-simple-choice-fill';

INSERT INTO activities
(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES
('act-de-simple-choice-listen',@l_choice,5,'listen_choose','پرسش را گوش کن و معنی درستش را انتخاب کن.','همان پرسش دقیق منبع به‌صورت شنیداری ارائه می‌شود تا تفاوت «خواستن» و «دوست داشتن» فقط به خواندن محدود نماند.',NULL,
 JSON_OBJECT('audioTextTargetFa','چی می‌خوای؟','options',JSON_ARRAY(JSON_OBJECT('text','چی می‌خوای؟','correct',TRUE),JSON_OBJECT('text','پیتزا دوست داری؟','correct',FALSE))),
 JSON_ARRAY('other','persian_translation_added'),'Was möchtest du?','pending')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);

-- Move the price listening activity to the lesson where price is actually taught.
UPDATE activities SET
 lesson_id=@l_price,
 position_index=5,
 activity_type='listen_choose',
 instruction_fa='قیمت را گوش کن و عدد درست را انتخاب کن.',
 selection_reason='تمرین شنیداری حالا بعد از آموزش «kosten»، «Euro» و «Cent» قرار دارد و از همان پاسخ دقیق منبع استفاده می‌کند.',
 payload=JSON_OBJECT('audioTextTargetFa','این ۳۵ یورو و ۱۵ سنت قیمت دارد.','options',JSON_ARRAY(JSON_OBJECT('text','35,15 €','correct',TRUE),JSON_OBJECT('text','70,92 €','correct',FALSE))),
 transformations=JSON_ARRAY('other','persian_translation_added'),
 audio_text_target='Das kostet 35 Euro und 15 Cent.',
 audio_status='stale'
WHERE activity_key='act-de-price-listen';

UPDATE activities SET
 instruction_fa='کدام جمله قیمت ۳۵ یورو و ۱۵ سنت را می‌گوید؟',
 selection_reason='دو پاسخ قیمتِ بسیار شبیه و هر دو منبع‌دار جای distractor نامرتبط را می‌گیرند تا پاسخ بدون خواندن دقیق عددها قابل حدس نباشد.',
 payload=JSON_OBJECT('options',JSON_ARRAY(
   JSON_OBJECT('textTarget','Das kostet 35 Euro und 15 Cent.','translationFa','این ۳۵ یورو و ۱۵ سنت قیمت دارد.','correct',TRUE),
   JSON_OBJECT('textTarget','Das kostet 70 Euro und 92 Cent.','translationFa','این ۷۰ یورو و ۹۲ سنت قیمت دارد.','correct',FALSE)
 ))
WHERE activity_key='act-de-price-sentence-choice';

-- Personal review now contains only material already taught before it.
UPDATE activities SET position_index=3 WHERE activity_key='act-de-personal-review-match';
UPDATE activities SET
 position_index=4,
 selection_reason='نمونهٔ کامل و منبع‌دار شماره تلفن جای نمونهٔ سه‌رقمی مصنوعی را می‌گیرد.',
 payload=JSON_OBJECT('statementTarget','Meine Telefonnummer ist: 692-267-752.','statementFa','این جمله یک شماره تلفن را بیان می‌کند.','answer',TRUE)
WHERE activity_key='act-de-personal-review-phone-check';

-- Replace the artificial 3-digit phone example with the full sourced sample.
UPDATE dialogue_turns SET
 text_target='Meine Telefonnummer ist: 692-267-752.',
 translation_fa='شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.',
 audio_status='stale'
WHERE turn_key='turn-de-phone-2';

UPDATE activities SET
 instruction_fa='شماره تلفن را بپرس و پاسخ کامل منبع‌دار را بگو.',
 selection_reason='پرسش و پاسخ مستقیم شماره تلفن توصیفگر صریح پیش از A1 است و نمونهٔ پاسخ کامل از خود منبع بازاستفاده می‌شود.'
WHERE activity_key='act-de-phone-conversation';

UPDATE activities SET
 instruction_fa='شماره را گوش کن و نمونهٔ درست را انتخاب کن.',
 selection_reason='شماره تلفن باید در دریافت شنیداری هم قابل تشخیص باشد و هر دو گزینهٔ عددی از نمونه‌های موجود در منابع پروژه می‌آیند.',
 payload=JSON_OBJECT('audioTextTargetFa','شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.','options',JSON_ARRAY(JSON_OBJECT('text','692-267-752','correct',TRUE),JSON_OBJECT('text','789','correct',FALSE))),
 audio_text_target='Meine Telefonnummer ist: 692-267-752.',
 audio_status='stale'
WHERE activity_key='act-de-phone-listen';

UPDATE activities SET
 payload=JSON_OBJECT('sourceText','Meine Telefonnummer ist: 692-267-752.','sourceTextFa','شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.','tokens',JSON_ARRAY('Meine','Telefonnummer','ist:','692-267-752.'),'answer',JSON_ARRAY('Meine','Telefonnummer','ist:','692-267-752.'))
WHERE activity_key='act-de-phone-word-order';

UPDATE activities SET
 payload=JSON_OBJECT('options',JSON_ARRAY(
   JSON_OBJECT('textTarget','Wie lautet deine Telefonnummer?','translationFa','شماره تلفنت چیه؟','correct',TRUE),
   JSON_OBJECT('textTarget','Meine Telefonnummer ist: 692-267-752.','translationFa','شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.','correct',FALSE)
 ))
WHERE activity_key='act-de-phone-question-choice';

-- Source-backed natural toilet exchange and listening -------------------------
UPDATE dialogues SET
 scenario='آیریس با عذرخواهی شروع می‌کند، پاول با عبارت پرسشی مؤدبانه پاسخ می‌دهد، سپس آیریس محل سرویس بهداشتی را می‌پرسد و پاول می‌گوید نمی‌داند.',
 scene_quality_rationale='چهار نوبت از یک عبارت‌نامهٔ قابل‌بازاستفاده آمده‌اند و شروع گفت‌وگو از «Ja.» مصنوعی به «Bitte?» منبع‌دار تغییر کرده است، بدون ساختن جملهٔ آلمانی تازه.'
WHERE dialogue_key='dlg-de-pre-a1-find-toilet';

UPDATE dialogue_turns SET
 text_target='Entschuldigung!',translation_fa='ببخشید!',audio_status='stale'
WHERE turn_key='turn-de-toilet-1';
UPDATE dialogue_turns SET
 text_target='Bitte?',translation_fa='بفرمایید؟',audio_status='stale'
WHERE turn_key='turn-de-toilet-2';

UPDATE activities SET
 instruction_fa='با «Entschuldigung!» شروع کن و بعد بپرس سرویس بهداشتی کجاست.',
 selection_reason='چهار نوبت دقیقاً از عبارت‌های منبع تشکیل شده‌اند و شروع مؤدبانه را بدون جملهٔ ساختگی تمرین می‌کنند.',
 transformations=JSON_ARRAY('verbatim_dialogue','persian_translation_added','character_metadata_added')
WHERE activity_key='act-de-toilet-conversation';

UPDATE activities SET
 instruction_fa='دو شروع گفت‌وگو را به پاسخ مناسب وصل کن.',
 selection_reason='دو جفت کوتاه منبع‌دار، شروع مؤدبانه و پرسش مکان را به پاسخ درستشان وصل می‌کنند.',
 payload=JSON_OBJECT('pairs',JSON_ARRAY(
   JSON_OBJECT('left','Entschuldigung!','leftFa','ببخشید!','right','Bitte?','rightFa','بفرمایید؟'),
   JSON_OBJECT('left','Wo ist die Toilette?','leftFa','سرویس بهداشتی کجاست؟','right','Ich weiß nicht.','rightFa','نمی‌دانم.')
 ))
WHERE activity_key='act-de-toilet-exchange-match';

INSERT INTO activities
(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES
('act-de-toilet-listen',@l_toilet,5,'listen_choose','پرسش را گوش کن و معنی درستش را انتخاب کن.','پرسش دقیق عبارت‌نامه به‌صورت شنیداری تمرین می‌شود تا توانایی فقط به متن محدود نماند.',NULL,
 JSON_OBJECT('audioTextTargetFa','سرویس بهداشتی کجاست؟','options',JSON_ARRAY(JSON_OBJECT('text','سرویس بهداشتی کجاست؟','correct',TRUE),JSON_OBJECT('text','نمی‌دانم.','correct',FALSE))),
 JSON_ARRAY('other','persian_translation_added'),'Wo ist die Toilette?','pending')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);

-- Add sourced listening to the simple order lesson ----------------------------
INSERT INTO activities
(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES
('act-de-simple-order-listen',@l_order,5,'listen_choose','عبارت را گوش کن و معنی درستش را انتخاب کن.','عبارت دقیق سفارش از همان منبع به‌صورت شنیداری تمرین می‌شود تا زبان‌آموز فقط شکل نوشته‌شده را نشناسد.',NULL,
 JSON_OBJECT('audioTextTargetFa','یک فنجان قهوه لطفاً!','options',JSON_ARRAY(JSON_OBJECT('text','یک فنجان قهوه لطفاً!','correct',TRUE),JSON_OBJECT('text','لطفاً چی میل دارید؟','correct',FALSE))),
 JSON_ARRAY('other','persian_translation_added'),'Eine Tasse Kaffee bitte!','pending')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);

-- Activity/lesson lexeme and target mapping sync ------------------------------
SET @a_choice_listen := (SELECT id FROM activities WHERE activity_key='act-de-simple-choice-listen');
SET @a_price_listen := (SELECT id FROM activities WHERE activity_key='act-de-price-listen');
SET @a_price_choice := (SELECT id FROM activities WHERE activity_key='act-de-price-sentence-choice');
SET @a_phone_listen := (SELECT id FROM activities WHERE activity_key='act-de-phone-listen');
SET @a_phone_word := (SELECT id FROM activities WHERE activity_key='act-de-phone-word-order');
SET @a_phone_choice := (SELECT id FROM activities WHERE activity_key='act-de-phone-question-choice');
SET @a_review_phone := (SELECT id FROM activities WHERE activity_key='act-de-personal-review-phone-check');
SET @a_toilet_conv := (SELECT id FROM activities WHERE activity_key='act-de-toilet-conversation');
SET @a_toilet_match := (SELECT id FROM activities WHERE activity_key='act-de-toilet-exchange-match');
SET @a_toilet_listen := (SELECT id FROM activities WHERE activity_key='act-de-toilet-listen');
SET @a_order_listen := (SELECT id FROM activities WHERE activity_key='act-de-simple-order-listen');
SET @a_day_tod := (SELECT id FROM activities WHERE activity_key='act-de-time-of-day');

DELETE FROM activity_lexemes WHERE activity_id IN (@a_choice_listen,@a_price_listen,@a_price_choice,@a_phone_listen,@a_phone_word,@a_phone_choice,@a_review_phone,@a_toilet_conv,@a_toilet_match,@a_toilet_listen,@a_order_listen,@a_day_tod);

INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES
(@a_choice_listen,@x_moegen),
(@a_price_listen,@x_kosten),(@a_price_listen,@x_euro),(@a_price_listen,@x_cent),
(@a_price_choice,@x_kosten),(@a_price_choice,@x_euro),(@a_price_choice,@x_cent),
(@a_phone_listen,@x_phone),(@a_phone_word,@x_phone),(@a_phone_choice,@x_phone),(@a_review_phone,@x_phone),
(@a_toilet_conv,@x_toilette),(@a_toilet_conv,@x_dont_know),(@a_toilet_conv,@x_entschuldigung),(@a_toilet_conv,@x_bitte),
(@a_toilet_match,@x_toilette),(@a_toilet_match,@x_dont_know),(@a_toilet_match,@x_entschuldigung),(@a_toilet_match,@x_bitte),
(@a_toilet_listen,@x_toilette),
(@a_order_listen,@x_bitte),(@a_order_listen,@x_tasse),(@a_order_listen,@x_kaffee),
(@a_day_tod,@x_morgen),(@a_day_tod,@x_abend);

-- Reuse the same target mappings as each lesson's conversation activity.
DELETE FROM activity_targets WHERE activity_id IN (@a_choice_listen,@a_price_listen,@a_toilet_listen,@a_order_listen);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @a_choice_listen,at.curriculum_target_id FROM activity_targets at JOIN activities a ON a.id=at.activity_id WHERE a.activity_key='act-de-simple-choice-conversation';
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @a_price_listen,at.curriculum_target_id FROM activity_targets at JOIN activities a ON a.id=at.activity_id WHERE a.activity_key='act-de-price-conversation';
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @a_toilet_listen,at.curriculum_target_id FROM activity_targets at JOIN activities a ON a.id=at.activity_id WHERE a.activity_key='act-de-toilet-conversation';
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT @a_order_listen,at.curriculum_target_id FROM activity_targets at JOIN activities a ON a.id=at.activity_id WHERE a.activity_key='act-de-simple-order-conversation';

-- Occurrences changed by the toilet dialogue.
DELETE FROM lexeme_occurrences WHERE occurrence_key='occ-turn-de-toilet-2-ja';
INSERT INTO lexeme_occurrences
(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-toilet-2-bitte','dialogue_turn','turn-de-toilet-2','Bitte',NULL,NULL,@x_bitte,NULL,'approved','اتصال «Bitte» در پاسخ پرسشی مؤدبانه تأیید شده است.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

-- Provenance: replace obsolete source links and add the new exact links.
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key IN ('turn-de-toilet-1','turn-de-toilet-2','turn-de-phone-2');
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key IN (
 'act-de-simple-choice-listen','act-de-price-listen','act-de-phone-listen','act-de-phone-word-order','act-de-phone-question-choice','act-de-personal-review-phone-check','act-de-toilet-conversation','act-de-toilet-exchange-match','act-de-toilet-listen','act-de-simple-order-listen','act-de-time-of-day'
);

INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-toilet-1',@si_ent,'verbatim','متن هدف عین عبارت Phrasebook است.'),
('dialogue_turn','turn-de-toilet-2',@si_bitte_q,'verbatim','متن هدف عین عبارت Phrasebook است.'),
('dialogue_turn','turn-de-phone-2',@si_phone_full,'verbatim','نمونهٔ کامل شماره تلفن عین منبع است.'),
('activity','act-de-simple-choice-listen',@si_choice_q,'other','متن شنیداری عین پرسش منبع‌دار است.'),
('activity','act-de-price-listen',@si_price_a2,'other','متن شنیداری عین پاسخ قیمت منبع‌دار است.'),
('activity','act-de-phone-listen',@si_phone_full,'other','متن شنیداری عین نمونهٔ کامل منبع است.'),
('activity','act-de-phone-word-order',@si_phone_full,'sentence_tokenized_for_word_order','نمونهٔ کامل منبع برای مرتب‌سازی واژه‌ها بخش‌بندی شده است.'),
('activity','act-de-phone-question-choice',@si_phone_q,'options_selected_from_source_material','گزینهٔ پرسش از منبع انتخاب شده است.'),
('activity','act-de-phone-question-choice',@si_phone_full,'options_selected_from_source_material','گزینهٔ پاسخ کامل از منبع انتخاب شده است.'),
('activity','act-de-personal-review-phone-check',@si_phone_full,'other','نمونهٔ کامل شماره تلفن عین منبع است.'),
('activity','act-de-toilet-conversation',@si_ent,'verbatim','شروع مؤدبانه از Phrasebook است.'),
('activity','act-de-toilet-conversation',@si_bitte_q,'verbatim','پاسخ پرسشی مؤدبانه از Phrasebook است.'),
('activity','act-de-toilet-conversation',@si_toilet,'verbatim','پرسش محل عین Phrasebook است.'),
('activity','act-de-toilet-conversation',@si_dont_know,'verbatim','پاسخ کوتاه عین Phrasebook است.'),
('activity','act-de-toilet-exchange-match',@si_ent,'source_items_grouped_for_matching','عبارت‌های Phrasebook برای تطبیق گروه‌بندی شده‌اند.'),
('activity','act-de-toilet-exchange-match',@si_bitte_q,'source_items_grouped_for_matching','عبارت‌های Phrasebook برای تطبیق گروه‌بندی شده‌اند.'),
('activity','act-de-toilet-exchange-match',@si_toilet,'source_items_grouped_for_matching','عبارت‌های Phrasebook برای تطبیق گروه‌بندی شده‌اند.'),
('activity','act-de-toilet-exchange-match',@si_dont_know,'source_items_grouped_for_matching','عبارت‌های Phrasebook برای تطبیق گروه‌بندی شده‌اند.'),
('activity','act-de-toilet-listen',@si_toilet,'other','متن شنیداری عین Phrasebook است.'),
('activity','act-de-simple-order-listen',@si_order_a,'other','متن شنیداری عین عبارت سفارش منبع‌دار است.'),
('activity','act-de-time-of-day',@si_morgen,'options_selected_from_source_material','گزینهٔ صبح عین منبع است.'),
('activity','act-de-time-of-day',@si_abend,'options_selected_from_source_material','گزینهٔ عصر عین منبع است.'),
('lexeme','lex-de-morgen',@si_morgen,'other','واژه از نمونهٔ زمان روز منبع استخراج شده است.'),
('lexeme','lex-de-abend',@si_abend,'other','واژه از نمونهٔ زمان روز منبع استخراج شده است.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

-- Restore lesson final/previous states after all activity mutations.
UPDATE lessons l
JOIN _prea1_quality_fix_lesson_status s ON s.lesson_id=l.id
SET l.status=s.original_status;

DROP TEMPORARY TABLE _prea1_quality_fix_lesson_status;
COMMIT;
