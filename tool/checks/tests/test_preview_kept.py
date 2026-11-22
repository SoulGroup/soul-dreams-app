# tool/preview_kept.py: the Dev build's invented kept sentences (D131 item
# 1) come whole from fixtures/invented-nights.json, and nothing else.
import json
import os
import sys
import tempfile
import unittest

from helpers import CHECKS

sys.path.insert(0, os.path.dirname(CHECKS))

import preview_kept  # noqa: E402


class PreviewKept(unittest.TestCase):
    def test_every_night_with_waking_passages_whole(self):
        with open(preview_kept.FIXTURES, encoding='utf-8') as f:
            nights = json.load(f)['nights']
        out = preview_kept.preview()
        self.assertEqual(list(out), ['PREVIEW_KEPT'])
        chosen = json.loads(out['PREVIEW_KEPT'])
        want = [n for n in nights if n.get('waking')]
        self.assertTrue(want)
        self.assertEqual(len(chosen), len(want))
        for c, n in zip(chosen, want):
            self.assertEqual(c, {'lang': n['lang'], 'dreams': n['dreams'],
                                 'waking': [w['text'] for w in n['waking']]})

    def test_writes_the_define_file_only_with_one_path(self):
        d = tempfile.mkdtemp(prefix='preview-')
        path = os.path.join(d, 'preview-kept.json')
        self.assertEqual(preview_kept.main([]), 2)
        self.assertEqual(preview_kept.main([path]), 0)
        with open(path, encoding='utf-8') as f:
            self.assertEqual(json.load(f), preview_kept.preview())
        os.remove(path)
        os.rmdir(d)


if __name__ == '__main__':
    unittest.main()
