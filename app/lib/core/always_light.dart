// Onboarding is always in the light theme, whatever the time
// (main-path.md, Every Screen and Onboarding; design-system.md §6). A page
// holds the whole app light, not only itself, so the cover over it (P11)
// is light too; the change is at once, never a fade.
import 'package:flutter/widgets.dart';

class AlwaysLight extends InheritedWidget {
  const AlwaysLight({super.key, required this.light, required super.child});

  /// True while a page holds the app light.
  final ValueNotifier<bool> light;

  /// Holds the app light, or lets it go, from a page under it.
  static void hold(BuildContext context, bool on) =>
      context.getInheritedWidgetOfExactType<AlwaysLight>()?.light.value = on;

  @override
  bool updateShouldNotify(AlwaysLight old) => old.light != light;
}
