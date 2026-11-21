// The three consents (C159-I item 5; C18-P, MP·66 to MP·70; D122), in
// plain Dart: the readings (a), Life Context (b) and the night images (c),
// each given or not, none given beforehand. The record kept on the phone
// (D122, the stop's question 10): each consent's answer and the UTC day it
// last changed, and that the dreamer is 18 or over (D103); no identifier
// and never the age band (C146-I item 1). Version 1, D103's one consent,
// still reads: as (a) given and (b) and (c) not given, with no day (D122,
// the stop's question 12).
import 'dart:convert';
import 'dart:typed_data';

enum Consent { readings, lifeContext, images }

/// One consent's answer, and the UTC day of its last change
/// (`YYYY-MM-DD`), or null when that is not known (read from version 1).
final class Answer {
  const Answer(this.given, [this.day]);

  final bool given;
  final String? day;

  @override
  bool operator ==(Object other) => other is Answer && other.given == given && other.day == day;

  @override
  int get hashCode => Object.hash(given, day);
}

/// The UTC day of [instant], as the record keeps it.
String dayOf(DateTime instant) {
  final u = instant.toUtc();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${u.year.toString().padLeft(4, '0')}-${two(u.month)}-${two(u.day)}';
}

/// The three answers, every consent answered.
final class Consents {
  Consents(Map<Consent, Answer> answers) : answers = Map.unmodifiable(answers) {
    if (answers.length != Consent.values.length) throw ArgumentError('answers');
  }

  /// Each consent [given] or not, all on the day of [now].
  factory Consents.answered(Map<Consent, bool> given, DateTime now) =>
      Consents({for (final c in Consent.values) c: Answer(given[c] ?? false, dayOf(now))});

  final Map<Consent, Answer> answers;

  bool given(Consent consent) => answers[consent]!.given;

  /// The same, with [consent] [given] or not on the day of [now]; the others
  /// as they were.
  Consents withAnswer(Consent consent, bool given, DateTime now) =>
      Consents({...answers, consent: Answer(given, dayOf(now))});

  @override
  bool operator ==(Object other) =>
      other is Consents && Consent.values.every((c) => other.answers[c] == answers[c]);

  @override
  int get hashCode => Object.hashAll([for (final c in Consent.values) answers[c]]);
}

final _day = RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$');

/// The file's bytes: version 2.
Uint8List encodeConsents(Consents consents) => utf8.encode(
  jsonEncode({
    'version': 2,
    'over18': true,
    for (final c in Consent.values)
      c.name: {'given': consents.answers[c]!.given, 'day': ?consents.answers[c]!.day},
  }),
);

/// The consents [bytes] hold, or null when they hold none: version 2
/// exactly, or version 1 exactly (D103), else nothing, and onboarding asks
/// again.
Consents? decodeConsents(Uint8List bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return null;
  }
  if (json is! Map<String, dynamic> || json['over18'] != true) return null;
  if (json['version'] == 1 && json.length == 2) {
    return Consents({
      Consent.readings: const Answer(true),
      Consent.lifeContext: const Answer(false),
      Consent.images: const Answer(false),
    });
  }
  if (json['version'] != 2 || json.length != 2 + Consent.values.length) return null;
  final answers = <Consent, Answer>{};
  for (final c in Consent.values) {
    final a = json[c.name];
    if (a is! Map<String, dynamic>) return null;
    final given = a['given'];
    final day = a['day'];
    if (given is! bool || a.length != (a.containsKey('day') ? 2 : 1)) return null;
    if (a.containsKey('day') && (day is! String || !_day.hasMatch(day))) return null;
    answers[c] = Answer(given, day as String?);
  }
  return Consents(answers);
}
