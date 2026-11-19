// The founder's export, its text and name (D107 item 2; D108), from the
// invented nights only (R2).
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/founder/export_text.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/row_text.dart';

import '../fixtures.dart';

Night _night(String key) => nightsFromFixtures().singleWhere((n) => n.dreams.first == invented(key).dreams.first);

void main() {
  test('the date, then each dream in order, a blank line between', () {
    final n = _night('two-dreams-en');
    expect(exportText(n), '${dayDigits(n.date)}\n\n${n.dreams[0]}\n\n${n.dreams[1]}\n');
  });

  test('a named night: the name above the date', () {
    final n = _night('named-three-dreams-sv');
    expect(n.name, isNotNull);
    expect(
      exportText(n),
      '${n.name}\n${dayDigits(n.date)}\n\n${n.dreams[0]}\n\n${n.dreams[1]}\n\n${n.dreams[2]}\n',
    );
  });

  test('a waiting recording is left out; the others keep their order', () {
    final n = _night('named-three-dreams-sv');
    final mixed = n.withEntries([Told(n.dreams[0]), Waiting('0' * 32), Told(n.dreams[2])]);
    expect(exportText(mixed), '${n.name}\n${dayDigits(n.date)}\n\n${n.dreams[0]}\n\n${n.dreams[2]}\n');
  });

  test('the bytes are the text in UTF-8, Swedish letters whole', () {
    final n = _night('one-dream-sv');
    expect(utf8.decode(exportBytes(n)), exportText(n));
    // Å, ä and ö take two bytes each: the text has some.
    expect(exportBytes(n).length, greaterThan(exportText(n).length));
  });

  test("the file's name: the night's date in digits, padded", () {
    final n = _night('two-dreams-en');
    final march = Night(
      id: n.id,
      firstRecorded: n.firstRecorded,
      date: (year: 2026, month: 3, day: 7),
      closes: n.closes,
      lang: n.lang,
      dreams: n.dreams,
    );
    expect(exportFileName(march), '2026-03-07.txt');
    expect(exportFileName(n), matches(RegExp(r'^\d{4}-\d{2}-\d{2}\.txt$')));
  });
}
