// The journal and the pending lines reach SoulDreams Dev only (D49 O1;
// D57 Q11). G8 reads direct imports only (banked item 25), so this test
// follows every import, from each entry point, through every file it
// reaches in lib/. `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _import = RegExp(r"^\s*(?:import|export)\s+'([^']+)'", multiLine: true);

/// Every file in lib/ that [entry] reaches through its imports.
Set<String> reached(String entry) {
  final seen = <String>{};
  final todo = [entry];
  while (todo.isNotEmpty) {
    final path = todo.removeLast();
    if (!seen.add(path)) continue;
    final text = File(path).readAsStringSync().split('\n').map((l) => l.split('//').first).join('\n');
    for (final m in _import.allMatches(text)) {
      final uri = m[1]!;
      if (uri.startsWith('dart:')) continue;
      if (uri.startsWith('package:')) {
        if (uri.startsWith('package:souldreams/')) todo.add('lib/${uri.substring(19)}');
        continue;
      }
      todo.add(Uri.parse(path).resolve(uri).path);
    }
  }
  return seen;
}

void main() {
  const pending = 'lib/words/pending.g.dart';

  for (final entry in ['lib/main.dart', 'lib/main_founder.dart']) {
    test('$entry reaches no journal code and no pending line', () {
      final files = reached(entry);
      expect(files, contains('lib/app.dart'));
      expect(files.where((f) => f.startsWith('lib/journal/')), isEmpty);
      expect(files, isNot(contains(pending)));
    });
  }

  test('SoulDreams Dev reaches the journal pages and the pending lines', () {
    final files = reached('lib/main_dev.dart');
    expect(files, contains('lib/journal/pages/journal_page.dart'));
    expect(files, contains('lib/journal/pages/night_page.dart'));
    expect(files, contains(pending));
  });

  test('the walk follows relative and package imports', () {
    final files = reached('lib/journal/pages/night_page.dart');
    expect(files, containsAll(['lib/words/pending.g.dart', 'lib/journal/night.dart', 'lib/design/tokens.g.dart']));
  });
}
