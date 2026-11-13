# The app's mutation checks (D49 c), run by hand from the repository
# root: python3 -I -B tool/app_mutations.py
# Expected: every row "caught" (A1 to A39, with the rows A24a to A24as of
# the later rulings among them), then "app mutations: 84 run, 84
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
    # Task 9b (D63): no automatic focus, a page that scrolls, MP·62, and a
    # save when the app is left
    ('A24p', 'lib/journal/pages/typing_page.dart',
     'expands: true,',
     'expands: true, autofocus: true,',
     'test/journal/pages/typing_page_test.dart', 'the field takes no focus; a tap brings the keyboard'),
    ('A24q', 'lib/journal/pages/typing_page.dart',
     'constraints: BoxConstraints(minHeight: minField),',
     'constraints: const BoxConstraints(),',
     'test/journal/pages/typing_page_test.dart', 'an iPhone SE, keyboard up at 1.0x: no overflow, Save reachable'),
    ('A24r', 'lib/journal/pages/typing_page.dart',
     'builder: (context, box) => SingleChildScrollView(',
     'builder: (context, box) => SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),',
     'test/journal/pages/typing_page_test.dart', 'with the keyboard up, MP·10 scrolls away and the field stays'),
    ('A24s', 'lib/journal/pages/typing_page.dart',
     'PendingLines.MP_62.text(appLanguage)',
     "''",
     'test/journal/pages/typing_page_test.dart', 'a failed Save stays on the screen; Save again keeps it'),
    ('A24t', 'lib/journal/pages/typing_page.dart',
     'WidgetsBinding.instance.addObserver(this);',
     '',
     'test/journal/pages/typing_page_test.dart', 'paused saves'),
    ('A24u', 'lib/journal/pages/typing_page.dart',
     '|| state == AppLifecycleState.paused;',
     '|| state == AppLifecycleState.paused || state == AppLifecycleState.inactive;',
     'test/journal/pages/typing_page_test.dart', 'going inactive saves nothing'),
    ('A24v', 'lib/journal/pages/typing_page.dart',
     'if (_away && !wasAway)',
     'if (_away)',
     'test/journal/pages/typing_page_test.dart', 'a failed save on leaving is not retried on return'),
    ('A24w', 'lib/journal/pages/typing_page.dart',
     'if (leaving && isEmptyText(_text.text)) return;\n',
     '',
     'test/journal/pages/typing_page_test.dart', 'leaving the app with nothing typed keeps nothing and stays'),
    # Task 9c (the review of 9b): MP·62 in the scroll area, cleared on a retry
    ('A24x', 'lib/journal/pages/typing_page.dart',
     'if (_failed) setState(() => _failed = false);',
     '',
     'test/journal/pages/typing_page_test.dart', 'MP·62 goes during a retry and stays if it fails'),
    ('A24y', 'lib/journal/pages/typing_page.dart',
     'constraints: BoxConstraints(minHeight: box.maxHeight),',
     'constraints: const BoxConstraints(),',
     'test/journal/pages/typing_page_test.dart', 'the field fills the page when there is room'),
    ('A24z', 'lib/journal/pages/typing_page.dart',
     'if (mounted && line != null) Scrollable.ensureVisible(line);',
     '',
     'test/journal/pages/typing_page_test.dart', 'a failure at largest text keeps a window, shows MP·62'),
    # Task 10a (D64): a failed delete or read, a delete in flight, semantics
    ('A24aa', 'lib/journal/pages/night_page.dart',
     '    } on Object {\n      SafeLog.event(LogEvent.journalDeleteFailed);',
     '    } on StateError {\n      SafeLog.event(LogEvent.journalDeleteFailed);',
     'test/journal/pages/night_page_test.dart', 'a failed delete keeps the page and night, logs a code'),
    ('A24ab', 'lib/journal/pages/night_page.dart',
     '    } on Object {\n      SafeLog.event(LogEvent.journalReadFailed);',
     '    } on StateError {\n      SafeLog.event(LogEvent.journalReadFailed);',
     'test/journal/pages/night_page_test.dart', 'a failed read after typing keeps the page, logs a code'),
    ('A24ac', 'lib/journal/pages/night_page.dart',
     '      if (mounted) setState(() => _busy = false);\n',
     '',
     'test/journal/pages/night_page_test.dart', 'a failed delete keeps the page and night, logs a code'),
    ('A24ad', 'lib/journal/pages/night_page.dart',
     '    if (_busy) return;\n    final page',
     '    final page',
     'test/journal/pages/night_page_test.dart', 'the menu, Add and a dream wait while a delete runs'),
    ('A24ae', 'lib/journal/pages/night_page.dart',
     'enabled: !_busy,',
     'enabled: true,',
     'test/journal/pages/night_page_test.dart', 'the menu, Add and a dream wait while a delete runs'),
    ('A24af', 'lib/journal/pages/parts.dart',
     '          button: true,\n          child: GestureDetector(',
     '          button: false,\n          child: GestureDetector(',
     'test/journal/pages/night_page_test.dart', 'a dream is heard as a button'),
    ('A24ag', 'lib/journal/pages/night_page.dart',
     'header: true,',
     'header: false,',
     'test/journal/pages/night_page_test.dart', 'the date is heard as a heading'),
    ('A24ah', 'lib/journal/pages/night_page.dart',
     'Text(n.name!, style: TypeRoles.h2.style(p.text)),',
     'const SizedBox.shrink(),',
     'test/journal/pages/night_page_test.dart', 'a named night shows name over date, as a heading'),
    # Task 12a (D65): the import walk, and the journal list after the phone check
    ('A24ai', 'test/dev_only_test.dart',
     '''(['"])(.+?)''',
     '''(')(.+?)''',
     'test/dev_only_test.dart', 'the walk follows double-quoted directives'),
    ('A24aj', 'test/dev_only_test.dart',
     "directive.replaceAll(_condition, ' ')",
     'directive',
     'test/dev_only_test.dart', 'the walk follows every alternative of a conditional import'),
    ('A24ak', 'test/dev_only_test.dart',
     '(?:import|export|part)',
     '(?:import|export)',
     'test/dev_only_test.dart', 'the walk follows part directives, both ways'),
    ('A24al', 'test/dev_only_test.dart',
     "text.replaceAll(_blockComment, ' ')",
     'text',
     'test/dev_only_test.dart', 'the walk skips comments and other packages'),
    ('A24am', 'test/dev_only_test.dart',
     "bare.split(';')",
     "bare.split('\\n')",
     'test/dev_only_test.dart', 'the walk follows multi-line directives, and two on a line'),
    ('A24an', 'lib/core/night_day.dart',
     "import 'package:flutter/material.dart';",
     "import 'package:flutter/material.dart';\nimport \"../journal/journal.dart\";",
     'test/dev_only_test.dart', 'lib/main.dart reaches no journal code and no pending line'),
    ('A24ao', 'lib/journal/pages/journal_home.dart',
     '      await widget.after;\n',
     '',
     'test/journal/pages/journal_home_test.dart', 'the list waits for the phone check, then shows'),
    ('A24ap', 'lib/main_dev.dart',
     'JournalHome(files: files, after: check)',
     'JournalHome(files: files)',
     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check to the list'),
    ('A24aq', 'lib/journal/pages/journal_home.dart',
     '      await widget.after;\n    } on Object {',
     '      await widget.after;\n    } on ArgumentError {',
     'test/journal/pages/journal_home_test.dart', 'a phone check that throws does not keep the list away'),
    # Task 15a (P13, the owner's correction): the record button is a circle
    ('A24ar', 'lib/journal/pages/parts.dart',
     'borderRadius: BorderRadius.circular(StandIns.recordHeight / 2),',
     'borderRadius: BorderRadius.circular(Spacing.radius),',
     'test/journal/pages/journal_page_test.dart', 'the record button is a circle, radius half its height'),
    ('A24as', 'lib/journal/pages/parts.dart',
     '          width: StandIns.recordWidth,\n',
     '',
     'test/journal/pages/journal_page_test.dart', 'large text cannot stretch the record button'),
    # The final review: a night that is made always reads back
    ('A24', 'lib/journal/night.dart',
     "    if (!_isDay(date.year, date.month, date.day)) throw ArgumentError('date');\n",
     '',
     'test/journal/night_test.dart', 'a date its file could not hold is refused'),
    # journal-screens: the night rules and the journal's operations
    ('A25', 'lib/journal/night_rules.dart',
     'return same.isAfter(first) ? same',
     'return !same.isBefore(first) ? same',
     'test/journal/night_rules_test.dart', '20:59 closes a minute later; 21:00 itself starts a new night'),
    ('A26', 'lib/journal/night_rules.dart',
     'if (c > 0 || (c == 0',
     'if (c < 0 || (c == 0',
     'test/journal/night_rules_test.dart', "tonight's night is the latest one not yet closed"),
    ('A27', 'lib/journal/journal.dart',
     '    if (isEmptyText(text)) return false;\n',
     '',
     'test/journal/journal_test.dart', 'an empty Save keeps nothing'),
    ('A28', 'lib/journal/journal.dart',
     '      dreams.removeAt(index);',
     '      dreams[index] = text;',
     'test/journal/journal_test.dart', 'an edit replaces the dream; an emptied dream disappears'),
    ('A29', 'lib/journal/journal.dart',
     'return dreams.isEmpty ? null : n.withDreams(dreams);',
     'return n.withDreams(dreams);',
     'test/journal/journal_test.dart', 'a night whose every dream is emptied is deleted, nothing left'),
    ('A30', 'lib/journal/pages/typing_page.dart',
     'await widget.journal.addDream(widget.target, ',
     'await widget.journal.addDream(await widget.journal.targetNow(), ',
     'test/journal/pages/typing_page_test.dart', 'a screen open across 21:00 saves into its own night'),
    # the rows
    ('A31', 'lib/journal/row_text.dart',
     '    if (dream.length > f.length && _wordChar.hasMatch(dream[f.length])) continue;\n',
     '',
     'test/journal/row_text_test.dart', 'a framing is trimmed only whole, at the start'),
    ('A32', 'lib/journal/row_text.dart',
     '.toLowerCase() != f.toLowerCase()',
     ' != f',
     'test/journal/row_text_test.dart', 'each framing is trimmed from the very start, ignoring case'),
    ('A33', 'lib/journal/row_text.dart',
     'final words = year == currentYear',
     'final words = false',
     'test/journal/row_text_test.dart', 'a divider: the month alone this year, month and year before'),
    # motion
    ('A34', 'lib/core/night_day.dart',
     'return f.reduceMotion || f.disableAnimations;',
     'return f.disableAnimations;',
     'test/core/night_day_test.dart', 'with Reduce Motion the change is instant'),
    ('A35', 'lib/core/night_day.dart',
     '? NightDay.fade : Duration.zero',
     '? Duration.zero : Duration.zero',
     'test/core/night_day_test.dart', 'at 21:00 the open app fades to dark over five seconds'),
    ('A36', 'lib/core/app_line.dart',
     'if (f.reduceMotion || f.disableAnimations) {',
     'if (f.disableAnimations) {',
     'test/core/app_line_test.dart', 'with Reduce Motion the line stands whole'),
    ('A37', 'lib/core/app_line.dart',
     '    _shown = 1;\n',
     '    _shown = _words.length;\n',
     'test/core/app_line_test.dart', 'one word, then one more every 60 ms'),
    # deleting, and Dev only
    ('A38', 'lib/journal/pages/night_page.dart',
     '    if (yes != true || !mounted) return;\n',
     '    if (!mounted) return;\n',
     'test/journal/pages/night_page_test.dart', 'one confirmation: Cancel first keeps the night'),
    ('A39', 'lib/main.dart',
     "import 'core/safe_log.dart';\n",
     "import 'core/safe_log.dart';\nimport 'journal/journal.dart';\n",
     'test/dev_only_test.dart', 'lib/main.dart reaches no journal code and no pending line'),
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
