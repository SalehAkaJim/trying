# قرارداد فارسی‌سازی فرانت‌اند

## قانون اصلی
هر مقداری که قرار است به کاربر فارسی‌زبان نمایش داده شود باید معادل فارسی صریح و canonical داشته باشد.

کدهای فنی مانند `farewell_formula`، `greeting_formula`، `inflected`، `response_particle`، `interjection_response_particle` و `adverb_response_particle` فقط برای پایداری API، دیتابیس و منطق داخلی هستند و نمایش مستقیم آن‌ها در UI ممنوع است.

## منبع canonical
معادل‌های فارسی semantic/taxonomy codeها در `config/fa-taxonomy.json` نگه‌داری می‌شوند و در MySQL داخل `taxonomy_labels` sync می‌شوند.

اگر یک code در فرانت نمایش داده می‌شود، UI باید یکی از این دو مسیر را استفاده کند:

1. companion فارسی همان payload مثل `partOfSpeechFa` یا `formTypeFa`؛ یا
2. lookup قطعی `domain_code + value_code -> label_fa` از taxonomy.

Fallback به خود code انگلیسی مجاز نیست. نبود label فارسی باید خطای داده/قرارداد محسوب شود، نه حالتی برای نمایش code خام.

## Lexicon
برای داده‌های واژگان، runtime viewهای زیر برای مصرف فرانت تعریف شده‌اند:

- `v_frontend_lexemes`
- `v_frontend_lexeme_forms`
- `v_frontend_lexeme_form_features`

این viewها code فنی و label فارسی متناظر را کنار هم ارائه می‌کنند. فرانت برای label باید ستون `*_fa` را نمایش دهد.

## Authoring
در authoring JSON:

- `partOfSpeech` باید `partOfSpeechFa` داشته باشد.
- `formType` باید `formTypeFa` داشته باشد.
- `features` باید `featuresFa` داشته باشد.
- `origin` باید `originFa` داشته باشد.
- `reviewStatus` باید `reviewStatusFa` داشته باشد.

`scripts/sync_fa_labels.py` این مقادیر را از taxonomy canonical کنترل می‌کند و CI در صورت missing یا mismatch شدن آن‌ها fail می‌شود.

## اصل توسعهٔ آینده
هر semantic code جدیدی که احتمال نمایش در UI دارد، قبل از merge باید:

- در `config/fa-taxonomy.json` label فارسی داشته باشد؛
- در payload learner-facing companion فارسی یا lookup مشخص داشته باشد؛
- تحت validation خودکار قرار بگیرد.

اضافه‌کردن code بدون مسیر فارسی learner-facing ناقض قرارداد پروژه است.
