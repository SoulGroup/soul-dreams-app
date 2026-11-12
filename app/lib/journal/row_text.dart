// What the journal list shows of a night, in plain Dart (main-path.md,
// The Journal; C131-I items 1, 2; D58 Q7; P5).
// - The opening: the first dream as told, with TECH·1's framing trimmed
//   from its very start only, matched as a whole word or phrase and
//   ignoring case, the longest first. When unsure, nothing is trimmed.
// - The date: day/month/year, never a time.
// - The month divider: the phone's own month name for the language
//   (Flutter's localization data), the first letter capitalised; the month
//   alone in the current year, month and year in an earlier one.
import 'package:intl/intl.dart';

import '../words/lines.g.dart' show Lang;
import '../words/lists.g.dart';
import 'night.dart';

final _wordChar = RegExp(r'[\p{L}\p{N}]', unicode: true);

/// The first dream's opening, with its framing trimmed.
String opening(Night night) {
  final dream = night.dreams.first;
  final framings = [...(night.lang == Lang.en ? ListWords.tech1En : ListWords.tech1Sv)]
    ..sort((a, b) => b.length.compareTo(a.length));
  for (final f in framings) {
    if (dream.length < f.length) continue;
    if (dream.substring(0, f.length).toLowerCase() != f.toLowerCase()) continue;
    if (dream.length > f.length && _wordChar.hasMatch(dream[f.length])) continue;
    final rest = dream.substring(f.length).trimLeft();
    return rest.isEmpty ? dream : rest;
  }
  return dream;
}

String _two(int n) => n.toString().padLeft(2, '0');

/// The night's date: day/month/year (main-path.md, Every Screen; MP·27).
String dayDigits(NightDate d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

/// The month divider's words, in [lang].
String monthDivider(int year, int month, int currentYear, Lang lang) {
  final at = DateTime(year, month);
  final words = year == currentYear
      ? DateFormat.LLLL(lang.name).format(at)
      : DateFormat('LLLL y', lang.name).format(at);
  return words.isEmpty ? words : words[0].toUpperCase() + words.substring(1);
}

/// One entry of the journal list: a month divider or a night.
sealed class ListItem {
  const ListItem();
}

final class MonthItem extends ListItem {
  const MonthItem(this.year, this.month);

  final int year;
  final int month;
}

final class NightItem extends ListItem {
  const NightItem(this.night);

  final Night night;
}

/// The list: newest first, a divider above each run of nights in one
/// month, and no divider over a month with no nights; no count anywhere.
List<ListItem> listItems(List<Night> newestFirst) {
  final out = <ListItem>[];
  (int, int)? month;
  for (final n in newestFirst) {
    final m = (n.date.year, n.date.month);
    if (m != month) out.add(MonthItem(m.$1, m.$2));
    month = m;
    out.add(NightItem(n));
  }
  return out;
}
