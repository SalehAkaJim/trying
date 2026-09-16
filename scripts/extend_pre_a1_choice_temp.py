#!/usr/bin/env python3
import json
from pathlib import Path

ROOT=Path('.')

def dump(path,data):
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

def add_unique(seq,item):
    if item not in seq: seq.append(item)

def replace_once(text,old,new,label):
    if old not in text:
        raise SystemExit(f'{label} anchor not found')
    return text.replace(old,new,1)

# --- Authoring sources -------------------------------------------------------
dump(ROOT/'content/de/sources/oak-was-moechtest-du.json',{
  'schemaVersion':'1.0.0','id':'src-oak-de-was-moechtest-du',
  'title':"Oak National Academy: Was möchtest du? Present and conditional 'mögen'",
  'organizationOrAuthor':'Oak National Academy','language':'de','sourceType':'course',
  'url':'https://www.thenational.academy/teachers/programmes/german-secondary-ks4-edexcel/units/people-and-lifestyle-positive-lebensentscheidungen/lessons/was-mochtest-du-present-and-conditional-mogen',
  'locator':"Lesson title and key learning points: Was möchtest du? / conditional form of mögen",
  'publishedOrUpdatedAt':None,'modernityStatus':'contemporary_verified',
  'currencyEvidence':'صفحهٔ آموزشی زندهٔ Oak National Academy در سپتامبر ۲۰۲۶ بررسی شده است؛ خود درس استفادهٔ معاصر از «Was möchtest du?» و شکل «möcht-» را آموزش می‌دهد و شرایط فعلی Oak محتوای جدید را تحت OGL v3.0 منتشر می‌کند مگر خلاف آن ذکر شده باشد.',
  'licenseName':'Open Government Licence v3.0 (OGL)','licenseUrl':'https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/',
  'attributionText':'A German lesson by Oak National Academy licensed under Open Government Licence v3.0 (OGL)',
  'reuseStatus':'reuse_with_attribution','retrievedAt':'2026-09-16',
  'notes':'منبع دقیق پرسش «Was möchtest du?» و شاهد آموزشی معاصر برای کاربرد «möcht-».'
})

dump(ROOT/'content/de/sources/wiktionary-moechten.json',{
  'schemaVersion':'1.0.0','id':'src-wiktionary-de-moechten','title':'Wiktionary: möchten',
  'organizationOrAuthor':'Wiktionary contributors','language':'de','sourceType':'dictionary',
  'url':'https://de.wiktionary.org/wiki/m%C3%B6chten','locator':'German möchten entry; inflected form of mögen and second-person singular möchtest',
  'publishedOrUpdatedAt':None,'modernityStatus':'maintained_current',
  'currencyEvidence':'مدخل زنده و نگهداری‌شدهٔ Wiktionary در سپتامبر ۲۰۲۶ بررسی شده و «möchten» را به‌عنوان صورت صرف‌شدهٔ «mögen» و کاربرد معاصر آن ثبت می‌کند.',
  'licenseName':'CC BY-SA 4.0','licenseUrl':'https://creativecommons.org/licenses/by-sa/4.0/',
  'attributionText':'Wiktionary contributors — https://de.wiktionary.org/wiki/m%C3%B6chten',
  'reuseStatus':'reuse_with_attribution','retrievedAt':'2026-09-16',
  'notes':'مرجع شکل «möchtest» و پیوند آن با lexeme «mögen».'
})

# --- Lexeme form -------------------------------------------------------------
dump(ROOT/'content/de/lexeme_forms/moegen-moechtest.json',{
  'schemaVersion':'1.0.0','id':'lexform-de-moegen-moechtest','lexemeId':'lex-de-moegen','surface':'möchtest','formType':'inflected',
  'features':{'mood':'subjunctive_II','person':'2','number':'singular'},
  'origin':'reference_attested','reviewStatus':'approved',
  'sourceRefs':['src-wiktionary-de-moechten','src-oak-de-was-moechtest-du'],
  'notes':'در پرسش منبع‌دار «Was möchtest du?» به‌صورت دوم‌شخص مفرد به lexeme پایهٔ «mögen» متصل است.'
})
moegen_path=ROOT/'content/de/lexemes/moegen.json'
moegen=json.loads(moegen_path.read_text(encoding='utf-8'))
add_unique(moegen.setdefault('formRefs',[]),'lexform-de-moegen-moechtest')
dump(moegen_path,moegen)

# --- Dialogue / lesson -------------------------------------------------------
dump(ROOT/'content/de/pre-a1/dialogues/simple-choice.json',{
  'id':'dlg-de-pre-a1-simple-choice','languageId':'de','level':'Pre-A1',
  'sourceRefs':['src-wiktionary-de-hallo','src-oak-de-was-moechtest-du','src-wiktionary-de-moechten','src-wiktionary-de-pizza'],
  'scenario':'میا و زبان‌آموز سلام می‌کنند؛ میا با یک پرسش بسیار کوتاه می‌پرسد زبان‌آموز چه می‌خواهد و زبان‌آموز یک گزینهٔ کاملاً آشنا را انتخاب می‌کند.',
  'openingInitiator':'app','characterRefs':['char-de-mia','char-de-learner'],
  'turns':[
    {'id':'turn-de-choice-1','speakerCharacterId':'char-de-mia','speakerIdentityOrigin':'app_assigned','speakerGenderEvidence':'unspecified','textTarget':'Hallo!','translationFa':'سلام!','learnerTurn':False,'lexemeRefs':['lex-de-hallo'],'lexemeOccurrences':[{'surface':'Hallo','lexemeId':'lex-de-hallo','lexemeFormId':None}],'sourceRefs':['src-wiktionary-de-hallo'],'audioRef':None},
    {'id':'turn-de-choice-2','speakerCharacterId':'char-de-learner','speakerIdentityOrigin':'app_assigned','speakerGenderEvidence':'unspecified','textTarget':'Hallo!','translationFa':'سلام!','learnerTurn':True,'lexemeRefs':['lex-de-hallo'],'lexemeOccurrences':[{'surface':'Hallo','lexemeId':'lex-de-hallo','lexemeFormId':None}],'sourceRefs':['src-wiktionary-de-hallo'],'audioRef':None},
    {'id':'turn-de-choice-3','speakerCharacterId':'char-de-mia','speakerIdentityOrigin':'app_assigned','speakerGenderEvidence':'unspecified','textTarget':'Was möchtest du?','translationFa':'چی می‌خوای؟','learnerTurn':False,'lexemeRefs':['lex-de-moegen'],'lexemeOccurrences':[{'surface':'möchtest','lexemeId':'lex-de-moegen','lexemeFormId':'lexform-de-moegen-moechtest'}],'sourceRefs':['src-oak-de-was-moechtest-du','src-wiktionary-de-moechten'],'audioRef':None},
    {'id':'turn-de-choice-4','speakerCharacterId':'char-de-learner','speakerIdentityOrigin':'app_assigned','speakerGenderEvidence':'unspecified','textTarget':'Pizza.','translationFa':'پیتزا.','learnerTurn':True,'lexemeRefs':['lex-de-pizza'],'lexemeOccurrences':[{'surface':'Pizza','lexemeId':'lex-de-pizza','lexemeFormId':None}],'sourceRefs':['src-wiktionary-de-pizza'],'audioRef':None}
  ],
  'sceneQualityRationale':'درس نهم هنوز در بازهٔ ده درس اول است؛ مکالمه دقیقاً چهار turn دارد و فقط یک پرسش تازه را با یک پاسخ واژگانی از قبل آشنا ترکیب می‌کند.'
})

dump(ROOT/'content/de/pre-a1/lessons/simple-choice.json',{
  'schemaVersion':'1.0.0','id':'de-pre-a1-lesson-simple-choice','languageId':'de','level':'Pre-A1','unitRef':'de-pre-a1-unit-first-steps',
  'titleFa':'چی می‌خوای؟','sourceTitle':'Was möchtest du? / Pizza',
  'learningTargets':['پرسش کوتاه «Was möchtest du?» را بفهمد.','با یک گزینهٔ کاملاً آشنا مثل «Pizza.» انتخاب ساده انجام دهد.','فرم «möchtest» را به lexeme پایهٔ «mögen» مرتبط کند.'],
  'sourceRefs':['src-wiktionary-de-hallo','src-oak-de-was-moechtest-du','src-wiktionary-de-moechten','src-wiktionary-de-pizza'],
  'lexemeRefs':['lex-de-hallo','lex-de-moegen','lex-de-pizza'],'grammarNoteRefs':[],
  'activityDesign':{
    'activitySelectionRationale':'هدف این مرحله فقط فهم یک پرسش سادهٔ خواستن و انتخاب یک گزینهٔ آشناست؛ همان گفت‌وگوی چهار turn هدف را کامل پوشش می‌دهد و تمرین اضافه در این لحظه فقط تکرار مکانیکی ایجاد می‌کند.',
    'sequenceRationale':'زبان‌آموز ابتدا زبان آشنای سلام را بازیابی می‌کند، سپس پرسش تازهٔ «Was möchtest du?» را می‌شنود و بدون واژهٔ جدید با «Pizza.» پاسخ می‌دهد.',
    'templateSignature':'conversation_speaking'
  },
  'activities':[{
    'id':'act-de-simple-choice-conversation','type':'conversation_speaking',
    'instructionFa':'با میا سلام کن؛ وقتی می‌پرسد «Was möchtest du?» گزینهٔ آشنای «Pizza.» را انتخاب کن.',
    'selectionReason':'پرسش تازه با یک پاسخ از قبل آشنا تمرین می‌شود تا بار شناختی فقط روی «möchtest» و مفهوم انتخاب بماند.',
    'sourceRefs':['src-wiktionary-de-hallo','src-oak-de-was-moechtest-du','src-wiktionary-de-moechten','src-wiktionary-de-pizza'],
    'learningTargets':['فهم «Was möchtest du?» و انتخاب یک گزینهٔ آشنا.'],
    'lexemeRefs':['lex-de-hallo','lex-de-moegen','lex-de-pizza'],'dialogueRef':'dlg-de-pre-a1-simple-choice',
    'data':{'interaction':'read_aloud_exchange','openingInitiator':'app'},
    'transformations':['persian_translation_added','character_metadata_added'],'audioStatus':'not_required'
  }],
  'status':'draft','audioStatus':'blocked_until_level_final'
})

# --- Level/unit manifests ----------------------------------------------------
level_path=ROOT/'content/de/pre-a1/level.json'; level=json.loads(level_path.read_text(encoding='utf-8'))
add_unique(level['coverage']['communicativeTargets'],'فهم پرسش «Was möchtest du?» و انتخاب یک گزینهٔ آشنا')
add_unique(level['coverage']['linguisticTargets'],'فرم «möchtest» از «mögen» برای بیان خواستن در یک پرسش ساده')
add_unique(level['coverage']['situations'],'انتخاب یک چیز آشنا در پاسخ به یک پرسش کوتاه')
level['coverage']['gaps']=[x for x in level['coverage']['gaps'] if x!='خواستن و انتخاب‌کردن چیزهای ساده']
for x in ['src-oak-de-was-moechtest-du','src-wiktionary-de-moechten']:
    add_unique(level['sourceRefs'],x)
add_unique(level['lessonRefs'],'de-pre-a1-lesson-simple-choice')
dump(level_path,level)

unit_path=ROOT/'content/de/pre-a1/units/first-steps.json'; unit=json.loads(unit_path.read_text(encoding='utf-8'))
add_unique(unit['learningTargets'],'فهم یک پرسش کوتاه دربارهٔ خواستن و انتخاب یک گزینهٔ آشنا')
add_unique(unit['lessonRefs'],'de-pre-a1-lesson-simple-choice')
for x in ['src-oak-de-was-moechtest-du','src-wiktionary-de-moechten']:
    add_unique(unit['sourceRefs'],x)
dump(unit_path,unit)

# --- MySQL snapshot ----------------------------------------------------------
p=ROOT/'database/content/de/pre-a1.sql'; s=p.read_text(encoding='utf-8')
if 'de-pre-a1-lesson-simple-choice' not in s:
    s=s.replace('-- Current snapshot: 8 source-backed beginner lessons.','-- Current snapshot: 9 source-backed beginner lessons.')
    s=replace_once(s,"  'احوال‌پرسی بسیار ساده با «Wie geht''s?» و «Gut.»'\n ),","  'احوال‌پرسی بسیار ساده با «Wie geht''s?» و «Gut.»',\n  'فهم پرسش «Was möchtest du?» و انتخاب یک گزینهٔ آشنا'\n ),",'coverage communicative')
    s=replace_once(s,"  'عبارت «Wie geht''s?» و پاسخ کوتاه «Gut.»'\n ),","  'عبارت «Wie geht''s?» و پاسخ کوتاه «Gut.»',\n  'فرم «möchtest» از «mögen» برای بیان خواستن در یک پرسش ساده'\n ),",'coverage linguistic')
    s=replace_once(s,"  'پرسیدن نام در آشنایی اولیه','احوال‌پرسی بسیار کوتاه'\n ),","  'پرسیدن نام در آشنایی اولیه','احوال‌پرسی بسیار کوتاه',\n  'انتخاب یک چیز آشنا در پاسخ به یک پرسش کوتاه'\n ),",'coverage situations')
    s=s.replace("  'خواستن و انتخاب‌کردن چیزهای ساده',\n",'')

    target_anchor="(@level,'de.pre_a1.notice_heissen_forms','linguistic','ارتباط «heiße» و «heißt» با «heißen»','شکل‌های «heiße» و «heißt» را به lexeme پایهٔ «heißen» مرتبط کند.',FALSE,'partial',JSON_OBJECT('lexemeFormAware',TRUE))"
    target_new=target_anchor+",\n(@level,'de.pre_a1.choose_simple_item','communicative','فهم «Was möchtest du?» و انتخاب ساده','پرسش «Was möchtest du?» را بفهمد و با یک گزینهٔ آشنا پاسخ دهد.',TRUE,'partial',JSON_OBJECT('zeroBeginner',TRUE)),\n(@level,'de.pre_a1.notice_moegen_moechtest','linguistic','ارتباط «möchtest» با «mögen»','فرم «möchtest» را به lexeme پایهٔ «mögen» مرتبط کند.',FALSE,'partial',JSON_OBJECT('lexemeFormAware',TRUE))"
    s=replace_once(s,target_anchor,target_new,'curriculum target')
    s=replace_once(s,"SET @t_heissen := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.notice_heissen_forms');", "SET @t_heissen := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.notice_heissen_forms');\nSET @t_choice := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.choose_simple_item');\nSET @t_moechtest := (SELECT id FROM curriculum_targets WHERE language_level_id=@level AND target_key='de.pre_a1.notice_moegen_moechtest');",'target vars')

    # Sources section: insert before its ON DUPLICATE.
    marker="\nON DUPLICATE KEY UPDATE title=VALUES(title),organization_or_author=VALUES(organization_or_author)"
    source_rows=",\n('src-oak-de-was-moechtest-du','Oak National Academy: Was möchtest du? Present and conditional ''mögen''','Oak National Academy','de','course','https://www.thenational.academy/teachers/programmes/german-secondary-ks4-edexcel/units/people-and-lifestyle-positive-lebensentscheidungen/lessons/was-mochtest-du-present-and-conditional-mogen',NULL,'contemporary_verified','صفحهٔ آموزشی زندهٔ Oak National Academy در سپتامبر ۲۰۲۶ بررسی شده است؛ خود درس کاربرد معاصر «Was möchtest du?» و «möcht-» را آموزش می‌دهد و محتوای جدید Oak تحت OGL v3.0 منتشر می‌شود مگر خلاف آن ذکر شده باشد.','Open Government Licence v3.0 (OGL)','https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/','A German lesson by Oak National Academy licensed under Open Government Licence v3.0 (OGL)','reuse_with_attribution','2026-09-16','منبع دقیق پرسش «Was möchtest du?».'),\n('src-wiktionary-de-moechten','Wiktionary: möchten','Wiktionary contributors','de','dictionary','https://de.wiktionary.org/wiki/m%C3%B6chten',NULL,'maintained_current','مدخل زنده و نگهداری‌شدهٔ Wiktionary در سپتامبر ۲۰۲۶ بررسی شده و «möchten» را به‌عنوان صورت صرف‌شدهٔ «mögen» ثبت می‌کند.','CC BY-SA 4.0','https://creativecommons.org/licenses/by-sa/4.0/','Wiktionary contributors — https://de.wiktionary.org/wiki/m%C3%B6chten','reuse_with_attribution','2026-09-16','مرجع شکل «möchtest» و پیوند آن با «mögen».')"
    s=replace_once(s,marker,source_rows+marker,'source rows')
    s=replace_once(s,"SET @s_heissen := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-heissen');", "SET @s_heissen := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-heissen');\nSET @s_oak_choice := (SELECT id FROM sources WHERE source_key='src-oak-de-was-moechtest-du');\nSET @s_moechten := (SELECT id FROM sources WHERE source_key='src-wiktionary-de-moechten');",'source vars')

    item_anchor="(@s_heissen,'srcitem-de-heissen-heisst','Present form','heißt',UNHEX(SHA2('heißt',256)),'دوم‌شخص مفرد حال.')"
    s=replace_once(s,item_anchor,item_anchor+",\n(@s_oak_choice,'srcitem-de-was-moechtest-du','Lesson title / key learning point','Was möchtest du?',UNHEX(SHA2('Was möchtest du?',256)),'پرسش دقیق منبع.'),\n(@s_moechten,'srcitem-de-moegen-moechtest','Second-person singular form','möchtest',UNHEX(SHA2('möchtest',256)),'فرم دوم‌شخص مفرد «mögen» در Konjunktiv II.')",'source items')
    s=replace_once(s,"SET @si_heisst := (SELECT id FROM source_items WHERE source_id=@s_heissen AND item_key='srcitem-de-heissen-heisst');", "SET @si_heisst := (SELECT id FROM source_items WHERE source_id=@s_heissen AND item_key='srcitem-de-heissen-heisst');\nSET @si_choice_q := (SELECT id FROM source_items WHERE source_id=@s_oak_choice AND item_key='srcitem-de-was-moechtest-du');\nSET @si_moechtest := (SELECT id FROM source_items WHERE source_id=@s_moechten AND item_key='srcitem-de-moegen-moechtest');",'source item vars')

    lesson_anchor="('de-pre-a1-lesson-wellbeing',@level,@unit,8,8,'حالت چطوره؟','Wie geht''s? / Gut.','draft',\n 'بعد از گفت‌وگو، fill blank فقط عبارت تازهٔ «Wie geht''s?» را با حذف یک بخش کوچک بازیابی می‌کند و بار شناختی را پایین نگه می‌دارد.',\n 'اول معنی و پاسخ در مکالمه دیده می‌شود و بعد همان عبارت منبع‌دار با یک جای‌خالی ساده بازیابی می‌شود.','conversation_speaking>fill_blank','blocked_until_level_final',NULL)"
    lesson_new=lesson_anchor+",\n('de-pre-a1-lesson-simple-choice',@level,@unit,9,9,'چی می‌خوای؟','Was möchtest du? / Pizza','draft',\n 'هدف این مرحله فقط فهم یک پرسش سادهٔ خواستن و انتخاب یک گزینهٔ آشناست؛ همان گفت‌وگوی چهار turn هدف را کامل پوشش می‌دهد و تمرین اضافه لازم نیست.',\n 'زبان‌آموز ابتدا سلام آشنا را بازیابی می‌کند، سپس پرسش تازه را می‌شنود و بدون واژهٔ جدید با «Pizza.» پاسخ می‌دهد.','conversation_speaking','blocked_until_level_final',NULL)"
    s=replace_once(s,lesson_anchor,lesson_new,'lesson row')
    s=replace_once(s,"SET @l8 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-wellbeing');", "SET @l8 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-wellbeing');\nSET @l9 := (SELECT id FROM lessons WHERE lesson_key='de-pre-a1-lesson-simple-choice');",'lesson var')
    s=s.replace('(@unit,@t_apology),(@unit,@t_name),(@unit,@t_heissen),(@unit,@t_wellbeing);','(@unit,@t_apology),(@unit,@t_name),(@unit,@t_heissen),(@unit,@t_wellbeing),(@unit,@t_choice),(@unit,@t_moechtest);')
    s=s.replace("(@l8,@t_wellbeing,'introduce'),(@l8,@t_hallo,'review');", "(@l8,@t_wellbeing,'introduce'),(@l8,@t_hallo,'review'),\n(@l9,@t_choice,'introduce'),(@l9,@t_moechtest,'support'),(@l9,@t_hallo,'review');")

    dlg_anchor="('dlg-de-pre-a1-wellbeing',@level,'میا و زبان‌آموز سلام می‌کنند و میا یک احوال‌پرسی خیلی کوتاه می‌پرسد که زبان‌آموز با یک پاسخ ساده جواب می‌دهد.','app','فقط چهار turn لازم برای سلام و یک احوال‌پرسی پایه نگه داشته شده و هیچ عبارت اضافی برای طولانی‌کردن صحنه وارد نشده است.')"
    dlg_new=dlg_anchor+",\n('dlg-de-pre-a1-simple-choice',@level,'میا و زبان‌آموز سلام می‌کنند؛ میا می‌پرسد زبان‌آموز چه می‌خواهد و زبان‌آموز یک گزینهٔ کاملاً آشنا را انتخاب می‌کند.','app','درس نهم هنوز در بازهٔ ده درس اول است؛ مکالمه دقیقاً چهار turn دارد و فقط یک پرسش تازه را با یک پاسخ آشنا ترکیب می‌کند.')"
    s=replace_once(s,dlg_anchor,dlg_new,'dialogue row')
    s=replace_once(s,"SET @d8 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-wellbeing');", "SET @d8 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-wellbeing');\nSET @d9 := (SELECT id FROM dialogues WHERE dialogue_key='dlg-de-pre-a1-simple-choice');",'dialogue var')

    turn_anchor="('turn-de-wellbeing-4',@d8,4,@learner,'app_assigned','unspecified','Gut.','خوبم.',TRUE,'blocked_until_level_final',NULL,NULL)"
    turn_new=turn_anchor+",\n\n('turn-de-choice-1',@d9,1,@mia,'app_assigned','unspecified','Hallo!','سلام!',FALSE,'blocked_until_level_final',NULL,NULL),\n('turn-de-choice-2',@d9,2,@learner,'app_assigned','unspecified','Hallo!','سلام!',TRUE,'blocked_until_level_final',NULL,NULL),\n('turn-de-choice-3',@d9,3,@mia,'app_assigned','unspecified','Was möchtest du?','چی می‌خوای؟',FALSE,'blocked_until_level_final',NULL,NULL),\n('turn-de-choice-4',@d9,4,@learner,'app_assigned','unspecified','Pizza.','پیتزا.',TRUE,'blocked_until_level_final',NULL,NULL)"
    s=replace_once(s,turn_anchor,turn_new,'dialogue turns')
    s=s.replace('WHERE dialogue_id IN (@d1,@d2,@d3,@d4,@d5,@d6,@d7,@d8)', 'WHERE dialogue_id IN (@d1,@d2,@d3,@d4,@d5,@d6,@d7,@d8,@d9)')
    s=s.replace("'turn-de-wellbeing-3','turn-de-wellbeing-4');", "'turn-de-wellbeing-3','turn-de-wellbeing-4','turn-de-choice-1','turn-de-choice-2','turn-de-choice-3','turn-de-choice-4');")

    act_anchor=" JSON_ARRAY('source_sentence_blanked'),'not_required')\nON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id)"
    act_new=" JSON_ARRAY('source_sentence_blanked'),'not_required'),\n\n('act-de-simple-choice-conversation',@l9,1,'conversation_speaking',\n 'با میا سلام کن؛ وقتی می‌پرسد «Was möchtest du?» گزینهٔ آشنای «Pizza.» را انتخاب کن.',\n 'پرسش تازه با پاسخ از قبل آشنا تمرین می‌شود تا بار شناختی فقط روی «möchtest» و مفهوم انتخاب بماند.',@d9,\n JSON_OBJECT('interaction','read_aloud_exchange','openingInitiator','app'),\n JSON_ARRAY('persian_translation_added','character_metadata_added'),'not_required')\nON DUPLICATE KEY UPDATE lesson_id=VALUES(lesson_id)"
    s=replace_once(s,act_anchor,act_new,'activity row')
    s=replace_once(s,"SET @a14 := (SELECT id FROM activities WHERE activity_key='act-de-wellbeing-fill');", "SET @a14 := (SELECT id FROM activities WHERE activity_key='act-de-wellbeing-fill');\nSET @a15 := (SELECT id FROM activities WHERE activity_key='act-de-simple-choice-conversation');",'activity var')

    form_anchor="('lexform-de-moegen-magst',@x_moegen,'magst','magst','inflected',JSON_OBJECT('tense','present','mood','indicative','person','2','number','singular'),'reference_attested','approved','در پرسش منبع‌دار «Magst du Pizza?» به‌صورت دوم‌شخص مفرد استفاده شده است.'),"
    form_new=form_anchor+"\n('lexform-de-moegen-moechtest',@x_moegen,'möchtest','möchtest','inflected',JSON_OBJECT('mood','subjunctive_II','person','2','number','singular'),'reference_attested','approved','در پرسش منبع‌دار «Was möchtest du?» به lexeme پایهٔ «mögen» متصل است.'),"
    s=replace_once(s,form_anchor,form_new,'lexeme form')
    s=replace_once(s,"SET @f_magst := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-magst');", "SET @f_magst := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-magst');\nSET @f_moechtest := (SELECT id FROM lexeme_forms WHERE lexeme_form_key='lexform-de-moegen-moechtest');",'form var')
    s=s.replace("(@l8,@x_hallo,FALSE,'review'),(@l8,@x_wiegehts,TRUE,'introduce'),(@l8,@x_gut,TRUE,'introduce');", "(@l8,@x_hallo,FALSE,'review'),(@l8,@x_wiegehts,TRUE,'introduce'),(@l8,@x_gut,TRUE,'introduce'),\n(@l9,@x_hallo,FALSE,'review'),(@l9,@x_moegen,TRUE,'practice'),(@l9,@x_pizza,FALSE,'review');")
    s=s.replace("(@a13,@x_hallo),(@a13,@x_wiegehts),(@a13,@x_gut),(@a14,@x_wiegehts),(@a14,@x_gut);", "(@a13,@x_hallo),(@a13,@x_wiegehts),(@a13,@x_gut),(@a14,@x_wiegehts),(@a14,@x_gut),\n(@a15,@x_hallo),(@a15,@x_moegen),(@a15,@x_pizza);")
    s=s.replace("(@a13,@t_wellbeing),(@a14,@t_wellbeing);", "(@a13,@t_wellbeing),(@a14,@t_wellbeing),\n(@a15,@t_choice),(@a15,@t_moechtest);")

    occ_anchor="('occ-act-de-name-order-heisse','activity','act-de-name-word-order','heiße',NULL,NULL,@x_heissen,@f_heisse,'approved','توکن «heiße» به «heißen» متصل است.');"
    occ_new="('occ-act-de-name-order-heisse','activity','act-de-name-word-order','heiße',NULL,NULL,@x_heissen,@f_heisse,'approved','توکن «heiße» به «heißen» متصل است.'),\n('occ-turn-de-choice-1-1','dialogue_turn','turn-de-choice-1','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال «Hallo» تأیید شده است.'),\n('occ-turn-de-choice-2-1','dialogue_turn','turn-de-choice-2','Hallo',NULL,NULL,@x_hallo,NULL,'approved','اتصال «Hallo» تأیید شده است.'),\n('occ-turn-de-choice-3-1','dialogue_turn','turn-de-choice-3','möchtest',NULL,NULL,@x_moegen,@f_moechtest,'approved','فرم «möchtest» به «mögen» متصل است.'),\n('occ-turn-de-choice-4-1','dialogue_turn','turn-de-choice-4','Pizza',NULL,NULL,@x_pizza,NULL,'approved','اتصال «Pizza» تأیید شده است.');"
    s=replace_once(s,occ_anchor,occ_new,'occurrences')

    s=replace_once(s,"('lesson','de-pre-a1-lesson-wellbeing',@si_gut,'other','منبع پشتیبان این درس.'),", "('lesson','de-pre-a1-lesson-wellbeing',@si_gut,'other','منبع پشتیبان این درس.'),\n('lesson','de-pre-a1-lesson-simple-choice',@si_choice_q,'other','منبع اصلی پرسش این درس.'),\n('lesson','de-pre-a1-lesson-simple-choice',@si_pizza,'other','پاسخ واژگانی آشنا از منبع آمده است.'),",'lesson provenance')
    s=replace_once(s,"('dialogue_turn','turn-de-wellbeing-4',@si_gut,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),", "('dialogue_turn','turn-de-wellbeing-4',@si_gut,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),\n('dialogue_turn','turn-de-choice-1',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),\n('dialogue_turn','turn-de-choice-2',@si_hallo,'persian_translation_added','متن هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),\n('dialogue_turn','turn-de-choice-3',@si_choice_q,'persian_translation_added','پرسش دقیق منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),\n('dialogue_turn','turn-de-choice-4',@si_pizza,'persian_translation_added','واژهٔ هدف منبع‌دار است و ترجمهٔ فارسی افزوده شده است.'),",'turn provenance')
    s=replace_once(s,"('lexeme_form','lexform-de-moegen-magst',@si_magst,'verbatim','شکل تأییدشدهٔ «mögen».'),", "('lexeme_form','lexform-de-moegen-magst',@si_magst,'verbatim','شکل تأییدشدهٔ «mögen».'),\n('lexeme_form','lexform-de-moegen-moechtest',@si_moechtest,'verbatim','شکل تأییدشدهٔ «mögen» برای پرسش خواستن.'),",'form provenance')

    p.write_text(s,encoding='utf-8')

print('Prepared German Pre-A1 simple-choice lesson and MySQL snapshot.')
