// The founder's export (C142-I item 3; D107; D108): what the file holds.
// No document rules a format, so D107 item 2's: plain text, UTF-8, with
// the night's date as its page shows it (its name above, if it has one),
// then each dream told in words, in order, a blank line between. No label
// or number is added (R1). A recording still waiting has no words and is
// left out (D108). The file's name is the night's date in digits only.
import 'dart:convert';
import 'dart:typed_data';

import '../journal/night.dart';
import '../journal/row_text.dart';

const _line = '\n';

/// The file's text.
String exportText(Night night) {
  final head = [?night.name, dayDigits(night.date)].join(_line);
  return [head, ...night.dreams].join(_line + _line) + _line;
}

/// The file's bytes: the text in UTF-8.
Uint8List exportBytes(Night night) => utf8.encode(exportText(night));

/// The file's name: the night's date, `YYYY-MM-DD.txt`.
String exportFileName(Night night) {
  final d = night.date;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${d.year.toString().padLeft(4, '0')}-${two(d.month)}-${two(d.day)}.txt';
}
