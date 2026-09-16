# Automation Contract

## Goal
Starting the next language should not require repeating the same manual checks or re-explaining settled product rules. Cross-language rules live in GitHub and are enforced by machine-readable contracts and CI.

## Required pipeline for every language
1. Read `docs/PROJECT_RULES_INDEX.md` and all referenced contracts.
2. Create the language authoring structure without inventing curriculum quotas.
3. Build coverage from CEFR + language-specific needs + current reusable sources.
4. Use only modern/current reusable learner-facing sources.
5. Store Persian support/editorial text and Persian labels for every semantic code.
6. Keep the current image-free baseline.
7. Start every finalized lesson with `conversation_speaking`.
8. Apply the beginner opening-dialogue rule: lessons 1–10 of the beginner path use exactly 4 turns; later openings use 4–12 as pedagogically justified.
9. Allow either app-start or learner-start; learner-start must explicitly instruct the learner to begin and turn 1 must belong to the learner.
10. Preserve provenance, lexeme/form identity and occurrence mappings.
11. Export each language × level as one MySQL 9.0.1 content file.
12. Run authoring validation, taxonomy/localization validation, JSON contract checks, MySQL import twice, idempotency, provenance/source QA, image-free checks and Persian editorial checks.
13. Finalize a CEFR level only after completion audit and quality review show no material gaps and release quality is close to 10/10.

## Automation principles
- CI rules are cross-language by default; avoid hard-coding German-specific logic when the same rule should apply to future languages.
- Counts used for consistency checks are derived from manifests/data, never authoring quotas.
- A failed contract test must be fixed at the content/schema/rule source; do not weaken the test merely to make CI green.
- Repeated manual defects should become permanent regression tests.
- Shared semantic codes must resolve through `config/fa-taxonomy.json`; introducing a code without its Persian label is invalid.
- GitHub `main` is the canonical durable memory for project decisions.

## Minimum automatic gates before a language batch is accepted
- JSON parses and required schemas are valid.
- assistant-authored prose that should be Persian contains Persian text.
- all semantic codes used by authoring content have canonical Persian taxonomy labels.
- direct companion Persian fields required by schema match taxonomy.
- no image-bearing learner content exists while the image-free baseline is active.
- dialogue length and initiator rules pass.
- source modernity/reuse rules pass.
- SQL imports into MySQL 9.0.1 and imports a second time without changing row counts unexpectedly.
- authoring manifest and MySQL content remain in sync.
- no invalid learner-facing provenance links remain.

## Extending the system
When a new reusable category, activity, status, grammatical label, or other semantic code is needed:
1. define the stable technical code;
2. add the Persian label to the taxonomy;
3. update schema/docs if the concept changes the contract;
4. add validator coverage;
5. then use it in content.

This order is mandatory.