// The image trial (D135, D136): open image models on SageMaker
// asynchronous inference in eu-north-1, each endpoint at most one
// instance, scaled to zero after its idle minutes, its requests and
// results in a private bucket that deletes them within a day, and a
// budget alarm. A trial: the owner deploys it, runs it and destroys it
// (docs/plans/image-trial.md). Nothing here is used by the server.
import { CfnOutput, Duration, RemovalPolicy, Stack } from 'aws-cdk-lib';
import * as appscaling from 'aws-cdk-lib/aws-applicationautoscaling';
import * as budgets from 'aws-cdk-lib/aws-budgets';
import * as cloudwatch from 'aws-cdk-lib/aws-cloudwatch';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as logs from 'aws-cdk-lib/aws-logs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as sagemaker from 'aws-cdk-lib/aws-sagemaker';
import type { Construct } from 'constructs';
import { REGION } from './stack.ts';

// AWS's Hugging Face inference container (diffusers 0.38.0, PyTorch 2.6,
// CUDA 12.4), from AWS's own registry in eu-north-1, by exact tag.
export const IMAGE_ACCOUNT = '763104351884';
export const IMAGE_REPOSITORY = 'huggingface-pytorch-inference';
export const IMAGE_TAG = '2.6.0-transformers5.5.3-gpu-py312-cu124-ubuntu22.04';
export const IMAGE = `${IMAGE_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE_REPOSITORY}:${IMAGE_TAG}`;

export const VARIANT = 'main';
export const BUDGET_USD = 30;
// The prefixes deleted within a day (D135 item 2). The weights, under
// models/, stay until the teardown empties the bucket.
export const SHORT_LIVED = ['in/', 'out/', 'fail/'] as const;

export type ModelKey = 'flux' | 'sdxl';

export interface TrialModel {
  readonly key: ModelKey;
  readonly instanceType: string;
  /** D136's fallback: FLUX in 8 bits on the smaller GPU. */
  readonly eightBit: boolean;
}

export interface TrialSettings {
  readonly models: readonly TrialModel[];
  readonly alertEmail: string;
  readonly idleMinutes: number;
}

export function endpointName(key: ModelKey): string {
  return `souldreams-trial-${key}`;
}

/** The trial's settings from the CDK context, or a refusal's code. */
export function trialSettings(context: (key: string) => unknown): TrialSettings {
  // 'bucket' first: the bucket and the budget alone, so the weights can
  // go in before any endpoint loads them.
  const which = context('imageTrial');
  const keys: ModelKey[] | undefined =
    which === 'both'
      ? ['flux', 'sdxl']
      : which === 'flux' || which === 'sdxl'
        ? [which]
        : which === 'bucket'
          ? []
          : undefined;
  if (keys === undefined) {
    throw new Error('trial-models');
  }
  const email = context('alertEmail');
  if (typeof email !== 'string' || !/^[^@\s]+@[^@\s]+$/.test(email)) {
    throw new Error('trial-email');
  }
  const idleRaw = context('idleMinutes');
  const idle = idleRaw === undefined ? 10 : Number(idleRaw);
  if (!Number.isInteger(idle) || idle < 2 || idle > 60) {
    throw new Error('trial-idle');
  }
  const eightBitRaw = context('fluxEightBit');
  if (eightBitRaw !== undefined && eightBitRaw !== 'yes') {
    throw new Error('trial-eight-bit');
  }
  const eightBit = eightBitRaw === 'yes';
  return { models: keys.map((key) => trialModel(key, eightBit)), alertEmail: email, idleMinutes: idle };
}

/** FLUX on g6e.xlarge, or in 8 bits on g6.xlarge (D136); SDXL on g6.xlarge. */
export function trialModel(key: ModelKey, eightBit: boolean): TrialModel {
  return key === 'flux'
    ? { key, instanceType: eightBit ? 'ml.g6.xlarge' : 'ml.g6e.xlarge', eightBit }
    : { key, instanceType: 'ml.g6.xlarge', eightBit: false };
}

export interface ImageTrialStackProps {
  readonly account: string | undefined;
  readonly settings: TrialSettings;
}

export class ImageTrialStack extends Stack {
  constructor(scope: Construct, id: string, props: ImageTrialStackProps) {
    super(scope, id, {
      env: { account: props.account, region: REGION },
      analyticsReporting: false,
      // The teardown destroys it whole.
      terminationProtection: false,
    });
    const { models, alertEmail, idleMinutes } = props.settings;

    // No access logging, no versioning: nothing kept beyond its day.
    const bucket = new s3.Bucket(this, 'Bucket', {
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      encryption: s3.BucketEncryption.S3_MANAGED,
      enforceSSL: true,
      removalPolicy: RemovalPolicy.DESTROY,
      lifecycleRules: [
        ...SHORT_LIVED.map((prefix) => ({ prefix, expiration: Duration.days(1) })),
        { abortIncompleteMultipartUploadAfter: Duration.days(1) },
      ],
    });

    // Application Auto Scaling's own role for SageMaker, made by AWS on
    // first use; the teardown deletes it.
    const scalingRole = this.formatArn({
      service: 'iam',
      region: '',
      resource: 'role',
      resourceName:
        'aws-service-role/sagemaker.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint',
    });

    // Made with the first endpoint: the bucket's stage has none.
    let role: iam.Role | undefined;
    for (const model of models) {
      role ??= this.modelRole(bucket);
      const name = endpointName(model.key);
      // SageMaker writes here; made first so it is kept 1 day, not for
      // ever, and goes with the stack.
      const logGroup = new logs.LogGroup(this, `Logs-${model.key}`, {
        logGroupName: `/aws/sagemaker/Endpoints/${name}`,
        retention: logs.RetentionDays.ONE_DAY,
        removalPolicy: RemovalPolicy.DESTROY,
      });
      logGroup.grantWrite(role);

      const cfnModel = new sagemaker.CfnModel(this, `Model-${model.key}`, {
        executionRoleArn: role.roleArn,
        enableNetworkIsolation: true,
        primaryContainer: {
          image: IMAGE,
          modelDataSource: {
            s3DataSource: {
              s3Uri: bucket.s3UrlForObject(`models/${model.key}/`),
              s3DataType: 'S3Prefix',
              compressionType: 'None',
            },
          },
          environment: model.eightBit
            ? { HF_HUB_OFFLINE: '1', TRIAL_EIGHT_BIT: 'yes' }
            : { HF_HUB_OFFLINE: '1' },
        },
      });
      // The role's policy must exist before SageMaker checks the model.
      cfnModel.node.addDependency(role);

      const config = new sagemaker.CfnEndpointConfig(this, `Config-${model.key}`, {
        productionVariants: [
          {
            variantName: VARIANT,
            modelName: cfnModel.attrModelName,
            instanceType: model.instanceType,
            initialInstanceCount: 1,
            modelDataDownloadTimeoutInSeconds: 1800,
            containerStartupHealthCheckTimeoutInSeconds: 1800,
          },
        ],
        asyncInferenceConfig: {
          outputConfig: {
            s3OutputPath: bucket.s3UrlForObject(`out/${model.key}/`),
            s3FailurePath: bucket.s3UrlForObject(`fail/${model.key}/`),
          },
          clientConfig: { maxConcurrentInvocationsPerInstance: 1 },
        },
      });

      const endpoint = new sagemaker.CfnEndpoint(this, `Endpoint-${model.key}`, {
        endpointName: name,
        endpointConfigName: config.attrEndpointConfigName,
      });
      endpoint.node.addDependency(logGroup);

      const target = new appscaling.CfnScalableTarget(this, `Scaling-${model.key}`, {
        serviceNamespace: 'sagemaker',
        resourceId: `endpoint/${name}/variant/${VARIANT}`,
        scalableDimension: 'sagemaker:variant:DesiredInstanceCount',
        minCapacity: 0,
        maxCapacity: 1,
        roleArn: scalingRole,
      });
      target.addDependency(endpoint);

      // A request waiting with no instance: one instance.
      const wake = new appscaling.CfnScalingPolicy(this, `Wake-${model.key}`, {
        policyName: `${name}-wake`,
        policyType: 'StepScaling',
        scalingTargetId: target.ref,
        stepScalingPolicyConfiguration: {
          adjustmentType: 'ExactCapacity',
          cooldown: 60,
          metricAggregationType: 'Maximum',
          stepAdjustments: [{ metricIntervalLowerBound: 0, scalingAdjustment: 1 }],
        },
      });
      // Nothing waiting or in progress for the idle minutes: none.
      const idle = new appscaling.CfnScalingPolicy(this, `Idle-${model.key}`, {
        policyName: `${name}-idle`,
        policyType: 'StepScaling',
        scalingTargetId: target.ref,
        stepScalingPolicyConfiguration: {
          adjustmentType: 'ExactCapacity',
          cooldown: 60,
          metricAggregationType: 'Maximum',
          stepAdjustments: [{ metricIntervalUpperBound: 0, scalingAdjustment: 0 }],
        },
      });

      const metric = (metricName: string): cloudwatch.Metric =>
        new cloudwatch.Metric({
          namespace: 'AWS/SageMaker',
          metricName,
          dimensionsMap: { EndpointName: name },
          statistic: 'Maximum',
          period: Duration.minutes(1),
        });
      new cloudwatch.Alarm(this, `WakeAlarm-${model.key}`, {
        metric: metric('HasBacklogWithoutCapacity'),
        threshold: 0.5,
        comparisonOperator: cloudwatch.ComparisonOperator.GREATER_THAN_THRESHOLD,
        evaluationPeriods: 1,
        datapointsToAlarm: 1,
        treatMissingData: cloudwatch.TreatMissingData.NOT_BREACHING,
      }).addAlarmAction({ bind: () => ({ alarmActionArn: wake.ref }) });
      // ApproximateBacklogSize counts requests waiting and in progress.
      // No data counts as idle, so an endpoint never asked scales in too.
      new cloudwatch.Alarm(this, `IdleAlarm-${model.key}`, {
        metric: metric('ApproximateBacklogSize'),
        threshold: 0.5,
        comparisonOperator: cloudwatch.ComparisonOperator.LESS_THAN_THRESHOLD,
        evaluationPeriods: idleMinutes,
        datapointsToAlarm: idleMinutes,
        treatMissingData: cloudwatch.TreatMissingData.BREACHING,
      }).addAlarmAction({ bind: () => ({ alarmActionArn: idle.ref }) });
    }

    // The whole account's month, checked by AWS up to three times a day:
    // a warning after the fact, not a stop (D135 item 3).
    new budgets.CfnBudget(this, 'Budget', {
      budget: {
        budgetName: 'souldreams-image-trial',
        budgetType: 'COST',
        timeUnit: 'MONTHLY',
        budgetLimit: { amount: BUDGET_USD, unit: 'USD' },
      },
      notificationsWithSubscribers: (
        [
          ['ACTUAL', 50],
          ['ACTUAL', 100],
          ['FORECASTED', 100],
        ] as const
      ).map(([notificationType, threshold]) => ({
        notification: {
          notificationType,
          comparisonOperator: 'GREATER_THAN',
          threshold,
          thresholdType: 'PERCENTAGE',
        },
        subscribers: [{ subscriptionType: 'EMAIL', address: alertEmail }],
      })),
    });

    new CfnOutput(this, 'BucketName', { value: bucket.bucketName });
  }

  /** The models' role: their weights and requests, their results, their logs, the container. */
  private modelRole(bucket: s3.Bucket): iam.Role {
    const role = new iam.Role(this, 'Role', {
      assumedBy: new iam.ServicePrincipal('sagemaker.amazonaws.com'),
    });
    role.addToPrincipalPolicy(
      new iam.PolicyStatement({ actions: ['s3:ListBucket'], resources: [bucket.bucketArn] }),
    );
    role.addToPrincipalPolicy(
      new iam.PolicyStatement({
        actions: ['s3:GetObject'],
        resources: [bucket.arnForObjects('models/*'), bucket.arnForObjects('in/*')],
      }),
    );
    role.addToPrincipalPolicy(
      new iam.PolicyStatement({
        actions: ['s3:PutObject'],
        resources: [bucket.arnForObjects('out/*'), bucket.arnForObjects('fail/*')],
      }),
    );
    role.addToPrincipalPolicy(
      new iam.PolicyStatement({ actions: ['ecr:GetAuthorizationToken'], resources: ['*'] }),
    );
    role.addToPrincipalPolicy(
      new iam.PolicyStatement({
        actions: ['ecr:BatchCheckLayerAvailability', 'ecr:GetDownloadUrlForLayer', 'ecr:BatchGetImage'],
        resources: [
          this.formatArn({ service: 'ecr', account: IMAGE_ACCOUNT, resource: 'repository', resourceName: IMAGE_REPOSITORY }),
        ],
      }),
    );
    return role;
  }
}
