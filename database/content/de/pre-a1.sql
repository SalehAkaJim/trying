-- German Pre-A1
-- Canonical runtime: MySQL 9.0.1
-- Requires database/schema.sql first.
-- Unit/lesson/activity sizing is coverage-driven. Opening dialogues follow the explicit 5–12 turn product rule.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

-- Language and level ---------------------------------------------------------
INSERT INTO languages (code,name_native,name_fa,status,standalone_audio_voice_name,standalone_audio_voice_id)
VALUES ('de','Deutsch','آلمانی','building',NULL,NULL)
ON DUPLICATE KEY UPDATE name_native=VALUES(name_native),name_fa=VALUES(name_fa),status=VALUES(status);
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
INSERT INTO language_levels (language_id,cefr_level,status,structure_rationale,coverage,notes) VALUES
(@de,'Pre-A1','building','سطح از ارتباط‌های بسیار ساده و فوری برای زبان‌آموز صفر شروع می‌شود و فقط وقتی گسترش پیدا می‌کند که پوشش CEFR، پیش‌نیازها یا نیاز به تمرین بیشتر آن را توجیه کند؛ تعداد درس یا واحد معیار تولید محتوا نیست.',JSON_OBJECT('communicativeTargets',JSON_ARRAY('سلام‌کردن دوستانه با «Hallo!»','شروع گفت‌وگوی صبحگاهی با «Guten Morgen!»','پرسیدن و پاسخ‌دادن دربارهٔ علاقه به یک غذای بسیار آشنا','استفاده و تشخیص پاسخ‌های کوتاه «ja» و «nein»','تشکر کوتاه و پاسخ مؤدبانه با «danke» و «bitte»','احوال‌پرسی بسیار ساده با «Wie geht''s?» و «Gut.»','خداحافظی ساده با «Tschüss!»'),'linguisticTargets',JSON_ARRAY('عبارت ثابت «hallo» برای سلام','عبارت ثابت «guten Morgen» برای صبح‌بخیر','فعل «mögen» در شکل‌های «mag» و «magst»','اسم آشنای «Pizza»','ذره‌های پاسخ «ja» و «nein»','عبارت‌های مؤدبانهٔ «danke» و «bitte»','عبارت «Wie geht''s?» و پاسخ کوتاه «Gut.»','عبارت خداحافظی «Tschüss!»'),'situations',JSON_ARRAY('اولین سلام ساده','شروع گفت‌وگو در صبح','پرسش و پاسخ ساده دربارهٔ علاقه به پیتزا','پاسخ مثبت و منفی در یک بافت آشنا','تشکر و پاسخ مؤدبانه','احوال‌پرسی و خداحافظی بسیار ساده'),'gaps',JSON_ARRAY('عبارت‌های مؤدبانهٔ بیشتر مانند «Entschuldigung»','پرسیدن و گفتن نام','خواستن و انتخاب‌کردن چیزهای ساده','مرور و بازیابی بیشتر در جاهایی که شواهد آموزشی نیاز نشان دهد')),'این فهرست فقط محتوایی است که تا این مرحله ساخته شده و به معنی تعداد هدف برای Pre-A1 نیست.')
ON DUPLICATE KEY UPDATE status=VALUES(status),structure_rationale=VALUES(structure_rationale),coverage=VALUES(coverage),notes=VALUES(notes);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);

-- Curriculum targets ---------------------------------------------------------
INSERT INTO curriculum_targets (language_level_id,target_key,target_type,title,description,required_for_completion,status,metadata) VALUES
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
(@level,'de.pre_a1.basic_wellbeing','communicative','احوال‌پرسی بسیار ساده','«Wie geht’s?» را بفهمد و با پاسخ کوتاه «Gut.» جواب دهد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),
(@level,'de.pre_a1.farewell_tschuess','communicative','خداحافظی ساده با «Tschüss!»','در پایان گفت‌وگوی دوستانه از «Tschüss!» استفاده کند.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE))
ON DUPLICATE KEY UPDATE target_type=VALUES(target_type),title=VALUES(title),description=VALUES(description),required_for_completion=VALUES(required_for_completion),status=VALUES(status),metadata=VALUES(metadata);
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

-- Modern reusable sources ----------------------------------------------------
INSERT INTO sources (source_key,title,organization_or_author,language_code,source_type,url,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wiktionary-de-hallo','Wiktionary: hallo','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/hallo',NULL,'maintained_current','مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده و فقط برای کاربرد معاصر سلام و هویت واژگانی استفاده می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/hallo','reuse_with_attribution','2026-09-16','منبع عبارت سلام «hallo».'),
('src-wiktionary-de-guten-morgen','Wiktionary: guten Morgen','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/guten_Morgen',NULL,'maintained_current','مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده و برای عبارت معاصر صبح‌بخیر استفاده می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/guten_Morgen','reuse_with_attribution','2026-09-16','منبع عبارت «guten Morgen».'),
('src-wiktionary-de-moegen','Wiktionary: mögen','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/m%C3%B6gen',NULL,'maintained_current','مدخل زنده و فعال Wiktionary آلمانی برای هویت واژگانی «mögen» و شکل‌های صرفی معاصر بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/m%C3%B6gen','reuse_with_attribution','2026-09-16','منبع «mögen» و شکل‌های «mag / magst».'),
('src-wiktionary-de-pizza','Wiktionary: Pizza','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/Pizza',NULL,'maintained_current','مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده و برای اسم معاصر «Pizza» استفاده می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/Pizza','reuse_with_attribution','2026-09-16','منبع اسم «Pizza».'),
('src-libra-de-ich-mag-pizza','Sprachstandsfeststellung Deutsch als Zweitsprache – Zusatzmodul Alphabetisierung','Landesinstitut Brandenburg für Schule und Lehrkräftebildung (LIBRA)','de','book','https://bildungsserver.berlin-brandenburg.de/fileadmin/bbb/themen/sprachbildung/Sprachfeststellungpruefung/Sprachstandsfeststellung_DaZ_Alphabetisierung_2025-03-20.pdf','2025-03-20','contemporary_verified','منبع رسمی آموزشی ایالت Brandenburg از سال ۲۰۲۵ است و برای کاربرد معاصر زبان‌آموزی بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Landesinstitut Brandenburg für Schule und Lehrkräftebildung (LIBRA), Sprachstandsfeststellung Deutsch als Zweitsprache – Zusatzmodul Alphabetisierung, p. 12','reuse_with_attribution','2026-09-16','منبع رسمی جملهٔ دقیق «Ich mag Pizza.».'),
('src-wikibooks-de-magst-du-pizza','Wikibooks example containing Magst du Pizza?','Wikibooks contributors','de','book','https://de.wikibooks.org/wiki/Ungarisch/Ungarisch-Lesebuch-h%C3%A4ufigeW%C3%B6rter/012',NULL,'maintained_current','صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده و پرسش آلمانی مورد استفاده با زبان معیار معاصر سازگار است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — https://de.wikibooks.org/wiki/Ungarisch/Ungarisch-Lesebuch-h%C3%A4ufigeW%C3%B6rter/012','reuse_with_attribution','2026-09-16','فقط پرسش منبع‌دار «Magst du Pizza?» استفاده می‌شود.'),
('src-wiktionary-de-ja','Wiktionary: ja','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/ja',NULL,'maintained_current','مدخل زنده و فعال Wiktionary برای پاسخ مثبت معاصر «ja» بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/ja','reuse_with_attribution','2026-09-16','منبع پاسخ مثبت «ja».'),
('src-wiktionary-de-nein','Wiktionary: nein','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/nein',NULL,'maintained_current','مدخل زنده و فعال Wiktionary برای پاسخ منفی معاصر «nein» بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/nein','reuse_with_attribution','2026-09-16','منبع پاسخ منفی «nein».'),
('src-wiktionary-de-danke','Wiktionary: danke','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/danke',NULL,'maintained_current','مدخل زنده و فعال Wiktionary برای عبارت تشکر معاصر «danke» بررسی شده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/danke','reuse_with_attribution','2026-09-16','منبع عبارت تشکر «danke».'),
('src-wiktionary-de-bitte','Wiktionary: bitte','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/bitte',NULL,'maintained_current','مدخل زنده و فعال Wiktionary در وضعیت فعلی بررسی شده است؛ در این پروژه فقط کاربرد «خواهش می‌کنم» در پاسخ به تشکر استفاده می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/bitte','reuse_with_attribution','2026-09-16','در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود.'),
('src-wikibooks-de-basic-greetings','Wikibooks: German/Print version — basic greetings and wellbeing','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Print_version',NULL,'maintained_current','صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده و عبارت‌های پایهٔ سلام، احوال‌پرسی و خداحافظی آن با کاربرد معاصر سازگارند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — https://en.wikibooks.org/wiki/German/Print_version','reuse_with_attribution','2026-09-16','برای عبارت‌های «Wie geht’s?»، پاسخ کوتاه «Gut.» و «Tschüss!» استفاده می‌شود.')
ON DUPLICATE KEY UPDATE title=VALUES(title),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
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

INSERT INTO source_items (source_id,item_key,locator,source_text,source_text_hash,notes) VALUES
(@s_hallo,'srcitem-de-hallo-headword','German greeting formula','hallo',UNHEX(SHA2('hallo',256)),'عبارت سلام معاصر.'),
(@s_gm,'srcitem-de-guten-morgen-formula','German greeting formula','guten Morgen',UNHEX(SHA2('guten Morgen',256)),'عبارت صبح‌بخیر معاصر.'),
(@s_moegen,'srcitem-de-moegen-lemma','German verb lemma','mögen',UNHEX(SHA2('mögen',256)),'صورت پایهٔ فعل.'),
(@s_moegen,'srcitem-de-moegen-mag','Present form','mag',UNHEX(SHA2('mag',256)),'شکل صرفی حال.'),
(@s_moegen,'srcitem-de-moegen-magst','Present form','magst',UNHEX(SHA2('magst',256)),'شکل صرفی حال.'),
(@s_pizza,'srcitem-de-pizza-headword','German noun','Pizza',UNHEX(SHA2('Pizza',256)),'اسم آشنای غذا.'),
(@s_libra,'srcitem-de-ich-mag-pizza','p. 12, Alphabetisierung – Vorlesen, Aufgabe 3a','Ich mag Pizza.',UNHEX(SHA2('Ich mag Pizza.',256)),'جملهٔ دقیق منبع.'),
(@s_pq,'srcitem-de-magst-du-pizza','German examples under igen, item 8','Magst du Pizza?',UNHEX(SHA2('Magst du Pizza?',256)),'پرسش دقیق منبع.'),
(@s_ja,'srcitem-de-ja-headword','German affirmative response particle','ja',UNHEX(SHA2('ja',256)),'پاسخ مثبت.'),
(@s_nein,'srcitem-de-nein-headword','German negative response particle','nein',UNHEX(SHA2('nein',256)),'پاسخ منفی.'),
(@s_danke,'srcitem-de-danke-headword','German expression of thanks','danke',UNHEX(SHA2('danke',256)),'تشکر کوتاه.'),
(@s_bitte,'srcitem-de-bitte-response','Meaning [2]: response to thanks','bitte',UNHEX(SHA2('bitte',256)),'پاسخ مؤدبانه به تشکر.'),
(@s_basic,'srcitem-de-wie-gehts','Basic conversation: How is it going?','Wie geht''s?',UNHEX(SHA2('Wie geht''s?',256)),'پرسش کوتاه احوال‌پرسی.'),
(@s_basic,'srcitem-de-gut-short','Replies to Wie geht''s? — even shorter response','Gut.',UNHEX(SHA2('Gut.',256)),'پاسخ کوتاه احوال‌پرسی.'),
(@s_basic,'srcitem-de-tschuess','Informal goodbye / Bye!','Tschüss!',UNHEX(SHA2('Tschüss!',256)),'خداحافظی دوستانه.')
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

-- Characters -----------------------------------------------------------------
INSERT INTO characters (character_key,language_id,name,origin,gender,age_band,roles,relationship_tags,context_notes,voice_profile,elevenlabs_voice_id,voice_name) VALUES
('char-de-learner',@de,'زبان‌آموز','app_created','unspecified','unspecified',JSON_ARRAY('learner'),JSON_ARRAY(),'نقش عمومی زبان‌آموز؛ برای صحنه‌های فعلی هیچ فرض جمعیت‌شناختی لازم نیست.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression',NULL,'genderImpression','neutral'),NULL,NULL),
('char-de-mia',@de,'Mia','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY(),'شخصیت گفت‌وگویی دوستانه و تکرارشونده؛ جمله‌های منبع فعلی با این هویت اختصاص‌داده‌شده تعارض ندارند.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young adult','genderImpression','female'),NULL,NULL)
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),name=VALUES(name),origin=VALUES(origin),gender=VALUES(gender),age_band=VALUES(age_band),roles=VALUES(roles),relationship_tags=VALUES(relationship_tags),context_notes=VALUES(context_notes),voice_profile=VALUES(voice_profile);
SET @learner := (SELECT id FROM characters WHERE character_key='char-de-learner');
SET @mia := (SELECT id FROM characters WHERE character_key='char-de-mia');

-- Unit and lessons ------------------------------------------------------------
INSERT INTO units (unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes) VALUES
('de-pre-a1-unit-first-steps',@level,1,'اولین قدم‌ها','این درس‌ها کنار هم قرار گرفته‌اند چون همگی ارتباط‌های بسیار ساده، فوری و کم‌فشار برای شروع از صفر هستند. این گروه‌بندی دلیل آموزشی دارد و ظرفیت عددی برای تعداد درس ندارد.','draft',JSON_OBJECT('dynamicStructure',TRUE),'باز یا بسته‌ماندن این واحد فقط به تصمیم‌های پوشش آموزشی بعدی بستگی دارد، نه به رسیدن به تعداد مشخصی درس.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=VALUES(status),metadata=VALUES(metadata),notes=VALUES(notes);
SET @unit := (SELECT id FROM units WHERE unit_key='de-pre-a1-unit-first-steps');
INSERT INTO lessons (lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes) VALUES
('de-pre-a1-lesson-hallo',@level,@unit,1,1,'سلام!','hallo / Wie geht''s? / Gut. / Tschüss!','draft','گفت‌وگوی آغازین خودش چرخهٔ کامل سلام، احوال‌پرسی بسیار کوتاه و خداحافظی را تمرین می‌کند؛ در این مرحله فعالیت اضافه‌ای لازم نیست.','زبان‌آموز از همان ابتدا در یک گفت‌وگوی خیلی ساده شرکت می‌کند و عبارت‌ها را در بافت می‌بیند.','conversation_speaking','blocked_until_language_final',NULL),
('de-pre-a1-lesson-guten-morgen',@level,@unit,2,2,'صبح بخیر!','guten Morgen','draft','پس از شروع‌کردن گفت‌وگو با سلام صبحگاهی، یک فعالیت تشخیصی تفاوت آن را با سلام عمومی تثبیت می‌کند.','اول زبان‌آموز خودش مکالمه را با عبارت صبحگاهی آغاز می‌کند و بعد زمان مناسب استفاده از آن را تشخیص می‌دهد.','conversation_speaking>multiple_choice','blocked_until_language_final',NULL),
('de-pre-a1-lesson-pizza-like',@level,@unit,3,3,'پیتزا دوست دارم','Magst du Pizza? / Ich mag Pizza.','draft','گفت‌وگو پرسش و پاسخ دربارهٔ علاقه به پیتزا را در بافت قرار می‌دهد و سپس بازسازی همان جمله یک بازیابی متمرکز ایجاد می‌کند.','اول زبان‌آموز در مکالمه به پرسش واقعی پاسخ می‌دهد و بعد همان جملهٔ منبع‌دار را دوباره می‌سازد.','conversation_speaking>word_order','blocked_until_language_final',NULL),
('de-pre-a1-lesson-ja-nein',@level,@unit,4,4,'بله یا نه؟','Magst du Pizza? / ja / nein','draft','مکالمه این بار با زبان‌آموز شروع می‌شود تا سؤال آشنا را فعالانه بپرسد؛ سپس انتخاب پاسخ تفاوت «ja» و «nein» را تمرین می‌کند.','اول زبان‌آموز نقش آغازکننده و پرسشگر را می‌گیرد، سپس پاسخ مثبت و منفی را در همان بافت تشخیص می‌دهد.','conversation_speaking>choose_response','blocked_until_language_final',NULL),
('de-pre-a1-lesson-danke-bitte',@level,@unit,5,5,'ممنون! خواهش می‌کنم','danke / bitte','draft','گفت‌وگو عبارت تشکر و پاسخ مؤدبانه را داخل یک تعامل کامل از سلام تا خداحافظی قرار می‌دهد و برای این هدف تمرین اضافه لازم نیست.','زبان‌آموز تشکر را در بافت می‌شنود، پاسخ مؤدبانه می‌دهد و مکالمه را طبیعی تمام می‌کند.','conversation_speaking','blocked_until_language_final',NULL)
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),audio_status=VALUES(audio_status),notes=VALUES(notes);
SET @l1 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-hallo');
SET @l2 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-guten-morgen');
SET @l3 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-pizza-like');
SET @l4 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-ja-nein');
SET @l5 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-danke-bitte');
INSERT INTO unit_targets (unit_id,curriculum_target_id) VALUES
(@unit,@t_hallo),(@unit,@t_wellbeing),(@unit,@t_bye),(@unit,@t_gm),(@unit,@t_gm_diff),(@unit,@t_pq),(@unit,@t_pa),(@unit,@t_forms),(@unit,@t_ja),(@unit,@t_nein),(@unit,@t_danke),(@unit,@t_bitte)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id);
INSERT INTO lesson_targets (lesson_id,curriculum_target_id,coverage_role) VALUES
(@l1,@t_hallo,'introduce'),(@l1,@t_wellbeing,'introduce'),(@l1,@t_bye,'introduce'),
(@l2,@t_gm,'introduce'),(@l2,@t_gm_diff,'practice'),(@l2,@t_wellbeing,'review'),(@l2,@t_bye,'review'),
(@l3,@t_pq,'introduce'),(@l3,@t_pa,'introduce'),(@l3,@t_forms,'support'),(@l3,@t_bye,'review'),
(@l4,@t_ja,'introduce'),(@l4,@t_nein,'practice'),(@l4,@t_pq,'review'),(@l4,@t_bye,'review'),
(@l5,@t_danke,'introduce'),(@l5,@t_bitte,'introduce'),(@l5,@t_bye,'review')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id);

-- Dialogues and turns ---------------------------------------------------------
INSERT INTO dialogues (dialogue_key,language_level_id,scenario,scene_quality_rationale) VALUES
('dlg-de-pre-a1-hallo',@level,'میا و زبان‌آموز با یک سلام ساده شروع می‌کنند، یک احوال‌پرسی خیلی کوتاه دارند و خداحافظی می‌کنند.','صحنه یک تعامل کامل و بسیار ساده از سلام تا احوال‌پرسی و خداحافظی است و بدون اضافه‌کردن جملهٔ ساختگی، در بازهٔ تعیین‌شدهٔ مکالمه قرار می‌گیرد.'),
('dlg-de-pre-a1-guten-morgen',@level,'صبح است و این بار زبان‌آموز گفت‌وگو را شروع می‌کند؛ بعد یک احوال‌پرسی کوتاه و خداحافظی انجام می‌شود.','زبان‌آموز نقش آغازکننده را می‌گیرد تا سلام صبحگاهی را فعالانه تولید کند و صحنه با احوال‌پرسی و خداحافظی ساده کامل می‌شود.'),
('dlg-de-pre-a1-pizza-like',@level,'میا و زبان‌آموز سلام می‌کنند، دربارهٔ دوست‌داشتن پیتزا صحبت می‌کنند و در پایان خداحافظی می‌کنند.','پرسش و پاسخ دربارهٔ پیتزا داخل یک دیدار کوتاه و کامل قرار گرفته و همهٔ جمله‌های آلمانی به منبع قابل‌ردیابی متصل‌اند.'),
('dlg-de-pre-a1-ja',@level,'این بار زبان‌آموز خودش سلام می‌کند و سؤال آشنای پیتزا را می‌پرسد؛ میا پاسخ می‌دهد و گفت‌وگو با خداحافظی تمام می‌شود.','زبان‌آموز از نقش پاسخ‌دهنده خارج می‌شود و خودش مکالمه و پرسش را آغاز می‌کند؛ زبان جدید ساختگی اضافه نشده و جمله‌ها از مواد منبع‌دار قبلی بازیابی می‌شوند.'),
('dlg-de-pre-a1-danke-bitte',@level,'میا و زبان‌آموز سلام می‌کنند؛ بعد از یک کمک کوچک میا تشکر می‌کند، زبان‌آموز پاسخ مؤدبانه می‌دهد و در پایان خداحافظی می‌کنند.','تشکر و پاسخ مؤدبانه داخل یک تعامل کامل و کوتاه قرار گرفته‌اند و صحنه بدون وابستگی به تصویر یا جملهٔ ساختگی قابل اجراست.')
ON DUPLICATE KEY UPDATE language_level_id=VALUES(language_level_id),scenario=VALUES(scenario),scene_quality_rationale=VALUES(scene_quality_rationale);
SET @d1 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-hallo');
SET @d2 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-guten-morgen');
SET @d3 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-pizza-like');
SET @d4 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-ja');
SET @d5 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-danke-bitte');
DELETE FROM lexeme_occurrences WHERE owner_type='dialogue_turn' AND owner_key LIKE 'turn-de-%';
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key LIKE 'turn-de-%';
DELETE FROM dialogue_turns WHERE dialogue_id IN (@d1,@d2,@d3,@d4,@d5);
INSERT INTO dialogue_turns (turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,text_target,translation_fa,learner_turn,audio_status,audio_url,elevenlabs_voice_id) VALUES
('turn-de-hallo-1',@d1,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-hallo-2',@d1,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-hallo-3',@d1,3,@mia,'app_assigned','unspecified','Wie geht''s?','حالت چطوره؟',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-hallo-4',@d1,4,@learner,'app_assigned','unspecified','Gut.','خوبم.',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-hallo-5',@d1,5,@mia,'app_assigned','unspecified','Tschüss!','خداحافظ!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-hallo-6',@d1,6,@learner,'app_assigned','unspecified','Tschüss!','خداحافظ!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-gm-1',@d2,1,@learner,'app_assigned','unspecified','Guten Morgen!','صبح بخیر!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-gm-2',@d2,2,@mia,'app_assigned','unspecified','Guten Morgen!','صبح بخیر!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-gm-3',@d2,3,@mia,'app_assigned','unspecified','Wie geht''s?','حالت چطوره؟',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-gm-4',@d2,4,@learner,'app_assigned','unspecified','Gut.','خوبم.',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-gm-5',@d2,5,@mia,'app_assigned','unspecified','Tschüss!','خداحافظ!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-gm-6',@d2,6,@learner,'app_assigned','unspecified','Tschüss!','خداحافظ!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-1',@d3,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-2',@d3,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-3',@d3,3,@mia,'app_assigned','unspecified','Magst du Pizza?','پیتزا دوست داری؟',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-4',@d3,4,@learner,'app_assigned','unspecified','Ich mag Pizza.','من پیتزا دوست دارم.',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-5',@d3,5,@mia,'app_assigned','unspecified','Ich mag Pizza.','من هم پیتزا دوست دارم.',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-6',@d3,6,@mia,'app_assigned','unspecified','Tschüss!','خداحافظ!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-pizza-7',@d3,7,@learner,'app_assigned','unspecified','Tschüss!','خداحافظ!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-1',@d4,1,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-2',@d4,2,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-3',@d4,3,@learner,'app_assigned','unspecified','Magst du Pizza?','پیتزا دوست داری؟',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-4',@d4,4,@mia,'app_assigned','unspecified','Ja!','بله!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-5',@d4,5,@mia,'app_assigned','unspecified','Ich mag Pizza.','من پیتزا دوست دارم.',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-6',@d4,6,@learner,'app_assigned','unspecified','Ich mag Pizza.','من هم پیتزا دوست دارم.',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-7',@d4,7,@mia,'app_assigned','unspecified','Tschüss!','خداحافظ!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-ja-8',@d4,8,@learner,'app_assigned','unspecified','Tschüss!','خداحافظ!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-danke-bitte-1',@d5,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-danke-bitte-2',@d5,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-danke-bitte-3',@d5,3,@mia,'app_assigned','unspecified','Danke!','ممنون!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-danke-bitte-4',@d5,4,@learner,'app_assigned','unspecified','Bitte!','خواهش می‌کنم!',TRUE,'blocked_until_language_final',NULL,NULL),
('turn-de-danke-bitte-5',@d5,5,@mia,'app_assigned','unspecified','Tschüss!','خداحافظ!',FALSE,'blocked_until_language_final',NULL,NULL),
('turn-de-danke-bitte-6',@d5,6,@learner,'app_assigned','unspecified','Tschüss!','خداحافظ!',TRUE,'blocked_until_language_final',NULL,NULL);

-- Activities ------------------------------------------------------------------
INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_status) VALUES
('act-de-hallo-conversation',@l1,1,'conversation_speaking','با میا یک گفت‌وگوی خیلی ساده را از سلام تا خداحافظی انجام بده.','هدف درس یک تعامل گفتاری پایه است و خود مکالمه تمرین اصلی و کافی این مرحله را فراهم می‌کند.',@d1,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language'),
('act-de-gm-conversation',@l2,1,'conversation_speaking','این بار تو گفت‌وگو را شروع کن؛ صبح است، به میا «Guten Morgen!» بگو.','شروع‌کردن مکالمه توسط زبان‌آموز باعث می‌شود سلام صبحگاهی را فعالانه تولید کند، نه فقط به آن پاسخ بدهد.',@d2,JSON_OBJECT('interaction','read_aloud_exchange','contextFa','صبح است.','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language'),
('act-de-gm-choice',@l2,2,'multiple_choice','برای سلام کردن در صبح کدام عبارت مناسب‌تر است؟','این فعالیت فقط تفاوت جدید درس را می‌سنجد: سلام مخصوص صبح در برابر سلام عمومی.',NULL,JSON_OBJECT('promptFa','صبح است.','options',JSON_ARRAY(JSON_OBJECT('textTarget','Guten Morgen!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-guten-morgen')),JSON_OBJECT('textTarget','Hallo!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-hallo')))),JSON_ARRAY('options_selected_from_source_material'),'pending_final_language'),
('act-de-pizza-conversation',@l3,1,'conversation_speaking','با میا دربارهٔ پیتزا یک گفت‌وگوی کوتاه داشته باش و به سؤالش جواب بده.','موضوع آشنای پیتزا امکان استفادهٔ فوری و قابل‌فهم از «mögen» را فراهم می‌کند.',@d3,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language'),
('act-de-pizza-word-order',@l3,2,'word_order','جمله‌ای را که همین الان گفتی دوباره بساز.','بازسازی همان جملهٔ منبع‌دار، الگوی جدید را بدون واردکردن زبان تازه تقویت می‌کند.',NULL,JSON_OBJECT('sourceText','Ich mag Pizza.','tokens',JSON_ARRAY('Ich','mag','Pizza.'),'answer',JSON_ARRAY('Ich','mag','Pizza.'),'tokenLexemeMappings',JSON_ARRAY(JSON_OBJECT('token','mag','lexemeId','lex-de-moegen','lexemeFormId','lexform-de-moegen-mag'),JSON_OBJECT('token','Pizza.','lexemeId','lex-de-pizza','lexemeFormId',NULL))),JSON_ARRAY('sentence_tokenized_for_word_order'),'pending_final_language'),
('act-de-ja-conversation',@l4,1,'conversation_speaking','این بار تو مکالمه را شروع کن؛ سلام کن و سؤال آشنای پیتزا را از میا بپرس.','شروع مکالمه توسط زبان‌آموز، زبان آشنای قبلی را از حالت پاسخ‌دادن به تولید فعال تبدیل می‌کند.',@d4,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','learner'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language'),
('act-de-ja-nein-choice',@l4,2,'choose_response','فرض کن پیتزا دوست نداری. کدام جواب مناسب است؟','چون پرسش از قبل آشناست، تمرکز فعالیت فقط روی تشخیص پاسخ مثبت و منفی می‌ماند.',NULL,JSON_OBJECT('promptTarget','Magst du Pizza?','contextFa','پیتزا دوست نداری.','options',JSON_ARRAY(JSON_OBJECT('textTarget','Ja!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-ja')),JSON_OBJECT('textTarget','Nein!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-nein')))),JSON_ARRAY('options_selected_from_source_material'),'pending_final_language'),
('act-de-danke-bitte-conversation',@l5,1,'conversation_speaking','میا بعد از یک کمک کوچک تشکر می‌کند؛ پاسخ مؤدبانه بده و گفت‌وگو را تا خداحافظی ادامه بده.','«Danke!» و «Bitte!» در یک تعامل روزمره و کامل بهتر از دو کارت جداگانه یاد گرفته می‌شوند.',@d5,JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),JSON_ARRAY('persian_translation_added','character_metadata_added'),'pending_final_language')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_status=VALUES(audio_status);
SET @a1 := (SELECT id FROM activities WHERE activity_key='act-de-hallo-conversation');
SET @a2 := (SELECT id FROM activities WHERE activity_key='act-de-gm-conversation');
SET @a3 := (SELECT id FROM activities WHERE activity_key='act-de-gm-choice');
SET @a4 := (SELECT id FROM activities WHERE activity_key='act-de-pizza-conversation');
SET @a5 := (SELECT id FROM activities WHERE activity_key='act-de-pizza-word-order');
SET @a6 := (SELECT id FROM activities WHERE activity_key='act-de-ja-conversation');
SET @a7 := (SELECT id FROM activities WHERE activity_key='act-de-ja-nein-choice');
SET @a8 := (SELECT id FROM activities WHERE activity_key='act-de-danke-bitte-conversation');
INSERT INTO activity_targets (activity_id,curriculum_target_id) VALUES
(@a1,@t_hallo),(@a1,@t_wellbeing),(@a1,@t_bye),(@a2,@t_gm),(@a2,@t_wellbeing),(@a2,@t_bye),(@a3,@t_gm_diff),(@a4,@t_pq),(@a4,@t_pa),(@a4,@t_bye),(@a5,@t_pa),(@a5,@t_forms),(@a6,@t_pq),(@a6,@t_ja),(@a6,@t_bye),(@a7,@t_nein),(@a8,@t_danke),(@a8,@t_bitte),(@a8,@t_bye)
ON DUPLICATE KEY UPDATE activity_id=VALUES(activity_id);

-- Lexemes and forms -----------------------------------------------------------
INSERT INTO lexemes (lexeme_key,language_id,lexeme_type,surface,normalized_surface,lemma,part_of_speech,cefr_level,translation_fa,usage_note_fa,flashcard_eligible,audio_status,audio_url,audio_voice_name,audio_voice_id) VALUES
('lex-de-hallo',@de,'word','hallo','hallo','hallo','interjection','Pre-A1','سلام','برای سلام‌کردن دوستانه و عمومی.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-guten-morgen',@de,'phrase','guten Morgen','guten morgen',NULL,'greeting_formula','Pre-A1','صبح بخیر','برای سلام‌کردن در صبح.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-moegen',@de,'word','mögen','mögen','mögen','verb','Pre-A1','دوست داشتن / خوش آمدن',NULL,TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-pizza',@de,'word','Pizza','pizza','Pizza','noun','Pre-A1','پیتزا',NULL,TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-ja',@de,'word','ja','ja','ja','response_particle','Pre-A1','بله','برای پاسخ مثبت و موافقت.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-nein',@de,'word','nein','nein','nein','response_particle','Pre-A1','نه','برای پاسخ منفی.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-danke',@de,'word','danke','danke','danke','interjection_response_particle','Pre-A1','ممنون / متشکرم','برای تشکر کوتاه و روزمره.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-bitte',@de,'word','bitte','bitte','bitte','adverb_response_particle','Pre-A1','خواهش می‌کنم / لطفاً','در این درس به معنی «خواهش می‌کنم» در پاسخ به تشکر استفاده می‌شود.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-wie-gehts',@de,'phrase','wie geht''s','wie geht''s',NULL,'greeting_formula','Pre-A1','حالت چطوره؟','برای احوال‌پرسی دوستانه و خیلی کوتاه.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-gut',@de,'word','gut','gut','gut','adjective_response','Pre-A1','خوب','در این مرحله «Gut.» به‌عنوان پاسخ کوتاه به احوال‌پرسی استفاده می‌شود.',TRUE,'blocked_until_language_final',NULL,NULL,NULL),
('lex-de-tschuess',@de,'word','tschüss','tschüss','tschüss','farewell_formula','Pre-A1','خداحافظ / فعلاً','برای خداحافظی دوستانه و غیررسمی.',TRUE,'blocked_until_language_final',NULL,NULL,NULL)
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),lexeme_type=VALUES(lexeme_type),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),lemma=VALUES(lemma),part_of_speech=VALUES(part_of_speech),cefr_level=VALUES(cefr_level),translation_fa=VALUES(translation_fa),usage_note_fa=VALUES(usage_note_fa),flashcard_eligible=VALUES(flashcard_eligible),audio_status=VALUES(audio_status);
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
INSERT INTO lexeme_forms (lexeme_form_key,lexeme_id,surface,normalized_surface,form_type,features,origin,review_status,notes) VALUES
('lexform-de-moegen-mag',@x_moegen,'mag','mag','inflected',JSON_OBJECT('tense','present','mood','indicative','person',JSON_ARRAY('1','3'),'number','singular'),'reference_attested','approved','در جملهٔ منبع‌دار «Ich mag Pizza.» به‌صورت اول‌شخص مفرد استفاده شده است.'),
('lexform-de-moegen-magst',@x_moegen,'magst','magst','inflected',JSON_OBJECT('tense','present','mood','indicative','person','2','number','singular'),'reference_attested','approved','در پرسش منبع‌دار «Magst du Pizza?» به‌صورت دوم‌شخص مفرد استفاده شده است.')
ON DUPLICATE KEY UPDATE lexeme_id=VALUES(lexeme_id),surface=VALUES(surface),normalized_surface=VALUES(normalized_surface),form_type=VALUES(form_type),features=VALUES(features),origin=VALUES(origin),review_status=VALUES(review_status),notes=VALUES(notes);
SET @f_mag := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-mag');
SET @f_magst := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-magst');
INSERT INTO lesson_lexemes (lesson_id,lexeme_id,is_primary,role) VALUES
(@l1,@x_hallo,TRUE,'introduce'),(@l1,@x_wiegehts,TRUE,'introduce'),(@l1,@x_gut,FALSE,'support'),(@l1,@x_tschuess,FALSE,'support'),
(@l2,@x_gm,TRUE,'introduce'),(@l2,@x_hallo,TRUE,'introduce'),(@l2,@x_wiegehts,FALSE,'support'),(@l2,@x_gut,FALSE,'support'),(@l2,@x_tschuess,FALSE,'support'),
(@l3,@x_hallo,TRUE,'introduce'),(@l3,@x_moegen,TRUE,'introduce'),(@l3,@x_pizza,FALSE,'support'),(@l3,@x_ja,FALSE,'support'),(@l3,@x_tschuess,FALSE,'support'),
(@l4,@x_hallo,TRUE,'introduce'),(@l4,@x_moegen,TRUE,'introduce'),(@l4,@x_pizza,FALSE,'support'),(@l4,@x_ja,FALSE,'support'),(@l4,@x_nein,FALSE,'support'),(@l4,@x_tschuess,FALSE,'support'),
(@l5,@x_hallo,TRUE,'introduce'),(@l5,@x_danke,TRUE,'introduce'),(@l5,@x_bitte,FALSE,'support'),(@l5,@x_tschuess,FALSE,'support')
ON DUPLICATE KEY UPDATE is_primary=VALUES(is_primary),role=VALUES(role);
INSERT INTO activity_lexemes (activity_id,lexeme_id) VALUES
(@a1,@x_hallo),(@a1,@x_wiegehts),(@a1,@x_gut),(@a1,@x_tschuess),
(@a2,@x_gm),(@a2,@x_wiegehts),(@a2,@x_gut),(@a2,@x_tschuess),(@a3,@x_gm),(@a3,@x_hallo),
(@a4,@x_hallo),(@a4,@x_moegen),(@a4,@x_pizza),(@a4,@x_ja),(@a4,@x_tschuess),(@a5,@x_moegen),(@a5,@x_pizza),
(@a6,@x_hallo),(@a6,@x_moegen),(@a6,@x_pizza),(@a6,@x_ja),(@a6,@x_tschuess),(@a7,@x_ja),(@a7,@x_nein),
(@a8,@x_hallo),(@a8,@x_danke),(@a8,@x_bitte),(@a8,@x_tschuess)
ON DUPLICATE KEY UPDATE activity_id=VALUES(activity_id);

-- Occurrence resolution -------------------------------------------------------
INSERT INTO lexeme_occurrences (occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-turn-de-hallo-1-1','dialogue_turn','turn-de-hallo-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-hallo-2-1','dialogue_turn','turn-de-hallo-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-hallo-3-1','dialogue_turn','turn-de-hallo-3','Wie geht''s',NULL,NULL,@x_wiegehts,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-hallo-4-1','dialogue_turn','turn-de-hallo-4','Gut',NULL,NULL,@x_gut,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-hallo-5-1','dialogue_turn','turn-de-hallo-5','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-hallo-6-1','dialogue_turn','turn-de-hallo-6','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-1-1','dialogue_turn','turn-de-gm-1','Guten Morgen',NULL,NULL,@x_gm,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-2-1','dialogue_turn','turn-de-gm-2','Guten Morgen',NULL,NULL,@x_gm,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-3-1','dialogue_turn','turn-de-gm-3','Wie geht''s',NULL,NULL,@x_wiegehts,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-4-1','dialogue_turn','turn-de-gm-4','Gut',NULL,NULL,@x_gut,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-5-1','dialogue_turn','turn-de-gm-5','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-gm-6-1','dialogue_turn','turn-de-gm-6','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-1-1','dialogue_turn','turn-de-pizza-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-2-1','dialogue_turn','turn-de-pizza-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-3-1','dialogue_turn','turn-de-pizza-3','Magst',NULL,NULL,@x_moegen,@f_magst,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-3-2','dialogue_turn','turn-de-pizza-3','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-4-1','dialogue_turn','turn-de-pizza-4','mag',NULL,NULL,@x_moegen,@f_mag,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-4-2','dialogue_turn','turn-de-pizza-4','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-5-1','dialogue_turn','turn-de-pizza-5','mag',NULL,NULL,@x_moegen,@f_mag,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-5-2','dialogue_turn','turn-de-pizza-5','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-6-1','dialogue_turn','turn-de-pizza-6','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-pizza-7-1','dialogue_turn','turn-de-pizza-7','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-1-1','dialogue_turn','turn-de-ja-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-2-1','dialogue_turn','turn-de-ja-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-3-1','dialogue_turn','turn-de-ja-3','Magst',NULL,NULL,@x_moegen,@f_magst,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-3-2','dialogue_turn','turn-de-ja-3','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-4-1','dialogue_turn','turn-de-ja-4','Ja',NULL,NULL,@x_ja,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-5-1','dialogue_turn','turn-de-ja-5','mag',NULL,NULL,@x_moegen,@f_mag,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-5-2','dialogue_turn','turn-de-ja-5','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-6-1','dialogue_turn','turn-de-ja-6','mag',NULL,NULL,@x_moegen,@f_mag,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-6-2','dialogue_turn','turn-de-ja-6','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-7-1','dialogue_turn','turn-de-ja-7','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-ja-8-1','dialogue_turn','turn-de-ja-8','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-danke-bitte-1-1','dialogue_turn','turn-de-danke-bitte-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-danke-bitte-2-1','dialogue_turn','turn-de-danke-bitte-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-danke-bitte-3-1','dialogue_turn','turn-de-danke-bitte-3','Danke',NULL,NULL,@x_danke,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-danke-bitte-4-1','dialogue_turn','turn-de-danke-bitte-4','Bitte',NULL,NULL,@x_bitte,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-danke-bitte-5-1','dialogue_turn','turn-de-danke-bitte-5','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-turn-de-danke-bitte-6-1','dialogue_turn','turn-de-danke-bitte-6','Tschüss',NULL,NULL,@x_tschuess,NULL,'approved','اتصال occurrence به lexeme در QA تأیید شده است.'),
('occ-act-de-pizza-order-mag','activity','act-de-pizza-word-order','mag',NULL,NULL,@x_moegen,@f_mag,'approved','توکن صرف‌شده به «mögen» متصل است.'),
('occ-act-de-pizza-order-pizza','activity','act-de-pizza-word-order','Pizza.',NULL,NULL,@x_pizza,NULL,'approved','توکن با نشانه‌گذاری به «Pizza» متصل است.'),
('occ-act-de-ja-nein-ja','activity','act-de-ja-nein-choice','Ja!',NULL,NULL,@x_ja,NULL,'approved','گزینه به «ja» متصل است.'),
('occ-act-de-ja-nein-nein','activity','act-de-ja-nein-choice','Nein!',NULL,NULL,@x_nein,NULL,'approved','گزینه به «nein» متصل است.')
ON DUPLICATE KEY UPDATE owner_type=VALUES(owner_type),owner_key=VALUES(owner_key),surface=VALUES(surface),start_offset=VALUES(start_offset),end_offset=VALUES(end_offset),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

-- Provenance ------------------------------------------------------------------
DELETE FROM provenance_links WHERE entity_type IN ('lesson','dialogue','dialogue_turn','activity','lexeme','lexeme_form') AND (entity_key LIKE 'de-pre-a1-%' OR entity_key LIKE 'dlg-de-pre-a1-%' OR entity_key LIKE 'turn-de-%' OR entity_key LIKE 'act-de-%' OR entity_key LIKE 'lex-de-%' OR entity_key LIKE 'lexform-de-%');
INSERT INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes) VALUES
('lesson','de-pre-a1-lesson-hallo',@si_hallo,'other','منبع پشتیبان این درس.'),('lesson','de-pre-a1-lesson-hallo',@si_wiegehts,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-guten-morgen',@si_gm,'other','منبع پشتیبان این درس.'),('lesson','de-pre-a1-lesson-guten-morgen',@si_wiegehts,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-pizza-like',@si_q,'other','منبع پشتیبان این درس.'),('lesson','de-pre-a1-lesson-pizza-like',@si_stmt,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-ja-nein',@si_q,'other','منبع پشتیبان این درس.'),('lesson','de-pre-a1-lesson-ja-nein',@si_ja,'other','منبع پشتیبان این درس.'),('lesson','de-pre-a1-lesson-ja-nein',@si_nein,'other','منبع پشتیبان این درس.'),
('lesson','de-pre-a1-lesson-danke-bitte',@si_danke,'other','منبع پشتیبان این درس.'),('lesson','de-pre-a1-lesson-danke-bitte',@si_bitte,'other','منبع پشتیبان این درس.'),
('dialogue_turn','turn-de-hallo-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-hallo-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-hallo-3',@si_wiegehts,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-hallo-4',@si_gut,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-hallo-5',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-hallo-6',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-1',@si_gm,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-2',@si_gm,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-3',@si_wiegehts,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-4',@si_gut,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-5',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-gm-6',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-3',@si_q,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-4',@si_stmt,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-5',@si_stmt,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-6',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-pizza-7',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-3',@si_q,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-4',@si_ja,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-5',@si_stmt,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-6',@si_stmt,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-7',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-ja-8',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-3',@si_danke,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-4',@si_bitte,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-5',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('dialogue_turn','turn-de-danke-bitte-6',@si_tschuess,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),
('lexeme','lex-de-hallo',@si_hallo,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-guten-morgen',@si_gm,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-moegen',@si_moegen,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-pizza',@si_pizza,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-ja',@si_ja,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-nein',@si_nein,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-danke',@si_danke,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-bitte',@si_bitte,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-wie-gehts',@si_wiegehts,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-gut',@si_gut,'verbatim','lexeme منبع‌دار.'),('lexeme','lex-de-tschuess',@si_tschuess,'verbatim','lexeme منبع‌دار.'),
('lexeme_form','lexform-de-moegen-mag',@si_mag,'verbatim','شکل تأییدشدهٔ «mögen».'),('lexeme_form','lexform-de-moegen-magst',@si_magst,'verbatim','شکل تأییدشدهٔ «mögen».')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

COMMIT;
