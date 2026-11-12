// The journal list, the app's home (main-path.md, The Journal, design 1;
// C131-I items 1, 2; S5): one row per night, newest first, never a time;
// a month divider over each month with nights; the record button bottom
// centre; C4-P·5 when there is no night. No Settings entry and no search
// (P8). Nothing on a row grades it: no badge, count or status.
import 'package:flutter/material.dart';

import '../../core/app_line.dart';
import '../../core/language.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../journal.dart';
import '../night.dart';
import '../row_text.dart';
import 'night_page.dart';
import 'parts.dart';
import 'typing_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key, required this.journal});

  final Journal journal;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
  List<Night>? _nights;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // On returning, the year may have turned: the dividers are built again.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  Future<void> _load() async {
    final nights = await widget.journal.newestFirst();
    if (mounted) setState(() => _nights = nights);
  }

  Future<void> _push(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
    await _load();
  }

  // The screen's target is fixed now, when it opens (P10; D58 Q2).
  Future<void> _record() async {
    final target = await widget.journal.targetNow();
    if (mounted) await _push(TypingPage(journal: widget.journal, target: target));
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final nights = _nights;
    final year = widget.journal.zone.wall(widget.journal.now()).year;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          if (nights != null && nights.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
                child: AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
              ),
            ),
          if (nights != null && nights.isNotEmpty)
            ListView(
              padding: const EdgeInsets.fromLTRB(StandIns.pageSide, 0, StandIns.pageSide,
                  StandIns.journalEnd + StandIns.recordHeight + StandIns.recordBelow),
              children: [
                for (final item in listItems(nights))
                  switch (item) {
                    MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
                    NightItem(:final night) =>
                      _Row(night, onTap: () => _push(NightPage(journal: widget.journal, id: night.id))),
                  },
              ],
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: StandIns.recordBelow,
            child: Center(child: RecordButton(onPressed: _record)),
          ),
        ]),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: StandIns.dividerAbove, bottom: StandIns.dividerBelow),
        child: Semantics(
          header: true,
          child: Text(text, style: TypeRoles.h4.style(Palette.of(context).text)),
        ),
      );
}

/// A night's row: an unnamed night's date (h3), or a named night's name
/// (h5) with its date under it in the button style; then the opening,
/// always three lines (C10-P; D58 Q7).
class _Row extends StatelessWidget {
  const _Row(this.night, {required this.onTap});

  final Night night;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final summary = StandIns.summary.style(p.summary);
    final name = night.name;
    final lines = MediaQuery.textScalerOf(context).scale(summary.fontSize!) * summary.height! * 3;
    return Padding(
      padding: const EdgeInsets.only(bottom: StandIns.rowGap),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: surface(p),
          padding: StandIns.rowPadding,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (name == null)
              Text(dayDigits(night.date), style: TypeRoles.h3.style(p.text))
            else ...[
              Text(name, style: TypeRoles.h5.style(p.text)),
              Text(dayDigits(night.date), style: TypeRoles.button.style(p.text)),
            ],
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: lines),
              child: Text(opening(night), maxLines: 3, overflow: TextOverflow.ellipsis, style: summary),
            ),
          ]),
        ),
      ),
    );
  }
}
