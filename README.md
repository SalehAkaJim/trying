# Language Learning Project — Rules-Only Baseline

This repository is the clean rules/contracts foundation for the language-learning project.

**It intentionally contains no educational course content.** There are no lessons, dialogues, vocabulary lists, grammar items, curriculum plans, source excerpts, language manifests, seed data, or language-specific content batches.

What is preserved here is only the finalized project framework:

- editorial/content rules;
- source and provenance policy;
- CEFR planning rules;
- fully dynamic content-generation rules;
- activity and conversation rules;
- character and future audio rules;
- lexeme and inflected/variant-form architecture;
- QA rules;
- database architecture decisions;
- JSON content contracts.

Start with [`docs/PROJECT_DECISIONS.md`](docs/PROJECT_DECISIONS.md), [`docs/DYNAMIC_CONTENT_MODEL.md`](docs/DYNAMIC_CONTENT_MODEL.md), [`docs/CONTENT_RULES.md`](docs/CONTENT_RULES.md) and [`docs/SOURCE_POLICY.md`](docs/SOURCE_POLICY.md).

## Canonical technical direction

- MySQL-first architecture.
- Canonical database runtime: **MySQL 9.0.1**.
- Final language deliverables must be exportable as complete MySQL `.sql` files.
- Persian is the support/UI language.
- CEFR levels: `Pre-A1`, `A1`, `A2`, `B1`, `B2`, `C1`, `C2`.
- **No fixed or preferred numeric count is used to design units, lessons, activities, opening-conversation turns, learner turns, or review cadence.**
- Counts are derived outputs of source-backed coverage and QA, never authoring quotas.
- Every finalized lesson begins with `conversation_speaking`; everything after that is dynamically selected.
- Opening-conversation length is determined by the scene, source material and learning need, not by a turn threshold.
- Target-language instructional content must be source-backed and provenance-preserving.
- `lexemes` represent lexical identity; approved inflected/variant surfaces resolve through `lexeme_forms` rather than becoming duplicate lexemes.
- Surface-form lookup must support ambiguity and must not assume one written form uniquely identifies one lexeme.
- Audio generation is deferred until the full target-language curriculum is finalized.

## Repository layout

```text
/docs/      Finalized project, editorial, QA and architecture rules
/schemas/   Formal content contracts only; no content instances
```

The old repository's educational content, curriculum plans, source maps, SQL content batches, language manifests and German Pre-A1 implementation are deliberately excluded. Database implementation and CI can be rebuilt later from these finalized rules when content production begins.
