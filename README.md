# Language Learning Project

This repository is the canonical durable source of truth for the product rules, machine-readable contracts, source-backed educational content and MySQL output.

## Start here

Before creating or modifying a language, level or substantial content batch, start with [`docs/PROJECT_RULES_INDEX.md`](docs/PROJECT_RULES_INDEX.md). It defines the mandatory read order and rule-change protocol.

Important shared references:
- [`docs/PROJECT_DECISIONS.md`](docs/PROJECT_DECISIONS.md)
- [`docs/LOCALIZATION_POLICY.md`](docs/LOCALIZATION_POLICY.md)
- [`docs/AUTOMATION_CONTRACT.md`](docs/AUTOMATION_CONTRACT.md)
- [`docs/QA_RULES.md`](docs/QA_RULES.md)
- [`config/fa-taxonomy.json`](config/fa-taxonomy.json)

## Non-negotiable architecture

- MySQL-first architecture; canonical target runtime: **MySQL 9.0.1**.
- Final language deliverables are organized as one MySQL content file per language × CEFR level.
- Course sizing is coverage-driven, source-driven and QA-driven — never quota-driven.
- There is no fixed/preferred numeric count for units, lessons, post-opening activities, learner turns or review cadence.
- Every finalized lesson begins with `conversation_speaking`.
- Opening conversations use 4–12 turns; the first 10 lessons of a language's beginner path use exactly 4 turns.
- The app or learner may initiate a conversation; learner-start is explicit and turn 1 belongs to the learner.
- Target-language instructional content is source-backed and provenance-preserving.
- Current learner-facing content is image-free.
- `lexemes` represent lexical identity; inflected/variant forms resolve through `lexeme_forms`.
- Stable technical codes may remain English/ASCII, but every semantic code has a stored Persian human-readable label through the canonical taxonomy; `partOfSpeech` also stores `partOfSpeechFa` directly.
- Audio generation is deferred until the full target-language curriculum is finalized.

## Automation

Cross-language validation lives in `scripts/validate_project_contracts.py` and CI. New languages inherit the existing rules automatically. Repeated defects should become permanent repository rules/tests rather than chat-only reminders.

## Repository layout

```text
/docs/              Canonical project, editorial, QA and architecture rules
/config/            Machine-readable shared configuration such as Persian taxonomy
/schemas/           Formal authoring contracts
/scripts/           Shared automation and validation tools
/content/           Source-backed language authoring content
/database/          MySQL 9.0.1 schema and per-language/per-level content SQL
```

## Current content status

German `Pre-A1` production is in progress under `content/de/pre-a1/`. Current counts describe only what has been built so far and are never curriculum targets or forecasts.
