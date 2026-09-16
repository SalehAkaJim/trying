# Finalized Project Decisions

This file is the compact source of truth for the decisions carried forward into the clean repository.

## 1. Database and deliverable

- The project is **MySQL-first**.
- Canonical runtime/version: **MySQL 9.0.1**.
- The final output for each completed language must be exportable as a complete MySQL `.sql` deliverable.
- JSON schemas are authoring/validation contracts; MySQL remains the canonical finalized storage model.

## 2. Dynamic curriculum sizing

- No language or CEFR level has a globally fixed lesson count.
- Lesson count is determined only after CEFR targets, language-specific requirements, source coverage, practice depth, review needs, and gaps are assessed.
- `planned_lesson_count` begins unassessed, may become provisional, and becomes final only after coverage review.

## 3. Dynamic lesson/activity design

- Every lesson starts with `conversation_speaking` at activity position `1`.
- After the opening conversation, activity type, order, and count are dynamic.
- A lesson may be short or long when pedagogically justified; there is no global fixed number such as 5 activities per lesson.
- Repetitive templates across neighboring lessons must be avoided and flagged by QA.
- Activities must exist because they support the lesson targets, not because a template demands them.

## 4. Opening conversations

- The opening activity is a real mini-scene, not a token prompt/answer wrapper.
- Conversation length is source-driven and should follow the scene naturally.
- For normal zero-beginner Pre-A1 openings, fewer than **4 total turns** or fewer than **2 learner-speaking turns** is a strong QA failure/review signal and requires an explicit editorial/source justification.
- The learner should participate more than once in ordinary opening scenes.
- Dialogue must not be lengthened by inventing target-language filler.
- Composite scenes are allowed only when every target-language turn is independently source-backed and the combined utterances are contextually compatible.

## 5. Source-backed instructional content

- Target-language dialogues, sentences, words, phrases, grammar explanations, and reusable teaching examples are not invented merely to fill curriculum or activity gaps.
- Every reusable teaching item must be traceable to identifiable source records/source items.
- Restricted sources may inform curriculum analysis, but reusable lesson text must obey reuse/license status.
- `analysis_only` and `needs_review` sources must not feed active learner-facing teaching content.
- Attribution-required sources must carry the required attribution metadata.

## 6. Transformations that are allowed

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

## 7. Persian support layer

- Persian text should be natural and readable, not mechanical word-for-word translation.
- It must remain faithful to the source meaning and teaching intent.
- Unsupported explanations must not be silently added.

## 8. Zero-beginner design

- Pre-A1 must work for a learner starting with zero knowledge of the target language.
- Early lessons should keep productive load small, recycle high-value language, and prefer immediately understandable communication before unnecessarily complex situations.
- Progression is principle-driven, not a globally fixed lesson list.

## 9. Words, phrases, and surface forms as first-class entities

- Reusable words and phrases have stable lexeme IDs.
- They are shared entities rather than duplicated educational metadata.
- `lexemes.surface` is the canonical/headword display form for a lexeme, not every spelling or inflected form that may appear in content.
- `lexemes.lemma` stores the linguistic lemma when applicable; for a canonical word it may equal `surface`.
- Inflected forms and meaningful surface variants belong to a child entity/table concept named `lexeme_forms` and point back to the parent lexeme.
- A lexeme form stores at minimum a stable ID, `lexeme_id`, exact `surface`, and a coarse `form_type`. Language-specific morphology belongs in flexible feature metadata rather than a fixed language-specific column set.
- Form provenance/origin and review state must be retained so automatically generated candidates cannot silently become trusted learner-facing data.
- The same written surface may legitimately have multiple grammatical analyses for one lexeme and may also map to multiple different lexemes. Therefore form `surface` is **not globally unique** and lookup must allow multiple candidates rather than silently choosing one.
- Canonical matching should consider both `lexemes.surface` and approved `lexeme_forms.surface` records. A canonical form does not need to be duplicated in `lexeme_forms` solely to make lookup work.
- Inflected or orthographic forms must not become separate lexemes merely because their surface differs. A separate lexeme is justified only when the lexical identity/meaning actually differs.
- Surface-string lookup is used to discover candidates during ingestion/authoring, not as the permanent runtime identity mechanism.
- Once a word/phrase occurrence in dialogue, activity, example, or other tappable text is resolved, the future storage model should persist its `lexeme_id` and, when applicable, `lexeme_form_id` (or an equivalent referential mapping). Approved clients should consume this stored resolution instead of re-guessing from the raw surface string.
- Ambiguous surface matches must be resolved during content QA before the occurrence is used for tappable help, grammar behavior, review, or similar learner-facing lexeme features.
- Lexemes and their forms can later support tap-for-help, grammar/usage links, examples, pronunciation, flashcards, review, and occurrence-to-lexeme resolution.
- `lesson_lexemes.is_primary` marks the core tappable lexemes/phrases for a lesson without changing the many-to-many relation.

## 10. Characters

- Source-defined speaker identity should be preserved when practical.
- App-assigned characters must never contradict source evidence about gender, age, relationship, role, setting, or register.
- Gender conflict is a hard QA issue.
- Non-person speaker entities may use `gender = not_applicable`; this must not be overloaded into `unspecified`.
- Prefer a manageable recurring character library for consistency.

## 11. Audio

- Audio is not generated during initial curriculum assembly.
- Audio generation begins only after the whole target-language curriculum is finalized and speaker assignments/text are stable.
- Conversation audio uses character-specific voices.
- Standalone words/phrases use one consistent voice per language; Hope/Lori are the retained preferred options unless later testing changes that decision.
- Learner clarity and intelligibility outrank dramatic performance.

## 12. QA and readiness

Before content can be final, QA must verify at minimum:

- opening activity is `conversation_speaking`;
- opening conversation has real scene depth and sufficient learner participation;
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

## 13. Clean-baseline rule

This repository intentionally starts with **zero educational content**. New course content must be added only after these rules and the database contracts are accepted as the baseline.
