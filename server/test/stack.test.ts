// The template (D41, D42), synthesized in-process: no AWS credentials, no
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
    'AWS::ApiGatewayV2::Api',
    'AWS::ApiGatewayV2::Integration',
    'AWS::ApiGatewayV2::Route',
    'AWS::ApiGatewayV2::Stage',
    'AWS::IAM::Policy',
    'AWS::IAM::Role',
    'AWS::Lambda::Function',
    'AWS::Lambda::Permission',
    'AWS::Logs::LogGroup',
  ]);
});

test('eu-north-1, termination protection on', () => {
  assert.equal(stack.region, 'eu-north-1');
  assert.equal(stack.terminationProtection, true);
});

test('Node 24 on arm64, its own handler', () => {
  template.hasResourceProperties('AWS::Lambda::Function', {
    Runtime: 'nodejs24.x',
    Architectures: ['arm64'],
    Handler: 'handler.handler',
  });
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

test('no environment, no tracing', () => {
  const props = only('AWS::Lambda::Function').Properties ?? {};
  assert.equal(props['Environment'], undefined);
  assert.equal(props['TracingConfig'], undefined);
});

test('no access logs, no CORS, no authorizer', () => {
  assert.equal(only('AWS::ApiGatewayV2::Stage').Properties?.['AccessLogSettings'], undefined);
  assert.equal(only('AWS::ApiGatewayV2::Api').Properties?.['CorsConfiguration'], undefined);
  assert.equal(only('AWS::ApiGatewayV2::Route').Properties?.['AuthorizerId'], undefined);
});

test('the role writes to its own log group only', () => {
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
