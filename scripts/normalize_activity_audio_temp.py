#!/usr/bin/env python3
import json
from pathlib import Path

# Authoring activity wrapper audio is independent from dialogue-turn audio.
for p in Path('content').glob('*/*/lessons/*.json'):
    data=json.loads(p.read_text(encoding='utf-8'))
    changed=False
    for a in data.get('activities',[]):
        has_audio=isinstance(a.get('audioTextTarget'),str) and bool(a['audioTextTarget'].strip())
        desired='blocked_until_level_final' if has_audio else 'not_required'
        if a.get('audioStatus') != desired:
            a['audioStatus']=desired
            changed=True
    if changed:
        p.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

# Current SQL snapshots: activities without standalone audio text do not own audio assets.
for p in Path('database/content').rglob('*.sql'):
    text=p.read_text(encoding='utf-8')
    start=text.find('-- Activities')
    end=text.find('-- Lexemes / forms',start)
    if start>=0 and end>start:
        block=text[start:end].replace("'blocked_until_level_final')","'not_required')")
        text=text[:start]+block+text[end:]
        p.write_text(text,encoding='utf-8')

# Permanent static validator.
p=Path('scripts/validate_audio_contracts.py')
p.write_text('''#!/usr/bin/env python3
import json
from pathlib import Path
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

for p in Path("content").glob("*/*/lessons/*.json"):
    data=json.loads(p.read_text(encoding="utf-8"))
    for i,a in enumerate(data.get("activities", []),1):
        status=a.get("audioStatus")
        audio_text=a.get("audioTextTarget")
        has_audio=isinstance(audio_text,str) and bool(audio_text.strip())
        if not has_audio and status != "not_required":
            errors.append(f"{p}: activity {i} has no audioTextTarget and must use audioStatus=not_required")
        if has_audio and status == "not_required":
            errors.append(f"{p}: activity {i} has audioTextTarget but audioStatus=not_required")
        if a.get("type") in {"listen_choose","listen_repeat","pronunciation_read"} and not has_audio:
            errors.append(f"{p}: audio-dependent activity {i} ({a.get('type')}) requires audioTextTarget")

for p in Path("database/content").rglob("*.sql"):
    text=p.read_text(encoding="utf-8")
    if "DELETE FROM dialogue_turns WHERE" in text and "AND turn_key NOT IN" not in text:
        errors.append(f"{p}: destructive dialogue_turn re-import can break audio linkage")
    if "audio_status=VALUES(audio_status)" in text:
        errors.append(f"{p}: base content must not overwrite generated audio status")

schema=Path("database/schema.sql").read_text(encoding="utf-8")
for required in ["v_audio_generation_manifest","audio_storage_path","audio_source_hash","audio_generated_at","blocked_until_level_final"]:
    if required not in schema:
        errors.append(f"database/schema.sql missing {required}")

if errors:
    print("Audio contract validation failed:")
    print("\\n".join(errors))
    sys.exit(1)
print("Audio contract validation passed.")
''',encoding='utf-8')

# Permanent MySQL invariant mirrors authoring distinction.
p=Path('scripts/validate_mysql_content.sh')
s=p.read_text(encoding='utf-8')
anchor='invalid_ready_audio="$(compact_query "SELECT COUNT(*) FROM v_audio_generation_manifest WHERE audio_status=\'ready\' AND audio_is_current<>1;")"\n'
if 'invalid_activity_audio_state=' not in s:
    if anchor not in s:
        raise SystemExit('audio check anchor not found')
    addition='invalid_activity_audio_state="$(compact_query "SELECT COUNT(*) FROM activities WHERE (audio_text_target IS NULL AND audio_status<>\'not_required\') OR (audio_text_target IS NOT NULL AND audio_status=\'not_required\');")"\n'
    s=s.replace(anchor,addition+anchor,1)
    s=s.replace('echo "audio invalid-ready=$invalid_ready_audio premature-ready=$premature_ready_audio invalid-level-ready=$invalid_level_audio_ready"',
                'echo "audio invalid-activity-state=$invalid_activity_audio_state invalid-ready=$invalid_ready_audio premature-ready=$premature_ready_audio invalid-level-ready=$invalid_level_audio_ready"')
    s=s.replace('test "$invalid_ready_audio" = "0"','test "$invalid_activity_audio_state" = "0"\ntest "$invalid_ready_audio" = "0"',1)
p.write_text(s,encoding='utf-8')
