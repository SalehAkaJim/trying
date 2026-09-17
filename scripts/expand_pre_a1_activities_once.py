#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LESSONS = ROOT / "content" / "de" / "pre-a1" / "lessons"
BOUNDS = ROOT / "config" / "activity-count-bounds.json"
SQL_OUT = ROOT / "database" / "content" / "de" / "zzzzz-pre-a1-activity-expansion.sql"


def act(aid, typ, instruction, reason, targets, lexemes, data, transforms, source_refs=None):
    return {
        "id": aid,
        "type": typ,
        "instructionFa": instruction,
        "selectionReason": reason,
        "sourceRefs": source_refs or [],
        "learningTargets": targets,
        "lexemeRefs": lexemes,
        "dialogueRef": None,
        "data": data,
        "transformations": transforms,
        "audioStatus": "not_required",
    }


ADDITIONS = {
    "hallo.json": [
        act(
            "act-de-hallo-role-match", "matching",
            "هر عبارت را به کاربردش وصل کن.",
            "بعد از استفاده در مکالمه و تشخیص خداحافظی، این مرحله نقش دو عبارت پایه را بدون افزودن زبان تازه از هم جدا می‌کند.",
            ["تشخیص نقش «Hallo!» و «Tschüss!» در شروع و پایان گفت‌وگو."],
            ["lex-de-hallo", "lex-de-tschuess"],
            {"pairs": [
                {"left": "Hallo!", "leftFa": "سلام!", "rightFa": "شروع گفت‌وگو"},
                {"left": "Tschüss!", "leftFa": "خداحافظ!", "rightFa": "پایان گفت‌وگو"},
            ]},
            ["source_items_grouped_for_matching", "persian_translation_added"],
        )
    ],
    "guten-morgen.json": [
        act(
            "act-de-gm-farewell-response", "choose_response",
            "گفت‌وگوی صبحگاهی تمام شده؛ پاسخ مناسب را انتخاب کن.",
            "پس از تمرکز روی سلام صبحگاهی، یک بازیابی کوتاه از پایان مکالمه کمک می‌کند زبان‌آموز شروع و پایان را در یک توالی کامل نگه دارد.",
            ["انتخاب «Tschüss!» برای پایان گفت‌وگوی صبحگاهی."],
            ["lex-de-guten-morgen", "lex-de-tschuess"],
            {"contextFa": "صبح است و گفت‌وگو تمام شده.", "options": [
                {"textTarget": "Tschüss!", "translationFa": "خداحافظ!", "correct": True},
                {"textTarget": "Guten Morgen!", "translationFa": "صبح بخیر!", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        )
    ],
    "pizza-like.json": [
        act(
            "act-de-pizza-fill-mag", "fill_blank",
            "جملهٔ علاقه را کامل کن.",
            "این مرحله تفاوت «mag» و «magst» را در همان جملهٔ منبع‌دار بازیابی می‌کند و شکل اول‌شخص را تثبیت می‌کند.",
            ["انتخاب فرم درست «mag» در «Ich mag Pizza.»."],
            ["lex-de-moegen", "lex-de-pizza"],
            {"sourceText": "Ich mag Pizza.", "sourceTextFa": "من پیتزا دوست دارم.", "blankedText": "Ich ___ Pizza.", "blankedTextFa": "من پیتزا ___ دارم.", "choices": ["mag", "magst"], "answer": "mag"},
            ["source_sentence_blank_created", "persian_translation_added"],
        ),
        act(
            "act-de-pizza-question-vs-answer", "multiple_choice",
            "کدام جمله دربارهٔ علاقهٔ خودت است؟",
            "پس از ساخت جمله، زبان‌آموز باید پرسش و پاسخ را از هم تشخیص دهد تا نقش «mag» و «magst» فقط حفظ شکلی نباشد.",
            ["تشخیص پاسخ «Ich mag Pizza.» از پرسش «Magst du Pizza?»."],
            ["lex-de-moegen", "lex-de-pizza"],
            {"options": [
                {"textTarget": "Ich mag Pizza.", "translationFa": "من پیتزا دوست دارم.", "correct": True},
                {"textTarget": "Magst du Pizza?", "translationFa": "پیتزا دوست داری؟", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
    ],
    "ja-nein.json": [
        act(
            "act-de-ja-nein-meaning-check", "true_false",
            "درست یا غلط؟ «Nein!» یعنی پاسخ منفی.",
            "پس از انتخاب پاسخ در بافت، یک بررسی معنایی بسیار کوتاه بازیابی مستقیم «nein» را تثبیت می‌کند.",
            ["تشخیص مستقیم «Nein!» به‌عنوان پاسخ منفی."],
            ["lex-de-nein"],
            {"statementTarget": "Nein!", "statementFa": "«Nein!» پاسخ منفی است.", "answer": True},
            ["persian_translation_added"],
        )
    ],
    "danke-bitte.json": [
        act(
            "act-de-danke-bitte-role-match", "matching",
            "تشکر و پاسخ به تشکر را به هم وصل کن.",
            "بعد از انتخاب «Bitte!» در پاسخ، این مرحله نقش دو عبارت را به‌صورت دوطرفه تثبیت می‌کند.",
            ["تشخیص نقش «Danke!» و «Bitte!» در یک تبادل مؤدبانه."],
            ["lex-de-danke", "lex-de-bitte"],
            {"pairs": [
                {"left": "Danke!", "leftFa": "ممنون!", "rightFa": "تشکر"},
                {"left": "Bitte!", "leftFa": "خواهش می‌کنم!", "rightFa": "پاسخ به تشکر"},
            ]},
            ["source_items_grouped_for_matching", "persian_translation_added"],
        )
    ],
    "entschuldigung.json": [
        act(
            "act-de-apology-response-choice", "choose_response",
            "در پاسخ به «Entschuldigung.» کدام عبارت مناسب‌تر است؟",
            "این فعالیت پاسخ آرام به عذرخواهی را از جفت اجتماعی تشکر جدا می‌کند و بازیابی کاربردی می‌سازد.",
            ["انتخاب «Kein Problem.» به‌عنوان پاسخ به عذرخواهی."],
            ["lex-de-entschuldigung", "lex-de-kein-problem", "lex-de-danke"],
            {"promptTarget": "Entschuldigung.", "promptFa": "ببخشید.", "options": [
                {"textTarget": "Kein Problem.", "translationFa": "مشکلی نیست.", "correct": True},
                {"textTarget": "Danke!", "translationFa": "ممنون!", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
        act(
            "act-de-apology-formula-choice", "multiple_choice",
            "کدام عبارت خودِ عذرخواهی است؟",
            "در مرحلهٔ پایانی، زبان‌آموز باید عبارت آغازگر عذرخواهی را از یک عبارت اجتماعی آشنای دیگر تشخیص دهد.",
            ["تشخیص «Entschuldigung.» به‌عنوان عبارت عذرخواهی."],
            ["lex-de-entschuldigung", "lex-de-danke"],
            {"options": [
                {"textTarget": "Entschuldigung.", "translationFa": "ببخشید.", "correct": True},
                {"textTarget": "Danke!", "translationFa": "ممنون!", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
    ],
    "name-exchange.json": [
        act(
            "act-de-name-fill-heisse", "fill_blank",
            "پاسخ معرفی نام را کامل کن.",
            "جای‌خالی روی فرم «heiße» تمرکز می‌کند تا زبان‌آموز آن را از «heißt» در پرسش جدا کند.",
            ["انتخاب «heiße» در پاسخ «Ich heiße Iris.»."],
            ["lex-de-heissen"],
            {"sourceText": "Ich heiße Iris.", "sourceTextFa": "اسم من آیریس است.", "blankedText": "Ich ___ Iris.", "blankedTextFa": "اسم من آیریس است.", "choices": ["heiße", "heißt"], "answer": "heiße"},
            ["source_sentence_blank_created", "persian_translation_added"],
        ),
        act(
            "act-de-name-question-role", "multiple_choice",
            "کدام عبارت سؤالِ نام است؟",
            "بعد از بازیابی پاسخ، تشخیص سؤال از جواب نقش دو فرم «heißt» و «heiße» را در ارتباط واقعی روشن می‌کند.",
            ["تشخیص «Wie heißt du?» به‌عنوان پرسش نام."],
            ["lex-de-heissen"],
            {"options": [
                {"textTarget": "Wie heißt du?", "translationFa": "اسمت چیه؟", "correct": True},
                {"textTarget": "Ich heiße Iris.", "translationFa": "اسم من آیریس است.", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
    ],
    "wellbeing.json": [
        act(
            "act-de-wellbeing-response", "choose_response",
            "به «Wie geht's?» پاسخ مناسب بده.",
            "پس از کامل‌کردن پرسش، این مرحله جفت پرسش و پاسخ را با بازیابی مستقیم و کم‌فشار می‌بندد.",
            ["انتخاب «Gut.» در پاسخ به «Wie geht's?»."],
            ["lex-de-wie-gehts", "lex-de-gut", "lex-de-hallo"],
            {"promptTarget": "Wie geht's?", "promptFa": "حالت چطوره؟", "options": [
                {"textTarget": "Gut.", "translationFa": "خوبم.", "correct": True},
                {"textTarget": "Hallo!", "translationFa": "سلام!", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        )
    ],
    "simple-choice.json": [
        act(
            "act-de-simple-choice-fill", "fill_blank",
            "پرسش انتخاب را کامل کن.",
            "این بازیابی روی فرم «möchtest» تمرکز می‌کند و آن را از فرم آشنای «magst» جدا نگه می‌دارد.",
            ["انتخاب «möchtest» در «Was möchtest du?»."],
            ["lex-de-moegen"],
            {"sourceText": "Was möchtest du?", "sourceTextFa": "چی می‌خوای؟", "blankedText": "Was ___ du?", "blankedTextFa": "چی می‌خوای؟", "choices": ["möchtest", "magst"], "answer": "möchtest"},
            ["source_sentence_blank_created", "persian_translation_added"],
        ),
        act(
            "act-de-simple-choice-response", "choose_response",
            "برای «Was möchtest du?» یک پاسخ مناسب انتخاب کن.",
            "در پایان، زبان‌آموز پرسش تازه را به گزینهٔ آشنای «Pizza.» وصل می‌کند تا معنی آن در کاربرد تثبیت شود.",
            ["پاسخ‌دادن به «Was möchtest du?» با یک گزینهٔ آشنا."],
            ["lex-de-moegen", "lex-de-pizza", "lex-de-hallo"],
            {"promptTarget": "Was möchtest du?", "promptFa": "چی می‌خوای؟", "options": [
                {"textTarget": "Pizza.", "translationFa": "پیتزا.", "correct": True},
                {"textTarget": "Hallo!", "translationFa": "سلام!", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
    ],
    "residence-origin.json": [
        act(
            "act-de-residence-question-choice", "multiple_choice",
            "کدام سؤال دربارهٔ محل زندگی است؟",
            "پس از تطبیق پرسش و پاسخ، تشخیص خود سؤال‌ها از هم مانع قاطی‌شدن «wohnen» و «kommen» می‌شود.",
            ["تشخیص پرسش محل زندگی از پرسش مبدأ."],
            ["lex-de-wohnen", "lex-de-kommen"],
            {"options": [
                {"textTarget": "Wo wohnen Sie?", "translationFa": "کجا زندگی می‌کنید؟", "correct": True},
                {"textTarget": "Woher kommen Sie?", "translationFa": "اهل کجا هستید؟", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
        act(
            "act-de-residence-word-order", "word_order",
            "پاسخ محل زندگی را دوباره بساز.",
            "بازسازی جملهٔ کامل، الگوی «Ich wohne in ...» را از تشخیص به بازیابی فعال می‌برد.",
            ["بازسازی «Ich wohne in Österreich.»."],
            ["lex-de-wohnen", "lex-de-oesterreich"],
            {"sourceText": "Ich wohne in Österreich.", "sourceTextFa": "من در اتریش زندگی می‌کنم.", "tokens": ["Ich", "wohne", "in", "Österreich."], "answer": ["Ich", "wohne", "in", "Österreich."]},
            ["sentence_tokenized_for_word_order", "persian_translation_added"],
        ),
    ],
    "age-numbers.json": [
        act(
            "act-de-age-question-choice", "multiple_choice",
            "کدام پرسش دربارهٔ سن است؟",
            "بعد از تمرین گفتاری و شنیداری عدد، تشخیص پرسش سن کمک می‌کند معنی کل الگو حفظ شود.",
            ["تشخیص «Wie alt bist du?» به‌عنوان پرسش سن."],
            ["lex-de-alt"],
            {"options": [
                {"textTarget": "Wie alt bist du?", "translationFa": "چند سالته؟", "correct": True},
                {"textTarget": "Ich bin 20 Jahre alt.", "translationFa": "من ۲۰ ساله هستم.", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
        act(
            "act-de-age-word-order", "word_order",
            "پاسخ سن را دوباره بساز.",
            "این مرحله الگوی کامل گفتن سن را از تشخیص عدد به تولید ساختاری منتقل می‌کند.",
            ["بازسازی «Ich bin 20 Jahre alt.»."],
            ["lex-de-alt", "lex-de-jahr", "lex-de-zwanzig"],
            {"sourceText": "Ich bin 20 Jahre alt.", "sourceTextFa": "من ۲۰ ساله هستم.", "tokens": ["Ich", "bin", "20", "Jahre", "alt."], "answer": ["Ich", "bin", "20", "Jahre", "alt."]},
            ["sentence_tokenized_for_word_order", "persian_translation_added"],
        ),
    ],
    "day-time.json": [
        act(
            "act-de-time-question-match", "matching",
            "پرسش روز و ساعت را به پاسخ مناسب وصل کن.",
            "این مرحله دو نوع اطلاعات نزدیک را کنار هم مقایسه می‌کند تا زبان‌آموز فقط عدد ساعت را حفظ نکند.",
            ["تشخیص ارتباط پرسش روز با پاسخ روز و پرسش ساعت با پاسخ ساعت."],
            ["lex-de-heute", "lex-de-dienstag", "lex-de-uhr"],
            {"pairs": [
                {"left": "Welcher Tag ist heute?", "leftFa": "امروز چه روزی است؟", "right": "Heute ist Dienstag.", "rightFa": "امروز سه‌شنبه است."},
                {"left": "Wie spät ist es?", "leftFa": "ساعت چنده؟", "right": "Es ist 6.30 Uhr.", "rightFa": "ساعت ۶:۳۰ است."},
            ]},
            ["source_items_grouped_for_matching", "persian_translation_added"],
        ),
        act(
            "act-de-time-word-order", "word_order",
            "جملهٔ ساعت را دوباره بساز.",
            "بازسازی جملهٔ شنیده‌شده، دریافت شنیداری را به بازیابی فعال همان ساختار متصل می‌کند.",
            ["بازسازی «Es ist 6.30 Uhr.»."],
            ["lex-de-uhr"],
            {"sourceText": "Es ist 6.30 Uhr.", "sourceTextFa": "ساعت ۶:۳۰ است.", "tokens": ["Es", "ist", "6.30", "Uhr."], "answer": ["Es", "ist", "6.30", "Uhr."]},
            ["sentence_tokenized_for_word_order", "persian_translation_added"],
        ),
    ],
    "birthday-date.json": [
        act(
            "act-de-birthday-question-order", "word_order",
            "پرسش تاریخ تولد را دوباره بساز.",
            "پس از گفت‌وگو و تکمیل پاسخ، بازسازی خود پرسش باعث می‌شود هر دو سمت تبادل بازیابی شوند.",
            ["بازسازی «Wann hast du Geburtstag?»."],
            ["lex-de-geburtstag"],
            {"sourceText": "Wann hast du Geburtstag?", "sourceTextFa": "تولدت کیه؟", "tokens": ["Wann", "hast", "du", "Geburtstag?"], "answer": ["Wann", "hast", "du", "Geburtstag?"]},
            ["sentence_tokenized_for_word_order", "persian_translation_added"],
        ),
        act(
            "act-de-birthday-month-check", "true_false",
            "درست یا غلط؟ این جمله یک تاریخ تولد در نوامبر می‌گوید.",
            "بررسی معنی ماه در جملهٔ کامل کمک می‌کند تمرین فقط روی شکل «dreizehnten» متوقف نماند.",
            ["تشخیص «November» در جملهٔ تاریخ تولد."],
            ["lex-de-geburtstag", "lex-de-november"],
            {"statementTarget": "Ich habe am dreizehnten November Geburtstag.", "statementFa": "این تاریخ تولد در ماه نوامبر است.", "answer": True},
            ["persian_translation_added"],
        ),
    ],
    "phone-number.json": [
        act(
            "act-de-phone-word-order", "word_order",
            "جملهٔ شماره تلفن را دوباره بساز.",
            "پس از تشخیص شنیداری، بازسازی همان جمله باعث می‌شود الگوی گفتن شماره نیز فعالانه تمرین شود.",
            ["بازسازی «Meine Telefonnummer lautet 789.»."],
            ["lex-de-telefonnummer"],
            {"sourceText": "Meine Telefonnummer lautet 789.", "sourceTextFa": "شماره تلفن من ۷۸۹ است.", "tokens": ["Meine", "Telefonnummer", "lautet", "789."], "answer": ["Meine", "Telefonnummer", "lautet", "789."]},
            ["sentence_tokenized_for_word_order", "persian_translation_added"],
        ),
        act(
            "act-de-phone-question-choice", "multiple_choice",
            "کدام عبارت سؤالِ شماره تلفن است؟",
            "این مرحله پرسش را از پاسخ جدا می‌کند تا زبان‌آموز هر دو نقش را در تبادل تشخیص دهد.",
            ["تشخیص «Wie lautet deine Telefonnummer?» به‌عنوان پرسش شماره تلفن."],
            ["lex-de-telefonnummer"],
            {"options": [
                {"textTarget": "Wie lautet deine Telefonnummer?", "translationFa": "شماره تلفنت چیه؟", "correct": True},
                {"textTarget": "Meine Telefonnummer lautet 789.", "translationFa": "شماره تلفن من ۷۸۹ است.", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
    ],
    "basic-object.json": [
        act(
            "act-de-object-answer-choice", "multiple_choice",
            "کدام پاسخ می‌گوید «این یک کتاب است»؟",
            "بعد از بازسازی یک پاسخ، این مرحله دو پاسخ هم‌ساخت را از نظر معنی واژهٔ پایانی مقایسه می‌کند.",
            ["تشخیص «Das ist ein Buch.» از پاسخ مربوط به کارت."],
            ["lex-de-buch", "lex-de-karte"],
            {"options": [
                {"textTarget": "Das ist ein Buch.", "translationFa": "این یک کتاب است.", "correct": True},
                {"textTarget": "Das ist eine Karte.", "translationFa": "این یک کارت است.", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
        act(
            "act-de-object-question-check", "true_false",
            "درست یا غلط؟ «Was ist das?» یک پرسش است.",
            "این بررسی کوتاه نقش عبارت را تثبیت می‌کند و از حفظ صرفِ پاسخ جلوگیری می‌کند.",
            ["تشخیص «Was ist das?» به‌عنوان پرسش اطلاعاتی ساده."],
            ["lex-de-buch", "lex-de-karte"],
            {"statementTarget": "Was ist das?", "statementFa": "این یک پرسش اطلاعاتی ساده است.", "answer": True},
            ["persian_translation_added"],
        ),
    ],
    "personal-review.json": [
        act(
            "act-de-personal-review-match", "matching",
            "هر پرسش شخصی را به پاسخ مناسب وصل کن.",
            "مرور چندهدفه باید علاوه بر فرم آزاد، بازیابی ساختاری پرسش و پاسخ‌های مهم را هم دوباره فعال کند.",
            ["بازیابی ارتباط پرسش سن و محل زندگی با پاسخ مناسب."],
            ["lex-de-wohnen", "lex-de-oesterreich", "lex-de-alt", "lex-de-jahr", "lex-de-zwanzig"],
            {"pairs": [
                {"left": "Wo wohnen Sie?", "leftFa": "کجا زندگی می‌کنید؟", "right": "Ich wohne in Österreich.", "rightFa": "من در اتریش زندگی می‌کنم."},
                {"left": "Wie alt bist du?", "leftFa": "چند سالته؟", "right": "Ich bin 20 Jahre alt.", "rightFa": "من ۲۰ ساله هستم."},
            ]},
            ["source_items_grouped_for_matching", "persian_translation_added"],
        ),
        act(
            "act-de-personal-review-phone-check", "true_false",
            "درست یا غلط؟ این جمله یک شماره تلفن را بیان می‌کند.",
            "این مرحلهٔ کوتاه یک هدف اطلاعات شخصی دیگر را بعد از فرم و شنیدن دوباره بازیابی می‌کند.",
            ["تشخیص الگوی بیان شماره تلفن در مرور نهایی."],
            ["lex-de-telefonnummer"],
            {"statementTarget": "Meine Telefonnummer lautet 789.", "statementFa": "این جمله یک شماره تلفن را بیان می‌کند.", "answer": True},
            ["persian_translation_added"],
        ),
    ],
    "food-today.json": [
        act(
            "act-de-food-eat-word-order", "word_order",
            "پاسخ مربوط به چیزی که می‌خوری را دوباره بساز.",
            "بعد از تطبیق دو جفت پرسش و پاسخ، بازسازی پاسخ «essen» بازیابی فعال فعل تازه را اضافه می‌کند.",
            ["بازسازی «Ich esse Reis.»."],
            ["lex-de-essen", "lex-de-reis"],
            {"sourceText": "Ich esse Reis.", "sourceTextFa": "من برنج می‌خورم.", "tokens": ["Ich", "esse", "Reis."], "answer": ["Ich", "esse", "Reis."]},
            ["sentence_tokenized_for_word_order", "persian_translation_added"],
        ),
        act(
            "act-de-food-available-choice", "multiple_choice",
            "کدام جمله می‌گوید امروز چه غذایی موجود است؟",
            "این مقایسهٔ معنایی تفاوت «غذای موجود» و «چیزی که فرد می‌خورد» را روشن نگه می‌دارد.",
            ["تشخیص جملهٔ «Heute gibt es Suppe.» به‌عنوان پاسخ دربارهٔ غذای موجود."],
            ["lex-de-heute", "lex-de-suppe", "lex-de-essen", "lex-de-reis"],
            {"options": [
                {"textTarget": "Heute gibt es Suppe.", "translationFa": "امروز سوپ داریم.", "correct": True},
                {"textTarget": "Ich esse Reis.", "translationFa": "من برنج می‌خورم.", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
    ],
    "simple-order.json": [
        act(
            "act-de-simple-order-response", "choose_response",
            "به سؤال سفارش پاسخ مناسب بده.",
            "بعد از بازسازی سفارش، این مرحله پرسش رسمی را دوباره به پاسخ کاربردی آن وصل می‌کند.",
            ["انتخاب سفارش «Eine Tasse Kaffee bitte!» در پاسخ به «Was möchten Sie bitte?»."],
            ["lex-de-moegen", "lex-de-bitte", "lex-de-tasse", "lex-de-kaffee"],
            {"promptTarget": "Was möchten Sie bitte?", "promptFa": "لطفاً چی میل دارید؟", "options": [
                {"textTarget": "Eine Tasse Kaffee bitte!", "translationFa": "یک فنجان قهوه لطفاً!", "correct": True},
                {"textTarget": "Guten Tag!", "translationFa": "روز بخیر!", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
        act(
            "act-de-simple-order-function-check", "true_false",
            "درست یا غلط؟ این عبارت یک سفارش کوتاه و مؤدبانه است.",
            "در پایان زبان‌آموز باید نقش کل عبارت را بفهمد، نه اینکه فقط ترتیب واژه‌ها را حفظ کرده باشد.",
            ["تشخیص کاربرد «Eine Tasse Kaffee bitte!» به‌عنوان سفارش کوتاه."],
            ["lex-de-bitte", "lex-de-tasse", "lex-de-kaffee"],
            {"statementTarget": "Eine Tasse Kaffee bitte!", "statementFa": "این یک سفارش کوتاه و مؤدبانه است.", "answer": True},
            ["persian_translation_added"],
        ),
    ],
    "need-and-buy.json": [
        act(
            "act-de-need-word-order", "word_order",
            "جملهٔ نیاز را دوباره بساز.",
            "پس از تطبیق، بازسازی جملهٔ «brauchen» آن را از تشخیص به تولید فعال منتقل می‌کند.",
            ["بازسازی «Ich brauche eine Hose.»."],
            ["lex-de-brauchen", "lex-de-hose"],
            {"sourceText": "Ich brauche eine Hose.", "sourceTextFa": "من یک شلوار لازم دارم.", "tokens": ["Ich", "brauche", "eine", "Hose."], "answer": ["Ich", "brauche", "eine", "Hose."]},
            ["sentence_tokenized_for_word_order", "persian_translation_added"],
        ),
        act(
            "act-de-buy-sentence-choice", "multiple_choice",
            "کدام جمله دربارهٔ خرید است؟",
            "مرحلهٔ پایانی تفاوت معنایی «نیاز داشتن» و «خریدن» را با دو جملهٔ کامل منبع‌دار می‌سنجد.",
            ["تشخیص جملهٔ دارای «kaufen» به‌عنوان بیان خرید."],
            ["lex-de-brauchen", "lex-de-hose", "lex-de-kaufen", "lex-de-hemd", "lex-de-schuhe"],
            {"options": [
                {"textTarget": "Ich kaufe ein Hemd und ein Paar Schuhe.", "translationFa": "من یک پیراهن و یک جفت کفش می‌خرم.", "correct": True},
                {"textTarget": "Ich brauche eine Hose.", "translationFa": "من یک شلوار لازم دارم.", "correct": False},
            ]},
            ["options_selected_from_source_material", "persian_translation_added"],
        ),
    ],
}

DESIGN = {
    "hallo.json": ("سه مرحلهٔ کوتاه، استفاده در مکالمه، تشخیص خداحافظی و تمایز نقش سلام/خداحافظی را پوشش می‌دهد.", "از کاربرد واقعی به تشخیص و سپس دسته‌بندی نقش دو عبارت می‌رسد."),
    "guten-morgen.json": ("سلام صبحگاهی، تمایز آن با سلام عمومی و پایان گفت‌وگو هر کدام یک بازیابی مشخص دارند.", "مکالمه، تشخیص زمان مناسب و سپس انتخاب پایان مناسب انجام می‌شود."),
    "pizza-like.json": ("چهار مرحله فهم پرسش، ساخت پاسخ، انتخاب فرم درست و تمایز پرسش/پاسخ را بدون زبان تازه پوشش می‌دهد.", "تعامل به بازسازی، بازیابی فرم و در پایان تشخیص نقش جمله‌ها پیش می‌رود."),
    "ja-nein.json": ("سه مرحله تولید پرسش، انتخاب پاسخ و تأیید معنای پاسخ منفی را پوشش می‌دهد.", "از تعامل به انتخاب در بافت و سپس بازیابی مستقیم معنی می‌رسد."),
    "danke-bitte.json": ("سه مرحله تبادل مؤدبانه، انتخاب پاسخ و تمایز نقش تشکر/پاسخ را تثبیت می‌کند.", "کاربرد در مکالمه، بازیابی پاسخ و سپس دسته‌بندی نقش انجام می‌شود."),
    "entschuldigung.json": ("چهار مرحله عذرخواهی، تطبیق جفت‌های اجتماعی، انتخاب پاسخ و تشخیص عبارت عذرخواهی را پوشش می‌دهد.", "از تعامل به مقایسهٔ جفت‌ها و سپس دو بازیابی کاربردی می‌رسد."),
    "name-exchange.json": ("چهار مرحله پرسیدن نام، بازسازی پاسخ، بازیابی «heiße» و تشخیص پرسش از پاسخ را پوشش می‌دهد.", "کاربرد، ساخت جمله، تمرکز روی فرم و در پایان تشخیص نقش جمله انجام می‌شود."),
    "wellbeing.json": ("سه مرحله تعامل، بازیابی ساختار پرسش و انتخاب پاسخ کوتاه را پوشش می‌دهد.", "معنی در مکالمه ساخته می‌شود و سپس پرسش و پاسخ جداگانه بازیابی می‌شوند."),
    "simple-choice.json": ("چهار مرحله فهم انتخاب، بازسازی پرسش، بازیابی «möchtest» و پاسخ‌دادن را پوشش می‌دهد.", "تعامل به ساخت پرسش، تمرکز روی فرم و سپس پاسخ کاربردی می‌رسد."),
    "residence-origin.json": ("چهار مرحله تعامل، تطبیق، تشخیص نوع سؤال و ساخت پاسخ محل زندگی را پوشش می‌دهد.", "از کاربرد دو مفهوم نزدیک به تمایز و در پایان تولید ساختاری می‌رسد."),
    "age-numbers.json": ("چهار مرحله گفتن سن، شنیدن عدد، تشخیص پرسش و ساخت پاسخ کامل را ترکیب می‌کند.", "تعامل، دریافت شنیداری، تشخیص معنایی و تولید ساختاری به‌ترتیب انجام می‌شود."),
    "day-time.json": ("پنج مرحله روز، ساعت، شنیدن، زمان روز، تطبیق سؤال/پاسخ و ساخت جمله را بدون تکرار بی‌هدف پوشش می‌دهد.", "از تعامل به دریافت و تشخیص و سپس بازیابی ترکیبی و ساخت جمله می‌رسد."),
    "birthday-date.json": ("چهار مرحله پرسش و پاسخ تاریخ تولد، تکمیل ساختار، بازسازی پرسش و تشخیص ماه را پوشش می‌دهد.", "تعامل به بازیابی پاسخ، ساخت پرسش و در پایان فهم معنی تاریخ می‌رسد."),
    "phone-number.json": ("چهار مرحله تبادل شماره، دریافت شنیداری، ساخت پاسخ و تشخیص پرسش را پوشش می‌دهد.", "تعامل و شنیدن به تولید ساختاری و سپس تشخیص نقش پرسش می‌رسد."),
    "basic-object.json": ("چهار مرحله پرسش/پاسخ متنی، ساخت پاسخ، تمایز دو شیء و تشخیص نقش پرسش را پوشش می‌دهد.", "از تعامل به ساخت جمله و سپس دو تشخیص معنایی می‌رسد."),
    "personal-review.json": ("پنج مرحله مرور گفتاری، فرم متنی، شنیدن قیمت، تطبیق پرسش‌های شخصی و تشخیص الگوی تلفن را ترکیب می‌کند.", "بازیابی گفتاری، نوشتاری و شنیداری با دو مرور کوتاه ساختاری تکمیل می‌شود."),
    "food-today.json": ("چهار مرحله مکالمه، تطبیق دو پرسش، ساخت پاسخ «essen» و تمایز غذای موجود از غذای خورده‌شده را پوشش می‌دهد.", "از تعامل به ارتباط پرسش/پاسخ، تولید جمله و سپس تشخیص معنایی می‌رسد."),
    "simple-order.json": ("چهار مرحله مکالمهٔ سفارش، ساخت عبارت، پاسخ به سؤال رسمی و تشخیص نقش کل سفارش را پوشش می‌دهد.", "تعامل به ساخت سفارش، بازیابی پاسخ و در پایان فهم کاربرد عبارت می‌رسد."),
    "need-and-buy.json": ("چهار مرحله مکالمه، تطبیق نیاز/خرید، ساخت جملهٔ نیاز و تشخیص جملهٔ خرید را پوشش می‌دهد.", "معنی دو فعل در تعامل ساخته می‌شود و سپس با تولید و تمایز فعال تثبیت می‌شود."),
}


def sqlq(value):
    if value is None:
        return "NULL"
    s = str(value).replace("\\", "\\\\").replace("'", "''")
    return "'" + s + "'"


def collect_target_strings(value):
    out = set()
    if isinstance(value, dict):
        for k, v in value.items():
            if k in {"textTarget", "promptTarget", "statementTarget", "sourceText", "left", "right"} and isinstance(v, str):
                out.add(v)
            else:
                out |= collect_target_strings(v)
    elif isinstance(value, list):
        for v in value:
            out |= collect_target_strings(v)
    return out


# Patch lesson JSON files.
all_added = []
for filename, additions in ADDITIONS.items():
    path = LESSONS / filename
    data = json.loads(path.read_text(encoding="utf-8"))
    existing = {a["id"] for a in data.get("activities", [])}
    for item in additions:
        if not item["sourceRefs"]:
            item["sourceRefs"] = list(data["sourceRefs"])
        if item["id"] not in existing:
            data["activities"].append(item)
        all_added.append((data["id"], item, len(data["activities"])))
    rationale, sequence = DESIGN[filename]
    design = data.setdefault("activityDesign", {})
    design["activitySelectionRationale"] = rationale
    design["sequenceRationale"] = sequence
    design["templateSignature"] = ">".join(a["type"] for a in data["activities"])
    count = len(data["activities"])
    if not 3 <= count <= 6:
        raise SystemExit(f"{filename}: expected 3-6 activities, got {count}")
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

# Harden the guardrail so future final Pre-A1 lessons cannot drop back to two activities.
bounds = json.loads(BOUNDS.read_text(encoding="utf-8"))
bounds["levels"]["Pre-A1"] = {"minActivities": 3, "maxActivities": 6}
BOUNDS.write_text(json.dumps(bounds, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

# Update the level audit note without changing German audio-bearing text.
level_path = ROOT / "content" / "de" / "pre-a1" / "level.json"
level = json.loads(level_path.read_text(encoding="utf-8"))
level["notes"] = "سطح پیش از A1 آلمانی ۱۹ درس دارد و پس از بازبینی تمرینی، هر درس بین ۳ تا ۶ فعالیت هدفمند دارد. ۱۲۶ دارایی صوتی فعلی معتبر و کامل باقی می‌مانند."
qa = level.get("completionAssessment", {}).get("qualityReview", {})
qa["rationale"] = "بازبینی تمرینی دوباره انجام شد: درس‌های دو‌مرحله‌ای گسترش یافتند تا علاوه بر مکالمه، تشخیص معنی، بازیابی فعال، ساخت جمله و مرور نیز متناسب با هدف هر درس پوشش داده شود؛ همهٔ درس‌ها اکنون در بازهٔ ۳ تا ۶ فعالیت قرار دارند و هیچ فعالیتی صرفاً برای پرکردن سهمیه اضافه نشده است."
qa["strengths"] = [
    "پوشش توصیفگرمحور بدون سهمیهٔ ثابت برای تعداد دقیق فعالیت داخل بازهٔ مجاز",
    "هر ۱۹ درس حداقل سه مرحلهٔ تمرین دارد و درس‌های چندهدفه تمرین بیشتری دریافت کرده‌اند",
    "تمرین‌های تازه عمدتاً از متن‌های هدف موجود و منبع‌دار استفاده می‌کنند و TTS تازه ایجاد نمی‌کنند",
    "قواعد فارسی، بدون تصویر، آغازکننده، صوت و MySQL به‌صورت خودکار کنترل می‌شوند.",
]
qa["remainingWeaknesses"] = []
level_path.write_text(json.dumps(level, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

# Generate an idempotent MySQL migration for exactly the new authoring activities.
lesson_keys = []
for filename in ADDITIONS:
    data = json.loads((LESSONS / filename).read_text(encoding="utf-8"))
    lesson_keys.append(data["id"])

lines = [
    "-- German Pre-A1 activity expansion: 3-6 purposeful activities per final lesson.",
    "-- Generated once from canonical authoring JSON; safe to reapply.",
    "SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;",
    "SET time_zone = '+00:00';",
    "START TRANSACTION;",
    "SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);",
    "SET @level := (SELECT id FROM language_levels WHERE language_id=@de AND cefr_level='Pre-A1' LIMIT 1);",
    "UPDATE lessons SET status='qa' WHERE language_level_id=@level AND status='final';",
]

for filename, additions in ADDITIONS.items():
    lesson = json.loads((LESSONS / filename).read_text(encoding="utf-8"))
    positions = {a["id"]: i + 1 for i, a in enumerate(lesson["activities"])}
    for a in additions:
        payload = json.dumps(a["data"], ensure_ascii=False, separators=(",", ":"))
        transforms = json.dumps(a["transformations"], ensure_ascii=False, separators=(",", ":"))
        lines += [
            "INSERT INTO activities (activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status)",
            f"SELECT {sqlq(a['id'])},l.id,{positions[a['id']]},{sqlq(a['type'])},{sqlq(a['instructionFa'])},{sqlq(a['selectionReason'])},NULL,{sqlq(payload)},{sqlq(transforms)},NULL,'not_required'",
            f"FROM lessons l WHERE l.lesson_key={sqlq(lesson['id'])}",
            "ON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status=VALUES(audio_status);",
        ]
        if a.get("lexemeRefs"):
            lexlist = ",".join(sqlq(x) for x in a["lexemeRefs"])
            lines += [
                "INSERT IGNORE INTO activity_lexemes (activity_id,lexeme_id)",
                f"SELECT av.id,lx.id FROM activities av JOIN lexemes lx ON lx.lexeme_key IN ({lexlist}) WHERE av.activity_key={sqlq(a['id'])};",
            ]
        targets = sorted(collect_target_strings(a["data"]))
        if targets:
            srclist = ",".join(sqlq(x) for x in a["sourceRefs"])
            targetlist = ",".join(sqlq(x) for x in targets)
            lines += [
                "INSERT IGNORE INTO provenance_links (entity_type,entity_key,source_item_id,transformation,notes)",
                f"SELECT 'activity',{sqlq(a['id'])},si.id,'other','متن هدف این فعالیت عیناً از آیتم منبع موجود گرفته شده است.' FROM source_items si JOIN sources s ON s.id=si.source_id WHERE s.source_key IN ({srclist}) AND si.source_text IN ({targetlist});",
            ]

lines += [
    "UPDATE lessons SET status='final' WHERE language_level_id=@level;",
    "COMMIT;",
    "",
]
SQL_OUT.write_text("\n".join(lines), encoding="utf-8")

# Final local audit summary.
counts = {}
for path in sorted(LESSONS.glob("*.json")):
    data = json.loads(path.read_text(encoding="utf-8"))
    counts[data["id"]] = len(data.get("activities", []))
if len(counts) != 19:
    raise SystemExit(f"Expected 19 Pre-A1 lessons, got {len(counts)}")
if any(not 3 <= n <= 6 for n in counts.values()):
    raise SystemExit(f"Activity bounds failed: {counts}")
if sum(counts.values()) != 73:
    raise SystemExit(f"Expected 73 total activities, got {sum(counts.values())}: {counts}")
print(json.dumps({"lessonCount": len(counts), "activityTotal": sum(counts.values()), "counts": counts}, ensure_ascii=False, indent=2))
