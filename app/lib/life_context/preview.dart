// SoulDreams Dev's invented kept sentences (D131 item 1), for the owner's
// by-eye review of Life Context's page. Built with the file
// tool/preview_kept.py writes (--dart-define-from-file), SoulDreams Dev
// seeds its journal once: the invented nights that have waking passages
// (fixtures/invented-nights.json, R2), dated from today to ten weeks back so
// each window shows a different list, and their passages kept whatever Life
// Context's state, since Off only pauses it (D134). A flag file marks it done;
// deleting the journal takes it, and the next agreement seeds again. The seed
// logs its two counts (`previewSeeded`), so a build that did not seed shows
// no such line. Only JournalHome reaches it, so no tester or founder build
// does.
import 'dart:convert';
import 'dart:math';

import '../core/safe_log.dart';
import '../journal/journal.dart';
import '../journal/journal_store.dart';
import '../journal/night.dart';
import '../journal/night_rules.dart';
import '../words/lines.g.dart' show Lang;

/// How many days back each invented night is dated, in turn.
const previewDaysBack = [0, 5, 12, 25, 70];

/// The flag file that marks the seed done.
const previewFlag = 'preview-kept-seeded';

/// Seeds [store] from [define] once. Nothing without [define]; a [define]
/// that does not read throws a [FormatException] and seeds nothing.
Future<void> seedPreview(
  JournalStore store,
  String define, {
  DateTime Function()? now,
  Zone zone = const PhoneZone(),
  Random? random,
}) async {
  if (define.isEmpty || await store.flagged(previewFlag)) return;
  final nights = jsonDecode(define);
  if (nights is! List) throw const FormatException('preview');
  final read = [
    for (final n in nights)
      if (n case {'lang': String lang, 'dreams': List<Object?> dreams, 'waking': List<Object?> waking})
        (Lang.values.byName(lang), dreams.cast<String>(), waking.cast<String>())
      else
        throw const FormatException('preview'),
  ];
  final today = (now ?? () => DateTime.now().toUtc())();
  var kept = 0;
  for (final (i, (lang, dreams, waking)) in read.indexed) {
    final at = today.subtract(Duration(days: previewDaysBack[i % previewDaysBack.length]));
    final night = Night(
      id: newNightId(random),
      firstRecorded: at,
      date: dateOf(at, zone),
      closes: closesAfter(at, zone),
      lang: lang,
      dreams: dreams,
    );
    await store.save(night);
    final journal = Journal(store, zone: zone, now: () => at, random: random);
    for (final w in waking) {
      kept += await journal.keep(night.id, w);
    }
  }
  await store.flag(previewFlag);
  SafeLog.event(LogEvent.previewSeeded, [read.length, kept]);
}
