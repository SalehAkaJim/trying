# Persian Localization Policy

## Core rule
Every assistant-authored semantic value that may be interpreted by the product, content tooling, QA, analytics, admin UI, learner UI, or future content generators must have a stored Persian equivalent.

Technical codes remain stable ASCII/English identifiers where useful for APIs and database consistency, but a technical code must never be the only stored human-readable representation.

Examples:
- `greeting_formula` -> `عبارت سلام و احوال‌پرسی`
- `farewell_formula` -> `عبارت خداحافظی`
- `conversation_speaking` -> `مکالمهٔ گفتاری`
- `source_checked` -> `منبع بررسی‌شده`

## Canonical taxonomy
`config/fa-taxonomy.json` is the canonical code-to-Persian-label registry.

Before introducing any new semantic code:
1. add its Persian label to the correct taxonomy domain;
2. run the project contract validator;
3. only then use the code in authoring content or SQL.

A new semantic code without a Persian taxonomy entry is a hard QA failure.

## Direct Persian companion fields
For content fields whose semantic label is likely to be inspected directly in authoring files, a Persian companion is stored on the entity as well.

Currently required:
- `partOfSpeech` + `partOfSpeechFa` on every lexeme when part of speech is present.

The direct Persian value must exactly match the canonical taxonomy label for that technical code. This prevents translation drift.

## What must be Persian
Assistant-authored learner/support/editorial prose remains Persian, including:
- titles and instructions;
- learning targets;
- scenarios and rationales;
- explanations and notes;
- coverage and gap descriptions;
- usage notes;
- generated labels shown to humans.

## Allowed non-Persian data
These may remain in their original form, but if they need a human-facing product label they must also resolve to Persian through the taxonomy or an explicit `*Fa` field:
- target-language instructional text;
- stable IDs and keys;
- URLs;
- licenses and exact official source/bibliographic names;
- exact quotations from sources;
- language codes and standardized technical identifiers.

## Database rule
MySQL stores canonical technical codes and the Persian localization layer. `taxonomy_labels` is the runtime registry for shared semantic codes. Content-specific semantic labels such as part of speech are also stored directly where specified by the schema.

## QA hard failures
- semantic code used without a Persian taxonomy entry;
- `partOfSpeech` present without `partOfSpeechFa`;
- `partOfSpeechFa` differs from the canonical taxonomy value;
- new human-facing generated label exists only in English;
- assistant-authored editorial/support prose is English-only where Persian is required.

This policy applies to every language, every CEFR level, and all future content generation.

## Strict Persian coverage
- A Persian field is not valid merely because it contains one Persian character; untranslated English prose/jargon mixed into assistant-authored Persian text is a QA failure.
- Exact target-language strings, official names and standardized identifiers may remain in their original form, but human-facing companions must be Persian.
- `sourceTitle` requires `sourceTitleFa`; source `title` has `titleFa`; source `locator` requires `locatorFa`.
- Character roles, voice-profile values, activity interaction modes and grammatical feature values are semantic codes and must resolve through the canonical Persian taxonomy.
- Content README files under `content/` are Persian durable project/content memory.

