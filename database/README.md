# Database

Canonical database target: **MySQL 9.0.1**.

## Files

- `schema.sql` — reusable relational schema only; it contains no educational course rows.
- `content/<language-code>/<level>.sql` — one complete content file per language and CEFR level.

Examples:

```text
database/content/de/pre-a1.sql
database/content/de/a1.sql
database/content/en/pre-a1.sql
database/content/en/a1.sql
```

## Content-file rule

Each `language × level` file is the import/export unit for that level. It may contain the sources, source items, characters, lexemes, lexeme forms, units, lessons, dialogues, activities, grammar notes, examples and relationship rows needed by that level.

Shared records are identified by stable `*_key` values. Level files should use idempotent upserts for shared records so re-running a file does not duplicate them.

The database never uses target counts for curriculum generation. Unit, lesson, activity and dialogue-turn counts are derived from approved rows after content exists.

## Import order

```sql
SOURCE database/schema.sql;
SOURCE database/content/de/pre-a1.sql;
SOURCE database/content/de/a1.sql;
```

A content file should normally be executed inside a transaction and should fail rather than silently accept unresolved foreign keys or invalid structural mappings.