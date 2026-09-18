-- German A1 pedagogy/source-quality Fix Pass, 2026-09-18.
-- German learner-facing strings in this migration are copied from canonical authoring JSON.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES
('src-wiktionary-de-bitte','Wiktionary: bitte','در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود.','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/bitte','German adverb / response particle; meaning [2]: response to thanks','در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود.',NULL,'maintained_current','مدخل زنده و فعال Wiktionary در وضعیت فعلی بررسی شده و فقط کاربرد مستند پاسخ به تشکر استفاده می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/bitte','reuse_with_attribution','2026-09-16','در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود.')
ON DUPLICATE KEY UPDATE
 title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),
 language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),
 locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),
 modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),
 license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),
 reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);


-- Keep relational provenance enum synchronized with the canonical taxonomy.
ALTER TABLE provenance_links
  MODIFY COLUMN transformation ENUM(
    'verbatim',
    'persian_translation_added',
    'sentence_tokenized_for_word_order',
    'source_sentence_blank_created',
    'source_items_grouped_for_matching',
    'options_selected_from_source_material',
    'source_items_grouped_for_pronunciation',
    'character_metadata_added',
    'cefr_level_assigned_by_app',
    'other'
  ) NULL;

INSERT INTO taxonomy_labels(domain_code,value_code,label_fa) VALUES
('activity_transformation','source_items_grouped_for_pronunciation','موارد منبع برای تمرین تلفظ گروه‌بندی شده‌اند'),
('provenance_transformation','source_items_grouped_for_pronunciation','موارد منبع برای تمرین تلفظ گروه‌بندی شده‌اند')
ON DUPLICATE KEY UPDATE label_fa=VALUES(label_fa);

-- Source catalog additions and German Print demotions.
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-coerll-dib-directions','Deutsch im Blick — Kapitel 10 — Nach dem Weg fragen / Wegbeschreibungen','Deutsch im Blick — پرسیدن و دادن مسیر','Dr. Zsuzsanna Abrams / COERLL, University of Texas at Austin','de','course','https://coerll.utexas.edu/dib/voc.php?k=10','Kapitel 10: Nach dem Weg fragen; Wegbeschreibungen — phrases for asking for and giving simple directions.','فصل ۱۰؛ بخش‌های پرسیدن مسیر و راهنمایی مسیر.','2017','maintained_current','منبع باز دانشگاه تگزاس همچنان در وب‌سایت فعال COERLL نگه‌داری می‌شود و در ۱۸ سپتامبر ۲۰۲۶ دوباره بررسی شد. عبارت‌های انتخاب‌شده مربوط به مسیر و مکان‌اند و از نظر کاربرد روزمره همچنان معاصر هستند.','CC BY 4.0','https://creativecommons.org/licenses/by/4.0/','Zsuzsanna Abrams / COERLL, University of Texas at Austin — Deutsch im Blick','reuse_with_attribution','2026-09-18','برای جایگزینی منابع ضعیف‌تر مسیر در سطح A1 و برای درس‌های آیندهٔ جهت‌یابی استفاده می‌شود. فقط عبارت‌های آلمانی موجود در خود منبع قابل استفاده‌اند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-coerll-dib-weather','Deutsch im Blick — Kapitel 6 — Über das Wetter sprechen','Deutsch im Blick — صحبت دربارهٔ آب‌وهوا','Dr. Zsuzsanna Abrams / COERLL, University of Texas at Austin','de','course','https://coerll.utexas.edu/dib/voc.php?k=6','Kapitel 6: Über das Wetter sprechen — current-weather vocabulary and short condition sentences.','فصل ۶؛ بخش صحبت دربارهٔ آب‌وهوا.','2017','maintained_current','منبع باز دانشگاه تگزاس در وب‌سایت فعال COERLL نگه‌داری می‌شود و در ۱۸ سپتامبر ۲۰۲۶ بازبینی شد. واژگان و جمله‌های کوتاه وضعیت فعلی هوا معاصر و برای استفادهٔ روزمره پایدارند.','CC BY 4.0','https://creativecommons.org/licenses/by/4.0/','Zsuzsanna Abrams / COERLL, University of Texas at Austin — Deutsch im Blick','reuse_with_attribution','2026-09-18','برای آب‌وهوای فعلی و نمونه‌های کوتاه آفتابی، ابری، باد، گرما، باران و برف استفاده می‌شود.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-coerll-dib-pronunciation-alphabet','Deutsch im Blick — Kapitel 1 — Aussprache: Das Alphabet','Deutsch im Blick — تلفظ الفبای آلمانی','Dr. Zsuzsanna Abrams / COERLL, University of Texas at Austin','de','course','https://coerll.utexas.edu/dib/pho.php?k=1','Kapitel 1 pronunciation: German alphabet including Ä, Ö, Ü and ß, with recorded examples.','فصل ۱؛ بخش تلفظ و الفبای آلمانی.','2017','maintained_current','بخش تلفظ منبع باز COERLL در ۱۸ سپتامبر ۲۰۲۶ فعال و قابل دسترسی بود. الفبا و نگاشت‌های صوتی آن محتوای پایه و پایدار زبان آلمانی هستند.','CC BY 4.0','https://creativecommons.org/licenses/by/4.0/','Zsuzsanna Abrams / COERLL, University of Texas at Austin — Deutsch im Blick','reuse_with_attribution','2026-09-18','منبع مرجع برای آموزش الفبای کامل و تلفظ حروف در سطح A1 و سطوح بعدی.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-coerll-dib-pronunciation-umlauts','Deutsch im Blick — Kapitel 2 — Aussprache: Der Umlaut','Deutsch im Blick — تلفظ واکه‌های دگرگون‌شدهٔ آلمانی','Dr. Zsuzsanna Abrams / COERLL, University of Texas at Austin','de','course','https://coerll.utexas.edu/dib/pho.php?k=2','Kapitel 2 pronunciation: Ä/ä, Ö/ö and Ü/ü with recorded sample vocabulary.','فصل ۲؛ بخش تلفظ Ä، Ö و Ü.','2017','maintained_current','بخش تلفظ واکه‌های دگرگون‌شده در منبع باز COERLL در ۱۸ سپتامبر ۲۰۲۶ فعال بود و نمونه‌های صوتی آن برای آموزش تلفظ پایهٔ آلمانی همچنان معتبرند.','CC BY 4.0','https://creativecommons.org/licenses/by/4.0/','Zsuzsanna Abrams / COERLL, University of Texas at Austin — Deutsch im Blick','reuse_with_attribution','2026-09-18','برای افزودن تمرین مستقیم Ä، Ö و Ü بدون تولید مثال آلمانی جدید استفاده می‌شود.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-coerll-dib-pronunciation-consonants','Deutsch im Blick — Kapitel 3 — Aussprache: Beachtenswerte deutsche Konsonanten','Deutsch im Blick — تلفظ همخوان‌های مهم آلمانی','Dr. Zsuzsanna Abrams / COERLL, University of Texas at Austin','de','course','https://coerll.utexas.edu/dib/pho.php?k=3','Kapitel 3 pronunciation: ß, s, z, v, w, j and selected consonant clusters; includes Vetter/Wetter contrast.','فصل ۳؛ بخش تلفظ چند همخوان مهم آلمانی.','2017','maintained_current','بخش تلفظ همخوان‌ها در منبع باز COERLL در ۱۸ سپتامبر ۲۰۲۶ بررسی شد و نمونه‌های صوتی و توضیحات آن همچنان برای آلمانی معیار معتبرند.','CC BY 4.0','https://creativecommons.org/licenses/by/4.0/','Zsuzsanna Abrams / COERLL, University of Texas at Austin — Deutsch im Blick','reuse_with_attribution','2026-09-18','برای تمرین مستقیم همخوان‌های دشوار آلمانی در درس‌های فعلی و آینده استفاده می‌شود.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-wikibooks-german-appendix-phrasebook','German/Appendices/Phrasebook','عبارت‌نامهٔ آلمانی ویکی‌بوکس — مکان و مسیر','Wikibooks contributors','de','website','https://en.wikibooks.org/wiki/German/Appendix_2','Positionen (Locations): pharmacy/shop/airport location questions and short left/right directions.','بخش مکان‌ها؛ داروخانه، فروشگاه، فرودگاه و جهت‌های کوتاه چپ/راست.',NULL,'maintained_current','صفحهٔ زندهٔ ویکی‌بوکس در ۱۸ سپتامبر ۲۰۲۶ بررسی شد. عبارت‌های انتخاب‌شده کوتاه، روزمره و مطابق آلمانی معیار هستند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Appendices/Phrasebook','reuse_with_attribution','2026-09-18','برای پرسش مکان‌های عمومی و پاسخ‌های بسیار کوتاه چپ/راست استفاده می‌شود.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-wikibooks-german-lesson-9-clothing','German/Lesson 9 — Einkaufen gehen','درس ۹ ویکی‌بوکس آلمانی — خرید لباس و کفش','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Lesson_9','Gespräche 9-1: Katrin macht Besorgungen — short shoe-shopping exchanges about need, colour, fit and price.','گفت‌وگوی ۹-۱؛ خرید کفش، رنگ، اندازه و قیمت.','2023','maintained_current','صفحهٔ ویکی‌بوکس در ۱۸ سپتامبر ۲۰۲۶ دوباره بررسی شد. گفت‌وگوی انتخاب‌شده کوتاه و روزمره است و واژگان خرید لباس آن برای A1 قابل استفاده است.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Lesson 9','reuse_with_attribution','2026-09-18','جایگزین ساده‌تر برای گفت‌وگوی سنگین فروشگاه لباس در A1 و منبع آینده برای خرید پوشاک.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-goethe-a1-wortliste','Start Deutsch 1 — Wortliste','فهرست رسمی واژگان سطح A1 مؤسسهٔ گوته','Goethe-Institut / telc GmbH','de','book','https://www.goethe.de/pro/relaunch/prf/sr/A1_SD1_Wortliste_02.pdf','Official Start Deutsch 1 vocabulary list and thematic vocabulary groups.','فهرست رسمی واژگان و گروه‌های موضوعی سطح A1.','2012','maintained_current','فهرست رسمی واژگان سطح A1 همچنان از سوی مؤسسهٔ گوته به‌عنوان مرجع آماده‌سازی این سطح ارائه می‌شود و در ۱۸ سپتامبر ۲۰۲۶ از دامنهٔ رسمی گوته بازیابی شد.',NULL,NULL,'Goethe-Institut / telc GmbH — Start Deutsch 1 Wortliste','analysis_only','2026-09-18','فقط برای ممیزی پوشش واژگان و مقایسهٔ مجموعهٔ واژگان استفاده می‌شود؛ متن یا مثال‌های دارای حق نشر مستقیماً وارد محتوای آموزشی نمی‌شوند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-goethe-a1-practice-materials','Goethe-Zertifikat A1: Start Deutsch 1 — Übungsmaterialien','مواد تمرینی رسمی آزمون سطح A1 مؤسسهٔ گوته','Goethe-Institut','de','website','https://www.goethe.de/ins/de/de/prf/prf/gzsd1/ueb.html','Official A1 practice materials covering Hören, Lesen, Schreiben and Sprechen.','نمونه‌ها و تمرین‌های رسمی چهار مهارت شنیدن، خواندن، نوشتن و صحبت‌کردن.',NULL,'maintained_current','صفحهٔ رسمی تمرین‌های آزمون A1 در ۱۸ سپتامبر ۲۰۲۶ فعال بود و همچنان نمونه‌های چهار مهارت شنیدن، خواندن، نوشتن و صحبت‌کردن را ارائه می‌کند.',NULL,NULL,'Goethe-Institut — Goethe-Zertifikat A1 Übungsmaterialien','analysis_only','2026-09-18','فقط برای کالیبراسیون مهارت‌ها و ممیزی ساختار سطح A1 استفاده می‌شود؛ متن آزمون، صوت یا سؤال‌های دارای حق نشر وارد محتوای نمایش‌داده‌شونده به زبان‌آموز نمی‌شوند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-wikibooks-german-print-shopping-service','German/Print version — Going Shopping','درخواست کمک در فروشگاه لباس','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Print_version','Level one shopping dialogue, boutique section: offer of help, finding a skirt in the right size, and locating the fitting room.','گفت‌وگوی خرید، بخش بوتیک؛ پیشنهاد کمک، پیدا کردن سایز مناسب و پرسیدن محل اتاق پرو.','2024-06-05','needs_currency_review','این منبع در بازبینی کیفیت ۱۸ سپتامبر ۲۰۲۶ برای استفادهٔ مستقیم در محتوای آموزشی فعال کنار گذاشته شد. به‌دلیل ناهمگونی سطح، سبک و کیفیت آموزشیِ نسخهٔ چاپی و وجود منابع بازِ مناسب‌تر، تا بازبینی مستقل بعدی فقط برای تحلیل و مقایسه نگه‌داری می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Print version','analysis_only','2026-09-18','برای محتوای آموزشی جدید استفاده نشود. جایگزین‌های اولویت‌دار، منابع باز Deutsch im Blick از COERLL و بخش‌های دقیق‌تر ویکی‌بوکس و ویکی‌ویاژ هستند که در فهرست منابع ثبت شده‌اند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-wikibooks-german-print-weather','German/Print version — Weather','هوا، پیش‌بینی و دما','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Print_version','Weather lesson — Common Phrases: current weather, forecast, rain/umbrella and thermometer temperature.','بخش هوا و عبارت‌های رایج؛ هوای فعلی، پیش‌بینی، باران و چتر و دمای دماسنج.','2024-06-05','needs_currency_review','این منبع در بازبینی کیفیت ۱۸ سپتامبر ۲۰۲۶ برای استفادهٔ مستقیم در محتوای آموزشی فعال کنار گذاشته شد. به‌دلیل ناهمگونی سطح، سبک و کیفیت آموزشیِ نسخهٔ چاپی و وجود منابع بازِ مناسب‌تر، تا بازبینی مستقل بعدی فقط برای تحلیل و مقایسه نگه‌داری می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Print version','analysis_only','2026-09-18','برای محتوای آموزشی جدید استفاده نشود. جایگزین‌های اولویت‌دار، منابع باز Deutsch im Blick از COERLL و بخش‌های دقیق‌تر ویکی‌بوکس و ویکی‌ویاژ هستند که در فهرست منابع ثبت شده‌اند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);
INSERT INTO sources(source_key,title,title_fa,organization_or_author,language_code,source_type,url,locator,locator_fa,published_or_updated_at,modernity_status,currency_evidence,license_name,license_url,attribution_text,reuse_status,retrieved_at,notes) VALUES ('src-wikibooks-german-print-directions','German/Print version — Gespräch 5-2: Der Engländer in Österreich','گفت‌وگوی پرسیدن مسیر شهرداری','Wikibooks contributors','de','course','https://en.wikibooks.org/wiki/German/Print_version','Lesson 3.05, Gespräch 5-2 — locating a hotel and restaurant, then asking for and following the route to the Rathaus in St. Pölten.','درس ۳.۰۵، گفت‌وگوی ۵-۲؛ پیدا کردن هتل و رستوران و سپس پرسیدن و دنبال‌کردن مسیر شهرداری سنت پولتن.','2024-06-05','needs_currency_review','این منبع در بازبینی کیفیت ۱۸ سپتامبر ۲۰۲۶ برای استفادهٔ مستقیم در محتوای آموزشی فعال کنار گذاشته شد. به‌دلیل ناهمگونی سطح، سبک و کیفیت آموزشیِ نسخهٔ چاپی و وجود منابع بازِ مناسب‌تر، تا بازبینی مستقل بعدی فقط برای تحلیل و مقایسه نگه‌داری می‌شود.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wikibooks contributors — German/Print version','analysis_only','2026-09-18','برای محتوای آموزشی جدید استفاده نشود. جایگزین‌های اولویت‌دار، منابع باز Deutsch im Blick از COERLL و بخش‌های دقیق‌تر ویکی‌بوکس و ویکی‌ویاژ هستند که در فهرست منابع ثبت شده‌اند.')
ON DUPLICATE KEY UPDATE title=VALUES(title),title_fa=VALUES(title_fa),organization_or_author=VALUES(organization_or_author),language_code=VALUES(language_code),source_type=VALUES(source_type),url=VALUES(url),locator=VALUES(locator),locator_fa=VALUES(locator_fa),published_or_updated_at=VALUES(published_or_updated_at),modernity_status=VALUES(modernity_status),currency_evidence=VALUES(currency_evidence),license_name=VALUES(license_name),license_url=VALUES(license_url),attribution_text=VALUES(attribution_text),reuse_status=VALUES(reuse_status),retrieved_at=VALUES(retrieved_at),notes=VALUES(notes);

DELETE p
FROM provenance_links p
JOIN source_items si ON si.id=p.source_item_id
JOIN sources s ON s.id=si.source_id
WHERE p.entity_type IN ('lesson','activity','dialogue','dialogue_turn','lexeme','lexeme_form','grammar_note','example_sentence')
  AND s.source_key IN ('src-wikibooks-german-print-shopping-service','src-wikibooks-german-print-weather','src-wikibooks-german-print-directions');

-- Level metadata reflects real remaining pedagogy/skill-mode gaps.
UPDATE language_levels
SET status='final',
    audio_status='stale',
    structure_rationale='A1 نیازمحور باقی می‌ماند و هر واحد نهایی باید بین ۳ تا ۱۲ درس داشته باشد. تعداد دقیق داخل این بازه بر اساس گسترهٔ موضوع، پیش‌نیازها، تنوع مهارتی، بازیابی و کاربرد واقعی تعیین می‌شود؛ نه بر اساس پرکردن سهمیه.',
    coverage=CAST('{"communicativeTargets":["فهم و استفاده از عبارت‌ها و جمله‌های ساده و پرتکرار در موقعیت‌های آشنای روزمره","معرفی خود و دیگران و پرسیدن و پاسخ‌دادن دربارهٔ اطلاعات شخصی پایه","پرسیدن و گفتن اطلاعات ساده دربارهٔ خانواده، افراد آشنا و روابط نزدیک","صحبت ساده دربارهٔ محل زندگی، خانه و محیط نزدیک","پرسیدن و پاسخ‌دادن دربارهٔ کار، مدرسه و کارهای روزمرهٔ پایه","خرید ساده: پرسیدن قیمت، مقدار، نیاز و انتخاب کالا","سفارش و درخواست سادهٔ غذا و نوشیدنی و فهم پاسخ‌های رایج","پرسیدن و فهم زمان، تاریخ، ساعت، برنامه و قرار ساده","پرسیدن و دادن مسیر و اطلاعات مکانی بسیار ساده","درخواست، اجازه، کمک و پاسخ مؤدبانه در موقعیت‌های روزمره","فهم گفت‌وگوهای کوتاه روزمره وقتی آهسته و روشن گفته می‌شوند","فهم اطلاعات اصلی در پیام تلفنی کوتاه و خواندن تابلو یا اعلان بسیار کوتاه","خواندن و فهم متن‌های بسیار کوتاه مانند یادداشت، آگهی، تابلو و اعلان","تکمیل فرم ساده و تکمیل/بازسازی هدایت‌شدهٔ یک پیام شخصی کوتاه","پرسیدن و پاسخ‌دادن به سؤال‌های روزمره و انجام یک درخواست ساده در گفت‌وگوی کوتاه","بیان و فهم علائم بسیار سادهٔ بیماری و نیازهای پایهٔ دارویی","گرفتن بلیت و فهم اطلاعات بسیار سادهٔ حمل‌ونقل عمومی، توقف، زمان و سکو","پرسیدن و فهم هوای فعلی و وضعیت‌های سادهٔ آفتابی، ابری، بارانی و برفی"],"linguisticTargets":["گسترش واژگان پایه برای شخص، خانواده، خانه، خرید، کار یا مدرسه، غذا، زمان و محیط نزدیک","ساخت جملهٔ سادهٔ خبری و پرسشی با ترتیب واژهٔ پایه در آلمانی","پرسش‌های W و پرسش‌های بله/خیر در موقعیت‌های روزمره","ضمیرهای شخصی و تمایز کاربردی خطاب دوستانه و رسمی","فعل‌های پرتکرار در زمان حال و الگوهای صرفی لازم برای ارتباط A1","منفی‌سازی پایه با الگوهای منبع‌دار مانند nicht و kein پس از ثبت منبع مناسب","اسم، جنس، حرف تعریف و جمع در حد لازم برای واژگان پرتکرار A1","حالت‌های دستوری پایه در حد کاربردهای روزمره و منبع‌دار، بدون آموزش انتزاعیِ زودهنگام","عدد، مقدار، قیمت، تاریخ و ساعت در دامنهٔ روزمرهٔ A1","حروف اضافهٔ بسیار پرتکرار زمان و مکان در عبارت‌های منبع‌دار","افعال وجهی و الگوهای درخواست ساده فقط پس از تثبیت منابع آلمانی قابل‌بازاستفاده","خواندن و تلفظ واضح الفبای آلمانی، اوملاوت‌های پایه و یک تقابل سادهٔ V/W با نمونه‌های منبع‌دار"],"situations":["معرفی و آشنایی","خانواده و افراد نزدیک","خانه و محل زندگی","کار، مدرسه و روتین روزانه","خرید و پرداخت","کافه، رستوران و سفارش","زمان، تاریخ، برنامه و قرار","خیابان، مسیر و مکان‌های عمومی","درخواست کمک، اجازه و خدمات روزمره","فرم، یادداشت، پیام کوتاه و تماس یا اعلام ساده","پزشک، علائم ساده و داروخانه","بلیت، قطار، اتوبوس، توقف و سکو","آب‌وهوا، آفتاب، ابر، باران و برف"],"gaps":[]}' AS JSON),
    completion_assessment=CAST('{"reviewedAt":"2026-09-18T11:00:00Z","cefrCoverageComplete":true,"progressionComplete":true,"practiceAndRetrievalComplete":false,"skillModeCoverageComplete":false,"requiredGaps":["تنوع فعالیت‌ها هنوز بیش از حد به چند الگوی پرتکرار متکی است و برای کامل‌شدن طراحی تمرین به الگوهای تعاملی متنوع‌تری نیاز دارد.","تمرین مستقل شنیداری و تلفظ نسبت به قبل بهتر شده، اما در مقیاس ۳۹ درس هنوز پوشش کافی و توزیع یکنواخت ندارد.","بازیابی تجمعی اکنون سه ایستگاه مرور بین‌واحدی دارد، اما هنوز به اندازهٔ کافی گسترده و نظام‌مند نیست."],"qualityReview":{"overallScore":8.2,"dimensionScores":{"cefrCoverage":8.8,"pedagogicalProgression":8.6,"practiceAndRetrieval":7.2,"activityQualityAndVariety":7.3,"linguisticAccuracyAndNaturalness":9.2,"sourceQualityAndCurrency":8.2,"learnerSupportAndClarity":8.7,"qaIntegrity":9.2},"rationale":"این دور اصلاح کیفیت منبع و چند ضعف روشن سطح A1 را بهبود داده است، اما هنوز نباید کامل تلقی شود. از ۱۴۲ فعالیت، تعداد زیادی همچنان در چند قالب تکرارشونده متمرکزند؛ تمرین مستقل شنیداری فقط در ۱۰ فعالیت و تلفظ فقط در ۳ فعالیت وجود دارد و بازیابی تجمعی به سه ایستگاه مرور بین‌واحدی محدود است. منابع ضعیف نسخهٔ چاپی قدیمی از محتوای نمایش‌داده‌شده به زبان‌آموز کنار گذاشته و فقط برای تحلیل نگه‌داری شده‌اند، اما ممیزی موردبه‌مورد واژگان در برابر فهرست رسمی واژگان سطح A1 مؤسسهٔ گوته هنوز انجام نشده است. نوشتن آزاد نیز به‌علت محدودیت ساختار فعلی فعالیت‌ها جزو دامنهٔ این نسخه نیست.","strengths":["۱۳ واحد و ۳۹ درس، موقعیت‌های ارتباطی اصلی سطح A1 را با پیشروی نیازمحور پوشش می‌دهند.","متن آلمانی نمایش‌داده‌شونده به زبان‌آموز فقط از منابع مجاز و قابل‌بازاستفاده یا تبدیل مکانیکی ثبت‌شده می‌آید.","فعالیت تطبیق اکنون حالت صریح دارد و زبان هر دو سمت توسط قرارداد محتوایی کنترل می‌شود.","تمرین مستقل شنیداری در چند حوزهٔ متفاوت اضافه شده و تمرین تلفظ از الفبا فراتر رفته است.","سه ایستگاه مرور و بازیابی بین‌واحدی به نیمهٔ دوم سطح A1 اضافه شده‌اند.","منابع ضعیف نسخهٔ چاپی قدیمی از محتوای نمایش‌داده‌شونده به زبان‌آموز خارج و فقط برای تحلیل نگه‌داری شده‌اند."],"remainingWeaknesses":["طراحی فعالیت‌ها هنوز بیش از حد الگوگراست و مکالمهٔ گفتاری و مرتب‌سازی کلمات سهم بزرگی از تمرین‌ها را تشکیل می‌دهند.","تمرین مستقل شنیداری با ۱۰ فعالیت و تلفظ با ۳ فعالیت برای ۳۹ درس هنوز کم است.","بازیابی تجمعی فقط سه ایستگاه مرور بین‌واحدی دارد و هنوز پوشش نظام‌مند کل مسیر نیست.","نوشتن آزاد در انواع فعالیت فعلی پشتیبانی نمی‌شود و فقط تمرین نوشتاری هدایت‌شده قابل ادعاست.","پوشش واژگان با فهرست رسمی واژگان سطح A1 مؤسسهٔ گوته هنوز به‌صورت موردبه‌مورد ممیزی نشده است."]},"scopeExclusions":["ورودی آزاد تایپی در ساختار فعلی فعالیت‌ها پشتیبانی نمی‌شود؛ تولید نوشتاری سطح A1 در این نسخه هدایت‌شده است.","برابری کامل فهرست واژگان با همهٔ مدخل‌های فهرست رسمی واژگان سطح A1 مؤسسهٔ گوته در این بازبینی ادعا نمی‌شود؛ منبع رسمی برای ممیزی آینده ثبت شده است."]}' AS JSON),
    notes='A1 شامل ۱۳ واحد و ۳۹ درس است. این دور بازبینی کیفیت منبع، چند درس سنگین، شنیدن مستقل، تلفظ، بازیابی تجمعی و قرارداد تطبیق را بهبود داده است؛ با این حال کامل‌بودن تمرین و بازیابی و همچنین پوشش شیوه‌های مهارتی عمداً تأیید نشده‌اند تا وضعیت واقعی محصول پنهان نشود. نوشتن آزاد در ساختار فعلی فعالیت‌ها پشتیبانی نمی‌شود.'
WHERE id=@level;



-- Canonical A1 unit metadata.
UPDATE units
SET sequence_index=1,
    title_fa='معرفی کامل‌تر: کار و زبان‌ها',
    grouping_rationale='واحد از واژگان و پرسش‌های بسیار سادهٔ شغل شروع می‌کند، سپس کار و زبان‌ها را گسترش می‌دهد و در پایان آشنایی رسمی همراه با نام، مبدأ و محل زندگی را تمرین می‌کند.',
    status='final',
    metadata=CAST('{"learningTargets":["اطلاعات قبلیِ نام، محل زندگی و مبدأ را در یک معرفی پیوسته بازیابی کند، بدون اینکه این موارد دوباره به‌عنوان هدف تازه آموزش داده شوند.","کار یا شغل را با الگوهای منبع‌دار بسیار ساده در معرفی شخصی بفهمد و بیان کند.","زبان‌هایی را که فرد صحبت می‌کند یا یاد می‌گیرد در جمله‌های کوتاه و منبع‌دار بفهمد و بیان کند.","یک معرفی کوتاه A1 را به‌عنوان مجموعه‌ای از اطلاعات مرتبط دربارهٔ یک نفر بفهمد، نه چند جملهٔ جدا از هم."],"sourceRefs":["src-wikibooks-bll-a1-lesson-1","src-wikibooks-bll-a1-lesson-2","src-wikibooks-de-lesson-002-professions"],"lessonRefs":["de-a1-lesson-profession-profile","de-a1-lesson-work-and-languages","de-a1-lesson-integrated-introduction-review"]}' AS JSON),
    notes='درس شغل در بازبینی ۱۸ سپتامبر ۲۰۲۶ با نمونه‌های ساده‌تر و رایج‌تر Student/Studentin و Polizist/Polizistin از همان منبع جایگزین شد؛ Kraftfahrer دیگر محور آموزشی نیست.'
WHERE unit_key='de-a1-unit-extended-introduction' AND language_level_id=@level;
UPDATE units
SET sequence_index=2,
    title_fa='خانواده و افراد نزدیک',
    grouping_rationale='واحد ابتدا اطلاعات پایهٔ خواهر و برادر و سپس والدین را پوشش می‌دهد؛ درس سوم محور تازهٔ مکان را اضافه می‌کند و از زبان‌آموز می‌خواهد محل تحصیل یا زندگی اعضای خانواده را بفهمد و بپرسد.',
    status='final',
    metadata=CAST('{"learningTargets":["اعضای بسیار پرتکرار خانواده مانند پدر، مادر، برادر و خواهر را در بافت منبع‌دار تشخیص دهد.","اطلاعات سادهٔ یک عضو خانواده مانند نام، سن، محل زندگی یا شغل را بفهمد و در حد A1 دربارهٔ آن پرسش و پاسخ کند.","الگوهای مالکیت لازم برای صحبت دربارهٔ خانواده را فقط در حدی که منابع و سناریوی واقعی درس توجیه می‌کنند به کار ببرد.","اطلاعات مربوط به یک فرد نزدیک را به‌صورت چند جملهٔ مرتبط بفهمد، نه مجموعه‌ای از واژه‌های جدا از هم."],"sourceRefs":["src-wikibooks-de-lesson-007-family"],"lessonRefs":["de-a1-lesson-family-brother-profile","de-a1-lesson-family-parents-profile","de-a1-lesson-family-profile-review"]}' AS JSON),
    notes='سه درس خانواده اکنون نام/سن/شغل، والدین، و محل تحصیل/زندگی را به‌عنوان سه زیرمهارت مستقل پوشش می‌دهند.'
WHERE unit_key='de-a1-unit-family-and-close-people' AND language_level_id=@level;
UPDATE units
SET sequence_index=3,
    title_fa='خانه و محیط نزدیک',
    grouping_rationale='واحد از شناخت و مالکیت وسایل اتاق به موقعیت آن‌ها می‌رسد و در درس سوم یک نیاز کاربردی تازه را اضافه می‌کند: پرسیدن «وسایلم کجاست؟» و پاسخ‌دادن با مفرد/جمع و شکل مؤدبانهٔ مالکیت.',
    status='final',
    metadata=CAST('{"learningTargets":["واژه‌های پرتکرار برای اتاق و وسایل سادهٔ داخل آن را در بافت منبع‌دار تشخیص دهد.","دربارهٔ تعلق داشتن یا شناسایی یک وسیلهٔ سادهٔ خانه پرسش و پاسخ کوتاه را بفهمد.","اطلاعات بسیار ساده دربارهٔ محل قرارگیری یا ویژگی یک اتاق و وسایل آن را بفهمد.","واژگان خانه را به اطلاعات واقعیِ محل زندگی متصل کند، نه اینکه فقط فهرست اشیا را حفظ کند."],"sourceRefs":["src-wikibooks-de-lesson-007-room-objects","src-wikibooks-de-lesson-009-room-position"],"lessonRefs":["de-a1-lesson-room-table-lamp","de-a1-lesson-room-position","de-a1-lesson-home-description-review"]}' AS JSON),
    notes='درس سوم از تمرین منبع‌دار پیدا کردن وسایل شخصی استفاده می‌کند و تکرار درس موقعیت اتاق نیست.'
WHERE unit_key='de-a1-unit-home-and-nearby' AND language_level_id=@level;
UPDATE units
SET sequence_index=4,
    title_fa='روتین روزانه: کار و مدرسه',
    grouping_rationale='دو درس نخست مسیر صبح و پیش‌ازظهرِ کار و مدرسه را می‌سازند؛ درس سوم نیمهٔ دوم روز را با خرید بعدازظهر و فعالیت‌های شبانه گسترش می‌دهد تا روتین فقط به همان صحنه‌های قبلی محدود نماند.',
    status='final',
    metadata=CAST('{"learningTargets":["دربارهٔ کارهای معمول در بخش‌های مختلف روز پرسش و پاسخ کوتاه را بفهمد.","زمان‌های سادهٔ روز مانند صبح، پیش از ظهر، ظهر و بعدازظهر را به کارهای روزمره وصل کند.","اطلاعات ساده دربارهٔ کار یا مدرسه را در بافت روتین روزانه بفهمد و بیان کند.","چند کار روزمره را به‌صورت توالی زمانی ساده دنبال کند."],"sourceRefs":["src-wikibooks-de-lesson-022-daily-routine"],"lessonRefs":["de-a1-lesson-daily-routine-work","de-a1-lesson-daily-routine-school","de-a1-lesson-daily-routine-day-review"]}' AS JSON),
    notes='هر سه درس بخش زمانی و کارکرد متفاوتی دارند: کار، مدرسه، و فعالیت‌های بعدازظهر/شب.'
WHERE unit_key='de-a1-unit-daily-routine-work-school' AND language_level_id=@level;
UPDATE units
SET sequence_index=5,
    title_fa='خرید واقعی‌تر: مقدار، قیمت و پرداخت',
    grouping_rationale='واحد اکنون سه مرحلهٔ واقعی خرید را جدا می‌کند: تشخیص نیاز و تصمیم خرید، تراکنش مقدار و پرداخت، و فهم قیمت دقیق/جمع کل با یورو و سنت.',
    status='final',
    metadata=CAST('{"learningTargets":["قیمت یک کالا را در گفت‌وگوی کوتاه بپرسد و پاسخ قیمت را بفهمد.","مقدارهای سادهٔ خرید مانند گرم و کیلو را در درخواست و پاسخ تشخیص دهد.","یک کالای دیگر را به خرید اضافه کند و مقدار موردنظر را بفهمد یا بیان کند.","پایان خرید و رفتن به صندوق برای پرداخت را در گفت‌وگوی روزمره بفهمد."],"sourceRefs":["src-wikibooks-de-lesson-009-shopping","src-wikibooks-de-lesson-004"],"lessonRefs":["de-a1-lesson-shopping-price-review","de-a1-lesson-shopping-quantity-payment","de-a1-lesson-shopping-checkout-review"]}' AS JSON),
    notes='دو درس تازه از منبع مستقل درس ۰۰۴ استفاده می‌کنند و به‌جای تکرار گفت‌وگوی تراکنش، انتخاب کالا و خواندن قیمت/جمع کل را آموزش می‌دهند.'
WHERE unit_key='de-a1-unit-shopping-quantity-payment' AND language_level_id=@level;
UPDATE units
SET sequence_index=6,
    title_fa='سفارش گسترده‌تر غذا و نوشیدنی',
    grouping_rationale='واحد سه نیاز متفاوت را پوشش می‌دهد: شخصی‌سازی نوشیدنی، ادامهٔ سفارش با پرسش «چیز دیگری هم؟» و موجودی/قیمت، و فهم جایگزین وقتی یک قلم موجود نیست. یک تمرین کوتاه اوملاوت نیز به واژگان آشنا متصل شده است.',
    status='final',
    metadata=CAST('{"learningTargets":["در یک سفارش کوتاه دربارهٔ قلم دیگری، موجودبودن خوراکی و قیمت سؤال کند و پاسخ را بفهمد.","نوشیدنی را با شیر/شکر یا بدون یکی از آن‌ها شخصی‌سازی کند.","وقتی یک قلم موجود نیست، جایگزین پیشنهادی را در پاسخ کوتاه بفهمد.","Ö و Ü را در چند نمونهٔ کوتاه و منبع‌دار واضح بخواند."],"sourceRefs":["src-wikibooks-de-lesson-007-food-order","src-coerll-dib-pronunciation-umlauts"],"lessonRefs":["de-a1-lesson-food-preference-review","de-a1-lesson-expanded-food-order","de-a1-lesson-food-combinations-review"]}' AS JSON),
    notes='عبارت محاوره‌ای‌تر درس میانی با یک درس کامل دیگر از همان منبع جایگزین شد که «Noch etwas bitte?» را در بافت واقعی دارد؛ متن آلمانی به‌صورت دستی اصلاح نشده است.'
WHERE unit_key='de-a1-unit-expanded-food-order' AND language_level_id=@level;
UPDATE units
SET sequence_index=7,
    title_fa='زمان، برنامه و قرار',
    grouping_rationale='واحد از فهم بازهٔ زمانی به دعوت و سپس موافقت یا رد یک برنامه می‌رسد. درس سوم پس از بازبینی کامل با نمونه‌های صحیح و عیناً منبع‌دارِ موافقت جایگزین شده است.',
    status='final',
    metadata=CAST('{"learningTargets":["بازهٔ زمانی یک برنامه را با ساعت شروع و پایان بفهمد.","پرسش و پاسخ دربارهٔ «تا چه زمانی» را در برنامهٔ روزمره بفهمد.","یک دعوت ساده و رد مؤدبانه را دنبال کند.","پرسش دربارهٔ مناسب‌بودن یک برنامه را بفهمد و پاسخ موافقت را تشخیص دهد."],"sourceRefs":["src-wikibooks-de-lesson-021-time-appointment"],"lessonRefs":["de-a1-lesson-time-class-schedule","de-a1-lesson-time-simple-appointment","de-a1-lesson-time-plans-review"]}' AS JSON),
    notes='هیچ متن آلمانی این واحد برای اصلاح دستی بازنویسی نمی‌شود؛ در بازبینی ۱۸ سپتامبر ۲۰۲۶ درس سوم به‌طور کامل با محتوای منبع‌دار جایگزین شد.'
WHERE unit_key='de-a1-unit-time-plans-appointment' AND language_level_id=@level;
UPDATE units
SET sequence_index=8,
    title_fa='مسیر و مکان‌های عمومی',
    grouping_rationale='واحد سه کارکرد را تفکیک می‌کند: پرسیدن «کجاست؟» برای مکان‌های نزدیک، پرسیدن «چطور برسم؟» برای یک مقصد، و کاربرد همان الگو برای ایستگاه/فرودگاه همراه با بازیابی بین‌واحدی.',
    status='final',
    metadata=CAST('{"learningTargets":["محل یک مکان عمومی را با پرسش کوتاه بپرسد.","برای رسیدن به یک مقصد ساده مسیر را بپرسد.","راهنمایی کوتاه با چپ، راست و مستقیم را بفهمد.","مسیر ایستگاه قطار و فرودگاه را در پرسش‌های ساده دنبال کند."],"sourceRefs":["src-wikibooks-german-appendix-phrasebook","src-coerll-dib-directions","src-wikivoyage-german-phrasebook-directions","src-wikibooks-de-lesson-007-family","src-wikibooks-de-lesson-004"],"lessonRefs":["de-a1-lesson-directions-public-places-review","de-a1-lesson-ask-and-follow-directions","de-a1-lesson-directions-sequence-review"]}' AS JSON),
    notes='دو درس سنگینِ متکی بر نسخهٔ چاپی قدیمی ویکی‌بوکس کامل جایگزین شدند. منابع فعال این واحد اکنون عبارت‌نامهٔ ویکی‌بوکس، Deutsch im Blick و ویکی‌ویاژ هستند.'
WHERE unit_key='de-a1-unit-directions-public-places' AND language_level_id=@level;
UPDATE units
SET sequence_index=9,
    title_fa='درخواست، اجازه و خدمات روزمره',
    grouping_rationale='واحد از روشن‌سازی و کمک پایه به دو موقعیت خدماتی ساده می‌رود: خرید کفش با نیاز/رنگ، و پیدا کردن پزشک با پاسخ مکانی کوتاه. ساختارهای سنگین فروشگاه لباس حذف شده‌اند.',
    status='final',
    metadata=CAST('{"learningTargets":["درخواست تکرار و آهسته‌تر گفتن کند.","نیاز به کمک را مستقیم بیان یا تشخیص دهد.","در یک خرید ساده نیاز و رنگ موردنظر را بیان کند.","محل پزشک را با پرسش کوتاه بپرسد و پاسخ مکانی ساده را بفهمد."],"sourceRefs":["src-wikibooks-de-lesson-002-service-clarification","src-wikivoyage-german-phrasebook-services","src-wiktionary-de-ja","src-wikibooks-german-lesson-9-clothing","src-wikibooks-de-lesson-006-where-when","src-coerll-dib-directions","src-wiktionary-de-bitte"],"lessonRefs":["de-a1-lesson-clarify-permission-help","de-a1-lesson-services-permission-review","de-a1-lesson-services-help-review"]}' AS JSON),
    notes='دو درس خدماتی در بازبینی ۱۸ سپتامبر ۲۰۲۶ به منابع ساده‌تر و قابل‌بازاستفاده منتقل شدند؛ نسخهٔ چاپی قدیمی ویکی‌بوکس دیگر منبع فعال این واحد نیست.'
WHERE unit_key='de-a1-unit-requests-services-help' AND language_level_id=@level;
UPDATE units
SET sequence_index=10,
    title_fa='فرم، تابلو و پیام کوتاه',
    grouping_rationale='واحد فرم و تابلو را با الفبای کامل و تلفظ حروف در درس اول، پیام کوتاه شنیداری/خواندنی در درس دوم، و هجی‌کردن اطلاعات شخصی همراه با یک بازیابی بین‌واحدی در درس سوم پوشش می‌دهد.',
    status='final',
    metadata=CAST('{"learningTargets":["اطلاعات شخصی آشنا را به فیلدهای یک فرم ساده وصل کند و یک فیلد را کامل کند.","تابلوهای بسیار کوتاه روزمره را بخواند.","الفبای کامل آلمانی شامل Ä، Ö، Ü و ß را برای هجی‌کردن واضح بخواند.","یک پیام کوتاه تماس را از راه شنیدن بفهمد.","پیام‌های کوتاه زمانی را بخواند و یک پیام را به‌صورت هدایت‌شده کامل و بازسازی کند.","در پایان واحد، یک پرسش خرید را از نمونه‌های خانواده و مسیر تشخیص دهد."],"sourceRefs":["src-wikibooks-de-residence-origin","src-wikibooks-de-lesson-007-form-spelling","src-wikivoyage-german-phrasebook-signs","src-wikibooks-de-lesson-024-short-messages","src-coerll-dib-pronunciation-alphabet","src-wikibooks-de-lesson-004","src-wikibooks-de-lesson-007-family","src-coerll-dib-directions"],"lessonRefs":["de-a1-lesson-personal-form-signs","de-a1-lesson-short-phone-message","de-a1-lesson-forms-signs-message-review"]}' AS JSON),
    notes='تلفظ فقط به A–Z محدود نیست؛ Ä، Ö، Ü و ß نیز از منبع باز COERLL اضافه شده‌اند. نوشتن همچنان هدایت‌شده است چون ورودی آزاد متنی در محصول پشتیبانی نمی‌شود.'
WHERE unit_key='de-a1-unit-forms-signs-messages' AND language_level_id=@level;
UPDATE units
SET sequence_index=11,
    title_fa='سلامت، پزشک و داروخانه',
    grouping_rationale='واحد از بیان مستقیم علامت شروع می‌کند، سپس دارو و داروخانه را پوشش می‌دهد و در پایان به پیگیری حال بیمار و بیان بهترشدن می‌رسد.',
    status='final',
    metadata=CAST('{"learningTargets":["علائم بسیار رایج بیماری را در پرسش و پاسخ کوتاه بیان و تشخیص دهد.","دارو و محل گرفتن دارو را در یک موقعیت سادهٔ پزشکی بفهمد.","با الگوی سادهٔ «دیگر ندارم» بهترشدن یک علامت را بیان کند."],"sourceRefs":["src-wikibooks-de-lesson-018-health"],"lessonRefs":["de-a1-lesson-health-symptoms","de-a1-lesson-health-medicine-pharmacy","de-a1-lesson-health-recovery"]}' AS JSON),
    notes='ادعای آموزش نسخه در بازبینی ۱۸ سپتامبر ۲۰۲۶ حذف شد، چون فعالیت‌های فعلی این واحد نسخه را به‌صورت مستقیم آموزش نمی‌دهند.'
WHERE unit_key='de-a1-unit-health-doctor-pharmacy' AND language_level_id=@level;
UPDATE units
SET sequence_index=12,
    title_fa='بلیت و حمل‌ونقل عمومی',
    grouping_rationale='واحد سه گام مستقل سفر با حمل‌ونقل عمومی را پوشش می‌دهد: درخواست بلیت، تشخیص وسیله یا توقف درست، و فهم اطلاعات واقعیِ زمان و سکو.',
    status='final',
    metadata=CAST('{"learningTargets":["برای یک مقصد ساده بلیت بخواهد.","قطار یا اتوبوس درست را با پرسش دربارهٔ مقصد و توقف تشخیص دهد.","اطلاعات سادهٔ توقف، زمان حرکت و شمارهٔ سکو را در یک گفت‌وگوی کوتاه بفهمد."],"sourceRefs":["src-wikivoyage-german-phrasebook-transport","src-wikivoyage-german-phrasebook-directions","src-wikibooks-de-transport-dialogue-current"],"lessonRefs":["de-a1-lesson-transport-ticket","de-a1-lesson-transport-train-bus","de-a1-lesson-transport-times-platform"]}' AS JSON),
    notes='در بازبینی ۱۸ سپتامبر ۲۰۲۶ ادعای آموزش قیمت بلیت حذف شد و درس سوم با گفت‌وگوی منبع‌دارِ واقعی دربارهٔ توقف، زمان و سکو جایگزین شد.'
WHERE unit_key='de-a1-unit-public-transport-tickets' AND language_level_id=@level;
UPDATE units
SET sequence_index=13,
    title_fa='آب‌وهوا',
    grouping_rationale='واحد فقط روی هوای فعلی متمرکز است: باد/گرما، آفتاب/ابر و باران/برف. پیش‌بینی سنگین حذف شده و یک تمرین کوتاه V/W و یک بازیابی بین‌واحدی پایان A1 اضافه شده‌اند.',
    status='final',
    metadata=CAST('{"learningTargets":["دربارهٔ هوای فعلی یک شهر سؤال کند و پاسخ ساده را بفهمد.","وضعیت‌های سادهٔ باد، گرما، آفتاب و ابر را تشخیص دهد.","وضعیت‌های سادهٔ باران و برف را از هم تشخیص دهد.","یک تقابل کوتاه V/W را با نمونهٔ منبع‌دار تمرین کند.","در پایان A1 یک پرسش سلامت را از آب‌وهوا و حمل‌ونقل تشخیص دهد."],"sourceRefs":["src-wikibooks-de-weather-appendix","src-coerll-dib-weather","src-coerll-dib-pronunciation-consonants","src-wikibooks-de-lesson-018-health","src-wikibooks-de-transport-dialogue-current"],"lessonRefs":["de-a1-lesson-weather-current","de-a1-lesson-weather-rain-plan","de-a1-lesson-weather-temperature"]}' AS JSON),
    notes='شناسهٔ فنی واحد برای سازگاری تاریخی حفظ شده، اما محتوای فعال دیگر دما را به‌عنوان محور مستقل آموزش نمی‌دهد. منبع قدیمی هواشناسی نسخهٔ چاپی از محتوای فعال کنار گذاشته شده است.'
WHERE unit_key='de-a1-unit-weather-temperature' AND language_level_id=@level;


-- Canonical replacements for the seven A1 dialogues changed by the Fix Pass.

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale)
VALUES ('dlg-de-a1-ask-and-follow-directions',@level,'زبان‌آموز محل باغ‌وحش و راه رسیدن به آن را می‌پرسد و دو پاسخ کوتاه منبع‌دار می‌شنود.','learner','چهار نوبت از بخش‌های پرسیدن مسیر و راهنمایی مسیر Deutsch im Blick انتخاب شده‌اند؛ عبارت آلمانی جدیدی ساخته نشده است.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),
 scenario=VALUES(scenario),
 opening_initiator=VALUES(opening_initiator),
 scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-ask-and-follow-directions' LIMIT 1);
DELETE FROM dialogue_turns
WHERE dialogue_id=@dlg AND turn_key NOT IN ('turn-de-a1-ask-and-follow-directions-1','turn-de-a1-ask-and-follow-directions-2','turn-de-a1-ask-and-follow-directions-3','turn-de-a1-ask-and-follow-directions-4');
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-ask-and-follow-directions-1',@dlg,1,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Wo ist der Zoo?','باغ‌وحش کجاست؟',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-ask-and-follow-directions-1-1','turn-de-a1-ask-and-follow-directions-1','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wo ist der Zoo?',UNHEX(SHA2('Wo ist der Zoo?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-ask-and-follow-directions-1';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-ask-and-follow-directions-1',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-ask-and-follow-directions-1-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-ask-and-follow-directions-2',@dlg,2,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Gleich da drüben.','همین آن طرف.',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-ask-and-follow-directions-2-1','turn-de-a1-ask-and-follow-directions-2','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Gleich da drüben.',UNHEX(SHA2('Gleich da drüben.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-ask-and-follow-directions-2';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-ask-and-follow-directions-2',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-ask-and-follow-directions-2-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-ask-and-follow-directions-3',@dlg,3,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Wie komme ich zum Zoo?','چطور به باغ‌وحش برسم؟',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-ask-and-follow-directions-3-1','turn-de-a1-ask-and-follow-directions-3','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wie komme ich zum Zoo?',UNHEX(SHA2('Wie komme ich zum Zoo?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-ask-and-follow-directions-3';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-ask-and-follow-directions-3',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-ask-and-follow-directions-3-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-ask-and-follow-directions-4',@dlg,4,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Gehen Sie geradeaus','مستقیم بروید.',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-ask-and-follow-directions-4-1','turn-de-a1-ask-and-follow-directions-4','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Gehen Sie geradeaus',UNHEX(SHA2('Gehen Sie geradeaus',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-ask-and-follow-directions-4';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-ask-and-follow-directions-4',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-ask-and-follow-directions-4-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue' AND entity_key='dlg-de-a1-ask-and-follow-directions';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-ask-and-follow-directions-1','dlg-de-a1-ask-and-follow-directions','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-ask-and-follow-directions',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-ask-and-follow-directions-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale)
VALUES ('dlg-de-a1-clothing-store-help',@level,'مشتری در فروشگاه کفش محل کفش‌ها و رنگ موردنظر را در یک گفت‌وگوی کوتاه مشخص می‌کند.','learner','چهار نوبت نخست گفت‌وگوی خرید کفش در منبع عیناً استفاده شده‌اند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),
 scenario=VALUES(scenario),
 opening_initiator=VALUES(opening_initiator),
 scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-clothing-store-help' LIMIT 1);
DELETE FROM dialogue_turns
WHERE dialogue_id=@dlg AND turn_key NOT IN ('turn-de-a1-clothing-store-help-1','turn-de-a1-clothing-store-help-2','turn-de-a1-clothing-store-help-3','turn-de-a1-clothing-store-help-4');
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-clothing-store-help-1',@dlg,1,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Entschuldigen Sie. Ich brauche Schuhe. Wo sind sie?','ببخشید. کفش لازم دارم. کجا هستند؟',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-clothing-store-help-1-1','turn-de-a1-clothing-store-help-1','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Entschuldigen Sie. Ich brauche Schuhe. Wo sind sie?',UNHEX(SHA2('Entschuldigen Sie. Ich brauche Schuhe. Wo sind sie?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-clothing-store-help-1';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-clothing-store-help-1',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-clothing-store-help-1-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-clothing-store-help-2',@dlg,2,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Wir haben viele Schuhe. Welche Farbe möchten Sie?','کفش‌های زیادی داریم. چه رنگی می‌خواهید؟',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-clothing-store-help-2-1','turn-de-a1-clothing-store-help-2','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wir haben viele Schuhe. Welche Farbe möchten Sie?',UNHEX(SHA2('Wir haben viele Schuhe. Welche Farbe möchten Sie?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-clothing-store-help-2';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-clothing-store-help-2',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-clothing-store-help-2-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-clothing-store-help-3',@dlg,3,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Ein Paar Schuhe in Weiß, bitte.','لطفاً یک جفت کفش سفید.',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-clothing-store-help-3-1','turn-de-a1-clothing-store-help-3','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Ein Paar Schuhe in Weiß, bitte.',UNHEX(SHA2('Ein Paar Schuhe in Weiß, bitte.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-clothing-store-help-3';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-clothing-store-help-3',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-clothing-store-help-3-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-clothing-store-help-4',@dlg,4,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Da drüben.','آن طرف.',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-clothing-store-help-4-1','turn-de-a1-clothing-store-help-4','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Da drüben.',UNHEX(SHA2('Da drüben.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-clothing-store-help-4';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-clothing-store-help-4',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-clothing-store-help-4-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue' AND entity_key='dlg-de-a1-clothing-store-help';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-clothing-store-help-1','dlg-de-a1-clothing-store-help','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-clothing-store-help',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-clothing-store-help-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale)
VALUES ('dlg-de-a1-expanded-food-order',@level,'پس از گرفتن قهوه، مشتری دربارهٔ مورد دیگری و موجودبودن کیک سؤال می‌کند و قیمت نان‌ها را می‌پرسد.','app','چهار نوبت پیوسته از بخش ۲۸۲ منبع انتخاب شده‌اند و عبارت رسمی‌تر و کامل‌تر «Noch etwas bitte?» را در بافت واقعی سفارش می‌آورند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),
 scenario=VALUES(scenario),
 opening_initiator=VALUES(opening_initiator),
 scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-expanded-food-order' LIMIT 1);
DELETE FROM dialogue_turns
WHERE dialogue_id=@dlg AND turn_key NOT IN ('turn-de-a1-food-order-1','turn-de-a1-food-order-2','turn-de-a1-food-order-3','turn-de-a1-food-order-4');
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-food-order-1',@dlg,1,
 (SELECT id FROM characters WHERE character_key='char-de-jonas' LIMIT 1),
 'app_assigned','unspecified','Hier ist ihr Kaffee. Noch etwas bitte?','قهوه‌تان اینجاست. چیز دیگری هم؟',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-food-order-1-1','turn-de-a1-food-order-1','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Hier ist ihr Kaffee. Noch etwas bitte?',UNHEX(SHA2('Hier ist ihr Kaffee. Noch etwas bitte?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-food-order-1';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-food-order-1',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-food-order-1-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-food-order-2',@dlg,2,
 (SELECT id FROM characters WHERE character_key='char-de-lena' LIMIT 1),
 'app_assigned','unspecified','Gibt es auch Kuchen?','کیک هم هست؟',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-food-order-2-1','turn-de-a1-food-order-2','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Gibt es auch Kuchen?',UNHEX(SHA2('Gibt es auch Kuchen?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-food-order-2';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-food-order-2',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-food-order-2-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-food-order-3',@dlg,3,
 (SELECT id FROM characters WHERE character_key='char-de-jonas' LIMIT 1),
 'app_assigned','unspecified','Nein, Kuchen gibt es heute nicht, aber Brötchen mit Wurst oder mit Käse.','نه، امروز کیک نداریم، اما نان گرد با سوسیس یا پنیر داریم.',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-food-order-3-1','turn-de-a1-food-order-3','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Nein, Kuchen gibt es heute nicht, aber Brötchen mit Wurst oder mit Käse.',UNHEX(SHA2('Nein, Kuchen gibt es heute nicht, aber Brötchen mit Wurst oder mit Käse.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-food-order-3';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-food-order-3',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-food-order-3-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-food-order-4',@dlg,4,
 (SELECT id FROM characters WHERE character_key='char-de-lena' LIMIT 1),
 'app_assigned','unspecified','Wie viel kosten die Brötchen?','نان‌ها چقدر قیمت دارند؟',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-food-order-4-1','turn-de-a1-food-order-4','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wie viel kosten die Brötchen?',UNHEX(SHA2('Wie viel kosten die Brötchen?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-food-order-4';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-food-order-4',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-food-order-4-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue' AND entity_key='dlg-de-a1-expanded-food-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-expanded-food-order-1','dlg-de-a1-expanded-food-order','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-expanded-food-order',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-expanded-food-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale)
VALUES ('dlg-de-a1-hotel-restaurant-location',@level,'زبان‌آموز محل داروخانه و فروشگاه را می‌پرسد و دو جهت کوتاه چپ و راست را می‌شنود.','learner','هر چهار نوبت عین بخش مکان‌ها در عبارت‌نامهٔ منبع هستند و هیچ متن آلمانی برای اتصال صحنه ساخته نشده است.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),
 scenario=VALUES(scenario),
 opening_initiator=VALUES(opening_initiator),
 scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-hotel-restaurant-location' LIMIT 1);
DELETE FROM dialogue_turns
WHERE dialogue_id=@dlg AND turn_key NOT IN ('turn-de-a1-hotel-restaurant-location-1','turn-de-a1-hotel-restaurant-location-2','turn-de-a1-hotel-restaurant-location-3','turn-de-a1-hotel-restaurant-location-4');
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-hotel-restaurant-location-1',@dlg,1,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Wo ist die Apotheke?','داروخانه کجاست؟',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-hotel-restaurant-location-1-1','turn-de-a1-hotel-restaurant-location-1','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wo ist die Apotheke?',UNHEX(SHA2('Wo ist die Apotheke?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-hotel-restaurant-location-1';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-hotel-restaurant-location-1',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-hotel-restaurant-location-1-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-hotel-restaurant-location-2',@dlg,2,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Gehen Sie nach links.','به چپ بروید.',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-hotel-restaurant-location-2-1','turn-de-a1-hotel-restaurant-location-2','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Gehen Sie nach links.',UNHEX(SHA2('Gehen Sie nach links.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-hotel-restaurant-location-2';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-hotel-restaurant-location-2',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-hotel-restaurant-location-2-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-hotel-restaurant-location-3',@dlg,3,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Wo ist das Geschäft?','فروشگاه کجاست؟',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-hotel-restaurant-location-3-1','turn-de-a1-hotel-restaurant-location-3','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wo ist das Geschäft?',UNHEX(SHA2('Wo ist das Geschäft?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-hotel-restaurant-location-3';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-hotel-restaurant-location-3',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-hotel-restaurant-location-3-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-hotel-restaurant-location-4',@dlg,4,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Gehen Sie nach rechts.','به راست بروید.',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-hotel-restaurant-location-4-1','turn-de-a1-hotel-restaurant-location-4','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Gehen Sie nach rechts.',UNHEX(SHA2('Gehen Sie nach rechts.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-hotel-restaurant-location-4';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-hotel-restaurant-location-4',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-hotel-restaurant-location-4-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue' AND entity_key='dlg-de-a1-hotel-restaurant-location';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-hotel-restaurant-location-1','dlg-de-a1-hotel-restaurant-location','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-hotel-restaurant-location',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-hotel-restaurant-location-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale)
VALUES ('dlg-de-a1-profession-profile',@level,'دو پرسش و پاسخ کوتاه برای تشخیص شغل و شکل زن/مرد از نمونه‌های مستقیم منبع تمرین می‌شوند.','app','هر چهار نوبت عین بخش ۰۷۰ منبع هستند؛ واژگان کم‌کاربردتر درس قبلی حذف شده‌اند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),
 scenario=VALUES(scenario),
 opening_initiator=VALUES(opening_initiator),
 scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-profession-profile' LIMIT 1);
DELETE FROM dialogue_turns
WHERE dialogue_id=@dlg AND turn_key NOT IN ('turn-de-a1-profession-1','turn-de-a1-profession-2','turn-de-a1-profession-3','turn-de-a1-profession-4');
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-profession-1',@dlg,1,
 (SELECT id FROM characters WHERE character_key='char-de-jonas' LIMIT 1),
 'app_assigned','unspecified','Was ist er?','شغل او چیست؟',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-profession-1-1','turn-de-a1-profession-1','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Was ist er?',UNHEX(SHA2('Was ist er?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-profession-1';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-profession-1',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-profession-1-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-profession-2',@dlg,2,
 (SELECT id FROM characters WHERE character_key='char-de-lena' LIMIT 1),
 'app_assigned','unspecified','Er ist Student.','او دانشجوی مرد است.',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-profession-2-1','turn-de-a1-profession-2','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Er ist Student.',UNHEX(SHA2('Er ist Student.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-profession-2';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-profession-2',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-profession-2-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-profession-3',@dlg,3,
 (SELECT id FROM characters WHERE character_key='char-de-jonas' LIMIT 1),
 'app_assigned','unspecified','Was ist sie?','شغل او چیست؟',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-profession-3-1','turn-de-a1-profession-3','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Was ist sie?',UNHEX(SHA2('Was ist sie?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-profession-3';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-profession-3',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-profession-3-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-profession-4',@dlg,4,
 (SELECT id FROM characters WHERE character_key='char-de-lena' LIMIT 1),
 'app_assigned','unspecified','Sie ist Studentin.','او دانشجوی زن است.',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-profession-4-1','turn-de-a1-profession-4','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Sie ist Studentin.',UNHEX(SHA2('Sie ist Studentin.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-profession-4';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-profession-4',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-profession-4-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue' AND entity_key='dlg-de-a1-profession-profile';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-profession-profile-1','dlg-de-a1-profession-profile','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-profession-profile',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-profession-profile-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale)
VALUES ('dlg-de-a1-urgent-service-help',@level,'زبان‌آموز محل پزشک را می‌پرسد، جهت کوتاه می‌شنود و با تشکر گفت‌وگو را پایان می‌دهد.','learner','هر نوبت عین یکی از منابع قابل‌بازاستفاده است؛ فقط نقش شخصیت‌ها و ترجمهٔ فارسی اضافه شده‌اند.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),
 scenario=VALUES(scenario),
 opening_initiator=VALUES(opening_initiator),
 scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-urgent-service-help' LIMIT 1);
DELETE FROM dialogue_turns
WHERE dialogue_id=@dlg AND turn_key NOT IN ('turn-de-a1-urgent-service-help-1','turn-de-a1-urgent-service-help-2','turn-de-a1-urgent-service-help-3','turn-de-a1-urgent-service-help-4');
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-urgent-service-help-1',@dlg,1,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Wo finde ich einen Arzt?','کجا می‌توانم یک پزشک پیدا کنم؟',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-006-where-when' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-urgent-service-help-1-1','turn-de-a1-urgent-service-help-1','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wo finde ich einen Arzt?',UNHEX(SHA2('Wo finde ich einen Arzt?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-urgent-service-help-1';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-urgent-service-help-1',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-urgent-service-help-1-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-urgent-service-help-2',@dlg,2,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Gleich da drüben.','همین آن طرف.',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-urgent-service-help-2-1','turn-de-a1-urgent-service-help-2','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Gleich da drüben.',UNHEX(SHA2('Gleich da drüben.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-urgent-service-help-2';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-urgent-service-help-2',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-urgent-service-help-2-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-urgent-service-help-3',@dlg,3,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Vielen Dank.','خیلی ممنون.',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-urgent-service-help-3-1','turn-de-a1-urgent-service-help-3','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Vielen Dank.',UNHEX(SHA2('Vielen Dank.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-urgent-service-help-3';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-urgent-service-help-3',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-urgent-service-help-3-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-urgent-service-help-4',@dlg,4,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Bitte.','خواهش می‌کنم.',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-bitte' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-urgent-service-help-4-1','turn-de-a1-urgent-service-help-4','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Bitte.',UNHEX(SHA2('Bitte.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-urgent-service-help-4';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-urgent-service-help-4',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-urgent-service-help-4-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue' AND entity_key='dlg-de-a1-urgent-service-help';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-006-where-when' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-urgent-service-help-1','dlg-de-a1-urgent-service-help','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-urgent-service-help',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-urgent-service-help-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-urgent-service-help-2','dlg-de-a1-urgent-service-help','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-urgent-service-help',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-urgent-service-help-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-bitte' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-urgent-service-help-3','dlg-de-a1-urgent-service-help','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-urgent-service-help',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-urgent-service-help-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

INSERT INTO dialogues(dialogue_key,language_level_id,scenario,opening_initiator,scene_quality_rationale)
VALUES ('dlg-de-a1-weather-current',@level,'دو وضعیت سادهٔ هوای فعلی، باد و گرما، در پاسخ به یک پرسش شهری تمرین می‌شوند.','app','پرسش و هر دو پاسخ از منابع باز انتخاب شده‌اند و ساختار پیش‌بینی سنگین درس قبلی حذف شده است.')
ON DUPLICATE KEY UPDATE
 language_level_id=VALUES(language_level_id),
 scenario=VALUES(scenario),
 opening_initiator=VALUES(opening_initiator),
 scene_quality_rationale=VALUES(scene_quality_rationale);
SET @dlg := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-weather-current' LIMIT 1);
DELETE FROM dialogue_turns
WHERE dialogue_id=@dlg AND turn_key NOT IN ('turn-de-a1-weather-current-1','turn-de-a1-weather-current-2','turn-de-a1-weather-current-3','turn-de-a1-weather-current-4');
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-weather-current-1',@dlg,1,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Wie ist das Wetter in Berlin?','هوا در برلین چطور است؟',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-weather-current-1-1','turn-de-a1-weather-current-1','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wie ist das Wetter in Berlin?',UNHEX(SHA2('Wie ist das Wetter in Berlin?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-weather-current-1';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-weather-current-1',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-weather-current-1-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-weather-current-2',@dlg,2,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Es ist windig.','هوا باد می‌آید / بادی است.',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-weather' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-weather-current-2-1','turn-de-a1-weather-current-2','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Es ist windig.',UNHEX(SHA2('Es ist windig.',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-weather-current-2';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-weather-current-2',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-weather-current-2-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-weather-current-3',@dlg,3,
 (SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1),
 'app_assigned','unspecified','Wie ist das Wetter in Berlin?','هوا در برلین چطور است؟',
 FALSE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-weather-current-3-1','turn-de-a1-weather-current-3','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Wie ist das Wetter in Berlin?',UNHEX(SHA2('Wie ist das Wetter in Berlin?',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-weather-current-3';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-weather-current-3',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-weather-current-3-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO dialogue_turns(
 turn_key,dialogue_id,position_index,speaker_character_id,speaker_identity_origin,speaker_gender_evidence,
 text_target,translation_fa,learner_turn,audio_status,audio_url,audio_storage_path,audio_source_hash,
 audio_provider,audio_model_id,audio_voice_name,audio_voice_id,audio_generated_at
) VALUES (
 'turn-de-a1-weather-current-4',@dlg,4,
 (SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1),
 'app_assigned','unspecified','Es ist heiß draußen!','بیرون هوا گرم است!',
 TRUE,'stale',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
)
ON DUPLICATE KEY UPDATE
 dialogue_id=VALUES(dialogue_id),
 position_index=VALUES(position_index),
 speaker_character_id=VALUES(speaker_character_id),
 speaker_identity_origin=VALUES(speaker_identity_origin),
 speaker_gender_evidence=VALUES(speaker_gender_evidence),
 text_target=VALUES(text_target),
 translation_fa=VALUES(translation_fa),
 learner_turn=VALUES(learner_turn),
 audio_status='stale',
 audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,
 audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-weather' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-turn-de-a1-weather-current-4-1','turn-de-a1-weather-current-4','نوبت گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت','Es ist heiß draußen!',UNHEX(SHA2('Es ist heiß draußen!',256)),'متن دقیق نمایش‌داده‌شونده به زبان‌آموز از منبع ثبت‌شده برای این نوبت حفظ شده است.')
ON DUPLICATE KEY UPDATE
 locator=VALUES(locator),locator_fa=VALUES(locator_fa),source_text=VALUES(source_text),
 source_text_hash=VALUES(source_text_hash),notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue_turn' AND entity_key='turn-de-a1-weather-current-4';
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue_turn','turn-de-a1-weather-current-4',id,'verbatim','پیوند منبع دقیق برای نوبت جایگزین‌شده در Fix Pass.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-turn-de-a1-weather-current-4-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE FROM provenance_links WHERE entity_type='dialogue' AND entity_key='dlg-de-a1-weather-current';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-weather-current-1','dlg-de-a1-weather-current','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-weather-current',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-weather-current-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-weather' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-dialogue-dlg-de-a1-weather-current-2','dlg-de-a1-weather-current','منبع گفت‌وگوی جایگزین‌شده در دور اصلاح کیفیت',NULL,NULL,'پیوند سطح گفت‌وگو به منبع رسمی؛ متن دقیق در موارد منبعِ نوبت‌ها ثبت شده است.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'dialogue','dlg-de-a1-weather-current',id,'other','پیوند منبع رسمی گفت‌وگو.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-dialogue-dlg-de-a1-weather-current-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);


-- Canonical A1 lesson/activity sync, batch 1 of 3.

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-extended-introduction' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-profession-profile',@level,@unit,1,1,'شغلش چیه؟','Was ist er?','شغل او چیست؟','qa',
 'درس با دو جفت پرسش‌وپاسخ سادهٔ شغلی شروع می‌شود؛ سپس شنیدن مستقل، تطبیق و بازسازی پاسخ، همان واژگان رایج را در سه شیوهٔ تمرین تکرار می‌کنند.','از مکالمه به شنیدن، تطبیق واژه و بازیابی فعال حرکت می‌کند.','conversation_speaking>listen_choose>matching>word_order',
 'stale',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-profession-profile' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-profession-profile';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-profession-profile-1','de-a1-lesson-profession-profile','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-profession-profile',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-profession-profile-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-profession-conversation',@lesson,1,'conversation_speaking','دو پرسش کوتاه شغل را در گفت‌وگو پاسخ بده.','چهار نوبت عین بخش ۰۷۰ منبع هستند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-profession-profile' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-profession-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-profession-conversation-1','act-de-a1-profession-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-profession-listen',@lesson,2,'listen_choose','پرسش را گوش کن و یک پاسخ شغلی درست را انتخاب کن.','پرسش و هر سه گزینه عین بخش شغل منبع هستند.',
 NULL,
 CAST('{"audioTextTargetFa":"شغل او چیست؟","options":[{"text":"Er ist Student.","translationFa":"او دانشجوی مرد است.","correct":true},{"text":"Er ist Polizist.","translationFa":"او پلیس مرد است.","correct":false},{"text":"Sie ist Studentin.","translationFa":"او دانشجوی زن است.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Was ist er?','stale'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-profession-listen';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-profession-listen-1','act-de-a1-profession-listen','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-listen',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-listen-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-listen',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-listen-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-profession-matching',@lesson,3,'matching','هر شغل را به معنی درستش وصل کن.','چهار واژهٔ رایج و مستقیم منبع انتخاب شده‌اند.',
 NULL,
 CAST('{"pairMode":"target_to_persian","pairs":[{"left":"Student","leftFa":"دانشجوی مرد","right":"دانشجوی مرد","rightFa":"دانشجوی مرد"},{"left":"Studentin","leftFa":"دانشجوی زن","right":"دانشجوی زن","rightFa":"دانشجوی زن"},{"left":"Polizist","leftFa":"پلیس مرد","right":"پلیس مرد","rightFa":"پلیس مرد"},{"left":"Polizistin","leftFa":"پلیس زن","right":"پلیس زن","rightFa":"پلیس زن"}]}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-profession-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-profession-matching-1','act-de-a1-profession-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-profession-word-order',@lesson,4,'word_order','پاسخ شغلی را دوباره بساز.','پاسخ عین منبع است و فقط به قطعه‌های واژگانی تقسیم می‌شود.',
 NULL,
 CAST('{"sourceText":"Sie ist Polizistin.","sourceTextFa":"او پلیس زن است.","tokens":["Sie","ist","Polizistin."],"answer":["Sie","ist","Polizistin."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-profession-word-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-professions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-profession-word-order-1','act-de-a1-profession-word-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-word-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-word-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-profession-word-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-profession-word-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-extended-introduction' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-work-and-languages',@level,@unit,2,2,'کارت چیه؟ چه زبانی یاد می‌گیری؟','Welche Sprachen lernen Sie?','چه زبان‌هایی یاد می‌گیرید؟','qa',
 'گفت‌وگوی چهار نوبتی شغل و زبان‌های در حال یادگیری را در یک تعامل مؤدبانه می‌آورد؛ سپس تفاوت صحبت‌کردن، یادگیری و کار با جمله‌های منبع‌دار سنجیده می‌شود و در پایان پرسش زبان بازسازی می‌شود.','درس از تعامل و فهم بافت به تمایز معنایی سه فعل، دسته‌بندی جمله‌ها و بازیابی فعال پرسش حرکت می‌کند؛ بنابراین نسبت به درس اول الگوی فعالیت متفاوتی دارد.','conversation_speaking>multiple_choice>matching>word_order',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-work-and-languages' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-work-and-languages';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-1' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-work-and-languages-1','de-a1-lesson-work-and-languages','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-work-and-languages',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-work-and-languages-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-work-and-languages-2','de-a1-lesson-work-and-languages','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-work-and-languages',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-work-and-languages-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-work-language-conversation',@lesson,1,'conversation_speaking','با آیریس دربارهٔ شغل و زبان‌هایی که یاد می‌گیری صحبت کن.','دو جفت پرسش و پاسخ منبع‌دار یک گفت‌وگوی کوتاه و مؤدبانه می‌سازند و هدف تازه را بدون توضیح دستوری انتزاعی وارد می‌کنند. کنارهم‌گذاری دو جفت و انتخاب شکل مردانهٔ شغل برای پاول در ردیابی منبع ثبت شده است.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-work-and-languages' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-work-language-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-work-language-conversation-1','act-de-a1-work-language-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-work-language-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-work-language-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-work-language-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-work-language-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-work-language-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-work-language-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-speak-learn-work-choice',@lesson,2,'multiple_choice','کدام جمله می‌گوید فرد انگلیسی و فرانسوی صحبت می‌کند؟','سه جملهٔ کامل و منبع‌دار، sprechen را از lernen و arbeiten جدا می‌کنند.',
 NULL,
 CAST('{"options":[{"textTarget":"Ich spreche Englisch und Französisch.","translationFa":"من انگلیسی و فرانسوی صحبت می‌کنم.","correct":true},{"textTarget":"Ich lerne Deutsch und Französisch.","translationFa":"من آلمانی و فرانسوی یاد می‌گیرم.","correct":false},{"textTarget":"Nein, ich arbeite als Journalist.","translationFa":"نه، من به‌عنوان روزنامه‌نگار کار می‌کنم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-speak-learn-work-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-1' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-speak-learn-work-choice-1','act-de-a1-speak-learn-work-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-speak-learn-work-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-speak-learn-work-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-speak-learn-work-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-speak-learn-work-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-speak-learn-work-choice-2','act-de-a1-speak-learn-work-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-speak-learn-work-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-speak-learn-work-choice-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-speak-learn-work-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-speak-learn-work-choice-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-work-language-matching',@lesson,3,'matching','هر جمله را به کاری که انجام می‌دهد وصل کن.','چهار جملهٔ منبع‌دار نقش کار، یادگیری یک یا چند زبان و صحبت‌کردن به زبان‌ها را از هم جدا می‌کنند.',
 NULL,
 CAST('{"pairs":[{"left":"Nein, ich arbeite als Journalist.","leftFa":"نه، من به‌عنوان روزنامه‌نگار کار می‌کنم.","right":"کار / شغل","rightFa":"کار / شغل"},{"left":"Ich lerne Deutsch und Französisch.","leftFa":"من آلمانی و فرانسوی یاد می‌گیرم.","right":"یادگیری دو زبان","rightFa":"یادگیری دو زبان"},{"left":"Ich spreche Englisch und Französisch.","leftFa":"من انگلیسی و فرانسوی صحبت می‌کنم.","right":"صحبت‌کردن به زبان‌ها","rightFa":"صحبت‌کردن به زبان‌ها"},{"left":"Ich lerne Deutsch.","leftFa":"من آلمانی یاد می‌گیرم.","right":"یادگیری یک زبان","rightFa":"یادگیری یک زبان"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-work-language-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-1' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-work-language-matching-1','act-de-a1-work-language-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-work-language-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-work-language-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-work-language-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-work-language-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-work-language-matching-2','act-de-a1-work-language-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-work-language-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-work-language-matching-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-work-language-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-work-language-matching-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-language-question-order',@lesson,4,'word_order','پرسش دربارهٔ زبان‌های در حال یادگیری را دوباره بساز.','در پایان، زبان‌آموز پرسش اصلی را از تشخیص به بازیابی فعال منتقل می‌کند.',
 NULL,
 CAST('{"sourceText":"Welche Sprachen lernen Sie?","sourceTextFa":"چه زبان‌هایی یاد می‌گیرید؟","tokens":["Welche","Sprachen","lernen","Sie?"],"answer":["Welche","Sprachen","lernen","Sie?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-language-question-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-language-question-order-1','act-de-a1-language-question-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-language-question-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-language-question-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-language-question-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-language-question-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-extended-introduction' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-integrated-introduction-review',@level,@unit,3,3,'اول مطمئن شو با چه کسی حرف می‌زنی','Guten Tag! Ich suche Lisa Müller. Sind Sie Lisa Müller? / Ja, und Sie? Wie heißen Sie?','روز بخیر! دنبال لیزا مولر می‌گردم. شما لیزا مولر هستید؟ / بله، و شما؟ اسمتان چیست؟','qa',
 'این درس به‌جای مرور شغل و زبان، مهارت تازهٔ شروع گفت‌وگوی رسمی با فرد ناآشنا و جداکردن مبدأ از محل زندگی را اضافه می‌کند.','از تشخیص هویت در مکالمه به فهم پاسخ مبدأ/محل زندگی و سپس ساخت پرسش مبدأ حرکت می‌کند.','conversation_speaking>multiple_choice>word_order',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-integrated-introduction-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-integrated-introduction-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-integrated-introduction-review-1','de-a1-lesson-integrated-introduction-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-integrated-introduction-review',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-integrated-introduction-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-intro-review-conversation',@lesson,1,'conversation_speaking','مکالمه را اجرا کن و اول مطمئن شو طرف مقابل همان کسی است که دنبالش می‌گردی.','مکالمهٔ منبع‌دار برخورد رسمی، نام، مبدأ و محل زندگی را در یک صحنهٔ واقعی کنار هم می‌آورد.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-find-person-formal' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-intro-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-intro-review-conversation-1','act-de-a1-intro-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-intro-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-intro-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-intro-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-intro-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-intro-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-intro-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-intro-review-choice',@lesson,2,'multiple_choice','کدام پاسخ هم مبدأ و هم محل زندگی را می‌گوید؟','زبان‌آموز باید بین معرفی نام و پاسخ کامل مبدأ/محل زندگی تمایز بگذارد.',
 NULL,
 CAST('{"options":[{"textTarget":"Nein, ich komme aus Deutschland und ich wohne hier in Bern.","translationFa":"نه، من از آلمان می‌آیم و اینجا در برن زندگی می‌کنم.","correct":true},{"textTarget":"Ich heiße Lutz Schmidt.","translationFa":"اسم من لوتس اشمیت است.","correct":false},{"textTarget":"Ja, und Sie? Wie heißen Sie?","translationFa":"بله، و شما؟ اسمتان چیست؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-intro-review-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-intro-review-choice-1','act-de-a1-intro-review-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-intro-review-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-intro-review-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-intro-review-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-intro-review-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-intro-review-order',@lesson,3,'word_order','پرسش «اهل کجا هستید؟» را بساز.','بازسازی پرسش، تفاوت Woher با معرفی صرفِ نام را فعال می‌کند.',
 NULL,
 CAST('{"sourceText":"Woher kommen Sie?","sourceTextFa":"اهل کجا هستید؟","tokens":["Woher","kommen","Sie?"],"answer":["Woher","kommen","Sie?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-intro-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-bll-a1-lesson-2' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-intro-review-order-1','act-de-a1-intro-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-intro-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-intro-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-intro-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-intro-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-family-and-close-people' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-family-brother-profile',@level,@unit,4,1,'برادرتان چند ساله است؟','Wie alt ist euer Bruder? / Wie heißt euer Bruder?','برادرتان چند ساله است؟ / اسم برادرتان چیست؟','qa',
 'درس با دو پرسش واقعی دربارهٔ یک برادر شروع می‌شود؛ سپس واژه‌های اعضای خانواده تفکیک می‌شوند، اطلاعات خواهر در یک پرسش و پاسخ دیگر بازیابی می‌شود و در پایان پرسش نام برادر بازسازی می‌شود.','مسیر از فهم گفت‌وگوی خانوادگی به تشخیص واژه، بازیابی اطلاعات و بازسازی پرسش می‌رود. اطلاعات نام و سن از سطح قبل آشنا هستند و بار تازه روی رابطهٔ خانوادگی و مالکیت در بافت قرار می‌گیرد.','conversation_speaking>matching>multiple_choice>word_order',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-family-brother-profile' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-family-brother-profile';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-family-brother-profile-1','de-a1-lesson-family-brother-profile','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-family-brother-profile',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-family-brother-profile-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-brother-conversation',@lesson,1,'conversation_speaking','آیریس از شما و میا دربارهٔ برادرتان می‌پرسد؛ از طرف هر دو جواب بده.','مخاطب جمعِ منبع با حضور هم‌زمان پاول و میا در صحنه واقعی می‌شود و پاول می‌تواند پاسخ جمعِ منبع را بدون تغییر بیان کند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-family-brother-profile' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-brother-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-brother-conversation-1','act-de-a1-family-brother-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-brother-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-brother-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-brother-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-brother-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-brother-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-brother-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-words-matching',@lesson,2,'matching','هر عضو خانواده را به معنی درستش وصل کن.','چهار واژهٔ پرتکرار از همان تمرین خانواده جدا می‌شوند تا پیش از گسترش اطلاعات شخصی، رابطه‌ها روشن باشند.',
 NULL,
 CAST('{"pairs":[{"left":"Bruder","leftFa":"برادر","right":"برادر","rightFa":"برادر"},{"left":"Schwester","leftFa":"خواهر","right":"خواهر","rightFa":"خواهر"},{"left":"Mutter","leftFa":"مادر","right":"مادر","rightFa":"مادر"},{"left":"Vater","leftFa":"پدر","right":"پدر","rightFa":"پدر"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-words-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-words-matching-1','act-de-a1-family-words-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-words-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-words-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-words-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-words-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-sister-choice',@lesson,3,'multiple_choice','طبق جملهٔ منبع، خواهرشان کجا زندگی می‌کند؟','پرسش و پاسخ مربوط به خواهر، واژهٔ خانواده را با اطلاعات آشنای محل زندگی ترکیب می‌کند و دو گزینهٔ مقایسه‌ای نیز عین همان بخش منبع هستند.',
 NULL,
 CAST('{"options":[{"textTarget":"Unsere Schwester wohnt in Hamburg.","translationFa":"خواهر ما در هامبورگ زندگی می‌کند.","correct":true},{"textTarget":"Unser Bruder studiert in Berlin.","translationFa":"برادر ما در برلین تحصیل می‌کند.","correct":false},{"textTarget":"Unsere Mutter ist 66 Jahre alt.","translationFa":"مادر ما ۶۶ ساله است.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-sister-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-sister-choice-1','act-de-a1-family-sister-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-sister-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-sister-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-sister-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-sister-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-name-order',@lesson,4,'word_order','پرسش نام برادر را دوباره بساز.','در پایان، پرسش آشنای نام با واژهٔ خانوادگی و مالکیت جمع به‌صورت فعال بازیابی می‌شود.',
 NULL,
 CAST('{"sourceText":"Wie heißt euer Bruder?","sourceTextFa":"اسم برادرتان چیست؟","tokens":["Wie","heißt","euer","Bruder?"],"answer":["Wie","heißt","euer","Bruder?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-name-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-name-order-1','act-de-a1-family-name-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-name-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-name-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-name-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-name-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-family-and-close-people' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-family-parents-profile',@level,@unit,5,2,'مادر و پدرتان چند ساله‌اند؟','Wie alt ist eure Mutter? / Wie alt ist euer Vater?','مادرتان چند ساله است؟ / پدرتان چند ساله است؟','qa',
 'گفت‌وگوی آغازین سن مادر و پدر را در همان بافت خانوادگی تثبیت می‌کند؛ سپس پرسش شغل پدر بازسازی می‌شود، پاسخ شغلی از جمله‌های منبع‌دار تشخیص داده می‌شود و در پایان چهار اطلاعات خانوادگی به فرد درست وصل می‌شوند.','درس از فهم سن دو عضو خانواده به بازیابی پرسش شغل، تشخیص پاسخ و یکپارچه‌سازی اطلاعات چند عضو می‌رود؛ بنابراین مهارت‌های آشنای اطلاعات شخصی به شبکهٔ خانوادگی منتقل می‌شوند.','conversation_speaking>word_order>multiple_choice>matching',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-family-parents-profile' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-family-parents-profile';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-family-parents-profile-1','de-a1-lesson-family-parents-profile','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-family-parents-profile',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-family-parents-profile-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-parents-conversation',@lesson,1,'conversation_speaking','آیریس دربارهٔ سن مادر و پدرتان می‌پرسد؛ از طرف خودت و میا جواب بده.','دو جفت پرسش و پاسخ سن عین منبع هستند و با حضور دو خواهر و برادر، خطاب و پاسخ جمع بدون بازنویسی طبیعی می‌ماند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-family-parents-profile' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-parents-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-parents-conversation-1','act-de-a1-family-parents-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-parents-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-parents-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-parents-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-parents-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-parents-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-parents-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-father-job-order',@lesson,2,'word_order','پرسش شغل پدر را دوباره بساز.','پرسش شغل از همان تمرین خانواده می‌آید و اطلاعات کاریِ آموخته‌شده در واحد قبل را به یک عضو خانواده منتقل می‌کند.',
 NULL,
 CAST('{"sourceText":"Was ist euer Vater?","sourceTextFa":"شغل پدرتان چیست؟","tokens":["Was","ist","euer","Vater?"],"answer":["Was","ist","euer","Vater?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-father-job-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-father-job-order-1','act-de-a1-family-father-job-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-father-job-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-father-job-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-father-job-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-father-job-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-father-job-choice',@lesson,3,'multiple_choice','طبق منبع، شغل پدرشان چیست؟','پاسخ درست دربارهٔ شغل پدر در برابر دو جملهٔ خانوادگیِ منبع‌دار با اطلاعات متفاوت بازیابی می‌شود.',
 NULL,
 CAST('{"options":[{"textTarget":"Unser Vater ist Lehrer.","translationFa":"پدر ما معلم است.","correct":true},{"textTarget":"Unser Bruder heißt Uwe.","translationFa":"اسم برادر ما اووه است.","correct":false},{"textTarget":"Unsere Schwester wohnt in Hamburg.","translationFa":"خواهر ما در هامبورگ زندگی می‌کند.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-father-job-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-father-job-choice-1','act-de-a1-family-father-job-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-father-job-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-father-job-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-father-job-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-father-job-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-info-matching',@lesson,4,'matching','هر جمله را به اطلاعات درست خانواده وصل کن.','چهار جملهٔ منبع‌دار نام، سن و محل زندگی را میان اعضای خانواده تفکیک می‌کنند و فهم کلی واحد را جمع می‌کنند.',
 NULL,
 CAST('{"pairs":[{"left":"Unsere Mutter ist 66 Jahre alt.","leftFa":"مادر ما ۶۶ ساله است.","right":"سن مادر","rightFa":"سن مادر"},{"left":"Unser Vater ist 56 Jahre alt.","leftFa":"پدر ما ۵۶ ساله است.","right":"سن پدر","rightFa":"سن پدر"},{"left":"Unser Bruder heißt Uwe.","leftFa":"اسم برادر ما اووه است.","right":"نام برادر","rightFa":"نام برادر"},{"left":"Unsere Schwester wohnt in Hamburg.","leftFa":"خواهر ما در هامبورگ زندگی می‌کند.","right":"محل زندگی خواهر","rightFa":"محل زندگی خواهر"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-info-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-info-matching-1','act-de-a1-family-info-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-info-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-info-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-info-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-info-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-family-and-close-people' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-family-profile-review',@level,@unit,6,3,'برادرت کجا درس می‌خونه؟ خواهرت کجا زندگی می‌کنه؟','Wo studiert euer Bruder? / Wo wohnt eure Schwester?','برادرتان کجا درس می‌خواند؟ / خواهرتان کجا زندگی می‌کند؟','qa',
 'این درس محور تازهٔ مکان را به واحد خانواده اضافه می‌کند؛ دو درس قبلی بیشتر روی نام، سن و شغل متمرکز بودند.','مکالمه دو کاربرد مکان را معرفی می‌کند، تمرین تشخیص فعل‌ها را جدا می‌کند و بازسازی پرسشِ محل زندگی تولید هدایت‌شده می‌دهد.','conversation_speaking>multiple_choice>word_order',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-family-profile-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-family-profile-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-family-profile-review-1','de-a1-lesson-family-profile-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-family-profile-review',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-family-profile-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-review-conversation',@lesson,1,'conversation_speaking','دربارهٔ محل تحصیل برادر و محل زندگی خواهر گفت‌وگو کن.','دو جفت پرسش‌وپاسخ منبع‌دار اطلاعات مکانی تازه‌ای به پروفایل خانواده اضافه می‌کنند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-family-study-residence' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-review-conversation-1','act-de-a1-family-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-review-matching',@lesson,2,'multiple_choice','کدام جمله دربارهٔ محل تحصیل برادر است؟','تمرین تفاوت فعل‌های مربوط به تحصیل و زندگی را در همان بافت خانواده می‌سنجد.',
 NULL,
 CAST('{"options":[{"textTarget":"Unser Bruder studiert in Berlin.","translationFa":"برادر ما در برلین درس می‌خواند.","correct":true},{"textTarget":"Unsere Schwester wohnt in Hamburg.","translationFa":"خواهر ما در هامبورگ زندگی می‌کند.","correct":false},{"textTarget":"Unser Vater ist LKW-Fahrer.","translationFa":"پدر ما رانندهٔ کامیون است.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-review-matching-1','act-de-a1-family-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-review-matching',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-family-review-order',@lesson,3,'word_order','پرسش محل زندگی خواهر را بساز.','پرسش Wo + wohnen برای انتقال مهارت از فهم به تولید هدایت‌شده انتخاب شده است.',
 NULL,
 CAST('{"sourceText":"Wo wohnt eure Schwester?","sourceTextFa":"خواهرتان کجا زندگی می‌کند؟","tokens":["Wo","wohnt","eure","Schwester?"],"answer":["Wo","wohnt","eure","Schwester?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-family-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-family-review-order-1','act-de-a1-family-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-family-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-family-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-home-and-nearby' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-room-table-lamp',@level,@unit,7,1,'این میز شماست؟','Ist das Ihr Tisch? / Ist das Ihre Lampe?','آیا این میز شماست؟ / آیا این چراغ شماست؟','qa',
 'درس با دو جفت پرسش و پاسخ دربارهٔ وسایل یک اتاق شروع می‌شود؛ سپس چهار واژهٔ پایهٔ محیط خانه تفکیک می‌شوند، پاسخ درست به پرسش چراغ بازیابی می‌شود و در پایان پرسش میز بازسازی می‌شود.','مسیر از فهم تعامل و تشخیص شیء به تثبیت واژگان، انتخاب پاسخ و بازیابی فعال پرسش می‌رود. مالکیت در بافت جمله باقی می‌ماند و به توضیح انتزاعی دستور زبان تبدیل نمی‌شود.','conversation_speaking>matching>multiple_choice>word_order',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-room-table-lamp' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-room-table-lamp';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-room-table-lamp-1','de-a1-lesson-room-table-lamp','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-room-table-lamp',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-room-table-lamp-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-room-objects-conversation',@lesson,1,'conversation_speaking','آیریس دربارهٔ میز و چراغ می‌پرسد؛ جواب بده کدام وسیله مال توست.','دو جفت پرسش و پاسخ عین منبع هستند و در یک صحنهٔ واحدِ اتاق و وسایل آن طبیعی می‌مانند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-room-table-lamp' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-room-objects-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-room-objects-conversation-1','act-de-a1-room-objects-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-objects-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-objects-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-objects-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-objects-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-objects-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-objects-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-room-words-matching',@lesson,2,'matching','هر وسیله را به معنی درستش وصل کن.','چهار واژهٔ پایهٔ محیط اتاق پیش از گسترش توصیف خانه تثبیت می‌شوند.',
 NULL,
 CAST('{"pairs":[{"left":"Zimmer","leftFa":"اتاق","right":"اتاق","rightFa":"اتاق"},{"left":"Tisch","leftFa":"میز","right":"میز","rightFa":"میز"},{"left":"Lampe","leftFa":"چراغ / لامپ","right":"چراغ / لامپ","rightFa":"چراغ / لامپ"},{"left":"Stuhl","leftFa":"صندلی","right":"صندلی","rightFa":"صندلی"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-room-words-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-room-words-matching-1','act-de-a1-room-words-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-words-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-words-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-words-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-words-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-room-lamp-choice',@lesson,3,'multiple_choice','پاسخ درست به پرسش دربارهٔ چراغ کدام است؟','پاسخ درست چراغ در برابر دو پاسخ منبع‌دار مربوط به وسایل دیگر بازیابی می‌شود.',
 NULL,
 CAST('{"options":[{"textTarget":"Ja, das ist meine Lampe.","translationFa":"بله، این چراغ من است.","correct":true},{"textTarget":"Ja, das ist mein Tisch.","translationFa":"بله، این میز من است.","correct":false},{"textTarget":"Ja, das ist unser Zimmer.","translationFa":"بله، این اتاق ماست.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-room-lamp-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-room-lamp-choice-1','act-de-a1-room-lamp-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-lamp-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-lamp-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-lamp-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-lamp-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-room-table-order',@lesson,4,'word_order','پرسش دربارهٔ میز را دوباره بساز.','پرسش اصلی درس در پایان از تشخیص به بازیابی فعال منتقل می‌شود.',
 NULL,
 CAST('{"sourceText":"Ist das Ihr Tisch?","sourceTextFa":"آیا این میز شماست؟","tokens":["Ist","das","Ihr","Tisch?"],"answer":["Ist","das","Ihr","Tisch?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-room-table-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-room-table-order-1','act-de-a1-room-table-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-table-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-table-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-table-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-table-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-home-and-nearby' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-room-position',@level,@unit,8,2,'پنجره کدام طرف است؟','Ist das Fenster rechts? / Steht der Stuhl hinten?','آیا پنجره سمت راست است؟ / آیا صندلی عقب قرار دارد؟','qa',
 'گفت‌وگوی آغازین دو محور مکانی راست و چپ و جلو و عقب را وارد می‌کند؛ سپس ویژگی کوچک بودن خانه تشخیص داده می‌شود، پرسش موقعیت صندلی بازسازی می‌شود و در پایان چهار قید مکانی به معنی درست وصل می‌شوند.','درس از فهم موقعیت در بافت به تشخیص ویژگی، بازیابی فعال پرسش و تثبیت شبکهٔ واژگان مکانی می‌رود و الگوی آن با درس قبلی متفاوت است.','conversation_speaking>multiple_choice>word_order>matching',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-room-position' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-room-position';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-room-position' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-room-position-1','de-a1-lesson-room-position','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-room-position',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-room-position-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-room-position-conversation',@lesson,1,'conversation_speaking','آیریس دربارهٔ جای پنجره و صندلی می‌پرسد؛ موقعیت درست را جواب بده.','دو جفت پرسش و پاسخِ منبع‌دار، دو تضاد مکانی پایه را در یک صحنهٔ اتاق تمرین می‌کنند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-room-position' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-room-position-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-room-position' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-room-position-conversation-1','act-de-a1-room-position-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-position-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-position-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-position-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-position-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-room-position-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-room-position-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-home-small-choice',@lesson,2,'multiple_choice','کدام جملهٔ منبع می‌گوید خانه کوچک است؟','ویژگی سادهٔ خانه از میان سه جملهٔ منبع‌دار با موضوع‌های متفاوت تشخیص داده می‌شود.',
 NULL,
 CAST('{"options":[{"textTarget":"Ist das Haus klein? - Ja, es ist klein.","translationFa":"آیا خانه کوچک است؟ بله، کوچک است.","correct":true},{"textTarget":"Ist die Lampe alt? - Nein, sie ist neu.","translationFa":"آیا چراغ قدیمی است؟ نه، نو است.","correct":false},{"textTarget":"Ist das Fenster rechts? - Nein, es ist links.","translationFa":"آیا پنجره سمت راست است؟ نه، سمت چپ است.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-home-small-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-room-position' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-home-small-choice-1','act-de-a1-home-small-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-small-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-small-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-small-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-small-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-chair-position-order',@lesson,3,'word_order','پرسش دربارهٔ جای صندلی را دوباره بساز.','پرسش مکانیِ گفت‌وگو پس از فهم آن به بازیابی فعال منتقل می‌شود.',
 NULL,
 CAST('{"sourceText":"Steht der Stuhl hinten?","sourceTextFa":"آیا صندلی عقب قرار دارد؟","tokens":["Steht","der","Stuhl","hinten?"],"answer":["Steht","der","Stuhl","hinten?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-chair-position-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-room-position' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-chair-position-order-1','act-de-a1-chair-position-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-chair-position-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-chair-position-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-chair-position-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-chair-position-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-position-words-matching',@lesson,4,'matching','هر موقعیت را به معنی درستش وصل کن.','چهار قید مکانیِ موجود در همان بخش منبع به‌صورت شبکهٔ دو تضاد تثبیت می‌شوند.',
 NULL,
 CAST('{"pairs":[{"left":"rechts","leftFa":"سمت راست","right":"سمت راست","rightFa":"سمت راست"},{"left":"links","leftFa":"سمت چپ","right":"سمت چپ","rightFa":"سمت چپ"},{"left":"hinten","leftFa":"عقب","right":"عقب","rightFa":"عقب"},{"left":"vorn","leftFa":"جلو","right":"جلو","rightFa":"جلو"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-position-words-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-room-position' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-position-words-matching-1','act-de-a1-position-words-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-position-words-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-position-words-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-position-words-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-position-words-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-home-and-nearby' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-home-description-review',@level,@unit,9,3,'وسایلم کجاست؟','Wo ist mein Heft? / Wo ist meine Tasche?','دفترم کجاست؟ / کیفم کجاست؟','qa',
 'به‌جای مرور جهت‌های اتاق، این درس یک نیاز واقعی تازه را پوشش می‌دهد: پیدا کردن وسایل شخصی و پاسخ‌دادن با شکل مؤدبانهٔ مالکیت.','مکالمه مفرد را معرفی می‌کند، تمرین تشخیص مفرد/جمع را گسترش می‌دهد و تطبیق چند وسیله دامنه را وسیع‌تر می‌کند.','conversation_speaking>multiple_choice>matching',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-home-description-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-home-description-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-home-description-review-1','de-a1-lesson-home-description-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-home-description-review',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-home-description-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-home-review-conversation',@lesson,1,'conversation_speaking','وسایل گم‌شده را بپرس و پاسخ محل آن‌ها را بده.','مکالمهٔ منبع‌دار mein/meine و Ihr/Ihre را در موقعیت پیدا کردن وسایل فعال می‌کند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-find-belongings' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-home-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-home-review-conversation-1','act-de-a1-home-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-home-review-order',@lesson,2,'multiple_choice','اگر دربارهٔ چند کتاب صحبت می‌کنیم، کدام پاسخ درست است؟','مفرد و جمع با پاسخ‌های واقعی همان تمرین از هم تفکیک می‌شوند.',
 NULL,
 CAST('{"options":[{"textTarget":"Ihre Bücher sind hier.","translationFa":"کتاب‌های شما اینجاست.","correct":true},{"textTarget":"Ihr Heft ist hier.","translationFa":"دفتر شما اینجاست.","correct":false},{"textTarget":"Ihre Tasche ist hier.","translationFa":"کیف شما اینجاست.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-home-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-home-review-order-1','act-de-a1-home-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-review-order',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-home-review-matching',@lesson,3,'matching','هر سؤال را به پاسخ درستش وصل کن.','چهار جفت منبع‌دار دامنه را از دفتر و کیف به مداد و کتاب‌ها گسترش می‌دهند.',
 NULL,
 CAST('{"pairs":[{"left":"Wo ist mein Heft?","leftFa":"دفترم کجاست؟","right":"Ihr Heft ist hier.","rightFa":"دفتر شما اینجاست."},{"left":"Wo ist mein Bleistift?","leftFa":"مدادم کجاست؟","right":"Ihr Bleistift ist hier.","rightFa":"مداد شما اینجاست."},{"left":"Wo ist meine Tasche?","leftFa":"کیفم کجاست؟","right":"Ihre Tasche ist hier.","rightFa":"کیف شما اینجاست."},{"left":"Wo sind meine Bücher?","leftFa":"کتاب‌هایم کجاست؟","right":"Ihre Bücher sind hier.","rightFa":"کتاب‌های شما اینجاست."}],"pairMode":"target_to_target"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-home-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-room-objects' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-home-review-matching-1','act-de-a1-home-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-review-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-home-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-home-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-daily-routine-work-school' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-daily-routine-work',@level,@unit,10,1,'صبح‌ها چه کار می‌کنی؟','Was machen Sie morgens? / Was machen Sie vormittags?','صبح‌ها چه کار می‌کنید؟ / پیش از ظهرها چه کار می‌کنید؟','qa',
 'گفت‌وگو دو بخش نخست روز را در بافت وارد می‌کند؛ سپس چهار جملهٔ منبع‌دار به زمان مناسب وصل می‌شوند، جملهٔ مربوط به کار تشخیص داده می‌شود و در پایان پاسخ صبح بازسازی می‌شود.','درس از تعامل و فهم زمان روز به دسته‌بندی، تمایز معنایی و بازیابی فعال یک پاسخ کوتاه حرکت می‌کند و الگوی فعالیت آن با درس قبلی متفاوت است.','conversation_speaking>matching>multiple_choice>word_order',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-daily-routine-work' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-daily-routine-work';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-daily-routine-work-1','de-a1-lesson-daily-routine-work','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-daily-routine-work',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-daily-routine-work-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-daily-routine-conversation',@lesson,1,'conversation_speaking','به آیریس بگو صبح و پیش از ظهر معمولاً چه کار می‌کنی.','دو جفت پرسش و پاسخ منبع‌دار، روتین صبح و کار پیش از ظهر را بدون توضیح دستوری سنگین وارد می‌کنند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-daily-routine-work' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-daily-routine-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-daily-routine-conversation-1','act-de-a1-daily-routine-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-routine-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-routine-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-routine-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-routine-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-routine-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-routine-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-dayparts-matching',@lesson,2,'matching','هر جمله را به بخش درست روز وصل کن.','چهار پاسخ کامل از همان بخش منبع، ترتیب زمانی صبح تا بعدازظهر را با کارهای واقعی روزمره پیوند می‌دهند.',
 NULL,
 CAST('{"pairs":[{"left":"Morgens trinke ich Kaffee.","leftFa":"صبح‌ها قهوه می‌نوشم.","right":"صبح","rightFa":"صبح"},{"left":"Vormittags arbeite ich im Betrieb.","leftFa":"پیش از ظهرها در محل کار کار می‌کنم.","right":"پیش از ظهر","rightFa":"پیش از ظهر"},{"left":"Mittags esse ich in einem Restaurant.","leftFa":"ظهرها در یک رستوران غذا می‌خورم.","right":"ظهر","rightFa":"ظهر"},{"left":"Nachmittags gehe ich nach Hause.","leftFa":"بعدازظهرها به خانه می‌روم.","right":"بعدازظهر","rightFa":"بعدازظهر"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-dayparts-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-dayparts-matching-1','act-de-a1-dayparts-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-dayparts-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-dayparts-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-dayparts-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-dayparts-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-routine-work-choice',@lesson,3,'multiple_choice','کدام جمله دربارهٔ کار کردن پیش از ظهر است؟','سه پاسخ کامل و منبع‌دار از همان تمرین، کار را از نوشیدن و غذا خوردن جدا می‌کنند.',
 NULL,
 CAST('{"options":[{"textTarget":"Vormittags arbeite ich im Betrieb.","translationFa":"پیش از ظهرها در محل کار کار می‌کنم.","correct":true},{"textTarget":"Morgens trinke ich Tee.","translationFa":"صبح‌ها چای می‌نوشم.","correct":false},{"textTarget":"Mittags esse ich in einem Restaurant.","translationFa":"ظهرها در یک رستوران غذا می‌خورم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-routine-work-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-routine-work-choice-1','act-de-a1-routine-work-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-routine-work-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-routine-work-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-routine-work-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-routine-work-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-morning-answer-order',@lesson,4,'word_order','پاسخ مربوط به صبح را دوباره بساز.','پاسخ آغاز گفت‌وگو پس از فهم و تمایز به بازیابی فعال منتقل می‌شود.',
 NULL,
 CAST('{"sourceText":"Morgens trinke ich Kaffee.","sourceTextFa":"صبح‌ها قهوه می‌نوشم.","tokens":["Morgens","trinke","ich","Kaffee."],"answer":["Morgens","trinke","ich","Kaffee."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-morning-answer-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-morning-answer-order-1','act-de-a1-morning-answer-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-morning-answer-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-morning-answer-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-morning-answer-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-morning-answer-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-daily-routine-work-school' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-daily-routine-school',@level,@unit,11,2,'مدرسه و برگشت به خانه','Was machen Sie vormittags? / Was machen Sie nachmittags?','پیش از ظهرها چه کار می‌کنید؟ / بعدازظهرها چه کار می‌کنید؟','qa',
 'گفت‌وگوی چهار نوبتی مدرسه و برگشت به خانه را در دو بخش روز وارد می‌کند؛ سپس جملهٔ مدرسه از گزینه‌های منبع‌دار جدا می‌شود، همان جمله بازسازی می‌شود و در پایان زبان‌آموز پاسخ درستِ پرسش بعدازظهر را انتخاب می‌کند.','درس از تعامل به تمایز معنایی، بازیابی فعال جمله و انتخاب پاسخ مناسب در بافت می‌رود؛ بنابراین پس از درس قبلی به‌جای تکرار تطبیق زمان‌ها روی مدرسه و حرکت روزانه تمرکز می‌کند.','conversation_speaking>multiple_choice>word_order>choose_response',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-daily-routine-school' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-daily-routine-school';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-daily-routine-school-1','de-a1-lesson-daily-routine-school','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-daily-routine-school',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-daily-routine-school-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-daily-school-conversation',@lesson,1,'conversation_speaking','به آیریس بگو پیش از ظهر و بعدازظهر چه کار می‌کنی.','دو جفت پرسش و پاسخ منبع‌دار، مدرسه و برگشت به خانه را در یک توالی روزانهٔ کوتاه قرار می‌دهند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-daily-routine-school' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-daily-school-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-daily-school-conversation-1','act-de-a1-daily-school-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-school-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-school-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-school-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-school-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-school-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-school-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-school-sentence-choice',@lesson,2,'multiple_choice','کدام جمله می‌گوید فرد پیش از ظهر به مدرسه می‌رود؟','سه پاسخ کامل از همان منبع، مدرسه را از کار و غذا خوردن جدا می‌کنند.',
 NULL,
 CAST('{"options":[{"textTarget":"Vormittags gehe ich in die Schule.","translationFa":"پیش از ظهرها به مدرسه می‌روم.","correct":true},{"textTarget":"Vormittags arbeite ich im Betrieb.","translationFa":"پیش از ظهرها در محل کار کار می‌کنم.","correct":false},{"textTarget":"Mittags esse ich in einem Restaurant.","translationFa":"ظهرها در یک رستوران غذا می‌خورم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-school-sentence-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-school-sentence-choice-1','act-de-a1-school-sentence-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-school-sentence-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-school-sentence-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-school-sentence-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-school-sentence-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-school-sentence-order',@lesson,3,'word_order','جملهٔ رفتن به مدرسه را دوباره بساز.','پس از تشخیص معنایی، پاسخ مدرسه به بازیابی فعال منتقل می‌شود.',
 NULL,
 CAST('{"sourceText":"Vormittags gehe ich in die Schule.","sourceTextFa":"پیش از ظهرها به مدرسه می‌روم.","tokens":["Vormittags","gehe","ich","in","die","Schule."],"answer":["Vormittags","gehe","ich","in","die","Schule."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-school-sentence-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-school-sentence-order-1','act-de-a1-school-sentence-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-school-sentence-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-school-sentence-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-school-sentence-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-school-sentence-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-afternoon-response-choice',@lesson,4,'choose_response','برای پرسش بعدازظهر، پاسخ درست را انتخاب کن.','زبان‌آموز باید پاسخ متناسب با همان پرسش زمانی را از میان پاسخ‌های واقعی منبع پیدا کند.',
 NULL,
 CAST('{"promptTarget":"Was machen Sie nachmittags?","promptFa":"بعدازظهرها چه کار می‌کنید؟","options":[{"textTarget":"Nachmittags gehe ich nach Hause.","translationFa":"بعدازظهرها به خانه می‌روم.","correct":true},{"textTarget":"Morgens trinke ich Kaffee.","translationFa":"صبح‌ها قهوه می‌نوشم.","correct":false},{"textTarget":"Mittags esse ich in einem Restaurant.","translationFa":"ظهرها در یک رستوران غذا می‌خورم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-afternoon-response-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-afternoon-response-choice-1','act-de-a1-afternoon-response-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-afternoon-response-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-afternoon-response-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-afternoon-response-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-afternoon-response-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-daily-routine-work-school' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-daily-routine-day-review',@level,@unit,12,3,'بعدازظهر و شب چه کار می‌کنی؟','Was machen Sie nachmittags? / Was machen Sie abends?','بعدازظهرها چه کار می‌کنید؟ / شب‌ها چه کار می‌کنید؟','qa',
 'دو درس قبلی صبح، کار، مدرسه و برگشت به خانه را پوشش می‌دهند؛ این درس عمداً دامنه را به خرید بعدازظهر و فعالیت‌های شب گسترش می‌دهد.','ابتدا دو بخش تازهٔ روز در مکالمه می‌آیند، سپس تشخیص زمان سنجیده می‌شود و در پایان جملهٔ شب بازسازی می‌شود.','conversation_speaking>multiple_choice>word_order',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-daily-routine-day-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-daily-routine-day-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-daily-routine-day-review-1','de-a1-lesson-daily-routine-day-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-daily-routine-day-review',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-daily-routine-day-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-daily-review-conversation',@lesson,1,'conversation_speaking','برنامهٔ بعدازظهر و شب را در گفت‌وگو دنبال کن.','دو پاسخ استفاده‌نشدهٔ منبع، نیمهٔ دوم روز را به روتین اضافه می‌کنند.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-afternoon-evening-routine' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-daily-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-daily-review-conversation-1','act-de-a1-daily-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-daily-review-matching',@lesson,2,'multiple_choice','کدام جمله دربارهٔ بعدازظهر است؟','زبان‌آموز باید نشانهٔ زمانی و محتوای فعالیت را هم‌زمان تشخیص دهد.',
 NULL,
 CAST('{"options":[{"textTarget":"Nachmittags gehe ich in die Stadt und mache Einkäufe.","translationFa":"بعدازظهرها به شهر می‌روم و خرید می‌کنم.","correct":true},{"textTarget":"Abends höre ich Radio, sehe fern und lese Zeitung.","translationFa":"شب‌ها رادیو گوش می‌دهم، تلویزیون می‌بینم و روزنامه می‌خوانم.","correct":false},{"textTarget":"Vormittags arbeite ich im Betrieb.","translationFa":"پیش از ظهرها در محل کار کار می‌کنم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-daily-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-daily-review-matching-1','act-de-a1-daily-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-review-matching',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-daily-review-response',@lesson,3,'word_order','جملهٔ فعالیت‌های شب را دوباره بساز.','بازسازی یک جملهٔ چندفعلی ساده، دامنهٔ روتین را فراتر از یک فعل منفرد می‌برد.',
 NULL,
 CAST('{"sourceText":"Abends höre ich Radio, sehe fern und lese Zeitung.","sourceTextFa":"شب‌ها رادیو گوش می‌دهم، تلویزیون می‌بینم و روزنامه می‌خوانم.","tokens":["Abends","höre","ich","Radio,","sehe","fern","und","lese","Zeitung."],"answer":["Abends","höre","ich","Radio,","sehe","fern","und","lese","Zeitung."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-daily-review-response';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-022-daily-routine' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-daily-review-response-1','act-de-a1-daily-review-response','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-review-response',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-review-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-daily-review-response',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-daily-review-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-shopping-quantity-payment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(
 lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,
 activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes
) VALUES (
 'de-a1-lesson-shopping-price-review',@level,@unit,13,1,'چی لازم داری؟ چی می‌خری؟','Was brauchen Sie? / Was kaufen Sie?','چه چیزی لازم دارید؟ / چه چیزی می‌خرید؟','qa',
 'این درس پیش از تراکنش مقدار و پرداخت، مرحلهٔ واقعیِ انتخاب کالا را اضافه می‌کند: اول نیاز، بعد تصمیم خرید.','مکالمه تفاوت دو فعل را در یک کالای ثابت روشن می‌کند؛ تطبیق نمونه‌ها دامنه را گسترش می‌دهد و بازسازی پرسش نیاز تولید هدایت‌شده می‌دهد.','conversation_speaking>matching>word_order',
 'pending',NULL
)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),
 title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),
 activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),
 template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-shopping-price-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-shopping-price-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-shopping-price-review-1','de-a1-lesson-shopping-price-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-shopping-price-review',id,'other','پیوند رسمی منبع درس.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-shopping-price-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-shopping-price-review-conversation',@lesson,1,'conversation_speaking','بگو چه چیزی لازم داری و بعد چه چیزی می‌خری.','ثابت نگه‌داشتن کالا باعث می‌شود تفاوت brauchen و kaufen بدون حواس‌پرتی واژگانی دیده شود.',
 (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-shopping-needs-buying' LIMIT 1),
 CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-price-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-conversation-1','act-de-a1-shopping-price-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-shopping-price-review-matching',@lesson,2,'matching','هر جمله را به «نیاز» یا «خرید» وصل کن.','نمونه‌های مختلفِ لباس و کالا الگوی فعل را از یک مثال منفرد جدا می‌کنند.',
 NULL,
 CAST('{"pairs":[{"left":"Ich brauche eine Tasche.","leftFa":"یک کیف لازم دارم.","right":"نیاز: Tasche","rightFa":"نیاز: کیف"},{"left":"Ich brauche eine Hose.","leftFa":"یک شلوار لازم دارم.","right":"نیاز: Hose","rightFa":"نیاز: شلوار"},{"left":"Ich kaufe eine Tasche.","leftFa":"یک کیف می‌خرم.","right":"خرید: Tasche","rightFa":"خرید: کیف"},{"left":"Ich kaufe ein Paar Schuhe.","leftFa":"یک جفت کفش می‌خرم.","right":"خرید: Schuhe","rightFa":"خرید: کفش"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-price-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-matching-1','act-de-a1-shopping-price-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-review-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(
 activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status
) VALUES (
 'act-de-a1-shopping-price-review-order',@lesson,3,'word_order','پرسش «چه چیزی لازم دارید؟» را بساز.','پرسش پایهٔ نیاز برای شروع خرید به بازیابی فعال منتقل می‌شود.',
 NULL,
 CAST('{"sourceText":"Was brauchen Sie?","sourceTextFa":"چه چیزی لازم دارید؟","tokens":["Was","brauchen","Sie?"],"answer":["Was","brauchen","Sie?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required'
)
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-price-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-order-1','act-de-a1-shopping-price-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.'
FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id
FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit
WHERE a.lesson_id=@lesson;
DELETE p FROM provenance_links p LEFT JOIN activities a ON a.activity_key=p.entity_key WHERE p.entity_type='activity' AND a.id IS NULL;


-- Canonical A1 lesson/activity sync, batch 2 of 3.

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-shopping-quantity-payment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-shopping-quantity-payment',@level,@unit,14,2,'چقدر می‌خواهید؟','Wie viel kostet dieses Fleisch? / Wie viel möchten Sie?','این گوشت چقدر است؟ / چه مقدار می‌خواهید؟','qa','گفت‌وگوی کامل تراکنش را در بافت می‌آورد؛ تطبیق چهار کالای دیگر مقدار را به قیمت وصل می‌کند، انتخاب پاسخ مقدار فهم نوبت فروشنده را می‌سنجد و مرتب‌سازی جملهٔ پرداخت آخرین مرحلهٔ خرید را فعال می‌کند.','درس از مشارکت در یک تراکنش واقعی به خواندن مقدار و قیمت، انتخاب پاسخ مناسب و در پایان بازیابی هدایت‌شدهٔ دستور پرداخت حرکت می‌کند.','conversation_speaking>matching>choose_response>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-shopping-quantity-payment' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-shopping-quantity-payment';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-shopping' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-shopping-quantity-payment-1','de-a1-lesson-shopping-quantity-payment','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-shopping-quantity-payment',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-shopping-quantity-payment-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-shopping-conversation',@lesson,1,'conversation_speaking','خرید را از پرسیدن قیمت تا رسیدن به صندوق انجام بده.','گفت‌وگوی هشت‌نوبتی منبع همهٔ مراحل اصلی تراکنش این واحد را به‌صورت پیوسته دارد.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-shopping-quantity-payment' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["verbatim_dialogue","other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-shopping' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-conversation-1','act-de-a1-shopping-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-shopping-price-matching',@lesson,2,'matching','هر مقدار کالا را به قیمت منبع‌دار خودش وصل کن.','چهار نمونهٔ بخش ۴۱۰ مقدارهای متفاوت و چند کالای روزمره را با قیمت واقعی تمرین پیوند می‌دهند.',NULL,CAST('{"pairs":[{"left":"300 g Wurst","leftFa":"۳۰۰ گرم سوسیس","right":"5,99 Euro","rightFa":"۵٫۹۹ یورو"},{"left":"250 g Butter","leftFa":"۲۵۰ گرم کره","right":"3,95 Euro","rightFa":"۳٫۹۵ یورو"},{"left":"zwei Flaschen Milch","leftFa":"دو بطری شیر","right":"2,99 Euro","rightFa":"۲٫۹۹ یورو"},{"left":"fünf Eier","leftFa":"پنج تخم‌مرغ","right":"2,67 Euro","rightFa":"۲٫۶۷ یورو"}],"pairMode":"target_to_target"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-price-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-shopping' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-price-matching-1','act-de-a1-shopping-price-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-price-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-price-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-shopping-quantity-response',@lesson,3,'choose_response','فروشنده مقدار را می‌پرسد؛ پاسخ درست را انتخاب کن.','پاسخ مقدار باید از دو نوبت دیگرِ همان تراکنش متمایز شود.',NULL,CAST('{"promptTarget":"Wie viel möchten Sie?","promptFa":"چه مقدار می‌خواهید؟","options":[{"textTarget":"Bitte 250 Gramm.","translationFa":"لطفاً ۲۵۰ گرم.","correct":true},{"textTarget":"Noch etwas?","translationFa":"چیز دیگری؟","correct":false},{"textTarget":"Danke, das ist alles.","translationFa":"ممنون، همین کافی است.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-quantity-response';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-shopping' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-quantity-response-1','act-de-a1-shopping-quantity-response','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-quantity-response',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-quantity-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-quantity-response',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-quantity-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-shopping-payment-order',@lesson,4,'word_order','دستور پرداخت را دوباره بساز.','آخرین مرحلهٔ تراکنش از فهم شنیداری و خواندن به بازیابی فعال جملهٔ پرداخت منتقل می‌شود.',NULL,CAST('{"sourceText":"Bezahlen Sie bitte dort.","sourceTextFa":"لطفاً آنجا پرداخت کنید.","tokens":["Bezahlen","Sie","bitte","dort."],"answer":["Bezahlen","Sie","bitte","dort."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-payment-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-009-shopping' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-payment-order-1','act-de-a1-shopping-payment-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-payment-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-payment-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-payment-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-payment-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-shopping-quantity-payment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-shopping-checkout-review',@level,@unit,15,3,'قیمت دقیق و جمع خرید','Wie viel kostet das? / Was kostet das?','این چقدر قیمت دارد؟ / قیمت این چقدر است؟','qa','به‌جای تکرار صندوقِ درس اصلی، این درس خواندن دقیق یورو/سنت و تفاوت قیمت یک کالا با جمع کل را آموزش می‌دهد.','مکالمه دو صورت پرسش قیمت را معرفی می‌کند، انتخاب چند صورت پرسش را مقایسه می‌کند و در پایان جمع کل با عدد دقیق تکمیل می‌شود.','conversation_speaking>multiple_choice>fill_blank','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-shopping-checkout-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-shopping-checkout-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-shopping-checkout-review-1','de-a1-lesson-shopping-checkout-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-shopping-checkout-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-shopping-checkout-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-shopping-checkout-review-conversation',@lesson,1,'conversation_speaking','دو روش پرسیدن قیمت و پاسخ یورو/سنت را اجرا کن.','جمله‌های منبع‌دار مهارت خواندن قیمت دقیق را مستقل از مقدار کالا تمرین می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-shopping-price-total' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-checkout-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-conversation-1','act-de-a1-shopping-checkout-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-checkout-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-checkout-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-checkout-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-shopping-checkout-review-response',@lesson,2,'multiple_choice','کدام پرسش دربارهٔ جمع کل خرید است؟','تفاوت kostet با macht در کاربرد فروشگاهی به‌صورت معنایی سنجیده می‌شود.',NULL,CAST('{"options":[{"textTarget":"Wie viel macht das bitte?","translationFa":"جمعش لطفاً چقدر می‌شود؟","correct":true},{"textTarget":"Wie viel kostet das?","translationFa":"این چقدر قیمت دارد؟","correct":false},{"textTarget":"Was kostet das?","translationFa":"قیمت این چقدر است؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-checkout-review-response';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-response-1','act-de-a1-shopping-checkout-review-response','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-checkout-review-response',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-checkout-review-response',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-shopping-checkout-review-order',@lesson,3,'fill_blank','جمع کل را با عدد درست کامل کن.','تمرین عدد دقیق یورو و سنت، فهم شنیداری/خواندنی قیمت را به بازیابی هدایت‌شده وصل می‌کند.',NULL,CAST('{"sourceText":"Das macht 63 Euro und 10 Cent.","sourceTextFa":"جمعش ۶۳ یورو و ۱۰ سنت می‌شود.","blankedText":"Das macht ___.","blankedTextFa":"جمعش ___ می‌شود.","choices":["63 Euro und 10 Cent","35 Euro und 15 Cent","70 Euro und 92 Cent"],"choicesFa":["۶۳ یورو و ۱۰ سنت","۳۵ یورو و ۱۵ سنت","۷۰ یورو و ۹۲ سنت"],"answer":"63 Euro und 10 Cent"}' AS JSON),CAST('["source_sentence_blank_created","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-shopping-checkout-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-order-1','act-de-a1-shopping-checkout-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-checkout-review-order',id,'source_sentence_blank_created','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-shopping-checkout-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-shopping-checkout-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-expanded-food-order' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-food-preference-review',@level,@unit,16,1,'قهوه‌ات رو چطور می‌خوای؟','Was möchten Sie? / Mit Milch und Zucker?','چه میل دارید؟ / با شیر و شکر؟','qa','این درس به‌جای مرور دوست‌داشتن/نداشتن، مهارت تازهٔ شخصی‌سازی سفارش را اضافه می‌کند؛ چیزی که در سفارش واقعی بسیار پرتکرار است.','پس از سفارش و انتخاب پاسخ، جملهٔ کاربردی بازسازی می‌شود و در پایان Ö و Ü با نمونه‌های دقیق منبع تمرین می‌شوند.','conversation_speaking>choose_response>word_order>pronunciation_read','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-food-preference-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-food-preference-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-food-preference-review-1','de-a1-lesson-food-preference-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-food-preference-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-food-preference-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-pronunciation-umlauts' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-food-preference-review-2','de-a1-lesson-food-preference-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-food-preference-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-food-preference-review-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-food-preference-review-conversation',@lesson,1,'conversation_speaking','قهوه سفارش بده و دقیق بگو چه چیزی داخلش می‌خواهی.','چهار نوبت منبع‌دار سفارش و شخصی‌سازی نوشیدنی را به‌صورت پیوسته تمرین می‌کنند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-coffee-customization' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-food-preference-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-conversation-1','act-de-a1-food-preference-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-preference-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-preference-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-preference-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-food-preference-review-choice',@lesson,2,'choose_response','برای «Mit Milch und Zucker?» پاسخ درست را انتخاب کن.','پاسخ فقط با شکر مستقیماً مهارت تعیین ترجیح در سفارش را می‌سنجد.',NULL,CAST('{"promptTarget":"Mit Milch und Zucker?","promptFa":"با شیر و شکر؟","options":[{"textTarget":"Bitte nur mit Zucker.","translationFa":"لطفاً فقط با شکر.","correct":true},{"textTarget":"Bitte eine Tasse Kaffee.","translationFa":"لطفاً یک فنجان قهوه.","correct":false},{"textTarget":"Gibt es auch Kuchen?","translationFa":"کیک هم دارید؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-food-preference-review-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-choice-1','act-de-a1-food-preference-review-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-preference-review-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-preference-review-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-food-preference-review-order',@lesson,3,'word_order','بعد از نوشیدنی بپرس آیا کیک هم هست.','این پرسش سفارش را از یک قلم به بررسی قلم دوم گسترش می‌دهد.',NULL,CAST('{"sourceText":"Gibt es auch Kuchen?","sourceTextFa":"کیک هم هست؟","tokens":["Gibt","es","auch","Kuchen?"],"answer":["Gibt","es","auch","Kuchen?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-food-preference-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-order-1','act-de-a1-food-preference-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-preference-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-preference-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-preference-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-food-preference-umlaut',@lesson,4,'pronunciation_read','این چهار نمونهٔ منبع‌دار را با تمرکز روی Ö و Ü با صدای بلند بخوان.','نمونه‌ها عین بخش تلفظ واکه‌های دگرگون‌شده در Deutsch im Blick هستند و تمرین تلفظ را به واژگان آشنای همان منبع وصل می‌کنند.',NULL,CAST('{"lines":["die Körbe","ich möchte","die Bücher","die Küche"],"audioTextTargetFa":"چهار نمونهٔ تلفظی برای Ö و Ü."}' AS JSON),CAST('["source_items_grouped_for_pronunciation"]' AS JSON),'die Körbe
ich möchte
die Bücher
die Küche','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-food-preference-umlaut';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-pronunciation-umlauts' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-food-preference-umlaut-1','act-de-a1-food-preference-umlaut','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-preference-umlaut',id,'source_items_grouped_for_pronunciation','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-preference-umlaut-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-expanded-food-order' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-expanded-food-order',@level,@unit,17,2,'چیز دیگری هم؟','Noch etwas bitte?','چیز دیگری هم؟','qa','گفت‌وگو یک سفارش واقعی را از «چیز دیگری هم؟» تا موجودی و قیمت پیش می‌برد؛ سپس شنیدن، تکمیل هدایت‌شده و بازسازی پرسش قیمت اضافه می‌شوند.','از تعامل کامل به شنیدن مستقل، تکمیل سفارش و بازیابی پرسش قیمت حرکت می‌کند.','conversation_speaking>listen_choose>fill_blank>word_order','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-expanded-food-order' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-expanded-food-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-expanded-food-order-1','de-a1-lesson-expanded-food-order','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-expanded-food-order',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-expanded-food-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-expanded-food-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی سفارش را ادامه بده: دربارهٔ کیک و قیمت نان‌ها بپرس.','چهار نوبت پیوسته از بخش ۲۸۲ منبع هستند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-expanded-food-order' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-expanded-food-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-expanded-food-conversation-1','act-de-a1-expanded-food-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-expanded-food-listen',@lesson,2,'listen_choose','عبارت را گوش کن و همان پرسش فروشنده را انتخاب کن.','عبارت صوتی و گزینه‌ها همگی عین بخش ۲۸۲ منبع‌اند.',NULL,CAST('{"audioTextTargetFa":"چیز دیگری هم؟","options":[{"text":"Noch etwas bitte?","translationFa":"چیز دیگری هم؟","correct":true},{"text":"Gibt es auch Kuchen?","translationFa":"کیک هم هست؟","correct":false},{"text":"Wie viel kosten die Brötchen?","translationFa":"نان‌ها چقدر قیمت دارند؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Noch etwas bitte?','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-expanded-food-listen';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-expanded-food-listen-1','act-de-a1-expanded-food-listen','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-listen',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-listen-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-listen',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-listen-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-expanded-food-fill',@lesson,3,'fill_blank','سفارش دو نان با سوسیس را کامل کن.','جمله و واژه‌های انتخابی همگی در همان بخش منبع وجود دارند.',NULL,CAST('{"sourceText":"Bitte zwei Brötchen mit Wurst.","sourceTextFa":"لطفاً دو نان گرد با سوسیس.","blankedText":"Bitte zwei Brötchen mit ___.","blankedTextFa":"لطفاً دو نان گرد با ___.","choices":["Wurst","Käse","Milch"],"choicesFa":["سوسیس","پنیر","شیر"],"answer":"Wurst"}' AS JSON),CAST('["source_sentence_blank_created","options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-expanded-food-fill';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-expanded-food-fill-1','act-de-a1-expanded-food-fill','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-fill',id,'source_sentence_blank_created','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-fill',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-fill',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-expanded-food-order-price',@lesson,4,'word_order','پرسش قیمت نان‌ها را بساز.','پرسش عین منبع است و فقط قطعه‌بندی شده است.',NULL,CAST('{"sourceText":"Wie viel kosten die Brötchen?","sourceTextFa":"نان‌ها چقدر قیمت دارند؟","tokens":["Wie","viel","kosten","die","Brötchen?"],"answer":["Wie","viel","kosten","die","Brötchen?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-expanded-food-order-price';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-expanded-food-order-price-1','act-de-a1-expanded-food-order-price','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-order-price',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-order-price-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-expanded-food-order-price',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-expanded-food-order-price-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-expanded-food-order' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-food-combinations-review',@level,@unit,18,3,'نداریم؛ این چطور؟','Gibt es Käse? / Gibt es Gemüse?','پنیر هست؟ / سبزیجات هست؟','qa','این درس مهارت تازهٔ مدیریت ناموجودبودن یک قلم را اضافه می‌کند؛ زبان‌آموز فقط سفارش حفظ‌شده نمی‌دهد و باید جایگزین را بفهمد.','مکالمه الگوی سؤال/جایگزین را معرفی می‌کند، تطبیق چهار جفت دامنه را گسترش می‌دهد و تکمیل جمله ساختار aber es gibt را تثبیت می‌کند.','conversation_speaking>matching>fill_blank','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-food-combinations-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-food-combinations-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-food-combinations-review-1','de-a1-lesson-food-combinations-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-food-combinations-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-food-combinations-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-food-combinations-review-conversation',@lesson,1,'conversation_speaking','بپرس چه چیزی موجود است و جایگزین پیشنهادی را بفهم.','دو جفت پرسش‌وپاسخ منبع‌دار الگوی نبودن یک قلم و وجود جایگزین را در بافت سفارش نشان می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-food-substitutes' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-food-combinations-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-conversation-1','act-de-a1-food-combinations-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-combinations-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-combinations-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-combinations-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-food-combinations-review-matching',@lesson,2,'matching','هر قلم ناموجود را به جایگزین منبع‌دارش وصل کن.','چهار جفت مختلف نشان می‌دهند الگو به یک خوراکی محدود نیست.',NULL,CAST('{"pairs":[{"left":"Käse","leftFa":"پنیر","right":"Wurst","rightFa":"سوسیس"},{"left":"Gemüse","leftFa":"سبزیجات","right":"Obst","rightFa":"میوه"},{"left":"Milch","leftFa":"شیر","right":"Tee","rightFa":"چای"},{"left":"Wasser","leftFa":"آب","right":"Kakao","rightFa":"کاکائو"}],"pairMode":"target_to_target"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-food-combinations-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-matching-1','act-de-a1-food-combinations-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-combinations-review-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-combinations-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-food-combinations-review-order',@lesson,3,'fill_blank','پاسخ جایگزین را کامل کن.','تکمیل aber es gibt ساختار کاربردی پاسخ به نبودن یک قلم را فعال می‌کند.',NULL,CAST('{"sourceText":"Nein, aber es gibt Tee.","sourceTextFa":"نه، اما چای هست.","blankedText":"Nein, aber es gibt ___.","blankedTextFa":"نه، اما ___ هست.","choices":["Tee","Milch","Wasser"],"choicesFa":["چای","شیر","آب"],"answer":"Tee"}' AS JSON),CAST('["source_sentence_blank_created","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-food-combinations-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-food-order' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-order-1','act-de-a1-food-combinations-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-combinations-review-order',id,'source_sentence_blank_created','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-food-combinations-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-food-combinations-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-time-plans-appointment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-time-class-schedule',@level,@unit,19,1,'تا چه ساعتی کلاس داری؟','Wie lange hast du heute Unterricht? / Und bis wann bleibst du dann noch in der Schule?','امروز چند ساعت کلاس داری؟ / و بعد تا چه زمانی در مدرسه می‌مانی؟','qa','گفت‌وگوی اصلی یک بازهٔ کلاس و زمان پایان ماندن را می‌سازد؛ سپس چهار جفت پرسش و پاسخ زمانی وصل می‌شوند، پرسش کلیدی بازسازی می‌شود و در پایان پاسخ ساعت ۱۳ از دو پاسخ زمانی دیگر تشخیص داده می‌شود.','درس از فهم تعامل کامل به تشخیص چند بازه، بازیابی فعال پرسش و سپس تمایز پاسخ زمانی حرکت می‌کند.','conversation_speaking>matching>word_order>multiple_choice','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-time-class-schedule' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-time-class-schedule';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-time-class-schedule-1','de-a1-lesson-time-class-schedule','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-time-class-schedule',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-time-class-schedule-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-time-schedule-conversation',@lesson,1,'conversation_speaking','دربارهٔ مدت کلاس و ساعتی که تا آن زمان می‌مانی جواب بده.','چهار نوبت منبع‌دار بخش ۸۵۰ یک تعامل کامل با «از ... تا ...» و «تا چه زمانی» می‌سازند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-time-class-schedule' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-time-schedule-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-time-schedule-conversation-1','act-de-a1-time-schedule-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-schedule-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-schedule-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-schedule-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-schedule-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-schedule-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-schedule-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-time-ranges-matching',@lesson,2,'matching','هر پرسش زمانی را به پاسخ درستش وصل کن.','چهار جفت کامل از بخش ۸۵۳ چند بازهٔ روزمره را بدون ساخت جملهٔ تازه تمرین می‌کنند.',NULL,CAST('{"pairs":[{"left":"Wie lange haben Sie Unterricht?","leftFa":"چند ساعت کلاس دارید؟","right":"Von 7.30 bis 12.00 Uhr.","rightFa":"از ۷:۳۰ تا ۱۲."},{"left":"Wie lange arbeitet Herr Müller?","leftFa":"آقای مولر چه مدت کار می‌کند؟","right":"Von 7.00 Uhr bis 16.00 Uhr.","rightFa":"از ساعت ۷ تا ۱۶."},{"left":"Wie lange üben Sie am Nachmittag?","leftFa":"بعدازظهر چه مدت تمرین می‌کنید؟","right":"Von 14.00 Uhr bis 16.30 Uhr.","rightFa":"از ساعت ۱۴ تا ۱۶:۳۰."},{"left":"Wie lange waren Sie im Kino?","leftFa":"چه مدت در سینما بودید؟","right":"Von 20.00 Uhr bis 21.45 Uhr.","rightFa":"از ساعت ۲۰ تا ۲۱:۴۵."}],"pairMode":"target_to_target"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-time-ranges-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-time-ranges-matching-1','act-de-a1-time-ranges-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-ranges-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-ranges-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-ranges-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-ranges-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-time-bis-wann-order',@lesson,3,'word_order','پرسش «تا چه زمانی در مدرسه می‌مانی؟» را دوباره بساز.','پرسش اصلی گفت‌وگو پس از فهم بازهٔ زمانی به بازیابی فعال منتقل می‌شود.',NULL,CAST('{"sourceText":"Und bis wann bleibst du dann noch in der Schule?","sourceTextFa":"و بعد تا چه زمانی در مدرسه می‌مانی؟","tokens":["Und","bis","wann","bleibst","du","dann","noch","in","der","Schule?"],"answer":["Und","bis","wann","bleibst","du","dann","noch","in","der","Schule?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-time-bis-wann-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-time-bis-wann-order-1','act-de-a1-time-bis-wann-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-bis-wann-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-bis-wann-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-bis-wann-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-bis-wann-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-time-until-choice',@lesson,4,'multiple_choice','کدام پاسخ می‌گوید تا ساعت ۱۳ اینجا می‌مانم؟','یک پاسخ کامل گفت‌وگو با دو پاسخ کوتاه زمانی از همان بخش مقایسه می‌شود.',NULL,CAST('{"options":[{"textTarget":"Bis 13.00 Uhr bleibe ich noch hier.","translationFa":"تا ساعت ۱۳ اینجا می‌مانم.","correct":true},{"textTarget":"Bis 12.30 Uhr.","translationFa":"تا ساعت ۱۲:۳۰.","correct":false},{"textTarget":"Bis übermorgen.","translationFa":"تا پس‌فردا.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-time-until-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-time-until-choice-1','act-de-a1-time-until-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-until-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-until-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-until-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-until-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-time-plans-appointment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-time-simple-appointment',@level,@unit,20,2,'امشب نمی‌شود؛ فردا چطور؟','Was machen Sie heute Abend? Darf ich Sie ins Konzert einladen? / Und morgen?','امشب چه کار می‌کنید؟ می‌توانم شما را به کنسرت دعوت کنم؟ / و فردا؟','qa','گفت‌وگو دعوت امشب و پیشنهاد فردا را پوشش می‌دهد؛ سپس پاسخ مناسب به یک زمان دقیق انتخاب می‌شود، چهار عبارت زمانی و قرار تثبیت می‌شوند و در پایان جملهٔ دعوت بازسازی می‌شود.','درس از فهم پیشنهاد و تغییر برنامه به تشخیص پاسخ ساعت مشخص، تثبیت واژگان زمان و قرار و بازیابی فعال دعوت حرکت می‌کند.','conversation_speaking>choose_response>matching>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-time-simple-appointment' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-time-simple-appointment';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-time-simple-appointment-1','de-a1-lesson-time-simple-appointment','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-time-simple-appointment',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-time-simple-appointment-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-appointment-conversation',@lesson,1,'conversation_speaking','به دعوت امشب پاسخ بده و پیشنهاد فردا را دنبال کن.','چهار نوبت بخش ۸۸۷ یک دعوت طبیعی، رد مؤدبانه و پیشنهاد روز جایگزین را بدون جمله‌سازی آزاد پوشش می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-time-simple-appointment' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-appointment-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-appointment-conversation-1','act-de-a1-appointment-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-appointment-time-response',@lesson,2,'choose_response','اگر از تو بپرسند ساعت ۱۲ منتظر می‌مانی، کدام پاسخ منبع‌دار مناسب است؟','پرسش و پاسخ ساعت مشخص از بخش ۸۸۶ با دو پاسخ واقعی دیگر همان صفحه مقایسه می‌شود.',NULL,CAST('{"promptTarget":"Warten Sie um 12 Uhr auf mich?","promptFa":"ساعت ۱۲ منتظر من می‌مانید؟","options":[{"textTarget":"Es tut mir leid, um 12 Uhr geht es nicht.","translationFa":"متأسفم، ساعت ۱۲ نمی‌شود.","correct":true},{"textTarget":"Morgen geht es vielleicht.","translationFa":"فردا شاید بشود.","correct":false},{"textTarget":"Ja, ich bin einverstanden.","translationFa":"بله، موافقم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-appointment-time-response';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-appointment-time-response-1','act-de-a1-appointment-time-response','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-time-response',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-time-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-time-response',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-time-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-appointment-time-phrases',@lesson,3,'matching','هر عبارت مربوط به زمان یا قرار را به معنی درستش وصل کن.','چهار عبارت مستقیماً از بخش‌های ۸۶۲، ۸۸۶ و ۸۸۷ گرفته شده‌اند و واژگان کاربردی زمان و قرار را تثبیت می‌کنند.',NULL,CAST('{"pairs":[{"left":"einen Termin","leftFa":"یک قرار / وقت ملاقات","right":"یک قرار / وقت ملاقات","rightFa":"یک قرار / وقت ملاقات"},{"left":"heute Abend","leftFa":"امشب","right":"امشب","rightFa":"امشب"},{"left":"morgen","leftFa":"فردا","right":"فردا","rightFa":"فردا"},{"left":"um 12 Uhr","leftFa":"ساعت ۱۲","right":"ساعت ۱۲","rightFa":"ساعت ۱۲"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-appointment-time-phrases';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-appointment-time-phrases-1','act-de-a1-appointment-time-phrases','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-time-phrases',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-time-phrases-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-time-phrases',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-time-phrases-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-appointment-invite-order',@lesson,4,'word_order','جملهٔ دعوت به کنسرت را دوباره بساز.','دعوت اصلی پس از فهم سناریو و زمان به بازیابی فعال منتقل می‌شود.',NULL,CAST('{"sourceText":"Darf ich Sie ins Konzert einladen?","sourceTextFa":"می‌توانم شما را به کنسرت دعوت کنم؟","tokens":["Darf","ich","Sie","ins","Konzert","einladen?"],"answer":["Darf","ich","Sie","ins","Konzert","einladen?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-appointment-invite-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-appointment-invite-order-1','act-de-a1-appointment-invite-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-invite-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-invite-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-appointment-invite-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-appointment-invite-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-time-plans-appointment' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-time-plans-review',@level,@unit,21,3,'این برنامه براتون مناسبه؟','Ich begleite Sie noch ein Stück. Ist Ihnen das recht? / Ja, ich bin einverstanden.','کمی دیگر همراهتان می‌آیم. برایتان مناسب است؟ / بله، موافقم.','qa','به‌جای دستکاری جملهٔ آلمانی مشکل‌دار قبلی، کل درس با نمونه‌های صحیح و عیناً منبع‌دارِ موافقت با برنامه جایگزین شده است.','مکالمه دو نمونهٔ موافقت را در بافت می‌آورد، سپس پاسخ مناسب انتخاب می‌شود و در پایان یک پاسخ کوتاه بازسازی می‌شود.','conversation_speaking>choose_response>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-time-plans-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-time-plans-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-time-plans-review-1','de-a1-lesson-time-plans-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-time-plans-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-time-plans-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-time-review-conversation',@lesson,1,'conversation_speaking','در دو برنامهٔ کوتاه، مناسب‌بودن پیشنهاد را بفهم و موافقت کن.','چهار نوبت عین بخش موافقت منبع هستند و خطای جملهٔ قبلی را بدون بازنویسی آلمانی حذف می‌کنند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-reschedule-exact-time' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-time-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-time-review-conversation-1','act-de-a1-time-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-time-review-matching',@lesson,2,'choose_response','برای این پیشنهاد، پاسخ موافقت را انتخاب کن.','گزینهٔ درست و گزینه‌های دیگر همگی از نمونه‌های همان منبع انتخاب شده‌اند.',NULL,CAST('{"promptTarget":"Ich begleite Sie noch ein Stück. Ist Ihnen das recht?","promptFa":"کمی دیگر همراهتان می‌آیم. برایتان مناسب است؟","options":[{"textTarget":"Ja, ich bin einverstanden.","translationFa":"بله، موافقم.","correct":true},{"textTarget":"Es tut mir leid, heute geht es nicht.","translationFa":"متأسفم، امروز نمی‌شود.","correct":false},{"textTarget":"Morgen geht es vielleicht.","translationFa":"فردا شاید بشود.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-time-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-time-review-matching-1','act-de-a1-time-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-review-matching',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-time-review-order',@lesson,3,'word_order','پاسخ کوتاه موافقت را بساز.','این پاسخ عین نمونهٔ منبع است و به بازیابی فعال منتقل می‌شود.',NULL,CAST('{"sourceText":"Ja, das ist mir recht.","sourceTextFa":"بله، برای من مناسب است.","tokens":["Ja,","das","ist","mir","recht."],"answer":["Ja,","das","ist","mir","recht."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-time-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-021-time-appointment' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-time-review-order-1','act-de-a1-time-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-time-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-time-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-directions-public-places' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-directions-public-places-review',@level,@unit,22,1,'داروخانه و فروشگاه کجاست؟','Wo ist die Apotheke?','داروخانه کجاست؟','qa','درس سنگین قبلی کامل کنار گذاشته شده و با چهار عبارت کوتاه و منبع‌دار برای مکان و جهت جایگزین شده است.','مکالمه دو مکان و دو جهت را وارد می‌کند؛ سپس جهت به‌صورت مستقل شنیده می‌شود و در پایان یک پرسش مکان بازسازی می‌شود.','conversation_speaking>listen_choose>word_order','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-directions-public-places-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-directions-public-places-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-directions-public-places-review-1','de-a1-lesson-directions-public-places-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-directions-public-places-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-directions-public-places-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-places-review-conversation',@lesson,1,'conversation_speaking','خودت گفت‌وگو را شروع کن: محل داروخانه و فروشگاه را بپرس.','چهار نوبت عین بخش مکان‌های عبارت‌نامه‌اند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-hotel-restaurant-location' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-places-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-conversation-1','act-de-a1-directions-places-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-places-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-places-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-places-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-places-review-matching',@lesson,2,'listen_choose','عبارت را گوش کن و همان جهت را انتخاب کن.','عبارت صوتی و هر سه گزینه عین منبع‌اند.',NULL,CAST('{"audioTextTargetFa":"به راست بروید.","options":[{"text":"Gehen Sie nach rechts.","translationFa":"به راست بروید.","correct":true},{"text":"Gehen Sie nach links.","translationFa":"به چپ بروید.","correct":false},{"text":"Wo ist die Apotheke?","translationFa":"داروخانه کجاست؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Gehen Sie nach rechts.','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-places-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-matching-1','act-de-a1-directions-places-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-places-review-matching',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-places-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-places-review-order',@lesson,3,'word_order','پرسش محل فروشگاه را بساز.','پرسش عین منبع است و فقط به قطعه‌های واژگانی تقسیم می‌شود.',NULL,CAST('{"sourceText":"Wo ist das Geschäft?","sourceTextFa":"فروشگاه کجاست؟","tokens":["Wo","ist","das","Geschäft?"],"answer":["Wo","ist","das","Geschäft?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-places-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-appendix-phrasebook' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-order-1','act-de-a1-directions-places-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-places-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-places-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-places-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-directions-public-places' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-ask-and-follow-directions',@level,@unit,23,2,'چطور به باغ‌وحش برسم؟','Wie komme ich zum Zoo?','چطور به باغ‌وحش برسم؟','qa','گفت‌وگوی پیچیدهٔ قبلی کامل حذف شده و فقط عبارت‌های کوتاه پرسیدن و دادن مسیر از منبع باز دانشگاهی استفاده می‌شوند.','مکالمه از «کجاست؟» به «چطور برسم؟» می‌رود؛ سپس یک پاسخ کوتاه شنیده و در پایان پرسش اصلی بازسازی می‌شود.','conversation_speaking>listen_choose>word_order','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-ask-and-follow-directions' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-ask-and-follow-directions';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-ask-and-follow-directions-1','de-a1-lesson-ask-and-follow-directions','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-ask-and-follow-directions',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-ask-and-follow-directions-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-conversation',@lesson,1,'conversation_speaking','خودت گفت‌وگو را شروع کن: محل باغ‌وحش و راه رسیدن به آن را بپرس.','هر چهار نوبت از بخش‌های پرسیدن و دادن مسیر Deutsch im Blick انتخاب شده‌اند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-ask-and-follow-directions' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-conversation-1','act-de-a1-directions-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-public-places-matching',@lesson,2,'listen_choose','پاسخ کوتاه را گوش کن و همان عبارت را انتخاب کن.','عبارت صوتی و گزینه‌ها عین منبع‌اند و نیاز به تولید متن جدید ندارند.',NULL,CAST('{"audioTextTargetFa":"همین آن طرف.","options":[{"text":"Gleich da drüben.","translationFa":"همین آن طرف.","correct":true},{"text":"Wo ist der Zoo?","translationFa":"باغ‌وحش کجاست؟","correct":false},{"text":"Vielen Dank.","translationFa":"خیلی ممنون.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Gleich da drüben.','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-public-places-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-public-places-matching-1','act-de-a1-public-places-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-public-places-matching',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-public-places-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-public-places-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-public-places-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-question-order',@lesson,3,'word_order','پرسش راه رسیدن به باغ‌وحش را بساز.','پرسش عین منبع است و فقط به‌صورت مکانیکی به قطعه‌های واژگانی تقسیم شده است.',NULL,CAST('{"sourceText":"Wie komme ich zum Zoo?","sourceTextFa":"چطور به باغ‌وحش برسم؟","tokens":["Wie","komme","ich","zum","Zoo?"],"answer":["Wie","komme","ich","zum","Zoo?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-question-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-question-order-1','act-de-a1-directions-question-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-question-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-question-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-question-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-question-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-directions-public-places' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-directions-sequence-review',@level,@unit,24,3,'ایستگاه و فرودگاه کدام طرف‌اند؟','Wie komme ich zum Bahnhof? / Wie komme ich zum Flughafen?','چطور به ایستگاه قطار برسم؟ / چطور به فرودگاه برسم؟','qa','درس قبلی با حمل‌ونقل عمومی هم‌پوشانی داشت و به نمونهٔ زمانی ضعیف متکی بود؛ این جایگزین فقط مهارت مسیر و مکان عمومی را با عبارت‌نامهٔ فعلی پوشش می‌دهد.','مسیر ایستگاه و فرودگاه تمرین می‌شود، سپس پرسش مسیر بازسازی می‌شود و در پایان یک بازیابی بین‌واحدی خانواده/خرید/مسیر اضافه می‌شود.','conversation_speaking>multiple_choice>word_order>multiple_choice','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-directions-sequence-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-directions-sequence-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-directions-sequence-review-1','de-a1-lesson-directions-sequence-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-directions-sequence-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-directions-sequence-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-directions-sequence-review-2','de-a1-lesson-directions-sequence-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-directions-sequence-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-directions-sequence-review-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-directions-sequence-review-3','de-a1-lesson-directions-sequence-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-directions-sequence-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-directions-sequence-review-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-sequence-review-conversation',@lesson,1,'conversation_speaking','خودت گفت‌وگو را شروع کن: مسیر ایستگاه و فرودگاه را بپرس.','پرسش‌ها از الگوی مقصد در منبع و پاسخ‌ها از عبارت‌های جهت همان منبع می‌آیند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-train-arrival-station' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-sequence-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-conversation-1','act-de-a1-directions-sequence-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-sequence-review-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-sequence-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-sequence-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-sequence-review-choice',@lesson,2,'multiple_choice','کدام عبارت یعنی «به راست بپیچید»؟','سه گزینه همگی عین عبارت‌های مسیر در منبع هستند.',NULL,CAST('{"options":[{"textTarget":"Rechts abbiegen.","translationFa":"به راست بپیچید.","correct":true},{"textTarget":"Links abbiegen.","translationFa":"به چپ بپیچید.","correct":false},{"textTarget":"geradeaus","translationFa":"مستقیم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-sequence-review-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-choice-1','act-de-a1-directions-sequence-review-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-sequence-review-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-sequence-review-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-sequence-review-fill',@lesson,3,'word_order','پرسش مسیر فرودگاه را بساز.','جمله از الگوی مقصد و نمونهٔ فرودگاهِ خود منبع ساخته شده و فقط به قطعه‌های واژگانی تقسیم می‌شود.',NULL,CAST('{"sourceText":"Wie komme ich zum Flughafen?","sourceTextFa":"چطور به فرودگاه برسم؟","tokens":["Wie","komme","ich","zum","Flughafen?"],"answer":["Wie","komme","ich","zum","Flughafen?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-sequence-review-fill';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-fill-1','act-de-a1-directions-sequence-review-fill','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-sequence-review-fill',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-sequence-review-fill',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-sequence-review-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-directions-cross-unit-retrieval',@lesson,4,'multiple_choice','کدام جمله مربوط به خانواده است، نه خرید یا مسیر؟','سه جمله عین منابع واحدهای قبلی‌اند و بازیابی فاصله‌دار بین خانواده، خرید و مسیر را می‌سنجند.',NULL,CAST('{"options":[{"textTarget":"Unsere Schwester wohnt in Hamburg.","translationFa":"خواهر ما در هامبورگ زندگی می‌کند.","correct":true},{"textTarget":"Was brauchen Sie?","translationFa":"چه چیزی لازم دارید؟","correct":false},{"textTarget":"Wie komme ich zum Flughafen?","translationFa":"چطور به فرودگاه برسم؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-directions-cross-unit-retrieval';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-1','act-de-a1-directions-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-2','act-de-a1-directions-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-3','act-de-a1-directions-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-directions-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-directions-cross-unit-retrieval-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-requests-services-help' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-clarify-permission-help',@level,@unit,25,1,'لطفاً یک بار دیگر، آهسته','Wie bitte? Noch einmal, bitte langsam. / Kann ich Ihr Telefon benutzen?','ببخشید؟ یک بار دیگر، لطفاً آهسته. / می‌توانم از تلفن شما استفاده کنم؟','qa','گفت‌وگو درخواست تکرار را در بافت واقعی تمرین می‌کند؛ سپس اجازهٔ استفاده از تلفن، درخواست کمک، واژگان خدمات و در پایان بازسازی عبارت تکرار پوشش داده می‌شوند.','درس از یک مشکل فهم واقعی به تشخیص اجازه و کمک، تثبیت واژگان خدمات و بازیابی فعال درخواست روشن‌سازی حرکت می‌کند.','conversation_speaking>multiple_choice>choose_response>matching>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-clarify-permission-help' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-clarify-permission-help';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-service-clarification' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-clarify-permission-help-1','de-a1-lesson-clarify-permission-help','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-clarify-permission-help',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-clarify-permission-help-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-services' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-clarify-permission-help-2','de-a1-lesson-clarify-permission-help','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-clarify-permission-help',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-clarify-permission-help-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-ja' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-clarify-permission-help-3','de-a1-lesson-clarify-permission-help','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-clarify-permission-help',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-clarify-permission-help-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-clarify-permission-help-4','de-a1-lesson-clarify-permission-help','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-clarify-permission-help',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-clarify-permission-help-4'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-service-conversation',@lesson,1,'conversation_speaking','اگر پرسش را نفهمیدی، بخواه یک بار دیگر و آهسته گفته شود.','چهار نوبت منبع‌دار یک چرخهٔ طبیعی پرسش، درخواست تکرار، تکرار همان پرسش و پاسخ مثبت کوتاه را می‌سازند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-clarify-slowly' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-service-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-service-clarification' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-service-conversation-1','act-de-a1-service-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-services' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-service-conversation-2','act-de-a1-service-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-ja' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-service-conversation-3','act-de-a1-service-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-conversation-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-phone-permission-choice',@lesson,2,'multiple_choice','کدام عبارت برای اجازه گرفتنِ استفاده از تلفن است؟','شکل رسمی از گزینهٔ رسمی منبع انتخاب شده و با دو پرسش خدماتی دیگر مقایسه می‌شود.',NULL,CAST('{"options":[{"textTarget":"Kann ich Ihr Telefon benutzen?","translationFa":"می‌توانم از تلفن شما استفاده کنم؟","correct":true},{"textTarget":"Wo ist die Toilette, bitte?","translationFa":"سرویس بهداشتی کجاست، لطفاً؟","correct":false},{"textTarget":"Sprechen Sie Englisch?","translationFa":"انگلیسی صحبت می‌کنید؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","other","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-phone-permission-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-services' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-phone-permission-choice-1','act-de-a1-phone-permission-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-phone-permission-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-phone-permission-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-phone-permission-choice',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-phone-permission-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-phone-permission-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-phone-permission-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-specific-help-response',@lesson,3,'choose_response','در پاسخ به «چه چیزی لازم دارید؟» کدام جمله مستقیم می‌گوید به کمک نیاز داری؟','پرسش «چه چیزی لازم دارید؟» از منبع پیشین نیاز/خرید بازاستفاده می‌شود؛ پاسخ رسمیِ درخواست کمک و دو گزینهٔ مقایسه‌ای از منابع خدماتی ثبت‌شده می‌آیند.',NULL,CAST('{"promptTarget":"Was brauchen Sie?","promptFa":"چه چیزی لازم دارید؟","options":[{"textTarget":"Ich brauche Ihre Hilfe.","translationFa":"به کمک شما نیاز دارم.","correct":true},{"textTarget":"Ich verstehe das nicht.","translationFa":"این را نمی‌فهمم.","correct":false},{"textTarget":"Wo ist die Toilette, bitte?","translationFa":"سرویس بهداشتی کجاست، لطفاً؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","other","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-specific-help-response';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-services' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-specific-help-response-1','act-de-a1-specific-help-response','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-specific-help-response',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-specific-help-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-specific-help-response',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-specific-help-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-specific-help-response',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-specific-help-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-specific-help-response-2','act-de-a1-specific-help-response','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-specific-help-response',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-specific-help-response-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-specific-help-response',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-specific-help-response-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-specific-help-response',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-specific-help-response-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-service-words-matching',@lesson,4,'matching','هر واژهٔ خدماتی را به معنی درستش وصل کن.','دو واژهٔ آشنا و دو واژهٔ تازه در یک شبکهٔ خدمات روزمره تثبیت می‌شوند.',NULL,CAST('{"pairs":[{"left":"Hilfe","leftFa":"کمک","right":"کمک","rightFa":"کمک"},{"left":"Telefon","leftFa":"تلفن","right":"تلفن","rightFa":"تلفن"},{"left":"Toilette","leftFa":"سرویس بهداشتی","right":"سرویس بهداشتی","rightFa":"سرویس بهداشتی"},{"left":"Apotheke","leftFa":"داروخانه","right":"داروخانه","rightFa":"داروخانه"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-service-words-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-services' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-service-words-matching-1','act-de-a1-service-words-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-words-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-words-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-service-words-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-service-words-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-repeat-slowly-order',@lesson,5,'word_order','درخواست تکرار و آهسته‌تر گفتن را دوباره بساز.','عبارت کلیدی گفت‌وگو در پایان به بازیابی فعال منتقل می‌شود.',NULL,CAST('{"sourceText":"Wie bitte? Noch einmal, bitte langsam.","sourceTextFa":"ببخشید؟ یک بار دیگر، لطفاً آهسته.","tokens":["Wie","bitte?","Noch","einmal,","bitte","langsam."],"answer":["Wie","bitte?","Noch","einmal,","bitte","langsam."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-repeat-slowly-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-002-service-clarification' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-repeat-slowly-order-1','act-de-a1-repeat-slowly-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-repeat-slowly-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-repeat-slowly-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-repeat-slowly-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-repeat-slowly-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-requests-services-help' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-services-permission-review',@level,@unit,26,2,'کفش‌ها کجاست؟','Entschuldigen Sie. Ich brauche Schuhe. Wo sind sie?','ببخشید. کفش لازم دارم. کجا هستند؟','qa','درس قبلی به‌دلیل بار دستوری بالا کامل جایگزین شده و چهار نوبت نخست گفت‌وگوی سادهٔ خرید کفش مستقیماً از منبع استفاده می‌شوند.','مکالمه نیاز، رنگ و محل کالا را می‌دهد؛ سپس پرسش رنگ شنیده می‌شود و در پایان پاسخ کوتاه خرید بازسازی می‌شود.','conversation_speaking>listen_choose>word_order','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-services-permission-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-services-permission-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-services-permission-review-1','de-a1-lesson-services-permission-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-services-permission-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-services-permission-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-services-permission-review-conversation',@lesson,1,'conversation_speaking','خودت گفت‌وگو را شروع کن: بگو کفش لازم داری و رنگ موردنظرت را مشخص کن.','چهار نوبت نخست گفت‌وگوی خرید کفش عین منبع هستند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-clothing-store-help' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-services-permission-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-conversation-1','act-de-a1-services-permission-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-permission-review-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-permission-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-permission-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-services-permission-review-choice',@lesson,2,'listen_choose','پرسش را گوش کن و پاسخ مناسب را انتخاب کن.','پرسش و هر سه پاسخ از همان گفت‌وگوی منبع انتخاب شده‌اند.',NULL,CAST('{"audioTextTargetFa":"چه رنگی می‌خواهید؟","options":[{"text":"Ein Paar Schuhe in Weiß, bitte.","translationFa":"لطفاً یک جفت کفش سفید.","correct":true},{"text":"Nein, sie sind zu klein.","translationFa":"نه، خیلی کوچک‌اند.","correct":false},{"text":"Ja, danke.","translationFa":"بله، ممنون.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Welche Farbe möchten Sie?','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-services-permission-review-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-choice-1','act-de-a1-services-permission-review-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-permission-review-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-permission-review-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-services-permission-review-order',@lesson,3,'word_order','پاسخ سفارش کفش سفید را بساز.','پاسخ عین منبع است و فقط برای بازیابی قطعه‌بندی می‌شود.',NULL,CAST('{"sourceText":"Ein Paar Schuhe in Weiß, bitte.","sourceTextFa":"لطفاً یک جفت کفش سفید.","tokens":["Ein","Paar","Schuhe","in","Weiß,","bitte."],"answer":["Ein","Paar","Schuhe","in","Weiß,","bitte."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-services-permission-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-german-lesson-9-clothing' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-order-1','act-de-a1-services-permission-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-permission-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-permission-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-permission-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;
DELETE p FROM provenance_links p LEFT JOIN activities a ON a.activity_key=p.entity_key WHERE p.entity_type='activity' AND a.id IS NULL;


-- Canonical A1 lesson/activity sync, batch 3 of 3.

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-requests-services-help' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-services-help-review',@level,@unit,27,3,'پزشک را کجا پیدا کنم؟','Wo finde ich einen Arzt?','کجا می‌توانم یک پزشک پیدا کنم؟','qa','وابستگی‌های ضعیف قبلی حذف شده‌اند و هر چهار نوبت گفت‌وگو از منابع مستقلِ قابل‌بازاستفاده می‌آیند.','از پرسش خدمت ضروری به پاسخ مکانی و پایان مؤدبانه می‌رسد؛ سپس پاسخ مکانی مستقل شنیده و پرسش اصلی بازسازی می‌شود.','conversation_speaking>listen_choose>word_order','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-services-help-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-services-help-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-006-where-when' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-services-help-review-1','de-a1-lesson-services-help-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-services-help-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-services-help-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-services-help-review-2','de-a1-lesson-services-help-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-services-help-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-services-help-review-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-bitte' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-services-help-review-3','de-a1-lesson-services-help-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-services-help-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-services-help-review-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-services-help-review-conversation',@lesson,1,'conversation_speaking','خودت گفت‌وگو را شروع کن: محل پزشک را بپرس و با تشکر پایان بده.','هر نوبت عین یکی از منابع ثبت‌شده است.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-urgent-service-help' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-services-help-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-006-where-when' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-1','act-de-a1-services-help-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-2','act-de-a1-services-help-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-bitte' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-3','act-de-a1-services-help-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-conversation-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-services-help-review-matching',@lesson,2,'listen_choose','پاسخ مکانی را گوش کن و همان عبارت را انتخاب کن.','گزینه‌ها همگی عبارت‌های ثبت‌شده در منابع هستند.',NULL,CAST('{"audioTextTargetFa":"همین آن طرف.","options":[{"text":"Gleich da drüben.","translationFa":"همین آن طرف.","correct":true},{"text":"Vielen Dank.","translationFa":"خیلی ممنون.","correct":false},{"text":"Bitte.","translationFa":"خواهش می‌کنم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Gleich da drüben.','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-services-help-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-help-review-matching-1','act-de-a1-services-help-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-matching',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-bitte' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-help-review-matching-2','act-de-a1-services-help-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-matching',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-matching-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-matching-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-services-help-review-order',@lesson,3,'word_order','پرسش محل پزشک را بساز.','پرسش عین منبع است و فقط قطعه‌بندی شده است.',NULL,CAST('{"sourceText":"Wo finde ich einen Arzt?","sourceTextFa":"کجا می‌توانم یک پزشک پیدا کنم؟","tokens":["Wo","finde","ich","einen","Arzt?"],"answer":["Wo","finde","ich","einen","Arzt?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-services-help-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-006-where-when' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-services-help-review-order-1','act-de-a1-services-help-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-services-help-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-services-help-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-forms-signs-messages' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-personal-form-signs',@level,@unit,28,1,'فرم را پر کن، تابلو را بخوان','der Vorname / der Familienname / die Adresse / die Stadt / Offen / Geschlossen','نام کوچک / نام خانوادگی / نشانی / شهر / باز / بسته','qa','درس با بازیابی اطلاعات شخصی شروع می‌شود؛ سپس برچسب‌های فرم، تکمیل یک فیلد واقعی، خواندن چهار تابلوی کوتاه و در پایان خواندن حروف برای هجی‌کردن تمرین می‌شوند.','ترتیب از تعامل آشنا به خواندن فرم، تولید هدایت‌شده، خواندن متن محیطی و سپس وضوح تلفظ حروف حرکت می‌کند.','conversation_speaking>matching>fill_blank>matching>pronunciation_read','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-personal-form-signs' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-personal-form-signs';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-residence-origin' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-personal-form-signs-1','de-a1-lesson-personal-form-signs','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-personal-form-signs',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-personal-form-signs-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-form-spelling' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-personal-form-signs-2','de-a1-lesson-personal-form-signs','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-personal-form-signs',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-personal-form-signs-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-signs' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-personal-form-signs-3','de-a1-lesson-personal-form-signs','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-personal-form-signs',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-personal-form-signs-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-pronunciation-alphabet' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-personal-form-signs-4','de-a1-lesson-personal-form-signs','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-personal-form-signs',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-personal-form-signs-4'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-form-conversation',@lesson,1,'conversation_speaking','اطلاعات پایهٔ نام و محل زندگی را در یک ثبت‌نام کوتاه پاسخ بده.','گفت‌وگوی منبع‌دار سطح پیشین اطلاعاتی را بازیابی می‌کند که بلافاصله در فرم استفاده می‌شوند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-personal-form-review' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-form-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-residence-origin' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-form-conversation-1','act-de-a1-form-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-form-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-form-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-form-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-form-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-form-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-form-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-form-fields-matching',@lesson,2,'matching','هر اسمِ فرم را همراه با حرف تعریفش به معنی درست وصل کن.','چهار ترکیب اسم و حرف تعریف مستقیماً از بخش فرم و واژگان منبع گرفته شده‌اند تا جنس و برچسب فرم هم‌زمان در بافت کاربردی مرور شوند.',NULL,CAST('{"pairs":[{"left":"der Vorname","leftFa":"نام کوچک","right":"نام کوچک، مذکر","rightFa":"نام کوچک، مذکر"},{"left":"der Familienname","leftFa":"نام خانوادگی","right":"نام خانوادگی، مذکر","rightFa":"نام خانوادگی، مذکر"},{"left":"die Adresse","leftFa":"نشانی","right":"نشانی، مؤنث","rightFa":"نشانی، مؤنث"},{"left":"die Stadt","leftFa":"شهر","right":"شهر، مؤنث","rightFa":"شهر، مؤنث"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-form-fields-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-form-spelling' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-form-fields-matching-1','act-de-a1-form-fields-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-form-fields-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-form-fields-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-form-fields-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-form-fields-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-form-first-name-fill',@lesson,3,'fill_blank','فیلد نام کوچک را با نمونهٔ درست کامل کن.','چهار مقدار از مثال‌های هجی‌کردن همان بخش منبع گرفته شده‌اند و فقط یکی برای فیلد نام کوچک مناسب است.',NULL,CAST('{"blankedText":"Vorname: ___","blankedTextFa":"نام کوچک: ___","choices":["Marcus","Clinton","Hauptstraße","Werdau"],"choicesFa":["مارکوس","کلینتون","هاوپت‌اشتراسه","ورداو"],"answer":"Marcus"}' AS JSON),CAST('["other","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-form-first-name-fill';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-form-spelling' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-form-first-name-fill-1','act-de-a1-form-first-name-fill','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-form-first-name-fill',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-form-first-name-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-form-first-name-fill',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-form-first-name-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-common-signs-matching',@lesson,4,'matching','هر تابلوی کوتاه را به معنی درستش وصل کن.','چهار تابلوی بسیار پرتکرار از بخش تابلوهای رایج منبع انتخاب شده‌اند.',NULL,CAST('{"pairs":[{"left":"Offen","leftFa":"باز","right":"باز","rightFa":"باز"},{"left":"Geschlossen","leftFa":"بسته","right":"بسته","rightFa":"بسته"},{"left":"Eingang","leftFa":"ورودی","right":"ورودی","rightFa":"ورودی"},{"left":"Ausgang","leftFa":"خروجی","right":"خروجی","rightFa":"خروجی"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-common-signs-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-signs' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-common-signs-matching-1','act-de-a1-common-signs-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-common-signs-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-common-signs-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-common-signs-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-common-signs-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-alphabet-pronunciation',@lesson,5,'pronunciation_read','گروه‌های حروف را واضح و با صدای بلند بخوان.','الفبای کامل عین منبع تلفظ Deutsch im Blick است و Ä، Ö، Ü و ß را هم در تمرین مستقیم وارد می‌کند.',NULL,CAST('{"lines":["A, Ä, B, C, D, E, F, G, H, I, J, K, L, M, N, O, Ö, P, Q, R, S, ß, T, U, Ü, V, W, X, Y, Z"],"audioTextTargetFa":"الفبای کامل آلمانی همراه با Ä، Ö، Ü و ß."}' AS JSON),CAST('["source_items_grouped_for_pronunciation"]' AS JSON),'A, Ä, B, C, D, E, F, G, H, I, J, K, L, M, N, O, Ö, P, Q, R, S, ß, T, U, Ü, V, W, X, Y, Z','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-alphabet-pronunciation';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-pronunciation-alphabet' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-alphabet-pronunciation-1','act-de-a1-alphabet-pronunciation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-alphabet-pronunciation',id,'source_items_grouped_for_pronunciation','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-alphabet-pronunciation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-forms-signs-messages' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-short-phone-message',@level,@unit,29,2,'لطفاً دوشنبه دوباره تماس بگیرید','Rufen Sie bitte am Montag noch einmal an.','لطفاً دوشنبه دوباره تماس بگیرید','qa','گفت‌وگو هماهنگی کوتاه را می‌سازد؛ سپس یک پیام مستقل شنیده می‌شود، چهار پیام زمانی خوانده و تطبیق داده می‌شوند، یک پیام با انتخاب زمان مناسب کامل می‌شود و در پایان یک پیام دیگر بازسازی می‌شود.','درس از تعامل به دریافت شنیداری، سپس خواندن چند نمونه، تکمیل هدایت‌شدهٔ پیام و در پایان بازسازی کامل یک پیام کوتاه حرکت می‌کند.','conversation_speaking>listen_choose>matching>fill_blank>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-short-phone-message' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-short-phone-message';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-024-short-messages' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-short-phone-message-1','de-a1-lesson-short-phone-message','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-short-phone-message',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-short-phone-message-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-message-conversation',@lesson,1,'conversation_speaking','تماس دوباره و گرفتن بلیت‌ها برای فردا را هماهنگ کن.','دو جفت پرسش‌وپاسخ مجاور منبع، یک هماهنگی کوتاه برای تماس دوباره و تحویل گرفتن بلیت‌ها می‌سازند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-short-message-coordination' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-message-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-024-short-messages' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-message-conversation-1','act-de-a1-message-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-message-listen-callback',@lesson,2,'listen_choose','پیام را گوش کن و زمان تماس دوباره را انتخاب کن.','جملهٔ کامل بخش ۱۰۰۷ به‌عنوان پیام مستقل شنیداری استفاده می‌شود و زمان درست از سه عبارت منبع‌دار انتخاب می‌شود.',NULL,CAST('{"audioTextTargetFa":"لطفاً دوشنبه دوباره تماس بگیرید.","options":[{"text":"am Montag","translationFa":"دوشنبه","correct":true},{"text":"heute Abend","translationFa":"امشب","correct":false},{"text":"übermorgen","translationFa":"پس‌فردا","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Rufen Sie bitte am Montag noch einmal an.','pending')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_status=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_status,'stale'),audio_url=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_url,NULL),audio_storage_path=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_storage_path,NULL),audio_source_hash=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_source_hash,NULL),audio_provider=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_provider,NULL),audio_model_id=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_model_id,NULL),audio_voice_name=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_voice_name,NULL),audio_voice_id=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_voice_id,NULL),audio_generated_at=IF((BINARY COALESCE(audio_text_target,'') = BINARY COALESCE(VALUES(audio_text_target),'')),audio_generated_at,NULL),audio_text_target=VALUES(audio_text_target);
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-message-listen-callback';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-024-short-messages' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-message-listen-callback-1','act-de-a1-message-listen-callback','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-listen-callback',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-listen-callback-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-listen-callback',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-listen-callback-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-message-reading-matching',@lesson,3,'matching','هر پیام کوتاه را به زمان درستش وصل کن.','چهار پیام کامل از بخش ۱۰۰۷ انتخاب شده‌اند تا خواندن متن کوتاه و استخراج زمان تمرین شود.',NULL,CAST('{"pairs":[{"left":"Rufen Sie bitte am Montag noch einmal an.","leftFa":"لطفاً دوشنبه دوباره تماس بگیرید.","right":"دوشنبه","rightFa":"دوشنبه"},{"left":"Rufen Sie bitte heute Abend noch einmal an.","leftFa":"لطفاً امشب دوباره تماس بگیرید.","right":"امشب","rightFa":"امشب"},{"left":"Rufen Sie bitte übermorgen noch einmal an.","leftFa":"لطفاً پس‌فردا دوباره تماس بگیرید.","right":"پس‌فردا","rightFa":"پس‌فردا"},{"left":"Rufen Sie bitte um zehn noch einmal an.","leftFa":"لطفاً ساعت ده دوباره تماس بگیرید.","right":"ساعت ده","rightFa":"ساعت ده"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-message-reading-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-024-short-messages' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-message-reading-matching-1','act-de-a1-message-reading-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-reading-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-reading-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-reading-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-reading-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-message-write-fill',@lesson,4,'fill_blank','پیام تماس برای بعدازظهر را با عبارت زمانی درست کامل کن.','جملهٔ کامل و همهٔ عبارت‌های زمانی از پاسخ‌های منبع‌دار بخش ۱۰۰۷ می‌آیند؛ زبان‌آموز یک پیام واقعی را با انتخاب زمان مناسب کامل می‌کند.',NULL,CAST('{"sourceText":"Rufen Sie bitte am Nachmittag noch einmal an.","sourceTextFa":"لطفاً بعدازظهر دوباره تماس بگیرید.","blankedText":"Rufen Sie bitte ___ noch einmal an.","blankedTextFa":"لطفاً ___ دوباره تماس بگیرید.","choices":["am Nachmittag","am Montag","übermorgen"],"choicesFa":["بعدازظهر","دوشنبه","پس‌فردا"],"answer":"am Nachmittag"}' AS JSON),CAST('["source_sentence_blank_created","options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-message-write-fill';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-024-short-messages' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-message-write-fill-1','act-de-a1-message-write-fill','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-write-fill',id,'source_sentence_blank_created','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-write-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-write-fill',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-write-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-write-fill',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-write-fill-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-message-write-order',@lesson,5,'word_order','پیام کوتاه تماس برای بعدازظهر را دوباره بساز.','یک پیام کامل دیگر از همان تمرین به تولید هدایت‌شده منتقل می‌شود تا فقط پیام شنیده‌شده تکرار نشود.',NULL,CAST('{"sourceText":"Rufen Sie bitte am Nachmittag noch einmal an.","sourceTextFa":"لطفاً بعدازظهر دوباره تماس بگیرید.","tokens":["Rufen","Sie","bitte","am","Nachmittag","noch","einmal","an."],"answer":["Rufen","Sie","bitte","am","Nachmittag","noch","einmal","an."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-message-write-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-024-short-messages' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-message-write-order-1','act-de-a1-message-write-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-write-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-write-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-message-write-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-message-write-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-forms-signs-messages' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-forms-signs-message-review',@level,@unit,30,3,'اسم و آدرست را هجی کن','Buchstabieren Sie Ihren Vornamen. / Buchstabieren Sie Ihren Familiennamen.','نام کوچک‌تان را هجی کنید. / نام خانوادگی‌تان را هجی کنید.','qa','درس اول فقط الفبا و فیلدهای فرم را آماده کرده بود؛ این درس مهارت عملیِ بعدی یعنی هجی‌کردن واقعی اطلاعات شخصی را اضافه می‌کند.','هجی‌کردن در گفت‌وگو اجرا می‌شود، فیلدهای فرم و درخواست آهسته‌هجی‌کردن تمرین می‌شوند و در پایان یک بازیابی بین‌واحدی اضافه می‌شود.','conversation_speaking>matching>word_order>multiple_choice','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-forms-signs-message-review' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-forms-signs-message-review';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-form-spelling' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-forms-signs-message-review-1','de-a1-lesson-forms-signs-message-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-forms-signs-message-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-forms-signs-message-review-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-forms-signs-message-review-2','de-a1-lesson-forms-signs-message-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-forms-signs-message-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-forms-signs-message-review-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-forms-signs-message-review-3','de-a1-lesson-forms-signs-message-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-forms-signs-message-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-forms-signs-message-review-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-forms-signs-message-review-4','de-a1-lesson-forms-signs-message-review','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-forms-signs-message-review',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-forms-signs-message-review-4'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-forms-review-conversation',@lesson,1,'conversation_speaking','نام و نام خانوادگی نمونه را حرف‌به‌حرف هجی کن.','دو دستور و دو نمونهٔ تمرین ۲۹۸ به یک نقش‌آفرینی فرم تبدیل شده‌اند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-spell-personal-data' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-forms-review-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-form-spelling' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-forms-review-conversation-1','act-de-a1-forms-review-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-review-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-review-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-review-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-review-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-forms-review-matching',@lesson,2,'matching','هر فیلد را به نمونهٔ درست منبع وصل کن.','چهار نمونهٔ همان تمرین نشان می‌دهند هجی‌کردن فقط برای نام کوچک نیست.',NULL,CAST('{"pairs":[{"left":"Vorname","leftFa":"نام کوچک","right":"Marcus","rightFa":"مارکوس"},{"left":"Familienname","leftFa":"نام خانوادگی","right":"Clinton","rightFa":"کلینتون"},{"left":"Straßenname","leftFa":"نام خیابان","right":"Hauptstraße","rightFa":"هاوپت‌اشتراسه"},{"left":"Stadt","leftFa":"شهر","right":"Werdau","rightFa":"ورداو"}],"pairMode":"target_to_target"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-forms-review-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-form-spelling' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-forms-review-matching-1','act-de-a1-forms-review-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-review-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-review-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-review-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-forms-review-order',@lesson,3,'word_order','درخواست «لطفاً آهسته هجی کنید» را بساز.','این جمله مستقیماً مهارت هجی‌کردن را به مدیریت سرعت گفتار وصل می‌کند.',NULL,CAST('{"sourceText":"Können Sie das bitte langsam buchstabieren?","sourceTextFa":"می‌توانید لطفاً آن را آهسته هجی کنید؟","tokens":["Können","Sie","das","bitte","langsam","buchstabieren?"],"answer":["Können","Sie","das","bitte","langsam","buchstabieren?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-forms-review-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-form-spelling' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-forms-review-order-1','act-de-a1-forms-review-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-review-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-review-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-review-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-forms-cross-unit-retrieval',@lesson,4,'multiple_choice','کدام پرسش مربوط به خرید است؟','گزینه‌ها از سه واحد قبلی انتخاب شده‌اند تا بازیابی خرید، خانواده و مسیر در پایان واحد فرم فعال شود.',NULL,CAST('{"options":[{"textTarget":"Was kaufen Sie?","translationFa":"چه چیزی می‌خرید؟","correct":true},{"textTarget":"Wo wohnt eure Schwester?","translationFa":"خواهرتان کجا زندگی می‌کند؟","correct":false},{"textTarget":"Wie komme ich zum Zoo?","translationFa":"چطور به باغ‌وحش برسم؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-forms-cross-unit-retrieval';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-004' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-1','act-de-a1-forms-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-007-family' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-2','act-de-a1-forms-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-directions' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-3','act-de-a1-forms-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-forms-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-forms-cross-unit-retrieval-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-health-doctor-pharmacy' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-health-symptoms',@level,@unit,31,1,'چه مشکلی دارید؟','Was fehlt Ihnen? / Ich habe Fieber.','چه مشکلی دارید؟ / تب دارم.','qa','درس نخست واحد سلامت زبان لازم برای بیان مستقیم یک مشکل جسمی را می‌سازد و دامنه را عمداً به علائم بسیار رایج محدود می‌کند.','از مکالمهٔ کوتاه به تشخیص علامت و سپس بازسازی پاسخ ساده حرکت می‌کند.','conversation_speaking>multiple_choice>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-health-symptoms' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-health-symptoms';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-health-symptoms-1','de-a1-lesson-health-symptoms','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-health-symptoms',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-health-symptoms-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-symptoms-conversation',@lesson,1,'conversation_speaking','گفت‌وگوی کوتاه پزشک و بیمار را اجرا کن و دو علامت را درست بیان کن.','دو جفت پرسش و پاسخ منبع‌دار، الگوی پایهٔ بیان علامت را بدون پیچیدگی اضافی نشان می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-symptoms' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-symptoms-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-conversation-1','act-de-a1-health-symptoms-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-symptoms-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-symptoms-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-symptoms-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-symptoms-choice',@lesson,2,'multiple_choice','کدام پاسخ یعنی «تب دارم»؟','سه پاسخ کوتاه باعث می‌شوند زبان‌آموز معنی علامت را مستقیم تشخیص دهد.',NULL,CAST('{"options":[{"textTarget":"Ich habe Fieber.","translationFa":"تب دارم.","correct":true},{"textTarget":"Ich habe Husten.","translationFa":"سرفه دارم.","correct":false},{"textTarget":"Ich habe kein Fieber mehr.","translationFa":"دیگر تب ندارم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-symptoms-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-choice-1','act-de-a1-health-symptoms-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-symptoms-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-symptoms-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-symptoms-order',@lesson,3,'word_order','پاسخ «سرفه دارم» را بساز.','بازسازی یک پاسخ بسیار کوتاه، الگوی بیان علامت را به بازیابی فعال منتقل می‌کند.',NULL,CAST('{"sourceText":"Ich habe Husten.","sourceTextFa":"سرفه دارم.","tokens":["Ich","habe","Husten."],"answer":["Ich","habe","Husten."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-symptoms-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-order-1','act-de-a1-health-symptoms-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-symptoms-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-symptoms-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-symptoms-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-health-doctor-pharmacy' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-health-medicine-pharmacy',@level,@unit,32,2,'دارو را از کجا می‌گیری؟','Welche Medikamente bekommt Herr Berger? / Wo bekommt er sie?','آقای برگر چه داروهایی می‌گیرد؟ / آن‌ها را کجا می‌گیرد؟','qa','درس دوم مسیر بعد از تشخیص بیماری را پوشش می‌دهد: دارو چیست و از کجا گرفته می‌شود.','ابتدا مکالمهٔ دارو و داروخانه می‌آید، سپس واژگان دارو تثبیت می‌شوند و در پایان پرسش محل بازسازی می‌شود.','conversation_speaking>matching>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-health-medicine-pharmacy' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-health-medicine-pharmacy';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-health-medicine-pharmacy-1','de-a1-lesson-health-medicine-pharmacy','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-health-medicine-pharmacy',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-health-medicine-pharmacy-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-medicine-conversation',@lesson,1,'conversation_speaking','دربارهٔ دارو و محل گرفتن آن گفت‌وگو کن.','دو جفت پرسش و پاسخ منبع‌دار، دارو و داروخانه را در یک زنجیرهٔ کاربردی قرار می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-medicine-pharmacy' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-medicine-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-medicine-conversation-1','act-de-a1-health-medicine-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-medicine-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-medicine-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-medicine-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-medicine-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-medicine-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-medicine-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-medicine-matching',@lesson,2,'matching','هر واژه را به معنی درستش وصل کن.','سه واژهٔ اصلی این موقعیت بدون افزودن بار دستوری تازه تثبیت می‌شوند.',NULL,CAST('{"pairs":[{"left":"Tabletten","leftFa":"قرص‌ها","right":"قرص","rightFa":"قرص"},{"left":"Tropfen","leftFa":"قطره‌ها","right":"قطره","rightFa":"قطره"},{"left":"Apotheke","leftFa":"داروخانه","right":"محل گرفتن دارو","rightFa":"محل گرفتن دارو"},{"left":"Medikamente","leftFa":"داروها","right":"دارو","rightFa":"دارو"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-medicine-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-medicine-matching-1','act-de-a1-health-medicine-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-medicine-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-medicine-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-medicine-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-medicine-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-medicine-order',@lesson,3,'word_order','پرسش «کجا آن‌ها را می‌گیرد؟» را بساز.','پرسش مکان، زبان‌آموز را از فهم پاسخ به تولید هدایت‌شده می‌رساند.',NULL,CAST('{"sourceText":"Wo bekommt er sie?","sourceTextFa":"آن‌ها را کجا می‌گیرد؟","tokens":["Wo","bekommt","er","sie?"],"answer":["Wo","bekommt","er","sie?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-medicine-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-medicine-order-1','act-de-a1-health-medicine-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-medicine-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-medicine-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-medicine-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-medicine-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-health-doctor-pharmacy' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-health-recovery',@level,@unit,33,3,'دیگه بهتر شدی؟','Haben Sie noch Fieber? / Haben Sie noch Husten?','هنوز تب دارید؟ / هنوز سرفه دارید؟','qa','درس سوم یک مهارت مستقل و طبیعی اضافه می‌کند: پیگیری حال بیمار و گفتن اینکه یک علامت دیگر وجود ندارد.','گفت‌وگو بهترشدن را در بافت می‌آورد، انتخاب پاسخ فهم معنا را می‌سنجد، شنیدن مستقل دریافت صوتی را اضافه می‌کند و در پایان پاسخ دیگری بازسازی می‌شود.','conversation_speaking>choose_response>listen_choose>word_order','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-health-recovery' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-health-recovery';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-health-recovery-1','de-a1-lesson-health-recovery','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-health-recovery',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-health-recovery-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-recovery-conversation',@lesson,1,'conversation_speaking','در پیگیری حال بیمار بگو آیا تب یا سرفه هنوز ادامه دارد.','دو جفت پرسش و پاسخ منبع‌دار الگوی سادهٔ بهترشدن را نشان می‌دهند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-health-recovery' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-recovery-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-recovery-conversation-1','act-de-a1-health-recovery-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-recovery-response',@lesson,2,'choose_response','برای پرسش «هنوز تب دارید؟» پاسخ مناسبِ بهترشدن را انتخاب کن.','پاسخ درست باید روشن کند علامت دیگر وجود ندارد.',NULL,CAST('{"promptTarget":"Haben Sie noch Fieber?","promptFa":"هنوز تب دارید؟","options":[{"textTarget":"Nein, ich habe kein Fieber mehr.","translationFa":"نه، دیگر تب ندارم.","correct":true},{"textTarget":"Ich habe Fieber.","translationFa":"تب دارم.","correct":false},{"textTarget":"Ich habe Husten.","translationFa":"سرفه دارم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-recovery-response';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-recovery-response-1','act-de-a1-health-recovery-response','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-response',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-response',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-recovery-listen',@lesson,3,'listen_choose','پاسخ را گوش کن و جمله‌ای را انتخاب کن که می‌گوید تب دیگر ادامه ندارد.','عبارت صوتی و گزینه‌ها همگی از محتوای منبع‌دار همین درس هستند و یک دریافت شنیداری مستقل اضافه می‌کنند.',NULL,CAST('{"audioTextTargetFa":"نه، دیگر تب ندارم.","options":[{"text":"Nein, ich habe kein Fieber mehr.","translationFa":"نه، دیگر تب ندارم.","correct":true},{"text":"Ich habe Fieber.","translationFa":"تب دارم.","correct":false},{"text":"Ich habe Husten.","translationFa":"سرفه دارم.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Nein, ich habe kein Fieber mehr.','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-recovery-listen';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-recovery-listen-1','act-de-a1-health-recovery-listen','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-listen',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-listen-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-listen',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-listen-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-health-recovery-order',@lesson,4,'word_order','پاسخ «دیگر سرفه ندارم» را بساز.','بازسازی پاسخ منفی، مهارت پیگیری حال را به بازیابی فعال می‌رساند.',NULL,CAST('{"sourceText":"Nein, ich habe keinen Husten mehr.","sourceTextFa":"نه، دیگر سرفه ندارم.","tokens":["Nein,","ich","habe","keinen","Husten","mehr."],"answer":["Nein,","ich","habe","keinen","Husten","mehr."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-health-recovery-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-health-recovery-order-1','act-de-a1-health-recovery-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-health-recovery-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-health-recovery-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-public-transport-tickets' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-transport-ticket',@level,@unit,34,1,'یک بلیت برای برلین لطفاً','Bitte eine Fahrkarte nach Berlin.','لطفاً یک بلیت به برلین.','qa','درس نخست سفر با حمل‌ونقل عمومی از کار واقعیِ خرید خدمت شروع می‌کند: درخواست بلیت برای یک مقصد مشخص.','از مکالمهٔ باجه به واژگان اصلی و سپس بازسازی درخواست بلیت می‌رسد.','conversation_speaking>matching>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-transport-ticket' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-transport-ticket';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-transport' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-transport-ticket-1','de-a1-lesson-transport-ticket','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-transport-ticket',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-transport-ticket-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-ticket-conversation',@lesson,1,'conversation_speaking','در باجه بلیت بخواه و گفت‌وگوی کوتاه را کامل کن.','درخواست بلیت در یک تبادل کوتاه سلام، درخواست و تشکر قرار می‌گیرد.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-transport-ticket' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-ticket-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-transport' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-conversation-1','act-de-a1-transport-ticket-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-ticket-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-ticket-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-ticket-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-ticket-matching',@lesson,2,'matching','هر واژه را به معنی درستش وصل کن.','سه واژهٔ پایهٔ سفر با قطار برای ادامهٔ واحد لازم‌اند.',NULL,CAST('{"pairs":[{"left":"Fahrkarte","leftFa":"بلیت","right":"بلیت سفر","rightFa":"بلیت سفر"},{"left":"Bahnhof","leftFa":"ایستگاه قطار","right":"محل قطار","rightFa":"محل قطار"},{"left":"Zug","leftFa":"قطار","right":"وسیلهٔ سفر","rightFa":"وسیلهٔ سفر"},{"left":"Bus","leftFa":"اتوبوس","right":"وسیلهٔ جاده‌ای","rightFa":"وسیلهٔ جاده‌ای"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-ticket-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-transport' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-matching-1','act-de-a1-transport-ticket-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-ticket-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-ticket-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-ticket-order',@lesson,3,'word_order','درخواست بلیت به برلین را بساز.','عبارت درخواست بلیت به بازیابی مستقیم منتقل می‌شود.',NULL,CAST('{"sourceText":"Bitte eine Fahrkarte nach Berlin.","sourceTextFa":"لطفاً یک بلیت به برلین.","tokens":["Bitte","eine","Fahrkarte","nach","Berlin."],"answer":["Bitte","eine","Fahrkarte","nach","Berlin."]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-ticket-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-transport' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-order-1','act-de-a1-transport-ticket-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-ticket-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-ticket-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-ticket-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-public-transport-tickets' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-transport-train-bus',@level,@unit,35,2,'این قطار در برلین توقف می‌کند؟','Hält dieser Zug in Berlin?','این قطار در برلین توقف می‌کند؟','qa','درس دوم بعد از گرفتن بلیت روی انتخاب وسیلهٔ درست و اطمینان از توقف در مقصد تمرکز می‌کند.','مکالمه پرسش توقف را معرفی می‌کند، واژگان وسیله و ایستگاه را تفکیک می‌کند و در پایان پرسش بازسازی می‌شود.','conversation_speaking>matching>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-transport-train-bus' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-transport-train-bus';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-transport' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-transport-train-bus-1','de-a1-lesson-transport-train-bus','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-transport-train-bus',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-transport-train-bus-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-stop-conversation',@lesson,1,'conversation_speaking','بپرس آیا این قطار در مقصد موردنظر توقف می‌کند.','پرسش توقف یک نیاز واقعی و مستقل از خرید بلیت است.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-transport-stop' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-stop-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-transport' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-stop-conversation-1','act-de-a1-transport-stop-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-stop-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-stop-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-stop-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-stop-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-stop-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-stop-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-stop-matching',@lesson,2,'matching','هر واژه را به معنی درستش وصل کن.','واژگان قطار و اتوبوس در یک شبکهٔ سادهٔ حمل‌ونقل تثبیت می‌شوند.',NULL,CAST('{"pairs":[{"left":"Zug","leftFa":"قطار","right":"قطار","rightFa":"قطار"},{"left":"Bus","leftFa":"اتوبوس","right":"اتوبوس","rightFa":"اتوبوس"},{"left":"Bahnhof","leftFa":"ایستگاه قطار","right":"ایستگاه قطار","rightFa":"ایستگاه قطار"},{"left":"Bushaltestelle","leftFa":"ایستگاه اتوبوس","right":"ایستگاه اتوبوس","rightFa":"ایستگاه اتوبوس"}],"pairMode":"target_to_persian"}' AS JSON),CAST('["source_items_grouped_for_matching","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-stop-matching';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-transport' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-stop-matching-1','act-de-a1-transport-stop-matching','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-stop-matching',id,'source_items_grouped_for_matching','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-stop-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-stop-matching',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-stop-matching-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-stop-order',@lesson,3,'word_order','پرسش توقف قطار در برلین را بساز.','بازسازی پرسش توقف، مهارت انتخاب مسیر را فعال می‌کند.',NULL,CAST('{"sourceText":"Hält dieser Zug in Berlin?","sourceTextFa":"این قطار در برلین توقف می‌کند؟","tokens":["Hält","dieser","Zug","in","Berlin?"],"answer":["Hält","dieser","Zug","in","Berlin?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-stop-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikivoyage-german-phrasebook-transport' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-stop-order-1','act-de-a1-transport-stop-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-stop-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-stop-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-stop-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-stop-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-public-transport-tickets' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-transport-times-platform',@level,@unit,36,3,'ایستگاه بعدی و سکوی قطار','Wann fährt der nächste Zug nach Budapest? / In 20 Minuten von Gleis 3.','قطار بعدی به بوداپست چه زمانی حرکت می‌کند؟ / ۲۰ دقیقهٔ دیگر از سکوی ۳.','qa','درس قبلی پاسخ زمانِ ضعیف و پوشش صوری سکو داشت؛ این درس کامل با یک گفت‌وگوی جاری و منبع‌دار دربارهٔ توقف، زمان و سکو جایگزین شده است.','مکالمه اطلاعات توقف، زمان و سکو را می‌دهد؛ انتخاب چندگزینه‌ای استخراج اطلاعات را می‌سنجد، شنیدن مستقل همان مهارت را صوتی می‌کند و در پایان پرسش قطار بازسازی می‌شود.','conversation_speaking>multiple_choice>listen_choose>word_order','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-transport-times-platform' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-transport-times-platform';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-transport-dialogue-current' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-transport-times-platform-1','de-a1-lesson-transport-times-platform','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-transport-times-platform',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-transport-times-platform-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-arrival-conversation',@lesson,1,'conversation_speaking','خودت گفت‌وگو را شروع کن و اطلاعات توقف، زمان و سکو را بگیر.','شش نوبت عین گفت‌وگوی حمل‌ونقل منبع هستند و هیچ پاسخ آلمانی برای پرکردن صحنه ساخته نشده است.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-transport-arrival' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"learner"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-arrival-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-transport-dialogue-current' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-conversation-1','act-de-a1-transport-arrival-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-arrival-choice',@lesson,2,'multiple_choice','کدام پاسخ هم زمان و هم شمارهٔ سکو را می‌دهد؟','گزینه‌ها همگی عین گفت‌وگوی ۳ منبع هستند.',NULL,CAST('{"options":[{"textTarget":"In 20 Minuten von Gleis 3.","translationFa":"۲۰ دقیقهٔ دیگر از سکوی ۳.","correct":true},{"textTarget":"Ja, das ist die nächste Haltestelle.","translationFa":"بله، ایستگاه بعدی است.","correct":false},{"textTarget":"Gleich dort, neben der Treppe.","translationFa":"همان‌جا، کنار پله‌ها.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-arrival-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-transport-dialogue-current' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-choice-1','act-de-a1-transport-arrival-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-arrival-listen',@lesson,3,'listen_choose','اطلاعات حرکت را گوش کن و پاسخی را انتخاب کن که زمان و سکو را با هم می‌گوید.','عبارت صوتی و گزینه‌ها از همان گفت‌وگوی منبع‌دار حمل‌ونقل انتخاب شده‌اند.',NULL,CAST('{"audioTextTargetFa":"۲۰ دقیقهٔ دیگر از سکوی ۳.","options":[{"text":"In 20 Minuten von Gleis 3.","translationFa":"۲۰ دقیقهٔ دیگر از سکوی ۳.","correct":true},{"text":"Ja, das ist die nächste Haltestelle.","translationFa":"بله، ایستگاه بعدی است.","correct":false},{"text":"Gleich dort, neben der Treppe.","translationFa":"همان‌جا، کنار پله‌ها.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'In 20 Minuten von Gleis 3.','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-arrival-listen';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-transport-dialogue-current' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-listen-1','act-de-a1-transport-arrival-listen','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-listen',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-listen-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-listen',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-listen-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-transport-arrival-order',@lesson,4,'word_order','پرسش زمان حرکت قطار بعدی را بساز.','پرسش عین گفت‌وگوی منبع است و به بازیابی هدایت‌شده منتقل می‌شود.',NULL,CAST('{"sourceText":"Wann fährt der nächste Zug nach Budapest?","sourceTextFa":"قطار بعدی به بوداپست چه زمانی حرکت می‌کند؟","tokens":["Wann","fährt","der","nächste","Zug","nach","Budapest?"],"answer":["Wann","fährt","der","nächste","Zug","nach","Budapest?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-transport-arrival-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-transport-dialogue-current' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-order-1','act-de-a1-transport-arrival-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-transport-arrival-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-transport-arrival-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-weather-temperature' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-weather-current',@level,@unit,37,1,'هوا در برلین چطوره؟','Wie ist das Wetter in Berlin?','هوا در برلین چطور است؟','qa','ساختار پیش‌بینی درس قبلی کامل حذف شده و درس فقط روی وضعیت فعلی هوا و یک تمرین کوتاه تلفظی منبع‌دار تمرکز می‌کند.','مکالمه دو وضعیت فعلی را معرفی می‌کند، یک وضعیت مستقل شنیده می‌شود، پرسش هوا بازسازی می‌شود و در پایان یک تمایز تلفظی کوتاه تمرین می‌شود.','conversation_speaking>listen_choose>word_order>pronunciation_read','stale',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-weather-current' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-weather-current';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-weather-current-1','de-a1-lesson-weather-current','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-weather-current',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-weather-current-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-weather' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-weather-current-2','de-a1-lesson-weather-current','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-weather-current',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-weather-current-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-pronunciation-consonants' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-weather-current-3','de-a1-lesson-weather-current','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-weather-current',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-weather-current-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-current-conversation',@lesson,1,'conversation_speaking','دربارهٔ هوای فعلی برلین گفت‌وگو کن.','پرسش و پاسخ‌ها از دو منبع باز و قابل‌بازاستفاده انتخاب شده‌اند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-weather-current' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["other","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-current-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-current-conversation-1','act-de-a1-weather-current-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-weather' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-current-conversation-2','act-de-a1-weather-current-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-conversation',id,'other','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-conversation-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-current-choice',@lesson,2,'listen_choose','عبارت هوا را گوش کن و همان وضعیت را انتخاب کن.','عبارت صوتی و گزینه‌ها عین منبع Deutsch im Blick هستند.',NULL,CAST('{"audioTextTargetFa":"هوا بادی است.","options":[{"text":"Es ist windig.","translationFa":"هوا بادی است.","correct":true},{"text":"Es ist sonnig.","translationFa":"هوا آفتابی است.","correct":false},{"text":"Es ist bewölkt.","translationFa":"هوا ابری است.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),'Es ist windig.','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-current-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-weather' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-current-choice-1','act-de-a1-weather-current-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-current-order',@lesson,3,'word_order','پرسش هوای برلین را بساز.','پرسش عین منبع است و فقط قطعه‌بندی شده است.',NULL,CAST('{"sourceText":"Wie ist das Wetter in Berlin?","sourceTextFa":"هوا در برلین چطور است؟","tokens":["Wie","ist","das","Wetter","in","Berlin?"],"answer":["Wie","ist","das","Wetter","in","Berlin?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-current-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-current-order-1','act-de-a1-weather-current-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-current-pronunciation',@lesson,4,'pronunciation_read','این جفت منبع‌دار را با دقت به تفاوت دو همخوان بخوان.','این جفت کمینه عین بخش تلفظ همخوان‌های Deutsch im Blick است.',NULL,CAST('{"lines":["Vetter - Wetter"],"audioTextTargetFa":"جفت تلفظی Vetter و Wetter."}' AS JSON),CAST('["source_items_grouped_for_pronunciation"]' AS JSON),'Vetter - Wetter','stale')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status='stale',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-current-pronunciation';
SET @src := (SELECT id FROM sources WHERE source_key='src-coerll-dib-pronunciation-consonants' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-current-pronunciation-1','act-de-a1-weather-current-pronunciation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-current-pronunciation',id,'source_items_grouped_for_pronunciation','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-current-pronunciation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-weather-temperature' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-weather-rain-plan',@level,@unit,38,2,'آفتابی یا ابری؟','Es ist sonnig / Es ist bewölkt','هوا آفتابی است / هوا ابری است','qa','ساختارهای سنگین پیش‌بینی و توصیهٔ درس قبلی حذف شده‌اند؛ این جایگزین فقط عبارت‌های ساده و عیناً منبع‌دارِ وضعیت فعلی هوا را تمرین می‌دهد.','مکالمه دو وضعیت ساده را می‌آورد، سپس وضعیت درست تشخیص داده می‌شود و پرسش پایهٔ هوا بازسازی می‌شود.','conversation_speaking>multiple_choice>word_order','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-weather-rain-plan' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-weather-rain-plan';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-weather-rain-plan-1','de-a1-lesson-weather-rain-plan','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-weather-rain-plan',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-weather-rain-plan-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-rain-conversation',@lesson,1,'conversation_speaking','دو وضعیت سادهٔ آفتابی و ابری را در گفت‌وگو دنبال کن.','چهار نوبت فقط از پرسش و پاسخ‌های سادهٔ منبع تشکیل شده‌اند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-weather-rain-plan' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-rain-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-rain-conversation-1','act-de-a1-weather-rain-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-rain-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-rain-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-rain-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-rain-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-rain-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-rain-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-rain-response',@lesson,2,'multiple_choice','کدام جمله یعنی هوا ابری است؟','سه گزینه عین عبارت‌های وضعیت هوا در منبع هستند.',NULL,CAST('{"options":[{"textTarget":"Es ist bewölkt","translationFa":"هوا ابری است.","correct":true},{"textTarget":"Es ist sonnig","translationFa":"هوا آفتابی است.","correct":false},{"textTarget":"Es ist regnerisch","translationFa":"هوا بارانی است.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-rain-response';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-rain-response-1','act-de-a1-weather-rain-response','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-rain-response',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-rain-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-rain-response',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-rain-response-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-rain-order',@lesson,3,'word_order','پرسش سادهٔ هوا در برلین را بساز.','پرسش عین منبع است و فقط برای بازسازی به قطعه‌های واژگانی تقسیم شده است.',NULL,CAST('{"sourceText":"Wie ist das Wetter in Berlin?","sourceTextFa":"هوا در برلین چطور است؟","tokens":["Wie","ist","das","Wetter","in","Berlin?"],"answer":["Wie","ist","das","Wetter","in","Berlin?"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-rain-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-rain-order-1','act-de-a1-weather-rain-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-rain-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-rain-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-rain-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-rain-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;

SET @unit := (SELECT id FROM units WHERE unit_key='de-a1-unit-weather-temperature' AND language_level_id=@level LIMIT 1);
INSERT INTO lessons(lesson_key,language_level_id,unit_id,sequence_index,position_in_unit,title_fa,source_title,source_title_fa,status,activity_selection_rationale,sequence_rationale,template_signature,audio_status,notes)
VALUES ('de-a1-lesson-weather-temperature',@level,@unit,39,3,'باران یا برف؟','Es regnet / Es schneit','باران می‌بارد / برف می‌بارد','qa','عبارت‌های دماسنجِ مصنوعی درس قبلی کنار گذاشته شده‌اند؛ این درس کامل با دو وضعیت بسیار ساده و منبع‌دار باران و برف جایگزین شده است.','باران و برف در گفت‌وگو و بازسازی تمرین می‌شوند و در پایان یک بازیابی بین‌واحدی سلامت/آب‌وهوا/حمل‌ونقل اضافه می‌شود.','conversation_speaking>multiple_choice>word_order>multiple_choice','pending',NULL)
ON DUPLICATE KEY UPDATE unit_id=VALUES(unit_id),sequence_index=VALUES(sequence_index),position_in_unit=VALUES(position_in_unit),title_fa=VALUES(title_fa),source_title=VALUES(source_title),source_title_fa=VALUES(source_title_fa),status=VALUES(status),activity_selection_rationale=VALUES(activity_selection_rationale),sequence_rationale=VALUES(sequence_rationale),template_signature=VALUES(template_signature),notes=VALUES(notes);
SET @lesson := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-weather-temperature' AND language_level_id=@level LIMIT 1);
UPDATE lessons SET status='qa' WHERE id=@lesson;
DELETE FROM activities WHERE lesson_id=@lesson;
DELETE FROM provenance_links WHERE entity_type='lesson' AND entity_key='de-a1-lesson-weather-temperature';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-weather-temperature-1','de-a1-lesson-weather-temperature','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-weather-temperature',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-weather-temperature-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-weather-temperature-2','de-a1-lesson-weather-temperature','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-weather-temperature',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-weather-temperature-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-transport-dialogue-current' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-lesson-de-a1-lesson-weather-temperature-3','de-a1-lesson-weather-temperature','پیوند منبع درس در دور اصلاح کیفیت',NULL,NULL,'پیوند رسمی درس به منبع قابل‌بازاستفادهٔ ثبت‌شده.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'lesson','de-a1-lesson-weather-temperature',id,'other','پیوند رسمی منبع درس.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-lesson-de-a1-lesson-weather-temperature-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-temperature-conversation',@lesson,1,'conversation_speaking','دو وضعیت سادهٔ باران و برف را در گفت‌وگو دنبال کن.','چهار نوبت عین پرسش و پاسخ‌های بخش واژگان آب‌وهوا هستند.',(SELECT id FROM dialogues WHERE dialogue_key='dlg-de-a1-weather-temperature' LIMIT 1),CAST('{"interaction":"read_aloud_exchange","openingInitiator":"app"}' AS JSON),CAST('["verbatim_dialogue","persian_translation_added","character_metadata_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-temperature-conversation';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-conversation-1','act-de-a1-weather-temperature-conversation','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-temperature-conversation',id,'verbatim','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-temperature-conversation',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-temperature-conversation',id,'character_metadata_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-conversation-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-temperature-choice',@lesson,2,'multiple_choice','کدام جمله یعنی باران می‌بارد؟','سه گزینه همگی عین عبارت‌های منبع هستند.',NULL,CAST('{"options":[{"textTarget":"Es regnet","translationFa":"باران می‌بارد.","correct":true},{"textTarget":"Es schneit","translationFa":"برف می‌بارد.","correct":false},{"textTarget":"Es nieselt","translationFa":"نم‌نم باران می‌بارد.","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-temperature-choice';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-choice-1','act-de-a1-weather-temperature-choice','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-temperature-choice',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-temperature-choice',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-choice-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-temperature-order',@lesson,3,'word_order','عبارت «برف می‌بارد» را بساز.','عبارت عین منبع است و فقط برای بازیابی به قطعه‌های واژگانی تقسیم شده است.',NULL,CAST('{"sourceText":"Es schneit","sourceTextFa":"برف می‌بارد.","tokens":["Es","schneit"],"answer":["Es","schneit"]}' AS JSON),CAST('["sentence_tokenized_for_word_order","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-temperature-order';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-order-1','act-de-a1-weather-temperature-order','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-temperature-order',id,'sentence_tokenized_for_word_order','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-temperature-order',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-temperature-order-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO activities(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)
VALUES ('act-de-a1-weather-cross-unit-retrieval',@lesson,4,'multiple_choice','کدام پرسش مربوط به سلامت است؟','سه پرسش عین منابع سلامت، آب‌وهوا و حمل‌ونقل‌اند و بازیابی فاصله‌دار چند واحد را در پایان A1 تمرین می‌کنند.',NULL,CAST('{"options":[{"textTarget":"Was fehlt Ihnen?","translationFa":"چه مشکلی دارید؟","correct":true},{"textTarget":"Wie ist das Wetter in Berlin?","translationFa":"هوا در برلین چطور است؟","correct":false},{"textTarget":"Wann fährt der nächste Zug nach Budapest?","translationFa":"قطار بعدی به بوداپست چه زمانی حرکت می‌کند؟","correct":false}]}' AS JSON),CAST('["options_selected_from_source_material","persian_translation_added"]' AS JSON),NULL,'not_required')
ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=NULL,audio_status='not_required',audio_url=NULL,audio_storage_path=NULL,audio_source_hash=NULL,audio_provider=NULL,audio_model_id=NULL,audio_voice_name=NULL,audio_voice_id=NULL,audio_generated_at=NULL;
DELETE FROM provenance_links WHERE entity_type='activity' AND entity_key='act-de-a1-weather-cross-unit-retrieval';
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-lesson-018-health' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-1','act-de-a1-weather-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-1'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-weather-appendix' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-2','act-de-a1-weather-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-2'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
SET @src := (SELECT id FROM sources WHERE source_key='src-wikibooks-de-transport-dialogue-current' LIMIT 1);
INSERT INTO source_items(source_id,item_key,locator,locator_fa,source_text,source_text_hash,notes)
VALUES (@src,'srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-3','act-de-a1-weather-cross-unit-retrieval','پیوند منبع فعالیت در دور اصلاح کیفیت',NULL,NULL,'متن آلمانی نمایش‌داده‌شونده به زبان‌آموز در دادهٔ فعالیت از نسخهٔ رسمی محتوا کپی شده و این رکورد پیوند منبع آن را نگه می‌دارد.')
ON DUPLICATE KEY UPDATE locator=VALUES(locator),locator_fa=VALUES(locator_fa),notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-cross-unit-retrieval',id,'options_selected_from_source_material','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes)
SELECT 'activity','act-de-a1-weather-cross-unit-retrieval',id,'persian_translation_added','پیوند منشأ فعالیت از نسخهٔ رسمی محتوا.' FROM source_items WHERE source_id=@src AND item_key='srcitem-a1-fixpass-activity-act-de-a1-weather-cross-unit-retrieval-3'
ON DUPLICATE KEY UPDATE notes=VALUES(notes);
DELETE atg FROM activity_targets atg JOIN activities a ON a.id=atg.activity_id WHERE a.lesson_id=@lesson;
INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id)
SELECT a.id,ut.curriculum_target_id FROM activities a JOIN unit_targets ut ON ut.unit_id=@unit WHERE a.lesson_id=@lesson;
UPDATE lessons SET status='final' WHERE id=@lesson;
DELETE p FROM provenance_links p LEFT JOIN activities a ON a.activity_key=p.entity_key WHERE p.entity_type='activity' AND a.id IS NULL;

-- Restore the authoring release state after all lesson activity mutations.
UPDATE lessons SET status='final' WHERE language_level_id=@level;

-- Final-level text changes are invalidated by schema triggers as blocked; once the
-- level remains final, those changed assets become stale and are eligible for regeneration.
UPDATE dialogue_turns dt
JOIN dialogues d ON d.id=dt.dialogue_id
SET dt.audio_status='stale'
WHERE d.language_level_id=@level
  AND dt.audio_status='blocked_until_level_final';

UPDATE activities a
JOIN lessons l ON l.id=a.lesson_id
SET a.audio_status='stale'
WHERE l.language_level_id=@level
  AND a.audio_text_target IS NOT NULL
  AND a.audio_status='blocked_until_level_final';

-- Remove provenance rows left behind by obsolete learner-facing entities.
DELETE p FROM provenance_links p
LEFT JOIN activities a ON p.entity_type='activity' AND a.activity_key=p.entity_key
WHERE p.entity_type='activity' AND a.id IS NULL;
DELETE p FROM provenance_links p
LEFT JOIN dialogue_turns t ON p.entity_type='dialogue_turn' AND t.turn_key=p.entity_key
WHERE p.entity_type='dialogue_turn' AND t.id IS NULL;

-- Structural totals and matching/source contracts are enforced by the canonical CI validators.
COMMIT;

DROP TABLE IF EXISTS __a1_reimport_guard;
