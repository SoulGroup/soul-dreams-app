// Settings (main-path.md, Settings; Design System §6; C18-P; D110; D121;
// D122; D128), reached from the journal's gear, in SoulDreams Dev only: the
// back control top left; the quick toggle top centre (MP·45), showing what it
// switches to, a moon in the light theme and a sun in the dark, which
// switches the theme in half a second and sets Night/Day mode to Manual
// (D125 items 6 and 7); MP·25 in h2; then six rows, each its name and a
// value pill, every pill one size and every row one height (D125 item 4),
// the gap from a pill's right edge to its row's equal to the gap above and
// below it (D128 item 6), opening the phone's menu: Language (EM·9; English
// only, its name owed, D121 item 1), Word Animation (MP·26), Night images
// (MP·85), Night/Day mode (MP·44), Life Context (MP·83) and Life Context
// length (MP·84); then "Read disclosure & privacy" (MP·48) and "Delete
// journal" (EM·11) in the destructive style. No feedback (D121 item 4), no
// region, and no way to give or withdraw consent: each feature is the
// dreamer's own act (D128 item 2).
//
// Life Context On shows its page (ConsentPage: Back, Turn on); Off asks MP·93
// (what is kept goes). Before the dreamer has agreed, a tap on that row shows
// the popup (MP·101, MP·102) and changes nothing; the Disclosure & privacy
// page then ends with one button, MP·100, which agrees (D128 item 3). Night
// images asks nothing (D125 item 8). Delete journal asks once (C4-P·4), then
// everything goes and the app starts again (D110). Each confirmation is the
// phone's standard dialog, Cancel first (as a night's delete). The rows, the
// pills and the toggle are stand-ins (TO TRY, P13).
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/language.dart';
import '../core/night_day.dart';
import '../core/safe_log.dart';
import '../design/palette.dart';
import '../design/stand_ins.dart';
import '../design/tokens.g.dart';
import '../journal/journal.dart';
import '../journal/pages/parts.dart';
import '../journal/pages/sky_mark.dart';
import '../journal/sky.dart';
import '../onboarding/disclosure_page.dart';
import '../words/lines.g.dart';
import '../words/pending.g.dart';
import 'agreement_popup.dart';
import 'consent_page.dart';
import 'consents.dart';
import 'setting_line.dart';
import 'settings.dart';
import 'settings_controller.dart';

/// The language's name, owed by Product: a visible placeholder (R1; the
/// stop's question 4).
const owedLanguage = '[owed·language]';

/// Which row a key names.
enum SettingRow { language, wordAnimation, nightImages, nightDay, lifeContext, length }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.journal, required this.settings});

  final Journal journal;
  final SettingsController settings;

  static const toggleKey = Key('settings-toggle');
  static const disclosureKey = Key('settings-disclosure');
  static const agreeKey = Key('settings-agree');
  static const deleteKey = Key('settings-delete');

  /// A row, whole.
  static Key rowKey(SettingRow row) => ValueKey('setting-row-${row.name}');

  /// A row's value pill.
  static Key valueKey(SettingRow row) => ValueKey('setting-${row.name}');

  /// A choice in a row's menu.
  static Key choiceKey(SettingRow row, int index) => ValueKey('setting-${row.name}-$index');

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsController get _c => widget.settings;

  @override
  void initState() {
    super.initState();
    _c.addListener(_changed);
  }

  @override
  void dispose() {
    _c.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  // The theme the dreamer is heading for: Manual's own, since the theme on
  // screen lags a fade by half its length and a second tap would undo
  // nothing; Automatic's is the one shown.
  bool get _dark => switch (_c.settings.nightDay) {
    NightDayMode.night => true,
    NightDayMode.day => false,
    NightDayMode.automatic => Theme.of(context).brightness == Brightness.dark,
  };

  // The phone's standard dialog, Cancel (MP·61) first, [yes] destructive.
  Future<bool> _confirm(Line text, Line yes) async =>
      await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(text.text(appLanguage)),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(Lines.MP_61.text(appLanguage)),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(yes.text(appLanguage)),
            ),
          ],
        ),
      ) ==
      true;

  // The quick toggle: the other theme, Manual (Design System §6).
  void _toggle() => _c.change(_c.settings.copyWith(nightDay: _dark ? NightDayMode.day : NightDayMode.night));

  void _wordAnimation(int i) => _c.change(_c.settings.copyWith(wordAnimation: i == 0));

  // Night images asks nothing: it is a setting, with no consent (D125 item 8).
  void _nightImages(int i) => _c.change(_c.settings.copyWith(images: NightImages.values[i]));

  // Manual keeps the theme on screen (the stop's question 5).
  void _nightDay(int i) => _c.change(
    _c.settings.copyWith(nightDay: i == 0 ? NightDayMode.automatic : (_dark ? NightDayMode.night : NightDayMode.day)),
  );

  // Before the dreamer has agreed, the popup, nothing changed (D128 item 3);
  // On shows Life Context's page, Off asks MP·93 (what is kept goes).
  Future<void> _lifeContext(int i) async {
    if (!_c.agreed) return showAgreementPopup(context);
    final on = i == 0;
    if (on == _c.consents.given(Consent.lifeContext)) return;
    final yes = on ? await ConsentPage.ask(context) : await _confirm(Lines.MP_93, Lines.MP_94);
    if (yes) await _c.answer(Consent.lifeContext, on);
  }

  // The Disclosure & privacy page, the text only; before the dreamer has
  // agreed it ends with one button, MP·100, which agrees, as in onboarding,
  // and goes (D128 item 3).
  void _openDisclosure() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DisclosurePage(
        end: [
          ListenableBuilder(
            listenable: _c,
            builder: (context, _) => _c.agreed
                ? const SizedBox.shrink()
                : Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: PlainButton(
                        key: SettingsPage.agreeKey,
                        PendingLines.MP_100.text(appLanguage),
                        onPressed: _c.agree,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );

  void _length(int i) => _c.change(_c.settings.copyWith(length: LifeContextLength.values[i]));

  // Delete journal (D110): one confirmation; then everything goes, and the
  // journal's home returns to the start, closing this page.
  Future<void> _delete() async {
    if (!await _confirm(Lines.C4_P_4, Lines.MP_60)) return;
    try {
      await widget.journal.deleteAll();
    } on Object {
      SafeLog.event(LogEvent.journalDeleteFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final s = _c.settings;
    final c = _c.consents;
    Widget row(SettingRow key, Line line, int chosen, ValueChanged<int> onChoose) {
      final words = settingWords(line, appLanguage);
      return _Row(
        row: key,
        name: words?.name ?? '[${line.handle}]',
        choices: words?.choices ?? const [],
        chosen: chosen,
        onChoose: onChoose,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.gap, Spacing.pageSide, StandIns.journalEnd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: StandIns.hitMin,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: BackControl(onPressed: () => Navigator.of(context).pop()),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: _Toggle(dark: _dark, onPressed: _toggle),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: StandIns.gap),
              Semantics(
                header: true,
                child: Text(
                  Lines.MP_25.text(appLanguage),
                  textAlign: TextAlign.center,
                  style: TypeRoles.h2.style(p.text),
                ),
              ),
              const SizedBox(height: StandIns.gap),
              _Row(
                row: SettingRow.language,
                name: Lines.EM_9.text(appLanguage),
                choices: const [owedLanguage],
                chosen: 0,
                onChoose: (_) {},
              ),
              row(SettingRow.wordAnimation, Lines.MP_26, s.wordAnimation ? 0 : 1, _wordAnimation),
              row(SettingRow.nightImages, Lines.MP_85, s.images.index, _nightImages),
              row(SettingRow.nightDay, Lines.MP_44, s.nightDay == NightDayMode.automatic ? 0 : 1, _nightDay),
              row(SettingRow.lifeContext, Lines.MP_83, c.given(Consent.lifeContext) ? 0 : 1, _lifeContext),
              row(SettingRow.length, Lines.MP_84, s.length.index, _length),
              const SizedBox(height: StandIns.listAbove),
              _action(
                PlainButton(
                  key: SettingsPage.disclosureKey,
                  Lines.MP_48.text(appLanguage),
                  onPressed: _openDisclosure,
                ),
              ),
              const SizedBox(height: Spacing.journalRow),
              _action(_Destructive(Lines.EM_11.parts(appLanguage).first, onPressed: _delete)),
            ],
          ),
        ),
      ),
    );
  }
}

/// An action below the rows, centred; at large text it shrinks its words to
/// stay on one row, as the foot's pairs do (ButtonRow).
Widget _action(Widget button) => Center(
  child: FittedBox(fit: BoxFit.scaleDown, child: button),
);

/// A setting's row: a white rounded row, its name, then a value pill with
/// a small chevron, opening the phone's menu of its choices.
class _Row extends StatelessWidget {
  const _Row({
    required this.row,
    required this.name,
    required this.choices,
    required this.chosen,
    required this.onChoose,
  });

  final SettingRow row;
  final String name;
  final List<String> choices;
  final int chosen;
  final ValueChanged<int> onChoose;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final style = TypeRoles.button.style(p.text);
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.journalRow),
      child: DecoratedBox(
        key: SettingsPage.rowKey(row),
        decoration: surface(p),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: StandIns.settingRowHeight),
          child: Padding(
            padding: StandIns.settingPadding,
            child: Row(
              children: [
                Expanded(child: Text(name, style: style)),
                const SizedBox(width: StandIns.searchGap),
                if (choices.isNotEmpty) SizedBox(width: StandIns.settingPillWidth, child: _pill(p)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // The value pill opening the phone's menu: one size for every row, its
  // border the row's own grey (D125 item 4); at large text its words shrink
  // to fit, the pill's size staying.
  Widget _pill(Palette p) => CupertinoMenuAnchor(
    consumeOutsideTaps: true,
    menuChildren: [
      for (final (i, choice) in choices.indexed)
        CupertinoMenuItem(key: SettingsPage.choiceKey(row, i), onPressed: () => onChoose(i), child: Text(choice)),
    ],
    builder: (context, controller, _) => Semantics(
      button: true,
      label: name,
      value: choices[chosen],
      excludeSemantics: true,
      child: GestureDetector(
        key: SettingsPage.valueKey(row),
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: StandIns.hitMin),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: p.field,
              borderRadius: BorderRadius.circular(Spacing.radius),
              border: Border.all(color: p.surfaceBorder),
            ),
            child: Padding(
              padding: StandIns.settingValuePadding,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(choices[chosen], style: TypeRoles.button.style(p.fieldText)),
                    const SizedBox(width: StandIns.searchGap),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Chevron(colour: p.fieldText, size: StandIns.settingChevron),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// The quick toggle (MP·45): a 41 bordered circle in a 44 tap box, showing
/// what it switches to: a moon in the light theme, drawn in the dark theme's
/// page colour, and a sun in the dark (the sky mark's drawing; D125 item 7).
class _Toggle extends StatelessWidget {
  const _Toggle({required this.dark, required this.onPressed});

  final bool dark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      button: true,
      toggled: dark,
      label: Lines.MP_45.text(appLanguage),
      excludeSemantics: true,
      child: GestureDetector(
        key: SettingsPage.toggleKey,
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox.square(
          dimension: StandIns.hitMin,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox.square(
              dimension: StandIns.backSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [p.buttonTop, p.buttonBottom],
                  ),
                  border: Border.all(color: p.buttonBorder),
                ),
                child: Center(
                  child: SkyMark(dark ? Sky.sun : Sky.moon, size: StandIns.toggleMark, moon: DarkColours.page.colour),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Delete journal: a pill in color.destructive, white words (the Design
/// System §2), told apart by its place and its word as well (§3).
class _Destructive extends StatelessWidget {
  const _Destructive(this.text, {required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const role = LightColours.destructive;
    return Semantics(
      button: true,
      child: GestureDetector(
        key: SettingsPage.deleteKey,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [role.colour!, role.colourEnd!],
            ),
            borderRadius: BorderRadius.circular(Spacing.radius),
          ),
          child: Padding(
            padding: StandIns.buttonPadding,
            child: Text(text, style: TypeRoles.button.style(role.text!)),
          ),
        ),
      ),
    );
  }
}
