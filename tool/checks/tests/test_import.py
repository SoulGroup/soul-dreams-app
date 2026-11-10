# The import, end to end, in throwaway repositories in $TMPDIR: a
# documents repository with a bare remote, and an app repository
# holding a copy of tool/checks with test rows. Nothing real is read.
import hashlib
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

from helpers import CHECKS
import test_wordsgen as invented

ENV = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1',
           GIT_AUTHOR_NAME='t', GIT_AUTHOR_EMAIL='t@x.example',
           GIT_COMMITTER_NAME='t', GIT_COMMITTER_EMAIL='t@x.example')
ROWS = ("ROWS = (\n"
        "    ('product/handover.md', 'docs/source/handover.md', 'copy'),\n"
        "    ('product/register.csv', 'app/assets/words/places-register.csv', 'words'),\n"
        "    ('product/lists.md', 'app/assets/words/founder-lists-for-technology.md', 'lists'),\n"
        "    ('product/odd.md', 'docs/elsewhere.md', 'copy'),\n"
        "    ('restricted/a.md', 'docs/source/a.md', 'copy'),\n"
        ")\n")
BODY = b'# Handover\n\nword word\n'
WRAPPER = os.path.join(os.path.dirname(CHECKS), 'import.sh')
ORDINAL = 'C1-T item 2'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def git(where, *args):
    r = subprocess.run(('git', '-C', where) + args, capture_output=True, env=ENV)
    if r.returncode != 0:
        raise RuntimeError('git')
    return r.stdout


class Import(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix='import-')
        self.docs = os.path.join(self.tmp, 'docs')
        remote = os.path.join(self.tmp, 'remote.git')
        git(self.tmp, 'init', '-q', '--bare', '-b', 'main', remote)
        git(self.tmp, 'init', '-q', '-b', 'main', self.docs)
        self.put('product/handover.md', BODY)
        self.put('product/register.csv', b'a,b\n')
        self.put('product/odd.md', BODY)
        self.put('product/lists.md', invented.lists())
        self.put('restricted/a.md', BODY)
        git(self.docs, 'add', '-A')
        git(self.docs, 'commit', '-q', '-m', 'docs')
        git(self.docs, 'remote', 'add', 'origin', remote)
        git(self.docs, 'push', '-q', '-u', 'origin', 'main')
        self.app = os.path.join(self.tmp, 'app')
        git(self.tmp, 'init', '-q', '-b', 'work', self.app)
        checks = os.path.join(self.app, 'tool', 'checks')
        shutil.copytree(CHECKS, checks, ignore=shutil.ignore_patterns('__pycache__', 'tests'))
        if os.path.exists(WRAPPER):  # not in the mutation checks' copy
            shutil.copy2(WRAPPER, os.path.join(self.app, 'tool', 'import.sh'))
        with open(os.path.join(checks, 'import_rows.py'), 'w', encoding='utf-8') as f:
            f.write(ROWS)

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def put(self, path, data):
        full = os.path.join(self.docs, path)
        os.makedirs(os.path.dirname(full), exist_ok=True)
        with open(full, 'wb') as f:
            f.write(data)

    def run_import(self, *args, env=None):
        script = os.path.join(self.app, 'tool', 'checks', 'importer.py')
        r = subprocess.run([sys.executable, '-I', '-B', script, '--docs', self.docs] + list(args),
                           capture_output=True, env=env or ENV)
        return r.returncode, r.stdout.decode()

    def app_files(self):
        out = []
        for d, dirs, files in os.walk(self.app):
            dirs[:] = [x for x in dirs if x not in ('.git', 'tool')]
            out += [os.path.relpath(os.path.join(d, f), self.app) for f in files]
        return sorted(out)

    def refused(self, code, *args):
        args = args or ('product/handover.md', digest(BODY), ORDINAL)
        rc, out = self.run_import(*args)
        self.assertEqual(rc, 1)
        self.assertIn('import: refused ' + code, out)
        self.assertEqual(self.app_files(), [])

    def sources(self):
        with open(os.path.join(self.app, 'docs', 'source', 'SOURCES'), encoding='utf-8') as f:
            return f.read()

    def test_clean_import_copies_and_records(self):
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 0, out)
        with open(os.path.join(self.app, 'docs', 'source', 'handover.md'), 'rb') as f:
            self.assertEqual(f.read(), BODY)
        line = '%s  docs/source/handover.md  %s\n' % (digest(BODY), ORDINAL)
        self.assertTrue(self.sources().endswith(line))
        self.assertEqual(self.app_files(), ['docs/source/SOURCES', 'docs/source/handover.md'])

    def test_sources_reads_back_through_guardlib(self):
        self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.run_import('product/register.csv', digest(b'a,b\n'), 'C2-P item 1')
        sys.path.insert(0, CHECKS)
        import guardlib
        src = guardlib.Source(self.app, 'walk')
        entries, findings = guardlib.parse_sources(src)
        self.assertEqual(findings, [])
        self.assertEqual(sorted(entries), ['app/assets/words/places-register.csv',
                                           'docs/source/handover.md'])

    def test_reimport_replaces_the_line(self):
        self.run_import('product/handover.md', digest(BODY), ORDINAL)
        new = BODY + b'more\n'
        self.put('product/handover.md', new)
        git(self.docs, 'commit', '-q', '-am', 'change')
        git(self.docs, 'push', '-q')
        rc, out = self.run_import('product/handover.md', digest(new), 'C3-T item 1')
        self.assertEqual(rc, 0, out)
        self.assertNotIn(digest(BODY), self.sources())
        self.assertEqual(self.sources().count('docs/source/handover.md'), 1)

    def test_same_import_twice_is_unchanged(self):
        self.run_import('product/handover.md', digest(BODY), ORDINAL)
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 0)
        self.assertIn('import: unchanged docs/source/handover.md', out)

    def test_words_run_the_generator(self):
        register = invented.register()
        self.put('product/register.csv', register)
        git(self.docs, 'commit', '-q', '-am', 'register')
        git(self.docs, 'push', '-q')
        rc, out = self.run_import('product/register.csv', digest(register), ORDINAL)
        self.assertEqual(rc, 0, out)
        self.assertIn('import: the generator waits for the register and the lists', out)
        rc, out = self.run_import('product/lists.md', digest(invented.lists()), ORDINAL)
        self.assertEqual(rc, 0, out)
        self.assertIn('wordsgen: wrote app/lib/words/lines.g.dart', out)
        self.assertIn('app/ios/Runner/sv.lproj/InfoPlist.strings', self.app_files())

    def test_generator_refusal_is_reported(self):
        register = invented.register(invented.row('A' + invented.DOT + '1', 'unheard of'))
        self.put('product/register.csv', register)
        git(self.docs, 'commit', '-q', '-am', 'register')
        git(self.docs, 'push', '-q')
        self.run_import('product/lists.md', digest(invented.lists()), ORDINAL)
        rc, out = self.run_import('product/register.csv', digest(register), ORDINAL)
        self.assertEqual(rc, 1)
        self.assertIn('import: generator refused register unknown-status row 4', out)
        self.assertNotIn('app/lib/words/lines.g.dart', self.app_files())

    def test_wrapper_needs_the_documents_location(self):
        self.assertTrue(os.path.exists(WRAPPER))
        script = os.path.join(self.app, 'tool', 'import.sh')
        env = {k: v for k, v in ENV.items() if k != 'SOUL_DREAMS_DOCS'}
        r = subprocess.run(['sh', script, 'product/handover.md', digest(BODY), ORDINAL],
                           capture_output=True, env=env)
        self.assertNotEqual(r.returncode, 0)
        self.assertNotIn(b'import:', r.stdout)  # the importer never ran
        self.assertEqual(self.app_files(), [])
        r = subprocess.run(['sh', script, 'product/handover.md', digest(BODY), ORDINAL],
                           capture_output=True, env=dict(ENV, SOUL_DREAMS_DOCS=self.docs))
        self.assertEqual(r.returncode, 0, r.stdout)
        self.assertIn(b'import: hash ok, copied docs/source/handover.md', r.stdout)

    def test_hash_mismatch_refused(self):
        self.refused('hash-mismatch', 'product/handover.md', digest(b'other'), ORDINAL)

    def test_bad_arguments_refused(self):
        self.refused('bad-hash', 'product/handover.md', 'abc', ORDINAL)
        self.refused('bad-hash', 'product/handover.md', digest(BODY).upper(), ORDINAL)
        self.refused('bad-ordinal', 'product/handover.md', digest(BODY), '')
        self.refused('bad-ordinal', 'product/handover.md', digest(BODY), 'C1\tx')
        self.refused('bad-ordinal', 'product/handover.md', digest(BODY), ' C1')
        rc, out = self.run_import('product/handover.md', digest(BODY))
        self.assertEqual(rc, 1)
        self.assertIn('import: refused usage', out)

    def test_paths_refused(self):
        for path in ('/product/handover.md', 'product/../product/handover.md',
                     'product//handover.md', './product/handover.md'):
            self.refused('bad-path', path, digest(BODY), ORDINAL)
        self.refused('refused-document', 'restricted/a.md', digest(BODY), ORDINAL)
        self.refused('refused-document', 'product/privacy-ethics-safety.md', digest(BODY), ORDINAL)
        self.refused('not-allowed', 'product/other.md', digest(BODY), ORDINAL)
        self.refused('bad-row', 'product/odd.md', digest(BODY), ORDINAL)

    def test_dirty_docs_refused(self):
        self.put('product/new.md', b'x\n')
        self.refused('docs-dirty')

    def test_changed_working_file_refused(self):
        self.put('product/handover.md', b'changed\n')
        self.refused('docs-dirty', 'product/handover.md', digest(b'changed\n'), ORDINAL)

    def test_reads_the_committed_bytes(self):
        # A working file git is told to ignore: status is clean, but the
        # import must still copy the bytes committed at HEAD.
        self.put('product/handover.md', b'changed\n')
        git(self.docs, 'update-index', '--skip-worktree', 'product/handover.md')
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 0, out)
        with open(os.path.join(self.app, 'docs', 'source', 'handover.md'), 'rb') as f:
            self.assertEqual(f.read(), BODY)

    def test_unsynced_docs_refused(self):
        self.put('product/new.md', b'x\n')
        git(self.docs, 'add', '-A')
        git(self.docs, 'commit', '-q', '-m', 'local only')
        self.refused('docs-unsynced')

    def test_no_upstream_refused(self):
        git(self.docs, 'branch', '-q', '--unset-upstream')
        self.refused('docs-no-upstream')

    def test_not_a_repository_refused(self):
        shutil.rmtree(os.path.join(self.docs, '.git'))
        self.refused('docs-not-a-repository')

    def test_untracked_symlink_and_missing_refused(self):
        os.symlink('handover.md', os.path.join(self.docs, 'product', 'link.md'))
        git(self.docs, 'add', '-A')
        git(self.docs, 'commit', '-q', '-m', 'link')
        git(self.docs, 'push', '-q')
        with open(os.path.join(self.app, 'tool', 'checks', 'import_rows.py'), 'a',
                  encoding='utf-8') as f:
            f.write("ROWS += (('product/link.md', 'docs/source/link.md', 'copy'),\n"
                    "         ('product/gone.md', 'docs/source/gone.md', 'copy'))\n")
        self.refused('not-a-file', 'product/link.md', digest(b'handover.md'), ORDINAL)
        self.refused('not-tracked', 'product/gone.md', digest(BODY), ORDINAL)

    def test_on_main_refused(self):
        git(self.app, 'checkout', '-q', '-b', 'main')
        self.refused('on-main')

    def commit_empty(self, where):
        git(where, 'commit', '-q', '--allow-empty', '-m', 'x')

    def test_on_main_refused_though_a_tag_is_named_main(self):
        # With a tag of the same name, `symbolic-ref --short` prints heads/main.
        git(self.app, 'checkout', '-q', '-b', 'main')
        self.commit_empty(self.app)
        git(self.app, 'tag', 'main')
        self.refused('on-main')

    def test_detached_head_at_main_refused_elsewhere_allowed(self):
        git(self.app, 'checkout', '-q', '-b', 'main')
        self.commit_empty(self.app)
        git(self.app, 'checkout', '-q', '--detach')
        self.refused('on-main')
        self.commit_empty(self.app)  # detached, and no longer main's commit
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 0, out)

    def test_git_environment_does_not_steer_the_checks(self):
        gitdir = os.path.join(self.docs, '.git')
        env = dict(ENV, GIT_DIR=gitdir, GIT_WORK_TREE=self.docs,
                   GIT_INDEX_FILE=os.path.join(gitdir, 'index'))
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL, env=env)
        self.assertEqual(rc, 0, out)
        with open(os.path.join(self.app, 'docs', 'source', 'handover.md'), 'rb') as f:
            self.assertEqual(f.read(), BODY)

    def test_control_characters_in_the_ordinal_refused(self):
        for bad in ('C1\x85x', 'C1 x', 'C1 x', 'C1\x7fx', 'C1\nx'):
            self.refused('bad-ordinal', 'product/handover.md', digest(BODY), bad)
        rc, out = self.run_import('product/handover.md', digest(BODY), 'C1–T item 2')
        self.assertEqual(rc, 0, out)

    def test_app_not_a_repository_refused(self):
        shutil.rmtree(os.path.join(self.app, '.git'))
        self.refused('app-not-a-repository')

    def test_fetch_failure_refused(self):
        git(self.docs, 'remote', 'set-url', 'origin', os.path.join(self.tmp, 'gone.git'))
        self.refused('docs-fetch-failed')

    def test_not_text_refused(self):
        nul, latin = b'a\0b\n', b'\xff\xfe\n'
        self.put('product/nul.md', nul)
        self.put('product/latin.md', latin)
        git(self.docs, 'add', '-A')
        git(self.docs, 'commit', '-q', '-m', 'binary')
        git(self.docs, 'push', '-q')
        with open(os.path.join(self.app, 'tool', 'checks', 'import_rows.py'), 'a',
                  encoding='utf-8') as f:
            f.write("ROWS += (('product/nul.md', 'docs/source/nul.md', 'copy'),\n"
                    "         ('product/latin.md', 'docs/source/latin.md', 'copy'))\n")
        self.refused('not-text', 'product/nul.md', digest(nul), ORDINAL)
        self.refused('not-text', 'product/latin.md', digest(latin), ORDINAL)

    def test_malformed_sources_refused(self):
        os.makedirs(os.path.join(self.app, 'docs', 'source'))
        with open(os.path.join(self.app, 'docs', 'source', 'SOURCES'), 'w') as f:
            f.write('not a line\n')
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 1)
        self.assertIn('import: refused sources-malformed', out)
        self.assertFalse(os.path.exists(os.path.join(self.app, 'docs', 'source', 'handover.md')))


if __name__ == '__main__':
    unittest.main()
