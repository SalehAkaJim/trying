#!/usr/bin/env python3
import json
from pathlib import Path
import py_compile
import re
import sys

errors=[]
legacy=("blocked_until_language_final","pending_final_language")
for base in [Path("database"),Path("content"),Path("schemas")]:
    if not base.exists():
        continue
    for p in base.rglob("*"):
        if p.is_file() and p.suffix in {".sql",".json",".md",".sh",".py"}:
            text=p.read_text(encoding="utf-8")
            for token in legacy:
                if token in text:
                    errors.append(f"{p}: legacy audio status {token}")

for required in [
    Path('config/audio-pipeline.json'),
    Path('schemas/audio-pipeline.schema.json'),
    Path('schemas/audio-voice-lock.schema.json'),
    Path('scripts/audio_pipeline.py'),
    Path('.github/workflows/audio-generation.yml'),
    Path('docs/AUDIO_PIPELINE.md'),
]:
    if not required.exists(): errors.append(f'missing required audio pipeline file: {required}')

try:
    py_compile.compile('scripts/audio_pipeline.py', doraise=True)
except Exception as exc:
    errors.append(f'scripts/audio_pipeline.py does not compile: {exc}')

config=json.loads(Path('config/audio-pipeline.json').read_text(encoding='utf-8'))
if config.get('apiKeyEnv')!='ELEVENLABS_API_KEY': errors.append('audio API key env must remain ELEVENLABS_API_KEY')
if config.get('generation',{}).get('requirePaidGenerationConfirmation') is not True: errors.append('paid generation confirmation must remain mandatory')
if config.get('storageRoot')!='audio': errors.append('audio storageRoot must be audio')
if config.get('mappingRoot')!='database/audio': errors.append('audio mappingRoot must be database/audio')
if config.get('voiceResolution',{}).get('learnerUsesStandaloneVoice') is not False: errors.append('learner dialogue turns must never inherit the standalone voice')
for pth in Path('content').glob('*/characters/*.json'):
    d=json.loads(pth.read_text(encoding='utf-8'))
    if 'learner' in set(d.get('roles') or []): errors.append(f'{pth}: durable learner persona is forbidden')

for p in Path("content").glob("*/*/lessons/*.json"):
    data=json.loads(p.read_text(encoding="utf-8"))
    for i,a in enumerate(data.get("activities", []),1):
        status=a.get("audioStatus")
        audio_text=a.get("audioTextTarget")
        has_audio=isinstance(audio_text,str) and bool(audio_text.strip())
        if not has_audio and status != "not_required": errors.append(f"{p}: activity {i} has no audioTextTarget and must use audioStatus=not_required")
        if has_audio and status == "not_required": errors.append(f"{p}: activity {i} has audioTextTarget but audioStatus=not_required")
        if a.get("type") in {"listen_choose","listen_repeat","pronunciation_read"} and not has_audio: errors.append(f"{p}: audio-dependent activity {i} ({a.get('type')}) requires audioTextTarget")

for p in Path("database/content").rglob("*.sql"):
    text=p.read_text(encoding="utf-8")
    if "DELETE FROM dialogue_turns WHERE" in text and "AND turn_key NOT IN" not in text: errors.append(f"{p}: destructive dialogue_turn re-import can break audio linkage")
    if "audio_status=VALUES(audio_status)" in text: errors.append(f"{p}: base content must not overwrite generated audio status")

schema=Path("database/schema.sql").read_text(encoding="utf-8")
for required in ["v_audio_generation_manifest","audio_storage_path","audio_source_hash","audio_generated_at","blocked_until_level_final"]:
    if required not in schema: errors.append(f"database/schema.sql missing {required}")

levels={}
for pth in Path("content").glob("*/*/level.json"):
    d=json.loads(pth.read_text(encoding="utf-8")); levels[(d.get("languageId"),d.get("level"))]=d
for pth in Path("content").glob("*/language.json"):
    d=json.loads(pth.read_text(encoding="utf-8")); policy=d.get("audioPolicy") or {}
    if policy.get("generateAfterEachLevelFinal") is not True: errors.append(f"{pth}: generateAfterEachLevelFinal must be true")
    if "generateOnlyAfterLanguageFinal" in policy: errors.append(f"{pth}: legacy generateOnlyAfterLanguageFinal is forbidden")
for pth in Path("content").glob("*/*/lessons/*.json"):
    d=json.loads(pth.read_text(encoding="utf-8"))
    if (levels.get((d.get("languageId"),d.get("level"))) or {}).get("status")=="final":
        if d.get("audioStatus")=="blocked_until_level_final": errors.append(f"{pth}: final-level lesson audio remains blocked")
        for a in d.get("activities",[]):
            if a.get("audioTextTarget") and a.get("audioStatus")=="blocked_until_level_final": errors.append(f"{pth}:{a.get('id')}: final-level activity audio remains blocked")
for pth in Path("content").glob("*/lexemes/*.json"):
    d=json.loads(pth.read_text(encoding="utf-8"))
    if (levels.get((d.get("languageId"),d.get("level"))) or {}).get("status")=="final" and d.get("audioStatus")=="blocked_until_level_final": errors.append(f"{pth}: final-level lexeme audio remains blocked")

# Voice locks, when present, must have provider SQL and no duplicate conversation voice IDs except learner inheritance.
for lock_path in Path('config/audio-voice-locks').glob('*.json'):
    lock=json.loads(lock_path.read_text(encoding='utf-8'))
    language=lock.get('language')
    voice_sql=Path('database/audio')/str(language)/'voices.sql'
    if not voice_sql.exists(): errors.append(f'{lock_path}: missing {voice_sql}')
    ids=[]
    for key,rec in (lock.get('characters') or {}).items():
        if rec.get('strategy')!='standalone_inherited': ids.append((key,rec.get('voiceId')))
    seen={}
    for key,vid in ids:
        if vid in seen: errors.append(f'{lock_path}: duplicate non-learner conversation voice {vid} for {seen[vid]} and {key}')
        seen[vid]=key

if errors:
    print("Audio contract validation failed:")
    print("\n".join(errors))
    sys.exit(1)
print("Audio contract validation passed.")
