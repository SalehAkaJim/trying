# Content Rules

## 1. Source-first content

Target-language teaching content is source-driven. Do not invent new lesson dialogue, example sentences, vocabulary explanations, or grammar explanations merely to fill gaps.

Permitted editorial work includes:
- selecting source material;
- assigning it to an appropriate CEFR level;
- grouping source material into lessons;
- combining compatible source-backed utterances into a coherent app scene when every target-language turn remains individually traceable;
- transforming source material into app-friendly activities;
- translating required content into Persian;
- creating metadata, IDs, character assignments and UI-only instructions.

When a source cannot be directly reused, it may still inform curriculum coverage, but the repository must not bulk-copy restricted copyrighted text. Prefer reusable/public-domain/openly licensed sources for the actual reusable lesson corpus.

## 2. Persian translation

- Translation must be fluent Persian, not mechanical word-for-word Persian.
- Meaning and teaching intent must remain faithful to the source.
- Do not silently add instructional claims absent from the source.
- Preserve ambiguity when the source is genuinely ambiguous.

## 3. Lesson structure

- Every lesson MUST begin with `conversation_speaking`.
- The opening conversation introduces the learner directly to the lesson context, including at beginner/zero-knowledge entry points.
- Do not require a pre-lesson vocabulary screen.
- After the opening conversation, activity type, order and count are dynamic.
- There is NO universal sequence such as `conversation -> multiple_choice -> word_order -> review`.
- A lesson may contain 2 activities, 10 activities, or another count if justified by the source content and learning targets.
- Do not pad a lesson to reach a target activity count.
- Do not truncate a lesson just to fit a maximum count unless product constraints are later defined.
- Avoid repeating the same activity type back-to-back without a pedagogical reason.
- Across neighboring lessons, vary practice patterns to reduce predictability and fatigue.

### Opening-conversation depth

`conversation_speaking` is a real mini-scene, not merely a two-line prompt/answer wrapper.

- Conversation length is dynamic and source-driven.
- For normal course lessons, a two-turn dialogue is considered insufficient and must be replaced by a more complete source-backed scene.
- A typical beginner opening should contain several alternating turns and multiple learner-speaking turns so the learner participates more than once.
- Early zero-beginner lessons should normally expose the learner to the same small language set repeatedly inside one coherent scene instead of introducing many unrelated words.
- Prefer one source's continuous dialogue when suitable. A composite scene is allowed only when its source-backed turns are mutually compatible and every turn keeps exact provenance.
- Do not lengthen a dialogue by inventing target-language filler.
- Dialogue length must follow the scene: a greeting may be compact, while a cafe, shopping, directions or registration scene may be substantially longer.

## 4. Zero-beginner progression

Pre-A1 must be designed for a learner who can start with zero knowledge of the target language.

The beginning of a language should favor immediately understandable, reusable communication before administrative or travel-heavy material. A sensible progression is:

1. hello / good morning / goodbye;
2. how are you and fixed short responses;
3. yes / no / please / thanks / excuse me and repair phrases;
4. giving and asking a name;
5. very simple identity/origin/residence;
6. very simple preferences such as liking familiar food;
7. simple wants/choices such as water, coffee or food;
8. numbers and age;
9. family and familiar people;
10. only then broader time/date/place/transaction/form tasks as coverage requires.

This is a progression principle rather than a globally fixed lesson list. Source availability and language-specific structure may change the exact grouping.

For the earliest lessons:
- assume no unexplained target-language vocabulary;
- keep each lesson's new productive load small;
- recycle previously introduced phrases heavily;
- prioritize concrete familiar words and visually supportable meanings;
- avoid starting the course with passport control, registration bureaucracy, formal travel procedures or other contexts that require unnecessary world knowledge when simpler communicative material is available.

## 5. Activity integrity

Activities should reinforce material introduced by the lesson rather than introduce unrelated target-language content.

For transformed activities:
- `word_order`: use the words of a source-backed sentence/phrase;
- `fill_blank`: remove part of a source-backed sentence rather than inventing a new sentence;
- `listen_choose` / `multiple_choice`: correct answers must be source-backed; distractors should come from source-backed material or safe structural transformations rather than newly authored target-language teaching sentences;
- `matching`: pair source-backed words/phrases with faithful Persian meanings or source-backed equivalents;
- grammar activities must trace back to a cited grammar source.

## 6. Words and phrases

Every reusable word or phrase should have a stable ID. This enables:
- tap-for-help inside lessons;
- Persian meaning;
- source-backed grammar/usage notes;
- examples when sourced;
- future pronunciation/audio;
- future user flashcards and spaced review.

A lesson references lexeme IDs rather than duplicating educational metadata wherever possible.

## 7. Audio policy

Audio is not produced during initial content assembly.

Audio is generated only after a full target-language curriculum is complete, reviewed and considered final.

Future audio rules:
- conversation lines: character-specific ElevenLabs voices;
- standalone words/phrases: one consistent voice, preferably Hope or Lori;
- voices should be clear, calm, low-stress, non-aggressive and relatively consistent in overall tone;
- speech should remain easy for learners to understand.

## 8. Source provenance

Every reusable teaching item must be traceable to one or more source records. Store, when available:
- source ID;
- source title;
- source URL/location;
- section/lesson/page/reference;
- license/reuse information;
- retrieval date;
- transformation notes.

## 9. QA invariants

Before a lesson is final:
- first activity is conversation speaking;
- opening conversation is a meaningful multi-turn mini-scene rather than a token two-line exchange;
- the learner speaks more than once in ordinary opening scenes;
- source references resolve;
- CEFR assignment is justified;
- Persian translations preserve meaning;
- character assignment does not conflict with speaker gender, age, role, relationship or context;
- no unsupported grammar explanation has been authored;
- activity ordering is not mechanically copied from a global template;
- word/phrase IDs resolve;
- audio fields remain empty until the language audio phase.