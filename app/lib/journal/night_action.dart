// One more item for a night's "⋯" menu, given by the entry point (D107
// item 1). The journal knows only its words and that it takes the night:
// what it does lives with whoever gives it, so nothing of it is built into
// an app that gives none (R8).
import 'night.dart';

final class NightAction {
  const NightAction({required this.label, required this.run});

  /// The item's words, from the register or a pending line (R1).
  final String label;

  /// What the item does with the night shown.
  final Future<void> Function(Night night) run;
}
