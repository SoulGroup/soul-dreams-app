// Recordings waiting on the phone, turned into words again (D92 items 2
// and 3; D94): each one's saved audio replayed through Soniox's real-time
// stream with a fresh key, at real-time pace, never Soniox's file API.
// Only while the app is open: when the journal opens, when the app comes
// back, and when the connection returns; never while a typing screen is
// open, so no dream moves under it. One at a time, the oldest night
// first. Progress is kept (D94): when a retry is cut short (the app
// leaves, the connection breaks, a typing screen opens), the words already
// final go into the night before the recording, the audio they cover is
// cut away, and the next retry starts from there. When all of it is in
// words, the recording becomes its own dream in its place (D93 Q2), or
// goes, with no words (D93 Q7), and its audio is deleted at once.
// Nothing here names a file; each step logs a code only (R3).
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../core/safe_log.dart';
import 'key_client.dart';
import 'recording.dart';
import 'soniox.dart';

/// A recording waiting for its words: its night, its audio's id, and how
/// many of its bytes are already in words.
typedef Pending = ({String night, String audio, int from});

/// What the retries need of the journal; lib/journal/ implements it.
abstract interface class WaitingAudio {
  /// Every recording waiting, the oldest night first, in each night's
  /// order.
  Future<List<Pending>> waiting();

  /// What is left on the phone of [audio]: its bytes from [start] of the
  /// recording on, [size] of them; null when nothing is.
  Future<({int start, int size})?> part(String audio);

  /// Up to [length] bytes of [audio] from [at], counted from the
  /// recording's start, out of the part that begins at [start].
  Future<Uint8List> read(String audio, int start, int at, int length);

  /// [words] heard of [pending]'s audio, up to byte [to]. With [done], the
  /// recording becomes its words, or goes when there are none, and its
  /// audio is deleted; else the words go in before it, and its audio
  /// before [to] is cut away.
  Future<void> heard(Pending pending, String words, int to, {required bool done});
}

/// How much audio goes in each frame of a retry: a tenth of a second.
const retryFrame = bytesPerSecond ~/ 10;

final class Retries extends ChangeNotifier {
  Retries(this._recording, this._audio, {this.pace = 1, this.wait = const Duration(seconds: 10)}) {
    _changes = _recording.connection?.changes.listen((online) {
      if (online) kick();
    });
  }

  final Recording _recording;
  final WaitingAudio _audio;

  /// How fast the audio goes, against real time: 1, as Soniox asks; 0 in
  /// tests, with no wait at all.
  final double pace;

  /// How long the end waits for Soniox's last words.
  final Duration wait;

  /// Called after each recording's retry, whatever came of it (D98's
  /// diagnostic); never waited on for long, never throws into the loop.
  Future<void> Function()? afterRetry;

  StreamSubscription<bool>? _changes;
  int _holds = 0;
  bool _away = false;
  bool _running = false;
  // A chance came while a retry ran: look again when it ends.
  bool _again = false;
  bool _disposed = false;
  Completer<void> _stop = Completer<void>();
  String? _transcribing;

  /// The recording being turned into words now, for AI·6 (D93 Q3), or null.
  String? get transcribing => _transcribing;

  bool get _stopped => _holds > 0 || _away;

  // Stopped, or cut short since this run began.
  bool get _halted => _stopped || _stop.isCompleted;

  /// A chance to retry: the journal opened, the app came back, a typing
  /// screen closed, or the connection returned.
  void kick() {
    if (!_recording.on || _stopped) return;
    if (_running) {
      _again = true;
      return;
    }
    unawaited(_loop());
  }

  /// A typing screen opened: no retry until it closes.
  void hold() {
    _holds++;
    _cut();
  }

  /// A typing screen closed.
  void release() {
    if (_holds > 0) _holds--;
    kick();
  }

  /// The app leaves: the retry running is cut short, its progress kept.
  void away() {
    _away = true;
    _cut();
  }

  /// The app is back.
  void back() {
    _away = false;
    kick();
  }

  void _cut() {
    if (!_stop.isCompleted) _stop.complete();
  }

  void _show(String? audio) {
    _transcribing = audio;
    _changed();
  }

  // A retry ending after the journal is gone tells no one.
  void _changed() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _loop() async {
    _running = true;
    _again = false;
    _stop = Completer<void>();
    try {
      Pending? done;
      // The recordings whose retry failed in this run: at the back of the
      // queue, so those behind them get their turn (D96 Q4). Never deleted;
      // the next chance tries them first again.
      final failed = <String>{};
      while (!_halted) {
        // The phone says there is no connection: no key to ask for, and AI·6
        // would only flash; the connection returning is the next chance.
        if (!(_recording.connection?.online ?? true)) break;
        final all = [for (final p in await _audio.waiting()) if (!failed.contains(p.audio)) p];
        if (all.isEmpty || _halted) break;
        // A recording heard whole that still waits as it was: the journal
        // did not take its words, so stop rather than go round (a code).
        if (all.first == done) {
          SafeLog.event(LogEvent.retryFailed, [-3]);
          break;
        }
        final next = all.first;
        final retried = await _one(next);
        try {
          await afterRetry?.call();
        } on Object {
          // A diagnostic: nothing depends on it.
        }
        if (retried) {
          done = next;
        } else {
          // Cut short by the app leaving or a typing screen, or failed: the
          // run ends if halted, else the next one has its turn.
          failed.add(next.audio);
          if (_transcribing != null) _show(null);
        }
      }
    } on Object {
      SafeLog.event(LogEvent.retryFailed, [-2]);
    } finally {
      _running = false;
      if (_transcribing != null) _show(null);
      if (_again) kick();
    }
  }

  // One recording; true when all of it is now in words.
  Future<bool> _one(Pending p) async {
    final part = await _audio.part(p.audio);
    final end = part == null ? p.from : part.start + part.size;
    final start = part?.start ?? p.from;
    final at = math.max(p.from, start);
    if (part == null || at >= end) {
      // Nothing left to hear: the recording goes, or becomes nothing more.
      await _audio.heard(p, '', end & ~1, done: true);
      _changed();
      return true;
    }
    SafeLog.event(LogEvent.retryStarted);
    _show(p.audio);
    final String key;
    try {
      key = await _recording.key();
    } on KeyFailure catch (e) {
      SafeLog.event(LogEvent.retryFailed, [e.status]);
      return false;
    } on Object {
      SafeLog.event(LogEvent.retryFailed, [0]);
      return false;
    }
    if (_halted) return false;
    final SonioxLink link;
    try {
      link = await _recording.connect(key);
    } on Object {
      SafeLog.event(LogEvent.retryFailed, [0]);
      return false;
    }
    final words = StringBuffer();
    var heardMs = 0;
    final ended = Completer<bool>();
    void over(bool finished) {
      if (!ended.isCompleted) ended.complete(finished);
    }

    final replies = link.replies.listen(
      (text) {
        switch (readReply(text)) {
          case Heard(:final finalText, :final finalMs, :final finished):
            words.write(finalText);
            heardMs = math.max(heardMs, finalMs);
            if (finished) over(true);
          case Refused(:final code):
            SafeLog.event(LogEvent.retryFailed, [code]);
            over(false);
        }
      },
      onError: (Object _) => over(false),
      onDone: () => over(false),
    );
    var sent = at;
    try {
      final clock = Stopwatch()..start();
      while (sent < end && !ended.isCompleted && !_halted) {
        final bytes = await _audio.read(p.audio, start, sent, math.min(retryFrame, end - sent));
        if (bytes.isEmpty) break;
        link.add(bytes);
        sent += bytes.length;
        final due = Duration(microseconds: ((sent - at) * 1000000 * pace) ~/ bytesPerSecond) - clock.elapsed;
        if (due > Duration.zero) await Future.any([Future<void>.delayed(due), _stop.future, ended.future]);
      }
      if (sent >= end && !ended.isCompleted && !_halted) {
        link.finish();
        await Future.any([ended.future, _stop.future, Future<void>.delayed(wait)]);
      }
    } on Object {
      over(false);
    }
    unawaited(replies.cancel());
    try {
      unawaited(link.close().then((_) {}, onError: (Object _) {}));
    } on Object {
      // Already closed.
    }
    final finished = ended.isCompleted && await ended.future;
    if (finished && sent >= end) {
      await _audio.heard(p, words.toString(), end, done: true);
      SafeLog.event(LogEvent.retryDone);
      _changed();
      return true;
    }
    // Cut short: the words already final are kept, and the audio they
    // cover is cut away (D94).
    final to = math.min(at + heardMs * bytesPerSecond ~/ 1000, sent) & ~1;
    if (to > at) {
      await _audio.heard(p, words.toString(), to, done: false);
      _changed();
    }
    SafeLog.event(LogEvent.retryCut, [to > at ? to - at : 0, heardMs]);
    return false;
  }

  @override
  void dispose() {
    _disposed = true;
    _away = true;
    unawaited(_changes?.cancel());
    _cut();
    super.dispose();
  }
}
