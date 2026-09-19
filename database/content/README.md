# Canonical level content SQL files

Store **exactly one active SQL file per language × CEFR level** here.

Naming convention:

```text
<language-code>/<level>.sql
```

Use lowercase level names in file paths: `pre-a1`, `a1`, `a2`, `b1`, `b2`, `c1`, `c2`.

These files are complete canonical educational-data snapshots for their level; `database/schema.sql` remains content-free. Historical patch/migration chains are preserved by Git history and must not remain as active files under `database/content/`.

`scripts/validate_mysql_content.sh` derives the expected files from authoring `level.json` manifests, rejects missing or extra SQL files, and imports canonical files in CEFR order rather than filename order.
