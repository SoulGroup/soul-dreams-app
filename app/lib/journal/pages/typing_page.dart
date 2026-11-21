// The typing screen (main-path.md, Recording, as P2 to P4, P12, D58 and
// D70 shape it): Back (MP·14) top left, which saves just like Save; the
// instruction (MP·10 on first use, MP·32 after) centred in the button
// type; the field, a pill with MP·12 as its placeholder and, in a build
// that records, the microphone inside it (MP·11), growing with its words
// up to StandIns.fieldCap of the space; then Save (MP·13, with its
// sleeping-person icon, a stand-in) on the left and Start Interpretation
// (EM·1) on the right, which does nothing yet (D71 Q3). Never tonight's
// earlier dreams; the same screen, filled with a dream, edits it (D58
// Q4). The keyboard follows the phone's own settings (P12; D57 Q10).
// D62: Save, Back, the system's back and the iPhone's edge swipe all go
// through one _save; when it fails the words and the screen stay, one
// code is logged, and each of them tries again. D63: the field takes no
// focus by itself, a failed save shows MP·62, and leaving the app
// (hidden or paused, not inactive) saves what is typed. Recording (D69,
// D71): the words heard go in at the caret where it started (D87); an
// edit attempt only stops it (D90); while it runs, a level line and a
// timer show and a screen reader is told
// MP·33; a stop, Save or Back waits for the last words; leaving the app
// ends it at once. A refused microphone shows MP·63 where MP·62 shows,
// until the next tap of the microphone (D93 Q4); while it records, the
// microphone's spoken name is MP·64. Offline recording (D92 to D94): with
// no connection at the tap, MP·15 shows in place of MP·33's announcement;
// a key, a stream or Soniox's budget failing shows MP·54; either way the
// recording goes on, and what was not turned into words waits on the phone.
// The Save puts each waiting recording after the dream's words, and keeps
// a night with nothing typed but a recording waiting (D93 Q2, Q7).
// Without a keep, a failure to start or a break shows nothing new.
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../core/app_line.dart';
import '../../core/language.dart';
import '../../core/safe_log.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../recording/heard_text.dart';
import '../../recording/recording.dart';
import '../../words/lines.g.dart';
import '../journal.dart';
import '../night.dart';
import '../night_rules.dart';
import 'parts.dart';

/// A dream to edit: its night, its place, its text.
typedef DreamEdit = ({String id, int index, String text});

class TypingPage extends StatefulWidget {
  const TypingPage({super.key, required this.journal, required this.target, this.edit, this.recording});

  static const fieldKey = Key('typing-field');
  static const saveKey = Key('typing-save');
  static const startKey = Key('typing-start');
  static const micKey = Key('typing-mic');
  static const levelKey = Key('typing-level');
  static const noticeKey = Key('typing-notice');

  final Journal journal;

  /// Where a new dream is saved, fixed when the screen opened (P10).
  final Target target;

  /// The dream being edited, or null for a new one.
  final DreamEdit? edit;

  /// How to record by voice, or null for no microphone.
  final Recording? recording;

  @override
  State<TypingPage> createState() => _TypingPageState();
}

enum _Mic { idle, starting, recording, stopping }

// A Save that could not be written anywhere: a failed Save (D96 Q3, D97). Carries no text.
final class _NotLanded implements Exception {
  const _NotLanded();
}

class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
  late final _text = TextEditingController(text: widget.edit?.text);
  // The field's own scrolling: while recording it follows the insertion
  // point (D79 a, D87 3) until the dreamer drags upward; a drag of theirs
  // that ends with the insertion point in view follows again. The app's own
  // jumps change nothing (D80).
  final _scroll = ScrollController();
  bool _following = false;
  bool _dreamerScrolls = false;
  bool? _firstUse;
  bool _saving = false;
  bool _failed = false;
  // MP·62 sits in the instruction's scroll area, so it can never squeeze
  // the field away; a failure scrolls it into view (9c).
  final _failure = GlobalKey();

  // Flutter's own edge swipe is off while this screen's PopScope refuses
  // a pop, so the screen answers the swipe itself (D62): from the left
  // edge, a drag of this far, or a flick this fast, acts as Back.
  static const _edgeWidth = 20.0;
  static const _swipeFar = 60.0;
  static const _swipeFast = 300.0;
  double _swiped = 0;

  // Recording: its state; the text before and after the insertion point
  // and the words heard so far, final then provisional (D87); the recent
  // levels, and the time it has run.
  _Mic _mic = _Mic.idle;
  RecordingSession? _session;
  String _before = '';
  String _after = '';
  String _finals = '';
  String _provisional = '';
  // Where the dictated words end, and the value the page last set.
  int _insertEnd = 0;
  TextEditingValue? _shownValue;
  // Whether an edit attempt has stopped this recording, and the caret a
  // tap put down, noted until the last words have landed; later attempts in
  // that wait are ignored (D87 2, D90).
  bool _attempted = false;
  ({int caret, int shownLength})? _caret;
  final _levels = <double>[];
  int _seconds = 0;
  // What the dreamer is told about the recording, until the next tap of the
  // microphone or the screen closes (D93 Q4).
  Trouble? _trouble;
  // The recordings this screen left waiting for their words, in order; the
  // Save keeps them (D93 Q2).
  final _waiting = <Waiting>[];
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _text.addListener(_moved);
    // No retry while this screen is open, so no dream moves under it (D94).
    widget.recording?.retries?.hold();
    // A key fetched in advance, so a recording starts at once (D88).
    widget.recording?.warm();
    // A failed read shows the short line and marks nothing; a failed mark
    // still shows MP·10. Each logs a code (D71 Q18).
    widget.journal.firstUseSeen().then(
      (seen) async {
        if (!seen) {
          try {
            await widget.journal.markFirstUseSeen();
          } on Object {
            SafeLog.event(LogEvent.firstUseReadFailed);
          }
        }
        if (mounted) setState(() => _firstUse = !seen);
      },
      onError: (Object _) {
        SafeLog.event(LogEvent.firstUseReadFailed);
        if (mounted) setState(() => _firstUse = false);
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.recording?.retries?.release();
    _ticker?.cancel();
    final session = _session;
    _session = null;
    if (session != null) unawaited(session.cancel());
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // Leaving the app saves what is typed, as Save does (D63). `inactive`
  // only covers the screen (D50 2) and saves nothing.
  // It saves once, as the app goes away; the way back (paused, hidden,
  // inactive, resumed) passes through hidden again and does not save.
  bool _away = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final wasAway = _away;
    _away = state == AppLifecycleState.hidden || state == AppLifecycleState.paused;
    if (_away && !wasAway) _save(leaving: true);
  }

  Future<void> _save({bool leaving = false}) async {
    if (_saving) {
      // Leaving the app while Save waits for the last words: the wait ends
      // at once, and the save already under way goes on (D75).
      if (leaving) unawaited(_session?.cancel());
      return;
    }
    // A recording ends first: at once when leaving the app, else with its
    // last words.
    final session = _session;
    if (session != null) {
      _saving = true;
      await (leaving ? session.cancel() : session.stop());
      _saving = false;
    }
    // Leaving with nothing typed and nothing waiting keeps nothing and
    // stays, so an emptied edit never deletes a dream behind the dreamer's
    // back (D93 Q7: a recording waiting is something).
    if (leaving && isEmptyText(_text.text) && _waiting.isEmpty) return;
    _saving = true;
    if (_failed && mounted) setState(() => _failed = false);
    try {
      final e = widget.edit;
      final waiting = List.of(_waiting);
      final text = _text.text;
      final something = !isEmptyText(text) || waiting.isNotEmpty;
      var landed = false;
      if (e == null) {
        landed = await widget.journal.addDream(widget.target, text, appLanguage, waiting: waiting);
      } else {
        // Leaving never removes a dream: an emptied field keeps the old
        // words, and only a Save removes it (D96 Q2).
        final words = leaving && isEmptyText(text) ? e.text : text;
        landed = await widget.journal.editDream(e.id, e.index, words, waiting: waiting, was: e.text);
      }
      // The night is gone: what was said goes into a new night, so nothing
      // is lost and the screen can be left (D97). Nothing to keep is not a
      // failure; a Save that cannot be written anywhere is.
      if (!landed && something) {
        landed = await widget.journal.addDream(
          await widget.journal.targetNow(),
          text,
          appLanguage,
          waiting: waiting,
        );
        if (!landed) throw const _NotLanded();
      }
      _waiting.clear();
    } on Object {
      SafeLog.event(LogEvent.journalSaveFailed);
      _saving = false;
      if (mounted) setState(() => _failed = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final line = _failure.currentContext;
        if (mounted && line != null) Scrollable.ensureVisible(line);
      });
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  void _toggleMic() {
    // Save or Back is waiting for the recording: no second one (D74).
    if (_saving) return;
    switch (_mic) {
      case _Mic.idle:
        if (_trouble != null) setState(() => _trouble = null);
        _startRecording();
      case _Mic.recording:
        setState(() => _mic = _Mic.stopping);
        _session?.stop();
      case _Mic.starting || _Mic.stopping:
        break;
    }
  }

  Future<void> _startRecording() async {
    final recording = widget.recording;
    if (recording == null) return;
    // The insertion point: the caret, or a selection's end (the selected
    // words stay), or the end if the dreamer has not placed it (D87 1).
    final value = _text.value;
    final at = value.selection.isValid ? value.selection.end : value.text.length;
    _before = value.text.substring(0, at);
    _after = value.text.substring(at);
    _finals = '';
    _provisional = '';
    _attempted = false;
    _caret = null;
    setState(() => _mic = _Mic.starting);
    _compose();
    final session = RecordingSession(
      recording,
      onHeard: _heard,
      onLevel: _level,
      onStopping: _stopClock,
      onEnded: _ended,
      onTrouble: _troubled,
      onTroubleOver: _troubleOver,
    );
    _session = session;
    final started = await session.start();
    // A start that comes late from an earlier session, ended meanwhile,
    // changes nothing (D75).
    if (!mounted || !identical(session, _session)) return;
    if (!started) {
      // Nothing new is shown (D71); the session logged its code. The field
      // is the dreamer's again at once (Task 16f-1).
      _session = null;
      setState(() => _mic = _Mic.idle);
      _settle();
      return;
    }
    setState(() {
      _mic = _Mic.recording;
      _levels.clear();
      _seconds = 0;
    });
    // A recording starts with the insertion point in view (D80 2, D87 3).
    _following = true;
    _reveal();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
    // With no connection, MP·15 is what a screen reader hears (D93 Q4).
    if (_trouble != Trouble.offline) {
      SemanticsService.sendAnnouncement(View.of(context), Lines.MP_33.text(appLanguage), TextDirection.ltr);
    }
  }

  // Heard words go in at the insertion point (D87 1).
  void _heard(String finalText, String provisional) {
    if (!mounted) return;
    _finals += finalText;
    _provisional = provisional;
    _compose();
    // The jump checks following when it runs (D81, D86).
    _reveal();
  }

  // The field's text: the words between the text before and after them,
  // the caret at their end.
  void _compose() {
    final r = dictatedInto(_before, _finals + _provisional, _after);
    _insertEnd = r.end;
    final value = TextEditingValue(text: r.text, selection: TextSelection.collapsed(offset: r.end));
    // Noted first, so the listener sees the page's own change as nothing new.
    _shownValue = value;
    _text.value = value;
  }

  // After the next layout, the field shows the insertion point, if it still
  // follows then and no drag of the dreamer's is under way (D81, D87 3).
  void _reveal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_following || _dreamerScrolls || !_scroll.hasClients) return;
      _editable()?.bringIntoView(TextPosition(offset: _insertEnd));
    });
  }

  EditableTextState? _editable() {
    EditableTextState? found;
    void visit(Element e) {
      if (found != null) return;
      if (e is StatefulElement && e.state is EditableTextState) {
        found = e.state as EditableTextState;
      } else {
        e.visitChildElements(visit);
      }
    }

    if (mounted) context.visitChildElements(visit);
    return found;
  }

  bool _insertionInView() {
    final editable = _editable()?.renderEditable;
    if (editable == null) return false;
    final caret = editable.getLocalRectForCaret(TextPosition(offset: _insertEnd));
    return caret.top >= -1 && caret.bottom <= editable.size.height + 1;
  }

  bool get _live => _mic == _Mic.recording || _mic == _Mic.stopping;

  // An edit attempt while recording (D87 2, D90): a key press, a paste or a
  // cut (the text is put back as shown, never applied), or a tap or a handle
  // that moves the caret or the selection (its caret noted). The recording
  // stops as Stop does. A
  // shown value exists only while a recording runs; the page's own changes,
  // and the keyboard's own composing range, are nothing new.
  void _moved() {
    final shown = _shownValue;
    if (shown == null) return;
    final now = _text.value;
    if (now.text == shown.text && now.selection == shown.selection) return;
    _attempt(shown, now);
    if (now.text != shown.text) _text.value = shown;
  }

  void _attempt(TextEditingValue old, TextEditingValue edited) {
    if (_attempted) return;
    _attempted = true;
    if (old.text == edited.text && edited.selection.isValid) {
      _caret = (caret: edited.selection.extentOffset, shownLength: old.text.length);
    }
    if (_mic == _Mic.recording) setState(() => _mic = _Mic.stopping);
    _session?.stop();
  }

  // The dreamer's own drags (D80): upward pauses; a scroll of theirs that
  // ends with the insertion point in view follows again (D87 3). Scrolls
  // with no drag are the app's.
  bool _scrolled(ScrollNotification n) {
    if (n is ScrollStartNotification) _dreamerScrolls = n.dragDetails != null;
    if (n is ScrollUpdateNotification && n.dragDetails != null && (n.scrollDelta ?? 0) < 0) _following = false;
    if (n is ScrollEndNotification && _dreamerScrolls) {
      _dreamerScrolls = false;
      if (_insertionInView()) _following = true;
    }
    return false;
  }

  void _level(double level) {
    if (!mounted) return;
    setState(() {
      _levels.add(level);
      if (_levels.length > StandIns.levelFrames) _levels.removeAt(0);
    });
  }

  void _troubled(Trouble trouble) {
    if (mounted) setState(() => _trouble = trouble);
  }

  // The recording can no longer wait on the phone: what it told no longer
  // holds (D96 Q1).
  void _troubleOver() {
    if (mounted && _trouble != null) setState(() => _trouble = null);
  }

  // What the dreamer is told, by the trouble.
  String _troubleText(Trouble trouble) => switch (trouble) {
    Trouble.refused => Lines.MP_63.text(appLanguage),
    Trouble.offline => Lines.MP_15.text(appLanguage),
    Trouble.broke => Lines.MP_54.text(appLanguage),
  };

  // A stop began, the dreamer's or a call's: the clock stops at once, while
  // the last words may still come (D83).
  void _stopClock() {
    _ticker?.cancel();
    _ticker = null;
  }

  // The recording ended, by a stop or by itself: the words shown stay, and
  // what it left waiting is noted for the Save.
  void _ended() {
    _ticker?.cancel();
    _ticker = null;
    final left = _session?.left;
    if (left != null) _waiting.add(Waiting(left.audio, left.from));
    _session = null;
    if (!mounted) return;
    // The next key, fetched in advance (D88).
    widget.recording?.warm();
    setState(() => _mic = _Mic.idle);
    _settle();
  }

  // The recording is over or never began: the field is the dreamer's again
  // (D87). The caret goes where the dreamer tapped it, moved with the words,
  // else after the dictated words, whatever was tried in the wait (D90).
  void _settle() {
    _shownValue = null;
    final tapped = _caret;
    _caret = null;
    _text.selection = TextSelection.collapsed(
      offset: tapped == null
          ? _insertEnd
          : caretSettled(
              tapped.caret,
              insertAt: _before.length,
              shownLength: tapped.shownLength,
              settledLength: _text.text.length,
            ),
    );
  }

  String _elapsed() {
    // Minutes and seconds: digits only, no words.
    return [(_seconds ~/ 60).toString(), (_seconds % 60).toString().padLeft(2, '0')].join(':');
  }

  // The field grows to StandIns.fieldCap of the space between Back and the
  // buttons, but never so far that the level row and the gaps no longer fit
  // beside it (D75): the newest words stay above Save.
  double _fieldCap(BuildContext context, double space, bool live) {
    var level = 0.0;
    if (live) {
      final painter = TextPainter(
        text: TextSpan(text: _elapsed(), style: TypeRoles.button.style(Palette.of(context).text)),
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      level = StandIns.gap + max(StandIns.levelHeight, painter.height);
      painter.dispose();
    }
    return min(space * StandIns.fieldCap, max(0.0, space - level - StandIns.gap));
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final first = _firstUse;
    final dreamer = TypeRoles.voiceDreamer;
    // A pill: the corners half the height of one line of the field.
    final oneLine =
        MediaQuery.textScalerOf(context).scale(dreamer.size) * dreamer.height! + StandIns.fieldPadding.vertical;
    final edge = OutlineInputBorder(
      borderRadius: BorderRadius.circular(oneLine / 2),
      borderSide: BorderSide(color: p.fieldBorder),
    );
    final live = _live;
    final trouble = _trouble;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _save();
      },
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.pageSide),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackControl(onPressed: _save),
                    ),
                    Expanded(
                      // What stands below the back control starts where its look ends (D102).
                      child: BelowTapBox(
                        child: LayoutBuilder(
                          builder: (context, box) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        if (first != null)
                                          AppLine(
                                            (first ? Lines.MP_10 : Lines.MP_32).text(appLanguage),
                                            style: TypeRoles.button.style(p.text),
                                          ),
                                        if (trouble != null)
                                          Padding(
                                            key: TypingPage.noticeKey,
                                            padding: const EdgeInsets.only(top: StandIns.gap),
                                            child: Semantics(
                                              liveRegion: true,
                                              child: AppLine(
                                                _troubleText(trouble),
                                                style: TypeRoles.button.style(p.text),
                                              ),
                                            ),
                                          ),
                                        if (_failed)
                                          Padding(
                                            key: _failure,
                                            padding: const EdgeInsets.only(top: StandIns.gap),
                                            child: Semantics(
                                              liveRegion: true,
                                              child: AppLine(
                                                Lines.MP_62.text(appLanguage),
                                                style: TypeRoles.button.style(p.text),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (live)
                                ExcludeSemantics(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: StandIns.gap),
                                    child: Row(
                                      key: TypingPage.levelKey,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: StandIns.levelHeight,
                                            child: CustomPaint(painter: _LevelLine(List.of(_levels), p.text)),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(_elapsed(), style: TypeRoles.button.style(p.text)),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: StandIns.gap),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: _fieldCap(context, box.maxHeight, live)),
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: _scrolled,
                                  child: TextField(
                                    key: TypingPage.fieldKey,
                                    controller: _text,
                                    scrollController: _scroll,
                                    minLines: 1,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    textCapitalization: TextCapitalization.sentences,
                                    style: TypeRoles.voiceDreamer.style(p.fieldText),
                                    cursorColor: p.fieldText,
                                    decoration: InputDecoration(
                                      hintText: Lines.MP_12.text(appLanguage),
                                      hintStyle: TypeRoles.button.style(p.placeholder),
                                      filled: true,
                                      fillColor: p.field,
                                      contentPadding: StandIns.fieldPadding,
                                      border: edge,
                                      enabledBorder: edge,
                                      focusedBorder: edge,
                                      suffixIcon: widget.recording == null
                                          ? null
                                          : IconButton(
                                              key: TypingPage.micKey,
                                              // The stop control's own name while it
                                              // records (D93; MP·64 replaces MP·11).
                                              tooltip: live
                                                  ? Lines.MP_64.text(appLanguage)
                                                  : Lines.MP_11.text(appLanguage),
                                              isSelected: live,
                                              onPressed: _toggleMic,
                                              icon: Icon(Icons.mic_none, color: p.placeholder),
                                              selectedIcon: Icon(Icons.stop_rounded, color: p.fieldText),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: StandIns.gap),
                    ButtonRow(
                      left: KeyedSubtree(
                        key: TypingPage.saveKey,
                        child: PlainButton(Lines.MP_13.text(appLanguage), icon: Icons.hotel, onPressed: _save),
                      ),
                      right: KeyedSubtree(
                        key: TypingPage.startKey,
                        // Nothing to start yet: the readings come later (D71 Q3).
                        child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: StandIns.gap),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: _edgeWidth,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (_) => _swiped = 0,
              onHorizontalDragUpdate: (d) => _swiped += d.delta.dx,
              onHorizontalDragEnd: (d) {
                if (_swiped >= _swipeFar || (d.primaryVelocity ?? 0) >= _swipeFast) _save();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The level line: one bar a frame, newest on the right, as loud as the
/// frame was (a stand-in, D71 Q7).
class _LevelLine extends CustomPainter {
  _LevelLine(this.levels, this.colour);

  final List<double> levels;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colour
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final step = size.width / StandIns.levelFrames;
    final middle = size.height / 2;
    for (var i = 0; i < levels.length; i++) {
      final x = size.width - (levels.length - i - 0.5) * step;
      final half = (levels[i] * size.height / 2).clamp(1.0, middle);
      canvas.drawLine(Offset(x, middle - half), Offset(x, middle + half), paint);
    }
  }

  @override
  bool shouldRepaint(_LevelLine old) => true;
}
