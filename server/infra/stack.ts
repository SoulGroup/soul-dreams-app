// The server's AWS infrastructure (D41, D42; head's message 14; D71): one
// Lambda in eu-north-1 behind its own function URL, with no
// authentication of the URL's own (the beta key is checked in the code),
// its logs kept 7 days, with no access logs, no tracing, no environment
// and no identifier. It reads two SecureStrings the owner makes, and
// nothing else. No reserved concurrency yet (D71 Q12: the account's
// quota must allow it first; a first-deploy checklist line returns it).
import { CfnOutput, Duration, RemovalPolicy, Stack } from 'aws-cdk-lib';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as logs from 'aws-cdk-lib/aws-logs';
import type { Construct } from 'constructs';
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
      // A cold start, then Parameter Store, then Soniox (D71 Q20).
      timeout: Duration.seconds(10),
    });
    const url = fn.addFunctionUrl({ authType: lambda.FunctionUrlAuthType.NONE });
    // The owner reads the address after the deploy, for app/lib/core/hosts.dart.
    new CfnOutput(this, 'Url', { value: url.url });
  }
}
