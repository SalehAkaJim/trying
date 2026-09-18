# Source Policy

## Goal

The course should be built from identifiable external language-learning sources rather than newly authored target-language teaching content.

## German authorship restriction

For German learner-facing content, source-first is absolute: the assistant may not create, repair, paraphrase, normalize, or otherwise rewrite German. A defective German item must be replaced from an eligible reusable source rather than edited. Persian translations and editorial metadata may be corrected directly. Mechanical transformations such as tokenization or source-provided placeholder substitution are allowed only when traceable and logged.

## Modern-source requirement

Learner-facing instructional content must come from **modern, contemporary sources**.

A source is eligible for learner-facing reuse only when it is either:
- a contemporary publication/document whose currency has been verified; or
- an actively maintained modern reference, corpus, dictionary, educational website or similar living source whose current state is reviewed at retrieval time.

Old or legacy books, historical textbooks, outdated course documents, archived editions, vintage grammar references, old scans/OCR editions and other materially dated instructional sources must **not** feed learner-facing lessons, dialogues, examples, lexemes or grammar guidance, even when their copyright/license would otherwise allow reuse.

Such older sources may be retained only as `analysis_only` material for historical comparison, research or coverage analysis. They must not be used as authoritative evidence of current learner-facing usage.

There is no arbitrary global publication-year cutoff. Currency is evaluated from evidence such as:
- publication or revision date;
- whether the source is actively maintained;
- whether it represents contemporary standard usage;
- whether its pedagogy, terminology, spelling, register and real-world contexts are still current;
- whether a newer authoritative edition or replacement exists.

For static books and documents, prefer current/recent editions and current official educational materials. If source currency cannot be established, mark it `needs_currency_review` and do not use it in active learner-facing content until reviewed.

## Preferred German source catalog

For new German learner-facing work, prefer the reusable sources already cataloged in `content/de/sources/`, especially:
- Deutsch im Blick / COERLL (CC BY 4.0) for contemporary first-year vocabulary, directions, weather and pronunciation;
- maintained Wikibooks/Wikivoyage pages with a precise locator and CC BY-SA reuse;
- Goethe-Institut A1 profile, practice materials and Wortliste for analysis/coverage calibration only unless reuse rights for a specific item are separately established.

The legacy `German/Print version` source records are analysis-only after the 2026-09-18 A1 quality audit and must not feed new learner-facing content unless they are independently re-reviewed and re-approved.

## Source priority

Among modern sources, prefer sources that allow reliable reuse of the actual instructional material, especially:
- current official educational resources;
- current openly licensed teaching materials;
- actively maintained dictionaries and language references;
- modern corpora with suitable licensing;
- sources with explicit reuse permission.

Restricted copyrighted sources may still be useful for curriculum analysis, topic mapping and coverage comparison, but they must not be bulk-copied into the repository when direct reuse is not permitted.

## Provenance requirement

Every reusable teaching item should reference one or more source records.

A source record should capture, when available:
- stable `sourceId`;
- title;
- organization/author;
- URL or other locator;
- language;
- source type;
- publication/update date or other currency evidence;
- modernity/currency status;
- license name and URL;
- attribution text if required;
- section / unit / lesson / page / item locator;
- retrieval date;
- reuse status;
- notes.

## Modernity status

Use one of:
- `contemporary_verified` — a contemporary static publication/document whose current suitability has been verified;
- `maintained_current` — a living/actively maintained modern source reviewed in its current state;
- `historical_or_legacy` — old/legacy material; never learner-facing;
- `needs_currency_review` — current suitability has not yet been established.

Only `contemporary_verified` and `maintained_current` sources may directly support active learner-facing instructional content.

`historical_or_legacy` sources must be `analysis_only`. `needs_currency_review` sources must remain `analysis_only` or `needs_review` until cleared.

## Reuse status

Use one of:
- `direct_reuse_allowed`
- `reuse_with_attribution`
- `analysis_only`
- `needs_review`

Modernity approval and copyright/reuse approval are separate gates. A source must pass **both** before it can feed reusable learner-facing content.

## Transformation logging

When source material becomes an app activity, store a transformation note such as:
- `verbatim_dialogue`
- `persian_translation_added`
- `sentence_tokenized_for_word_order`
- `source_sentence_blank_created`
- `source_items_grouped_for_matching`
- `character_metadata_added`
- `cefr_level_assigned_by_app`

The transformation log exists to distinguish original source text from app structuring.

## Multiple sources per lesson

A lesson may combine several sources. For example, one source may provide a dialogue, another vocabulary support and another grammar explanation. Each item retains its own source references, and every learner-facing source must independently satisfy the modern-source rule.

## Source list in the app

The data model should preserve enough metadata to later expose a user-facing Sources/Credits section without rebuilding provenance manually.
