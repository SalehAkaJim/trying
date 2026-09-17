-- Persian learner-facing payload translations for German Pre-A1.
-- This file is intentionally sorted after pre-a1.sql and is idempotent.

START TRANSACTION;

UPDATE activities
SET payload = JSON_SET(payload,
  '$.options[0].translationFa','خداحافظ!',
  '$.options[1].translationFa','سلام!')
WHERE activity_key='act-de-hallo-farewell-choice';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.options[0].translationFa','صبح بخیر!',
  '$.options[1].translationFa','سلام!')
WHERE activity_key='act-de-gm-choice';

UPDATE activities
SET payload = JSON_SET(payload,'$.sourceTextFa','من پیتزا دوست دارم.')
WHERE activity_key='act-de-pizza-word-order';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.promptFa','پیتزا دوست داری؟',
  '$.options[0].translationFa','بله!',
  '$.options[1].translationFa','نه!')
WHERE activity_key='act-de-ja-nein-choice';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.promptFa','ممنون!',
  '$.options[0].translationFa','خواهش می‌کنم!',
  '$.options[1].translationFa','سلام!')
WHERE activity_key='act-de-danke-bitte-response';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.pairs[0].leftFa','ببخشید.',
  '$.pairs[0].rightFa','مشکلی نیست.',
  '$.pairs[1].leftFa','ممنون!',
  '$.pairs[1].rightFa','خواهش می‌کنم!')
WHERE activity_key='act-de-entschuldigung-matching';

UPDATE activities
SET payload = JSON_SET(payload,'$.sourceTextFa','اسم من آیریس است.')
WHERE activity_key='act-de-name-word-order';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.sourceTextFa','حالت چطوره؟',
  '$.blankedTextFa','___ چطوره؟',
  '$.choicesFa',JSON_ARRAY('حالت','خوب'))
WHERE activity_key='act-de-wellbeing-fill';

UPDATE activities
SET payload = JSON_SET(payload,'$.sourceTextFa','چی می‌خوای؟')
WHERE activity_key='act-de-simple-choice-word-order';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.pairs[0].leftFa','کجا زندگی می‌کنید؟',
  '$.pairs[0].rightFa','من در اتریش زندگی می‌کنم.',
  '$.pairs[1].leftFa','اهل کجا هستید؟',
  '$.pairs[1].rightFa','من اهل آلمان هستم، شما چطور؟')
WHERE activity_key='act-de-residence-matching';

UPDATE activities
SET payload = JSON_SET(payload,'$.audioTextTargetFa','هجده')
WHERE activity_key='act-de-age-listen';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.audioTextTargetFa','ساعت ۶:۳۰ است.')
WHERE activity_key='act-de-time-listen';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.options[0].translationFa','صبح است.',
  '$.options[1].translationFa','عصر است.')
WHERE activity_key='act-de-time-of-day';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.sourceTextFa','تولد من سیزدهم نوامبر است.',
  '$.blankedTextFa','تولد من ___ نوامبر است.',
  '$.choicesFa',JSON_ARRAY('سیزدهم'))
WHERE activity_key='act-de-birthday-fill';

UPDATE activities
SET payload = JSON_SET(payload,'$.audioTextTargetFa','شماره تلفن من ۷۸۹ است.')
WHERE activity_key='act-de-phone-listen';

UPDATE activities
SET payload = JSON_SET(payload,'$.sourceTextFa','این یک کتاب است.')
WHERE activity_key='act-de-object-word-order';

UPDATE activities
SET payload = JSON_SET(payload,
  '$.fields[0].patternFa','اسم من ___ است.',
  '$.fields[0].exampleSourceTextFa','اسم من پاول مولر است.',
  '$.fields[1].patternFa','من در ___ زندگی می‌کنم.',
  '$.fields[1].exampleSourceTextFa','من در اتریش زندگی می‌کنم.',
  '$.fields[2].patternFa','من ___ ساله هستم.',
  '$.fields[2].exampleSourceTextFa','من ۲۰ ساله هستم.',
  '$.fields[3].patternFa','شماره تلفن من ___ است.',
  '$.fields[3].exampleSourceTextFa','شماره تلفن من ۷۸۹ است.',
  '$.fields[4].patternFa','تولد من ___ است.',
  '$.fields[4].exampleSourceTextFa','تولد من سیزدهم نوامبر است.',
  '$.fields[5].patternFa','نشانی: ___',
  '$.fields[5].exampleSourceTextFa','نشانی')
WHERE activity_key='act-de-personal-form';

UPDATE activities
SET payload = JSON_SET(payload,'$.audioTextTargetFa','قیمت مجله ۷٫۶۰ یورو است.')
WHERE activity_key='act-de-price-listen';

COMMIT;
