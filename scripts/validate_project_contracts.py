#!/usr/bin/env python3
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
CONTENT = ROOT / "content"
TAXONOMY_PATH = ROOT / "config" / "fa-taxonomy.json"
FA = re.compile(r"[\u0600-\u06FF]")
IMAGE_KEYS = {
    "image", "imageurl", "imageref", "picture", "photo", "illustration",
    "thumbnail", "thumbnailurl", "thumbnailref"
}
EDITORIAL_KEYS = {
    "structureRationale", "groupingRationale", "activitySelectionRationale",
    "sequenceRationale", "selectionReason", "scenario", "sceneQualityRationale",
    "contextNotes", "notes", "instructionFa", "translationFa", "usageNoteFa",
    "titleFa", "contextFa", "promptFa", "descriptionFa", "partOfSpeechFa"
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
for path in CONTENT.rglob("*.json"):
    data = load(path)
    if data is None:
        continue
    all_json.append((path, data))
    walk_editorial(path, data, is_source="sources" in path.parts)

# Language manifests
for path, data in all_json:
    parts = path.parts
    if path.name == "language.json":
        require_label("language_status", data.get("status"), path)
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
        activities = data.get("activities", [])
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
        if turns and init in {"app", "learner"}:
            if bool(turns[0].get("learnerTurn")) != (init == "learner"):
                errors.append(f"{path}: openingInitiator conflicts with turn 1")
        for turn in turns:
            tid = turn.get("id", "<turn>")
            require_label("speaker_identity_origin", turn.get("speakerIdentityOrigin"), f"{path}:{tid}")
            require_label("gender", turn.get("speakerGenderEvidence"), f"{path}:{tid}")

# Beginner-path exact four-turn rule derives lesson order from level manifests.
dialogues = {}
lessons = {}
levels_by_language = {}
cefr_order = {"Pre-A1": 0, "A1": 1, "A2": 2, "B1": 3, "B2": 4, "C1": 5, "C2": 6}
for path, data in all_json:
    if "dialogues" in path.parts:
        dialogues[data.get("id")] = (path, data)
    elif "lessons" in path.parts:
        lessons[data.get("id")] = (path, data)
    elif path.name == "level.json":
        levels_by_language.setdefault(data.get("languageId"), []).append((path, data))

for language_id, manifests in levels_by_language.items():
    beginner_path, beginner = min(manifests, key=lambda item: cefr_order.get(item[1].get("level"), 999))
    for lesson_id in (beginner.get("lessonRefs") or [])[:10]:
        lesson_entry = lessons.get(lesson_id)
        if not lesson_entry:
            errors.append(f"{beginner_path}: missing beginner lesson {lesson_id}")
            continue
        lesson_path, lesson = lesson_entry
        activities = lesson.get("activities") or []
        if not activities or activities[0].get("type") != "conversation_speaking":
            errors.append(f"{lesson_path}: first activity must be conversation_speaking")
            continue
        ref = activities[0].get("dialogueRef")
        if ref not in dialogues:
            errors.append(f"{lesson_path}: opening dialogue {ref!r} not found")
            continue
        dialogue_path, dialogue = dialogues[ref]
        count = len(dialogue.get("turns") or [])
        if count != 4:
            errors.append(f"{dialogue_path}: first ten beginner lessons require exactly 4 turns; got {count}")
        if dialogue.get("openingInitiator") == "learner" and "شروع" not in (activities[0].get("instructionFa") or ""):
            errors.append(f"{lesson_path}: learner-start opening must explicitly ask the learner to start")

if errors:
    print("\n".join(errors))
    sys.exit(1)

print(f"Project contract validation passed for {len(all_json)} JSON files and {sum(len(v) for v in domains.values())} Persian taxonomy labels.")
