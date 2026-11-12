import 'package:flutter/material.dart';

/// SoulDreams Dev only (D50 1; the plan's Task 13): one empty field, no
/// words, so the owner can see that the phone offers no third-party
/// keyboard here. Nothing typed is kept.
class KeyboardCheck extends StatelessWidget {
  const KeyboardCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: TextField(autofocus: true)));
  }
}
