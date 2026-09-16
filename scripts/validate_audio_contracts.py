from pathlib import Path
import sys
errors=[]
for base in [Path("database"),Path("content"),Path("schemas")]:
    if not base.exists(): continue
    for p in base.rglob("*"):
        if p.is_file() and p.suffix in {".sql",".json",".md",".sh",".py"}:
            text=p.read_text(encoding="utf-8")
            for token in ("blocked_until_language_final","pending_final_language"):
                if token in text: errors.append(f"{p}: legacy audio status {token}")
for p in Path("database/content").rglob("*.sql"):
    text=p.read_text(encoding="utf-8")
    if "DELETE FROM dialogue_turns WHERE" in text and "AND turn_key NOT IN" not in text: errors.append(f"{p}: destructive dialogue_turn re-import can break audio linkage")
    if "audio_status=VALUES(audio_status)" in text: errors.append(f"{p}: base content must not overwrite generated audio status")
schema=Path("database/schema.sql").read_text(encoding="utf-8")
for required in ["v_audio_generation_manifest","audio_storage_path","audio_source_hash","audio_generated_at","blocked_until_level_final"]:
    if required not in schema: errors.append(f"database/schema.sql missing {required}")
if errors:
    print("Audio contract validation failed:")
    print("\n".join(errors))
    sys.exit(1)
print("Audio contract validation passed.")
