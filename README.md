# Language Learning Project — Content-Free Baseline

This repository is the clean foundation for the language-learning project.

**It intentionally contains no educational course content.** There are no lessons, dialogues, vocabulary lists, grammar items, curriculum plans, source excerpts, language manifests, or language-specific content batches in this repository yet.

What is preserved here is only the finalized project framework:

- editorial/content rules;
- source and provenance policy;
- CEFR planning rules;
- activity and conversation rules;
- character and future audio rules;
- QA rules;
- JSON content contracts;
- the canonical MySQL 9.0.1 schema and generic QA queries;
- a CI check that verifies the schema and confirms the baseline remains content-free.

Start with [`docs/PROJECT_DECISIONS.md`](docs/PROJECT_DECISIONS.md), then read [`docs/CONTENT_RULES.md`](docs/CONTENT_RULES.md) and [`docs/SOURCE_POLICY.md`](docs/SOURCE_POLICY.md).

## Canonical technical direction

- MySQL-first architecture.
- Canonical database runtime: **MySQL 9.0.1**.
- Final language deliverables must be exportable as complete MySQL `.sql` files.
- Persian is the support/UI language.
- CEFR levels: `Pre-A1`, `A1`, `A2`, `B1`, `B2`, `C1`, `C2`.
- Lesson counts are dynamic per language and level.
- Activity counts and post-opening activity order are dynamic per lesson.
- Every lesson begins with `conversation_speaking`.
- Target-language instructional content must be source-backed and provenance-preserving.
- Audio generation is deferred until the full target-language curriculum is finalized.

## Repository layout

```text
/docs/                  Finalized project and editorial rules
/schemas/               Content contracts only; no content instances
/database/schema.sql    Canonical empty MySQL content schema
/database/qa_queries.sql Generic QA checks
/.github/workflows/     Content-free baseline CI
```

No `/content`, `/database/content`, or language-specific curriculum-plan directory is included by design.
