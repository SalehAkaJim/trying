#!/usr/bin/env python3
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]
TAXONOMY = json.loads((ROOT / 'config' / 'fa-taxonomy.json').read_text(encoding='utf-8'))['domains']


def sql_quote(value):
    return str(value).replace("'", "''")


def sync_schema():
    path = ROOT / 'database' / 'schema.sql'
    text = path.read_text(encoding='utf-8')

    rows = []
    for domain, values in TAXONOMY.items():
        for code, label in values.items():
            rows.append(f"('{sql_quote(domain)}','{sql_quote(code)}','{sql_quote(label)}')")

    seed = (
        "\nCREATE TABLE IF NOT EXISTS taxonomy_labels (\n"
        "  domain_code VARCHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,\n"
        "  value_code VARCHAR(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,\n"
        "  label_fa VARCHAR(255) NOT NULL,\n"
        "  PRIMARY KEY (domain_code,value_code)\n"
        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;\n\n"
        "-- BEGIN GENERATED FA TAXONOMY\n"
        "INSERT INTO taxonomy_labels (domain_code,value_code,label_fa) VALUES\n  "
        + ",\n  ".join(rows)
        + "\nON DUPLICATE KEY UPDATE label_fa=VALUES(label_fa);\n"
        "-- END GENERATED FA TAXONOMY\n"
    )

    if 'CREATE TABLE IF NOT EXISTS taxonomy_labels' not in text:
        anchor = "SET time_zone = '+00:00';\n"
        if anchor not in text:
            raise SystemExit('schema.sql: insertion anchor not found')
        text = text.replace(anchor, anchor + seed, 1)

    old = "  part_of_speech VARCHAR(128) NULL,\n  cefr_level ENUM"
    new = "  part_of_speech VARCHAR(128) NULL,\n  part_of_speech_fa VARCHAR(191) NULL,\n  cefr_level ENUM"
    if old in text:
        text = text.replace(old, new, 1)
    elif 'part_of_speech_fa VARCHAR(191)' not in text:
        raise SystemExit('schema.sql: lexeme part_of_speech anchor not found')

    trigger = """DROP TRIGGER IF EXISTS trg_lexemes_bi_fa_taxonomy$$
CREATE TRIGGER trg_lexemes_bi_fa_taxonomy BEFORE INSERT ON lexemes FOR EACH ROW
BEGIN
  DECLARE expected_label VARCHAR(255);
  IF NEW.part_of_speech IS NULL THEN
    IF NEW.part_of_speech_fa IS NOT NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech_fa must be null when part_of_speech is null';
    END IF;
  ELSE
    SET expected_label=(SELECT label_fa FROM taxonomy_labels WHERE domain_code='part_of_speech' AND value_code=NEW.part_of_speech LIMIT 1);
    IF expected_label IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech requires a Persian taxonomy label';
    END IF;
    IF NEW.part_of_speech_fa IS NULL OR NEW.part_of_speech_fa<>expected_label THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech_fa must match canonical Persian taxonomy label';
    END IF;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_lexemes_bu_fa_taxonomy$$
CREATE TRIGGER trg_lexemes_bu_fa_taxonomy BEFORE UPDATE ON lexemes FOR EACH ROW
BEGIN
  DECLARE expected_label VARCHAR(255);
  IF NEW.part_of_speech IS NULL THEN
    IF NEW.part_of_speech_fa IS NOT NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech_fa must be null when part_of_speech is null';
    END IF;
  ELSE
    SET expected_label=(SELECT label_fa FROM taxonomy_labels WHERE domain_code='part_of_speech' AND value_code=NEW.part_of_speech LIMIT 1);
    IF expected_label IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech requires a Persian taxonomy label';
    END IF;
    IF NEW.part_of_speech_fa IS NULL OR NEW.part_of_speech_fa<>expected_label THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='part_of_speech_fa must match canonical Persian taxonomy label';
    END IF;
  END IF;
END$$

"""
    marker = 'DROP TRIGGER IF EXISTS trg_lexeme_occurrences_bi$$'
    if 'trg_lexemes_bi_fa_taxonomy' not in text:
        if marker not in text:
            raise SystemExit('schema.sql: trigger insertion anchor not found')
        text = text.replace(marker, trigger + marker, 1)

    path.write_text(text, encoding='utf-8')


def sync_content_sql():
    labels = TAXONOMY['part_of_speech']
    for path in (ROOT / 'database' / 'content').rglob('*.sql'):
        text = path.read_text(encoding='utf-8')
        if 'INSERT INTO lexemes' not in text:
            continue
        text = text.replace(
            'lemma,part_of_speech,cefr_level,translation_fa',
            'lemma,part_of_speech,part_of_speech_fa,cefr_level,translation_fa'
        )
        for code, label in sorted(labels.items(), key=lambda item: -len(item[0])):
            for level in ('Pre-A1','A1','A2','B1','B2','C1','C2'):
                text = text.replace(
                    f",'{code}','{level}'",
                    f",'{code}','{sql_quote(label)}','{level}'"
                )
        text = text.replace(
            'part_of_speech=VALUES(part_of_speech),cefr_level=VALUES(cefr_level)',
            'part_of_speech=VALUES(part_of_speech),part_of_speech_fa=VALUES(part_of_speech_fa),cefr_level=VALUES(cefr_level)'
        )
        path.write_text(text, encoding='utf-8')


if __name__ == '__main__':
    sync_schema()
    sync_content_sql()
    print('MySQL Persian taxonomy migration applied.')
