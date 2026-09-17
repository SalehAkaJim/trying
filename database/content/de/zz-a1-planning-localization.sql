-- Persian-only synchronization for German A1 planning metadata.
-- Runs after a1-planning.sql and is intentionally idempotent.

SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @de_a1 := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

UPDATE language_levels
SET
  structure_rationale='A1 از توانایی‌های تثبیت‌شدهٔ سطح پیشین عبور می‌کند و زبان‌آموز را به ارتباط ساده اما مستقل‌تر در موقعیت‌های روزمره می‌رساند. ساختار واحدها و درس‌ها تا زمانی که پوشش CEFR، پیش‌نیازها، منابع قابل‌بازاستفاده و نیاز واقعی به تمرین مشخص نشده‌اند سهمیه‌بندی عددی نمی‌شود.',
  notes='A1 در مرحلهٔ برنامه‌ریزی باز شده است. سطح پیشین، پیش‌نیاز بسته و نهایی این سطح است. مرحلهٔ بعد، ساخت فهرست منبع‌دار آلمانی و تبدیل هدف‌ها به توالی آموزشی است.'
WHERE id=@de_a1;

UPDATE sources
SET
  title_fa='پروفایل رسمی آزمون آلمانی سطح A1 مؤسسهٔ گوته',
  currency_evidence='صفحهٔ رسمی و فعال مؤسسهٔ گوته در ۱۷ سپتامبر ۲۰۲۶ بررسی شد و همچنان پروفایل مهارتی آزمون A1 بزرگسالان را ارائه می‌کند.'
WHERE source_key='src-goethe-a1-profile';

COMMIT;
