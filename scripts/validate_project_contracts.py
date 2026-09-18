#!/usr/bin/env python3
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
CONTENT = ROOT / "content"
TAXONOMY_PATH = ROOT / "config" / "fa-taxonomy.json"
UNIT_BOUNDS_PATH = ROOT / "config" / "unit-lesson-count-bounds.json"
SCHEMA_PATH = ROOT / "database" / "schema.sql"
FA = re.compile(r"[\u0600-\u06FF]")
IMAGE_KEYS = {"image", "imageurl", "imageref", "picture", "photo", "illustration", "thumbnail", "thumbnailurl", "thumbnailref"}
EDITORIAL_KEYS = {
    "structureRationale", "groupingRationale", "activitySelectionRationale",
    "sequenceRationale", "selectionReason", "scenario", "sceneQualityRationale",
    "contextNotes", "notes", "instructionFa", "translationFa", "usageNoteFa",
    "titleFa", "contextFa", "promptFa", "descriptionFa", "partOfSpeechFa", "rationale"
}
EDITORIAL_LIST_KEYS = {"scopeExclusions", "requiredGaps", "strengths", "remainingWeaknesses"}
SCHEMA_ENUM_DOMAINS = {
    ("languages", "status"): "language_status",
    ("language_levels", "cefr_level"): "cefr_level",
    ("language_levels", "status"): "level_status",
    ("language_levels", "audio_status"): "audio_status",
    ("curriculum_targets", "target_type"): "curriculum_target_type",
    ("curriculum_targets", "status"): "curriculum_target_status",
    ("sources", "source_type"): "source_type",
    ("sources", "modernity_status"): "modernity_status",
    ("sources", "reuse_status"): "reuse_status",
    ("characters", "origin"): "character_origin",
    ("characters", "gender"): "gender",
    ("characters", "age_band"): "age_band",
    ("units", "status"): "unit_status",
    ("lessons", "status"): "lesson_status",
    ("lessons", "audio_status"): "audio_status",
    ("lesson_targets", "coverage_role"): "coverage_role",
    ("dialogues", "opening_initiator"): "opening_initiator",
    ("dialogue_turns", "speaker_identity_origin"): "speaker_identity_origin",
    ("dialogue_turns", "speaker_gender_evidence"): "gender",
    ("dialogue_turns", "audio_status"): "audio_status",
    ("activities", "activity_type"): "activity_type",
    ("activities", "audio_status"): "audio_status",
    ("lexemes", "lexeme_type"): "lexeme_type",
    ("lexemes", "cefr_level"): "cefr_level",
    ("lexemes", "audio_status"): "audio_status",
    ("example_sentences", "audio_status"): "audio_status",
    ("lexeme_forms", "form_type"): "lexeme_form_type",
    ("lexeme_forms", "origin"): "lexeme_form_origin",
    ("lexeme_forms", "review_status"): "review_status",
    ("lesson_lexemes", "role"): "lexeme_role",
    ("lexeme_occurrences", "owner_type"): "occurrence_owner_type",
    ("lexeme_occurrences", "resolution_status"): "resolution_status",
    ("provenance_links", "entity_type"): "provenance_entity_type",
    ("provenance_links", "transformation"): "provenance_transformation",
}
errors = []


def load(path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"{path}: invalid JSON: {exc}")
        return None


tax = load(TAXONOMY_PATH) or {}
domains = tax.get("domains", {})
unit_bounds_config = load(UNIT_BOUNDS_PATH) or {}
unit_lesson_bounds = unit_bounds_config.get("levels", {})
for level_code, rule in unit_lesson_bounds.items():
    minimum = rule.get("minLessons") if isinstance(rule, dict) else None
    maximum = rule.get("maxLessons") if isinstance(rule, dict) else None
    if not isinstance(minimum, int) or not isinstance(maximum, int) or minimum < 1 or maximum < minimum:
        errors.append(f"{UNIT_BOUNDS_PATH}: invalid lesson bounds for {level_code!r}: {rule!r}")


def require_label(domain, code, where):
    if code is None:
        return None
    table = domains.get(domain)
    if not isinstance(table, dict):
        errors.append(f"{where}: missing taxonomy domain {domain!r}")
        return None
    label = table.get(str(code))
    if not isinstance(label, str) or not label.strip():
        errors.append(f"{where}: semantic code {domain}.{code} has no Persian taxonomy label")
        return None
    if not FA.search(label):
        errors.append(f"{where}: taxonomy label for {domain}.{code} must contain Persian text: {label!r}")
    return label


for domain, values in domains.items():
    if not isinstance(values, dict) or not values:
        errors.append(f"{TAXONOMY_PATH}: taxonomy domain {domain!r} is empty/invalid")
        continue
    for code, label in values.items():
        if not isinstance(label, str) or not label.strip() or not FA.search(label):
            errors.append(f"{TAXONOMY_PATH}: {domain}.{code} needs a non-empty Persian label")

# Every semantic ENUM defined by MySQL must already have a Persian taxonomy label,
# even before a content row uses that code.
schema_text = SCHEMA_PATH.read_text(encoding="utf-8")
for table, body in re.findall(r"CREATE TABLE IF NOT EXISTS\s+(\w+)\s*\((.*?)\) ENGINE=", schema_text, flags=re.S):
    for column, enum_body in re.findall(r"^\s*(\w+)\s+ENUM\(([^)]+)\)", body, flags=re.M):
        domain = SCHEMA_ENUM_DOMAINS.get((table, column))
        if domain is None:
            errors.append(f"{SCHEMA_PATH}: enum {table}.{column} has no taxonomy-domain mapping in validator")
            continue
        for code in re.findall(r"'([^']+)'", enum_body):
            require_label(domain, code, f"{SCHEMA_PATH}:{table}.{column}")


def normalized_image_key(key):
    return re.sub(r"[_\-\s]", "", str(key)).lower()


def walk_editorial(path, value, is_source=False, loc="$."):
    if isinstance(value, dict):
        for key, child in value.items():
            here = f"{loc}{key}"
            if normalized_image_key(key) in IMAGE_KEYS:
                errors.append(f"{path}:{here}: image-bearing field is forbidden by the current baseline")
            if not is_source and key in EDITORIAL_KEYS and isinstance(child, str) and child.strip() and not FA.search(child):
                errors.append(f"{path}:{here}: assistant-authored prose must contain Persian text: {child!r}")
            if not is_source and key == "learningTargets" and isinstance(child, list):
                for i, item in enumerate(child):
                    if isinstance(item, str) and item.strip() and not FA.search(item):
                        errors.append(f"{path}:{here}[{i}]: learning target must contain Persian text")
            if not is_source and key in EDITORIAL_LIST_KEYS and isinstance(child, list):
                for i, item in enumerate(child):
                    if isinstance(item, str) and item.strip() and not FA.search(item):
                        errors.append(f"{path}:{here}[{i}]: audit/editorial text must contain Persian text")
            if not is_source and key == "coverage" and isinstance(child, dict):
                for group, items in child.items():
                    if isinstance(items, list):
                        for i, item in enumerate(items):
                            if isinstance(item, str) and item.strip() and not FA.search(item):
                                errors.append(f"{path}:{here}.{group}[{i}]: coverage/gap prose must contain Persian text")
            walk_editorial(path, child, is_source=is_source, loc=here + ".")
    elif isinstance(value, list):
        for i, child in enumerate(value):
            walk_editorial(path, child, is_source=is_source, loc=f"{loc}[{i}].")


all_json = []
characters_by_language = {}
language_manifests = {}
levels_by_language = {}
dialogues = {}
lessons = {}
cefr_order = {"Pre-A1": 0, "A1": 1, "A2": 2, "B1": 3, "B2": 4, "C1": 5, "C2": 6}

for path in CONTENT.rglob("*.json"):
    data = load(path)
    if data is None:
        continue
    all_json.append((path, data))
    walk_editorial(path, data, is_source="sources" in path.parts)
    if path.name == "language.json":
        language_manifests[data.get("id")] = (path, data)
    elif path.name == "level.json":
        levels_by_language.setdefault(data.get("languageId"), []).append((path, data))
    elif "characters" in path.parts:
        characters_by_language.setdefault(data.get("languageId"), {})[data.get("id")] = path
    elif "dialogues" in path.parts:
        dialogues[data.get("id")] = (path, data)
    elif "lessons" in path.parts:
        lessons[data.get("id")] = (path, data)

for path, data in all_json:
    parts = path.parts
    if path.name == "language.json":
        require_label("language_status", data.get("status"), path)
        policy=data.get("audioPolicy") or {}
        if policy.get("generateAfterEachLevelFinal") is not True:
            errors.append(f"{path}: audioPolicy.generateAfterEachLevelFinal must be true")
        if "generateOnlyAfterLanguageFinal" in policy:
            errors.append(f"{path}: legacy generateOnlyAfterLanguageFinal is forbidden")
        for level in data.get("supportedLevels", []) or []:
            require_label("cefr_level", level, path)
    if path.name == "level.json":
        require_label("cefr_level", data.get("level"), path)
        require_label("level_status", data.get("status"), path)
    if "units" in parts:
        require_label("unit_status", data.get("status"), path)
    if "characters" in parts:
        require_label("character_origin", data.get("origin"), path)
        require_label("gender", data.get("gender"), path)
        require_label("age_band", data.get("ageBand"), path)
    if "sources" in parts:
        require_label("source_type", data.get("sourceType"), path)
        require_label("modernity_status", data.get("modernityStatus"), path)
        require_label("reuse_status", data.get("reuseStatus"), path)
    if "lexemes" in parts:
        require_label("lexeme_type", data.get("type"), path)
        require_label("cefr_level", data.get("level"), path)
        require_label("audio_status", data.get("audioStatus"), path)
        pos = data.get("partOfSpeech")
        expected = require_label("part_of_speech", pos, path)
        actual = data.get("partOfSpeechFa")
        if pos is not None:
            if not isinstance(actual, str) or not actual.strip():
                errors.append(f"{path}: partOfSpeech={pos!r} requires partOfSpeechFa")
            elif actual != expected:
                errors.append(f"{path}: partOfSpeechFa must equal canonical taxonomy label {expected!r}; got {actual!r}")
        elif actual is not None:
            errors.append(f"{path}: partOfSpeechFa must be null/absent when partOfSpeech is null")
    if "lexeme_forms" in parts:
        require_label("lexeme_form_type", data.get("formType"), path)
        require_label("lexeme_form_origin", data.get("origin"), path)
        require_label("review_status", data.get("reviewStatus"), path)
    if "lessons" in parts:
        require_label("cefr_level", data.get("level"), path)
        require_label("lesson_status", data.get("status"), path)
        require_label("audio_status", data.get("audioStatus"), path)
        if data.get("status") == "final":
            source_title = data.get("sourceTitle")
            source_title_fa = data.get("sourceTitleFa")
            if not isinstance(source_title, str) or not source_title.strip():
                errors.append(f"{path}: finalized lesson requires a non-empty sourceTitle")
            if not isinstance(source_title_fa, str) or not source_title_fa.strip() or not FA.search(source_title_fa):
                errors.append(f"{path}: finalized lesson requires a Persian sourceTitleFa")
            if data.get("languageId") == "de" and isinstance(source_title, str):
                if FA.search(source_title):
                    errors.append(f"{path}: German sourceTitle must not contain Persian text: {source_title!r}")
                if not re.search(r"[A-Za-zÄÖÜäöüß]", source_title):
                    errors.append(f"{path}: German sourceTitle must contain German/Latin-script target text: {source_title!r}")
        activities = data.get("activities", [])
        if activities and activities[0].get("type") != "conversation_speaking":
            errors.append(f"{path}: first activity must be conversation_speaking")
        for activity in activities:
            aid = activity.get("id", "<activity>")
            require_label("activity_type", activity.get("type"), f"{path}:{aid}")
            require_label("audio_status", activity.get("audioStatus"), f"{path}:{aid}")
            initiator = (activity.get("data") or {}).get("openingInitiator")
            if initiator is not None:
                require_label("opening_initiator", initiator, f"{path}:{aid}")
            for transform in activity.get("transformations", []) or []:
                require_label("activity_transformation", transform, f"{path}:{aid}")
    if "dialogues" in parts:
        require_label("cefr_level", data.get("level"), path)
        require_label("opening_initiator", data.get("openingInitiator"), path)
        turns = data.get("turns", [])
        if not 4 <= len(turns) <= 12:
            errors.append(f"{path}: opening dialogue must contain 4–12 turns; got {len(turns)}")
        init = data.get("openingInitiator")
        if turns and init in {"app", "learner"} and bool(turns[0].get("learnerTurn")) != (init == "learner"):
            errors.append(f"{path}: openingInitiator conflicts with turn 1")
        for turn in turns:
            tid = turn.get("id", "<turn>")
            require_label("speaker_identity_origin", turn.get("speakerIdentityOrigin"), f"{path}:{tid}")
            require_label("gender", turn.get("speakerGenderEvidence"), f"{path}:{tid}")

# Manifests must enumerate the durable objects belonging to their language.
for language_id, (path, manifest) in language_manifests.items():
    actual_characters = set(characters_by_language.get(language_id, {}))
    declared_characters = set(manifest.get("characterRefs") or [])
    for missing in sorted(actual_characters - declared_characters):
        errors.append(f"{path}: character file {missing!r} exists but is missing from characterRefs")
    for unknown in sorted(declared_characters - actual_characters):
        errors.append(f"{path}: characterRefs contains unknown character {unknown!r}")
    actual_levels = {level.get("id") for _, level in levels_by_language.get(language_id, [])}
    declared_levels = set(manifest.get("levelManifestRefs") or [])
    for missing in sorted(actual_levels - declared_levels):
        errors.append(f"{path}: level manifest {missing!r} exists but is missing from levelManifestRefs")
    for unknown in sorted(declared_levels - actual_levels):
        errors.append(f"{path}: levelManifestRefs contains unknown level {unknown!r}")

# Final-level contract: explicit audit, no hidden gaps, final child lessons/units, and audio unblocked.
units_by_id={}
for path,data in all_json:
    if "units" in path.parts:
        units_by_id[data.get("id")]=(path,data)

# From A1 onward, a finalized unit needs enough room for introduction, focused
# practice and retrieval/application, but the upper bound prevents artificial sprawl.
for unit_id,(unit_path,unit) in units_by_id.items():
    rule=unit_lesson_bounds.get(unit.get("level"))
    if unit.get("status") != "final" or not rule:
        continue
    refs=unit.get("lessonRefs") or []
    minimum=rule["minLessons"]; maximum=rule["maxLessons"]
    if not minimum <= len(refs) <= maximum:
        errors.append(f"{unit_path}: final {unit.get('level')} unit must contain {minimum}–{maximum} lessons; got {len(refs)}")
    for lesson_id in refs:
        entry=lessons.get(lesson_id)
        if not entry:
            errors.append(f"{unit_path}: lessonRefs contains missing lesson {lesson_id!r}")
            continue
        lesson_path,lesson=entry
        if lesson.get("unitRef") != unit_id:
            errors.append(f"{lesson_path}: unitRef {lesson.get('unitRef')!r} does not match owning unit {unit_id!r}")

for language_id, manifests in levels_by_language.items():
    for level_path, level in manifests:
        if level.get("status") != "final":
            continue
        if (level.get("coverage") or {}).get("gaps"):
            errors.append(f"{level_path}: final level coverage.gaps must be empty")
        assessment=level.get("completionAssessment") or {}
        if assessment.get("requiredGaps"):
            errors.append(f"{level_path}: final level requiredGaps must be empty")
        if "scopeExclusions" not in assessment:
            errors.append(f"{level_path}: final level must explicitly record scopeExclusions (empty is allowed)")
        if level.get("audioStatus") == "blocked_until_level_final":
            errors.append(f"{level_path}: final level audio must no longer be blocked")
        for lesson_id in level.get("lessonRefs") or []:
            entry=lessons.get(lesson_id)
            if not entry:
                errors.append(f"{level_path}: missing lesson {lesson_id!r}")
                continue
            lesson_path,lesson=entry
            if lesson.get("status") != "final":
                errors.append(f"{lesson_path}: lesson referenced by final level must be final")
            if lesson.get("audioStatus") == "blocked_until_level_final":
                errors.append(f"{lesson_path}: final lesson audio must no longer be blocked")
        flattened_unit_lessons=[]
        for unit_id in level.get("unitRefs") or []:
            entry=units_by_id.get(unit_id)
            if not entry:
                errors.append(f"{level_path}: missing unit {unit_id!r}")
            elif entry[1].get("status") != "final":
                errors.append(f"{entry[0]}: unit referenced by final level must be final")
            else:
                flattened_unit_lessons.extend(entry[1].get("lessonRefs") or [])
        if unit_lesson_bounds.get(level.get("level")) and flattened_unit_lessons != (level.get("lessonRefs") or []):
            errors.append(f"{level_path}: lessonRefs must exactly match unit lessonRefs in unit order")

# Beginner-path exact four-turn rule derives lesson order from level manifests.
for language_id, manifests in levels_by_language.items():
    beginner_path, beginner = min(manifests, key=lambda item: cefr_order.get(item[1].get("level"), 999))
    for lesson_id in (beginner.get("lessonRefs") or [])[:10]:
        lesson_entry = lessons.get(lesson_id)
        if not lesson_entry:
            errors.append(f"{beginner_path}: missing beginner lesson {lesson_id}")
            continue
        lesson_path, lesson = lesson_entry
        activities = lesson.get("activities") or []
        if not activities or not activities[0].get("dialogueRef"):
            errors.append(f"{lesson_path}: beginner lesson has no opening dialogue")
            continue
        ref = activities[0]["dialogueRef"]
        if ref not in dialogues:
            errors.append(f"{lesson_path}: opening dialogue {ref!r} not found")
            continue
        dialogue_path, dialogue = dialogues[ref]
        count = len(dialogue.get("turns") or [])
        if count != 4:
            errors.append(f"{dialogue_path}: first ten beginner lessons require exactly 4 turns; got {count}")
        if dialogue.get("openingInitiator") == "learner" and "شروع" not in (activities[0].get("instructionFa") or ""):
            errors.append(f"{lesson_path}: learner-start opening must explicitly ask the learner to start")

# Character identity / learner-role contract.
for language_id, character_paths in characters_by_language.items():
    character_data={k:load(p) for k,p in character_paths.items()}
    for key,ch in character_data.items():
        if "learner" in set(ch.get("roles") or []): errors.append(f"{character_paths[key]}: durable characters must not use the learner role")
        for rel in ch.get("relationships") or []:
            target=rel.get("characterId"); typ=rel.get("type")
            if target==key: errors.append(f"{character_paths[key]}: relationship cannot point to itself")
            if target not in character_data: errors.append(f"{character_paths[key]}: relationship target {target!r} does not exist"); continue
            if not any(x.get("characterId")==key and x.get("type")==typ for x in (character_data[target].get("relationships") or [])):
                errors.append(f"{character_paths[key]}: relationship {typ!r} to {target!r} is not reciprocal")
for dialogue_id,(dialogue_path,dialogue) in dialogues.items():
    lang=dialogue.get("languageId"); paths=characters_by_language.get(lang,{}); refs=set(dialogue.get("characterRefs") or []); learner=dialogue.get("learnerCharacterId")
    if not learner: errors.append(f"{dialogue_path}: learnerCharacterId is required"); continue
    if learner not in refs: errors.append(f"{dialogue_path}: learnerCharacterId must be present in characterRefs")
    if learner not in paths: errors.append(f"{dialogue_path}: learnerCharacterId {learner!r} is not canonical")
    if str(learner).endswith("-learner"): errors.append(f"{dialogue_path}: generic learner persona is forbidden")
    for turn in dialogue.get("turns") or []:
        tid=turn.get("id","<turn>"); sp=turn.get("speakerCharacterId")
        if sp not in refs: errors.append(f"{dialogue_path}:{tid}: speakerCharacterId must be present in characterRefs")
        if sp not in paths: errors.append(f"{dialogue_path}:{tid}: unknown speaker {sp!r}"); continue
        if str(sp).endswith("-learner"): errors.append(f"{dialogue_path}:{tid}: generic learner persona is forbidden")
        if bool(turn.get("learnerTurn")) and sp!=learner: errors.append(f"{dialogue_path}:{tid}: learner turn must use learnerCharacterId")
        if not bool(turn.get("learnerTurn")) and sp==learner: errors.append(f"{dialogue_path}:{tid}: app turn cannot use learner-controlled character")
        ev=turn.get("speakerGenderEvidence")
        if ev in {"female","male"} and load(paths[sp]).get("gender")!=ev: errors.append(f"{dialogue_path}:{tid}: speaker gender evidence conflicts with character gender")

if errors:
    print("\n".join(errors))
    sys.exit(1)

print(f"Project contract validation passed for {len(all_json)} JSON files, all mapped MySQL ENUMs, and {sum(len(v) for v in domains.values())} Persian taxonomy labels.")
