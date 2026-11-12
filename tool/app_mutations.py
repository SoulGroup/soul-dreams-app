# The app's mutation checks (D49 c), run by hand from the repository
# root: python3 -I -B tool/app_mutations.py
# Expected: A1 to A24 each "caught", then "app mutations: 24 run, 24
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
    # Task 5a (D61): a read and its write are one turn; invisible text is empty;
    # a night open too long is damaged
    ('A24a', 'lib/journal/journal.dart',
     '        return _store.update(id, (n) => n.withDreams([...n.dreams, text]));\n',
     '        final n = await night(id);\n'
     '        if (n == null) return false;\n'
     '        await _store.save(n.withDreams([...n.dreams, text]));\n'
     '        return true;\n',
     'test/journal/journal_test.dart', 'a delete queued behind a Save keeps the night deleted'),
    ('A24b', 'lib/journal/journal.dart',
     '    await _store.update(id, (n) {\n'
     '      if (index < 0 || index >= n.dreams.length) return n;\n'
     '      final dreams = [...n.dreams];\n'
     '      if (isEmptyText(text)) {\n'
     '        dreams.removeAt(index);\n'
     '      } else {\n'
     '        dreams[index] = text;\n'
     '      }\n'
     '      return dreams.isEmpty ? null : n.withDreams(dreams);\n'
     '    });\n',
     ''.join(line + '\n' for line in [
         '    final n = await night(id);',
         '    if (n == null) return;',
         '    if (index < 0 || index >= n.dreams.length) return;',
         '    final dreams = [...n.dreams];',
         '    if (isEmptyText(text)) {',
         '      dreams.removeAt(index);',
         '    } else {',
         '      dreams[index] = text;',
         '    }',
         '    if (dreams.isEmpty) {',
         '      await _store.delete(id);',
         '    } else {',
         '      await _store.save(n.withDreams(dreams));',
         '    }',
     ]),
     'test/journal/journal_test.dart', 'a delete queued right behind an edit keeps the night deleted'),
    ('A24c', 'lib/journal/night_rules.dart',
     "text.replaceAll(_invisible, '').trim().isEmpty",
     'text.trim().isEmpty',
     'test/journal/night_rules_test.dart', 'invisible characters alone are empty too'),
    ('A24d', 'lib/journal/night.dart',
     ' || shut.difference(at) > maxOpen) return null;',
     ') return null;',
     'test/journal/night_test.dart', 'a closing instant over 26 hours on is refused as damaged'),
    ('A24e', 'lib/journal/night.dart',
     ' || shut.difference(at) > maxOpen) return null;',
     ' || shut.isAfter(at.add(maxOpen))) return null;',
     'test/journal/night_test.dart', 'a night at the far end of time reads without throwing'),
    ('A24f', 'lib/journal/journal_store.dart',
     'if (night == null || night.id != id) return false;',
     'if (night == null) return false;',
     'test/journal/journal_store_test.dart', 'an update leaves a file that holds another id alone'),
    # Task 9a (D62): a failed save, the edge swipe, the double tap, the
    # keyboard, the edit's place
    ('A24g', 'lib/journal/pages/typing_page.dart',
     '      _saving = false;\n',
     '',
     'test/journal/pages/typing_page_test.dart', 'a failed Save stays on the screen; Save again keeps it'),
    ('A24h', 'lib/journal/pages/typing_page.dart',
     '} on Object {',
     '} on StateError {',
     'test/journal/pages/typing_page_test.dart', 'a failed Save stays on the screen; Save again keeps it'),
    ('A24i', 'lib/journal/pages/typing_page.dart',
     '      SafeLog.event(LogEvent.journalSaveFailed);\n',
     '',
     'test/journal/pages/typing_page_test.dart', 'a failed Save stays on the screen; Save again keeps it'),
    ('A24j', 'lib/journal/pages/typing_page.dart',
     'onHorizontalDragEnd: (d) {',
     'onHorizontalDragEnd: (d) {\n                return;',
     'test/journal/pages/typing_page_test.dart', 'the iPhone edge swipe saves, then leaves, like Back'),
    ('A24k', 'lib/journal/pages/typing_page.dart',
     '_swiped >= _swipeFar ||',
     'true ||',
     'test/journal/pages/typing_page_test.dart', 'a short edge drag or a middle swipe saves nothing'),
    ('A24l', 'lib/journal/pages/typing_page.dart',
     '    if (_saving) return;\n',
     '',
     'test/journal/pages/typing_page_test.dart', 'two quick taps on Save keep the dream once'),
    ('A24m', 'lib/journal/pages/typing_page.dart',
     'textCapitalization: TextCapitalization.sentences,',
     'textCapitalization: TextCapitalization.sentences, smartQuotesType: SmartQuotesType.disabled,',
     'test/journal/pages/typing_page_test.dart', 'nothing else about the keyboard is overridden (P12)'),
    ('A24n', 'lib/journal/pages/typing_page.dart',
     'editDream(e.id, e.index, _text.text)',
     'editDream(e.id, 0, _text.text)',
     'test/journal/pages/typing_page_test.dart', 'an edit replaces the dream at its own place'),
    ('A24o', 'lib/journal/pages/typing_page.dart',
     'editDream(e.id, e.index, _text.text)',
     'editDream(e.id, e.index, _text.text.trim().isEmpty ? e.text : _text.text)',
     'test/journal/pages/typing_page_test.dart', 'an edit emptied to nothing removes that dream only'),
    # The final review: a night that is made always reads back
    ('A24', 'lib/journal/night.dart',
     "    if (!_isDay(date.year, date.month, date.day)) throw ArgumentError('date');\n",
     '',
     'test/journal/night_test.dart', 'a date its file could not hold is refused'),
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
