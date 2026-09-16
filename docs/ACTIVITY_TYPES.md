# Activity Types

The activity engine is intentionally composable. Every finalized lesson opens with `conversation_speaking`. Everything after that is selected from the lesson's actual source material, learning targets, progression role and practice needs.

## Sequencing rules

- `conversation_speaking` is the opening activity.
- There is no target, minimum, maximum or preferred activity count used for lesson sizing.
- There is no universal post-opening sequence.
- Do not force lessons through the same pattern.
- Avoid predictable neighboring-lesson patterns unless target-driven repetition is pedagogically justified.
- Repetition is allowed when pedagogically useful, never because a template requires it.
- Activity selection must be explainable through `learningTargets`, `sourceRefs`, and optional `selectionReason`.
- Stop adding activities when the lesson has the practice it needs in the wider curriculum; do not stop because a numeric limit was reached.

## Activity catalog

### `conversation_speaking`
Required opening activity for a finalized lesson. It establishes a real source-backed communicative context. Its turn count, speaker count and learner-turn count are fully scene-driven and have no target or preferred range. App-played character lines may use future TTS. Learner turns display the exact source-backed sentence/word/phrase expected for that step.

### `listen_choose`
Learner hears source-backed target-language material and chooses the correct interpretation/continuation from options.

### `multiple_choice`
General source-backed multiple-choice comprehension, vocabulary, grammar or contextual question.

### `choose_response`
Learner selects the contextually correct response to a source-backed conversation prompt.

### `word_order`
Words/tokens from a source-backed sentence are shuffled; learner restores the original sequence.

### `fill_blank`
A word or phrase is removed from a source-backed sentence and the learner restores it.

### `matching`
Learner matches words/phrases to Persian meanings, equivalents, roles or other source-supported pairs.

### `listen_repeat`
Learner hears a source-backed utterance and repeats it.

### `pronunciation_read`
Learner sees a source-backed word/phrase/sentence and reads it aloud for pronunciation practice.

### `grammar_focus`
Presents or practices a grammar point whose explanation and examples are source-backed.

### `comprehension`
Checks understanding of a source-backed dialogue, sentence or short passage.

### `true_false`
Learner evaluates a statement against source-backed material. Avoid inventing new target-language teaching sentences solely to create the activity.

### `review`
Reuses content already encountered in the course to consolidate learning. It must not become a dumping ground for unrelated generated content.

## Variety guidance

Variety is evaluated across dimensions such as:
- modality: speaking, listening, reading, recognition, reconstruction;
- response form: voice, choice, ordering, matching, completion;
- cognitive demand: recognition, recall, reconstruction, contextual choice;
- content granularity: word, phrase, sentence, dialogue turn, short passage.

The authoring system should prefer varied practice when several activity types fit the same objective, but it must not randomize blindly. Pedagogical fit wins over novelty.

There is deliberately no catalog of canonical lesson shapes. Any example sequence can become an accidental template, so lesson shape must be generated from the actual lesson targets and source material each time.
