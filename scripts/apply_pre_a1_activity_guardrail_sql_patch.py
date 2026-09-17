#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "database" / "content" / "de" / "pre-a1.sql"
MYSQL_VALIDATOR = ROOT / "scripts" / "validate_mysql_content.sh"

SQL_MARKER = "-- BEGIN PRE-A1 ACTIVITY COUNT GUARDRAIL SYNC"

SQL_BLOCK = r'''-- BEGIN PRE-A1 ACTIVITY COUNT GUARDRAIL SYNC
-- Keep canonical MySQL content synchronized with the finalized authoring lessons.
START TRANSACTION;

SET @g_l_hallo=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-hallo' LIMIT 1);
SET @g_l_danke=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-danke-bitte' LIMIT 1);
SET @g_l_residence=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-residence-origin' LIMIT 1);
SET @g_l_object=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-basic-object' LIMIT 1);
SET @g_l_choice=(SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-choice' LIMIT 1);

UPDATE lessons SET
 activity_selection_rationale='گفت‌وگوی کوتاه سلام و خداحافظی را در بافت می‌آورد و یک تشخیص متنیِ سبک کمک می‌کند زبان‌آموز نقش «Tschüss!» را جدا از «Hallo!» بازیابی کند.',
 sequence_rationale='اول دو عبارت در تعامل استفاده می‌شوند و سپس زبان‌آموز عبارت مناسب برای پایان گفت‌وگو را تشخیص می‌دهد.',
 template_signature='conversation_speaking>multiple_choice'
WHERE id=@g_l_hallo;

UPDATE lessons SET
 activity_selection_rationale='گفت‌وگوی کوتاه تشکر و پاسخ مؤدبانه را در بافت قرار می‌دهد و یک انتخاب پاسخ، رابطهٔ مستقیم «Danke!» و «Bitte!» را بدون افزودن زبان تازه تثبیت می‌کند.',
 sequence_rationale='ابتدا زبان‌آموز پاسخ مؤدبانه را در مکالمه می‌گوید و سپس همان پاسخ را در یک موقعیت روشن بازیابی می‌کند.',
 template_signature='conversation_speaking>choose_response'
WHERE id=@g_l_danke;

UPDATE lessons SET
 activity_selection_rationale='مکالمه محل زندگی و مبدأ را در یک آشنایی کوتاه تمرین می‌کند و تطبیق دو جفت پرسش‌وپاسخِ دقیق منبع کمک می‌کند این دو مفهوم نزدیک با هم قاطی نشوند.',
 sequence_rationale='ابتدا زبان‌آموز محل زندگی و مبدأ را در گفت‌وگو استفاده می‌کند و سپس هر پرسش را به پاسخ منبع‌دار مناسب وصل می‌کند.',
 template_signature='conversation_speaking>matching'
WHERE id=@g_l_residence;

UPDATE lessons SET
 activity_selection_rationale='مکالمه پرسش و پاسخ را در بافت متنی تمرین می‌کند و بازسازی یکی از پاسخ‌های دقیق منبع، الگوی «Das ist ...» را بدون تصویر و بدون ساخت جملهٔ تازه بازیابی می‌کند.',
 sequence_rationale='اول زبان‌آموز سؤال و پاسخ را در تعامل می‌بیند و سپس یک پاسخ منبع‌دار را با مرتب‌کردن واژه‌ها بازسازی می‌کند.',
 template_signature='conversation_speaking>word_order'
WHERE id=@g_l_object;

UPDATE lessons SET
 activity_selection_rationale='گفت‌وگو معنی «Was möchtest du?» را در یک انتخاب ساده روشن می‌کند و بازسازی همان پرسش دقیق منبع، فرم «möchtest» را بدون افزودن واژه یا ساختار تازه بازیابی می‌کند.',
 sequence_rationale='ابتدا زبان‌آموز پرسش را در بافت می‌فهمد و پاسخ آشنا می‌دهد؛ سپس خود پرسش منبع‌دار را با مرتب‌کردن واژه‌ها بازسازی می‌کند.',
 template_signature='conversation_speaking>word_order'
WHERE id=@g_l_choice;

UPDATE activities SET
 selection_reason='تعامل چهار نوبت دو عبارت پایه را در یک موقعیت ساده و کم‌فشار قرار می‌دهد.'
WHERE activity_key='act-de-hallo-conversation';

INSERT INTO activities
(activity_key,lesson_id,position_index,activity_type,instruction_fa,selection_reason,dialogue_id,payload,transformations,audio_text_target,audio_status) VALUES
('act-de-hallo-farewell-choice',@g_l_hallo,2,'multiple_choice',
 'برای خداحافظی کدام عبارت مناسب است؟',
 'این تشخیص کوتاه تفاوت نقش سلام و خداحافظی را با همان دو عبارت منبع‌دار تثبیت می‌کند.',NULL,
 JSON_OBJECT('promptFa','می‌خواهی گفت‌وگو را تمام کنی.','options',JSON_ARRAY(
  JSON_OBJECT('textTarget','Tschüss!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wikibooks-de-basic-greetings')),
  JSON_OBJECT('textTarget','Hallo!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-hallo')))),
 JSON_ARRAY('options_selected_from_source_material'),NULL,'not_required'),
('act-de-danke-bitte-response',@g_l_danke,2,'choose_response',
 'در پاسخ به «Danke!» کدام عبارت مناسب است؟',
 'این تمرین پاسخ مؤدبانه را با دو عبارت آشنای منبع‌دار بازیابی می‌کند و نقش «Bitte!» را روشن نگه می‌دارد.',NULL,
 JSON_OBJECT('promptTarget','Danke!','options',JSON_ARRAY(
  JSON_OBJECT('textTarget','Bitte!','correct',TRUE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-bitte')),
  JSON_OBJECT('textTarget','Hallo!','correct',FALSE,'sourceRefs',JSON_ARRAY('src-wiktionary-de-hallo')))),
 JSON_ARRAY('options_selected_from_source_material'),NULL,'not_required'),
('act-de-residence-matching',@g_l_residence,2,'matching',
 'هر پرسش را به پاسخ مناسبش وصل کن.',
 'این تطبیق تفاوت «محل زندگی» و «مبدأ» را با چهار عبارت دقیق منبع و بدون افزودن جملهٔ تازه تمرین می‌کند.',NULL,
 JSON_OBJECT('pairs',JSON_ARRAY(
  JSON_OBJECT('left','Wo wohnen Sie?','right','Ich wohne in Österreich.','sourceRefs',JSON_ARRAY('src-wikibooks-de-residence-origin')),
  JSON_OBJECT('left','Woher kommen Sie?','right','Ich komme aus Deutschland, und Sie?','sourceRefs',JSON_ARRAY('src-wikibooks-de-residence-origin')))),
 JSON_ARRAY('source_items_grouped_for_matching'),NULL,'not_required'),
('act-de-object-word-order',@g_l_object,2,'word_order',
 'پاسخ منبع‌دار را دوباره بساز.',
 'بازسازی «Das ist ein Buch.» همان الگوی پاسخ درس را بدون تصویر و بدون افزودن زبان تازه تثبیت می‌کند.',NULL,
 JSON_OBJECT('sourceText','Das ist ein Buch.','tokens',JSON_ARRAY('Das','ist','ein','Buch.'),'answer',JSON_ARRAY('Das','ist','ein','Buch.')),
 JSON_ARRAY('sentence_tokenized_for_word_order'),NULL,'not_required'),
('act-de-simple-choice-word-order',@g_l_choice,2,'word_order',
 'پرسش منبع‌دار را دوباره بساز.',
 'بازسازی «Was möchtest du?» فرم تازهٔ «möchtest» را در همان پرسش آشنا تثبیت می‌کند و زبان تازه‌ای وارد نمی‌کند.',NULL,
 JSON_OBJECT('sourceText','Was möchtest du?','tokens',JSON_ARRAY('Was','möchtest','du?'),'answer',JSON_ARRAY('Was','möchtest','du?'),'tokenLexemeMappings',JSON_ARRAY(
  JSON_OBJECT('token','möchtest','lexemeId','lex-de-moegen','lexemeFormId','lexform-de-moegen-moechtest'))),
 JSON_ARRAY('sentence_tokenized_for_word_order'),NULL,'not_required')
ON DUPLICATE KEY UPDATE
 lesson_id=VALUES(lesson_id),position_index=VALUES(position_index),activity_type=VALUES(activity_type),
 instruction_fa=VALUES(instruction_fa),selection_reason=VALUES(selection_reason),dialogue_id=VALUES(dialogue_id),
 payload=VALUES(payload),transformations=VALUES(transformations),audio_text_target=VALUES(audio_text_target),audio_status=VALUES(audio_status);

SET @g_a_hallo=(SELECT id FROM activities WHERE activity_key='act-de-hallo-farewell-choice');
SET @g_a_danke=(SELECT id FROM activities WHERE activity_key='act-de-danke-bitte-response');
SET @g_a_res=(SELECT id FROM activities WHERE activity_key='act-de-residence-matching');
SET @g_a_obj=(SELECT id FROM activities WHERE activity_key='act-de-object-word-order');
SET @g_a_choice=(SELECT id FROM activities WHERE activity_key='act-de-simple-choice-word-order');

SET @g_x_hallo=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-hallo');
SET @g_x_tschuess=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-tschuess');
SET @g_x_danke=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-danke');
SET @g_x_bitte=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-bitte');
SET @g_x_wohnen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-wohnen');
SET @g_x_oesterreich=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-oesterreich');
SET @g_x_kommen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-kommen');
SET @g_x_deutschland=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-deutschland');
SET @g_x_buch=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-buch');
SET @g_x_moegen=(SELECT id FROM lexemes WHERE lexeme_key='lex-de-moegen');
SET @g_f_moechtest=(SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-moechtest');

INSERT IGNORE INTO activity_lexemes(activity_id,lexeme_id) VALUES
(@g_a_hallo,@g_x_hallo),(@g_a_hallo,@g_x_tschuess),
(@g_a_danke,@g_x_hallo),(@g_a_danke,@g_x_danke),(@g_a_danke,@g_x_bitte),
(@g_a_res,@g_x_wohnen),(@g_a_res,@g_x_oesterreich),(@g_a_res,@g_x_kommen),(@g_a_res,@g_x_deutschland),
(@g_a_obj,@g_x_buch),(@g_a_choice,@g_x_moegen);

INSERT INTO lexeme_occurrences
(occurrence_key,owner_type,owner_key,surface,start_offset,end_offset,lexeme_id,lexeme_form_id,resolution_status,resolution_notes) VALUES
('occ-act-de-hallo-farewell-tschuess','activity','act-de-hallo-farewell-choice','Tschüss!',NULL,NULL,@g_x_tschuess,NULL,'approved','گزینهٔ خداحافظی به واژه/عبارت منبع‌دار متصل است.'),
('occ-act-de-hallo-farewell-hallo','activity','act-de-hallo-farewell-choice','Hallo!',NULL,NULL,@g_x_hallo,NULL,'approved','گزینهٔ سلام به واژه/عبارت منبع‌دار متصل است.'),
('occ-act-de-danke-response-danke','activity','act-de-danke-bitte-response','Danke!',NULL,NULL,@g_x_danke,NULL,'approved','پرسش تمرین به عبارت تشکر منبع‌دار متصل است.'),
('occ-act-de-danke-response-bitte','activity','act-de-danke-bitte-response','Bitte!',NULL,NULL,@g_x_bitte,NULL,'approved','گزینهٔ پاسخ مؤدبانه به عبارت منبع‌دار متصل است.'),
('occ-act-de-danke-response-hallo','activity','act-de-danke-bitte-response','Hallo!',NULL,NULL,@g_x_hallo,NULL,'approved','گزینهٔ مقایسه‌ای به عبارت سلام منبع‌دار متصل است.'),
('occ-act-de-residence-match-wohnen','activity','act-de-residence-matching','wohnen',NULL,NULL,@g_x_wohnen,NULL,'approved','فعل محل زندگی به lexeme تأییدشده متصل است.'),
('occ-act-de-residence-match-oesterreich','activity','act-de-residence-matching','Österreich',NULL,NULL,@g_x_oesterreich,NULL,'approved','نام کشور به lexeme تأییدشده متصل است.'),
('occ-act-de-residence-match-kommen','activity','act-de-residence-matching','kommen',NULL,NULL,@g_x_kommen,NULL,'approved','فعل مبدأ به lexeme تأییدشده متصل است.'),
('occ-act-de-residence-match-deutschland','activity','act-de-residence-matching','Deutschland',NULL,NULL,@g_x_deutschland,NULL,'approved','نام کشور به lexeme تأییدشده متصل است.'),
('occ-act-de-object-order-buch','activity','act-de-object-word-order','Buch.',NULL,NULL,@g_x_buch,NULL,'approved','توکن با نشانه‌گذاری به «Buch» متصل است.'),
('occ-act-de-simple-choice-order-moechtest','activity','act-de-simple-choice-word-order','möchtest',NULL,NULL,@g_x_moegen,@g_f_moechtest,'approved','توکن صرف‌شده به «mögen» و فرم تأییدشدهٔ «möchtest» متصل است.')
ON DUPLICATE KEY UPDATE surface=VALUES(surface),lexeme_id=VALUES(lexeme_id),lexeme_form_id=VALUES(lexeme_form_id),resolution_status=VALUES(resolution_status),resolution_notes=VALUES(resolution_notes);

SET @g_si_hallo=(SELECT id FROM source_items WHERE item_key='srcitem-de-hallo-headword' LIMIT 1);
SET @g_si_tschuess=(SELECT id FROM source_items WHERE item_key='srcitem-de-tschuess' LIMIT 1);
SET @g_si_danke=(SELECT id FROM source_items WHERE item_key='srcitem-de-danke-headword' LIMIT 1);
SET @g_si_bitte=(SELECT id FROM source_items WHERE item_key='srcitem-de-bitte-response' LIMIT 1);
SET @g_si_res_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-wo-wohnen-sie' LIMIT 1);
SET @g_si_res_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-wohne-oesterreich' LIMIT 1);
SET @g_si_origin_q=(SELECT id FROM source_items WHERE item_key='srcitem-de-woher-kommen-sie' LIMIT 1);
SET @g_si_origin_a=(SELECT id FROM source_items WHERE item_key='srcitem-de-ich-komme-deutschland' LIMIT 1);
SET @g_si_object=(SELECT id FROM source_items WHERE item_key='srcitem-de-das-buch' LIMIT 1);
SET @g_si_choice=(SELECT id FROM source_items WHERE item_key='srcitem-de-was-moechtest-du' LIMIT 1);
SET @g_si_moechtest=(SELECT id FROM source_items WHERE item_key='srcitem-de-moegen-moechtest' LIMIT 1);

INSERT INTO provenance_links(entity_type,entity_key,source_item_id,transformation,notes) VALUES
('activity','act-de-hallo-farewell-choice',@g_si_tschuess,'options_selected_from_source_material','گزینهٔ درست مستقیماً از منبع خداحافظی آمده است.'),
('activity','act-de-hallo-farewell-choice',@g_si_hallo,'options_selected_from_source_material','گزینهٔ مقایسه‌ای مستقیماً از منبع سلام آمده است.'),
('activity','act-de-danke-bitte-response',@g_si_danke,'options_selected_from_source_material','عبارت محرک از منبع تشکر آمده است.'),
('activity','act-de-danke-bitte-response',@g_si_bitte,'options_selected_from_source_material','پاسخ درست از منبع کاربرد «Bitte!» آمده است.'),
('activity','act-de-danke-bitte-response',@g_si_hallo,'options_selected_from_source_material','گزینهٔ مقایسه‌ای از منبع سلام آمده است.'),
('activity','act-de-residence-matching',@g_si_res_q,'source_items_grouped_for_matching','پرسش محل زندگی از منبع آمده است.'),
('activity','act-de-residence-matching',@g_si_res_a,'source_items_grouped_for_matching','پاسخ محل زندگی از منبع آمده است.'),
('activity','act-de-residence-matching',@g_si_origin_q,'source_items_grouped_for_matching','پرسش مبدأ از منبع آمده است.'),
('activity','act-de-residence-matching',@g_si_origin_a,'source_items_grouped_for_matching','پاسخ مبدأ از منبع آمده است.'),
('activity','act-de-object-word-order',@g_si_object,'sentence_tokenized_for_word_order','جملهٔ منبع‌دار فقط برای مرتب‌سازی توکن‌بندی شده است.'),
('activity','act-de-simple-choice-word-order',@g_si_choice,'sentence_tokenized_for_word_order','پرسش منبع‌دار فقط برای مرتب‌سازی توکن‌بندی شده است.'),
('activity','act-de-simple-choice-word-order',@g_si_moechtest,'other','فرم «möchtest» به شاهد واژگانی منبع‌دار متصل است.')
ON DUPLICATE KEY UPDATE notes=VALUES(notes);

COMMIT;
-- END PRE-A1 ACTIVITY COUNT GUARDRAIL SYNC'''

MYSQL_SYNC_BLOCK = r'''# Authoring lesson activity counts and MySQL activity counts must be identical.
python - <<'PY' > /tmp/expected_lesson_activities.tsv
import json, pathlib
rows=[]
for path in pathlib.Path('content').glob('*/*/lessons/*.json'):
    data=json.loads(path.read_text(encoding='utf-8'))
    rows.append((data['languageId'], data['level'], data['id'], len(data.get('activities', [])), data.get('status','')))
for row in sorted(rows):
    print('\t'.join(map(str, row)))
PY
mysql_cmd -e "
  SELECT lang.code,ll.cefr_level,l.lesson_key,COUNT(a.id)
  FROM lessons l
  JOIN language_levels ll ON ll.id=l.language_level_id
  JOIN languages lang ON lang.id=ll.language_id
  LEFT JOIN activities a ON a.lesson_id=l.id
  GROUP BY lang.code,ll.cefr_level,l.lesson_key
  ORDER BY lang.code,FIELD(ll.cefr_level,'Pre-A1','A1','A2','B1','B2','C1','C2'),l.sequence_index,l.lesson_key;
" > /tmp/actual_lesson_activities.tsv

python - <<'PY'
import json, pathlib, sys
expected={}
statuses={}
for line in pathlib.Path('/tmp/expected_lesson_activities.tsv').read_text(encoding='utf-8').splitlines():
    if line.strip():
        lang, level, lesson, count, status=line.split('\t')
        key=(lang,level,lesson)
        expected[key]=int(count)
        statuses[key]=status
actual={}
for line in pathlib.Path('/tmp/actual_lesson_activities.tsv').read_text(encoding='utf-8').splitlines():
    if line.strip():
        lang, level, lesson, count=line.split('\t')
        actual[(lang,level,lesson)]=int(count)
if expected != actual:
    print('Authoring/MySQL lesson activity-count mismatch')
    missing=set(expected)-set(actual)
    extra=set(actual)-set(expected)
    changed={k:(expected[k],actual[k]) for k in expected.keys() & actual.keys() if expected[k] != actual[k]}
    print('Missing:', sorted(missing))
    print('Extra:', sorted(extra))
    print('Changed:', changed)
    sys.exit(1)
bounds=json.loads(pathlib.Path('config/activity-count-bounds.json').read_text(encoding='utf-8')).get('levels',{})
bad=[]
for key,count in sorted(actual.items()):
    if statuses.get(key) != 'final':
        continue
    level=key[1]
    rule=bounds.get(level)
    if not rule:
        continue
    minimum=rule['minActivities']; maximum=rule['maxActivities']
    if not minimum <= count <= maximum:
        bad.append((key,count,minimum,maximum))
if bad:
    print('Final MySQL lessons outside configured activity-count bounds:')
    for key,count,minimum,maximum in bad:
        print(f'- {key}: {count}, expected {minimum}-{maximum}')
    sys.exit(1)
print(f'Authoring/MySQL activity counts are synchronized for {len(expected)} lessons.')
PY

'''

sql = SQL_PATH.read_text(encoding="utf-8")
if SQL_MARKER not in sql:
    SQL_PATH.write_text(sql.rstrip() + "\n\n" + SQL_BLOCK + "\n", encoding="utf-8")

validator = MYSQL_VALIDATOR.read_text(encoding="utf-8")
anchor = "# Dialogue starter is canonical relational data in MySQL and must match authoring JSON."
if "Authoring lesson activity counts and MySQL activity counts must be identical." not in validator:
    if anchor not in validator:
        raise SystemExit(f"Missing validator anchor: {anchor}")
    validator = validator.replace(anchor, MYSQL_SYNC_BLOCK + anchor, 1)
    MYSQL_VALIDATOR.write_text(validator, encoding="utf-8")

print("Pre-A1 SQL and MySQL activity-count validation synchronized.")
