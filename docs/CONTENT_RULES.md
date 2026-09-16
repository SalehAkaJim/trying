# Content Rules

## 1. Source-first content

Target-language teaching content is source-driven. Do not invent new lesson dialogue, example sentences, vocabulary explanations, or grammar explanations merely to fill gaps.

Permitted editorial work includes:
- selecting source material;
- assigning it to an appropriate CEFR level;
- grouping source material into lessons and units when pedagogically coherent;
- combining compatible source-backed utterances into a coherent app scene when every target-language turn remains individually traceable;
- transforming source material into app-friendly activities;
- translating required content into Persian;
- creating metadata, IDs, character assignments and UI-only instructions.

When a source cannot be directly reused, it may still inform curriculum coverage, but the repository must not bulk-copy restricted copyrighted text. Prefer reusable/public-domain/openly licensed sources for the actual reusable lesson corpus.

## 2. No-fixed-count rule

Content structure is never quota-driven.

Do not use a fixed number or preferred numeric range for:
- units per language or CEFR level;
- lessons per level or unit;
- activities per lesson;
- turns in the opening conversation;
- learner turns in the opening conversation;
- review cadence.

Counts are derived from approved content after creation. They are not authoring targets, limits, completion criteria or QA thresholds.

Do not pad, split, merge or truncate content merely to make its size resemble neighboring content.

See `DYNAMIC_CONTENT_MODEL.md` for the complete generation model.

## 3. Persian translation

- Translation must be fluent Persian, not mechanical word-for-word Persian.
- Meaning and teaching intent must remain faithful to the source.
- Do not silently add instructional claims absent from the source.
- Preserve ambiguity when the source is genuinely ambiguous.

## 4. Units and lessons

- Units are coherent organizational clusters, not fixed-size containers.
- Unit boundaries come from theme, progression, prerequisite structure, review logic or learner-facing navigation needs.
- A new unit must not be created because a lesson-count threshold was reached.
- A unit must not be kept open because it has not reached a lesson-count threshold.
- Lessons are built around coherent learning targets and source-backed material, not a target lesson size.
- Content should not be split solely to create more lessons or merged solely to create fewer lessons.

## 5. Lesson structure

- Every finalized lesson MUST begin with `conversation_speaking`.
- The opening conversation introduces the learner directly to the lesson context, including at beginner/zero-knowledge entry points.
- Do not require a pre-lesson vocabulary screen.
- After the opening conversation, activity type, order and count are fully dynamic.
- There is NO universal sequence such as `conversation -> multiple_choice -> word_order -> review`.
- Do not pad a lesson to reach an activity count.
- Do not truncate a lesson to fit an activity count.
- Avoid repeating the same activity pattern without a pedagogical reason.
- Across neighboring lessons, vary practice patterns when the learning targets support different modalities.

### Opening-conversation depth

`conversation_speaking` is a real scene, not a count-based wrapper.

- Conversation length is dynamic and source-driven.
- There is no minimum, maximum, target or preferred range for total turns.
- There is no minimum, maximum, target or preferred range for learner turns.
- QA evaluates whether the scene has enough communicative progression and learner participation for its actual purpose.
- Prefer one source's continuous dialogue when suitable. A composite scene is allowed only when its source-backed turns are mutually compatible and every turn keeps exact provenance.
- Do not lengthen a dialogue by inventing target-language filler.
- Do not shorten a useful scene merely to make it resemble another lesson.
- Dialogue length follows the scene, source evidence, cognitive load and learning target.

## 6. Zero-beginner progression

Pre-A1 must be designed for a learner who can start with zero knowledge of the target language.

The beginning of a language should favor immediately understandable, reusable communication before unnecessarily complex contexts. Progression should be chosen by communicative prerequisites, learner load, source coverage and recycling needs—not by assigning topics to fixed lesson numbers.

For early progression:
- assume no unexplained target-language vocabulary;
- keep new productive load appropriate to what has already been established;
- recycle high-value phrases when pedagogically useful;
- prioritize concrete familiar meanings that can be understood through text, Persian support, context and previously learned material;
- avoid unnecessarily complex administrative or travel contexts when simpler communication is a better prerequisite.

There is no fixed number of "early lessons" to which these rules apply. Apply them for as long as the learner's actual progression requires them.

## 7. Initial image-free learner-content policy

The current learner-facing curriculum is intentionally **image-free**.

Until an explicit future product decision changes this rule:
- lessons, units, activities, conversations, questions, prompts, answers, options, hints, examples and review items must not include instructional images;
- no learner-facing content may depend on seeing a picture, illustration, photograph, icon, thumbnail or other artwork to understand the prompt or select the answer;
- do not author instructions such as “look at the picture”, “choose the image”, “which picture is correct?”, “what do you see?” or equivalent visual tasks;
- activity payloads must not contain `image`, `imageUrl`, `imageURL`, `imageRef`, `picture`, `photo`, `illustration`, thumbnail fields or equivalent aliases;
- source material that contains illustrations may still be used only when the reused target-language item remains fully understandable and solvable without the illustration;
- educational meaning must come from text, Persian support/context, prior learning and later audio—not from visual artwork.

Decorative product UI that carries no instructional meaning is outside this authoring restriction. Image-based educational activities can be added only after this baseline is explicitly changed.

## 8. Activity integrity

Activities should reinforce material introduced by the lesson rather than introduce unrelated target-language content.

For transformed activities:
- `word_order`: use the words of a source-backed sentence/phrase;
- `fill_blank`: remove part of a source-backed sentence rather than inventing a new sentence;
- `listen_choose` / `multiple_choice`: correct answers must be source-backed; distractors should come from source-backed material or safe structural transformations rather than newly authored target-language teaching sentences;
- `matching`: pair source-backed words/phrases with faithful Persian meanings or source-backed equivalents;
- grammar activities must trace back to a cited grammar source.

Activity quantity is determined only by what practice the lesson requires in the wider curriculum.

## 9. Words and phrases

Every reusable word or phrase should have a stable ID. This enables:
- tap-for-help inside lessons;
- Persian meaning;
- source-backed grammar/usage notes;
- examples when sourced;
- future pronunciation/audio;
- future user flashcards and spaced review.

A lesson references lexeme IDs rather than duplicating educational metadata wherever possible. Inflected and alternate forms resolve through `lexeme_forms` when lexical identity is unchanged.

## 10. Audio policy

Audio is not produced during initial content assembly.

Audio is generated only after a full target-language curriculum is complete, reviewed and considered final.

Future audio rules:
- conversation lines: character-specific ElevenLabs voices;
- standalone words/phrases: one consistent voice, preferably Hope or Lori;
- voices should be clear, calm, low-stress, non-aggressive and relatively consistent in overall tone;
- speech should remain easy for learners to understand.

## 11. Source provenance

Every reusable teaching item must be traceable to one or more source records. Store, when available:
- source ID;
- source title;
- source URL/location;
- section/lesson/page/reference;
- license/reuse information;
- retrieval date;
- transformation notes.

## 12. QA invariants

Before a lesson is final:
- first activity is conversation speaking;
- opening conversation is a meaningful scene judged semantically, not by turn count;
- learner participation is meaningful for the scene, not checked against a numeric quota;
- no structural decision was made primarily to hit a unit, lesson, activity or dialogue count;
- no learner-facing instructional content includes, references or depends on an image;
- source references resolve;
- CEFR assignment is justified;
- Persian translations preserve meaning;
- character assignment does not conflict with speaker gender, age, role, relationship or context;
- no unsupported grammar explanation has been authored;
- activity ordering is not mechanically copied from a global template;
- word/phrase/form IDs resolve;
- audio fields remain empty until the language audio phase.
