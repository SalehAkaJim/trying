# Project Rules Index

This file is the required entry point before creating, modifying, reviewing, exporting, or automating educational content.

## Source of truth
The current `main` branch of this repository is the canonical project memory and contract source. Chat history or model memory is secondary. If a rule was explicitly changed and committed here, the committed rule wins for future work.

## Mandatory read order
Before starting a new language, a new CEFR level, or a substantial content batch, read and apply these files in order:

1. `docs/PROJECT_DECISIONS.md`
2. `docs/LOCALIZATION_POLICY.md`
3. `docs/DYNAMIC_CONTENT_MODEL.md`
4. `docs/CONTENT_RULES.md`
5. `docs/SOURCE_POLICY.md`
6. `docs/CEFR_MAPPING.md`
7. `docs/ACTIVITY_TYPES.md`
8. `docs/CHARACTER_RULES.md`
9. `docs/DATABASE_DESIGN.md`
10. `docs/QA_RULES.md`
11. `docs/AUTOMATION_CONTRACT.md`
12. `config/fa-taxonomy.json`
13. relevant JSON Schemas under `schemas/`

## Rule-change protocol
Whenever the user makes a durable product/content decision:
1. update the relevant canonical doc(s) in the same work session;
2. update machine-readable contracts/schema/taxonomy when applicable;
3. add or update an automated regression test when the rule is testable;
4. update existing content if the new rule makes current content invalid;
5. run MySQL 9.0.1 and authoring QA before considering the change complete.

Do not rely on remembering a decision only from chat.

## New-language gate
A new language must not begin content production until the automation/contract validator passes for the repository baseline. The new language then inherits every cross-language rule automatically.

Language-specific exceptions must be explicit, documented, scoped, and tested. They must not silently weaken global rules.

## Conflict handling
If two documents appear to conflict, apply the more specific newer explicit decision and immediately reconcile the docs so the repository returns to a single unambiguous rule set.
- `docs/AUDIO_PIPELINE.md` — قرارداد تولید، اتصال، اعتبارسنجی و بازتولید فایل‌های صوتی پس از نهایی‌شدن هر سطح.
