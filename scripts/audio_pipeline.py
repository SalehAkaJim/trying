#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
CONFIG_PATH = ROOT / "config/audio-pipeline.json"


def load_json(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, data) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def utc_now() -> str:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def sql_quote(value: str | None) -> str:
    if value is None:
        return "NULL"
    return "'" + value.replace("\\", "\\\\").replace("'", "''") + "'"


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def mysql_base_command(db: str) -> list[str]:
    host = os.environ.get("AUDIO_DB_HOST", "127.0.0.1")
    port = os.environ.get("AUDIO_DB_PORT", "3306")
    user = os.environ.get("AUDIO_DB_USER", "root")
    password = os.environ.get("AUDIO_DB_PASSWORD", "root")
    if shutil.which("mysql"):
        return ["mysql", "-N", "-B", "-s", f"-h{host}", f"-P{port}", f"-u{user}", f"-p{password}", db]
    image = os.environ.get("AUDIO_MYSQL_IMAGE", "mysql:9.0.1")
    return [
        "docker", "run", "--rm", "--network", "host", image,
        "mysql", "-N", "-B", "-s", f"-h{host}", f"-P{port}", f"-u{user}", f"-p{password}", db,
    ]


def mysql_rows(query: str, db: str) -> list[list[str]]:
    proc = subprocess.run(mysql_base_command(db) + ["-e", query], text=True, capture_output=True)
    if proc.returncode != 0:
        raise RuntimeError(f"MySQL query failed:\n{proc.stderr}\nQuery:\n{query}")
    rows = []
    for line in proc.stdout.splitlines():
        if line.strip():
            rows.append(line.rstrip("\n").split("\t"))
    return rows


def language_manifest(language: str) -> dict:
    path = ROOT / "content" / language / "language.json"
    if not path.exists():
        raise RuntimeError(f"Missing language manifest: {path.relative_to(ROOT)}")
    return load_json(path)


def level_manifest(language: str, level: str) -> dict:
    slug = level.lower().replace("-", "-")
    candidates = [ROOT / "content" / language / slug / "level.json"]
    if level == "Pre-A1":
        candidates.insert(0, ROOT / "content" / language / "pre-a1" / "level.json")
    for path in candidates:
        if path.exists():
            return load_json(path)
    for path in (ROOT / "content" / language).glob("*/level.json"):
        data = load_json(path)
        if data.get("level") == level:
            return data
    raise RuntimeError(f"No level manifest found for {language} {level}")


def level_slug(language: str, level: str) -> str:
    for path in (ROOT / "content" / language).glob("*/level.json"):
        data = load_json(path)
        if data.get("level") == level:
            return path.parent.name
    return level.lower().replace("-", "-")


def voice_lock_path(language: str) -> Path:
    return ROOT / "config/audio-voice-locks" / f"{language}.json"


def voice_sql_path(language: str) -> Path:
    return ROOT / "database/audio" / language / "voices.sql"


def mapping_sql_path(language: str, level: str) -> Path:
    return ROOT / "database/audio" / language / f"{level_slug(language, level)}.sql"


def asset_manifest_path(language: str, level: str, config: dict) -> Path:
    return ROOT / config["storageRoot"] / language / level_slug(language, level) / "manifest.json"


def api_request(url: str, api_key: str, *, method: str = "GET", body: dict | None = None, timeout: int = 120, max_retries: int = 3) -> bytes:
    data = None
    headers = {"xi-api-key": api_key, "Accept": "application/json"}
    if body is not None:
        data = json.dumps(body, ensure_ascii=False).encode("utf-8")
        headers["Content-Type"] = "application/json"
    last_error = None
    for attempt in range(max_retries):
        try:
            req = urllib.request.Request(url, data=data, headers=headers, method=method)
            with urllib.request.urlopen(req, timeout=timeout) as response:
                return response.read()
        except urllib.error.HTTPError as exc:
            payload = exc.read().decode("utf-8", errors="replace")
            last_error = RuntimeError(f"ElevenLabs HTTP {exc.code}: {payload}")
            if exc.code not in {429, 500, 502, 503, 504}:
                raise last_error
        except (urllib.error.URLError, TimeoutError) as exc:
            last_error = RuntimeError(f"ElevenLabs request failed: {exc}")
        if attempt + 1 < max_retries:
            time.sleep(2 ** attempt)
    raise last_error or RuntimeError("ElevenLabs request failed")


def fetch_all_voices(config: dict, api_key: str) -> list[dict]:
    base = config["baseUrl"].rstrip("/")
    token = None
    voices: list[dict] = []
    while True:
        params = {"page_size": "100", "include_total_count": "false", "sort": "name", "sort_direction": "asc"}
        if token:
            params["next_page_token"] = token
        url = base + "/v2/voices?" + urllib.parse.urlencode(params)
        payload = json.loads(api_request(
            url,
            api_key,
            timeout=int(config["generation"]["timeoutSeconds"]),
            max_retries=int(config["generation"]["maxRetries"]),
        ).decode("utf-8"))
        voices.extend(payload.get("voices") or [])
        if not payload.get("has_more"):
            break
        token = payload.get("next_page_token")
        if not token:
            raise RuntimeError("ElevenLabs reported has_more without next_page_token")
    dedup = {v.get("voice_id"): v for v in voices if v.get("voice_id") and v.get("name")}
    return sorted(dedup.values(), key=lambda v: (str(v.get("name", "")).casefold(), v["voice_id"]))


def verified_for_language(voice: dict, language: str) -> bool:
    for item in voice.get("verified_languages") or []:
        code = str(item.get("language") or "").casefold()
        locale = str(item.get("locale") or "").casefold()
        if code == language.casefold() or locale == language.casefold() or locale.startswith(language.casefold() + "-"):
            return True
    labels = voice.get("labels") or {}
    label_language = str(labels.get("language") or "").casefold()
    return label_language == language.casefold() or label_language.startswith(language.casefold() + "-")


def normalize_age(value: str | None) -> str:
    v = (value or "").strip().lower().replace("_", "-").replace(" ", "-")
    aliases = {
        "young-adult": "young", "young": "young", "adult": "adult",
        "middle-aged": "middle-aged", "middle-aged-adult": "middle-aged",
        "older-adult": "old", "old": "old", "senior": "old",
        "teen": "young", "child": "young",
    }
    return aliases.get(v, v)


def score_voice(voice: dict, language: str, character: dict) -> float:
    labels = voice.get("labels") or {}
    profile = character.get("voiceProfile") or {}
    score = 0.0
    if verified_for_language(voice, language):
        score += 100.0
    gender = str(labels.get("gender") or "").lower()
    wanted_gender = str(profile.get("genderImpression") or character.get("gender") or "").lower()
    if wanted_gender in {"female", "male"}:
        score += 35.0 if gender == wanted_gender else -25.0
    wanted_age = normalize_age(profile.get("ageImpression") or character.get("ageBand"))
    voice_age = normalize_age(labels.get("age"))
    if wanted_age and voice_age:
        score += 12.0 if wanted_age == voice_age else 0.0
    if str(voice.get("recording_quality") or "").lower() == "studio":
        score += 8.0
    if str(voice.get("category") or "").lower() == "professional":
        score += 5.0
    description = (str(voice.get("description") or "") + " " + str(labels.get("description") or "")).lower()
    if any(token in description for token in ("clear", "calm", "friendly", "warm", "neutral")):
        score += 3.0
    return score


def voice_record(voice: dict, *, strategy: str, score: float | None = None, character_key: str | None = None) -> dict:
    result = {
        "voiceId": voice["voice_id"],
        "voiceName": voice["name"],
        "strategy": strategy,
        "matchScore": score,
        "providerMetadata": {
            "category": voice.get("category"),
            "labels": voice.get("labels") or {},
            "verifiedLanguages": voice.get("verified_languages") or [],
            "recordingQuality": voice.get("recording_quality"),
        },
    }
    if character_key:
        result["characterKey"] = character_key
    return result


def resolve_voices(language: str, config: dict, api_key: str) -> dict:
    manifest = language_manifest(language)
    voices = fetch_all_voices(config, api_key)
    if not voices:
        raise RuntimeError("No ElevenLabs voices are available for this account")

    by_name = {}
    for voice in voices:
        by_name.setdefault(voice["name"].casefold(), []).append(voice)

    standalone = None
    for name in (manifest.get("audioPolicy") or {}).get("standaloneVoicePreference") or []:
        candidates = by_name.get(str(name).casefold()) or []
        if candidates:
            candidates = sorted(candidates, key=lambda v: (not verified_for_language(v, language), v["voice_id"]))
            standalone = voice_record(candidates[0], strategy="preference_name", score=None)
            break
    if not standalone:
        prefs = (manifest.get("audioPolicy") or {}).get("standaloneVoicePreference") or []
        raise RuntimeError(f"None of the configured standalone voices are available in ElevenLabs: {prefs}")

    used = {standalone["voiceId"]}
    characters = {}
    character_dir = ROOT / "content" / language / "characters"
    for path in sorted(character_dir.glob("*.json")):
        character = load_json(path)
        key = character["id"]
        roles = set(character.get("roles") or [])
        profile = character.get("voiceProfile") or {}
        explicit_id = profile.get("elevenLabsVoiceId")
        explicit_name = profile.get("voiceName")

        if "learner" in roles and config["voiceResolution"].get("learnerUsesStandaloneVoice", True):
            rec = dict(standalone)
            rec["strategy"] = "standalone_inherited"
            rec["characterKey"] = key
            characters[key] = rec
            continue

        if explicit_id:
            match = next((v for v in voices if v.get("voice_id") == explicit_id), None)
            if not match:
                raise RuntimeError(f"Configured ElevenLabs voice ID for {key} is unavailable: {explicit_id}")
            rec = voice_record(match, strategy="explicit", character_key=key)
            characters[key] = rec
            used.add(rec["voiceId"])
            continue
        if explicit_name:
            matches = by_name.get(str(explicit_name).casefold()) or []
            if not matches:
                raise RuntimeError(f"Configured ElevenLabs voice name for {key} is unavailable: {explicit_name}")
            match = sorted(matches, key=lambda v: v["voice_id"])[0]
            rec = voice_record(match, strategy="explicit", character_key=key)
            characters[key] = rec
            used.add(rec["voiceId"])
            continue

        candidates = [v for v in voices if v["voice_id"] not in used]
        if not candidates:
            raise RuntimeError(f"No distinct ElevenLabs voice remains for {key}")
        scored = sorted(
            ((score_voice(v, language, character), v) for v in candidates),
            key=lambda pair: (-pair[0], str(pair[1].get("name", "")).casefold(), pair[1]["voice_id"]),
        )
        score, match = scored[0]
        rec = voice_record(match, strategy="profile_match", score=score, character_key=key)
        characters[key] = rec
        used.add(rec["voiceId"])

    new_lock = {
        "schemaVersion": "1.0.0",
        "provider": "elevenlabs",
        "language": language,
        "resolvedAt": utc_now(),
        "standalone": standalone,
        "characters": characters,
    }

    old_path = voice_lock_path(language)
    if old_path.exists():
        old = load_json(old_path)
        comparable_old = dict(old)
        comparable_new = dict(new_lock)
        comparable_old.pop("resolvedAt", None)
        comparable_new.pop("resolvedAt", None)
        if comparable_old == comparable_new:
            new_lock["resolvedAt"] = old.get("resolvedAt", new_lock["resolvedAt"])

    write_json(old_path, new_lock)
    write_voice_sql(new_lock)
    return new_lock


def write_voice_sql(lock: dict) -> Path:
    language = lock["language"]
    standalone = lock["standalone"]
    path = voice_sql_path(language)
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "-- Generated provider voice assignments. Do not hand-edit; regenerate from config/audio-voice-locks.",
        "SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;",
        "START TRANSACTION;",
        f"UPDATE languages SET standalone_audio_voice_name={sql_quote(standalone['voiceName'])}, standalone_audio_voice_id={sql_quote(standalone['voiceId'])} WHERE code={sql_quote(language)};",
    ]
    for key, rec in sorted(lock["characters"].items()):
        lines.append(
            "UPDATE characters c JOIN languages l ON l.id=c.language_id "
            f"SET c.voice_name={sql_quote(rec['voiceName'])}, c.elevenlabs_voice_id={sql_quote(rec['voiceId'])}, "
            f"c.voice_profile=JSON_SET(COALESCE(c.voice_profile,JSON_OBJECT()),'$.voiceName',{sql_quote(rec['voiceName'])},'$.elevenLabsVoiceId',{sql_quote(rec['voiceId'])}) "
            f"WHERE l.code={sql_quote(language)} AND c.character_key={sql_quote(key)};"
        )
    lines += ["COMMIT;", ""]
    path.write_text("\n".join(lines), encoding="utf-8")
    return path


def load_voice_lock(language: str) -> dict | None:
    path = voice_lock_path(language)
    return load_json(path) if path.exists() else None


def manifest_rows(language: str, level: str, db: str, lock: dict | None = None) -> list[dict]:
    rows = mysql_rows(
        "SELECT owner_type,owner_key,HEX(audio_text),expected_source_hash,"
        "COALESCE(expected_voice_name,''),COALESCE(expected_voice_id,''),audio_status,"
        "COALESCE(audio_url,''),COALESCE(audio_storage_path,''),audio_is_current "
        "FROM v_audio_generation_manifest "
        f"WHERE language_code={sql_quote(language)} AND cefr_level={sql_quote(level)} AND level_status='final' "
        "ORDER BY owner_type,owner_key;",
        db,
    )
    turn_voice_map = {
        row[0]: row[1]
        for row in mysql_rows(
            "SELECT t.turn_key,c.character_key FROM dialogue_turns t "
            "JOIN characters c ON c.id=t.speaker_character_id "
            "JOIN dialogues d ON d.id=t.dialogue_id JOIN language_levels ll ON ll.id=d.language_level_id "
            "JOIN languages l ON l.id=ll.language_id "
            f"WHERE l.code={sql_quote(language)} AND ll.cefr_level={sql_quote(level)};",
            db,
        )
    }
    out = []
    for row in rows:
        owner_type, owner_key, text_hex, expected_hash, voice_name, voice_id, audio_status, audio_url, storage_path, current = row
        text = bytes.fromhex(text_hex).decode("utf-8")
        voice_assignment_key = turn_voice_map.get(owner_key) if owner_type == "dialogue_turn" else "standalone"
        if lock:
            rec = lock["standalone"] if voice_assignment_key == "standalone" else (lock.get("characters") or {}).get(voice_assignment_key)
            if rec:
                voice_name = rec["voiceName"]
                voice_id = rec["voiceId"]
        out.append({
            "ownerType": owner_type,
            "ownerKey": owner_key,
            "audioText": text,
            "expectedSourceHash": expected_hash.lower(),
            "voiceAssignmentKey": voice_assignment_key,
            "voiceName": voice_name or None,
            "voiceId": voice_id or None,
            "audioStatus": audio_status,
            "audioUrl": audio_url or None,
            "audioStoragePath": storage_path or None,
            "audioIsCurrent": current == "1",
            "needsGeneration": current != "1",
        })
    return out


def plan(language: str, level: str, config: dict, db: str, allow_unresolved: bool) -> dict:
    level_data = level_manifest(language, level)
    if level_data.get("status") != "final":
        raise RuntimeError(f"{language} {level} is not final")
    lock = load_voice_lock(language)
    rows = manifest_rows(language, level, db, lock=lock)
    if not rows:
        raise RuntimeError(f"No required audio rows found for final level {language} {level}")
    unresolved = [r for r in rows if not r.get("voiceId")]
    if unresolved and not allow_unresolved:
        keys = ", ".join(r["ownerKey"] for r in unresolved[:10])
        raise RuntimeError(f"Voice lock is unresolved for {len(unresolved)} audio rows: {keys}")
    result = {
        "schemaVersion": "1.0.0",
        "language": language,
        "level": level,
        "levelStatus": level_data.get("status"),
        "voiceLockPresent": lock is not None,
        "totalRequired": len(rows),
        "currentAssets": sum(1 for r in rows if r["audioIsCurrent"]),
        "needsGeneration": sum(1 for r in rows if r["needsGeneration"]),
        "unresolvedVoices": len(unresolved),
        "items": rows,
    }
    build = ROOT / "build"
    build.mkdir(exist_ok=True)
    write_json(build / f"audio-plan-{language}-{level_slug(language, level)}.json", result)
    return result


def asset_path_for(item: dict, language: str, level: str, config: dict) -> Path:
    return ROOT / config["storageRoot"] / language / level_slug(language, level) / item["ownerType"] / f"{item['ownerKey']}.mp3"


def public_url_for(path: Path, config: dict) -> str:
    rel = path.relative_to(ROOT).as_posix()
    return config["publicBaseUrl"].rstrip("/") + "/" + urllib.parse.quote(rel, safe="/-_.")


def tts_audio(text: str, voice_id: str, config: dict, api_key: str) -> bytes:
    base = config["baseUrl"].rstrip("/")
    output_format = config["outputFormat"]
    url = f"{base}/v1/text-to-speech/{urllib.parse.quote(voice_id, safe='')}?" + urllib.parse.urlencode({"output_format": output_format})
    return api_request(
        url,
        api_key,
        method="POST",
        body={"text": text, "model_id": config["modelId"]},
        timeout=int(config["generation"]["timeoutSeconds"]),
        max_retries=int(config["generation"]["maxRetries"]),
    )


def mapping_update(item: dict, *, url: str, storage_path: str, voice_name: str, voice_id: str, generated_at_sql: str, config: dict) -> str:
    common = (
        "audio_status='ready',"
        f"audio_url={sql_quote(url)},audio_storage_path={sql_quote(storage_path)},"
        f"audio_source_hash={sql_quote(item['expectedSourceHash'])},audio_provider='elevenlabs',"
        f"audio_model_id={sql_quote(config['modelId'])},audio_voice_name={sql_quote(voice_name)},"
        f"audio_voice_id={sql_quote(voice_id)},audio_generated_at={sql_quote(generated_at_sql)}"
    )
    key = item["ownerKey"]
    h = item["expectedSourceHash"]
    if item["ownerType"] == "dialogue_turn":
        return f"UPDATE dialogue_turns SET {common} WHERE turn_key={sql_quote(key)} AND SHA2(text_target,256)={sql_quote(h)};"
    if item["ownerType"] == "lexeme":
        return f"UPDATE lexemes SET {common} WHERE lexeme_key={sql_quote(key)} AND SHA2(surface,256)={sql_quote(h)};"
    if item["ownerType"] == "activity":
        return f"UPDATE activities SET {common} WHERE activity_key={sql_quote(key)} AND SHA2(audio_text_target,256)={sql_quote(h)};"
    if item["ownerType"] == "example_sentence":
        return f"UPDATE example_sentences SET {common} WHERE example_key={sql_quote(key)} AND SHA2(text_target,256)={sql_quote(h)};"
    raise RuntimeError(f"Unsupported audio owner type: {item['ownerType']}")


def generate(language: str, level: str, config: dict, db: str, api_key: str, confirmed: bool) -> dict:
    if config["generation"].get("requirePaidGenerationConfirmation", True) and not confirmed:
        raise RuntimeError("Paid generation was not confirmed.")
    lock = load_voice_lock(language)
    if not lock:
        raise RuntimeError(f"Voice lock is missing: {voice_lock_path(language).relative_to(ROOT)}")
    p = plan(language, level, config, db, allow_unresolved=False)
    generated_at = dt.datetime.now(dt.timezone.utc).replace(microsecond=0)
    generated_at_sql = generated_at.strftime("%Y-%m-%d %H:%M:%S")
    assets = []
    for item in p["items"]:
        voice_id = item["voiceId"]
        voice_name = item["voiceName"]
        path = asset_path_for(item, language, level, config)
        if item["audioIsCurrent"] and path.exists():
            assets.append({
                **item,
                "path": path.relative_to(ROOT).as_posix(),
                "publicUrl": public_url_for(path, config),
                "audioSha256": sha256_file(path),
                "byteSize": path.stat().st_size,
                "reused": True,
            })
            continue
        audio = tts_audio(item["audioText"], voice_id, config, api_key)
        if not audio:
            raise RuntimeError(f"Empty ElevenLabs response for {item['ownerKey']}")
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(audio)
        assets.append({
            **item,
            "path": path.relative_to(ROOT).as_posix(),
            "publicUrl": public_url_for(path, config),
            "audioSha256": sha256_file(path),
            "byteSize": path.stat().st_size,
            "reused": False,
        })

    asset_manifest = {
        "schemaVersion": "1.0.0",
        "provider": "elevenlabs",
        "language": language,
        "level": level,
        "modelId": config["modelId"],
        "outputFormat": config["outputFormat"],
        "generatedAt": generated_at.isoformat().replace("+00:00", "Z"),
        "assetCount": len(assets),
        "assets": assets,
    }
    manifest_path = asset_manifest_path(language, level, config)
    write_json(manifest_path, asset_manifest)

    mapping_path = mapping_sql_path(language, level)
    mapping_path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "-- Generated audio asset mapping. Do not hand-edit.",
        "SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;",
        "START TRANSACTION;",
    ]
    for asset in assets:
        lines.append(mapping_update(
            asset,
            url=asset["publicUrl"],
            storage_path=asset["path"],
            voice_name=asset["voiceName"],
            voice_id=asset["voiceId"],
            generated_at_sql=generated_at_sql,
            config=config,
        ))
    lines += [
        "UPDATE language_levels ll JOIN languages lang ON lang.id=ll.language_id",
        "SET ll.audio_status=IF(NOT EXISTS (",
        "  SELECT 1 FROM v_audio_generation_manifest m",
        "  WHERE m.language_code=lang.code AND m.cefr_level=ll.cefr_level AND m.audio_is_current<>1",
        "),'ready','pending')",
        f"WHERE lang.code={sql_quote(language)} AND ll.cefr_level={sql_quote(level)} AND ll.status='final';",
        "UPDATE languages lang SET lang.status='audio_ready'",
        f"WHERE lang.code={sql_quote(language)} AND NOT EXISTS (SELECT 1 FROM language_levels ll WHERE ll.language_id=lang.id AND (ll.status<>'final' OR ll.audio_status<>'ready'));",
        "COMMIT;",
        "",
    ]
    mapping_path.write_text("\n".join(lines), encoding="utf-8")
    return asset_manifest


def validate_assets(language: str, level: str, config: dict) -> dict:
    manifest_path = asset_manifest_path(language, level, config)
    if not manifest_path.exists():
        raise RuntimeError(f"Asset manifest does not exist: {manifest_path.relative_to(ROOT)}")
    data = load_json(manifest_path)
    errors = []
    seen = set()
    for asset in data.get("assets") or []:
        key = (asset.get("ownerType"), asset.get("ownerKey"))
        if key in seen:
            errors.append(f"duplicate asset key: {key}")
        seen.add(key)
        path = ROOT / str(asset.get("path") or "")
        if not path.is_file():
            errors.append(f"missing file: {asset.get('path')}")
            continue
        actual = sha256_file(path)
        if actual != asset.get("audioSha256"):
            errors.append(f"audio file hash mismatch: {asset.get('path')}")
        if path.stat().st_size != asset.get("byteSize"):
            errors.append(f"audio byte size mismatch: {asset.get('path')}")
        if sha256_text(asset.get("audioText") or "") != asset.get("expectedSourceHash"):
            errors.append(f"source text hash mismatch: {asset.get('ownerKey')}")
        if not asset.get("voiceId") or not asset.get("voiceName"):
            errors.append(f"missing voice assignment: {asset.get('ownerKey')}")
    if not mapping_sql_path(language, level).exists():
        errors.append(f"missing SQL mapping: {mapping_sql_path(language, level).relative_to(ROOT)}")
    if errors:
        raise RuntimeError("Audio asset validation failed:\n" + "\n".join(errors))
    return {"assetCount": len(seen), "manifest": manifest_path.relative_to(ROOT).as_posix()}


def main() -> int:
    parser = argparse.ArgumentParser(description="Provider-independent curriculum audio pipeline with ElevenLabs implementation.")
    parser.add_argument("command", choices=["plan", "resolve-voices", "generate", "validate-assets"])
    parser.add_argument("--language", required=True)
    parser.add_argument("--level", required=False, default="Pre-A1")
    parser.add_argument("--db", default=os.environ.get("AUDIO_DB_NAME", "language_content_test"))
    parser.add_argument("--allow-unresolved-voices", action="store_true")
    parser.add_argument("--confirm-paid-generation", action="store_true")
    args = parser.parse_args()

    config = load_json(CONFIG_PATH)
    api_key = os.environ.get(config["apiKeyEnv"], "")

    try:
        if args.command == "resolve-voices":
            if not api_key:
                raise RuntimeError(f"Missing required environment secret: {config['apiKeyEnv']}")
            lock = resolve_voices(args.language, config, api_key)
            print(json.dumps({
                "language": args.language,
                "standalone": lock["standalone"],
                "characters": {k: {"voiceId": v["voiceId"], "voiceName": v["voiceName"], "strategy": v["strategy"]} for k, v in lock["characters"].items()},
            }, ensure_ascii=False, indent=2))
            return 0
        if args.command == "plan":
            result = plan(args.language, args.level, config, args.db, args.allow_unresolved_voices)
            print(json.dumps({k: result[k] for k in ("language", "level", "totalRequired", "currentAssets", "needsGeneration", "unresolvedVoices", "voiceLockPresent")}, ensure_ascii=False, indent=2))
            return 0
        if args.command == "generate":
            if not api_key:
                raise RuntimeError(f"Missing required environment secret: {config['apiKeyEnv']}")
            result = generate(args.language, args.level, config, args.db, api_key, args.confirm_paid_generation)
            print(json.dumps({"language": args.language, "level": args.level, "assetCount": result["assetCount"]}, ensure_ascii=False, indent=2))
            return 0
        if args.command == "validate-assets":
            result = validate_assets(args.language, args.level, config)
            print(json.dumps(result, ensure_ascii=False, indent=2))
            return 0
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
