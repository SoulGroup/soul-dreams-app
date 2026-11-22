// SoulDreams Dev's first page (D49 O1; D56): it opens the journal's
// folder on the phone, then shows onboarding until the dreamer has agreed
// (D103), held in the light theme, and then the journal list; the first
// time, the journal list's first empty state (main-path.md, Onboarding, 5).
// Nothing leaves the phone before the consent: the recording and its
// retries start only with the journal. When the journal is deleted, the
// consents with it, it returns to onboarding's start, closing every page
// above it (D110). Until the folder is
// open the page is blank; if it cannot be opened it stays blank and logs
// a code, never a night's words (R3). A phone check it is handed (D65)
// finishes first, so its probe never shows as a row. The recording it is
// handed keeps its audio in the journal's folder (D92), and retries the
// recordings waiting there while the app is open: when the journal opens,
// when the app comes back, and when the connection returns; leaving the
// app cuts a retry short (D92 item 3, D94). Once the journal opens, it
// holds the settings and the consents (`SettingsController`, D122) and
// follows them: Word Animation, Night/Day mode, Night images, and recording
// by voice with its retries only while consent (a) is given; withdrawn,
// they pause and every night stays (D121 item 5).
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/always_light.dart';
import '../../core/app_line.dart' show wordAnimation;
import '../../core/night_day.dart';
import '../../core/safe_log.dart';
import '../../onboarding/onboarding.dart';
import '../../recording/recording.dart';
import '../../settings/consents.dart';
import '../../settings/settings.dart';
import '../../settings/settings_controller.dart';
import '../journal.dart';
import '../journal_audio.dart';
import '../journal_files.dart';
import '../journal_store.dart';
import '../night_action.dart';
import '../night_look.dart';
import 'journal_page.dart';

class JournalHome extends StatefulWidget {
  const JournalHome({
    super.key,
    required this.files,
    this.after,
    this.recording,
    this.nightAction,
    this.read = noneRead,
  });

  final JournalFiles files;

  /// A phone check (D49 c) to wait for before the folder is opened and the
  /// list loaded. Whether it passed or threw, the list follows.
  final Future<Object?>? after;

  /// How to record by voice, or null (D69).
  final Recording? recording;

  /// The item each night's menu gains, or null (D107 item 1).
  final NightAction? nightAction;

  /// Whether a night has been read (D110): none is yet.
  final ReadCheck read;

  @override
  State<JournalHome> createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
  JournalStore? _store;
  Journal? _journal;
  JournalAudio? _audio;
  SettingsController? _settings;
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
    _settings?.dispose();
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
    Consents? consents;
    try {
      consents = await journal.consents();
    } on Object {
      // Asked again: nothing is shown as agreed that is not kept.
      SafeLog.event(LogEvent.consentReadFailed);
    }
    Settings? settings;
    if (consents != null) {
      try {
        settings = await journal.settings();
      } on Object {
        // The defaults stand (D122).
        SafeLog.event(LogEvent.settingsReadFailed);
      }
    }
    if (!mounted) return;
    _store = store;
    _journal = journal;
    consents == null ? _onboard() : _enter(consents, settings ?? const Settings());
  }

  // Onboarding, always in the light theme (main-path.md, Every Screen).
  void _onboard() {
    _agreeing = false;
    AlwaysLight.hold(context, true);
    setState(() => _agreed = false);
  }

  // The journal, once the dreamer has answered the consents, with the
  // settings kept (D122). Only now may anything leave the phone (D103).
  void _enter(Consents consents, Settings settings, {bool first = false}) {
    AlwaysLight.hold(context, false);
    final audio = _audio = JournalAudio(_store!);
    final controller = SettingsController(_journal!, consents: consents, settings: settings)..addListener(_follow);
    setState(() {
      _agreed = true;
      _first = first;
      _settings = controller;
    });
    // D98: the counts at launch and after each retry, for DevTools.
    unawaited(audio.logCounts());
    _follow();
  }

  // The settings followed (D122): Word Animation, Night/Day mode, and
  // recording by voice with its retries only while consent (a) is given;
  // withdrawn, a retry running is cut and none starts (D121 item 5).
  void _follow() {
    final controller = _settings;
    if (controller == null || !mounted) return;
    wordAnimation = controller.settings.wordAnimation;
    NightDayChoice.set(context, controller.settings.nightDay);
    final readings = controller.consents.given(Consent.readings);
    if (readings && _recording == null) {
      final audio = _audio!;
      _recording = widget.recording?.keeping(audio, waiting: audio);
      _recording?.retries?.afterRetry = audio.logCounts;
      _recording?.retries?.kick();
    } else if (!readings && _recording != null) {
      _recording?.retries?.dispose();
      _recording = null;
    }
    setState(() {});
  }

  // "I consent": the consents kept, then the journal. Until onboarding asks
  // the three (D119 item 1), it gives (a) and leaves (b) and (c) not given
  // (D122). Consents that cannot be kept log a code; the journal opens, and
  // the next opening asks again.
  Future<void> _agree() async {
    if (_agreeing) return;
    _agreeing = true;
    final journal = _journal!;
    final consents = Consents.answered({Consent.readings: true}, journal.now());
    try {
      await journal.keepConsents(consents);
    } on Object {
      SafeLog.event(LogEvent.consentKeepFailed);
    }
    // Not reset here: a tap that lands before onboarding has left the tree
    // must not open the journal twice. `_onboard` resets it.
    if (mounted) _enter(consents, const Settings(), first: true);
  }

  // The journal deleted, the consents and settings with it (D110): every
  // page above closes, the retries stop, the settings return to their
  // defaults, and onboarding starts again.
  void _restart() {
    if (!mounted) return;
    _recording?.retries?.dispose();
    _recording = null;
    _settings?.dispose();
    _settings = null;
    wordAnimation = true;
    NightDayChoice.set(context, NightDayMode.automatic);
    Navigator.of(context).popUntil((route) => route.isFirst);
    _onboard();
  }

  @override
  Widget build(BuildContext context) {
    return switch (_agreed) {
      null => const Scaffold(),
      false => Onboarding(onAgreed: _agree),
      true => JournalPage(
        journal: _journal!,
        recording: _recording,
        firstTime: _first,
        nightAction: widget.nightAction,
        read: widget.read,
        settings: _settings,
        images: _settings?.nightImages != NightImages.off,
      ),
    };
  }
}
