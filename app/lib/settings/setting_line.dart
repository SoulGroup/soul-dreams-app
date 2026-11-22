// A setting's line as the register writes it: its name, then its choices in
// brackets, split at " / " ("Word Animation (On / Off)"; MP·26, MP·44,
// MP·83, MP·84, MP·85). The generator splits every line at " / ", so the
// name and the choices are read back here, in Dart (D122, the stop's
// question 13). A line not in that exact form gives null, and its row shows
// the place's handle (R1).
import '../words/lines.g.dart';

/// A setting's name and its choices, in the register's order.
typedef SettingWords = ({String name, List<String> choices});

/// [line]'s name and choices in [lang], or null when it is not exactly
/// "Name (A / B ...)".
SettingWords? settingWords(Line line, Lang lang) {
  final parts = line.parts(lang);
  if (parts.length < 2) return null;
  final first = parts.first;
  final last = parts.last;
  final open = first.indexOf(' (');
  if (open <= 0 || !last.endsWith(')')) return null;
  final name = first.substring(0, open);
  final choices = [first.substring(open + 2), ...parts.sublist(1, parts.length - 1), last.substring(0, last.length - 1)];
  bool bare(String w) => w.trim() == w && w.isNotEmpty && !w.contains('(') && !w.contains(')');
  if (!bare(name) || !choices.every(bare)) return null;
  return (name: name, choices: choices);
}
