// type.voice.app's line height is the founder's 1.3, not the filed 1.5
// (D125 item 1; for Product's next filing): every use of the role goes
// through StandIns.voiceApp, whose family, size and weight stay the filed ones.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/palette.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/onboarding/disclosure_page.dart';
import 'package:souldreams/words/lines.g.dart';

void main() {
  test('the voice style: the filed family and size, the height 1.3', () {
    final style = StandIns.voiceApp(const Color(0xFF123456));
    expect(StandIns.voiceAppHeight, 1.3);
    expect(style.height, 1.3);
    expect(style.fontFamily, TypeRoles.voiceApp.family);
    expect(style.fontSize, TypeRoles.voiceApp.size);
    expect(style.fontWeight, TypeRoles.voiceApp.weight);
    expect(style.letterSpacing, TypeRoles.voiceApp.letterSpacing);
    expect(style.color, const Color(0xFF123456));
    // The filed value stays in the generated tokens, for Product to re-file.
    expect(TypeRoles.voiceApp.height, 1.5);
  });

  test('no page reaches the role without the override', () {
    final users = [
      for (final f in Directory('lib').listSync(recursive: true).whereType<File>())
        if (f.path.endsWith('.dart') &&
            !f.path.endsWith('tokens.g.dart') &&
            !f.path.endsWith('stand_ins.dart') &&
            f.readAsStringSync().contains('TypeRoles.voiceApp'))
          f.path,
    ];
    expect(users, isEmpty);
  });

  testWidgets('the disclosure page reads at 1.3', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: themeFor(Brightness.light), home: const DisclosurePage(shown: [Lines.W27_1])));
    final text = tester.widget<Text>(find.text(Lines.W27_1.parts(Lang.en).join('\n')));
    expect(text.style!.height, 1.3);
  });
}
