import unittest

from helpers import GuardTest, sentence
import g4_invented


def ts(n):
    return "export const s = '%s';\n" % sentence(n)


class G4(GuardTest):
    guard = g4_invented

    def test_twelve_words_refused_in_each_language(self):
        bodies = {
            'server/src/a.ts': ts(12),
            'app/test/a_test.dart': "const s = '%s';\n" % sentence(12),
            'tool/a.py': "s = '%s'\n" % sentence(12),
            'tool/a.sh': "s='%s'\n" % sentence(12),
        }
        for path, body in bodies.items():
            self.refused({path: body}, 'long-literal')

    def test_eleven_words_pass(self):
        self.passed({'server/src/a.ts': ts(11)})

    def test_config_strings_refused(self):
        self.refused({'server/package.json': '{"description": "%s"}\n' % sentence(12)}, 'long-literal')
        self.refused({'app/ios/Runner/Info.plist': '<string>%s</string>\n' % sentence(12)}, 'long-literal')
        self.refused({'app/pubspec.yaml': 'description: %s\n' % sentence(12)}, 'long-literal')

    def test_generated_words_pass(self):
        # D32 Q18: G1 proves these are the generator's output.
        self.passed({'app/ios/Flutter/words.g.xcconfig': 'WORDS_MIC_USAGE = %s\n' % sentence(15)})

    def test_hand_written_xcconfig_refused(self):
        self.refused({'app/ios/Flutter/founder.xcconfig': 'X = %s\n' % sentence(12)},
                     'long-literal')

    def test_exempt_places_pass(self):
        self.passed({'fixtures/invented-nights.json': '["%s"]\n' % sentence(30),
                     'app/lib/words/lines.g.dart': "const s = '%s';\n" % sentence(30),
                     'docs/plans/p.md': sentence(30) + '\n',
                     'tool/a.py': '# %s\n' % sentence(30)})


if __name__ == '__main__':
    unittest.main()
