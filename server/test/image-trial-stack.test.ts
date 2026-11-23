// The image trial's template (D135, D136), synthesized in-process: no AWS
// credentials, no CLI and no network. The address is invented.
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import { App } from 'aws-cdk-lib';
import { Template } from 'aws-cdk-lib/assertions';
import { IMAGE, ImageTrialStack, trialSettings, type TrialSettings } from '../infra/image-trial.ts';

const EMAIL = 'owner@example.invalid';

function settingsOf(context: Record<string, unknown>): TrialSettings {
  return trialSettings((key) => context[key]);
}

function synth(context: Record<string, unknown>): { stack: ImageTrialStack; template: Template } {
  const app = new App({ context: { 'aws:cdk:version-reporting': true } });
  const stack = new ImageTrialStack(app, 'Trial', { account: undefined, settings: settingsOf(context) });
  return { stack, template: Template.fromStack(stack) };
}

const both = synth({ imageTrial: 'both', alertEmail: EMAIL });
const template = both.template;

type Resource = { Type: string; Properties?: Record<string, unknown>; DeletionPolicy?: string };
function resourcesOf(t: Template): Resource[] {
  return Object.values(t.toJSON()['Resources'] as Record<string, Resource>);
}
function ofType(t: Template, type: string): Resource[] {
  return resourcesOf(t).filter((r) => r.Type === type);
}
function byEndpoint(type: string, name: string): Resource {
  const found = ofType(template, type).filter((r) => JSON.stringify(r).includes(name));
  assert.equal(found.length, 1, `${type} ${name}`);
  return found[0] as Resource;
}

test('the trial: these resources and no others', () => {
  const two = (type: string): string[] => [type, type];
  const four = (type: string): string[] => [...two(type), ...two(type)];
  assert.deepEqual(resourcesOf(template).map((r) => r.Type).sort(), [
    ...two('AWS::ApplicationAutoScaling::ScalableTarget'),
    ...four('AWS::ApplicationAutoScaling::ScalingPolicy'),
    'AWS::Budgets::Budget',
    ...four('AWS::CloudWatch::Alarm'),
    'AWS::IAM::Policy',
    'AWS::IAM::Role',
    ...two('AWS::Logs::LogGroup'),
    'AWS::S3::Bucket',
    'AWS::S3::BucketPolicy',
    ...two('AWS::SageMaker::Endpoint'),
    ...two('AWS::SageMaker::EndpointConfig'),
    ...two('AWS::SageMaker::Model'),
  ]);
});

test('the trial: eu-north-1, destroyable, no version reporting', () => {
  assert.equal(both.stack.region, 'eu-north-1');
  assert.equal(both.stack.terminationProtection, false);
  assert.equal(template.toJSON()['Metadata'], undefined);
  assert.equal(JSON.stringify(template.toJSON()).includes('AWS::CDK::Metadata'), false);
});

test('the bucket: private, encrypted, TLS only, no logging or versions', () => {
  template.hasResource('AWS::S3::Bucket', {
    DeletionPolicy: 'Delete',
    UpdateReplacePolicy: 'Delete',
    Properties: {
      PublicAccessBlockConfiguration: {
        BlockPublicAcls: true,
        BlockPublicPolicy: true,
        IgnorePublicAcls: true,
        RestrictPublicBuckets: true,
      },
      BucketEncryption: {
        ServerSideEncryptionConfiguration: [{ ServerSideEncryptionByDefault: { SSEAlgorithm: 'AES256' } }],
      },
    },
  });
  const props = ofType(template, 'AWS::S3::Bucket')[0]?.Properties ?? {};
  assert.equal(props['LoggingConfiguration'], undefined);
  assert.equal(props['VersioningConfiguration'], undefined);
  assert.equal(props['BucketName'], undefined);
  const policy = JSON.stringify(ofType(template, 'AWS::S3::BucketPolicy')[0]?.Properties);
  assert.match(policy, /"aws:SecureTransport":"false"/);
  assert.match(policy, /"Effect":"Deny"/);
});

test('requests and results deleted within a day; the weights kept', () => {
  const rules = (ofType(template, 'AWS::S3::Bucket')[0]?.Properties?.['LifecycleConfiguration'] as {
    Rules: Record<string, unknown>[];
  }).Rules;
  assert.deepEqual(rules, [
    { Prefix: 'in/', ExpirationInDays: 1, Status: 'Enabled' },
    { Prefix: 'out/', ExpirationInDays: 1, Status: 'Enabled' },
    { Prefix: 'fail/', ExpirationInDays: 1, Status: 'Enabled' },
    { AbortIncompleteMultipartUpload: { DaysAfterInitiation: 1 }, Status: 'Enabled' },
  ]);
});

test('each model: the pinned container, its weights, no network', () => {
  for (const key of ['flux', 'sdxl']) {
    const model = ofType(template, 'AWS::SageMaker::Model').filter((r) =>
      JSON.stringify(r).includes(`/models/${key}/`),
    );
    assert.equal(model.length, 1, key);
    const props = model[0]?.Properties ?? {};
    assert.equal(props['EnableNetworkIsolation'], true);
    const container = props['PrimaryContainer'] as Record<string, unknown>;
    assert.equal(container['Image'], IMAGE);
    assert.deepEqual(container['Environment'], { HF_HUB_OFFLINE: '1' });
    const source = (container['ModelDataSource'] as { S3DataSource: Record<string, unknown> }).S3DataSource;
    assert.equal(source['S3DataType'], 'S3Prefix');
    assert.equal(source['CompressionType'], 'None');
  }
  assert.equal(
    IMAGE,
    '763104351884.dkr.ecr.eu-north-1.amazonaws.com/huggingface-pytorch-inference:' +
      '2.6.0-transformers5.5.3-gpu-py312-cu124-ubuntu22.04',
  );
});

test('FLUX on g6e.xlarge, SDXL on g6.xlarge, one instance, asynchronous', () => {
  const expected: Record<string, string> = { flux: 'ml.g6e.xlarge', sdxl: 'ml.g6.xlarge' };
  for (const [key, instance] of Object.entries(expected)) {
    const config = ofType(template, 'AWS::SageMaker::EndpointConfig').filter((r) =>
      JSON.stringify(r).includes(`/out/${key}/`),
    );
    assert.equal(config.length, 1, key);
    const props = config[0]?.Properties ?? {};
    const variants = props['ProductionVariants'] as Record<string, unknown>[];
    assert.equal(variants.length, 1);
    assert.equal(variants[0]?.['InstanceType'], instance);
    assert.equal(variants[0]?.['InitialInstanceCount'], 1);
    assert.equal(variants[0]?.['VariantName'], 'main');
    assert.equal(variants[0]?.['ModelDataDownloadTimeoutInSeconds'], 1800);
    assert.equal(variants[0]?.['ContainerStartupHealthCheckTimeoutInSeconds'], 1800);
    const async = props['AsyncInferenceConfig'] as Record<string, Record<string, unknown>>;
    assert.deepEqual(async['ClientConfig'], { MaxConcurrentInvocationsPerInstance: 1 });
    assert.match(JSON.stringify(async['OutputConfig']?.['S3FailurePath']), new RegExp(`/fail/${key}/`));
    assert.equal(async['OutputConfig']?.['NotificationConfig'], undefined);
    assert.equal(async['OutputConfig']?.['KmsKeyId'], undefined);
  }
  const names = ofType(template, 'AWS::SageMaker::Endpoint').map((r) => r.Properties?.['EndpointName']).sort();
  assert.deepEqual(names, ['souldreams-trial-flux', 'souldreams-trial-sdxl']);
});

test('scaling: from none to one on a waiting request', () => {
  for (const name of ['souldreams-trial-flux', 'souldreams-trial-sdxl']) {
    const target = byEndpoint('AWS::ApplicationAutoScaling::ScalableTarget', name).Properties ?? {};
    assert.equal(target['MinCapacity'], 0);
    assert.equal(target['MaxCapacity'], 1);
    assert.equal(target['ResourceId'], `endpoint/${name}/variant/main`);
    assert.match(JSON.stringify(target['RoleARN']), /AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint/);
    const wake = byEndpoint('AWS::ApplicationAutoScaling::ScalingPolicy', `${name}-wake`).Properties ?? {};
    assert.deepEqual(wake['StepScalingPolicyConfiguration'], {
      AdjustmentType: 'ExactCapacity',
      Cooldown: 60,
      MetricAggregationType: 'Maximum',
      StepAdjustments: [{ MetricIntervalLowerBound: 0, ScalingAdjustment: 1 }],
    });
  }
  const alarms = ofType(template, 'AWS::CloudWatch::Alarm').filter(
    (r) => r.Properties?.['MetricName'] === 'HasBacklogWithoutCapacity',
  );
  assert.equal(alarms.length, 2);
  for (const alarm of alarms) {
    assert.equal(alarm.Properties?.['Threshold'], 0.5);
    assert.equal(alarm.Properties?.['ComparisonOperator'], 'GreaterThanThreshold');
    assert.equal(alarm.Properties?.['EvaluationPeriods'], 1);
    assert.equal(alarm.Properties?.['Period'], 60);
    assert.equal(alarm.Properties?.['TreatMissingData'], 'notBreaching');
    assert.match(JSON.stringify(alarm.Properties?.['AlarmActions']), /Wake/);
  }
});

function idleAlarms(t: Template): Resource[] {
  return ofType(t, 'AWS::CloudWatch::Alarm').filter((r) => r.Properties?.['MetricName'] === 'ApproximateBacklogSize');
}

test('scaling: to none after 10 idle minutes', () => {
  for (const name of ['souldreams-trial-flux', 'souldreams-trial-sdxl']) {
    const idle = byEndpoint('AWS::ApplicationAutoScaling::ScalingPolicy', `${name}-idle`).Properties ?? {};
    assert.deepEqual(idle['StepScalingPolicyConfiguration'], {
      AdjustmentType: 'ExactCapacity',
      Cooldown: 60,
      MetricAggregationType: 'Maximum',
      StepAdjustments: [{ MetricIntervalUpperBound: 0, ScalingAdjustment: 0 }],
    });
  }
  const alarms = idleAlarms(template);
  assert.equal(alarms.length, 2);
  for (const alarm of alarms) {
    assert.equal(alarm.Properties?.['Namespace'], 'AWS/SageMaker');
    assert.equal(alarm.Properties?.['Statistic'], 'Maximum');
    assert.equal(alarm.Properties?.['Threshold'], 0.5);
    assert.equal(alarm.Properties?.['ComparisonOperator'], 'LessThanThreshold');
    assert.equal(alarm.Properties?.['EvaluationPeriods'], 10);
    assert.equal(alarm.Properties?.['DatapointsToAlarm'], 10);
    assert.equal(alarm.Properties?.['Period'], 60);
    assert.equal(alarm.Properties?.['TreatMissingData'], 'breaching');
    assert.match(JSON.stringify(alarm.Properties?.['AlarmActions']), /Idle/);
  }
});

test('the idle minutes come from the context', () => {
  const two = synth({ imageTrial: 'sdxl', alertEmail: EMAIL, idleMinutes: '2' }).template;
  const alarms = idleAlarms(two);
  assert.equal(alarms.length, 1);
  assert.equal(alarms[0]?.Properties?.['EvaluationPeriods'], 2);
  assert.equal(alarms[0]?.Properties?.['DatapointsToAlarm'], 2);
});

test('the logs: made first, kept 1 day, gone with the stack', () => {
  for (const name of ['souldreams-trial-flux', 'souldreams-trial-sdxl']) {
    template.hasResource('AWS::Logs::LogGroup', {
      Properties: { LogGroupName: `/aws/sagemaker/Endpoints/${name}`, RetentionInDays: 1 },
      DeletionPolicy: 'Delete',
    });
  }
  const json = template.toJSON()['Resources'] as Record<string, { Type: string; DependsOn?: string[] }>;
  for (const endpoint of Object.values(json).filter((r) => r.Type === 'AWS::SageMaker::Endpoint')) {
    const logs = (endpoint.DependsOn ?? []).filter((d) => json[d]?.Type === 'AWS::Logs::LogGroup');
    assert.equal(logs.length, 1);
  }
});

test("the models' role: its prefixes, its logs, the container, nothing else", () => {
  template.hasResourceProperties('AWS::IAM::Role', {
    AssumeRolePolicyDocument: {
      Statement: [{ Action: 'sts:AssumeRole', Effect: 'Allow', Principal: { Service: 'sagemaker.amazonaws.com' } }],
    },
  });
  const role = ofType(template, 'AWS::IAM::Role')[0]?.Properties ?? {};
  assert.equal(role['ManagedPolicyArns'], undefined);
  assert.equal(role['Policies'], undefined);
  const statements = (
    ofType(template, 'AWS::IAM::Policy')[0]?.Properties?.['PolicyDocument'] as {
      Statement: { Action: string | string[]; Resource: unknown }[];
    }
  ).Statement;
  const actions = statements.flatMap((s) => (Array.isArray(s.Action) ? s.Action : [s.Action])).sort();
  assert.deepEqual(actions, [
    'ecr:BatchCheckLayerAvailability',
    'ecr:BatchGetImage',
    'ecr:GetAuthorizationToken',
    'ecr:GetDownloadUrlForLayer',
    'logs:CreateLogStream',
    'logs:CreateLogStream',
    'logs:PutLogEvents',
    'logs:PutLogEvents',
    's3:GetObject',
    's3:ListBucket',
    's3:PutObject',
  ]);
  const text = (s: { Resource: unknown }): string => JSON.stringify(s.Resource);
  for (const s of statements) {
    const only = Array.isArray(s.Action) ? s.Action : [s.Action];
    if (only.includes('ecr:GetAuthorizationToken')) {
      assert.equal(s.Resource, '*');
    } else {
      assert.notEqual(s.Resource, '*');
    }
    if (only.includes('s3:GetObject')) {
      assert.match(text(s), /\/models\/\*/);
      assert.match(text(s), /\/in\/\*/);
      assert.doesNotMatch(text(s), /\/out\/|\/fail\//);
    }
    if (only.includes('s3:PutObject')) {
      assert.match(text(s), /\/out\/\*/);
      assert.match(text(s), /\/fail\/\*/);
      assert.doesNotMatch(text(s), /\/models\/|\/in\//);
    }
    if (only.includes('ecr:BatchGetImage')) {
      assert.match(text(s), /763104351884:repository\/huggingface-pytorch-inference/);
    }
  }
});

test('the budget: USD 30 a month, three emails to one address', () => {
  const budget = ofType(template, 'AWS::Budgets::Budget')[0]?.Properties ?? {};
  assert.deepEqual(budget['Budget'], {
    BudgetName: 'souldreams-image-trial',
    BudgetType: 'COST',
    TimeUnit: 'MONTHLY',
    BudgetLimit: { Amount: 30, Unit: 'USD' },
  });
  const notes = budget['NotificationsWithSubscribers'] as {
    Notification: Record<string, unknown>;
    Subscribers: unknown[];
  }[];
  assert.deepEqual(
    notes.map((n) => [n.Notification['NotificationType'], n.Notification['Threshold']]),
    [
      ['ACTUAL', 50],
      ['ACTUAL', 100],
      ['FORECASTED', 100],
    ],
  );
  for (const n of notes) {
    assert.deepEqual(n.Subscribers, [{ SubscriptionType: 'EMAIL', Address: EMAIL }]);
  }
});

test("one output, the bucket's name", () => {
  assert.deepEqual(Object.keys(template.toJSON()['Outputs'] as object), ['BucketName']);
});

test('the first stage: the bucket and the budget, no endpoint', () => {
  const first = synth({ imageTrial: 'bucket', alertEmail: EMAIL }).template;
  assert.deepEqual(resourcesOf(first).map((r) => r.Type).sort(), [
    'AWS::Budgets::Budget',
    'AWS::S3::Bucket',
    'AWS::S3::BucketPolicy',
  ]);
});

test("D136's fallback: FLUX in 8 bits on g6.xlarge, alone", () => {
  const fallback = synth({ imageTrial: 'flux', alertEmail: EMAIL, fluxEightBit: 'yes' }).template;
  assert.equal(ofType(fallback, 'AWS::SageMaker::Endpoint').length, 1);
  const variants = ofType(fallback, 'AWS::SageMaker::EndpointConfig')[0]?.Properties?.['ProductionVariants'] as {
    InstanceType: string;
  }[];
  assert.equal(variants[0]?.InstanceType, 'ml.g6.xlarge');
  const container = ofType(fallback, 'AWS::SageMaker::Model')[0]?.Properties?.['PrimaryContainer'] as {
    Environment: unknown;
  };
  assert.deepEqual(container.Environment, { HF_HUB_OFFLINE: '1', TRIAL_EIGHT_BIT: 'yes' });
});

test('the settings refuse what they do not know', () => {
  const ok = { imageTrial: 'both', alertEmail: EMAIL };
  assert.throws(() => settingsOf({ ...ok, imageTrial: 'yes' }), { message: 'trial-models' });
  assert.throws(() => settingsOf({ ...ok, alertEmail: undefined }), { message: 'trial-email' });
  assert.throws(() => settingsOf({ ...ok, alertEmail: 'owner' }), { message: 'trial-email' });
  assert.throws(() => settingsOf({ ...ok, idleMinutes: '1' }), { message: 'trial-idle' });
  assert.throws(() => settingsOf({ ...ok, idleMinutes: '61' }), { message: 'trial-idle' });
  assert.throws(() => settingsOf({ ...ok, idleMinutes: 'ten' }), { message: 'trial-idle' });
  assert.throws(() => settingsOf({ ...ok, fluxEightBit: 'no' }), { message: 'trial-eight-bit' });
  assert.equal(settingsOf(ok).idleMinutes, 10);
  assert.equal(settingsOf({ ...ok, idleMinutes: 60 }).idleMinutes, 60);
});

const APP = fileURLToPath(new URL('../infra/app.ts', import.meta.url));

// The stacks the app writes, run as the CLI would, into its own folder.
function stacksOf(context: Record<string, unknown>): string[] {
  const out = mkdtempSync(join(tmpdir(), 'trial-app-'));
  try {
    const env = {
      PATH: process.env['PATH'] ?? '',
      TMPDIR: tmpdir(),
      CDK_OUTDIR: out,
      CDK_CONTEXT_JSON: JSON.stringify(context),
    };
    const run = spawnSync(process.execPath, [APP], { env, encoding: 'utf8' });
    assert.equal(run.status, 0, run.stderr);
    const manifest = JSON.parse(readFileSync(join(out, 'manifest.json'), 'utf8')) as {
      artifacts: Record<string, { type: string }>;
    };
    return Object.entries(manifest.artifacts)
      .filter(([, a]) => a.type === 'aws:cloudformation:stack')
      .map(([name]) => name)
      .sort();
  } finally {
    rmSync(out, { recursive: true, force: true });
  }
}

test('the app makes the trial only when asked', () => {
  assert.deepEqual(stacksOf({}), ['SoulDreamsServer']);
  assert.deepEqual(stacksOf({ imageTrial: 'both', alertEmail: EMAIL }), ['SoulDreamsImageTrial', 'SoulDreamsServer']);
});
