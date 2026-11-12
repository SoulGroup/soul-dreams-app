// The fonts (D49 a): every face and weight the design values use is
// declared in pubspec.yaml, every declared file is there, and every font
// file is declared. G2 proves each file's fingerprint. `flutter test`
// runs in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// (family, weight, italic) for each asset pubspec.yaml declares, read
/// from its fonts block.
Map<String, (String, int, bool)> declared() {
  final out = <String, (String, int, bool)>{};
  var family = '';
  var asset = '';
  for (final line in File('pubspec.yaml').readAsLinesSync()) {
    final f = RegExp(r'^    - family: (\w+)$').firstMatch(line);
    final a = RegExp(r'^        - asset: (\S+)$').firstMatch(line);
    final w = RegExp(r'^          weight: (\d+)$').firstMatch(line);
    if (f != null) family = f[1]!;
    if (a != null) {
      asset = a[1]!;
      out[asset] = (family, 400, false);
    }
    final (name, weight, italic) = out[asset] ?? ('', 400, false);
    if (w != null) out[asset] = (name, int.parse(w[1]!), italic);
    if (line == '          style: italic') out[asset] = (name, weight, true);
  }
  return out;
}

void main() {
  test('every family and weight in the design values is declared', () {
    final tokens = File('lib/design/tokens.g.dart').readAsStringSync();
    final used = {
      for (final m in RegExp(r"TypeRole\('(\w+)', FontWeight\.w(\d+),").allMatches(tokens))
        (m[1]!, int.parse(m[2]!)),
    };
    final have = {for (final d in declared().values) if (!d.$3) (d.$1, d.$2)};
    expect(used, isNotEmpty);
    expect(have.containsAll(used), isTrue, reason: '$used against $have');
  });

  test("the dreamer voice's italic is declared (Design System §1)", () {
    expect(declared().values, contains(('Nunito', 400, true)));
  });

  test('every declared font is there, and every font file is declared', () {
    final files = Directory('assets/fonts')
        .listSync()
        .map((e) => e.path.replaceAll(r'\', '/'))
        .where((p) => p.endsWith('.ttf'))
        .toSet();
    expect(declared().keys.toSet(), files);
  });
}
