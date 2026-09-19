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
8. Keep every finalized lesson inside the CEFR-level activity-count range configured in `config/activity-count-bounds.json`; `Pre-A1` currently requires 3–6 total activities. Treat the range as a quality guardrail, not an exact-count target.
9. Apply the beginner opening-dialogue rule: lessons 1–10 of the beginner path use exactly 4 turns; later openings use 4–12 as pedagogically justified.
10. Allow either app-start or learner-start; learner-start must explicitly instruct the learner to begin and turn 1 must belong to the learner.
11. Preserve provenance, lexeme/form identity and occurrence mappings.
12. Export each language × level as one MySQL 9.0.1 content file under `database/content/<language>/<level>.sql`.
13. Run authoring validation, activity-count validation, taxonomy/localization validation, JSON contract checks, MySQL import twice, idempotency, provenance/source QA, image-free checks and Persian editorial checks.
14. Finalize a CEFR level only after completion audit and quality review show no material gaps and release quality is close to 10/10.

## Automation principles
- CI rules are cross-language by default; avoid hard-coding German-specific logic when the same rule should apply to future languages.
- `config/activity-count-bounds.json` is the machine-readable source of CEFR-level activity-count guardrails. Do not hard-code a language-specific range in content validators.
- `scripts/validate_activity_count_bounds.py` validates finalized lessons generically across languages for every level that has an explicit range.
- `scripts/validate_mysql_content.sh` is the reusable MySQL 9.0.1 validation entry point. It automatically discovers every `database/content/**/*.sql` file; adding a new language or CEFR level must not require a bespoke database workflow.
- Counts used for consistency checks are derived from manifests/data unless they are explicit quality guardrails such as the configured activity-count range; no exact activity target is inferred from a range.
- A failed contract test must be fixed at the content/schema/rule source; do not weaken the test merely to make CI green.
- Repeated manual defects should become permanent regression tests.
- Shared semantic codes must resolve through `config/fa-taxonomy.json`; introducing a code without its Persian label is invalid.
- Semantic values that drive runtime behavior or cross-language QA should be first-class relational fields in MySQL rather than existing only inside generic JSON payloads.
- GitHub `main` is the canonical durable memory for project decisions.

## Localization contract
- Stable technical codes may remain English/ASCII for API/database compatibility.
- Every human-interpretable semantic code must have a canonical Persian label in `config/fa-taxonomy.json` before the code is used.
- Companion Persian fields required by a schema, such as `partOfSpeechFa`, must equal the canonical taxonomy label rather than carrying an independent translation.
- Assistant-authored learner, curriculum, QA and source-explanation prose must be Persian unless it is target-language text, an exact quotation, a proper name, an identifier/key/enum, a URL, a license, or official bibliographic metadata.
- MySQL taxonomy seeds and authoring taxonomy must remain synchronized automatically.

## Relational dialogue-starter contract
- `dialogues.opening_initiator` is the canonical MySQL value for who starts a dialogue: `app` or `learner`.
- Authoring `dialogue.openingInitiator` and MySQL `dialogues.opening_initiator` must match exactly; CI compares all dialogues automatically.
- If an activity payload also contains `openingInitiator`, that copy must match the relational dialogue value.
- MySQL validates structural starter semantics: learner-start means turn 1 belongs to the learner; app-start means turn 1 does not.
- The Persian wording rule for learner-start instructions is validated in `scripts/validate_project_contracts.py` using Unicode-aware Python. Do not reimplement this language-sensitive rule with database collation-dependent `LIKE` checks.

## Minimum automatic gates before a language batch is accepted
- JSON parses and required schemas are valid.
- finalized lessons satisfy the configured CEFR-level activity-count range;
- assistant-authored prose that should be Persian contains Persian text.
- all semantic codes used by authoring content have canonical Persian taxonomy labels.
- direct companion Persian fields required by schema match taxonomy.
- no image-bearing learner content exists while the image-free baseline is active.
- dialogue length and initiator rules pass.
- authoring dialogue starters and MySQL relational starters are synchronized.
- source modernity/reuse rules pass.
- SQL imports into the real MySQL 9.0.1 runtime and imports a second time without changing row counts unexpectedly.
- every language-level SQL file is discovered automatically by the generic validation script.
- authoring manifests and MySQL lesson counts remain in sync.
- taxonomy row counts and Persian labels remain synchronized between authoring and MySQL.
- no invalid learner-facing provenance links remain.
- Persian editorial/support rows stored in MySQL pass the Persian-content audit.

## Extending the system
When a new reusable category, activity, status, grammatical label, or other semantic code is needed:
1. define the stable technical code;
2. add the Persian label to the taxonomy;
3. update schema/docs if the concept changes the contract;
4. add validator coverage;
5. then use it in content.

When a new CEFR-level activity range is needed:
1. decide the explicit minimum and maximum for that level;
2. add the range to `config/activity-count-bounds.json` before finalizing lessons at that level;
3. keep exact activity counts pedagogically dynamic inside the range;
4. never infer the new range from a neighboring CEFR level.

When a new language or level is needed:
1. create its authoring manifests and content using the shared contracts;
2. create `database/content/<language>/<level>.sql`;
3. do not create language-specific CI unless the language has a genuinely language-specific rule that cannot belong to the shared contract;
4. let the shared Project Contracts and MySQL 9.0.1 workflows validate it automatically.

This order is mandatory.

## Audio automation
- After a CEFR level becomes final, generate audio only from `v_audio_generation_manifest`.
- Write deterministic assets and a separate stable-key mapping SQL file under `database/audio/<language>/<level>.sql`.
- Re-run MySQL CI after linking; ready audio must match the current text hash and expected voice.
