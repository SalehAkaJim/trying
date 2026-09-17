-- German A1 — first progression unit planning
-- Canonical runtime: MySQL 9.0.1
-- Source + draft unit only; no learner-facing lesson rows or audio are created here.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @de_a1 := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

INSERT INTO sources (
  source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,
  published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,
  reuse_status,retrieved_at,notes
) VALUES (
  'src-wikibooks-bll-a1-lesson-1',
  'BLL German/A1/Lesson 1',
  'معرفی کامل‌تر در A1: کار و زبان‌ها',
  'Wikibooks contributors','de','course',
  'https://en.wikibooks.org/wiki/BLL_German/A1/Lesson_1',
  'Text, New words and Extension: self-introduction with wohnen/kommen plus arbeiten als, sprechen and lernen.',
  'بخش متن، واژه‌های تازه و Extension؛ معرفی شخصی با افزودن کار، شغل، صحبت‌کردن به زبان‌ها و یادگیری زبان.',
  '2026-08-16','maintained_current',
  'صفحهٔ زندهٔ Wikibooks در ۱۷ سپتامبر ۲۰۲۶ بررسی شد؛ آخرین ویرایش ثبت‌شدهٔ آن ۱۶ اوت ۲۰۲۶ است و نمونه‌های معرفی، کار و زبان‌آموزی برای کاربرد آموزشی معاصر مناسب‌اند.',
  'CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/',
  'Wikibooks contributors — BLL German/A1/Lesson 1',
  'reuse_with_attribution','2026-09-17',
  'منبع قابل‌بازاستفاده برای پل‌زدن از معرفی شخصی Pre-A1 به معرفی کامل‌تر A1؛ بخش تازهٔ موردنظر شامل کار، شغل، زبان‌هایی که فرد صحبت می‌کند و زبانی که یاد می‌گیرد است و قرار نیست نام، محل زندگی و مبدأ دوباره به‌عنوان هدف تازه آموزش داده شوند.'
)
ON DUPLICATE KEY UPDATE
  title=VALUES(title),
  title_fa=VALUES(title_fa),
  organization_or_author=VALUES(organization_or_author),
  language_code=VALUES(language_code),
  source_type=VALUES(source_type),
  url=VALUES(url),
  locator=VALUES(locator),
  locator_fa=VALUES(locator_fa),
  published_or_updated_at=VALUES(published_or_updated_at),
  modernity_status=VALUES(modernity_status),
  currency_evidence=VALUES(currency_evidence),
  license_name=VALUES(license_name),
  license_url=VALUES(license_url),
  attribution_text=VALUES(attribution_text),
  reuse_status=VALUES(reuse_status),
  retrieved_at=VALUES(retrieved_at),
  notes=VALUES(notes);

INSERT INTO units (
  unit_key,language_level_id,sequence_index,title_fa,grouping_rationale,status,metadata,notes
) VALUES (
  'de-a1-unit-extended-introduction',
  @de_a1,
  1,
  'معرفی کامل‌تر: کار و زبان‌ها',
  'این Unit اولین گسترش واقعی بعد از Pre-A1 است: زبان‌آموز اطلاعات شخصی تثبیت‌شده را فقط برای بازیابی به کار می‌گیرد و دو بعد تازهٔ کار/شغل و زبان‌ها را به معرفی اضافه می‌کند. این ترتیب بار شناختی را پایین نگه می‌دارد و در عین حال از تکرار محتوای سطح قبلی جلوگیری می‌کند.',
  'draft',
  JSON_OBJECT(
    'sourceRefs',JSON_ARRAY('src-wikibooks-bll-a1-lesson-1'),
    'learningTargets',JSON_ARRAY(
      'اطلاعات قبلیِ نام، محل زندگی و مبدأ را در یک معرفی پیوسته بازیابی کند، بدون اینکه این موارد دوباره به‌عنوان هدف تازه آموزش داده شوند.',
      'کار یا شغل را با الگوهای منبع‌دار بسیار ساده در معرفی شخصی بفهمد و بیان کند.',
      'زبان‌هایی را که فرد صحبت می‌کند یا یاد می‌گیرد در جمله‌های کوتاه و منبع‌دار بفهمد و بیان کند.',
      'یک معرفی کوتاه A1 را به‌عنوان مجموعه‌ای از اطلاعات مرتبط دربارهٔ یک نفر بفهمد، نه چند جملهٔ جدا از هم.'
    )
  ),
  'Lessonها عمداً هنوز ساخته نشده‌اند. قدم بعدی inventory دقیق عبارت‌ها، lexemeها و یک گفت‌وگوی ۴ تا ۱۲ نوبتی طبیعی از منابع قابل‌بازاستفاده است؛ هیچ جملهٔ آلمانی آزاد برای پرکردن مکالمه ساخته نمی‌شود.'
)
ON DUPLICATE KEY UPDATE
  sequence_index=VALUES(sequence_index),
  title_fa=VALUES(title_fa),
  grouping_rationale=VALUES(grouping_rationale),
  status=IF(status IN ('review','final'),status,VALUES(status)),
  metadata=VALUES(metadata),
  notes=VALUES(notes);

UPDATE language_levels
SET
  coverage=JSON_SET(
    coverage,
    '$.gaps[2]',
    'progression اولیه ثبت شده و Unit نخست باز شده است، اما تقسیم کامل هدف‌ها به Unit/Lesson هنوز باید هم‌زمان با تکمیل inventory منابع و بر اساس پیش‌نیاز و بار شناختی ادامه پیدا کند.'
  ),
  notes='A1 در مرحلهٔ برنامه‌ریزی است. Pre-A1 پیش‌نیاز بسته و frozen باقی می‌ماند. progression اولیه در content/de/a1/progression.md ثبت شده و Unit نخست برای گسترش معرفی شخصی به کار/شغل و زبان‌ها باز شده است؛ قدم بعد inventory دقیق lexeme/dialogue و ساخت نخستین Lessonهای منبع‌دار است.'
WHERE id=@de_a1;

COMMIT;
