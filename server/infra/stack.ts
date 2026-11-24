// The server's AWS infrastructure (D41, D42; head's message 14; D71; D152):
// one Lambda in eu-north-1 behind its own function URL, with no
// authentication of the URL's own (the beta key is checked in the code),
// its logs kept 7 days, with no access logs, no tracing and no identifier;
// its one variable is the feedback bucket's name. It reads two SecureStrings
// the owner makes, and puts feedback in its bucket, and nothing else. No
// reserved concurrency yet (D71 Q12: the account's quota must allow it
// first; a first-deploy checklist line returns it).
//
// The feedback bucket (D152 item 1): private (every public access blocked,
// no ACLs, TLS only), encrypted by S3 (SSE-S3), unversioned so a deletion is
// whole, each object deleted 90 days after it was put, with no access logs,
// inventory, replication or notification. The Lambda may only put objects;
// the owner reads and deletes them with tool/read_feedback.sh. The bucket is
// kept if the stack is ever removed, its 90 days still running.
import { CfnOutput, Duration, RemovalPolicy, Stack } from 'aws-cdk-lib';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as logs from 'aws-cdk-lib/aws-logs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import type { Construct } from 'constructs';
import { FEEDBACK_BUCKET_VARIABLE } from '../src/feedback.ts';
import { PARAMETERS } from '../src/parameter-names.ts';

export const REGION = 'eu-north-1';

export interface ServerStackProps {
  /** The workload account, or none (infra/account.ts). */
  readonly account: string | undefined;
  /** The compiled code, dist/src. */
  readonly codeDir: string;
}

export class ServerStack extends Stack {
  constructor(scope: Construct, id: string, props: ServerStackProps) {
    super(scope, id, {
      env: { account: props.account, region: REGION },
      analyticsReporting: false,
      terminationProtection: true,
    });
    const logGroup = new logs.LogGroup(this, 'Logs', {
      retention: logs.RetentionDays.ONE_WEEK,
      removalPolicy: RemovalPolicy.DESTROY,
    });
    // Only its own log group: no managed policy, which could create a
    // default log group kept for ever (D42 Q8).
    const role = new iam.Role(this, 'Role', {
      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),
    });
    logGroup.grantWrite(role);
    // The two keys, by name, and their decryption through Parameter Store
    // only (D69).
    role.addToPrincipalPolicy(
      new iam.PolicyStatement({
        actions: ['ssm:GetParameter'],
        resources: PARAMETERS.map((name) =>
          this.formatArn({ service: 'ssm', resource: 'parameter', resourceName: name.slice(1) }),
        ),
      }),
    );
    role.addToPrincipalPolicy(
      new iam.PolicyStatement({
        actions: ['kms:Decrypt'],
        resources: [this.formatArn({ service: 'kms', resource: 'key', resourceName: '*' })],
        conditions: { StringEquals: { 'kms:ViaService': `ssm.${REGION}.amazonaws.com` } },
      }),
    );
    const feedback = new s3.Bucket(this, 'Feedback', {
      encryption: s3.BucketEncryption.S3_MANAGED,
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_ENFORCED,
      enforceSSL: true,
      versioned: false,
      lifecycleRules: [{ expiration: Duration.days(90) }],
      removalPolicy: RemovalPolicy.RETAIN,
    });
    // Putting feedback, and nothing else: no read, list or delete.
    role.addToPrincipalPolicy(
      new iam.PolicyStatement({ actions: ['s3:PutObject'], resources: [feedback.arnForObjects('*')] }),
    );
    const fn = new lambda.Function(this, 'Handler', {
      runtime: lambda.Runtime.NODEJS_24_X,
      architecture: lambda.Architecture.ARM_64,
      code: lambda.Code.fromAsset(props.codeDir),
      handler: 'handler.handler',
      role,
      logGroup,
      loggingFormat: lambda.LoggingFormat.JSON,
      applicationLogLevelV2: lambda.ApplicationLogLevel.INFO,
      systemLogLevelV2: lambda.SystemLogLevel.WARN,
      // A cold start, then Parameter Store, then Soniox or S3 (D71 Q20).
      timeout: Duration.seconds(10),
      environment: { [FEEDBACK_BUCKET_VARIABLE]: feedback.bucketName },
    });
    const url = fn.addFunctionUrl({ authType: lambda.FunctionUrlAuthType.NONE });
    // The owner reads the address after the deploy, for app/lib/core/hosts.dart.
    new CfnOutput(this, 'Url', { value: url.url });
    // The owner's reading command finds the bucket by this (tool/read_feedback.sh).
    new CfnOutput(this, 'FeedbackBucket', { value: feedback.bucketName });
  }
}
