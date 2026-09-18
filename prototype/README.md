# NOVA Content Prototype

این پوشه یک پروتوتایپ محلی برای دیدن و گذراندن محتوای فعلی `content/` است.

## اجرا

از ریشهٔ repository فقط این دستور را اجرا کنید:

```bash
python prototype/run.py
```

مرورگر به‌صورت خودکار روی `http://127.0.0.1:8765/` باز می‌شود.

هیچ package یا dependency خارجی لازم نیست؛ Python 3 کافی است.

برای اجرا بدون باز شدن خودکار مرورگر:

```bash
python prototype/run.py --no-browser
```

برای پورت دیگر:

```bash
python prototype/run.py --port 9000
```

## رفتار پروتوتایپ

- زبان‌ها، levelها، unitها، lessonها و activityها در زمان اجرا از `content/` خوانده می‌شوند.
- تعداد lesson یا activity هیچ مقدار ثابت و hard-coded ندارد.
- `level.lessonRefs` مرجع اصلی ترتیب درس‌هاست؛ درس‌ها بر اساس `unitRef` گروه‌بندی می‌شوند و هیچ درس referenced شده‌ای بی‌صدا حذف نمی‌شود.
- در صفحهٔ مسیر یادگیری برای هر level یک Unit dropdown وجود دارد؛ می‌توان همهٔ یونیت‌ها یا فقط یک یونیت را نمایش داد.
- برای تمام activity typeهای فعلی schema renderer تعاملی وجود دارد: `conversation_speaking`، `listen_choose`، `multiple_choice`، `choose_response`، `word_order`، `fill_blank`، `matching`، `listen_repeat`، `pronunciation_read`، `grammar_focus`، `comprehension`، `true_false` و `review`.
- فایل‌های صوتی واقعی از `audio/<language>/<level>/manifest.json` resolve می‌شوند. اگر فایل روی دیسک موجود باشد، prototype همان MP3 تولیدشده را از مسیر `/audio/...` پخش می‌کند.
- audioهای activity، تک‌تک dialogue turnها و lexemeها به UI وصل شده‌اند. جمله‌های مکالمه و واژه‌های داخل modal دکمهٔ پخش مستقل دارند.
- Web Speech Synthesis فقط fallback است و زمانی استفاده می‌شود که فایل اصلی صوتی در دسترس نباشد یا مرورگر نتواند آن را باز کند.
- در تمرین‌های speaking/pronunciation، مرورگرهای سازگار می‌توانند از Web Speech Recognition برای مقایسهٔ تقریبی گفتار با متن هدف استفاده کنند؛ نبودن این قابلیت مانع ادامهٔ درس نمی‌شود.
- در UI تا جای ممکن داده‌های فارسی مثل `instructionFa`، `contextFa`، `promptFa`، `textFa` و `explanationFa` در اولویت نمایش هستند و متن زبان هدف برای خود تمرین حفظ می‌شود.
- واژه‌ها، عبارت‌ها و formهای موجود در lexeme data داخل متن قابل کلیک هستند و توضیحات در modal نمایش داده می‌شود.
- activity نوع `review` می‌تواند فرم‌های متنی داینامیک را از `data.fields` بسازد و داده‌های واردشده را به سرور ارسال نمی‌کند.
- پیشرفت فقط در `localStorage` همان مرورگر ذخیره می‌شود و روی محتوای repository چیزی نمی‌نویسد.
- اگر در آینده activity type جدیدی به schema اضافه شود، prototype آن را حذف نمی‌کند و تا زمان اضافه‌شدن renderer اختصاصی یک fallback review screen نشان می‌دهد.
