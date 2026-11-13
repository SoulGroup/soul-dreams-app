// Recording by voice, in SoulDreams Dev (D69, as D71 corrects it): the
// words appear as the dreamer speaks, and the audio goes from the
// microphone to Soniox and nowhere else; nothing of it is kept on the
// phone. This slice needs a connection: with none, or with the key or
// the stream failing, the microphone does not start; a stream that breaks
// stops, keeping the words shown. Each logs a code and shows nothing new
// (D71). Offline recording is the next slice.
import 'dart:async';
import 'dart:typed_data';

import '../core/hosts.dart';
import '../core/safe_log.dart';
import 'key_client.dart';
import 'microphone.dart';
import 'soniox.dart';

/// What a typing screen needs to record.
final class Recording {
  const Recording({required this.on, required this.microphone, required this.key, required this.connect});

  /// SoulDreams Dev's own: our server for the key, Soniox's EU endpoint for
  /// the words. Off while the server's address is empty, or the build's
  /// beta key is not 48 characters of A-Z, a-z and 0-9 (D18; D71 Q17).
  factory Recording.live({required Microphone microphone, required String betaKey, String server = Hosts.server}) =>
      Recording(
        on: server.isNotEmpty && _betaShape.hasMatch(betaKey),
        microphone: microphone,
        key: () => fetchKey(Uri.parse(server), betaKey),
        connect: (key) => SocketLink.open(Hosts.soniox, key),
      );

  final bool on;
  final Microphone microphone;
  final Future<String> Function() key;
  final Future<SonioxLink> Function(String key) connect;
}

final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');

/// How long a stop waits for Soniox's last words.
const lastWords = Duration(seconds: 5);

/// One recording, from the microphone's tap to its end.
final class RecordingSession {
  RecordingSession(
    this._recording, {
    required this.onHeard,
    required this.onLevel,
    required this.onEnded,
    this.wait = lastWords,
  });

  final Recording _recording;

  /// How long a stop waits for the last words.
  final Duration wait;

  /// Words heard: the newly final ones, and the provisional ones.
  final void Function(String finalText, String provisional) onHeard;

  /// Each frame's loudness, 0 to 1.
  final void Function(double level) onLevel;

  /// The recording ended, by a stop or by itself.
  final void Function() onEnded;

  SonioxLink? _link;
  StreamSubscription<String>? _replies;
  StreamSubscription<Uint8List>? _frames;
  final _finished = Completer<void>();
  bool _cancelled = false;
  bool _ended = false;

  // The microphone has been started and not yet stopped, whether or not its
  // frames are listened to yet.
  bool _micStarted = false;
  Future<void>? _stopping;

  /// Starts recording; false when it did not start (a code is logged).
  Future<bool> start() async {
    if (!_recording.on) return _fail(LogEvent.recordingOff);
    final bool allowed;
    try {
      allowed = await _recording.microphone.allowed();
    } on Object {
      return _fail(LogEvent.recordingRefused);
    }
    if (!allowed) return _fail(LogEvent.recordingRefused);
    if (_cancelled || _ended) return false;
    final String key;
    try {
      key = await _recording.key();
    } on KeyFailure catch (e) {
      return _fail(LogEvent.recordingKeyFailed, [e.status]);
    } on Object {
      return _fail(LogEvent.recordingKeyFailed, [0]);
    }
    if (_cancelled || _ended) return false;
    final SonioxLink link;
    try {
      link = await _recording.connect(key);
    } on Object {
      return _fail(LogEvent.recordingStreamFailed, [0]);
    }
    if (_cancelled || _ended) {
      // The session ended while the stream opened: close it, wait for nothing.
      _closeQuietly(link);
      return false;
    }
    _link = link;
    _replies = link.replies.listen(_reply, onError: (Object _) => _broke(0), onDone: () => _broke(link.closeCode ?? 0));
    final Stream<Uint8List> frames;
    try {
      frames = await _recording.microphone.start();
    } on Object {
      SafeLog.event(LogEvent.recordingMicFailed);
      await _shut();
      return false;
    }
    _micStarted = true;
    if (_cancelled || _ended) {
      // The session ended while the microphone started: it is on, so off.
      await _micOff();
      await _shut();
      return false;
    }
    _frames = frames.listen((frame) {
      _link?.add(frame);
      onLevel(level(frame));
    });
    SafeLog.event(LogEvent.recordingStarted);
    return true;
  }

  bool _fail(LogEvent code, [List<num> numbers = const []]) {
    SafeLog.event(code, numbers);
    return false;
  }

  void _reply(String text) {
    if (_ended) return;
    switch (readReply(text)) {
      case Heard(:final finalText, :final provisional, :final finished):
        if (finalText.isNotEmpty || provisional.isNotEmpty || finished) onHeard(finalText, provisional);
        if (finished && !_finished.isCompleted) _finished.complete();
      case Refused(:final code):
        _broke(code);
    }
  }

  // The stream broke off before its end: the words shown stay.
  void _broke(int code) {
    if (_ended || _finished.isCompleted) return;
    SafeLog.event(LogEvent.recordingStreamFailed, [code]);
    unawaited(_shut());
  }

  /// Stops: the microphone off, then Soniox's last words, waited for up to
  /// [wait].
  ///
  /// A second stop is the first one.
  Future<void> stop() => _stopping ??= _stop();

  Future<void> _stop() async {
    if (_ended) return;
    await _micOff();
    final link = _link;
    if (link != null) {
      link.finish();
      await _finished.future.timeout(wait, onTimeout: () {});
    }
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

  Future<void> _shut() async {
    if (_ended) return;
    _ended = true;
    if (!_finished.isCompleted) _finished.complete();
    await _micOff();
    final replies = _replies;
    _replies = null;
    final link = _link;
    _link = null;
    unawaited(replies?.cancel());
    SafeLog.event(LogEvent.recordingEnded);
    onEnded();
    if (link != null) _closeQuietly(link);
  }
}
