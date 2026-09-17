# فرایند Audio

## دامنه
Audio بعد از نهایی‌شدن هر سطح CEFR ساخته می‌شود، نه بعد از پایان کل زبان. نهایی‌شدن سطح، متن هدف و انتساب شخصیت/صدا را برای همان سطح ثابت می‌کند.

## هویت پایدار
Audio هرگز با شناسهٔ عددی دیتابیس متصل نمی‌شود. اتصال فقط با `turn_key`، `lexeme_key`، `activity_key` یا `example_key` انجام می‌شود.

برای Audio مکالمه، زنجیرهٔ هویت باید قابل ردیابی باشد:

`audio asset -> character key -> provider voice ID`

`character key` هویت پایدار شخصیت است و Voice ID قابل تعویض است. بنابراین تغییر صدای یک شخصیت نباید نیازمند پیدا کردن دستی فایل‌های مربوط به او باشد.

## نقش زبان‌آموز
`learnerTurn=true` فقط مشخص می‌کند کاربر آن turn را در اپ اجرا می‌کند؛ این flag یک شخصیت یا صدای مستقل ایجاد نمی‌کند.

زبان‌آموز در هر مکالمه نقش یکی از شخصیت‌های واقعی همان صحنه را بازی می‌کند. اگر برای learner turn نمونهٔ صوتی تولید شود، باید با صدای همان شخصیت ساخته شود. هیچ Voice ثابت و عمومی برای تمام learner turnها وجود ندارد.

Voice مستقل زبان برای واژه‌ها، عبارت‌ها و تلفظ‌های standalone است و نباید به‌عنوان Voice عمومی learner در Dialogue استفاده شود.

## Manifest تولید
View با نام `v_audio_generation_manifest` زبان، سطح، نوع و کلید مالک، متن دقیق، SHA-256، صدای مورد انتظار، metadata فعلی Audio و معتبربودن فایل فعلی را برمی‌گرداند. تولید فقط برای سطح `final` مجاز است.

Pipeline برای Dialogue علاوه بر owner key، `voiceAssignmentKey` را نگه می‌دارد که همان Character Key شخصیت گوینده است. به این ترتیب تمام Audioهای متعلق به یک شخصیت مستقیماً قابل شناسایی‌اند.

## Metadata ذخیره‌شده
برای هر Audio وضعیت، URL عمومی، مسیر ذخیره‌سازی، SHA-256 متن دقیق، provider، model ID، نام/شناسهٔ صدا و زمان تولید ذخیره می‌شود.

برای Dialogue، metadata تولید باید امکان اتصال دوباره به Character Key و Voice ID استفاده‌شده را فراهم کند.

## مسیر قطعی فایل
`audio/<language>/<level>/<owner_type>/<owner_key>.mp3`

URL عمومی فعلاً از Raw GitHub ساخته می‌شود؛ `audio_storage_path` هویت فایل را مستقل از provider نگه می‌دارد.

## اتصال دیتابیس
Mappingهای تولیدشده جداگانه در `database/audio/<language>/<level>.sql` ذخیره می‌شوند. SQL با stable key رکورد را پیدا می‌کند و قبل از `ready` شدن، hash متن را هم تطبیق می‌دهد. SQL پایهٔ محتوا حق overwrite کردن metadata تولیدشدهٔ Audio را ندارد.

Dialogue turn از طریق `speaker_character_id` به شخصیت متصل است و شخصیت Voice ID تولید فعلی خود را نگه می‌دارد. View تولید Audio، Voice مورد انتظار شخصیت را با `audio_voice_id` فایل موجود مقایسه می‌کند. اگر Voice binding شخصیت عوض شود، Audioهای ساخته‌شده با Voice قبلی دیگر current محسوب نمی‌شوند و باید regenerate شوند.

## قفل صدا
اولین اجرای `resolve-voices` فایل `config/audio-voice-locks/<language>.json` را می‌سازد.

این فایل نگاشت canonical بین Character Key و Voice واقعی provider را نگه می‌دارد. برای هر شخصیت مکالمه‌ای باید Voice مستقل و متناسب با `voiceProfile`، جنسیت، سن، نقش و موقعیت انتخاب شود.

شناسه‌های واقعی provider بعد از resolve قفل می‌شوند تا اجرای بعدی به تغییرات فهرست صداها وابسته نباشد. Mapping صداها در `database/audio/<language>/voices.sql` نگه‌داری می‌شود.

اگر کاربر یک Voice را رد کند، Voice binding همان Character تغییر می‌کند. سپس تمام Dialogue Audioهای متعلق به آن Character که با Voice قبلی ساخته شده‌اند stale محسوب می‌شوند و اجرای `generate` آن‌ها را دوباره می‌سازد. Audio سایر شخصیت‌ها قابل reuse است، مگر اینکه کاربر صریحاً بازتولید کامل سطح را بخواهد.

نمونه: اگر Voice شخصیت `char-de-max` عوض شود، باید تمام turnهایی که `voiceAssignmentKey=char-de-max` دارند با Voice جدید ساخته شوند.

## اجرای GitHub Actions
Workflow با نام `Curriculum Audio Pipeline` فقط به‌صورت دستی اجرا می‌شود و چهار عملیات دارد:

- `plan`: بدون API key، فهرست تمام Audioهای لازم و وضعیت فعلی را می‌سازد.
- `resolve-voices`: فقط Voice IDهای واقعی ElevenLabs را resolve و lock می‌کند و هیچ TTS پولی تولید نمی‌کند.
- `generate`: Audioهای لازم را تولید می‌کند، MP3 و manifest و SQL mapping را می‌سازد و روی MySQL 9.0.1 اعتبارسنجی می‌کند.
- `validate-assets`: فایل‌های موجود، hashها و mapping را دوباره بررسی می‌کند.

Secret استاندارد GitHub Actions برای ElevenLabs دقیقاً `ELEVENLABS_API_KEY` است. هیچ secret یا API key نباید داخل repository، voice lock، manifest یا SQL ذخیره شود.

## محافظت هزینه
عملیات `generate` فقط با input صریح `confirm_paid_generation=true` اجرا می‌شود. نبود این تأیید باید job را قبل از درخواست TTS متوقف کند. `plan` و validation هیچ درخواست پولی ندارند؛ `resolve-voices` فقط metadata صداها را از ElevenLabs می‌خواند.

## مدل و API فعلی
تنظیم canonical در `config/audio-pipeline.json` نگه‌داری می‌شود. مدل فعلی `eleven_multilingual_v2` و فرمت `mp3_44100_128` است. endpointهای provider داخل `scripts/audio_pipeline.py` متمرکز هستند تا در صورت تغییر API فقط یک لایه اصلاح شود.

## ترتیب اجرای تولید
1. سطح باید `final` باشد.
2. MySQL canonical ساخته و `v_audio_generation_manifest` خوانده می‌شود.
3. Character assignment هر Dialogue turn، از جمله learner turnها، باید نهایی و سازگار باشد.
4. اگر voice lock وجود ندارد، `resolve-voices` اجرا می‌شود.
5. plan باید هیچ Voice حل‌نشده‌ای نداشته باشد.
6. کاربر باید تولید پولی را صریحاً تأیید کند.
7. MP3ها در مسیر deterministic تولید می‌شوند.
8. `manifest.json` و SQL mapping ساخته می‌شوند.
9. فایل‌ها و hashها validate می‌شوند.
10. کل schema/content/audio روی MySQL 9.0.1 دوباره import و validate می‌شود.
11. فقط در صورت موفقیت همهٔ مراحل، فایل‌ها commit می‌شوند.

## کهنه‌شدن Audio
اگر متن قابل‌خواندن، Character assignment یا Voice binding تغییر کند، Audio قبلی دیگر معتبر نیست.

برای Dialogue، عوض‌شدن Voice ID یک Character باعث می‌شود تمام Audioهای قبلی همان Character که Voice ID قدیمی دارند current نباشند. Pipeline باید آن‌ها را regenerate کند و فایل‌های deterministic قبلی را با نسخهٔ جدید جایگزین کند.

اگر کاربر صریحاً درخواست بازتولید کامل یک شخصیت یا کل سطح را بدهد، حتی assetهای قابل reuse نیز می‌توانند از صفر ساخته شوند.

## وضعیت انتشار
یک سطح نهایی می‌تواند از `pending` به `ready` برسد. سطح فقط وقتی Audio-ready است که تمام ردیف‌های موردنیاز manifest معتبر و current باشند.
