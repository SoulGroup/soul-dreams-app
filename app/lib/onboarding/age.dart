// The age question's bands (main-path.md, Onboarding; C7-P item 4): MP·6's
// one line, parted where the register parts it, into seven labels in the
// register's order, the first under 18. The band chosen is never kept or
// sent: only the consent's one result, 18 or over, is kept, and only with
// the consent (C146-I item 1; D103 item 2).
import '../words/lines.g.dart';

/// The seven bands' labels in [lang].
List<String> ageBands(Lang lang) => Lines.MP_6.text(lang).split('; ');

/// Whether the band at [index] is under 18: the app is for adults (C127-I
/// I6).
bool underAge(int index) => index == 0;
