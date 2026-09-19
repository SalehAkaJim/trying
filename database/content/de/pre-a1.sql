-- German Pre-A1 canonical SQL — consolidated from the historical migration chain.
-- Mechanical consolidation only; learner-facing German is unchanged.


-- ===== BEGIN 00-language-bootstrap.sql =====
-- Shared German language bootstrap.
-- Must run before any German level migration so levels do not depend on Pre-A1 file ordering.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

INSERT INTO languages (code,name_native,name_fa,status,standalone_audio_voice_name,standalone_audio_voice_id)
VALUES ('de','Deutsch','آلمانی','building',NULL,NULL)
ON DUPLICATE KEY UPDATE
  name_native=VALUES(name_native),
  name_fa=VALUES(name_fa);

COMMIT;

-- ===== END 00-language-bootstrap.sql =====

-- ===== BEGIN 00-pre-a1-reopen.sql =====
-- Reopen existing final German Pre-A1 lessons before the base content file is reapplied.
-- First import: no-op because the lessons do not exist yet.
-- Re-import: allows the canonical base migration to update activities without violating
-- the final-lesson activity guard. Later migrations restore the lessons to final.
-- Quality-fix review activities are temporarily moved out of the canonical range so
-- the older base migration can safely restore its historical position 3 before the
-- later quality migration moves the price listening activity back to Lesson 20 and
-- restores review positions 3 and 4.
-- Two audio-bearing activities were intentionally changed by the quality pass. Before
-- the historical base file is reapplied, restore their historical audio text while the
-- lessons are open, then mark them pending in a second update. This prevents the audio
-- invalidation trigger from leaving them blocked when the base file finalizes lessons.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

UPDATE lessons l
JOIN language_levels ll ON ll.id=l.language_level_id
JOIN languages lang ON lang.id=ll.language_id
SET l.status='qa'
WHERE lang.code='de'
  AND ll.cefr_level='Pre-A1'
  AND l.status='final';

UPDATE activities
SET position_index=98
WHERE activity_key='act-de-personal-review-match';

UPDATE activities
SET position_index=99
WHERE activity_key='act-de-personal-review-phone-check';

UPDATE activities
SET audio_text_target='Meine Telefonnummer lautet 789.'
WHERE activity_key='act-de-phone-listen'
  AND NOT (audio_text_target <=> 'Meine Telefonnummer lautet 789.');

UPDATE activities
SET audio_text_target='Die Zeitschrift kostet 7,60 Euro.'
WHERE activity_key='act-de-price-listen'
  AND NOT (audio_text_target <=> 'Die Zeitschrift kostet 7,60 Euro.');

UPDATE activities a
JOIN lessons l ON l.id=a.lesson_id
JOIN language_levels ll ON ll.id=l.language_level_id
JOIN languages lang ON lang.id=ll.language_id
SET a.audio_status='pending'
WHERE lang.code='de'
  AND ll.cefr_level='Pre-A1'
  AND a.activity_key IN ('act-de-phone-listen','act-de-price-listen')
  AND a.audio_text_target IS NOT NULL
  AND a.audio_url IS NULL;

UPDATE activities a
JOIN lessons l ON l.id=a.lesson_id
JOIN language_levels ll ON ll.id=l.language_level_id
JOIN languages lang ON lang.id=ll.language_id
SET a.audio_status='pending'
WHERE lang.code='de'
  AND ll.cefr_level='Pre-A1'
  AND a.audio_text_target IS NOT NULL
  AND a.audio_status='blocked_until_level_final'
  AND a.audio_url IS NULL;

COMMIT;

-- ===== END 00-pre-a1-reopen.sql =====

-- ===== BEGIN pre-a1.sql =====

-- German Pre-A1
-- Canonical runtime: MySQL 9.0.1
-- Requires database/schema.sql first.
-- Current snapshot: finalized source-backed German Pre-A1 curriculum.
-- Product rule: beginner lessons 1-10 use exactly 4 opening turns.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

-- Language / level ------------------------------------------------------------
INSERT INTO languages (code,name_native,name_fa,status,standalone_audio_voice_name,standalone_audio_voice_id)
VALUES ('de','Deutsch','آلمانی','building',NULL,NULL)
ON DUPLICATE KEY UPDATE name_native=VALUES(name_native),name_fa=VALUES(name_fa),status=VALUES(status);
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);

INSERT INTO language_levels (language_id,cefr_level,status,structure_rationale,coverage,notes) VALUES
(@de,'Pre-A1','building',
'سطح از ارتباط‌های بسیار ساده و فوری برای زبان‌آموز صفر شروع می‌شود و فقط وقتی گسترش پیدا می‌کند که پوشش CEFR، پیش‌نیازها یا نیاز به تمرین بیشتر آن را توجیه کند؛ تعداد درس یا واحد معیار تولید محتوا نیست.',
JSON_OBJECT(
 'communicativeTargets',JSON_ARRAY(
  'سلام‌کردن دوستانه با «Hallo!»',
  'شروع گفت‌وگوی صبحگاهی با «Guten Morgen!»',
  'پرسیدن و پاسخ‌دادن دربارهٔ علاقه به یک غذای بسیار آشنا',
  'استفاده و تشخیص پاسخ‌های کوتاه «ja» و «nein»',
  'تشکر کوتاه و پاسخ مؤدبانه با «danke» و «bitte»',
  'خداحافظی ساده با «Tschüss!»',
  'عذرخواهی کوتاه با «Entschuldigung» و فهم پاسخ «Kein Problem»',
  'پرسیدن نام با «Wie heißt du?» و فهم پاسخ «Ich heiße Iris.»',
  'احوال‌پرسی بسیار ساده با «Wie geht''s?» و «Gut.»',
  'فهم پرسش «Was möchtest du?» و انتخاب یک گزینهٔ آشنا'
 ),
 'linguisticTargets',JSON_ARRAY(
  'عبارت ثابت «hallo» برای سلام',
  'عبارت ثابت «guten Morgen» برای صبح‌بخیر',
  'فعل «mögen» در شکل‌های «mag» و «magst»',
  'اسم آشنای «Pizza»',
  'ذره‌های پاسخ «ja» و «nein»',
  'عبارت‌های مؤدبانهٔ «danke» و «bitte»',
  'عبارت خداحافظی «Tschüss!»',
  'عبارت‌های «Entschuldigung» و «kein Problem»',
  'فعل «heißen» در شکل‌های «heiße» و «heißt»',
  'عبارت «Wie geht''s?» و پاسخ کوتاه «Gut.»',
  'فرم «möchtest» از «mögen» برای بیان خواستن در یک پرسش ساده'
 ),
 'situations',JSON_ARRAY(
  'اولین سلام ساده و خداحافظی','شروع گفت‌وگو در صبح',
  'پرسش و پاسخ ساده دربارهٔ علاقه به پیتزا','پاسخ مثبت و منفی در یک بافت آشنا',
  'تشکر و پاسخ مؤدبانه','عذرخواهی کوتاه و پاسخ آرام',
  'پرسیدن نام در آشنایی اولیه','احوال‌پرسی بسیار کوتاه',
  'انتخاب یک چیز آشنا در پاسخ به یک پرسش کوتاه'
 ),
 'gaps',JSON_ARRAY(
  'گفتن نام واقعی خود زبان‌آموز با یک slot شخصی‌سازی‌شده و منبع‌دار',
  'مرور و بازیابی بیشتر در جاهایی که شواهد آموزشی نیاز نشان دهد'
 )
),
'این فهرست فقط محتوایی است که تا این مرحله ساخته شده و به معنی تعداد هدف برای Pre-A1 نیست.')
ON DUPLICATE KEY UPDATE status=VALUES(status),structure_rationale=VALUES(structure_rationale),coverage=VALUES(coverage),notes=VALUES(notes);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);

-- Curriculum targets ----------------------------------------------------------
INSERT INTO curriculum_targets
(language_level_id,target_key,target_type,title,description,required_for_completion,status,metadata) VALUES
(@level,'de.pre_a1.greet_informal_hallo','communicative','سلام دوستانه با «Hallo!»','در یک برخورد ساده از «Hallo!» برای سلام استفاده کند.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.greet_morning_guten_morgen','communicative','شروع گفت‌وگوی صبحگاهی با «Guten Morgen!»','در صبح گفت‌وگو را با «Guten Morgen!» شروع کند.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.distinguish_morning_general_greeting','linguistic','تشخیص سلام صبحگاهی از سلام عمومی','تفاوت کاربرد «Guten Morgen!» و «Hallo!» را در بافت ساده تشخیص دهد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.understand_pizza_preference_question','communicative','فهم پرسش ساده دربارهٔ علاقه به پیتزا','پرسش منبع‌دار «Magst du Pizza?» را بفهمد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.state_positive_pizza_preference','communicative','بیان علاقهٔ ساده به پیتزا','با جملهٔ منبع‌دار «Ich mag Pizza.» علاقهٔ ساده را بیان کند.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.notice_moegen_mag_magst','linguistic','ارتباط «mag» و «magst» با «mögen»','شکل‌های «mag» و «magst» را به lexeme پایهٔ «mögen» مرتبط کند.',FALSE,'partial',JSON_OBJECT('lexemeFormAware',TRUE)),
(@level,'de.pre_a1.answer_yes_with_ja','communicative','پاسخ مثبت با «ja»','در یک پرسش بله/خیر آشنا از «ja» به‌عنوان پاسخ مثبت استفاده یا آن را تشخیص دهد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.recognize_no_with_nein','communicative','تشخیص پاسخ منفی «nein»','در یک بافت آشنا «nein» را از «ja» تشخیص دهد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.thank_with_danke','communicative','فهم تشکر کوتاه با «danke»','«danke» را در یک تعامل روزمرهٔ ساده بفهمد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.respond_with_bitte','communicative','پاسخ به تشکر با «bitte»','در پاسخ به تشکر از «bitte» استفاده کند.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.basic_wellbeing','communicative','احوال‌پرسی بسیار ساده','«Wie geht''s?» را بفهمد و با پاسخ کوتاه «Gut.» جواب دهد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.farewell_tschuess','communicative','خداحافظی ساده با «Tschüss!»','در پایان گفت‌وگوی دوستانه از «Tschüss!» استفاده کند.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.apologize_basic','communicative','عذرخواهی کوتاه و پاسخ به آن','با «Entschuldigung.» عذرخواهی کند و «Kein Problem.» را به‌عنوان پاسخ بفهمد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.ask_name_basic','communicative','پرسیدن نام و فهم پاسخ','با «Wie heißt du?» نام را بپرسد و «Ich heiße Iris.» را بفهمد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.notice_heissen_forms','linguistic','ارتباط «heiße» و «heißt» با «heißen»','شکل‌های «heiße» و «heißt» را به lexeme پایهٔ «heißen» مرتبط کند.',FALSE,'partial',JSON_OBJECT('lexemeFormAware',TRUE)),
(@level,'de.pre_a1.choose_simple_item','communicative','فهم «Was möchtest du?» و انتخاب ساده','پرسش «Was möchtest du?» را بفهمد و با یک گزینهٔ آشنا پاسخ دهد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.notice_moegen_moechtest','linguistic','ارتباط «möchtest» با «mögen»','فرم «möchtest» را به lexeme پایهٔ «mögen» مرتبط کند.',FALSE,'partial',JSON_OBJECT('lexemeFormAware',TRUE))
ON DUPLICATE KEY UPDATE target_type=VALUES(target_type),title=VALUES(title),description=VALUES(description),
 required_for_completion=VALUES(required_for_completion),status=VALUES(status),metadata=VALUES(metadata);

SET @t_hallo := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.greet_informal_hallo');
SET @t_gm := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.greet_morning_guten_morgen');
SET @t_gm_diff := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.distinguish_morning_general_greeting');
SET @t_pq := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.understand_pizza_preference_question');
SET @t_pa := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.state_positive_pizza_preference');
SET @t_forms := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.notice_moegen_mag_magst');
SET @t_ja := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.answer_yes_with_ja');
SET @t_nein := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.recognize_no_with_nein');
SET @t_danke := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.thank_with_danke');
SET @t_bitte := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.respond_with_bitte');
SET @t_wellbeing := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.basic_wellbeing');
SET @t_bye := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.farewell_tschuess');
SET @t_apology := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.apologize_basic');
SET @t_name := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.ask_name_basic');
SET @t_heissen := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.notice_heissen_forms');
SET @t_choice := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.choose_simple_item');
SET @t_moechtest := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.notice_moegen_moechtest');

-- Modern reusable sources -----------------------------------------------------
INSERT INTO sources
(source_key,title,organization_or_author,language_code,source_type,url,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wiktionary-de-hallo','Wiktionary: hallo','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/hallo',NULL,'maintained_current','مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/hallo','reuse_with_attribution','2026-09-16','منبع عبارت سلام «hallo».'),
('src-wiktionary-de-guten-morgen','Wiktionary: guten Morgen','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/guten_Morgen',NULL,'maintained_current','مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/guten_Morgen','reuse_with_attribution','2026-09-16','منبع عبارت «guten Morgen».'),
('src-wiktionary-de-moegen','Wiktionary: mögen','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/m%C3%B6gen',NULL,'maintained_current','مدخل زنده و فعال Wiktionary برای هویت واژگانی و شکل‌های صرفی معاصر بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/m%C3%B6gen','reuse_with_attribution','2026-09-16','منبع «mögen» و شکل‌های «mag / magst».'),
('src-wiktionary-de-pizza','Wiktionary: Pizza','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/Pizza',NULL,'maintained_current','مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/Pizza','reuse_with_attribution','2026-09-16','منبع اسم «Pizza».'),
('src-libra-de-ich-mag-pizza','Sprachstandsfeststellung Deutsch als Zweitsprache – Zusatzmodul Alphabetisierung','Landesinstitut Brandenburg für Schule und Lehrkräftebildung (LIBRA)','de','book','https://bildungsserver.berlin-brandenburg.de/fileadmin/bbb/themen/sprachbildung/Sprachfeststellungpruefung/Sprachstandsfeststellung_DaZ_Alphabetisierung_2025-03-20.pdf','2025-03-20','contemporary_verified','منبع رسمی آموزشی ایالت Brandenburg از سال ۲۰۲۵ است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Landesinstitut Brandenburg für Schule und Lehrkräftebildung (LIBRA), p. 12','reuse_with_attribution','2026-09-16','منبع رسمی جملهٔ دقیق «Ich mag Pizza.».'),
('src-wikibooks-de-magst-du-pizza','Wikibooks example containing Magst du Pizza?','Wikibooks contributors','de','book','https://de.wikibooks.org/wiki/Ungarisch/Ungarisch-Lesebuch-h%C3%A4ufigeW%C3%B6rter/012',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — source page','reuse_with_attribution','2026-09-16','منبع پرسش «Magst du Pizza?».'),
('src-wiktionary-de-ja','Wiktionary: ja','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/ja',NULL,'maintained_current','مدخل زنده و فعال Wiktionary برای پاسخ مثبت معاصر بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/ja','reuse_with_attribution','2026-09-16','منبع پاسخ مثبت «ja».'),
('src-wiktionary-de-nein','Wiktionary: nein','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/nein',NULL,'maintained_current','مدخل زنده و فعال Wiktionary برای پاسخ منفی معاصر بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/nein','reuse_with_attribution','2026-09-16','منبع پاسخ منفی «nein».'),
('src-wiktionary-de-danke','Wiktionary: danke','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/danke',NULL,'maintained_current','مدخل زنده و فعال Wiktionary برای عبارت تشکر معاصر بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/danke','reuse_with_attribution','2026-09-16','منبع عبارت تشکر «danke».'),
('src-wiktionary-de-bitte','Wiktionary: bitte','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/bitte',NULL,'maintained_current','مدخل زنده و فعال Wiktionary در وضعیت فعلی بررسی شده و فقط کاربرد مستند پاسخ به تشکر استفاده می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/bitte','reuse_with_attribution','2026-09-16','در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود.'),
('src-wikibooks-de-basic-greetings','Wikibooks: German/Print version — basic greetings and wellbeing','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Print_version',NULL,'maintained_current','صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — https://en.wikibooks.org/wiki/German/Print_version','reuse_with_attribution','2026-09-16','برای «Wie geht''s?»، «Gut.» و «Tschüss!» استفاده می‌شود.'),
('src-wiktionary-de-entschuldigung','Wiktionary: Entschuldigung','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/Entschuldigung',NULL,'maintained_current','مدخل زنده و نگهداری‌شدهٔ Wiktionary آلمانی در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/Entschuldigung','reuse_with_attribution','2026-09-16','منبع «Entschuldigung».'),
('src-wiktionary-de-kein-problem','Wiktionary: kein Problem','Wiktionary contributors','de','dictionary','https://en.wiktionary.org/wiki/kein_Problem','2026-06-04','contemporary_verified','مدخل در سال ۲۰۲۶ به‌روز شده و عبارت امروزی «kein Problem» را مستقیم ثبت می‌کند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://en.wiktionary.org/wiki/kein_Problem','reuse_with_attribution','2026-09-16','منبع «kein Problem».'),
('src-wikibooks-de-wie-heisst-du','Wikibooks: German/Level I/Wie heißt du? (2. Teil)','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Level_I/Wie_hei%C3%9Ft_du_2',NULL,'maintained_current','صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — name lesson page','reuse_with_attribution','2026-09-16','منبع «Wie heißt du?» و «Ich heiße Iris.».'),
('src-wiktionary-de-heissen','Wiktionary: heißen','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/hei%C3%9Fen',NULL,'maintained_current','مدخل زنده و نگهداری‌شدهٔ Wiktionary آلمانی و شکل‌های حال آن بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/hei%C3%9Fen','reuse_with_attribution','2026-09-16','منبع «heißen» و «heiße / heißt».'),
('src-oak-de-was-moechtest-du','Oak National Academy: Was möchtest du? Present and conditional ''mögen''','Oak National Academy','de','course','https://www.thenational.academy/teachers/programmes/german-secondary-ks4-edexcel/units/people-and-lifestyle-positive-lebensentscheidungen/lessons/was-mochtest-du-present-and-conditional-mogen',NULL,'contemporary_verified','صفحهٔ آموزشی زندهٔ Oak National Academy در سپتامبر ۲۰۲۶ بررسی شده است؛ خود درس کاربرد معاصر «Was möchtest du?» و «möcht-» را آموزش می‌دهد و محتوای جدید Oak تحت OGL v3.0 منتشر می‌شود مگر خلاف آن ذکر شده باشد.','Open Government Licence v3.0 (OGL)','https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/','A German lesson by Oak National Academy licensed under Open Government Licence v3.0 (OGL)','reuse_with_attribution','2026-09-16','منبع دقیق پرسش «Was möchtest du?».'),
('src-wiktionary-de-moechten','Wiktionary: möchten','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/m%C3%B6chten',NULL,'maintained_current','مدخل زنده و نگهداری‌شدهٔ Wiktionary در سپتامبر ۲۰۲۶ بررسی شده و «möchten» را به‌عنوان صورت صرف‌شدهٔ «mögen» ثبت می‌کند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/m%C3%B6chten','reuse_with_attribution','2026-09-16','مرجع شکل «möchtest» و پیوند آن با «mögen».')
ON DUPLICATE KEY UPDATE title=VALUES(title),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),
 source_type=VALUES(source_type),url=VALUES(url),published_or_updated_at=VALUES(published_or_updated_at),
 modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),
 license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),
 retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);


SET @s_hallo := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-hallo');
SET @s_gm := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-guten-morgen');
SET @s_moegen := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-moegen');
SET @s_pizza := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-pizza');
SET @s_libra := (SELECT id FROM sources WHERE source_key='src-libra-de-ich-mag-pizza');
SET @s_pq := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-magst-du-pizza');
SET @s_ja := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-ja');
SET @s_nein := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-nein');
SET @s_danke := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-danke');
SET @s_bitte := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-bitte');
SET @s_basic := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-basic-greetings');
SET @s_entsch := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-entschuldigung');
SET @s_keinp := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-kein-problem');
SET @s_name := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-wie-heisst-du');
SET @s_heissen := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-heissen');
SET @s_oak_choice := (SELECT id FROM sources WHERE source_key='src-oak-de-was-moechtest-du');
SET @s_moechten := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-moechten');

INSERT INTO source_items (source_id,item_key,locator,source_text,source_text_hash,notes) VALUES
(@s_hallo,'srcitem-de-hallo-headword','German greeting formula','hallo',UNHEX(SHA2('hallo',256)),'عبارت سلام معاصر.'),
(@s_gm,'srcitem-de-guten-morgen-formula','German greeting formula','guten Morgen',UNHEX(SHA2('guten Morgen',256)),'عبارت صبح‌بخیر معاصر.'),
(@s_moegen,'srcitem-de-moegen-lemma','German verb lemma','mögen',UNHEX(SHA2('mögen',256)),'صورت پایهٔ فعل.'),
(@s_moegen,'srcitem-de-moegen-mag','Present form','mag',UNHEX(SHA2('mag',256)),'شکل صرفی حال.'),
(@s_moegen,'srcitem-de-moegen-magst','Present form','magst',UNHEX(SHA2('magst',256)),'شکل صرفی حال.'),
(@s_pizza,'srcitem-de-pizza-headword','German noun','Pizza',UNHEX(SHA2('Pizza',256)),'اسم آشنای غذا.'),
(@s_libra,'srcitem-de-ich-mag-pizza','p. 12, Aufgabe 3a','Ich mag Pizza.',UNHEX(SHA2('Ich mag Pizza.',256)),'جملهٔ دقیق منبع.'),
(@s_pq,'srcitem-de-magst-du-pizza','German example','Magst du Pizza?',UNHEX(SHA2('Magst du Pizza?',256)),'پرسش دقیق منبع.'),
(@s_ja,'srcitem-de-ja-headword','German affirmative response particle','ja',UNHEX(SHA2('ja',256)),'پاسخ مثبت.'),
(@s_nein,'srcitem-de-nein-headword','German negative response particle','nein',UNHEX(SHA2('nein',256)),'پاسخ منفی.'),
(@s_danke,'srcitem-de-danke-headword','German expression of thanks','danke',UNHEX(SHA2('danke',256)),'تشکر کوتاه.'),
(@s_bitte,'srcitem-de-bitte-response','Meaning [2]: response to thanks','bitte',UNHEX(SHA2('bitte',256)),'پاسخ مؤدبانه به تشکر.'),
(@s_basic,'srcitem-de-wie-gehts','Basic conversation','Wie geht''s?',UNHEX(SHA2('Wie geht''s?',256)),'پرسش کوتاه احوال‌پرسی.'),
(@s_basic,'srcitem-de-gut-short','Short reply','Gut.',UNHEX(SHA2('Gut.',256)),'پاسخ کوتاه احوال‌پرسی.'),
(@s_basic,'srcitem-de-tschuess','Informal goodbye','Tschüss!',UNHEX(SHA2('Tschüss!',256)),'خداحافظی دوستانه.'),
(@s_entsch,'srcitem-de-entschuldigung','German interjection','Entschuldigung.',UNHEX(SHA2('Entschuldigung.',256)),'عذرخواهی کوتاه.'),
(@s_keinp,'srcitem-de-kein-problem','German phrase','kein Problem',UNHEX(SHA2('kein Problem',256)),'پاسخ کوتاه به عذرخواهی.'),
(@s_name,'srcitem-de-wie-heisst-du','Exercise answer','Wie heißt du?',UNHEX(SHA2('Wie heißt du?',256)),'پرسش نام.'),
(@s_name,'srcitem-de-ich-heisse-iris','Exercise answer','Ich heiße Iris.',UNHEX(SHA2('Ich heiße Iris.',256)),'پاسخ نام.'),
(@s_heissen,'srcitem-de-heissen-lemma','German verb lemma','heißen',UNHEX(SHA2('heißen',256)),'صورت پایهٔ فعل.'),
(@s_heissen,'srcitem-de-heissen-heisse','Present form','heiße',UNHEX(SHA2('heiße',256)),'اول‌شخص مفرد حال.'),
(@s_heissen,'srcitem-de-heissen-heisst','Present form','heißt',UNHEX(SHA2('heißt',256)),'دوم‌شخص مفرد حال.'),
(@s_oak_choice,'srcitem-de-was-moechtest-du','Lesson title / key learning point','Was möchtest du?',UNHEX(SHA2('Was möchtest du?',256)),'پرسش دقیق منبع.'),
(@s_moechten,'srcitem-de-moegen-moechtest','Second-person singular form','möchtest',UNHEX(SHA2('möchtest',256)),'فرم دوم‌شخص مفرد «mögen» در Konjunktiv II.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

SET @si_hallo := (SELECT id FROM source_items WHERE source_id=@s_hallo AND item_key='srcitem-de-hallo-headword');
SET @si_gm := (SELECT id FROM source_items WHERE source_id=@s_gm AND item_key='srcitem-de-guten-morgen-formula');
SET @si_moegen := (SELECT id FROM source_items WHERE source_id=@s_moegen AND item_key='srcitem-de-moegen-lemma');
SET @si_mag := (SELECT id FROM source_items WHERE source_id=@s_moegen AND item_key='srcitem-de-moegen-mag');
SET @si_magst := (SELECT id FROM source_items WHERE source_id=@s_moegen AND item_key='srcitem-de-moegen-magst');
SET @si_pizza := (SELECT id FROM source_items WHERE source_id=@s_pizza AND item_key='srcitem-de-pizza-headword');
SET @si_stmt := (SELECT id FROM source_items WHERE source_id=@s_libra AND item_key='srcitem-de-ich-mag-pizza');
SET @si_q := (SELECT id FROM source_items WHERE source_id=@s_pq AND item_key='srcitem-de-magst-du-pizza');
SET @si_ja := (SELECT id FROM source_items WHERE source_id=@s_ja AND item_key='srcitem-de-ja-headword');
SET @si_nein := (SELECT id FROM source_items WHERE source_id=@s_nein AND item_key='srcitem-de-nein-headword');
SET @si_danke := (SELECT id FROM source_items WHERE source_id=@s_danke AND item_key='srcitem-de-danke-headword');
SET @si_bitte := (SELECT id FROM source_items WHERE source_id=@s_bitte AND item_key='srcitem-de-bitte-response');
SET @si_wiegehts := (SELECT id FROM source_items WHERE source_id=@s_basic AND item_key='srcitem-de-wie-gehts');
SET @si_gut := (SELECT id FROM source_items WHERE source_id=@s_basic AND item_key='srcitem-de-gut-short');
SET @si_tschuess := (SELECT id FROM source_items WHERE source_id=@s_basic AND item_key='srcitem-de-tschuess');
SET @si_entsch := (SELECT id FROM source_items WHERE source_id=@s_entsch AND item_key='srcitem-de-entschuldigung');
SET @si_keinp := (SELECT id FROM source_items WHERE source_id=@s_keinp AND item_key='srcitem-de-kein-problem');
SET @si_name_q := (SELECT id FROM source_items WHERE source_id=@s_name AND item_key='srcitem-de-wie-heisst-du');
SET @si_name_a := (SELECT id FROM source_items WHERE source_id=@s_name AND item_key='srcitem-de-ich-heisse-iris');
SET @si_heissen := (SELECT id FROM source_items WHERE source_id=@s_heissen AND item_key='srcitem-de-heissen-lemma');
SET @si_heisse := (SELECT id FROM source_items WHERE source_id=@s_heissen AND item_key='srcitem-de-heissen-heisse');
SET @si_heisst := (SELECT id FROM source_items WHERE source_id=@s_heissen AND item_key='srcitem-de-heissen-heisst');
SET @si_choice_q := (SELECT id FROM source_items WHERE source_id=@s_oak_choice AND item_key='srcitem-de-was-moechtest-du');
SET @si_moechtest := (SELECT id FROM source_items WHERE source_id=@s_moechten AND item_key='srcitem-de-moegen-moechtest');

-- Characters ------------------------------------------------------------------
INSERT INTO characters
(character_key,language_id,name,origin,gender,age_band,roles,relationship_tags,context_notes,voice_profile,elevenlabs_voice_id,voice_name) VALUES
('char-de-learner',@de,'زبان‌آموز','app_created','unspecified','unspecified',JSON_ARRAY('learner'),JSON_ARRAY(),
 'نقش عمومی زبان‌آموز؛ برای صحنه‌های فعلی هیچ فرض جمعیت‌شناختی لازم نیست.',
 JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression',NULL,'genderImpression','neutral'),NULL,NULL),
('char-de-mia',@de,'Mia','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY(),
 'شخصیت گفت‌وگویی دوستانه و تکرارشونده؛ جمله‌های منبع فعلی با این هویت اختصاص‌داده‌شده تعارض ندارند.',
 JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young adult','genderImpression','female'),NULL,NULL),
('char-de-iris',@de,'Iris','app_created','unspecified','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY(),
 'شخصیت گفت‌وگویی برای تمرین نام‌پرسیدن؛ دربارهٔ جنسیت یا ویژگی‌های دیگری که منبع مشخص نکرده چیزی فرض نشده است.',
 JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young adult','genderImpression','neutral'),NULL,NULL)
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),name=VALUES(name),origin=VALUES(origin),gender=VALUES(gender),
 age_band=VALUES(age_band),roles=VALUES(roles),relationship_tags=VALUES(relationship_tags),context_notes=VALUES(context_notes),voice_profile=VALUES(voice_profile);
SET @learner := (SELECT id FROM characters WHERE character_key='char-de-learner');
SET @mia := (SELECT id FROM characters WHERE character_key='char-de-mia');
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris');

-- Unit / lessons --------------------------------------------------------------
INSERT INTO units (unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-pre-a1-unit-first-steps',@level,1,'اولین قدم‌ها',
 'این درس‌ها کنار هم قرار گرفته‌اند چون همگی ارتباط‌های بسیار ساده، فوری و کم‌فشار برای شروع از صفر هستند. این گروه‌بندی دلیل آموزشی دارد و ظرفیت عددی برای تعداد درس ندارد.',
 'draft',JSON_OBJECT('dynamicStructure',TRUE),
 'باز یا بسته‌ماندن این واحد فقط به تصمیم‌های پوشش آموزشی بعدی بستگی دارد، نه به رسیدن به تعداد مشخصی درس.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),
 grouping_rationale=VALUES(grouping_rationale),status=VALUES(status),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-pre-a1-unit-first-steps');

INSERT INTO lessons
(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-pre-a1-lesson-hallo',@level,@unit,1,1,'سلام!','hallo / Tschüss!','draft',
 'برای درس اول، یک گفت‌وگوی چهار turn از سلام تا خداحافظی کافی است و بار زبانی بیشتری اضافه نمی‌شود.',
 'زبان‌آموز فقط دو عبارت بسیار پایه را در یک رفت‌وبرگشت کوتاه استفاده می‌کند.','conversation_speaking','blocked_until_level_final',NULL),
('de-pre-a1-lesson-guten-morgen',@level,@unit,2,2,'صبح بخیر!','guten Morgen / Tschüss!','draft',
 'گفت‌وگوی چهار turn فقط سلام صبحگاهی و خداحافظی را تمرین می‌کند؛ بعد یک فعالیت تشخیصی تفاوت آن را با سلام عمومی تثبیت می‌کند.',
 'اول زبان‌آموز خودش مکالمه را با عبارت صبحگاهی آغاز می‌کند و بعد زمان مناسب استفاده از آن را تشخیص می‌دهد.','conversation_speaking>multiple_choice','blocked_until_level_final',NULL),
('de-pre-a1-lesson-pizza-like',@level,@unit,3,3,'پیتزا دوست دارم','Magst du Pizza? / Ich mag Pizza.','draft',
 'گفت‌وگوی چهار turn پرسش و پاسخ دربارهٔ علاقه به پیتزا را در بافت قرار می‌دهد و سپس بازسازی همان جمله یک بازیابی متمرکز ایجاد می‌کند.',
 'اول زبان‌آموز در مکالمهٔ کوتاه به پرسش واقعی پاسخ می‌دهد و بعد همان جملهٔ منبع‌دار را دوباره می‌سازد.','conversation_speaking>word_order','blocked_until_level_final',NULL),
('de-pre-a1-lesson-ja-nein',@level,@unit,4,4,'بله یا نه؟','Magst du Pizza? / ja / nein','draft',
 'مکالمهٔ چهار turn این بار با زبان‌آموز شروع می‌شود تا سؤال آشنا را فعالانه بپرسد؛ سپس انتخاب پاسخ تفاوت «ja» و «nein» را تمرین می‌کند.',
 'اول زبان‌آموز نقش آغازکننده و پرسشگر را می‌گیرد، سپس پاسخ مثبت و منفی را در همان بافت تشخیص می‌دهد.','conversation_speaking>choose_response','blocked_until_level_final',NULL),
('de-pre-a1-lesson-danke-bitte',@level,@unit,5,5,'ممنون! خواهش می‌کنم','danke / bitte','draft',
 'گفت‌وگوی چهار turn عبارت تشکر و پاسخ مؤدبانه را داخل یک تعامل کوتاه و روشن قرار می‌دهد و برای این هدف تمرین اضافه لازم نیست.',
 'زبان‌آموز سلام می‌کند، تشکر را در بافت می‌شنود و پاسخ مؤدبانه می‌دهد؛ مکالمه عمداً طولانی‌تر نمی‌شود.','conversation_speaking','blocked_until_level_final',NULL),
('de-pre-a1-lesson-entschuldigung',@level,@unit,6,6,'ببخشید!','Entschuldigung. / Kein Problem. / Danke! / Bitte!','draft',
 'بعد از گفت‌وگوی کوتاه، matching فقط رابطهٔ دو جفت اجتماعی نزدیک را تثبیت می‌کند و زبان تازه‌ای وارد نمی‌کند.',
 'زبان‌آموز ابتدا خودش عذرخواهی را آغاز می‌کند و بعد پاسخ‌های مناسب را به عبارت‌های آشنا وصل می‌کند.','conversation_speaking>matching','blocked_until_level_final',NULL),
('de-pre-a1-lesson-name-exchange',@level,@unit,7,7,'اسمت چیه؟','Wie heißt du? / Ich heiße Iris.','draft',
 'گفت‌وگو نام‌پرسیدن را در بافت قرار می‌دهد و word order همان پاسخ منبع‌دار را برای بازیابی الگوی «Ich heiße ...» تمرین می‌کند.',
 'اول زبان‌آموز سؤال نام را در مکالمه استفاده می‌کند و بعد پاسخ منبع‌دار را بدون معرفی جملهٔ تازه بازسازی می‌کند.','conversation_speaking>word_order','blocked_until_level_final',NULL),
('de-pre-a1-lesson-wellbeing',@level,@unit,8,8,'حالت چطوره؟','Wie geht''s? / Gut.','draft',
 'بعد از گفت‌وگو، fill blank فقط عبارت تازهٔ «Wie geht''s?» را با حذف یک بخش کوچک بازیابی می‌کند و بار شناختی را پایین نگه می‌دارد.',
 'اول معنی و پاسخ در مکالمه دیده می‌شود و بعد همان عبارت منبع‌دار با یک جای‌خالی ساده بازیابی می‌شود.','conversation_speaking>fill_blank','blocked_until_level_final',NULL),
('de-pre-a1-lesson-simple-choice',@level,@unit,9,9,'چی می‌خوای؟','Was möchtest du? / Pizza','draft',
 'هدف این مرحله فقط فهم یک پرسش سادهٔ خواستن و انتخاب یک گزینهٔ آشناست؛ همان گفت‌وگوی چهار turn هدف را کامل پوشش می‌دهد و تمرین اضافه لازم نیست.',
 'زبان‌آموز ابتدا سلام آشنا را بازیابی می‌کند، سپس پرسش تازه را می‌شنود و بدون واژهٔ جدید با «Pizza.» پاسخ می‌دهد.','conversation_speaking','blocked_until_level_final',NULL)
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),
 position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);

SET @l1 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-hallo');
SET @l2 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-guten-morgen');
SET @l3 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-pizza-like');
SET @l4 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-ja-nein');
SET @l5 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-danke-bitte');
SET @l6 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-entschuldigung');
SET @l7 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-name-exchange');
SET @l8 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-wellbeing');
SET @l9 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-choice');

DELETE lt FROM lesson_targets lt JOIN lessons l ON l.id=lt.lesson_id WHERE l.language_level_id=@level;
DELETE ut FROM unit_targets ut JOIN units u ON u.id=ut.unit_id WHERE u.language_level_id=@level;

INSERT INTO unit_targets (unit_id,curriculum_target_id) VALUES
(@unit,@t_hallo),(@unit,@t_bye),(@unit,@t_gm),(@unit,@t_gm_diff),(@unit,@t_pq),(@unit,@t_pa),(@unit,@t_forms),
(@unit,@t_ja),(@unit,@t_nein),(@unit,@t_danke),(@unit,@t_bitte),(@unit,@t_apology),(@unit,@t_name),(@unit,@t_heissen),(@unit,@t_wellbeing),(@unit,@t_choice),(@unit,@t_moechtest);

INSERT INTO lesson_targets (lesson_id,curriculum_target_id,coverage_role) VALUES
(@l1,@t_hallo,'introduce'),(@l1,@t_bye,'introduce'),
(@l2,@t_gm,'introduce'),(@l2,@t_gm_diff,'practice'),(@l2,@t_bye,'review'),
(@l3,@t_pq,'introduce'),(@l3,@t_pa,'introduce'),(@l3,@t_forms,'support'),
(@l4,@t_ja,'introduce'),(@l4,@t_nein,'practice'),(@l4,@t_pq,'review'),
(@l5,@t_danke,'introduce'),(@l5,@t_bitte,'introduce'),
(@l6,@t_apology,'introduce'),(@l6,@t_danke,'review'),(@l6,@t_bitte,'review'),
(@l7,@t_name,'introduce'),(@l7,@t_heissen,'support'),(@l7,@t_hallo,'review'),
(@l8,@t_wellbeing,'introduce'),(@l8,@t_hallo,'review'),
(@l9,@t_choice,'introduce'),(@l9,@t_moechtest,'support'),(@l9,@t_hallo,'review');


-- Dialogues / turns -----------------------------------------------------------
INSERT INTO dialogues (dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-pre-a1-hallo',@level,'میا و زبان‌آموز با یک سلام ساده شروع می‌کنند و با یک خداحافظی کوتاه مکالمه را تمام می‌کنند.','app','برای شروع دوره، مکالمه عمداً روی چهار turn نگه داشته شده و فقط سلام و خداحافظی بسیار ساده را تمرین می‌کند.'),
('dlg-de-pre-a1-guten-morgen',@level,'صبح است و این بار زبان‌آموز گفت‌وگو را با سلام صبحگاهی شروع می‌کند و مکالمه با یک خداحافظی کوتاه تمام می‌شود.','learner','زبان‌آموز نقش آغازکننده را می‌گیرد و مکالمه برای شروع دوره عمداً در چهار turn و با دو عبارت بسیار ساده نگه داشته شده است.'),
('dlg-de-pre-a1-pizza-like',@level,'میا و زبان‌آموز سلام می‌کنند و بعد یک پرسش و پاسخ کوتاه دربارهٔ دوست‌داشتن پیتزا دارند.','app','پرسش و پاسخ اصلی دربارهٔ پیتزا در چهار turn کامل می‌شود و برای درس‌های ابتدایی هیچ ادامهٔ غیرضروری به مکالمه اضافه نشده است.'),
('dlg-de-pre-a1-ja',@level,'این بار زبان‌آموز خودش سلام می‌کند و سؤال آشنای پیتزا را می‌پرسد؛ میا با یک پاسخ مثبت کوتاه جواب می‌دهد.','learner','زبان‌آموز در چهار turn کوتاه هم مکالمه را شروع می‌کند و هم سؤال آشنا را فعالانه می‌پرسد؛ ادامهٔ غیرضروری حذف شده است.'),
('dlg-de-pre-a1-danke-bitte',@level,'میا و زبان‌آموز سلام می‌کنند؛ بعد از یک کمک کوچک میا تشکر می‌کند و زبان‌آموز پاسخ مؤدبانه می‌دهد.','app','تشکر و پاسخ مؤدبانه در چهار turn کوتاه و بدون وابستگی به تصویر یا جملهٔ ساختگی تمرین می‌شوند.'),
('dlg-de-pre-a1-entschuldigung',@level,'زبان‌آموز برای یک اشتباه کوچک عذرخواهی می‌کند، میا پاسخ آرام می‌دهد و تعامل با تشکر و پاسخ مؤدبانه تمام می‌شود.','learner','چهار turn یک تبادل اجتماعی کامل و کم‌فشار می‌سازند و هر چهار عبارت از منابع مدرن قابل‌ردیابی آمده‌اند.'),
('dlg-de-pre-a1-name-exchange',@level,'آیریس سلام می‌کند و زبان‌آموز پس از پاسخ، نام او را می‌پرسد و یک پاسخ ساده با «heißen» می‌شنود.','app','مکالمه فقط یک سلام و یک پرسش‌وپاسخ نام دارد؛ برای شروع از صفر کوتاه است و فرم‌های «heißt / heiße» مستقیماً به lexeme پایه متصل‌اند.'),
('dlg-de-pre-a1-wellbeing',@level,'میا و زبان‌آموز سلام می‌کنند و میا یک احوال‌پرسی خیلی کوتاه می‌پرسد که زبان‌آموز با یک پاسخ ساده جواب می‌دهد.','app','فقط چهار turn لازم برای سلام و یک احوال‌پرسی پایه نگه داشته شده و هیچ عبارت اضافی برای طولانی‌کردن صحنه وارد نشده است.'),
('dlg-de-pre-a1-simple-choice',@level,'میا و زبان‌آموز سلام می‌کنند؛ میا می‌پرسد زبان‌آموز چه می‌خواهد و زبان‌آموز یک گزینهٔ کاملاً آشنا را انتخاب می‌کند.','app','درس نهم هنوز در بازهٔ ده درس اول است؛ مکالمه دقیقاً چهار turn دارد و فقط یک پرسش تازه را با یک پاسخ آشنا ترکیب می‌کند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);

SET @d1 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-hallo');
SET @d2 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-guten-morgen');
SET @d3 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-pizza-like');
SET @d4 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-ja');
SET @d5 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-danke-bitte');
SET @d6 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-entschuldigung');
SET @d7 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-name-exchange');
SET @d8 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-wellbeing');
SET @d9 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-simple-choice');

DELETE FROM lexeme_occurrences WHERE owner_type='dialogue_turn' AND owner_key LIKE 'turn-de-%';
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key LIKE 'turn-de-%';

INSERT INTO dialogue_turns
(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status,audio_url,audio_voice_id) VALUES
('turn-de-hallo-1',@d1,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-hallo-2',@d1,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-hallo-3',@d1,3,@mia,'app_assigned','unspecified','Tschüss!','خداحافظ!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-hallo-4',@d1,4,@learner,'app_assigned','unspecified','Tschüss!','خداحافظ!',TRUE,'blocked_until_level_final',NULL,NULL),

('turn-de-gm-1',@d2,1,@learner,'app_assigned','unspecified','Guten Morgen!','صبح بخیر!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-gm-2',@d2,2,@mia,'app_assigned','unspecified','Guten Morgen!','صبح بخیر!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-gm-3',@d2,3,@mia,'app_assigned','unspecified','Tschüss!','خداحافظ!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-gm-4',@d2,4,@learner,'app_assigned','unspecified','Tschüss!','خداحافظ!',TRUE,'blocked_until_level_final',NULL,NULL),

('turn-de-pizza-1',@d3,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-pizza-2',@d3,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-pizza-3',@d3,3,@mia,'app_assigned','unspecified','Magst du Pizza?','پیتزا دوست داری؟',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-pizza-4',@d3,4,@learner,'app_assigned','unspecified','Ich mag Pizza.','من پیتزا دوست دارم.',TRUE,'blocked_until_level_final',NULL,NULL),

('turn-de-ja-1',@d4,1,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-ja-2',@d4,2,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-ja-3',@d4,3,@learner,'app_assigned','unspecified','Magst du Pizza?','پیتزا دوست داری؟',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-ja-4',@d4,4,@mia,'app_assigned','unspecified','Ja!','بله!',FALSE,'blocked_until_level_final',NULL,NULL),

('turn-de-danke-bitte-1',@d5,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-danke-bitte-2',@d5,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-danke-bitte-3',@d5,3,@mia,'app_assigned','unspecified','Danke!','ممنون!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-danke-bitte-4',@d5,4,@learner,'app_assigned','unspecified','Bitte!','خواهش می‌کنم!',TRUE,'blocked_until_level_final',NULL,NULL),

('turn-de-entschuldigung-1',@d6,1,@learner,'app_assigned','unspecified','Entschuldigung.','ببخشید.',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-entschuldigung-2',@d6,2,@mia,'app_assigned','unspecified','Kein Problem.','مشکلی نیست.',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-entschuldigung-3',@d6,3,@learner,'app_assigned','unspecified','Danke!','ممنون!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-entschuldigung-4',@d6,4,@mia,'app_assigned','unspecified','Bitte!','خواهش می‌کنم!',FALSE,'blocked_until_level_final',NULL,NULL),

('turn-de-name-1',@d7,1,@iris,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-name-2',@d7,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-name-3',@d7,3,@learner,'app_assigned','unspecified','Wie heißt du?','اسمت چیه؟',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-name-4',@d7,4,@iris,'app_assigned','unspecified','Ich heiße Iris.','اسم من آیریس است.',FALSE,'blocked_until_level_final',NULL,NULL),

('turn-de-wellbeing-1',@d8,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-wellbeing-2',@d8,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-wellbeing-3',@d8,3,@mia,'app_assigned','unspecified','Wie geht''s?','حالت چطوره؟',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-wellbeing-4',@d8,4,@learner,'app_assigned','unspecified','Gut.','خوبم.',TRUE,'blocked_until_level_final',NULL,NULL),

('turn-de-choice-1',@d9,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-choice-2',@d9,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_level_final',NULL,NULL),
('turn-de-choice-3',@d9,3,@mia,'app_assigned','unspecified','Was möchtest du?','چی می‌خوای؟',FALSE,'blocked_until_level_final',NULL,NULL),
('turn-de-choice-4',@d9,4,@learner,'app_assigned','unspecified','Pizza.','پیتزا.',TRUE,'blocked_until_level_final',NULL,NULL)
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
DELETE FROM dialogue_turns WHERE dialogue_id IN (@d1,@d2,@d3,@d4,@d5,@d6,@d7,@d8,@d9) AND turn_key NOT IN ('turn-de-hallo-1','turn-de-hallo-2','turn-de-hallo-3','turn-de-hallo-4','turn-de-gm-1','turn-de-gm-2','turn-de-gm-3','turn-de-gm-4','turn-de-pizza-1','turn-de-pizza-2','turn-de-pizza-3','turn-de-pizza-4','turn-de-ja-1','turn-de-ja-2','turn-de-ja-3','turn-de-ja-4','turn-de-danke-bitte-1','turn-de-danke-bitte-2','turn-de-danke-bitte-3','turn-de-danke-bitte-4','turn-de-entschuldigung-1','turn-de-entschuldigung-2','turn-de-entschuldigung-3','turn-de-entschuldigung-4','turn-de-name-1','turn-de-name-2','turn-de-name-3','turn-de-name-4','turn-de-wellbeing-1','turn-de-wellbeing-2','turn-de-wellbeing-3','turn-de-wellbeing-4','turn-de-choice-1','turn-de-choice-2','turn-de-choice-3','turn-de-choice-4');

-- Activities ------------------------------------------------------------------
INSERT INTO activities
(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_status) VALUES
('act-de-hallo-conversation',@l1,1,'conversation_speaking',
 'با میا یک گفت‌وگوی خیلی کوتاه از سلام تا خداحافظی انجام بده.',
 'برای شروع دوره همین تعامل چهار turn هدف اصلی را پوشش می‌دهد و تمرین اضافه لازم نیست.',@d1,
 JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required'),

('act-de-gm-conversation',@l2,1,'conversation_speaking',
 'این بار تو گفت‌وگو را شروع کن؛ صبح است، به میا «Guten Morgen!» بگو و مکالمهٔ کوتاه را ادامه بده.',
 'شروع‌کردن مکالمه توسط زبان‌آموز باعث می‌شود سلام صبحگاهی را فعالانه تولید کند، بدون اینکه مکالمهٔ شروع دوره طولانی شود.',@d2,
 JSON_OBJECT('interaction','read_aloud_exchange','contextFa','صبح است.','openingInitiator','learner'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required'),
('act-de-gm-choice',@l2,2,'multiple_choice',
 'برای سلام کردن در صبح کدام عبارت مناسب‌تر است؟',
 'این فعالیت فقط تفاوت جدید درس را می‌سنجد: سلام مخصوص صبح در برابر سلام عمومی.',NULL,
 JSON_OBJECT('promptFa','صبح است.','options',JSON_ARRAY(
  JSON_OBJECT('textTarget','Guten Morgen!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-guten-morgen')),
  JSON_OBJECT('textTarget','Hallo!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-hallo'))
 )),
 JSON_ARRAY('options_selected_from_source_material'),'not_required'),

('act-de-pizza-conversation',@l3,1,'conversation_speaking',
 'با میا دربارهٔ پیتزا یک گفت‌وگوی چهار turn داشته باش و به سؤالش جواب بده.',
 'موضوع آشنای پیتزا امکان استفادهٔ فوری و قابل‌فهم از «mögen» را در یک مکالمهٔ کوتاه فراهم می‌کند.',@d3,
 JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required'),
('act-de-pizza-word-order',@l3,2,'word_order',
 'جمله‌ای را که همین الان گفتی دوباره بساز.',
 'بازسازی همان جملهٔ منبع‌دار، الگوی جدید را بدون واردکردن زبان تازه تقویت می‌کند.',NULL,
 JSON_OBJECT('sourceText','Ich mag Pizza.','tokens',JSON_ARRAY('Ich','mag','Pizza.'),'answer',JSON_ARRAY('Ich','mag','Pizza.'),
  'tokenLexemeMappings',JSON_ARRAY(
   JSON_OBJECT('token','mag','lexemeId','lex-de-moegen','lexemeFormId','lexform-de-moegen-mag'),
   JSON_OBJECT('token','Pizza.','lexemeId','lex-de-pizza','lexemeFormId',NULL)
  )),
 JSON_ARRAY('sentence_tokenized_for_word_order'),'not_required'),

('act-de-ja-conversation',@l4,1,'conversation_speaking',
 'این بار تو مکالمه را شروع کن؛ سلام کن و سؤال آشنای پیتزا را از میا بپرس.',
 'شروع مکالمه توسط زبان‌آموز، زبان آشنای قبلی را از حالت پاسخ‌دادن به تولید فعال تبدیل می‌کند و در چهار turn تمام می‌شود.',@d4,
 JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required'),
('act-de-ja-nein-choice',@l4,2,'choose_response',
 'فرض کن پیتزا دوست نداری. کدام جواب مناسب است؟',
 'چون پرسش از قبل آشناست، تمرکز فعالیت فقط روی تشخیص پاسخ مثبت و منفی می‌ماند.',NULL,
 JSON_OBJECT('promptTarget','Magst du Pizza?','contextFa','پیتزا دوست نداری.','options',JSON_ARRAY(
  JSON_OBJECT('textTarget','Ja!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-ja')),
  JSON_OBJECT('textTarget','Nein!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-nein'))
 )),
 JSON_ARRAY('options_selected_from_source_material'),'not_required'),

('act-de-danke-bitte-conversation',@l5,1,'conversation_speaking',
 'میا بعد از یک کمک کوچک تشکر می‌کند؛ پاسخ مؤدبانه بده.',
 '«Danke!» و «Bitte!» در یک تعامل چهار turn روزمره بهتر از دو کارت جداگانه یاد گرفته می‌شوند.',@d5,
 JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required'),

('act-de-entschuldigung-conversation',@l6,1,'conversation_speaking',
 'این بار تو گفت‌وگو را شروع کن؛ برای یک اشتباه کوچک با «Entschuldigung.» عذرخواهی کن.',
 'هدف اصلی این درس استفادهٔ فعال از یک عذرخواهی کوتاه در یک تعامل واقعی و کم‌فشار است.',@d6,
 JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required'),
('act-de-entschuldigung-matching',@l6,2,'matching',
 'هر عبارت را به پاسخ مناسبش وصل کن.',
 'دو جفت اجتماعی کوتاه ممکن است در شروع دوره با هم قاطی شوند؛ matching بدون افزودن متن تازه رابطهٔ درست را تمرین می‌کند.',NULL,
 JSON_OBJECT('pairs',JSON_ARRAY(
  JSON_OBJECT('left','Entschuldigung.','right','Kein Problem.','sourceRefs',JSON_ARRAY('src-wiktionary-de-entschuldigung','src-wiktionary-de-kein-problem')),
  JSON_OBJECT('left','Danke!','right','Bitte!','sourceRefs',JSON_ARRAY('src-wiktionary-de-danke','src-wiktionary-de-bitte'))
 )),
 JSON_ARRAY('source_backed_pairs_grouped'),'not_required'),

('act-de-name-conversation',@l7,1,'conversation_speaking',
 'بعد از سلام، نام آیریس را با «Wie heißt du?» بپرس.',
 'پرسیدن نام یکی از اولین کنش‌های ارتباطی مفید است و در چهار turn ساده قابل تمرین است.',@d7,
 JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required'),
('act-de-name-word-order',@l7,2,'word_order',
 'پاسخ آیریس را دوباره بساز.',
 'بازسازی جملهٔ دقیق منبع، الگوی «Ich heiße ...» و فرم «heiße» را بدون توضیح دستوری سنگین تقویت می‌کند.',NULL,
 JSON_OBJECT('sourceText','Ich heiße Iris.','tokens',JSON_ARRAY('Ich','heiße','Iris.'),'answer',JSON_ARRAY('Ich','heiße','Iris.'),
  'tokenLexemeMappings',JSON_ARRAY(JSON_OBJECT('token','heiße','lexemeId','lex-de-heissen','lexemeFormId','lexform-de-heissen-heisse'))),
 JSON_ARRAY('sentence_tokenized_for_word_order'),'not_required'),

('act-de-wellbeing-conversation',@l8,1,'conversation_speaking',
 'با میا سلام کن و وقتی می‌پرسد «Wie geht''s?» با «Gut.» جواب بده.',
 'احوال‌پرسی پایه باید اول در یک تعامل کوتاه و روشن دیده و گفته شود.',@d8,
 JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required'),
('act-de-wellbeing-fill',@l8,2,'fill_blank',
 'عبارت احوال‌پرسی را کامل کن.',
 'جای‌خالی از همان عبارت منبع‌دار ساخته شده و بدون معرفی واژهٔ تازه یک بازیابی سبک ایجاد می‌کند.',NULL,
 JSON_OBJECT('sourceText','Wie geht''s?','blankedText','Wie ___?','choices',JSON_ARRAY('geht''s','gut'),'answer','geht''s'),
 JSON_ARRAY('source_sentence_blanked'),'not_required'),

('act-de-simple-choice-conversation',@l9,1,'conversation_speaking',
 'با میا سلام کن؛ وقتی می‌پرسد «Was möchtest du?» گزینهٔ آشنای «Pizza.» را انتخاب کن.',
 'پرسش تازه با پاسخ از قبل آشنا تمرین می‌شود تا بار شناختی فقط روی «möchtest» و مفهوم انتخاب بماند.',@d9,
 JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),
 JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations);

SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-hallo-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-gm-conversation');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-gm-choice');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-pizza-conversation');
SET @a5 := (SELECT id FROM activities WHERE activity_key='act-de-pizza-word-order');
SET @a6 := (SELECT id FROM activities WHERE activity_key='act-de-ja-conversation');
SET @a7 := (SELECT id FROM activities WHERE activity_key='act-de-ja-nein-choice');
SET @a8 := (SELECT id FROM activities WHERE activity_key='act-de-danke-bitte-conversation');
SET @a9 := (SELECT id FROM activities WHERE activity_key='act-de-entschuldigung-conversation');
SET @a10 := (SELECT id FROM activities WHERE activity_key='act-de-entschuldigung-matching');
SET @a11 := (SELECT id FROM activities WHERE activity_key='act-de-name-conversation');
SET @a12 := (SELECT id FROM activities WHERE activity_key='act-de-name-word-order');
SET @a13 := (SELECT id FROM activities WHERE activity_key='act-de-wellbeing-conversation');
SET @a14 := (SELECT id FROM activities WHERE activity_key='act-de-wellbeing-fill');
SET @a15 := (SELECT id FROM activities WHERE activity_key='act-de-simple-choice-conversation');


-- Lexemes / forms -------------------------------------------------------------
INSERT INTO lexemes
(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status,audio_url,audio_voice_name,audio_voice_id) VALUES
('lex-de-hallo',@de,'word','hallo','hallo','hallo','interjection','حرف ندا / عبارت واکنشی','Pre-A1','سلام','برای سلام‌کردن دوستانه و عمومی.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-guten-morgen',@de,'phrase','guten Morgen','guten morgen',NULL,'greeting_formula','عبارت سلام و احوال‌پرسی','Pre-A1','صبح بخیر','برای سلام‌کردن در صبح.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-moegen',@de,'word','mögen','mögen','mögen','verb','فعل','Pre-A1','دوست داشتن / خوش آمدن',NULL,TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-pizza',@de,'word','Pizza','pizza','Pizza','noun','اسم','Pre-A1','پیتزا',NULL,TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-ja',@de,'word','ja','ja','ja','response_particle','واژهٔ پاسخ','Pre-A1','بله','برای پاسخ مثبت و موافقت.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-nein',@de,'word','nein','nein','nein','response_particle','واژهٔ پاسخ','Pre-A1','نه','برای پاسخ منفی.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-danke',@de,'word','danke','danke','danke','interjection_response_particle','عبارت واکنشی / واژهٔ پاسخ','Pre-A1','ممنون / متشکرم','برای تشکر کوتاه و روزمره.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-bitte',@de,'word','bitte','bitte','bitte','adverb_response_particle','قید / واژهٔ پاسخ','Pre-A1','خواهش می‌کنم / لطفاً','در این مرحله فقط به معنی «خواهش می‌کنم» در پاسخ به تشکر استفاده می‌شود.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-wie-gehts',@de,'phrase','wie geht''s','wie geht''s',NULL,'greeting_formula','عبارت سلام و احوال‌پرسی','Pre-A1','حالت چطوره؟','برای احوال‌پرسی دوستانه و خیلی کوتاه.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-gut',@de,'word','gut','gut','gut','adjective_response','صفت / پاسخ کوتاه','Pre-A1','خوب','در این مرحله «Gut.» به‌عنوان پاسخ کوتاه به احوال‌پرسی استفاده می‌شود.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-tschuess',@de,'word','tschüss','tschüss','tschüss','farewell_formula','عبارت خداحافظی','Pre-A1','خداحافظ / فعلاً','برای خداحافظی دوستانه و غیررسمی.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-entschuldigung',@de,'word','Entschuldigung','entschuldigung','Entschuldigung','interjection','حرف ندا / عبارت واکنشی','Pre-A1','ببخشید / معذرت می‌خواهم','برای عذرخواهی کوتاه یا شروع مؤدبانهٔ خطاب به کسی.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-kein-problem',@de,'phrase','kein Problem','kein problem',NULL,'response_formula','عبارت پاسخ','Pre-A1','مشکلی نیست','برای پاسخ کوتاه و دوستانه به یک عذرخواهی ساده.',TRUE,'blocked_until_level_final',NULL,NULL,NULL),
('lex-de-heissen',@de,'word','heißen','heißen','heißen','verb','فعل','Pre-A1','نام داشتن / نامیده شدن','در این مرحله فقط برای پرسیدن نام و گفتن نام استفاده می‌شود.',TRUE,'blocked_until_level_final',NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),
 normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),
 translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);

SET @x_hallo := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hallo');
SET @x_gm := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-guten-morgen');
SET @x_moegen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-moegen');
SET @x_pizza := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-pizza');
SET @x_ja := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-ja');
SET @x_nein := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-nein');
SET @x_danke := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-danke');
SET @x_bitte := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bitte');
SET @x_wiegehts := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-wie-gehts');
SET @x_gut := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-gut');
SET @x_tschuess := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-tschuess');
SET @x_entsch := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-entschuldigung');
SET @x_keinp := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kein-problem');
SET @x_heissen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-heissen');

INSERT INTO lexeme_forms (lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes) VALUES
('lexform-de-moegen-mag',@x_moegen,'mag','mag','inflected',JSON_OBJECT('tense','present','mood','indicative','person',JSON_ARRAY('1','3'),'number','singular'),'reference_attested','approved','در جملهٔ منبع‌دار «Ich mag Pizza.» به‌صورت اول‌شخص مفرد استفاده شده است.'),
('lexform-de-moegen-magst',@x_moegen,'magst','magst','inflected',JSON_OBJECT('tense','present','mood','indicative','person','2','number','singular'),'reference_attested','approved','در پرسش منبع‌دار «Magst du Pizza?» به‌صورت دوم‌شخص مفرد استفاده شده است.'),
('lexform-de-moegen-moechtest',@x_moegen,'möchtest','möchtest','inflected',JSON_OBJECT('mood','subjunctive_II','person','2','number','singular'),'reference_attested','approved','در پرسش منبع‌دار «Was möchtest du?» به lexeme پایهٔ «mögen» متصل است.'),
('lexform-de-heissen-heisse',@x_heissen,'heiße','heiße','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'reference_attested','approved','در جملهٔ منبع‌دار «Ich heiße Iris.» به‌صورت اول‌شخص مفرد استفاده شده است.'),
('lexform-de-heissen-heisst',@x_heissen,'heißt','heißt','inflected',JSON_OBJECT('tense','present','mood','indicative','person','2','number','singular'),'reference_attested','approved','در پرسش منبع‌دار «Wie heißt du?» به‌صورت دوم‌شخص مفرد استفاده شده است.')
ON DUPLICATE KEY UPDATE lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),
 form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);

SET @f_mag := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-mag');
SET @f_magst := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-magst');
SET @f_moechtest := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-moechtest');
SET @f_heisse := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-heissen-heisse');
SET @f_heisst := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-heissen-heisst');

DELETE ll FROM lesson_lexemes ll JOIN lessons l ON l.id=ll.lesson_id WHERE l.language_level_id=@level;
INSERT INTO lesson_lexemes (lesson_id,lexeme_id,is_primary,role) VALUES
(@l1,@x_hallo,TRUE,'introduce'),(@l1,@x_tschuess,TRUE,'introduce'),
(@l2,@x_gm,TRUE,'introduce'),(@l2,@x_hallo,FALSE,'review'),(@l2,@x_tschuess,FALSE,'review'),
(@l3,@x_hallo,FALSE,'review'),(@l3,@x_moegen,TRUE,'introduce'),(@l3,@x_pizza,TRUE,'support'),
(@l4,@x_hallo,FALSE,'review'),(@l4,@x_moegen,FALSE,'review'),(@l4,@x_pizza,FALSE,'review'),(@l4,@x_ja,TRUE,'introduce'),(@l4,@x_nein,TRUE,'practice'),
(@l5,@x_hallo,FALSE,'review'),(@l5,@x_danke,TRUE,'introduce'),(@l5,@x_bitte,TRUE,'introduce'),
(@l6,@x_entsch,TRUE,'introduce'),(@l6,@x_keinp,TRUE,'introduce'),(@l6,@x_danke,FALSE,'review'),(@l6,@x_bitte,FALSE,'review'),
(@l7,@x_hallo,FALSE,'review'),(@l7,@x_heissen,TRUE,'introduce'),
(@l8,@x_hallo,FALSE,'review'),(@l8,@x_wiegehts,TRUE,'introduce'),(@l8,@x_gut,TRUE,'introduce'),
(@l9,@x_hallo,FALSE,'review'),(@l9,@x_moegen,TRUE,'practice'),(@l9,@x_pizza,FALSE,'review');

DELETE al FROM activity_lexemes al JOIN activities a ON a.id=al.activity_id JOIN lessons l ON l.id=a.lesson_id WHERE l.language_level_id=@level;
INSERT INTO activity_lexemes (activity_id,lexeme_id) VALUES
(@a1,@x_hallo),(@a1,@x_tschuess),
(@a2,@x_gm),(@a2,@x_tschuess),(@a3,@x_gm),(@a3,@x_hallo),
(@a4,@x_hallo),(@a4,@x_moegen),(@a4,@x_pizza),(@a5,@x_moegen),(@a5,@x_pizza),
(@a6,@x_hallo),(@a6,@x_moegen),(@a6,@x_pizza),(@a6,@x_ja),(@a7,@x_ja),(@a7,@x_nein),
(@a8,@x_hallo),(@a8,@x_danke),(@a8,@x_bitte),
(@a9,@x_entsch),(@a9,@x_keinp),(@a9,@x_danke),(@a9,@x_bitte),
(@a10,@x_entsch),(@a10,@x_keinp),(@a10,@x_danke),(@a10,@x_bitte),
(@a11,@x_hallo),(@a11,@x_heissen),(@a12,@x_heissen),
(@a13,@x_hallo),(@a13,@x_wiegehts),(@a13,@x_gut),(@a14,@x_wiegehts),(@a14,@x_gut),
(@a15,@x_hallo),(@a15,@x_moegen),(@a15,@x_pizza);

DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id JOIN lessons l ON l.id=a.lesson_id WHERE l.language_level_id=@level;
INSERT INTO activity_targets (activity_id,curriculum_target_id) VALUES
(@a1,@t_hallo),(@a1,@t_bye),
(@a2,@t_gm),(@a2,@t_bye),(@a3,@t_gm_diff),
(@a4,@t_pq),(@a4,@t_pa),(@a5,@t_pa),(@a5,@t_forms),
(@a6,@t_pq),(@a6,@t_ja),(@a7,@t_nein),
(@a8,@t_danke),(@a8,@t_bitte),
(@a9,@t_apology),(@a10,@t_apology),(@a10,@t_danke),(@a10,@t_bitte),
(@a11,@t_name),(@a11,@t_heissen),(@a12,@t_heissen),
(@a13,@t_wellbeing),(@a14,@t_wellbeing),
(@a15,@t_choice),(@a15,@t_moechtest);

-- Occurrence resolution -------------------------------------------------------
DELETE FROM lexeme_occurrences
WHERE (owner_type='dialogue_turn' AND owner_key LIKE 'turn-de-%')
   OR (owner_type='activity' AND owner_key LIKE 'act-de-%');

INSERT INTO lexeme_occurrences
(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-hallo-1-1','dialogue_turn','turn-de-hallo-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-hallo-2-1','dialogue_turn','turn-de-hallo-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-hallo-3-1','dialogue_turn','turn-de-hallo-3','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-hallo-4-1','dialogue_turn','turn-de-hallo-4','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),

('occ-turn-de-gm-1-1','dialogue_turn','turn-de-gm-1','Guten Morgen',NULL,NULL,@x_gm,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-2-1','dialogue_turn','turn-de-gm-2','Guten Morgen',NULL,NULL,@x_gm,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-3-1','dialogue_turn','turn-de-gm-3','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-4-1','dialogue_turn','turn-de-gm-4','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),

('occ-turn-de-pizza-1-1','dialogue_turn','turn-de-pizza-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-2-1','dialogue_turn','turn-de-pizza-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-3-1','dialogue_turn','turn-de-pizza-3','Magst',NULL,NULL,@x_moegen,@f_magst,'approved','فرم «Magst» به «mögen» متصل است.'),
('occ-turn-de-pizza-3-2','dialogue_turn','turn-de-pizza-3','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال «Pizza» تأیید شده است.'),
('occ-turn-de-pizza-4-1','dialogue_turn','turn-de-pizza-4','mag',NULL,NULL,@x_moegen,@f_mag,'approved','فرم «mag» به «mögen» متصل است.'),
('occ-turn-de-pizza-4-2','dialogue_turn','turn-de-pizza-4','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال «Pizza» تأیید شده است.'),

('occ-turn-de-ja-1-1','dialogue_turn','turn-de-ja-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence تأیید شده است.'),
('occ-turn-de-ja-2-1','dialogue_turn','turn-de-ja-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence تأیید شده است.'),
('occ-turn-de-ja-3-1','dialogue_turn','turn-de-ja-3','Magst',NULL,NULL,@x_moegen,@f_magst,'approved','فرم «Magst» به «mögen» متصل است.'),
('occ-turn-de-ja-3-2','dialogue_turn','turn-de-ja-3','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال «Pizza» تأیید شده است.'),
('occ-turn-de-ja-4-1','dialogue_turn','turn-de-ja-4','Ja',NULL,NULL,@x_ja,NULL,'approved','اتصال «Ja» تأیید شده است.'),

('occ-turn-de-danke-1-1','dialogue_turn','turn-de-danke-bitte-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence تأیید شده است.'),
('occ-turn-de-danke-2-1','dialogue_turn','turn-de-danke-bitte-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence تأیید شده است.'),
('occ-turn-de-danke-3-1','dialogue_turn','turn-de-danke-bitte-3','Danke',NULL,NULL,@x_danke,NULL,'approved','اتصال «Danke» تأیید شده است.'),
('occ-turn-de-danke-4-1','dialogue_turn','turn-de-danke-bitte-4','Bitte',NULL,NULL,@x_bitte,NULL,'approved','اتصال «Bitte» تأیید شده است.'),

('occ-turn-de-entsch-1-1','dialogue_turn','turn-de-entschuldigung-1','Entschuldigung',NULL,NULL,@x_entsch,NULL,'approved','اتصال «Entschuldigung» تأیید شده است.'),
('occ-turn-de-entsch-2-1','dialogue_turn','turn-de-entschuldigung-2','Kein Problem',NULL,NULL,@x_keinp,NULL,'approved','اتصال «Kein Problem» تأیید شده است.'),
('occ-turn-de-entsch-3-1','dialogue_turn','turn-de-entschuldigung-3','Danke',NULL,NULL,@x_danke,NULL,'approved','اتصال «Danke» تأیید شده است.'),
('occ-turn-de-entsch-4-1','dialogue_turn','turn-de-entschuldigung-4','Bitte',NULL,NULL,@x_bitte,NULL,'approved','اتصال «Bitte» تأیید شده است.'),

('occ-turn-de-name-1-1','dialogue_turn','turn-de-name-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال «Hallo» تأیید شده است.'),
('occ-turn-de-name-2-1','dialogue_turn','turn-de-name-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال «Hallo» تأیید شده است.'),
('occ-turn-de-name-3-1','dialogue_turn','turn-de-name-3','heißt',NULL,NULL,@x_heissen,@f_heisst,'approved','فرم «heißt» به «heißen» متصل است.'),
('occ-turn-de-name-4-1','dialogue_turn','turn-de-name-4','heiße',NULL,NULL,@x_heissen,@f_heisse,'approved','فرم «heiße» به «heißen» متصل است.'),

('occ-turn-de-wellbeing-1-1','dialogue_turn','turn-de-wellbeing-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال «Hallo» تأیید شده است.'),
('occ-turn-de-wellbeing-2-1','dialogue_turn','turn-de-wellbeing-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال «Hallo» تأیید شده است.'),
('occ-turn-de-wellbeing-3-1','dialogue_turn','turn-de-wellbeing-3','Wie geht''s',NULL,NULL,@x_wiegehts,NULL,'approved','اتصال عبارت احوال‌پرسی تأیید شده است.'),
('occ-turn-de-wellbeing-4-1','dialogue_turn','turn-de-wellbeing-4','Gut',NULL,NULL,@x_gut,NULL,'approved','اتصال پاسخ کوتاه تأیید شده است.'),

('occ-act-de-pizza-order-mag','activity','act-de-pizza-word-order','mag',NULL,NULL,@x_moegen,@f_mag,'approved','توکن صرف‌شده به «mögen» متصل است.'),
('occ-act-de-pizza-order-pizza','activity','act-de-pizza-word-order','Pizza.',NULL,NULL,@x_pizza,NULL,'approved','توکن با نشانه‌گذاری به «Pizza» متصل است.'),
('occ-act-de-ja-nein-ja','activity','act-de-ja-nein-choice','Ja!',NULL,NULL,@x_ja,NULL,'approved','گزینه به «ja» متصل است.'),
('occ-act-de-ja-nein-nein','activity','act-de-ja-nein-choice','Nein!',NULL,NULL,@x_nein,NULL,'approved','گزینه به «nein» متصل است.'),
('occ-act-de-name-order-heisse','activity','act-de-name-word-order','heiße',NULL,NULL,@x_heissen,@f_heisse,'approved','توکن «heiße» به «heißen» متصل است.'),
('occ-turn-de-choice-1-1','dialogue_turn','turn-de-choice-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال «Hallo» تأیید شده است.'),
('occ-turn-de-choice-2-1','dialogue_turn','turn-de-choice-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال «Hallo» تأیید شده است.'),
('occ-turn-de-choice-3-1','dialogue_turn','turn-de-choice-3','möchtest',NULL,NULL,@x_moegen,@f_moechtest,'approved','فرم «möchtest» به «mögen» متصل است.'),
('occ-turn-de-choice-4-1','dialogue_turn','turn-de-choice-4','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال «Pizza» تأیید شده است.');


-- Provenance ------------------------------------------------------------------
DELETE FROM provenance_links
WHERE entity_type IN ('lesson','dialogue','dialogue_turn','activity','lexeme','lexeme_form')
  AND (entity_key LIKE 'de-pre-a1-%' OR entity_key LIKE 'dlg-de-pre-a1-%' OR entity_key LIKE 'turn-de-%'
       OR entity_key LIKE 'act-de-%' OR entity_key LIKE 'lex-de-%' OR entity_key LIKE 'lexform-de-%');

INSERT INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes) VALUES
('lesson','de-pre-a1-lesson-hallo',@si_hallo,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-hallo',@si_tschuess,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-guten-morgen',@si_gm,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-guten-morgen',@si_tschuess,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-pizza-like',@si_q,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-pizza-like',@si_stmt,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-ja-nein',@si_q,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-ja-nein',@si_ja,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-ja-nein',@si_nein,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-danke-bitte',@si_danke,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-danke-bitte',@si_bitte,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-entschuldigung',@si_entsch,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-entschuldigung',@si_keinp,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-name-exchange',@si_name_q,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-name-exchange',@si_name_a,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-wellbeing',@si_wiegehts,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-wellbeing',@si_gut,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-simple-choice',@si_choice_q,'other','منبع اصلی پرسش این درس.'),
('lesson','de-pre-a1-lesson-simple-choice',@si_pizza,'other','پاسخ واژگانی آشنا از منبع آمده است.'),

('dialogue_turn','turn-de-hallo-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-hallo-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-hallo-3',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-hallo-4',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),

('dialogue_turn','turn-de-gm-1',@si_gm,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-2',@si_gm,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-3',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-4',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),

('dialogue_turn','turn-de-pizza-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-3',@si_q,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-4',@si_stmt,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),

('dialogue_turn','turn-de-ja-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-3',@si_q,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-4',@si_ja,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),

('dialogue_turn','turn-de-danke-bitte-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-3',@si_danke,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-4',@si_bitte,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),

('dialogue_turn','turn-de-entschuldigung-1',@si_entsch,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-entschuldigung-2',@si_keinp,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-entschuldigung-3',@si_danke,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-entschuldigung-4',@si_bitte,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),

('dialogue_turn','turn-de-name-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-name-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-name-3',@si_name_q,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-name-4',@si_name_a,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),

('dialogue_turn','turn-de-wellbeing-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-wellbeing-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-wellbeing-3',@si_wiegehts,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-wellbeing-4',@si_gut,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-choice-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-choice-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-choice-3',@si_choice_q,'persian_translation_added','پرسش دقیق منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-choice-4',@si_pizza,'persian_translation_added','واژهٔ هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),

('activity','act-de-gm-choice',@si_gm,'other','گزینهٔ درست از منبع آمده است.'),
('activity','act-de-gm-choice',@si_hallo,'other','گزینهٔ مقایسه‌ای از منبع آمده است.'),
('activity','act-de-pizza-word-order',@si_stmt,'sentence_tokenized_for_word_order','جملهٔ منبع‌دار فقط توکن‌بندی شده است.'),
('activity','act-de-ja-nein-choice',@si_q,'other','پرسش از منبع آمده است.'),
('activity','act-de-ja-nein-choice',@si_ja,'other','گزینهٔ پاسخ از منبع آمده است.'),
('activity','act-de-ja-nein-choice',@si_nein,'other','گزینهٔ پاسخ از منبع آمده است.'),
('activity','act-de-entschuldigung-matching',@si_entsch,'other','عبارت جفت‌سازی از منبع آمده است.'),
('activity','act-de-entschuldigung-matching',@si_keinp,'other','پاسخ جفت‌سازی از منبع آمده است.'),
('activity','act-de-entschuldigung-matching',@si_danke,'other','عبارت جفت‌سازی از منبع آمده است.'),
('activity','act-de-entschuldigung-matching',@si_bitte,'other','پاسخ جفت‌سازی از منبع آمده است.'),
('activity','act-de-name-word-order',@si_name_a,'sentence_tokenized_for_word_order','جملهٔ منبع‌دار فقط توکن‌بندی شده است.'),
('activity','act-de-wellbeing-fill',@si_wiegehts,'source_sentence_blank_created','عبارت منبع‌دار فقط برای جای‌خالی تبدیل شده است.'),

('lexeme','lex-de-hallo',@si_hallo,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-guten-morgen',@si_gm,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-moegen',@si_moegen,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-pizza',@si_pizza,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-ja',@si_ja,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-nein',@si_nein,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-danke',@si_danke,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-bitte',@si_bitte,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-wie-gehts',@si_wiegehts,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-gut',@si_gut,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-tschuess',@si_tschuess,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-entschuldigung',@si_entsch,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-kein-problem',@si_keinp,'verbatim','lexeme منبع‌دار.'),
('lexeme','lex-de-heissen',@si_heissen,'verbatim','lexeme منبع‌دار.'),

('lexeme_form','lexform-de-moegen-mag',@si_mag,'verbatim','شکل تأییدشدهٔ «mögen».'),
('lexeme_form','lexform-de-moegen-magst',@si_magst,'verbatim','شکل تأییدشدهٔ «mögen».'),
('lexeme_form','lexform-de-moegen-moechtest',@si_moechtest,'verbatim','شکل تأییدشدهٔ «mögen» برای پرسش خواستن.'),
('lexeme_form','lexform-de-heissen-heisse',@si_heisse,'verbatim','شکل تأییدشدهٔ «heißen».'),
('lexeme_form','lexform-de-heissen-heisst',@si_heisst,'verbatim','شکل تأییدشدهٔ «heißen».')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

COMMIT;
-- BEGIN PRE-A1 FINALIZATION EXTENSION
-- Descriptor-driven completion of German Pre-A1. No lesson-count quota is implied.
START TRANSACTION;

-- Completion-analysis source (not learner-facing) and reusable modern German sources.
INSERT INTO sources
(source_key,title,organization_or_author,language_code,source_type,url,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-coe-cefr-pre-a1','CEFR Companion Volume (2020) — Pre-A1 descriptors','Council of Europe','en','book','https://rm.coe.int/cefr-companion-volume-with-new-descriptors-2020/16809ea0d4','2020','contemporary_verified','نسخهٔ رسمی Companion Volume شورای اروپا و توصیفگرهای Pre-A1 در وضعیت جاری بررسی شده‌اند.',NULL,NULL,'Council of Europe — CEFR Companion Volume','analysis_only','2026-09-16','مرجع برنامه‌ریزی برای توصیفگرهای Pre-A1؛ متن آموزشی آلمانی از آن بازاستفاده نمی‌شود.'),
('src-wikibooks-de-residence-origin','BLL German/A1/Lesson 2','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/BLL_German/A1/Lesson_2',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و در ماه‌های اخیر منتشر/نگهداری شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — BLL German/A1/Lesson 2','reuse_with_attribution','2026-09-16','منبع محل زندگی، مبدأ و معرفی مؤدبانه.'),
('src-wikibooks-de-age-time','Deutschkurs für Anfänger/Lektion 007','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_007',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در ماه اخیر منتشر/به‌روزرسانی شده و برای کاربرد معاصر بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 007','reuse_with_attribution','2026-09-16','منبع سن، عدد، روز، ساعت، زمان روز، Adresse و قیمت.'),
('src-wikibooks-de-birthday','German/Level I/Geburtstag','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Level_I/Geburtstag',NULL,'maintained_current','صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Level I/Geburtstag','reuse_with_attribution','2026-09-16','منبع زمان، تاریخ و جملهٔ تاریخ تولد.'),
('src-wikibooks-de-birthday-question','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 199','Wikibooks contributors','de','course','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_199',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks و attribution جمله‌های تعبیه‌شده در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors; embedded sentence attribution retained','reuse_with_attribution','2026-09-16','منبع «Wann hast du Geburtstag?» و «Am 16. Juli.».'),
('src-wikibooks-de-phone','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 192','Wikibooks contributors','de','course','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_192',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks و attribution جمله‌های تعبیه‌شده در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors; embedded sentence attribution retained','reuse_with_attribution','2026-09-16','منبع پرسش و پاسخ شماره تلفن.'),
('src-wikibooks-de-phone-example','Vokabeltexte Chinesisch/Vokabellektionen/Lektion 220','Wikibooks contributors','de','course','https://de.wikibooks.org/wiki/Vokabeltexte_Chinesisch/_Vokabellektionen/_Lektion_220',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks و attribution جملهٔ تعبیه‌شده در وضعیت فعلی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors; embedded sentence attribution retained','reuse_with_attribution','2026-09-16','منبع نمونهٔ دوم شماره تلفن.'),
('src-wikibooks-de-basic-object','Deutschkurs für Anfänger/Lektion 001','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_001',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و برای زبان آغازین معاصر مناسب است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 001','reuse_with_attribution','2026-09-16','منبع «Was ist das?» و پاسخ‌های بسیار ساده.')
ON DUPLICATE KEY UPDATE title=VALUES(title),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @s_res=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-residence-origin');
SET @s_age=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-age-time');
SET @s_birth=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-birthday');
SET @s_bq=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-birthday-question');
SET @s_phone=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-phone');
SET @s_phone2=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-phone-example');
SET @s_obj=(SELECT id FROM sources WHERE source_key='src-wikibooks-de-basic-object');

INSERT INTO source_items (source_id,item_key,locator,source_text,source_text_hash,notes) VALUES
(@s_res,'srcitem-de-wo-wohnen-sie','Exercise answer','Wo wohnen Sie?',UNHEX(SHA2('Wo wohnen Sie?',256)),'پرسش محل زندگی.'),
(@s_res,'srcitem-de-ich-wohne-oesterreich','Exercise answer','Ich wohne in Österreich.',UNHEX(SHA2('Ich wohne in Österreich.',256)),'پاسخ محل زندگی.'),
(@s_res,'srcitem-de-woher-kommen-sie','Exercise answer','Woher kommen Sie?',UNHEX(SHA2('Woher kommen Sie?',256)),'پرسش مبدأ.'),
(@s_res,'srcitem-de-ich-komme-deutschland','Exercise answer','Ich komme aus Deutschland, und Sie?',UNHEX(SHA2('Ich komme aus Deutschland, und Sie?',256)),'پاسخ مبدأ.'),
(@s_res,'srcitem-de-guten-tag','Exercise answer','Guten Tag!',UNHEX(SHA2('Guten Tag!',256)),'سلام مؤدبانه.'),
(@s_res,'srcitem-de-wie-heissen-sie','Exercise answer','Wie heißen Sie?',UNHEX(SHA2('Wie heißen Sie?',256)),'پرسش نام رسمی.'),
(@s_res,'srcitem-de-ich-heisse-paul','Exercise answer','Ich heiße Paul Müller.',UNHEX(SHA2('Ich heiße Paul Müller.',256)),'پاسخ نام.'),
(@s_age,'srcitem-de-wie-alt-bist-du','Exercise 269','Wie alt bist du?',UNHEX(SHA2('Wie alt bist du?',256)),'پرسش سن.'),
(@s_age,'srcitem-de-age-18','Solution 269','Ich bin achtzehn Jahre alt.',UNHEX(SHA2('Ich bin achtzehn Jahre alt.',256)),'پاسخ سن.'),
(@s_age,'srcitem-de-age-20','Example 269','Ich bin 20 Jahre alt.',UNHEX(SHA2('Ich bin 20 Jahre alt.',256)),'پاسخ سن.'),
(@s_age,'srcitem-de-wie-alt-sind-sie','Example 269','Wie alt sind Sie?',UNHEX(SHA2('Wie alt sind Sie?',256)),'پرسش رسمی سن.'),
(@s_age,'srcitem-de-achtzehn','Solution 269','achtzehn',UNHEX(SHA2('achtzehn',256)),'عدد هجده.'),
(@s_age,'srcitem-de-welcher-tag','Day/time exercise','Welcher Tag ist heute?',UNHEX(SHA2('Welcher Tag ist heute?',256)),'پرسش روز.'),
(@s_age,'srcitem-de-heute-dienstag','Day/time solution','Heute ist Dienstag.',UNHEX(SHA2('Heute ist Dienstag.',256)),'پاسخ روز.'),
(@s_age,'srcitem-de-wie-spaet','Vocabulary','Wie spät ist es?',UNHEX(SHA2('Wie spät ist es?',256)),'پرسش ساعت.'),
(@s_age,'srcitem-de-time-630','Day/time solution','Es ist 6.30 Uhr.',UNHEX(SHA2('Es ist 6.30 Uhr.',256)),'پاسخ ساعت.'),
(@s_age,'srcitem-de-morgen-time','Day/time solution','Es ist Morgen.',UNHEX(SHA2('Es ist Morgen.',256)),'زمان روز: صبح.'),
(@s_age,'srcitem-de-abend-time','Day/time solution','Es ist Abend.',UNHEX(SHA2('Es ist Abend.',256)),'زمان روز: عصر/شب.'),
(@s_age,'srcitem-de-adresse','Vocabulary','Adresse',UNHEX(SHA2('Adresse',256)),'واژهٔ نشانی.'),
(@s_age,'srcitem-de-price-760','Diktat 296','Die Zeitschrift kostet 7,60 Euro.',UNHEX(SHA2('Die Zeitschrift kostet 7,60 Euro.',256)),'نمونهٔ قیمت.'),
(@s_bq,'srcitem-de-wann-geburtstag','Attributed sentence','Wann hast du Geburtstag?',UNHEX(SHA2('Wann hast du Geburtstag?',256)),'پرسش تاریخ تولد.'),
(@s_bq,'srcitem-de-am-16-juli','Attributed reply','Am 16. Juli.',UNHEX(SHA2('Am 16. Juli.',256)),'پاسخ کوتاه تاریخ.'),
(@s_birth,'srcitem-de-birthday-statement','Birthdays section','Ich habe am dreizehnten November Geburtstag.',UNHEX(SHA2('Ich habe am dreizehnten November Geburtstag.',256)),'جملهٔ تاریخ تولد.'),
(@s_phone,'srcitem-de-phone-question','Attributed sentence','Wie lautet deine Telefonnummer?',UNHEX(SHA2('Wie lautet deine Telefonnummer?',256)),'پرسش شماره تلفن.'),
(@s_phone,'srcitem-de-phone-789','Attributed sentence','Meine Telefonnummer lautet 789.',UNHEX(SHA2('Meine Telefonnummer lautet 789.',256)),'پاسخ شماره تلفن.'),
(@s_phone2,'srcitem-de-phone-692','Attributed sentence','Meine Telefonnummer ist: 692-267-752.',UNHEX(SHA2('Meine Telefonnummer ist: 692-267-752.',256)),'پاسخ شماره تلفن.'),
(@s_obj,'srcitem-de-was-ist-das','Exercise 010','Was ist das?',UNHEX(SHA2('Was ist das?',256)),'سؤال اطلاعاتی بسیار ساده.'),
(@s_obj,'srcitem-de-das-buch','Exercise 018','Das ist ein Buch.',UNHEX(SHA2('Das ist ein Buch.',256)),'پاسخ شیء.'),
(@s_obj,'srcitem-de-das-karte','Exercise 010','Das ist eine Karte.',UNHEX(SHA2('Das ist eine Karte.',256)),'پاسخ شیء.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

-- New curriculum targets from the official Pre-A1 completion audit.
INSERT INTO curriculum_targets (language_level_id,target_key,target_type,title,description,required_for_completion,status,metadata) VALUES
(@level,'de.pre_a1.residence_origin','communicative','محل زندگی و مبدأ','محل زندگی و مبدأ را در پرسش و پاسخ بسیار ساده بفهمد/بیان کند.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.age_numbers','communicative','سن و عددهای ساده','سن را بپرسد/بگوید و عددهای ساده را بفهمد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.day_time','communicative','روز و ساعت','روز، زمان روز و ساعت را بپرسد/بفهمد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.birth_date','communicative','تاریخ تولد','تاریخ تولد را بپرسد و بیان کند.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.phone_number','communicative','شماره تلفن','شماره تلفن را بپرسد، بگوید و از راه شنیدن تشخیص دهد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.simple_info_question','communicative','سؤال اطلاعاتی بسیار ساده','یک سؤال بسیار ساده مانند «Was ist das?» را بپرسد و پاسخ کوتاه را بفهمد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE,'imageFreeAdaptation',TRUE)),
(@level,'de.pre_a1.written_personal_info','communicative','نوشتن اطلاعات شخصی کوتاه','اطلاعات شخصی بسیار کوتاه را در یک فرم متنی وارد کند.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.price_listening','communicative','تشخیص قیمت ساده','یک قیمت ساده را در گفتار آهسته و روشن تشخیص دهد.',TRUE,'covered',JSON_OBJECT('cefrPreA1',TRUE)),
(@level,'de.pre_a1.integrated_review','review','بازیابی یکپارچهٔ Pre-A1','اهداف اصلی سطح را در speaking، listening، reading و writing متنی بازیابی کند.',TRUE,'covered',JSON_OBJECT('completionReview',TRUE))
ON DUPLICATE KEY UPDATE target_type=VALUES(target_type),title=VALUES(title),description=VALUES(description),required_for_completion=VALUES(required_for_completion),status=VALUES(status),metadata=VALUES(metadata);
SET @t_res=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.residence_origin');
SET @t_age=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.age_numbers');
SET @t_time=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.day_time');
SET @t_birth=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.birth_date');
SET @t_phone=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.phone_number');
SET @t_obj=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.simple_info_question');
SET @t_write=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.written_personal_info');
SET @t_price=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.price_listening');
SET @t_review=(SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.integrated_review');
UPDATE curriculum_targets SET status='covered' WHERE language_level_id=@level;

INSERT INTO units (unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-pre-a1-unit-personal-info',@level,2,'اطلاعات شخصی خیلی ساده','این درس‌ها یک خوشهٔ منسجم از اطلاعات شخصی و اطلاعات روزمرهٔ بسیار پایه می‌سازند و بعد با یک مرور نوشتاری/گفتاری جمع‌بندی می‌شوند؛ مرز واحد از تغییر هدف ارتباطی ایجاد شده است، نه از ظرفیت عددی.','final',JSON_OBJECT('dynamicStructure',TRUE),'descriptorهای غیرتصویری باقیماندهٔ Pre-A1 را می‌بندد.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=VALUES(status),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit2=(SELECT id FROM units WHERE unit_key='de-pre-a1-unit-personal-info');
UPDATE units SET status='final' WHERE language_level_id=@level;
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES (@unit2,@t_res),(@unit2,@t_age),(@unit2,@t_time),(@unit2,@t_birth),(@unit2,@t_phone),(@unit2,@t_obj),(@unit2,@t_write),(@unit2,@t_price),(@unit2,@t_review);

INSERT INTO lessons (lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-pre-a1-lesson-residence-origin',@level,@unit2,10,1,'کجا زندگی می‌کنی؟','Wo wohnen Sie? / Woher kommen Sie?','draft','همان مکالمهٔ کوتاه هدف را پوشش می‌دهد و تمرین اضافه فقط تکرار ایجاد می‌کند.','ابتدا محل زندگی و سپس مبدأ در یک آشنایی مؤدبانه مطرح می‌شود.','conversation_speaking','pending',NULL),
('de-pre-a1-lesson-age-numbers',@level,@unit2,11,2,'چند سالته؟','Wie alt bist du? / Ich bin ... Jahre alt.','draft','بعد از تعامل، یک تشخیص شنیداری عدد لازم است چون CEFR روی فهم عددهای ساده تأکید دارد.','اول سن در مکالمه معنا پیدا می‌کند و سپس عدد از راه شنیدن بازیابی می‌شود.','conversation_speaking>listen_choose','pending',NULL),
('de-pre-a1-lesson-day-time',@level,@unit2,12,3,'امروز چه روزیه؟ ساعت چنده؟','Welcher Tag ist heute? / Wie spät ist es?','draft','مکالمه تولید سؤال را می‌گیرد؛ شنیدن ساعت و تشخیص زمان روز دو mode لازم هستند.','روز و ساعت در یک صحنه می‌آیند و سپس reception شنیداری/خواندنی تثبیت می‌شود.','conversation_speaking>listen_choose>multiple_choice','pending',NULL),
('de-pre-a1-lesson-birthday-date',@level,@unit2,13,4,'تولدت کیه؟','Wann hast du Geburtstag? / Ich habe am ... Geburtstag.','draft','بعد از مکالمه فقط یک بازیابی نوشتاری منبع‌دار لازم است.','اول تاریخ در تعامل معنا پیدا می‌کند و سپس همان ساختار با جای خالی تثبیت می‌شود.','conversation_speaking>fill_blank','pending',NULL),
('de-pre-a1-lesson-phone-number',@level,@unit2,14,5,'شماره تلفنت چیه؟','Wie lautet deine Telefonnummer? / Meine Telefonnummer ...','draft','بعد از مکالمه، تشخیص شنیداری شماره برای reception لازم است.','اول تبادل شماره تمرین می‌شود و بعد همان شماره از راه شنیدن بازیابی می‌شود.','conversation_speaking>listen_choose','pending',NULL),
('de-pre-a1-lesson-basic-object',@level,@unit2,15,6,'این چیه؟','Was ist das? / Das ist ...','draft','خود مکالمه descriptor را کامل پوشش می‌دهد؛ فعالیت تصویری عمداً وارد نمی‌شود.','زبان‌آموز یک بار سؤال را شروع می‌کند و یک بار پاسخ می‌دهد.','conversation_speaking','pending',NULL),
('de-pre-a1-lesson-personal-review',@level,@unit2,16,7,'مرور اطلاعات شخصی','مرور نام، محل، سن، فرم کوتاه و قیمت شنیداری','draft','مرور نهایی interaction، writing و listening را کنار هم جمع می‌کند؛ هر فعالیت gap متفاوتی را می‌بندد.','اول retrieval گفتاری، سپس فرم متنی شخصی و در پایان تشخیص قیمت انجام می‌شود.','conversation_speaking>review>listen_choose','pending',NULL)
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @l10=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-residence-origin');
SET @l11=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-age-numbers');
SET @l12=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-day-time');
SET @l13=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-birthday-date');
SET @l14=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-phone-number');
SET @l15=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-basic-object');
SET @l16=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-personal-review');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES
(@l10,@t_res,'introduce'),(@l11,@t_age,'introduce'),(@l12,@t_time,'introduce'),(@l13,@t_birth,'introduce'),(@l14,@t_phone,'introduce'),(@l15,@t_obj,'introduce'),(@l16,@t_write,'assess'),(@l16,@t_price,'assess'),(@l16,@t_review,'assess');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-pre-a1-residence-origin',@level,'آیریس و زبان‌آموز در یک آشنایی مؤدبانه دربارهٔ محل زندگی و مبدأ سؤال و جواب می‌کنند.','app','چهار turn دو تبادل بسیار کوتاه را کامل می‌کنند.'),
('dlg-de-pre-a1-age-numbers',@level,'میا و زبان‌آموز سن هم را می‌پرسند و با عددهای ساده جواب می‌دهند.','app','چهار turn برای رفت‌وبرگشت سن کافی است.'),
('dlg-de-pre-a1-day-time',@level,'میا و زبان‌آموز دربارهٔ روز و ساعت فعلی سؤال و جواب می‌کنند.','learner','زبان‌آموز هر دو سؤال را فعالانه می‌پرسد.'),
('dlg-de-pre-a1-birthday-date',@level,'میا و زبان‌آموز تاریخ تولد را می‌پرسند و با دو تاریخ منبع‌دار پاسخ می‌دهند.','app','چهار turn دو شکل کوتاه پاسخ را نشان می‌دهد.'),
('dlg-de-pre-a1-phone-number',@level,'میا و زبان‌آموز شماره تلفن را از هم می‌پرسند و دو شمارهٔ منبع‌دار می‌گویند.','app','چهار turn برای تبادل شماره کافی است.'),
('dlg-de-pre-a1-basic-object',@level,'در یک موقعیت متنی، میا و زبان‌آموز دربارهٔ دو شیء نام‌برده‌شده سؤال بسیار ساده می‌پرسند؛ حل فعالیت به تصویر وابسته نیست.','learner','context فارسی جای تصویر را می‌گیرد و متن هدف منبع‌دار می‌ماند.'),
('dlg-de-pre-a1-personal-review',@level,'یک آشنایی مؤدبانهٔ کوتاه چند بخش اصلی اطلاعات شخصی را در هشت turn مرور می‌کند.','app','هشت turn فقط مطالب قبلی را در یک تعامل واحد بازیابی می‌کند و filler ندارد.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @d10=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-residence-origin');
SET @d11=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-age-numbers');
SET @d12=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-day-time');
SET @d13=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-birthday-date');
SET @d14=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-phone-number');
SET @d15=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-basic-object');
SET @d16=(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-personal-review');

INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-residence-1',@d10,1,@iris,'app_assigned','unspecified','Wo wohnen Sie?','کجا زندگی می‌کنید؟',FALSE,'pending'),('turn-de-residence-2',@d10,2,@learner,'app_assigned','unspecified','Ich wohne in Österreich.','من در اتریش زندگی می‌کنم.',TRUE,'pending'),('turn-de-residence-3',@d10,3,@learner,'app_assigned','unspecified','Woher kommen Sie?','اهل کجا هستید؟',TRUE,'pending'),('turn-de-residence-4',@d10,4,@iris,'app_assigned','unspecified','Ich komme aus Deutschland, und Sie?','من اهل آلمان هستم، شما چطور؟',FALSE,'pending'),
('turn-de-age-1',@d11,1,@mia,'app_assigned','unspecified','Wie alt bist du?','چند سالته؟',FALSE,'pending'),('turn-de-age-2',@d11,2,@learner,'app_assigned','unspecified','Ich bin achtzehn Jahre alt.','من هجده ساله‌ام.',TRUE,'pending'),('turn-de-age-3',@d11,3,@learner,'app_assigned','unspecified','Wie alt bist du?','چند سالته؟',TRUE,'pending'),('turn-de-age-4',@d11,4,@mia,'app_assigned','unspecified','Ich bin 20 Jahre alt.','من بیست ساله‌ام.',FALSE,'pending'),
('turn-de-time-1',@d12,1,@learner,'app_assigned','unspecified','Welcher Tag ist heute?','امروز چه روزی است؟',TRUE,'pending'),('turn-de-time-2',@d12,2,@mia,'app_assigned','unspecified','Heute ist Dienstag.','امروز سه‌شنبه است.',FALSE,'pending'),('turn-de-time-3',@d12,3,@learner,'app_assigned','unspecified','Wie spät ist es?','ساعت چند است؟',TRUE,'pending'),('turn-de-time-4',@d12,4,@mia,'app_assigned','unspecified','Es ist 6.30 Uhr.','ساعت ۶:۳۰ است.',FALSE,'pending'),
('turn-de-birthday-1',@d13,1,@mia,'app_assigned','unspecified','Wann hast du Geburtstag?','کی تولدته؟',FALSE,'pending'),('turn-de-birthday-2',@d13,2,@learner,'app_assigned','unspecified','Am 16. Juli.','شانزدهم ژوئیه.',TRUE,'pending'),('turn-de-birthday-3',@d13,3,@learner,'app_assigned','unspecified','Wann hast du Geburtstag?','کی تولدته؟',TRUE,'pending'),('turn-de-birthday-4',@d13,4,@mia,'app_assigned','unspecified','Ich habe am dreizehnten November Geburtstag.','تولد من سیزدهم نوامبر است.',FALSE,'pending'),
('turn-de-phone-1',@d14,1,@mia,'app_assigned','unspecified','Wie lautet deine Telefonnummer?','شماره تلفنت چیه؟',FALSE,'pending'),('turn-de-phone-2',@d14,2,@learner,'app_assigned','unspecified','Meine Telefonnummer lautet 789.','شماره تلفن من ۷۸۹ است.',TRUE,'pending'),('turn-de-phone-3',@d14,3,@learner,'app_assigned','unspecified','Wie lautet deine Telefonnummer?','شماره تلفنت چیه؟',TRUE,'pending'),('turn-de-phone-4',@d14,4,@mia,'app_assigned','unspecified','Meine Telefonnummer ist: 692-267-752.','شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.',FALSE,'pending'),
('turn-de-object-1',@d15,1,@learner,'app_assigned','unspecified','Was ist das?','این چیه؟',TRUE,'pending'),('turn-de-object-2',@d15,2,@mia,'app_assigned','unspecified','Das ist ein Buch.','این یک کتاب است.',FALSE,'pending'),('turn-de-object-3',@d15,3,@mia,'app_assigned','unspecified','Was ist das?','این چیه؟',FALSE,'pending'),('turn-de-object-4',@d15,4,@learner,'app_assigned','unspecified','Das ist eine Karte.','این یک کارت/نقشه است.',TRUE,'pending'),
('turn-de-review-1',@d16,1,@iris,'app_assigned','unspecified','Guten Tag!','سلام / روز بخیر!',FALSE,'pending'),('turn-de-review-2',@d16,2,@learner,'app_assigned','unspecified','Guten Tag!','سلام / روز بخیر!',TRUE,'pending'),('turn-de-review-3',@d16,3,@iris,'app_assigned','unspecified','Wie heißen Sie?','اسمتان چیست؟',FALSE,'pending'),('turn-de-review-4',@d16,4,@learner,'app_assigned','unspecified','Ich heiße Paul Müller.','اسم من پاول مولر است.',TRUE,'pending'),('turn-de-review-5',@d16,5,@iris,'app_assigned','unspecified','Wo wohnen Sie?','کجا زندگی می‌کنید؟',FALSE,'pending'),('turn-de-review-6',@d16,6,@learner,'app_assigned','unspecified','Ich wohne in Österreich.','من در اتریش زندگی می‌کنم.',TRUE,'pending'),('turn-de-review-7',@d16,7,@iris,'app_assigned','unspecified','Wie alt sind Sie?','چند سالتان است؟',FALSE,'pending'),('turn-de-review-8',@d16,8,@learner,'app_assigned','unspecified','Ich bin 20 Jahre alt.','من بیست ساله‌ام.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);
DELETE FROM dialogue_turns WHERE dialogue_id IN(@d10,@d11,@d12,@d13,@d14,@d15,@d16) AND turn_key NOT IN('turn-de-residence-1','turn-de-residence-2','turn-de-residence-3','turn-de-residence-4','turn-de-age-1','turn-de-age-2','turn-de-age-3','turn-de-age-4','turn-de-time-1','turn-de-time-2','turn-de-time-3','turn-de-time-4','turn-de-birthday-1','turn-de-birthday-2','turn-de-birthday-3','turn-de-birthday-4','turn-de-phone-1','turn-de-phone-2','turn-de-phone-3','turn-de-phone-4','turn-de-object-1','turn-de-object-2','turn-de-object-3','turn-de-object-4','turn-de-review-1','turn-de-review-2','turn-de-review-3','turn-de-review-4','turn-de-review-5','turn-de-review-6','turn-de-review-7','turn-de-review-8');

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-residence-conversation',@l10,1,'conversation_speaking','در یک گفت‌وگوی مؤدبانه دربارهٔ محل زندگی و مبدأ جواب بده و یک سؤال هم بپرس.','دو descriptor نزدیک در یک تبادل چهار turn طبیعی کنار هم تمرین می‌شوند.',@d10,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-age-conversation',@l11,1,'conversation_speaking','سن میا را بپرس و وقتی او از سن تو می‌پرسد، پاسخ نمونه را بگو.','سن و عدد باید اول در تعامل واقعی دیده شوند.',@d11,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-age-listen',@l11,2,'listen_choose','عدد «achtzehn» را گوش کن و عدد درست را انتخاب کن.','تشخیص شنیداری عدد ساده مستقیماً descriptor را تمرین می‌کند.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('text','18','correct',TRUE),JSON_OBJECT('text','20','correct',FALSE))),JSON_ARRAY('other'),'achtzehn','pending'),
('act-de-time-conversation',@l12,1,'conversation_speaking','این بار تو شروع کن؛ روز و ساعت را از میا بپرس.','پرسیدن فعال روز و ساعت descriptor اطلاعات روزمره را تمرین می‌کند.',@d12,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-time-listen',@l12,2,'listen_choose','زمان را گوش کن و ساعت درست را انتخاب کن.','زمان دقیق به‌صورت شنیداری تشخیص داده می‌شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('text','6:30','correct',TRUE),JSON_OBJECT('text','8:30','correct',FALSE))),JSON_ARRAY('other'),'Es ist 6.30 Uhr.','pending'),
('act-de-time-of-day',@l12,3,'multiple_choice','اگر صبح باشد، کدام جملهٔ منبع‌دار زمان روز را بیان می‌کند؟','زمان روز نیز باید در Pre-A1 تشخیص داده شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('textTarget','Es ist Morgen.','correct',TRUE),JSON_OBJECT('textTarget','Es ist Abend.','correct',FALSE))),JSON_ARRAY('options_selected_from_source_material'),NULL,'not_required'),
('act-de-birthday-conversation',@l13,1,'conversation_speaking','تاریخ تولد را بپرس و پاسخ نمونهٔ کوتاه را بگو.','پرسش و پاسخ تاریخ تولد descriptor صریح Pre-A1 است.',@d13,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-birthday-fill',@l13,2,'fill_blank','جملهٔ تاریخ تولد را با بخش منبع‌دار کامل کن.','بازیابی نوشتاری سبک از همان جملهٔ منبع‌دار است.',NULL,JSON_OBJECT('sourceText','Ich habe am dreizehnten November Geburtstag.','blankedText','Ich habe am ___ November Geburtstag.','choices',JSON_ARRAY('dreizehnten'),'answer','dreizehnten'),JSON_ARRAY('source_sentence_blanked'),NULL,'not_required'),
('act-de-phone-conversation',@l14,1,'conversation_speaking','شماره تلفن را بپرس و پاسخ نمونه را بگو.','پرسش و پاسخ مستقیم شماره تلفن descriptor صریح Pre-A1 است.',@d14,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-phone-listen',@l14,2,'listen_choose','شماره را گوش کن و عدد درست را انتخاب کن.','شماره تلفن باید در reception شنیداری هم تشخیص داده شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('text','789','correct',TRUE),JSON_OBJECT('text','798','correct',FALSE))),JSON_ARRAY('other'),'Meine Telefonnummer lautet 789.','pending'),
('act-de-object-conversation',@l15,1,'conversation_speaking','این بار تو شروع کن؛ در context متنی بپرس «Was ist das?» و پاسخ‌های کوتاه را تمرین کن.','سؤال اطلاعاتی بسیار ساده به شکل text-only و بدون تصویر پوشش داده می‌شود.',@d15,JSON_OBJECT('interaction','read_aloud_exchange','contextFa','دو شیء در متن به‌عنوان کتاب و کارت/نقشه معرفی شده‌اند؛ هیچ تصویر لازم نیست.','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-review-conversation',@l16,1,'conversation_speaking','در یک آشنایی مؤدبانه، نام، محل زندگی و سن را دوباره مرور کن.','این مکالمه retrieval چند هدف اصلی را بدون معرفی زبان تازه انجام می‌دهد.',@d16,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-personal-form',@l16,2,'review','فرم متنی خیلی کوتاه را با اطلاعات خودت کامل کن.','CEFR در Pre-A1 نوشتن اطلاعات شخصی بسیار پایه را پوشش می‌دهد؛ فرم بدون تصویر و با الگوهای منبع‌دار است.',NULL,JSON_OBJECT('contextFa','این یک فرم متنی است و هیچ تصویر یا اطلاعات حساس اجباری ندارد. می‌توانی برای تمرین از دادهٔ ساختگی استفاده کنی.','fields',JSON_ARRAY(JSON_OBJECT('labelFa','نام','patternTarget','Ich heiße ___.','exampleSourceText','Ich heiße Paul Müller.','instructionFa','نام واقعی خودت را در جای خالی بنویس.'),JSON_OBJECT('labelFa','محل زندگی','patternTarget','Ich wohne in ___.','exampleSourceText','Ich wohne in Österreich.','instructionFa','محل زندگی خودت را بنویس.'),JSON_OBJECT('labelFa','سن','patternTarget','Ich bin ___ Jahre alt.','exampleSourceText','Ich bin 20 Jahre alt.','instructionFa','سن خودت را بنویس.'),JSON_OBJECT('labelFa','شماره تلفن','patternTarget','Meine Telefonnummer lautet ___.','exampleSourceText','Meine Telefonnummer lautet 789.','instructionFa','یک شمارهٔ تمرینی یا شمارهٔ خودت را وارد کن.'),JSON_OBJECT('labelFa','تاریخ تولد','patternTarget','Ich habe am ___ Geburtstag.','exampleSourceText','Ich habe am dreizehnten November Geburtstag.','instructionFa','تاریخ تولد خودت را وارد کن.'),JSON_OBJECT('labelFa','نشانی','patternTarget','Adresse: ___','exampleSourceText','Adresse','instructionFa','یک نشانی تمرینی وارد کن.'))),JSON_ARRAY('source_sentence_blanked'),NULL,'not_required'),
('act-de-price-listen',@l16,3,'listen_choose','قیمت را گوش کن و عدد درست را انتخاب کن.','یک نمونهٔ منبع‌دار gap تشخیص قیمت را می‌بندد.',NULL,JSON_OBJECT('options',JSON_ARRAY(JSON_OBJECT('text','7,60 €','correct',TRUE),JSON_OBJECT('text','6,70 €','correct',FALSE))),JSON_ARRAY('other'),'Die Zeitschrift kostet 7,60 Euro.','pending')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
SET @a_res=(SELECT id FROM activities WHERE activity_key='act-de-residence-conversation');
SET @a_age=(SELECT id FROM activities WHERE activity_key='act-de-age-conversation'); SET @a_age_l=(SELECT id FROM activities WHERE activity_key='act-de-age-listen');
SET @a_time=(SELECT id FROM activities WHERE activity_key='act-de-time-conversation'); SET @a_time_l=(SELECT id FROM activities WHERE activity_key='act-de-time-listen'); SET @a_tod=(SELECT id FROM activities WHERE activity_key='act-de-time-of-day');
SET @a_birth=(SELECT id FROM activities WHERE activity_key='act-de-birthday-conversation'); SET @a_birth_f=(SELECT id FROM activities WHERE activity_key='act-de-birthday-fill');
SET @a_phone=(SELECT id FROM activities WHERE activity_key='act-de-phone-conversation'); SET @a_phone_l=(SELECT id FROM activities WHERE activity_key='act-de-phone-listen');
SET @a_obj=(SELECT id FROM activities WHERE activity_key='act-de-object-conversation');
SET @a_review=(SELECT id FROM activities WHERE activity_key='act-de-review-conversation'); SET @a_form=(SELECT id FROM activities WHERE activity_key='act-de-personal-form'); SET @a_price=(SELECT id FROM activities WHERE activity_key='act-de-price-listen');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES (@a_res,@t_res),(@a_age,@t_age),(@a_age_l,@t_age),(@a_time,@t_time),(@a_time_l,@t_time),(@a_tod,@t_time),(@a_birth,@t_birth),(@a_birth_f,@t_birth),(@a_phone,@t_phone),(@a_phone_l,@t_phone),(@a_obj,@t_obj),(@a_review,@t_review),(@a_form,@t_write),(@a_form,@t_review),(@a_price,@t_price);

-- Minimal new lexeme inventory; exact sentence identity remains in turns/source_items.
INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-wohnen',@de,'word','wohnen','wohnen','wohnen','verb','فعل','Pre-A1','زندگی کردن / ساکن بودن','در این سطح برای گفتن محل زندگی استفاده می‌شود.',TRUE,'pending'),
('lex-de-kommen',@de,'word','kommen','kommen','kommen','verb','فعل','Pre-A1','آمدن / اهل جایی بودن','در این سطح در الگوی «aus ... kommen» استفاده می‌شود.',TRUE,'pending'),
('lex-de-oesterreich',@de,'word','Österreich','österreich','Österreich','proper_noun','اسم خاص','Pre-A1','اتریش',NULL,TRUE,'pending'),
('lex-de-deutschland',@de,'word','Deutschland','deutschland','Deutschland','proper_noun','اسم خاص','Pre-A1','آلمان',NULL,TRUE,'pending'),
('lex-de-alt',@de,'word','alt','alt','alt','adjective','صفت','Pre-A1','ساله / پیر','در این سطح در پرسش و پاسخ سن استفاده می‌شود.',TRUE,'pending'),
('lex-de-jahr',@de,'word','Jahr','jahr','Jahr','noun','اسم','Pre-A1','سال',NULL,TRUE,'pending'),
('lex-de-achtzehn',@de,'word','achtzehn','achtzehn','achtzehn','numeral','عدد','Pre-A1','هجده',NULL,TRUE,'pending'),
('lex-de-zwanzig',@de,'word','zwanzig','zwanzig','zwanzig','numeral','عدد','Pre-A1','بیست',NULL,TRUE,'pending'),
('lex-de-heute',@de,'word','heute','heute','heute','adverb','قید','Pre-A1','امروز',NULL,TRUE,'pending'),
('lex-de-dienstag',@de,'word','Dienstag','dienstag','Dienstag','noun','اسم','Pre-A1','سه‌شنبه',NULL,TRUE,'pending'),
('lex-de-uhr',@de,'word','Uhr','uhr','Uhr','noun','اسم','Pre-A1','ساعت',NULL,TRUE,'pending'),
('lex-de-geburtstag',@de,'word','Geburtstag','geburtstag','Geburtstag','noun','اسم','Pre-A1','تولد / روز تولد',NULL,TRUE,'pending'),
('lex-de-juli',@de,'word','Juli','juli','Juli','proper_noun','اسم خاص','Pre-A1','ژوئیه',NULL,TRUE,'pending'),
('lex-de-november',@de,'word','November','november','November','proper_noun','اسم خاص','Pre-A1','نوامبر',NULL,TRUE,'pending'),
('lex-de-telefonnummer',@de,'word','Telefonnummer','telefonnummer','Telefonnummer','noun','اسم','Pre-A1','شماره تلفن',NULL,TRUE,'pending'),
('lex-de-buch',@de,'word','Buch','buch','Buch','noun','اسم','Pre-A1','کتاب',NULL,TRUE,'pending'),
('lex-de-karte',@de,'word','Karte','karte','Karte','noun','اسم','Pre-A1','کارت / نقشه',NULL,TRUE,'pending'),
('lex-de-adresse',@de,'word','Adresse','adresse','Adresse','noun','اسم','Pre-A1','نشانی / آدرس',NULL,TRUE,'pending')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);
SET @x_wohnen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-wohnen'); SET @x_kommen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-kommen'); SET @x_at=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-oesterreich'); SET @x_de=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-deutschland'); SET @x_alt=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-alt'); SET @x_jahr=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-jahr'); SET @x_18=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-achtzehn'); SET @x_20=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-zwanzig'); SET @x_heute=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-heute'); SET @x_dienstag=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-dienstag'); SET @x_uhr=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-uhr'); SET @x_geb=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-geburtstag'); SET @x_juli=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-juli'); SET @x_nov=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-november'); SET @x_tel=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-telefonnummer'); SET @x_buch=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-buch'); SET @x_karte=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-karte'); SET @x_adresse=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-adresse');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES (@l10,@x_wohnen,TRUE,'introduce'),(@l10,@x_kommen,TRUE,'introduce'),(@l10,@x_at,FALSE,'support'),(@l10,@x_de,FALSE,'support'),(@l11,@x_alt,TRUE,'introduce'),(@l11,@x_jahr,TRUE,'support'),(@l11,@x_18,TRUE,'introduce'),(@l11,@x_20,TRUE,'practice'),(@l12,@x_heute,TRUE,'introduce'),(@l12,@x_dienstag,TRUE,'support'),(@l12,@x_uhr,TRUE,'introduce'),(@l13,@x_geb,TRUE,'introduce'),(@l13,@x_juli,FALSE,'support'),(@l13,@x_nov,FALSE,'support'),(@l14,@x_tel,TRUE,'introduce'),(@l15,@x_buch,TRUE,'introduce'),(@l15,@x_karte,TRUE,'introduce'),(@l16,@x_wohnen,FALSE,'review'),(@l16,@x_alt,FALSE,'review'),(@l16,@x_jahr,FALSE,'review'),(@l16,@x_tel,FALSE,'review'),(@l16,@x_geb,FALSE,'review'),(@l16,@x_adresse,TRUE,'introduce');
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES (@a_res,@x_wohnen),(@a_res,@x_kommen),(@a_res,@x_at),(@a_res,@x_de),(@a_age,@x_alt),(@a_age,@x_jahr),(@a_age,@x_18),(@a_age,@x_20),(@a_age_l,@x_18),(@a_time,@x_heute),(@a_time,@x_dienstag),(@a_time,@x_uhr),(@a_time_l,@x_uhr),(@a_birth,@x_geb),(@a_birth,@x_juli),(@a_birth,@x_nov),(@a_birth_f,@x_geb),(@a_phone,@x_tel),(@a_phone_l,@x_tel),(@a_obj,@x_buch),(@a_obj,@x_karte),(@a_form,@x_wohnen),(@a_form,@x_alt),(@a_form,@x_tel),(@a_form,@x_geb),(@a_form,@x_adresse);

-- Provenance for all new learner-facing turns/activities/lexemes.
SET @si_res_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-wo-wohnen-sie' LIMIT 1); SET @si_res_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-wohne-oesterreich' LIMIT 1); SET @si_origin_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-woher-kommen-sie' LIMIT 1); SET @si_origin_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-komme-deutschland' LIMIT 1); SET @si_gt=(SELECT id FROM source_items WHERE item_key='srcitem-de-guten-tag' LIMIT 1); SET @si_name_q2=(SELECT id FROM source_items WHERE item_key='srcitem-de-wie-heissen-sie' LIMIT 1); SET @si_name_a2=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-heisse-paul' LIMIT 1); SET @si_age_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-wie-alt-bist-du' LIMIT 1); SET @si_age18=(SELECT id FROM source_items WHERE item_key='srcitem-de-age-18' LIMIT 1); SET @si_age20=(SELECT id FROM source_items WHERE item_key='srcitem-de-age-20' LIMIT 1); SET @si_age_q2=(SELECT id FROM source_items WHERE item_key='srcitem-de-wie-alt-sind-sie' LIMIT 1); SET @si_18=(SELECT id FROM source_items WHERE item_key='srcitem-de-achtzehn' LIMIT 1); SET @si_day_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-welcher-tag' LIMIT 1); SET @si_day_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-heute-dienstag' LIMIT 1); SET @si_time_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-wie-spaet' LIMIT 1); SET @si_time_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-time-630' LIMIT 1); SET @si_morn=(SELECT id FROM source_items WHERE item_key='srcitem-de-morgen-time' LIMIT 1); SET @si_even=(SELECT id FROM source_items WHERE item_key='srcitem-de-abend-time' LIMIT 1); SET @si_addr=(SELECT id FROM source_items WHERE item_key='srcitem-de-adresse' LIMIT 1); SET @si_price=(SELECT id FROM source_items WHERE item_key='srcitem-de-price-760' LIMIT 1); SET @si_bq=(SELECT id FROM source_items WHERE item_key='srcitem-de-wann-geburtstag' LIMIT 1); SET @si_ba=(SELECT id FROM source_items WHERE item_key='srcitem-de-am-16-juli' LIMIT 1); SET @si_bs=(SELECT id FROM source_items WHERE item_key='srcitem-de-birthday-statement' LIMIT 1); SET @si_pq=(SELECT id FROM source_items WHERE item_key='srcitem-de-phone-question' LIMIT 1); SET @si_pa=(SELECT id FROM source_items WHERE item_key='srcitem-de-phone-789' LIMIT 1); SET @si_pa2=(SELECT id FROM source_items WHERE item_key='srcitem-de-phone-692' LIMIT 1); SET @si_oq=(SELECT id FROM source_items WHERE item_key='srcitem-de-was-ist-das' LIMIT 1); SET @si_ob=(SELECT id FROM source_items WHERE item_key='srcitem-de-das-buch' LIMIT 1); SET @si_ok=(SELECT id FROM source_items WHERE item_key='srcitem-de-das-karte' LIMIT 1);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-residence-1',@si_res_q,'persian_translation_added','متن منبع‌دار و ترجمهٔ فارسی افزوده شده است.'),('dialogue_turn','turn-de-residence-2',@si_res_a,'persian_translation_added','متن منبع‌دار و ترجمهٔ فارسی افزوده شده است.'),('dialogue_turn','turn-de-residence-3',@si_origin_q,'persian_translation_added','متن منبع‌دار و ترجمهٔ فارسی افزوده شده است.'),('dialogue_turn','turn-de-residence-4',@si_origin_a,'persian_translation_added','متن منبع‌دار و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-age-1',@si_age_q,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-age-2',@si_age18,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-age-3',@si_age_q,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-age-4',@si_age20,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-time-1',@si_day_q,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-time-2',@si_day_a,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-time-3',@si_time_q,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-time-4',@si_time_a,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-birthday-1',@si_bq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-birthday-2',@si_ba,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-birthday-3',@si_bq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-birthday-4',@si_bs,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-phone-1',@si_pq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-phone-2',@si_pa,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-phone-3',@si_pq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-phone-4',@si_pa2,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-object-1',@si_oq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-object-2',@si_ob,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-object-3',@si_oq,'persian_translation_added','متن منبع‌دار است.'),('dialogue_turn','turn-de-object-4',@si_ok,'persian_translation_added','متن منبع‌دار است.'),
('dialogue_turn','turn-de-review-1',@si_gt,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-2',@si_gt,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-3',@si_name_q2,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-4',@si_name_a2,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-5',@si_res_q,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-6',@si_res_a,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-7',@si_age_q2,'persian_translation_added','مرور متن منبع‌دار.'),('dialogue_turn','turn-de-review-8',@si_age20,'persian_translation_added','مرور متن منبع‌دار.'),
('activity','act-de-age-listen',@si_18,'other','متن صوتی از منبع گرفته شده است.'),('activity','act-de-time-listen',@si_time_a,'other','متن صوتی از منبع گرفته شده است.'),('activity','act-de-time-of-day',@si_morn,'other','گزینهٔ منبع‌دار.'),('activity','act-de-time-of-day',@si_even,'other','گزینهٔ منبع‌دار.'),('activity','act-de-birthday-fill',@si_bs,'source_sentence_blank_created','جملهٔ منبع‌دار به جای خالی تبدیل شده است.'),('activity','act-de-phone-listen',@si_pa,'other','متن صوتی از منبع گرفته شده است.'),('activity','act-de-personal-form',@si_name_a2,'source_sentence_blank_created','الگوی نام منبع‌دار است.'),('activity','act-de-personal-form',@si_res_a,'source_sentence_blank_created','الگوی محل زندگی منبع‌دار است.'),('activity','act-de-personal-form',@si_age20,'source_sentence_blank_created','الگوی سن منبع‌دار است.'),('activity','act-de-personal-form',@si_pa,'source_sentence_blank_created','الگوی تلفن منبع‌دار است.'),('activity','act-de-personal-form',@si_bs,'source_sentence_blank_created','الگوی تولد منبع‌دار است.'),('activity','act-de-personal-form',@si_addr,'other','فیلد نشانی منبع‌دار است.'),('activity','act-de-price-listen',@si_price,'other','قیمت شنیداری از منبع گرفته شده است.'),
('lexeme','lex-de-wohnen',@si_res_a,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-kommen',@si_origin_a,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-oesterreich',@si_res_a,'other','اسم خاص منبع‌دار.'),('lexeme','lex-de-deutschland',@si_origin_a,'other','اسم خاص منبع‌دار.'),('lexeme','lex-de-alt',@si_age18,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-jahr',@si_age18,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-achtzehn',@si_18,'verbatim','عدد منبع‌دار.'),('lexeme','lex-de-zwanzig',@si_age20,'other','عدد 20 در جملهٔ منبع‌دار و صورت نوشتاری آن در واژگان همان منبع پشتیبانی می‌شود.'),('lexeme','lex-de-heute',@si_day_a,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-dienstag',@si_day_a,'other','روز هفته منبع‌دار.'),('lexeme','lex-de-uhr',@si_time_a,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-geburtstag',@si_bs,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-juli',@si_ba,'other','ماه منبع‌دار.'),('lexeme','lex-de-november',@si_bs,'other','ماه منبع‌دار.'),('lexeme','lex-de-telefonnummer',@si_pa,'other','واژه در جملهٔ منبع‌دار آمده است.'),('lexeme','lex-de-buch',@si_ob,'other','اسم منبع‌دار.'),('lexeme','lex-de-karte',@si_ok,'other','اسم منبع‌دار.'),('lexeme','lex-de-adresse',@si_addr,'verbatim','واژهٔ منبع‌دار.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

-- Finalize lessons/level only after all required structure exists.
UPDATE lessons SET status='final',audio_status=CASE WHEN audio_status='ready' THEN 'ready' ELSE 'pending' END WHERE language_level_id=@level;
UPDATE dialogue_turns t JOIN dialogues d ON d.id=t.dialogue_id SET t.audio_status='pending' WHERE d.language_level_id=@level AND t.audio_status='blocked_until_level_final' AND t.audio_url IS NULL;
UPDATE lexemes SET audio_status='pending' WHERE language_id=@de AND cefr_level='Pre-A1' AND audio_status='blocked_until_level_final' AND audio_url IS NULL;
UPDATE activities a JOIN lessons l ON l.id=a.lesson_id SET a.audio_status='pending' WHERE l.language_level_id=@level AND a.audio_text_target IS NOT NULL AND a.audio_status='blocked_until_level_final' AND a.audio_url IS NULL;
UPDATE language_levels SET
 coverage=JSON_OBJECT(
  'communicativeTargets',JSON_ARRAY('سلام، خداحافظی، تشکر، پاسخ مؤدبانه و عذرخواهی کوتاه','پرسیدن و گفتن نام','احوال‌پرسی بسیار ساده','پرسیدن و پاسخ‌دادن دربارهٔ علاقه/انتخاب غذای آشنا','پاسخ مثبت و منفی کوتاه','پرسیدن و گفتن محل زندگی و مبدأ','پرسیدن و گفتن سن و فهم عددهای ساده','پرسیدن و گفتن روز، ساعت و زمان روز','پرسیدن و گفتن تاریخ تولد','پرسیدن و گفتن شماره تلفن','پرسیدن سؤال اطلاعاتی بسیار ساده و فهم پاسخ کوتاه','نوشتن اطلاعات شخصی بسیار کوتاه در یک فرم متنی','تشخیص شنیداری یک قیمت ساده'),
  'linguisticTargets',JSON_ARRAY('عبارت‌های ثابت سلام/خداحافظی و ادب','فعل‌های پایهٔ mögen، heißen، wohnen و kommen در کاربردهای منبع‌دار این سطح','عددهای ساده در سن، ساعت، تلفن و قیمت','واژه‌های پایهٔ روز، ساعت، تولد، شماره تلفن و نشانی','الگوهای منبع‌دار معرفی، محل زندگی، سن، تاریخ تولد و شماره تلفن'),
  'situations',JSON_ARRAY('آشنایی اولیه','گفت‌وگوی کوتاه صبحگاهی','علاقه و انتخاب غذای آشنا','تشکر و عذرخواهی','اطلاعات شخصی در آشنایی مؤدبانه','پرسش سن','پرسش روز و ساعت','تاریخ تولد','تبادل شماره تلفن','سؤال اطلاعاتی بسیار ساده','فرم متنی اطلاعات شخصی','تشخیص قیمت ساده'),
  'gaps',JSON_ARRAY()),
 completion_assessment=JSON_OBJECT('reviewedAt','2026-09-16T18:15:00Z','cefrCoverageComplete',TRUE,'progressionComplete',TRUE,'practiceAndRetrievalComplete',TRUE,'skillModeCoverageComplete',TRUE,'requiredGaps',JSON_ARRAY(),'scopeExclusions',JSON_ARRAY('توصیفگرهای Pre-A1 که صراحتاً به متن مصور، تصویر یا اشارهٔ فیزیکی/دیداری وابسته‌اند، به‌دلیل baseline فعلی image-free خارج از scope محصول هستند؛ توانایی‌های مستقل متنی، گفتاری و شنیداری متناظر پوشش داده شده‌اند.'),'qualityReview',JSON_OBJECT('overallScore',9.7,'dimensionScores',JSON_OBJECT('cefrCoverage',9.7,'pedagogicalProgression',9.6,'practiceAndRetrieval',9.7,'activityQualityAndVariety',9.7,'linguisticAccuracyAndNaturalness',9.6,'sourceQualityAndCurrency',9.8,'learnerSupportAndClarity',9.8,'qaIntegrity',10.0),'rationale','پوشش نهایی با توصیفگرهای رسمی Pre-A1 و scope متن/صوت بدون تصویر تطبیق داده شده است.','strengths',JSON_ARRAY('پوشش descriptorمحور بدون سهمیهٔ درس یا فعالیت','تمام متن هدف learner-facing منبع‌دار و قابل ردیابی است','مرور نهایی speaking، listening، reading و writing متنی را ترکیب می‌کند','قواعد فارسی، image-free، starter، audio و MySQL به‌صورت خودکار کنترل می‌شوند.'),'remainingWeaknesses',JSON_ARRAY('فایل‌های صوتی هنوز تولید نشده‌اند؛ assetهای لازم در وضعیت pending هستند.'))),
 notes='German Pre-A1 از نظر محتوای آموزشی در scope فعلی text/audio و image-free نهایی شده است؛ audio assetها مرحلهٔ بعدی مستقل هستند.',
 audio_status=CASE WHEN audio_status='ready' THEN 'ready' ELSE 'pending' END
WHERE id=@level;
UPDATE language_levels SET status='final' WHERE id=@level;
COMMIT;
-- END PRE-A1 FINALIZATION EXTENSION

-- BEGIN GENERATED PERSIAN LOCALIZATION SYNC
START TRANSACTION;
UPDATE language_levels SET status='review' WHERE id=@level AND status='final';
UPDATE lessons SET status='qa' WHERE language_level_id=@level AND status='final';
UPDATE sources SET title_fa='منبع عبارت سلام «hallo».', locator='German interjection / greeting formula', locator_fa='منبع عبارت سلام «hallo».', currency_evidence='مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.', notes='منبع عبارت سلام «hallo».' WHERE source_key='src-wiktionary-de-hallo';
UPDATE sources SET title_fa='منبع عبارت «guten Morgen».', locator='German greeting formula', locator_fa='منبع عبارت «guten Morgen».', currency_evidence='مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.', notes='منبع عبارت «guten Morgen».' WHERE source_key='src-wiktionary-de-guten-morgen';
UPDATE sources SET title_fa='منبع «mögen» و شکل‌های «mag / magst».', locator='German verb; present forms include mag and magst', locator_fa='منبع «mögen» و شکل‌های «mag / magst».', currency_evidence='مدخل زنده و فعال Wiktionary برای هویت واژگانی و شکل‌های صرفی معاصر بررسی شده است.', notes='منبع «mögen» و شکل‌های «mag / magst».' WHERE source_key='src-wiktionary-de-moegen';
UPDATE sources SET title_fa='منبع اسم «Pizza».', locator='German noun', locator_fa='منبع اسم «Pizza».', currency_evidence='مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.', notes='منبع اسم «Pizza».' WHERE source_key='src-wiktionary-de-pizza';
UPDATE sources SET title_fa='منبع رسمی جملهٔ دقیق «Ich mag Pizza.».', locator='p. 12, Alphabetisierung – Vorlesen, Aufgabe 3a: Ich mag Pizza.', locator_fa='منبع رسمی جملهٔ دقیق «Ich mag Pizza.».', currency_evidence='منبع رسمی آموزشی ایالت Brandenburg از سال ۲۰۲۵ است و برای کاربرد آموزشی معاصر بررسی شده است.', notes='منبع رسمی جملهٔ دقیق «Ich mag Pizza.».' WHERE source_key='src-libra-de-ich-mag-pizza';
UPDATE sources SET title_fa='منبع پرسش «Magst du Pizza?».', locator='German examples under igen, item 8: Magst du Pizza?', locator_fa='منبع پرسش «Magst du Pizza?».', currency_evidence='صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده است و مثال مورد استفاده با کاربرد معاصر آلمانی سازگار است.', notes='منبع پرسش «Magst du Pizza?».' WHERE source_key='src-wikibooks-de-magst-du-pizza';
UPDATE sources SET title_fa='منبع پاسخ مثبت «ja».', locator='German response particle expressing agreement / affirmation', locator_fa='منبع پاسخ مثبت «ja».', currency_evidence='مدخل زنده و فعال Wiktionary برای پاسخ مثبت معاصر بررسی شده است.', notes='منبع پاسخ مثبت «ja».' WHERE source_key='src-wiktionary-de-ja';
UPDATE sources SET title_fa='منبع پاسخ منفی «nein».', locator='German response particle expressing rejection / negation, commonly in answer to a question', locator_fa='منبع پاسخ منفی «nein».', currency_evidence='مدخل زنده و فعال Wiktionary برای پاسخ منفی معاصر بررسی شده است.', notes='منبع پاسخ منفی «nein».' WHERE source_key='src-wiktionary-de-nein';
UPDATE sources SET title_fa='منبع عبارت تشکر «danke».', locator='German interjection / response particle used to express thanks', locator_fa='منبع عبارت تشکر «danke».', currency_evidence='مدخل زنده و فعال Wiktionary برای عبارت تشکر معاصر بررسی شده است.', notes='منبع عبارت تشکر «danke».' WHERE source_key='src-wiktionary-de-danke';
UPDATE sources SET title_fa='در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود.', locator='German adverb / response particle; meaning [2]: response to thanks', locator_fa='در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود.', currency_evidence='مدخل زنده و فعال Wiktionary در وضعیت فعلی بررسی شده و فقط کاربرد مستند پاسخ به تشکر استفاده می‌شود.', notes='در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود.' WHERE source_key='src-wiktionary-de-bitte';
UPDATE sources SET title_fa='برای «Wie geht''s?»، «Gut.» و «Tschüss!» استفاده می‌شود.', locator='Starting Point / basic conversation: Hallo!, Wie geht''s?, shorter reply Gut., informal goodbye Tschüss!', locator_fa='برای «Wie geht''s?»، «Gut.» و «Tschüss!» استفاده می‌شود.', currency_evidence='صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده و عبارت‌های استفاده‌شده با آلمانی معاصر سازگارند.', notes='برای «Wie geht''s?»، «Gut.» و «Tschüss!» استفاده می‌شود.' WHERE source_key='src-wikibooks-de-basic-greetings';
UPDATE sources SET title_fa='منبع «Entschuldigung».', locator='German interjection; contemporary apology / attention-getting expression', locator_fa='منبع «Entschuldigung».', currency_evidence='مدخل زنده و نگهداری‌شدهٔ Wiktionary آلمانی در وضعیت فعلی بررسی شده است.', notes='منبع «Entschuldigung».' WHERE source_key='src-wiktionary-de-entschuldigung';
UPDATE sources SET title_fa='منبع «kein Problem».', locator='German phrase: kein Problem', locator_fa='منبع «kein Problem».', currency_evidence='مدخل در سال ۲۰۲۶ به‌روز شده و عبارت امروزی «kein Problem» را مستقیم ثبت می‌کند.', notes='منبع «kein Problem».' WHERE source_key='src-wiktionary-de-kein-problem';
UPDATE sources SET title_fa='منبع «Wie heißt du?» و «Ich heiße Iris.».', locator='Exercises and answers containing Wie heißt du? and Ich heiße Iris.', locator_fa='منبع «Wie heißt du?» و «Ich heiße Iris.».', currency_evidence='صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده و برای الگوی سادهٔ پرسیدن و گفتن نام استفاده می‌شود.', notes='منبع «Wie heißt du?» و «Ich heiße Iris.».' WHERE source_key='src-wikibooks-de-wie-heisst-du';
UPDATE sources SET title_fa='منبع «heißen» و شکل‌های «heiße / heißt».', locator='German verb heißen; present forms heiße and heißt', locator_fa='منبع «heißen» و شکل‌های «heiße / heißt».', currency_evidence='مدخل زنده و نگهداری‌شدهٔ Wiktionary آلمانی و شکل‌های حال آن در وضعیت فعلی بررسی شده است.', notes='منبع «heißen» و شکل‌های «heiße / heißt».' WHERE source_key='src-wiktionary-de-heissen';
UPDATE sources SET title_fa='منبع دقیق پرسش «Was möchtest du?» و شاهد آموزشی معاصر برای کاربرد «möcht-».', locator='Lesson title and key learning points: Was möchtest du? / conditional form of mögen', locator_fa='منبع دقیق پرسش «Was möchtest du?» و شاهد آموزشی معاصر برای کاربرد «möcht-».', currency_evidence='صفحهٔ آموزشی زندهٔ Oak National Academy در سپتامبر ۲۰۲۶ بررسی شده است؛ خود درس استفادهٔ معاصر از «Was möchtest du?» و شکل «möcht-» را آموزش می‌دهد و شرایط فعلی Oak محتوای جدید را تحت OGL v3.0 منتشر می‌کند مگر خلاف آن ذکر شده باشد.', notes='منبع دقیق پرسش «Was möchtest du?» و شاهد آموزشی معاصر برای کاربرد «möcht-».' WHERE source_key='src-oak-de-was-moechtest-du';
UPDATE sources SET title_fa='مرجع شکل «möchtest» و پیوند آن با مدخل واژگانی «mögen».', locator='German möchten entry; inflected form of mögen and second-person singular möchtest', locator_fa='مرجع شکل «möchtest» و پیوند آن با مدخل واژگانی «mögen».', currency_evidence='مدخل زنده و نگهداری‌شدهٔ Wiktionary در سپتامبر ۲۰۲۶ بررسی شده و «möchten» را به‌عنوان صورت صرف‌شدهٔ «mögen» و کاربرد معاصر آن ثبت می‌کند.', notes='مرجع شکل «möchtest» و پیوند آن با مدخل واژگانی «mögen».' WHERE source_key='src-wiktionary-de-moechten';
UPDATE sources SET title_fa='مرجع برنامه‌ریزی برای توصیفگرهای Pre-A1؛ برای تعیین پوشش استفاده می‌شود و متن آموزشی آلمانی از آن بازاستفاده نمی‌شود.', locator='مرجع برنامه‌ریزی برای توصیفگرهای Pre-A1؛ برای تعیین پوشش استفاده می‌شود و متن آموزشی آلمانی از آن بازاستفاده نمی‌شود.', locator_fa='مرجع برنامه‌ریزی برای توصیفگرهای Pre-A1؛ برای تعیین پوشش استفاده می‌شود و متن آموزشی آلمانی از آن بازاستفاده نمی‌شود.', currency_evidence='نسخهٔ رسمی Companion Volume شورای اروپا و توصیفگرهای Pre-A1 در وضعیت جاری بررسی شده‌اند.', notes='مرجع برنامه‌ریزی برای توصیفگرهای Pre-A1؛ برای تعیین پوشش استفاده می‌شود و متن آموزشی آلمانی از آن بازاستفاده نمی‌شود.' WHERE source_key='src-coe-cefr-pre-a1';
UPDATE sources SET title_fa='منبع عبارت‌های «Wo wohnen Sie? / Ich wohne in Österreich. / Woher kommen Sie? / Ich komme aus Deutschland, und Sie?» و «Guten Tag! / Wie heißen Sie? / Ich heiße Paul Müller.».', locator='منبع عبارت‌های «Wo wohnen Sie? / Ich wohne in Österreich. / Woher kommen Sie? / Ich komme aus Deutschland, und Sie?» و «Guten Tag! / Wie heißen Sie? / Ich heiße Paul Müller.».', locator_fa='منبع عبارت‌های «Wo wohnen Sie? / Ich wohne in Österreich. / Woher kommen Sie? / Ich komme aus Deutschland, und Sie?» و «Guten Tag! / Wie heißen Sie? / Ich heiße Paul Müller.».', currency_evidence='صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و در ماه‌های اخیر منتشر/نگهداری شده است.', notes='منبع عبارت‌های «Wo wohnen Sie? / Ich wohne in Österreich. / Woher kommen Sie? / Ich komme aus Deutschland, und Sie?» و «Guten Tag! / Wie heißen Sie? / Ich heiße Paul Müller.».' WHERE source_key='src-wikibooks-de-residence-origin';
UPDATE sources SET title_fa='منبع سن، عددهای ساده، روز، ساعت، زمان روز، Adresse و نمونهٔ قیمت «Die Zeitschrift kostet 7,60 Euro.».', locator='منبع سن، عددهای ساده، روز، ساعت، زمان روز، Adresse و نمونهٔ قیمت «Die Zeitschrift kostet 7,60 Euro.».', locator_fa='منبع سن، عددهای ساده، روز، ساعت، زمان روز، Adresse و نمونهٔ قیمت «Die Zeitschrift kostet 7,60 Euro.».', currency_evidence='صفحهٔ زندهٔ Wikibooks در ماه اخیر منتشر/به‌روزرسانی شده و برای کاربرد معاصر بررسی شده است.', notes='منبع سن، عددهای ساده، روز، ساعت، زمان روز، Adresse و نمونهٔ قیمت «Die Zeitschrift kostet 7,60 Euro.».' WHERE source_key='src-wikibooks-de-age-time';
UPDATE sources SET title_fa='منبع زمان، روزها، تاریخ و جملهٔ «Ich habe am dreizehnten November Geburtstag.».', locator='منبع زمان، روزها، تاریخ و جملهٔ «Ich habe am dreizehnten November Geburtstag.».', locator_fa='منبع زمان، روزها، تاریخ و جملهٔ «Ich habe am dreizehnten November Geburtstag.».', currency_evidence='صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده است.', notes='منبع زمان، روزها، تاریخ و جملهٔ «Ich habe am dreizehnten November Geburtstag.».' WHERE source_key='src-wikibooks-de-birthday';
UPDATE sources SET title_fa='منبع عبارت‌های آلمانیِ دارای attribution «Wann hast du Geburtstag?» و «Am 16. Juli.».', locator='منبع عبارت‌های آلمانیِ دارای attribution «Wann hast du Geburtstag?» و «Am 16. Juli.».', locator_fa='منبع عبارت‌های آلمانیِ دارای attribution «Wann hast du Geburtstag?» و «Am 16. Juli.».', currency_evidence='صفحهٔ زندهٔ Wikibooks و attribution جمله‌های تعبیه‌شده در وضعیت فعلی بررسی شده است.', notes='منبع عبارت‌های آلمانیِ دارای attribution «Wann hast du Geburtstag?» و «Am 16. Juli.».' WHERE source_key='src-wikibooks-de-birthday-question';
UPDATE sources SET title_fa='منبع دارای attribution برای «Wie lautet deine Telefonnummer?» و «Meine Telefonnummer lautet 789.».', locator='منبع دارای attribution برای «Wie lautet deine Telefonnummer?» و «Meine Telefonnummer lautet 789.».', locator_fa='منبع دارای attribution برای «Wie lautet deine Telefonnummer?» و «Meine Telefonnummer lautet 789.».', currency_evidence='صفحهٔ زندهٔ Wikibooks و attribution جمله‌های تعبیه‌شده در وضعیت فعلی بررسی شده است.', notes='منبع دارای attribution برای «Wie lautet deine Telefonnummer?» و «Meine Telefonnummer lautet 789.».' WHERE source_key='src-wikibooks-de-phone';
UPDATE sources SET title_fa='منبع دارای attribution برای «Meine Telefonnummer ist: 692-267-752.».', locator='منبع دارای attribution برای «Meine Telefonnummer ist: 692-267-752.».', locator_fa='منبع دارای attribution برای «Meine Telefonnummer ist: 692-267-752.».', currency_evidence='صفحهٔ زندهٔ Wikibooks و attribution جملهٔ تعبیه‌شده در وضعیت فعلی بررسی شده است.', notes='منبع دارای attribution برای «Meine Telefonnummer ist: 692-267-752.».' WHERE source_key='src-wikibooks-de-phone-example';
UPDATE sources SET title_fa='منبع پرسش بسیار سادهٔ «Was ist das?» و پاسخ‌های «Das ist ein Buch.» و «Das ist eine Karte.».', locator='منبع پرسش بسیار سادهٔ «Was ist das?» و پاسخ‌های «Das ist ein Buch.» و «Das ist eine Karte.».', locator_fa='منبع پرسش بسیار سادهٔ «Was ist das?» و پاسخ‌های «Das ist ein Buch.» و «Das ist eine Karte.».', currency_evidence='صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و برای زبان آغازین معاصر مناسب است.', notes='منبع پرسش بسیار سادهٔ «Was ist das?» و پاسخ‌های «Das ist ein Buch.» و «Das ist eine Karte.».' WHERE source_key='src-wikibooks-de-basic-object';
UPDATE source_items si JOIN sources s ON s.id=si.source_id SET si.locator_fa=si.notes WHERE s.language_code='de' AND si.locator IS NOT NULL;
UPDATE language_levels ll JOIN languages la ON la.id=ll.language_id SET ll.status='review', ll.audio_status='pending', ll.structure_rationale='سطح از ارتباط‌های بسیار ساده و فوری برای زبان‌آموز صفر شروع می‌شود و فقط وقتی گسترش پیدا می‌کند که پوشش CEFR، پیش‌نیازها یا نیاز به تمرین بیشتر آن را توجیه کند؛ تعداد درس یا واحد معیار تولید محتوا نیست.', ll.coverage=CAST('{"communicativeTargets":["سلام، خداحافظی، تشکر، پاسخ مؤدبانه و عذرخواهی کوتاه","پرسیدن و گفتن نام","احوال‌پرسی بسیار ساده","پرسیدن و پاسخ‌دادن دربارهٔ علاقه/انتخاب غذای آشنا","پاسخ مثبت و منفی کوتاه","پرسیدن و گفتن محل زندگی و مبدأ","پرسیدن و گفتن سن و فهم عددهای ساده","پرسیدن و گفتن روز، ساعت و زمان روز","پرسیدن و گفتن تاریخ تولد","پرسیدن و گفتن شماره تلفن","پرسیدن سؤال اطلاعاتی بسیار ساده و فهم پاسخ کوتاه","نوشتن اطلاعات شخصی بسیار کوتاه در یک فرم متنی","تشخیص شنیداری یک قیمت ساده"],"linguisticTargets":["عبارت‌های ثابت سلام/خداحافظی و ادب","فعل‌های پایهٔ «mögen»، «heißen»، «wohnen» و «kommen» در کاربردهای منبع‌دار این سطح","عددهای ساده در سن، ساعت، تلفن و قیمت","واژه‌های پایهٔ روز، ساعت، تولد، شماره تلفن و نشانی","الگوهای منبع‌دار معرفی، محل زندگی، سن، تاریخ تولد و شماره تلفن"],"situations":["آشنایی اولیه","گفت‌وگوی کوتاه صبحگاهی","علاقه و انتخاب غذای آشنا","تشکر و عذرخواهی","اطلاعات شخصی در آشنایی مؤدبانه","پرسش سن","پرسش روز و ساعت","تاریخ تولد","تبادل شماره تلفن","سؤال اطلاعاتی بسیار ساده","فرم متنی اطلاعات شخصی","تشخیص قیمت ساده"],"gaps":[]}' AS JSON), ll.completion_assessment=CAST('{"reviewedAt":"2026-09-16T18:15:00Z","cefrCoverageComplete":true,"progressionComplete":true,"practiceAndRetrievalComplete":true,"skillModeCoverageComplete":true,"requiredGaps":[],"scopeExclusions":["توصیفگرهای Pre-A1 که صراحتاً به متن مصور، تصویر یا اشارهٔ فیزیکی/دیداری وابسته‌اند، به‌دلیل baseline فعلی بدون تصویر خارج از دامنه محصول هستند؛ توانایی‌های مستقلِ متنی، گفتاری و شنیداری متناظر پوشش داده شده‌اند."],"qualityReview":{"overallScore":9.7,"dimensionScores":{"cefrCoverage":9.7,"pedagogicalProgression":9.6,"practiceAndRetrieval":9.7,"activityQualityAndVariety":9.7,"linguisticAccuracyAndNaturalness":9.6,"sourceQualityAndCurrency":9.8,"learnerSupportAndClarity":9.8,"qaIntegrity":10.0},"rationale":"پوشش نهایی بر توصیفگرهای رسمی Pre-A1 و دامنه متن/صوت بدون تصویر تطبیق داده شده است؛ اهداف اطلاعات شخصی، عدد، روز/ساعت/تاریخ، تاریخ تولد، تلفن، سؤال اطلاعاتی بسیار ساده، نوشتن فرم کوتاه و بازیابی چندحالتی پوشش دارند و CI منبع، فارسی، ساختار و MySQL را کنترل می‌کند.","strengths":["پوشش توصیفگرمحور بدون سهمیهٔ درس یا فعالیت","تمام متن هدف نمایش‌داده‌شده به زبان‌آموز منبع‌دار و قابل ردیابی است","مرور نهایی گفتار، شنیدن، خواندن و نوشتن متنی را ترکیب می‌کند","قواعد فارسی، بدون تصویر، آغازکننده، صوت و MySQL به‌صورت خودکار کنترل می‌شوند."],"remainingWeaknesses":["فایل‌های صوتی هنوز تولید نشده‌اند؛ همهٔ فایل‌های لازم پس از نهایی شدن سطح در وضعیت در انتظار تولید قرار می‌گیرند و فرایند صوت باید آن‌ها را تولید و لینک کند."]}}' AS JSON), ll.notes='سطح پیش از A1 آلمانی از نظر محتوای آموزشی در دامنه فعلی متن/صوت و بدون تصویر نهایی شده است؛ صوت فایل‌ها مرحلهٔ بعدی مستقل هستند.' WHERE la.code='de' AND ll.cefr_level='Pre-A1';
UPDATE units SET title_fa='اولین قدم‌ها', grouping_rationale='این درس‌ها کنار هم قرار گرفته‌اند چون همگی ارتباط‌های بسیار ساده، فوری و کم‌فشار برای شروع از صفر هستند. این گروه‌بندی دلیل آموزشی دارد و ظرفیت عددی برای تعداد درس ندارد.', status='final', notes='باز یا بسته‌ماندن این واحد فقط به تصمیم‌های پوشش آموزشی بعدی بستگی دارد، نه به رسیدن به تعداد مشخصی درس.' WHERE unit_key='de-pre-a1-unit-first-steps';
UPDATE units SET title_fa='اطلاعات شخصی خیلی ساده', grouping_rationale='این درس‌ها یک خوشهٔ منسجم از اطلاعات شخصی و اطلاعات روزمرهٔ بسیار پایه می‌سازند و بعد با یک مرور نوشتاری/گفتاری جمع‌بندی می‌شوند؛ مرز واحد از تغییر هدف ارتباطی ایجاد شده است، نه از ظرفیت عددی.', status='final', notes='این واحد توصیفگرهای غیرتصویری باقیماندهٔ Pre-A1 را می‌بندد و سپس سطح وارد audit نهایی می‌شود.' WHERE unit_key='de-pre-a1-unit-personal-info';
UPDATE lessons SET title_fa='سلام!', source_title='hallo / Tschüss!', source_title_fa='سلام!', status='qa', activity_selection_rationale='برای درس اول، یک گفت‌وگوی چهار نوبت از سلام تا خداحافظی کافی است و بار زبانی بیشتری اضافه نمی‌شود.', sequence_rationale='زبان‌آموز فقط دو عبارت بسیار پایه را در یک رفت‌وبرگشت کوتاه استفاده می‌کند.', template_signature='conversation_speaking', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-hallo';
UPDATE activities SET instruction_fa='با میا یک گفت‌وگوی خیلی کوتاه از سلام تا خداحافظی انجام بده.', selection_reason='برای شروع دوره همین تعامل چهار نوبت هدف اصلی را پوشش می‌دهد و تمرین اضافه لازم نیست.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-hallo-conversation';
UPDATE lessons SET title_fa='صبح بخیر!', source_title='guten Morgen / Tschüss!', source_title_fa='صبح بخیر!', status='qa', activity_selection_rationale='گفت‌وگوی چهار نوبت فقط سلام صبحگاهی و خداحافظی را تمرین می‌کند؛ بعد یک فعالیت تشخیصی تفاوت آن را با سلام عمومی تثبیت می‌کند.', sequence_rationale='اول زبان‌آموز خودش مکالمه را با عبارت صبحگاهی آغاز می‌کند و بعد زمان مناسب استفاده از آن را تشخیص می‌دهد.', template_signature='conversation_speaking>multiple_choice', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-guten-morgen';
UPDATE activities SET instruction_fa='این بار تو گفت‌وگو را شروع کن؛ صبح است، به میا «Guten Morgen!» بگو و مکالمهٔ کوتاه را ادامه بده.', selection_reason='شروع‌کردن مکالمه توسط زبان‌آموز باعث می‌شود سلام صبحگاهی را فعالانه تولید کند، بدون اینکه مکالمهٔ شروع دوره طولانی شود.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-gm-conversation';
UPDATE activities SET instruction_fa='برای سلام کردن در صبح کدام عبارت مناسب‌تر است؟', selection_reason='این فعالیت فقط تفاوت جدید درس را می‌سنجد: سلام مخصوص صبح در برابر سلام عمومی.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-gm-choice';
UPDATE lessons SET title_fa='پیتزا دوست دارم', source_title='Magst du Pizza? / Ich mag Pizza.', source_title_fa='پیتزا دوست دارم', status='qa', activity_selection_rationale='گفت‌وگوی چهار نوبت پرسش و پاسخ دربارهٔ علاقه به پیتزا را در بافت قرار می‌دهد و سپس بازسازی همان جمله یک بازیابی متمرکز ایجاد می‌کند.', sequence_rationale='اول زبان‌آموز در مکالمهٔ کوتاه به پرسش واقعی پاسخ می‌دهد و بعد همان جملهٔ منبع‌دار را دوباره می‌سازد.', template_signature='conversation_speaking>word_order', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-pizza-like';
UPDATE activities SET instruction_fa='با میا دربارهٔ پیتزا یک گفت‌وگوی چهار نوبت داشته باش و به سؤالش جواب بده.', selection_reason='موضوع آشنای پیتزا امکان استفادهٔ فوری و قابل‌فهم از «mögen» را در یک مکالمهٔ کوتاه فراهم می‌کند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-pizza-conversation';
UPDATE activities SET instruction_fa='جمله‌ای را که همین الان گفتی دوباره بساز.', selection_reason='بازسازی همان جملهٔ منبع‌دار، الگوی جدید را بدون واردکردن زبان تازه تقویت می‌کند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-pizza-word-order';
UPDATE lessons SET title_fa='بله یا نه؟', source_title='Magst du Pizza? / ja / nein', source_title_fa='بله یا نه؟', status='qa', activity_selection_rationale='مکالمهٔ چهار نوبت این بار با زبان‌آموز شروع می‌شود تا سؤال آشنا را فعالانه بپرسد؛ سپس انتخاب پاسخ تفاوت «ja» و «nein» را تمرین می‌کند.', sequence_rationale='اول زبان‌آموز نقش آغازکننده و پرسشگر را می‌گیرد، سپس پاسخ مثبت و منفی را در همان بافت تشخیص می‌دهد.', template_signature='conversation_speaking>choose_response', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-ja-nein';
UPDATE activities SET instruction_fa='این بار تو مکالمه را شروع کن؛ سلام کن و سؤال آشنای پیتزا را از میا بپرس.', selection_reason='شروع مکالمه توسط زبان‌آموز، زبان آشنای قبلی را از حالت پاسخ‌دادن به تولید فعال تبدیل می‌کند و در چهار نوبت تمام می‌شود.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-ja-conversation';
UPDATE activities SET instruction_fa='فرض کن پیتزا دوست نداری. کدام جواب مناسب است؟', selection_reason='چون پرسش از قبل آشناست، تمرکز فعالیت فقط روی تشخیص پاسخ مثبت و منفی می‌ماند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-ja-nein-choice';
UPDATE lessons SET title_fa='ممنون! خواهش می‌کنم', source_title='danke / bitte', source_title_fa='ممنون! خواهش می‌کنم', status='qa', activity_selection_rationale='گفت‌وگوی چهار نوبت عبارت تشکر و پاسخ مؤدبانه را داخل یک تعامل کوتاه و روشن قرار می‌دهد و برای این هدف تمرین اضافه لازم نیست.', sequence_rationale='زبان‌آموز سلام می‌کند، تشکر را در بافت می‌شنود و پاسخ مؤدبانه می‌دهد؛ مکالمه عمداً طولانی‌تر نمی‌شود.', template_signature='conversation_speaking', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-danke-bitte';
UPDATE activities SET instruction_fa='میا بعد از یک کمک کوچک تشکر می‌کند؛ پاسخ مؤدبانه بده.', selection_reason='«Danke!» و «Bitte!» در یک تعامل چهار نوبت روزمره بهتر از دو کارت جداگانه یاد گرفته می‌شوند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-danke-bitte-conversation';
UPDATE lessons SET title_fa='ببخشید!', source_title='Entschuldigung. / Kein Problem. / Danke! / Bitte!', source_title_fa='ببخشید!', status='qa', activity_selection_rationale='بعد از گفت‌وگوی کوتاه، matching فقط رابطهٔ دو جفت اجتماعی نزدیک را تثبیت می‌کند و زبان تازه‌ای وارد نمی‌کند.', sequence_rationale='زبان‌آموز ابتدا خودش عذرخواهی را آغاز می‌کند و بعد پاسخ‌های مناسب را به عبارت‌های آشنا وصل می‌کند.', template_signature='conversation_speaking>matching', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-entschuldigung';
UPDATE activities SET instruction_fa='این بار تو گفت‌وگو را شروع کن؛ برای یک اشتباه کوچک با «Entschuldigung.» عذرخواهی کن.', selection_reason='هدف اصلی این درس استفادهٔ فعال از یک عذرخواهی کوتاه در یک تعامل واقعی و کم‌فشار است.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-entschuldigung-conversation';
UPDATE activities SET instruction_fa='هر عبارت را به پاسخ مناسبش وصل کن.', selection_reason='دو جفت اجتماعی کوتاه ممکن است در شروع دوره با هم قاطی شوند؛ matching بدون افزودن متن تازه رابطهٔ درست را تمرین می‌کند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-entschuldigung-matching';
UPDATE lessons SET title_fa='اسمت چیه؟', source_title='Wie heißt du? / Ich heiße Iris.', source_title_fa='اسمت چیه؟', status='qa', activity_selection_rationale='گفت‌وگو نام‌پرسیدن را در بافت قرار می‌دهد و word order همان پاسخ منبع‌دار را برای بازیابی الگوی «Ich heiße ...» تمرین می‌کند.', sequence_rationale='اول زبان‌آموز سؤال نام را در مکالمه استفاده می‌کند و بعد پاسخ منبع‌دار را بدون معرفی جملهٔ تازه بازسازی می‌کند.', template_signature='conversation_speaking>word_order', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-name-exchange';
UPDATE activities SET instruction_fa='بعد از سلام، نام آیریس را با «Wie heißt du?» بپرس.', selection_reason='پرسیدن نام یکی از اولین کنش‌های ارتباطی مفید است و در چهار نوبت ساده قابل تمرین است.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-name-conversation';
UPDATE activities SET instruction_fa='پاسخ آیریس را دوباره بساز.', selection_reason='بازسازی جملهٔ دقیق منبع، الگوی «Ich heiße ...» و فرم «heiße» را بدون توضیح دستوری سنگین تقویت می‌کند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-name-word-order';
UPDATE lessons SET title_fa='حالت چطوره؟', source_title='Wie geht''s? / Gut.', source_title_fa='حالت چطوره؟', status='qa', activity_selection_rationale='بعد از گفت‌وگو، fill blank فقط عبارت تازهٔ «Wie geht''s?» را با حذف یک بخش کوچک بازیابی می‌کند و بار شناختی را پایین نگه می‌دارد.', sequence_rationale='اول معنی و پاسخ در مکالمه دیده می‌شود و بعد همان عبارت منبع‌دار با یک جای‌خالی ساده بازیابی می‌شود.', template_signature='conversation_speaking>fill_blank', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-wellbeing';
UPDATE activities SET instruction_fa='با میا سلام کن و وقتی می‌پرسد «Wie geht''s?» با «Gut.» جواب بده.', selection_reason='احوال‌پرسی پایه باید اول در یک تعامل کوتاه و روشن دیده و گفته شود.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-wellbeing-conversation';
UPDATE activities SET instruction_fa='عبارت احوال‌پرسی را کامل کن.', selection_reason='جای‌خالی از همان عبارت منبع‌دار ساخته شده و بدون معرفی واژهٔ تازه یک بازیابی سبک ایجاد می‌کند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-wellbeing-fill';
UPDATE lessons SET title_fa='چی می‌خوای؟', source_title='Was möchtest du? / Pizza', source_title_fa='چی می‌خوای؟', status='qa', activity_selection_rationale='هدف این مرحله فقط فهم یک پرسش سادهٔ خواستن و انتخاب یک گزینهٔ آشناست؛ همان گفت‌وگوی چهار نوبت هدف را کامل پوشش می‌دهد و تمرین اضافه در این لحظه فقط تکرار مکانیکی ایجاد می‌کند.', sequence_rationale='زبان‌آموز ابتدا زبان آشنای سلام را بازیابی می‌کند، سپس پرسش تازهٔ «Was möchtest du?» را می‌شنود و بدون واژهٔ جدید با «Pizza.» پاسخ می‌دهد.', template_signature='conversation_speaking', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-simple-choice';
UPDATE activities SET instruction_fa='با میا سلام کن؛ وقتی می‌پرسد «Was möchtest du?» گزینهٔ آشنای «Pizza.» را انتخاب کن.', selection_reason='پرسش تازه با یک پاسخ از قبل آشنا تمرین می‌شود تا بار شناختی فقط روی «möchtest» و مفهوم انتخاب بماند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-simple-choice-conversation';
UPDATE lessons SET title_fa='کجا زندگی می‌کنی؟', source_title='Wo wohnen Sie? / Woher kommen Sie?', source_title_fa='کجا زندگی می‌کنی؟', status='qa', activity_selection_rationale='همان مکالمهٔ کوتاه هدف این درس را پوشش می‌دهد و تمرین اضافه فقط تکرار ایجاد می‌کند.', sequence_rationale='ابتدا محل زندگی و سپس مبدأ در یک آشنایی مؤدبانه مطرح می‌شود.', template_signature='conversation_speaking', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-residence-origin';
UPDATE activities SET instruction_fa='در یک گفت‌وگوی مؤدبانه دربارهٔ محل زندگی و مبدأ جواب بده و یک سؤال هم بپرس.', selection_reason='دو توصیفگر نزدیکِ اطلاعات شخصی در یک تبادل چهار نوبت طبیعی کنار هم تمرین می‌شوند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-residence-conversation';
UPDATE lessons SET title_fa='چند سالته؟', source_title='Wie alt bist du? / Ich bin ... Jahre alt.', source_title_fa='چند سالته؟', status='qa', activity_selection_rationale='بعد از تعامل، یک تشخیص شنیداری عدد لازم است چون CEFR روی فهم عددهای ساده تأکید دارد.', sequence_rationale='اول سن در مکالمه معنا پیدا می‌کند و سپس عدد به‌تنهایی از راه شنیدن بازیابی می‌شود.', template_signature='conversation_speaking>listen_choose', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-age-numbers';
UPDATE activities SET instruction_fa='سن میا را بپرس و وقتی او از سن تو می‌پرسد، پاسخ نمونه را بگو.', selection_reason='سن و عدد باید اول در تعامل واقعی دیده شوند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-age-conversation';
UPDATE activities SET instruction_fa='عدد «achtzehn» را گوش کن و عدد درست را انتخاب کن.', selection_reason='توصیفگر Pre-A1 فهم عددهای ساده را می‌خواهد؛ این تمرین تشخیص شنیداری را بدون افزودن زبان تازه می‌سنجد.', audio_status='pending', audio_text_target='achtzehn' WHERE activity_key='act-de-age-listen';
UPDATE lessons SET title_fa='امروز چه روزیه؟ ساعت چنده؟', source_title='Welcher Tag ist heute? / Wie spät ist es?', source_title_fa='امروز چه روزیه؟ ساعت چنده؟', status='qa', activity_selection_rationale='مکالمه تولید سؤال را می‌گیرد؛ شنیدن ساعت و تشخیص زمان روز دو شیوه جدا و لازم برای توصیفگر هستند.', sequence_rationale='روز و ساعت در یک صحنه می‌آیند؛ سپس دریافت شنیداری و خواندنی بدون افزودن ساختار تازه تثبیت می‌شود.', template_signature='conversation_speaking>listen_choose>multiple_choice', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-day-time';
UPDATE activities SET instruction_fa='این بار تو شروع کن؛ روز و ساعت را از میا بپرس.', selection_reason='پرسیدن فعال روز و ساعت مستقیماً توصیفگر اطلاعات روزمره را تمرین می‌کند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-time-conversation';
UPDATE activities SET instruction_fa='زمان را گوش کن و ساعت درست را انتخاب کن.', selection_reason='برای پوشش دریافت، زمان دقیق به‌صورت شنیداری تشخیص داده می‌شود.', audio_status='pending', audio_text_target='Es ist 6.30 Uhr.' WHERE activity_key='act-de-time-listen';
UPDATE activities SET instruction_fa='اگر صبح باشد، کدام جملهٔ منبع‌دار زمان روز را بیان می‌کند؟', selection_reason='CEFR علاوه بر ساعت، زمان روز را هم در Pre-A1 می‌آورد؛ تشخیص متنی کافی است و زبان تازهٔ اضافی لازم ندارد.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-time-of-day';
UPDATE lessons SET title_fa='تولدت کیه؟', source_title='Wann hast du Geburtstag? / Ich habe am ... Geburtstag.', source_title_fa='تولدت کیه؟', status='qa', activity_selection_rationale='بعد از مکالمه فقط یک بازیابی نوشتاری منبع‌دار لازم است.', sequence_rationale='اول تاریخ در تعامل معنا پیدا می‌کند و سپس همان ساختار با جای خالی تثبیت می‌شود.', template_signature='conversation_speaking>fill_blank', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-birthday-date';
UPDATE activities SET instruction_fa='تاریخ تولد را بپرس و پاسخ نمونهٔ کوتاه را بگو.', selection_reason='پرسش و پاسخ تاریخ تولد مستقیماً توصیفگر Pre-A1 را پوشش می‌دهد.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-birthday-conversation';
UPDATE activities SET instruction_fa='جملهٔ تاریخ تولد را با بخش منبع‌دار کامل کن.', selection_reason='یک بازیابی نوشتاری سبک از همان جملهٔ منبع‌دار، تاریخ را بدون ساخت جملهٔ تازه تمرین می‌کند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-birthday-fill';
UPDATE lessons SET title_fa='شماره تلفنت چیه؟', source_title='Wie lautet deine Telefonnummer? / Meine Telefonnummer ...', source_title_fa='شماره تلفنت چیه؟', status='qa', activity_selection_rationale='بعد از مکالمه، تشخیص شنیداری شماره برای پوشش دریافت لازم است.', sequence_rationale='اول تبادل شماره تمرین می‌شود و بعد یک شمارهٔ همان منبع از راه شنیدن بازیابی می‌شود.', template_signature='conversation_speaking>listen_choose', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-phone-number';
UPDATE activities SET instruction_fa='شماره تلفن را بپرس و پاسخ نمونه را بگو.', selection_reason='پرسش و پاسخ مستقیم شماره تلفن توصیفگر صریح Pre-A1 است.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-phone-conversation';
UPDATE activities SET instruction_fa='شماره را گوش کن و عدد درست را انتخاب کن.', selection_reason='شماره تلفن باید در دریافت شنیداری هم قابل تشخیص باشد.', audio_status='pending', audio_text_target='Meine Telefonnummer lautet 789.' WHERE activity_key='act-de-phone-listen';
UPDATE lessons SET title_fa='این چیه؟', source_title='Was ist das? / Das ist ...', source_title_fa='این چیه؟', status='qa', activity_selection_rationale='خود مکالمه توصیفگر را کامل پوشش می‌دهد؛ فعالیت تصویری عمداً وارد نمی‌شود.', sequence_rationale='زبان‌آموز یک بار سؤال را شروع می‌کند و یک بار پاسخ می‌دهد تا هر دو نقش تمرین شوند.', template_signature='conversation_speaking', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-basic-object';
UPDATE activities SET instruction_fa='این بار تو شروع کن؛ در بافت متنی بپرس «Was ist das?» و پاسخ‌های کوتاه را تمرین کن.', selection_reason='این فعالیت توصیفگر سؤال اطلاعاتی بسیار ساده را به شکل فقط متنی و بدون تصویر پوشش می‌دهد.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-object-conversation';
UPDATE lessons SET title_fa='مرور اطلاعات شخصی', source_title='مرور نام، محل، سن، فرم کوتاه و قیمت شنیداری', source_title_fa='مرور اطلاعات شخصی', status='qa', activity_selection_rationale='مرور نهایی باید تعامل، نوشتن و شنیدن را کنار هم جمع کند؛ هر سه فعالیت خلأ متفاوتی را می‌بندند و هیچ‌کدام برای رسیدن به تعداد اضافه نشده‌اند.', sequence_rationale='اول بازیابی گفتاری، سپس فرم متنی شخصی و در پایان یک تشخیص شنیداری قیمت انجام می‌شود.', template_signature='conversation_speaking>review>listen_choose', audio_status='pending' WHERE lesson_key='de-pre-a1-lesson-personal-review';
UPDATE activities SET instruction_fa='در یک آشنایی مؤدبانه، نام، محل زندگی و سن را دوباره مرور کن.', selection_reason='این مکالمه بازیابی چند هدف اصلی را بدون معرفی زبان تازه انجام می‌دهد.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-review-conversation';
UPDATE activities SET instruction_fa='فرم متنی خیلی کوتاه را با اطلاعات خودت کامل کن.', selection_reason='CEFR در Pre-A1 نوشتن/تکمیل اطلاعات شخصی بسیار پایه را پوشش می‌دهد؛ این فرم بدون تصویر و فقط با الگوهای منبع‌دار همان توانایی را تمرین می‌کند.', audio_status='not_required', audio_text_target=NULL WHERE activity_key='act-de-personal-form';
UPDATE activities SET instruction_fa='قیمت را گوش کن و عدد درست را انتخاب کن.', selection_reason='توصیفگر دریافت در Pre-A1 تشخیص عدد و قیمت آشنا را پوشش می‌دهد؛ یک نمونهٔ منبع‌دار برای این خلأ کافی است.', audio_status='pending', audio_text_target='Die Zeitschrift kostet 7,60 Euro.' WHERE activity_key='act-de-price-listen';
UPDATE dialogues SET scenario='میا و زبان‌آموز سلام می‌کنند؛ بعد از یک کمک کوچک میا تشکر می‌کند و زبان‌آموز پاسخ مؤدبانه می‌دهد.', opening_initiator='app', scene_quality_rationale='تشکر و پاسخ مؤدبانه در چهار نوبت کوتاه و بدون وابستگی به تصویر یا جملهٔ ساختگی تمرین می‌شوند.' WHERE dialogue_key='dlg-de-pre-a1-danke-bitte';
UPDATE dialogues SET scenario='زبان‌آموز برای یک اشتباه کوچک عذرخواهی می‌کند، میا پاسخ آرام می‌دهد و تعامل با تشکر و پاسخ مؤدبانه تمام می‌شود.', opening_initiator='learner', scene_quality_rationale='چهار نوبت یک تبادل اجتماعی کامل و کم‌فشار می‌سازند و هر چهار عبارت از منابع مدرن قابل‌ردیابی آمده‌اند.' WHERE dialogue_key='dlg-de-pre-a1-entschuldigung';
UPDATE dialogues SET scenario='میا و زبان‌آموز سلام می‌کنند و میا یک احوال‌پرسی خیلی کوتاه می‌پرسد که زبان‌آموز با یک پاسخ ساده جواب می‌دهد.', opening_initiator='app', scene_quality_rationale='فقط چهار نوبت لازم برای سلام و یک احوال‌پرسی پایه نگه داشته شده و هیچ عبارت اضافی برای طولانی‌کردن صحنه وارد نشده است.' WHERE dialogue_key='dlg-de-pre-a1-wellbeing';
UPDATE dialogues SET scenario='آیریس و زبان‌آموز در یک آشنایی مؤدبانه دربارهٔ محل زندگی و مبدأ سؤال و جواب می‌کنند.', opening_initiator='app', scene_quality_rationale='این چهار نوبت دو تبادل بسیار کوتاه و منبع‌دار دربارهٔ محل زندگی و مبدأ را کامل می‌کنند و درس دهم را مطابق قانون شروع دوره سبک نگه می‌دارند.' WHERE dialogue_key='dlg-de-pre-a1-residence-origin';
UPDATE dialogues SET scenario='میا و زبان‌آموز با یک سلام ساده شروع می‌کنند و با یک خداحافظی کوتاه مکالمه را تمام می‌کنند.', opening_initiator='app', scene_quality_rationale='برای شروع دوره، مکالمه عمداً روی چهار نوبت نگه داشته شده و فقط سلام و خداحافظی بسیار ساده را تمرین می‌کند.' WHERE dialogue_key='dlg-de-pre-a1-hallo';
UPDATE dialogues SET scenario='این بار زبان‌آموز خودش سلام می‌کند و سؤال آشنای پیتزا را می‌پرسد؛ میا با یک پاسخ مثبت کوتاه جواب می‌دهد.', opening_initiator='learner', scene_quality_rationale='زبان‌آموز در چهار نوبت کوتاه هم مکالمه را شروع می‌کند و هم سؤال آشنا را فعالانه می‌پرسد؛ ادامهٔ غیرضروری حذف شده است.' WHERE dialogue_key='dlg-de-pre-a1-ja';
UPDATE dialogues SET scenario='میا و زبان‌آموز سن هم را می‌پرسند و با عددهای ساده جواب می‌دهند.', opening_initiator='app', scene_quality_rationale='چهار نوبت برای رفت‌وبرگشت سن کافی است؛ فعالیت شنیداری بعدی عدد را جداگانه بازیابی می‌کند.' WHERE dialogue_key='dlg-de-pre-a1-age-numbers';
UPDATE dialogues SET scenario='میا و زبان‌آموز سلام می‌کنند؛ میا با یک پرسش بسیار کوتاه می‌پرسد زبان‌آموز چه می‌خواهد و زبان‌آموز یک گزینهٔ کاملاً آشنا را انتخاب می‌کند.', opening_initiator='app', scene_quality_rationale='درس نهم هنوز در بازهٔ ده درس اول است؛ مکالمه دقیقاً چهار نوبت دارد و فقط یک پرسش تازه را با یک پاسخ واژگانی از قبل آشنا ترکیب می‌کند.' WHERE dialogue_key='dlg-de-pre-a1-simple-choice';
UPDATE dialogues SET scenario='میا و زبان‌آموز دربارهٔ روز و ساعت فعلی سؤال و جواب می‌کنند.', opening_initiator='learner', scene_quality_rationale='زبان‌آموز هر دو سؤال را فعالانه می‌پرسد و چهار نوبت روز و ساعت را بدون حاشیه پوشش می‌دهند.' WHERE dialogue_key='dlg-de-pre-a1-day-time';
UPDATE dialogues SET scenario='میا و زبان‌آموز سلام می‌کنند و بعد یک پرسش و پاسخ کوتاه دربارهٔ دوست‌داشتن پیتزا دارند.', opening_initiator='app', scene_quality_rationale='پرسش و پاسخ اصلی دربارهٔ پیتزا در چهار نوبت کامل می‌شود و برای درس‌های ابتدایی هیچ ادامهٔ غیرضروری به مکالمه اضافه نشده است.' WHERE dialogue_key='dlg-de-pre-a1-pizza-like';
UPDATE dialogues SET scenario='صبح است و این بار زبان‌آموز گفت‌وگو را با سلام صبحگاهی شروع می‌کند و مکالمه با یک خداحافظی کوتاه تمام می‌شود.', opening_initiator='learner', scene_quality_rationale='زبان‌آموز نقش آغازکننده را می‌گیرد و مکالمه برای شروع دوره عمداً در چهار نوبت و با دو عبارت بسیار ساده نگه داشته شده است.' WHERE dialogue_key='dlg-de-pre-a1-guten-morgen';
UPDATE dialogues SET scenario='آیریس سلام می‌کند و زبان‌آموز پس از پاسخ، نام او را می‌پرسد و یک پاسخ ساده با «heißen» می‌شنود.', opening_initiator='app', scene_quality_rationale='مکالمه فقط یک سلام و یک پرسش‌وپاسخ نام دارد؛ برای شروع از صفر کوتاه است و فرم‌های «heißt / heiße» مستقیماً به مدخل واژگانی پایه متصل‌اند.' WHERE dialogue_key='dlg-de-pre-a1-name-exchange';
UPDATE dialogues SET scenario='میا و زبان‌آموز تاریخ تولد را می‌پرسند و با دو تاریخ منبع‌دار پاسخ می‌دهند.', opening_initiator='app', scene_quality_rationale='چهار نوبت دو شکل رایج پاسخ به تاریخ تولد را نشان می‌دهد و برای Pre-A1 کافی است.' WHERE dialogue_key='dlg-de-pre-a1-birthday-date';
UPDATE dialogues SET scenario='یک آشنایی مؤدبانهٔ کوتاه چند بخش اصلی اطلاعات شخصی را در هشت نوبت مرور می‌کند.', opening_initiator='app', scene_quality_rationale='هشت نوبت فقط مطالب اصلی قبلی را در یک تعامل واحد بازیابی می‌کند؛ هیچ زبان تازه‌ای برای طولانی‌کردن صحنه اضافه نشده است.' WHERE dialogue_key='dlg-de-pre-a1-personal-review';
UPDATE dialogues SET scenario='در یک موقعیت متنی، میا و زبان‌آموز دربارهٔ دو شیء نام‌برده‌شده سؤال بسیار ساده می‌پرسند؛ حل فعالیت به تصویر وابسته نیست.', opening_initiator='learner', scene_quality_rationale='سؤال اطلاعاتی بسیار ساده و پاسخ کوتاه از متن منبع گرفته شده‌اند؛ بافت فارسی شیء را مشخص می‌کند تا هیچ تصویر آموزشی لازم نباشد.' WHERE dialogue_key='dlg-de-pre-a1-basic-object';
UPDATE dialogues SET scenario='میا و زبان‌آموز شماره تلفن را از هم می‌پرسند و دو شمارهٔ منبع‌دار می‌گویند.', opening_initiator='app', scene_quality_rationale='چهار نوبت برای تمرین پرسیدن و شنیدن/گفتن شماره کافی است و عددها نقش اطلاعات واقعی را دارند.' WHERE dialogue_key='dlg-de-pre-a1-phone-number';
UPDATE characters SET roles=CAST('["conversation_partner"]' AS JSON), relationship_tags=CAST('[]' AS JSON), context_notes='شخصیت گفت‌وگویی برای تمرین نام‌پرسیدن؛ دربارهٔ جنسیت یا ویژگی‌های دیگری که منبع مشخص نکرده چیزی فرض نشده است.', voice_profile=CAST('{"clarity":"high","stressLevel":"very_low","aggressiveness":"none","toneConsistency":"high","ageImpression":"young_adult","genderImpression":"neutral","elevenLabsVoiceId":null,"voiceName":null}' AS JSON) WHERE character_key='char-de-iris';
UPDATE characters SET roles=CAST('["conversation_partner"]' AS JSON), relationship_tags=CAST('[]' AS JSON), context_notes='شخصیت گفت‌وگویی دوستانه و تکرارشونده؛ جمله‌های منبع فعلی با این هویت اختصاص‌داده‌شده تعارض ندارند.', voice_profile=CAST('{"clarity":"high","stressLevel":"very_low","aggressiveness":"none","toneConsistency":"high","ageImpression":"young_adult","genderImpression":"female","elevenLabsVoiceId":null,"voiceName":null}' AS JSON) WHERE character_key='char-de-mia';
UPDATE characters SET roles=CAST('["learner"]' AS JSON), relationship_tags=CAST('[]' AS JSON), context_notes='نقش عمومی زبان‌آموز؛ برای صحنه‌های فعلی هیچ فرض جمعیت‌شناختی لازم نیست.', voice_profile=CAST('{"clarity":"high","stressLevel":"very_low","aggressiveness":"none","toneConsistency":"high","ageImpression":null,"genderImpression":"neutral","elevenLabsVoiceId":null,"voiceName":null}' AS JSON) WHERE character_key='char-de-learner';
UPDATE lexeme_forms SET features=CAST('{"mood":"subjunctive_II","person":"2","number":"singular"}' AS JSON), notes='در پرسش منبع‌دار «Was möchtest du?» به‌صورت دوم‌شخص مفرد به مدخل واژگانی پایهٔ «mögen» متصل است.' WHERE lexeme_form_key='lexform-de-moegen-moechtest';
UPDATE lexeme_forms SET features=CAST('{"tense":"present","mood":"indicative","person":["1","3"],"number":"singular"}' AS JSON), notes='در جملهٔ منبع‌دار «Ich mag Pizza.» به‌صورت اول‌شخص مفرد استفاده شده است.' WHERE lexeme_form_key='lexform-de-moegen-mag';
UPDATE lexeme_forms SET features=CAST('{"tense":"present","mood":"indicative","person":"1","number":"singular"}' AS JSON), notes='در جملهٔ منبع‌دار «Ich heiße Iris.» به‌صورت اول‌شخص مفرد استفاده شده است.' WHERE lexeme_form_key='lexform-de-heissen-heisse';
UPDATE lexeme_forms SET features=CAST('{"tense":"present","mood":"indicative","person":"2","number":"singular"}' AS JSON), notes='در پرسش منبع‌دار «Magst du Pizza?» به‌صورت دوم‌شخص مفرد استفاده شده است.' WHERE lexeme_form_key='lexform-de-moegen-magst';
UPDATE lexeme_forms SET features=CAST('{"tense":"present","mood":"indicative","person":"2","number":"singular"}' AS JSON), notes='در پرسش منبع‌دار «Wie heißt du?» به‌صورت دوم‌شخص مفرد استفاده شده است.' WHERE lexeme_form_key='lexform-de-heissen-heisst';
UPDATE lessons SET status='final' WHERE language_level_id=@level;
UPDATE language_levels SET status='final' WHERE id=@level;
COMMIT;
-- END GENERATED PERSIAN LOCALIZATION SYNC

-- BEGIN PRE-A1 ACTIVITY COUNT GUARDRAIL SYNC
-- Keep canonical MySQL content synchronized with the finalized authoring lessons.
START TRANSACTION;

SET @g_l_hallo=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-hallo' LIMIT 1);
SET @g_l_danke=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-danke-bitte' LIMIT 1);
SET @g_l_residence=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-residence-origin' LIMIT 1);
SET @g_l_object=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-basic-object' LIMIT 1);
SET @g_l_choice=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-choice' LIMIT 1);

-- Reopen only the lessons whose activity sequences are being revised.
UPDATE lessons SET status='qa'
WHERE id IN (@g_l_hallo,@g_l_danke,@g_l_residence,@g_l_object,@g_l_choice);

UPDATE lessons SET
 activity_selection_rationale='گفت‌وگوی کوتاه سلام و خداحافظی را در بافت می‌آورد و یک تشخیص متنیِ سبک کمک می‌کند زبان‌آموز نقش «Tschüss!» را جدا از «Hallo!» بازیابی کند.',
 sequence_rationale='اول دو عبارت در تعامل استفاده می‌شوند و سپس زبان‌آموز عبارت مناسب برای پایان گفت‌وگو را تشخیص می‌دهد.',
 template_signature='conversation_speaking>multiple_choice'
WHERE id=@g_l_hallo;

UPDATE lessons SET
 activity_selection_rationale='گفت‌وگوی کوتاه تشکر و پاسخ مؤدبانه را در بافت قرار می‌دهد و یک انتخاب پاسخ، رابطهٔ مستقیم «Danke!» و «Bitte!» را بدون افزودن زبان تازه تثبیت می‌کند.',
 sequence_rationale='ابتدا زبان‌آموز پاسخ مؤدبانه را در مکالمه می‌گوید و سپس همان پاسخ را در یک موقعیت روشن بازیابی می‌کند.',
 template_signature='conversation_speaking>choose_response'
WHERE id=@g_l_danke;

UPDATE lessons SET
 activity_selection_rationale='مکالمه محل زندگی و مبدأ را در یک آشنایی کوتاه تمرین می‌کند و تطبیق دو جفت پرسش‌وپاسخِ دقیق منبع کمک می‌کند این دو مفهوم نزدیک با هم قاطی نشوند.',
 sequence_rationale='ابتدا زبان‌آموز محل زندگی و مبدأ را در گفت‌وگو استفاده می‌کند و سپس هر پرسش را به پاسخ منبع‌دار مناسب وصل می‌کند.',
 template_signature='conversation_speaking>matching'
WHERE id=@g_l_residence;

UPDATE lessons SET
 activity_selection_rationale='مکالمه پرسش و پاسخ را در بافت متنی تمرین می‌کند و بازسازی یکی از پاسخ‌های دقیق منبع، الگوی «Das ist ...» را بدون تصویر و بدون ساخت جملهٔ تازه بازیابی می‌کند.',
 sequence_rationale='اول زبان‌آموز سؤال و پاسخ را در تعامل می‌بیند و سپس یک پاسخ منبع‌دار را با مرتب‌کردن واژه‌ها بازسازی می‌کند.',
 template_signature='conversation_speaking>word_order'
WHERE id=@g_l_object;

UPDATE lessons SET
 activity_selection_rationale='گفت‌وگو معنی «Was möchtest du?» را در یک انتخاب ساده روشن می‌کند و بازسازی همان پرسش دقیق منبع، فرم «möchtest» را بدون افزودن واژه یا ساختار تازه بازیابی می‌کند.',
 sequence_rationale='ابتدا زبان‌آموز پرسش را در بافت می‌فهمد و پاسخ آشنا می‌دهد؛ سپس خود پرسش منبع‌دار را با مرتب‌کردن واژه‌ها بازسازی می‌کند.',
 template_signature='conversation_speaking>word_order'
WHERE id=@g_l_choice;

UPDATE activities SET
 selection_reason='تعامل چهار نوبت دو عبارت پایه را در یک موقعیت ساده و کم‌فشار قرار می‌دهد.'
WHERE activity_key='act-de-hallo-conversation';

INSERT INTO activities
(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-hallo-farewell-choice',@g_l_hallo,2,'multiple_choice',
 'برای خداحافظی کدام عبارت مناسب است؟',
 'این تشخیص کوتاه تفاوت نقش سلام و خداحافظی را با همان دو عبارت منبع‌دار تثبیت می‌کند.',NULL,
 JSON_OBJECT('promptFa','می‌خواهی گفت‌وگو را تمام کنی.','options',JSON_ARRAY(
  JSON_OBJECT('textTarget','Tschüss!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wikibooks-de-basic-greetings')),
  JSON_OBJECT('textTarget','Hallo!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-hallo')))),
 JSON_ARRAY('options_selected_from_source_material'),NULL,'not_required'),
('act-de-danke-bitte-response',@g_l_danke,2,'choose_response',
 'در پاسخ به «Danke!» کدام عبارت مناسب است؟',
 'این تمرین پاسخ مؤدبانه را با دو عبارت آشنای منبع‌دار بازیابی می‌کند و نقش «Bitte!» را روشن نگه می‌دارد.',NULL,
 JSON_OBJECT('promptTarget','Danke!','options',JSON_ARRAY(
  JSON_OBJECT('textTarget','Bitte!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-bitte')),
  JSON_OBJECT('textTarget','Hallo!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-hallo')))),
 JSON_ARRAY('options_selected_from_source_material'),NULL,'not_required'),
('act-de-residence-matching',@g_l_residence,2,'matching',
 'هر پرسش را به پاسخ مناسبش وصل کن.',
 'این تطبیق تفاوت «محل زندگی» و «مبدأ» را با چهار عبارت دقیق منبع و بدون افزودن جملهٔ تازه تمرین می‌کند.',NULL,
 JSON_OBJECT('pairs',JSON_ARRAY(
  JSON_OBJECT('left','Wo wohnen Sie?','right','Ich wohne in Österreich.','sourceRefs',JSON_ARRAY('src-wikibooks-de-residence-origin')),
  JSON_OBJECT('left','Woher kommen Sie?','right','Ich komme aus Deutschland, und Sie?','sourceRefs',JSON_ARRAY('src-wikibooks-de-residence-origin')))),
 JSON_ARRAY('source_items_grouped_for_matching'),NULL,'not_required'),
('act-de-object-word-order',@g_l_object,2,'word_order',
 'پاسخ منبع‌دار را دوباره بساز.',
 'بازسازی «Das ist ein Buch.» همان الگوی پاسخ درس را بدون تصویر و بدون افزودن زبان تازه تثبیت می‌کند.',NULL,
 JSON_OBJECT('sourceText','Das ist ein Buch.','tokens',JSON_ARRAY('Das','ist','ein','Buch.'),'answer',JSON_ARRAY('Das','ist','ein','Buch.')),
 JSON_ARRAY('sentence_tokenized_for_word_order'),NULL,'not_required'),
('act-de-simple-choice-word-order',@g_l_choice,2,'word_order',
 'پرسش منبع‌دار را دوباره بساز.',
 'بازسازی «Was möchtest du?» فرم تازهٔ «möchtest» را در همان پرسش آشنا تثبیت می‌کند و زبان تازه‌ای وارد نمی‌کند.',NULL,
 JSON_OBJECT('sourceText','Was möchtest du?','tokens',JSON_ARRAY('Was','möchtest','du?'),'answer',JSON_ARRAY('Was','möchtest','du?'),'tokenLexemeMappings',JSON_ARRAY(
  JSON_OBJECT('token','möchtest','lexemeId','lex-de-moegen','lexemeFormId','lexform-de-moegen-moechtest'))),
 JSON_ARRAY('sentence_tokenized_for_word_order'),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);

SET @g_a_hallo=(SELECT id FROM activities WHERE activity_key='act-de-hallo-farewell-choice');
SET @g_a_danke=(SELECT id FROM activities WHERE activity_key='act-de-danke-bitte-response');
SET @g_a_res=(SELECT id FROM activities WHERE activity_key='act-de-residence-matching');
SET @g_a_obj=(SELECT id FROM activities WHERE activity_key='act-de-object-word-order');
SET @g_a_choice=(SELECT id FROM activities WHERE activity_key='act-de-simple-choice-word-order');

SET @g_x_hallo=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-hallo');
SET @g_x_tschuess=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-tschuess');
SET @g_x_danke=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-danke');
SET @g_x_bitte=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-bitte');
SET @g_x_wohnen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-wohnen');
SET @g_x_oesterreich=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-oesterreich');
SET @g_x_kommen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-kommen');
SET @g_x_deutschland=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-deutschland');
SET @g_x_buch=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-buch');
SET @g_x_moegen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-moegen');
SET @g_f_moechtest=(SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-moechtest');

INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES
(@g_a_hallo,@g_x_hallo),(@g_a_hallo,@g_x_tschuess),
(@g_a_danke,@g_x_hallo),(@g_a_danke,@g_x_danke),(@g_a_danke,@g_x_bitte),
(@g_a_res,@g_x_wohnen),(@g_a_res,@g_x_oesterreich),(@g_a_res,@g_x_kommen),(@g_a_res,@g_x_deutschland),
(@g_a_obj,@g_x_buch),(@g_a_choice,@g_x_moegen);

INSERT INTO lexeme_occurrences
(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-act-de-hallo-farewell-tschuess','activity','act-de-hallo-farewell-choice','Tschüss!',NULL,NULL,@g_x_tschuess,NULL,'approved','گزینهٔ خداحافظی به واژه/عبارت منبع‌دار متصل است.'),
('occ-act-de-hallo-farewell-hallo','activity','act-de-hallo-farewell-choice','Hallo!',NULL,NULL,@g_x_hallo,NULL,'approved','گزینهٔ سلام به واژه/عبارت منبع‌دار متصل است.'),
('occ-act-de-danke-response-danke','activity','act-de-danke-bitte-response','Danke!',NULL,NULL,@g_x_danke,NULL,'approved','پرسش تمرین به عبارت تشکر منبع‌دار متصل است.'),
('occ-act-de-danke-response-bitte','activity','act-de-danke-bitte-response','Bitte!',NULL,NULL,@g_x_bitte,NULL,'approved','گزینهٔ پاسخ مؤدبانه به عبارت منبع‌دار متصل است.'),
('occ-act-de-danke-response-hallo','activity','act-de-danke-bitte-response','Hallo!',NULL,NULL,@g_x_hallo,NULL,'approved','گزینهٔ مقایسه‌ای به عبارت سلام منبع‌دار متصل است.'),
('occ-act-de-residence-match-wohnen','activity','act-de-residence-matching','wohnen',NULL,NULL,@g_x_wohnen,NULL,'approved','فعل محل زندگی به lexeme تأییدشده متصل است.'),
('occ-act-de-residence-match-oesterreich','activity','act-de-residence-matching','Österreich',NULL,NULL,@g_x_oesterreich,NULL,'approved','نام کشور به lexeme تأییدشده متصل است.'),
('occ-act-de-residence-match-kommen','activity','act-de-residence-matching','kommen',NULL,NULL,@g_x_kommen,NULL,'approved','فعل مبدأ به lexeme تأییدشده متصل است.'),
('occ-act-de-residence-match-deutschland','activity','act-de-residence-matching','Deutschland',NULL,NULL,@g_x_deutschland,NULL,'approved','نام کشور به lexeme تأییدشده متصل است.'),
('occ-act-de-object-order-buch','activity','act-de-object-word-order','Buch.',NULL,NULL,@g_x_buch,NULL,'approved','توکن با نشانه‌گذاری به «Buch» متصل است.'),
('occ-act-de-simple-choice-order-moechtest','activity','act-de-simple-choice-word-order','möchtest',NULL,NULL,@g_x_moegen,@g_f_moechtest,'approved','توکن صرف‌شده به «mögen» و فرم تأییدشدهٔ «möchtest» متصل است.')
ON DUPLICATE KEY UPDATE surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

SET @g_si_hallo=(SELECT id FROM source_items WHERE item_key='srcitem-de-hallo-headword' LIMIT 1);
SET @g_si_tschuess=(SELECT id FROM source_items WHERE item_key='srcitem-de-tschuess' LIMIT 1);
SET @g_si_danke=(SELECT id FROM source_items WHERE item_key='srcitem-de-danke-headword' LIMIT 1);
SET @g_si_bitte=(SELECT id FROM source_items WHERE item_key='srcitem-de-bitte-response' LIMIT 1);
SET @g_si_res_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-wo-wohnen-sie' LIMIT 1);
SET @g_si_res_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-wohne-oesterreich' LIMIT 1);
SET @g_si_origin_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-woher-kommen-sie' LIMIT 1);
SET @g_si_origin_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-komme-deutschland' LIMIT 1);
SET @g_si_object=(SELECT id FROM source_items WHERE item_key='srcitem-de-das-buch' LIMIT 1);
SET @g_si_choice=(SELECT id FROM source_items WHERE item_key='srcitem-de-was-moechtest-du' LIMIT 1);
SET @g_si_moechtest=(SELECT id FROM source_items WHERE item_key='srcitem-de-moegen-moechtest' LIMIT 1);

INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('activity','act-de-hallo-farewell-choice',@g_si_tschuess,'options_selected_from_source_material','گزینهٔ درست مستقیماً از منبع خداحافظی آمده است.'),
('activity','act-de-hallo-farewell-choice',@g_si_hallo,'options_selected_from_source_material','گزینهٔ مقایسه‌ای مستقیماً از منبع سلام آمده است.'),
('activity','act-de-danke-bitte-response',@g_si_danke,'options_selected_from_source_material','عبارت محرک از منبع تشکر آمده است.'),
('activity','act-de-danke-bitte-response',@g_si_bitte,'options_selected_from_source_material','پاسخ درست از منبع کاربرد «Bitte!» آمده است.'),
('activity','act-de-danke-bitte-response',@g_si_hallo,'options_selected_from_source_material','گزینهٔ مقایسه‌ای از منبع سلام آمده است.'),
('activity','act-de-residence-matching',@g_si_res_q,'source_items_grouped_for_matching','پرسش محل زندگی از منبع آمده است.'),
('activity','act-de-residence-matching',@g_si_res_a,'source_items_grouped_for_matching','پاسخ محل زندگی از منبع آمده است.'),
('activity','act-de-residence-matching',@g_si_origin_q,'source_items_grouped_for_matching','پرسش مبدأ از منبع آمده است.'),
('activity','act-de-residence-matching',@g_si_origin_a,'source_items_grouped_for_matching','پاسخ مبدأ از منبع آمده است.'),
('activity','act-de-object-word-order',@g_si_object,'sentence_tokenized_for_word_order','جملهٔ منبع‌دار فقط برای مرتب‌سازی توکن‌بندی شده است.'),
('activity','act-de-simple-choice-word-order',@g_si_choice,'sentence_tokenized_for_word_order','پرسش منبع‌دار فقط برای مرتب‌سازی توکن‌بندی شده است.'),
('activity','act-de-simple-choice-word-order',@g_si_moechtest,'other','فرم «möchtest» به شاهد واژگانی منبع‌دار متصل است.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);


-- Restore finalized status after the activity revision is complete.
UPDATE lessons SET status='final'
WHERE id IN (@g_l_hallo,@g_l_danke,@g_l_residence,@g_l_object,@g_l_choice);

COMMIT;
-- END PRE-A1 ACTIVITY COUNT GUARDRAIL SYNC

-- ===== END pre-a1.sql =====

-- ===== BEGIN zz-pre-a1-character-cast.sql =====
-- German Pre-A1 canonical character cast overlay.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
INSERT INTO characters
(character_key,language_id,name,origin,gender,age_band,roles,relationship_tags,context_notes,voice_profile,elevenlabs_voice_id,voice_name) VALUES
('char-de-mia',@de,'Mia','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('classmate','friend'),'میا ۲۰ ساله است. تاریخ تولد او سیزدهم نوامبر و شمارهٔ تمرینی او 692-267-752 است.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','female'),NULL,NULL),
('char-de-max',@de,'Max','app_created','male','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('classmate'),'مکس ۱۸ ساله است. تاریخ تولد او ۱۶ ژوئیه و شمارهٔ تمرینی او 789 است. زبان‌آموز در چند صحنه نقش مکس را بازی می‌کند.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','male'),NULL,NULL),
('char-de-lena',@de,'Lena','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('friend','neighbor'),'لنا جوان، دوستانه و آرام است. زبان‌آموز در برخی صحنه‌های روزمره نقش لنا را بازی می‌کند.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','female'),NULL,NULL),
('char-de-jonas',@de,'Jonas','app_created','male','young_adult',JSON_ARRAY('conversation_partner','cafe_staff'),JSON_ARRAY('neighbor'),'یوناس جوان و خوش‌برخورد است و در یکی از موقعیت‌های انتخاب غذا نقش کارمند کافه را دارد.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','male'),NULL,NULL),
('char-de-iris',@de,'Iris','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('acquaintance'),'آیریس یک زن جوان است و در صحنه‌های آشنایی مؤدبانه حضور دارد. در محتوای فعلی می‌گوید اهل آلمان است.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','female'),NULL,NULL),
('char-de-paul',@de,'Paul Müller','app_created','male','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('acquaintance'),'پاول مولر ۲۰ ساله است و در محتوای فعلی در اتریش زندگی می‌کند. زبان‌آموز در مرور اطلاعات شخصی نقش پاول را بازی می‌کند.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','male'),NULL,NULL)
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),name=VALUES(name),origin=VALUES(origin),gender=VALUES(gender),age_band=VALUES(age_band),roles=VALUES(roles),relationship_tags=VALUES(relationship_tags),context_notes=VALUES(context_notes),voice_profile=VALUES(voice_profile);
SET @mia:=(SELECT id FROM characters WHERE character_key='char-de-mia' LIMIT 1);
SET @max:=(SELECT id FROM characters WHERE character_key='char-de-max' LIMIT 1);
SET @lena:=(SELECT id FROM characters WHERE character_key='char-de-lena' LIMIT 1);
SET @jonas:=(SELECT id FROM characters WHERE character_key='char-de-jonas' LIMIT 1);
SET @iris:=(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul:=(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);
UPDATE dialogue_turns SET speaker_character_id=@iris WHERE turn_key IN ('turn-de-name-1','turn-de-name-4','turn-de-residence-1','turn-de-residence-4','turn-de-review-1','turn-de-review-3','turn-de-review-5','turn-de-review-7');
UPDATE dialogue_turns SET speaker_character_id=@jonas WHERE turn_key IN ('turn-de-choice-1','turn-de-choice-3','turn-de-danke-bitte-1','turn-de-danke-bitte-3','turn-de-gm-2','turn-de-gm-3','turn-de-name-2','turn-de-name-3','turn-de-time-1','turn-de-time-3');
UPDATE dialogue_turns SET speaker_character_id=@lena WHERE turn_key IN ('turn-de-danke-bitte-2','turn-de-danke-bitte-4','turn-de-gm-1','turn-de-gm-4','turn-de-object-1','turn-de-object-4','turn-de-wellbeing-2','turn-de-wellbeing-4');
UPDATE dialogue_turns SET speaker_character_id=@max WHERE turn_key IN ('turn-de-age-2','turn-de-age-3','turn-de-birthday-2','turn-de-birthday-3','turn-de-choice-2','turn-de-choice-4','turn-de-entschuldigung-1','turn-de-entschuldigung-3','turn-de-hallo-2','turn-de-hallo-4','turn-de-ja-1','turn-de-ja-3','turn-de-phone-2','turn-de-phone-3','turn-de-pizza-2','turn-de-pizza-4');
UPDATE dialogue_turns SET speaker_character_id=@mia WHERE turn_key IN ('turn-de-age-1','turn-de-age-4','turn-de-birthday-1','turn-de-birthday-4','turn-de-entschuldigung-2','turn-de-entschuldigung-4','turn-de-hallo-1','turn-de-hallo-3','turn-de-ja-2','turn-de-ja-4','turn-de-object-2','turn-de-object-3','turn-de-phone-1','turn-de-phone-4','turn-de-pizza-1','turn-de-pizza-3','turn-de-time-2','turn-de-time-4','turn-de-wellbeing-1','turn-de-wellbeing-3');
UPDATE dialogue_turns SET speaker_character_id=@paul WHERE turn_key IN ('turn-de-residence-2','turn-de-residence-3','turn-de-review-2','turn-de-review-4','turn-de-review-6','turn-de-review-8');
UPDATE dialogues SET scenario='میا و مکس با یک سلام ساده شروع می‌کنند و با یک خداحافظی کوتاه مکالمه را تمام می‌کنند.' WHERE dialogue_key='dlg-de-pre-a1-hallo';
UPDATE dialogues SET scenario='صبح است؛ لنا گفت‌وگو را با همسایه‌اش یوناس با یک سلام صبحگاهی شروع می‌کند و مکالمه با خداحافظی کوتاه تمام می‌شود.' WHERE dialogue_key='dlg-de-pre-a1-guten-morgen';
UPDATE dialogues SET scenario='میا و مکس سلام می‌کنند و بعد یک پرسش و پاسخ کوتاه دربارهٔ دوست‌داشتن پیتزا دارند.' WHERE dialogue_key='dlg-de-pre-a1-pizza-like';
UPDATE dialogues SET scenario='این بار مکس خودش سلام می‌کند و سؤال آشنای پیتزا را می‌پرسد؛ میا با یک پاسخ مثبت کوتاه جواب می‌دهد.' WHERE dialogue_key='dlg-de-pre-a1-ja';
UPDATE dialogues SET scenario='یوناس و لنا سلام می‌کنند؛ بعد از یک کمک کوچک یوناس تشکر می‌کند و لنا پاسخ مؤدبانه می‌دهد.' WHERE dialogue_key='dlg-de-pre-a1-danke-bitte';
UPDATE dialogues SET scenario='مکس برای یک اشتباه کوچک عذرخواهی می‌کند، میا پاسخ آرام می‌دهد و تعامل با تشکر و پاسخ مؤدبانه تمام می‌شود.' WHERE dialogue_key='dlg-de-pre-a1-entschuldigung';
UPDATE dialogues SET scenario='آیریس سلام می‌کند و یوناس پس از پاسخ، نام او را می‌پرسد و پاسخ سادهٔ «Ich heiße Iris.» را می‌شنود.' WHERE dialogue_key='dlg-de-pre-a1-name-exchange';
UPDATE dialogues SET scenario='میا و لنا سلام می‌کنند و میا یک احوال‌پرسی خیلی کوتاه می‌پرسد که لنا با یک پاسخ ساده جواب می‌دهد.' WHERE dialogue_key='dlg-de-pre-a1-wellbeing';
UPDATE dialogues SET scenario='مکس در یک کافه با یوناس سلام می‌کند؛ یوناس می‌پرسد چه می‌خواهد و مکس گزینهٔ آشنای «Pizza.» را انتخاب می‌کند.' WHERE dialogue_key='dlg-de-pre-a1-simple-choice';
UPDATE dialogues SET scenario='آیریس و پاول در یک آشنایی مؤدبانه دربارهٔ محل زندگی و مبدأ سؤال و جواب می‌کنند.' WHERE dialogue_key='dlg-de-pre-a1-residence-origin';
UPDATE dialogues SET scenario='میا و مکس سن هم را می‌پرسند؛ مکس ۱۸ ساله و میا ۲۰ ساله است.' WHERE dialogue_key='dlg-de-pre-a1-age-numbers';
UPDATE dialogues SET scenario='میا و مکس تاریخ تولد را از هم می‌پرسند؛ تاریخ‌های این صحنه به اطلاعات ثابت همین دو شخصیت تبدیل شده‌اند.' WHERE dialogue_key='dlg-de-pre-a1-birthday-date';
UPDATE dialogues SET scenario='میا و مکس شمارهٔ تلفن تمرینی را از هم می‌پرسند و دو شمارهٔ منبع‌دار می‌گویند.' WHERE dialogue_key='dlg-de-pre-a1-phone-number';
UPDATE dialogues SET scenario='یوناس دربارهٔ روز و ساعت فعلی سؤال می‌کند و میا با اطلاعات ساده پاسخ می‌دهد.' WHERE dialogue_key='dlg-de-pre-a1-day-time';
UPDATE dialogues SET scenario='لنا و میا دربارهٔ دو شیء نام‌برده‌شده سؤال بسیار ساده می‌پرسند؛ حل فعالیت به تصویر وابسته نیست.' WHERE dialogue_key='dlg-de-pre-a1-basic-object';
UPDATE dialogues SET scenario='آیریس در یک آشنایی مؤدبانه با پاول مولر چند بخش اصلی اطلاعات شخصی او را در هشت نوبت مرور می‌کند.' WHERE dialogue_key='dlg-de-pre-a1-personal-review';
DELETE FROM characters WHERE language_id=@de AND character_key='char-de-learner';
COMMIT;

-- ===== END zz-pre-a1-character-cast.sql =====

-- ===== BEGIN zz-pre-a1-persian-payloads.sql =====
-- Persian learner-facing payload translations for German Pre-A1.
-- This file is intentionally sorted after pre-a1.sql and is idempotent.
-- Final lessons are reopened only for the duration of these activity updates,
-- then restored to their exact prior status in the same transaction.

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS _prea1_translation_lesson_status;
CREATE TEMPORARY TABLE _prea1_translation_lesson_status AS
SELECT DISTINCT l.id AS lesson_id, l.status AS original_status
FROM lessons l
JOIN activities a ON a.lesson_id=l.id
WHERE a.activity_key IN (
  'act-de-hallo-farewell-choice',
  'act-de-gm-choice',
  'act-de-pizza-word-order',
  'act-de-ja-nein-choice',
  'act-de-danke-bitte-response',
  'act-de-entschuldigung-matching',
  'act-de-name-word-order',
  'act-de-wellbeing-fill',
  'act-de-simple-choice-word-order',
  'act-de-residence-matching',
  'act-de-age-listen',
  'act-de-time-listen',
  'act-de-time-of-day',
  'act-de-birthday-fill',
  'act-de-phone-listen',
  'act-de-object-word-order',
  'act-de-personal-form',
  'act-de-price-listen'
);

UPDATE lessons l
JOIN _prea1_translation_lesson_status b ON b.lesson_id=l.id
SET l.status='qa'
WHERE b.original_status='final';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.options[0].translationFa','خداحافظ!',
  '$.options[1].translationFa','سلام!')
WHERE activity_key='act-de-hallo-farewell-choice';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.options[0].translationFa','صبح بخیر!',
  '$.options[1].translationFa','سلام!')
WHERE activity_key='act-de-gm-choice';

UPDATE activities
SET payload = JSON_SET(payload,'$.sourceTextFa','من پیتزا دوست دارم.')
WHERE activity_key='act-de-pizza-word-order';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.promptFa','پیتزا دوست داری؟',
  '$.options[0].translationFa','بله!',
  '$.options[1].translationFa','نه!')
WHERE activity_key='act-de-ja-nein-choice';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.promptFa','ممنون!',
  '$.options[0].translationFa','خواهش می‌کنم!',
  '$.options[1].translationFa','سلام!')
WHERE activity_key='act-de-danke-bitte-response';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.pairs[0].leftFa','ببخشید.',
  '$.pairs[0].rightFa','مشکلی نیست.',
  '$.pairs[1].leftFa','ممنون!',
  '$.pairs[1].rightFa','خواهش می‌کنم!')
WHERE activity_key='act-de-entschuldigung-matching';

UPDATE activities
SET payload = JSON_SET(payload,'$.sourceTextFa','اسم من آیریس است.')
WHERE activity_key='act-de-name-word-order';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.sourceTextFa','حالت چطوره؟',
  '$.blankedTextFa','___ چطوره؟',
  '$.choicesFa',JSON_ARRAY('حالت','خوب'))
WHERE activity_key='act-de-wellbeing-fill';

UPDATE activities
SET payload = JSON_SET(payload,'$.sourceTextFa','چی می‌خوای؟')
WHERE activity_key='act-de-simple-choice-word-order';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.pairs[0].leftFa','کجا زندگی می‌کنید؟',
  '$.pairs[0].rightFa','من در اتریش زندگی می‌کنم.',
  '$.pairs[1].leftFa','اهل کجا هستید؟',
  '$.pairs[1].rightFa','من اهل آلمان هستم، شما چطور؟')
WHERE activity_key='act-de-residence-matching';

UPDATE activities
SET payload = JSON_SET(payload,'$.audioTextTargetFa','هجده')
WHERE activity_key='act-de-age-listen';

UPDATE activities
SET payload = JSON_SET(payload,'$.audioTextTargetFa','ساعت ۶:۳۰ است.')
WHERE activity_key='act-de-time-listen';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.options[0].translationFa','صبح است.',
  '$.options[1].translationFa','عصر است.')
WHERE activity_key='act-de-time-of-day';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.sourceTextFa','تولد من سیزدهم نوامبر است.',
  '$.blankedTextFa','تولد من ___ نوامبر است.',
  '$.choicesFa',JSON_ARRAY('سیزدهم'))
WHERE activity_key='act-de-birthday-fill';

UPDATE activities
SET payload = JSON_SET(payload,'$.audioTextTargetFa','شماره تلفن من ۷۸۹ است.')
WHERE activity_key='act-de-phone-listen';

UPDATE activities
SET payload = JSON_SET(payload,'$.sourceTextFa','این یک کتاب است.')
WHERE activity_key='act-de-object-word-order';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.fields[0].patternFa','اسم من ___ است.',
  '$.fields[0].exampleSourceTextFa','اسم من پاول مولر است.',
  '$.fields[1].patternFa','من در ___ زندگی می‌کنم.',
  '$.fields[1].exampleSourceTextFa','من در اتریش زندگی می‌کنم.',
  '$.fields[2].patternFa','من ___ ساله هستم.',
  '$.fields[2].exampleSourceTextFa','من ۲۰ ساله هستم.',
  '$.fields[3].patternFa','شماره تلفن من ___ است.',
  '$.fields[3].exampleSourceTextFa','شماره تلفن من ۷۸۹ است.',
  '$.fields[4].patternFa','تولد من ___ است.',
  '$.fields[4].exampleSourceTextFa','تولد من سیزدهم نوامبر است.',
  '$.fields[5].patternFa','نشانی: ___',
  '$.fields[5].exampleSourceTextFa','نشانی')
WHERE activity_key='act-de-personal-form';

UPDATE activities
SET payload = JSON_SET(payload,'$.audioTextTargetFa','قیمت مجله ۷٫۶۰ یورو است.')
WHERE activity_key='act-de-price-listen';

UPDATE lessons l
JOIN _prea1_translation_lesson_status b ON b.lesson_id=l.id
SET l.status=b.original_status;

DROP TEMPORARY TABLE _prea1_translation_lesson_status;

COMMIT;

-- ===== END zz-pre-a1-persian-payloads.sql =====

-- ===== BEGIN zzy-pre-a1-simple-orders-reopen.sql =====
-- Reopen Unit 3 lessons before the idempotent Unit 3 upsert runs again.
-- On the first import these rows do not exist, so this is intentionally a no-op.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;
UPDATE lessons
SET status='qa'
WHERE lesson_key IN (
  'de-pre-a1-lesson-food-today',
  'de-pre-a1-lesson-simple-order',
  'de-pre-a1-lesson-need-and-buy'
) AND status='final';
COMMIT;

-- ===== END zzy-pre-a1-simple-orders-reopen.sql =====

-- ===== BEGIN zzz-pre-a1-simple-orders.sql =====
-- German Pre-A1 Unit 3: simple food, ordering, needs and shopping.
-- Idempotent extension; generated audio metadata is never overwritten on re-import.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
SET @iris := (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul := (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);

INSERT INTO curriculum_targets(language_level_id,target_key,target_type,title,description,required_for_completion,status,metadata) VALUES
(@level,'de.pre_a1.food_today','communicative','فهم غذای موجود و گفتن یک غذای آشنا','«Was gibt es heute?» و «Was essen Sie?» را در بافت بسیار ساده بفهمد و پاسخ کوتاه بدهد.',TRUE,'covered',JSON_OBJECT('unit3',TRUE)),
(@level,'de.pre_a1.simple_order','communicative','سفارش بسیار کوتاه و مؤدبانه','پرسش سفارش ساده را بفهمد و با عبارت کوتاه «Eine Tasse Kaffee bitte!» پاسخ دهد.',TRUE,'covered',JSON_OBJECT('unit3',TRUE)),
(@level,'de.pre_a1.need_and_buy','communicative','فهم نیاز و خرید بسیار ساده','پرسش‌های ساده با «brauchen» و «kaufen» را بفهمد و پاسخ کوتاه منبع‌دار بدهد.',TRUE,'covered',JSON_OBJECT('unit3',TRUE))
ON DUPLICATE KEY UPDATE target_type=VALUES(target_type),title=VALUES(title),description=VALUES(description),required_for_completion=VALUES(required_for_completion),status=VALUES(status),metadata=VALUES(metadata);
SET @t_food := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.food_today');
SET @t_order := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.simple_order');
SET @t_need := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.need_and_buy');

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wikibooks-de-lesson-002','Deutschkurs für Anfänger/Lektion 002','منبع غذای روز و سفارش خیلی ساده','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_002','Items 040–058','بخش‌های ۰۴۰ تا ۰۵۸؛ غذای موجود، خوردن و سفارش ساده.',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ بررسی شد؛ عبارت‌های غذا، نوشیدنی و سفارش برای کاربرد آموزشی معاصر مناسب‌اند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 002','reuse_with_attribution','2026-09-17','منبع اصلی واحد سوم برای غذای امروز و سفارش خیلی ساده.'),
('src-wikibooks-de-lesson-004','Deutschkurs für Anfänger/Lektion 004','منبع نیاز و خرید خیلی ساده','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_004','Items 131 and 134','بخش‌های ۱۳۱ و ۱۳۴؛ نیاز و خرید بسیار ساده.',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ بررسی شد؛ الگوهای «brauchen» و «kaufen» برای کاربرد آموزشی معاصر معتبرند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 004','reuse_with_attribution','2026-09-17','منبع واحد سوم برای نیاز و خرید خیلی ساده.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
SET @s2 := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002');
SET @s4 := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004');

INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes) VALUES
(@s2,'srcitem-de-u3-was-gibt-heute','046','بخش ۰۴۶','Was gibt es heute?',UNHEX(SHA2('Was gibt es heute?',256)),'پرسش غذای موجود.'),
(@s2,'srcitem-de-u3-heute-suppe','046','بخش ۰۴۶','Heute gibt es Suppe.',UNHEX(SHA2('Heute gibt es Suppe.',256)),'پاسخ غذای موجود.'),
(@s2,'srcitem-de-u3-was-essen','047','بخش ۰۴۷','Was essen Sie?',UNHEX(SHA2('Was essen Sie?',256)),'پرسش دربارهٔ خوردن.'),
(@s2,'srcitem-de-u3-ich-esse-reis','042','بخش ۰۴۲','Ich esse Reis.',UNHEX(SHA2('Ich esse Reis.',256)),'پاسخ دربارهٔ خوردن.'),
(@s2,'srcitem-de-u3-guten-tag','049/058','بخش ۰۴۹/۰۵۸','Guten Tag!',UNHEX(SHA2('Guten Tag!',256)),'سلام مؤدبانه.'),
(@s2,'srcitem-de-u3-order-question','049','بخش ۰۴۹','Was möchten Sie bitte?',UNHEX(SHA2('Was möchten Sie bitte?',256)),'پرسش سفارش.'),
(@s2,'srcitem-de-u3-coffee-please','057','بخش ۰۵۷','Eine Tasse Kaffee bitte!',UNHEX(SHA2('Eine Tasse Kaffee bitte!',256)),'سفارش کوتاه قهوه.'),
(@s4,'srcitem-de-u3-need-question','131','بخش ۱۳۱','Was brauchen Sie?',UNHEX(SHA2('Was brauchen Sie?',256)),'پرسش نیاز.'),
(@s4,'srcitem-de-u3-need-hose','134','بخش ۱۳۴','Ich brauche eine Hose.',UNHEX(SHA2('Ich brauche eine Hose.',256)),'پاسخ نیاز.'),
(@s4,'srcitem-de-u3-buy-question','134','بخش ۱۳۴','Und was kaufen Sie?',UNHEX(SHA2('Und was kaufen Sie?',256)),'پرسش خرید.'),
(@s4,'srcitem-de-u3-buy-answer','134','بخش ۱۳۴','Ich kaufe ein Hemd und ein Paar Schuhe.',UNHEX(SHA2('Ich kaufe ein Hemd und ein Paar Schuhe.',256)),'پاسخ خرید.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-pre-a1-unit-simple-orders',@level,3,'خرید و سفارش خیلی ساده','این سه درس زبان‌آموز را از دیدن و گفتن گزینهٔ موجود، به سفارش مؤدبانه و سپس بیان یک نیاز یا خرید بسیار ساده می‌برند؛ همه در موقعیت‌های روزمرهٔ کم‌فشار و با جمله‌های کوتاه و منبع‌دار باقی می‌مانند.','final',JSON_OBJECT('dynamicStructure',TRUE),'این واحد دامنهٔ کاربرد روزمرهٔ سطح پیش از A1 را گسترش می‌دهد و سهمیهٔ عددی ایجاد نمی‌کند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=VALUES(status),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit3 := (SELECT id FROM units WHERE unit_key='de-pre-a1-unit-simple-orders');
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES(@unit3,@t_food),(@unit3,@t_order),(@unit3,@t_need);

INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-pre-a1-lesson-food-today',@level,@unit3,17,1,'امروز چی داریم؟','Was gibt es heute? / Was essen Sie?','امروز چی داریم؟ / شما چی می‌خورید؟','draft','مکالمه معنی دو پرسش روزمره را در بافت می‌سازد و تمرین تطبیق همان دو جفت را بازیابی می‌کند.','اول پرسش‌ها در گفت‌وگو و سپس همان ارتباط‌ها در تمرین تطبیق تثبیت می‌شوند.','conversation_speaking>matching','pending',NULL),
('de-pre-a1-lesson-simple-order',@level,@unit3,18,2,'یک قهوه، لطفاً','Was möchten Sie bitte? / Eine Tasse Kaffee bitte!','لطفاً چی میل دارید؟ / یک فنجان قهوه لطفاً!','draft','گفت‌وگو سفارش کوتاه را در موقعیت واقعی قرار می‌دهد و مرتب‌سازی واژه‌ها همان عبارت سفارش را بازسازی می‌کند.','اول سفارش در تعامل و سپس همان عبارت با مرتب‌سازی واژه‌ها بازیابی می‌شود.','conversation_speaking>word_order','pending',NULL),
('de-pre-a1-lesson-need-and-buy',@level,@unit3,19,3,'چی لازم داری؟ چی می‌خری؟','Was brauchen Sie? / Und was kaufen Sie?','چه چیزی لازم دارید؟ / و چه چیزی می‌خرید؟','draft','مکالمه دو فعل کاربردی را در دو سؤال معرفی می‌کند و تمرین تطبیق تفاوت نیاز و خرید را تثبیت می‌کند.','ابتدا نیاز و خرید در تعامل دیده می‌شوند و سپس به پاسخ درست وصل می‌شوند.','conversation_speaking>matching','pending',NULL)
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @l17 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-food-today');
SET @l18 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-order');
SET @l19 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-need-and-buy');
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES(@l17,@t_food,'introduce'),(@l18,@t_order,'introduce'),(@l19,@t_need,'introduce');

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale) VALUES
('dlg-de-pre-a1-food-today',@level,'آیریس و پاول دربارهٔ غذای امروز و چیزی که می‌خورند سؤال و جواب می‌کنند.','app','چهار نوبت برای دو جفت سؤال و پاسخ کوتاه کافی است.'),
('dlg-de-pre-a1-simple-order',@level,'آیریس سفارش بسیار کوتاه پاول را می‌گیرد و پاول قهوه سفارش می‌دهد.','app','سلام، پرسش سفارش و پاسخ مؤدبانه بدون پیچیدگی اضافه تمرین می‌شوند.'),
('dlg-de-pre-a1-need-and-buy',@level,'آیریس از پاول می‌پرسد چه چیزی لازم دارد و چه چیزی می‌خرد.','app','دو پرسش و دو پاسخ کوتاه تفاوت کاربردی نیاز و خرید را نشان می‌دهند.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),opening_initiator=VALUES(opening_initiator),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @d17 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-food-today');
SET @d18 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-simple-order');
SET @d19 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-need-and-buy');

INSERT INTO dialogue_turns(turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status) VALUES
('turn-de-food-today-1',@d17,1,@iris,'app_assigned','unspecified','Was gibt es heute?','امروز چی داریم؟',FALSE,'pending'),
('turn-de-food-today-2',@d17,2,@paul,'app_assigned','unspecified','Heute gibt es Suppe.','امروز سوپ داریم.',TRUE,'pending'),
('turn-de-food-today-3',@d17,3,@iris,'app_assigned','unspecified','Was essen Sie?','شما چی می‌خورید؟',FALSE,'pending'),
('turn-de-food-today-4',@d17,4,@paul,'app_assigned','unspecified','Ich esse Reis.','من برنج می‌خورم.',TRUE,'pending'),
('turn-de-simple-order-1',@d18,1,@iris,'app_assigned','unspecified','Guten Tag!','سلام / روز بخیر!',FALSE,'pending'),
('turn-de-simple-order-2',@d18,2,@paul,'app_assigned','unspecified','Guten Tag!','سلام / روز بخیر!',TRUE,'pending'),
('turn-de-simple-order-3',@d18,3,@iris,'app_assigned','unspecified','Was möchten Sie bitte?','لطفاً چی میل دارید؟',FALSE,'pending'),
('turn-de-simple-order-4',@d18,4,@paul,'app_assigned','unspecified','Eine Tasse Kaffee bitte!','یک فنجان قهوه لطفاً!',TRUE,'pending'),
('turn-de-need-buy-1',@d19,1,@iris,'app_assigned','unspecified','Was brauchen Sie?','چه چیزی لازم دارید؟',FALSE,'pending'),
('turn-de-need-buy-2',@d19,2,@paul,'app_assigned','unspecified','Ich brauche eine Hose.','من یک شلوار لازم دارم.',TRUE,'pending'),
('turn-de-need-buy-3',@d19,3,@iris,'app_assigned','unspecified','Und was kaufen Sie?','و چه چیزی می‌خرید؟',FALSE,'pending'),
('turn-de-need-buy-4',@d19,4,@paul,'app_assigned','unspecified','Ich kaufe ein Hemd und ein Paar Schuhe.','من یک پیراهن و یک جفت کفش می‌خرم.',TRUE,'pending')
ON DUPLICATE KEY UPDATE dialogue_id=VALUES(dialogue_id),position_index=VALUES(position_index),speaker_character_id=VALUES(speaker_character_id),speaker_identity_origin=VALUES(speaker_identity_origin),speaker_gender_evidence=VALUES(speaker_gender_evidence),text_target=VALUES(text_target),translation_fa=VALUES(translation_fa),learner_turn=VALUES(learner_turn);

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-food-today-conversation',@l17,1,'conversation_speaking','به سؤال‌های آیریس دربارهٔ غذای امروز و چیزی که می‌خوری جواب بده.','چهار نوبت منبع‌دار هر دو هدف ارتباطی را با کمترین بار شناختی پوشش می‌دهد.',@d17,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-food-today-matching',@l17,2,'matching','هر پرسش را به پاسخ درست وصل کن.','دو جفت دقیق منبع‌دار را بدون جملهٔ تازه دوباره بازیابی می‌کند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Was gibt es heute?','leftFa','امروز چی داریم؟','right','Heute gibt es Suppe.','rightFa','امروز سوپ داریم.'),JSON_OBJECT('left','Was essen Sie?','leftFa','شما چی می‌خورید؟','right','Ich esse Reis.','rightFa','من برنج می‌خورم.'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-simple-order-conversation',@l18,1,'conversation_speaking','سلام کن و وقتی آیریس سفارش را می‌پرسد، یک فنجان قهوه سفارش بده.','این تبادل کوتاه الگوی منبع را بدون دستور تازه تمرین می‌دهد.',@d18,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-simple-order-word-order',@l18,2,'word_order','سفارش کوتاه را دوباره بساز.','بازسازی همان عبارت منبع‌دار، الگوی کاربردی سفارش را تثبیت می‌کند.',NULL,JSON_OBJECT('sourceText','Eine Tasse Kaffee bitte!','sourceTextFa','یک فنجان قهوه لطفاً!','tokens',JSON_ARRAY('Eine','Tasse','Kaffee','bitte!'),'answer',JSON_ARRAY('Eine','Tasse','Kaffee','bitte!')),JSON_ARRAY('sentence_tokenized_for_word_order','persian_translation_added'),NULL,'not_required'),
('act-de-need-buy-conversation',@l19,1,'conversation_speaking','به آیریس بگو چه چیزی لازم داری و چه چیزی می‌خری.','دو جفت سؤال و پاسخ کوتاه معنای کاربردی «brauchen» و «kaufen» را روشن می‌کنند.',@d19,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-need-buy-matching',@l19,2,'matching','هر سؤال را به پاسخ درست وصل کن.','دو کاربرد نزدیک ولی متفاوت فقط با جمله‌های دقیق منبع تثبیت می‌شوند.',NULL,JSON_OBJECT('pairs',JSON_ARRAY(JSON_OBJECT('left','Was brauchen Sie?','leftFa','چه چیزی لازم دارید؟','right','Ich brauche eine Hose.','rightFa','من یک شلوار لازم دارم.'),JSON_OBJECT('left','Und was kaufen Sie?','leftFa','و چه چیزی می‌خرید؟','right','Ich kaufe ein Hemd und ein Paar Schuhe.','rightFa','من یک پیراهن و یک جفت کفش می‌خرم.'))),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
UPDATE lessons SET status='final' WHERE id IN(@l17,@l18,@l19);

INSERT INTO lexemes(lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status) VALUES
('lex-de-suppe',@de,'word','Suppe','Suppe','Suppe','noun','اسم','Pre-A1','سوپ','در پاسخ «Heute gibt es Suppe.» استفاده می‌شود.',TRUE,'pending'),
('lex-de-essen',@de,'word','essen','essen','essen','verb','فعل','Pre-A1','خوردن','برای پرسیدن و گفتن چیزی که فرد می‌خورد استفاده می‌شود.',TRUE,'pending'),
('lex-de-reis',@de,'word','Reis','Reis','Reis','noun','اسم','Pre-A1','برنج',NULL,TRUE,'pending'),
('lex-de-tasse',@de,'word','Tasse','Tasse','Tasse','noun','اسم','Pre-A1','فنجان','در سفارش «Eine Tasse Kaffee bitte!» استفاده می‌شود.',TRUE,'pending'),
('lex-de-kaffee',@de,'word','Kaffee','Kaffee','Kaffee','noun','اسم','Pre-A1','قهوه',NULL,TRUE,'pending'),
('lex-de-brauchen',@de,'word','brauchen','brauchen','brauchen','verb','فعل','Pre-A1','لازم داشتن / نیاز داشتن','در این سطح فقط در الگوی خیلی سادهٔ نیاز استفاده می‌شود.',TRUE,'pending'),
('lex-de-hose',@de,'word','Hose','Hose','Hose','noun','اسم','Pre-A1','شلوار',NULL,TRUE,'pending'),
('lex-de-kaufen',@de,'word','kaufen','kaufen','kaufen','verb','فعل','Pre-A1','خریدن','در این سطح فقط برای بیان یک خرید ساده استفاده می‌شود.',TRUE,'pending'),
('lex-de-hemd',@de,'word','Hemd','Hemd','Hemd','noun','اسم','Pre-A1','پیراهن',NULL,TRUE,'pending'),
('lex-de-schuhe',@de,'word','Schuhe','Schuhe','Schuh','noun','اسم','Pre-A1','کفش‌ها / یک جفت کفش','در جملهٔ منبع به‌صورت جمع «Schuhe» آمده است.',TRUE,'pending')
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible);

SET @x_suppe=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-suppe');
SET @x_essen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-essen');
SET @x_reis=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-reis');
SET @x_tasse=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-tasse');
SET @x_kaffee=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-kaffee');
SET @x_brauchen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-brauchen');
SET @x_hose=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-hose');
SET @x_kaufen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-kaufen');
SET @x_hemd=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-hemd');
SET @x_schuhe=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-schuhe');
SET @x_heute=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-heute');
SET @x_bitte=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-bitte');
INSERT IGNORE INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role) VALUES
(@l17,@x_heute,FALSE,'review'),(@l17,@x_suppe,TRUE,'introduce'),(@l17,@x_essen,TRUE,'introduce'),(@l17,@x_reis,TRUE,'introduce'),
(@l18,@x_bitte,FALSE,'review'),(@l18,@x_tasse,TRUE,'introduce'),(@l18,@x_kaffee,TRUE,'introduce'),
(@l19,@x_brauchen,TRUE,'introduce'),(@l19,@x_hose,TRUE,'introduce'),(@l19,@x_kaufen,TRUE,'introduce'),(@l19,@x_hemd,TRUE,'introduce'),(@l19,@x_schuhe,TRUE,'introduce');

SET @a17a=(SELECT id FROM activities WHERE activity_key='act-de-food-today-conversation');
SET @a17b=(SELECT id FROM activities WHERE activity_key='act-de-food-today-matching');
SET @a18a=(SELECT id FROM activities WHERE activity_key='act-de-simple-order-conversation');
SET @a18b=(SELECT id FROM activities WHERE activity_key='act-de-simple-order-word-order');
SET @a19a=(SELECT id FROM activities WHERE activity_key='act-de-need-buy-conversation');
SET @a19b=(SELECT id FROM activities WHERE activity_key='act-de-need-buy-matching');
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES(@a17a,@t_food),(@a17b,@t_food),(@a18a,@t_order),(@a18b,@t_order),(@a19a,@t_need),(@a19b,@t_need);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES
(@a17a,@x_heute),(@a17a,@x_suppe),(@a17a,@x_essen),(@a17a,@x_reis),(@a17b,@x_heute),(@a17b,@x_suppe),(@a17b,@x_essen),(@a17b,@x_reis),
(@a18a,@x_bitte),(@a18a,@x_tasse),(@a18a,@x_kaffee),(@a18b,@x_bitte),(@a18b,@x_tasse),(@a18b,@x_kaffee),
(@a19a,@x_brauchen),(@a19a,@x_hose),(@a19a,@x_kaufen),(@a19a,@x_hemd),(@a19a,@x_schuhe),(@a19b,@x_brauchen),(@a19b,@x_hose),(@a19b,@x_kaufen),(@a19b,@x_hemd),(@a19b,@x_schuhe);

SET @si_q1=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-was-gibt-heute');
SET @si_a1=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-heute-suppe');
SET @si_q2=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-was-essen');
SET @si_a2=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-ich-esse-reis');
SET @si_gt=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-guten-tag');
SET @si_oq=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-order-question');
SET @si_oa=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-coffee-please');
SET @si_nq=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-need-question');
SET @si_na=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-need-hose');
SET @si_bq=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-buy-question');
SET @si_ba=(SELECT id FROM source_items WHERE item_key='srcitem-de-u3-buy-answer');
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('dialogue_turn','turn-de-food-today-1',@si_q1,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-food-today-2',@si_a1,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-food-today-3',@si_q2,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-food-today-4',@si_a2,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-simple-order-1',@si_gt,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-simple-order-2',@si_gt,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-simple-order-3',@si_oq,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-simple-order-4',@si_oa,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-need-buy-1',@si_nq,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-need-buy-2',@si_na,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-need-buy-3',@si_bq,'verbatim','متن هدف عین منبع است.'),
('dialogue_turn','turn-de-need-buy-4',@si_ba,'verbatim','متن هدف عین منبع است.'),
('activity','act-de-food-today-matching',@si_q1,'source_items_grouped_for_matching','جفت پرسش و پاسخ از منبع گروه‌بندی شده است.'),
('activity','act-de-food-today-matching',@si_a1,'source_items_grouped_for_matching','جفت پرسش و پاسخ از منبع گروه‌بندی شده است.'),
('activity','act-de-food-today-matching',@si_q2,'source_items_grouped_for_matching','جفت پرسش و پاسخ از منبع گروه‌بندی شده است.'),
('activity','act-de-food-today-matching',@si_a2,'source_items_grouped_for_matching','جفت پرسش و پاسخ از منبع گروه‌بندی شده است.'),
('activity','act-de-simple-order-word-order',@si_oa,'sentence_tokenized_for_word_order','جملهٔ منبع برای مرتب‌سازی واژه‌ها بخش‌بندی شده است.'),
('activity','act-de-need-buy-matching',@si_nq,'source_items_grouped_for_matching','جفت پرسش و پاسخ از منبع گروه‌بندی شده است.'),
('activity','act-de-need-buy-matching',@si_na,'source_items_grouped_for_matching','جفت پرسش و پاسخ از منبع گروه‌بندی شده است.'),
('activity','act-de-need-buy-matching',@si_bq,'source_items_grouped_for_matching','جفت پرسش و پاسخ از منبع گروه‌بندی شده است.'),
('activity','act-de-need-buy-matching',@si_ba,'source_items_grouped_for_matching','جفت پرسش و پاسخ از منبع گروه‌بندی شده است.'),
('lexeme','lex-de-suppe',@si_a1,'other','واژه در جملهٔ منبع‌دار آمده است.'),
('lexeme','lex-de-essen',@si_q2,'other','واژه در جملهٔ منبع‌دار آمده است.'),
('lexeme','lex-de-reis',@si_a2,'other','واژه در جملهٔ منبع‌دار آمده است.'),
('lexeme','lex-de-tasse',@si_oa,'other','واژه در جملهٔ منبع‌دار آمده است.'),
('lexeme','lex-de-kaffee',@si_oa,'other','واژه در جملهٔ منبع‌دار آمده است.'),
('lexeme','lex-de-brauchen',@si_nq,'other','فعل در پرسش منبع‌دار آمده است.'),
('lexeme','lex-de-hose',@si_na,'other','واژه در جملهٔ منبع‌دار آمده است.'),
('lexeme','lex-de-kaufen',@si_bq,'other','فعل در پرسش منبع‌دار آمده است.'),
('lexeme','lex-de-hemd',@si_ba,'other','واژه در جملهٔ منبع‌دار آمده است.'),
('lexeme','lex-de-schuhe',@si_ba,'other','واژه در جملهٔ منبع‌دار آمده است.');

UPDATE language_levels
SET coverage=JSON_SET(
      coverage,
      '$.communicativeTargets',JSON_ARRAY('سلام، خداحافظی، تشکر، پاسخ مؤدبانه و عذرخواهی کوتاه','پرسیدن و گفتن نام','احوال‌پرسی بسیار ساده','پرسیدن و پاسخ‌دادن دربارهٔ علاقه/انتخاب غذای آشنا','پاسخ مثبت و منفی کوتاه','پرسیدن و گفتن محل زندگی و مبدأ','پرسیدن و گفتن سن و فهم عددهای ساده','پرسیدن و گفتن روز، ساعت و زمان روز','پرسیدن و گفتن تاریخ تولد','پرسیدن و گفتن شماره تلفن','پرسیدن سؤال اطلاعاتی بسیار ساده و فهم پاسخ کوتاه','نوشتن اطلاعات شخصی بسیار کوتاه در یک فرم متنی','تشخیص شنیداری یک قیمت ساده','پرسیدن و گفتن غذای موجود و چیزی که فرد می‌خورد','انجام یک سفارش بسیار کوتاه و مؤدبانه','فهم و بیان یک نیاز یا خرید بسیار ساده'),
      '$.linguisticTargets',JSON_ARRAY('عبارت‌های ثابت سلام/خداحافظی و ادب','فعل‌های پایهٔ mögen، heißen، wohnen و kommen در کاربردهای منبع‌دار این سطح','عددهای ساده در سن، ساعت، تلفن و قیمت','واژه‌های پایهٔ روز، ساعت، تولد، شماره تلفن و نشانی','الگوهای منبع‌دار معرفی، محل زندگی، سن، تاریخ تولد و شماره تلفن','واژه‌های خیلی پایهٔ غذا و نوشیدنی در جمله‌های کوتاه','الگوهای خیلی سادهٔ essen، brauchen و kaufen در بافت روزمره'),
      '$.situations',JSON_ARRAY('آشنایی اولیه','گفت‌وگوی کوتاه صبحگاهی','علاقه و انتخاب غذای آشنا','تشکر و عذرخواهی','اطلاعات شخصی در آشنایی مؤدبانه','پرسش سن','پرسش روز و ساعت','تاریخ تولد','تبادل شماره تلفن','سؤال اطلاعاتی بسیار ساده','فرم متنی اطلاعات شخصی','تشخیص قیمت ساده','پرسیدن دربارهٔ غذای امروز','سفارش خیلی سادهٔ قهوه','بیان نیاز و خرید خیلی ساده'),
      '$.gaps',JSON_ARRAY()),
    completion_assessment=JSON_SET(
      completion_assessment,
      '$.reviewedAt','2026-09-17T09:30:00Z',
      '$.qualityReview.rationale','واحد سوم دامنهٔ کاربرد روزمره را با غذای موجود، سفارش مؤدبانه و بیان نیاز یا خرید خیلی ساده گسترش می‌دهد؛ همهٔ متن‌های هدف جدید منبع‌دار و قابل ردیابی‌اند.',
      '$.qualityReview.remainingWeaknesses',JSON_ARRAY('۲۲ دارایی صوتی جدید واحد سوم هنوز تولید نشده‌اند.')),
    notes='German Pre-A1 اکنون واحد سوم برای غذا، سفارش و خرید خیلی ساده دارد؛ ۱۰۴ دارایی صوتی قبلی معتبرند و ۲۲ دارایی تازه باید تولید شوند.',
    audio_status='stale'
WHERE id=@level;
COMMIT;

-- ===== END zzz-pre-a1-simple-orders.sql =====

-- ===== BEGIN zzzz-pre-a1-simple-orders-forms.sql =====
-- Canonical form/occurrence sync for German Pre-A1 Unit 3.
-- Applied after zzz-pre-a1-simple-orders.sql and safe to re-run.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);

UPDATE sources
SET locator='Items 040–058',
    locator_fa='بخش‌های ۰۴۰ تا ۰۵۸؛ جمله‌های منبع‌دار دربارهٔ غذای موجود، خوردن و سفارش ساده.'
WHERE source_key='src-wikibooks-de-lesson-002';

UPDATE source_items
SET locator='042', locator_fa='بخش ۰۴۲'
WHERE item_key='srcitem-de-u3-ich-esse-reis';

SET @x_essen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-essen');
SET @x_brauchen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-brauchen');
SET @x_kaufen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kaufen');
SET @x_moegen := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-moegen');
SET @x_heute := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-heute');
SET @x_suppe := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-suppe');
SET @x_reis := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-reis');
SET @x_bitte := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-bitte');
SET @x_tasse := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-tasse');
SET @x_kaffee := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-kaffee');
SET @x_hose := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hose');
SET @x_hemd := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-hemd');
SET @x_schuhe := (SELECT id FROM lexemes WHERE lexeme_key='lex-de-schuhe');

INSERT INTO lexeme_forms
(lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes) VALUES
('lexform-de-essen-esse',@x_essen,'esse','esse','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','در جملهٔ منبع‌دار «Ich esse Reis.» به‌صورت اول‌شخص مفرد حال استفاده شده است.'),
('lexform-de-brauchen-brauche',@x_brauchen,'brauche','brauche','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','در جملهٔ منبع‌دار «Ich brauche eine Hose.» به‌صورت اول‌شخص مفرد حال استفاده شده است.'),
('lexform-de-kaufen-kaufe',@x_kaufen,'kaufe','kaufe','inflected',JSON_OBJECT('tense','present','mood','indicative','person','1','number','singular'),'source_attested','approved','در جملهٔ منبع‌دار «Ich kaufe ein Hemd und ein Paar Schuhe.» به‌صورت اول‌شخص مفرد حال استفاده شده است.'),
('lexform-de-moegen-moechten',@x_moegen,'möchten','möchten','inflected',JSON_OBJECT('mood','subjunctive_II','person','3','number','plural'),'source_attested','approved','در پرسش مؤدبانهٔ منبع‌دار «Was möchten Sie bitte?» با ضمیر رسمی «Sie» استفاده شده است؛ از نظر صرفی با سوم‌شخص جمع هم‌شکل است.')
ON DUPLICATE KEY UPDATE
 lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);

SET @f_esse := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-essen-esse');
SET @f_brauche := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-brauchen-brauche');
SET @f_kaufe := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-kaufen-kaufe');
SET @f_moechten := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-moechten');

INSERT INTO lexeme_occurrences
(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-food-today-1-heute','dialogue_turn','turn-de-food-today-1','heute',NULL,NULL,@x_heute,NULL,'approved','اتصال «heute» تأیید شده است.'),
('occ-turn-de-food-today-2-heute','dialogue_turn','turn-de-food-today-2','Heute',NULL,NULL,@x_heute,NULL,'approved','اتصال «Heute» تأیید شده است.'),
('occ-turn-de-food-today-2-suppe','dialogue_turn','turn-de-food-today-2','Suppe',NULL,NULL,@x_suppe,NULL,'approved','اتصال «Suppe» تأیید شده است.'),
('occ-turn-de-food-today-3-essen','dialogue_turn','turn-de-food-today-3','essen',NULL,NULL,@x_essen,NULL,'approved','صورت پایهٔ «essen» در پرسش منبع‌دار آمده است.'),
('occ-turn-de-food-today-4-esse','dialogue_turn','turn-de-food-today-4','esse',NULL,NULL,@x_essen,@f_esse,'approved','فرم «esse» به «essen» متصل است.'),
('occ-turn-de-food-today-4-reis','dialogue_turn','turn-de-food-today-4','Reis',NULL,NULL,@x_reis,NULL,'approved','اتصال «Reis» تأیید شده است.'),
('occ-turn-de-simple-order-3-moechten','dialogue_turn','turn-de-simple-order-3','möchten',NULL,NULL,@x_moegen,@f_moechten,'approved','فرم رسمی «möchten» به «mögen» متصل است.'),
('occ-turn-de-simple-order-3-bitte','dialogue_turn','turn-de-simple-order-3','bitte',NULL,NULL,@x_bitte,NULL,'approved','اتصال «bitte» تأیید شده است.'),
('occ-turn-de-simple-order-4-tasse','dialogue_turn','turn-de-simple-order-4','Tasse',NULL,NULL,@x_tasse,NULL,'approved','اتصال «Tasse» تأیید شده است.'),
('occ-turn-de-simple-order-4-kaffee','dialogue_turn','turn-de-simple-order-4','Kaffee',NULL,NULL,@x_kaffee,NULL,'approved','اتصال «Kaffee» تأیید شده است.'),
('occ-turn-de-simple-order-4-bitte','dialogue_turn','turn-de-simple-order-4','bitte',NULL,NULL,@x_bitte,NULL,'approved','اتصال «bitte» تأیید شده است.'),
('occ-turn-de-need-buy-1-brauchen','dialogue_turn','turn-de-need-buy-1','brauchen',NULL,NULL,@x_brauchen,NULL,'approved','صورت پایهٔ «brauchen» در پرسش منبع‌دار آمده است.'),
('occ-turn-de-need-buy-2-brauche','dialogue_turn','turn-de-need-buy-2','brauche',NULL,NULL,@x_brauchen,@f_brauche,'approved','فرم «brauche» به «brauchen» متصل است.'),
('occ-turn-de-need-buy-2-hose','dialogue_turn','turn-de-need-buy-2','Hose',NULL,NULL,@x_hose,NULL,'approved','اتصال «Hose» تأیید شده است.'),
('occ-turn-de-need-buy-3-kaufen','dialogue_turn','turn-de-need-buy-3','kaufen',NULL,NULL,@x_kaufen,NULL,'approved','صورت پایهٔ «kaufen» در پرسش منبع‌دار آمده است.'),
('occ-turn-de-need-buy-4-kaufe','dialogue_turn','turn-de-need-buy-4','kaufe',NULL,NULL,@x_kaufen,@f_kaufe,'approved','فرم «kaufe» به «kaufen» متصل است.'),
('occ-turn-de-need-buy-4-hemd','dialogue_turn','turn-de-need-buy-4','Hemd',NULL,NULL,@x_hemd,NULL,'approved','اتصال «Hemd» تأیید شده است.'),
('occ-turn-de-need-buy-4-schuhe','dialogue_turn','turn-de-need-buy-4','Schuhe',NULL,NULL,@x_schuhe,NULL,'approved','اتصال «Schuhe» تأیید شده است.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

SET @l18 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-order');
SET @a18a := (SELECT id FROM activities WHERE activity_key='act-de-simple-order-conversation');
INSERT INTO lesson_lexemes(lesson_id,lexeme_id,is_primary,role)
VALUES(@l18,@x_moegen,FALSE,'review')
ON DUPLICATE KEY UPDATE is_primary=VALUES(is_primary),role=VALUES(role);
INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES(@a18a,@x_moegen);

SET @si_esse := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-ich-esse-reis');
SET @si_brauche := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-need-hose');
SET @si_kaufe := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-buy-answer');
SET @si_moechten := (SELECT id FROM source_items WHERE item_key='srcitem-de-u3-order-question');
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('lexeme_form','lexform-de-essen-esse',@si_esse,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-brauchen-brauche',@si_brauche,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-kaufen-kaufe',@si_kaufe,'other','فرم صرفی از جملهٔ منبع‌دار استخراج شده است.'),
('lexeme_form','lexform-de-moegen-moechten',@si_moechten,'other','فرم رسمی «möchten» از پرسش منبع‌دار استخراج شده است.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

COMMIT;

-- ===== END zzzz-pre-a1-simple-orders-forms.sql =====

-- ===== BEGIN zzzzz-pre-a1-activity-expansion.sql =====
-- German Pre-A1 activity expansion: 3-6 purposeful activities per final lesson.
-- Generated once from canonical authoring JSON; safe to reapply.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
UPDATE lessons SET status='qa' WHERE language_level_id=@level AND status='final';
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-hallo-role-match',l.id,3,'matching','هر عبارت را به کاربردش وصل کن.','بعد از استفاده در مکالمه و تشخیص خداحافظی، این مرحله نقش دو عبارت پایه را بدون افزودن زبان تازه از هم جدا می‌کند.',NULL,'{"pairs":[{"left":"Hallo!","leftFa":"سلام!","rightFa":"شروع گفت‌وگو"},{"left":"Tschüss!","leftFa":"خداحافظ!","rightFa":"پایان گفت‌وگو"}]}','["source_items_grouped_for_matching","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-hallo'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-hallo','lex-de-tschuess') WHERE av.activity_key='act-de-hallo-role-match';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-hallo-role-match',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-hallo','src-wikibooks-de-basic-greetings') AND si.source_text IN ('Hallo!','Tschüss!');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-gm-farewell-response',l.id,3,'choose_response','گفت‌وگوی صبحگاهی تمام شده؛ پاسخ مناسب را انتخاب کن.','پس از تمرکز روی سلام صبحگاهی، یک بازیابی کوتاه از پایان مکالمه کمک می‌کند زبان‌آموز شروع و پایان را در یک توالی کامل نگه دارد.',NULL,'{"contextFa":"صبح است و گفت‌وگو تمام شده.","options":[{"textTarget":"Tschüss!","translationFa":"خداحافظ!","correct":true},{"textTarget":"Guten Morgen!","translationFa":"صبح بخیر!","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-guten-morgen'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-guten-morgen','lex-de-tschuess') WHERE av.activity_key='act-de-gm-farewell-response';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-gm-farewell-response',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-guten-morgen','src-wiktionary-de-hallo','src-wikibooks-de-basic-greetings') AND si.source_text IN ('Guten Morgen!','Tschüss!');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-pizza-fill-mag',l.id,3,'fill_blank','جملهٔ علاقه را کامل کن.','این مرحله تفاوت «mag» و «magst» را در همان جملهٔ منبع‌دار بازیابی می‌کند و شکل اول‌شخص را تثبیت می‌کند.',NULL,'{"sourceText":"Ich mag Pizza.","sourceTextFa":"من پیتزا دوست دارم.","blankedText":"Ich ___ Pizza.","blankedTextFa":"من پیتزا ___ دارم.","choices":["mag","magst"],"answer":"mag"}','["source_sentence_blank_created","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-pizza-like'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-moegen','lex-de-pizza') WHERE av.activity_key='act-de-pizza-fill-mag';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-pizza-fill-mag',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-magst-du-pizza','src-libra-de-ich-mag-pizza','src-wiktionary-de-moegen','src-wiktionary-de-pizza','src-wiktionary-de-hallo') AND si.source_text IN ('Ich mag Pizza.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-pizza-question-vs-answer',l.id,4,'multiple_choice','کدام جمله دربارهٔ علاقهٔ خودت است؟','پس از ساخت جمله، زبان‌آموز باید پرسش و پاسخ را از هم تشخیص دهد تا نقش «mag» و «magst» فقط حفظ شکلی نباشد.',NULL,'{"options":[{"textTarget":"Ich mag Pizza.","translationFa":"من پیتزا دوست دارم.","correct":true},{"textTarget":"Magst du Pizza?","translationFa":"پیتزا دوست داری؟","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-pizza-like'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-moegen','lex-de-pizza') WHERE av.activity_key='act-de-pizza-question-vs-answer';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-pizza-question-vs-answer',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-magst-du-pizza','src-libra-de-ich-mag-pizza','src-wiktionary-de-moegen','src-wiktionary-de-pizza','src-wiktionary-de-hallo') AND si.source_text IN ('Ich mag Pizza.','Magst du Pizza?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-ja-nein-meaning-check',l.id,3,'true_false','درست یا غلط؟ «Nein!» یعنی پاسخ منفی.','پس از انتخاب پاسخ در بافت، یک بررسی معنایی بسیار کوتاه بازیابی مستقیم «nein» را تثبیت می‌کند.',NULL,'{"statementTarget":"Nein!","statementFa":"«Nein!» پاسخ منفی است.","answer":true}','["persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-ja-nein'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-nein') WHERE av.activity_key='act-de-ja-nein-meaning-check';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-ja-nein-meaning-check',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-hallo','src-wikibooks-de-magst-du-pizza','src-wiktionary-de-ja','src-wiktionary-de-nein') AND si.source_text IN ('Nein!');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-danke-bitte-role-match',l.id,3,'matching','تشکر و پاسخ به تشکر را به هم وصل کن.','بعد از انتخاب «Bitte!» در پاسخ، این مرحله نقش دو عبارت را به‌صورت دوطرفه تثبیت می‌کند.',NULL,'{"pairs":[{"left":"Danke!","leftFa":"ممنون!","rightFa":"تشکر"},{"left":"Bitte!","leftFa":"خواهش می‌کنم!","rightFa":"پاسخ به تشکر"}]}','["source_items_grouped_for_matching","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-danke-bitte'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-danke','lex-de-bitte') WHERE av.activity_key='act-de-danke-bitte-role-match';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-danke-bitte-role-match',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-hallo','src-wiktionary-de-danke','src-wiktionary-de-bitte') AND si.source_text IN ('Bitte!','Danke!');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-apology-response-choice',l.id,3,'choose_response','در پاسخ به «Entschuldigung.» کدام عبارت مناسب‌تر است؟','این فعالیت پاسخ آرام به عذرخواهی را از جفت اجتماعی تشکر جدا می‌کند و بازیابی کاربردی می‌سازد.',NULL,'{"promptTarget":"Entschuldigung.","promptFa":"ببخشید.","options":[{"textTarget":"Kein Problem.","translationFa":"مشکلی نیست.","correct":true},{"textTarget":"Danke!","translationFa":"ممنون!","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-entschuldigung'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-entschuldigung','lex-de-kein-problem','lex-de-danke') WHERE av.activity_key='act-de-apology-response-choice';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-apology-response-choice',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-entschuldigung','src-wiktionary-de-kein-problem','src-wiktionary-de-danke','src-wiktionary-de-bitte') AND si.source_text IN ('Danke!','Entschuldigung.','Kein Problem.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-apology-formula-choice',l.id,4,'multiple_choice','کدام عبارت خودِ عذرخواهی است؟','در مرحلهٔ پایانی، زبان‌آموز باید عبارت آغازگر عذرخواهی را از یک عبارت اجتماعی آشنای دیگر تشخیص دهد.',NULL,'{"options":[{"textTarget":"Entschuldigung.","translationFa":"ببخشید.","correct":true},{"textTarget":"Danke!","translationFa":"ممنون!","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-entschuldigung'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-entschuldigung','lex-de-danke') WHERE av.activity_key='act-de-apology-formula-choice';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-apology-formula-choice',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-entschuldigung','src-wiktionary-de-kein-problem','src-wiktionary-de-danke','src-wiktionary-de-bitte') AND si.source_text IN ('Danke!','Entschuldigung.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-name-fill-heisse',l.id,3,'fill_blank','پاسخ معرفی نام را کامل کن.','جای‌خالی روی فرم «heiße» تمرکز می‌کند تا زبان‌آموز آن را از «heißt» در پرسش جدا کند.',NULL,'{"sourceText":"Ich heiße Iris.","sourceTextFa":"اسم من آیریس است.","blankedText":"Ich ___ Iris.","blankedTextFa":"اسم من آیریس است.","choices":["heiße","heißt"],"answer":"heiße"}','["source_sentence_blank_created","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-name-exchange'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-heissen') WHERE av.activity_key='act-de-name-fill-heisse';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-name-fill-heisse',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-hallo','src-wikibooks-de-wie-heisst-du','src-wiktionary-de-heissen') AND si.source_text IN ('Ich heiße Iris.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-name-question-role',l.id,4,'multiple_choice','کدام عبارت سؤالِ نام است؟','بعد از بازیابی پاسخ، تشخیص سؤال از جواب نقش دو فرم «heißt» و «heiße» را در ارتباط واقعی روشن می‌کند.',NULL,'{"options":[{"textTarget":"Wie heißt du?","translationFa":"اسمت چیه؟","correct":true},{"textTarget":"Ich heiße Iris.","translationFa":"اسم من آیریس است.","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-name-exchange'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-heissen') WHERE av.activity_key='act-de-name-question-role';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-name-question-role',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-hallo','src-wikibooks-de-wie-heisst-du','src-wiktionary-de-heissen') AND si.source_text IN ('Ich heiße Iris.','Wie heißt du?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-wellbeing-response',l.id,3,'choose_response','به «Wie geht''s?» پاسخ مناسب بده.','پس از کامل‌کردن پرسش، این مرحله جفت پرسش و پاسخ را با بازیابی مستقیم و کم‌فشار می‌بندد.',NULL,'{"promptTarget":"Wie geht''s?","promptFa":"حالت چطوره؟","options":[{"textTarget":"Gut.","translationFa":"خوبم.","correct":true},{"textTarget":"Hallo!","translationFa":"سلام!","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-wellbeing'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-wie-gehts','lex-de-gut','lex-de-hallo') WHERE av.activity_key='act-de-wellbeing-response';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-wellbeing-response',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-hallo','src-wikibooks-de-basic-greetings') AND si.source_text IN ('Gut.','Hallo!','Wie geht''s?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-simple-choice-fill',l.id,3,'fill_blank','پرسش انتخاب را کامل کن.','این بازیابی روی فرم «möchtest» تمرکز می‌کند و آن را از فرم آشنای «magst» جدا نگه می‌دارد.',NULL,'{"sourceText":"Was möchtest du?","sourceTextFa":"چی می‌خوای؟","blankedText":"Was ___ du?","blankedTextFa":"چی می‌خوای؟","choices":["möchtest","magst"],"answer":"möchtest"}','["source_sentence_blank_created","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-simple-choice'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-moegen') WHERE av.activity_key='act-de-simple-choice-fill';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-simple-choice-fill',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-hallo','src-oak-de-was-moechtest-du','src-wiktionary-de-moechten','src-wiktionary-de-pizza') AND si.source_text IN ('Was möchtest du?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-simple-choice-response',l.id,4,'choose_response','برای «Was möchtest du?» یک پاسخ مناسب انتخاب کن.','در پایان، زبان‌آموز پرسش تازه را به گزینهٔ آشنای «Pizza.» وصل می‌کند تا معنی آن در کاربرد تثبیت شود.',NULL,'{"promptTarget":"Was möchtest du?","promptFa":"چی می‌خوای؟","options":[{"textTarget":"Pizza.","translationFa":"پیتزا.","correct":true},{"textTarget":"Hallo!","translationFa":"سلام!","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-simple-choice'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-moegen','lex-de-pizza','lex-de-hallo') WHERE av.activity_key='act-de-simple-choice-response';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-simple-choice-response',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wiktionary-de-hallo','src-oak-de-was-moechtest-du','src-wiktionary-de-moechten','src-wiktionary-de-pizza') AND si.source_text IN ('Hallo!','Pizza.','Was möchtest du?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-residence-question-choice',l.id,3,'multiple_choice','کدام سؤال دربارهٔ محل زندگی است؟','پس از تطبیق پرسش و پاسخ، تشخیص خود سؤال‌ها از هم مانع قاطی‌شدن «wohnen» و «kommen» می‌شود.',NULL,'{"options":[{"textTarget":"Wo wohnen Sie?","translationFa":"کجا زندگی می‌کنید؟","correct":true},{"textTarget":"Woher kommen Sie?","translationFa":"اهل کجا هستید؟","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-residence-origin'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-wohnen','lex-de-kommen') WHERE av.activity_key='act-de-residence-question-choice';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-residence-question-choice',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-residence-origin') AND si.source_text IN ('Wo wohnen Sie?','Woher kommen Sie?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-residence-word-order',l.id,4,'word_order','پاسخ محل زندگی را دوباره بساز.','بازسازی جملهٔ کامل، الگوی «Ich wohne in ...» را از تشخیص به بازیابی فعال می‌برد.',NULL,'{"sourceText":"Ich wohne in Österreich.","sourceTextFa":"من در اتریش زندگی می‌کنم.","tokens":["Ich","wohne","in","Österreich."],"answer":["Ich","wohne","in","Österreich."]}','["sentence_tokenized_for_word_order","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-residence-origin'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-wohnen','lex-de-oesterreich') WHERE av.activity_key='act-de-residence-word-order';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-residence-word-order',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-residence-origin') AND si.source_text IN ('Ich wohne in Österreich.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-age-question-choice',l.id,3,'multiple_choice','کدام پرسش دربارهٔ سن است؟','بعد از تمرین گفتاری و شنیداری عدد، تشخیص پرسش سن کمک می‌کند معنی کل الگو حفظ شود.',NULL,'{"options":[{"textTarget":"Wie alt bist du?","translationFa":"چند سالته؟","correct":true},{"textTarget":"Ich bin 20 Jahre alt.","translationFa":"من ۲۰ ساله هستم.","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-age-numbers'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-alt') WHERE av.activity_key='act-de-age-question-choice';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-age-question-choice',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-age-time') AND si.source_text IN ('Ich bin 20 Jahre alt.','Wie alt bist du?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-age-word-order',l.id,4,'word_order','پاسخ سن را دوباره بساز.','این مرحله الگوی کامل گفتن سن را از تشخیص عدد به تولید ساختاری منتقل می‌کند.',NULL,'{"sourceText":"Ich bin 20 Jahre alt.","sourceTextFa":"من ۲۰ ساله هستم.","tokens":["Ich","bin","20","Jahre","alt."],"answer":["Ich","bin","20","Jahre","alt."]}','["sentence_tokenized_for_word_order","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-age-numbers'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-alt','lex-de-jahr','lex-de-zwanzig') WHERE av.activity_key='act-de-age-word-order';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-age-word-order',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-age-time') AND si.source_text IN ('Ich bin 20 Jahre alt.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-time-question-match',l.id,4,'matching','پرسش روز و ساعت را به پاسخ مناسب وصل کن.','این مرحله دو نوع اطلاعات نزدیک را کنار هم مقایسه می‌کند تا زبان‌آموز فقط عدد ساعت را حفظ نکند.',NULL,'{"pairs":[{"left":"Welcher Tag ist heute?","leftFa":"امروز چه روزی است؟","right":"Heute ist Dienstag.","rightFa":"امروز سه‌شنبه است."},{"left":"Wie spät ist es?","leftFa":"ساعت چنده؟","right":"Es ist 6.30 Uhr.","rightFa":"ساعت ۶:۳۰ است."}]}','["source_items_grouped_for_matching","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-day-time'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-heute','lex-de-dienstag','lex-de-uhr') WHERE av.activity_key='act-de-time-question-match';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-time-question-match',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-age-time') AND si.source_text IN ('Es ist 6.30 Uhr.','Heute ist Dienstag.','Welcher Tag ist heute?','Wie spät ist es?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-time-word-order',l.id,5,'word_order','جملهٔ ساعت را دوباره بساز.','بازسازی جملهٔ شنیده‌شده، دریافت شنیداری را به بازیابی فعال همان ساختار متصل می‌کند.',NULL,'{"sourceText":"Es ist 6.30 Uhr.","sourceTextFa":"ساعت ۶:۳۰ است.","tokens":["Es","ist","6.30","Uhr."],"answer":["Es","ist","6.30","Uhr."]}','["sentence_tokenized_for_word_order","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-day-time'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-uhr') WHERE av.activity_key='act-de-time-word-order';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-time-word-order',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-age-time') AND si.source_text IN ('Es ist 6.30 Uhr.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-birthday-question-order',l.id,3,'word_order','پرسش تاریخ تولد را دوباره بساز.','پس از گفت‌وگو و تکمیل پاسخ، بازسازی خود پرسش باعث می‌شود هر دو سمت تبادل بازیابی شوند.',NULL,'{"sourceText":"Wann hast du Geburtstag?","sourceTextFa":"تولدت کیه؟","tokens":["Wann","hast","du","Geburtstag?"],"answer":["Wann","hast","du","Geburtstag?"]}','["sentence_tokenized_for_word_order","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-birthday-date'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-geburtstag') WHERE av.activity_key='act-de-birthday-question-order';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-birthday-question-order',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-birthday-question','src-wikibooks-de-birthday') AND si.source_text IN ('Wann hast du Geburtstag?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-birthday-month-check',l.id,4,'true_false','درست یا غلط؟ این جمله یک تاریخ تولد در نوامبر می‌گوید.','بررسی معنی ماه در جملهٔ کامل کمک می‌کند تمرین فقط روی شکل «dreizehnten» متوقف نماند.',NULL,'{"statementTarget":"Ich habe am dreizehnten November Geburtstag.","statementFa":"این تاریخ تولد در ماه نوامبر است.","answer":true}','["persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-birthday-date'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-geburtstag','lex-de-november') WHERE av.activity_key='act-de-birthday-month-check';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-birthday-month-check',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-birthday-question','src-wikibooks-de-birthday') AND si.source_text IN ('Ich habe am dreizehnten November Geburtstag.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-phone-word-order',l.id,3,'word_order','جملهٔ شماره تلفن را دوباره بساز.','پس از تشخیص شنیداری، بازسازی همان جمله باعث می‌شود الگوی گفتن شماره نیز فعالانه تمرین شود.',NULL,'{"sourceText":"Meine Telefonnummer lautet 789.","sourceTextFa":"شماره تلفن من ۷۸۹ است.","tokens":["Meine","Telefonnummer","lautet","789."],"answer":["Meine","Telefonnummer","lautet","789."]}','["sentence_tokenized_for_word_order","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-phone-number'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-telefonnummer') WHERE av.activity_key='act-de-phone-word-order';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-phone-word-order',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-phone','src-wikibooks-de-phone-example') AND si.source_text IN ('Meine Telefonnummer lautet 789.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-phone-question-choice',l.id,4,'multiple_choice','کدام عبارت سؤالِ شماره تلفن است؟','این مرحله پرسش را از پاسخ جدا می‌کند تا زبان‌آموز هر دو نقش را در تبادل تشخیص دهد.',NULL,'{"options":[{"textTarget":"Wie lautet deine Telefonnummer?","translationFa":"شماره تلفنت چیه؟","correct":true},{"textTarget":"Meine Telefonnummer lautet 789.","translationFa":"شماره تلفن من ۷۸۹ است.","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-phone-number'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-telefonnummer') WHERE av.activity_key='act-de-phone-question-choice';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-phone-question-choice',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-phone','src-wikibooks-de-phone-example') AND si.source_text IN ('Meine Telefonnummer lautet 789.','Wie lautet deine Telefonnummer?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-object-answer-choice',l.id,3,'multiple_choice','کدام پاسخ می‌گوید «این یک کتاب است»؟','بعد از بازسازی یک پاسخ، این مرحله دو پاسخ هم‌ساخت را از نظر معنی واژهٔ پایانی مقایسه می‌کند.',NULL,'{"options":[{"textTarget":"Das ist ein Buch.","translationFa":"این یک کتاب است.","correct":true},{"textTarget":"Das ist eine Karte.","translationFa":"این یک کارت است.","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-basic-object'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-buch','lex-de-karte') WHERE av.activity_key='act-de-object-answer-choice';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-object-answer-choice',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-basic-object') AND si.source_text IN ('Das ist ein Buch.','Das ist eine Karte.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-object-question-check',l.id,4,'true_false','درست یا غلط؟ «Was ist das?» یک پرسش است.','این بررسی کوتاه نقش عبارت را تثبیت می‌کند و از حفظ صرفِ پاسخ جلوگیری می‌کند.',NULL,'{"statementTarget":"Was ist das?","statementFa":"این یک پرسش اطلاعاتی ساده است.","answer":true}','["persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-basic-object'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-buch','lex-de-karte') WHERE av.activity_key='act-de-object-question-check';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-object-question-check',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-basic-object') AND si.source_text IN ('Was ist das?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-personal-review-match',l.id,4,'matching','هر پرسش شخصی را به پاسخ مناسب وصل کن.','مرور چندهدفه باید علاوه بر فرم آزاد، بازیابی ساختاری پرسش و پاسخ‌های مهم را هم دوباره فعال کند.',NULL,'{"pairs":[{"left":"Wo wohnen Sie?","leftFa":"کجا زندگی می‌کنید؟","right":"Ich wohne in Österreich.","rightFa":"من در اتریش زندگی می‌کنم."},{"left":"Wie alt bist du?","leftFa":"چند سالته؟","right":"Ich bin 20 Jahre alt.","rightFa":"من ۲۰ ساله هستم."}]}','["source_items_grouped_for_matching","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-personal-review'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-wohnen','lex-de-oesterreich','lex-de-alt','lex-de-jahr','lex-de-zwanzig') WHERE av.activity_key='act-de-personal-review-match';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-personal-review-match',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-residence-origin','src-wikibooks-de-age-time','src-wikibooks-de-birthday','src-wikibooks-de-phone') AND si.source_text IN ('Ich bin 20 Jahre alt.','Ich wohne in Österreich.','Wie alt bist du?','Wo wohnen Sie?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-personal-review-phone-check',l.id,5,'true_false','درست یا غلط؟ این جمله یک شماره تلفن را بیان می‌کند.','این مرحلهٔ کوتاه یک هدف اطلاعات شخصی دیگر را بعد از فرم و شنیدن دوباره بازیابی می‌کند.',NULL,'{"statementTarget":"Meine Telefonnummer lautet 789.","statementFa":"این جمله یک شماره تلفن را بیان می‌کند.","answer":true}','["persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-personal-review'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-telefonnummer') WHERE av.activity_key='act-de-personal-review-phone-check';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-personal-review-phone-check',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-residence-origin','src-wikibooks-de-age-time','src-wikibooks-de-birthday','src-wikibooks-de-phone') AND si.source_text IN ('Meine Telefonnummer lautet 789.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-food-eat-word-order',l.id,3,'word_order','پاسخ مربوط به چیزی که می‌خوری را دوباره بساز.','بعد از تطبیق دو جفت پرسش و پاسخ، بازسازی پاسخ «essen» بازیابی فعال فعل تازه را اضافه می‌کند.',NULL,'{"sourceText":"Ich esse Reis.","sourceTextFa":"من برنج می‌خورم.","tokens":["Ich","esse","Reis."],"answer":["Ich","esse","Reis."]}','["sentence_tokenized_for_word_order","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-food-today'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-essen','lex-de-reis') WHERE av.activity_key='act-de-food-eat-word-order';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-food-eat-word-order',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-lesson-002') AND si.source_text IN ('Ich esse Reis.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-food-available-choice',l.id,4,'multiple_choice','کدام جمله می‌گوید امروز چه غذایی موجود است؟','این مقایسهٔ معنایی تفاوت «غذای موجود» و «چیزی که فرد می‌خورد» را روشن نگه می‌دارد.',NULL,'{"options":[{"textTarget":"Heute gibt es Suppe.","translationFa":"امروز سوپ داریم.","correct":true},{"textTarget":"Ich esse Reis.","translationFa":"من برنج می‌خورم.","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-food-today'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-heute','lex-de-suppe','lex-de-essen','lex-de-reis') WHERE av.activity_key='act-de-food-available-choice';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-food-available-choice',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-lesson-002') AND si.source_text IN ('Heute gibt es Suppe.','Ich esse Reis.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-simple-order-response',l.id,3,'choose_response','به سؤال سفارش پاسخ مناسب بده.','بعد از بازسازی سفارش، این مرحله پرسش رسمی را دوباره به پاسخ کاربردی آن وصل می‌کند.',NULL,'{"promptTarget":"Was möchten Sie bitte?","promptFa":"لطفاً چی میل دارید؟","options":[{"textTarget":"Eine Tasse Kaffee bitte!","translationFa":"یک فنجان قهوه لطفاً!","correct":true},{"textTarget":"Guten Tag!","translationFa":"روز بخیر!","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-simple-order'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-moegen','lex-de-bitte','lex-de-tasse','lex-de-kaffee') WHERE av.activity_key='act-de-simple-order-response';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-simple-order-response',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-lesson-002') AND si.source_text IN ('Eine Tasse Kaffee bitte!','Guten Tag!','Was möchten Sie bitte?');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-simple-order-function-check',l.id,4,'true_false','درست یا غلط؟ این عبارت یک سفارش کوتاه و مؤدبانه است.','در پایان زبان‌آموز باید نقش کل عبارت را بفهمد، نه اینکه فقط ترتیب واژه‌ها را حفظ کرده باشد.',NULL,'{"statementTarget":"Eine Tasse Kaffee bitte!","statementFa":"این یک سفارش کوتاه و مؤدبانه است.","answer":true}','["persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-simple-order'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-bitte','lex-de-tasse','lex-de-kaffee') WHERE av.activity_key='act-de-simple-order-function-check';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-simple-order-function-check',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-lesson-002') AND si.source_text IN ('Eine Tasse Kaffee bitte!');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-need-word-order',l.id,3,'word_order','جملهٔ نیاز را دوباره بساز.','پس از تطبیق، بازسازی جملهٔ «brauchen» آن را از تشخیص به تولید فعال منتقل می‌کند.',NULL,'{"sourceText":"Ich brauche eine Hose.","sourceTextFa":"من یک شلوار لازم دارم.","tokens":["Ich","brauche","eine","Hose."],"answer":["Ich","brauche","eine","Hose."]}','["sentence_tokenized_for_word_order","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-need-and-buy'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-brauchen','lex-de-hose') WHERE av.activity_key='act-de-need-word-order';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-need-word-order',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-lesson-004') AND si.source_text IN ('Ich brauche eine Hose.');
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
SELECT 'act-de-buy-sentence-choice',l.id,4,'multiple_choice','کدام جمله دربارهٔ خرید است؟','مرحلهٔ پایانی تفاوت معنایی «نیاز داشتن» و «خریدن» را با دو جملهٔ کامل منبع‌دار می‌سنجد.',NULL,'{"options":[{"textTarget":"Ich kaufe ein Hemd und ein Paar Schuhe.","translationFa":"من یک پیراهن و یک جفت کفش می‌خرم.","correct":true},{"textTarget":"Ich brauche eine Hose.","translationFa":"من یک شلوار لازم دارم.","correct":false}]}','["options_selected_from_source_material","persian_translation_added"]',NULL,'not_required'
FROM lessons l WHERE l.lesson_key='de-pre-a1-lesson-need-and-buy'
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);
INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)
SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ('lex-de-brauchen','lex-de-hose','lex-de-kaufen','lex-de-hemd','lex-de-schuhe') WHERE av.activity_key='act-de-buy-sentence-choice';
INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-buy-sentence-choice',si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ('src-wikibooks-de-lesson-004') AND si.source_text IN ('Ich brauche eine Hose.','Ich kaufe ein Hemd und ein Paar Schuhe.');
UPDATE lessons SET status='final' WHERE language_level_id=@level;
COMMIT;

-- ===== END zzzzz-pre-a1-activity-expansion.sql =====

-- ===== BEGIN zzzzzz-pre-a1-activity-payload-fixes.sql =====
-- Fix incomplete learner-facing payloads in German Pre-A1 activities.
-- Idempotent and safe for both existing databases and fresh imports.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS _prea1_payload_fix_lesson_status;
CREATE TEMPORARY TABLE _prea1_payload_fix_lesson_status AS
SELECT DISTINCT l.id AS lesson_id, l.status AS original_status
FROM lessons l
JOIN activities a ON a.lesson_id=l.id
WHERE a.activity_key IN (
  'act-de-hallo-role-match',
  'act-de-danke-bitte-role-match',
  'act-de-birthday-fill',
  'act-de-pizza-fill-mag',
  'act-de-name-fill-heisse',
  'act-de-simple-choice-fill'
);

UPDATE lessons l
JOIN _prea1_payload_fix_lesson_status b ON b.lesson_id=l.id
SET l.status='qa'
WHERE b.original_status='final';

-- Matching renderer requires both left and right values. Keep Persian companion labels too.
UPDATE activities
SET payload = JSON_SET(
  payload,
  '$.pairs[0].right','شروع گفت‌وگو',
  '$.pairs[0].rightFa','شروع گفت‌وگو',
  '$.pairs[1].right','پایان گفت‌وگو',
  '$.pairs[1].rightFa','پایان گفت‌وگو'
)
WHERE activity_key='act-de-hallo-role-match';

UPDATE activities
SET payload = JSON_SET(
  payload,
  '$.pairs[0].right','تشکر',
  '$.pairs[0].rightFa','تشکر',
  '$.pairs[1].right','پاسخ به تشکر',
  '$.pairs[1].rightFa','پاسخ به تشکر'
)
WHERE activity_key='act-de-danke-bitte-role-match';

-- A fill-blank must provide a real choice. Use two source-backed month options.
UPDATE activities
SET payload = JSON_SET(
  payload,
  '$.sourceText','Ich habe am dreizehnten November Geburtstag.',
  '$.sourceTextFa','تولد من سیزدهم نوامبر است.',
  '$.blankedText','Ich habe am dreizehnten ___ Geburtstag.',
  '$.blankedTextFa','تولد من سیزدهم ___ است.',
  '$.choices',JSON_ARRAY('November','Juli'),
  '$.choicesFa',JSON_ARRAY('نوامبر','ژوئیه'),
  '$.answer','November'
)
WHERE activity_key='act-de-birthday-fill';

-- Keep Persian companion choice labels synchronized for the newer fill-blank activities.
UPDATE activities
SET payload = JSON_SET(payload,'$.choicesFa',JSON_ARRAY('برای «من»','برای «تو»'))
WHERE activity_key='act-de-pizza-fill-mag';

UPDATE activities
SET payload = JSON_SET(payload,'$.choicesFa',JSON_ARRAY('برای «من»','برای «تو»'))
WHERE activity_key='act-de-name-fill-heisse';

UPDATE activities
SET payload = JSON_SET(payload,'$.choicesFa',JSON_ARRAY('می‌خواهی','دوست داری'))
WHERE activity_key='act-de-simple-choice-fill';

UPDATE lessons l
JOIN _prea1_payload_fix_lesson_status b ON b.lesson_id=l.id
SET l.status=b.original_status;

DROP TEMPORARY TABLE _prea1_payload_fix_lesson_status;
COMMIT;

-- ===== END zzzzzz-pre-a1-activity-payload-fixes.sql =====

-- ===== BEGIN zzzzzzx-pre-a1-survival-reopen.sql =====
-- Reopen the three Unit 4 lessons before the idempotent Unit 4 upsert runs.
-- On the first import the lessons do not exist yet, so this is a no-op.
-- On re-import it allows activity updates without violating final-lesson guards.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
UPDATE lessons
SET status='qa'
WHERE language_level_id=@level
  AND lesson_key IN (
    'de-pre-a1-lesson-ask-price',
    'de-pre-a1-lesson-find-toilet',
    'de-pre-a1-lesson-need-help'
  )
  AND status='final';

-- ===== END zzzzzzx-pre-a1-survival-reopen.sql =====

-- ===== BEGIN zzzzzzz-pre-a1-survival-basics.sql =====
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

-- ===== END zzzzzzz-pre-a1-survival-basics.sql =====

-- ===== BEGIN zzzzzzzz-pre-a1-quality-fixes.sql =====
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

-- ===== END zzzzzzzz-pre-a1-quality-fixes.sql =====

-- ===== BEGIN zzzzzzzzx-pre-a1-quality-audio-status.sql =====
-- Normalize audio state after source-backed quality fixes change existing German text.
-- Audio invalidation triggers intentionally set changed targets to blocked_until_level_final.
-- Once the content change is complete, mark those exact assets stale while lessons are open.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
SET @l_phone := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-phone-number' LIMIT 1);
SET @l_price := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-ask-price' LIMIT 1);

DROP TEMPORARY TABLE IF EXISTS _prea1_quality_audio_lesson_status;
CREATE TEMPORARY TABLE _prea1_quality_audio_lesson_status AS
SELECT id AS lesson_id,status AS original_status
FROM lessons
WHERE id IN (@l_phone,@l_price);

UPDATE lessons l
JOIN _prea1_quality_audio_lesson_status s ON s.lesson_id=l.id
SET l.status='qa'
WHERE s.original_status='final';

UPDATE activities
SET audio_status='stale'
WHERE activity_key IN ('act-de-phone-listen','act-de-price-listen')
  AND audio_text_target IS NOT NULL;

UPDATE dialogue_turns
SET audio_status='stale'
WHERE turn_key IN ('turn-de-phone-2','turn-de-toilet-1','turn-de-toilet-2');

UPDATE lessons l
JOIN _prea1_quality_audio_lesson_status s ON s.lesson_id=l.id
SET l.status=s.original_status;

DROP TEMPORARY TABLE _prea1_quality_audio_lesson_status;
COMMIT;

-- ===== END zzzzzzzzx-pre-a1-quality-audio-status.sql =====

-- ===== BEGIN zzzzzzzzz-pre-a1-quality-localization.sql =====
-- Final Persian companion cleanup for the targeted Pre-A1 quality fixes.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS _prea1_quality_localization_status;
CREATE TEMPORARY TABLE _prea1_quality_localization_status AS
SELECT DISTINCT l.id AS lesson_id,l.status AS original_status
FROM lessons l
JOIN activities a ON a.lesson_id=l.id
WHERE a.activity_key IN ('act-de-wellbeing-fill','act-de-price-sentence-choice','act-de-time-of-day');

UPDATE lessons l
JOIN _prea1_quality_localization_status s ON s.lesson_id=l.id
SET l.status='qa'
WHERE s.original_status='final';

UPDATE activities
SET payload=JSON_SET(
  payload,
  '$.blankedTextFa','حالت ___؟',
  '$.choicesFa',JSON_ARRAY('جزء ثابت عبارت «حالت چطوره؟»','خوب')
)
WHERE activity_key='act-de-wellbeing-fill';

UPDATE activities
SET selection_reason='دو پاسخ قیمتِ بسیار شبیه و هر دو منبع‌دار جای گزینهٔ غلطِ نامرتبط را می‌گیرند تا پاسخ بدون خواندن دقیق عددها قابل حدس نباشد.'
WHERE activity_key='act-de-price-sentence-choice';

UPDATE activities
SET selection_reason='دو عبارت زمان روز مستقیماً از منبع آمده‌اند و واژه‌های «Morgen» و «Abend» نیز به‌عنوان مدخل‌های واژگانی منبع‌دار ثبت شده‌اند.'
WHERE activity_key='act-de-time-of-day';

UPDATE lessons l
JOIN _prea1_quality_localization_status s ON s.lesson_id=l.id
SET l.status=s.original_status;

DROP TEMPORARY TABLE _prea1_quality_localization_status;
COMMIT;

-- ===== END zzzzzzzzz-pre-a1-quality-localization.sql =====

-- ===== BEGIN zzzzzzzzzz-pre-a1-matching-bounds.sql =====
-- German Pre-A1 matching activities: global matching bound is 4–8 pairs; Pre-A1 uses exactly 4.
-- This migration changes only non-audio matching payloads and learner-facing Persian guidance.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @prea1 := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
UPDATE lessons SET status='qa' WHERE language_level_id=@prea1 AND lesson_key IN ('de-pre-a1-lesson-hallo','de-pre-a1-lesson-danke-bitte','de-pre-a1-lesson-entschuldigung','de-pre-a1-lesson-residence-origin','de-pre-a1-lesson-personal-review','de-pre-a1-lesson-day-time','de-pre-a1-lesson-food-today','de-pre-a1-lesson-need-and-buy','de-pre-a1-lesson-ask-price','de-pre-a1-lesson-find-toilet') AND status='final';
UPDATE activities SET instruction_fa='هر عبارت را به کاربردش وصل کن.', selection_reason='چهار عبارت اجتماعی پایهٔ منبع‌دارِ واحد اول را در یک تطبیق کوتاه از هم جدا می‌کند تا مرحلهٔ وصل‌کردن چهار گزینهٔ معنادار داشته باشد.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Hallo!','leftFa','سلام!','right','سلام / شروع گفت‌وگو','rightFa','سلام / شروع گفت‌وگو'),JSON_OBJECT('left','Tschüss!','leftFa','خداحافظ!','right','خداحافظی / پایان گفت‌وگو','rightFa','خداحافظی / پایان گفت‌وگو'),JSON_OBJECT('left','Danke!','leftFa','ممنون!','right','تشکر','rightFa','تشکر'),JSON_OBJECT('left','Bitte!','leftFa','خواهش می‌کنم!','right','پاسخ به تشکر','rightFa','پاسخ به تشکر'))) WHERE activity_key='act-de-hallo-role-match';
UPDATE activities SET instruction_fa='هر عبارت را به کاربردش وصل کن.', selection_reason='چهار عبارت اجتماعی آشنای منبع‌دار را کنار هم می‌گذارد تا تشکر و پاسخ به آن در میان سلام و خداحافظی هم درست تشخیص داده شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Hallo!','leftFa','سلام!','right','سلام / شروع گفت‌وگو','rightFa','سلام / شروع گفت‌وگو'),JSON_OBJECT('left','Tschüss!','leftFa','خداحافظ!','right','خداحافظی / پایان گفت‌وگو','rightFa','خداحافظی / پایان گفت‌وگو'),JSON_OBJECT('left','Danke!','leftFa','ممنون!','right','تشکر','rightFa','تشکر'),JSON_OBJECT('left','Bitte!','leftFa','خواهش می‌کنم!','right','پاسخ به تشکر','rightFa','پاسخ به تشکر'))) WHERE activity_key='act-de-danke-bitte-role-match';
UPDATE activities SET instruction_fa='هر عبارت را به کاربردش وصل کن.', selection_reason='چهار عبارت منبع‌دارِ همین درس را جداگانه تطبیق می‌دهد تا عذرخواهی، پاسخ به عذرخواهی، تشکر و پاسخ به تشکر با چهار گزینهٔ روشن از هم تفکیک شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Entschuldigung.','leftFa','ببخشید.','right','عذرخواهی','rightFa','عذرخواهی'),JSON_OBJECT('left','Kein Problem.','leftFa','مشکلی نیست.','right','پاسخ به عذرخواهی','rightFa','پاسخ به عذرخواهی'),JSON_OBJECT('left','Danke!','leftFa','ممنون!','right','تشکر','rightFa','تشکر'),JSON_OBJECT('left','Bitte!','leftFa','خواهش می‌کنم!','right','پاسخ به تشکر','rightFa','پاسخ به تشکر'))) WHERE activity_key='act-de-entschuldigung-matching';
UPDATE activities SET instruction_fa='هر عبارت را به نقش درستش وصل کن.', selection_reason='چهار عبارت دقیق منبع را جداگانه تطبیق می‌دهد تا پرسش و پاسخِ محل زندگی و مبدأ با چهار گزینهٔ مستقل از هم تشخیص داده شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Wo wohnen Sie?','leftFa','کجا زندگی می‌کنید؟','right','پرسش دربارهٔ محل زندگی','rightFa','پرسش دربارهٔ محل زندگی'),JSON_OBJECT('left','Ich wohne in Österreich.','leftFa','من در اتریش زندگی می‌کنم.','right','پاسخ دربارهٔ محل زندگی','rightFa','پاسخ دربارهٔ محل زندگی'),JSON_OBJECT('left','Woher kommen Sie?','leftFa','اهل کجا هستید؟','right','پرسش دربارهٔ مبدأ','rightFa','پرسش دربارهٔ مبدأ'),JSON_OBJECT('left','Ich komme aus Deutschland, und Sie?','leftFa','من اهل آلمان هستم، شما چطور؟','right','پاسخ دربارهٔ مبدأ','rightFa','پاسخ دربارهٔ مبدأ'))) WHERE activity_key='act-de-residence-matching';
UPDATE activities SET instruction_fa='هر عبارت را به نقش درستش وصل کن.', selection_reason='چهار عبارت منبع‌دارِ مرور را جداگانه تطبیق می‌دهد تا پرسش و پاسخ سن و محل زندگی با چهار گزینهٔ مستقل بازیابی شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Wo wohnen Sie?','leftFa','کجا زندگی می‌کنید؟','right','پرسش دربارهٔ محل زندگی','rightFa','پرسش دربارهٔ محل زندگی'),JSON_OBJECT('left','Ich wohne in Österreich.','leftFa','من در اتریش زندگی می‌کنم.','right','پاسخ دربارهٔ محل زندگی','rightFa','پاسخ دربارهٔ محل زندگی'),JSON_OBJECT('left','Wie alt bist du?','leftFa','چند سالته؟','right','پرسش دربارهٔ سن','rightFa','پرسش دربارهٔ سن'),JSON_OBJECT('left','Ich bin 20 Jahre alt.','leftFa','من ۲۰ ساله هستم.','right','پاسخ دربارهٔ سن','rightFa','پاسخ دربارهٔ سن'))) WHERE activity_key='act-de-personal-review-match';
UPDATE activities SET instruction_fa='هر عبارت را به نقش درستش وصل کن.', selection_reason='چهار عبارت منبع‌دار روز و ساعت را جداگانه تطبیق می‌دهد تا پرسش و پاسخ هر دسته با چهار گزینهٔ مستقل از هم تشخیص داده شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Welcher Tag ist heute?','leftFa','امروز چه روزی است؟','right','پرسش دربارهٔ روز','rightFa','پرسش دربارهٔ روز'),JSON_OBJECT('left','Heute ist Dienstag.','leftFa','امروز سه‌شنبه است.','right','پاسخ دربارهٔ روز','rightFa','پاسخ دربارهٔ روز'),JSON_OBJECT('left','Wie spät ist es?','leftFa','ساعت چنده؟','right','پرسش دربارهٔ ساعت','rightFa','پرسش دربارهٔ ساعت'),JSON_OBJECT('left','Es ist 6.30 Uhr.','leftFa','ساعت ۶:۳۰ است.','right','پاسخ دربارهٔ ساعت','rightFa','پاسخ دربارهٔ ساعت'))) WHERE activity_key='act-de-time-question-match';
UPDATE activities SET instruction_fa='هر عبارت را به نقش درستش وصل کن.', selection_reason='چهار عبارت دقیق منبع را جداگانه تطبیق می‌دهد تا پرسش و پاسخ دربارهٔ غذای موجود و چیزی که فرد می‌خورد با چهار گزینهٔ مستقل تمرین شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Was gibt es heute?','leftFa','امروز چی داریم؟','right','پرسش دربارهٔ غذای امروز','rightFa','پرسش دربارهٔ غذای امروز'),JSON_OBJECT('left','Heute gibt es Suppe.','leftFa','امروز سوپ داریم.','right','پاسخ دربارهٔ غذای موجود','rightFa','پاسخ دربارهٔ غذای موجود'),JSON_OBJECT('left','Was essen Sie?','leftFa','شما چی می‌خورید؟','right','پرسش دربارهٔ چیزی که می‌خورید','rightFa','پرسش دربارهٔ چیزی که می‌خورید'),JSON_OBJECT('left','Ich esse Reis.','leftFa','من برنج می‌خورم.','right','پاسخ دربارهٔ خوردن','rightFa','پاسخ دربارهٔ خوردن'))) WHERE activity_key='act-de-food-today-matching';
UPDATE activities SET instruction_fa='هر عبارت را به نقش درستش وصل کن.', selection_reason='چهار عبارت دقیق منبع را جداگانه تطبیق می‌دهد تا پرسش و پاسخِ نیاز و خرید با چهار گزینهٔ مستقل از هم متمایز شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Was brauchen Sie?','leftFa','چه چیزی لازم دارید؟','right','پرسش دربارهٔ نیاز','rightFa','پرسش دربارهٔ نیاز'),JSON_OBJECT('left','Ich brauche eine Hose.','leftFa','من یک شلوار لازم دارم.','right','پاسخ دربارهٔ نیاز','rightFa','پاسخ دربارهٔ نیاز'),JSON_OBJECT('left','Und was kaufen Sie?','leftFa','و چه چیزی می‌خرید؟','right','پرسش دربارهٔ خرید','rightFa','پرسش دربارهٔ خرید'),JSON_OBJECT('left','Ich kaufe ein Hemd und ein Paar Schuhe.','leftFa','من یک پیراهن و یک جفت کفش می‌خرم.','right','پاسخ دربارهٔ خرید','rightFa','پاسخ دربارهٔ خرید'))) WHERE activity_key='act-de-need-buy-matching';
UPDATE activities SET instruction_fa='هر عبارت را به نقش درستش وصل کن.', selection_reason='چهار عبارت منبع‌دار قیمت را جداگانه تطبیق می‌دهد تا دو شکل پرسش و دو پاسخ عددی با چهار گزینهٔ مستقل خوانده و تشخیص داده شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Wie viel kostet das?','leftFa','این چقدر قیمت دارد؟','right','پرسش قیمت','rightFa','پرسش قیمت'),JSON_OBJECT('left','Das kostet 70 Euro und 92 Cent.','leftFa','این ۷۰ یورو و ۹۲ سنت قیمت دارد.','right','پاسخ قیمت ۷۰ یورو و ۹۲ سنت','rightFa','پاسخ قیمت ۷۰ یورو و ۹۲ سنت'),JSON_OBJECT('left','Was kostet das?','leftFa','قیمت این چقدره؟','right','شکل کوتاه‌تر پرسش قیمت','rightFa','شکل کوتاه‌تر پرسش قیمت'),JSON_OBJECT('left','Das kostet 35 Euro und 15 Cent.','leftFa','این ۳۵ یورو و ۱۵ سنت قیمت دارد.','right','پاسخ قیمت ۳۵ یورو و ۱۵ سنت','rightFa','پاسخ قیمت ۳۵ یورو و ۱۵ سنت'))) WHERE activity_key='act-de-price-match';
UPDATE activities SET instruction_fa='هر عبارت را به نقش درستش وصل کن.', selection_reason='چهار عبارت منبع‌دار گفت‌وگو را جداگانه تطبیق می‌دهد تا شروع مؤدبانه، پاسخ آن، پرسش مکان و پاسخ «نمی‌دانم» با چهار گزینهٔ مستقل تمرین شوند.', payload=JSON_SET(payload,'$.pairMode','target_to_persian','$.pairs',JSON_ARRAY(JSON_OBJECT('left','Entschuldigung!','leftFa','ببخشید!','right','شروع مؤدبانه','rightFa','شروع مؤدبانه'),JSON_OBJECT('left','Bitte?','leftFa','بفرمایید؟','right','پاسخ به شروع مؤدبانه','rightFa','پاسخ به شروع مؤدبانه'),JSON_OBJECT('left','Wo ist die Toilette?','leftFa','سرویس بهداشتی کجاست؟','right','پرسش دربارهٔ مکان','rightFa','پرسش دربارهٔ مکان'),JSON_OBJECT('left','Ich weiß nicht.','leftFa','نمی‌دانم.','right','پاسخ «نمی‌دانم»','rightFa','پاسخ «نمی‌دانم»'))) WHERE activity_key='act-de-toilet-exchange-match';
UPDATE lessons SET status='final' WHERE language_level_id=@prea1 AND lesson_key IN ('de-pre-a1-lesson-hallo','de-pre-a1-lesson-danke-bitte','de-pre-a1-lesson-entschuldigung','de-pre-a1-lesson-residence-origin','de-pre-a1-lesson-personal-review','de-pre-a1-lesson-day-time','de-pre-a1-lesson-food-today','de-pre-a1-lesson-need-and-buy','de-pre-a1-lesson-ask-price','de-pre-a1-lesson-find-toilet');
COMMIT;

-- ===== END zzzzzzzzzz-pre-a1-matching-bounds.sql =====

-- ===== CONSOLIDATED FROM lesson-target-titles (Pre-A1 only) =====
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
UPDATE lessons SET source_title='Wie heißen Sie? / Wo wohnen Sie? / Wie alt sind Sie?', source_title_fa='اسمتان چیست؟ / کجا زندگی می‌کنید؟ / چند سالتان است؟' WHERE lesson_key='de-pre-a1-lesson-personal-review';
COMMIT;


-- ===== BEGIN zzzzzzzzzzz-pre-a1-audit-rebalance.sql =====
-- Pre-A1 pedagogical rebalance after the 2026-09-19 audit.
-- No new German is authored here: every target-language string below already
-- exists in registered source material or earlier source-backed Pre-A1 content.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @prea1 := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);
SET @l_hallo := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-hallo' LIMIT 1);
SET @l_name := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-name-exchange' LIMIT 1);
SET @l_order := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-order' LIMIT 1);
SET @l_toilet := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-find-toilet' LIMIT 1);
SET @l_help := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-need-help' LIMIT 1);

DROP TEMPORARY TABLE IF EXISTS _prea1_audit_lesson_status;
CREATE TEMPORARY TABLE _prea1_audit_lesson_status AS
SELECT id AS lesson_id,status AS original_status
FROM lessons
WHERE id IN (@l_hallo,@l_name,@l_order,@l_toilet,@l_help);

UPDATE lessons l
JOIN _prea1_audit_lesson_status s ON s.lesson_id=l.id
SET l.status='qa'
WHERE s.original_status='final';

UPDATE activities
SET activity_type='listen_repeat',
    instruction_fa='«Tschüss!» را گوش کن و بعد با صدای بلند تکرار کن.',
    selection_reason='درس اول فقط روی سلام و خداحافظی خودش می‌ماند؛ تکرار شنیداری «Tschüss!» به‌جای واردکردن زودهنگام «Danke/Bitte»، تولید شفاهی همان هدف درس را تقویت می‌کند.',
    payload=JSON_OBJECT('audioTextTargetFa','خداحافظ!','repeatTextTarget','Tschüss!','repeatTextTargetFa','خداحافظ!'),
    transformations=JSON_ARRAY('other','persian_translation_added'),
    audio_text_target='Tschüss!',
    audio_status='stale'
WHERE activity_key='act-de-hallo-role-match';

UPDATE activities
SET activity_type='listen_repeat',
    instruction_fa='پاسخ آیریس را گوش کن و بعد با صدای بلند تکرار کن.',
    selection_reason='برای معرفی نام در سطح پیش از A1، بازگویی یک پاسخ کوتاهِ عیناً منبع‌دار از مرتب‌سازی دوبارهٔ واژه‌ها ارزش گفتاری بیشتری دارد.',
    payload=JSON_OBJECT('audioTextTargetFa','اسم من آیریس است.','repeatTextTarget','Ich heiße Iris.','repeatTextTargetFa','اسم من آیریس است.'),
    transformations=JSON_ARRAY('other','persian_translation_added'),
    audio_text_target='Ich heiße Iris.',
    audio_status='stale'
WHERE activity_key='act-de-name-word-order';

UPDATE activities
SET activity_type='listen_repeat',
    instruction_fa='سفارش کوتاه را گوش کن و بعد با صدای بلند تکرار کن.',
    selection_reason='این عبارت یک تکه‌زبان کاربردی برای سفارش است؛ شنیدن و بازگویی همان متن منبع‌دار از مرتب‌سازی واژه‌ها برای هدف گفتاری این درس مناسب‌تر است.',
    payload=JSON_OBJECT('audioTextTargetFa','یک فنجان قهوه لطفاً!','repeatTextTarget','Eine Tasse Kaffee bitte!','repeatTextTargetFa','یک فنجان قهوه لطفاً!'),
    transformations=JSON_ARRAY('other','persian_translation_added'),
    audio_text_target='Eine Tasse Kaffee bitte!',
    audio_status='stale'
WHERE activity_key='act-de-simple-order-word-order';

UPDATE activities
SET activity_type='listen_repeat',
    instruction_fa='پرسش محل را گوش کن و بعد با صدای بلند تکرار کن.',
    selection_reason='این پرسش یک عبارت بقای فوری است؛ بازگویی شفاهی متن دقیق منبع برای استفادهٔ واقعی از مرتب‌سازی واژه‌ها مناسب‌تر است.',
    payload=JSON_OBJECT('audioTextTargetFa','سرویس بهداشتی کجاست؟','repeatTextTarget','Wo ist die Toilette?','repeatTextTargetFa','سرویس بهداشتی کجاست؟'),
    transformations=JSON_ARRAY('other','persian_translation_added'),
    audio_text_target='Wo ist die Toilette?',
    audio_status='stale'
WHERE activity_key='act-de-toilet-question-order';

UPDATE activities
SET activity_type='listen_repeat',
    instruction_fa='درخواست کمک را گوش کن و بعد با صدای بلند تکرار کن.',
    selection_reason='درخواست کمک باید به‌صورت یک عبارت آمادهٔ قابل‌گفتن بازیابی شود؛ شنیدن و بازگویی متن دقیق منبع از مرتب‌سازی واژه‌ها کاربردی‌تر است.',
    payload=JSON_OBJECT('audioTextTargetFa','من کمک لازم دارم.','repeatTextTarget','Ich brauche Hilfe.','repeatTextTargetFa','من کمک لازم دارم.'),
    transformations=JSON_ARRAY('other','persian_translation_added'),
    audio_text_target='Ich brauche Hilfe.',
    audio_status='stale'
WHERE activity_key='act-de-help-word-order';

INSERT INTO activities
(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES
('act-de-pre-a1-final-review',@l_help,5,'review',
 'چهار عبارت را بدون برگشت به درس‌های قبلی بخوان و کاربرد هرکدام را مشخص کن.',
 'در پایان سطح پیش از A1 یک بازیابی فاصله‌دار از چهار حوزهٔ جدا—اطلاعات شخصی، سفارش، قیمت و درخواست کمک—لازم است تا مرور فقط به محتوای همین درس محدود نماند؛ همهٔ عبارت‌ها عین محتوای منبع‌دار قبلی‌اند.',
 NULL,
 JSON_OBJECT('items',JSON_ARRAY(
   JSON_OBJECT('textTarget','Ich heiße Paul Müller.','translationFa','اسم من پاول مولر است.','categoryFa','اطلاعات شخصی'),
   JSON_OBJECT('textTarget','Eine Tasse Kaffee bitte!','translationFa','یک فنجان قهوه لطفاً!','categoryFa','سفارش'),
   JSON_OBJECT('textTarget','Wie viel kostet das?','translationFa','این چقدر قیمت دارد؟','categoryFa','قیمت'),
   JSON_OBJECT('textTarget','Ich brauche Hilfe.','translationFa','من کمک لازم دارم.','categoryFa','درخواست کمک')
 )),
 JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),
 NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target);

UPDATE lessons SET activity_selection_rationale='سه مرحلهٔ کوتاه، استفاده در مکالمه، تشخیص خداحافظی و سپس شنیدن و بازگویی همان عبارت پایه را پوشش می‌دهد؛ محتوای درس‌های بعدی زودتر وارد نمی‌شود.',sequence_rationale='از کاربرد واقعی به تشخیص نقش و سپس بازگویی شفاهی یکی از همان دو عبارت پایه می‌رسد.',template_signature='conversation_speaking>multiple_choice>listen_repeat',audio_status='stale' WHERE id=@l_hallo;
UPDATE lessons SET activity_selection_rationale='چهار مرحله پرسیدن نام، شنیدن و بازگویی پاسخ، بازیابی «heiße» و تشخیص پرسش از پاسخ را پوشش می‌دهد.',sequence_rationale='کاربرد در مکالمه به بازگویی شفاهی پاسخ، تمرکز روی فرم و در پایان تشخیص نقش جمله می‌رسد.',template_signature='conversation_speaking>listen_repeat>fill_blank>multiple_choice',audio_status='stale' WHERE id=@l_name;
UPDATE lessons SET activity_selection_rationale='پنج مرحله مکالمهٔ سفارش، شنیدن و بازگویی عبارت، پاسخ به سؤال رسمی، تشخیص نقش کل سفارش و دریافت شنیداری مستقل را پوشش می‌دهد.',sequence_rationale='تعامل به بازگویی شفاهی سفارش، بازیابی پاسخ، فهم کاربرد عبارت و در پایان تشخیص شنیداری همان سفارش می‌رسد.',template_signature='conversation_speaking>listen_repeat>choose_response>true_false>listen_choose',audio_status='stale' WHERE id=@l_order;
UPDATE lessons SET activity_selection_rationale='پنج مرحله مکالمه، تطبیق دو جفت کوتاه، شنیدن و بازگویی پرسش مکان، تشخیص معنی «نمی‌دانم» و دریافت شنیداری مستقل را پوشش می‌دهد.',sequence_rationale='پرسش ابتدا در یک تبادل مؤدبانهٔ منبع‌دار دیده می‌شود، سپس ارتباط جفت‌ها تثبیت می‌شود، خود پرسش از راه شنیدن بازگو می‌شود، پاسخ کوتاه تشخیص داده می‌شود و در پایان همان پرسش در دریافت شنیداری بازیابی می‌شود.',template_signature='conversation_speaking>matching>listen_repeat>multiple_choice>listen_choose',audio_status='stale' WHERE id=@l_toilet;
UPDATE lessons SET activity_selection_rationale='پنج مرحله مکالمه، شنیدن و بازگویی درخواست کمک، جای‌خالی، تشخیص معنی و در پایان یک مرور تجمعی بین‌واحدی را پوشش می‌دهد.',sequence_rationale='عبارت کمک ابتدا در تعامل و سپس به‌صورت شفاهی بازیابی می‌شود؛ بعد معنی واژهٔ کلیدی تثبیت می‌شود و آخرین فعالیت بدون زبان تازه، چهار کاربرد مهم از کل سطح پیش از A1 را دوباره فعال می‌کند.',template_signature='conversation_speaking>listen_repeat>fill_blank>multiple_choice>review',audio_status='stale' WHERE id=@l_help;

UPDATE units SET notes='این واحد خوشهٔ اطلاعات شخصی و مرور آن را می‌بندد؛ پس از آن سطح به کاربردهای خرید، سفارش و موقعیت‌های ضروری روزمره ادامه پیدا می‌کند.' WHERE unit_key='de-pre-a1-unit-personal-info';
UPDATE language_levels SET audio_status='pending',notes='سطح پیش از A1 آلمانی ۲۲ درس در ۴ واحد و ۸۹ فعالیت هدفمند دارد؛ پنج تمرین شنیدن و بازگویی و یک مرور تجمعی پایانی به‌صورت نیازمحور در بازبینی ۲۰۲۶-۰۹-۱۹ تثبیت شدند.' WHERE id=@prea1;

SET @t_review := (SELECT id FROM curriculum_targets WHERE language_level_id=@prea1 AND target_key='de.pre_a1.integrated_review' LIMIT 1);
SET @a_final_review := (SELECT id FROM activities WHERE activity_key='act-de-pre-a1-final-review' LIMIT 1);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES (@a_final_review,@t_review);

INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-hallo-role-match',si.id,'other','عبارت تکرار شنیداری عین منبع قبلی است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key='src-wikibooks-de-basic-greetings' AND si.source_text='Tschüss!';
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-name-word-order',si.id,'other','عبارت تکرار شنیداری عین منبع قبلی است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key='src-wikibooks-de-wie-heisst-du' AND si.source_text='Ich heiße Iris.';
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-simple-order-word-order',si.id,'other','عبارت تکرار شنیداری عین منبع قبلی است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key='src-wikibooks-de-lesson-002' AND si.source_text='Eine Tasse Kaffee bitte!';
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-toilet-question-order',si.id,'other','عبارت تکرار شنیداری عین منبع قبلی است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key='src-wikibooks-de-phrasebook' AND si.source_text='Wo ist die Toilette?';
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-help-word-order',si.id,'other','عبارت تکرار شنیداری عین منبع قبلی است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key='src-wikibooks-de-phrasebook' AND si.source_text='Ich brauche Hilfe.';
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-pre-a1-final-review',si.id,'options_selected_from_source_material','عبارت منبع‌دار قبلی برای مرور تجمعی پایان Pre-A1 بازاستفاده شده است.'
FROM source_items si JOIN sources s ON s.id=si.source_id
WHERE (s.source_key='src-wikibooks-de-residence-origin' AND si.source_text='Ich heiße Paul Müller.')
   OR (s.source_key='src-wikibooks-de-lesson-002' AND si.source_text='Eine Tasse Kaffee bitte!')
   OR (s.source_key='src-wikibooks-de-lesson-004' AND si.source_text='Wie viel kostet das?')
   OR (s.source_key='src-wikibooks-de-phrasebook' AND si.source_text='Ich brauche Hilfe.');

UPDATE lessons l JOIN _prea1_audit_lesson_status s ON s.lesson_id=l.id SET l.status=s.original_status;
DROP TEMPORARY TABLE _prea1_audit_lesson_status;
COMMIT;

-- ===== END zzzzzzzzzzz-pre-a1-audit-rebalance.sql =====


-- ===== BEGIN zzzzzzzzzzzz-pre-a1-new-audio-unblock-2026-09-19.sql =====
-- Reopen only the lessons whose previously non-audio activities became audio-bearing
-- during the Pre-A1 audit. This late section runs after every historical content
-- mutation so the new assets end in the intended stale state and are eligible for
-- regeneration instead of remaining blocked on a final lesson.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @prea1 := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);

DROP TEMPORARY TABLE IF EXISTS _prea1_new_audio_lesson_status;
CREATE TEMPORARY TABLE _prea1_new_audio_lesson_status AS
SELECT DISTINCT l.id AS lesson_id,l.status AS original_status
FROM lessons l
JOIN activities a ON a.lesson_id=l.id
WHERE l.language_level_id=@prea1
  AND a.activity_key IN (
    'act-de-hallo-role-match',
    'act-de-name-word-order',
    'act-de-simple-order-word-order',
    'act-de-toilet-question-order',
    'act-de-help-word-order'
  );

UPDATE lessons l
JOIN _prea1_new_audio_lesson_status s ON s.lesson_id=l.id
SET l.status='qa'
WHERE s.original_status='final';

UPDATE activities
SET audio_status='stale'
WHERE activity_key IN (
    'act-de-hallo-role-match',
    'act-de-name-word-order',
    'act-de-simple-order-word-order',
    'act-de-toilet-question-order',
    'act-de-help-word-order'
  )
  AND audio_text_target IS NOT NULL;

UPDATE language_levels
SET audio_status='stale'
WHERE id=@prea1;

UPDATE lessons l
JOIN _prea1_new_audio_lesson_status s ON s.lesson_id=l.id
SET l.status=s.original_status;

DROP TEMPORARY TABLE _prea1_new_audio_lesson_status;
COMMIT;

-- ===== END zzzzzzzzzzzz-pre-a1-new-audio-unblock-2026-09-19.sql =====


-- ===== BEGIN zzzzzzzzzzzzz-pre-a1-cumulative-review-unit-2026-09-19.sql =====
-- Dedicated cumulative review unit for German Pre-A1.
-- All German strings below are reused from existing source-backed Pre-A1 content.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @prea1 := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes)
VALUES(
 'de-pre-a1-unit-cumulative-review',@prea1,5,'مرور نهایی پیش از A1',
 'پس از پایان چهار واحد آموزشی، یک واحد جدا برای بازیابی فاصله‌دار لازم است تا زبان‌آموز مطالب را نه در ترتیب آموزش، بلکه در خوشه‌های کاربردی دوباره به یاد بیاورد. چهار درس نخست هرکدام یک حوزهٔ بزرگ را جمع‌بندی می‌کنند و درس پنجم حوزه‌ها را با هم مخلوط می‌کند؛ این پنج درس از نیاز مرور و ترکیب مهارت‌ها به‌دست آمده‌اند و برای رسیدن به عدد خاصی انتخاب نشده‌اند.',
 'final',JSON_OBJECT('dynamicStructure',TRUE,'cumulativeReview',TRUE),
 'این واحد فقط مطالب منبع‌دار قبلی را دوباره ترکیب می‌کند و هیچ هدف زبانی تازه‌ای به سطح اضافه نمی‌کند.'
)
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=VALUES(status),metadata=VALUES(metadata),notes=VALUES(notes);
SET @u_review := (SELECT id FROM units WHERE unit_key='de-pre-a1-unit-cumulative-review' LIMIT 1);

SET @d_wellbeing := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-wellbeing' LIMIT 1);
SET @d_personal_review := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-personal-review' LIMIT 1);
SET @d_food_today := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-food-today' LIMIT 1);
SET @d_find_toilet := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-find-toilet' LIMIT 1);
SET @d_simple_order := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-simple-order' LIMIT 1);

INSERT INTO lessons
(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES
('de-pre-a1-lesson-review-social-basics',@prea1,@u_review,23,1,'مرور ارتباط‌های پایه','Hallo! / Wie geht''s? / Guten Morgen! / Tschüss!','سلام! / حالت چطوره؟ / صبح بخیر! / خداحافظ!','qa',
 'چهار مرحلهٔ مرور، مکالمهٔ آشنا، تشخیص نقش چهار عبارت اجتماعی، پاسخ به عذرخواهی و در پایان بازیابی چند عبارت پایه را پوشش می‌دهد؛ برای این خوشه تمرین اضافه ارزش آموزشی مستقلی ندارد.',
 'مرور از تعامل آشنا شروع می‌شود، سپس نقش عبارت‌های اجتماعی تفکیک می‌شود، پاسخ مناسب انتخاب می‌شود و در پایان چند عبارت از درس‌های جدا کنار هم بازیابی می‌شوند.',
 'conversation_speaking>matching>choose_response>review','ready',NULL),
('de-pre-a1-lesson-review-personal-info',@prea1,@u_review,24,2,'جمع‌بندی اطلاعات شخصی','Wie heißen Sie? / Wo wohnen Sie? / Wie alt sind Sie?','اسمتان چیست؟ / کجا زندگی می‌کنید؟ / چند سالتان است؟','qa',
 'چهار مرحلهٔ مرور، مکالمهٔ چندهدفه، تطبیق روز و ساعت، تکمیل الگوی سن و بازیابی تاریخ/تلفن/سؤال اطلاعاتی را پوشش می‌دهد؛ این چهار مرحله شکاف‌های اصلی این خوشه را می‌بندند.',
 'ابتدا اطلاعات شخصی در تعامل بازیابی می‌شود، بعد روز و ساعت از هم تفکیک می‌شوند، الگوی سن فعالانه تکمیل می‌شود و در پایان چند نوع اطلاعات شخصی و روزمره با هم مخلوط می‌شوند.',
 'conversation_speaking>matching>fill_blank>review','ready',NULL),
('de-pre-a1-lesson-review-food-shopping',@prea1,@u_review,25,3,'مرور غذا، سفارش و خرید','Was gibt es heute? / Was möchten Sie bitte? / Wie viel kostet das?','امروز چی داریم؟ / لطفاً چی میل دارید؟ / این چقدر قیمت دارد؟','qa',
 'پنج مرحله لازم است چون این خوشه چهار تمایز جدا دارد: غذای موجود/خورده‌شده، سفارش، نیاز/خرید و قیمت؛ مرحلهٔ پنجم این حوزه‌ها را مخلوط می‌کند تا مرور فقط بلوکی نباشد.',
 'مکالمهٔ غذا نقطهٔ شروع است، سپس سفارش، نیاز/خرید و قیمت جداگانه بازیابی می‌شوند و در پایان چهار کاربرد در یک مرور ترکیبی کنار هم می‌آیند.',
 'conversation_speaking>choose_response>matching>multiple_choice>review','ready',NULL),
('de-pre-a1-lesson-review-survival',@prea1,@u_review,26,4,'مرور موقعیت‌های ضروری','Wo ist die Toilette? / Ich brauche Hilfe.','سرویس بهداشتی کجاست؟ / من کمک لازم دارم.','qa',
 'چهار مرحلهٔ مرور برای این خوشه کافی است: تعامل موقعیت، فهم پاسخ «نمی‌دانم»، تفکیک درخواست کمک از نیاز خرید و یک بازیابی ترکیبی از عبارت‌های ضروری.',
 'از موقعیت واقعی پیدا کردن مکان شروع می‌شود، سپس فهم پاسخ کوتاه و درخواست کمک جداگانه سنجیده می‌شوند و در پایان عبارت‌های ضروری کنار هم قرار می‌گیرند.',
 'conversation_speaking>multiple_choice>fill_blank>review','ready',NULL),
('de-pre-a1-lesson-review-final-mix',@prea1,@u_review,27,5,'مرور نهایی ترکیبی','Wie heißen Sie? / Eine Tasse Kaffee bitte! / Ich brauche Hilfe.','اسمتان چیست؟ / یک فنجان قهوه لطفاً! / من کمک لازم دارم.','qa',
 'پنج مرحله برای جمع‌بندی نهایی لازم است: یک تعامل آشنا، یک تطبیق چهاردامنه‌ای، یک مرور مخلوط از اطلاعات دورتر، تمایز کمک/خرید و یک بررسی کوتاه از سؤال اطلاعاتی. هر مرحله پوشش متفاوتی دارد و فعالیت ششم ارزش مستقل اضافه نمی‌کند.',
 'درس با یک تعامل روان شروع می‌شود، سپس حوزه‌ها به‌صورت بین‌موضوعی مخلوط می‌شوند و در دو مرحلهٔ آخر دو تمایز مهم و کوتاه تثبیت می‌شوند؛ هیچ ترتیب آموزشی قبلی دوباره کپی نمی‌شود.',
 'conversation_speaking>matching>review>multiple_choice>true_false','ready',NULL)
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),
 notes=VALUES(notes);

SET @l23 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-review-social-basics' LIMIT 1);
SET @l24 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-review-personal-info' LIMIT 1);
SET @l25 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-review-food-shopping' LIMIT 1);
SET @l26 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-review-survival' LIMIT 1);
SET @l27 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-review-final-mix' LIMIT 1);

INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES
('act-de-review-social-conversation',@l23,1,'conversation_speaking','گفت‌وگوی سلام و احوال‌پرسی را دوباره انجام بده.','بازگشت به یک گفت‌وگوی چهار نوبتی آشنا، شروع مرور را کم‌فشار نگه می‌دارد و بدون زبان تازه بازیابی گفتاری ایجاد می‌کند.',@d_wellbeing,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-review-social-functions',@l23,2,'matching','هر عبارت را به کاربردش وصل کن.','چهار عبارت اجتماعی از درس‌های مختلف کنار هم قرار می‌گیرند تا زبان‌آموز نقش آن‌ها را بدون کمک ترتیب قبلی درس‌ها بازیابی کند.',NULL,JSON_OBJECT('pairMode','target_to_persian','pairs',JSON_ARRAY(
 JSON_OBJECT('left','Hallo!','leftFa','سلام!','right','سلام / شروع گفت‌وگو','rightFa','سلام / شروع گفت‌وگو'),
 JSON_OBJECT('left','Tschüss!','leftFa','خداحافظ!','right','خداحافظی / پایان گفت‌وگو','rightFa','خداحافظی / پایان گفت‌وگو'),
 JSON_OBJECT('left','Danke!','leftFa','ممنون!','right','تشکر','rightFa','تشکر'),
 JSON_OBJECT('left','Bitte!','leftFa','خواهش می‌کنم!','right','پاسخ به تشکر','rightFa','پاسخ به تشکر')
)),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-review-social-apology',@l23,3,'choose_response','بعد از عذرخواهی کدام پاسخ مناسب‌تر است؟','پاسخ به عذرخواهی جدا از تشکر سنجیده می‌شود تا دو واکنش اجتماعی نزدیک با هم اشتباه نشوند.',NULL,JSON_OBJECT('promptTarget','Entschuldigung.','promptFa','ببخشید.','options',JSON_ARRAY(
 JSON_OBJECT('textTarget','Kein Problem.','translationFa','مشکلی نیست.','correct',TRUE),
 JSON_OBJECT('textTarget','Danke!','translationFa','ممنون!','correct',FALSE)
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-review-social-mix',@l23,4,'review','کاربرد هر عبارت را از بین چیزهایی که قبلاً یاد گرفته‌ای به یاد بیاور.','چهار عبارت از درس‌های غیرپیاپی کنار هم آمده‌اند تا بازیابی به ترتیب آموزش وابسته نباشد.',NULL,JSON_OBJECT('items',JSON_ARRAY(
 JSON_OBJECT('textTarget','Guten Morgen!','translationFa','صبح بخیر!','categoryFa','سلام صبحگاهی'),
 JSON_OBJECT('textTarget','Wie geht''s?','translationFa','حالت چطوره؟','categoryFa','احوال‌پرسی'),
 JSON_OBJECT('textTarget','Gut.','translationFa','خوبم.','categoryFa','پاسخ احوال‌پرسی'),
 JSON_OBJECT('textTarget','Nein!','translationFa','نه!','categoryFa','پاسخ منفی')
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),

('act-de-review-personal-conversation',@l24,1,'conversation_speaking','نام، محل زندگی و سن را در گفت‌وگوی آشنا دوباره مرور کن.','گفت‌وگوی هشت نوبتیِ مرور شخصی قبلاً منبع‌دار و آماده است و سه هدف مهم را بدون ساختن متن تازه یکجا بازیابی می‌کند.',@d_personal_review,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-review-personal-time',@l24,2,'matching','هر عبارت را به نقش درستش وصل کن.','روز و ساعت پس از فاصله از درس اصلی دوباره کنار هم قرار می‌گیرند تا پرسش و پاسخ هرکدام از حافظه بازیابی شوند.',NULL,JSON_OBJECT('pairMode','target_to_persian','pairs',JSON_ARRAY(
 JSON_OBJECT('left','Welcher Tag ist heute?','leftFa','امروز چه روزی است؟','right','پرسش دربارهٔ روز','rightFa','پرسش دربارهٔ روز'),
 JSON_OBJECT('left','Heute ist Dienstag.','leftFa','امروز سه‌شنبه است.','right','پاسخ دربارهٔ روز','rightFa','پاسخ دربارهٔ روز'),
 JSON_OBJECT('left','Wie spät ist es?','leftFa','ساعت چنده؟','right','پرسش دربارهٔ ساعت','rightFa','پرسش دربارهٔ ساعت'),
 JSON_OBJECT('left','Es ist 6.30 Uhr.','leftFa','ساعت ۶:۳۰ است.','right','پاسخ دربارهٔ ساعت','rightFa','پاسخ دربارهٔ ساعت')
)),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-review-personal-age',@l24,3,'fill_blank','جملهٔ سن را با عدد درست کامل کن.','الگوی سن باید بعد از فاصلهٔ زمانی دوباره فعال شود؛ دو عدد آشنای همین سطح انتخاب واقعی ایجاد می‌کنند.',NULL,JSON_OBJECT(
 'sourceText','Ich bin 20 Jahre alt.','sourceTextFa','من ۲۰ ساله هستم.','blankedText','Ich bin ___ Jahre alt.','blankedTextFa','من ___ ساله هستم.',
 'choices',JSON_ARRAY('20','18'),'choicesFa',JSON_ARRAY('۲۰','۱۸'),'answer','20'
),JSON_ARRAY('source_sentence_blank_created','persian_translation_added'),NULL,'not_required'),
('act-de-review-personal-mix',@l24,4,'review','هر نمونه را به نوع اطلاعاتی که منتقل می‌کند ربط بده.','تاریخ تولد، شماره تلفن و سؤال اطلاعاتی ساده از درس‌های جدا کنار هم می‌آیند تا تشخیص آن‌ها مستقل از ترتیب درس‌ها شود.',NULL,JSON_OBJECT('items',JSON_ARRAY(
 JSON_OBJECT('textTarget','Wann hast du Geburtstag?','translationFa','تولدت کیه؟','categoryFa','تاریخ تولد'),
 JSON_OBJECT('textTarget','Meine Telefonnummer ist: 692-267-752.','translationFa','شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.','categoryFa','شماره تلفن'),
 JSON_OBJECT('textTarget','Was ist das?','translationFa','این چیه؟','categoryFa','سؤال اطلاعاتی ساده'),
 JSON_OBJECT('textTarget','Das ist ein Buch.','translationFa','این یک کتاب است.','categoryFa','پاسخ اطلاعاتی ساده')
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),

('act-de-review-food-conversation',@l25,1,'conversation_speaking','به سؤال‌های مربوط به غذای امروز دوباره پاسخ بده.','گفت‌وگوی قبلی غذا دو مفهوم نزدیک را در چهار نوبت بازیابی می‌کند و شروع مناسبی برای ورود به مرور خرید و سفارش است.',@d_food_today,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-review-order-response',@l25,2,'choose_response','به پرسش سفارش پاسخ مناسب بده.','پرسش رسمی سفارش بعد از فاصله از درس اصلی دوباره به پاسخ کاربردی‌اش وصل می‌شود.',NULL,JSON_OBJECT('promptTarget','Was möchten Sie bitte?','promptFa','لطفاً چی میل دارید؟','options',JSON_ARRAY(
 JSON_OBJECT('textTarget','Eine Tasse Kaffee bitte!','translationFa','یک فنجان قهوه لطفاً!','correct',TRUE),
 JSON_OBJECT('textTarget','Guten Tag!','translationFa','روز بخیر!','correct',FALSE)
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-review-need-buy',@l25,3,'matching','هر عبارت را به نقش درستش وصل کن.','نیاز و خرید دوباره در قالب چهار نقش مستقل مرور می‌شوند تا «brauchen» و «kaufen» فقط با ترتیب قبلی درس به یاد نیایند.',NULL,JSON_OBJECT('pairMode','target_to_persian','pairs',JSON_ARRAY(
 JSON_OBJECT('left','Was brauchen Sie?','leftFa','چه چیزی لازم دارید؟','right','پرسش دربارهٔ نیاز','rightFa','پرسش دربارهٔ نیاز'),
 JSON_OBJECT('left','Ich brauche eine Hose.','leftFa','من یک شلوار لازم دارم.','right','پاسخ دربارهٔ نیاز','rightFa','پاسخ دربارهٔ نیاز'),
 JSON_OBJECT('left','Und was kaufen Sie?','leftFa','و چه چیزی می‌خرید؟','right','پرسش دربارهٔ خرید','rightFa','پرسش دربارهٔ خرید'),
 JSON_OBJECT('left','Ich kaufe ein Hemd und ein Paar Schuhe.','leftFa','من یک پیراهن و یک جفت کفش می‌خرم.','right','پاسخ دربارهٔ خرید','rightFa','پاسخ دربارهٔ خرید')
)),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-review-price-choice',@l25,4,'multiple_choice','کدام جمله قیمت ۳۵ یورو و ۱۵ سنت را می‌گوید؟','دو پاسخ قیمتِ نزدیک و هر دو منبع‌دار دوباره مقایسه می‌شوند تا عددها با دقت خوانده شوند.',NULL,JSON_OBJECT('options',JSON_ARRAY(
 JSON_OBJECT('textTarget','Das kostet 35 Euro und 15 Cent.','translationFa','این ۳۵ یورو و ۱۵ سنت قیمت دارد.','correct',TRUE),
 JSON_OBJECT('textTarget','Das kostet 70 Euro und 92 Cent.','translationFa','این ۷۰ یورو و ۹۲ سنت قیمت دارد.','correct',FALSE)
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-review-food-shopping-mix',@l25,5,'review','کاربرد هر عبارت را بدون توجه به درس اصلی‌اش مشخص کن.','چهار حوزهٔ این خوشه در یک فعالیت مخلوط می‌شوند تا انتقال بین موقعیت‌ها تمرین شود.',NULL,JSON_OBJECT('items',JSON_ARRAY(
 JSON_OBJECT('textTarget','Was gibt es heute?','translationFa','امروز چی داریم؟','categoryFa','غذای موجود'),
 JSON_OBJECT('textTarget','Eine Tasse Kaffee bitte!','translationFa','یک فنجان قهوه لطفاً!','categoryFa','سفارش'),
 JSON_OBJECT('textTarget','Ich brauche eine Hose.','translationFa','من یک شلوار لازم دارم.','categoryFa','نیاز'),
 JSON_OBJECT('textTarget','Wie viel kostet das?','translationFa','این چقدر قیمت دارد؟','categoryFa','پرسش قیمت')
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),

('act-de-review-survival-conversation',@l26,1,'conversation_speaking','با عذرخواهی شروع کن و دوباره محل سرویس بهداشتی را بپرس.','گفت‌وگوی قبلی چهار عبارت ضروری و منبع‌دار را در یک موقعیت کوتاه بازیابی می‌کند.',@d_find_toilet,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-review-survival-dont-know',@l26,2,'multiple_choice','کدام عبارت یعنی «نمی‌دانم»؟','پاسخ کوتاه دوباره از خود پرسش مکان جدا می‌شود تا فهم مستقیم عبارت سنجیده شود.',NULL,JSON_OBJECT('options',JSON_ARRAY(
 JSON_OBJECT('textTarget','Ich weiß nicht.','translationFa','نمی‌دانم.','correct',TRUE),
 JSON_OBJECT('textTarget','Wo ist die Toilette?','translationFa','سرویس بهداشتی کجاست؟','correct',FALSE)
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-review-survival-help',@l26,3,'fill_blank','جمله را طوری کامل کن که معنی‌اش «کمک لازم دارم» باشد.','همان تمایز مهم بین درخواست کمک و نیاز خرید بعد از فاصلهٔ زمانی دوباره فعال می‌شود.',NULL,JSON_OBJECT(
 'sourceText','Ich brauche Hilfe.','sourceTextFa','من کمک لازم دارم.','blankedText','Ich brauche ___.','blankedTextFa','من ___ لازم دارم.',
 'choices',JSON_ARRAY('Hilfe','eine Hose'),'choicesFa',JSON_ARRAY('کمک','یک شلوار'),'answer','Hilfe'
),JSON_ARRAY('source_sentence_blank_created','options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-review-survival-mix',@l26,4,'review','هر عبارت را به کاربردی که قبلاً یاد گرفته‌ای ربط بده.','چهار عبارت ضروری در یک فعالیت ترکیب می‌شوند تا زبان‌آموز بین شروع مؤدبانه، پاسخ، پرسش مکان و درخواست کمک جابه‌جا شود.',NULL,JSON_OBJECT('items',JSON_ARRAY(
 JSON_OBJECT('textTarget','Entschuldigung!','translationFa','ببخشید!','categoryFa','شروع مؤدبانه'),
 JSON_OBJECT('textTarget','Bitte?','translationFa','بفرمایید؟','categoryFa','پاسخ به شروع مؤدبانه'),
 JSON_OBJECT('textTarget','Wo ist die Toilette?','translationFa','سرویس بهداشتی کجاست؟','categoryFa','پرسش مکان'),
 JSON_OBJECT('textTarget','Ich brauche Hilfe.','translationFa','من کمک لازم دارم.','categoryFa','درخواست کمک')
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),

('act-de-review-final-conversation',@l27,1,'conversation_speaking','گفت‌وگوی سفارش کوتاه را یک بار دیگر بدون راهنمای درس اصلی انجام بده.','استفادهٔ دوباره از گفت‌وگوی سفارش، شروع نهایی را کاربردی نگه می‌دارد و نیاز به ساختن صحنه یا جملهٔ تازه را از بین می‌برد.',@d_simple_order,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),NULL,'not_required'),
('act-de-review-final-domains',@l27,2,'matching','هر پرسش را به حوزهٔ درستش وصل کن.','چهار پرسش از چهار بخش دور از هم انتخاب شده‌اند تا زبان‌آموز مجبور شود کاربرد را از خود عبارت تشخیص دهد، نه از جایگاه آن در دوره.',NULL,JSON_OBJECT('pairMode','target_to_persian','pairs',JSON_ARRAY(
 JSON_OBJECT('left','Wie heißen Sie?','leftFa','اسمتان چیست؟','right','اطلاعات شخصی','rightFa','اطلاعات شخصی'),
 JSON_OBJECT('left','Was möchten Sie bitte?','leftFa','لطفاً چی میل دارید؟','right','سفارش','rightFa','سفارش'),
 JSON_OBJECT('left','Wie viel kostet das?','leftFa','این چقدر قیمت دارد؟','right','قیمت','rightFa','قیمت'),
 JSON_OBJECT('left','Wo ist die Toilette?','leftFa','سرویس بهداشتی کجاست؟','right','پرسش مکان','rightFa','پرسش مکان')
)),JSON_ARRAY('source_items_grouped_for_matching','persian_translation_added'),NULL,'not_required'),
('act-de-review-final-mixed-items',@l27,3,'review','چهار نمونهٔ دور از هم را بخوان و نوع اطلاعات یا کاربرد هرکدام را مشخص کن.','این مرحله دانسته‌های اجتماعی، زمانی، اطلاعات تماس و موقعیت ضروری را عمداً با هم مخلوط می‌کند تا بازیابی بین‌موضوعی انجام شود.',NULL,JSON_OBJECT('items',JSON_ARRAY(
 JSON_OBJECT('textTarget','Guten Morgen!','translationFa','صبح بخیر!','categoryFa','سلام صبحگاهی'),
 JSON_OBJECT('textTarget','Es ist 6.30 Uhr.','translationFa','ساعت ۶:۳۰ است.','categoryFa','ساعت'),
 JSON_OBJECT('textTarget','Meine Telefonnummer ist: 692-267-752.','translationFa','شماره تلفن من ۶۹۲-۲۶۷-۷۵۲ است.','categoryFa','شماره تلفن'),
 JSON_OBJECT('textTarget','Ich brauche Hilfe.','translationFa','من کمک لازم دارم.','categoryFa','درخواست کمک')
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-review-final-help-choice',@l27,4,'multiple_choice','کدام جمله درخواست کمک است؟','دو جمله با فعل یکسان دوباره مقایسه می‌شوند تا تفاوت موقعیت ضروری و نیاز خرید روشن بماند.',NULL,JSON_OBJECT('options',JSON_ARRAY(
 JSON_OBJECT('textTarget','Ich brauche Hilfe.','translationFa','من کمک لازم دارم.','correct',TRUE),
 JSON_OBJECT('textTarget','Ich brauche eine Hose.','translationFa','من یک شلوار لازم دارم.','correct',FALSE)
)),JSON_ARRAY('options_selected_from_source_material','persian_translation_added'),NULL,'not_required'),
('act-de-review-final-object-check',@l27,5,'true_false','درست یا غلط؟ «Was ist das?» یک پرسش اطلاعاتی ساده است.','این بررسی کوتاه یک هدف کوچک ولی مستقل از واحد اطلاعات شخصی را در پایان دوباره فعال می‌کند تا در مرورهای بزرگ‌تر گم نشود.',NULL,JSON_OBJECT('statementTarget','Was ist das?','statementFa','این یک پرسش اطلاعاتی ساده است.','answer',TRUE),JSON_ARRAY('persian_translation_added'),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),
 selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),
 audio_text_target=VALUES(audio_text_target);

-- The previous cumulative checkpoint now sits before the dedicated review unit.
UPDATE lessons
SET sequence_rationale='عبارت کمک ابتدا در تعامل و سپس به‌صورت شفاهی بازیابی می‌شود؛ بعد معنی واژهٔ کلیدی تثبیت می‌شود و آخرین فعالیت چهار کاربرد مهم از مسیر تا این نقطه را پیش از ورود به واحد مرور نهایی دوباره فعال می‌کند.'
WHERE lesson_key='de-pre-a1-lesson-need-help';
UPDATE activities
SET selection_reason='در پایان واحد موقعیت‌های ضروری و پیش از واحد مرور نهایی، یک بازیابی فاصله‌دار از چهار حوزهٔ جدا—اطلاعات شخصی، سفارش، قیمت و درخواست کمک—لازم است؛ همهٔ عبارت‌ها عین محتوای منبع‌دار قبلی‌اند.'
WHERE activity_key='act-de-pre-a1-final-review';

SET @t_review := (SELECT id FROM curriculum_targets WHERE language_level_id=@prea1 AND target_key='de.pre_a1.integrated_review' LIMIT 1);
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES (@u_review,@t_review);
INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id) VALUES
(@l23,@t_review),(@l24,@t_review),(@l25,@t_review),(@l26,@t_review),(@l27,@t_review);
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,@t_review FROM activities a WHERE a.lesson_id IN (@l23,@l24,@l25,@l26,@l27);

-- Provenance: each new review activity points only to already registered, reusable source items.
INSERT IGNORE INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity',a.activity_key,si.id,'options_selected_from_source_material','این فعالیت مرور فقط از عبارت‌های منبع‌دار قبلی استفاده می‌کند.'
FROM activities a
JOIN lessons l ON l.id=a.lesson_id
JOIN source_items si ON si.source_text IN (
 'Hallo!','Tschüss!','Danke!','Bitte!','Entschuldigung.','Kein Problem.','Guten Morgen!','Wie geht''s?','Gut.','Nein!',
 'Wie heißen Sie?','Wo wohnen Sie?','Wie alt sind Sie?','Welcher Tag ist heute?','Heute ist Dienstag.','Wie spät ist es?','Es ist 6.30 Uhr.',
 'Ich bin 20 Jahre alt.','Wann hast du Geburtstag?','Meine Telefonnummer ist: 692-267-752.','Was ist das?','Das ist ein Buch.',
 'Was gibt es heute?','Eine Tasse Kaffee bitte!','Was möchten Sie bitte?','Was brauchen Sie?','Ich brauche eine Hose.','Und was kaufen Sie?',
 'Ich kaufe ein Hemd und ein Paar Schuhe.','Das kostet 35 Euro und 15 Cent.','Das kostet 70 Euro und 92 Cent.','Wie viel kostet das?',
 'Ich weiß nicht.','Wo ist die Toilette?','Ich brauche Hilfe.','Entschuldigung!','Bitte?'
)
JOIN sources s ON s.id=si.source_id
WHERE l.id IN (@l23,@l24,@l25,@l26,@l27)
  AND s.modernity_status IN ('contemporary_verified','maintained_current')
  AND s.reuse_status IN ('direct_reuse_allowed','reuse_with_attribution');

UPDATE lessons SET status='final' WHERE id IN (@l23,@l24,@l25,@l26,@l27);

UPDATE language_levels
SET audio_status='ready',
    notes='سطح پیش از A1 آلمانی اکنون ۲۷ درس در ۵ واحد و ۱۱۱ فعالیت هدفمند دارد. واحد پنجم یک مرور تجمعی پنج‌درسی است که مطالب چهار واحد قبلی را در خوشه‌های کاربردی و سپس به‌صورت ترکیبی بازیابی می‌کند؛ هیچ متن آلمانی تازه‌ای برای این مرور ساخته نشده و دارایی‌های صوتی گفت‌وگو از دارایی‌های آمادهٔ قبلی بازاستفاده می‌شوند.'
WHERE id=@prea1;

COMMIT;

-- ===== END zzzzzzzzzzzzz-pre-a1-cumulative-review-unit-2026-09-19.sql =====
