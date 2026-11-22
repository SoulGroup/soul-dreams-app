// "What you've told Soul Dreams" (MP·86; C159-I item 1; D110, head's message
// 24 item 2; D131; Design System §2, §3, §5, lifecontext.sentence), opened
// from Settings, in SoulDreams Dev only: the back control top left and the
// "⋯" menu top right (MP·88); the title in h2; then, when anything is kept,
// two lists under their labels (MP·87): Kept longer, empty until its rule
// exists (D131 item 5), and Recent with the window as set; each sentence in
// quotation marks in its box, its date beneath in small grey, edit (MP·89)
// at its left and delete in terracotta at its right; Delete all (MP·91) at
// the foot. When nothing is kept, MP·92 alone.
//
// - Tapping a sentence opens its night. A night shows only its dreams for
//   now, and nothing kept is ever from a dream, so nothing is marked there
//   yet: the mark (in Bold, as search's, D131 item 3) comes with the part
//   of a night that shows the sentence (Questions, Reflection).
// - Edit turns the sentence's box into a field holding its words; Done on
//   the keyboard, or leaving the field, keeps the edit, which changes only
//   the kept copy (D131 item 2). Emptied, it is a deletion, and asks C4-P·4;
//   Cancel keeps the sentence as it was.
// - Select sentences: each box, and its mark at its left, toggles its
//   selection; the foot shows Delete selected ({n}) (MP·90), which does
//   nothing at 0; the top left is a drawn tick (MP·103's name) instead of
//   the back control, and it ends selecting (D133).
// - While Life Context is Off the page shows MP·104 alone (D133 item 3).
// - Every deletion asks C4-P·4 once, the phone's standard dialog, Cancel
//   (MP·61) first and Delete (MP·60) destructive (C4-P·4's flag).
// The boxes, labels, icons and spacing are stand-ins (TO TRY, P13).
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_line.dart';
import '../core/language.dart';
import '../design/palette.dart';
import '../design/stand_ins.dart';
import '../design/tokens.g.dart';
import '../journal/night_rules.dart' show isEmptyText;
import '../journal/pages/parts.dart';
import '../journal/row_text.dart';
import '../words/lines.g.dart';
import '../words/pending.g.dart';
import 'kept.dart';
import 'life_context.dart';

/// A kept sentence as the page shows it: in quotation marks.
String quoted(String text) => '“$text”';

class LifeContextPage extends StatefulWidget {
  const LifeContextPage({super.key, required this.lifeContext, this.openNight});

  final LifeContext lifeContext;

  /// Opens night [id], or null.
  final Future<void> Function(String id)? openNight;

  static const menuKey = Key('kept-menu');
  static const selectKey = Key('kept-select');
  static const deleteLongerKey = Key('kept-delete-longer');
  static const deleteRecentKey = Key('kept-delete-recent');
  static const deleteAllKey = Key('kept-delete-all');
  static const deleteSelectedKey = Key('kept-delete-selected');
  static const emptyKey = Key('kept-empty');
  static const offKey = Key('kept-off');
  static const fieldKey = Key('kept-field');

  /// A kept sentence's box, its words, edit and delete.
  static Key sentenceKey(String id) => ValueKey('kept-$id');
  static Key wordsKey(String id) => ValueKey('kept-words-$id');
  static Key markKey(String id) => ValueKey('kept-mark-$id');
  static Key editKey(String id) => ValueKey('kept-edit-$id');
  static Key deleteKey(String id) => ValueKey('kept-delete-$id');

  @override
  State<LifeContextPage> createState() => _LifeContextPageState();
}

class _LifeContextPageState extends State<LifeContextPage> {
  LifeContext get _life => widget.lifeContext;

  List<Kept> _recent = const [];
  bool _loaded = false;
  bool _selecting = false;
  final _selected = <String>{};
  String? _editing;
  final _field = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _life.addListener(_load);
    _focus.addListener(() {
      if (!_focus.hasFocus) _finishEdit();
    });
    _load();
  }

  @override
  void dispose() {
    _life.removeListener(_load);
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final recent = await _life.recent();
    if (!mounted) return;
    setState(() {
      _recent = recent;
      _loaded = true;
      _selected.retainAll({for (final k in recent) k.id});
      if (recent.isEmpty) _selecting = false;
    });
  }

  // C4-P·4, once: Cancel first, Delete destructive.
  Future<bool> _confirm() async =>
      await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(Lines.C4_P_4.text(appLanguage)),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(Lines.MP_61.text(appLanguage)),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(Lines.MP_60.text(appLanguage)),
            ),
          ],
        ),
      ) ==
      true;

  Future<void> _delete(Set<String> ids) async {
    if (!await _confirm()) return;
    await _life.delete(ids);
  }

  Future<void> _deleteAll() async {
    if (!await _confirm()) return;
    await _life.deleteAll();
  }

  Future<void> _deleteSelected() async {
    await _delete({..._selected});
    if (mounted) setState(() => _selecting = _recent.isNotEmpty && _selecting);
  }

  void _startEdit(Kept k) {
    setState(() {
      _editing = k.id;
      _field.text = k.text;
    });
    _focus.requestFocus();
  }

  // Keeps the edit; emptied, asks C4-P·4 first; Cancel keeps it as it was.
  Future<void> _finishEdit() async {
    final id = _editing;
    if (id == null) return;
    final text = _field.text;
    setState(() => _editing = null);
    final was = [
      for (final k in _recent)
        if (k.id == id) k.text,
    ].firstOrNull;
    if (was == null || text.trim() == was) return;
    if (isEmptyText(text) && !await _confirm()) return;
    await _life.edit(id, text);
  }

  void _toggle(Kept k) =>
      setState(() => _selected.contains(k.id) ? _selected.remove(k.id) : _selected.add(k.id));

  void _tap(Kept k) {
    if (_selecting) return _toggle(k);
    if (_editing != null) return;
    final open = widget.openNight;
    if (open != null) open(k.night).then((_) => _load());
  }

  // The tick ends selecting, and the selection with it.
  void _done() {
    setState(() {
      _selecting = false;
      _selected.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final longer = _life.longer;
    final off = !_life.on;
    final empty = _recent.isEmpty && longer.isEmpty;
    final labels = Lines.MP_87.parts(appLanguage);
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
                      child: _selecting
                          ? DoneControl(onPressed: _done)
                          : BackControl(onPressed: () => Navigator.of(context).pop()),
                    ),
                    if (!_selecting && !empty) Align(alignment: Alignment.topRight, child: _menu(p, longer)),
                  ],
                ),
              ),
              const SizedBox(height: StandIns.gap),
              Semantics(
                header: true,
                child: Text(
                  Lines.MP_86.text(appLanguage),
                  textAlign: TextAlign.center,
                  style: TypeRoles.h2.style(p.text),
                ),
              ),
              const SizedBox(height: StandIns.gap),
              if (!_loaded)
                const SizedBox.shrink()
              else if (off)
                AppLine(key: LifeContextPage.offKey, PendingLines.MP_104.text(appLanguage), style: StandIns.voiceApp(p.text))
              else if (empty)
                AppLine(key: LifeContextPage.emptyKey, Lines.MP_92.text(appLanguage), style: StandIns.voiceApp(p.text))
              else ...[
                Center(child: _Label(labels.first)),
                for (final k in longer) _sentence(p, k),
                const SizedBox(height: StandIns.gap),
                Center(child: _Label(labels[1 + _life.length.index])),
                const SizedBox(height: Spacing.journalRow),
                for (final k in _recent) _sentence(p, k),
                const SizedBox(height: StandIns.listAbove),
                SizedBox(
                  width: double.infinity,
                  child: _selecting
                      ? DestructivePill(
                          key: LifeContextPage.deleteSelectedKey,
                          Lines.MP_90(n: _selected.length).text(appLanguage),
                          onPressed: _selected.isEmpty ? null : _deleteSelected,
                        )
                      : DestructivePill(
                          key: LifeContextPage.deleteAllKey,
                          Lines.MP_91.text(appLanguage),
                          onPressed: _deleteAll,
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // The "⋯" menu (MP·88): Select sentences, and each list's deletion, for
  // a list that holds anything.
  Widget _menu(Palette p, List<Kept> longer) {
    final words = Lines.MP_88.parts(appLanguage);
    return CupertinoMenuAnchor(
      consumeOutsideTaps: true,
      menuChildren: [
        CupertinoMenuItem(
          key: LifeContextPage.selectKey,
          onPressed: () => setState(() => _selecting = true),
          child: Text(words[0]),
        ),
        if (longer.isNotEmpty)
          CupertinoMenuItem(
            key: LifeContextPage.deleteLongerKey,
            onPressed: () => _delete({for (final k in longer) k.id}),
            child: Text(words[1]),
          ),
        if (_recent.isNotEmpty)
          CupertinoMenuItem(
            key: LifeContextPage.deleteRecentKey,
            onPressed: () => _delete({for (final k in _recent) k.id}),
            child: Text(words[2]),
          ),
      ],
      builder: (context, controller, _) => Semantics(
        button: true,
        child: GestureDetector(
          key: LifeContextPage.menuKey,
          behavior: HitTestBehavior.opaque,
          onTap: () => controller.isOpen
              ? controller.close()
              : controller.open(position: const Offset(StandIns.menuWidth, StandIns.backSize + 8)),
          child: SizedBox(
            width: StandIns.menuWidth,
            height: StandIns.hitMin,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: StandIns.menuWidth,
                height: StandIns.backSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [p.buttonTop, p.buttonBottom],
                    ),
                    borderRadius: BorderRadius.circular(StandIns.backSize / 2),
                    border: Border.all(color: p.buttonBorder),
                  ),
                  child: Icon(Icons.more_horiz, color: p.buttonText),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // A kept sentence: its box, edit at its left and delete at its right, or
  // its selection mark while selecting.
  Widget _sentence(Palette p, Kept k) {
    final words = Lines.MP_89.parts(appLanguage);
    final editing = _editing == k.id;
    Widget icon(Key key, IconData data, Color colour, String label, VoidCallback onTap) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        key: key,
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox.square(
          dimension: StandIns.hitMin,
          child: Icon(data, size: StandIns.keptIcon, color: colour),
        ),
      ),
    );
    final selected = _selected.contains(k.id);
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.journalRow),
      child: DecoratedBox(
        key: LifeContextPage.sentenceKey(k.id),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.keptTop, p.keptBottom],
          ),
          borderRadius: BorderRadius.circular(Spacing.radius),
          border: Border.all(color: p.keptBorder),
        ),
        child: Padding(
          padding: StandIns.keptPadding,
          child: Row(
            children: [
              if (_selecting)
                Semantics(
                  checked: selected,
                  child: GestureDetector(
                    key: LifeContextPage.markKey(k.id),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _toggle(k),
                    child: SizedBox.square(
                      dimension: StandIns.hitMin,
                      child: Icon(
                        selected ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: StandIns.keptIcon,
                        color: p.keptText,
                      ),
                    ),
                  ),
                )
              else
                icon(LifeContextPage.editKey(k.id), Icons.edit_outlined, p.keptText, words[0], () => _startEdit(k)),
              Expanded(
                child: editing
                    ? TextField(
                        key: LifeContextPage.fieldKey,
                        controller: _field,
                        focusNode: _focus,
                        maxLines: null,
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _focus.unfocus(),
                        style: TypeRoles.voiceDreamer.style(p.keptText),
                        decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true),
                      )
                    : GestureDetector(
                        key: LifeContextPage.wordsKey(k.id),
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _tap(k),
                        child: Column(
                          children: [
                            Text(
                              quoted(k.text),
                              textAlign: TextAlign.center,
                              style: TypeRoles.voiceDreamer.style(p.keptText),
                            ),
                            const SizedBox(height: StandIns.keptDateGap),
                            Text(shownDate(k.day), style: TypeRoles.buttonSmall.style(p.keptDate)),
                          ],
                        ),
                      ),
              ),
              if (!_selecting)
                icon(
                  LifeContextPage.deleteKey(k.id),
                  Icons.delete_outline,
                  p.keptDelete,
                  words[1],
                  () => _delete({k.id}),
                )
              else
                const SizedBox(width: StandIns.hitMin),
            ],
          ),
        ),
      ),
    );
  }
}

/// A list's label: a pill in color.tag.dream (a stand-in), heard as a
/// heading.
class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      header: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.tagTop, p.tagBottom],
          ),
          borderRadius: BorderRadius.circular(Spacing.radius),
        ),
        child: Padding(
          padding: StandIns.labelPadding,
          child: Text(text, style: TypeRoles.button.style(p.tagText)),
        ),
      ),
    );
  }
}
