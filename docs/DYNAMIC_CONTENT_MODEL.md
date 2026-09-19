# Dynamic Content Generation Model

Curriculum sizing is coverage-driven, source-driven and QA-driven. Unit, Lesson and Activity counts are outputs of educational design, never authoring targets.

Configured minimum/maximum ranges are **guardrails only**. They protect minimum practice and maximum cognitive load; they do not define a preferred count and must never be used to make neighboring content look regular.

## Mandatory design order

Always design in this order:

```text
learning needs → source inventory → progression → lesson boundaries → activity design → counts
```

Never reverse the process into:

```text
count target → fill Lessons / Activities
```

Before deciding a Unit's Lesson count, determine its learning targets, prerequisites, introduction/practice/retrieval/review needs and available source-backed material. Before deciding a Lesson's Activity count, determine what the learner must do and which distinct practice modes are pedagogically useful.

If Unit A needs 3 Lessons and Unit B needs 7, preserve that difference. If a Lesson is complete with 3 Activities, do not add a fourth for visual consistency. If it genuinely needs 5 or 6, do not compress it to resemble neighboring Lessons.

## Unit formation

A Unit boundary exists only for a pedagogical/navigation reason such as coherent communicative purpose, prerequisite boundary, scenario cluster, retrieval boundary or learner-facing navigation clarity.

- Do not open or close a Unit because another Unit has a particular Lesson count.
- Do not split a coherent Unit merely to make counts symmetric.
- Do not merge unrelated material merely to create numerical variety.
- The configured Lesson range is a final-quality boundary, not a sizing recipe.
- Every final Unit's `groupingRationale` must explain why exactly those Lessons belong together and why that boundary is educationally useful.

## Activity design

There is exactly one fixed activity rule: **activity 1 is always `conversation_speaking` backed by the opening dialogue turns**. That opening conversation is a structural product requirement and is deliberately excluded from activity-diversity scoring.

`conversation_speaking` appears exactly once in a Lesson and only at position 1.

From **activity 2 onward**, all of the following are dynamic:
- whether another activity is needed at all;
- exact number of remaining activities inside the CEFR total-count guardrail;
- activity type;
- activity order;
- stopping point.

There is no preferred second activity, no preferred final activity, and no universal sequence such as ending every Lesson with `word_order`. A type may repeat when the learning need justifies it, but repetition caused by a template is a QA risk.

For `Pre-A1`, finalized Lessons currently contain **3–6 total Activities**, including the fixed opening conversation; other levels use their configured range in `config/activity-count-bounds.json`.

Every final Lesson must record:
- `activityDesign.activitySelectionRationale`: why the post-opening Activities are needed and why that set is sufficient;
- `activityDesign.sequenceRationale`: why the post-opening sequence is pedagogically appropriate;
- a derived `templateSignature` matching the actual full activity sequence.

Filler, near-duplicate Activities, superficial type changes and padding toward a minimum/maximum are forbidden.

## Quota-like structure audit

After designing a level, run:

```bash
python scripts/audit_dynamic_structure.py
```

The audit prints:
- Lesson count for every Unit;
- Unit Lesson-count distribution;
- Activity-count distribution across Lessons;
- most frequent **post-opening** Activity sequences;
- how many Lessons contain each post-opening Activity type;
- number of Units exactly at the configured minimum;
- number of Lessons exactly at the configured minimum.

`config/dynamic-structure-policy.json` contains **risk-detection thresholds only**. They are not desired distributions and must never be treated as new quotas.

Serious warning signals include:
- one Lesson count dominating many Units;
- many Units stopping exactly at the minimum;
- one Activity count dominating many Lessons;
- many Lessons stopping exactly at the minimum;
- one post-opening Activity sequence dominating the level;
- one post-opening Activity type appearing in most Lessons;
- several consecutive Lessons using the same sequence.

A detected signal is not permission to randomize counts. Re-check the educational design. Fix the structure only when learning needs, source inventory, progression or practice design justify a different boundary/count.

## Explicit opening-dialogue exception

Opening `conversation_speaking` scenes contain **4–12 turns**.

For the first 10 Lessons of a language's beginner path, the opening conversation contains exactly **4 turns**. After that point, choose the natural length inside 4–12 from scene, source and learning need. Learner-turn count remains unconstrained.

## Generation loop

1. Build CEFR/language-specific coverage.
2. Identify uncovered or under-supported learning needs.
3. Inventory modern reusable source-backed material.
4. Establish prerequisite/progression order.
5. Draw Lesson boundaries from coherent learning tasks, never from a count target.
6. Build the source-backed opening scene with the applicable dialogue rule.
7. Select only the distinct Activities needed for practice/retrieval/review.
8. Confirm the Lesson falls inside its configured Activity guardrail.
9. Group Lessons into Units only where coherent learner-facing boundaries emerge.
10. Confirm final Units fall inside the configured Unit guardrail.
11. Run `scripts/audit_dynamic_structure.py` and review its distribution report.
12. If the audit finds quota-like risk, revisit the design rather than manufacturing numerical variation.
13. Re-run progression/coverage QA.
14. Continue until unresolved required coverage no longer justifies content.
15. Run completion audit + 0–10 quality review.

If source material cannot support a coherent Lesson or enough useful practice to satisfy a minimum, obtain better source material or redesign the Lesson rather than inventing filler.
