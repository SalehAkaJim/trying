#!/usr/bin/env python3
from pathlib import Path
import json

ROOT=Path(__file__).resolve().parents[1]
def load(p): return json.loads((ROOT/p).read_text(encoding="utf-8"))
def dump(p,d):
    q=ROOT/p; q.parent.mkdir(parents=True,exist_ok=True)
    q.write_text(json.dumps(d,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
def vp(g,vid=None,vname=None):
    return {"clarity":"high","stressLevel":"very_low","aggressiveness":"none","toneConsistency":"high","ageImpression":"young_adult","genderImpression":g,"elevenLabsVoiceId":vid,"voiceName":vname}

chars={
"mia":{"id":"char-de-mia","name":"Mia","gender":"female","tags":["classmate","friend"],"rels":[("char-de-max","classmate","میا و مکس هم‌کلاسی‌اند و در چند درس ابتدایی دوباره با هم صحبت می‌کنند."),("char-de-lena","friend","میا و لنا دوست‌اند و می‌توانند در درس‌های بعدی خط داستانی مشترک داشته باشند.")],"notes":"میا ۲۰ ساله است. تاریخ تولد او سیزدهم نوامبر و شمارهٔ تمرینی او 692-267-752 است.","voice":vp("female","gJx1vCzNCD1EQHT212Ls","Ava – Natural AI Voice")},
"max":{"id":"char-de-max","name":"Max","gender":"male","tags":["classmate"],"rels":[("char-de-mia","classmate","مکس و میا هم‌کلاسی‌اند و چند گفت‌وگوی پایه را با هم پیش می‌برند.")],"notes":"مکس ۱۸ ساله است. تاریخ تولد او ۱۶ ژوئیه و شمارهٔ تمرینی او 789 است. زبان‌آموز در چند صحنه نقش مکس را بازی می‌کند.","voice":vp("male")},
"lena":{"id":"char-de-lena","name":"Lena","gender":"female","tags":["friend","neighbor"],"rels":[("char-de-mia","friend","لنا و میا دوست‌اند."),("char-de-jonas","neighbor","لنا و یوناس همسایه‌اند و موقعیت‌های روزمرهٔ ساده می‌توانند بین آن‌ها ادامه پیدا کنند.")],"notes":"لنا جوان، دوستانه و آرام است. زبان‌آموز در برخی صحنه‌های روزمره نقش لنا را بازی می‌کند.","voice":vp("female")},
"jonas":{"id":"char-de-jonas","name":"Jonas","gender":"male","tags":["neighbor"],"rels":[("char-de-lena","neighbor","یوناس و لنا همسایه‌اند.")],"notes":"یوناس جوان و خوش‌برخورد است و در یکی از موقعیت‌های انتخاب غذا نقش کارمند کافه را دارد.","voice":vp("male"),"roles":["conversation_partner","cafe_staff"]},
"iris":{"id":"char-de-iris","name":"Iris","gender":"female","tags":["acquaintance"],"rels":[("char-de-paul","acquaintance","آیریس و پاول در یک آشنایی مؤدبانه با هم صحبت می‌کنند و این آشنایی می‌تواند بعداً ادامه پیدا کند.")],"notes":"آیریس یک زن جوان است و در صحنه‌های آشنایی مؤدبانه حضور دارد. در محتوای فعلی می‌گوید اهل آلمان است.","voice":vp("female")},
"paul":{"id":"char-de-paul","name":"Paul Müller","gender":"male","tags":["acquaintance"],"rels":[("char-de-iris","acquaintance","پاول و آیریس در یک آشنایی مؤدبانه با هم آشنا شده‌اند.")],"notes":"پاول مولر ۲۰ ساله است و در محتوای فعلی در اتریش زندگی می‌کند. زبان‌آموز در مرور اطلاعات شخصی نقش پاول را بازی می‌کند.","voice":vp("male")}
}
for stem,c in chars.items():
    dump(f"content/de/characters/{stem}.json",{
      "schemaVersion":"1.0.0","id":c["id"],"languageId":"de","name":c["name"],"origin":"app_created",
      "gender":c["gender"],"ageBand":"young_adult","roles":c.get("roles",["conversation_partner"]),
      "relationshipTags":c["tags"],"relationships":[{"characterId":a,"type":b,"contextNotes":n} for a,b,n in c["rels"]],
      "contextNotes":c["notes"],"voiceProfile":c["voice"]})
p=ROOT/"content/de/characters/learner.json"
if p.exists(): p.unlink()

d=load("content/de/language.json")
d["characterRefs"]=[chars[x]["id"] for x in ("mia","max","lena","jonas","iris","paul")]
dump("content/de/language.json",d)

s=load("schemas/character.schema.json")
s["properties"]["relationships"]={"type":"array","items":{"type":"object","additionalProperties":False,"required":["characterId","type"],"properties":{"characterId":{"type":"string","minLength":1},"type":{"enum":["friend","classmate","neighbor","acquaintance","coworker","family","service_context"]},"contextNotes":{"type":"string"}}},"uniqueItems":True,"default":[]}
dump("schemas/character.schema.json",s)

s=load("schemas/dialogue.schema.json")
if "learnerCharacterId" not in s["required"]:
    s["required"].insert(s["required"].index("turns"),"learnerCharacterId")
s["properties"]["learnerCharacterId"]={"type":"string","minLength":1}
dump("schemas/dialogue.schema.json",s)

d=load("config/audio-pipeline.json")
d["voiceResolution"]["learnerUsesStandaloneVoice"]=False
dump("config/audio-pipeline.json",d)
s=load("schemas/audio-pipeline.schema.json")
s["properties"]["voiceResolution"]["properties"]["learnerUsesStandaloneVoice"]={"const":False}
dump("schemas/audio-pipeline.schema.json",s)

casts={
"hallo":("char-de-max","char-de-mia","میا و مکس با یک سلام ساده شروع می‌کنند و با یک خداحافظی کوتاه مکالمه را تمام می‌کنند."),
"guten-morgen":("char-de-lena","char-de-jonas","صبح است؛ لنا گفت‌وگو را با همسایه‌اش یوناس با یک سلام صبحگاهی شروع می‌کند و مکالمه با خداحافظی کوتاه تمام می‌شود."),
"pizza-like":("char-de-max","char-de-mia","میا و مکس سلام می‌کنند و بعد یک پرسش و پاسخ کوتاه دربارهٔ دوست‌داشتن پیتزا دارند."),
"ja":("char-de-max","char-de-mia","این بار مکس خودش سلام می‌کند و سؤال آشنای پیتزا را می‌پرسد؛ میا با یک پاسخ مثبت کوتاه جواب می‌دهد."),
"danke-bitte":("char-de-lena","char-de-jonas","یوناس و لنا سلام می‌کنند؛ بعد از یک کمک کوچک یوناس تشکر می‌کند و لنا پاسخ مؤدبانه می‌دهد."),
"entschuldigung":("char-de-max","char-de-mia","مکس برای یک اشتباه کوچک عذرخواهی می‌کند، میا پاسخ آرام می‌دهد و تعامل با تشکر و پاسخ مؤدبانه تمام می‌شود."),
"name-exchange":("char-de-jonas","char-de-iris","آیریس سلام می‌کند و یوناس پس از پاسخ، نام او را می‌پرسد و پاسخ سادهٔ «Ich heiße Iris.» را می‌شنود."),
"wellbeing":("char-de-lena","char-de-mia","میا و لنا سلام می‌کنند و میا یک احوال‌پرسی خیلی کوتاه می‌پرسد که لنا با یک پاسخ ساده جواب می‌دهد."),
"simple-choice":("char-de-max","char-de-jonas","مکس در یک کافه با یوناس سلام می‌کند؛ یوناس می‌پرسد چه می‌خواهد و مکس گزینهٔ آشنای «Pizza.» را انتخاب می‌کند."),
"residence-origin":("char-de-paul","char-de-iris","آیریس و پاول در یک آشنایی مؤدبانه دربارهٔ محل زندگی و مبدأ سؤال و جواب می‌کنند."),
"age-numbers":("char-de-max","char-de-mia","میا و مکس سن هم را می‌پرسند؛ مکس ۱۸ ساله و میا ۲۰ ساله است."),
"birthday-date":("char-de-max","char-de-mia","میا و مکس تاریخ تولد را از هم می‌پرسند؛ تاریخ‌های این صحنه به اطلاعات ثابت همین دو شخصیت تبدیل شده‌اند."),
"phone-number":("char-de-max","char-de-mia","میا و مکس شمارهٔ تلفن تمرینی را از هم می‌پرسند و دو شمارهٔ منبع‌دار می‌گویند."),
"day-time":("char-de-jonas","char-de-mia","یوناس دربارهٔ روز و ساعت فعلی سؤال می‌کند و میا با اطلاعات ساده پاسخ می‌دهد."),
"basic-object":("char-de-lena","char-de-mia","لنا و میا دربارهٔ دو شیء نام‌برده‌شده سؤال بسیار ساده می‌پرسند؛ حل فعالیت به تصویر وابسته نیست."),
"personal-review":("char-de-paul","char-de-iris","آیریس در یک آشنایی مؤدبانه با پاول مولر چند بخش اصلی اطلاعات شخصی او را در هشت نوبت مرور می‌کند.")
}
groups={}
for stem,(learner,app,scenario) in casts.items():
    rel=f"content/de/pre-a1/dialogues/{stem}.json"
    d=load(rel); d["scenario"]=scenario; d["learnerCharacterId"]=learner; d["characterRefs"]=[app,learner]
    for t in d["turns"]:
        sp=learner if t.get("learnerTurn") else app
        t["speakerCharacterId"]=sp
        groups.setdefault(sp,[]).append(t["id"])
    dump(rel,d)

pv=ROOT/"scripts/validate_project_contracts.py"
txt=pv.read_text(encoding="utf-8")
if "# Character identity / learner-role contract." not in txt:
    block='''# Character identity / learner-role contract.
for language_id, character_paths in characters_by_language.items():
    character_data={k:load(p) for k,p in character_paths.items()}
    for key,ch in character_data.items():
        if "learner" in set(ch.get("roles") or []): errors.append(f"{character_paths[key]}: durable characters must not use the learner role")
        for rel in ch.get("relationships") or []:
            target=rel.get("characterId"); typ=rel.get("type")
            if target==key: errors.append(f"{character_paths[key]}: relationship cannot point to itself")
            if target not in character_data: errors.append(f"{character_paths[key]}: relationship target {target!r} does not exist"); continue
            if not any(x.get("characterId")==key and x.get("type")==typ for x in (character_data[target].get("relationships") or [])):
                errors.append(f"{character_paths[key]}: relationship {typ!r} to {target!r} is not reciprocal")
for dialogue_id,(dialogue_path,dialogue) in dialogues.items():
    lang=dialogue.get("languageId"); paths=characters_by_language.get(lang,{}); refs=set(dialogue.get("characterRefs") or []); learner=dialogue.get("learnerCharacterId")
    if not learner: errors.append(f"{dialogue_path}: learnerCharacterId is required"); continue
    if learner not in refs: errors.append(f"{dialogue_path}: learnerCharacterId must be present in characterRefs")
    if learner not in paths: errors.append(f"{dialogue_path}: learnerCharacterId {learner!r} is not canonical")
    if str(learner).endswith("-learner"): errors.append(f"{dialogue_path}: generic learner persona is forbidden")
    for turn in dialogue.get("turns") or []:
        tid=turn.get("id","<turn>"); sp=turn.get("speakerCharacterId")
        if sp not in refs: errors.append(f"{dialogue_path}:{tid}: speakerCharacterId must be present in characterRefs")
        if sp not in paths: errors.append(f"{dialogue_path}:{tid}: unknown speaker {sp!r}"); continue
        if str(sp).endswith("-learner"): errors.append(f"{dialogue_path}:{tid}: generic learner persona is forbidden")
        if bool(turn.get("learnerTurn")) and sp!=learner: errors.append(f"{dialogue_path}:{tid}: learner turn must use learnerCharacterId")
        if not bool(turn.get("learnerTurn")) and sp==learner: errors.append(f"{dialogue_path}:{tid}: app turn cannot use learner-controlled character")
        ev=turn.get("speakerGenderEvidence")
        if ev in {"female","male"} and load(paths[sp]).get("gender")!=ev: errors.append(f"{dialogue_path}:{tid}: speaker gender evidence conflicts with character gender")
'''
    txt=txt.replace("\nif errors:\n","\n"+block+"\nif errors:\n")
pv.write_text(txt,encoding="utf-8")

av=ROOT/"scripts/validate_audio_contracts.py"
txt=av.read_text(encoding="utf-8")
needle="if config.get('mappingRoot')!='database/audio': errors.append('audio mappingRoot must be database/audio')"
if "learner dialogue turns must never inherit" not in txt:
    txt=txt.replace(needle,needle+"\nif config.get('voiceResolution',{}).get('learnerUsesStandaloneVoice') is not False: errors.append('learner dialogue turns must never inherit the standalone voice')\nfor pth in Path('content').glob('*/characters/*.json'):\n    d=json.loads(pth.read_text(encoding='utf-8'))\n    if 'learner' in set(d.get('roles') or []): errors.append(f'{pth}: durable learner persona is forbidden')")
av.write_text(txt,encoding="utf-8")

def q(x): return "'"+x.replace("'","''")+"'"
rows=[]
for stem in ("mia","max","lena","jonas","iris","paul"):
    c=chars[stem]; roles=",".join(q(x) for x in c.get("roles",["conversation_partner"])); tags=",".join(q(x) for x in c["tags"])
    v="JSON_OBJECT('clarity','high','stressLevel','very_low','aggressiveness','none','toneConsistency','high','ageImpression','young_adult','genderImpression',"+q(c["gender"])+")"
    rows.append("("+",".join([q(c["id"]),"@de",q(c["name"]),"'app_created'",q(c["gender"]),"'young_adult'","JSON_ARRAY("+roles+")","JSON_ARRAY("+tags+")",q(c["notes"]),v,"NULL","NULL"])+")")
sql=["-- German Pre-A1 canonical character cast overlay.","SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;","START TRANSACTION;","SET @de := (SELECT id FROM languages WHERE code='de' LIMIT 1);","INSERT INTO characters","(character_key,language_id,name,origin,gender,age_band,roles,relationship_tags,context_notes,voice_profile,elevenlabs_voice_id,voice_name) VALUES",",\n".join(rows),"ON DUPLICATE KEY UPDATE language_id=VALUES(language_id),name=VALUES(name),origin=VALUES(origin),gender=VALUES(gender),age_band=VALUES(age_band),roles=VALUES(roles),relationship_tags=VALUES(relationship_tags),context_notes=VALUES(context_notes),voice_profile=VALUES(voice_profile);"]
for stem in ("mia","max","lena","jonas","iris","paul"): sql.append(f"SET @{stem}:=(SELECT id FROM characters WHERE character_key='char-de-{stem}' LIMIT 1);")
for sp,ids in sorted(groups.items()): sql.append("UPDATE dialogue_turns SET speaker_character_id=@"+sp.removeprefix("char-de-")+" WHERE turn_key IN ("+",".join(q(x) for x in sorted(ids))+");")
for stem,(_,_,scenario) in casts.items():
    did=load(f"content/de/pre-a1/dialogues/{stem}.json")["id"]
    sql.append("UPDATE dialogues SET scenario="+q(scenario)+" WHERE dialogue_key="+q(did)+";")
sql += ["DELETE FROM characters WHERE language_id=@de AND character_key='char-de-learner';","COMMIT;"]
(ROOT/"database/content/de/zz-pre-a1-character-cast.sql").write_text("\n".join(sql)+"\n",encoding="utf-8")

voices=ROOT/"database/audio/de/voices.sql"
if voices.exists():
    lines=[x for x in voices.read_text(encoding="utf-8").splitlines() if "char-de-learner" not in x and "char-de-iris" not in x]
    voices.write_text("\n".join(lines)+"\n",encoding="utf-8")
print("content cast migration complete")
