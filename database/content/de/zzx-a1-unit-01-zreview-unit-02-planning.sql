-- German A1: close Unit 1 for review and open Unit 2 family planning.
-- Canonical runtime: MySQL 9.0.1. No audio generation or generated-audio overwrite.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
SET @unit1 := (SELECT id FROM units WHERE unit_key='de-a1-unit-extended-introduction' LIMIT 1);

UPDATE units
SET status='review',
    notes='بازبینی پوشش انجام شد. دو درس موجود شناسایی فرد و شغل، کار شخصی، زبان‌های در حال یادگیری و تمایز صحبت‌کردن با یادگیری زبان را پوشش می‌دهند. شکاف آموزشی مستقلی که ساخت درس سوم را توجیه کند پیدا نشد؛ این واحد برای بازبینی نگه داشته می‌شود و ساخت سطح به خانواده و افراد نزدیک ادامه پیدا می‌کند.'
WHERE id=@unit1 AND status <> 'final';

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes)
VALUES(
 'src-wikibooks-de-lesson-007-family','Deutschkurs für Anfänger/Lektion 007','خانواده و اطلاعات سادهٔ اعضای خانواده','Wikibooks contributors','de','course',
 'https://en.wikibooks.org/wiki/Deutschkurs_f%C3%BCr_Anf%C3%A4nger/Lektion_007',
 'Exercises 269 and 277–280, especially 277: family members, age, name, residence, study/work and possessive patterns.',
 'تمرین‌های ۲۶۹ و ۲۷۷ تا ۲۸۰، به‌ویژه تمرین ۲۷۷؛ اعضای خانواده و پرسش دربارهٔ سن، نام، محل زندگی، تحصیل و شغل.',
 '2025-01-04','contemporary_verified',
 'صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ بررسی شد. آخرین ویرایش ثبت‌شدهٔ صفحه ۴ ژانویهٔ ۲۰۲۵ است. برای A1 فقط بخش‌های روشن و مستقیم مربوط به اعضای خانواده و اطلاعات سادهٔ شخصی استفاده می‌شوند و نمونه‌های دارای خطای آشکار یا ساختار فراتر از نیاز این مرحله وارد محتوای آموزشی نمی‌شوند.',
 'CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — Deutschkurs für Anfänger/Lektion 007','reuse_with_attribution','2026-09-17',
 'منبع اصلی آغاز واحد خانواده. تمرین ۲۷۷ مجموعهٔ منسجمی از Bruder، Mutter، Schwester و Vater را همراه با نام، سن، محل زندگی، محل تحصیل و شغل ارائه می‌کند. پیش از ساخت مکالمه باید بافت مالکیت euer و unser با شخصیت‌های برنامه سازگار شود؛ هیچ تغییر آزاد در جملهٔ آلمانی مجاز نیست.'
)
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);

INSERT INTO units(unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes)
VALUES(
 'de-a1-unit-family-and-close-people',@level,2,'خانواده و افراد نزدیک',
 'پس از معرفی خود، کار و زبان‌ها، گام طبیعی بعدی انتقال همان مهارت‌های اطلاعات شخصی به افراد نزدیک است. نام، سن، محل زندگی و شغل از نظر مفهوم آشنا هستند؛ بار تازهٔ اصلی رابطهٔ خانوادگی، اشاره به شخص سوم و مالکیت ساده است. بنابراین این واحد می‌تواند بدون تکرار سطح پیشین دامنهٔ ارتباط A1 را گسترش دهد.',
 'draft',
 JSON_OBJECT('sourceRefs',JSON_ARRAY('src-wikibooks-de-lesson-007-family'),'learningTargets',JSON_ARRAY('تشخیص اعضای پرتکرار خانواده در بافت منبع‌دار','فهم و پرسش و پاسخ دربارهٔ اطلاعات سادهٔ یک عضو خانواده','کاربرد مالکیت ساده فقط در حد توجیه‌شده با منبع','فهم چند جملهٔ مرتبط دربارهٔ یک فرد نزدیک')),
 'واحد باز شده اما هنوز درسی ساخته نشده است. منبع نخست واژگان و جفت‌های پرسش و پاسخ مناسب دارد، ولی نمونهٔ تمرین ۲۷۷ مخاطب جمع euer و پاسخ unser دارد. پیش از ساخت درس باید یک گفت‌وگوی چهار تا دوازده نوبتی پیدا یا از یک بخش پیوستهٔ منبع استخراج شود که با شخصیت‌های واقعی برنامه از نظر تعداد مخاطب و مالکیت کاملاً سازگار باشد.'
)
ON DUPLICATE KEY UPDATE sequence_index=VALUES(sequence_index),title_fa=VALUES(title_fa),grouping_rationale=VALUES(grouping_rationale),status=IF(status IN ('review','final'),status,VALUES(status)),metadata=VALUES(metadata),notes=VALUES(notes);

SET @unit2 := (SELECT id FROM units WHERE unit_key='de-a1-unit-family-and-close-people' LIMIT 1);
SET @t_family := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-family' LIMIT 1);
SET @t_family_sit := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-sit-family' LIMIT 1);
SET @t_personal := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-personal-info' LIMIT 1);
SET @t_core := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-core-vocabulary' LIMIT 1);
SET @t_questions := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-questions' LIMIT 1);
INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES(@unit2,@t_family),(@unit2,@t_family_sit),(@unit2,@t_personal),(@unit2,@t_core),(@unit2,@t_questions);

UPDATE language_levels
SET coverage=JSON_SET(coverage,'$.gaps[2]','توالی آموزشی اولیه ثبت شده است؛ واحد نخست به بازبینی رسیده و واحد دوم خانواده باز شده است. تقسیم ادامهٔ هدف‌ها به واحد و درس باید هم‌زمان با تکمیل منابع و بر اساس پیش‌نیاز و بار شناختی ادامه پیدا کند.'),
    notes='A1 همچنان در مرحلهٔ ساخت تدریجی است. واحد نخست پس از دو درس منبع‌دار به بازبینی رسیده است و شکاف مستقلی برای درس سوم پیدا نشد. واحد دوم دربارهٔ خانواده و افراد نزدیک باز شده و قدم بعد، یافتن یا استخراج یک گفت‌وگوی منبع‌دار طبیعی با مالکیت و تعداد مخاطب سازگار با شخصیت‌های برنامه است.'
WHERE id=@level;

COMMIT;
