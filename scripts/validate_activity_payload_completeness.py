#!/usr/bin/env python3
"""Validate that learner-facing activity payloads are complete enough to render and play.

The generic activity schema intentionally leaves ``data`` flexible. This guardrail checks
minimum runtime requirements for the interactive activity types used by the content player.
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LESSON_FILES = sorted(ROOT.glob("content/**/lessons/*.json"))


def has_text(value: object) -> bool:
    return isinstance(value, str) and bool(value.strip())


def add_error(errors: list[str], path: Path, activity_id: str, message: str) -> None:
    errors.append(f"{path.relative_to(ROOT)} :: {activity_id}: {message}")


def validate_choice_activity(errors: list[str], path: Path, activity: dict) -> None:
    activity_id = activity.get("id", "<missing-id>")
    data = activity.get("data") or {}
    options = data.get("options")
    if not isinstance(options, list) or len(options) < 2:
        add_error(errors, path, activity_id, "choice activity requires at least 2 options")
        return

    if all(isinstance(option, dict) and isinstance(option.get("correct"), bool) for option in options):
        correct_count = sum(1 for option in options if option["correct"])
        if correct_count != 1:
            add_error(
                errors,
                path,
                activity_id,
                f"choice activity requires exactly 1 correct option; found {correct_count}",
            )


def validate_fill_blank(errors: list[str], path: Path, activity: dict) -> None:
    activity_id = activity.get("id", "<missing-id>")
    data = activity.get("data") or {}
    choices = data.get("choices")
    answer = data.get("answer")

    if not has_text(data.get("blankedText")):
        add_error(errors, path, activity_id, "fill_blank requires non-empty data.blankedText")
    elif "___" not in data["blankedText"]:
        add_error(errors, path, activity_id, "fill_blank data.blankedText must contain ___")

    if not isinstance(choices, list) or len(choices) < 2:
        add_error(errors, path, activity_id, "fill_blank requires at least 2 choices")
        return

    normalized = [str(choice).strip() for choice in choices]
    if any(not value for value in normalized):
        add_error(errors, path, activity_id, "fill_blank choices must be non-empty")
    if len(set(normalized)) != len(normalized):
        add_error(errors, path, activity_id, "fill_blank choices must be unique")
    if not has_text(answer):
        add_error(errors, path, activity_id, "fill_blank requires non-empty data.answer")
    elif answer.strip() not in normalized:
        add_error(errors, path, activity_id, "fill_blank answer must be present in choices")

    choices_fa = data.get("choicesFa")
    if choices_fa is not None:
        if not isinstance(choices_fa, list) or len(choices_fa) != len(choices):
            add_error(errors, path, activity_id, "fill_blank choicesFa must match choices length")
        elif any(not has_text(value) for value in choices_fa):
            add_error(errors, path, activity_id, "fill_blank choicesFa entries must be non-empty")


def validate_matching(errors: list[str], path: Path, activity: dict) -> None:
    activity_id = activity.get("id", "<missing-id>")
    data = activity.get("data") or {}
    pairs = data.get("pairs")
    if not isinstance(pairs, list) or not 4 <= len(pairs) <= 8:
        add_error(errors, path, activity_id, "matching requires 4 to 8 pairs")
        return

    left_values: list[str] = []
    right_values: list[str] = []
    for index, pair in enumerate(pairs, start=1):
        if not isinstance(pair, dict):
            add_error(errors, path, activity_id, f"matching pair {index} must be an object")
            continue
        left = pair.get("left")
        right = pair.get("right")
        if not has_text(left):
            add_error(errors, path, activity_id, f"matching pair {index} requires non-empty left")
        else:
            left_values.append(left.strip())
        if not has_text(right):
            add_error(errors, path, activity_id, f"matching pair {index} requires non-empty right")
        else:
            right_values.append(right.strip())

    if len(left_values) == len(pairs) and len(set(left_values)) != len(left_values):
        add_error(errors, path, activity_id, "matching left values must be unique")
    if len(right_values) == len(pairs) and len(set(right_values)) != len(right_values):
        add_error(errors, path, activity_id, "matching right values must be unique")


def validate_word_order(errors: list[str], path: Path, activity: dict) -> None:
    activity_id = activity.get("id", "<missing-id>")
    data = activity.get("data") or {}
    tokens = data.get("tokens")
    answer = data.get("answer")
    if not isinstance(tokens, list) or len(tokens) < 2 or any(not has_text(token) for token in tokens):
        add_error(errors, path, activity_id, "word_order requires at least 2 non-empty tokens")
    if not isinstance(answer, list) or len(answer) < 2 or any(not has_text(token) for token in answer):
        add_error(errors, path, activity_id, "word_order requires a non-empty answer token list")
    elif isinstance(tokens, list) and sorted(map(str, tokens)) != sorted(map(str, answer)):
        add_error(errors, path, activity_id, "word_order answer must contain the same tokens as data.tokens")


def validate_true_false(errors: list[str], path: Path, activity: dict) -> None:
    activity_id = activity.get("id", "<missing-id>")
    data = activity.get("data") or {}
    if not any(has_text(data.get(key)) for key in ("statementTarget", "statementFa", "statement")):
        add_error(errors, path, activity_id, "true_false requires a statement")
    if not isinstance(data.get("answer"), bool):
        add_error(errors, path, activity_id, "true_false requires boolean data.answer")


def main() -> int:
    errors: list[str] = []
    checked = 0

    for path in LESSON_FILES:
        lesson = json.loads(path.read_text(encoding="utf-8"))
        for activity in lesson.get("activities", []):
            checked += 1
            activity_type = activity.get("type")
            activity_id = activity.get("id", "<missing-id>")
            data = activity.get("data")
            if not isinstance(data, dict):
                add_error(errors, path, activity_id, "data must be an object")
                continue

            if activity_type in {"multiple_choice", "choose_response", "listen_choose"}:
                validate_choice_activity(errors, path, activity)
            elif activity_type == "fill_blank":
                validate_fill_blank(errors, path, activity)
            elif activity_type == "matching":
                validate_matching(errors, path, activity)
            elif activity_type == "word_order":
                validate_word_order(errors, path, activity)
            elif activity_type == "true_false":
                validate_true_false(errors, path, activity)
            elif activity_type == "conversation_speaking" and not has_text(activity.get("dialogueRef")):
                add_error(errors, path, activity_id, "conversation_speaking requires dialogueRef")

    if errors:
        print("Activity payload completeness validation failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        f"Activity payload completeness OK for {checked} activities "
        f"across {len(LESSON_FILES)} lesson files."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
