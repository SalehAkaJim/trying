#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import urllib.parse
from collections import defaultdict, deque

import audio_pipeline as ap


def fetch_history(config: dict, api_key: str, after_unix: int, before_unix: int) -> list[dict]:
    base = config["baseUrl"].rstrip("/")
    params = {
        "page_size": "1000",
        "date_after_unix": str(after_unix),
        "date_before_unix": str(before_unix),
        "sort_direction": "asc",
        "source": "TTS",
    }
    url = base + "/v1/history?" + urllib.parse.urlencode(params)
    payload = json.loads(ap.api_request(
        url,
        api_key,
        timeout=int(config["generation"]["timeoutSeconds"]),
        max_retries=int(config["generation"]["maxRetries"]),
    ).decode("utf-8"))
    history = payload.get("history") or []
    if payload.get("has_more"):
        raise RuntimeError("Recovery window returned more than 1000 history items; narrow the time window")
    return history


def build_safe_mapping(language: str, level: str, assets: list[dict], config: dict, generated_at_sql: str) -> None:
    path = ap.mapping_sql_path(language, level)
    path.parent.mkdir(parents=True, exist_ok=True)
    temp = "_audio_recovery_lesson_status"
    lines = [
        "-- Generated audio asset mapping. Do not hand-edit.",
        "SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;",
        "START TRANSACTION;",
        f"DROP TEMPORARY TABLE IF EXISTS {temp};",
        f"CREATE TEMPORARY TABLE {temp} AS",
        "SELECT l.id AS lesson_id,l.status AS original_status",
        "FROM lessons l",
        "JOIN language_levels ll ON ll.id=l.language_level_id",
        "JOIN languages lang ON lang.id=ll.language_id",
        f"WHERE lang.code={ap.sql_quote(language)} AND ll.cefr_level={ap.sql_quote(level)};",
        "UPDATE lessons l",
        f"JOIN {temp} b ON b.lesson_id=l.id",
        "SET l.status='qa'",
        "WHERE b.original_status='final';",
    ]
    for asset in assets:
        lines.append(ap.mapping_update(
            asset,
            url=asset["publicUrl"],
            storage_path=asset["path"],
            voice_name=asset["voiceName"],
            voice_id=asset["voiceId"],
            generated_at_sql=generated_at_sql,
            config=config,
        ))
    lines += [
        "UPDATE lessons l",
        f"JOIN {temp} b ON b.lesson_id=l.id",
        "SET l.status=b.original_status;",
        "UPDATE language_levels ll JOIN languages lang ON lang.id=ll.language_id",
        "SET ll.audio_status=IF(NOT EXISTS (",
        "  SELECT 1 FROM v_audio_generation_manifest m",
        "  WHERE m.language_code=lang.code AND m.cefr_level=ll.cefr_level AND m.audio_is_current<>1",
        "),'ready','pending')",
        f"WHERE lang.code={ap.sql_quote(language)} AND ll.cefr_level={ap.sql_quote(level)} AND ll.status='final';",
        "UPDATE languages lang SET lang.status='audio_ready'",
        f"WHERE lang.code={ap.sql_quote(language)} AND NOT EXISTS (SELECT 1 FROM language_levels ll WHERE ll.language_id=lang.id AND (ll.status<>'final' OR ll.audio_status<>'ready'));",
        f"DROP TEMPORARY TABLE {temp};",
        "COMMIT;",
        "",
    ]
    path.write_text("\n".join(lines), encoding="utf-8")


def recover(language: str, level: str, db: str, after_unix: int, before_unix: int) -> dict:
    config = ap.load_json(ap.CONFIG_PATH)
    api_key = os.environ.get(config["apiKeyEnv"])
    if not api_key:
        raise RuntimeError(f"Missing environment variable {config['apiKeyEnv']}")

    plan = ap.plan(language, level, config, db, allow_unresolved=False)
    required = plan["items"]
    if not required:
        raise RuntimeError("No required audio items found")

    history = fetch_history(config, api_key, after_unix, before_unix)
    usable = [
        h for h in history
        if h.get("text") is not None
        and h.get("voice_id")
        and h.get("model_id") == config["modelId"]
        and h.get("source") == "TTS"
    ]
    by_key: dict[tuple[str, str], deque[dict]] = defaultdict(deque)
    for h in usable:
        by_key[(h.get("text") or "", h.get("voice_id") or "")].append(h)

    assignments: list[tuple[dict, dict]] = []
    missing: list[str] = []
    for item in required:
        key = (item["audioText"], item["voiceId"])
        if not by_key[key]:
            missing.append(f"{item['ownerType']}:{item['ownerKey']} voice={item['voiceName']} text={item['audioText']!r}")
            continue
        assignments.append((item, by_key[key].popleft()))

    if missing:
        sample = "\n".join(missing[:20])
        raise RuntimeError(f"Could not match {len(missing)} required items to ElevenLabs history in the requested window:\n{sample}")
    if len(assignments) != len(required):
        raise RuntimeError(f"Recovery assignment mismatch: {len(assignments)} != {len(required)}")

    generated_at = dt.datetime.now(dt.timezone.utc).replace(microsecond=0)
    generated_at_sql = generated_at.strftime("%Y-%m-%d %H:%M:%S")
    base = config["baseUrl"].rstrip("/")
    assets: list[dict] = []
    for item, h in assignments:
        history_id = h["history_item_id"]
        audio = ap.api_request(
            base + "/v1/history/" + urllib.parse.quote(history_id, safe="") + "/audio",
            api_key,
            timeout=int(config["generation"]["timeoutSeconds"]),
            max_retries=int(config["generation"]["maxRetries"]),
            accept="audio/mpeg",
        )
        if not audio:
            raise RuntimeError(f"Empty history audio for {history_id}")
        path = ap.asset_path_for(item, language, level, config)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(audio)
        assets.append({
            **item,
            "path": path.relative_to(ap.ROOT).as_posix(),
            "publicUrl": ap.public_url_for(path, config),
            "audioSha256": ap.sha256_file(path),
            "byteSize": path.stat().st_size,
            "reused": True,
        })

    manifest = {
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
    ap.write_json(ap.asset_manifest_path(language, level, config), manifest)
    build_safe_mapping(language, level, assets, config, generated_at_sql)
    return {
        "language": language,
        "level": level,
        "historyItemsInWindow": len(history),
        "matchedAssets": len(assets),
        "manifest": ap.asset_manifest_path(language, level, config).relative_to(ap.ROOT).as_posix(),
        "mapping": ap.mapping_sql_path(language, level).relative_to(ap.ROOT).as_posix(),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Recover already-paid ElevenLabs TTS assets from generation history.")
    parser.add_argument("--language", required=True)
    parser.add_argument("--level", required=True)
    parser.add_argument("--db", default=os.environ.get("AUDIO_DB_NAME", "language_content_test"))
    parser.add_argument("--after-unix", required=True, type=int)
    parser.add_argument("--before-unix", required=True, type=int)
    args = parser.parse_args()
    result = recover(args.language, args.level, args.db, args.after_unix, args.before_unix)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
