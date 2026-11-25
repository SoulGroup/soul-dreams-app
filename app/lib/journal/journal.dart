// The journal's operations, on the store (D56; D58). Plain Dart: the
// pages call these and decide nothing themselves.
//
// - A Save of new text makes a new dream (P2). The first Save makes the
//   night, and an empty Save keeps nothing (P10).
// - An edit replaces a dream's text. An emptied dream disappears and the
//   night's other dreams remain (D58 Q3); a night left with no dream is
//   deleted, as a deletion deletes it (P10).
// - The two consents and the settings (D103; D122; D125) are kept and read
//   here. When the journal is deleted, they go with it, and `consentGone`
//   tells the app, which returns to its start (D110).
// - A dream is told in words or waits as a recording (D93 Q2); a dream's
//   index counts both, and a waiting one is never edited. A Save puts the
//   recordings its screen left waiting after its words, in order; a Save
//   with nothing typed but a recording waiting keeps it (D93 Q7).
// - Life Context's kept sentences (C159-I item 1; D131): kept from a piece
//   of the dreamer's words said in a night, sentence by sentence, each with
//   the day it was said; edited (only the kept copy, D131 item 2), deleted
//   one by one, several, or all; and swept when past the Recent window.
//   Whether Life Context is on is decided above (`LifeContext`), not here.
import 'dart:math';

import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier, listEquals;

import '../life_context/kept.dart';
import '../life_context/sentences.dart';
import '../settings/consents.dart';
import '../settings/settings.dart';
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

  /// Saves [text] as a new dream at [target], and after it the recordings
  /// [waiting] for their words. Returns whether anything was kept.
  Future<bool> addDream(Target target, String text, Lang lang, {List<Waiting> waiting = const []}) async {
    final added = <Dream>[if (!isEmptyText(text)) Told(text), ...waiting];
    if (added.isEmpty) return false;
    switch (target) {
      case NewNight(:final begun):
        await _store.save(Night(
          id: newNightId(random),
          firstRecorded: begun,
          date: dateOf(begun, zone),
          closes: closesAfter(begun, zone),
          lang: lang,
          entries: added,
        ));
        return true;
      case IntoNight(:final id):
        // One turn of the store's queue: a delete cannot fall between
        // the read and the write, nor another Save lose this one (D61).
        return _store.update(id, (n) => n.withEntries([...n.entries, ...added]));
    }
  }

  /// Replaces dream [index] of night [id] with [text], and puts the
  /// recordings [waiting] for their words after it (at the night's end if
  /// that dream is gone). The index counts every dream, told or waiting; a
  /// waiting one is never replaced. With [was], the dream's words when its
  /// screen opened: if words that came for a recording moved it meanwhile
  /// (D94), it is found by them. Returns whether the night was there to
  /// change (D96 Q3).
  Future<bool> editDream(String id, int index, String text, {List<Waiting> waiting = const [], String? was}) {
    return _store.update(id, (n) {
      final entries = [...n.entries];
      var at = entries.length;
      if (was != null && !(index >= 0 && index < entries.length && entries[index] == Told(was))) {
        index = _nearest(entries, Told(was), index);
      }
      if (index >= 0 && index < entries.length && entries[index] is Told) {
        if (isEmptyText(text)) {
          entries.removeAt(index);
          at = index;
        } else {
          entries[index] = Told(text);
          at = index + 1;
        }
      }
      entries.insertAll(at, waiting);
      if (entries.isEmpty) return null;
      return listEquals(entries, n.entries) ? n : n.withEntries(entries);
    });
  }

  // The place of [dream] in [entries] nearest [near], the lower when two are
  // as near; -1 when it is not there. Equal words in two dreams must not send
  // an edit to the wrong one (D96).
  static int _nearest(List<Dream> entries, Dream dream, int near) {
    var best = -1;
    for (var i = 0; i < entries.length; i++) {
      if (entries[i] != dream) continue;
      if (best < 0 || (i - near).abs() < (best - near).abs()) best = i;
    }
    return best;
  }

  /// Keeps [readings] in night [id], which is then read (D155 item 2), with
  /// their calls' [usage] where kept (head's message 34); a night already
  /// read keeps its first. Returns whether the night was there.
  Future<bool> keepReadings(String id, List<Reading> readings, {List<ModelUsage>? usage}) =>
      _store.update(id, (n) => n.readings == null ? n.withReadings(readings, usage: usage) : n);

  /// Deletes the night, and everything of it (X11).
  Future<void> delete(String id) => _store.delete(id);

  Future<bool> firstUseSeen() => _store.firstUseSeen();

  Future<void> markFirstUseSeen() => _store.markFirstUseSeen();

  /// The consents answered in onboarding, or null when none is kept.
  Future<Consents?> consents() => _store.consents();

  /// Keeps the consents (D122).
  Future<void> keepConsents(Consents consents) => _store.keepConsents(consents);

  /// The settings kept, or null when none is.
  Future<Settings?> settings() => _store.settings();

  /// Keeps the settings (D122).
  Future<void> keepSettings(Settings settings) => _store.keepSettings(settings);

  /// The kept sentences, in the order kept.
  Future<List<Kept>> kept() => _store.kept();

  /// Keeps the sentences of [text], said now in night [night], word for
  /// word. Returns how many were kept: none when that night is gone.
  Future<int> keep(String night, String text) async {
    final day = dateOf(_now(), zone);
    final add = [for (final s in sentencesOf(text)) Kept(id: newKeptId(random), night: night, day: day, text: s)];
    return await _store.addKept(night, add) ? add.length : 0;
  }

  /// Replaces kept sentence [id]'s words with [text]; nothing but spaces
  /// deletes it. The night's own text never changes (D131 item 2).
  Future<void> editKept(String id, String text) => _store.changeKept(
    (kept) => [
      for (final k in kept)
        if (k.id != id) k else if (!isEmptyText(text)) k.withText(text.trim()),
    ],
  );

  /// Deletes the kept sentences [ids].
  Future<void> deleteKept(Set<String> ids) =>
      _store.changeKept((kept) => [for (final k in kept) if (!ids.contains(k.id)) k]);

  /// Deletes every kept sentence.
  Future<void> deleteAllKept() => _store.deleteKept();

  /// Deletes the kept sentences past the Recent window of [length] today.
  /// Returns how many went.
  Future<int> sweepKept(LifeContextLength length) async {
    final today = dateOf(_now(), zone);
    var gone = 0;
    await _store.changeKept((kept) {
      final rest = [for (final k in kept) if (inWindow(k, today, length)) k];
      gone = kept.length - rest.length;
      return rest;
    });
    return gone;
  }

  /// Moves on each time the journal is deleted, the consents with it: the
  /// app returns to its start (D110).
  ValueListenable<int> get consentGone => _consentGone;
  final _consentGone = ValueNotifier<int>(0);

  /// Deletes the whole journal, the consents, the settings and the first-use
  /// flag with it (X11; D54). Then the app returns to its start (D110).
  Future<void> deleteAll() async {
    await _store.deleteAll();
    _consentGone.value++;
  }
}
