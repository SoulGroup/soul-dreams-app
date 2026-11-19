// The founder's export (C142-I item 3; C153-I item 3; D107; D108): one
// night at a time, from its "⋯" menu, labelled MP·65 (a pending line). The
// file's name and bytes go to the phone's own share, through our channel
// in AppDelegate.swift, which is compiled into SoulDreams Dev and the
// founder's app only: it writes the file, hands it to AirDrop alone (every
// other target receives nothing), and deletes it when the share closes.
// Nothing goes through a server or any service (R8). A failure shows
// nothing and logs a code (D108; R3).
import 'package:flutter/services.dart';

import '../core/language.dart';
import '../core/safe_log.dart';
import '../journal/night.dart';
import '../journal/night_action.dart';
import '../words/lines.g.dart' show Lines;
import 'export_text.dart';

final class FounderExport {
  const FounderExport({this.channel = const MethodChannel(channelName)});

  static const channelName = 'souldreams/founder_export';

  final MethodChannel channel;

  /// The night's menu item.
  NightAction get action => NightAction(label: Lines.MP_65.text(appLanguage), run: share);

  /// Shares [night]'s file; answers when the share has closed.
  Future<void> share(Night night) async {
    try {
      await channel.invokeMethod<void>('share', {'name': exportFileName(night), 'bytes': exportBytes(night)});
    } on Object {
      SafeLog.event(LogEvent.exportFailed);
    }
  }
}
