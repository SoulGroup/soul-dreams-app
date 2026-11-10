// No test runs the entry points, so this one reads them (D27, Task 7a).
// Each must call requireFlavour with its own flavour, once, before runApp.
// It reads source text with comments removed; `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const entryPoints = {
    'lib/main.dart': 'tester',
    'lib/main_founder.dart': 'founder',
    'lib/main_dev.dart': 'dev',
  };

  entryPoints.forEach((path, flavour) {
    test('$path checks the $flavour flavour before runApp', () {
      final code = File(path)
          .readAsLinesSync()
          .map((line) => line.split('//').first)
          .join('\n');
      final checks = RegExp(r'requireFlavour\(').allMatches(code).toList();
      final runs = RegExp(r'runApp\(').allMatches(code).toList();
      expect(checks, hasLength(1));
      expect(runs, hasLength(1));
      expect(code, contains('requireFlavour(Flavour.$flavour);'));
      expect(checks.single.start, lessThan(runs.single.start));
      // The check is the first statement of main (D27a): not in a helper,
      // not under a condition, not after other work.
      final first = RegExp(
          r'main\(\)\s*(async\s*)?\{\s*requireFlavour\(Flavour\.' + flavour + r'\);');
      expect(first.hasMatch(code), isTrue, reason: 'first statement of main');
    });
  });
}
