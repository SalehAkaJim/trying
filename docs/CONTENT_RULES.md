# Content Rules

## Source-first
Target-language teaching content is source-driven and traceable. Do not invent target-language dialogue/examples merely to fill gaps.

## Persian editorial prose
Project-authored learner support and curriculum/editorial prose must be Persian. Exact target-language text, proper names, IDs/enums, source titles, bibliographic/license metadata and URLs are exempt.

## Structure
No target/preferred unit, lesson or activity count exists. Every finalized lesson starts with `conversation_speaking`; post-opening activities are dynamic.

## Opening conversation
Opening conversations must contain **5–12 turns**. Exact length inside the range is chosen by scene/source/learning need; do not pad toward 12 or compress toward 5.

Starter is dynamic:
- `openingInitiator = app` → turn 1 has `learnerTurn=false`.
- `openingInitiator = learner` → turn 1 has `learnerTurn=true` and `instructionFa` explicitly asks the learner to start.

Learner-turn count otherwise remains dynamic. Every target-language turn is source-backed.

## Image-free
Current learner content is text/audio-only and independently solvable without images.

## Activities
Activities reinforce lesson content. `word_order` and `fill_blank` reconstruct sourced text; choices/matching must not introduce fabricated teaching claims; grammar is sourced.

## Level completion
A level becomes final only when CEFR coverage, prerequisites, progression, practice/retrieval, skill modes and QA are complete. Run the 0–10 review and aim close to 10 without padding.
