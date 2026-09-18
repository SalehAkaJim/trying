-- German A1: align every built lesson with whole-level review.
-- This does not finalize content and does not unlock audio.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);
UPDATE lessons
SET status=IF(status='final',status,'review')
WHERE language_level_id=@level;
UPDATE language_levels
SET notes='A1 در مرحلهٔ بازبینی سراسری است. ده واحد و همهٔ ۱۶ درس اکنون در وضعیت بازبینی هستند و همهٔ ۳۷ هدف الزامی نگاشت واقعی دارند. بازبینی تا اینجا پوشش حرف تعریف، ردیابی منبع، سازگاری نوع خطاب، ترجمه‌های فارسی و تولید هدایت‌شدهٔ نوشتاری را تقویت کرده است. صوت تا نهایی‌شدن سطح مسدود می‌ماند.'
WHERE id=@level;
COMMIT;
