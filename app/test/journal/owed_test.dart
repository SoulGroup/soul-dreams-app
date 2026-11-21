// The places Product still owes (D110): each shows its provisional handle in
// square brackets (R1), no two alike, none a register handle.
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/owed.dart';
import 'package:souldreams/words/lines.g.dart';

void main() {
  test('an owed place shows its handle in square brackets', () {
    for (final o in OwedLines.all) {
      expect(o.text, '[${o.handle}]');
    }
  });

  test('nine owed places, each handle once, none in the register', () {
    final handles = [for (final o in OwedLines.all) o.handle];
    expect(handles, hasLength(9));
    expect(handles.toSet(), hasLength(9));
    final filed = {for (final l in Lines.all) l.handle};
    expect(handles.where(filed.contains), isEmpty);
  });
}
