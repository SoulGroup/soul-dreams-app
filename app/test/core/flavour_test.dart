import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/flavour.dart';
import 'package:souldreams/core/safe_log.dart';

void main() {
  final lines = <String>[];
  final original = SafeLog.sink;
  setUp(() {
    lines.clear();
    SafeLog.sink = lines.add;
  });
  tearDown(() => SafeLog.sink = original);

  test('each flavour starts under its own name', () {
    for (final f in Flavour.values) {
      requireFlavour(f, flavor: f.name);
    }
    expect(lines, isEmpty);
  });

  test('another flavour, or none, is refused with a code', () {
    expect(() => requireFlavour(Flavour.founder, flavor: 'dev'), throwsStateError);
    expect(() => requireFlavour(Flavour.tester, flavor: null), throwsStateError);
    expect(lines, ['wrongFlavour', 'wrongFlavour']);
  });

  test('the names are the Xcode schemes', () {
    expect([for (final f in Flavour.values) f.name], ['dev', 'founder', 'tester']);
  });
}
