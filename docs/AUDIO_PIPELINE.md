# فرایند Audio

## دامنه
Audio بعد از نهایی‌شدن هر سطح CEFR ساخته می‌شود، نه بعد از پایان کل زبان. نهایی‌شدن سطح، متن هدف و انتساب شخصیت/صدا را برای همان سطح ثابت می‌کند.

## هویت پایدار
Audio هرگز با شناسهٔ عددی دیتابیس متصل نمی‌شود. اتصال فقط با `turn_key`، `lexeme_key`، `activity_key` یا `example_key` انجام می‌شود.

## Manifest تولید
View با نام `v_audio_generation_manifest` زبان، سطح، نوع و کلید مالک، متن دقیق، SHA-256، صدای مورد انتظار، metadata فعلی Audio و معتبربودن فایل فعلی را برمی‌گرداند. تولید فقط برای سطح `final` مجاز است.

## Metadata ذخیره‌شده
برای هر Audio وضعیت، URL عمومی، مسیر ذخیره‌سازی، SHA-256 متن دقیق، provider، model ID، نام/شناسهٔ صدا و زمان تولید ذخیره می‌شود.

## مسیر قطعی فایل
`audio/<language>/<level>/<owner_type>/<owner_key>.mp3`

URL عمومی فعلاً از Raw GitHub ساخته می‌شود؛ `audio_storage_path` هویت فایل را مستقل از provider نگه می‌دارد.

## اتصال دیتابیس
Mappingهای تولیدشده جداگانه در `database/audio/<language>/<level>.sql` ذخیره می‌شوند. SQL با stable key رکورد را پیدا می‌کند و قبل از `ready` شدن، hash متن را هم تطبیق می‌دهد. SQL پایهٔ محتوا حق overwrite کردن metadata تولیدشدهٔ Audio را ندارد.

## قفل صدا
اولین اجرای `resolve-voices` فایل `config/audio-voice-locks/<language>.json` را می‌سازد. صدای واژه‌ها/عبارت‌های مستقل از اولویت‌های `audioPolicy.standaloneVoicePreference` انتخاب می‌شود؛ نقش زبان‌آموز همان صدا را به ارث می‌برد و شخصیت‌های گفت‌وگویی دیگر صدای متمایز متناسب با `voiceProfile` می‌گیرند. شناسه‌های واقعی provider بعد از resolve قفل می‌شوند تا اجرای بعدی به تغییرات فهرست صداها وابسته نباشد. Mapping صداها در `database/audio/<language>/voices.sql` نگه‌داری می‌شود.

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
3. اگر voice lock وجود ندارد، `resolve-voices` اجرا می‌شود.
4. plan باید هیچ Voice حل‌نشده‌ای نداشته باشد.
5. کاربر باید تولید پولی را صریحاً تأیید کند.
6. MP3ها در مسیر deterministic تولید می‌شوند.
7. `manifest.json` و SQL mapping ساخته می‌شوند.
8. فایل‌ها و hashها validate می‌شوند.
9. کل schema/content/audio روی MySQL 9.0.1 دوباره import و validate می‌شود.
10. فقط در صورت موفقیت همهٔ مراحل، فایل‌ها commit می‌شوند.

## کهنه‌شدن Audio
اگر متن قابل‌خواندن یا speaker/voice تغییر کند، MySQL metadata Audio قبلی را invalid می‌کند. اجرای بعدی plan آن مورد را دوباره برای generation علامت می‌زند.

## وضعیت انتشار
یک سطح نهایی می‌تواند از `pending` به `ready` برسد. سطح فقط وقتی Audio-ready است که تمام ردیف‌های موردنیاز manifest معتبر و current باشند.
