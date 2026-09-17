#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LESSONS = ROOT / "content" / "de" / "pre-a1" / "lessons"

fixes = {
    "pizza-like.json": ("act-de-pizza-fill-mag", ["برای «من»", "برای «تو»"]),
    "name-exchange.json": ("act-de-name-fill-heisse", ["برای «من»", "برای «تو»"]),
    "simple-choice.json": ("act-de-simple-choice-fill", ["می‌خواهی", "دوست داری"]),
}

for filename, (activity_id, choices_fa) in fixes.items():
    path = LESSONS / filename
    data = json.loads(path.read_text(encoding="utf-8"))
    activity = next(a for a in data["activities"] if a["id"] == activity_id)
    activity["data"]["choicesFa"] = choices_fa
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

level_path = ROOT / "content" / "de" / "pre-a1" / "level.json"
level = json.loads(level_path.read_text(encoding="utf-8"))
strengths = level["completionAssessment"]["qualityReview"]["strengths"]
level["completionAssessment"]["qualityReview"]["strengths"] = [
    s.replace("TTS تازه", "تولید صوت تازه") for s in strengths
]
level_path.write_text(json.dumps(level, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
