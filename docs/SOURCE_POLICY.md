# Source Policy

## Goal

The course should be built from identifiable external language-learning sources rather than newly authored target-language teaching content.

## Source priority

Prefer sources that allow reliable reuse of the actual instructional material, especially:
- public-domain sources;
- openly licensed sources;
- sources with explicit reuse permission;
- source corpora whose license permits the intended use.

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
- license name and URL;
- attribution text if required;
- section / unit / lesson / page / item locator;
- retrieval date;
- reuse status;
- notes.

## Reuse status

Use one of:
- `direct_reuse_allowed`
- `reuse_with_attribution`
- `analysis_only`
- `needs_review`

Only the first two should feed large-scale reusable lesson text directly.

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

A lesson may combine several sources. For example, one source may provide a dialogue, another vocabulary support and another grammar explanation. Each item retains its own source references.

## Source list in the app

The data model should preserve enough metadata to later expose a user-facing Sources/Credits section without rebuilding provenance manually.