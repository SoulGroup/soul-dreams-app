// SoulDreams Dev's first page (D49 O1; D56): it opens the journal's
// folder on the phone, then shows onboarding until the dreamer has agreed
// (D103), held in the light theme, and then the journal list; the first
// time, the journal list's first empty state (main-path.md, Onboarding, 5).
// Nothing leaves the phone before the consent: the recording and its
// retries start only with the journal. When the consent goes, withdrawn or
// deleted with the journal, it returns to onboarding's start, closing every
// page above it (D103 item 4). Until the folder is
// open the page is blank; if it cannot be opened it stays blank and logs
// a code, never a night's words (R3). A phone check it is handed (D65)
// finishes first, so its probe never shows as a row. The recording it is
// handed keeps its audio in the journal's folder (D92), and retries the
// recordings waiting there while the app is open: when the journal opens,
// when the app comes back, and when the connection returns; leaving the
// app cuts a retry short (D92 item 3, D94).
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/always_light.dart';
import '../../core/safe_log.dart';
import '../../onboarding/onboarding.dart';
import '../../recording/recording.dart';
import '../journal.dart';
import '../journal_audio.dart';
import '../journal_files.dart';
import '../journal_store.dart';
import '../night_action.dart';
import 'journal_page.dart';

class JournalHome extends StatefulWidget {
  const JournalHome({super.key, required this.files, this.after, this.recording, this.nightAction});

  final JournalFiles files;

  /// A phone check (D49 c) to wait for before the folder is opened and the
  /// list loaded. Whether it passed or threw, the list follows.
  final Future<Object?>? after;

  /// How to record by voice, or null (D69).
  final Recording? recording;

  /// The item each night's menu gains, or null (D107 item 1).
  final NightAction? nightAction;

  @override
  State<JournalHome> createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
  JournalStore? _store;
  Journal? _journal;
  Recording? _recording;
  // Null until the consent is read; then whether it is given.
  bool? _agreed;
  // The journal's first showing, straight from "I agree".
  bool _first = false;
  bool _agreeing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _open();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _journal?.consentGone.removeListener(_restart);
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
    final JournalStore store;
    try {
      store = await JournalStore.open(widget.files);
    } on Object {
      SafeLog.event(LogEvent.journalOpenFailed);
      return;
    }
    final journal = Journal(store)..consentGone.addListener(_restart);
    bool agreed;
    try {
      agreed = await journal.consented();
    } on Object {
      // Asked again: nothing is shown as agreed that is not kept.
      SafeLog.event(LogEvent.consentReadFailed);
      agreed = false;
    }
    if (!mounted) return;
    _store = store;
    _journal = journal;
    agreed ? _enter() : _onboard();
  }

  // Onboarding, always in the light theme (main-path.md, Every Screen).
  void _onboard() {
    _agreeing = false;
    AlwaysLight.hold(context, true);
    setState(() => _agreed = false);
  }

  // The journal, once the dreamer has agreed: only now may anything leave
  // the phone, so the recording and its retries begin here (D103).
  void _enter({bool first = false}) {
    AlwaysLight.hold(context, false);
    final audio = JournalAudio(_store!);
    setState(() {
      _agreed = true;
      _first = first;
      _recording = widget.recording?.keeping(audio, waiting: audio);
    });
    // D98: the counts at launch and after each retry, for DevTools.
    unawaited(audio.logCounts());
    _recording?.retries?.afterRetry = audio.logCounts;
    _recording?.retries?.kick();
  }

  // "I agree": the consent kept, then the journal. A consent that cannot be
  // kept logs a code; the journal opens, and the next opening asks again.
  Future<void> _agree() async {
    if (_agreeing) return;
    _agreeing = true;
    try {
      await _journal!.keepConsent();
    } on Object {
      SafeLog.event(LogEvent.consentKeepFailed);
    }
    // Not reset here: a tap that lands before onboarding has left the tree
    // must not open the journal twice. `_onboard` resets it.
    if (mounted) _enter(first: true);
  }

  // The consent gone (D103 item 4): every page above closes, the retries
  // stop, and onboarding starts again.
  void _restart() {
    if (!mounted) return;
    _recording?.retries?.dispose();
    _recording = null;
    Navigator.of(context).popUntil((route) => route.isFirst);
    _onboard();
  }

  @override
  Widget build(BuildContext context) {
    return switch (_agreed) {
      null => const Scaffold(),
      false => Onboarding(onAgreed: _agree),
      true => JournalPage(journal: _journal!, recording: _recording, firstTime: _first, nightAction: widget.nightAction),
    };
  }
}
