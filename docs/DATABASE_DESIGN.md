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
- Inflected and alternate written forms are child records of a lexeme rather than independent lexemes when lexical identity is unchanged.
- The lesson-to-lexeme relationship needs an `is_primary` marker for core tappable lexemes/phrases.

## Hybrid relational + JSON model

Stable relationships should be relational and protected with foreign keys: languages, CEFR levels, curriculum targets, lessons, activities, dialogues, characters, lexemes, lexeme forms, grammar notes, examples and source provenance.

Exercise-specific configuration varies by activity type, so activity-specific payload/configuration may use JSON without forcing a database migration for every exercise variant.

## Lexeme and form model

`lexemes` stores lexical identity. Its `surface` is the canonical/headword display form and `lemma` stores the linguistic lemma when applicable.

A future relational `lexeme_forms` table should store non-canonical inflections and surface variants that resolve to the parent lexeme. The minimum architecture is:

- `id` — stable primary key;
- `lexeme_id` — foreign key to `lexemes`;
- `surface` — exact observed/approved form;
- `form_type` — coarse cross-language classification such as inflected, orthographic variant, contraction, cliticized, abbreviation or other;
- `features` — JSON metadata for language-specific morphology/grammar (for example person, number, tense, mood, case, gender or degree when relevant);
- `origin` — whether the form is source-attested, reference-attested or generated;
- `review_status` — pending review or approved;
- provenance links for attested forms where available.

The SQL implementation may also maintain a derived/indexed `normalized_surface` or equivalent lookup key for efficient matching. That value is technical lookup metadata only: it must never replace the exact display `surface`, and normalization rules must be language-aware.

### Matching and ambiguity rules

- Lookup should search both canonical `lexemes.surface` and approved `lexeme_forms.surface` records.
- A canonical/headword form does not need to be duplicated in `lexeme_forms` solely for lookup.
- `surface` must not be globally unique. The same written form can belong to different lexemes (homographs), and the same lexeme can have one surface compatible with multiple morphological analyses.
- A lookup hit therefore returns candidate lexeme/form records; it must not silently assume that a surface string identifies exactly one lexeme.
- Language/context and, when needed, morphological analysis are used to disambiguate candidates.
- Generated form candidates remain non-authoritative until reviewed/approved.
- A surface difference alone is not enough reason to create a new lexeme. Create a separate lexeme only when lexical identity or meaning is genuinely distinct.

For indexing, the relational implementation should favor lookup indexes such as the normalized form key and parent-lexeme indexes, while avoiding a global unique constraint on `surface`.

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
- reusable words and phrases plus inflected/variant form resolution;
- grammar notes and example sentences;
- future ElevenLabs audio references.

User accounts, progress, streaks/XP, placement tests, SRS scheduling and payments remain outside the content schema until product behavior is defined.

## Clean-restart rule

The SQL schema, migrations, seeds, plans and content batches from the previous repository are **not** carried into this repository. When implementation restarts, the database should be rebuilt from these finalized decisions and the contracts in `/schemas`, with educational content kept separate from reusable infrastructure.
