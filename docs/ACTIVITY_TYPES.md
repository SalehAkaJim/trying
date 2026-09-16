# Activity Types

The activity engine is intentionally composable. Only the first activity is fixed: every lesson begins with `conversation_speaking`. Everything after that is selected from the lesson's actual source material and learning targets.

## Sequencing rules

1. `conversation_speaking` must be activity #1.
2. There is no fixed minimum beyond what the lesson needs to teach its targets coherently.
3. There is no fixed universal maximum at the content layer.
4. A short lesson may have 2 activities; a dense lesson may have 10 or more.
5. Do not force every lesson through the same pattern.
6. Avoid predictable neighboring-lesson patterns.
7. Repetition is allowed when pedagogically useful, but not because a template requires it.
8. Activity selection must be explainable through `learningTargets`, `sourceRefs`, and optional `selectionReason`.

## Initial activity catalog

### `conversation_speaking`
Required opening activity. Two or more turns form a context. App-played character lines may use future TTS. Learner turns display the exact source-backed sentence/word/phrase the learner is expected to read aloud.

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

Variety is measured across several dimensions:
- modality: speaking, listening, reading, recognition, reconstruction;
- response form: voice, choice, ordering, matching, completion;
- cognitive demand: recognition, recall, reconstruction, contextual choice;
- content granularity: word, phrase, sentence, dialogue turn, short passage.

The authoring system should prefer a varied sequence when several activity types can teach the same objective, but it must not randomize blindly. Pedagogical fit wins over novelty.

## Example valid lesson shapes

These are examples, not templates:

```text
conversation_speaking -> pronunciation_read
```

```text
conversation_speaking -> matching -> word_order -> listen_choose
```

```text
conversation_speaking -> fill_blank -> grammar_focus -> choose_response -> pronunciation_read -> review
```

```text
conversation_speaking -> listen_repeat -> comprehension -> multiple_choice -> word_order -> matching -> fill_blank -> pronunciation_read -> choose_response -> review
```

A future authoring/QA tool should flag excessive template similarity across adjacent lessons.