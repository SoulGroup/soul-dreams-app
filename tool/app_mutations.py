# The app's mutation checks (D49 c), run by hand from the repository
# root: python3 -I -B tool/app_mutations.py
# Expected: A1 to A23 each "caught", then "app mutations: 23 run, 23
# caught", exit 0. Each row breaks one thing in app/, in place, runs the
# named test with the pinned Flutter (fvm), which must pass unbroken
# and fail broken, and puts the file back byte for byte, whatever
# happens. check_all.sh does not call it. It reports row codes only,
# through the checks' own writer. Exit 0 when every row is caught, 1
# otherwise.
import os
import subprocess
import sys

TOOL = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(TOOL, 'checks'))

from guardlib import report  # noqa: E402

APP = os.path.join(os.path.dirname(TOOL), 'app')

# (code, file in app/, old, new, test file, the test that must fail)
ROWS = [
    ('A1', 'lib/journal/journal_store.dart',
     '    final name = fileOf(id);\n    await _files.delete(name);\n',
     '    final name = fileOf(id);\n',
     'test/journal/journal_store_test.dart', 'deleting a night leaves nothing of it anywhere'),
    ('A2', 'lib/journal/journal_store.dart',
     '      await _files.write(tempPrefix + name, encodeNight(night));\n'
     '      await _files.rename(tempPrefix + name, name);',
     '      await _files.write(name, encodeNight(night));',
     'test/journal/journal_store_test.dart', 'a save cut short leaves the last whole version'),
    ('A3', 'lib/journal/journal_store.dart',
     '      if (name.startsWith(tempPrefix)) {',
     '      if (name.startsWith(tempPrefix) && false) {',
     'test/journal/journal_store_test.dart', 'a save cut short leaves the last whole version'),
    ('A4', 'lib/journal/journal_store.dart',
     '  Future<void> deleteAll() => _run(() => _files.deleteAll());',
     '  Future<void> deleteAll() => _run(() async {\n'
     '    for (final name in await _files.list()) {\n'
     "      if (name.startsWith('night-')) await _files.delete(name);\n"
     '    }\n'
     '  });',
     'test/journal/journal_store_test.dart', 'deleting the journal empties the folder'),
    ('A5', 'lib/journal/journal_store.dart',
     '        SafeLog.event(LogEvent.journalFileSkipped);\n',
     '',
     'test/journal/journal_store_test.dart', 'an unreadable file is skipped with a code, never touched'),
    ('A6', 'lib/journal/journal_store.dart',
     'if (night == null || night.id != match[1]) {',
     'if (night == null) {',
     'test/journal/journal_store_test.dart', 'an unreadable file is skipped with a code, never touched'),
    ('A7', 'lib/journal/night.dart',
     ' || !setEquals(json.keys.toSet(), _keys)',
     '',
     'test/journal/night_test.dart', 'anything not a version-1 night decodes to null'),
    ('A8', 'lib/journal/self_check.dart',
     '    if (!p.excluded || !p.folderComplete || !p.fileComplete) return _failed(step);\n',
     '',
     'test/journal/self_check_test.dart', 'each missing protection fails at step 3, probe removed'),
    ('A9', 'lib/core/privacy_cover.dart',
     'final covered = state != AppLifecycleState.resumed;',
     'final covered = state == AppLifecycleState.paused;',
     'test/core/privacy_cover_test.dart', 'inactive covers the screen with the page colour, no text'),
    ('A10', 'lib/core/privacy_cover.dart',
     'ExcludeSemantics(excluding: _covered, ',
     'ExcludeSemantics(excluding: false, ',
     'test/core/privacy_cover_test.dart', 'the cover is on top and hides what is under it'),
    ('A11', 'lib/core/privacy_cover.dart',
     '(dark ? DarkColours.page : LightColours.page)',
     'LightColours.page',
     'test/core/privacy_cover_test.dart', 'the dark theme gets the dark page colour'),
    ('A12', 'lib/app.dart',
     'builder: (context, child) => PrivacyCover(child: child!),',
     'builder: (context, child) => child!,',
     'test/app_test.dart', 'every page of the app is under the cover'),
    ('A13', 'ios/Runner/AppDelegate.swift',
     'return extensionPointIdentifier != .keyboard',
     'return true',
     'test/core/keyboards_test.dart', 'AppDelegate refuses the keyboard extension point, and only it'),
    # Task 9a (D54)
    ('A14', 'lib/journal/journal_store.dart',
     '    await _files.delete(name);\n    await _files.delete(tempPrefix + name);\n',
     '    await _files.delete(name);\n',
     'test/journal/journal_store_test.dart', 'deleting a night takes a cut save temp file'),
    ('A15', 'lib/journal/journal_store.dart',
     '        await _files.delete(tempPrefix + name);\n      } on Object {',
     '        await Future<void>.value();\n      } on Object {',
     'test/journal/journal_store_test.dart', 'a save cut short leaves the last whole version'),
    ('A16', 'lib/journal/journal_store.dart',
     '    final result = _tail.then((_) => operation());',
     '    final result = operation();',
     'test/journal/journal_store_test.dart', 'deleting the journal waits for a save in flight'),
    ('A17', 'lib/journal/journal_store.dart',
     '    final result = _tail.then((_) => operation());',
     '    final result = operation();',
     'test/journal/journal_store_test.dart', 'a delete between a save write'),
    # Task 10a (D54)
    ('A18', 'lib/journal/journal_store.dart',
     '  Future<void> deleteAll() => _run(() => _files.deleteAll());',
     '  Future<void> deleteAll() => _run(() async {\n'
     '    for (final name in await _files.list()) {\n'
     '      await _files.delete(name);\n'
     '    }\n'
     '  });',
     'test/journal/journal_store_test.dart', 'deleting the journal does not depend on file names'),
    ('A19', 'ios/Runner/AppDelegate.swift',
     '      try flush(url)\n',
     '',
     'test/journal/channel_journal_files_test.dart', 'the Swift side answers every method this side calls'),
    ('A20', 'ios/Runner/AppDelegate.swift',
     '    case "deleteAll":',
     '    case "deleteEverything":',
     'test/journal/channel_journal_files_test.dart', 'the Swift side answers every method this side calls'),
    # Task 11a (D54)
    ('A21', 'lib/core/privacy_cover.dart',
     'ColoredBox(key: PrivacyCover.coverKey, color: page)',
     'ColoredBox(key: PrivacyCover.coverKey, color: page, child: const SizedBox())',
     'test/core/privacy_cover_test.dart', 'inactive covers the screen with the page colour, no text'),
    ('A22', 'lib/core/privacy_cover.dart',
     'Positioned.fill(child: ColoredBox(key: PrivacyCover.coverKey, color: page))',
     'Positioned.fill(child: Transform.translate(offset: const Offset(10, 10), child: ColoredBox(key: PrivacyCover.coverKey, color: page)))',
     'test/core/privacy_cover_test.dart', 'inactive covers the screen with the page colour, no text'),
    ('A23', 'lib/core/privacy_cover.dart',
     '_covered = state != null && state != AppLifecycleState.resumed;',
     '_covered = false;',
     'test/core/privacy_cover_test.dart', 'a cold start while not resumed starts covered'),
]


def run(test, name):
    r = subprocess.run(['fvm', 'flutter', 'test', '--no-pub', test, '--plain-name', name],
                       cwd=APP, capture_output=True)
    return r.returncode


def run_row(code, path, old, new, test, name):
    full = os.path.join(APP, path)
    with open(full, 'rb') as f:
        original = f.read()
    text = original.decode('utf-8')
    if text.count(old) != 1:
        return 'SETUP FAILED (pattern not found once)'
    if run(test, name) != 0:
        return 'SETUP FAILED (the test fails unbroken)'
    try:
        with open(full, 'wb') as f:
            f.write(text.replace(old, new).encode('utf-8'))
        caught = run(test, name) != 0
    finally:
        with open(full, 'wb') as f:
            f.write(original)
    return 'caught' if caught else 'SURVIVED'


def main():
    caught = 0
    for row in ROWS:
        result = run_row(*row)
        caught += result == 'caught'
        report('%s: %s' % (row[0], result))
    report('app mutations: %d run, %d caught' % (len(ROWS), caught))
    return 0 if caught == len(ROWS) else 1


if __name__ == '__main__':
    sys.exit(main())
