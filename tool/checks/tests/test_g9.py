import unittest

from helpers import GuardTest
import g9_hosts

S = '://'


class G9(GuardTest):
    guard = g9_hosts

    def test_each_scheme_refused(self):
        for scheme in ('http', 'https', 'ws', 'wss', 'HTTPS'):
            self.refused({'app/lib/a.dart': "const u = '" + scheme + S + "x.example';\n"}, 'host-literal')

    def test_server_and_shell_refused(self):
        self.refused({'server/src/a.ts': "const u = 'https" + S + "x.example';\n"}, 'host-literal')
        self.refused({'tool/a.sh': 'fetch https' + S + 'x.example\n'}, 'host-literal')

    def test_hosts_files_and_tests_pass(self):
        u = "const u = 'https" + S + "x.example';\n"
        self.passed({'app/lib/core/hosts.dart': u, 'server/src/hosts.ts': u,
                     'app/test/a_test.dart': u, 'server/test/a.test.ts': u})

    def test_comments_and_doctype_pass(self):
        self.passed({'app/lib/a.dart': '// see https' + S + 'x.example\n',
                     'app/ios/Runner/Info.plist': '<!DOCTYPE plist PUBLIC "x" "http' + S + 'x/y.dtd">\n'})


if __name__ == '__main__':
    unittest.main()
