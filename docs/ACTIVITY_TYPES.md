# Activity Types

Every finalized lesson contains exactly one `conversation_speaking`, always at activity 1. It is backed by the opening dialogue turns and may not appear again later in the lesson. This is the only fixed activity position; everything from activity 2 onward is chosen by learning need.

## conversation_speaking
- 4–12 turns overall; the first 10 beginner-path lessons use exactly 4 turns.
- App or learner may start.
- Learner-start means turn 1 is learner and instruction explicitly says to start.
- Every target-language turn is source-backed.
- No learner-turn quota.

## matching
- Display between **4 and 8 pairs**.
- Every matching payload declares `pairMode`.
- `target_to_persian`: `left` is target-language content and `right` is the Persian answer/category; both `leftFa` and `rightFa` remain explicit Persian companions.
- `target_to_target`: both `left` and `right` are target-language content; `leftFa` and `rightFa` provide Persian companions.
- Each left value and each right value must be non-empty and unique inside the activity.
- `Pre-A1` uses **exactly 4 pairs**.
- Levels above `Pre-A1` may use 4–8 pairs when the learning need justifies the extra load.
- All target-language items must remain source-backed.

## Catalog
`conversation_speaking`, `listen_choose`, `multiple_choice`, `choose_response`, `word_order`, `fill_blank`, `matching`, `listen_repeat`, `pronunciation_read`, `grammar_focus`, `comprehension`, `true_false`, `review`.

There is no universal post-opening sequence, no preferred second or final activity type, and no preferred exact activity count. The fixed opening conversation is excluded when auditing type/sequence diversity. Finalized lessons must stay inside the configured CEFR-level activity range; `Pre-A1` currently requires **3–6 total activities**. Inside that range, choose modality and count by learning need and do not add unnecessary exercises merely to approach the upper bound.
