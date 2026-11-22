// What Life Context keeps (C159-I item 1; D110; D131), in plain Dart, and
// its file format: each kept sentence word for word, with the day it was
// said (the phone's date then) and the night it was said in, under an id of
// its own that names it on the phone only and is never sent (R4). The app
// writes nothing else into it: no summary, theme, label or flag. Kept on the
// phone only, in the journal's folder (R11; docs/workflow.md (c)), as one
// file, version 1 (`JournalStore.keptFile`).
//
// The Recent window (MP·84, 2 weeks by default): a sentence is in it while
// its day is later than the cutoff, today less the length (a week, two
// weeks, or one or three months by the calendar, the day held to the
// month's end). Older ones go at launch and once a day while the app is
// open (D131 item 4). The Kept longer list has no rule yet and stays empty
// (D131 item 5), so nothing here marks a sentence for it.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import '../journal/night.dart';
import '../journal/night_rules.dart' show isEmptyText;
import '../settings/settings.dart';

final _id = RegExp(r'^[0-9a-f]{32}$');
final _day = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

/// The file format's version.
const keptVersion = 1;

bool _isDay(NightDate d) {
  if (d.year < 0 || d.year > 9999) return false;
  final c = DateTime.utc(d.year, d.month, d.day);
  return c.year == d.year && c.month == d.month && c.day == d.day;
}

/// One kept sentence.
final class Kept {
  Kept({required this.id, required this.night, required this.day, required this.text}) {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    if (!_id.hasMatch(night)) throw ArgumentError('night');
    if (!_isDay(day)) throw ArgumentError('day');
    if (isEmptyText(text)) throw ArgumentError('text');
  }

  final String id;

  /// The id of the night it was said in.
  final String night;

  /// The phone's date when it was said.
  final NightDate day;

  /// The dreamer's own words.
  final String text;

  /// The same sentence with the dreamer's edit: only this copy changes,
  /// never the night's text (D131 item 2).
  Kept withText(String text) => Kept(id: id, night: night, day: day, text: text);

  @override
  bool operator ==(Object other) =>
      other is Kept && other.id == id && other.night == night && other.day == day && other.text == text;

  @override
  int get hashCode => Object.hash(id, night, day, text);
}

/// A new kept sentence's id: 128 bits from the system's secure source.
String newKeptId([Random? random]) => newNightId(random);

String _two(int n) => n.toString().padLeft(2, '0');

String _dayText(NightDate d) => '${d.year.toString().padLeft(4, '0')}-${_two(d.month)}-${_two(d.day)}';

/// The file's bytes: version 1, the sentences in the order they were kept.
Uint8List encodeKept(List<Kept> kept) => utf8.encode(
  jsonEncode({
    'version': keptVersion,
    'sentences': [
      for (final k in kept) {'id': k.id, 'night': k.night, 'day': _dayText(k.day), 'text': k.text},
    ],
  }),
);

/// The sentences [bytes] hold, or null when they do not read as version 1
/// exactly.
List<Kept>? decodeKept(Uint8List bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return null;
  }
  if (json is! Map<String, dynamic> || json.length != 2 || json['version'] != keptVersion) return null;
  final list = json['sentences'];
  if (list is! List) return null;
  final out = <Kept>[];
  final ids = <String>{};
  for (final s in list) {
    if (s is! Map<String, dynamic> || s.length != 4) return null;
    final id = s['id'];
    final night = s['night'];
    final day = s['day'];
    final text = s['text'];
    if (id is! String || night is! String || day is! String || text is! String) return null;
    final m = _day.firstMatch(day);
    if (m == null) return null;
    try {
      out.add(
        Kept(
          id: id,
          night: night,
          day: (year: int.parse(m[1]!), month: int.parse(m[2]!), day: int.parse(m[3]!)),
          text: text,
        ),
      );
    } on ArgumentError {
      return null;
    }
    if (!ids.add(id)) return null;
  }
  return out;
}

/// The last day outside the Recent window of [length] on [today].
NightDate cutoffOf(NightDate today, LifeContextLength length) {
  NightDate days(int n) {
    final d = DateTime.utc(today.year, today.month, today.day - n);
    return (year: d.year, month: d.month, day: d.day);
  }

  NightDate months(int n) {
    var y = today.year;
    var m = today.month - n;
    while (m < 1) {
      m += 12;
      y--;
    }
    final last = DateTime.utc(y, m + 1, 0).day;
    return (year: y, month: m, day: min(today.day, last));
  }

  return switch (length) {
    LifeContextLength.oneWeek => days(7),
    LifeContextLength.twoWeeks => days(14),
    LifeContextLength.oneMonth => months(1),
    LifeContextLength.threeMonths => months(3),
  };
}

int _compare(NightDate a, NightDate b) =>
    a.year != b.year ? a.year - b.year : (a.month != b.month ? a.month - b.month : a.day - b.day);

/// Whether [kept] is inside the Recent window of [length] on [today].
bool inWindow(Kept kept, NightDate today, LifeContextLength length) => _compare(kept.day, cutoffOf(today, length)) > 0;

/// Newest day first; within a day, in the order kept.
List<Kept> newestFirst(List<Kept> kept) {
  final indexed = [for (final (i, k) in kept.indexed) (i, k)];
  indexed.sort((a, b) {
    final c = _compare(b.$2.day, a.$2.day);
    return c != 0 ? c : a.$1 - b.$1;
  });
  return [for (final (_, k) in indexed) k];
}
