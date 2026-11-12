// The journal and the pending lines reach SoulDreams Dev only (D49 O1;
// D57 Q11). G8 reads direct imports only (banked item 25), so this test
// follows every import, from each entry point, through every file it
// reaches in lib/. `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _blockComment = RegExp(r'/\*.*?\*/', dotAll: true);
// A directive's start: import, export, part or part of, then an address.
final _directive = RegExp(r"""^(?:import|export|part)\s+(?:of\s+)?['"]""");
// A conditional import's test, which may hold a quoted word of its own.
final _condition = RegExp(r'\bif\s*\([^)]*\)');
final _address = RegExp(r"""(['"])(.+?)\1""");

String _readFile(String path) => File(path).readAsStringSync();

/// Every address a directive in [text] names: any quote, every alternative
/// of a conditional import, whatever stands between the words and the
/// address, over any number of lines. Comments are not read.
Iterable<String> addressesIn(String text) sync* {
  final bare = text.replaceAll(_blockComment, ' ').split('\n').map((l) => l.split('//').first).join('\n');
  for (final statement in bare.split(';')) {
    final directive = statement.trim();
    if (!_directive.hasMatch(directive)) continue;
    for (final m in _address.allMatches(directive.replaceAll(_condition, ' '))) {
      yield m[2]!;
    }
  }
}

/// Every file in lib/ that [entry] reaches through its directives. [read]
/// gives a file's text (a synthetic tree in the tests of the walk itself).
Set<String> reached(String entry, {String Function(String path) read = _readFile}) {
  final seen = <String>{};
  final todo = [entry];
  while (todo.isNotEmpty) {
    final path = todo.removeLast();
    if (!seen.add(path)) continue;
    for (final uri in addressesIn(read(path))) {
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

  // D65 (the review of Task 12): the walk is proved on synthetic trees, so
  // no form of a directive can carry code past it.
  Set<String> walk(Map<String, String> tree) => reached('lib/main.dart', read: (p) => tree[p] ?? (throw StateError(p)));

  const j = 'lib/journal/j.dart';

  test('the walk follows double-quoted directives', () {
    expect(walk({'lib/main.dart': 'import "journal/j.dart";', j: ''}), contains(j));
    expect(walk({'lib/main.dart': 'export "journal/j.dart";', j: ''}), contains(j));
  });

  test('the walk follows every alternative of a conditional import', () {
    final files = walk({
      'lib/main.dart': "import 'stub.dart'\n    if (dart.library.io) 'journal/j.dart'\n    if (dart.library.html == \"true\") 'journal/h.dart';",
      'lib/stub.dart': '',
      j: '',
      'lib/journal/h.dart': '',
    });
    expect(files, containsAll([j, 'lib/journal/h.dart', 'lib/stub.dart']));
  });

  test('the walk follows part directives, both ways', () {
    expect(walk({'lib/main.dart': "part 'journal/j.dart';", j: ''}), contains(j));
    expect(walk({'lib/main.dart': "part of 'journal/j.dart';", j: ''}), contains(j));
  });

  test('the walk follows a directive with a comment before its address', () {
    expect(walk({'lib/main.dart': "import /* x */ 'journal/j.dart';", j: ''}), contains(j));
    expect(walk({'lib/main.dart': "import // x\n    'journal/j.dart';", j: ''}), contains(j));
  });

  test('the walk follows multi-line directives, and two on a line', () {
    expect(walk({'lib/main.dart': "import\n  'journal/j.dart'\n  show X,\n  hide Y;", j: ''}), contains(j));
    final files = walk({'lib/main.dart': "import 'a.dart'; import 'journal/j.dart' as j;", 'lib/a.dart': '', j: ''});
    expect(files, containsAll(['lib/a.dart', j]));
  });

  test('the walk skips comments and other packages', () {
    final files = walk({
      'lib/main.dart': [
        "/* x; import 'journal/j.dart'; */",
        "// import 'journal/j.dart';",
        "import 'dart:io';",
        "import 'package:flutter/material.dart';",
      ].join('\n'),
    });
    expect(files, {'lib/main.dart'});
  });

  test('the walk fails on an address that is not a file', () {
    expect(() => walk({'lib/main.dart': "import 'nowhere.dart';"}), throwsStateError);
  });

  test('the walk reaches lib/founder/ through a chain', () {
    final files = walk({
      'lib/main.dart': "import 'core/a.dart';",
      'lib/core/a.dart': "import '../founder/x.dart';",
      'lib/founder/x.dart': '',
    });
    expect(files.where((f) => f.startsWith('lib/founder/')), ['lib/founder/x.dart']);
  });

  test('the testers app reaches nothing of the founder (R8)', () {
    expect(reached('lib/main.dart').where((f) => f.startsWith('lib/founder/')), isEmpty);
  });
}
