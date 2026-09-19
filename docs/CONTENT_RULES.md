# Content Rules

## Source-first
Target-language teaching content is source-driven and traceable. Do not invent target-language dialogue/examples merely to fill gaps.

## No assistant-authored German

For German learner-facing content, the assistant must never author, correct, normalize, or rewrite German text. If a German string is wrong, unnatural, outdated, or too difficult, replace the whole affected lesson/item with eligible source-backed German. Direct edits are allowed only for Persian translation/support/editorial metadata. Mechanical transformations explicitly licensed by the source structure, such as placeholder substitution or tokenization, must be logged.

## Persian editorial prose
Project-authored learner support and curriculum/editorial prose must be Persian. Exact target-language text, proper names, IDs/enums, source titles, bibliographic/license metadata and URLs are exempt.

## Structure
No target/preferred Unit, Lesson or Activity count exists. Counts are determined only after learning needs, source inventory, progression, Lesson boundaries and Activity design are established.

Configured ranges are guardrails, not targets. Reaching the minimum never means a Unit/Lesson is automatically complete; approaching the maximum is never a goal. Do not equalize neighboring Unit sizes, clone Lesson templates, split/merge content for symmetry, or add/remove Activities merely to make distributions look varied.

Every final Unit must have a pedagogical `groupingRationale`. Every final Lesson must record non-empty `activitySelectionRationale` and `sequenceRationale`. Before a level is accepted, `scripts/audit_dynamic_structure.py` must report its Unit/Lesson/Activity distributions and pass the quota-like risk checks defined in `config/dynamic-structure-policy.json`.

Every finalized Lesson has exactly one `conversation_speaking`, always at activity 1 and backed by dialogue turns. It may not appear again later in the Lesson. This opening is the only fixed activity rule. From activity 2 onward, type, order, exact count and stopping point are dynamic and must be justified by that Lesson's learning need and source material. There is no preferred second/final activity and no universal post-opening template. Finalized Lesson activity count must stay inside the CEFR-level envelope in `config/activity-count-bounds.json`. `Pre-A1` currently requires **3–6 total Activities**, including the fixed opening conversation.

## Opening conversation
Opening conversations must contain **4–12 turns**. The first 10 lessons of a language's beginner path use exactly 4 turns; when Pre-A1 exists these are the first 10 Pre-A1 lessons. From lesson 11 onward, exact length inside 4–12 is chosen by scene/source/learning need; do not pad toward either boundary.

Starter is dynamic:
- `openingInitiator = app` → turn 1 has `learnerTurn=false`.
- `openingInitiator = learner` → turn 1 has `learnerTurn=true` and `instructionFa` explicitly asks the learner to start.

Learner-turn count otherwise remains dynamic. Every target-language turn is source-backed.

## Image-free
Current learner content is text/audio-only and independently solvable without images.

## Activities
Activities reinforce lesson content. `word_order` and `fill_blank` reconstruct sourced text; choices/matching must not introduce fabricated teaching claims; grammar is sourced. If a lesson is below the configured minimum, add a distinct useful retrieval/practice mode rather than filler or a near-duplicate exercise.

## Level completion
`status: final` is the release-freeze/audio-eligibility state, not a shortcut for pedagogical completeness. CEFR coverage and progression must be approved before finalization. Practice/retrieval and skill-mode completion are recorded independently; if either is incomplete, its flag stays false and `requiredGaps` must explain the remaining work. Run the 0–10 review without padding or inflating scores.
