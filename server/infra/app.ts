// The CDK app, run by cdk.json. `npm run build` first: the stack takes
// its code from dist/src.
import { fileURLToPath } from 'node:url';
import { App } from 'aws-cdk-lib';
import { pickAccount } from './account.ts';
import { ServerStack } from './stack.ts';

const app = new App();
new ServerStack(app, 'SoulDreamsServer', {
  account: pickAccount(app.node.tryGetContext('account'), process.env['CDK_DEFAULT_ACCOUNT']),
  codeDir: fileURLToPath(new URL('../dist/src/', import.meta.url)),
});
