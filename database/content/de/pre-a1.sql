
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
