// Inside a night, not yet read (main-path.md, The Journal, designs 2 and
// 3; P1, P6, P7; D58 Q1, Q4, Q8): the header (the date, or the name and
// the date); the "⋯" menu top right, spoken as MP·39, holding only
// "delete this night" (EM·11's second part), plain; one confirmation, the
// phone's standard dialog, Cancel first and Delete destructive (MP·61,
// MP·60, pending lines); the dreams under "Dreams" (MP·38), each opening
// the typing screen to edit it; "Add dreams" (MP·29). A recording that
// waits to be turned into text shows nothing in its place and cannot be
// tapped; while it is being turned into text, AI·6 shows in its place,
// heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
// When its words come, the page shows them. Not built: naming, Start
// Interpretation, and the space below the dreams.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/app_line.dart';
import '../../core/language.dart';
import '../../core/safe_log.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../../words/pending.g.dart';
import '../../recording/recording.dart';
import '../journal.dart';
import '../night.dart';
import '../night_rules.dart';
import '../row_text.dart';
import 'parts.dart';
import 'typing_page.dart';

class NightPage extends StatefulWidget {
  const NightPage({super.key, required this.journal, required this.id, this.recording});

  static const menuKey = Key('night-menu');
  static const deleteKey = Key('night-delete');
  static const addKey = Key('night-add');
  static const transcribingKey = Key('night-transcribing');

  final Journal journal;
  final String id;

  /// How to record by voice in the typing screen, or null (D69).
  final Recording? recording;

  @override
  State<NightPage> createState() => _NightPageState();
}

class _NightPageState extends State<NightPage> {
  Night? _night;

  // A delete is in flight: the menu, Add dreams and the dreams wait (D64).
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
    widget.recording?.retries?.addListener(_retried);
  }

  @override
  void dispose() {
    widget.recording?.retries?.removeListener(_retried);
    super.dispose();
  }

  String? get _transcribing => widget.recording?.retries?.transcribing;

  // A retry began, ended, or brought words (D94): shown at once.
  void _retried() {
    if (!mounted) return;
    setState(() {});
    if (!_busy) _load();
  }

  // A night gone (every dream emptied) leaves its page (P10).
  Future<void> _load() async {
    final Night? n;
    try {
      n = await widget.journal.night(widget.id);
    } on Object {
      SafeLog.event(LogEvent.journalReadFailed);
      return;
    }
    if (!mounted) return;
    if (n == null) {
      _leave();
      return;
    }
    setState(() => _night = n);
  }

  // The page leaves by its own route: with a question or a typing screen
  // open above it, popping would close that instead (D96).
  void _leave() {
    final route = ModalRoute.of(context);
    if (route == null || route.isCurrent) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).removeRoute(route);
    }
  }

  Future<void> _type(DreamEdit? edit) async {
    if (_busy) return;
    final page = TypingPage(
      journal: widget.journal,
      target: IntoNight(widget.id),
      edit: edit,
      recording: widget.recording,
    );
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
    await _load();
  }

  Future<void> _delete() async {
    if (_busy) return;
    final yes = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(Lines.C4_P_4.text(appLanguage)),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(PendingLines.MP_61.text(appLanguage)),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(PendingLines.MP_60.text(appLanguage)),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.journal.delete(widget.id);
    } on Object {
      SafeLog.event(LogEvent.journalDeleteFailed);
      if (mounted) setState(() => _busy = false);
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final n = _night;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
              child: Row(
              children: [
                BackControl(onPressed: () => Navigator.of(context).pop()),
                const Spacer(),
                PopupMenuButton<int>(
                  key: NightPage.menuKey,
                  enabled: !_busy,
                  tooltip: Lines.MP_39.text(appLanguage),
                  icon: Icon(Icons.more_horiz, color: p.text),
                  onSelected: (_) => _delete(),
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      key: NightPage.deleteKey,
                      value: 0,
                      child: Text(Lines.EM_11.parts(appLanguage)[1], style: TypeRoles.button.style(p.text)),
                    ),
                  ],
                ),
              ],
            ),
            ),
            if (n != null)
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
                  children: [
                    Padding(
                      padding: Spacing.nightHeader,
                      child: Semantics(
                        header: true,
                        child: n.name == null
                            ? Text(dayDigits(n.date), style: TypeRoles.h2.style(p.text))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(n.name!, style: TypeRoles.h2.style(p.text)),
                                  Text(dayDigits(n.date), style: TypeRoles.button.style(p.text)),
                                ],
                              ),
                      ),
                    ),
                    Align(alignment: Alignment.centerLeft, child: SectionLabel(Lines.MP_38.text(appLanguage))),
                    const SizedBox(height: StandIns.gap),
                    for (final (i, d) in n.entries.indexed)
                      if (d case Told(:final text)) ...[
                        DreamBubble(text, onTap: () => _type((id: n.id, index: i, text: text))),
                        const SizedBox(height: StandIns.bubbleGap),
                      ] else if (d case Waiting(:final audio) when _transcribing == audio) ...[
                        Semantics(
                          key: NightPage.transcribingKey,
                          liveRegion: true,
                          child: AppLine(Lines.AI_6.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
                        ),
                        const SizedBox(height: StandIns.bubbleGap),
                      ],
                    const SizedBox(height: StandIns.gap),
                    Center(
                      child: KeyedSubtree(
                        key: NightPage.addKey,
                        child: PlainButton(Lines.MP_29.text(appLanguage), onPressed: () => _type(null)),
                      ),
                    ),
                    const SizedBox(height: StandIns.gap),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
