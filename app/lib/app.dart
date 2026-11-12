import 'package:flutter/material.dart';

import 'core/privacy_cover.dart';

/// The app. For now a blank screen with no text (scaffold-2-app), under
/// the cover (D50 2) on every page.
class SoulDreamsApp extends StatelessWidget {
  const SoulDreamsApp({super.key, this.home});

  /// The first page; a blank one when null. Only SoulDreams Dev sets it
  /// (the keyboard check, D50 1).
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => PrivacyCover(child: child!),
      home: home ?? const Scaffold(),
    );
  }
}
