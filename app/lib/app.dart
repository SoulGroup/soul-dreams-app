import 'package:flutter/material.dart';

/// The app. For now a blank screen with no text (scaffold-2-app).
class SoulDreamsApp extends StatelessWidget {
  const SoulDreamsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold());
  }
}
