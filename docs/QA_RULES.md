# Content QA Rules

These checks are intended for future automated validation plus editorial review.

## Hard failures

A lesson fails QA when any of the following is true:

- activity #1 is not `conversation_speaking`;
- an ordinary course opening dialogue contains only one prompt/response pair and has no approved editorial exception;
- an opening dialogue has no learner turn, or the learner participates only once in a scene that is meant to be a normal multi-turn lesson conversation;
- a reusable target-language teaching item has no source reference;
- a grammar explanation has no source-backed origin;
- a required Persian translation is missing;
- a dialogue line is assigned to a character whose known gender conflicts with the speaker evidence;
- a character assignment conflicts with explicit age, relationship or role evidence;
- referenced lexeme, character, dialogue or source IDs do not resolve;
- audio is generated before the full language reaches final content status;
- an activity introduces unrelated target-language material only to satisfy a template.

## Conversation-depth checks

Conversation length is dynamic; QA must not force every lesson to the same turn count. It must, however, reject token conversations that do not function as a real scene.

For every opening dialogue, review:
- total turn count;
- learner-turn count;
- alternation between speakers;
- whether the scene has a clear beginning, progression and natural stopping point;
- whether repeated phrases are pedagogically useful rather than filler;
- whether every target-language turn remains source-backed;
- whether a composite dialogue combines compatible utterances without changing their target-language text.

For zero-beginner Pre-A1, flag strongly when:
- the opening has fewer than four total turns;
- the learner has fewer than two speaking turns;
- the first ten lessons repeatedly use the same two-turn or four-turn micro-pattern;
- a supposedly introductory lesson assumes unexplained vocabulary or a bureaucratic/travel context before simpler everyday communication has been introduced.

The preferred pattern for early lessons is several short turns with a very small recycled language set. Longer transactional scenes may naturally contain more turns.

## Zero-beginner progression checks

For the opening run of Pre-A1 lessons, verify that the learner can plausibly begin with no prior knowledge of the target language.

Flag for editorial review when:
- a lesson depends on words or structures that have not appeared earlier and are not immediately supported by context;
- passport, registration, complex travel, prices, dates or directions are introduced before basic greetings, name, courtesy, simple preferences and very simple personal information;
- productive vocabulary load increases sharply without recycling;
- a later lesson fails to reuse high-value beginner chunks introduced earlier;
- the course teaches isolated labels for too long without giving the learner simple conversational use.

## Dynamic activity checks

There is no desired universal activity count. QA must not reward a lesson for having more activities or penalize a lesson simply for being short.

For each lesson, record an activity signature, for example:

```text
conversation_speaking > word_order > pronunciation_read
```

Compare signatures across neighboring lessons and flag for editorial review when:

- adjacent lessons use the exact same full sequence without a clear pedagogical reason;
- a repeated local pattern becomes dominant across a run of lessons;
- the same response modality is overused while equally suitable alternatives exist;
- activity count appears padded to imitate nearby lessons;
- activity count appears artificially cut to match a preset number.

These are review flags, not automatic reasons to mutate source content.

## Activity-quality checks

- `word_order`: reconstructed output must match a source-backed utterance.
- `fill_blank`: completed output must restore source-backed content.
- `multiple_choice` / `listen_choose`: correct answer must be source-backed; distractors must not introduce fabricated teaching claims.
- `matching`: mappings must be semantically correct and traceable.
- `grammar_focus`: explanation and examples must be source-backed.
- speaking activities: learner text must be the exact expected source-backed target utterance for that step.

## CEFR checks

A level assignment should be reviewed against:
- communicative purpose;
- assumed prior knowledge;
- grammar complexity;
- vocabulary range/frequency;
- discourse length/complexity;
- learner output demand;
- listening/reading burden;
- support/scaffolding required.

Source-provided CEFR labels are evidence, not an unquestionable override.

## Translation checks

Persian should be:
- fluent and natural;
- faithful to source meaning;
- appropriate for learners;
- free from unsupported added explanations.

## Character checks

For every dialogue:
1. inspect explicit speaker identity from the source;
2. inspect pronouns, grammatical gender and relationship clues;
3. inspect role and setting;
4. assign/reuse a compatible character;
5. record whether identity came from the source or was app-assigned;
6. re-check compatibility before future voice generation.

## Audio preflight

Before ElevenLabs generation begins for a language:
- all levels are final;
- all dialogue speaker assignments are final;
- no unresolved gender/age/role conflicts remain;
- voice cast is stable;
- standalone word/phrase voice is selected (prefer Hope or Lori);
- pronunciation text is final and source content will no longer be edited.