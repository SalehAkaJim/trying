-- German A1: finalize reviewed lessons and units while keeping the level itself in review.
-- Audio remains blocked because the whole A1 level is not final yet.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

UPDATE lessons
SET status='final'
WHERE language_level_id=@level
  AND status IN ('draft','source_checked','cefr_checked','qa');

UPDATE units
SET status='final'
WHERE language_level_id=@level
  AND status IN ('draft','review');

UPDATE language_levels
SET status=IF(status='final',status,'review'),
    notes='A1 در مرحلهٔ بازبینی سراسری است. هر ۱۰ واحد و هر ۱۶ درس پس از کنترل کیفیت محتوایی به وضعیت نهایی رسیده‌اند، اما خود سطح هنوز نهایی نشده است. همهٔ ۳۷ هدف الزامی نگاشت واقعی دارند و صوت تا نهایی‌شدن کل سطح مسدود می‌ماند.'
WHERE id=@level;
COMMIT;
