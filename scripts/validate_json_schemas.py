#!/usr/bin/env python3
import json
from pathlib import Path
import sys
from jsonschema import Draft202012Validator, RefResolver

ROOT=Path(__file__).resolve().parents[1]
S=ROOT/'schemas'
schemas={}
for p in S.glob('*.schema.json'):
    data=json.loads(p.read_text(encoding='utf-8'))
    schemas[p.name]=data
    schemas[p.resolve().as_uri()]=data
    if data.get('$id'):
        schemas[data['$id']]=data


def schema_for(path):
    parts=path.parts
    if path.name=='language.json': return 'language.schema.json'
    if path.name=='level.json': return 'level.schema.json'
    if 'sources' in parts: return 'source.schema.json'
    if 'characters' in parts: return 'character.schema.json'
    if 'lexeme_forms' in parts: return 'lexeme_form.schema.json'
    if 'lexemes' in parts: return 'lexeme.schema.json'
    if 'units' in parts: return 'unit.schema.json'
    if 'dialogues' in parts: return 'dialogue.schema.json'
    if 'lessons' in parts: return 'lesson.schema.json'
    return None


def validate_instance(path, schema_name, errors):
    schema=schemas[schema_name]
    resolver=RefResolver(base_uri=(S/schema_name).resolve().as_uri(), referrer=schema, store=schemas)
    data=json.loads(path.read_text(encoding='utf-8'))
    for e in sorted(Draft202012Validator(schema,resolver=resolver).iter_errors(data), key=lambda x:list(x.absolute_path)):
        loc='.'.join(map(str,e.absolute_path)) or '$'
        errors.append(f'{path.relative_to(ROOT)}:{loc}: {e.message}')

errors=[]
files=0
for p in (ROOT/'content').rglob('*.json'):
    name=schema_for(p)
    if not name: continue
    files+=1
    validate_instance(p,name,errors)

# taxonomy is also an authored instance
p=ROOT/'config/fa-taxonomy.json'
validate_instance(p,'fa-taxonomy.schema.json',errors)

# Audio pipeline configuration is a canonical authored contract.
p=ROOT/'config/audio-pipeline.json'
validate_instance(p,'audio-pipeline.schema.json',errors)

# Provider voice locks become authored instances after the first voice resolution.
voice_locks=0
for p in sorted((ROOT/'config/audio-voice-locks').glob('*.json')):
    voice_locks+=1
    validate_instance(p,'audio-voice-lock.schema.json',errors)

if errors:
    print('JSON schema instance validation failed:')
    print('\n'.join(errors))
    sys.exit(1)
print(f'JSON schema instance validation passed for {files} content files, taxonomy, audio config and {voice_locks} voice lock(s).')
