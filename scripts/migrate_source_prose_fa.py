#!/usr/bin/env python3
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]

COPY = {
    "src-wiktionary-de-hallo": (
        "مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.",
        "منبع عبارت سلام «hallo»."
    ),
    "src-wiktionary-de-guten-morgen": (
        "مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.",
        "منبع عبارت «guten Morgen»."
    ),
    "src-wiktionary-de-moegen": (
        "مدخل زنده و فعال Wiktionary برای هویت واژگانی و شکل‌های صرفی معاصر بررسی شده است.",
        "منبع «mögen» و شکل‌های «mag / magst»."
    ),
    "src-wiktionary-de-pizza": (
        "مدخل زنده و فعال Wiktionary آلمانی در وضعیت فعلی بررسی شده است.",
        "منبع اسم «Pizza»."
    ),
    "src-libra-de-ich-mag-pizza": (
        "منبع رسمی آموزشی ایالت Brandenburg از سال ۲۰۲۵ است و برای کاربرد آموزشی معاصر بررسی شده است.",
        "منبع رسمی جملهٔ دقیق «Ich mag Pizza.»."
    ),
    "src-wikibooks-de-magst-du-pizza": (
        "صفحهٔ زندهٔ Wikibooks در وضعیت فعلی بررسی شده است و مثال مورد استفاده با کاربرد معاصر آلمانی سازگار است.",
        "منبع پرسش «Magst du Pizza?»."
    ),
    "src-wiktionary-de-ja": (
        "مدخل زنده و فعال Wiktionary برای پاسخ مثبت معاصر بررسی شده است.",
        "منبع پاسخ مثبت «ja»."
    ),
    "src-wiktionary-de-nein": (
        "مدخل زنده و فعال Wiktionary برای پاسخ منفی معاصر بررسی شده است.",
        "منبع پاسخ منفی «nein»."
    ),
    "src-wiktionary-de-danke": (
        "مدخل زنده و فعال Wiktionary برای عبارت تشکر معاصر بررسی شده است.",
        "منبع عبارت تشکر «danke»."
    ),
    "src-wiktionary-de-bitte": (
        "مدخل زنده و فعال Wiktionary در وضعیت فعلی بررسی شده و فقط کاربرد مستند پاسخ به تشکر استفاده می‌شود.",
        "در این سطح فقط کاربرد «Bitte!» در پاسخ به تشکر استفاده می‌شود."
    ),
    "src-wikibooks-de-basic-greetings": (
        "صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده و عبارت‌های استفاده‌شده با آلمانی معاصر سازگارند.",
        "برای «Wie geht's?»، «Gut.» و «Tschüss!» استفاده می‌شود."
    ),
    "src-wiktionary-de-entschuldigung": (
        "مدخل زنده و نگهداری‌شدهٔ Wiktionary آلمانی در وضعیت فعلی بررسی شده است.",
        "منبع «Entschuldigung»."
    ),
    "src-wiktionary-de-kein-problem": (
        "مدخل در سال ۲۰۲۶ به‌روز شده و عبارت امروزی «kein Problem» را مستقیم ثبت می‌کند.",
        "منبع «kein Problem»."
    ),
    "src-wikibooks-de-wie-heisst-du": (
        "صفحهٔ زنده و نگهداری‌شدهٔ Wikibooks در وضعیت فعلی بررسی شده و برای الگوی سادهٔ پرسیدن و گفتن نام استفاده می‌شود.",
        "منبع «Wie heißt du?» و «Ich heiße Iris.»."
    ),
    "src-wiktionary-de-heissen": (
        "مدخل زنده و نگهداری‌شدهٔ Wiktionary آلمانی و شکل‌های حال آن در وضعیت فعلی بررسی شده است.",
        "منبع «heißen» و شکل‌های «heiße / heißt»."
    )
}

changed = 0
seen = set()
for path in sorted((ROOT / "content").glob("*/sources/*.json")):
    data = json.loads(path.read_text(encoding="utf-8"))
    source_id = data.get("id")
    if source_id not in COPY:
        raise SystemExit(f"{path}: no Persian migration copy registered for {source_id!r}")
    evidence, notes = COPY[source_id]
    seen.add(source_id)
    if data.get("currencyEvidence") != evidence or data.get("notes") != notes:
        data["currencyEvidence"] = evidence
        data["notes"] = notes
        path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        changed += 1

missing = set(COPY) - seen
if missing:
    raise SystemExit(f"Registered source IDs without files: {sorted(missing)}")

print(f"Migrated Persian source prose in {changed} source files.")
