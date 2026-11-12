import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/language.dart';
import 'core/night_day.dart';
import 'core/privacy_cover.dart';
import 'design/palette.dart';

/// The app, under the cover (D50 2) on every page, in the theme Night/Day
/// mode sets (D56; P14), in the language it shows (D57 Q12). Flutter's
/// own localizations give the month names (P5) and the framework's own
/// words, which are not ours under R1 (D57 Q9).
class SoulDreamsApp extends StatelessWidget {
  const SoulDreamsApp({super.key, this.home, this.clock});

  /// The first page; a blank one when null. Only SoulDreams Dev sets it.
  final Widget? home;

  /// The phone's local time now; tests pass their own.
  final DateTime Function()? clock;

  @override
  Widget build(BuildContext context) {
    return NightDay(
      now: clock ?? DateTime.now,
      builder: (context, mode, fade) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeFor(Brightness.light),
        darkTheme: themeFor(Brightness.dark),
        themeMode: mode,
        themeAnimationDuration: fade,
        themeAnimationCurve: Curves.linear,
        locale: Locale(appLanguage.name),
        supportedLocales: const [Locale('en'), Locale('sv')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        builder: (context, child) => PrivacyCover(child: child!),
        home: home ?? const Scaffold(),
      ),
    );
  }
}
