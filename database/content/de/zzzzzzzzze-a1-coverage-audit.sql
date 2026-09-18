-- German A1 whole-level coverage audit mappings.
-- No new learner-facing German is introduced here; this migration connects existing
-- source-backed lesson/activity evidence to the three curriculum targets that were
-- previously unmapped.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+00:00';
START TRANSACTION;

SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='A1' LIMIT 1);

SET @t_everyday := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-comm-everyday-expressions' LIMIT 1);
SET @t_nouns := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-nouns-articles-plurals' LIMIT 1);
SET @t_cases := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='a1-ling-basic-cases' LIMIT 1);

SET @u_intro := (SELECT id FROM units WHERE unit_key='de-a1-unit-extended-introduction' LIMIT 1);
SET @u_time := (SELECT id FROM units WHERE unit_key='de-a1-unit-time-plans-appointment' LIMIT 1);
SET @u_dir := (SELECT id FROM units WHERE unit_key='de-a1-unit-directions-public-places' LIMIT 1);
SET @u_service := (SELECT id FROM units WHERE unit_key='de-a1-unit-requests-services-help' LIMIT 1);
SET @u_forms := (SELECT id FROM units WHERE unit_key='de-a1-unit-forms-signs-messages' LIMIT 1);

INSERT IGNORE INTO unit_targets(unit_id,curriculum_target_id) VALUES
(@u_service,@t_everyday),
(@u_intro,@t_nouns),
(@u_forms,@t_nouns),
(@u_time,@t_cases),
(@u_dir,@t_cases);

SET @l_work := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-work-and-languages' LIMIT 1);
SET @l_time := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-time-class-schedule' LIMIT 1);
SET @l_appt := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-time-simple-appointment' LIMIT 1);
SET @l_dir := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-ask-and-follow-directions' LIMIT 1);
SET @l_service := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-clarify-permission-help' LIMIT 1);
SET @l_forms := (SELECT id FROM lessons WHERE lesson_key='de-a1-lesson-personal-form-signs' LIMIT 1);

INSERT IGNORE INTO lesson_targets(lesson_id,curriculum_target_id,coverage_role) VALUES
(@l_service,@t_everyday,'introduce'),
(@l_work,@t_nouns,'practice'),
(@l_forms,@t_nouns,'support'),
(@l_time,@t_cases,'practice'),
(@l_appt,@t_cases,'practice'),
(@l_dir,@t_cases,'practice');

SET @a_service := (SELECT id FROM activities WHERE activity_key='act-de-a1-service-conversation' LIMIT 1);
SET @a_permission := (SELECT id FROM activities WHERE activity_key='act-de-a1-phone-permission-choice' LIMIT 1);
SET @a_help := (SELECT id FROM activities WHERE activity_key='act-de-a1-specific-help-response' LIMIT 1);
SET @a_plural := (SELECT id FROM activities WHERE activity_key='act-de-a1-language-question-order' LIMIT 1);
SET @a_form_nouns := (SELECT id FROM activities WHERE activity_key='act-de-a1-form-fields-matching' LIMIT 1);
SET @a_school_case := (SELECT id FROM activities WHERE activity_key='act-de-a1-time-bis-wann-order' LIMIT 1);
SET @a_concert_case := (SELECT id FROM activities WHERE activity_key='act-de-a1-appointment-invite-order' LIMIT 1);
SET @a_destination_case := (SELECT id FROM activities WHERE activity_key='act-de-a1-directions-question-order' LIMIT 1);

INSERT IGNORE INTO activity_targets(activity_id,curriculum_target_id) VALUES
(@a_service,@t_everyday),
(@a_permission,@t_everyday),
(@a_help,@t_everyday),
(@a_plural,@t_nouns),
(@a_form_nouns,@t_nouns),
(@a_school_case,@t_cases),
(@a_concert_case,@t_cases),
(@a_destination_case,@t_cases);

UPDATE language_levels
SET coverage=JSON_SET(
      coverage,
      '$.gaps[2]','بررسی سراسری ۳۷ هدف نشان داد همهٔ هدف‌ها شواهد آموزشی دارند؛ سه شکاف صرفاً در نگاشت دیتابیس بودند و به محتوای موجود وصل شدند.',
      '$.gaps[3]','پوشش چهار مهارت، تلفظ و الگوهای زبانی اکنون در درس‌های A1 توزیع شده است؛ مرحلهٔ بعد بازبینی سراسری کیفیت و کفایت پوشش، نه افزودن سهمیه‌ای محتوا، است.'
    ),
    notes='ده واحد محتوایی A1 ساخته و بازبینی واحدی شده‌اند. بررسی سراسری همهٔ ۳۷ هدف را به شواهد واقعی درس و فعالیت وصل کرده است. سطح هنوز نهایی نیست؛ قدم بعد بازبینی سراسری پیش از تغییر وضعیت کل سطح است و صوت همچنان تا نهایی‌شدن سطح مسدود می‌ماند.'
WHERE id=@level;

COMMIT;
