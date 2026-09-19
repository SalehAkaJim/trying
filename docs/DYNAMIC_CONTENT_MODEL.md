# Dynamic Content Generation Model

Curriculum sizing is coverage-driven, source-driven and QA-driven. No fixed/preferred unit or lesson count is used. Activity count is dynamic inside the CEFR-level quality envelope configured in `config/activity-count-bounds.json`; the envelope is a guardrail, not a target quota.

For `Pre-A1`, every finalized lesson contains **3–6 total activities**, including the opening `conversation_speaking`. Future levels may use larger ranges only after their own explicit envelope is defined.

## Explicit opening-dialogue exception
Opening `conversation_speaking` scenes must contain **4–12 turns**.

For the first 10 lessons of a language's beginner path, the opening conversation must contain exactly **4 turns**. After that point, choose any length inside the 4–12 envelope based on scene, source and learning need.

Learner-turn count remains unconstrained.

## Generation loop
1. Build CEFR/language-specific coverage.
2. Find the next uncovered/under-supported target.
3. Select modern reusable source-backed material.
4. Group by pedagogical coherence, never lesson size.
5. Build a source-backed opening scene with the applicable turn rule.
6. Decide whether app or learner initiates; do not hard-code one starter.
7. Add useful practice/retrieval/review activities until the lesson is educationally complete and inside the configured level activity envelope. Meeting the minimum requires genuine practice value; never add filler to move toward the maximum.
8. Re-run progression/QA.
9. Form units only when coherent grouping emerges.
10. Continue until required gaps no longer justify content.
11. Run completion audit + 0–10 quality review.

If available source material cannot form a coherent scene or enough useful practice to satisfy the applicable minimum, obtain better source material or redesign the lesson rather than inventing filler.
