// What the dreamer sets for themselves (main-path.md, Settings; C18-P,
// MP·26, MP·44, MP·84, MP·85; D110; D121; D122), in plain Dart, kept on the
// phone in the journal's folder (R11; docs/workflow.md (c)): Word Animation,
// on by default (D110); Night/Day mode, Automatic by default, or Manual,
// Day or Night; which painting Night images shows while consent (c) is
// given, Personal by default (D122, the stop's question 7); Life Context's
// length, 2 weeks by default (C159-I item 1), remembered now and used once
// Life Context is built (D121 item 2). Whether Life Context is on, and
// whether Night images is Off, are consents (b) and (c), kept with the
// consents (`consents.dart`), never here.
import 'dart:convert';
import 'dart:typed_data';

import '../core/night_day.dart';

/// Night images (MP·85): Off is consent (c) not given.
enum NightImages { personal, random, off }

/// Life Context length (MP·84), in its order.
enum LifeContextLength { oneWeek, twoWeeks, oneMonth, threeMonths }

final class Settings {
  const Settings({
    this.wordAnimation = true,
    this.nightDay = NightDayMode.automatic,
    this.images = NightImages.personal,
    this.length = LifeContextLength.twoWeeks,
  }) : assert(images != NightImages.off);

  final bool wordAnimation;
  final NightDayMode nightDay;

  /// The painting chosen for while consent (c) is given: never Off.
  final NightImages images;

  final LifeContextLength length;

  Settings copyWith({bool? wordAnimation, NightDayMode? nightDay, NightImages? images, LifeContextLength? length}) =>
      Settings(
        wordAnimation: wordAnimation ?? this.wordAnimation,
        nightDay: nightDay ?? this.nightDay,
        images: images ?? this.images,
        length: length ?? this.length,
      );

  @override
  bool operator ==(Object other) =>
      other is Settings &&
      other.wordAnimation == wordAnimation &&
      other.nightDay == nightDay &&
      other.images == images &&
      other.length == length;

  @override
  int get hashCode => Object.hash(wordAnimation, nightDay, images, length);
}

/// The file's bytes: version 1.
Uint8List encodeSettings(Settings s) => utf8.encode(
  jsonEncode({
    'version': 1,
    'wordAnimation': s.wordAnimation,
    'nightDay': s.nightDay.name,
    'images': s.images.name,
    'length': s.length.name,
  }),
);

T? _named<T extends Enum>(List<T> values, Object? name) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return null;
}

/// The settings [bytes] hold, or null when they do not read as version 1
/// exactly.
Settings? decodeSettings(Uint8List bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return null;
  }
  if (json is! Map<String, dynamic> || json.length != 5 || json['version'] != 1) return null;
  final animation = json['wordAnimation'];
  final nightDay = _named(NightDayMode.values, json['nightDay']);
  final images = _named(NightImages.values, json['images']);
  final length = _named(LifeContextLength.values, json['length']);
  if (animation is! bool || nightDay == null || images == null || images == NightImages.off || length == null) {
    return null;
  }
  return Settings(wordAnimation: animation, nightDay: nightDay, images: images, length: length);
}
