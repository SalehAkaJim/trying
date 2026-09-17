#!/usr/bin/env python3
from pathlib import Path

path=Path('scripts/audio_pipeline.py')
text=path.read_text(encoding='utf-8')
old='def api_request(url: str, api_key: str, *, method: str = "GET", body: dict | None = None, timeout: int = 120, max_retries: int = 3) -> bytes:\n    data = None\n    headers = {"xi-api-key": api_key, "Accept": "application/json"}'
new='def api_request(url: str, api_key: str, *, method: str = "GET", body: dict | None = None, timeout: int = 120, max_retries: int = 3, accept: str = "application/json") -> bytes:\n    data = None\n    headers = {"xi-api-key": api_key, "Accept": accept}'
if old not in text:
    raise SystemExit('api_request patch point not found')
text=text.replace(old,new,1)
old_call='        max_retries=int(config["generation"]["maxRetries"]),\n    )\n\n\ndef mapping_update'
new_call='        max_retries=int(config["generation"]["maxRetries"]),\n        accept="audio/mpeg",\n    )\n\n\ndef mapping_update'
if old_call not in text:
    raise SystemExit('tts_audio patch point not found')
text=text.replace(old_call,new_call,1)
path.write_text(text,encoding='utf-8')
print('Audio HTTP Accept header patched.')
