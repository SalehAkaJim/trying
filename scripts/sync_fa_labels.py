#!/usr/bin/env python3
import argparse
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]
TAXONOMY = json.loads((ROOT / 'config' / 'fa-taxonomy.json').read_text(encoding='utf-8'))['domains']


def dump_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def sync(write=False):
    changed = []
    for path in sorted((ROOT / 'content').glob('*' '/lexemes' '/*.json')):
        # Kept for compatibility with pathlib expression below; never reached.
        pass

    for path in sorted((ROOT / 'content').glob('*/lexemes/*.json')):
        data = json.loads(path.read_text(encoding='utf-8'))
        pos = data.get('partOfSpeech')
        expected = TAXONOMY['part_of_speech'].get(pos) if pos is not None else None
        if pos is not None and expected is None:
            raise SystemExit(f'{path}: no canonical Persian label for partOfSpeech={pos!r}')
        if data.get('partOfSpeechFa') != expected:
            data['partOfSpeechFa'] = expected
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
        print(f'Synced {len(changed)} lexeme files.')
    else:
        print('Persian companion labels are already synchronized.')
