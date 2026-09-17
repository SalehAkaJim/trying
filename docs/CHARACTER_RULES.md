# Character Rules

## Purpose

Characters make source-backed dialogues feel natural in the app without changing the underlying teaching text. Characters are persistent identities, not disposable speaker labels, and may recur across lessons and levels to support continuity and future storylines.

## Canonical character rules

### Rule 1 — The learner is a role, not a fixed character voice

`learnerTurn` means the user performs that turn in the app. It does **not** mean there is one permanent "learner" identity or one permanent learner voice.

For every dialogue, learner turns must belong to the actual character the learner is playing in that scene. If reference audio is generated for that learner turn, it must use the voice of that character.

Do not assign a universal standalone voice to all learner dialogue turns.

Every dialogue must declare `learnerCharacterId`. Every turn with `learnerTurn=true` must use that same character as `speakerCharacterId`; app-controlled turns must use another real character from the scene. A generic durable character such as `char-*-learner` is forbidden.

### Rule 2 — Character, text and voice must agree

Character assignment must be compatible with all available evidence in the dialogue:
- explicit speaker gender;
- pronouns and grammatical gender where relevant;
- stated age or life stage;
- family relationship;
- professional/social role;
- situation and setting;
- formality/register;
- cultural and contextual clues.

The selected voice must also match the character. A line clearly spoken by a woman must not be generated with a male character/voice, and vice versa. The same compatibility requirement applies to age, role and context when the source provides that evidence.

Gender compatibility is a hard production constraint, not merely a voice-ranking preference. Voice resolution must fail instead of selecting a voice with the wrong gender for a character whose gender is known.

When gender cannot be inferred from the source, assignment may be chosen freely only if it creates no contradiction elsewhere in the dialogue.

For non-person speaker entities (for example a class/group/system role), use `gender = not_applicable` rather than overloading `unspecified`.

### Rule 3 — Add characters when the scenario needs them

Prefer a manageable recurring cast, but never force an existing character into a scene merely to keep the cast small.

A new character may be created whenever the dialogue, setting, relationship, age/gender evidence, social role or future narrative quality benefits from it. Reuse a character only when that reuse feels natural and remains compatible with the text.

### Rule 4 — Relationships are persistent story data

Characters may have explicit relationships with other characters, such as friend, classmate, coworker, neighbor, family member, customer/shopkeeper or other context-specific relationships.

Relationships should identify **which characters are related**, not merely attach an isolated tag to one character. They may be reused in later lessons to create continuity and longer story arcs.

Pairwise relationships in authoring data must be reciprocal: if Character A records Character B as a classmate/friend/neighbor/etc., Character B must contain the corresponding relationship back to Character A.

Do not invent a relationship that contradicts source material. App-created relationships are allowed when the source is silent and the relationship does not change the instructional meaning of the source-backed dialogue.

### Rule 5 — Character identity must stay consistent

Once a recurring character has established identity attributes, preserve them across future lessons unless there is an explicit, intentional reason to change them.

Stable character identity includes, where applicable:
- stable character ID and display name;
- gender;
- approximate age/life stage;
- role/occupation;
- personality and speaking style;
- relationships with other characters;
- voice assignment.

Do not silently change a recurring character's gender, age profile, relationship, personality or production voice from one lesson to another.

If a deliberate change is required, update the canonical character data first and then update all affected downstream content/audio consistently.

## Source characters

If the source already defines characters/speakers, preserve them whenever practical.

If the source only has anonymous speakers (for example `A` / `B`) or no character metadata, the app may assign or create characters. Character creation must not change the dialogue text or its instructional meaning.

## Character library

Prefer reusing a manageable recurring character library instead of creating a new persona for every lesson. Familiar recurring characters are useful, but compatibility with the actual scene has priority over reuse.

Character metadata may include:
- stable ID;
- display name;
- gender;
- approximate age band;
- role/occupation;
- locale/background when relevant;
- explicit relationships to other character IDs;
- personality/voice notes;
- production voice binding.

## Character ↔ voice binding

Every production dialogue voice must be traceable through a stable relationship:

`audio asset -> character key -> provider voice ID`

The character key is the durable identity. The ElevenLabs voice ID is the replaceable production voice assigned to that identity.

The canonical voice lock must preserve the mapping between each character key and its exact provider voice ID/name. Generated dialogue-audio metadata must preserve both the character assignment key and the actual voice ID used for generation.

If a character's production voice is rejected or replaced (for example, "Max's voice does not fit"), update that character's voice binding. Every dialogue audio asset generated with the old voice for that character must then be treated as stale and regenerated. Other characters' audio should remain reusable unless a full-level regeneration is explicitly requested.

Voice-resolution SQL must mark existing dialogue audio for a character as stale when its stored `audio_voice_id` differs from the newly selected provider voice ID. The audio planner must also compare stored voice IDs against the current voice lock so stale audio cannot be mistaken for current audio while database voice metadata is being rebuilt.

A voice change must never require guessing from filenames or spoken text which files belong to the character.

## Voice assignment QA

Before audio generation:
- resolve the actual character identity for every dialogue turn, including learner turns;
- character gender and voice gender must match unless a deliberate source/context reason says otherwise;
- age impression should be plausible;
- voice should fit role/context;
- avoid extreme performance styles;
- speaking clarity outranks dramatic expressiveness;
- keep voice bindings stable after production unless explicitly replaced;
- when a binding changes, regenerate all affected audio for that character.

Conversation character voices should be:
- very clear and intelligible;
- calm and reassuring;
- free from aggressive, harsh or stressed delivery;
- relatively consistent in overall tone across the cast;
- natural for the character's age/gender/context;
- suitable for language learners.

For standalone word and phrase pronunciation, use one consistent standalone voice for the language, preferably Hope or Lori unless later testing selects another voice. This standalone pronunciation policy must not be reused as a universal learner-dialogue voice.
