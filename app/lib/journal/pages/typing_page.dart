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
// D71): the words heard are added at the end, never at the caret; while
// it runs, a level line and a timer show and a screen reader is told
// MP·33; a stop, Save or Back waits for the last words; leaving the app
// ends it at once. A failure to start or a break shows nothing new.
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
import '../../words/pending.g.dart';
import '../journal.dart';
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

class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
  late final _text = TextEditingController(text: widget.edit?.text);
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

  // Recording: its state, the provisional words now at the field's end,
  // the recent levels, and the time it has run.
  _Mic _mic = _Mic.idle;
  RecordingSession? _session;
  String _shown = '';
  int _shownAt = 0;
  // True until a final piece has been heard in this recording (D74): the
  // first piece after typed words gets one space; the rest go as sent.
  bool _gotFinal = false;
  final _levels = <double>[];
  int _seconds = 0;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    _ticker?.cancel();
    final session = _session;
    _session = null;
    if (session != null) unawaited(session.cancel());
    _text.dispose();
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
    // Leaving with nothing typed keeps nothing and stays, so an emptied
    // edit never deletes a dream behind the dreamer's back.
    if (leaving && isEmptyText(_text.text)) return;
    _saving = true;
    if (_failed && mounted) setState(() => _failed = false);
    try {
      final e = widget.edit;
      if (e == null) {
        await widget.journal.addDream(widget.target, _text.text, appLanguage);
      } else {
        await widget.journal.editDream(e.id, e.index, _text.text);
      }
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
    setState(() => _mic = _Mic.starting);
    final session = RecordingSession(recording, onHeard: _heard, onLevel: _level, onEnded: _ended);
    _session = session;
    final started = await session.start();
    // A start that comes late from an earlier session, ended meanwhile,
    // changes nothing (D75).
    if (!mounted || !identical(session, _session)) return;
    if (!started) {
      // Nothing new is shown (D71); the session logged its code.
      _session = null;
      setState(() => _mic = _Mic.idle);
      return;
    }
    setState(() {
      _mic = _Mic.recording;
      _levels.clear();
      _seconds = 0;
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
    SemanticsService.sendAnnouncement(View.of(context), Lines.MP_33.text(appLanguage), TextDirection.ltr);
  }

  // Heard words go at the end of the text, never at the caret (D71 Q6);
  // a caret at the end stays at the end.
  void _heard(String finalText, String provisional) {
    if (!mounted) return;
    final before = _text.value;
    final next = withHeard(before.text, _shown, finalText, provisional, first: !_gotFinal, at: _shownAt);
    _shown = next.shown;
    _shownAt = next.at;
    if (finalText.isNotEmpty) _gotFinal = true;
    final atEnd = !before.selection.isValid ||
        (before.selection.isCollapsed && before.selection.baseOffset == before.text.length);
    final selection = atEnd
        ? TextSelection.collapsed(offset: next.text.length)
        : TextSelection(
            baseOffset: before.selection.baseOffset.clamp(0, next.text.length),
            extentOffset: before.selection.extentOffset.clamp(0, next.text.length),
          );
    // The keyboard's own composing text stays while it lies in the part of
    // the text that did not change (D75).
    final composing = before.composing.isValid && next.text.startsWith(before.text.substring(0, before.composing.end))
        ? before.composing
        : TextRange.empty;
    _text.value = TextEditingValue(text: next.text, selection: selection, composing: composing);
  }

  void _level(double level) {
    if (!mounted) return;
    setState(() {
      _levels.add(level);
      if (_levels.length > StandIns.levelFrames) _levels.removeAt(0);
    });
  }

  // The recording ended, by a stop or by itself: the words shown stay.
  void _ended() {
    _ticker?.cancel();
    _ticker = null;
    _session = null;
    _shown = '';
    _shownAt = 0;
    _gotFinal = false;
    if (mounted) setState(() => _mic = _Mic.idle);
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
        MediaQuery.textScalerOf(context).scale(dreamer.size) * dreamer.height + StandIns.fieldPadding.vertical;
    final edge = OutlineInputBorder(
      borderRadius: BorderRadius.circular(oneLine / 2),
      borderSide: BorderSide(color: p.fieldBorder),
    );
    final live = _mic == _Mic.recording || _mic == _Mic.stopping;
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
                padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackControl(onPressed: _save),
                    ),
                    Expanded(
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
                                      if (_failed)
                                        Padding(
                                          key: _failure,
                                          padding: const EdgeInsets.only(top: StandIns.gap),
                                          child: Semantics(
                                            liveRegion: true,
                                            child: AppLine(
                                              PendingLines.MP_62.text(appLanguage),
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
                              child: TextField(
                                key: TypingPage.fieldKey,
                                controller: _text,
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
                                          tooltip: Lines.MP_11.text(appLanguage),
                                          isSelected: live,
                                          onPressed: _toggleMic,
                                          icon: Icon(Icons.mic_none, color: p.placeholder),
                                          selectedIcon: Icon(Icons.stop_rounded, color: p.fieldText),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: StandIns.gap),
                    // At large text the two pills shrink their words to stay on
                    // one row, as the record button does (Task 15a).
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: KeyedSubtree(
                              key: TypingPage.saveKey,
                              child: PlainButton(Lines.MP_13.text(appLanguage), icon: Icons.hotel, onPressed: _save),
                            ),
                          ),
                        ),
                        const SizedBox(width: StandIns.gap),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: KeyedSubtree(
                              key: TypingPage.startKey,
                              // Nothing to start yet: the readings come later (D71 Q3).
                              child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),
                            ),
                          ),
                        ),
                      ],
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
