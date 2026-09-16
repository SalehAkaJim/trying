# Finalized Project Decisions

## Database and deliverable
- MySQL-first; canonical runtime is **MySQL 9.0.1**.
- JSON schemas are authoring contracts; MySQL is canonical finalized storage.
- Each language × CEFR level may be one SQL content file.

## Coverage-driven curriculum
- No fixed/preferred unit, lesson or activity count exists.
- Counts are outputs, not authoring quotas.
- Do not pad/split/merge curriculum to resemble neighboring content.

## CEFR completion
- A level ends only when CEFR abilities, prerequisites, progression, practice/retrieval, skill modes and QA are sufficiently complete.
- Before `final`, run the documented 0–10 review; intended release quality is close to 10/10.
- A high score never overrides a material gap.

## Opening conversation
- Every finalized lesson starts with `conversation_speaking`.
- Opening conversations must contain **5–12 turns**. This is an explicit product exception to the anti-quota rule.
- Inside 5–12 there is no preferred count; choose the natural scene length and never invent filler.
- Learner-turn count has no quota.
- The app or learner may initiate. For learner initiation, turn 1 is a learner turn and the Persian instruction explicitly asks the learner to start.
- Do not hard-code the app as starter across the course.

## Persian editorial/support prose
- Assistant-authored learner/curriculum/editorial prose is Persian: targets, instructions, reasons, scenarios, rationales, coverage/gaps and editorial notes.
- Exceptions: target-language text, exact quotations, proper names, IDs/keys/enums, URLs, licenses and official source/bibliographic metadata.
- English-only authored prose in these fields is a QA failure.

## Sources
- Reusable target-language content is source-backed.
- Only modern/current `contemporary_verified` or `maintained_current` sources feed learner-facing content.
- Legacy/old books and archived instructional documents are analysis-only.

## Image-free baseline
- Current learner-facing content is text/audio-only and must not contain/reference/depend on instructional images.

## Dynamic lesson/activity design
- Post-opening activity type/order/count are dynamic and selected by learning need.
- Avoid mechanically cloned neighboring lesson patterns.

## Lexemes/forms
- Canonical lexical identity is stored in `lexemes`; inflections/variants in `lexeme_forms`.
- Persist resolved occurrences to lexeme/form IDs; do not rely on runtime string guessing.

## Audio
- Audio is generated only after the whole target-language curriculum/text/speaker assignments are final.
