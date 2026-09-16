#!/usr/bin/env python3
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
ALIASES={
    'source_backed_pairs_grouped':'source_items_grouped_for_matching',
    'source_sentence_blanked':'source_sentence_blank_created',
}
changed=0
for path in (ROOT/'content').glob('*/*/lessons/*.json'):
    data=json.loads(path.read_text(encoding='utf-8'))
    dirty=False
    for activity in data.get('activities',[]):
        old=activity.get('transformations') or []
        new=[ALIASES.get(x,x) for x in old]
        if new!=old:
            activity['transformations']=new
            dirty=True
    if dirty:
        path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        changed+=1

# The activity-transformation taxonomy must exactly cover the canonical codes
# accepted by schemas/activity.schema.json. Legacy aliases are migrated above
# rather than kept as parallel meanings.
tax_path=ROOT/'config/fa-taxonomy.json'
tax=json.loads(tax_path.read_text(encoding='utf-8'))
tax['domains']['activity_transformation']={
    'verbatim_dialogue':'گفت‌وگو عیناً از منبع استفاده شده',
    'persian_translation_added':'ترجمهٔ فارسی افزوده شده',
    'sentence_tokenized_for_word_order':'جمله برای مرتب‌سازی کلمات بخش‌بندی شده',
    'source_sentence_blank_created':'از جملهٔ منبع جای خالی ساخته شده',
    'source_items_grouped_for_matching':'موارد منبع برای تطبیق گروه‌بندی شده',
    'options_selected_from_source_material':'گزینه‌ها از محتوای منبع انتخاب شده‌اند',
    'character_metadata_added':'فرادادهٔ شخصیت افزوده شده',
    'cefr_level_assigned_by_app':'سطح CEFR توسط اپلیکیشن تعیین شده',
    'other':'سایر',
}
tax_path.write_text(json.dumps(tax,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(f'Normalized transformation codes in {changed} lesson files and aligned taxonomy.')
