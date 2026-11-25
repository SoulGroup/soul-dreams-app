// The template (D41, D42; head's message 14; D71), synthesized in-process: no AWS credentials, no
// CLI and no network. The App carries the CLI's own context, version
// reporting on, so the stack's opt-out is what keeps the metadata out.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import { App } from 'aws-cdk-lib';
import { Match, Template } from 'aws-cdk-lib/assertions';
import { ServerStack } from '../infra/stack.ts';

const app = new App({ context: { 'aws:cdk:version-reporting': true } });
const stack = new ServerStack(app, 'Test', {
  account: undefined,
  codeDir: fileURLToPath(new URL('../dist/src/', import.meta.url)),
});
const template = Template.fromStack(stack);

type Resource = { Type: string; Properties?: Record<string, unknown> };
const resources = Object.values(template.toJSON()['Resources'] as Record<string, Resource>);

function only(type: string): Resource {
  const found = resources.filter((r) => r.Type === type);
  assert.equal(found.length, 1, type);
  return found[0] as Resource;
}

test('these resources and no others', () => {
  assert.deepEqual(resources.map((r) => r.Type).sort(), [
    'AWS::IAM::Policy',
    'AWS::IAM::Role',
    'AWS::Lambda::Function',
    'AWS::Lambda::Permission',
    'AWS::Lambda::Permission',
    'AWS::Lambda::Url',
    'AWS::Logs::LogGroup',
    'AWS::S3::Bucket',
    'AWS::S3::BucketPolicy',
  ]);
});

test('eu-north-1, termination protection on', () => {
  assert.equal(stack.region, 'eu-north-1');
  assert.equal(stack.terminationProtection, true);
});

test('Node 24 on arm64, its own handler, 60 seconds', () => {
  template.hasResourceProperties('AWS::Lambda::Function', {
    Runtime: 'nodejs24.x',
    Architectures: ['arm64'],
    Handler: 'handler.handler',
    Timeout: 60,
  });
});

test('no reserved concurrency yet (D71 Q12)', () => {
  assert.equal(only('AWS::Lambda::Function').Properties?.['ReservedConcurrentExecutions'], undefined);
});

test('logs: 7 days, JSON, application INFO, system WARN', () => {
  // The group is kept 7 days and goes with the stack (D44 c).
  template.hasResource('AWS::Logs::LogGroup', {
    Properties: { RetentionInDays: 7 },
    DeletionPolicy: 'Delete',
    UpdateReplacePolicy: 'Delete',
  });
  // The Lambda writes to the stack's own group, never one outside (D44 b).
  const groups = Object.keys(template.findResources('AWS::Logs::LogGroup'));
  assert.equal(groups.length, 1);
  template.hasResourceProperties('AWS::Lambda::Function', {
    LoggingConfig: {
      LogFormat: 'JSON',
      ApplicationLogLevel: 'INFO',
      SystemLogLevel: 'WARN',
      LogGroup: { Ref: groups[0] },
    },
  });
});

test("one variable, the feedback bucket's name; no tracing", () => {
  const props = only('AWS::Lambda::Function').Properties ?? {};
  assert.deepEqual(props['Environment'], {
    Variables: { FEEDBACK_BUCKET: { Ref: Object.keys(template.findResources('AWS::S3::Bucket'))[0] } },
  });
  assert.equal(props['TracingConfig'], undefined);
});

test('the feedback bucket: private, encrypted, unversioned, 90 days, kept', () => {
  const [bucket] = Object.values(template.findResources('AWS::S3::Bucket')) as Resource[];
  assert.deepEqual(bucket, {
    Type: 'AWS::S3::Bucket',
    Properties: {
      BucketEncryption: { ServerSideEncryptionConfiguration: [{ ServerSideEncryptionByDefault: { SSEAlgorithm: 'AES256' } }] },
      LifecycleConfiguration: { Rules: [{ ExpirationInDays: 90, Status: 'Enabled' }] },
      OwnershipControls: { Rules: [{ ObjectOwnership: 'BucketOwnerEnforced' }] },
      PublicAccessBlockConfiguration: {
        BlockPublicAcls: true,
        BlockPublicPolicy: true,
        IgnorePublicAcls: true,
        RestrictPublicBuckets: true,
      },
    },
    UpdateReplacePolicy: 'Retain',
    DeletionPolicy: 'Retain',
  });
});

test('the feedback bucket refuses any request not over TLS', () => {
  const name = Object.keys(template.findResources('AWS::S3::Bucket'))[0] ?? '';
  const ref = { 'Fn::GetAtt': [name, 'Arn'] };
  template.hasResourceProperties('AWS::S3::BucketPolicy', {
    Bucket: { Ref: name },
    PolicyDocument: {
      Statement: [
        {
          Action: 's3:*',
          Condition: { Bool: { 'aws:SecureTransport': 'false' } },
          Effect: 'Deny',
          Principal: { AWS: '*' },
          Resource: [ref, { 'Fn::Join': ['', [ref, '/*']] }],
        },
      ],
    },
  });
});

test('one function URL: no authentication of its own, no CORS', () => {
  const url = only('AWS::Lambda::Url').Properties ?? {};
  assert.deepEqual(Object.keys(url).sort(), ['AuthType', 'TargetFunctionArn']);
  assert.equal(url['AuthType'], 'NONE');
  assert.equal(resources.filter((r) => r.Type.startsWith('AWS::ApiGatewayV2::')).length, 0);
});

test('anyone may call it, through the URL only', () => {
  const permissions = resources.filter((r) => r.Type === 'AWS::Lambda::Permission').map((r) => r.Properties ?? {});
  const fn = { 'Fn::GetAtt': [Match.stringLikeRegexp('^Handler'), 'Arn'] };
  assert.deepEqual(
    permissions.map((p) => Object.keys(p).sort()),
    [
      ['Action', 'FunctionName', 'FunctionUrlAuthType', 'Principal'],
      ['Action', 'FunctionName', 'InvokedViaFunctionUrl', 'Principal'],
    ],
  );
  template.hasResourceProperties('AWS::Lambda::Permission', {
    Action: 'lambda:InvokeFunctionUrl',
    FunctionName: fn,
    FunctionUrlAuthType: 'NONE',
    Principal: '*',
  });
  template.hasResourceProperties('AWS::Lambda::Permission', {
    Action: 'lambda:InvokeFunction',
    FunctionName: fn,
    InvokedViaFunctionUrl: true,
    Principal: '*',
  });
});

test("two outputs: the URL and the feedback bucket", () => {
  const outputs = template.toJSON()['Outputs'] as Record<string, unknown>;
  assert.deepEqual(Object.keys(outputs), ['Url', 'FeedbackBucket']);
  template.hasOutput('FeedbackBucket', { Value: { Ref: Match.stringLikeRegexp('^Feedback') } });
  template.hasOutput('Url', { Value: { 'Fn::GetAtt': [Match.stringLikeRegexp('^HandlerFunctionUrl'), 'FunctionUrl'] } });
});

test('the role: its log group, the three keys, putting feedback', () => {
  assert.equal(only('AWS::IAM::Role').Properties?.['ManagedPolicyArns'], undefined);
  // No inline policy on the role either (D44 a).
  assert.equal(only('AWS::IAM::Role').Properties?.['Policies'], undefined);
  template.hasResourceProperties('AWS::IAM::Policy', {
    PolicyDocument: {
      Statement: [
        {
          Action: ['logs:CreateLogStream', 'logs:PutLogEvents'],
          Effect: 'Allow',
          Resource: { 'Fn::GetAtt': [Match.stringLikeRegexp('^Logs'), 'Arn'] },
        },
        {
          Action: 'ssm:GetParameter',
          Effect: 'Allow',
          Resource: ['beta-key', 'soniox-key', 'bfl-key'].map((name) => ({
            'Fn::Join': [
              '',
              ['arn:', { Ref: 'AWS::Partition' }, ':ssm:eu-north-1:', { Ref: 'AWS::AccountId' }, `:parameter/souldreams/${name}`],
            ],
          })),
        },
        {
          Action: 'kms:Decrypt',
          Condition: { StringEquals: { 'kms:ViaService': 'ssm.eu-north-1.amazonaws.com' } },
          Effect: 'Allow',
          Resource: {
            'Fn::Join': ['', ['arn:', { Ref: 'AWS::Partition' }, ':kms:eu-north-1:', { Ref: 'AWS::AccountId' }, ':key/*']],
          },
        },
        {
          Action: 's3:PutObject',
          Effect: 'Allow',
          Resource: {
            'Fn::Join': ['', [{ 'Fn::GetAtt': [Match.stringLikeRegexp('^Feedback'), 'Arn'] }, '/*']],
          },
        },
      ],
    },
  });
});

test('no version reporting', () => {
  assert.equal(resources.filter((r) => r.Type === 'AWS::CDK::Metadata').length, 0);
});

test('cdk.json switches off the three reports', () => {
  const cdk = JSON.parse(readFileSync(new URL('../cdk.json', import.meta.url), 'utf8'));
  assert.equal(cdk.versionReporting, false);
  assert.equal(cdk.notices, false);
  assert.equal(cdk.context['cli-telemetry'], false);
  assert.equal(cdk.app, 'node infra/app.ts');
});
