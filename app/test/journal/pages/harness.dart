// The pages' widget tests: an in-memory journal on a fake Stockholm clock,
// inside the app (theme, localizations, cover), with every night from
// fixtures/invented-nights.json (R2).
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_rules.dart';
import 'package:souldreams/words/lines.g.dart' show Lang;

import '../../fixtures.dart';

import '../memory_journal_files.dart';
import '../zones.dart';

final class Harness {
  Harness._(this.files, this.store, this.journal);

  final MemoryJournalFiles files;
  final JournalStore store;
  final Journal journal;

  /// The journal's clock, in UTC; tests move it.
  static DateTime clock = stockholm(2026, 6, 10, 12);

  static Future<Harness> make() async {
    clock = stockholm(2026, 6, 10, 12);
    JournalStore.newQueueForTests();
    final files = MemoryJournalFiles();
    final store = await JournalStore.open(files);
    final journal = Journal(store, zone: const FakeStockholm(), now: () => clock, random: Random(5));
    return Harness._(files, store, journal);
  }

  Future<List<Night>> nights() => journal.newestFirst();

  /// The app at noon, so in the light theme, opening on [home].
  Future<void> pump(WidgetTester tester, Widget home) async {
    await tester.pumpWidget(SoulDreamsApp(home: home, clock: () => DateTime(2026, 6, 10, 12)));
    await tester.pumpAndSettle();
  }
}

/// Saves the invented night [key] as begun at [at] (Stockholm).
Future<Night> keep(Harness h, String key, DateTime at) async {
  final n = invented(key);
  final lang = Lang.values.byName(n.lang);
  final target = NewNight(at);
  await h.journal.addDream(target, n.dreams.first, lang);
  final made = (await h.nights()).firstWhere((x) => x.firstRecorded == at);
  for (final d in n.dreams.skip(1)) {
    await h.journal.addDream(IntoNight(made.id), d, lang);
  }
  return (await h.journal.night(made.id))!;
}

/// A first page with one control that opens [page].
class Opener extends StatelessWidget {
  const Opener(this.page, {super.key});

  static const openKey = Key('open');

  final Future<Widget> Function() page;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: IconButton(
            key: openKey,
            icon: const Icon(Icons.add),
            onPressed: () async {
              final next = await page();
              if (context.mounted) await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => next));
            },
          ),
        ),
      );
}
