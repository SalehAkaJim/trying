# MySQL Content Architecture

The database remains the canonical target for the language-learning content pipeline, but this clean repository preserves only the finalized architecture decisions—not the old implementation or educational data.

## Core decisions

- MySQL **9.0.1** is the canonical runtime.
- Final language deliverables must be exportable as complete MySQL `.sql` files.
- JSON schemas are authoring/validation contracts; finalized content must also be representable in the relational MySQL model.
- Lesson counts are dynamic per language and CEFR level.
- Activity counts and sequences are dynamic; only activity position `1` is fixed as `conversation_speaking`.
- A lesson/activity signature may be stored for QA so repetitive neighboring patterns can be detected; it is not a template requirement.
- Source provenance is first-class and should link learner-facing items to precise reusable source locations.
- Persian is the support/translation language and must remain faithful to source meaning.
- Dialogues are modeled independently from activities so turns, characters, translations, provenance and future audio remain structured.
- Character compatibility is enforceable data. Non-person speakers use `not_applicable` rather than overloading `unspecified`.
- Audio is deliberately deferred until a whole target-language curriculum is finalized.
- Words and phrases are reusable lexeme entities with stable IDs.
- The lesson-to-lexeme relationship needs an `is_primary` marker for core tappable lexemes/phrases.

## Hybrid relational + JSON model

Stable relationships should be relational and protected with foreign keys: languages, CEFR levels, curriculum targets, lessons, activities, dialogues, characters, lexemes, grammar notes, examples and source provenance.

Exercise-specific configuration varies by activity type, so activity-specific payload/configuration may use JSON without forcing a database migration for every exercise variant.

## Curriculum coverage

Curriculum targets are the planning mechanism for dynamic course sizing. Lessons connect to one or more targets. A level becomes final because mandatory targets have adequate source-backed coverage and pass QA, not because it reached an arbitrary lesson count.

## Intended content model

The future relational implementation should support:

- languages and CEFR levels;
- dynamic level planning and curriculum coverage;
- source and source-item provenance;
- reusable characters;
- conversations and turns;
- lessons and dynamic activity sequencing;
- activity items/options/tokens;
- reusable words and phrases;
- grammar notes and example sentences;
- future ElevenLabs audio references.

User accounts, progress, streaks/XP, placement tests, SRS scheduling and payments remain outside the content schema until product behavior is defined.

## Clean-restart rule

The SQL schema, migrations, seeds, plans and content batches from the previous repository are **not** carried into this repository. When implementation restarts, the database should be rebuilt from these finalized decisions and the contracts in `/schemas`, with educational content kept separate from reusable infrastructure.