-- German A1: move the fully mapped content build into whole-level review.
-- This does not finalize the level and does not unlock or generate audio.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

UPDATE curriculum_targets ct
SET ct.status='review'
WHERE ct.language_level_id=@level
  AND ct.required_for_completion=TRUE
  AND (
    EXISTS (
      SELECT 1 FROM unit_targets ut
      WHERE ut.curriculum_target_id=ct.id
    )
    OR EXISTS (
      SELECT 1 FROM lesson_targets lt
      WHERE lt.curriculum_target_id=ct.id
    )
    OR EXISTS (
      SELECT 1 FROM activity_targets atg
      WHERE atg.curriculum_target_id=ct.id
    )
  );

UPDATE language_levels
SET status=IF(status='final',status,'review'),
    coverage=JSON_OBJECT(
      'gaps',JSON_ARRAY(
        'همهٔ ۳۷ هدف الزامی به شواهد واقعی واحد، درس یا فعالیت وصل شده‌اند؛ در مرحلهٔ بازبینی باید کفایت هر نگاشت و نبودِ پوشش صوری دوباره بررسی شود.',
        'توازن دشواری، تنوع الگوی فعالیت و توزیع چهار مهارت در کل ۱۶ درس باید به‌صورت سراسری بازبینی شود.',
        'منابع، ترجمه‌های فارسی، ردیابی منبع و طبیعی‌بودن نقش شخصیت‌ها باید یک دور نهایی کنترل کیفیت شوند.',
        'صوت A1 تا نهایی‌شدن کل سطح تولید نمی‌شود و همهٔ موارد صوتی مستقل در این مرحله مسدود می‌مانند.'
      )
    ),
    notes='A1 وارد مرحلهٔ بازبینی سراسری شده است. ده واحد و ۱۶ درس ساخته شده‌اند و همهٔ ۳۷ هدف الزامی نگاشت واقعی دارند. این تغییر به معنی نهایی‌شدن محتوا نیست؛ مرحلهٔ بعد کنترل کیفیت سراسری و رفع فقط ایرادهای واقعی است. صوت تا نهایی‌شدن سطح مسدود می‌ماند.'
WHERE id=@level;

COMMIT;
