// Recording by voice, in SoulDreams Dev (D69, as D71 corrects it): the
// words appear as the dreamer speaks, and the audio goes from the
// microphone to Soniox and nowhere else off the phone. A recording starts
// the instant the microphone is tapped (D88): the microphone first, its
// audio held in memory until the stream opens and then sent first, in
// order; a key may be fetched in advance.
//
// Offline recording (D92 to D94): with a keep, every recording's audio is
// also kept on the phone from its first frame. When all its words are
// final, the audio is deleted at once. With no connection at the tap
// (MP·15), or a key, a stream or Soniox's budget that fails (MP·54), the
// recording goes on into the keep alone; what is not yet in final words
// waits, from Soniox's `final_audio_proc_ms` on, and the words not yet
// final leave the field, since they come back with the rest (D93 Q4, Q5).
// Every recording stops itself at ten minutes, as Stop does (D93 Q6).
// Without a keep, or once it fails, a key or a stream that fails stops the
// recording as a broken stream does, keeping the words shown (D71).
import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import '../core/hosts.dart';
import '../core/safe_log.dart';
import 'audio_keep.dart';
import 'connection.dart';
import 'key_client.dart';
import 'microphone.dart';
import 'retries.dart';
import 'soniox.dart';

/// What a typing screen needs to record.
final class Recording {
  Recording({
    required this.on,
    required this.microphone,
    required this.key,
    required this.connect,
    this.keep,
    this.connection,
    this.cap = recordingCap,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// SoulDreams Dev's own: our server for the key, Soniox's EU endpoint for
  /// the words. Off while the server's address is empty, or the build's
  /// beta key is not 48 characters of A-Z, a-z and 0-9 (D18; D71 Q17).
  factory Recording.live({
    required Microphone microphone,
    required String betaKey,
    String server = Hosts.server,
    Connection? connection,
  }) => Recording(
    on: server.isNotEmpty && _betaShape.hasMatch(betaKey),
    microphone: microphone,
    key: () => fetchKey(Uri.parse(server), betaKey),
    connect: (key) => SocketLink.open(Hosts.soniox, key),
    connection: connection,
  );

  final bool on;
  final Microphone microphone;
  final Future<String> Function() key;
  final Future<SonioxLink> Function(String key) connect;

  /// Where the audio waits on the phone (D92), or null: nothing kept, and a
  /// recording needs a connection (D71).
  final AudioKeep? keep;

  /// Whether the phone has a connection; null: taken as online.
  final Connection? connection;

  /// The bytes of audio at which a recording stops itself (D93 Q6).
  final int cap;
  final DateTime Function() _now;

  /// The same recording, keeping its audio in [keep]; with [waiting], it
  /// also retries the recordings waiting there (D94).
  Recording keeping(AudioKeep keep, {WaitingAudio? waiting}) {
    final kept = Recording(
      on: on,
      microphone: microphone,
      key: key,
      connect: connect,
      keep: keep,
      connection: connection,
      cap: cap,
      now: _now,
    );
    if (waiting != null) kept._retries = Retries(kept, waiting);
    return kept;
  }

  /// The retries of the recordings waiting on the phone, or null.
  Retries? get retries => _retries;
  Retries? _retries;

  // A key fetched in advance (D88): single use, and used only while fresh.
  Future<String>? _ahead;
  DateTime? _aheadAt;

  /// Fetches a key in advance, when the typing screen opens and after each
  /// recording.
  void warm() {
    if (!on) return;
    final ahead = key();
    ahead.ignore();
    _ahead = ahead;
    _aheadAt = _now();
  }

  /// A key for one recording: the one fetched in advance if it is fresh and
  /// came, else a new one.
  Future<String> takeKey() async {
    final ahead = _ahead;
    final at = _aheadAt;
    _ahead = null;
    _aheadAt = null;
    if (ahead != null && at != null && _now().difference(at) < keyFresh) {
      try {
        return await ahead;
      } on Object {
        // It failed: a new one below.
      }
    }
    return key();
  }
}

/// How long a key fetched in advance is used: Soniox's key opens a stream
/// within 60 seconds of being made (D71 Q10); the rest is left for opening.
const keyFresh = Duration(seconds: 45);

final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');

/// How long a stop waits for Soniox's last words.
const lastWords = Duration(seconds: 5);

/// A second of audio: 16 kHz, sixteen bits, one channel.
const bytesPerSecond = sampleRate * 2;

/// Every recording stops itself at ten minutes (D93 Q6).
const recordingCap = 10 * 60 * bytesPerSecond;

/// What a recording leaves to wait (D94): its audio's id, and how many of
/// its bytes are already in final words.
typedef Left = ({String audio, int from});

/// What went wrong, for the typing screen to say (D93 Q4): the microphone
/// refused (MP·63); no connection at the tap (MP·15); a key, a stream or
/// Soniox's budget that failed with one, the audio kept to wait (MP·54).
enum Trouble { refused, offline, broke }

void _noTrouble(Trouble _) {}

void _nothing() {}

/// One recording, from the microphone's tap to its end.
final class RecordingSession {
  RecordingSession(
    this._recording, {
    required this.onHeard,
    required this.onLevel,
    required this.onStopping,
    required this.onEnded,
    this.onTrouble = _noTrouble,
    this.onTroubleOver = _nothing,
    this.wait = lastWords,
  });

  final Recording _recording;

  /// How long a stop waits for the last words.
  final Duration wait;

  /// Words heard: the newly final ones, and the provisional ones.
  final void Function(String finalText, String provisional) onHeard;

  /// Each frame's loudness, 0 to 1.
  final void Function(double level) onLevel;

  /// A stop began: a tap, Save or Back, or a call or Siri. The last words
  /// may still come; the clock stops here (D83).
  final void Function() onStopping;

  /// The recording ended, by a stop or by itself.
  final void Function() onEnded;

  /// Something the dreamer is told (D93 Q4).
  final void Function(Trouble trouble) onTrouble;

  /// What [onTrouble] told no longer holds (D96 Q1).
  final void Function() onTroubleOver;

  SonioxLink? _link;
  // The audio heard before the stream opened, in memory only (D88).
  final _held = <Uint8List>[];
  // Opening the stream, once the microphone streams; done when it opened
  // or failed (a stop also stops waiting when the session ends).
  Future<void>? _opening;
  StreamSubscription<String>? _replies;
  StreamSubscription<Uint8List>? _frames;
  StreamSubscription<void>? _interruptions;
  // Done when the wait for the last words can end: Soniox finished, the
  // stream went while a stop waits, or the session ended.
  final _finished = Completer<void>();
  bool _cancelled = false;
  bool _ended = false;

  // The audio kept on the phone (D92): its id, what is not yet handed on,
  // whether the keep failed; the bytes recorded, and those in final words.
  String? _audio;
  final _unkept = BytesBuilder(copy: false);
  bool _keepFailed = false;
  // The last write asked of the keep; each waits for the one before, so the
  // audio is written in order and never past a write that failed (D96).
  Future<void> _written = Future<void>.value();
  int _recorded = 0;
  int _covered = 0;
  // Every word final: Soniox finished after the end frame.
  bool _allFinal = false;
  // No stream any more, or none at all: the audio goes to the keep only.
  bool _cut = false;
  bool _capped = false;

  /// What waits once the session has ended, or null: nothing kept, or every
  /// word final (D94).
  Left? get left => _left;
  Left? _left;

  // The audio is kept and the keep has not failed.
  bool get _keeping => _audio != null && !_keepFailed;

  // The microphone has been started and not yet stopped, whether or not its
  // frames are listened to yet.
  bool _micStarted = false;
  Future<void>? _stopping;

  /// Starts recording; true once the microphone streams, before the key
  /// and the stream (D88). False when it did not start: a code is logged
  /// for a failure; after a stop or a cancel while starting, none is, and
  /// the session has ended by then. A key or a stream that fails later ends
  /// the session as a break does, reported by [onEnded].
  Future<bool> start() async {
    if (!_recording.on) return _fail(LogEvent.recordingOff);
    final bool allowed;
    try {
      allowed = await _recording.microphone.allowed();
    } on Object {
      return _refused();
    }
    if (!allowed) return _refused();
    if (_cancelled || _ended) return false;
    final Stream<Uint8List> frames;
    try {
      frames = await _recording.microphone.start();
    } on Object {
      return _fail(LogEvent.recordingMicFailed);
    }
    _micStarted = true;
    _audio = _recording.keep?.newId();
    final stopping = _stopping;
    if (_cancelled || _ended || stopping != null) {
      // The session ended, or a stop came, while the microphone started: it
      // is on, so off; with no stream yet the stop ends it at once.
      await _micOff();
      await stopping;
      return false;
    }
    _frames = frames.listen((frame) {
      _keep(frame);
      final link = _link;
      if (_cut) {
        // The keep has it all.
      } else if (link != null) {
        link.add(frame);
      } else {
        _held.add(frame);
      }
      onLevel(level(frame));
      _recorded += frame.length;
      if (_recorded >= _recording.cap && !_capped) {
        _capped = true;
        SafeLog.event(LogEvent.recordingCapped);
        unawaited(stop());
      }
    });
    // A call or Siri stops the recording as Stop does: the words heard
    // stay (D79 b).
    _interruptions = _recording.microphone.interruptions.listen((_) {
      SafeLog.event(LogEvent.recordingInterrupted);
      unawaited(stop());
    });
    SafeLog.event(LogEvent.recordingStarted);
    if (_keeping && !(_recording.connection?.online ?? true)) {
      // No connection at the tap: no key is asked for; the audio waits
      // (D93 Q4, MP·15).
      _cut = true;
      SafeLog.event(LogEvent.recordingOffline);
      onTrouble(Trouble.offline);
    } else {
      _opening = _open();
    }
    return true;
  }

  // A frame into the keep, handed on about once a second (D92).
  void _keep(Uint8List frame) {
    if (!_keeping) return;
    _unkept.add(frame);
    if (_unkept.length >= bytesPerSecond) _handOn();
  }

  void _handOn({bool last = false}) {
    final audio = _audio;
    if (audio == null || _keepFailed) return;
    final bytes = _unkept.takeBytes();
    if (bytes.isEmpty && !last) return;
    _written = _write(audio, bytes, last);
  }

  // One write, after the one before it; it never throws. After a failure
  // nothing more is written: a later write would leave a gap, or begin in
  // the middle of a sample.
  Future<void> _write(String audio, Uint8List bytes, bool last) async {
    await _written;
    if (_keepFailed) return;
    try {
      await _recording.keep!.add(audio, bytes, last: last);
    } on Object {
      _failKeep();
    }
  }

  // The keep failed (a full phone): logged once. With no stream the
  // recording has nothing left to go on with, so it stops as a broken
  // stream does, and the notice that the audio stays on the phone goes
  // (D96 Q1); with a stream, the words still come (D71).
  void _failKeep() {
    if (_keepFailed) return;
    _keepFailed = true;
    SafeLog.event(LogEvent.audioKeepFailed);
    if (!_cut) return;
    onTroubleOver();
    if (!_ended) unawaited(_shut());
  }

  // The stream is gone or never came, with the audio kept: the recording
  // goes on into the keep alone (D92); the words not yet final leave the
  // field, since they come back with the rest (D93 Q5); MP·54 shows.
  void _goOn() {
    _cut = true;
    _held.clear();
    onHeard('', '');
    onTrouble(Trouble.broke);
    if (_stopping != null && !_finished.isCompleted) _finished.complete();
  }

  // The key and the stream, while the microphone already streams (D88).
  Future<void> _open() async {
    final String key;
    try {
      key = await _recording.takeKey();
    } on KeyFailure catch (e) {
      return _brokeOff(LogEvent.recordingKeyFailed, e.status);
    } on Object {
      return _brokeOff(LogEvent.recordingKeyFailed, 0);
    }
    if (_ended) return;
    final SonioxLink link;
    try {
      link = await _recording.connect(key);
    } on Object {
      return _brokeOff(LogEvent.recordingStreamFailed, 0);
    }
    if (_ended) {
      // The session ended while the stream opened: close it, wait for nothing.
      _closeQuietly(link);
      return;
    }
    _link = link;
    _replies = link.replies.listen(_reply, onError: (Object _) => _broke(0), onDone: () => _broke(link.closeCode ?? 0));
    // The held audio first, in order; then the frames as they come.
    for (final frame in _held) {
      link.add(frame);
    }
    _held.clear();
  }

  // No key or no stream: as a break, holding nothing (D88); with the audio
  // kept, the recording goes on (D92).
  void _brokeOff(LogEvent code, int number) {
    if (_ended) return;
    SafeLog.event(code, [number]);
    if (_keeping) {
      _goOn();
    } else {
      unawaited(_shut());
    }
  }

  bool _refused() {
    onTrouble(Trouble.refused);
    return _fail(LogEvent.recordingRefused);
  }

  bool _fail(LogEvent code, [List<num> numbers = const []]) {
    SafeLog.event(code, numbers);
    return false;
  }

  void _reply(String text) {
    if (_ended) return;
    switch (readReply(text)) {
      case Heard(:final finalText, :final provisional, :final finished, :final finalMs):
        _covered = math.max(_covered, finalMs * bytesPerSecond ~/ 1000);
        if (finalText.isNotEmpty || provisional.isNotEmpty || finished) onHeard(finalText, provisional);
        if (finished) _allFinal = true;
        if (finished && !_finished.isCompleted) _finished.complete();
      case Refused(:final code):
        _broke(code);
    }
  }

  // The stream broke off before its end: the words shown stay; with the
  // audio kept, the recording goes on and the rest waits (D92, D93 Q5).
  void _broke(int code) {
    if (_ended || _finished.isCompleted || _cut) return;
    SafeLog.event(LogEvent.recordingStreamFailed, [code]);
    if (!_keeping) {
      unawaited(_shut());
      return;
    }
    final link = _link;
    _link = null;
    unawaited(_replies?.cancel());
    _replies = null;
    if (link != null) _closeQuietly(link);
    _goOn();
  }

  /// Stops: the microphone off, then Soniox's last words, waited for up to
  /// [wait].
  ///
  /// A second stop is the first one.
  Future<void> stop() => _stopping ??= _stop();

  Future<void> _stop() async {
    // Already ending (a cancel, a failed keep): wait for the ending.
    if (_ended) return _shut();
    onStopping();
    await _micOff();
    // The stream may still be opening (D88): the held audio goes when it
    // opens, all within the one wait for the last words (D75).
    final clock = Stopwatch()..start();
    final opening = _opening;
    // A cancel or a break ends that wait at once (D75): `_shut` completes
    // `_finished`.
    if (opening != null) await Future.any([opening, _finished.future]).timeout(wait, onTimeout: () {});
    final link = _link;
    if (link != null && !_ended) {
      link.finish();
      await _finished.future.timeout(wait - clock.elapsed, onTimeout: () {});
    }
    // Nothing answered in time, and no break was reported: the stream is as
    // good as gone. With the audio kept, the rest waits and the dreamer is
    // told, as for a break (MP·54, D93 Q4; phone check 6).
    if (!_finished.isCompleted && !_ended && _keeping) _broke(0);
    await _shut();
  }

  /// Ends at once, waiting for nothing (leaving the screen or the app).
  Future<void> cancel() async {
    _cancelled = true;
    await _shut();
  }

  Future<void> _micOff() async {
    if (!_micStarted) return;
    _micStarted = false;
    final frames = _frames;
    _frames = null;
    unawaited(_interruptions?.cancel());
    _interruptions = null;
    // Not waited for: its future may belong to another zone, and nothing
    // needs it.
    if (frames != null) unawaited(frames.cancel());
    try {
      await _recording.microphone.stop();
    } on Object {
      SafeLog.event(LogEvent.recordingMicFailed);
    }
  }

  // A close is never waited for: on a dead connection it can take minutes.
  void _closeQuietly(SonioxLink link) {
    try {
      unawaited(link.close().then((_) {}, onError: (Object _) {}));
    } on Object {
      // Already closed: nothing to do.
    }
  }

  // Every caller waits for the one ending, so a stop that finds the session
  // already ending returns only when it has ended (`left` is set by then).
  Future<void>? _shutting;

  Future<void> _shut() => _shutting ??= _end();

  Future<void> _end() async {
    _ended = true;
    if (!_finished.isCompleted) _finished.complete();
    _held.clear();
    await _micOff();
    final replies = _replies;
    _replies = null;
    final link = _link;
    _link = null;
    unawaited(replies?.cancel());
    await _settleAudio();
    SafeLog.event(LogEvent.recordingEnded);
    onEnded();
    if (link != null) _closeQuietly(link);
  }

  // The audio, once the recording is over: deleted at once when every word
  // is final, or nothing was recorded past the final words; else it waits
  // from there, and the words not yet final leave the field (D93 Q5, D94).
  // It waits for the last write: what waits is what was really kept.
  Future<void> _settleAudio() async {
    final audio = _audio;
    if (audio == null) return;
    final from = math.min(_covered, _recorded) & ~1;
    if (!_keepFailed && !_allFinal && _recorded > from) {
      _handOn(last: true);
      await _written;
      if (!_keepFailed) {
        _left = (audio: audio, from: from);
        SafeLog.event(LogEvent.recordingSettled, [_covered * 1000 ~/ bytesPerSecond, _recorded * 1000 ~/ bytesPerSecond]);
        onHeard('', '');
        return;
      }
    }
    // Writes still queued must land first, or one would make a file after
    // the discard that no night names.
    await _written;
    _recording.keep!.discard(audio).catchError((Object _) {});
  }
}
