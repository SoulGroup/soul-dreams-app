// The phone check (D49 c; the plan's Task 13): SoulDreams Dev runs it
// once when built with --dart-define=JOURNAL_SELF_CHECK=true. It saves a
// probe night, reads back the folder's backup flag and both protection
// classes, reads the probe, deletes it, and checks no file names it. Then
// the same for a probe recording's audio (D92): a second of silence
// appended and forced to the disk, its protection, read back, discarded.
// It logs journalCheckPassed, or journalCheckFailed with the step's
// number. The probe holds one marker word, never a dream; the owner looks
// for it in the downloaded container, and must not find it.
import 'dart:typed_data';

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
  String? audioId;
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
    step = 6;
    final silence = Uint8List(32000);
    final audio = audioId = newNightId();
    await store.appendAudio(audio, silence, sync: true);
    final a = await protection.protection(JournalStore.audioOf(audio, 0));
    if (!a.excluded || !a.folderComplete || !a.fileComplete) return _failed(step);
    step = 7;
    final back = await store.readAudio(audio, 0, 0, silence.length);
    if (back.length != silence.length || back.any((b) => b != 0)) return _failed(step);
    await store.discardAudio(audio);
    audioId = null;
    if ((await files.list()).any((n) => n.contains(audio))) return _failed(step);
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
    if (store != null && audioId != null) {
      try {
        await store.discardAudio(audioId);
      } on Object {
        // As above: the next open sweeps audio no night names.
      }
    }
  }
}

bool _failed(int step) {
  SafeLog.event(LogEvent.journalCheckFailed, [step]);
  return false;
}
