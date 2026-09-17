# قفل صدای Audio

این پوشه فقط قفل‌های provider-specific صدا را نگه می‌دارد. هر فایل زبان مثل `de.json` بعد از resolve شدن صداهای واقعی ElevenLabs ساخته می‌شود و شناسهٔ Voice را ثابت نگه می‌دارد تا اجرای بعدی به تغییرات فهرست صداهای provider وابسته نباشد.

- صدای standalone از ترتیب `audioPolicy.standaloneVoicePreference` در manifest همان زبان resolve می‌شود.
- نقش `learner` همان صدای standalone را به ارث می‌برد.
- شخصیت‌های گفت‌وگویی دیگر بر اساس `voiceProfile` و زبان هدف یک صدای متمایز می‌گیرند.
- بعد از ساخته‌شدن lock، generation فقط از همان Voice ID استفاده می‌کند مگر اینکه lock عمداً حذف یا بازسازی شود.
- این فایل‌ها هیچ API key یا secret نگه نمی‌دارند.
