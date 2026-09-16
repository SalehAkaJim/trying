# MySQL Content Architecture

The database is the canonical target for the language-learning content pipeline.

## Core decisions

- MySQL **9.0.1** is the canonical runtime.
- JSON schemas are useful for authoring and validation, but finalized content must be representable in the relational MySQL model.
- Lesson counts are dynamic per language and CEFR level.
- Activity counts and sequences are dynamic; only activity position `1` is fixed as `conversation_speaking`.
- `lessons.template_signature` exists for QA so repetitive neighboring patterns can be detected; it is not a lesson template requirement.
- Source provenance is first-class and linked at the most precise reusable content level possible.
- Persian is the support/translation language and must remain faithful to the source.
- Dialogues are modeled independently from activities so turns, characters, translations, provenance and future audio remain structured.
- Character compatibility is enforceable data. Non-person speakers use `not_applicable` rather than overloading `unspecified`.
- Audio is deliberately deferred until a whole target-language curriculum is finalized.
- Words and phrases are reusable `lexemes` with stable IDs. `lesson_lexemes.is_primary` marks the core tappable lexemes/phrases for a lesson.

## Hybrid relational + JSON model

Stable relationships are relational and protected with foreign keys: languages, CEFR levels, curriculum targets, lessons, activities, dialogues, characters, lexemes, grammar notes, examples and source provenance.

Exercise-specific configuration varies by activity type, so activity payload/configuration may use JSON without forcing a migration for every new exercise variant.

## Curriculum coverage

`curriculum_targets` is the planning mechanism for dynamic course sizing. `lesson_targets` connects lessons to those targets. A level becomes final because mandatory targets have adequate source-backed coverage and pass QA, not because it reached an arbitrary lesson count.

## Current clean scope

This repository contains architecture only. It intentionally contains no language rows, curriculum plans, lessons, dialogues, vocabulary, grammar content or source excerpts.

The schema is designed to support:

- languages and CEFR levels;
- dynamic level planning and curriculum coverage;
- source provenance;
- reusable characters;
- conversations and turns;
- lessons and dynamic activity sequencing;
- activity items/options/tokens;
- words and phrases;
- grammar notes and example sentences;
- future ElevenLabs audio references.

User accounts, progress, streaks/XP, placement tests, SRS scheduling and payments remain outside the content schema until product behavior is defined.

## Baseline initialization

1. Run `database/schema.sql`.
2. Run `database/qa_queries.sql`.
3. Keep educational/content tables empty until content production intentionally begins.
4. When content production starts, keep reference/configuration data and language-specific content in separate files rather than embedding them into the reusable schema.