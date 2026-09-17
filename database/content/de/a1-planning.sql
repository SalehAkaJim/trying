-- German A1 curriculum planning
-- Canonical runtime: MySQL 9.0.1
-- This migration opens A1 without creating learner-facing German content.
-- Re-import must never regress an existing A1 status from building/review/final back to planning.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);

INSERT INTO sources (
  source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,
  published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,
  reuse_status,retrieved_at,notes
) VALUES
(
  'src-coe-cefr-a1',
  'CEFR Companion Volume (2020) — A1 descriptors',
  'جلد همراه CEFR — توصیفگرهای سطح A1',
  'Council of Europe','en','book',
  'https://rm.coe.int/cefr-companion-volume-with-new-descriptors-2020/16809ea0d4',
  'A1 illustrative descriptors and common reference level profile; used for curriculum planning only, not for direct German instructional text reuse.',
  'توصیفگرهای A1 و نمای کلی سطح برای برنامه‌ریزی آموزشی؛ نه برای بازاستفادهٔ مستقیم متن آلمانی.',
  '2020','contemporary_verified',
  'صفحه‌های رسمی CEFR شورای اروپا در سال ۲۰۲۶ دوباره بررسی شدند و جلد همراه ۲۰۲۰ همچنان مرجع رسمی توصیفگرهای به‌روزشدهٔ CEFR است.',
  NULL,NULL,'Council of Europe — CEFR Companion Volume','analysis_only','2026-09-17',
  'این منبع فقط برای تعیین دامنهٔ توانمندی‌های A1 استفاده می‌شود؛ هیچ متن آموزشی آلمانی از آن مستقیماً بازاستفاده نمی‌شود.'
),
(
  'src-goethe-a1-profile',
  'Goethe-Zertifikat A1: Start Deutsch 1',
  'پروفایل رسمی Goethe-Zertifikat A1: Start Deutsch 1',
  'Goethe-Institut','de','website',
  'https://www.goethe.de/ins/de/de/prf/prf/gzsd1.html',
  'Official A1 proficiency profile and examination skill coverage for adults: simple communication, everyday expressions, personal information, reading, listening, writing and speaking.',
  'پروفایل رسمی توانمندی A1 و پوشش خواندن، شنیدن، نوشتن و صحبت‌کردن برای بزرگسالان.',
  NULL,'maintained_current',
  'صفحهٔ رسمی و فعال Goethe-Institut در ۱۷ سپتامبر ۲۰۲۶ بررسی شد و همچنان پروفایل مهارتی آزمون A1 بزرگسالان را ارائه می‌کند.',
  NULL,NULL,'Goethe-Institut — Goethe-Zertifikat A1: Start Deutsch 1','analysis_only','2026-09-17',
  'این منبع برای کنترل پوشش عملی چهار مهارت و موقعیت‌های رایج A1 استفاده می‌شود؛ متن آزمون یا مثال‌های دارای حق نشر مستقیماً وارد محتوای آموزشی نمی‌شوند.'
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

INSERT INTO language_levels (
  language_id,cefr_level,status,audio_status,structure_rationale,coverage,completion_assessment,notes
) VALUES (
  @de,'A1','planning','blocked_until_level_final',
  'A1 از توانایی‌های تثبیت‌شدهٔ Pre-A1 عبور می‌کند و زبان‌آموز را به ارتباط ساده اما مستقل‌تر در موقعیت‌های روزمره می‌رساند. ساختار واحدها و درس‌ها تا زمانی که پوشش CEFR، پیش‌نیازها، منابع قابل‌بازاستفاده و نیاز واقعی به تمرین مشخص نشده‌اند سهمیه‌بندی عددی نمی‌شود.',
  JSON_OBJECT(
    'communicativeTargets',JSON_ARRAY(
      'فهم و استفاده از عبارت‌ها و جمله‌های ساده و پرتکرار در موقعیت‌های آشنای روزمره',
      'معرفی خود و دیگران و پرسیدن و پاسخ‌دادن دربارهٔ اطلاعات شخصی پایه',
      'پرسیدن و گفتن اطلاعات ساده دربارهٔ خانواده، افراد آشنا و روابط نزدیک',
      'صحبت ساده دربارهٔ محل زندگی، خانه و محیط نزدیک',
      'پرسیدن و پاسخ‌دادن دربارهٔ کار، مدرسه و کارهای روزمرهٔ پایه',
      'خرید ساده: پرسیدن قیمت، مقدار، نیاز و انتخاب کالا',
      'سفارش و درخواست سادهٔ غذا و نوشیدنی و فهم پاسخ‌های رایج',
      'پرسیدن و فهم زمان، تاریخ، ساعت، برنامه و قرار ساده',
      'پرسیدن و دادن مسیر و اطلاعات مکانی بسیار ساده',
      'درخواست، اجازه، کمک و پاسخ مؤدبانه در موقعیت‌های روزمره',
      'فهم گفت‌وگوهای کوتاه روزمره وقتی آهسته و روشن گفته می‌شوند',
      'فهم اطلاعات اصلی در پیام تلفنی کوتاه و اعلام عمومی ساده',
      'خواندن و فهم متن‌های بسیار کوتاه مانند یادداشت، آگهی، تابلو و اعلان',
      'تکمیل فرم ساده و نوشتن یک پیام شخصی کوتاه دربارهٔ موقعیت روزمره',
      'پرسیدن و پاسخ‌دادن به سؤال‌های روزمره و انجام یک درخواست ساده در گفت‌وگوی کوتاه'
    ),
    'linguisticTargets',JSON_ARRAY(
      'گسترش واژگان پایه برای شخص، خانواده، خانه، خرید، کار یا مدرسه، غذا، زمان و محیط نزدیک',
      'ساخت جملهٔ سادهٔ خبری و پرسشی با ترتیب واژهٔ پایه در آلمانی',
      'پرسش‌های W و پرسش‌های بله/خیر در موقعیت‌های روزمره',
      'ضمیرهای شخصی و تمایز کاربردی خطاب دوستانه و رسمی',
      'فعل‌های پرتکرار در زمان حال و الگوهای صرفی لازم برای ارتباط A1',
      'منفی‌سازی پایه با الگوهای منبع‌دار مانند nicht و kein پس از ثبت منبع مناسب',
      'اسم، جنس، حرف تعریف و جمع در حد لازم برای واژگان پرتکرار A1',
      'حالت‌های دستوری پایه در حد کاربردهای روزمره و منبع‌دار، بدون آموزش انتزاعیِ زودهنگام',
      'عدد، مقدار، قیمت، تاریخ و ساعت در دامنهٔ روزمرهٔ A1',
      'حروف اضافهٔ بسیار پرتکرار زمان و مکان در عبارت‌های منبع‌دار',
      'افعال وجهی و الگوهای درخواست ساده فقط پس از تثبیت منابع آلمانی قابل‌بازاستفاده',
      'تلفظ قابل‌فهمِ واژه‌ها و جمله‌های کوتاه، با تمرکز بر تفاوت‌های پرتکرار آلمانی که در منابع این سطح ظاهر می‌شوند'
    ),
    'situations',JSON_ARRAY(
      'معرفی و آشنایی','خانواده و افراد نزدیک','خانه و محل زندگی','کار، مدرسه و روتین روزانه',
      'خرید و پرداخت','کافه، رستوران و سفارش','زمان، تاریخ، برنامه و قرار','خیابان، مسیر و مکان‌های عمومی',
      'درخواست کمک، اجازه و خدمات روزمره','فرم، یادداشت، پیام کوتاه و تماس یا اعلام ساده'
    ),
    'gaps',JSON_ARRAY(
      'برای هر هدف A1 باید قبل از ساخت درس، متن و مثال آلمانی از منابع معاصر و قابل‌بازاستفاده ثبت شود.',
      'فهرست دقیق واژگان و دستور زبان آلمانی A1 هنوز باید با منابع زبان‌ویژه و قابل‌بازاستفاده نهایی شود؛ CEFR به‌تنهایی فهرست دستور زبان آلمانی ارائه نمی‌کند.',
      'تقسیم هدف‌ها به واحد و درس هنوز انجام نشده و باید بر اساس پیش‌نیاز و بار شناختی طراحی شود، نه تعداد ثابت درس.',
      'پوشش شنیدن، خواندن، نوشتن و گفتار باید هنگام طراحی درس‌ها به‌صورت واقعی و نه صرفاً برچسبی توزیع شود.',
      'صوت A1 تا نهایی‌شدن سطح تولید نمی‌شود.'
    )
  ),
  NULL,
  'A1 در مرحلهٔ برنامه‌ریزی باز شده است. Pre-A1 پیش‌نیاز بسته و نهایی این سطح است. مرحلهٔ بعد، ساخت inventory منبع‌دار آلمانی و تبدیل targetها به progression آموزشی است.'
)
ON DUPLICATE KEY UPDATE
  structure_rationale=VALUES(structure_rationale),
  coverage=VALUES(coverage),
  notes=VALUES(notes);

SET @de_a1 := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

INSERT INTO curriculum_targets (
  language_level_id,target_key,target_type,title,description,required_for_completion,status,metadata
) VALUES
(@de_a1,'a1-comm-everyday-expressions','communicative','عبارت‌ها و جمله‌های روزمرهٔ A1','فهم و استفاده از زبان ساده و پرتکرار در موقعیت‌های آشنا.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-coe-cefr-a1','src-goethe-a1-profile'))),
(@de_a1,'a1-comm-personal-info','communicative','اطلاعات شخصی و معرفی','معرفی خود و دیگران و پرسش و پاسخ دربارهٔ اطلاعات شخصی پایه.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-coe-cefr-a1','src-goethe-a1-profile'))),
(@de_a1,'a1-comm-family','communicative','خانواده و افراد نزدیک','گفت‌وگوی ساده دربارهٔ خانواده، افراد آشنا و روابط نزدیک.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-home','communicative','خانه و محیط نزدیک','صحبت ساده دربارهٔ محل زندگی، خانه و محیط نزدیک.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-work-school-routine','communicative','کار، مدرسه و روتین','پرسش و پاسخ ساده دربارهٔ کار، مدرسه و کارهای روزمره.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-shopping','communicative','خرید ساده','پرسیدن قیمت، مقدار، نیاز و انتخاب کالا در خرید ساده.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-food-order','communicative','غذا و سفارش','درخواست و سفارش سادهٔ غذا و نوشیدنی.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-coe-cefr-a1','src-goethe-a1-profile'))),
(@de_a1,'a1-comm-time-plans','communicative','زمان، برنامه و قرار','پرسیدن و فهم زمان، تاریخ، ساعت، برنامه و قرار ساده.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-coe-cefr-a1'))),
(@de_a1,'a1-comm-directions','communicative','مسیر و مکان','پرسیدن و دادن اطلاعات مکانی و مسیر بسیار ساده.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-coe-cefr-a1'))),
(@de_a1,'a1-comm-requests-help','communicative','درخواست و کمک','درخواست، اجازه، کمک و پاسخ مؤدبانه در موقعیت‌های روزمره.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-listening-dialogue','communicative','شنیدن گفت‌وگوی کوتاه','فهم گفت‌وگوهای کوتاه روزمره وقتی آهسته و روشن گفته می‌شوند.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-listening-message-announcement','communicative','پیام و اعلام کوتاه','فهم اطلاعات اصلی در پیام تلفنی کوتاه و اعلام عمومی ساده.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-reading-short-texts','communicative','خواندن متن کوتاه','خواندن یادداشت، آگهی، تابلو و اعلان بسیار کوتاه.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-writing-form-message','communicative','فرم و پیام کوتاه','تکمیل فرم ساده و نوشتن پیام شخصی کوتاه.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-comm-spoken-questions-requests','communicative','سؤال و درخواست گفتاری','پرسیدن و پاسخ‌دادن به سؤال‌های روزمره و انجام درخواست ساده.',TRUE,'uncovered',JSON_OBJECT('sourceRefs',JSON_ARRAY('src-goethe-a1-profile'))),
(@de_a1,'a1-ling-core-vocabulary','linguistic','واژگان پایهٔ A1','واژگان پرتکرار برای شخص، خانواده، خانه، خرید، کار یا مدرسه، غذا، زمان و محیط نزدیک.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-basic-word-order','linguistic','ترتیب واژهٔ پایه','ساخت جملهٔ خبری و پرسشی ساده با الگوهای منبع‌دار.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-questions','linguistic','پرسش‌های پایه','پرسش‌های W و بله/خیر در موقعیت‌های روزمره.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-pronouns-register','linguistic','ضمیر و خطاب','ضمیرهای شخصی و تمایز کاربردی خطاب دوستانه و رسمی.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-present-verbs','linguistic','فعل‌های پرتکرار زمان حال','الگوهای صرفی لازم برای ارتباط روزمرهٔ A1.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-negation','linguistic','منفی‌سازی پایه','الگوهای منبع‌دار منفی‌سازی پایه.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-nouns-articles-plurals','linguistic','اسم، حرف تعریف و جمع','جنس، حرف تعریف و جمع در حد واژگان پرتکرار و کاربردی.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-basic-cases','linguistic','حالت‌های دستوری پایه','حالت‌های دستوری فقط در حد کاربردهای روزمره و منبع‌دار.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-numbers-dates-time','linguistic','عدد، مقدار، تاریخ و ساعت','کاربرد روزمرهٔ عدد، مقدار، قیمت، تاریخ و ساعت.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-time-place-prepositions','linguistic','حروف اضافهٔ زمان و مکان','حروف اضافهٔ بسیار پرتکرار در عبارت‌های منبع‌دار.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-ling-modal-request-patterns','linguistic','افعال وجهی و درخواست','الگوهای درخواست و افعال وجهی پس از تثبیت منابع مناسب.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-pron-intelligibility','pronunciation','تلفظ قابل‌فهم','تلفظ قابل‌فهم واژه‌ها و جمله‌های کوتاه A1 بر اساس مواردی که در منابع سطح ظاهر می‌شوند.',TRUE,'uncovered',JSON_OBJECT('sourcePolicy','reusable_german_sources_required')),
(@de_a1,'a1-sit-introductions','situation','معرفی و آشنایی','موقعیت معرفی و آشنایی روزمره.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-family','situation','خانواده و افراد نزدیک','موقعیت گفت‌وگو دربارهٔ خانواده و افراد نزدیک.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-home','situation','خانه و محل زندگی','موقعیت خانه، نشانی و محیط نزدیک.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-work-school','situation','کار، مدرسه و روتین','موقعیت کار، مدرسه و برنامهٔ روزانه.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-shopping','situation','خرید و پرداخت','موقعیت خرید، قیمت، مقدار و پرداخت.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-cafe-restaurant','situation','کافه و رستوران','موقعیت سفارش و درخواست غذا و نوشیدنی.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-time-appointment','situation','زمان و قرار','موقعیت ساعت، تاریخ، برنامه و قرار.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-directions-public-places','situation','مسیر و مکان عمومی','موقعیت پرسیدن مسیر و مکان‌های عمومی.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-services-help','situation','خدمات و کمک','موقعیت درخواست کمک، اجازه و خدمات روزمره.',TRUE,'uncovered',NULL),
(@de_a1,'a1-sit-short-messages','situation','پیام و فرم کوتاه','موقعیت فرم، یادداشت، پیام کوتاه، تماس یا اعلام ساده.',TRUE,'uncovered',NULL)
ON DUPLICATE KEY UPDATE
  target_type=VALUES(target_type),
  title=VALUES(title),
  description=VALUES(description),
  required_for_completion=VALUES(required_for_completion),
  metadata=VALUES(metadata);

COMMIT;
