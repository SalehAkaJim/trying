# Audio Pipeline

## Scope
Audio is produced after each CEFR level is finalized, not after the whole language. Finalization freezes target-language text and speaker/voice assignments for that level.

## Stable identity
Never attach audio by numeric database IDs. Use `turn_key`, `lexeme_key`, `activity_key`, or `example_key`.

## Canonical generation manifest
`v_audio_generation_manifest` exposes language, level, owner type/key, exact spoken text, SHA-256, expected voice, current audio metadata and whether the asset is current. Generate only for a final level.

## Stored metadata
Persist audio status, public URL, repository/storage path, SHA-256 of exact spoken text, provider, model ID, voice name/ID and generation timestamp.

## Deterministic path
`audio/<language>/<level>/<owner_type>/<owner_key>.mp3`

The public URL may later point to GitHub, a CDN or object storage; `audio_storage_path` preserves provider-independent identity.

## Database mapping
Generated mappings are stored separately under `database/audio/<language>/<level>.sql`. Mapping SQL updates by stable owner key and verifies exact text hash before marking an asset `ready`. Base content SQL must never overwrite generated audio metadata.

## Staleness
If spoken text changes, MySQL invalidates its audio metadata. CI also compares stored hashes and expected voices through the manifest.

## Release state
A content-final level can transition its audio state from `pending` to `ready`. It is audio-ready only when all required manifest rows are current.
