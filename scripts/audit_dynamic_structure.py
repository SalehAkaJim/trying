#!/usr/bin/env python3
import collections
import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
CONTENT = ROOT / "content"
POLICY_PATH = ROOT / "config" / "dynamic-structure-policy.json"
UNIT_BOUNDS_PATH = ROOT / "config" / "unit-lesson-count-bounds.json"
ACTIVITY_BOUNDS_PATH = ROOT / "config" / "activity-count-bounds.json"

def load(path):
    return json.loads(path.read_text(encoding="utf-8"))

policy = load(POLICY_PATH)
unit_bounds = load(UNIT_BOUNDS_PATH).get("levels", {})
activity_bounds = load(ACTIVITY_BOUNDS_PATH).get("levels", {})
thresholds = policy["riskThresholds"]
min_population = policy["minimumPopulation"]
errors = []

def distribution(values):
    return dict(sorted(collections.Counter(values).items(), key=lambda item: item[0]))

def dominant_share(values):
    if not values:
        return 0.0, None, 0
    counts = collections.Counter(values)
    value, count = counts.most_common(1)[0]
    return count / len(values), value, count

def longest_identical_run(values):
    best = 0
    current = 0
    previous = object()
    best_value = None
    for value in values:
        if value == previous:
            current += 1
        else:
            previous = value
            current = 1
        if current > best:
            best = current
            best_value = value
    return best, best_value

def pct(value):
    return f"{value * 100:.1f}%"

for level_path in sorted(CONTENT.glob("*/*/level.json")):
    level_data = load(level_path)
    language = level_data.get("languageId")
    level = level_data.get("level")
    status = level_data.get("status")
    level_dir = level_path.parent

    unit_index = {}
    for path in (level_dir / "units").glob("*.json"):
        data = load(path)
        unit_index[data.get("id")] = (path, data)

    lesson_index = {}
    for path in (level_dir / "lessons").glob("*.json"):
        data = load(path)
        lesson_index[data.get("id")] = (path, data)

    unit_rows = []
    for unit_id in level_data.get("unitRefs") or []:
        entry = unit_index.get(unit_id)
        if entry is None:
            errors.append(f"{level_path}: dynamic audit cannot resolve unit {unit_id!r}")
            continue
        path, data = entry
        count = len(data.get("lessonRefs") or [])
        unit_rows.append((unit_id, count))
        if data.get("status") == "final" and not str(data.get("groupingRationale") or "").strip():
            errors.append(f"{path}: final unit requires a pedagogical groupingRationale that explains why these lessons belong together")

    lesson_rows = []
    signatures = []
    for lesson_id in level_data.get("lessonRefs") or []:
        entry = lesson_index.get(lesson_id)
        if entry is None:
            errors.append(f"{level_path}: dynamic audit cannot resolve lesson {lesson_id!r}")
            continue
        path, data = entry
        activities = data.get("activities") or []
        design = data.get("activityDesign") or {}
        signature = design.get("templateSignature") or ">".join(
            str(activity.get("type") or "") for activity in activities
        )
        lesson_rows.append((lesson_id, len(activities), signature))
        signatures.append(signature)
        if data.get("status") == "final":
            if not str(design.get("activitySelectionRationale") or "").strip():
                errors.append(f"{path}: final lesson requires activityDesign.activitySelectionRationale")
            if not str(design.get("sequenceRationale") or "").strip():
                errors.append(f"{path}: final lesson requires activityDesign.sequenceRationale")

    unit_counts = [count for _, count in unit_rows]
    activity_counts = [count for _, count, _ in lesson_rows]
    unit_dist = distribution(unit_counts)
    activity_dist = distribution(activity_counts)
    signature_dist = collections.Counter(signatures)
    top_signatures = signature_dist.most_common(5)
    unit_min = (unit_bounds.get(level) or {}).get("minLessons")
    activity_min = (activity_bounds.get(level) or {}).get("minActivities")
    units_at_min = sum(count == unit_min for count in unit_counts) if isinstance(unit_min, int) else 0
    lessons_at_min = sum(count == activity_min for count in activity_counts) if isinstance(activity_min, int) else 0

    print(f"\nDynamic structure audit: {language} {level} [{status}]")
    print("  Unit lesson counts:", ", ".join(f"{unit_id}={count}" for unit_id, count in unit_rows) or "none")
    print("  Unit lesson-count distribution:", unit_dist)
    print("  Lesson activity-count distribution:", activity_dist)
    print("  Top activity signatures:", top_signatures)
    print(f"  Units exactly at minimum: {units_at_min}/{len(unit_counts)}")
    print(f"  Lessons exactly at minimum: {lessons_at_min}/{len(activity_counts)}")

    if status not in {"review", "final"}:
        continue

    risks = []
    if len(unit_counts) >= min_population["units"]:
        share, value, count = dominant_share(unit_counts)
        if share >= thresholds["dominantUnitLessonCountShare"]:
            risks.append(
                f"dominant unit lesson count {value} appears in {count}/{len(unit_counts)} units ({pct(share)})"
            )
        if isinstance(unit_min, int):
            share = units_at_min / len(unit_counts)
            if share >= thresholds["unitsAtMinimumShare"]:
                risks.append(
                    f"{units_at_min}/{len(unit_counts)} units stop exactly at the minimum {unit_min} ({pct(share)})"
                )

    if len(activity_counts) >= min_population["lessons"]:
        share, value, count = dominant_share(activity_counts)
        if share >= thresholds["dominantLessonActivityCountShare"]:
            risks.append(
                f"dominant lesson activity count {value} appears in {count}/{len(activity_counts)} lessons ({pct(share)})"
            )
        if isinstance(activity_min, int):
            share = lessons_at_min / len(activity_counts)
            if share >= thresholds["lessonsAtMinimumShare"]:
                risks.append(
                    f"{lessons_at_min}/{len(activity_counts)} lessons stop exactly at the minimum {activity_min} ({pct(share)})"
                )
        sig_share, sig_value, sig_count = dominant_share(signatures)
        if sig_share >= thresholds["dominantActivitySignatureShare"]:
            risks.append(
                f"one activity sequence appears in {sig_count}/{len(signatures)} lessons ({pct(sig_share)}): {sig_value}"
            )
        run, run_value = longest_identical_run(signatures)
        if run >= thresholds["consecutiveIdenticalActivitySignature"]:
            risks.append(
                f"{run} consecutive lessons use the same activity sequence: {run_value}"
            )

    if risks:
        errors.append(
            f"{level_path}: quota-like structure risk detected. "
            "These thresholds are QA signals, not production targets. "
            "Re-check learning needs -> source inventory -> progression -> lesson boundaries -> activity design -> counts. "
            "Do not add artificial variety merely to silence the detector. Risks: " + "; ".join(risks)
        )

if errors:
    print("\nDynamic structure audit failed:", file=sys.stderr)
    for error in errors:
        print(f"- {error}", file=sys.stderr)
    sys.exit(1)

print("\nDynamic structure audit passed.")
