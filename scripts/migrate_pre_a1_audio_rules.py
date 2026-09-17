#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=ROOT/"scripts/audio_pipeline.py"
s=p.read_text(encoding="utf-8")

if "def voice_gender_compatible(" not in s:
    marker="def score_voice(voice: dict, language: str, character: dict) -> float:\n"
    helper="def voice_gender_compatible(voice: dict, character: dict) -> bool:\n    profile=character.get(\"voiceProfile\") or {}\n    wanted=str(profile.get(\"genderImpression\") or character.get(\"gender\") or \"\").lower()\n    if wanted not in {\"female\",\"male\"}: return True\n    return str((voice.get(\"labels\") or {}).get(\"gender\") or \"\").lower()==wanted\n\n\n"
    assert marker in s
    s=s.replace(marker,helper+marker)

old='        candidates = [v for v in voices if v["voice_id"] not in used]\n        if not candidates:\n            raise RuntimeError(f"No distinct ElevenLabs voice remains for {key}")'
new='        candidates = [v for v in voices if v["voice_id"] not in used and voice_gender_compatible(v, character)]\n        if not candidates:\n            wanted = profile.get("genderImpression") or character.get("gender") or "unspecified"\n            raise RuntimeError(f"No distinct gender-compatible ElevenLabs voice remains for {key} (wanted {wanted})")'
if old in s: s=s.replace(old,new)

old='            if not match:\n                raise RuntimeError(f"Configured ElevenLabs voice ID for {key} is unavailable: {explicit_id}")\n            rec = voice_record(match, strategy="explicit", character_key=key)'
new='            if not match:\n                raise RuntimeError(f"Configured ElevenLabs voice ID for {key} is unavailable: {explicit_id}")\n            if not voice_gender_compatible(match, character):\n                raise RuntimeError(f"Configured ElevenLabs voice ID for {key} conflicts with character gender: {explicit_id}")\n            rec = voice_record(match, strategy="explicit", character_key=key)'
if old in s: s=s.replace(old,new)

old='            match = sorted(matches, key=lambda v: v["voice_id"])[0]\n            rec = voice_record(match, strategy="explicit", character_key=key)'
new='            compatible = [v for v in matches if voice_gender_compatible(v, character)]\n            if not compatible:\n                raise RuntimeError(f"Configured ElevenLabs voice name for {key} conflicts with character gender: {explicit_name}")\n            match = sorted(compatible, key=lambda v: v["voice_id"])[0]\n            rec = voice_record(match, strategy="explicit", character_key=key)'
if old in s: s=s.replace(old,new)

old='    used = {standalone["voiceId"]}\n    characters = {}\n    character_dir = ROOT / "content" / language / "characters"\n    for path in sorted(character_dir.glob("*.json")):'
new='    used = {standalone["voiceId"]}\n    characters = {}\n    character_dir = ROOT / "content" / language / "characters"\n    for reserved_path in sorted(character_dir.glob("*.json")):\n        rc=load_json(reserved_path); rp=rc.get("voiceProfile") or {}\n        rid=rp.get("elevenLabsVoiceId"); rn=rp.get("voiceName")\n        if rid: used.add(rid)\n        elif rn:\n            m=by_name.get(str(rn).casefold()) or []\n            if m: used.add(sorted(m,key=lambda v:v["voice_id"])[0]["voice_id"])\n    for path in sorted(character_dir.glob("*.json")):'
if old in s: s=s.replace(old,new)

old='    for key, rec in sorted(lock["characters"].items()):\n        lines.append(\n            "UPDATE characters c JOIN languages l ON l.id=c.language_id "'
new='    for key, rec in sorted(lock["characters"].items()):\n        lines.append(\n            "UPDATE dialogue_turns t JOIN characters c ON c.id=t.speaker_character_id "\n            "JOIN languages l ON l.id=c.language_id "\n            f"SET t.audio_status=\'stale\' WHERE l.code={sql_quote(language)} AND c.character_key={sql_quote(key)} "\n            f"AND t.audio_status=\'ready\' AND t.audio_voice_id IS NOT NULL AND t.audio_voice_id<>{sql_quote(rec[\'voiceId\'])};"\n        )\n        lines.append(\n            "UPDATE characters c JOIN languages l ON l.id=c.language_id "'
if old in s: s=s.replace(old,new)

old='"COALESCE(audio_url,\'\'),COALESCE(audio_storage_path,\'\'),audio_is_current "'
new='"COALESCE(audio_url,\'\'),COALESCE(audio_storage_path,\'\'),COALESCE(audio_voice_id,\'\'),audio_is_current "'
if old in s: s=s.replace(old,new)
old='        owner_type, owner_key, text_hex, expected_hash, voice_name, voice_id, audio_status, audio_url, storage_path, current = row'
new='        owner_type, owner_key, text_hex, expected_hash, voice_name, voice_id, audio_status, audio_url, storage_path, stored_voice_id, current = row'
if old in s: s=s.replace(old,new)
old='            if rec:\n                voice_name = rec["voiceName"]\n                voice_id = rec["voiceId"]\n        out.append({'
new='            if rec:\n                voice_name = rec["voiceName"]\n                voice_id = rec["voiceId"]\n                if stored_voice_id != voice_id: current = "0"\n        if not voice_id: current = "0"\n        out.append({'
if old in s: s=s.replace(old,new)

p.write_text(s,encoding="utf-8")
print("audio pipeline patch complete")
