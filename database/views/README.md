# Runtime database views

Shared runtime/frontend views live here because they are database infrastructure, not language-level educational content.

Files in this directory are applied after canonical level snapshots by `scripts/validate_mysql_content.sh`. They must be idempotent (for example, use `CREATE OR REPLACE VIEW`) and must not contain language curriculum data.
