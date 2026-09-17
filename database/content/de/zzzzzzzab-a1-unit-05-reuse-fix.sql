-- German A1 Unit 5 reuses the frozen Pre-A1 price lexeme and its attested form.
-- Keep canonical level metadata unchanged after the A1 shopping migration; never touch audio state.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
START TRANSACTION;
UPDATE lexemes
SET cefr_level='Pre-A1',
    translation_fa='قیمت داشتن / هزینه داشتن',
    usage_note_fa='در این سطح فقط برای پرسیدن و گفتن قیمت یک چیز در جمله‌های خیلی کوتاه استفاده می‌شود.'
WHERE lexeme_key='lex-de-kosten';
UPDATE lexeme_forms
SET notes='در پرسش‌ها و پاسخ‌های قیمت منبع، «kostet» به‌صورت سوم‌شخص مفرد حال استفاده شده است.'
WHERE lexeme_form_key='lexform-de-kosten-kostet';
COMMIT;
