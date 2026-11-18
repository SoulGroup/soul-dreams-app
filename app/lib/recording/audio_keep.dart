// Where a recording's audio is kept on the phone until its words come
// (D92 item 1): the journal's folder, backup-excluded, under complete
// protection, reached through lib/journal/. Nothing here names a file or
// a folder; the session only hands its audio on.
import 'dart:typed_data';

abstract interface class AudioKeep {
  /// A new recording's id: 128 bits from the system's secure source, as
  /// 32 hex digits. It names the audio on the phone only, never sent (R4).
  String newId();

  /// Adds [bytes] to recording [id]'s audio, in order; [last] at its end,
  /// when the audio is forced to the disk.
  Future<void> add(String id, Uint8List bytes, {bool last = false});

  /// Deletes recording [id]'s audio: its words are all in (D92 item 1), or
  /// none will come.
  Future<void> discard(String id);
}
