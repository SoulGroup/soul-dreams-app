// Life Context while the journal is open (C159-I item 1; D110; D127; D128;
// D131), in plain Dart: whether it is on, what its page shows, and what the
// dreamer does there. On is consent (b), the Life Context row (MP·83): Off
// keeps nothing (a capture keeps nothing) and deletes what is kept (the
// sweep finds nothing kept while Off, and turning it off deletes it,
// `SettingsController.answer`).
//
// - The page shows exactly what readings could see now: the Recent list,
//   every kept sentence inside the window (MP·84), newest first, and the
//   Kept longer list, empty until its rule exists (D131 item 5).
// - The sweep (D131 item 4): sentences past the window are deleted when the
//   journal opens, when the app comes back, and at each local midnight
//   while it is open.
// - A change that cannot be done logs a code and the page shows what is
//   kept; nothing here carries a sentence into a log (R3).
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/safe_log.dart';
import '../journal/journal.dart';
import '../journal/night_rules.dart';
import '../settings/consents.dart';
import '../settings/settings_controller.dart';
import 'kept.dart';

final class LifeContext extends ChangeNotifier {
  LifeContext(this._journal, this._settings);

  final Journal _journal;
  final SettingsController _settings;
  Timer? _midnight;

  /// Whether Life Context is on: consent (b) is given.
  bool get on => _settings.consents.given(Consent.lifeContext);

  /// Keeps the sentences of [text], said now in night [night], when Life
  /// Context is on. Returns how many were kept. Nothing calls it yet: its
  /// sources come with Questions and Reflection.
  Future<int> capture(String night, String text) async {
    if (!on) return 0;
    try {
      final n = await _journal.keep(night, text);
      if (n > 0) notifyListeners();
      return n;
    } on Object {
      SafeLog.event(LogEvent.keptKeepFailed);
      return 0;
    }
  }

  /// The Recent list: every kept sentence inside the window today, newest
  /// first; nothing while Off.
  Future<List<Kept>> recent() async {
    if (!on) return const [];
    final today = dateOf(_journal.now(), _journal.zone);
    final length = _settings.settings.length;
    return newestFirst([for (final k in await _journal.kept()) if (inWindow(k, today, length)) k]);
  }

  /// The Kept longer list: empty until its rule exists (D131 item 5).
  List<Kept> get longer => const [];

  /// Deletes what is past the window, or everything while Off.
  Future<void> sweep() async {
    try {
      if (!on) return await _journal.deleteAllKept();
      final gone = await _journal.sweepKept(_settings.settings.length);
      if (gone > 0) SafeLog.event(LogEvent.keptExpired, [gone]);
    } on Object {
      SafeLog.event(LogEvent.keptDeleteFailed);
    }
  }

  /// Sweeps now, and again at each local midnight while the journal is open.
  void start() {
    unawaited(sweep());
    _schedule();
  }

  void _schedule() {
    _midnight?.cancel();
    final now = _journal.now();
    final w = _journal.zone.wall(now);
    final next = _journal.zone.instantAt(w.year, w.month, w.day + 1, 0);
    _midnight = Timer(next.difference(now), () {
      unawaited(sweep());
      _schedule();
    });
  }

  /// The app came back: a day may have passed.
  void resumed() => unawaited(sweep());

  /// Replaces sentence [id]'s words with [text]: the kept copy only (D131
  /// item 2); nothing but spaces deletes it.
  Future<void> edit(String id, String text) => _change(() => _journal.editKept(id, text), LogEvent.keptKeepFailed);

  /// Deletes the sentences [ids].
  Future<void> delete(Set<String> ids) => _change(() => _journal.deleteKept(ids), LogEvent.keptDeleteFailed);

  /// Deletes every kept sentence: Delete all, and the Recent list while the
  /// Kept longer list is empty.
  Future<void> deleteAll() => _change(_journal.deleteAllKept, LogEvent.keptDeleteFailed);

  Future<void> _change(Future<void> Function() change, LogEvent failed) async {
    try {
      await change();
    } on Object {
      SafeLog.event(failed);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _midnight?.cancel();
    super.dispose();
  }
}
