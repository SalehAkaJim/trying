#!/usr/bin/env python3
import hashlib
import json
from pathlib import Path
import py_compile
import re
import sys

errors=[]
legacy=("blocked_until_language_final","pending_final_language")
for base in [Path("database"),Path("content"),Path("schemas")]:
    if not base.exists():
        continue
    for p in base.rglob("*"):
        if p.is_file() and p.suffix in {".sql",".json",".md",".sh",".py"}:
            text=p.read_text(encoding="utf-8")
            for token in legacy:
                if token in text:
                    errors.append(f"{p}: legacy audio status {token}")

for required in [
    Path('config/audio-pipeline.json'),
    Path('schemas/audio-pipeline.schema.json'),
    Path('schemas/audio-voice-lock.schema.json'),
    Path('scripts/audio_pipeline.py'),
    Path('.github/workflows/audio-generation.yml'),
    Path('docs/AUDIO_PIPELINE.md'),
]:
    if not required.exists(): errors.append(f'missing required audio pipeline file: {required}')

try:
    py_compile.compile('scripts/audio_pipeline.py', doraise=True)
except Exception as exc:
    errors.append(f'scripts/audio_pipeline.py does not compile: {exc}')

config=json.loads(Path('config/audio-pipeline.json').read_text(encoding='utf-8'))
if config.get('apiKeyEnv')!='ELEVENLABS_API_KEY': errors.append('audio API key env must remain ELEVENLABS_API_KEY')
if config.get('generation',{}).get('requirePaidGenerationConfirmation') is not True: errors.append('paid generation confirmation must remain mandatory')
if config.get('storageRoot')!='audio': errors.append('audio storageRoot must be audio')
if config.get('mappingRoot')!='database/audio': errors.append('audio mappingRoot must be database/audio')
if config.get('voiceResolution',{}).get('learnerUsesStandaloneVoice') is not False: errors.append('learner dialogue turns must never inherit the standalone voice')
for pth in Path('content').glob('*/characters/*.json'):
    d=json.loads(pth.read_text(encoding='utf-8'))
    if 'learner' in set(d.get('roles') or []): errors.append(f'{pth}: durable learner persona is forbidden')

for p in Path("content").glob("*/*/lessons/*.json"):
    data=json.loads(p.read_text(encoding="utf-8"))
    for i,a in enumerate(data.get("activities", []),1):
        status=a.get("audioStatus")
        audio_text=a.get("audioTextTarget")
        has_audio=isinstance(audio_text,str) and bool(audio_text.strip())
        if not has_audio and status != "not_required": errors.append(f"{p}: activity {i} has no audioTextTarget and must use audioStatus=not_required")
        if has_audio and status == "not_required": errors.append(f"{p}: activity {i} has audioTextTarget but audioStatus=not_required")
        if a.get("type") in {"listen_choose","listen_repeat","pronunciation_read"} and not has_audio: errors.append(f"{p}: audio-dependent activity {i} ({a.get('type')}) requires audioTextTarget")

for p in Path("database/content").rglob("*.sql"):
    text=p.read_text(encoding="utf-8")
    if "DELETE FROM dialogue_turns WHERE" in text and "AND turn_key NOT IN" not in text: errors.append(f"{p}: destructive dialogue_turn re-import can break audio linkage")
    if "audio_status=VALUES(audio_status)" in text: errors.append(f"{p}: base content must not overwrite generated audio status")

schema=Path("database/schema.sql").read_text(encoding="utf-8")
for required in ["v_audio_generation_manifest","audio_storage_path","audio_source_hash","audio_generated_at","blocked_until_level_final"]:
    if required not in schema: errors.append(f"database/schema.sql missing {required}")

levels={}
for pth in Path("content").glob("*/*/level.json"):
    d=json.loads(pth.read_text(encoding="utf-8")); levels[(d.get("languageId"),d.get("level"))]=d
for pth in Path("content").glob("*/language.json"):
    d=json.loads(pth.read_text(encoding="utf-8")); policy=d.get("audioPolicy") or {}
    if policy.get("generateAfterEachLevelFinal") is not True: errors.append(f"{pth}: generateAfterEachLevelFinal must be true")
    if "generateOnlyAfterLanguageFinal" in policy: errors.append(f"{pth}: legacy generateOnlyAfterLanguageFinal is forbidden")
for pth in Path("content").glob("*/*/lessons/*.json"):
    d=json.loads(pth.read_text(encoding="utf-8"))
    if (levels.get((d.get("languageId"),d.get("level"))) or {}).get("status")=="final":
        if d.get("audioStatus")=="blocked_until_level_final": errors.append(f"{pth}: final-level lesson audio remains blocked")
        for a in d.get("activities",[]):
            if a.get("audioTextTarget") and a.get("audioStatus")=="blocked_until_level_final": errors.append(f"{pth}:{a.get('id')}: final-level activity audio remains blocked")
for pth in Path("content").glob("*/lexemes/*.json"):
    d=json.loads(pth.read_text(encoding="utf-8"))
    if (levels.get((d.get("languageId"),d.get("level"))) or {}).get("status")=="final" and d.get("audioStatus")=="blocked_until_level_final": errors.append(f"{pth}: final-level lexeme audio remains blocked")

# Voice locks, when present, must match the canonical cast, have provider SQL,
# preserve gender compatibility, and have no duplicate conversation voice IDs.
for lock_path in Path('config/audio-voice-locks').glob('*.json'):
    lock=json.loads(lock_path.read_text(encoding='utf-8'))
    language=lock.get('language')
    voice_sql=Path('database/audio')/str(language)/'voices.sql'
    if not voice_sql.exists(): errors.append(f'{lock_path}: missing {voice_sql}')
    locked=lock.get('characters') or {}
    char_dir=Path('content')/str(language)/'characters'
    canonical={}
    for cp in char_dir.glob('*.json'):
        cd=json.loads(cp.read_text(encoding='utf-8')); canonical[cd.get('id')]=cd
    if set(locked) != set(canonical):
        errors.append(f'{lock_path}: locked character keys must equal canonical cast; locked={sorted(locked)} canonical={sorted(canonical)}')
    ids=[]
    for key,rec in locked.items():
        if rec.get('strategy')=='standalone_inherited': errors.append(f'{lock_path}: standalone-inherited learner voice is forbidden for {key}')
        ids.append((key,rec.get('voiceId')))
        ch=canonical.get(key) or {}
        wanted=str((ch.get('voiceProfile') or {}).get('genderImpression') or ch.get('gender') or '').lower()
        actual=str(((rec.get('providerMetadata') or {}).get('labels') or {}).get('gender') or '').lower()
        if wanted in {'female','male'} and actual != wanted:
            errors.append(f'{lock_path}: voice gender {actual!r} conflicts with {key} gender {wanted!r}')
    seen={}
    for key,vid in ids:
        if vid in seen: errors.append(f'{lock_path}: duplicate non-learner conversation voice {vid} for {seen[vid]} and {key}')
        seen[vid]=key

# Committed generated manifests are release artifacts. They must be physically
# valid, current, and aligned with the current canonical voice lock.
def _audio_file_sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

for manifest_path in Path("audio").glob("*/*/manifest.json"):
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"{manifest_path}: invalid manifest JSON: {exc}")
        continue
    assets = manifest.get("assets") or []
    if manifest.get("assetCount") != len(assets):
        errors.append(f"{manifest_path}: assetCount does not match assets length")
    language = manifest.get("language")
    lock_path = Path("config/audio-voice-locks") / f"{language}.json"
    lock = json.loads(lock_path.read_text(encoding="utf-8")) if lock_path.exists() else None
    if not lock:
        errors.append(f"{manifest_path}: missing canonical voice lock {lock_path}")
        continue
    for asset in assets:
        owner = asset.get("ownerKey")
        rel = asset.get("path")
        p = Path(str(rel or ""))
        if not rel or not p.is_file():
            errors.append(f"{manifest_path}:{owner}: missing generated audio file {rel!r}")
        else:
            if _audio_file_sha256(p) != asset.get("audioSha256"):
                errors.append(f"{manifest_path}:{owner}: generated audio SHA mismatch")
            if p.stat().st_size != asset.get("byteSize"):
                errors.append(f"{manifest_path}:{owner}: generated audio byte size mismatch")
        expected_text_hash = hashlib.sha256(str(asset.get("audioText") or "").encode("utf-8")).hexdigest()
        if expected_text_hash != asset.get("expectedSourceHash"):
            errors.append(f"{manifest_path}:{owner}: source text hash mismatch")
        if asset.get("audioStatus") != "ready" or asset.get("audioIsCurrent") is not True or asset.get("needsGeneration") is not False:
            errors.append(f"{manifest_path}:{owner}: committed generated asset is not ready/current")
        if asset.get("audioUrl") != asset.get("publicUrl") or asset.get("audioStoragePath") != asset.get("path"):
            errors.append(f"{manifest_path}:{owner}: generated URL/storage metadata is inconsistent")
        assignment = asset.get("voiceAssignmentKey")
        expected_voice = lock.get("standalone") if assignment == "standalone" else (lock.get("characters") or {}).get(assignment)
        if not expected_voice:
            errors.append(f"{manifest_path}:{owner}: no canonical voice for {assignment!r}")
        elif asset.get("voiceId") != expected_voice.get("voiceId") or asset.get("voiceName") != expected_voice.get("voiceName"):
            errors.append(f"{manifest_path}:{owner}: generated voice does not match canonical voice lock")


# Authoring metadata must agree with committed generated assets whenever the
# authoring target still matches the generated text. A changed target is a
# legitimate stale state; a matching ready asset paired with pending/stale
# authoring metadata is drift and must fail validation.
authoring_lessons = {}
authoring_activities = {}
authoring_dialogues = {}
authoring_dialogue_turns = {}
authoring_lexemes = {}

for lesson_path in Path("content").glob("*/*/lessons/*.json"):
    lesson = json.loads(lesson_path.read_text(encoding="utf-8"))
    key = (lesson.get("languageId"), lesson.get("level"))
    authoring_lessons.setdefault(key, []).append((lesson_path, lesson))
    for activity in lesson.get("activities") or []:
        activity_id = activity.get("id")
        if activity_id:
            authoring_activities[(key[0], key[1], activity_id)] = (lesson_path, activity)

for dialogue_path in Path("content").glob("*/*/dialogues/*.json"):
    dialogue = json.loads(dialogue_path.read_text(encoding="utf-8"))
    key = (dialogue.get("languageId"), dialogue.get("level"))
    dialogue_id = dialogue.get("id")
    if dialogue_id:
        authoring_dialogues[(key[0], key[1], dialogue_id)] = (dialogue_path, dialogue)
    for turn in dialogue.get("turns") or []:
        turn_id = turn.get("id")
        if turn_id:
            authoring_dialogue_turns[(key[0], key[1], turn_id)] = (dialogue_path, turn)

for lexeme_path in Path("content").glob("*/lexemes/*.json"):
    lexeme = json.loads(lexeme_path.read_text(encoding="utf-8"))
    lexeme_id = lexeme.get("id")
    if lexeme_id:
        authoring_lexemes[(lexeme.get("languageId"), lexeme_id)] = (lexeme_path, lexeme)

manifests_by_level = {}
global_lexeme_assets = {}
for manifest_path in Path("audio").glob("*/*/manifest.json"):
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    language = manifest.get("language")
    level = manifest.get("level")
    asset_map = {}
    for asset in manifest.get("assets") or []:
        owner_type = asset.get("ownerType")
        owner_key = asset.get("ownerKey")
        if owner_type and owner_key:
            asset_map[(owner_type, owner_key)] = asset
        if owner_type == "lexeme" and owner_key:
            global_lexeme_assets.setdefault((language, owner_key), []).append(asset)
    manifests_by_level[(language, level)] = (manifest_path, asset_map)

    for (owner_type, owner_key), asset in asset_map.items():
        if owner_type == "activity":
            rec = authoring_activities.get((language, level, owner_key))
            if not rec:
                errors.append(f"{manifest_path}:{owner_key}: generated activity has no authoring activity")
                continue
            activity_path, activity = rec
            authoring_text = activity.get("audioTextTarget")
            if authoring_text == asset.get("audioText") and activity.get("audioStatus") != "ready":
                errors.append(
                    f"{activity_path}:{owner_key}: matching current generated activity audio exists but authoring audioStatus is {activity.get('audioStatus')!r}, expected 'ready'"
                )
        elif owner_type == "dialogue_turn":
            rec = authoring_dialogue_turns.get((language, level, owner_key))
            if not rec:
                errors.append(f"{manifest_path}:{owner_key}: generated dialogue turn has no authoring turn")
        elif owner_type == "lexeme":
            rec = authoring_lexemes.get((language, owner_key))
            if not rec:
                errors.append(f"{manifest_path}:{owner_key}: generated lexeme has no authoring lexeme")
                continue
            lexeme_path, lexeme = rec
            if lexeme.get("surface") == asset.get("audioText") and lexeme.get("audioStatus") != "ready":
                errors.append(
                    f"{lexeme_path}:{owner_key}: matching current generated lexeme audio exists but authoring audioStatus is {lexeme.get('audioStatus')!r}, expected 'ready'"
                )

# Ready authoring records must always have an exact current generated asset.
# Lexemes are global and can be reused across levels, so their reverse lookup is
# language-wide; activities and dialogue turns remain level-scoped.
for (language, level, activity_id), (activity_path, activity) in authoring_activities.items():
    if activity.get("audioStatus") != "ready":
        continue
    manifest_rec = manifests_by_level.get((language, level))
    asset = manifest_rec[1].get(("activity", activity_id)) if manifest_rec else None
    if not asset or asset.get("audioText") != activity.get("audioTextTarget"):
        errors.append(f"{activity_path}:{activity_id}: authoring activity is ready without an exact current generated asset")

for (language, lexeme_id), (lexeme_path, lexeme) in authoring_lexemes.items():
    if lexeme.get("audioStatus") != "ready":
        continue
    candidates = global_lexeme_assets.get((language, lexeme_id)) or []
    if not any(asset.get("audioText") == lexeme.get("surface") for asset in candidates):
        errors.append(f"{lexeme_path}:{lexeme_id}: authoring lexeme is ready without an exact current generated asset")

# Lesson readiness is derived from exact current activity and opening-dialogue
# assets. This catches aggregate drift without blocking a legitimate stale state.
for (language, level), lessons in authoring_lessons.items():
    manifest_rec = manifests_by_level.get((language, level))
    if not manifest_rec:
        continue
    _, asset_map = manifest_rec
    for lesson_path, lesson in lessons:
        if lesson.get("status") != "final":
            continue
        required_audio_found = False
        all_ready = True
        for activity in lesson.get("activities") or []:
            audio_text = activity.get("audioTextTarget")
            if isinstance(audio_text, str) and audio_text.strip():
                required_audio_found = True
                asset = asset_map.get(("activity", activity.get("id")))
                if not asset or asset.get("audioText") != audio_text:
                    all_ready = False
            if activity.get("type") == "conversation_speaking" and activity.get("dialogueRef"):
                dialogue_rec = authoring_dialogues.get((language, level, activity.get("dialogueRef")))
                if not dialogue_rec:
                    all_ready = False
                    continue
                _, dialogue = dialogue_rec
                for turn in dialogue.get("turns") or []:
                    turn_text = turn.get("textTarget")
                    turn_id = turn.get("id")
                    if isinstance(turn_text, str) and turn_text.strip() and turn_id:
                        required_audio_found = True
                        asset = asset_map.get(("dialogue_turn", turn_id))
                        if not asset or asset.get("audioText") != turn_text:
                            all_ready = False
        expected_ready = required_audio_found and all_ready
        if expected_ready and lesson.get("audioStatus") != "ready":
            errors.append(
                f"{lesson_path}: every required current asset exists but lesson audioStatus is {lesson.get('audioStatus')!r}, expected 'ready'"
            )
        if lesson.get("audioStatus") == "ready" and not expected_ready:
            errors.append(f"{lesson_path}: lesson claims ready but at least one required exact current asset is missing")


if errors:
    print("Audio contract validation failed:")
    print("\n".join(errors))
    sys.exit(1)
print("Audio contract validation passed.")
