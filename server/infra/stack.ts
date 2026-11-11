// The server's AWS infrastructure (D41, D42): one Lambda behind an HTTP
// API in eu-north-1, its logs kept 7 days, with no access logs, no
// tracing, no environment and no identifier. Nothing is deployed in
// branch 4; test/stack.test.ts proves the template.
import { RemovalPolicy, Stack } from 'aws-cdk-lib';
import { HttpApi } from 'aws-cdk-lib/aws-apigatewayv2';
import { HttpLambdaIntegration } from 'aws-cdk-lib/aws-apigatewayv2-integrations';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as logs from 'aws-cdk-lib/aws-logs';
import type { Construct } from 'constructs';

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
    });
    new HttpApi(this, 'Api', {
      defaultIntegration: new HttpLambdaIntegration('Handler', fn),
    });
  }
}
