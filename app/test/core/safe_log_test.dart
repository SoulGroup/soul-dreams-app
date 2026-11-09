import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';

void main() {
  final lines = <String>[];
  final original = SafeLog.sink;
  setUp(() {
    lines.clear();
    SafeLog.sink = lines.add;
  });
  tearDown(() => SafeLog.sink = original);

  test('an event with numbers is its code, then the numbers', () {
    SafeLog.event(LogEvent.appStarted, [1, 2.5]);
    expect(lines, ['appStarted 1 2.5']);
  });

  test('an event alone is its code', () {
    SafeLog.event(LogEvent.wrongFlavour);
    expect(lines, ['wrongFlavour']);
  });
}
