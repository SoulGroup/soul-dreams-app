// The CDK app, run by cdk.json. `npm run build` first: the stack takes
// its code from dist/src. The image trial's stack exists only when the
// owner passes `-c imageTrial=...` (docs/plans/image-trial.md).
import { fileURLToPath } from 'node:url';
import { App } from 'aws-cdk-lib';
import { pickAccount } from './account.ts';
import { ImageTrialStack, trialSettings } from './image-trial.ts';
import { ServerStack } from './stack.ts';

const app = new App();
const account = pickAccount(app.node.tryGetContext('account'), process.env['CDK_DEFAULT_ACCOUNT']);
new ServerStack(app, 'SoulDreamsServer', {
  account,
  codeDir: fileURLToPath(new URL('../dist/src/', import.meta.url)),
});
if (app.node.tryGetContext('imageTrial') !== undefined) {
  new ImageTrialStack(app, 'SoulDreamsImageTrial', {
    account,
    settings: trialSettings((key) => app.node.tryGetContext(key)),
  });
}
