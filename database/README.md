# Database Baseline

Canonical target database: **MySQL 9.0.1**.

This directory intentionally contains **schema and generic QA only**. It does not contain language rows, curriculum plans, lessons, dialogues, vocabulary, grammar content, source excerpts, or content seed batches.

## Files

- `schema.sql` — canonical content architecture with the finalized structural migrations already folded in.
- `qa_queries.sql` — generic editorial/content QA checks; no language-specific course data.

## Fresh setup

```sql
SOURCE database/schema.sql;
SOURCE database/qa_queries.sql;
```

The schema is expected to be safe to apply more than once on the same empty/baseline database.

## Finalized structural decisions already included

- MySQL 9.0.1 compatibility.
- Dynamic lesson counts and dynamic activity counts.
- Position `1` activity guard for `conversation_speaking`.
- Source/provenance link tables for learner-facing content entities.
- Character gender supports `not_applicable` for non-person speakers.
- `lesson_lexemes.is_primary` is included directly in the baseline schema.
- The corrected language-level status view is included directly in the baseline schema.
- Audio tables/fields exist, but audio remains deferred until language completion.

## Content policy

Do not place language-specific educational SQL in this baseline until content production intentionally begins. When that begins, keep content batches separate from the reusable schema.