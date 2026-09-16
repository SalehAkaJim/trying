# Dynamic Content Generation Model

## Non-negotiable principle

The course structure is **coverage-driven, source-driven and QA-driven**. It is never quota-driven.

No global numeric target, minimum, maximum, preferred range, batch size or template count may be used to decide:

- how many units a language or CEFR level has;
- how many lessons a unit or level has;
- how many activities a lesson has;
- how many turns an opening conversation has;
- how many learner turns an opening conversation has;
- how many items a particular activity must contain, unless the activity type itself logically requires a finite set of items to function;
- how many review lessons or review activities must appear.

Examples such as "A1 should have 100 lessons", "each unit should contain 5 lessons", "each lesson should have 6 activities", "the opening should have 4 turns", or even preferred ranges such as "normally 4–8 turns" are prohibited as planning rules.

Numeric counts may be **observed, reported and derived after content exists**. They must not become authoring quotas or completion criteria.

The project's 0–10 quality review is different: it evaluates the quality/completeness of content that exists. It must never be converted into a structural count target or gamed by padding content.

## The generation loop

For each `language x CEFR level`:

1. Build the target/coverage model from CEFR requirements, language-specific needs and available source evidence.
2. Identify the next uncovered or under-supported learning target.
3. Select source-backed material that can teach or practice that target.
4. Decide whether the material belongs in an existing lesson or requires a new lesson based on pedagogical coherence—not lesson size.
5. Build the opening scene to the natural length required by that scene and its source material.
6. Add only the activities needed to introduce, practice, discriminate, retrieve or review the lesson targets.
7. Re-run coverage and progression QA.
8. Continue until unresolved required coverage no longer justifies additional content.
9. Group lessons into units only where a coherent learner-facing grouping emerges.
10. Run the formal level-completion audit against CEFR abilities, language-specific prerequisites, skill/mode coverage, practice/retrieval, reinforcement, progression and remaining gaps.
11. Run the holistic 0–10 quality review; revise or extend content where a concrete educational weakness prevents the level from being close to 10/10.
12. Finalize the level only when material gaps are resolved, completion criteria are satisfied, source integrity passes and the quality review supports release.

The resulting counts of units, lessons, activities and dialogue turns are outputs of this process.

## Level endpoint and quality bar

Every CEFR level has an educational end point, but not a predetermined structural size.

The level should stop growing when:
- the intended CEFR learner capabilities are adequately covered for the product scope;
- required language-specific prerequisites are present;
- relevant reception, interaction, production and other appropriate modes are sufficiently supported;
- important targets have enough practice, retrieval and reinforcement;
- progression is coherent from the learner's prior state to the intended end-of-level capabilities;
- no material required coverage or QA gap remains.

Before finalization, assess overall level quality from 0–10. The desired release condition is **close to 10/10**, backed by evidence across CEFR completeness, progression, practice quality, activity design, linguistic quality, source quality/currentness, learner clarity/support and QA integrity.

A quality score is not a mathematical override. A level with a high score but a material missing CEFR capability is incomplete. Likewise, adding redundant content only to make the course longer must not raise the score.

## Units

Units are organizational clusters, not containers with a target capacity.

- A unit exists only when a coherent group of lessons benefits from being presented together.
- Unit boundaries come from communicative theme, progression, prerequisite structure, review logic or another pedagogical reason.
- No fixed number of units per level exists.
- No fixed number of lessons per unit exists.
- Units may differ greatly in size within the same level.
- A new unit must not be created merely because a previous unit has reached a certain lesson count.
- A unit must not be kept open merely because it has not reached a certain lesson count.

## Lessons

Lessons are coherent learning experiences, not fixed-size content packages.

- No level has a predetermined lesson quota.
- No unit has a predetermined lesson quota.
- A lesson exists because a coherent set of learning targets and source-backed material belong together.
- A lesson may be comparatively small or large if that is what the target and source material require.
- Content must never be split solely to increase lesson count.
- Unrelated material must never be merged solely to reduce lesson count.

Actual lesson count is derived from the lesson records that survive QA. It is not a planning field that drives authoring.

## Activities

Every finalized lesson begins with `conversation_speaking`; this is a structural invariant, not a sizing rule.

After that opening:

- activity count is fully dynamic;
- activity types are selected dynamically;
- activity order is selected dynamically;
- repeated activity patterns are allowed only when pedagogically justified, never because of a template;
- activities stop when the lesson targets have sufficient practice for that lesson's role in the wider curriculum;
- no activity is added merely to reach a number;
- no useful activity is removed merely to stay below a number.

The same language and level may therefore contain lessons with very different activity structures.

## Opening conversation

The opening conversation has **no numeric turn target, minimum, maximum or preferred range**.

Its length is determined by:

- the communicative scene;
- the source-backed material available;
- learner role and participation needs;
- what must be introduced in context;
- natural conversational progression;
- cognitive load appropriate to the learner's current progression.

QA evaluates whether the scene is pedagogically and conversationally complete, not whether it reaches a turn count.

A conversation must not be expanded with filler to satisfy a count, and it must not be shortened merely to fit a count. Learner participation is judged by whether the learner has enough meaningful participation for the scene and lesson goal, not by a fixed learner-turn threshold.

## Review and repetition

Review is also dynamic.

- Repetition is driven by retention risk, importance, prior exposure, confusion risk, prerequisite role and coverage gaps.
- There is no fixed review cadence such as one review lesson after every N lessons.
- There is no fixed number of repetitions required for every lexeme, grammar point or phrase.
- High-value material may recur much more often than low-value material when justified.

## Database implications

The database must represent actual structure rather than encode quotas.

Do not make fields such as these authoritative planning inputs:

- `planned_unit_count`;
- `planned_lesson_count`;
- `target_lessons_per_unit`;
- `target_activity_count`;
- `min_activity_count` / `max_activity_count`;
- `target_dialogue_turn_count`;
- `min_dialogue_turns` / `max_dialogue_turns`;
- `target_learner_turn_count`.

If analytics needs counts, derive them from actual rows/relationships. If a temporary estimate is ever displayed operationally, it must be explicitly non-binding and must not participate in content-generation logic or QA pass/fail rules.

A stored level-quality assessment is permitted because it evaluates educational quality; it must not be used as a hidden proxy for structural size.

## QA anti-quota rule

QA must flag any content decision whose rationale is primarily numeric rather than pedagogical. Examples:

- padding a conversation to reach a turn count;
- padding or cutting activities to match neighboring lessons;
- creating or closing a unit after a lesson count threshold;
- splitting a coherent lesson because a template says it is too large;
- merging unrelated targets because a level is expected to have fewer lessons;
- marking a level complete because it reached a lesson count.

Completion is a coverage and quality decision, never a count decision.
