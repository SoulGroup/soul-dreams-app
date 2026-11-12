// The journal's folder on the phone (D49 b), through the Swift channel
// in ios/Runner/AppDelegate.swift. A failure there arrives as a
// PlatformException carrying a code only (R3).
import 'package:flutter/services.dart';

import 'journal_files.dart';

const journalChannel = 'souldreams/journal_files';

final class ChannelJournalFiles implements JournalFiles, JournalProtection {
  const ChannelJournalFiles([this._channel = const MethodChannel(journalChannel)]);

  final MethodChannel _channel;

  String _checked(String name) {
    if (!validName(name)) throw ArgumentError('name');
    return name;
  }

  @override
  Future<void> open() => _channel.invokeMethod<void>('open');

  @override
  Future<List<String>> list() async =>
      await _channel.invokeListMethod<String>('list') ?? const <String>[];

  @override
  Future<Uint8List?> read(String name) => _channel.invokeMethod<Uint8List>('read', _checked(name));

  @override
  Future<void> write(String name, Uint8List bytes) =>
      _channel.invokeMethod<void>('write', {'name': _checked(name), 'bytes': bytes});

  @override
  Future<void> rename(String from, String to) =>
      _channel.invokeMethod<void>('rename', {'from': _checked(from), 'to': _checked(to)});

  @override
  Future<void> delete(String name) => _channel.invokeMethod<void>('delete', _checked(name));

  @override
  Future<void> deleteAll() => _channel.invokeMethod<void>('deleteAll');

  @override
  Future<Protection> protection(String name) async {
    final m = await _channel.invokeMapMethod<String, bool>('protection', _checked(name)) ??
        const <String, bool>{};
    return (
      excluded: m['excluded'] ?? false,
      folderComplete: m['folderComplete'] ?? false,
      fileComplete: m['fileComplete'] ?? false,
    );
  }
}
