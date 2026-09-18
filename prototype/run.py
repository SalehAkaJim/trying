#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import mimetypes
import threading
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlparse

PROTOTYPE_DIR = Path(__file__).resolve().parent
REPO_ROOT = PROTOTYPE_DIR.parent
CONTENT_ROOT = REPO_ROOT / "content"
AUDIO_ROOT = REPO_ROOT / "audio"


def read_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def index_json(directory: Path):
    result = {}
    errors = []
    if not directory.exists():
        return result, errors

    for path in sorted(directory.glob("*.json")):
        try:
            item = read_json(path)
        except (OSError, json.JSONDecodeError) as exc:
            errors.append(f"{path.name}: {exc}")
            continue

        item_id = item.get("id")
        if not item_id:
            errors.append(f"{path.name}: missing id")
            continue
        if item_id in result:
            errors.append(f"{path.name}: duplicate id {item_id}")
            continue
        result[item_id] = item

    return result, errors


def ordered_unique(values):
    seen = set()
    result = []
    for value in values:
        if value and value not in seen:
            seen.add(value)
            result.append(value)
    return result


def build_level_units(manifest, lessons, units):
    """Build unit groups without silently dropping lessons."""

    manifest_lesson_refs = ordered_unique(manifest.get("lessonRefs", []))
    missing_manifest_refs = [lesson_id for lesson_id in manifest_lesson_refs if lesson_id not in lessons]
    if missing_manifest_refs:
        raise ValueError(
            f"{manifest.get('id', 'level')} references lesson(s) that could not be loaded: "
            + ", ".join(missing_manifest_refs)
        )

    lesson_order = list(manifest_lesson_refs)
    for lesson_id in lessons:
        if lesson_id not in lesson_order:
            lesson_order.append(lesson_id)

    manifest_unit_refs = ordered_unique(manifest.get("unitRefs", []))
    unit_order = list(manifest_unit_refs)
    for unit_id in units:
        if unit_id not in unit_order:
            unit_order.append(unit_id)

    buckets = {unit_id: [] for unit_id in unit_order if unit_id in units}
    ungrouped = []

    unit_for_lesson = {}
    for unit_id in unit_order:
        unit = units.get(unit_id)
        if not unit:
            continue
        for lesson_id in unit.get("lessonRefs", []):
            unit_for_lesson.setdefault(lesson_id, unit_id)

    for lesson_id in lesson_order:
        lesson = lessons.get(lesson_id)
        if not lesson:
            continue

        unit_id = lesson.get("unitRef") or unit_for_lesson.get(lesson_id)
        if unit_id in buckets:
            buckets[unit_id].append(lesson)
        else:
            ungrouped.append(lesson)

    ordered_units = []
    for unit_id in unit_order:
        unit = units.get(unit_id)
        if not unit:
            continue
        ordered_units.append({"unit": unit, "lessons": buckets.get(unit_id, [])})

    if ungrouped:
        ordered_units.append({
            "unit": {
                "id": f"{manifest.get('id', 'level')}-ungrouped",
                "titleFa": "درس‌های دیگر",
                "lessonRefs": [lesson.get("id") for lesson in ungrouped],
            },
            "lessons": ungrouped,
        })

    loaded_ids = [
        lesson.get("id")
        for group in ordered_units
        for lesson in group.get("lessons", [])
        if lesson.get("id")
    ]

    if len(loaded_ids) != len(lessons) or set(loaded_ids) != set(lessons):
        missing = sorted(set(lessons) - set(loaded_ids))
        duplicates = sorted({item for item in loaded_ids if loaded_ids.count(item) > 1})
        details = []
        if missing:
            details.append("not grouped: " + ", ".join(missing))
        if duplicates:
            details.append("grouped more than once: " + ", ".join(duplicates))
        raise ValueError(
            f"Incomplete lesson grouping for {manifest.get('id', 'level')}: "
            + ("; ".join(details) or "lesson count mismatch")
        )

    return ordered_units, {
        "manifestLessonCount": len(manifest_lesson_refs),
        "loadedLessonCount": len(loaded_ids),
        "discoveredLessonCount": len(lessons),
        "unitCount": len(ordered_units),
        "lessonIds": loaded_ids,
    }


def load_audio_assets(language_code: str, level_slug: str):
    manifest_path = AUDIO_ROOT / language_code / level_slug / "manifest.json"
    if not manifest_path.exists():
        return {}, {
            "manifestFound": False,
            "assetCount": 0,
            "availableAssetCount": 0,
            "missingAssetCount": 0,
        }

    manifest = read_json(manifest_path)
    assets = {}
    available_count = 0
    missing_count = 0

    for raw_asset in manifest.get("assets", []):
        owner_key = raw_asset.get("ownerKey")
        owner_type = raw_asset.get("ownerType")
        relative_path = raw_asset.get("path") or raw_asset.get("audioStoragePath")
        if not owner_key or not relative_path:
            continue

        file_path = (REPO_ROOT / relative_path).resolve()
        try:
            file_path.relative_to(AUDIO_ROOT.resolve())
        except ValueError:
            continue

        file_exists = file_path.is_file()
        is_ready = raw_asset.get("audioStatus") == "ready"
        is_current = raw_asset.get("audioIsCurrent") is True
        needs_generation = raw_asset.get("needsGeneration") is True
        available = file_exists and is_ready and is_current and not needs_generation

        if available:
            available_count += 1
        else:
            missing_count += 1

        asset = dict(raw_asset)
        asset["fileExists"] = file_exists
        asset["available"] = available
        asset["localUrl"] = "/" + relative_path.replace("\\", "/") if available else None
        asset["effectiveUrl"] = asset["localUrl"] if available else None
        assets[f"{owner_type}:{owner_key}"] = asset
        assets.setdefault(owner_key, asset)

    return assets, {
        "manifestFound": True,
        "provider": manifest.get("provider"),
        "modelId": manifest.get("modelId"),
        "generatedAt": manifest.get("generatedAt"),
        "assetCount": manifest.get("assetCount", len(manifest.get("assets", []))),
        "availableAssetCount": available_count,
        "missingAssetCount": missing_count,
    }


def apply_audio_asset(item, asset):
    if not item or not asset:
        return
    item["audioUrl"] = asset.get("effectiveUrl")
    item["audioStatus"] = "ready" if asset.get("available") else item.get("audioStatus", "pending")
    item["audioStoragePath"] = asset.get("path") or asset.get("audioStoragePath")
    item["audioVoiceName"] = asset.get("voiceName")
    item["audioProvider"] = asset.get("provider") or "elevenlabs"
    item["audioAvailable"] = bool(asset.get("available"))


def enrich_level_audio(lessons, dialogues, lexemes, audio_assets):
    for lesson in lessons.values():
        for activity in lesson.get("activities") or []:
            activity_id = activity.get("id")
            apply_audio_asset(activity, audio_assets.get(f"activity:{activity_id}") or audio_assets.get(activity_id))

    for dialogue in dialogues.values():
        for turn in dialogue.get("turns") or []:
            turn_id = turn.get("id")
            apply_audio_asset(turn, audio_assets.get(f"dialogue_turn:{turn_id}") or audio_assets.get(turn_id))

    for lexeme_id, lexeme in lexemes.items():
        apply_audio_asset(lexeme, audio_assets.get(f"lexeme:{lexeme_id}") or audio_assets.get(lexeme_id))


def build_language_bundle(language_code: str):
    language_dir = CONTENT_ROOT / language_code
    language_file = language_dir / "language.json"
    if not language_file.exists():
        raise FileNotFoundError(f"Unknown language: {language_code}")

    language = read_json(language_file)
    lexemes, lexeme_errors = index_json(language_dir / "lexemes")
    lexeme_forms, lexeme_form_errors = index_json(language_dir / "lexeme_forms")
    characters, character_errors = index_json(language_dir / "characters")

    levels = []
    total_lessons = 0
    total_activities = 0
    diagnostics = []
    all_audio_assets = {}
    total_audio_assets = 0
    available_audio_assets = 0

    for level_file in sorted(language_dir.glob("*/level.json")):
        level_dir = level_file.parent
        manifest = read_json(level_file)
        lessons, lesson_errors = index_json(level_dir / "lessons")
        units, unit_errors = index_json(level_dir / "units")
        dialogues, dialogue_errors = index_json(level_dir / "dialogues")

        parse_errors = lesson_errors + unit_errors + dialogue_errors
        if parse_errors:
            raise ValueError(
                f"Could not fully load {manifest.get('id', level_dir.name)} content: "
                + " | ".join(parse_errors)
            )

        audio_assets, audio_meta = load_audio_assets(language_code, level_dir.name)
        enrich_level_audio(lessons, dialogues, lexemes, audio_assets)
        for key, asset in audio_assets.items():
            if ":" in key:
                all_audio_assets[key] = asset
        total_audio_assets += int(audio_meta.get("assetCount") or 0)
        available_audio_assets += int(audio_meta.get("availableAssetCount") or 0)

        ordered_units, level_diagnostics = build_level_units(manifest, lessons, units)
        total_lessons += level_diagnostics["loadedLessonCount"]
        total_activities += sum(
            len(lesson.get("activities") or [])
            for lesson in lessons.values()
        )
        diagnostics.append({
            "levelId": manifest.get("id", level_dir.name),
            **level_diagnostics,
            "audio": audio_meta,
        })

        levels.append({
            "manifest": manifest,
            "units": ordered_units,
            "dialogues": dialogues,
            "meta": {**level_diagnostics, "audio": audio_meta},
        })

    global_parse_errors = lexeme_errors + lexeme_form_errors + character_errors
    if global_parse_errors:
        raise ValueError("Could not fully load language support data: " + " | ".join(global_parse_errors))

    return {
        "language": language,
        "levels": levels,
        "lexemes": lexemes,
        "lexemeForms": lexeme_forms,
        "characters": characters,
        "audioAssets": all_audio_assets,
        "meta": {
            "source": str(CONTENT_ROOT.relative_to(REPO_ROOT)),
            "dynamic": True,
            "lessonCount": total_lessons,
            "activityCount": total_activities,
            "audioAssetCount": total_audio_assets,
            "availableAudioAssetCount": available_audio_assets,
            "levels": diagnostics,
        },
    }


def list_languages():
    items = []
    if not CONTENT_ROOT.exists():
        return items
    for path in sorted(CONTENT_ROOT.iterdir()):
        if not path.is_dir() or not (path / "language.json").exists():
            continue
        try:
            data = read_json(path / "language.json")
        except (OSError, json.JSONDecodeError):
            continue
        items.append({
            "id": data.get("id", path.name),
            "code": data.get("code", path.name),
            "nameFa": data.get("nameFa", path.name),
            "nameNative": data.get("nameNative", path.name),
            "status": data.get("status"),
        })
    return items


class PrototypeHandler(BaseHTTPRequestHandler):
    server_version = "NovaPrototype/1.3"

    def log_message(self, fmt, *args):
        print(f"[prototype] {self.address_string()} - {fmt % args}")

    def send_json(self, payload, status=200):
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def send_static(self, path: Path):
        if not path.exists() or not path.is_file():
            self.send_error(404)
            return
        body = path.read_bytes()
        content_type, _ = mimetypes.guess_type(str(path))
        if path.suffix == ".js":
            content_type = "text/javascript"
        self.send_response(200)
        self.send_header("Content-Type", f"{content_type or 'application/octet-stream'}; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def serve_audio_path(self, request_path: str):
        relative = unquote(request_path.lstrip("/"))
        candidate = (REPO_ROOT / relative).resolve()
        try:
            candidate.relative_to(AUDIO_ROOT.resolve())
        except ValueError:
            self.send_error(403)
            return
        self.send_static(candidate)

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path

        if path == "/api/languages":
            self.send_json({"languages": list_languages()})
            return

        if path == "/api/content":
            language = parse_qs(parsed.query).get("language", ["de"])[0]
            try:
                bundle = build_language_bundle(language)
            except FileNotFoundError as exc:
                self.send_json({"error": str(exc)}, status=404)
                return
            except (OSError, json.JSONDecodeError, ValueError) as exc:
                self.send_json({"error": f"Could not read complete content: {exc}"}, status=500)
                return
            self.send_json(bundle)
            return

        if path.startswith("/audio/"):
            self.serve_audio_path(path)
            return

        static_map = {
            "/": "index.html",
            "/index.html": "index.html",
            "/styles.css": "styles.css",
            "/app.js": "app.js",
            "/activity_extensions.js": "activity_extensions.js",
            "/audio_extensions.js": "audio_extensions.js",
        }
        filename = static_map.get(path)
        if filename:
            self.send_static(PROTOTYPE_DIR / filename)
            return

        self.send_error(404)


def main():
    parser = argparse.ArgumentParser(description="Run the NOVA content prototype locally.")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--no-browser", action="store_true")
    args = parser.parse_args()

    if not CONTENT_ROOT.exists():
        raise SystemExit(f"Content directory not found: {CONTENT_ROOT}")

    server = ThreadingHTTPServer((args.host, args.port), PrototypeHandler)
    url = f"http://{args.host}:{args.port}/"
    print("NOVA content prototype")
    print(f"Reading content from: {CONTENT_ROOT}")
    print(f"Reading audio from: {AUDIO_ROOT}")
    print(f"Open: {url}")
    print("Press Ctrl+C to stop.")

    if not args.no_browser:
        threading.Timer(0.35, lambda: webbrowser.open(url)).start()

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopping prototype...")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
