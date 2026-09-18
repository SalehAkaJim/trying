-- German A1: align final level metadata after successful audio generation and validation.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

UPDATE language_levels
SET completion_assessment=JSON_SET(
      completion_assessment,
      '$.reviewedAt','2026-09-18T05:02:00Z',
      '$.qualityReview.rationale','پوشش همهٔ ۳۷ هدف الزامی به شواهد واقعی درس و فعالیت متصل است؛ ۱۰ واحد و ۱۶ درس چند دور بازبینی ساختاری، زبانی، منبعی و ترجمه‌ای را گذرانده‌اند. ایرادهای پیدا‌شده در پوشش حرف تعریف، ردیابی منبع، نوع خطاب شخصیت‌ها، چند ترجمهٔ فارسی و تولید نوشتاری هدایت‌شده اصلاح شدند. هر ۱۶۷ فایل صوتی لازم نیز تولید و از نظر دارایی، نگاشت و سازگاری با پایگاه داده اعتبارسنجی شده‌اند؛ تنها بازبینی شنیداری انسانی برای کنترل کیفیت ادراکی باقی مانده است.',
      '$.qualityReview.remainingWeaknesses',JSON_ARRAY(
        'تولید نوشتاری در ساختار فعلی برنامه هدایت‌شده است و ورودی آزاد تایپی ندارد.',
        'دارایی‌های صوتی و نگاشت آن‌ها به‌صورت فنی اعتبارسنجی شده‌اند، اما بازبینی شنیداری انسانی برای کنترل لحن، تلفظ و طبیعی‌بودن همهٔ فایل‌ها هنوز انجام نشده است.'
      )
    ),
    notes='این سطح از نظر محتوایی و فنی نهایی شده است: هر ۱۰ واحد و هر ۱۶ درس نهایی‌اند، همهٔ ۳۷ هدف الزامی پوشش و ارزیابی شده‌اند و شکاف الزامی باز باقی نمانده است. هر ۱۶۷ فایل صوتی لازم تولید شده‌اند، نگاشت‌ها و دارایی‌ها اعتبارسنجی شده‌اند و وضعیت صوت آماده است؛ بازبینی شنیداری انسانی برای کنترل کیفیت نهایی باقی مانده است.'
WHERE id=@level;

COMMIT;
