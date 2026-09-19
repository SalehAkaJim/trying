# Content QA Rules

## Hard failures
- finalized lesson lacks a non-empty target-language `sourceTitle` or Persian `sourceTitleFa`;
- for German lessons, `sourceTitle` must contain target-language text and no Persian; from A1 onward it may not use ellipsis/compressed German and each title segment must be an exact source-backed string already present in that lesson/dialogue;
- a `matching` activity omits `pairMode` or its declared target/Persian side does not match the actual script;
- finalized lesson does not begin with `conversation_speaking`;
- finalized lesson activity count falls outside the CEFR-level range configured in `config/activity-count-bounds.json`; `Pre-A1` currently requires 3–6 total activities;
- `matching` activity contains fewer than 4 or more than 8 pairs;
- `Pre-A1` `matching` activity contains anything other than exactly 4 pairs;
- opening dialogue is outside 4–12 turns;
- any of the first 10 lessons of a language's beginner path has an opening dialogue other than exactly 4 turns;
- starter metadata and turn 1 disagree;
- learner-start instruction does not explicitly ask learner to start;
- target-language content lacks provenance;
- learner-facing source is not modern/current and reusable;
- authored learner/curriculum/editorial prose that should be Persian is English-only;
- mixed untranslated English jargon remains inside assistant-authored Persian prose;
- source/lesson human-readable original-language fields lack their required Persian companion;
- required Persian translation is missing;
- semantic code has no Persian label in `config/fa-taxonomy.json`;
- `partOfSpeech` is present but `partOfSpeechFa` is missing or differs from the canonical taxonomy label;
- a MySQL ENUM that carries human-interpretable meaning has no taxonomy-domain mapping or Persian labels for all allowed values;
- learner-facing content depends on instructional imagery;
- referenced IDs/forms/sources do not resolve;
- language/level manifests omit durable content objects that belong to them;
- authoring manifests and MySQL output disagree about the content batch;
- dialogue is padded with invented filler to satisfy the turn envelope;
- curriculum is padded/split/merged to hit unit or lesson counts;
- activities are duplicated or padded merely to approach the configured upper activity bound rather than meeting a real learning need;
- a final Unit lacks a pedagogical `groupingRationale`;
- a final Lesson lacks `activityDesign.activitySelectionRationale` or `activityDesign.sequenceRationale`;
- `scripts/audit_dynamic_structure.py` detects an unresolved quota-like distribution risk.

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

## Matching QA
- every `matching` activity contains **4–8 pairs**;
- each side must be non-empty and unique within that activity;
- `Pre-A1` uses **exactly 4 pairs**;
- levels above `Pre-A1` may increase above 4 only when justified by learning need rather than filler;
- target-language matching items must remain source-backed.

## Dynamic structure QA
- Run `python scripts/audit_dynamic_structure.py` before accepting a review/final level.
- The audit must print Unit Lesson counts, both count distributions, top Activity sequences, Units at minimum and Lessons at minimum.
- Risk thresholds live in `config/dynamic-structure-policy.json` and are detectors only; they must never be used as desired distributions.
- A suspicious pattern must trigger re-evaluation of learning needs, source inventory, progression and practice design.
- Do not silence a detector by randomly changing counts, adding filler, splitting coherent content or merging unrelated content.
- The correct causal order is: learning needs → source inventory → progression → Lesson boundaries → Activity design → counts.

## Activity-count QA
- activity-count ranges are configured by CEFR level in `config/activity-count-bounds.json` and apply to finalized lessons across languages;
- `Pre-A1` finalized lessons contain 3–6 total activities, including the opening conversation;
- the minimum is a quality floor: if a lesson is short, add a distinct source-backed retrieval/practice activity with real value rather than filler;
- the maximum is a ceiling, not a target; do not expand a complete lesson merely to use the available capacity;
- future level ranges must be explicitly defined before they are enforced; never infer an unset range from another level.

## Automation QA
Before accepting a batch, run the dynamic-structure audit, shared project contract validator, CEFR activity-count validator, JSON/schema validation, MySQL 9.0.1 import, second import/idempotency, source/provenance checks, localization checks, image-free checks and manifest/SQL consistency checks.

Rules that apply across languages must be tested generically. Do not solve a cross-language defect with a German-only test.

## CEFR completion
Before a release is frozen, verify CEFR coverage, prerequisites, progression, practice/retrieval, relevant skill modes, modern source integrity and unresolved gaps. Run the 0–10 quality review and record every known gap explicitly.

`status: final` means the current release is structurally approved, frozen and eligible for the audio pipeline. It does **not** by itself mean every pedagogical completion flag is true. A finalized level with `practiceAndRetrievalComplete: false` or `skillModeCoverageComplete: false` must keep those flags false and list the remaining work in `requiredGaps`. Educational completeness is claimed only when the relevant completion flags are true and `requiredGaps` is empty.
