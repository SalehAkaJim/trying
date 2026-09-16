# Content QA Rules

These checks are intended for future automated validation plus editorial review.

## Hard failures

A lesson fails QA when any of the following is true:

- the opening activity is not `conversation_speaking`;
- the opening scene is not a meaningful communicative scene for the lesson purpose;
- learner participation is absent or clearly inadequate for a lesson that requires learner interaction;
- any learner-facing educational item includes, references, requests or depends on an image, illustration, photograph, picture, thumbnail or equivalent visual artwork;
- an activity payload contains image-bearing fields such as `image`, `imageUrl`, `imageURL`, `imageRef`, `picture`, `photo`, `illustration`, thumbnail fields or equivalent aliases;
- a prompt, option, dialogue, answer, hint or instruction is not independently understandable/solvable without visual artwork;
- a reusable target-language teaching item has no source reference;
- any active learner-facing teaching item relies on a source whose modernity status is not `contemporary_verified` or `maintained_current`;
- a `historical_or_legacy` source is used as learner-facing evidence;
- a `needs_currency_review` source is used before current suitability is approved;
- a grammar explanation has no source-backed origin;
- a required Persian translation is missing;
- a dialogue line is assigned to a character whose known gender conflicts with the speaker evidence;
- a character assignment conflicts with explicit age, relationship or role evidence;
- referenced lexeme, lexeme-form, character, dialogue or source IDs do not resolve;
- an unreviewed generated lexeme form is treated as an authoritative learner-facing mapping;
- audio is generated before the full language reaches final content status;
- an activity introduces unrelated target-language material only to satisfy a template;
- content is padded, split, merged, truncated or grouped primarily to satisfy a numeric unit/lesson/activity/dialogue quota.

## Image-free content checks

The current learner-facing baseline is text/audio-only and must remain image-independent until an explicit future decision changes it.

For every lesson, activity and dialogue:
- reject image fields or media aliases in structured payloads, including nested option objects;
- reject prompts that ask the learner to inspect, identify, compare or choose a visual object;
- reject answer correctness that depends on artwork, icons, screenshots, photographs or illustrations;
- verify material sourced from illustrated documents remains independently valid after the illustration is removed;
- verify Persian context is sufficient when visual context would otherwise have been needed;
- do not treat decorative non-instructional app chrome as educational evidence.

This rule applies to all activity types, including `multiple_choice`, `choose_response`, `matching`, `listen_choose`, `conversation_speaking`, `review` and any future activity type.

## Source currency / modernity checks

Learner-facing sources must represent contemporary language and current instructional usage.

For every source used by a lesson, lexeme, dialogue, grammar note, example or activity:
- verify `modernityStatus` is present;
- allow learner-facing use only for `contemporary_verified` or `maintained_current`;
- require publication/update information or a clear `currencyEvidence` explanation;
- verify static books/documents are current/recent editions rather than legacy editions;
- verify living references/corpora/dictionaries are actively maintained and reviewed in their current state;
- verify spelling, register, terminology, examples and real-world contexts are not materially outdated;
- check whether a newer authoritative edition/replacement exists when using a static document;
- treat old textbooks, historical grammars, archived course documents, vintage instructional books and old scans/OCR editions as `historical_or_legacy` and `analysis_only`;
- treat uncertain-age/currentness sources as `needs_currency_review` until cleared.

There is no arbitrary universal publication-year cutoff. The question is whether the source is valid evidence of **current learner-facing usage**. Copyright/reuse eligibility does not override the modernity gate.

## Anti-quota checks

The project does not use fixed counts or preferred numeric ranges to design curriculum structure.

QA must flag rationales or automation rules such as:
- a target number of units per level;
- a target, minimum, maximum or preferred lesson count per level/unit;
- a target, minimum, maximum or preferred activity count per lesson;
- a target, minimum, maximum or preferred total-turn count for opening conversations;
- a target, minimum, maximum or preferred learner-turn count;
- a fixed review cadence such as review after every N lessons;
- closing/opening a unit because a lesson-count threshold was reached;
- marking a level complete because it reached a count.

Counts may be measured for analytics and QA observation, but must not become pass/fail targets or authoring quotas.

## Conversation-quality checks

Conversation length is fully dynamic. QA evaluates the scene semantically rather than against a turn threshold.

For every opening dialogue, review:
- whether it functions as a real scene rather than a token wrapper;
- whether learner participation is meaningful for the communicative purpose;
- whether speaker alternation and progression make sense for the actual scene;
- whether the scene has a natural beginning, development and stopping point where applicable;
- whether repeated phrases are pedagogically useful rather than filler;
- whether cognitive/productive load fits the learner's actual progression;
- whether every target-language turn remains source-backed;
- whether a composite dialogue combines compatible utterances without changing their target-language text;
- whether the dialogue is fully understandable without an instructional image.

Never fail or pass a conversation solely because of total-turn or learner-turn count. Never expand a conversation to reach a number and never cut useful source-backed turns to stay below a number.

## Dynamic unit and lesson checks

For units:
- verify that each unit boundary has a pedagogical/navigation rationale;
- flag units created or closed primarily because of lesson count;
- allow units within the same level to differ substantially in size;
- verify that unrelated lessons were not merged into a unit merely to reduce unit count.

For lessons:
- verify that learning targets and source-backed material form a coherent experience;
- flag artificial lesson splitting intended to increase lesson count;
- flag unrelated target merging intended to decrease lesson count;
- verify that level completion is based on coverage/progression rather than number of lessons.

## Dynamic activity checks

There is no desired universal activity count.

For each lesson, a derived activity signature may be recorded for pattern analysis, for example:

```text
conversation_speaking > word_order > pronunciation_read
```

Compare signatures across neighboring lessons and flag for editorial review when:
- adjacent lessons use the exact same sequence without a pedagogical reason;
- a repeated local pattern becomes dominant without target-driven justification;
- the same response modality is overused while equally suitable alternatives exist;
- activities appear padded to imitate nearby lessons;
- useful activities appear removed to imitate a target size;
- activity count or sequence rationale refers primarily to a numeric template rather than learning need.

These are review flags, not reasons to mutate source content automatically.

## Zero-beginner progression checks

For early Pre-A1 progression, verify that the learner can plausibly continue from actual previously introduced knowledge.

Flag for editorial review when:
- a lesson depends on words or structures not previously established and not immediately supported by context;
- complex administrative/travel contexts appear before simpler communicative prerequisites without justification;
- productive load increases sharply without enough support or recycling;
- high-value beginner chunks are not reused when later targets depend on them;
- the course teaches isolated labels for too long without simple communicative use.

Do not define "early" as a fixed number of lessons. Apply these checks for as long as the learner's actual progression requires them.

## Activity-quality checks

- `word_order`: reconstructed output must match a source-backed utterance.
- `fill_blank`: completed output must restore source-backed content.
- `multiple_choice` / `listen_choose`: correct answer must be source-backed; distractors must not introduce fabricated teaching claims.
- `matching`: mappings must be semantically correct and traceable.
- `grammar_focus`: explanation and examples must be source-backed.
- speaking activities: learner text must be the exact expected source-backed target utterance for that step.
- every activity must remain solvable without instructional imagery.

## Lexeme-form checks

Lexeme-form resolution is structural data and must be validated independently from lesson content.

Hard/review rules:
- every `lexeme_form.lexeme_id` resolves to an existing parent lexeme;
- the exact form `surface` is preserved; normalized lookup values never replace display text;
- generated forms remain `pending_review` until approved;
- source-attested forms retain resolvable provenance references;
- a form is not promoted into a separate lexeme merely because it is inflected or orthographically different;
- global uniqueness of form `surface` must not be assumed;
- collisions where one surface maps to multiple lexemes are valid ambiguity, not data corruption;
- multiple morphological analyses for the same surface and parent lexeme are allowed when linguistically valid;
- automatic lookup must return/disambiguate candidates rather than silently taking the first matching surface;
- language-aware normalization must not erase distinctions meaningful in that language.

Flag for editorial/linguistic review when:
- a form's morphology metadata conflicts with the parent lexeme or source context;
- an approved generated form has no documented review basis;
- a high-frequency encountered surface repeatedly fails to resolve to a canonical lexeme;
- normalization creates excessive collisions or merges forms that should remain distinct.

## CEFR checks

A level assignment should be reviewed against:
- communicative purpose;
- assumed prior knowledge;
- grammar complexity;
- vocabulary range/frequency;
- discourse complexity;
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
- all levels are final by coverage/QA criteria;
- all dialogue speaker assignments are final;
- no unresolved gender/age/role conflicts remain;
- voice cast is stable;
- standalone word/phrase voice is selected (prefer Hope or Lori);
- pronunciation text is final and source content will no longer be edited.
