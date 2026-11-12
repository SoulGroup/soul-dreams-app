// A night as the journal keeps it on the phone (D49 b; R11), and its
// file format. Which fields a night holds is settled with Product's
// answers; until the format first reaches the founder app it may change
// freely (D49, O5). After that, any change is a storage change
// (docs/workflow.md, "On-phone storage changes").
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../words/lines.g.dart' show Lang;

/// The file format's version, written in every night's file.
const formatVersion = 1;

final _id = RegExp(r'^[0-9a-f]{32}$');
final _date = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
const _keys = {'version', 'id', 'firstRecorded', 'date', 'lang', 'name', 'dreams'};

/// A new night's id: 128 bits from the system's secure source, as 32 hex
/// digits. It names a file on the phone and is never sent anywhere (R4).
String newNightId([Random? random]) {
  final r = random ?? Random.secure();
  return [for (var i = 0; i < 16; i++) r.nextInt(256).toRadixString(16).padLeft(2, '0')].join();
}

/// A calendar date, as the phone showed it at the first recording.
typedef NightDate = ({int year, int month, int day});

// A real day its file can hold: four digits of year, a month and a day
// that exist. The constructor and decodeNight share it, so every night
// that can be made reads back after a save.
bool _isDay(int y, int m, int d) {
  if (y < 0 || y > 9999) return false;
  final check = DateTime.utc(y, m, d);
  return check.year == y && check.month == m && check.day == d;
}

final class Night {
  Night({
    required this.id,
    required this.firstRecorded,
    required this.date,
    required this.lang,
    this.name,
    required List<String> dreams,
  }) : dreams = List.unmodifiable(dreams) {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    if (!firstRecorded.isUtc) throw ArgumentError('firstRecorded');
    if (!_isDay(date.year, date.month, date.day)) throw ArgumentError('date');
  }

  final String id;

  /// The moment of the first recording, in UTC.
  final DateTime firstRecorded;

  /// The phone's date at the first recording, kept so that it never moves.
  final NightDate date;

  /// The language the night was recorded in.
  final Lang lang;

  /// The dreamer's name for the night, if they gave one.
  final String? name;

  /// The dreams, in the dreamer's words, in order.
  final List<String> dreams;

  @override
  bool operator ==(Object other) =>
      other is Night &&
      other.id == id &&
      other.firstRecorded == firstRecorded &&
      other.date == date &&
      other.lang == lang &&
      other.name == name &&
      listEquals(other.dreams, dreams);

  @override
  int get hashCode => Object.hash(id, firstRecorded, date, lang, name, Object.hashAll(dreams));
}

String _two(int n) => n.toString().padLeft(2, '0');

/// The night's file: UTF-8 JSON, version [formatVersion].
Uint8List encodeNight(Night n) => utf8.encode(jsonEncode({
      'version': formatVersion,
      'id': n.id,
      'firstRecorded': n.firstRecorded.toIso8601String(),
      'date': '${n.date.year.toString().padLeft(4, '0')}-${_two(n.date.month)}-${_two(n.date.day)}',
      'lang': n.lang.name,
      'name': n.name,
      'dreams': n.dreams,
    }));

/// The night in [bytes], or null when they are not a whole night of this
/// format. Nothing is guessed or repaired.
Night? decodeNight(Uint8List bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return null;
  }
  if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _keys)) return null;
  if (json
      case {
        'version': formatVersion,
        'id': final String id,
        'firstRecorded': final String recorded,
        'date': final String date,
        'lang': final String lang,
        'name': final String? name,
        'dreams': final List<Object?> dreams,
      }) {
    final at = DateTime.tryParse(recorded);
    final d = _date.firstMatch(date);
    final language = Lang.values.where((l) => l.name == lang).firstOrNull;
    if (!_id.hasMatch(id) || at == null || !at.isUtc || d == null || language == null) return null;
    final (y, m, day) = (int.parse(d[1]!), int.parse(d[2]!), int.parse(d[3]!));
    if (!_isDay(y, m, day)) return null;
    if (dreams.any((x) => x is! String)) return null;
    return Night(
      id: id,
      firstRecorded: at,
      date: (year: y, month: m, day: day),
      lang: language,
      name: name,
      dreams: dreams.cast<String>(),
    );
  }
  return null;
}
