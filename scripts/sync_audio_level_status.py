#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from audio_pipeline import CONFIG_PATH, ROOT, level_slug, load_json, plan, write_json


def level_path(language: str, level: str) -> Path:
    path = ROOT / "content" / language / level_slug(language, level) / "level.json"
    if not path.exists():
        raise RuntimeError(f"Level manifest does not exist: {path.relative_to(ROOT)}")
    return path


def expected_status(audio_plan: dict) -> str:
    if audio_plan["needsGeneration"] == 0 and audio_plan["unresolvedVoices"] == 0:
        return "ready"
    if audio_plan["currentAssets"] > 0:
        return "stale"
    return "pending"


def sync_status(language: str, level: str, db: str, check: bool) -> dict:
    config = load_json(CONFIG_PATH)
    path = level_path(language, level)
    level_data = load_json(path)
    if level_data.get("status") != "final":
        raise RuntimeError(f"Audio level status is only derived for final levels: {language} {level}")

    audio_plan = plan(language, level, config, db, allow_unresolved=True)
    expected = expected_status(audio_plan)
    actual = level_data.get("audioStatus")

    summary = {
        "language": language,
        "level": level,
        "storedAudioStatus": actual,
        "expectedAudioStatus": expected,
        "totalRequired": audio_plan["totalRequired"],
        "currentAssets": audio_plan["currentAssets"],
        "needsGeneration": audio_plan["needsGeneration"],
        "unresolvedVoices": audio_plan["unresolvedVoices"],
    }

    if check:
        if actual != expected:
            raise RuntimeError(
                "Level audioStatus does not match canonical audio plan: "
                + json.dumps(summary, ensure_ascii=False)
            )
        return summary

    if actual != expected:
        level_data["audioStatus"] = expected
        write_json(path, level_data)
    return summary


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Sync aggregate level audioStatus from the canonical MySQL audio plan."
    )
    parser.add_argument("--language", required=True)
    parser.add_argument("--level", required=True)
    parser.add_argument("--db", default=os.environ.get("AUDIO_DB_NAME", "language_content_test"))
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    try:
        result = sync_status(args.language, args.level, args.db, args.check)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0
    except Exception as exc:
        print(str(exc), file=__import__("sys").stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
