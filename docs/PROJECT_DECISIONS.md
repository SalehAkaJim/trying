# Finalized Project Decisions

This file is the compact source of truth for the decisions carried forward into the clean repository.

## 1. Database and deliverable

- The project is **MySQL-first**.
- Canonical runtime/version: **MySQL 9.0.1**.
- The final output for each completed language must be exportable as a complete MySQL `.sql` deliverable.
- JSON schemas are authoring/validation contracts; MySQL remains the canonical finalized storage model.

## 2. Fully dynamic curriculum structure

- The project follows a strict **coverage-driven, source-driven and QA-driven** generation model.
- No language or CEFR level has a fixed or preferred unit count.
- No language, level or unit has a fixed or preferred lesson count.
- No lesson has a fixed or preferred activity count.
- No opening conversation has a fixed or preferred total-turn count or learner-turn count.
- Preferred numeric ranges are prohibited for these structural decisions just as fixed numbers are prohibited.
- Counts are derived from approved content after it exists; they are not authoring inputs, quotas, completion gates or QA targets.
- Content must never be padded, split, merged or truncated merely to satisfy a numeric structure.
- See `docs/DYNAMIC_CONTENT_MODEL.md` for the full generation loop and anti-quota rules.

## 3. Units and lessons

- Units are optional organizational clusters that emerge from coherent themes, progression, prerequisites, review logic or learner-facing navigation needs.
- A new unit is created because a pedagogical boundary exists, never because another unit reached a lesson count.
- Lessons are created because a coherent set of learning targets and source-backed material belong together.
- A level becomes final because required coverage and progression are sufficient and QA passes, not because a unit or lesson count was reached.
- Actual unit/lesson counts should be derived from stored relationships rather than used as authoritative planning fields.

## 4. Dynamic lesson/activity design

- Every finalized lesson begins with `conversation_speaking` as its opening activity. This is a structural invariant, not a sizing quota.
- After the opening conversation, activity type, order and count are fully dynamic.
- Activities exist only because they support introduction, practice, discrimination, retrieval or review of lesson targets.
- Repetitive templates across neighboring lessons must be avoided and flagged by QA unless pedagogically justified.
- No activity is added to reach a count and no useful activity is removed to stay below a count.

## 5. Opening conversations

- The opening activity is a real mini-scene, not a token prompt/answer wrapper.
- Conversation length is fully dynamic and source-driven.
- There is no minimum, maximum, target or preferred range for total turns or learner turns.
- QA judges whether the scene has sufficient communicative progression, learner participation and pedagogical completeness for its purpose.
- Dialogue must not be lengthened with target-language filler or shortened to fit a numeric expectation.
- Composite scenes are allowed only when every target-language turn is independently source-backed and the combined utterances are contextually compatible.

## 6. Source-backed instructional content

- Target-language dialogues, sentences, words, phrases, grammar explanations, and reusable teaching examples are not invented merely to fill curriculum or activity gaps.
- Every reusable teaching item must be traceable to identifiable source records/source items.
- Restricted sources may inform curriculum analysis, but reusable lesson text must obey reuse/license status.
- `analysis_only` and `needs_review` sources must not feed active learner-facing teaching content.
- Attribution-required sources must carry the required attribution metadata.

## 7. Transformations that are allowed

Allowed editorial/app transformations include:

- faithful Persian translation;
- CEFR placement after review;
- grouping compatible sourced material into a lesson;
- tokenizing a sourced utterance for word-order practice;
- removing part of a sourced utterance for fill-in-the-blank practice;
- selecting sourced options for recognition activities;
- grouping sourced items for matching;
- adding app metadata, stable IDs, character assignments, and UI-only instructions.

These transformations must not create unsupported target-language instructional claims.

## 8. Persian support layer

- Persian text should be natural and readable, not mechanical word-for-word translation.
- It must remain faithful to the source meaning and teaching intent.
- Unsupported explanations must not be silently added.

## 9. Zero-beginner design

- Pre-A1 must work for a learner starting with zero knowledge of the target language.
- Early progression should keep productive load appropriate, recycle high-value language, and prefer immediately understandable communication before unnecessarily complex situations.
- Progression is principle-driven and coverage-driven, not a globally fixed lesson sequence.
- No fixed number of early lessons receives special structural rules; QA evaluates the actual progression that exists.

## 10. Words, phrases, and surface forms as first-class entities

- Reusable words and phrases have stable lexeme IDs.
- `lexemes.surface` is the canonical/headword display form for a lexeme, not every spelling or inflected form that may appear in content.
- `lexemes.lemma` stores the linguistic lemma when applicable; for a canonical word it may equal `surface`.
- Inflected forms and meaningful surface variants belong to `lexeme_forms` and point back to the parent lexeme.
- A lexeme form stores at minimum a stable ID, `lexeme_id`, exact `surface`, and coarse `form_type`; language-specific morphology belongs in flexible feature metadata.
- Form provenance/origin and review state must be retained so generated candidates cannot silently become trusted learner-facing data.
- Form `surface` is not globally unique; the same surface may have multiple analyses and may map to multiple lexemes.
- Canonical matching considers both `lexemes.surface` and approved `lexeme_forms.surface` records.
- Surface-string lookup discovers candidates during ingestion/authoring; it is not the permanent runtime identity mechanism.
- Once an occurrence is resolved, future storage should persist `lexeme_id` and, when applicable, `lexeme_form_id` or equivalent referential mapping.
- Ambiguous mappings must be resolved during QA before dependent learner-facing lexeme features are enabled.
- `lesson_lexemes.is_primary` marks core tappable lexemes/phrases without changing the many-to-many relationship.

## 11. Characters

- Source-defined speaker identity should be preserved when practical.
- App-assigned characters must never contradict source evidence about gender, age, relationship, role, setting, or register.
- Gender conflict is a hard QA issue.
- Non-person speaker entities may use `gender = not_applicable`; this must not be overloaded into `unspecified`.
- Prefer a manageable recurring character library for consistency.

## 12. Audio

- Audio is not generated during initial curriculum assembly.
- Audio generation begins only after the whole target-language curriculum is finalized and speaker assignments/text are stable.
- Conversation audio uses character-specific voices.
- Standalone words/phrases use one consistent voice per language; Hope/Lori are the retained preferred options unless later testing changes that decision.
- Learner clarity and intelligibility outrank dramatic performance.

## 13. QA and readiness

Before content can be final, QA must verify at minimum:

- the opening activity is `conversation_speaking`;
- the opening scene is communicatively and pedagogically complete without relying on turn-count thresholds;
- learner participation is appropriate to the scene and learning goal without relying on a learner-turn quota;
- no unit, lesson, activity or conversation structure was padded, split, merged or truncated to satisfy a numeric quota or preferred range;
- provenance resolves for reusable teaching items;
- CEFR placement is justified;
- Persian translation preserves meaning;
- character assignment is compatible with source/context evidence;
- no unsupported grammar explanation has been authored;
- neighboring activity patterns are not mechanically cloned;
- referenced IDs resolve;
- lexeme-form references resolve to valid parent lexemes and unreviewed generated forms are not treated as trusted learner-facing mappings;
- ambiguous lexeme-form occurrence mappings are resolved before dependent learner-facing features are enabled;
- audio remains blocked until the language-level completion gate is satisfied.

## 14. Clean-baseline rule

This repository intentionally starts with **zero educational content**. New course content must be added only after these rules and database contracts are accepted as the baseline.
