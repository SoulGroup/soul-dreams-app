# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S72, D135, D138), run by hand from the repository
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
    ('S4', 'src/door.ts', "      safeLog('handlerFailed');\n      return { statusCode: 500 };",
     '      return { statusCode: 404 };',
     'test', 'a failure anywhere else: 500 and a code'),
    ('S5', 'package.json', ' && node infra/dist.ts mark', '',
     'test', 'the marker makes the code a module'),
    ('S6', 'infra/stack.ts', '      analyticsReporting: false,\n', '',
     'test', 'no version reporting'),
    ('S7', 'infra/stack.ts', 'RetentionDays.ONE_WEEK', 'RetentionDays.ONE_MONTH',
     'test', 'logs: 7 days, JSON, application INFO, system WARN'),
    ('S8', 'infra/stack.ts', '      role,\n', '',
     'test', 'the role: its own log group, and the two keys only'),
    ('S9', 'infra/account.ts', '  if (wanted !== resolved) {',
     '  if (wanted !== resolved && wanted !== undefined) {',
     'test', 'none passed, or another: refused'),
    ('S10', 'infra/app.ts', "process.env['CDK_DEFAULT_ACCOUNT']", 'undefined',
     'test', 'the app refuses a resolved account not passed'),
    ('S11', 'cdk.json', '"notices": false', '"notices": true',
     'test', 'cdk.json switches off the three reports'),
    ('S12', 'package.json', '"aws-cdk-lib": "2.275.0"', '"aws-cdk-lib": "^2.275.0"',
     'test', 'the six packages, exact, for development only'),
    ('S13', 'infra/stack.ts', '    const url = fn.addFunctionUrl(',
     "    new logs.LogGroup(this, 'Extra');\n    const url = fn.addFunctionUrl(",
     'test', 'these resources and no others'),
    ('S14', 'infra/stack.ts',
     "      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),\n",
     "      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),\n"
     "      inlinePolicies: { x: new iam.PolicyDocument({ statements: ["
     "new iam.PolicyStatement({ actions: ['logs:*'], resources: ['*'] })] }) },\n",
     'test', 'the role: its own log group, and the two keys only'),
    ('S15', 'infra/stack.ts', '      logGroup,\n',
     "      logGroup: logs.LogGroup.fromLogGroupName(this, 'Old', 'kept'),\n",
     'test', 'logs: 7 days, JSON, application INFO, system WARN'),
    ('S16', 'infra/stack.ts', 'RemovalPolicy.DESTROY', 'RemovalPolicy.RETAIN',
     'test', 'logs: 7 days, JSON, application INFO, system WARN'),
    # The recording branch (D71): the front door and its stack.
    ('S17', 'infra/stack.ts', 'FunctionUrlAuthType.NONE', 'FunctionUrlAuthType.AWS_IAM',
     'test', 'one function URL: no authentication of its own, no CORS'),
    ('S18', 'infra/stack.ts', 'authType: lambda.FunctionUrlAuthType.NONE }',
     "authType: lambda.FunctionUrlAuthType.NONE, cors: { allowedOrigins: ['*'] } }",
     'test', 'one function URL: no authentication of its own, no CORS'),
    ('S19', 'infra/stack.ts', '      timeout: Duration.seconds(10),\n',
     '      timeout: Duration.seconds(10),\n      reservedConcurrentExecutions: 5,\n',
     'test', 'no reserved concurrency yet (D71 Q12)'),
    ('S20', 'infra/stack.ts', 'Duration.seconds(10)', 'Duration.seconds(30)',
     'test', 'Node 24 on arm64, its own handler, 10 seconds'),
    ('S21', 'infra/stack.ts',
     "        conditions: { StringEquals: { 'kms:ViaService': `ssm.${REGION}.amazonaws.com` } },\n", '',
     'test', 'the role: its own log group, and the two keys only'),
    ('S22', 'infra/stack.ts', "    new CfnOutput(this, 'Url', { value: url.url });", '    void url;',
     'test', "one output, the URL's address"),
    ('S23', 'src/soniox.ts', '  max_session_duration_seconds: 1800,\n',
     "  max_session_duration_seconds: 1800,\n  context: 'x',\n",
     'test', 'exactly these four fields and no other (R4)'),
    ('S24', 'src/soniox.ts', '  if (reply.status !== 201) {', '  if (reply.status >= 500) {',
     'test', "Soniox's refusal carries its status"),
    ('S25', 'src/beta-key.ts', '  return timingSafeEqual(a, b);', '  return timingSafeEqual(a, b) && given === kept;',
     'test', 'the comparison hashes both keys and takes the same time'),
    ('S26', 'src/door.ts', '  if (!isBetaKeyShape(given)) {', "  if (!isBetaKeyShape(given) && given === '') {",
     'test', 'a misshapen key is refused before anything is read'),
    ('S27', 'src/door.ts', "  if (event.requestContext?.http?.method !== 'POST'",
     "  if (JSON.stringify(event) === '' || event.requestContext?.http?.method !== 'POST'",
     'test', 'the right key: 200 and a short-lived key, one code'),
    ('S28', 'src/door.ts', '  if (!sameKey(given, betaKey)) {', '  if (!sameKey(given, betaKey) && false) {',
     'test', 'a wrong, missing or misshapen key: 401, Soniox never asked'),
    ('S29', 'src/hosts.ts', 'api.eu.soniox.com/v1', 'api.soniox.com/v1',
     'test', 'the temporary-key address is on that host, over https'),
    ('S30', 'src/soniox.ts', "  if (typeof key !== 'string' || key === '' ||", "  if (typeof key !== 'string' ||",
     'test', 'no answer is 0; an unreadable answer is -1'),
    # The image trial (D135, D136): its stack, its serving code, its run
    # and its weights script.
    # The image trial: the stack.
    ('S31', 'infra/image-trial.ts',
     's3.BlockPublicAccess.BLOCK_ALL', 's3.BlockPublicAccess.BLOCK_ACLS',
     'test', 'the bucket: private, encrypted, TLS only, no logging or versions'),
    ('S32', 'infra/image-trial.ts',
     '      enforceSSL: true,\n', '',
     'test', 'the bucket: private, encrypted, TLS only, no logging or versions'),
    ('S33', 'infra/image-trial.ts',
     '({ prefix, expiration: Duration.days(1) })', '({ prefix, expiration: Duration.days(2) })',
     'test', 'requests and results deleted within a day; the weights kept'),
    ('S34', 'infra/image-trial.ts',
     '        enableNetworkIsolation: true,\n', '',
     'test', 'each model: the pinned container, its weights, no network'),
    ('S35', 'infra/image-trial.ts',
     '        maxCapacity: 1,', '        maxCapacity: 2,',
     'test', 'scaling: from none to one on a waiting request'),
    ('S36', 'infra/image-trial.ts',
     '        minCapacity: 0,', '        minCapacity: 1,',
     'test', 'scaling: from none to one on a waiting request'),
    ('S37', 'infra/image-trial.ts',
     'cloudwatch.TreatMissingData.BREACHING', 'cloudwatch.TreatMissingData.NOT_BREACHING',
     'test', 'scaling: to none after 10 idle minutes'),
    ('S38', 'infra/image-trial.ts',
     'idleRaw === undefined ? 10 :', 'idleRaw === undefined ? 15 :',
     'test', 'scaling: to none after 10 idle minutes'),
    ('S39', 'infra/image-trial.ts',
     'logs.RetentionDays.ONE_DAY', 'logs.RetentionDays.THREE_DAYS',
     'test', 'the logs: made first, kept 1 day, gone with the stack'),
    ('S40', 'infra/image-trial.ts',
     '      endpoint.node.addDependency(logGroup);\n', '',
     'test', 'the logs: made first, kept 1 day, gone with the stack'),
    ('S41', 'infra/image-trial.ts',
     "bucket.arnForObjects('models/*'), bucket.arnForObjects('in/*')", "bucket.arnForObjects('models/*'), bucket.arnForObjects('in/*'), bucket.arnForObjects('out/*')",
     'test', "the models' role: its prefixes, its logs, the container, nothing else"),
    # S42, the budget row, went with the budget resource (D138): it does
    # not exist in eu-north-1; the owner makes the budget with the CLI.
    ('S43', 'infra/image-trial.ts',
     '      terminationProtection: false,', '      terminationProtection: true,',
     'test', 'the trial: eu-north-1, destroyable, no version reporting'),
    ('S44', 'infra/app.ts',
     "if (app.node.tryGetContext('imageTrial') !== undefined) {", 'if (true) {',
     'test', 'the app makes the trial only when asked'),
    ('S45', 'infra/image-trial.ts',
     "eightBit ? 'ml.g6.xlarge' : 'ml.g6e.xlarge'", "'ml.g6e.xlarge'",
     'test', "D136's fallback: FLUX in 8 bits on g6.xlarge, alone"),
    ('S46', 'infra/image-trial.ts',
     "        : which === 'bucket'\n          ? []", "        : which === 'bucket'\n          ? ['sdxl']",
     'test', 'the first stage: the bucket and both log groups, no endpoint'),
    # The image trial: the serving code.
    ('S47', 'trial/code/inference.py',
     ", torch_dtype=torch.bfloat16, device_map='cuda')", ', torch_dtype=torch.bfloat16)',
     'test', 'serving: full precision, straight onto the GPU'),
    ('S48', 'trial/code/inference.py',
     "    if not set(settings) <= set(SETTINGS) | {'seed'}:", '    if False:',
     'test', 'serving: refusals are codes, never the words'),
    ('S49', 'trial/code/inference.py',
     "'install', '--no-index', ", "'install', ",
     'test', 'serving: 8 bits from the pinned wheel, offline'),
    ('S50', 'trial/code/inference.py',
     '.manual_seed(seed)', '.manual_seed(0)',
     'test', 'serving: seeded on the GPU, answered as PNG'),
    # The image trial: the run.
    ('S51', 'trial/measure.ts',
     'const shorter = (run.idleMinutes - 2) * 60;', 'const shorter = (run.idleMinutes - 3) * 60;',
     'test', 'the costs, from what was measured'),
    ('S52', 'trial/measure.ts',
     '/ (run.batch.paintings - 1);', '/ run.batch.paintings;',
     'test', 'the costs, from what was measured'),
    ('S53', 'trial/measure.ts',
     "  'ml.g6e.xlarge': 2.7636,", "  'ml.g6e.xlarge': 2.6054,",
     'test', 'the costs, from what was measured'),
    ('S54', 'trial/measure.ts',
     'seed: 1000 + index', 'seed: 1000',
     'test', "a request: the prompt, the model's settings, the prompt's seed"),
    ('S55', 'trial/run.ts',
     "      '--accept',\n      'image/png',", "      '--accept',\n      'application/json',",
     'test', 'a round: requests through S3, PNG asked, times from S3'),
    ('S56', 'trial/run.ts',
     '      rmSync(file, { force: true });\n', '',
     'test', 'a round: requests through S3, PNG asked, times from S3'),
    ('S57', 'trial/run.ts',
     ' || out.end > (r.done[0] ?? NaN)', '',
     'test', 'a round with no scaling found is refused, not guessed'),
    ('S58', 'trial/run.ts',
     "      throw new Error('trial-failed');\n", '',
     'test', 'a failed painting stops the run with a code'),
    ('S59', 'trial/run.ts',
     "      throw new Error('trial-not-png');\n", '',
     'test', 'a result that is not a PNG stops the run'),
    # The image trial: the weights script.
    ('S60', 'trial/fetch-weights.sh',
     '    *.fp16.*) continue ;;\n', '',
     'test', "weights: only the parts' files, checked, kept on a rerun"),
    ('S61', 'trial/fetch-weights.sh',
     '      aws s3 rm "s3://$bucket/$key" --region eu-north-1 --only-show-errors\n', '',
     'test', 'weights: a large file read back wrong is removed; a stop'),
    ('S62', 'trial/fetch-weights.sh',
     '    [ "$got" = "$oid" ] || fail "fetch-hash $path" 3\n', '',
     'test', 'weights: a small file unlike the hub is never uploaded'),
    ('S63', 'trial/fetch-weights.sh',
     '[ "${#rev}" -eq 40 ] || fail fetch-revision 2\n', '',
     'test', 'weights: the arguments are refused unless exact'),
    # D138: the logs with the bucket, the model server's timeout, the run's
    # deletions, the weights' staging name.
    ('S64', 'infra/image-trial.ts',
     '      MODEL_KEYS.map((key) => [',
     '      MODEL_KEYS.filter(() => models.length > 0).map((key) => [',
     'test', 'the first stage: the bucket and both log groups, no endpoint'),
    ('S65', 'infra/image-trial.ts',
     '    const logGroups = new Map<ModelKey, logs.LogGroup>(\n      MODEL_KEYS.map((key) => [',
     '    const logGroups = new Map<ModelKey, logs.LogGroup>(\n      models.map(({ key }) => [',
     'test', "a failed endpoint leaves its logs, made with the bucket"),
    ('S66', 'infra/image-trial.ts',
     "SAGEMAKER_MODEL_SERVER_TIMEOUT: '3600'", "SAGEMAKER_MODEL_SERVER_TIMEOUT: '60'",
     'test', 'each model: the pinned container, its weights, no network'),
    ('S67', 'trial/run.ts',
     "for (const prefix of ['in', 'out', 'fail'])", "for (const prefix of ['in', 'out'])",
     'test', 'the run deletes its requests, results and failures when it ends'),
    ('S68', 'trial/run.ts',
     '    await cleanup(t).catch(() => undefined);\n    throw error;', '    throw error;',
     'test', 'a stopped run deletes them too, reporting its own stop'),
    ('S69', 'trial/run.ts',
     '    await cleanup(t).catch(() => undefined);', '    await cleanup(t);',
     'test', 'a stopped run deletes them too, reporting its own stop'),
    ('S70', 'trial/run.ts',
     "    throw new Error('trial-cleanup');", '    return run;',
     'test', 'a deletion failing after a good run stops with a code'),
    ('S71', 'trial/fetch-weights.sh',
     '    staged="$key.unchecked"', '    staged="$key"',
     'test', 'weights: a check cut short leaves nothing a rerun would keep'),
    ('S72', 'trial/fetch-weights.sh',
     '    aws s3 rm "s3://$bucket/$key.unchecked" --region eu-north-1 --only-show-errors\n', '',
     'test', 'weights: a staging copy left beside a kept file is removed'),
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
