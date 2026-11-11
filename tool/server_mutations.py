# The server's mutation checks (D43 Q3), run by hand from the repository
# root: python3 -I -B tool/server_mutations.py
# First the unbroken server, copied, must pass its type check and tests.
# Then each row breaks one thing in a copy of server/ in the temporary
# folder (node_modules linked, never the repository), runs the type
# check or the tests there, and the named test must fail. check_all.sh
# does not call it. It reports row codes and test names only, through
# the checks' own writer. Exit 0 when every row is caught, 1 otherwise.
import os
import shutil
import subprocess
import sys
import tempfile

TOOL = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(TOOL, 'checks'))

from guardlib import report  # noqa: E402

SERVER = os.path.join(os.path.dirname(TOOL), 'server')

# (code, file, old, new, 'check' or 'test', the test that must fail)
ROWS = [
    ('S1', 'src/safe-log.ts',
     "    throw new TypeError('safe-log-code');\n", '',
     'test', 'an unknown code is refused'),
    ('S2', 'src/safe-log.ts', '!Number.isFinite(n)', 'Number.isNaN(n)',
     'test', 'a number that is not finite is refused'),
    ('S3', 'src/safe-log.ts', 'numbers: readonly number[] = []',
     'numbers: readonly unknown[] = []', 'check', 'test/safe-log.test.ts'),
    ('S4', 'src/handler.ts', "    safeLog('handlerFailed');\n    return { statusCode: 500 };",
     '    return { statusCode: 404 };',
     'test', 'a failure: 500 and a code, never its message'),
    ('S5', 'package.json', ' && node infra/dist.ts mark', '',
     'test', 'the marker makes the code a module'),
    ('S6', 'infra/stack.ts', '      analyticsReporting: false,\n', '',
     'test', 'no version reporting'),
    ('S7', 'infra/stack.ts', 'RetentionDays.ONE_WEEK', 'RetentionDays.ONE_MONTH',
     'test', 'logs: 7 days, JSON, application INFO, system WARN'),
    ('S8', 'infra/stack.ts', '      role,\n', '',
     'test', 'the role writes to its own log group only'),
    ('S9', 'infra/account.ts', '  if (wanted !== resolved) {',
     '  if (wanted !== resolved && wanted !== undefined) {',
     'test', 'none passed, or another: refused'),
    ('S10', 'infra/app.ts', "process.env['CDK_DEFAULT_ACCOUNT']", 'undefined',
     'test', 'the app refuses a resolved account not passed'),
    ('S11', 'cdk.json', '"notices": false', '"notices": true',
     'test', 'cdk.json switches off the three reports'),
    ('S12', 'package.json', '"aws-cdk-lib": "2.275.0"', '"aws-cdk-lib": "^2.275.0"',
     'test', 'the five packages, exact, for development only'),
    ('S13', 'infra/stack.ts', "    new HttpApi(this, 'Api', {",
     "    new logs.LogGroup(this, 'Extra');\n    new HttpApi(this, 'Api', {",
     'test', 'these resources and no others'),
    ('S14', 'infra/stack.ts',
     "      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),\n",
     "      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),\n"
     "      inlinePolicies: { x: new iam.PolicyDocument({ statements: ["
     "new iam.PolicyStatement({ actions: ['logs:*'], resources: ['*'] })] }) },\n",
     'test', 'the role writes to its own log group only'),
    ('S15', 'infra/stack.ts', '      logGroup,\n',
     "      logGroup: logs.LogGroup.fromLogGroupName(this, 'Old', 'kept'),\n",
     'test', 'logs: 7 days, JSON, application INFO, system WARN'),
    ('S16', 'infra/stack.ts', 'RemovalPolicy.DESTROY', 'RemovalPolicy.RETAIN',
     'test', 'logs: 7 days, JSON, application INFO, system WARN'),
]


def failed_names(output):
    # The names node:test marks as failed, and the files tsc names.
    names = set()
    for line in output.splitlines():
        if line.startswith('✖ '):
            names.add(line[2:].rsplit(' (', 1)[0])
        elif ': error TS' in line:
            names.add(line.split('(', 1)[0])
    return names


def copy_server():
    copy = tempfile.mkdtemp(prefix='server-mutation-')
    try:
        shutil.copytree(SERVER, copy, dirs_exist_ok=True,
                        ignore=shutil.ignore_patterns('node_modules', 'dist', 'cdk.out'))
        os.symlink(os.path.join(SERVER, 'node_modules'), os.path.join(copy, 'node_modules'))
    except BaseException:
        shutil.rmtree(copy, ignore_errors=True)
        raise
    return copy


def unbroken_passes():
    copy = copy_server()
    try:
        for cmd in (['npm', 'run', 'check'], ['npm', 'test']):
            if subprocess.run(cmd, cwd=copy, capture_output=True).returncode != 0:
                return False
        return True
    finally:
        shutil.rmtree(copy, ignore_errors=True)


def run_row(code, path, old, new, what, name):
    copy = copy_server()
    try:
        target = os.path.join(copy, path)
        with open(target, encoding='utf-8') as f:
            text = f.read()
        if text.count(old) != 1:
            return 'not-applied'
        with open(target, 'w', encoding='utf-8') as f:
            f.write(text.replace(old, new))
        cmd = ['npm', 'run', 'check'] if what == 'check' else ['npm', 'test']
        r = subprocess.run(cmd, cwd=copy, capture_output=True, text=True)
        caught = r.returncode != 0 and name in failed_names(r.stdout + r.stderr)
        return 'caught' if caught else 'missed'
    finally:
        shutil.rmtree(copy, ignore_errors=True)


def main():
    if not os.path.isdir(os.path.join(SERVER, 'node_modules')):
        report('server mutations: no server/node_modules (the owner installs them)')
        return 2
    if not unbroken_passes():
        report('server mutations: FAILED (the unbroken server fails)')
        return 1
    caught = 0
    for row in ROWS:
        result = run_row(*row)
        caught += result == 'caught'
        report('%s %s: %s' % (row[0], result, row[5]))
    report('server mutations: %d run, %d caught' % (len(ROWS), caught))
    return 0 if caught == len(ROWS) else 1


if __name__ == '__main__':
    sys.exit(main())
