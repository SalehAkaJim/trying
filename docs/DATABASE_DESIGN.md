# MySQL Content Architecture

The database remains the canonical target for the language-learning content pipeline, but this clean repository preserves only finalized architecture decisions—not old implementation or educational data.

## Core decisions

- MySQL **9.0.1** is the canonical runtime.
- Final language deliverables must be exportable as complete MySQL `.sql` files.
- JSON schemas are authoring/validation contracts; finalized content must also be representable in the relational MySQL model.
- Curriculum structure is coverage-driven, source-driven and QA-driven.
- Unit count, lesson count, activity count and opening-dialogue turn count are derived outputs, never authoritative planning inputs.
- Preferred numeric ranges are also prohibited for these structural decisions.
- Every finalized lesson begins with `conversation_speaking`; subsequent activity type/order/count are dynamic.
- Units are dynamic organizational clusters, not fixed-capacity containers.
- A lesson/activity signature may be stored for QA pattern detection; it is not a lesson template requirement.
- Source provenance is first-class and should link learner-facing items to precise reusable source locations.
- Persian is the support/translation language and must remain faithful to source meaning.
- Dialogues are modeled independently from activities so turns, characters, translations, provenance and future audio remain structured.
- Character compatibility is enforceable data. Non-person speakers use `not_applicable` rather than overloading `unspecified`.
- Audio is deliberately deferred until a whole target-language curriculum is finalized.
- Words and phrases are reusable lexeme entities with stable IDs.
- Inflected and alternate written forms are child records of a lexeme rather than independent lexemes when lexical identity is unchanged.
- The lesson-to-lexeme relationship needs an `is_primary` marker for core tappable lexemes/phrases.

## Dynamic structure and counts

The relational model must represent actual relationships rather than encode content quotas.

Do not make fields such as the following authoritative generation inputs:

- `planned_unit_count`;
- `planned_lesson_count`;
- `target_lessons_per_unit`;
- `min_lessons_per_unit` / `max_lessons_per_unit`;
- `target_activity_count`;
- `min_activity_count` / `max_activity_count`;
- `target_dialogue_turn_count`;
- `min_dialogue_turns` / `max_dialogue_turns`;
- `target_learner_turn_count`.

If analytics needs these counts, derive them from rows/relationships. A temporary operational estimate, if ever introduced, must be explicitly non-binding and must not control content generation or QA.

### Units

A future `units` table/entity groups lessons for a pedagogical or learner-navigation reason. It has stable identity, level/language relation, ordering metadata, learning-target/topic metadata, rationale and status. It does **not** have a target lesson capacity.

Lessons may reference their unit through an ordering/junction relationship depending on the final relational implementation. Unit size is whatever the approved grouping requires.

### Lessons and activities

Lessons are created from coherent targets and source-backed material. Their number is derived from coverage.

A finalized lesson must have an opening `conversation_speaking` activity. This is an existence/type invariant, not a target activity count. The rest of the sequence is variable-length and target-driven.

### Dialogues

Dialogue turn count and learner-turn count are not modeled as required targets or min/max thresholds. A dialogue stores the turns it actually needs. QA judges semantic completeness, communicative progression, learner participation and source integrity.

## Hybrid relational + JSON model

Stable relationships should be relational and protected with foreign keys: languages, CEFR levels, curriculum targets, units, lessons, activities, dialogues, characters, lexemes, lexeme forms, grammar notes, examples and source provenance.

Exercise-specific configuration varies by activity type, so activity-specific payload/configuration may use JSON without forcing a database migration for every exercise variant.

## Lexeme and form model

`lexemes` stores lexical identity. Its `surface` is the canonical/headword display form and `lemma` stores the linguistic lemma when applicable.

A future relational `lexeme_forms` table should store non-canonical inflections and surface variants that resolve to the parent lexeme. The minimum architecture is:

- `id` — stable primary key;
- `lexeme_id` — foreign key to `lexemes`;
- `surface` — exact observed/approved form;
- `form_type` — coarse cross-language classification such as inflected, orthographic variant, contraction, cliticized, abbreviation or other;
- `features` — JSON metadata for language-specific morphology/grammar;
- `origin` — source-attested, reference-attested or generated;
- `review_status` — pending review or approved;
- provenance links for attested forms where available.

The SQL implementation may maintain a derived/indexed `normalized_surface` or equivalent lookup key for efficient matching. It is technical lookup metadata only and never replaces exact display `surface`.

### Matching and ambiguity rules

- Lookup searches both canonical `lexemes.surface` and approved `lexeme_forms.surface` records.
- A canonical form does not need duplication in `lexeme_forms` solely for lookup.
- `surface` is not globally unique.
- A lookup hit returns candidate lexeme/form records rather than assuming one surface uniquely identifies one lexeme.
- Language/context and, when needed, morphology disambiguate candidates.
- Generated form candidates remain non-authoritative until reviewed/approved.
- A surface difference alone does not justify a new lexeme; lexical identity/meaning must genuinely differ.

### Content occurrence resolution

Surface lookup is an ingestion/authoring aid, not the final runtime identity mechanism.

When a token or tappable text occurrence is resolved, the future relational model should persist:

- exact occurrence surface or text offsets;
- resolved `lexeme_id`;
- optional `lexeme_form_id` for a non-canonical/variant form;
- resolution/review state when ambiguity remains.

Once approved, clients should use the persisted mapping instead of repeatedly guessing identity from raw string matching.

## Curriculum coverage

Curriculum targets are the planning mechanism for dynamic course sizing. Lessons connect to targets; units organize coherent lesson clusters after pedagogical structure emerges.

A level becomes final because mandatory targets have adequate source-backed coverage, progression is coherent and QA passes—not because it reached any count.

## Intended content model

The future relational implementation should support:

- languages and CEFR levels;
- dynamic level planning and curriculum coverage;
- dynamic units and lesson grouping;
- source and source-item provenance;
- reusable characters;
- conversations and turns;
- lessons and dynamic activity sequencing;
- activity items/options/tokens;
- reusable words and phrases plus inflected/variant form resolution and persisted occurrence mappings;
- grammar notes and example sentences;
- future ElevenLabs audio references.

User accounts, progress, streaks/XP, placement tests, SRS scheduling and payments remain outside the content schema until product behavior is defined.

## Clean-restart rule

The SQL schema, migrations, seeds, plans and content batches from the previous repository are **not** carried into this repository. When implementation restarts, the database should be rebuilt from these finalized decisions and contracts in `/schemas`, with educational content kept separate from reusable infrastructure.
