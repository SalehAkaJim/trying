# Content QA Rules

## Hard failures
- finalized lesson does not begin with `conversation_speaking`;
- opening dialogue is outside 4–12 turns;
- any of the first 10 lessons of a language's beginner path has an opening dialogue other than exactly 4 turns;
- starter metadata and turn 1 disagree;
- learner-start instruction does not explicitly ask learner to start;
- target-language content lacks provenance;
- learner-facing source is not modern/current and reusable;
- authored learner/curriculum/editorial prose that should be Persian is English-only;
- required Persian translation is missing;
- semantic code has no Persian label in `config/fa-taxonomy.json`;
- `partOfSpeech` is present but `partOfSpeechFa` is missing or differs from the canonical taxonomy label;
- a MySQL ENUM that carries human-interpretable meaning has no taxonomy-domain mapping or Persian labels for all allowed values;
- learner-facing content depends on instructional imagery;
- referenced IDs/forms/sources do not resolve;
- language/level manifests omit durable content objects that belong to them;
- authoring manifests and MySQL output disagree about the content batch;
- dialogue is padded with invented filler to satisfy the turn envelope;
- curriculum is padded/split/merged to hit unit/lesson/activity counts.

## Persian localization audit
Require Persian for `instructionFa`, `translationFa`, `learningTargets`, `selectionReason`, `scenario`, `sceneQualityRationale`, lesson/unit/level rationales, coverage/gaps, editorial notes, character context notes and direct `*Fa` companion fields.

Stable technical codes can remain English/ASCII only when a Persian human-readable label is stored centrally or directly according to `docs/LOCALIZATION_POLICY.md`.

Exact target language, exact source quotations, proper names, stable IDs/keys, URLs, licenses and exact official bibliographic metadata may remain in their original form. If the product needs a human-facing label for any of them, that label must be Persian.

## Taxonomy QA
- `config/fa-taxonomy.json` is canonical for shared semantic labels;
- every taxonomy label must contain Persian text;
- every semantic MySQL ENUM must map to a taxonomy domain;
- every allowed enum value in the schema must have a taxonomy label even if no current language uses it;
- every used dynamic semantic code such as `partOfSpeech` must already exist in taxonomy;
- duplicate hand-maintained translations that can drift are discouraged; direct companion fields must be checked against the canonical taxonomy value.

## Conversation QA
- 4–12 turns overall;
- exactly 4 turns for the first 10 lessons of the beginner path; when Pre-A1 exists, this means the first 10 Pre-A1 lessons;
- after lesson 10, natural progression and stopping point determine the length inside 4–12;
- source-backed target text;
- meaningful learner participation without learner-turn quota;
- starter may be app or learner and should follow communicative purpose rather than a fixed template.

## Automation QA
Before accepting a batch, run the shared project contract validator, JSON/schema validation, MySQL 9.0.1 import, second import/idempotency, source/provenance checks, localization checks, image-free checks and manifest/SQL consistency checks.

Rules that apply across languages must be tested generically. Do not solve a cross-language defect with a German-only test.

## CEFR completion
Before finalizing, verify CEFR coverage, prerequisites, progression, practice/retrieval, relevant skill modes, modern source integrity and unresolved gaps. Run 0–10 quality review; aim close to 10 but any material gap blocks finalization.
