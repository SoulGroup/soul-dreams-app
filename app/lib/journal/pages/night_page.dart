// Inside a night, not yet read (main-path.md, The Journal, designs 2 and
// 3; P1, P6, P7; D58 Q1, Q4, Q8): the header (the date, or the name and
// the date); the "⋯" menu top right, spoken as MP·39, holding only
// "delete this night" (EM·11's second part), plain; one confirmation, the
// phone's standard dialog, Cancel first and Delete destructive (MP·61,
// MP·60, pending lines); the dreams under "Dreams" (MP·38), each opening
// the typing screen to edit it; "Add dreams" (MP·29). Not built: naming,
// Start Interpretation, and the space below the dreams.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/language.dart';
import '../../core/safe_log.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../../words/pending.g.dart';
import '../journal.dart';
import '../night.dart';
import '../night_rules.dart';
import '../row_text.dart';
import 'parts.dart';
import 'typing_page.dart';

class NightPage extends StatefulWidget {
  const NightPage({super.key, required this.journal, required this.id});

  static const menuKey = Key('night-menu');
  static const deleteKey = Key('night-delete');
  static const addKey = Key('night-add');

  final Journal journal;
  final String id;

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
      Navigator.of(context).pop();
      return;
    }
    setState(() => _night = n);
  }

  Future<void> _type(DreamEdit? edit) async {
    if (_busy) return;
    final page = TypingPage(journal: widget.journal, target: IntoNight(widget.id), edit: edit);
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
            Row(
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
                    for (final (i, d) in n.dreams.indexed) ...[
                      DreamBubble(d, onTap: () => _type((id: n.id, index: i, text: d))),
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
