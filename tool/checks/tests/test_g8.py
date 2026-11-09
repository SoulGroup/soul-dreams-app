import unittest

from helpers import GuardTest
import g8_export

IMP = "import 'package:souldreams/founder/export.dart';\n"


class G8(GuardTest):
    guard = g8_export

    def test_tester_main_refused(self):
        self.refused({'app/lib/main.dart': IMP}, 'founder-import')

    def test_any_other_file_refused(self):
        self.refused({'app/lib/ui/a.dart': IMP}, 'founder-import')
        self.refused({'app/lib/ui/a.dart': "import '../founder/export.dart';\n"}, 'founder-import')
        self.refused({'app/lib/a.dart': "export 'founder/export.dart' show x;\n"}, 'founder-import')
        self.refused({'app/lib/a.dart': "part 'founder/p.dart';\n"}, 'founder-import')
        self.refused({'app/lib/a.dart': "import 'x.dart'\n  if (dart.library.io) 'founder/y.dart';\n"},
                     'founder-import')

    def test_allowed_importers_pass(self):
        self.passed({'app/lib/main_founder.dart': IMP, 'app/lib/main_dev.dart': IMP,
                     'app/lib/founder/a.dart': "import 'b.dart';\n",
                     'app/test/founder/a_test.dart': IMP})

    def test_lookalikes_pass(self):
        self.passed({'app/lib/a.dart': "import 'package:x/founders.dart';\n"
                                       "import 'founder_note.dart';\nconst s = 'founder/x';\n"})


if __name__ == '__main__':
    unittest.main()
