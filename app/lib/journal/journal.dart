// The journal's operations, on the store (D56; D58). Plain Dart: the
// pages call these and decide nothing themselves.
//
// - A Save of new text makes a new dream (P2). The first Save makes the
//   night, and an empty Save keeps nothing (P10).
// - An edit replaces a dream's text. An emptied dream disappears and the
//   night's other dreams remain (D58 Q3); a night left with no dream is
//   deleted, as a deletion deletes it (P10).
import 'dart:math';

import '../words/lines.g.dart' show Lang;
import 'journal_store.dart';
import 'night.dart';
import 'night_rules.dart';

final class Journal {
  Journal(this._store, {this.zone = const PhoneZone(), DateTime Function()? now, this.random})
      : _now = now ?? (() => DateTime.now().toUtc());

  final JournalStore _store;
  final Zone zone;
  final DateTime Function() _now;

  /// The source of new nights' ids; the system's secure one when null.
  final Random? random;

  /// Now, in UTC.
  DateTime now() => _now();

  /// Every night, newest first recording first.
  Future<List<Night>> newestFirst() async => (await _store.nights()).reversed.toList();

  /// The night with [id], or null.
  Future<Night?> night(String id) async {
    for (final n in await _store.nights()) {
      if (n.id == id) return n;
    }
    return null;
  }

  /// Where a typing screen opened now from the journal saves.
  Future<Target> targetNow() async => targetAt(await _store.nights(), _now());

  /// Saves [text] as a new dream at [target]. Returns whether anything
  /// was kept.
  Future<bool> addDream(Target target, String text, Lang lang) async {
    if (isEmptyText(text)) return false;
    switch (target) {
      case NewNight(:final begun):
        await _store.save(Night(
          id: newNightId(random),
          firstRecorded: begun,
          date: dateOf(begun, zone),
          closes: closesAfter(begun, zone),
          lang: lang,
          dreams: [text],
        ));
        return true;
      case IntoNight(:final id):
        // One turn of the store's queue: a delete cannot fall between
        // the read and the write, nor another Save lose this one (D61).
        return _store.update(id, (n) => n.withDreams([...n.dreams, text]));
    }
  }

  /// Replaces dream [index] of night [id] with [text].
  Future<void> editDream(String id, int index, String text) async {
    await _store.update(id, (n) {
      if (index < 0 || index >= n.dreams.length) return n;
      final dreams = [...n.dreams];
      if (isEmptyText(text)) {
        dreams.removeAt(index);
      } else {
        dreams[index] = text;
      }
      return dreams.isEmpty ? null : n.withDreams(dreams);
    });
  }

  /// Deletes the night, and everything of it (X11).
  Future<void> delete(String id) => _store.delete(id);

  Future<bool> firstUseSeen() => _store.firstUseSeen();

  Future<void> markFirstUseSeen() => _store.markFirstUseSeen();
}
