import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/always_light.dart';
import 'core/language.dart';
import 'core/night_day.dart';
import 'core/privacy_cover.dart';
import 'design/palette.dart';

/// The app, under the cover (D50 2) on every page, in the theme Night/Day
/// mode sets (D56; P14), in the language it shows (D57 Q12). Flutter's
/// own localizations give the month names (P5) and the framework's own
/// words, which are not ours under R1 (D57 Q9). A page may hold it in the
/// light theme, at once: onboarding (`AlwaysLight`).
class SoulDreamsApp extends StatefulWidget {
  const SoulDreamsApp({super.key, this.home, this.clock});

  /// The first page; a blank one when null. Only SoulDreams Dev sets it.
  final Widget? home;

  /// The phone's local time now; tests pass their own.
  final DateTime Function()? clock;

  @override
  State<SoulDreamsApp> createState() => _SoulDreamsAppState();
}

class _SoulDreamsAppState extends State<SoulDreamsApp> {
  final _light = ValueNotifier<bool>(false);
  bool _wasLight = false;

  @override
  void dispose() {
    _light.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlwaysLight(
      light: _light,
      child: NightDay(
        now: widget.clock ?? DateTime.now,
        builder: (context, mode, fade) => ValueListenableBuilder<bool>(
          valueListenable: _light,
          builder: (context, light, _) {
            // Held light, or let go: at once, never a fade.
            final held = light != _wasLight;
            _wasLight = light;
            return _app(light ? ThemeMode.light : mode, held ? Duration.zero : fade);
          },
        ),
      ),
    );
  }

  Widget _app(ThemeMode mode, Duration fade) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: themeFor(Brightness.light),
    darkTheme: themeFor(Brightness.dark),
    themeMode: mode,
    themeAnimationDuration: fade,
    // A gentle ease-in-out over the five seconds (head's message 20,
    // item 13).
    themeAnimationCurve: Curves.easeInOut,
    locale: Locale(appLanguage.name),
    supportedLocales: const [Locale('en'), Locale('sv')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    // The phone's own status bar style, as iOS gives it when the app sets
    // none, held under every page: a page that sets its own (a night's
    // header) is overridden only while it is shown, since Flutter leaves the
    // last style in place when a frame has none.
    builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: MediaQuery.platformBrightnessOf(context) == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: PrivacyCover(child: child!),
    ),
    home: widget.home ?? const Scaffold(),
  );
}
