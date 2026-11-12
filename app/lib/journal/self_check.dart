// The phone check (D49 c; the plan's Task 13): SoulDreams Dev runs it
// once when built with --dart-define=JOURNAL_SELF_CHECK=true. It saves a
// probe night, reads back the folder's backup flag and both protection
// classes, reads the probe, deletes it, and checks no file names it. It
// logs journalCheckPassed, or journalCheckFailed with the step's number.
// The probe holds one marker word, never a dream; the owner looks for
// it in the downloaded container, and must not find it.
import '../core/safe_log.dart';
import '../words/lines.g.dart' show Lang;
import 'journal_files.dart';
import 'journal_store.dart';
import 'night.dart';
import 'night_rules.dart';

const journalProbe = 'journal-probe-d49';

Future<bool> journalSelfCheck(JournalFiles files, JournalProtection protection,
    {DateTime? now}) async {
  var step = 1;
  String? probeId;
  JournalStore? store;
  try {
    store = await JournalStore.open(files);
    step = 2;
    final local = (now ?? DateTime.now()).toLocal();
    final probe = Night(
      id: probeId = newNightId(),
      firstRecorded: local.toUtc(),
      date: (year: local.year, month: local.month, day: local.day),
      closes: closesAfter(local.toUtc(), const PhoneZone()),
      lang: Lang.en,
      dreams: const [journalProbe],
    );
    await store.save(probe);
    step = 3;
    final p = await protection.protection(JournalStore.fileOf(probe.id));
    if (!p.excluded || !p.folderComplete || !p.fileComplete) return _failed(step);
    step = 4;
    if (!(await store.nights()).contains(probe)) return _failed(step);
    step = 5;
    await store.delete(probe.id);
    probeId = null;
    if ((await files.list()).any((n) => n.contains(probe.id))) return _failed(step);
    SafeLog.event(LogEvent.journalCheckPassed);
    return true;
  } on Object {
    return _failed(step);
  } finally {
    if (store != null && probeId != null) {
      try {
        await store.delete(probeId);
      } on Object {
        // The failure is already logged; the owner's container check finds the probe.
      }
    }
  }
}

bool _failed(int step) {
  SafeLog.event(LogEvent.journalCheckFailed, [step]);
  return false;
}
