# Finalized Project Decisions

## Repository as durable source of truth
- The current `main` branch is the canonical durable project memory for rules, contracts and automation.
- Before creating a new language, CEFR level or substantial content batch, start from `docs/PROJECT_RULES_INDEX.md` and apply the referenced contracts.
- Chat/model memory is secondary; durable decisions must be committed to GitHub.
- When a repeated defect is discovered, fix current content and add a rule/schema/test whenever the defect is machine-testable.

## Database and deliverable
- MySQL-first; canonical runtime is **MySQL 9.0.1**.
- JSON schemas are authoring contracts; MySQL is canonical finalized storage.
- Each language × CEFR level may be one SQL content file.

## Coverage-driven curriculum
- No fixed/preferred unit, lesson or activity count exists.
- Counts are outputs, not authoring quotas.
- Do not pad/split/merge curriculum to resemble neighboring content.

## CEFR completion
- A level ends only when CEFR abilities, prerequisites, progression, practice/retrieval, skill modes and QA are sufficiently complete.
- Before `final`, run the documented 0–10 review; intended release quality is close to 10/10.
- A high score never overrides a material gap.

## Opening conversation
- Every finalized lesson starts with `conversation_speaking`.
- Opening conversations use **4–12 turns**.
- For the **first 10 lessons of a language's beginner path**, the opening conversation is **exactly 4 turns** to keep initial cognitive load low. When Pre-A1 exists, these are the first 10 Pre-A1 lessons.
- From lesson 11 onward there is no preferred turn count inside 4–12; choose the natural scene length and never invent filler.
- This turn envelope is an explicit product exception to the general anti-quota rule.
- Learner-turn count has no quota.
- The app or learner may initiate. For learner initiation, turn 1 is a learner turn and the Persian instruction explicitly asks the learner to start.
- Do not hard-code the app as starter across the course.

## Persian localization
- Assistant-authored learner/curriculum/editorial prose is Persian: targets, instructions, reasons, scenarios, rationales, coverage/gaps and editorial notes.
- Stable machine codes may remain ASCII/English, but every semantic code must have a stored Persian human-readable label.
- `config/fa-taxonomy.json` is the canonical Persian label registry for shared semantic codes.
- `partOfSpeech` always stores the stable technical code and `partOfSpeechFa` stores the matching Persian label.
- A new semantic code without a Persian taxonomy entry is a hard QA failure.
- Exceptions for untranslated storage are limited to target-language text, exact source quotations, proper names, IDs/keys, URLs, licenses and exact official bibliographic metadata. If any such value needs a product-facing label, that label must be Persian.

## Sources
- Reusable target-language content is source-backed.
- Only modern/current `contemporary_verified` or `maintained_current` sources feed learner-facing content.
- Legacy/old books and archived instructional documents are analysis-only.

## Image-free baseline
- Current learner-facing content is text/audio-only and must not contain/reference/depend on instructional images.

## Dynamic lesson/activity design
- Post-opening activity type/order/count are dynamic and selected by learning need.
- Avoid mechanically cloned neighboring lesson patterns.

## Lexemes/forms
- Canonical lexical identity is stored in `lexemes`; inflections/variants in `lexeme_forms`.
- Persist resolved occurrences to lexeme/form IDs; do not rely on runtime string guessing.

## Automation
- Cross-language contract validation is mandatory before accepting content batches.
- Shared rules must be enforced generically across languages rather than reimplemented as German-only checks.
- Authoring manifests and MySQL output must remain synchronized.
- MySQL schema/content imports must pass on MySQL 9.0.1 and remain idempotent.
- The full automation sequence is defined in `docs/AUTOMATION_CONTRACT.md`.

## Audio
- Audio is generated **per CEFR level**, only after that level is `final` and its target-language text plus speaker/voice assignments are frozen.
- Audio/database linkage uses stable semantic keys (`turn_key`, `lexeme_key`, `activity_key`, `example_key`), never environment-specific auto-increment IDs.
- Every generated asset stores URL, repository/storage path, provider, model, voice metadata, generation time and SHA-256 of the exact spoken text.
- Re-importing base content must preserve valid audio metadata and stable row IDs. If canonical spoken text changes, linked audio is invalidated and must be regenerated.
- Generated audio mappings live separately from base content SQL under `database/audio/<language>/<level>.sql`; base content SQL must never own or overwrite generated audio URLs.

## Relational semantic invariants
- Semantic values that drive cross-language QA or runtime invariants must be first-class relational fields, not hidden only inside generic JSON payloads.
- Dialogue starter is canonical in MySQL as `dialogues.opening_initiator` (`app` / `learner`); activity payload copies, when present, must agree with it.
- Every such semantic code must have a canonical Persian label in `config/fa-taxonomy.json`.
