# Language Learning Project

This repository contains the finalized rules/contracts foundation and the source-backed educational content built from those rules.

## Non-negotiable architecture

- MySQL-first architecture; canonical target runtime: **MySQL 9.0.1**.
- Final language deliverables must be exportable as complete MySQL `.sql` files.
- Course sizing is coverage-driven, source-driven and QA-driven — never quota-driven.
- There is no fixed or preferred numeric count for units, lessons, activities, opening-conversation turns, learner turns, or review cadence.
- Every finalized lesson begins with `conversation_speaking`; everything after that is selected dynamically.
- Target-language instructional content must be source-backed and provenance-preserving.
- `lexemes` represent lexical identity; inflected/variant forms resolve through `lexeme_forms`.
- Audio generation is deferred until the full target-language curriculum is finalized.

Start with [`docs/PROJECT_DECISIONS.md`](docs/PROJECT_DECISIONS.md), [`docs/DYNAMIC_CONTENT_MODEL.md`](docs/DYNAMIC_CONTENT_MODEL.md), [`docs/CONTENT_RULES.md`](docs/CONTENT_RULES.md), and [`docs/SOURCE_POLICY.md`](docs/SOURCE_POLICY.md).

## Current content status

German `Pre-A1` production has started under `content/de/pre-a1/`.

The initial seed deliberately starts with the smallest immediately useful communication requested for a zero beginner: informal greeting, morning greeting, and a familiar food preference. The current number of units/lessons/activities is only the result of the content built so far; it is **not** a target or forecast for the completed level.

## Repository layout

```text
/docs/              Finalized project, editorial, QA and architecture rules
/schemas/           Formal content contracts
/content/           Source-backed language content produced under those contracts
```
