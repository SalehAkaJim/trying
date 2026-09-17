#!/usr/bin/env python3
import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
CONTENT = ROOT / "content"
CONFIG_PATH = ROOT / "config" / "activity-count-bounds.json"
errors = []


def load_json(path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"{path}: invalid JSON: {exc}")
        return None


config = load_json(CONFIG_PATH) or {}
levels = config.get("levels")
if not isinstance(levels, dict) or not levels:
    errors.append(f"{CONFIG_PATH}: levels must be a non-empty object")
    levels = {}

normalized_bounds = {}
for level, bounds in levels.items():
    if not isinstance(bounds, dict):
        errors.append(f"{CONFIG_PATH}: {level} bounds must be an object")
        continue
    minimum = bounds.get("minActivities")
    maximum = bounds.get("maxActivities")
    if not isinstance(minimum, int) or isinstance(minimum, bool) or minimum < 1:
        errors.append(f"{CONFIG_PATH}: {level}.minActivities must be an integer >= 1")
        continue
    if not isinstance(maximum, int) or isinstance(maximum, bool) or maximum < minimum:
        errors.append(f"{CONFIG_PATH}: {level}.maxActivities must be an integer >= minActivities")
        continue
    normalized_bounds[level] = (minimum, maximum)

for path in sorted(CONTENT.glob("**/lessons/*.json")):
    lesson = load_json(path)
    if not isinstance(lesson, dict):
        continue
    if lesson.get("status") != "final":
        continue
    level = lesson.get("level")
    bounds = normalized_bounds.get(level)
    if bounds is None:
        continue
    activities = lesson.get("activities")
    count = len(activities) if isinstance(activities, list) else 0
    minimum, maximum = bounds
    if not minimum <= count <= maximum:
        errors.append(
            f"{path}: final {level} lesson must contain {minimum}–{maximum} total activities; got {count}"
        )

if errors:
    print("Activity-count guardrail validation failed:")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print("Activity-count guardrails OK.")
