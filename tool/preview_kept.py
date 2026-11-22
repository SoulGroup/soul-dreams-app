# SoulDreams Dev's invented kept sentences (D131 item 1), for the owner's
# by-eye review of Life Context's page. Writes the file a Dev build reads
# through --dart-define-from-file: the invented nights that have waking
# passages, read from fixtures/invented-nights.json (R2), the one place they
# live, so nothing invented is copied into the repository. Run from the
# repository root, then build SoulDreams Dev as usual adding
# --dart-define-from-file="$TMPDIR/preview-kept.json":
#   python3 -I -B tool/preview_kept.py "$TMPDIR/preview-kept.json"
# It writes only that file, prints nothing, and exits 0; 2 without a path.
import json
import os
import sys

TOP = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FIXTURES = os.path.join(TOP, 'fixtures', 'invented-nights.json')


def preview(fixtures=FIXTURES):
    with open(fixtures, encoding='utf-8') as f:
        nights = json.load(f)['nights']
    chosen = [
        {'lang': n['lang'], 'dreams': n['dreams'], 'waking': [w['text'] for w in n['waking']]}
        for n in nights if n.get('waking')
    ]
    return {'PREVIEW_KEPT': json.dumps(chosen, ensure_ascii=False, separators=(',', ':'))}


def main(argv):
    if len(argv) != 1:
        return 2
    with open(argv[0], 'w', encoding='utf-8') as f:
        json.dump(preview(), f, ensure_ascii=False)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
