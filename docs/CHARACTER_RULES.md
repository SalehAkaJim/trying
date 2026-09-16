# Character Rules

## Purpose

Characters make source-backed dialogues feel natural in the app without changing the underlying teaching text.

## Source characters

If the source already defines characters/speakers, preserve them whenever practical.

If the source only has anonymous speakers (for example `A` / `B`) or no character metadata, the app may assign characters. Character creation must not change the dialogue text or its instructional meaning.

## Mandatory compatibility checks

Character assignment must be compatible with all available evidence in the dialogue:
- explicit speaker gender;
- pronouns and grammatical gender where relevant;
- stated age or life stage;
- family relationship;
- professional/social role;
- situation and setting;
- formality/register;
- cultural and contextual clues.

### Gender is a hard QA rule

If a line is clearly spoken by a woman, do not assign a male character. If it is clearly spoken by a man, do not assign a female character.

When gender cannot be inferred from the source, assignment may be chosen freely only if it creates no contradiction elsewhere in the dialogue.

For non-person speaker entities (for example a class/group/system role), use `gender = not_applicable` rather than overloading `unspecified`.

## Character library

Prefer reusing a manageable recurring character library instead of creating a new persona for every lesson. This supports familiarity and future voice consistency.

Character metadata may include:
- stable ID;
- display name;
- gender;
- approximate age band;
- role/occupation;
- locale/background when relevant;
- relationship tags;
- personality/voice notes;
- future ElevenLabs voice ID.

## Future ElevenLabs voice rules

Audio is generated only after the entire language curriculum is finalized.

Conversation character voices should be:
- very clear and intelligible;
- calm and reassuring;
- free from aggressive, harsh or stressed delivery;
- relatively consistent in overall tone across the cast;
- natural for the character's age/gender/context;
- suitable for language learners.

For standalone word and phrase pronunciation, use one consistent voice for the language, preferably Hope or Lori unless later testing selects another voice.

## Voice assignment QA

Before audio generation:
- character gender and voice gender must match unless a deliberate source/context reason says otherwise;
- age impression should be plausible;
- voice should fit role/context;
- avoid extreme performance styles;
- speaking clarity outranks dramatic expressiveness;
- keep voice IDs stable once final production begins.