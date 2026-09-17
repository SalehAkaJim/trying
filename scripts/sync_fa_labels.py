#!/usr/bin/env python3
import argparse
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]
TAXONOMY = json.loads((ROOT / 'config' / 'fa-taxonomy.json').read_text(encoding='utf-8'))['domains']

FEATURE_DOMAINS = {
    'tense': 'grammar_feature_tense',
    'mood': 'grammar_feature_mood',
    'number': 'grammar_feature_number',
    'person': 'grammar_feature_person',
}


def dump_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def canonical(domain, code, path, field):
    if code is None:
        return None
    label = (TAXONOMY.get(domain) or {}).get(str(code))
    if not isinstance(label, str) or not label.strip():
        raise SystemExit(f'{path}: no canonical Persian label for {field}={code!r} in {domain}')
    return label


def localize_feature(path, key, value):
    domain = FEATURE_DOMAINS.get(key)
    if domain is None:
        raise SystemExit(f'{path}: grammatical feature {key!r} has no Persian localization contract')
    if isinstance(value, list):
        return [canonical(domain, item, path, f'features.{key}') for item in value]
    return canonical(domain, value, path, f'features.{key}')


def sync(write=False):
    changed = []

    for path in sorted((ROOT / 'content').glob('*/lexemes/*.json')):
        data = json.loads(path.read_text(encoding='utf-8'))
        pos = data.get('partOfSpeech')
        expected = canonical('part_of_speech', pos, path, 'partOfSpeech') if pos is not None else None
        if data.get('partOfSpeechFa') != expected:
            data['partOfSpeechFa'] = expected
            changed.append(path)
            if write:
                dump_json(path, data)

    for path in sorted((ROOT / 'content').glob('*/lexeme_forms/*.json')):
        data = json.loads(path.read_text(encoding='utf-8'))
        expected = {
            'formTypeFa': canonical('lexeme_form_type', data.get('formType'), path, 'formType'),
            'originFa': canonical('lexeme_form_origin', data.get('origin'), path, 'origin'),
            'reviewStatusFa': canonical('review_status', data.get('reviewStatus'), path, 'reviewStatus'),
            'featuresFa': {
                key: localize_feature(path, key, value)
                for key, value in (data.get('features') or {}).items()
            },
        }
        dirty = False
        for field, value in expected.items():
            if data.get(field) != value:
                data[field] = value
                dirty = True
        if dirty:
            changed.append(path)
            if write:
                dump_json(path, data)

    return changed


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--write', action='store_true', help='Write canonical Persian labels into authoring files.')
    args = parser.parse_args()
    changed = sync(write=args.write)
    if changed and not args.write:
        print('Files needing sync:')
        for path in changed:
            print(path.relative_to(ROOT))
        raise SystemExit(1)
    if changed:
        print(f'Synced {len(changed)} learner-facing localization file(s).')
    else:
        print('Persian companion labels are already synchronized.')
