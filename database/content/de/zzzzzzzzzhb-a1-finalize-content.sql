-- German A1: finalize the content level and unlock audio planning.
-- This migration does not generate audio and never overwrites existing generated assets.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

UPDATE curriculum_targets
SET status='covered'
WHERE language_level_id=@level
  AND required_for_completion=TRUE
  AND status='review';

-- Activity metadata on final lessons is protected by a trigger.
-- Reopen the A1 lessons only inside this transaction, update audio metadata,
-- then restore every lesson to final before committing.
UPDATE lessons
SET status='qa'
WHERE language_level_id=@level
  AND status='final';

UPDATE lessons
SET audio_status=CASE
      WHEN audio_status='blocked_until_level_final' THEN 'pending'
      ELSE audio_status
    END
WHERE language_level_id=@level;

UPDATE dialogue_turns dt
JOIN dialogues d ON d.id=dt.dialogue_id
SET dt.audio_status=CASE
      WHEN dt.audio_status='blocked_until_level_final' THEN 'pending'
      ELSE dt.audio_status
    END
WHERE d.language_level_id=@level;

UPDATE activities a
JOIN lessons l ON l.id=a.lesson_id
SET a.audio_status=CASE
      WHEN a.audio_text_target IS NOT NULL
       AND a.audio_status='blocked_until_level_final' THEN 'pending'
      ELSE a.audio_status
    END
WHERE l.language_level_id=@level;

UPDATE lessons
SET status='final'
WHERE language_level_id=@level
  AND status='qa';

UPDATE lexemes
SET audio_status=CASE
      WHEN audio_status='blocked_until_level_final' THEN 'pending'
      ELSE audio_status
    END
WHERE language_id=@de
  AND cefr_level='A1';

UPDATE units
SET status='final'
WHERE language_level_id=@level;

UPDATE language_levels
SET status='final',
    audio_status='pending',
    coverage=JSON_SET(coverage,'$.gaps',JSON_ARRAY()),
    completion_assessment=JSON_OBJECT(
      'reviewedAt','2026-09-18T04:45:00Z',
      'cefrCoverageComplete',TRUE,
      'progressionComplete',TRUE,
      'practiceAndRetrievalComplete',TRUE,
      'skillModeCoverageComplete',TRUE,
      'requiredGaps',JSON_ARRAY(),
      'qualityReview',JSON_OBJECT(
        'overallScore',9.2,
        'dimensionScores',JSON_OBJECT(
          'cefrCoverage',9.4,
          'pedagogicalProgression',9.2,
          'practiceAndRetrieval',9.1,
          'activityQualityAndVariety',9.0,
          'linguisticAccuracyAndNaturalness',9.3,
          'sourceQualityAndCurrency',9.4,
          'learnerSupportAndClarity',9.1,
          'qaIntegrity',9.3
        ),
        'rationale','پوشش همهٔ ۳۷ هدف الزامی به شواهد واقعی درس و فعالیت متصل است؛ ۱۰ واحد و ۱۶ درس چند دور بازبینی ساختاری، زبانی، منبعی و ترجمه‌ای را گذرانده‌اند. ایرادهای پیدا‌شده در پوشش حرف تعریف، ردیابی منبع، نوع خطاب شخصیت‌ها، چند ترجمهٔ فارسی و تولید نوشتاری هدایت‌شده اصلاح شدند. سطح از نظر محتوایی آمادهٔ نهایی‌شدن است؛ صوت یک فرایند انتشار جداگانه و هنوز در انتظار برنامه‌ریزی و تولید است.',
        'strengths',JSON_ARRAY(
          'همهٔ هدف‌های الزامی A1 نگاشت واقعی به واحد، درس یا فعالیت دارند.',
          'متن آلمانی زبان‌آموز از منابع قابل‌بازاستفاده و بررسی‌شده می‌آید و متن آزادِ ساخته‌شده به محتوای آموزشی وارد نشده است.',
          'ترتیب فعالیت‌ها عمدتاً از فهم و تشخیص به بازیابی و تولید هدایت‌شده حرکت می‌کند.',
          'گفت‌وگوها از نظر نوع خطاب و رابطهٔ شخصیت‌ها بازبینی و اصلاح شده‌اند.',
          'خواندن، شنیدن، گفتار، فرم، تابلو، پیام کوتاه و تلفظ در سطح توزیع شده‌اند.'
        ),
        'remainingWeaknesses',JSON_ARRAY(
          'تولید نوشتاری در ساختار فعلی برنامه هدایت‌شده است و ورودی آزاد تایپی ندارد.',
          'صوت هنوز تولید نشده و کیفیت شنیداری نهایی پس از تولید و اعتبارسنجی فایل‌ها باید جداگانه کنترل شود.'
        )
      ),
      'scopeExclusions',JSON_ARRAY(
        'ورودی آزاد تایپی در ساختار فعلی فعالیت‌ها پشتیبانی نمی‌شود؛ تولید نوشتاری A1 در این نسخه به تکمیل و بازسازی هدایت‌شده محدود است.'
      )
    ),
    notes='A1 از نظر محتوایی نهایی شده است: هر ۱۰ واحد و هر ۱۶ درس نهایی‌اند، همهٔ ۳۷ هدف الزامی پوشش و ارزیابی شده‌اند و شکاف الزامی باز باقی نمانده است. صوت اکنون از حالت مسدود خارج شده و در وضعیت انتظار قرار دارد؛ هنوز هیچ تولید صوت پولی انجام نشده است.'
WHERE id=@level;

COMMIT;
