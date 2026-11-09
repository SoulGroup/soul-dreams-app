import unittest

from helpers import GuardTest
import g5_logging

P = 'pri' + 'nt('


class G5(GuardTest):
    guard = g5_logging

    def test_each_writer_refused(self):
        cases = [
            ('app/lib/a.dart', 'f() { ' + P + '1); }\n', 'writer-print'),
            ('app/lib/a.dart', 'f() { debugPrint(1); }\n', 'writer-debugPrint'),
            ('app/lib/a.dart', 'f() { developer.log(1); }\n', 'writer-log'),
            ('server/src/a.ts', 'console.info(1);\n', 'writer-console'),
            ('server/src/a.ts', 'process.stdout.write(1);\n', 'writer-stdout.write'),
            ('app/lib/a.dart', 'f() { stderr.writeln(1); }\n', 'writer-stderr.write'),
            ('app/lib/a.dart', 'f() { FlutterError.dumpErrorToConsole(e); }\n',
             'writer-dumpErrorToConsole'),
            ('tool/a.py', P + '1)\n', 'writer-print'),
        ]
        for path, body, reason in cases:
            self.refused({path: body}, reason)

    def test_safe_loggers_pass(self):
        self.passed({'app/lib/core/safe_log.dart': 'f() { ' + P + '1); }\n',
                     'server/src/safe-log.ts': 'console.info(1);\n'})

    def test_strings_comments_and_lookalikes_pass(self):
        self.passed({'app/lib/a.dart': "f() { showDialog(); catalog(); } // " + P + "\nconst s = '" + P + "';\n",
                     'server/src/a.ts': 'const y = Math.log(2);\n'})

    def test_apple_writers_refused_in_swift_and_headers(self):
        # D20 Q13: Apple's loggers, in Swift code and in headers.
        cases = [
            ('app/ios/Runner/a.swift', 'NSLog("%d", 1)\n', 'writer-NSLog'),
            ('app/ios/Runner/a.swift', 'os_log("%d", 1)\n', 'writer-os_log'),
            ('app/ios/Runner/a.swift', 'let l = Logger(subsystem: "a", category: "b")\n',
             'writer-Logger'),
            ('app/ios/Runner/a.h', 'void f(void) { NSLog(@"x"); }\n', 'writer-NSLog'),
        ]
        for path, body, reason in cases:
            self.refused({path: body}, reason)

    def test_apple_writers_only_in_apple_code(self):
        self.passed({'app/lib/a.dart': 'final l = Logger();\n',
                     'app/ios/Runner/a.swift': '// NSLog(1)\nlet s = "os_log(1)"\nlet m = MyLogger(1)\n'})


if __name__ == '__main__':
    unittest.main()
