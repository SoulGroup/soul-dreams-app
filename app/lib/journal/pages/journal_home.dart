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
// follows them: Word Animation, Night/Day mode, Night images (a setting, no
// consent behind it, D125 item 8), and recording by voice with its retries
// only once the dreamer has agreed (D128): until then every night stays, the
// microphone and Start Interpretation show a popup when tapped, and nothing is
// sent. It holds Life Context too (`LifeContext`, D131 item 4): what is past
// its window is deleted when the journal opens, when the app comes back, and
// at each local midnight while it is open.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/always_light.dart';
import '../../core/app_line.dart' show wordAnimation;
import '../../core/night_day.dart';
import '../../core/safe_log.dart';
import '../../life_context/life_context.dart';
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
  LifeContext? _lifeContext;
  Recording? _recording;
  // Null until the consents are read; then whether onboarding has been
  // answered (agreeing or not; `SettingsController.agreed` is the readings'
  // consent, a different thing, D128).
  bool? _agreed;
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
    _lifeContext?.dispose();
    _settings?.dispose();
    _recording?.retries?.dispose();
    super.dispose();
  }

  // No background task: a retry runs only while the app is open (D92
  // item 3). `inactive` changes nothing.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _lifeContext?.resumed();
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
  void _enter(Consents consents, Settings settings) {
    AlwaysLight.hold(context, false);
    final audio = _audio = JournalAudio(_store!);
    final controller = SettingsController(_journal!, consents: consents, settings: settings)..addListener(_follow);
    _lifeContext?.dispose();
    final lifeContext = LifeContext(_journal!, controller)..start();
    setState(() {
      _agreed = true;
      _settings = controller;
      _lifeContext = lifeContext;
    });
    // D98: the counts at launch and after each retry, for DevTools.
    unawaited(audio.logCounts());
    _follow(opening: true);
  }

  // The settings followed (D122): Word Animation, Night/Day mode, and
  // recording by voice with its retries only once the dreamer has agreed
  // (D128); there is no withdrawing, so what starts is not stopped again.
  void _follow({bool opening = false}) {
    final controller = _settings;
    if (controller == null || !mounted) return;
    wordAnimation = controller.settings.wordAnimation;
    // A mode found as the journal opens shows at once; one the dreamer
    // changes fades (D57 Q15).
    NightDayChoice.set(context, controller.settings.nightDay, instant: opening);
    if (controller.agreed && _recording == null) {
      final audio = _audio!;
      _recording = widget.recording?.keeping(audio, waiting: audio);
      _recording?.retries?.afterRetry = audio.logCounts;
      _recording?.retries?.kick();
    }
    setState(() {});
  }

  // "I agree" or "I don't agree": the two consents kept, then the journal (D122;
  // D127 item 1).
  // Consents that cannot be kept log a code; the journal opens, and the
  // next opening asks again.
  Future<void> _agree(Map<Consent, bool> given) async {
    if (_agreeing) return;
    _agreeing = true;
    final journal = _journal!;
    final consents = Consents.answered(given, journal.now());
    try {
      await journal.keepConsents(consents);
    } on Object {
      SafeLog.event(LogEvent.consentKeepFailed);
    }
    // Not reset here: a tap that lands before onboarding has left the tree
    // must not open the journal twice. `_onboard` resets it.
    if (mounted) _enter(consents, const Settings());
  }

  // The journal deleted, the consents and settings with it (D110): every
  // page above closes, the retries stop, the settings return to their
  // defaults, and onboarding starts again.
  void _restart() {
    if (!mounted) return;
    _recording?.retries?.dispose();
    _recording = null;
    _lifeContext?.dispose();
    _lifeContext = null;
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
        nightAction: widget.nightAction,
        read: widget.read,
        settings: _settings,
        images: _settings?.settings.images != NightImages.off,
        agreed: _settings?.agreed ?? true,
      ),
    };
  }
}
