#!/usr/bin/env python3
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]

# Harden resolver so an existing compatible lock remains stable.
p=ROOT/'scripts/audio_pipeline.py'
s=p.read_text(encoding='utf-8')
old='''    used = {standalone["voiceId"]}
    characters = {}
    character_dir = ROOT / "content" / language / "characters"
    for reserved_path in sorted(character_dir.glob("*.json")):
        rc=load_json(reserved_path); rp=rc.get("voiceProfile") or {}
        rid=rp.get("elevenLabsVoiceId"); rn=rp.get("voiceName")
        if rid: used.add(rid)
        elif rn:
            m=by_name.get(str(rn).casefold()) or []
            if m: used.add(sorted(m,key=lambda v:v["voice_id"])[0]["voice_id"])
    for path in sorted(character_dir.glob("*.json")):
'''
new='''    old_path = voice_lock_path(language)
    previous_lock = load_json(old_path) if old_path.exists() else None
    previous_characters = (previous_lock or {}).get("characters") or {}

    used = {standalone["voiceId"]}
    # Reserve both explicit authoring bindings and prior locked voices so a new
    # character cannot steal an existing character's production identity.
    used.update(rec.get("voiceId") for rec in previous_characters.values() if rec.get("voiceId"))
    characters = {}
    character_dir = ROOT / "content" / language / "characters"
    for reserved_path in sorted(character_dir.glob("*.json")):
        rc=load_json(reserved_path); rp=rc.get("voiceProfile") or {}
        rid=rp.get("elevenLabsVoiceId"); rn=rp.get("voiceName")
        if rid: used.add(rid)
        elif rn:
            m=by_name.get(str(rn).casefold()) or []
            if m: used.add(sorted(m,key=lambda v:v["voice_id"])[0]["voice_id"])
    for path in sorted(character_dir.glob("*.json")):
'''
if old not in s: raise SystemExit('resolver reservation anchor not found')
s=s.replace(old,new,1)

anchor='''        if explicit_name:
            matches = by_name.get(str(explicit_name).casefold()) or []
            if not matches:
                raise RuntimeError(f"Configured ElevenLabs voice name for {key} is unavailable: {explicit_name}")
            compatible = [v for v in matches if voice_gender_compatible(v, character)]
            if not compatible:
                raise RuntimeError(f"Configured ElevenLabs voice name for {key} conflicts with character gender: {explicit_name}")
            match = sorted(compatible, key=lambda v: v["voice_id"])[0]
            rec = voice_record(match, strategy="explicit", character_key=key)
            characters[key] = rec
            used.add(rec["voiceId"])
            continue

        candidates = [v for v in voices if v["voice_id"] not in used and voice_gender_compatible(v, character)]
'''
replacement='''        if explicit_name:
            matches = by_name.get(str(explicit_name).casefold()) or []
            if not matches:
                raise RuntimeError(f"Configured ElevenLabs voice name for {key} is unavailable: {explicit_name}")
            compatible = [v for v in matches if voice_gender_compatible(v, character)]
            if not compatible:
                raise RuntimeError(f"Configured ElevenLabs voice name for {key} conflicts with character gender: {explicit_name}")
            match = sorted(compatible, key=lambda v: v["voice_id"])[0]
            rec = voice_record(match, strategy="explicit", character_key=key)
            characters[key] = rec
            used.add(rec["voiceId"])
            continue

        previous = previous_characters.get(key)
        if previous and previous.get("voiceId"):
            match = next((v for v in voices if v.get("voice_id") == previous["voiceId"]), None)
            if match and voice_gender_compatible(match, character):
                strategy = previous.get("strategy")
                if strategy not in {"preference_name", "profile_match", "standalone_inherited", "explicit"}:
                    strategy = "profile_match"
                rec = voice_record(match, strategy=strategy, score=previous.get("matchScore"), character_key=key)
                characters[key] = rec
                used.add(rec["voiceId"])
                continue

        candidates = [v for v in voices if v["voice_id"] not in used and voice_gender_compatible(v, character)]
'''
if anchor not in s: raise SystemExit('previous-lock insertion anchor not found')
s=s.replace(anchor,replacement,1)

# Remove now-redundant old_path assignment near the end; preserve comparison logic.
s=s.replace('''    old_path = voice_lock_path(language)
    if old_path.exists():
        old = load_json(old_path)
''','''    if old_path.exists():
        old = load_json(old_path)
''',1)
p.write_text(s,encoding='utf-8')

# Harden validation: lock keys must equal canonical cast, and lock gender metadata
# must agree with known character gender.
p=ROOT/'scripts/validate_audio_contracts.py'
s=p.read_text(encoding='utf-8')
marker="# Voice locks, when present, must have provider SQL and no duplicate conversation voice IDs except learner inheritance.\n"
if marker not in s: raise SystemExit('audio validator anchor not found')
new_marker='''# Voice locks, when present, must match the canonical cast, have provider SQL,
# preserve gender compatibility, and have no duplicate conversation voice IDs.
'''
s=s.replace(marker,new_marker,1)
old='''    ids=[]
    for key,rec in (lock.get('characters') or {}).items():
        if rec.get('strategy')!='standalone_inherited': ids.append((key,rec.get('voiceId')))
'''
new='''    locked=lock.get('characters') or {}
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
'''
if old not in s: raise SystemExit('audio validator lock loop anchor not found')
s=s.replace(old,new,1)
p.write_text(s,encoding='utf-8')
print('voice lock stability hardening complete')
