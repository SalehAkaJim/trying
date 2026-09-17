-- German Pre-A1 canonical character cast overlay.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;
SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);
INSERT INTO characters
(character_key,language_id,name,origin,gender,age_band,roles,relationship_tags,context_notes,voice_profile,elevenlabs_voice_id,voice_name) VALUES
('char-de-mia',@de,'Mia','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('classmate','friend'),'میا ۲۰ ساله است. تاریخ تولد او سیزدهم نوامبر و شمارهٔ تمرینی او 692-267-752 است.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','female'),NULL,NULL),
('char-de-max',@de,'Max','app_created','male','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('classmate'),'مکس ۱۸ ساله است. تاریخ تولد او ۱۶ ژوئیه و شمارهٔ تمرینی او 789 است. زبان‌آموز در چند صحنه نقش مکس را بازی می‌کند.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','male'),NULL,NULL),
('char-de-lena',@de,'Lena','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('friend','neighbor'),'لنا جوان، دوستانه و آرام است. زبان‌آموز در برخی صحنه‌های روزمره نقش لنا را بازی می‌کند.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','female'),NULL,NULL),
('char-de-jonas',@de,'Jonas','app_created','male','young_adult',JSON_ARRAY('conversation_partner','cafe_staff'),JSON_ARRAY('neighbor'),'یوناس جوان و خوش‌برخورد است و در یکی از موقعیت‌های انتخاب غذا نقش کارمند کافه را دارد.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','male'),NULL,NULL),
('char-de-iris',@de,'Iris','app_created','female','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('acquaintance'),'آیریس یک زن جوان است و در صحنه‌های آشنایی مؤدبانه حضور دارد. در محتوای فعلی می‌گوید اهل آلمان است.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','female'),NULL,NULL),
('char-de-paul',@de,'Paul Müller','app_created','male','young_adult',JSON_ARRAY('conversation_partner'),JSON_ARRAY('acquaintance'),'پاول مولر ۲۰ ساله است و در محتوای فعلی در اتریش زندگی می‌کند. زبان‌آموز در مرور اطلاعات شخصی نقش پاول را بازی می‌کند.',JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression','male'),NULL,NULL)
ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),name=VALUES(name),origin=VALUES(origin),gender=VALUES(gender),age_band=VALUES(age_band),roles=VALUES(roles),relationship_tags=VALUES(relationship_tags),context_notes=VALUES(context_notes),voice_profile=VALUES(voice_profile);
SET @mia:=(SELECT id FROM characters WHERE character_key='char-de-mia' LIMIT 1);
SET @max:=(SELECT id FROM characters WHERE character_key='char-de-max' LIMIT 1);
SET @lena:=(SELECT id FROM characters WHERE character_key='char-de-lena' LIMIT 1);
SET @jonas:=(SELECT id FROM characters WHERE character_key='char-de-jonas' LIMIT 1);
SET @iris:=(SELECT id FROM characters WHERE character_key='char-de-iris' LIMIT 1);
SET @paul:=(SELECT id FROM characters WHERE character_key='char-de-paul' LIMIT 1);
UPDATE dialogue_turns SET speaker_character_id=@iris WHERE turn_key IN ('turn-de-name-1','turn-de-name-4','turn-de-residence-1','turn-de-residence-4','turn-de-review-1','turn-de-review-3','turn-de-review-5','turn-de-review-7');
UPDATE dialogue_turns SET speaker_character_id=@jonas WHERE turn_key IN ('turn-de-choice-1','turn-de-choice-3','turn-de-danke-bitte-1','turn-de-danke-bitte-3','turn-de-gm-2','turn-de-gm-3','turn-de-name-2','turn-de-name-3','turn-de-time-1','turn-de-time-3');
UPDATE dialogue_turns SET speaker_character_id=@lena WHERE turn_key IN ('turn-de-danke-bitte-2','turn-de-danke-bitte-4','turn-de-gm-1','turn-de-gm-4','turn-de-object-1','turn-de-object-4','turn-de-wellbeing-2','turn-de-wellbeing-4');
UPDATE dialogue_turns SET speaker_character_id=@max WHERE turn_key IN ('turn-de-age-2','turn-de-age-3','turn-de-birthday-2','turn-de-birthday-3','turn-de-choice-2','turn-de-choice-4','turn-de-entschuldigung-1','turn-de-entschuldigung-3','turn-de-hallo-2','turn-de-hallo-4','turn-de-ja-1','turn-de-ja-3','turn-de-phone-2','turn-de-phone-3','turn-de-pizza-2','turn-de-pizza-4');
UPDATE dialogue_turns SET speaker_character_id=@mia WHERE turn_key IN ('turn-de-age-1','turn-de-age-4','turn-de-birthday-1','turn-de-birthday-4','turn-de-entschuldigung-2','turn-de-entschuldigung-4','turn-de-hallo-1','turn-de-hallo-3','turn-de-ja-2','turn-de-ja-4','turn-de-object-2','turn-de-object-3','turn-de-phone-1','turn-de-phone-4','turn-de-pizza-1','turn-de-pizza-3','turn-de-time-2','turn-de-time-4','turn-de-wellbeing-1','turn-de-wellbeing-3');
UPDATE dialogue_turns SET speaker_character_id=@paul WHERE turn_key IN ('turn-de-residence-2','turn-de-residence-3','turn-de-review-2','turn-de-review-4','turn-de-review-6','turn-de-review-8');
UPDATE dialogues SET scenario='میا و مکس با یک سلام ساده شروع می‌کنند و با یک خداحافظی کوتاه مکالمه را تمام می‌کنند.' WHERE dialogue_key='dlg-de-pre-a1-hallo';
UPDATE dialogues SET scenario='صبح است؛ لنا گفت‌وگو را با همسایه‌اش یوناس با یک سلام صبحگاهی شروع می‌کند و مکالمه با خداحافظی کوتاه تمام می‌شود.' WHERE dialogue_key='dlg-de-pre-a1-guten-morgen';
UPDATE dialogues SET scenario='میا و مکس سلام می‌کنند و بعد یک پرسش و پاسخ کوتاه دربارهٔ دوست‌داشتن پیتزا دارند.' WHERE dialogue_key='dlg-de-pre-a1-pizza-like';
UPDATE dialogues SET scenario='این بار مکس خودش سلام می‌کند و سؤال آشنای پیتزا را می‌پرسد؛ میا با یک پاسخ مثبت کوتاه جواب می‌دهد.' WHERE dialogue_key='dlg-de-pre-a1-ja';
UPDATE dialogues SET scenario='یوناس و لنا سلام می‌کنند؛ بعد از یک کمک کوچک یوناس تشکر می‌کند و لنا پاسخ مؤدبانه می‌دهد.' WHERE dialogue_key='dlg-de-pre-a1-danke-bitte';
UPDATE dialogues SET scenario='مکس برای یک اشتباه کوچک عذرخواهی می‌کند، میا پاسخ آرام می‌دهد و تعامل با تشکر و پاسخ مؤدبانه تمام می‌شود.' WHERE dialogue_key='dlg-de-pre-a1-entschuldigung';
UPDATE dialogues SET scenario='آیریس سلام می‌کند و یوناس پس از پاسخ، نام او را می‌پرسد و پاسخ سادهٔ «Ich heiße Iris.» را می‌شنود.' WHERE dialogue_key='dlg-de-pre-a1-name-exchange';
UPDATE dialogues SET scenario='میا و لنا سلام می‌کنند و میا یک احوال‌پرسی خیلی کوتاه می‌پرسد که لنا با یک پاسخ ساده جواب می‌دهد.' WHERE dialogue_key='dlg-de-pre-a1-wellbeing';
UPDATE dialogues SET scenario='مکس در یک کافه با یوناس سلام می‌کند؛ یوناس می‌پرسد چه می‌خواهد و مکس گزینهٔ آشنای «Pizza.» را انتخاب می‌کند.' WHERE dialogue_key='dlg-de-pre-a1-simple-choice';
UPDATE dialogues SET scenario='آیریس و پاول در یک آشنایی مؤدبانه دربارهٔ محل زندگی و مبدأ سؤال و جواب می‌کنند.' WHERE dialogue_key='dlg-de-pre-a1-residence-origin';
UPDATE dialogues SET scenario='میا و مکس سن هم را می‌پرسند؛ مکس ۱۸ ساله و میا ۲۰ ساله است.' WHERE dialogue_key='dlg-de-pre-a1-age-numbers';
UPDATE dialogues SET scenario='میا و مکس تاریخ تولد را از هم می‌پرسند؛ تاریخ‌های این صحنه به اطلاعات ثابت همین دو شخصیت تبدیل شده‌اند.' WHERE dialogue_key='dlg-de-pre-a1-birthday-date';
UPDATE dialogues SET scenario='میا و مکس شمارهٔ تلفن تمرینی را از هم می‌پرسند و دو شمارهٔ منبع‌دار می‌گویند.' WHERE dialogue_key='dlg-de-pre-a1-phone-number';
UPDATE dialogues SET scenario='یوناس دربارهٔ روز و ساعت فعلی سؤال می‌کند و میا با اطلاعات ساده پاسخ می‌دهد.' WHERE dialogue_key='dlg-de-pre-a1-day-time';
UPDATE dialogues SET scenario='لنا و میا دربارهٔ دو شیء نام‌برده‌شده سؤال بسیار ساده می‌پرسند؛ حل فعالیت به تصویر وابسته نیست.' WHERE dialogue_key='dlg-de-pre-a1-basic-object';
UPDATE dialogues SET scenario='آیریس در یک آشنایی مؤدبانه با پاول مولر چند بخش اصلی اطلاعات شخصی او را در هشت نوبت مرور می‌کند.' WHERE dialogue_key='dlg-de-pre-a1-personal-review';
DELETE FROM characters WHERE language_id=@de AND character_key='char-de-learner';
COMMIT;
