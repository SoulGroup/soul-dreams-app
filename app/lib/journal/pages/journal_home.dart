// SoulDreams Dev's first page (D49 O1; D56): it opens the journal's
// folder on the phone, then shows the journal list. Until the folder is
// open the page is blank; if it cannot be opened it stays blank and logs
// a code, never a night's words (R3). A phone check it is handed (D65)
// finishes first, so its probe never shows as a row. The recording it is
// handed keeps its audio in the journal's folder (D92), and retries the
// recordings waiting there while the app is open: when the journal opens,
// when the app comes back, and when the connection returns; leaving the
// app cuts a retry short (D92 item 3, D94).
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/safe_log.dart';
import '../../recording/recording.dart';
import '../journal.dart';
import '../journal_audio.dart';
import '../journal_files.dart';
import '../journal_store.dart';
import 'journal_page.dart';

class JournalHome extends StatefulWidget {
  const JournalHome({super.key, required this.files, this.after, this.recording});

  final JournalFiles files;

  /// A phone check (D49 c) to wait for before the folder is opened and the
  /// list loaded. Whether it passed or threw, the list follows.
  final Future<Object?>? after;

  /// How to record by voice, or null (D69).
  final Recording? recording;

  @override
  State<JournalHome> createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
  Journal? _journal;
  Recording? _recording;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recording?.retries?.dispose();
    super.dispose();
  }

  // No background task: a retry runs only while the app is open (D92
  // item 3). `inactive` changes nothing.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final retries = _recording?.retries;
    if (retries == null) return;
    if (state == AppLifecycleState.resumed) retries.back();
    if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) retries.away();
  }

  Future<void> _open() async {
    try {
      await widget.after;
    } on Object {
      // The check logs its own result; the list does not depend on it.
    }
    JournalStore.open(widget.files).then((store) {
      if (!mounted) return;
      final audio = JournalAudio(store);
      setState(() {
        _journal = Journal(store);
        _recording = widget.recording?.keeping(audio, waiting: audio);
      });
      // D98: the counts at launch and after each retry, for DevTools.
      unawaited(audio.logCounts());
      _recording?.retries?.afterRetry = audio.logCounts;
      _recording?.retries?.kick();
    }, onError: (Object _) => SafeLog.event(LogEvent.journalOpenFailed));
  }

  @override
  Widget build(BuildContext context) {
    final journal = _journal;
    return journal == null ? const Scaffold() : JournalPage(journal: journal, recording: _recording);
  }
}
