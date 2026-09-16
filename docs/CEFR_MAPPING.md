# CEFR Mapping and Dynamic Lesson Planning

## Principle

CEFR levels do not map to a fixed lesson count. The number of lessons for each `language x level` pair is derived from coverage needs.

Fixed assumptions such as `Language X A1 = N lessons` must never be made in advance. Lesson counts are outputs of curriculum analysis, not inputs.

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

1. Identify the relevant CEFR communicative descriptors and expected learner abilities.
2. Identify language-specific linguistic content required to support those abilities.
3. Inventory available source material.
4. Map source items to CEFR targets and communicative situations.
5. Detect gaps, duplicates and overrepresented topics.
6. Group source-backed content into coherent lessons.
7. Estimate whether each target has sufficient introduction, practice and review.
8. Continue sourcing until the coverage matrix is complete enough for that level.
9. Only then freeze the lesson count.

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

## Lesson count state

Each level manifest uses:

```json
{
  "plannedLessonCount": null,
  "lessonCountStatus": "unassessed"
}
```

During curriculum analysis this may become:

```json
{
  "plannedLessonCount": 87,
  "lessonCountStatus": "provisional"
}
```

Only after coverage review:

```json
{
  "plannedLessonCount": 93,
  "lessonCountStatus": "final"
}
```

A final count can differ substantially between levels and languages.

## Completion rule

A level is not complete merely because it has many lessons. It is complete when:
- required communicative targets are covered;
- major language-specific prerequisites are covered;
- source-backed practice is sufficient;
- important content is not represented only once without reinforcement;
- known curriculum gaps are resolved or explicitly documented;
- QA has approved level placement and progression.

## Progression rule

Do not force all source material from one book/course to remain in its original order. Preserve useful source sequencing when it is pedagogically sound, but the app curriculum may reorganize material to achieve coherent CEFR progression.