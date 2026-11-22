// The popup before the dreamer has agreed (D128 item 3): a feature that
// sends something (the microphone, Start Interpretation) or Life Context's
// row, tapped before "I agree", shows MP·101 and one button, MP·102; nothing
// is started, recorded or sent. Both lines are pending lines: their words show
// in SoulDreams Dev only (R1).
import 'package:flutter/cupertino.dart';

import '../core/language.dart';
import '../words/pending.g.dart';

/// Shows MP·101 with its one button MP·102; completes when it is closed.
Future<void> showAgreementPopup(BuildContext context) => showCupertinoDialog<void>(
  context: context,
  builder: (context) => CupertinoAlertDialog(
    content: Text(PendingLines.MP_101.text(appLanguage)),
    actions: [
      CupertinoDialogAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(PendingLines.MP_102.text(appLanguage)),
      ),
    ],
  ),
);
