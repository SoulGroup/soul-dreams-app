import unittest

from helpers import GuardTest
import g6_identifiers

NAMES = ['client_' + 'reference_id', 'identifier' + 'ForVendor',
         'advertising' + 'Identifier', 'device' + '_info']


class G6(GuardTest):
    guard = g6_identifiers

    def test_each_name_refused_in_code_and_config(self):
        for name in NAMES:
            for path in ('app/lib/a.dart', 'server/src/a.ts', 'app/pubspec.yaml',
                         'app/ios/Runner/Info.plist'):
                self.refused({path: 'x ' + name + ' y\n'}, 'identifier')

    def test_other_spellings_refused(self):
        self.refused({'server/src/a.ts': 'const clientReference' + 'Id = 1;\n'}, 'identifier')
        self.refused({'app/pubspec.yaml': '  device' + '_info_plus: any\n'}, 'identifier')

    def test_near_miss_passes(self):
        self.passed({'app/lib/a.dart': 'final device = 1; final info = 2;\n'})


if __name__ == '__main__':
    unittest.main()
