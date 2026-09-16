# CEFR Mapping and Dynamic Curriculum Planning

## Principle

CEFR planning is **coverage-driven, not count-driven**.

No language or CEFR level receives a predetermined number of units or lessons. No preferred range is allowed either. Counts emerge only after source-backed curriculum coverage, progression and QA are satisfied.

Assumptions such as `Language X A1 = N lessons`, `each level has N units`, or `each unit has N lessons` must never be used as authoring rules.

Actual counts are outputs of the curriculum, not inputs to it.

## Supported levels

- `Pre-A1`
- `A1`
- `A2`
- `B1`
- `B2`
- `C1`
- `C2`

## Planning pipeline

For each language and level:

1. Identify relevant CEFR communicative descriptors and expected learner abilities.
2. Identify language-specific linguistic content required to support those abilities.
3. Inventory available source material.
4. Map source items to CEFR targets and communicative situations.
5. Detect gaps, duplicates and overrepresented topics.
6. Group compatible source-backed material into coherent lessons where pedagogically justified.
7. Add or revise lessons only when target coverage, practice, progression or review needs justify it.
8. Re-run the coverage matrix and QA.
9. Group lessons into units only when coherent learner-facing clusters emerge.
10. Continue until unresolved required coverage no longer justifies additional content.
11. Finalize the level based on coverage and quality—not because any numeric count was reached.

At every stage, unit and lesson counts are derived from the current approved structure.

## Coverage matrix

A level plan should track at minimum:

### Communicative modes
- reception / listening
- reception / reading
- spoken interaction
- spoken production
- written interaction/production where appropriate
- mediation where appropriate for the level and course design

### Linguistic support
- vocabulary / lexical range
- grammar / structural control
- pronunciation / phonological control
- formulaic language and common phrases

### Communicative functions
Examples include greeting, introducing oneself, asking for information, requesting, describing, comparing, narrating, expressing opinions, agreeing/disagreeing and other functions appropriate to the level.

### Situations/domains
Personal life, everyday transactions, travel, services, education, work, social interaction and additional domains as appropriate to level and source coverage.

## Language-specific assignment

If a source labels material with a CEFR level, record that label but still validate fit.

If a source has no CEFR label, assign one by evaluating the actual content, including:
- communicative function;
- assumed prior knowledge;
- grammatical complexity;
- lexical frequency/range;
- sentence and discourse complexity;
- listening/reading burden;
- amount of support required;
- expected learner output.

The same apparent topic can occur at multiple levels with different linguistic demands.

## Unit formation

Units are organizational groupings, not fixed-capacity containers.

A unit boundary should emerge from one or more pedagogical reasons such as:
- coherent communicative theme;
- prerequisite/progression boundary;
- meaningful scenario cluster;
- review/consolidation boundary;
- learner-facing navigation clarity.

Do not create a new unit because the previous unit reached a lesson count. Do not keep adding lessons to a unit because it has not reached a lesson count.

The number and size of units may differ substantially across languages, levels and even neighboring units in the same level.

## Count policy

Do not store or treat any of the following as authoritative curriculum targets:

- planned unit count;
- planned lesson count;
- target lessons per unit;
- minimum/maximum lessons per unit;
- preferred lesson-count range.

If analytics or UI needs counts, derive them from the actual approved `unit` and `lesson` records.

Operational estimates, if ever introduced, must be clearly non-binding and must never participate in generation logic or QA pass/fail decisions.

## Completion rule

A level is complete when:
- required communicative targets are adequately covered;
- major language-specific prerequisites are covered;
- source-backed practice is sufficient for the curriculum design;
- important material has appropriate reinforcement;
- known curriculum gaps are resolved or explicitly documented;
- progression is coherent;
- QA approves source integrity, level placement and structure.

A level is **not** complete because it reached a certain number of units or lessons.

## Progression rule

Do not force all source material from one book/course to remain in its original order. Preserve useful source sequencing when pedagogically sound, but the app curriculum may reorganize material to achieve coherent CEFR progression.

See [`DYNAMIC_CONTENT_MODEL.md`](DYNAMIC_CONTENT_MODEL.md) for the project-wide no-fixed-count rule covering units, lessons, activities and opening conversations.
