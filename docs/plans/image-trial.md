# Plan: the image trial (image-trial)

Branch `image-trial`, from `main` at `eaf0da1`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D126. Written by Claude Code (Opus) on 2026-11-22 and 2026-11-23. Governs: the owner's D135 (the
brainstorm) and D136 (on the stop `.scratch/for-build-chat/image-trial-stop.md`), with D123 (no visible AI mark on
images). Nothing in the app changes. The server's own stack (`SoulDreamsServer`) is unchanged. **Amended by Part 6 (D138), which governs where it differs.**

Markers: **[READ]** a fact read on its source page on the date given; **[ASSUMED]** believed, not proven, with what
proves it; **[ESTIMATE]** arithmetic on assumptions.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

Google withdrew its abuse-monitoring exception for ordinary accounts, so the personal night painting will run on an
open model in our own AWS account (founder-ruled). This branch builds a **trial** so the founder can choose: two open
models, each painting the same six invented scenes, with the time and the cost of each painting measured. Nothing a
dreamer says goes near it: the prompts are invented Van Gogh-like scenery, with no person and nothing from any dream.

What the owner does, in order (Part 3, Tasks 6 to 12): makes a Hugging Face read token and keeps it in Parameter
Store; deploys the trial's bucket and budget alarm; copies FLUX.1 [schnell]'s weights from Hugging Face into the bucket
in CloudShell; deploys FLUX's endpoint, which **proves ml.g6e.xlarge in eu-north-1 first** (D136); runs the trial
from his Mac, which leaves seven images and a results table in `~/Desktop/image-trial/flux/`; does the same for SDXL on
ml.g6.xlarge; reads the real g6e rate from his bill; and tears everything down, proving nothing is left.

What the founder gets: for each model, six paintings (and one more from the single-painting round) and a table:
cold start, time per painting, and the cost per painting warm, when every painting wakes the machine (idle 10
minutes measured, 2 minutes derived), six together, and a daily batch of 10, 60 or 100.

### What this branch builds

1. **The stack** `SoulDreamsImageTrial` (`server/infra/image-trial.ts`, Task 1), made by `server/infra/app.ts` only
   when the owner passes `-c imageTrial=bucket|flux|sdxl|both`; without it the app is exactly as today. In
   eu-north-1 (D135 item 2):
   - **The bucket**: all public access blocked, SSE-S3 encryption, TLS only, no access logging, no versions, a
     generated name. Requests (`in/`), results (`out/`) and failures (`fail/`) expire after 1 day, and unfinished
     uploads are dropped after 1 day. The weights (`models/`) stay until the teardown empties the bucket (Part 4, Q1).
   - **Per model** (`flux`, `sdxl`): a SageMaker model with **network isolation** (the endpoint can reach nothing),
     AWS's Hugging Face inference container by exact tag, its weights read uncompressed from `models/<model>/`; an
     endpoint configuration for **asynchronous inference** (one instance to start, at most one request at a time,
     results to `out/<model>/`, failures to `fail/<model>/`); the endpoint `souldreams-trial-<model>`; its log group
     `/aws/sagemaker/Endpoints/souldreams-trial-<model>`, made first and kept **1 day** (SageMaker's own default is
     for ever).
   - **Scaling** (D135 item 3): 0 to 1 instance. A request waiting with no instance (`HasBacklogWithoutCapacity`, 1
     minute) sets one; nothing waiting or in progress (`ApproximateBacklogSize`, which counts both [READ]) for 10
     minutes in a row sets none. No data counts as idle, so the endpoint's first instance scales in too.
   - **The models' role**: reads `models/*` and `in/*`, writes `out/*` and `fail/*`, writes its two log groups,
     pulls the one container repository; nothing else.
   - **The budget** `souldreams-image-trial`: USD 30 a month, emails at 50 % and 100 % actual and 100 % forecast, to
     the address the owner passes at deploy (never in the repository).
   - **Stages**: `bucket` (the bucket and the budget only, so the weights can go in before an endpoint loads them),
     `flux`, `sdxl`, `both`; and D136's fallback, `-c fluxEightBit=yes`, FLUX on ml.g6.xlarge in 8 bits.
2. **The serving code** (`server/trial/code/inference.py`, Task 2), run by the container from the weights' folder:
   loads the pipeline in bfloat16 **straight onto the GPU** (`device_map='cuda'`: FLUX in full precision, about 33.7
   GB, is larger than g6e.xlarge's 32 GiB of memory); takes a JSON request with the prompt, the allowed settings and
   a seed; paints with a seeded generator; answers PNG. Refusals are codes. It writes nothing anywhere. D136's
   fallback: installs the pinned `bitsandbytes` 0.50.2 wheel from the weights' folder (no network) and loads FLUX's
   transformer and its T5 encoder in 8 bits.
3. **The run** (`server/trial/measure.ts`, `server/trial/run.ts`, Task 3), on the owner's Mac with his AWS profile:
   waits for the endpoint to have no instance; sends one painting and waits for the endpoint to scale back to none;
   sends the six together and waits again; downloads every image (each checked to be a PNG); reads the scaling
   activities; writes `raw.json`, `results.json` and `results.md`. Its notes file holds codes and times only; no
   prompt is written anywhere on the Mac but the request files, deleted once sent.
4. **The weights script** (`server/trial/fetch-weights.sh`, Task 4), run by the owner in CloudShell: lists the
   pinned revision's files on Hugging Face, keeps only the pipeline's parts (no single-file copies, no fp16 copies,
   no ONNX, Flax or OpenVINO), streams each into the bucket and checks it against the hub's hash (a large file read
   back from S3, a small one before it goes up), and skips a file already there at its size, so a cut session simply
   runs again. The token is read from Parameter Store into a header file; it never reaches a command line or the
   screen.
5. **Docs** (Task 5): Status.md.

### What it does not build

No app change. No change to `SoulDreamsServer`, its Lambda or its hosts. No image mark of any kind (D123's invisible
tag belongs to the production painting, not the trial). No SD 3.5 Medium (D136). No production design: the founder's
choice comes first. No prompt from or about any dream (R2); the six scenes are invented here and are not dream text.

### The decisions, by number

| Ruling | What it settles | Where |
|---|---|---|
| D135 (1), D136 | FLUX.1 [schnell] full precision on ml.g6e.xlarge; SDXL on ml.g6.xlarge; SD 3.5 skipped | Task 1; Tasks 9 to 11 |
| D135 (1) | Each licence read on its own page; stop if commercial use in an app is not allowed: none stops | "The licences" |
| D135 (2) | eu-north-1; asynchronous; the private encrypted bucket, 1-day deletion; no prompt logged | Tasks 1, 2, 3; Task 11 |
| D135 (3) | USD 30 budget alarm; at most one instance; zero after 10 idle minutes; the teardown | Task 1; Task 12 |
| D135 (4) | The owner runs every AWS step | Tasks 6 to 12 |
| D135 (costs) | Wake-per-painting at idle 10 and 2, warm, a daily batch | Task 3; "The measures" |
| D136 | The first endpoint task proves g6e; if unsupported, FLUX in 8 bits on g6.xlarge, `bitsandbytes` pinned | Task 9; Fallback F |
| D136 | The Hugging Face token: an owner task, in Parameter Store | Task 6 |

### Decided under D91 (how to build only)

1. **A CDK stack, not a script** (the task left it to D91): it is the repository's way (`server/infra/`), it is
   tested in-process like `SoulDreamsServer`, and `cdk destroy` removes it whole. It is a second stack, made only when
   asked, so the owner's standing deploy of `SoulDreamsServer` is unchanged (with two stacks, a deploy names its
   stack).
2. **The container**: AWS's Hugging Face PyTorch inference image,
   `763104351884.dkr.ecr.eu-north-1.amazonaws.com/huggingface-pytorch-inference:2.6.0-transformers5.5.3-gpu-py312-cu124-ubuntu22.04`,
   the newest GPU tag listed [READ, aws.github.io/deep-learning-containers, available images and region
   availability (eu-north-1: 763104351884), 2026-11-22]. Its Dockerfile installs `diffusers==0.38.0`, PyTorch 2.6.0
   with CUDA 12.4, `transformers` 5.5.3 with `sentencepiece`, and the inference toolkit [READ, its
   `2.6/py3/cu124/Dockerfile.gpu`]. `diffusers` 0.38.0 has `FluxPipeline` and the SDXL pipeline, and accepts a
   pipeline-level `device_map` of `"balanced"`, the device or `"cpu"` [READ, its `pipeline_utils.py` at v0.38.0]. So
   full precision needs **no package beyond the image**.
3. **Our own `inference.py`** rather than the toolkit's default: the default loads to the CPU first (FLUX would not
   fit in 32 GiB), passes no seed, and would need D136's fallback anyway. The toolkit runs `code/inference.py` with
   `model_fn`, `input_fn`, `predict_fn` and `output_fn`, and logs only timings ("Preprocess time", "Predict time",
   "Postprocess time") [READ, its `handler_service.py`].
4. **The weights in S3, uncompressed, the endpoint with no network**: each wake loads from S3 in the region instead
   of downloading 34 GB from the internet, and the endpoint can reach nothing at all (`EnableNetworkIsolation`).
   `S3Prefix` with `CompressionType: None` [READ, SageMaker's "uncompressed model artifacts" page].
5. **The weights go in through CloudShell** in eu-north-1 [READ: CloudShell is offered there], streamed with no disk
   (its home is 1 GB): fast in the region, and nothing passes through the Mac. CloudShell ends a session after 20 to
   30 minutes without a key press [READ]; the script runs again safely.
6. **The token in Parameter Store** (D136): `/souldreams/trial/hf-token`, a SecureString on `aws/ssm`, read only by the
   weights script in CloudShell. FLUX.1 [schnell] is gated: its files need a logged-in account that has accepted the
   conditions [READ]. SDXL is not gated; the same token is sent, harmlessly.
7. **Pinned revisions**: FLUX.1 [schnell] at `169573f54945f633efbe126a40a5676b4228363c`, SDXL base 1.0 at
   `462165984030d82259a11f4367a4eed129e94a7b` [READ, the Hub's API, 2026-11-22]. The script refuses anything but a
   40-character revision.
8. **The bucket stage first**: an endpoint loads its weights the moment it is created, and the bucket comes from the
   stack. So the first deploy (`imageTrial=bucket`) makes only the bucket and the budget. D136's "first owner task
   proves g6e" therefore becomes "the first **endpoint** task": no cheaper call proves it, since only creating an
   endpoint shows whether the region serves the type [ASSUMED].
9. **Step scaling with our own alarms**, not the documented target tracking: target tracking's scale-in alarm is
   AWS's own (about 15 minutes) and cannot be set to D135's 10 [ASSUMED from AWS's target tracking behaviour]. Our
   idle alarm is 10 one-minute periods of `ApproximateBacklogSize` below 0.5; the wake alarm is one minute of
   `HasBacklogWithoutCapacity` above 0.5, as AWS documents for scaling out from zero [READ, "Autoscale an asynchronous
   endpoint"]. Thresholds of 0.5 avoid the step bounds' inclusive-or-exclusive edge at 0 and 1.
10. **The measures come from AWS's own clocks**: each result's time is its object's `LastModified` in S3; the
    billed time of a round is from the scale-out activity's start to the scale-in activity's end
    (`describe-scaling-activities`). Billing starts when the instance is requested [ASSUMED; Task 11 compares the
    measured seconds with the bill's hours].
11. **Settings**: 1024 × 1024 (both models' native size); FLUX: 4 steps, guidance 0, `max_sequence_length` 256 (its
    card [READ]); SDXL: 50 steps, guidance 5 (the library's defaults; its card shows none for the base alone [READ]).
    Each prompt's seed is `1000 + its index`, the same on both models.
12. **Prompts**: six invented scenes, each followed by "Van Gogh style oil painting, thick impasto brushstrokes, no
    people" (`measure.ts`). No literal is twelve words or more (G4).

### The licences [READ, each model's own page, 2026-11-22]

None forbids commercial use in an app, so none stops the trial (D135 item 1). For Product before anything ships
(Status banked item 170):
- **FLUX.1 [schnell]**: Apache-2.0: "can be used for personal, scientific, and commercial purposes". Gated (the
  download shares the account's contact information). Its LICENSE link gave 404; the page's licence tag is the only
  licence text read.
- **SDXL base 1.0**: CreativeML Open RAIL++-M. Commercial use and hosting allowed, but the use restrictions
  (Attachment A) must be "included as an enforceable provision" in the agreement with every user, and users told.
  Outputs: the licensor "claims no rights". Its card says "intended for research purposes only"; the licence does not.
- **SD 3.5 Medium** (skipped, D136): free below USD 1M revenue, with registration and "Powered by Stability AI"
  shown publicly.

### The measures and the price basis

Prices, on demand, USD per hour [READ, AWS Price List API, `AmazonSageMaker`, eu-north-1, published
2026-11-22T02:34:21Z, effective 2026-11-01]:
- **ml.g6.xlarge**: 1.195 (`EUN1-AsyncInf:ml.g6.xlarge`, and the same for `Host`).
- **ml.g6e.xlarge**: **no AsyncInf or Host entry for any g6e size in eu-north-1**, though the console offers it (D136).
  The trial uses its Training and Processing price, **2.7636**, because every type listed with both has equal
  training and hosting prices (ml.g6.xlarge 1.19504 and 1.195; ml.g5.xlarge 1.494 and 1.4938; in us-east-1,
  ml.g6e.xlarge 2.61 and 2.6054) [ASSUMED until Task 11 reads the bill].
- S3 in the same region: no transfer charge; storage about 48 GB for a day or two [ESTIMATE: well under USD 1].

What `results.md` shows (`measure.ts`, `costs`), with p the price per second:
- **Cold start**: the scale-out activity's start to its end (instance requested to in service).
- **Time per painting, warm**: the gap between consecutive results in the batch of six.
- **Tail**: the single painting's result to the scale-in's end (idle minutes plus AWS's alarm and shutdown delay).
- **Warm**: p × time per painting.
- **Woken for each, idle 10 minutes**: p × the single round's billed seconds (measured).
- **Woken for each, idle 2 minutes (derived)**: the same less 8 minutes. Derived, not run (Part 4, Q5).
- **Six together, measured**: p × the batch round's billed seconds ÷ 6.
- **Daily batch of N (derived)**, N = 10, 60, 100: p × (the single round's billed seconds + (N − 1) × time per
  painting) ÷ N: one wake, N paintings, one tail.

A worked example (the test's invented times, g6e): scale-out 300 s, one painting, gone 660 s after it, billed 980 s;
six paintings 5 s apart. Warm USD 0.0038; woken for each at 10 minutes USD 0.7523, at 2 minutes USD 0.3838; a daily
batch of 60 USD 0.0163 a painting.

What the whole trial may cost [ESTIMATE, revised under D140]: each endpoint runs about three wakes (the deploy's first
instance, the single round, the batch round), each a cold start plus about 11 minutes of tail. FLUX's first create
took 36 minutes (its container started 33 minutes after the create, and was in service 3 minutes later; one sample),
so a wake is about 46 minutes and a model about 2.3 hours: about USD 6 to 9 for FLUX on g6e (a capacity wait, if the
instance is billed during it, adds to that), and about USD 2 for SDXL on g6 (14 GB to copy instead of 34), with S3 and
CloudShell under USD 1. Well inside the USD 30 alarm.

### The tests (test-first, on the Mac; no AWS, no network)

- `server/test/image-trial-stack.test.ts` (17): the resources and no others; eu-north-1 and destroyable; the bucket's
  privacy, encryption, TLS, lifecycle; the container, weights and network isolation; the instance types; scaling
  out and in; the idle minutes from the context; the log groups; the role's exact permissions; the budget; the
  output; the bucket stage; D136's fallback; the context's refusals; the app makes the stack only when asked.
- `server/test/image-trial-inference.test.ts` (5), running `trial_inference_cases.py` against stand-ins for PyTorch,
  diffusers and transformers: full precision onto the GPU; a request's words, settings and seed; refusals as codes
  that never carry the words; seeded on the GPU and answered as PNG; 8 bits from the pinned wheel, offline.
- `server/test/image-trial-run.test.ts` (11): the scenes and requests; the costs, from invented times; the report;
  the command line; a round's commands (region, PNG, S3), its times from the bucket and its request files deleted; a
  failed painting; the whole run against a fake AWS CLI and clock; a result that is not a PNG; scaling not found.
- `server/test/image-trial-fetch.test.ts` (5), the script against a fake hub and a fake AWS CLI on PATH: only the
  parts' files, each checked, kept on a rerun; the token never on a command line or the screen; a large file read
  back wrong is removed; a small file unlike the hub never goes up; the arguments refused unless exact.

Server tests: 47 at the start, then 64, 69, 80, 85, 85. Server mutation rows: S31 to S63 (33 new), all caught; the
whole set `63 run, 63 caught`.

## Part 2 · Settings, packages and storage

- **No npm package** is added or changed. `server/tsconfig.json` includes `trial` (Task 3).
- **New dependencies of the trial, outside the repository** (R10: listed for the owner, Part 4 Q4): AWS's Hugging
  Face inference container (exact tag above, from AWS's registry; inside it `diffusers` 0.38.0, PyTorch 2.6.0); the
  two models' weights at the pinned revisions; for D136's fallback only, `bitsandbytes` 0.50.2, installed from its
  wheel inside the container (approved, D136); a Hugging Face account and read token; AWS CloudShell. None of them
  reaches the app or `SoulDreamsServer`.
- **New kinds of file**: none. `.ts`, `.py`, `.sh`, `.cjs` and `.json` are kinds G0 knows. No guard changes.
- **Hosts** (G9): no new host literal in the repository. Hugging Face's address appears only in the owner's
  CloudShell paste (Task 8), as the weights script's argument; the endpoints have no network (Part 4, Q3).
- **Secrets** (R5): the Hugging Face token only in Parameter Store and in a header file inside CloudShell's temporary
  folder, removed when the script ends. The budget's email is passed at deploy, never committed.
- **Storage on the phone**: none.

## Part 3 · The tasks

**How the blocks work.** Each code task's block is one patch, generated from the build that proved it (Part 5).
Apply it from the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Then run the task's checks and commit
through the hook with the message given.

Every code task ends green:
- `cd server && npm run check` prints only its header, and `npm test` passes at the count given.
- The task's rows (D126): `python3 -I -B tool/server_mutations.py` runs every row, about 7 minutes; at the task's
  commit, every row it lists is caught (the earlier rows stay caught).
- The hook prints `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `image-trial`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd server && npm run check | tail -1 && npm test 2>&1 | grep -E '^ℹ (tests|fail)')
```

Expected: nothing from `git status`; this plan's commit; `guards (tracked): all passed`; `> tsc -p tsconfig.json`;
`ℹ tests 47` and `ℹ fail 0`.

### Task 1 · The stack (D135 items 2 and 3; D136) · **Opus review**

The stack, the app's switch and the template tests; rows S31 to S46.

```
diff --git a/server/infra/app.ts b/server/infra/app.ts
--- a/server/infra/app.ts
+++ b/server/infra/app.ts
@@ -1,12 +1,21 @@
 // The CDK app, run by cdk.json. `npm run build` first: the stack takes
-// its code from dist/src.
+// its code from dist/src. The image trial's stack exists only when the
+// owner passes `-c imageTrial=...` (docs/plans/image-trial.md).
 import { fileURLToPath } from 'node:url';
 import { App } from 'aws-cdk-lib';
 import { pickAccount } from './account.ts';
+import { ImageTrialStack, trialSettings } from './image-trial.ts';
 import { ServerStack } from './stack.ts';
 
 const app = new App();
+const account = pickAccount(app.node.tryGetContext('account'), process.env['CDK_DEFAULT_ACCOUNT']);
 new ServerStack(app, 'SoulDreamsServer', {
-  account: pickAccount(app.node.tryGetContext('account'), process.env['CDK_DEFAULT_ACCOUNT']),
+  account,
   codeDir: fileURLToPath(new URL('../dist/src/', import.meta.url)),
 });
+if (app.node.tryGetContext('imageTrial') !== undefined) {
+  new ImageTrialStack(app, 'SoulDreamsImageTrial', {
+    account,
+    settings: trialSettings((key) => app.node.tryGetContext(key)),
+  });
+}
diff --git a/server/infra/image-trial.ts b/server/infra/image-trial.ts
new file mode 100644
--- /dev/null
+++ b/server/infra/image-trial.ts
@@ -0,0 +1,312 @@
+// The image trial (D135, D136): open image models on SageMaker
+// asynchronous inference in eu-north-1, each endpoint at most one
+// instance, scaled to zero after its idle minutes, its requests and
+// results in a private bucket that deletes them within a day, and a
+// budget alarm. A trial: the owner deploys it, runs it and destroys it
+// (docs/plans/image-trial.md). Nothing here is used by the server.
+import { CfnOutput, Duration, RemovalPolicy, Stack } from 'aws-cdk-lib';
+import * as appscaling from 'aws-cdk-lib/aws-applicationautoscaling';
+import * as budgets from 'aws-cdk-lib/aws-budgets';
+import * as cloudwatch from 'aws-cdk-lib/aws-cloudwatch';
+import * as iam from 'aws-cdk-lib/aws-iam';
+import * as logs from 'aws-cdk-lib/aws-logs';
+import * as s3 from 'aws-cdk-lib/aws-s3';
+import * as sagemaker from 'aws-cdk-lib/aws-sagemaker';
+import type { Construct } from 'constructs';
+import { REGION } from './stack.ts';
+
+// AWS's Hugging Face inference container (diffusers 0.38.0, PyTorch 2.6,
+// CUDA 12.4), from AWS's own registry in eu-north-1, by exact tag.
+export const IMAGE_ACCOUNT = '763104351884';
+export const IMAGE_REPOSITORY = 'huggingface-pytorch-inference';
+export const IMAGE_TAG = '2.6.0-transformers5.5.3-gpu-py312-cu124-ubuntu22.04';
+export const IMAGE = `${IMAGE_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${IMAGE_REPOSITORY}:${IMAGE_TAG}`;
+
+export const VARIANT = 'main';
+export const BUDGET_USD = 30;
+// The prefixes deleted within a day (D135 item 2). The weights, under
+// models/, stay until the teardown empties the bucket.
+export const SHORT_LIVED = ['in/', 'out/', 'fail/'] as const;
+
+export type ModelKey = 'flux' | 'sdxl';
+
+export interface TrialModel {
+  readonly key: ModelKey;
+  readonly instanceType: string;
+  /** D136's fallback: FLUX in 8 bits on the smaller GPU. */
+  readonly eightBit: boolean;
+}
+
+export interface TrialSettings {
+  readonly models: readonly TrialModel[];
+  readonly alertEmail: string;
+  readonly idleMinutes: number;
+}
+
+export function endpointName(key: ModelKey): string {
+  return `souldreams-trial-${key}`;
+}
+
+/** The trial's settings from the CDK context, or a refusal's code. */
+export function trialSettings(context: (key: string) => unknown): TrialSettings {
+  // 'bucket' first: the bucket and the budget alone, so the weights can
+  // go in before any endpoint loads them.
+  const which = context('imageTrial');
+  const keys: ModelKey[] | undefined =
+    which === 'both'
+      ? ['flux', 'sdxl']
+      : which === 'flux' || which === 'sdxl'
+        ? [which]
+        : which === 'bucket'
+          ? []
+          : undefined;
+  if (keys === undefined) {
+    throw new Error('trial-models');
+  }
+  const email = context('alertEmail');
+  if (typeof email !== 'string' || !/^[^@\s]+@[^@\s]+$/.test(email)) {
+    throw new Error('trial-email');
+  }
+  const idleRaw = context('idleMinutes');
+  const idle = idleRaw === undefined ? 10 : Number(idleRaw);
+  if (!Number.isInteger(idle) || idle < 2 || idle > 60) {
+    throw new Error('trial-idle');
+  }
+  const eightBitRaw = context('fluxEightBit');
+  if (eightBitRaw !== undefined && eightBitRaw !== 'yes') {
+    throw new Error('trial-eight-bit');
+  }
+  const eightBit = eightBitRaw === 'yes';
+  return { models: keys.map((key) => trialModel(key, eightBit)), alertEmail: email, idleMinutes: idle };
+}
+
+/** FLUX on g6e.xlarge, or in 8 bits on g6.xlarge (D136); SDXL on g6.xlarge. */
+export function trialModel(key: ModelKey, eightBit: boolean): TrialModel {
+  return key === 'flux'
+    ? { key, instanceType: eightBit ? 'ml.g6.xlarge' : 'ml.g6e.xlarge', eightBit }
+    : { key, instanceType: 'ml.g6.xlarge', eightBit: false };
+}
+
+export interface ImageTrialStackProps {
+  readonly account: string | undefined;
+  readonly settings: TrialSettings;
+}
+
+export class ImageTrialStack extends Stack {
+  constructor(scope: Construct, id: string, props: ImageTrialStackProps) {
+    super(scope, id, {
+      env: { account: props.account, region: REGION },
+      analyticsReporting: false,
+      // The teardown destroys it whole.
+      terminationProtection: false,
+    });
+    const { models, alertEmail, idleMinutes } = props.settings;
+
+    // No access logging, no versioning: nothing kept beyond its day.
+    const bucket = new s3.Bucket(this, 'Bucket', {
+      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
+      encryption: s3.BucketEncryption.S3_MANAGED,
+      enforceSSL: true,
+      removalPolicy: RemovalPolicy.DESTROY,
+      lifecycleRules: [
+        ...SHORT_LIVED.map((prefix) => ({ prefix, expiration: Duration.days(1) })),
+        { abortIncompleteMultipartUploadAfter: Duration.days(1) },
+      ],
+    });
+
+    // Application Auto Scaling's own role for SageMaker, made by AWS on
+    // first use; the teardown deletes it.
+    const scalingRole = this.formatArn({
+      service: 'iam',
+      region: '',
+      resource: 'role',
+      resourceName:
+        'aws-service-role/sagemaker.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint',
+    });
+
+    // Made with the first endpoint: the bucket's stage has none.
+    let role: iam.Role | undefined;
+    for (const model of models) {
+      role ??= this.modelRole(bucket);
+      const name = endpointName(model.key);
+      // SageMaker writes here; made first so it is kept 1 day, not for
+      // ever, and goes with the stack.
+      const logGroup = new logs.LogGroup(this, `Logs-${model.key}`, {
+        logGroupName: `/aws/sagemaker/Endpoints/${name}`,
+        retention: logs.RetentionDays.ONE_DAY,
+        removalPolicy: RemovalPolicy.DESTROY,
+      });
+      logGroup.grantWrite(role);
+
+      const cfnModel = new sagemaker.CfnModel(this, `Model-${model.key}`, {
+        executionRoleArn: role.roleArn,
+        enableNetworkIsolation: true,
+        primaryContainer: {
+          image: IMAGE,
+          modelDataSource: {
+            s3DataSource: {
+              s3Uri: bucket.s3UrlForObject(`models/${model.key}/`),
+              s3DataType: 'S3Prefix',
+              compressionType: 'None',
+            },
+          },
+          environment: model.eightBit
+            ? { HF_HUB_OFFLINE: '1', TRIAL_EIGHT_BIT: 'yes' }
+            : { HF_HUB_OFFLINE: '1' },
+        },
+      });
+      // The role's policy must exist before SageMaker checks the model.
+      cfnModel.node.addDependency(role);
+
+      const config = new sagemaker.CfnEndpointConfig(this, `Config-${model.key}`, {
+        productionVariants: [
+          {
+            variantName: VARIANT,
+            modelName: cfnModel.attrModelName,
+            instanceType: model.instanceType,
+            initialInstanceCount: 1,
+            modelDataDownloadTimeoutInSeconds: 1800,
+            containerStartupHealthCheckTimeoutInSeconds: 1800,
+          },
+        ],
+        asyncInferenceConfig: {
+          outputConfig: {
+            s3OutputPath: bucket.s3UrlForObject(`out/${model.key}/`),
+            s3FailurePath: bucket.s3UrlForObject(`fail/${model.key}/`),
+          },
+          clientConfig: { maxConcurrentInvocationsPerInstance: 1 },
+        },
+      });
+
+      const endpoint = new sagemaker.CfnEndpoint(this, `Endpoint-${model.key}`, {
+        endpointName: name,
+        endpointConfigName: config.attrEndpointConfigName,
+      });
+      endpoint.node.addDependency(logGroup);
+
+      const target = new appscaling.CfnScalableTarget(this, `Scaling-${model.key}`, {
+        serviceNamespace: 'sagemaker',
+        resourceId: `endpoint/${name}/variant/${VARIANT}`,
+        scalableDimension: 'sagemaker:variant:DesiredInstanceCount',
+        minCapacity: 0,
+        maxCapacity: 1,
+        roleArn: scalingRole,
+      });
+      target.addDependency(endpoint);
+
+      // A request waiting with no instance: one instance.
+      const wake = new appscaling.CfnScalingPolicy(this, `Wake-${model.key}`, {
+        policyName: `${name}-wake`,
+        policyType: 'StepScaling',
+        scalingTargetId: target.ref,
+        stepScalingPolicyConfiguration: {
+          adjustmentType: 'ExactCapacity',
+          cooldown: 60,
+          metricAggregationType: 'Maximum',
+          stepAdjustments: [{ metricIntervalLowerBound: 0, scalingAdjustment: 1 }],
+        },
+      });
+      // Nothing waiting or in progress for the idle minutes: none.
+      const idle = new appscaling.CfnScalingPolicy(this, `Idle-${model.key}`, {
+        policyName: `${name}-idle`,
+        policyType: 'StepScaling',
+        scalingTargetId: target.ref,
+        stepScalingPolicyConfiguration: {
+          adjustmentType: 'ExactCapacity',
+          cooldown: 60,
+          metricAggregationType: 'Maximum',
+          stepAdjustments: [{ metricIntervalUpperBound: 0, scalingAdjustment: 0 }],
+        },
+      });
+
+      const metric = (metricName: string): cloudwatch.Metric =>
+        new cloudwatch.Metric({
+          namespace: 'AWS/SageMaker',
+          metricName,
+          dimensionsMap: { EndpointName: name },
+          statistic: 'Maximum',
+          period: Duration.minutes(1),
+        });
+      new cloudwatch.Alarm(this, `WakeAlarm-${model.key}`, {
+        metric: metric('HasBacklogWithoutCapacity'),
+        threshold: 0.5,
+        comparisonOperator: cloudwatch.ComparisonOperator.GREATER_THAN_THRESHOLD,
+        evaluationPeriods: 1,
+        datapointsToAlarm: 1,
+        treatMissingData: cloudwatch.TreatMissingData.NOT_BREACHING,
+      }).addAlarmAction({ bind: () => ({ alarmActionArn: wake.ref }) });
+      // ApproximateBacklogSize counts requests waiting and in progress.
+      // No data counts as idle, so an endpoint never asked scales in too.
+      new cloudwatch.Alarm(this, `IdleAlarm-${model.key}`, {
+        metric: metric('ApproximateBacklogSize'),
+        threshold: 0.5,
+        comparisonOperator: cloudwatch.ComparisonOperator.LESS_THAN_THRESHOLD,
+        evaluationPeriods: idleMinutes,
+        datapointsToAlarm: idleMinutes,
+        treatMissingData: cloudwatch.TreatMissingData.BREACHING,
+      }).addAlarmAction({ bind: () => ({ alarmActionArn: idle.ref }) });
+    }
+
+    // The whole account's month, checked by AWS up to three times a day:
+    // a warning after the fact, not a stop (D135 item 3).
+    new budgets.CfnBudget(this, 'Budget', {
+      budget: {
+        budgetName: 'souldreams-image-trial',
+        budgetType: 'COST',
+        timeUnit: 'MONTHLY',
+        budgetLimit: { amount: BUDGET_USD, unit: 'USD' },
+      },
+      notificationsWithSubscribers: (
+        [
+          ['ACTUAL', 50],
+          ['ACTUAL', 100],
+          ['FORECASTED', 100],
+        ] as const
+      ).map(([notificationType, threshold]) => ({
+        notification: {
+          notificationType,
+          comparisonOperator: 'GREATER_THAN',
+          threshold,
+          thresholdType: 'PERCENTAGE',
+        },
+        subscribers: [{ subscriptionType: 'EMAIL', address: alertEmail }],
+      })),
+    });
+
+    new CfnOutput(this, 'BucketName', { value: bucket.bucketName });
+  }
+
+  /** The models' role: their weights and requests, their results, their logs, the container. */
+  private modelRole(bucket: s3.Bucket): iam.Role {
+    const role = new iam.Role(this, 'Role', {
+      assumedBy: new iam.ServicePrincipal('sagemaker.amazonaws.com'),
+    });
+    role.addToPrincipalPolicy(
+      new iam.PolicyStatement({ actions: ['s3:ListBucket'], resources: [bucket.bucketArn] }),
+    );
+    role.addToPrincipalPolicy(
+      new iam.PolicyStatement({
+        actions: ['s3:GetObject'],
+        resources: [bucket.arnForObjects('models/*'), bucket.arnForObjects('in/*')],
+      }),
+    );
+    role.addToPrincipalPolicy(
+      new iam.PolicyStatement({
+        actions: ['s3:PutObject'],
+        resources: [bucket.arnForObjects('out/*'), bucket.arnForObjects('fail/*')],
+      }),
+    );
+    role.addToPrincipalPolicy(
+      new iam.PolicyStatement({ actions: ['ecr:GetAuthorizationToken'], resources: ['*'] }),
+    );
+    role.addToPrincipalPolicy(
+      new iam.PolicyStatement({
+        actions: ['ecr:BatchCheckLayerAvailability', 'ecr:GetDownloadUrlForLayer', 'ecr:BatchGetImage'],
+        resources: [
+          this.formatArn({ service: 'ecr', account: IMAGE_ACCOUNT, resource: 'repository', resourceName: IMAGE_REPOSITORY }),
+        ],
+      }),
+    );
+    return role;
+  }
+}
diff --git a/server/test/image-trial-stack.test.ts b/server/test/image-trial-stack.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/image-trial-stack.test.ts
@@ -0,0 +1,377 @@
+// The image trial's template (D135, D136), synthesized in-process: no AWS
+// credentials, no CLI and no network. The address is invented.
+import assert from 'node:assert/strict';
+import { spawnSync } from 'node:child_process';
+import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
+import { tmpdir } from 'node:os';
+import { join } from 'node:path';
+import { test } from 'node:test';
+import { fileURLToPath } from 'node:url';
+import { App } from 'aws-cdk-lib';
+import { Template } from 'aws-cdk-lib/assertions';
+import { IMAGE, ImageTrialStack, trialSettings, type TrialSettings } from '../infra/image-trial.ts';
+
+const EMAIL = 'owner@example.invalid';
+
+function settingsOf(context: Record<string, unknown>): TrialSettings {
+  return trialSettings((key) => context[key]);
+}
+
+function synth(context: Record<string, unknown>): { stack: ImageTrialStack; template: Template } {
+  const app = new App({ context: { 'aws:cdk:version-reporting': true } });
+  const stack = new ImageTrialStack(app, 'Trial', { account: undefined, settings: settingsOf(context) });
+  return { stack, template: Template.fromStack(stack) };
+}
+
+const both = synth({ imageTrial: 'both', alertEmail: EMAIL });
+const template = both.template;
+
+type Resource = { Type: string; Properties?: Record<string, unknown>; DeletionPolicy?: string };
+function resourcesOf(t: Template): Resource[] {
+  return Object.values(t.toJSON()['Resources'] as Record<string, Resource>);
+}
+function ofType(t: Template, type: string): Resource[] {
+  return resourcesOf(t).filter((r) => r.Type === type);
+}
+function byEndpoint(type: string, name: string): Resource {
+  const found = ofType(template, type).filter((r) => JSON.stringify(r).includes(name));
+  assert.equal(found.length, 1, `${type} ${name}`);
+  return found[0] as Resource;
+}
+
+test('the trial: these resources and no others', () => {
+  const two = (type: string): string[] => [type, type];
+  const four = (type: string): string[] => [...two(type), ...two(type)];
+  assert.deepEqual(resourcesOf(template).map((r) => r.Type).sort(), [
+    ...two('AWS::ApplicationAutoScaling::ScalableTarget'),
+    ...four('AWS::ApplicationAutoScaling::ScalingPolicy'),
+    'AWS::Budgets::Budget',
+    ...four('AWS::CloudWatch::Alarm'),
+    'AWS::IAM::Policy',
+    'AWS::IAM::Role',
+    ...two('AWS::Logs::LogGroup'),
+    'AWS::S3::Bucket',
+    'AWS::S3::BucketPolicy',
+    ...two('AWS::SageMaker::Endpoint'),
+    ...two('AWS::SageMaker::EndpointConfig'),
+    ...two('AWS::SageMaker::Model'),
+  ]);
+});
+
+test('the trial: eu-north-1, destroyable, no version reporting', () => {
+  assert.equal(both.stack.region, 'eu-north-1');
+  assert.equal(both.stack.terminationProtection, false);
+  assert.equal(template.toJSON()['Metadata'], undefined);
+  assert.equal(JSON.stringify(template.toJSON()).includes('AWS::CDK::Metadata'), false);
+});
+
+test('the bucket: private, encrypted, TLS only, no logging or versions', () => {
+  template.hasResource('AWS::S3::Bucket', {
+    DeletionPolicy: 'Delete',
+    UpdateReplacePolicy: 'Delete',
+    Properties: {
+      PublicAccessBlockConfiguration: {
+        BlockPublicAcls: true,
+        BlockPublicPolicy: true,
+        IgnorePublicAcls: true,
+        RestrictPublicBuckets: true,
+      },
+      BucketEncryption: {
+        ServerSideEncryptionConfiguration: [{ ServerSideEncryptionByDefault: { SSEAlgorithm: 'AES256' } }],
+      },
+    },
+  });
+  const props = ofType(template, 'AWS::S3::Bucket')[0]?.Properties ?? {};
+  assert.equal(props['LoggingConfiguration'], undefined);
+  assert.equal(props['VersioningConfiguration'], undefined);
+  assert.equal(props['BucketName'], undefined);
+  const policy = JSON.stringify(ofType(template, 'AWS::S3::BucketPolicy')[0]?.Properties);
+  assert.match(policy, /"aws:SecureTransport":"false"/);
+  assert.match(policy, /"Effect":"Deny"/);
+});
+
+test('requests and results deleted within a day; the weights kept', () => {
+  const rules = (ofType(template, 'AWS::S3::Bucket')[0]?.Properties?.['LifecycleConfiguration'] as {
+    Rules: Record<string, unknown>[];
+  }).Rules;
+  assert.deepEqual(rules, [
+    { Prefix: 'in/', ExpirationInDays: 1, Status: 'Enabled' },
+    { Prefix: 'out/', ExpirationInDays: 1, Status: 'Enabled' },
+    { Prefix: 'fail/', ExpirationInDays: 1, Status: 'Enabled' },
+    { AbortIncompleteMultipartUpload: { DaysAfterInitiation: 1 }, Status: 'Enabled' },
+  ]);
+});
+
+test('each model: the pinned container, its weights, no network', () => {
+  for (const key of ['flux', 'sdxl']) {
+    const model = ofType(template, 'AWS::SageMaker::Model').filter((r) =>
+      JSON.stringify(r).includes(`/models/${key}/`),
+    );
+    assert.equal(model.length, 1, key);
+    const props = model[0]?.Properties ?? {};
+    assert.equal(props['EnableNetworkIsolation'], true);
+    const container = props['PrimaryContainer'] as Record<string, unknown>;
+    assert.equal(container['Image'], IMAGE);
+    assert.deepEqual(container['Environment'], { HF_HUB_OFFLINE: '1' });
+    const source = (container['ModelDataSource'] as { S3DataSource: Record<string, unknown> }).S3DataSource;
+    assert.equal(source['S3DataType'], 'S3Prefix');
+    assert.equal(source['CompressionType'], 'None');
+  }
+  assert.equal(
+    IMAGE,
+    '763104351884.dkr.ecr.eu-north-1.amazonaws.com/huggingface-pytorch-inference:' +
+      '2.6.0-transformers5.5.3-gpu-py312-cu124-ubuntu22.04',
+  );
+});
+
+test('FLUX on g6e.xlarge, SDXL on g6.xlarge, one instance, asynchronous', () => {
+  const expected: Record<string, string> = { flux: 'ml.g6e.xlarge', sdxl: 'ml.g6.xlarge' };
+  for (const [key, instance] of Object.entries(expected)) {
+    const config = ofType(template, 'AWS::SageMaker::EndpointConfig').filter((r) =>
+      JSON.stringify(r).includes(`/out/${key}/`),
+    );
+    assert.equal(config.length, 1, key);
+    const props = config[0]?.Properties ?? {};
+    const variants = props['ProductionVariants'] as Record<string, unknown>[];
+    assert.equal(variants.length, 1);
+    assert.equal(variants[0]?.['InstanceType'], instance);
+    assert.equal(variants[0]?.['InitialInstanceCount'], 1);
+    assert.equal(variants[0]?.['VariantName'], 'main');
+    assert.equal(variants[0]?.['ModelDataDownloadTimeoutInSeconds'], 1800);
+    assert.equal(variants[0]?.['ContainerStartupHealthCheckTimeoutInSeconds'], 1800);
+    const async = props['AsyncInferenceConfig'] as Record<string, Record<string, unknown>>;
+    assert.deepEqual(async['ClientConfig'], { MaxConcurrentInvocationsPerInstance: 1 });
+    assert.match(JSON.stringify(async['OutputConfig']?.['S3FailurePath']), new RegExp(`/fail/${key}/`));
+    assert.equal(async['OutputConfig']?.['NotificationConfig'], undefined);
+    assert.equal(async['OutputConfig']?.['KmsKeyId'], undefined);
+  }
+  const names = ofType(template, 'AWS::SageMaker::Endpoint').map((r) => r.Properties?.['EndpointName']).sort();
+  assert.deepEqual(names, ['souldreams-trial-flux', 'souldreams-trial-sdxl']);
+});
+
+test('scaling: from none to one on a waiting request', () => {
+  for (const name of ['souldreams-trial-flux', 'souldreams-trial-sdxl']) {
+    const target = byEndpoint('AWS::ApplicationAutoScaling::ScalableTarget', name).Properties ?? {};
+    assert.equal(target['MinCapacity'], 0);
+    assert.equal(target['MaxCapacity'], 1);
+    assert.equal(target['ResourceId'], `endpoint/${name}/variant/main`);
+    assert.match(JSON.stringify(target['RoleARN']), /AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint/);
+    const wake = byEndpoint('AWS::ApplicationAutoScaling::ScalingPolicy', `${name}-wake`).Properties ?? {};
+    assert.deepEqual(wake['StepScalingPolicyConfiguration'], {
+      AdjustmentType: 'ExactCapacity',
+      Cooldown: 60,
+      MetricAggregationType: 'Maximum',
+      StepAdjustments: [{ MetricIntervalLowerBound: 0, ScalingAdjustment: 1 }],
+    });
+  }
+  const alarms = ofType(template, 'AWS::CloudWatch::Alarm').filter(
+    (r) => r.Properties?.['MetricName'] === 'HasBacklogWithoutCapacity',
+  );
+  assert.equal(alarms.length, 2);
+  for (const alarm of alarms) {
+    assert.equal(alarm.Properties?.['Threshold'], 0.5);
+    assert.equal(alarm.Properties?.['ComparisonOperator'], 'GreaterThanThreshold');
+    assert.equal(alarm.Properties?.['EvaluationPeriods'], 1);
+    assert.equal(alarm.Properties?.['Period'], 60);
+    assert.equal(alarm.Properties?.['TreatMissingData'], 'notBreaching');
+    assert.match(JSON.stringify(alarm.Properties?.['AlarmActions']), /Wake/);
+  }
+});
+
+function idleAlarms(t: Template): Resource[] {
+  return ofType(t, 'AWS::CloudWatch::Alarm').filter((r) => r.Properties?.['MetricName'] === 'ApproximateBacklogSize');
+}
+
+test('scaling: to none after 10 idle minutes', () => {
+  for (const name of ['souldreams-trial-flux', 'souldreams-trial-sdxl']) {
+    const idle = byEndpoint('AWS::ApplicationAutoScaling::ScalingPolicy', `${name}-idle`).Properties ?? {};
+    assert.deepEqual(idle['StepScalingPolicyConfiguration'], {
+      AdjustmentType: 'ExactCapacity',
+      Cooldown: 60,
+      MetricAggregationType: 'Maximum',
+      StepAdjustments: [{ MetricIntervalUpperBound: 0, ScalingAdjustment: 0 }],
+    });
+  }
+  const alarms = idleAlarms(template);
+  assert.equal(alarms.length, 2);
+  for (const alarm of alarms) {
+    assert.equal(alarm.Properties?.['Namespace'], 'AWS/SageMaker');
+    assert.equal(alarm.Properties?.['Statistic'], 'Maximum');
+    assert.equal(alarm.Properties?.['Threshold'], 0.5);
+    assert.equal(alarm.Properties?.['ComparisonOperator'], 'LessThanThreshold');
+    assert.equal(alarm.Properties?.['EvaluationPeriods'], 10);
+    assert.equal(alarm.Properties?.['DatapointsToAlarm'], 10);
+    assert.equal(alarm.Properties?.['Period'], 60);
+    assert.equal(alarm.Properties?.['TreatMissingData'], 'breaching');
+    assert.match(JSON.stringify(alarm.Properties?.['AlarmActions']), /Idle/);
+  }
+});
+
+test('the idle minutes come from the context', () => {
+  const two = synth({ imageTrial: 'sdxl', alertEmail: EMAIL, idleMinutes: '2' }).template;
+  const alarms = idleAlarms(two);
+  assert.equal(alarms.length, 1);
+  assert.equal(alarms[0]?.Properties?.['EvaluationPeriods'], 2);
+  assert.equal(alarms[0]?.Properties?.['DatapointsToAlarm'], 2);
+});
+
+test('the logs: made first, kept 1 day, gone with the stack', () => {
+  for (const name of ['souldreams-trial-flux', 'souldreams-trial-sdxl']) {
+    template.hasResource('AWS::Logs::LogGroup', {
+      Properties: { LogGroupName: `/aws/sagemaker/Endpoints/${name}`, RetentionInDays: 1 },
+      DeletionPolicy: 'Delete',
+    });
+  }
+  const json = template.toJSON()['Resources'] as Record<string, { Type: string; DependsOn?: string[] }>;
+  for (const endpoint of Object.values(json).filter((r) => r.Type === 'AWS::SageMaker::Endpoint')) {
+    const logs = (endpoint.DependsOn ?? []).filter((d) => json[d]?.Type === 'AWS::Logs::LogGroup');
+    assert.equal(logs.length, 1);
+  }
+});
+
+test("the models' role: its prefixes, its logs, the container, nothing else", () => {
+  template.hasResourceProperties('AWS::IAM::Role', {
+    AssumeRolePolicyDocument: {
+      Statement: [{ Action: 'sts:AssumeRole', Effect: 'Allow', Principal: { Service: 'sagemaker.amazonaws.com' } }],
+    },
+  });
+  const role = ofType(template, 'AWS::IAM::Role')[0]?.Properties ?? {};
+  assert.equal(role['ManagedPolicyArns'], undefined);
+  assert.equal(role['Policies'], undefined);
+  const statements = (
+    ofType(template, 'AWS::IAM::Policy')[0]?.Properties?.['PolicyDocument'] as {
+      Statement: { Action: string | string[]; Resource: unknown }[];
+    }
+  ).Statement;
+  const actions = statements.flatMap((s) => (Array.isArray(s.Action) ? s.Action : [s.Action])).sort();
+  assert.deepEqual(actions, [
+    'ecr:BatchCheckLayerAvailability',
+    'ecr:BatchGetImage',
+    'ecr:GetAuthorizationToken',
+    'ecr:GetDownloadUrlForLayer',
+    'logs:CreateLogStream',
+    'logs:CreateLogStream',
+    'logs:PutLogEvents',
+    'logs:PutLogEvents',
+    's3:GetObject',
+    's3:ListBucket',
+    's3:PutObject',
+  ]);
+  const text = (s: { Resource: unknown }): string => JSON.stringify(s.Resource);
+  for (const s of statements) {
+    const only = Array.isArray(s.Action) ? s.Action : [s.Action];
+    if (only.includes('ecr:GetAuthorizationToken')) {
+      assert.equal(s.Resource, '*');
+    } else {
+      assert.notEqual(s.Resource, '*');
+    }
+    if (only.includes('s3:GetObject')) {
+      assert.match(text(s), /\/models\/\*/);
+      assert.match(text(s), /\/in\/\*/);
+      assert.doesNotMatch(text(s), /\/out\/|\/fail\//);
+    }
+    if (only.includes('s3:PutObject')) {
+      assert.match(text(s), /\/out\/\*/);
+      assert.match(text(s), /\/fail\/\*/);
+      assert.doesNotMatch(text(s), /\/models\/|\/in\//);
+    }
+    if (only.includes('ecr:BatchGetImage')) {
+      assert.match(text(s), /763104351884:repository\/huggingface-pytorch-inference/);
+    }
+  }
+});
+
+test('the budget: USD 30 a month, three emails to one address', () => {
+  const budget = ofType(template, 'AWS::Budgets::Budget')[0]?.Properties ?? {};
+  assert.deepEqual(budget['Budget'], {
+    BudgetName: 'souldreams-image-trial',
+    BudgetType: 'COST',
+    TimeUnit: 'MONTHLY',
+    BudgetLimit: { Amount: 30, Unit: 'USD' },
+  });
+  const notes = budget['NotificationsWithSubscribers'] as {
+    Notification: Record<string, unknown>;
+    Subscribers: unknown[];
+  }[];
+  assert.deepEqual(
+    notes.map((n) => [n.Notification['NotificationType'], n.Notification['Threshold']]),
+    [
+      ['ACTUAL', 50],
+      ['ACTUAL', 100],
+      ['FORECASTED', 100],
+    ],
+  );
+  for (const n of notes) {
+    assert.deepEqual(n.Subscribers, [{ SubscriptionType: 'EMAIL', Address: EMAIL }]);
+  }
+});
+
+test("one output, the bucket's name", () => {
+  assert.deepEqual(Object.keys(template.toJSON()['Outputs'] as object), ['BucketName']);
+});
+
+test('the first stage: the bucket and the budget, no endpoint', () => {
+  const first = synth({ imageTrial: 'bucket', alertEmail: EMAIL }).template;
+  assert.deepEqual(resourcesOf(first).map((r) => r.Type).sort(), [
+    'AWS::Budgets::Budget',
+    'AWS::S3::Bucket',
+    'AWS::S3::BucketPolicy',
+  ]);
+});
+
+test("D136's fallback: FLUX in 8 bits on g6.xlarge, alone", () => {
+  const fallback = synth({ imageTrial: 'flux', alertEmail: EMAIL, fluxEightBit: 'yes' }).template;
+  assert.equal(ofType(fallback, 'AWS::SageMaker::Endpoint').length, 1);
+  const variants = ofType(fallback, 'AWS::SageMaker::EndpointConfig')[0]?.Properties?.['ProductionVariants'] as {
+    InstanceType: string;
+  }[];
+  assert.equal(variants[0]?.InstanceType, 'ml.g6.xlarge');
+  const container = ofType(fallback, 'AWS::SageMaker::Model')[0]?.Properties?.['PrimaryContainer'] as {
+    Environment: unknown;
+  };
+  assert.deepEqual(container.Environment, { HF_HUB_OFFLINE: '1', TRIAL_EIGHT_BIT: 'yes' });
+});
+
+test('the settings refuse what they do not know', () => {
+  const ok = { imageTrial: 'both', alertEmail: EMAIL };
+  assert.throws(() => settingsOf({ ...ok, imageTrial: 'yes' }), { message: 'trial-models' });
+  assert.throws(() => settingsOf({ ...ok, alertEmail: undefined }), { message: 'trial-email' });
+  assert.throws(() => settingsOf({ ...ok, alertEmail: 'owner' }), { message: 'trial-email' });
+  assert.throws(() => settingsOf({ ...ok, idleMinutes: '1' }), { message: 'trial-idle' });
+  assert.throws(() => settingsOf({ ...ok, idleMinutes: '61' }), { message: 'trial-idle' });
+  assert.throws(() => settingsOf({ ...ok, idleMinutes: 'ten' }), { message: 'trial-idle' });
+  assert.throws(() => settingsOf({ ...ok, fluxEightBit: 'no' }), { message: 'trial-eight-bit' });
+  assert.equal(settingsOf(ok).idleMinutes, 10);
+  assert.equal(settingsOf({ ...ok, idleMinutes: 60 }).idleMinutes, 60);
+});
+
+const APP = fileURLToPath(new URL('../infra/app.ts', import.meta.url));
+
+// The stacks the app writes, run as the CLI would, into its own folder.
+function stacksOf(context: Record<string, unknown>): string[] {
+  const out = mkdtempSync(join(tmpdir(), 'trial-app-'));
+  try {
+    const env = {
+      PATH: process.env['PATH'] ?? '',
+      TMPDIR: tmpdir(),
+      CDK_OUTDIR: out,
+      CDK_CONTEXT_JSON: JSON.stringify(context),
+    };
+    const run = spawnSync(process.execPath, [APP], { env, encoding: 'utf8' });
+    assert.equal(run.status, 0, run.stderr);
+    const manifest = JSON.parse(readFileSync(join(out, 'manifest.json'), 'utf8')) as {
+      artifacts: Record<string, { type: string }>;
+    };
+    return Object.entries(manifest.artifacts)
+      .filter(([, a]) => a.type === 'aws:cloudformation:stack')
+      .map(([name]) => name)
+      .sort();
+  } finally {
+    rmSync(out, { recursive: true, force: true });
+  }
+}
+
+test('the app makes the trial only when asked', () => {
+  assert.deepEqual(stacksOf({}), ['SoulDreamsServer']);
+  assert.deepEqual(stacksOf({ imageTrial: 'both', alertEmail: EMAIL }), ['SoulDreamsImageTrial', 'SoulDreamsServer']);
+});
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S46, D135), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -96,6 +96,57 @@ ROWS = [
      'test', 'the temporary-key address is on that host, over https'),
     ('S30', 'src/soniox.ts', "  if (typeof key !== 'string' || key === '' ||", "  if (typeof key !== 'string' ||",
      'test', 'no answer is 0; an unreadable answer is -1'),
+    # The image trial (D135, D136): its stack, its serving code, its run
+    # and its weights script.
+    # The image trial: the stack.
+    ('S31', 'infra/image-trial.ts',
+     's3.BlockPublicAccess.BLOCK_ALL', 's3.BlockPublicAccess.BLOCK_ACLS',
+     'test', 'the bucket: private, encrypted, TLS only, no logging or versions'),
+    ('S32', 'infra/image-trial.ts',
+     '      enforceSSL: true,\n', '',
+     'test', 'the bucket: private, encrypted, TLS only, no logging or versions'),
+    ('S33', 'infra/image-trial.ts',
+     '({ prefix, expiration: Duration.days(1) })', '({ prefix, expiration: Duration.days(2) })',
+     'test', 'requests and results deleted within a day; the weights kept'),
+    ('S34', 'infra/image-trial.ts',
+     '        enableNetworkIsolation: true,\n', '',
+     'test', 'each model: the pinned container, its weights, no network'),
+    ('S35', 'infra/image-trial.ts',
+     '        maxCapacity: 1,', '        maxCapacity: 2,',
+     'test', 'scaling: from none to one on a waiting request'),
+    ('S36', 'infra/image-trial.ts',
+     '        minCapacity: 0,', '        minCapacity: 1,',
+     'test', 'scaling: from none to one on a waiting request'),
+    ('S37', 'infra/image-trial.ts',
+     'cloudwatch.TreatMissingData.BREACHING', 'cloudwatch.TreatMissingData.NOT_BREACHING',
+     'test', 'scaling: to none after 10 idle minutes'),
+    ('S38', 'infra/image-trial.ts',
+     'idleRaw === undefined ? 10 :', 'idleRaw === undefined ? 15 :',
+     'test', 'scaling: to none after 10 idle minutes'),
+    ('S39', 'infra/image-trial.ts',
+     'logs.RetentionDays.ONE_DAY', 'logs.RetentionDays.THREE_DAYS',
+     'test', 'the logs: made first, kept 1 day, gone with the stack'),
+    ('S40', 'infra/image-trial.ts',
+     '      endpoint.node.addDependency(logGroup);\n', '',
+     'test', 'the logs: made first, kept 1 day, gone with the stack'),
+    ('S41', 'infra/image-trial.ts',
+     "bucket.arnForObjects('models/*'), bucket.arnForObjects('in/*')", "bucket.arnForObjects('models/*'), bucket.arnForObjects('in/*'), bucket.arnForObjects('out/*')",
+     'test', "the models' role: its prefixes, its logs, the container, nothing else"),
+    ('S42', 'infra/image-trial.ts',
+     'export const BUDGET_USD = 30;', 'export const BUDGET_USD = 300;',
+     'test', 'the budget: USD 30 a month, three emails to one address'),
+    ('S43', 'infra/image-trial.ts',
+     '      terminationProtection: false,', '      terminationProtection: true,',
+     'test', 'the trial: eu-north-1, destroyable, no version reporting'),
+    ('S44', 'infra/app.ts',
+     "if (app.node.tryGetContext('imageTrial') !== undefined) {", 'if (true) {',
+     'test', 'the app makes the trial only when asked'),
+    ('S45', 'infra/image-trial.ts',
+     "eightBit ? 'ml.g6.xlarge' : 'ml.g6e.xlarge'", "'ml.g6e.xlarge'",
+     'test', "D136's fallback: FLUX in 8 bits on g6.xlarge, alone"),
+    ('S46', 'infra/image-trial.ts',
+     "        : which === 'bucket'\n          ? []", "        : which === 'bucket'\n          ? ['sdxl']",
+     'test', 'the first stage: the bucket and the budget, no endpoint'),
 ]
 
 
```

Checks: `npm test`: `ℹ tests 64`, `ℹ fail 0`. Rows S31 to S46 caught.

Commit: `The image trial's stack: a private bucket, endpoints scaled to zero, a budget alarm (D135, D136)`

### Task 2 · The serving code (D135 item 2; D136)

`inference.py`, its stand-ins and its cases; rows S47 to S50.

```
diff --git a/server/test/image-trial-inference.test.ts b/server/test/image-trial-inference.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/image-trial-inference.test.ts
@@ -0,0 +1,20 @@
+// The trial's serving code (server/trial/code/inference.py) against
+// stand-ins for PyTorch and diffusers: each case is one run of
+// trial_inference_cases.py, which exits 0 when it holds.
+import assert from 'node:assert/strict';
+import { spawnSync } from 'node:child_process';
+import { test } from 'node:test';
+import { fileURLToPath } from 'node:url';
+
+const CASES = fileURLToPath(new URL('trial_inference_cases.py', import.meta.url));
+
+function holds(name: string): void {
+  const run = spawnSync('python3', ['-I', '-B', CASES, name], { encoding: 'utf8' });
+  assert.equal(run.status, 0, run.stderr);
+}
+
+test('serving: full precision, straight onto the GPU', () => holds('full_precision'));
+test('serving: a request gives its words, settings and seed', () => holds('request'));
+test('serving: refusals are codes, never the words', () => holds('refusals'));
+test('serving: seeded on the GPU, answered as PNG', () => holds('seeded_on_the_gpu'));
+test('serving: 8 bits from the pinned wheel, offline', () => holds('eight_bit'));
diff --git a/server/test/trial-stubs/diffusers/__init__.py b/server/test/trial-stubs/diffusers/__init__.py
new file mode 100644
--- /dev/null
+++ b/server/test/trial-stubs/diffusers/__init__.py
@@ -0,0 +1,51 @@
+# A stand-in for diffusers in the trial's serving tests.
+import torch
+
+
+class Image:
+    def save(self, out, format):
+        torch.calls.append(('save', format))
+        out.write(b'\x89PNG stand-in')
+
+
+class Result:
+    images = [Image()]
+
+
+class Pipeline:
+    def __init__(self, kind):
+        self.kind = kind
+
+    def __call__(self, prompt, **kwargs):
+        torch.calls.append(('call', prompt, kwargs))
+        return Result()
+
+    def to(self, device):
+        torch.calls.append(('to', device))
+        return self
+
+
+class DiffusionPipeline:
+    @staticmethod
+    def from_pretrained(path, **kwargs):
+        torch.calls.append(('pipeline', path, kwargs))
+        return Pipeline('diffusion')
+
+
+class FluxPipeline:
+    @staticmethod
+    def from_pretrained(path, **kwargs):
+        torch.calls.append(('flux', path, sorted(kwargs)))
+        return Pipeline('flux')
+
+
+class FluxTransformer2DModel:
+    @staticmethod
+    def from_pretrained(path, **kwargs):
+        torch.calls.append(('transformer', kwargs['subfolder'], kwargs['quantization_config'].bits))
+        return 'transformer'
+
+
+class BitsAndBytesConfig:
+    def __init__(self, load_in_8bit):
+        self.bits = 8 if load_in_8bit else 16
diff --git a/server/test/trial-stubs/torch.py b/server/test/trial-stubs/torch.py
new file mode 100644
--- /dev/null
+++ b/server/test/trial-stubs/torch.py
@@ -0,0 +1,13 @@
+# A stand-in for PyTorch in the trial's serving tests: it records what
+# the serving code asks of it.
+bfloat16 = 'bfloat16'
+calls = []
+
+
+class Generator:
+    def __init__(self, device):
+        calls.append(('generator', device))
+
+    def manual_seed(self, seed):
+        calls.append(('seed', seed))
+        return self
diff --git a/server/test/trial-stubs/transformers/__init__.py b/server/test/trial-stubs/transformers/__init__.py
new file mode 100644
--- /dev/null
+++ b/server/test/trial-stubs/transformers/__init__.py
@@ -0,0 +1,14 @@
+# A stand-in for transformers in the trial's serving tests.
+import torch
+
+
+class BitsAndBytesConfig:
+    def __init__(self, load_in_8bit):
+        self.bits = 8 if load_in_8bit else 16
+
+
+class T5EncoderModel:
+    @staticmethod
+    def from_pretrained(path, **kwargs):
+        torch.calls.append(('encoder', kwargs['subfolder'], kwargs['quantization_config'].bits))
+        return 'encoder'
diff --git a/server/test/trial_inference_cases.py b/server/test/trial_inference_cases.py
new file mode 100644
--- /dev/null
+++ b/server/test/trial_inference_cases.py
@@ -0,0 +1,104 @@
+# The trial's serving code against stand-ins, one case per run:
+# python3 -I -B trial_inference_cases.py <case>. Exit 0 when it holds.
+# The prompt is invented scenery.
+import io
+import json
+import os
+import sys
+import tempfile
+
+HERE = os.path.dirname(os.path.abspath(__file__))
+sys.path.insert(0, os.path.join(HERE, 'trial-stubs'))
+sys.path.insert(0, os.path.join(HERE, '..', 'trial', 'code'))
+
+import inference  # noqa: E402
+import torch  # noqa: E402
+
+PROMPT = 'a quiet harbour at dusk'
+
+
+def body(**changes):
+    data = {'inputs': PROMPT, 'parameters': {'num_inference_steps': 4, 'seed': 7}}
+    data.update(changes)
+    return json.dumps(data)
+
+
+def refused(code, fn, *args):
+    try:
+        fn(*args)
+    except ValueError as e:
+        assert str(e) == code, str(e)
+        assert PROMPT not in str(e)
+        return
+    raise AssertionError('not refused')
+
+
+def case_full_precision():
+    os.environ.pop('TRIAL_EIGHT_BIT', None)
+    inference.model_fn('/opt/ml/model')
+    assert torch.calls == [('pipeline', '/opt/ml/model', {'torch_dtype': 'bfloat16', 'device_map': 'cuda'})]
+
+
+def case_request():
+    got = inference.input_fn(body(parameters={
+        'num_inference_steps': 4, 'guidance_scale': 0.0, 'height': 1024, 'width': 1024,
+        'max_sequence_length': 256, 'seed': 7}), 'application/json')
+    assert got == (PROMPT, {'num_inference_steps': 4, 'guidance_scale': 0.0, 'height': 1024, 'width': 1024,
+                            'max_sequence_length': 256}, 7)
+    assert inference.input_fn(json.dumps({'inputs': PROMPT}), 'application/json') == (PROMPT, {}, 0)
+
+
+def case_refusals():
+    refused('trial-content-type', inference.input_fn, body(), 'text/plain')
+    refused('trial-request', inference.input_fn, '{', 'application/json')
+    refused('trial-request', inference.input_fn, '[]', 'application/json')
+    refused('trial-request', inference.input_fn, body(inputs=''), 'application/json')
+    refused('trial-request', inference.input_fn, body(inputs=3), 'application/json')
+    refused('trial-request', inference.input_fn, body(parameters=[]), 'application/json')
+    refused('trial-setting', inference.input_fn, body(parameters={'negative_prompt': PROMPT}), 'application/json')
+    refused('trial-seed', inference.input_fn, body(parameters={'seed': -1}), 'application/json')
+    refused('trial-seed', inference.input_fn, body(parameters={'seed': True}), 'application/json')
+    refused('trial-seed', inference.input_fn, body(parameters={'seed': 1.5}), 'application/json')
+    refused('trial-accept', inference.output_fn, None, 'application/json')
+
+
+def case_seeded_on_the_gpu():
+    pipe = inference.model_fn('/opt/ml/model')
+    torch.calls.clear()
+    image = inference.predict_fn((PROMPT, {'num_inference_steps': 4}, 7), pipe)
+    assert torch.calls[:2] == [('generator', 'cuda'), ('seed', 7)]
+    call = torch.calls[2]
+    assert call[0] == 'call' and call[1] == PROMPT
+    assert call[2]['num_inference_steps'] == 4 and set(call[2]) == {'num_inference_steps', 'generator'}
+    assert inference.output_fn(image, 'image/png') == b'\x89PNG stand-in'
+    assert torch.calls[-1] == ('save', 'PNG')
+
+
+def case_eight_bit():
+    ran = []
+    inference.subprocess.run = lambda args, check: ran.append((args, check))
+    os.environ['TRIAL_EIGHT_BIT'] = 'yes'
+    with tempfile.TemporaryDirectory() as model_dir:
+        try:
+            inference.model_fn(model_dir)
+        except RuntimeError as e:
+            assert str(e) == 'trial-wheel'
+        else:
+            raise AssertionError('no wheel, yet loaded')
+        assert ran == [] and torch.calls == []
+        wheels = os.path.join(model_dir, 'code', 'wheels')
+        os.makedirs(wheels)
+        wheel = os.path.join(wheels, 'bitsandbytes-0.50.2-py3-none-manylinux_2_24_x86_64.whl')
+        io.open(wheel, 'wb').close()
+        inference.model_fn(model_dir)
+    assert ran == [([sys.executable, '-m', 'pip', 'install', '--no-index', '--no-deps', '--quiet', wheel], True)]
+    assert torch.calls == [
+        ('transformer', 'transformer', 8),
+        ('encoder', 'text_encoder_2', 8),
+        ('flux', model_dir, ['text_encoder_2', 'torch_dtype', 'transformer']),
+        ('to', 'cuda'),
+    ]
+
+
+if __name__ == '__main__':
+    globals()['case_' + sys.argv[1]]()
diff --git a/server/trial/code/inference.py b/server/trial/code/inference.py
new file mode 100644
--- /dev/null
+++ b/server/trial/code/inference.py
@@ -0,0 +1,83 @@
+# The image trial's serving code (D135, D136), run by the Hugging Face
+# inference toolkit inside AWS's container, from the weights' folder
+# (code/inference.py). It writes nothing anywhere: a refusal raises a
+# code, never the request's words (R3). The toolkit logs only timings.
+import glob
+import io
+import json
+import os
+import subprocess
+import sys
+
+import torch
+
+# What a request may set, besides the seed.
+SETTINGS = ('num_inference_steps', 'guidance_scale', 'height', 'width', 'max_sequence_length')
+# D136's fallback, pinned: its wheel sits in code/wheels/ beside this file.
+EIGHT_BIT_WHEEL = 'bitsandbytes-0.50.2-py3-none-manylinux_2_24_x86_64.whl'
+
+
+def model_fn(model_dir):
+    if os.environ.get('TRIAL_EIGHT_BIT') == 'yes':
+        return _eight_bit(model_dir)
+    from diffusers import DiffusionPipeline
+    # Straight onto the GPU: FLUX in full precision is larger than the
+    # instance's memory (32 GiB on g6e.xlarge).
+    return DiffusionPipeline.from_pretrained(model_dir, torch_dtype=torch.bfloat16, device_map='cuda')
+
+
+def _eight_bit(model_dir):
+    wheels = glob.glob(os.path.join(model_dir, 'code', 'wheels', EIGHT_BIT_WHEEL))
+    if len(wheels) != 1:
+        raise RuntimeError('trial-wheel')
+    # From the file alone: the endpoint has no network.
+    subprocess.run([sys.executable, '-m', 'pip', 'install', '--no-index', '--no-deps', '--quiet', wheels[0]],
+                   check=True)
+    from diffusers import BitsAndBytesConfig as DiffusersEightBit
+    from diffusers import FluxPipeline, FluxTransformer2DModel
+    from transformers import BitsAndBytesConfig as TransformersEightBit
+    from transformers import T5EncoderModel
+    transformer = FluxTransformer2DModel.from_pretrained(
+        model_dir, subfolder='transformer', torch_dtype=torch.bfloat16,
+        quantization_config=DiffusersEightBit(load_in_8bit=True))
+    text_encoder_2 = T5EncoderModel.from_pretrained(
+        model_dir, subfolder='text_encoder_2', dtype=torch.bfloat16,
+        quantization_config=TransformersEightBit(load_in_8bit=True))
+    pipe = FluxPipeline.from_pretrained(model_dir, transformer=transformer, text_encoder_2=text_encoder_2,
+                                        torch_dtype=torch.bfloat16)
+    return pipe.to('cuda')
+
+
+def input_fn(input_data, content_type):
+    if content_type != 'application/json':
+        raise ValueError('trial-content-type')
+    try:
+        data = json.loads(input_data)
+    except ValueError:
+        raise ValueError('trial-request') from None
+    if not isinstance(data, dict):
+        raise ValueError('trial-request')
+    prompt = data.get('inputs')
+    settings = data.get('parameters', {})
+    if not isinstance(prompt, str) or prompt == '' or not isinstance(settings, dict):
+        raise ValueError('trial-request')
+    if not set(settings) <= set(SETTINGS) | {'seed'}:
+        raise ValueError('trial-setting')
+    seed = settings.get('seed', 0)
+    if not isinstance(seed, int) or isinstance(seed, bool) or seed < 0:
+        raise ValueError('trial-seed')
+    return prompt, {k: settings[k] for k in SETTINGS if k in settings}, seed
+
+
+def predict_fn(data, model):
+    prompt, settings, seed = data
+    generator = torch.Generator(device='cuda').manual_seed(seed)
+    return model(prompt, generator=generator, **settings).images[0]
+
+
+def output_fn(prediction, accept):
+    if accept != 'image/png':
+        raise ValueError('trial-accept')
+    out = io.BytesIO()
+    prediction.save(out, format='PNG')
+    return out.getvalue()
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S46, D135), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S50, D135), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -147,6 +147,19 @@ ROWS = [
     ('S46', 'infra/image-trial.ts',
      "        : which === 'bucket'\n          ? []", "        : which === 'bucket'\n          ? ['sdxl']",
      'test', 'the first stage: the bucket and the budget, no endpoint'),
+    # The image trial: the serving code.
+    ('S47', 'trial/code/inference.py',
+     ", torch_dtype=torch.bfloat16, device_map='cuda')", ', torch_dtype=torch.bfloat16)',
+     'test', 'serving: full precision, straight onto the GPU'),
+    ('S48', 'trial/code/inference.py',
+     "    if not set(settings) <= set(SETTINGS) | {'seed'}:", '    if False:',
+     'test', 'serving: refusals are codes, never the words'),
+    ('S49', 'trial/code/inference.py',
+     "'install', '--no-index', ", "'install', ",
+     'test', 'serving: 8 bits from the pinned wheel, offline'),
+    ('S50', 'trial/code/inference.py',
+     '.manual_seed(seed)', '.manual_seed(0)',
+     'test', 'serving: seeded on the GPU, answered as PNG'),
 ]
 
 
```

Checks: `npm test`: `ℹ tests 69`, `ℹ fail 0`. Rows S47 to S50 caught.

Commit: `The image trial's serving code: full precision on the GPU, D136's 8-bit fallback`

### Task 3 · The run and its costs (D135)

The six prompts, the arithmetic, the run on the Mac and their tests; `trial` in the tsconfig; rows S51 to S59.

```
diff --git a/server/test/image-trial-run.test.ts b/server/test/image-trial-run.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/image-trial-run.test.ts
@@ -0,0 +1,318 @@
+// The image trial's arithmetic and its run, against a fake AWS CLI and a
+// fake clock: no credentials, no network. The bucket is invented.
+import assert from 'node:assert/strict';
+import { existsSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
+import { tmpdir } from 'node:os';
+import { join } from 'node:path';
+import { test } from 'node:test';
+import { costs, prompt, report, requestBody, SCENES, STYLE, type Run } from '../trial/measure.ts';
+import { framed, parseArgs, round, trial, type Aws, type Trial } from '../trial/run.ts';
+
+const BUCKET = 'trial-bucket-invented';
+const T0 = Date.parse('2026-11-23T09:00:00.000Z');
+
+test('six invented scenes, each with the one style', () => {
+  assert.equal(SCENES.length, 6);
+  assert.equal(prompt(0), `${SCENES[0]}, ${STYLE}`);
+  assert.equal(new Set(SCENES.map((_, i) => prompt(i))).size, 6);
+  assert.throws(() => prompt(6), { message: 'trial-prompt' });
+  assert.throws(() => prompt(-1), { message: 'trial-prompt' });
+});
+
+test("a request: the prompt, the model's settings, the prompt's seed", () => {
+  assert.deepEqual(JSON.parse(requestBody('flux', 2)), {
+    inputs: prompt(2),
+    parameters: { num_inference_steps: 4, guidance_scale: 0, max_sequence_length: 256, height: 1024, width: 1024, seed: 1002 },
+  });
+  assert.deepEqual(JSON.parse(requestBody('sdxl', 2)), {
+    inputs: prompt(2),
+    parameters: { num_inference_steps: 50, guidance_scale: 5, height: 1024, width: 1024, seed: 1002 },
+  });
+});
+
+const s = (n: number): number => T0 + n * 1000;
+const RUN: Run = {
+  model: 'flux',
+  instanceType: 'ml.g6e.xlarge',
+  idleMinutes: 10,
+  // Scale-out 300 s, the painting 20 s later, gone 660 s after it.
+  single: { paintings: 1, submitted: s(0), done: [s(380)], scaleOutStart: s(60), scaleOutEnd: s(360), scaleInEnd: s(1040) },
+  // Six, 5 s apart.
+  batch: {
+    paintings: 6,
+    submitted: s(2000),
+    done: [s(2380), s(2385), s(2390), s(2395), s(2400), s(2405)],
+    scaleOutStart: s(2060),
+    scaleOutEnd: s(2360),
+    scaleInEnd: s(3065),
+  },
+};
+
+test('the costs, from what was measured', () => {
+  const c = costs(RUN);
+  const perSecond = 2.7636 / 3600;
+  assert.equal(c.pricePerHour, 2.7636);
+  assert.equal(c.coldStart, 300);
+  assert.equal(c.perPainting, 5);
+  assert.equal(c.tail, 660);
+  assert.equal(c.singleBilled, 980);
+  assert.equal(c.batchBilled, 1005);
+  assert.ok(Math.abs(c.warm - perSecond * 5) < 1e-12);
+  assert.ok(Math.abs(c.wake10 - perSecond * 980) < 1e-12);
+  assert.ok(Math.abs(c.wake2 - perSecond * (980 - 480)) < 1e-12);
+  assert.ok(Math.abs(c.batchMeasured - (perSecond * 1005) / 6) < 1e-12);
+  assert.deepEqual(c.daily.map(([n]) => n), [10, 60, 100]);
+  assert.ok(Math.abs((c.daily[0]?.[1] ?? 0) - (perSecond * (980 + 9 * 5)) / 10) < 1e-12);
+  assert.ok(Math.abs((c.daily[2]?.[1] ?? 0) - (perSecond * (980 + 99 * 5)) / 100) < 1e-12);
+});
+
+test('g6.xlarge at its own price; an unknown instance refused', () => {
+  assert.equal(costs({ ...RUN, model: 'sdxl', instanceType: 'ml.g6.xlarge' }).pricePerHour, 1.195);
+  assert.throws(() => costs({ ...RUN, instanceType: 'ml.g5.xlarge' }), { message: 'trial-price' });
+  assert.throws(() => costs({ ...RUN, single: { ...RUN.single, scaleInEnd: s(10) } }), { message: 'trial-times' });
+  assert.throws(() => costs({ ...RUN, batch: { ...RUN.batch, done: [s(2380)] } }), { message: 'trial-round' });
+});
+
+test('the report: the basis, the measures and every cost', () => {
+  const text = report(RUN);
+  assert.match(text, /Price basis: USD 2\.7636 per hour, the Training price \[READ\]; hosting \[ASSUMED\]/);
+  assert.match(text, /\| Cold start, scale-out to in service \| 300\.0 s \|/);
+  assert.match(text, /\| Time per painting, warm \| 5\.0 s \|/);
+  assert.match(text, /\| Warm \| USD 0\.0038 \|/);
+  assert.match(text, /\| Woken for each, idle 10 minutes \| USD 0\.7523 \|/);
+  assert.match(text, /\| Woken for each, idle 2 minutes \(derived\) \| USD 0\.3838 \|/);
+  assert.match(text, /\| Daily batch of 60 \(derived\) \| USD 0\.0163 \|/);
+  assert.match(report({ ...RUN, instanceType: 'ml.g6.xlarge' }), /USD 1\.195 per hour, EUN1-AsyncInf \[READ\]/);
+  for (const scene of SCENES) {
+    assert.equal(text.includes(scene), false);
+  }
+});
+
+test('the command line', () => {
+  assert.deepEqual(parseArgs(['flux', BUCKET, '/tmp/x']), {
+    model: 'flux',
+    bucket: BUCKET,
+    folder: '/tmp/x',
+    instanceType: 'ml.g6e.xlarge',
+    idleMinutes: 10,
+  });
+  assert.equal(parseArgs(['flux', BUCKET, '/tmp/x', '10', 'yes']).instanceType, 'ml.g6.xlarge');
+  assert.equal(parseArgs(['sdxl', BUCKET, '/tmp/x', '2']).idleMinutes, 2);
+  for (const bad of [
+    [],
+    ['sd3', BUCKET, '/tmp/x'],
+    ['flux', 'Bad_Bucket', '/tmp/x'],
+    ['flux', BUCKET],
+    ['flux', BUCKET, ''],
+    ['flux', BUCKET, '/tmp/x', '1'],
+    ['flux', BUCKET, '/tmp/x', '10', 'maybe'],
+    ['flux', BUCKET, '/tmp/x', '10', 'no', 'more'],
+  ]) {
+    assert.throws(() => parseArgs(bad), { message: 'trial-usage' }, bad.join(' '));
+  }
+});
+
+// The fake AWS: the endpoint wakes 60 s after a request, is in service
+// 300 s later, paints one every 20 s, and is gone 10 minutes after its
+// last painting.
+interface Fake {
+  aws: Aws;
+  calls: string[][];
+  now: () => number;
+  sleep: (ms: number) => Promise<void>;
+}
+
+function fake(options: { fail?: boolean; notPng?: boolean } = {}): Fake {
+  let now = T0;
+  const calls: string[][] = [];
+  const results: { key: string; ready: number }[] = [];
+  const failures: string[] = [];
+  const acts: { to: number; start: number; end: number }[] = [];
+  let pending: number[] = [];
+  let busyUntil = 0;
+  const instances = (): number => {
+    const live = acts.filter((a) => a.end <= now).at(-1);
+    return live?.to ?? 0;
+  };
+  const aws: Aws = async (args) => {
+    calls.push([...args]);
+    const [service, op] = args;
+    if (service === 'sagemaker' && op === 'describe-endpoint') {
+      return JSON.stringify({ ProductionVariants: [{ CurrentInstanceCount: instances() }] });
+    }
+    if (service === 's3' && op === 'cp') {
+      const to = args[3] ?? '';
+      if (!to.startsWith('s3://')) {
+        writeFileSync(to, options.notPng ? 'nope' : Buffer.from([0x89, 0x50, 0x4e, 0x47, 1]));
+      }
+      return '';
+    }
+    if (service === 'sagemaker-runtime') {
+      const id = `${results.length + failures.length}`;
+      if (options.fail) {
+        failures.push(`fail/flux/${id}-error.out`);
+      } else {
+        if (busyUntil < now) {
+          // A wake: out from none, in service, then idle.
+          acts.push({ to: 1, start: now + 60000, end: now + 360000 });
+          busyUntil = now + 360000;
+        }
+        busyUntil += 20000;
+        results.push({ key: `out/flux/${id}.out`, ready: busyUntil });
+        pending.push(busyUntil);
+      }
+      return JSON.stringify({
+        OutputLocation: `s3://${BUCKET}/out/flux/${id}.out`,
+        FailureLocation: `s3://${BUCKET}/fail/flux/${id}-error.out`,
+      });
+    }
+    if (service === 's3api' && op === 'list-objects-v2') {
+      const prefix = args[args.indexOf('--prefix') + 1] ?? '';
+      if (prefix.startsWith('fail/')) {
+        return JSON.stringify({ Contents: failures.map((k) => ({ Key: k, LastModified: new Date(now).toISOString() })) });
+      }
+      const ready = results.filter((r) => r.ready <= now);
+      return JSON.stringify(
+        ready.length === 0
+          ? {}
+          : { Contents: ready.map((r) => ({ Key: r.key, LastModified: new Date(r.ready).toISOString() })) },
+      );
+    }
+    if (service === 'application-autoscaling') {
+      return JSON.stringify({
+        ScalingActivities: acts
+          .filter((a) => a.end <= now)
+          .reverse()
+          .map((a) => ({
+            Description: `Setting desired instance count to ${a.to}.`,
+            StartTime: new Date(a.start).toISOString(),
+            EndTime: new Date(a.end).toISOString(),
+            StatusCode: 'Successful',
+          })),
+      });
+    }
+    throw new Error('fake-unknown');
+  };
+  const sleep = async (ms: number): Promise<void> => {
+    now += ms;
+    // After the last painting, 10 idle minutes and a minute to go.
+    if (pending.length > 0 && results.every((r) => r.ready <= now)) {
+      const lastReady = Math.max(...pending);
+      if (now >= lastReady) {
+        acts.push({ to: 0, start: lastReady + 600000, end: lastReady + 660000 });
+        pending = [];
+      }
+    }
+  };
+  return { aws, calls, now: () => now, sleep };
+}
+
+function trialOf(f: Fake, folder: string, notes: string[]): Trial {
+  return {
+    aws: f.aws,
+    clock: { now: f.now, sleep: f.sleep },
+    model: 'flux',
+    bucket: BUCKET,
+    folder,
+    note: (code, numbers = []) => notes.push([code, ...numbers].join(' ')),
+  };
+}
+
+test('a round: requests through S3, PNG asked, times from S3', async () => {
+  const f = fake();
+  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
+  try {
+    const r = await round(trialOf(f, folder, []), [0, 1], 'batch');
+    assert.equal(r.submitted, T0);
+    assert.deepEqual(r.done, [T0 + 380000, T0 + 400000]);
+    const invokes = f.calls.filter((c) => c[0] === 'sagemaker-runtime');
+    assert.equal(invokes.length, 2);
+    for (const c of invokes) {
+      assert.deepEqual(c.slice(0, 4), ['sagemaker-runtime', 'invoke-endpoint-async', '--endpoint-name', 'souldreams-trial-flux']);
+      assert.equal(c[c.indexOf('--content-type') + 1], 'application/json');
+      assert.equal(c[c.indexOf('--accept') + 1], 'image/png');
+      assert.match(c[c.indexOf('--input-location') + 1] ?? '', new RegExp(`^s3://${BUCKET}/in/flux/`));
+    }
+    for (const c of f.calls) {
+      assert.equal(c[c.indexOf('--region') + 1], 'eu-north-1', c.join(' '));
+    }
+    // The request files are gone from the Mac once sent.
+    assert.equal(readdirSync(tmpdir()).filter((n) => n.startsWith(`trial-flux-${T0}-`)).length, 0);
+  } finally {
+    rmSync(folder, { recursive: true, force: true });
+  }
+});
+
+test('a failed painting stops the run with a code', async () => {
+  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
+  try {
+    await assert.rejects(round(trialOf(fake({ fail: true }), folder, []), [0], 'single'), { message: 'trial-failed' });
+  } finally {
+    rmSync(folder, { recursive: true, force: true });
+  }
+});
+
+test('the run: one painting, then six, each round back to none', async () => {
+  const f = fake();
+  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
+  const notes: string[] = [];
+  try {
+    const run = await trial(trialOf(f, folder, notes), 'ml.g6e.xlarge', 10);
+    assert.deepEqual(readdirSync(join(folder, 'flux')).sort(), [
+      '1.png',
+      '2.png',
+      '3.png',
+      '4.png',
+      '5.png',
+      '6.png',
+      'raw.json',
+      'results.json',
+      'results.md',
+      'wake-1.png',
+    ]);
+    assert.equal(run.single.paintings, 1);
+    assert.equal(run.batch.paintings, 6);
+    const c = costs(run);
+    assert.equal(c.coldStart, 300);
+    assert.equal(c.perPainting, 20);
+    assert.equal(c.tail, 660);
+    assert.equal(readFileSync(join(folder, 'flux', 'results.md'), 'utf8'), report(run));
+    assert.deepEqual(notes, ['waitIdle', 'submitted 1', 'singleDone', 'submitted 6', 'batchDone', 'finished']);
+    for (const name of ['raw.json', 'results.json', 'results.md']) {
+      const text = readFileSync(join(folder, 'flux', name), 'utf8');
+      assert.equal(text.includes(STYLE), false, name);
+    }
+  } finally {
+    rmSync(folder, { recursive: true, force: true });
+  }
+});
+
+test('a result that is not a PNG stops the run', async () => {
+  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
+  try {
+    await assert.rejects(trial(trialOf(fake({ notPng: true }), folder, []), 'ml.g6e.xlarge', 10), {
+      message: 'trial-not-png',
+    });
+    assert.equal(existsSync(join(folder, 'flux', 'results.md')), false);
+  } finally {
+    rmSync(folder, { recursive: true, force: true });
+  }
+});
+
+test('a round with no scaling found is refused, not guessed', () => {
+  const r = { submitted: s(0), done: [s(380)] };
+  assert.throws(() => framed([], 1, r), { message: 'trial-activities' });
+  const out = { to: 1, start: s(60), end: s(360) };
+  assert.throws(() => framed([out], 1, r), { message: 'trial-activities' });
+  const late = { to: 1, start: s(60), end: s(400) };
+  const inn = { to: 0, start: s(980), end: s(1040) };
+  assert.throws(() => framed([late, inn], 1, r), { message: 'trial-activities' });
+  assert.deepEqual(framed([out, inn], 1, r), {
+    paintings: 1,
+    submitted: s(0),
+    done: [s(380)],
+    scaleOutStart: s(60),
+    scaleOutEnd: s(360),
+    scaleInEnd: s(1040),
+  });
+});
diff --git a/server/trial/measure.ts b/server/trial/measure.ts
new file mode 100644
--- /dev/null
+++ b/server/trial/measure.ts
@@ -0,0 +1,173 @@
+// The image trial's requests and its arithmetic (D135, D136). The six
+// prompts are invented scenery, with no person and nothing from any
+// dream (R2). Every price is read from AWS's Price List (see PRICES).
+export type ModelKey = 'flux' | 'sdxl';
+
+// not-dreamer-facing: the trial's invented scenery, one per painting.
+export const SCENES = [
+  'a wheat field under a swirling starry sky',
+  'cypress trees bending in the wind beside a village',
+  'a blossoming almond branch against a pale blue sky',
+  'sunflowers in a clay vase on a wooden table',
+  'an olive grove on rolling hills under a yellow sun',
+  'a stone bridge over a calm canal at night',
+] as const;
+export const STYLE = 'Van Gogh style oil painting, thick impasto brushstrokes, no people';
+
+export function prompt(index: number): string {
+  const scene = SCENES[index];
+  if (scene === undefined) {
+    throw new Error('trial-prompt');
+  }
+  return `${scene}, ${STYLE}`;
+}
+
+// Each model's settings as its card or the library sets them, square
+// at 1024, the models' own size.
+export const SETTINGS: Record<ModelKey, Record<string, number>> = {
+  flux: { num_inference_steps: 4, guidance_scale: 0, max_sequence_length: 256, height: 1024, width: 1024 },
+  sdxl: { num_inference_steps: 50, guidance_scale: 5, height: 1024, width: 1024 },
+};
+
+/** The request's body: the same seed for the same prompt on every model. */
+export function requestBody(model: ModelKey, index: number): string {
+  return JSON.stringify({ inputs: prompt(index), parameters: { ...SETTINGS[model], seed: 1000 + index } });
+}
+
+// USD per hour, on demand, eu-north-1 [READ, AWS Price List API,
+// AmazonSageMaker, eu-north-1, published 2026-11-22T02:34:21Z, effective
+// 2026-11-01]. ml.g6.xlarge: EUN1-AsyncInf. ml.g6e.xlarge has no
+// AsyncInf or Host entry there: its Training and Processing price
+// stands in, as the two are equal for every type listed with both
+// [ASSUMED until the owner's bill shows it].
+export const PRICES: Record<string, number> = {
+  'ml.g6.xlarge': 1.195,
+  'ml.g6e.xlarge': 2.7636,
+};
+
+/** What the run measured, in milliseconds since the epoch. */
+export interface Round {
+  readonly paintings: number;
+  readonly submitted: number;
+  /** When each result reached the bucket, in order. */
+  readonly done: readonly number[];
+  readonly scaleOutStart: number;
+  readonly scaleOutEnd: number;
+  readonly scaleInEnd: number;
+}
+
+export interface Run {
+  readonly model: ModelKey;
+  readonly instanceType: string;
+  readonly idleMinutes: number;
+  /** One painting waking the machine. */
+  readonly single: Round;
+  /** Six paintings sent together, waking it once. */
+  readonly batch: Round;
+}
+
+export interface Costs {
+  readonly pricePerHour: number;
+  /** From the scale-out to in service, seconds. */
+  readonly coldStart: number;
+  /** Seconds between paintings, warm, from the batch. */
+  readonly perPainting: number;
+  /** After the single painting until the instance was gone, seconds. */
+  readonly tail: number;
+  /** Instance seconds billed for the single painting. */
+  readonly singleBilled: number;
+  readonly batchBilled: number;
+  readonly warm: number;
+  readonly wake10: number;
+  readonly wake2: number;
+  readonly batchMeasured: number;
+  /** Paintings per daily wake, and the cost of each. */
+  readonly daily: readonly (readonly [number, number])[];
+}
+
+export const DAILY = [10, 60, 100] as const;
+
+function seconds(from: number, to: number): number {
+  if (!(to >= from)) {
+    throw new Error('trial-times');
+  }
+  return (to - from) / 1000;
+}
+
+function last(r: Round): number {
+  const t = r.done[r.done.length - 1];
+  if (t === undefined || r.done.length !== r.paintings) {
+    throw new Error('trial-round');
+  }
+  return t;
+}
+
+export function costs(run: Run): Costs {
+  const price = PRICES[run.instanceType];
+  if (price === undefined) {
+    throw new Error('trial-price');
+  }
+  const perSecond = price / 3600;
+  const first = run.batch.done[0];
+  if (first === undefined || run.batch.paintings < 2) {
+    throw new Error('trial-round');
+  }
+  const perPainting = seconds(first, last(run.batch)) / (run.batch.paintings - 1);
+  const singleBilled = seconds(run.single.scaleOutStart, run.single.scaleInEnd);
+  const batchBilled = seconds(run.batch.scaleOutStart, run.batch.scaleInEnd);
+  // The same wake with an idle time of 2 minutes: the measured one less
+  // the minutes it waited beyond 2.
+  const shorter = (run.idleMinutes - 2) * 60;
+  return {
+    pricePerHour: price,
+    coldStart: seconds(run.single.scaleOutStart, run.single.scaleOutEnd),
+    perPainting,
+    tail: seconds(last(run.single), run.single.scaleInEnd),
+    singleBilled,
+    batchBilled,
+    warm: perSecond * perPainting,
+    wake10: perSecond * (singleBilled - (run.idleMinutes - 10) * 60),
+    wake2: perSecond * (singleBilled - shorter),
+    batchMeasured: (perSecond * batchBilled) / run.batch.paintings,
+    daily: DAILY.map((n) => [n, (perSecond * (singleBilled + (n - 1) * perPainting)) / n] as const),
+  };
+}
+
+function usd(n: number): string {
+  return `USD ${n.toFixed(4)}`;
+}
+
+function s(n: number): string {
+  return `${n.toFixed(1)} s`;
+}
+
+/** The results as Markdown, for the owner and the Build chat. */
+export function report(run: Run): string {
+  const c = costs(run);
+  const basis =
+    run.instanceType === 'ml.g6e.xlarge'
+      ? 'USD 2.7636 per hour, the Training price [READ]; hosting [ASSUMED]'
+      : 'USD 1.195 per hour, EUN1-AsyncInf [READ]';
+  return [
+    `# Image trial: ${run.model} on ${run.instanceType}`,
+    '',
+    `Price basis: ${basis}. Idle setting: ${run.idleMinutes} minutes.`,
+    '',
+    '| Measure | Value |',
+    '|---|---|',
+    `| Cold start, scale-out to in service | ${s(c.coldStart)} |`,
+    `| Time per painting, warm | ${s(c.perPainting)} |`,
+    `| Tail after the last painting | ${s(c.tail)} |`,
+    `| Billed, one painting waking it | ${s(c.singleBilled)} |`,
+    `| Billed, six paintings waking it once | ${s(c.batchBilled)} |`,
+    '',
+    '| Cost per painting | USD |',
+    '|---|---|',
+    `| Warm | ${usd(c.warm)} |`,
+    `| Woken for each, idle 10 minutes | ${usd(c.wake10)} |`,
+    `| Woken for each, idle 2 minutes (derived) | ${usd(c.wake2)} |`,
+    `| Six together, measured | ${usd(c.batchMeasured)} |`,
+    ...c.daily.map(([n, cost]) => `| Daily batch of ${n} (derived) | ${usd(cost)} |`),
+    '',
+  ].join('\n');
+}
diff --git a/server/trial/run.ts b/server/trial/run.ts
new file mode 100644
--- /dev/null
+++ b/server/trial/run.ts
@@ -0,0 +1,289 @@
+// The image trial's run, on the owner's Mac with his AWS profile (D135,
+// D136; docs/plans/image-trial.md): one painting waking the endpoint,
+// then six together, each round waiting for the endpoint to scale back
+// to none. The images and the results go to the folder given, outside
+// the repository. It writes no prompt anywhere: the requests go to S3 as
+// files, and its own notes hold codes and times only.
+//   node trial/run.ts <flux|sdxl> <bucket> <folder>
+import { execFile } from 'node:child_process';
+import { appendFileSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
+import { tmpdir } from 'node:os';
+import { join } from 'node:path';
+import { pathToFileURL } from 'node:url';
+import { endpointName, trialModel, VARIANT } from '../infra/image-trial.ts';
+import { REGION } from '../infra/stack.ts';
+import { report, requestBody, SCENES, type ModelKey, type Round, type Run } from './measure.ts';
+
+/** Runs the AWS CLI with these arguments; resolves its standard output. */
+export type Aws = (args: readonly string[]) => Promise<string>;
+
+export interface Clock {
+  now(): number;
+  sleep(ms: number): Promise<void>;
+}
+
+export interface Trial {
+  readonly aws: Aws;
+  readonly clock: Clock;
+  readonly model: ModelKey;
+  readonly bucket: string;
+  readonly folder: string;
+  /** A note of a step: a code and numbers, into the folder's notes. */
+  readonly note: (code: string, numbers?: readonly number[]) => void;
+}
+
+const WAIT_IDLE_MS = 60 * 60 * 1000;
+const WAIT_RESULT_MS = 60 * 60 * 1000;
+const PNG = Buffer.from([0x89, 0x50, 0x4e, 0x47]);
+
+async function json(t: Trial, args: readonly string[]): Promise<unknown> {
+  return JSON.parse(await t.aws([...args, '--region', REGION, '--output', 'json']));
+}
+
+export async function instances(t: Trial): Promise<number> {
+  const d = (await json(t, ['sagemaker', 'describe-endpoint', '--endpoint-name', endpointName(t.model)])) as {
+    ProductionVariants?: { CurrentInstanceCount?: number }[];
+  };
+  const n = d.ProductionVariants?.[0]?.CurrentInstanceCount;
+  if (typeof n !== 'number') {
+    throw new Error('trial-endpoint');
+  }
+  return n;
+}
+
+/** Waits until the endpoint has no instance. */
+export async function waitIdle(t: Trial): Promise<void> {
+  const until = t.clock.now() + WAIT_IDLE_MS;
+  while ((await instances(t)) !== 0) {
+    if (t.clock.now() > until) {
+      throw new Error('trial-not-idle');
+    }
+    await t.clock.sleep(15000);
+  }
+}
+
+function key(location: string, bucket: string): string {
+  const prefix = `s3://${bucket}/`;
+  if (!location.startsWith(prefix)) {
+    throw new Error('trial-location');
+  }
+  return location.slice(prefix.length);
+}
+
+interface Listed {
+  readonly key: string;
+  readonly modified: number;
+}
+
+async function listed(t: Trial, prefix: string): Promise<Listed[]> {
+  const d = (await json(t, ['s3api', 'list-objects-v2', '--bucket', t.bucket, '--prefix', prefix])) as {
+    Contents?: { Key: string; LastModified: string }[];
+  };
+  return (d.Contents ?? []).map((c) => ({ key: c.Key, modified: Date.parse(c.LastModified) }));
+}
+
+/** Sends these paintings together; resolves when each result is in. */
+export async function round(t: Trial, indices: readonly number[], label: string): Promise<{
+  submitted: number;
+  done: number[];
+  outputs: string[];
+}> {
+  const stamp = t.clock.now();
+  const outputs: string[] = [];
+  const failures: string[] = [];
+  let submitted = 0;
+  for (const i of indices) {
+    const file = join(tmpdir(), `trial-${t.model}-${stamp}-${i}.json`);
+    writeFileSync(file, requestBody(t.model, i));
+    const input = `s3://${t.bucket}/in/${t.model}/${stamp}-${label}-${i}.json`;
+    try {
+      await t.aws(['s3', 'cp', file, input, '--only-show-errors', '--region', REGION]);
+    } finally {
+      rmSync(file, { force: true });
+    }
+    const answer = (await json(t, [
+      'sagemaker-runtime',
+      'invoke-endpoint-async',
+      '--endpoint-name',
+      endpointName(t.model),
+      '--input-location',
+      input,
+      '--content-type',
+      'application/json',
+      '--accept',
+      'image/png',
+    ])) as { OutputLocation?: string; FailureLocation?: string };
+    if (submitted === 0) {
+      submitted = t.clock.now();
+    }
+    if (typeof answer.OutputLocation !== 'string' || typeof answer.FailureLocation !== 'string') {
+      throw new Error('trial-invoke');
+    }
+    outputs.push(key(answer.OutputLocation, t.bucket));
+    failures.push(key(answer.FailureLocation, t.bucket));
+  }
+  t.note('submitted', [indices.length]);
+  const until = t.clock.now() + WAIT_RESULT_MS;
+  for (;;) {
+    const fail = await listed(t, `fail/${t.model}/`);
+    if (fail.some((f) => failures.includes(f.key))) {
+      throw new Error('trial-failed');
+    }
+    const out = await listed(t, `out/${t.model}/`);
+    const done = outputs.map((o) => out.find((f) => f.key === o)?.modified);
+    if (done.every((d): d is number => d !== undefined)) {
+      return { submitted, done: [...done].sort((a, b) => a - b), outputs };
+    }
+    if (t.clock.now() > until) {
+      throw new Error('trial-no-result');
+    }
+    await t.clock.sleep(2000);
+  }
+}
+
+interface Activity {
+  readonly to: number;
+  readonly start: number;
+  readonly end: number;
+}
+
+export async function activities(t: Trial): Promise<Activity[]> {
+  const d = (await json(t, [
+    'application-autoscaling',
+    'describe-scaling-activities',
+    '--service-namespace',
+    'sagemaker',
+    '--resource-id',
+    `endpoint/${endpointName(t.model)}/variant/${VARIANT}`,
+  ])) as { ScalingActivities?: { Description: string; StartTime: string; EndTime?: string; StatusCode: string }[] };
+  return (d.ScalingActivities ?? [])
+    .filter((a) => a.StatusCode === 'Successful' && a.EndTime !== undefined)
+    .map((a) => ({
+      to: Number(/count to (\d+)/.exec(a.Description)?.[1] ?? NaN),
+      start: Date.parse(a.StartTime),
+      end: Date.parse(a.EndTime ?? ''),
+    }))
+    .sort((a, b) => a.start - b.start);
+}
+
+/** The scale-out after the round's request, and the scale-in after its last result. */
+export function framed(
+  all: readonly Activity[],
+  paintings: number,
+  r: { submitted: number; done: readonly number[] },
+): Round {
+  const lastDone = r.done[r.done.length - 1] ?? NaN;
+  const out = all.find((a) => a.to === 1 && a.start >= r.submitted - 60000);
+  const inn = all.find((a) => a.to === 0 && a.start >= lastDone);
+  if (out === undefined || inn === undefined || out.end > (r.done[0] ?? NaN)) {
+    throw new Error('trial-activities');
+  }
+  return {
+    paintings,
+    submitted: r.submitted,
+    done: r.done,
+    scaleOutStart: out.start,
+    scaleOutEnd: out.end,
+    scaleInEnd: inn.end,
+  };
+}
+
+async function save(t: Trial, outputs: readonly string[], names: readonly string[]): Promise<void> {
+  for (const [n, o] of outputs.entries()) {
+    const file = join(t.folder, t.model, `${names[n]}.png`);
+    await t.aws(['s3', 'cp', `s3://${t.bucket}/${o}`, file, '--only-show-errors', '--region', REGION]);
+    if (!readFileSync(file).subarray(0, 4).equals(PNG)) {
+      throw new Error('trial-not-png');
+    }
+  }
+}
+
+export async function trial(t: Trial, instanceType: string, idleMinutes: number): Promise<Run> {
+  mkdirSync(join(t.folder, t.model), { recursive: true });
+  t.note('waitIdle');
+  await waitIdle(t);
+  const one = await round(t, [0], 'single');
+  await save(t, one.outputs, ['wake-1']);
+  t.note('singleDone');
+  await waitIdle(t);
+  const all = SCENES.map((_, i) => i);
+  const six = await round(t, all, 'batch');
+  await save(t, six.outputs, all.map((i) => String(i + 1)));
+  t.note('batchDone');
+  await waitIdle(t);
+  const acts = await activities(t);
+  // Kept before anything is worked out from it.
+  writeFileSync(join(t.folder, t.model, 'raw.json'), `${JSON.stringify({ one, six, acts }, null, 2)}\n`);
+  const run: Run = {
+    model: t.model,
+    instanceType,
+    idleMinutes,
+    single: framed(acts, 1, one),
+    batch: framed(acts, all.length, six),
+  };
+  writeFileSync(join(t.folder, t.model, 'results.json'), `${JSON.stringify(run, null, 2)}\n`);
+  writeFileSync(join(t.folder, t.model, 'results.md'), report(run));
+  t.note('finished');
+  return run;
+}
+
+const cli: Aws = (args) =>
+  new Promise((resolve, reject) => {
+    execFile('aws', [...args], { maxBuffer: 16 * 1024 * 1024 }, (error, stdout) => {
+      if (error !== null) {
+        reject(new Error(`trial-aws ${args[0] ?? ''} ${args[1] ?? ''}`));
+      } else {
+        resolve(stdout);
+      }
+    });
+  });
+
+/** The command line: <flux|sdxl> <bucket> <folder> [idle minutes] [eight-bit]. */
+export function parseArgs(argv: readonly string[]): {
+  model: ModelKey;
+  bucket: string;
+  folder: string;
+  instanceType: string;
+  idleMinutes: number;
+} {
+  const [model, bucket, folder, idle = '10', eightBit = 'no'] = argv;
+  const idleMinutes = Number(idle);
+  if (
+    (model !== 'flux' && model !== 'sdxl') ||
+    bucket === undefined ||
+    !/^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$/.test(bucket) ||
+    folder === undefined ||
+    folder === '' ||
+    !Number.isInteger(idleMinutes) ||
+    idleMinutes < 2 ||
+    idleMinutes > 60 ||
+    (eightBit !== 'yes' && eightBit !== 'no') ||
+    argv.length > 5
+  ) {
+    throw new Error('trial-usage');
+  }
+  // The run's instance is the stack's, by the same rule.
+  return { model, bucket, folder, instanceType: trialModel(model, eightBit === 'yes').instanceType, idleMinutes };
+}
+
+async function main(argv: readonly string[]): Promise<void> {
+  const { model, bucket, folder, instanceType, idleMinutes } = parseArgs(argv);
+  const notes = join(folder, `${model}-notes.txt`);
+  mkdirSync(folder, { recursive: true });
+  await trial(
+    {
+      aws: cli,
+      clock: { now: () => Date.now(), sleep: (ms) => new Promise((r) => setTimeout(r, ms)) },
+      model,
+      bucket,
+      folder,
+      note: (code, numbers = []) => appendFileSync(notes, `${new Date().toISOString()} ${code} ${numbers.join(' ')}\n`),
+    },
+    instanceType,
+    idleMinutes,
+  );
+}
+
+if (process.argv[1] !== undefined && import.meta.url === pathToFileURL(process.argv[1]).href) {
+  await main(process.argv.slice(2));
+}
diff --git a/server/tsconfig.json b/server/tsconfig.json
--- a/server/tsconfig.json
+++ b/server/tsconfig.json
@@ -21,5 +21,5 @@
     "skipLibCheck": false,
     "noEmit": true
   },
-  "include": ["src", "infra", "test"]
+  "include": ["src", "infra", "test", "trial"]
 }
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S50, D135), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S59, D135), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -160,6 +160,34 @@ ROWS = [
     ('S50', 'trial/code/inference.py',
      '.manual_seed(seed)', '.manual_seed(0)',
      'test', 'serving: seeded on the GPU, answered as PNG'),
+    # The image trial: the run.
+    ('S51', 'trial/measure.ts',
+     'const shorter = (run.idleMinutes - 2) * 60;', 'const shorter = (run.idleMinutes - 3) * 60;',
+     'test', 'the costs, from what was measured'),
+    ('S52', 'trial/measure.ts',
+     '/ (run.batch.paintings - 1);', '/ run.batch.paintings;',
+     'test', 'the costs, from what was measured'),
+    ('S53', 'trial/measure.ts',
+     "  'ml.g6e.xlarge': 2.7636,", "  'ml.g6e.xlarge': 2.6054,",
+     'test', 'the costs, from what was measured'),
+    ('S54', 'trial/measure.ts',
+     'seed: 1000 + index', 'seed: 1000',
+     'test', "a request: the prompt, the model's settings, the prompt's seed"),
+    ('S55', 'trial/run.ts',
+     "      '--accept',\n      'image/png',", "      '--accept',\n      'application/json',",
+     'test', 'a round: requests through S3, PNG asked, times from S3'),
+    ('S56', 'trial/run.ts',
+     '      rmSync(file, { force: true });\n', '',
+     'test', 'a round: requests through S3, PNG asked, times from S3'),
+    ('S57', 'trial/run.ts',
+     ' || out.end > (r.done[0] ?? NaN)', '',
+     'test', 'a round with no scaling found is refused, not guessed'),
+    ('S58', 'trial/run.ts',
+     "      throw new Error('trial-failed');\n", '',
+     'test', 'a failed painting stops the run with a code'),
+    ('S59', 'trial/run.ts',
+     "      throw new Error('trial-not-png');\n", '',
+     'test', 'a result that is not a PNG stops the run'),
 ]
 
 
```

Checks: `npm test`: `ℹ tests 80`, `ℹ fail 0`. Rows S51 to S59 caught.

Commit: `The image trial's run: one wake, six together, the cost per painting (D135)`

### Task 4 · The weights script (D136)

The script, its fakes and its tests; rows S60 to S63.

```
diff --git a/server/test/image-trial-fetch.test.ts b/server/test/image-trial-fetch.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/image-trial-fetch.test.ts
@@ -0,0 +1,173 @@
+// The trial's weights script (trial/fetch-weights.sh) against a fake hub
+// and a fake AWS CLI, both small programs on PATH: no network, no AWS.
+// The repository, files and token are invented.
+import assert from 'node:assert/strict';
+import { spawnSync } from 'node:child_process';
+import { createHash } from 'node:crypto';
+import { chmodSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
+import { tmpdir } from 'node:os';
+import { dirname, join } from 'node:path';
+import { test } from 'node:test';
+import { fileURLToPath } from 'node:url';
+
+const SCRIPT = fileURLToPath(new URL('../trial/fetch-weights.sh', import.meta.url));
+const HUB = 'https://hub.invented';
+const REPO = 'maker/model';
+const REV = 'a'.repeat(40);
+const TOKEN = 'invented-token-value';
+const BUCKET = 'trial-bucket-invented';
+
+const sha256 = (b: Buffer): string => createHash('sha256').update(b).digest('hex');
+const gitOid = (b: Buffer): string =>
+  createHash('sha1').update(Buffer.concat([Buffer.from(`blob ${b.length}\0`), b])).digest('hex');
+
+// The hub's files: [path, content, large (with a sha256)].
+const FILES: [string, string, boolean][] = [
+  ['model_index.json', '{"_class_name":"Pipe","unet":["d","U"],"vae":["d","V"],"tokenizer":["t","T"]}', false],
+  ['unet/config.json', '{"u":1}', false],
+  ['unet/diffusion_pytorch_model.safetensors', 'unet weights', true],
+  ['unet/diffusion_pytorch_model.fp16.safetensors', 'unet half', true],
+  ['unet/model.onnx', 'onnx', true],
+  ['vae/diffusion_pytorch_model.safetensors', 'vae weights', true],
+  ['tokenizer/vocab.json', '{"a":1}', false],
+  ['tokenizer/merges.txt', 'a b', false],
+  ['vae_1_0/diffusion_pytorch_model.safetensors', 'other vae', true],
+  ['whole.safetensors', 'single file', true],
+  ['README.md', 'readme', false],
+];
+const WANTED = [
+  'model_index.json',
+  'tokenizer/merges.txt',
+  'tokenizer/vocab.json',
+  'unet/config.json',
+  'unet/diffusion_pytorch_model.safetensors',
+  'vae/diffusion_pytorch_model.safetensors',
+];
+
+const FAKES = fileURLToPath(new URL('trial-fakes/', import.meta.url));
+
+interface Setup {
+  state: string;
+  run: (args?: string[], env?: Record<string, string>) => { status: number | null; stdout: string; stderr: string };
+}
+
+function setup(changeHub: (b: Buffer, p: string) => Buffer = (b) => b): Setup {
+  const state = mkdtempSync(join(tmpdir(), 'trial-fetch-'));
+  const bin = join(state, 'bin');
+  mkdirSync(bin);
+  for (const name of ['curl', 'aws']) {
+    writeFileSync(join(bin, name), `#!/bin/sh\nexec '${process.execPath}' '${FAKES}${name}.cjs' "$@"\n`);
+  }
+  chmodSync(join(bin, 'curl'), 0o755);
+  chmodSync(join(bin, 'aws'), 0o755);
+  const tree = FILES.map(([p, content, large]) => {
+    const b = Buffer.from(content);
+    const file = join(state, 'hub', p);
+    mkdirSync(dirname(file), { recursive: true });
+    writeFileSync(file, changeHub(b, p));
+    const entry = { type: 'file', path: p, size: b.length, oid: gitOid(b) };
+    return large ? { ...entry, lfs: { oid: sha256(b), size: b.length, pointerSize: 130 } } : entry;
+  });
+  writeFileSync(join(state, 'tree.json'), JSON.stringify([{ type: 'directory', path: 'unet', size: 0, oid: 'x' }, ...tree]));
+  const run = (args = [HUB, REPO, REV, 'sdxl', BUCKET], env: Record<string, string> = {}) => {
+    const r = spawnSync('bash', [SCRIPT, ...args], {
+      encoding: 'utf8',
+      env: {
+        PATH: `${bin}:${process.env['PATH'] ?? ''}`,
+        TMPDIR: tmpdir(),
+        FAKE_STATE: state,
+        FAKE_TOKEN: TOKEN,
+        FAKE_HUB: HUB,
+        FAKE_REPO: REPO,
+        FAKE_REV: REV,
+        ...env,
+      },
+    });
+    return { status: r.status, stdout: r.stdout, stderr: r.stderr };
+  };
+  return { state, run };
+}
+
+function uploaded(state: string): string[] {
+  const root = join(state, 's3', BUCKET, 'models', 'sdxl');
+  return WANTED.filter((p) => existsSync(join(root, p))).concat(
+    FILES.map(([p]) => p).filter((p) => !WANTED.includes(p) && existsSync(join(root, p))),
+  );
+}
+
+test("weights: only the parts' files, checked, kept on a rerun", () => {
+  const { state, run } = setup();
+  try {
+    const first = run();
+    assert.equal(first.status, 0, first.stderr);
+    assert.equal(first.stdout, 'fetched 6 kept 0\n');
+    assert.deepEqual(uploaded(state), WANTED);
+    for (const p of WANTED) {
+      const content = FILES.find(([q]) => q === p)?.[1] ?? '';
+      assert.equal(readFileSync(join(state, 's3', BUCKET, 'models', 'sdxl', p), 'utf8'), content);
+    }
+    const again = run();
+    assert.equal(again.status, 0, again.stderr);
+    assert.equal(again.stdout, 'fetched 0 kept 6\n');
+  } finally {
+    rmSync(state, { recursive: true, force: true });
+  }
+});
+
+test('weights: the token never on a command line or screen', () => {
+  const { state, run } = setup();
+  try {
+    const r = run();
+    assert.equal(r.status, 0, r.stderr);
+    const argv = readFileSync(join(state, 'argv'), 'utf8');
+    assert.equal(argv.includes(TOKEN), false);
+    assert.equal(r.stdout.includes(TOKEN) || r.stderr.includes(TOKEN), false);
+    assert.match(argv, /"--name","\/souldreams\/trial\/hf-token","--with-decryption"/);
+    for (const line of argv.trim().split('\n')) {
+      const call = JSON.parse(line) as string[];
+      if (call[0] === 'aws') {
+        assert.equal(call[call.indexOf('--region') + 1], 'eu-north-1', line);
+      }
+    }
+  } finally {
+    rmSync(state, { recursive: true, force: true });
+  }
+});
+
+test('weights: a large file read back wrong is removed; a stop', () => {
+  const { state, run } = setup();
+  try {
+    const r = run(undefined, { FAKE_CORRUPT: 'unet/diffusion_pytorch_model.safetensors' });
+    assert.equal(r.status, 3);
+    assert.equal(r.stderr, 'fetch-hash unet/diffusion_pytorch_model.safetensors\n');
+    assert.equal(existsSync(join(state, 's3', BUCKET, 'models', 'sdxl', 'unet', 'diffusion_pytorch_model.safetensors')), false);
+  } finally {
+    rmSync(state, { recursive: true, force: true });
+  }
+});
+
+test('weights: a small file unlike the hub is never uploaded', () => {
+  const { state, run } = setup((b, p) => (p === 'unet/config.json' ? Buffer.from('{"u":2}') : b));
+  try {
+    const r = run();
+    assert.equal(r.status, 3);
+    assert.equal(r.stderr, 'fetch-hash unet/config.json\n');
+    assert.equal(existsSync(join(state, 's3', BUCKET, 'models', 'sdxl', 'unet', 'config.json')), false);
+  } finally {
+    rmSync(state, { recursive: true, force: true });
+  }
+});
+
+test('weights: the arguments are refused unless exact', () => {
+  const { state, run } = setup();
+  try {
+    assert.equal(run([HUB, REPO, REV, 'sdxl']).status, 2);
+    assert.equal(run([HUB, REPO, REV, 'sd3', BUCKET]).status, 2);
+    assert.equal(run([HUB, REPO, 'main', 'sdxl', BUCKET]).status, 2);
+    assert.equal(run([HUB, REPO, 'A'.repeat(40), 'sdxl', BUCKET]).status, 2);
+    assert.equal(run([HUB, REPO, 'a'.repeat(39), 'sdxl', BUCKET]).status, 2);
+    assert.equal(existsSync(join(state, 'argv')), false);
+  } finally {
+    rmSync(state, { recursive: true, force: true });
+  }
+});
diff --git a/server/test/trial-fakes/aws.cjs b/server/test/trial-fakes/aws.cjs
new file mode 100644
--- /dev/null
+++ b/server/test/trial-fakes/aws.cjs
@@ -0,0 +1,22 @@
+// A fake AWS CLI for the trial's weights test: S3 as a folder in the
+// state folder. Run by node from a wrapper on PATH.
+const fs = require('fs'); const path = require('path');
+const out = (b) => { const buf = Buffer.from(b); let o = 0; while (o < buf.length) { o += fs.writeSync(1, buf, o); } };
+const state = process.env.FAKE_STATE; const args = process.argv.slice(2);
+fs.appendFileSync(path.join(state, 'argv'), JSON.stringify(['aws', ...args]) + '\n');
+const s3 = (u) => path.join(state, 's3', u.replace(/^s3:\/\//, ''));
+if (args[0] === 'ssm') { out(process.env.FAKE_TOKEN + '\n'); process.exit(0); }
+if (args[0] === 's3api' && args[1] === 'head-object') {
+  const f = path.join(state, 's3', args[args.indexOf('--bucket') + 1], args[args.indexOf('--key') + 1]);
+  if (!fs.existsSync(f)) { process.exit(254); }
+  out(fs.statSync(f).size + '\n'); process.exit(0);
+}
+if (args[0] === 's3' && args[1] === 'cp') {
+  const [from, to] = [args[2], args[3]];
+  const data = from === '-' ? fs.readFileSync(0) : from.startsWith('s3://') ? fs.readFileSync(s3(from)) : fs.readFileSync(from);
+  if (to === '-') { out(data); process.exit(0); }
+  const stored = process.env.FAKE_CORRUPT && to.includes(process.env.FAKE_CORRUPT) ? Buffer.from('corrupt') : data;
+  fs.mkdirSync(path.dirname(s3(to)), { recursive: true }); fs.writeFileSync(s3(to), stored); process.exit(0);
+}
+if (args[0] === 's3' && args[1] === 'rm') { fs.rmSync(s3(args[2])); process.exit(0); }
+process.exit(99);
diff --git a/server/test/trial-fakes/curl.cjs b/server/test/trial-fakes/curl.cjs
new file mode 100644
--- /dev/null
+++ b/server/test/trial-fakes/curl.cjs
@@ -0,0 +1,17 @@
+// A fake curl for the trial's weights test: answers from the state folder,
+// only with the right token's header. Run by node from a wrapper on PATH.
+const fs = require('fs'); const path = require('path');
+const out = (b) => { const buf = Buffer.from(b); let o = 0; while (o < buf.length) { o += fs.writeSync(1, buf, o); } };
+const state = process.env.FAKE_STATE; const args = process.argv.slice(2);
+fs.appendFileSync(path.join(state, 'argv'), JSON.stringify(['curl', ...args]) + '\n');
+const h = args[args.indexOf('-H') + 1];
+const header = h && h.startsWith('@') ? fs.readFileSync(h.slice(1), 'utf8') : '';
+if (header !== 'Authorization: Bearer ' + process.env.FAKE_TOKEN + '\n') { process.exit(22); }
+const url = args[args.length - 1]; const base = process.env.FAKE_HUB + '/';
+const rest = url.slice(base.length);
+const tree = 'api/models/' + process.env.FAKE_REPO + '/tree/' + process.env.FAKE_REV + '?recursive=true';
+if (rest === tree) { out(fs.readFileSync(path.join(state, 'tree.json'))); process.exit(0); }
+const pre = process.env.FAKE_REPO + '/resolve/' + process.env.FAKE_REV + '/';
+const file = path.join(state, 'hub', rest.slice(pre.length));
+if (!rest.startsWith(pre) || !fs.existsSync(file)) { process.exit(22); }
+out(fs.readFileSync(file));
diff --git a/server/trial/fetch-weights.sh b/server/trial/fetch-weights.sh
new file mode 100755
--- /dev/null
+++ b/server/trial/fetch-weights.sh
@@ -0,0 +1,98 @@
+#!/bin/bash
+# The image trial's weights (D135, D136): from the model hub into the
+# trial bucket, run by the owner in CloudShell in eu-north-1
+# (docs/plans/image-trial.md). Only the files of the pipeline's parts at
+# the pinned revision: no single-file copies, no fp16 copies, no other
+# formats. A file already in the bucket at its size is kept, so a cut
+# session simply runs again. Each new file is checked against the hub's
+# hash: a large one read back from S3, a small one before it goes up.
+# The hub's address is the owner's argument. The token is read from
+# Parameter Store into a header file, never onto a command line or the
+# screen (R5). It writes counts and codes only.
+#   fetch-weights.sh <hub> <repo> <revision> <flux|sdxl> <bucket>
+set -euo pipefail
+
+fail() {
+  echo "$1" >&2
+  exit "$2"
+}
+
+[ "$#" -eq 5 ] || fail fetch-usage 2
+hub=$1
+repo=$2
+rev=$3
+model=$4
+bucket=$5
+case $model in
+  flux | sdxl) ;;
+  *) fail fetch-usage 2 ;;
+esac
+case $rev in
+  '' | *[!0-9a-f]*) fail fetch-revision 2 ;;
+esac
+[ "${#rev}" -eq 40 ] || fail fetch-revision 2
+
+umask 077
+work=$(mktemp -d "${TMPDIR:-/tmp}/fetch-weights.XXXXXX")
+trap 'rm -rf "$work"' EXIT
+headers="$work/headers"
+token=$(aws ssm get-parameter --region eu-north-1 --name /souldreams/trial/hf-token \
+  --with-decryption --query Parameter.Value --output text)
+printf 'Authorization: Bearer %s\n' "$token" >"$headers"
+unset token
+
+# The header goes only to the hub: curl drops it on a redirect elsewhere.
+get() {
+  curl -sSfL --retry 3 -H "@$headers" "$hub/$1"
+}
+
+get "api/models/$repo/tree/$rev?recursive=true" >"$work/tree.json"
+get "$repo/resolve/$rev/model_index.json" >"$work/model_index.json"
+jq -r 'keys[]|select(startswith("_")|not)' "$work/model_index.json" >"$work/parts.all"
+grep -Ex '[A-Za-z0-9_]+' "$work/parts.all" >"$work/parts" || true
+jq -r '.[]|select(.type=="file")|[.path,(.size|tostring),(.lfs.oid//"-"),.oid]|@tsv' \
+  "$work/tree.json" >"$work/all"
+# model_index.json, and each part's own files one folder deep; never an
+# fp16 copy, and only these kinds of file.
+while IFS=$'\t' read -r path size sha oid; do
+  case $path in
+    *.fp16.*) continue ;;
+    *.json | *.txt | *.model | *.safetensors) ;;
+    *) continue ;;
+  esac
+  if [ "$path" != model_index.json ]; then
+    part=${path%%/*}
+    rest=${path#*/}
+    [ "$part" != "$path" ] && [ "${rest#*/}" = "$rest" ] && grep -Fxq "$part" "$work/parts" || continue
+  fi
+  printf '%s\t%s\t%s\t%s\n' "$path" "$size" "$sha" "$oid"
+done <"$work/all" >"$work/files"
+[ -s "$work/files" ] || fail fetch-nothing 3
+
+fetched=0
+kept=0
+while IFS=$'\t' read -r path size sha oid <&3; do
+  key="models/$model/$path"
+  have=$(aws s3api head-object --region eu-north-1 --bucket "$bucket" --key "$key" \
+    --query ContentLength --output text 2>/dev/null || true)
+  if [ "$have" = "$size" ]; then
+    kept=$((kept + 1))
+    continue
+  fi
+  if [ "$sha" = "-" ]; then
+    get "$repo/resolve/$rev/$path" >"$work/small"
+    got=$( (printf 'blob %s\0' "$size" && cat "$work/small") | sha1sum | cut -c1-40)
+    [ "$got" = "$oid" ] || fail "fetch-hash $path" 3
+    aws s3 cp "$work/small" "s3://$bucket/$key" --region eu-north-1 --only-show-errors
+  else
+    get "$repo/resolve/$rev/$path" |
+      aws s3 cp - "s3://$bucket/$key" --region eu-north-1 --expected-size "$size" --only-show-errors
+    got=$(aws s3 cp "s3://$bucket/$key" - --region eu-north-1 --only-show-errors | sha256sum | cut -c1-64)
+    if [ "$got" != "$sha" ]; then
+      aws s3 rm "s3://$bucket/$key" --region eu-north-1 --only-show-errors
+      fail "fetch-hash $path" 3
+    fi
+  fi
+  fetched=$((fetched + 1))
+done 3<"$work/files"
+echo "fetched $fetched kept $kept"
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S59, D135), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S63, D135), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -188,6 +188,19 @@ ROWS = [
     ('S59', 'trial/run.ts',
      "      throw new Error('trial-not-png');\n", '',
      'test', 'a result that is not a PNG stops the run'),
+    # The image trial: the weights script.
+    ('S60', 'trial/fetch-weights.sh',
+     '    *.fp16.*) continue ;;\n', '',
+     'test', "weights: only the parts' files, checked, kept on a rerun"),
+    ('S61', 'trial/fetch-weights.sh',
+     '      aws s3 rm "s3://$bucket/$key" --region eu-north-1 --only-show-errors\n', '',
+     'test', 'weights: a large file read back wrong is removed; a stop'),
+    ('S62', 'trial/fetch-weights.sh',
+     '    [ "$got" = "$oid" ] || fail "fetch-hash $path" 3\n', '',
+     'test', 'weights: a small file unlike the hub is never uploaded'),
+    ('S63', 'trial/fetch-weights.sh',
+     '[ "${#rev}" -eq 40 ] || fail fetch-revision 2\n', '',
+     'test', 'weights: the arguments are refused unless exact'),
 ]
 
 
```

Checks: `npm test`: `ℹ tests 85`, `ℹ fail 0`. Rows S60 to S63 caught; the whole run `server mutations: 63 run,
63 caught`. `ls -l server/trial/fetch-weights.sh` shows `-rwxr-xr-x`.

Commit: `The image trial's weights script for CloudShell, each file checked against the hub`

### Task 5 · Docs: Status.md

```
diff --git a/docs/Status.md b/docs/Status.md
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-22, in branch `life-context` (Life Context, the mechanical part, D110 item 2, D131 to D134; the owner's look passed and the full mutation run done; the merge next), by Claude Code.
+Last updated: 2026-11-22, in branch `image-trial` (the trial of open image models in our own AWS account, D135, D136; the owner's AWS tasks next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,7 +14,14 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`life-context`: Life Context, the mechanical part (D110, head's message 24 item 2; C159-I item 1; D127; D128; D131; plan
+`image-trial`: a trial of open image models in our own AWS account, for the founder to choose (D135, D136; plan
+`docs/plans/image-trial.md`): FLUX.1 [schnell] on ml.g6e.xlarge and SDXL on ml.g6.xlarge, SageMaker asynchronous
+inference in eu-north-1, scaled to zero, a private bucket deleting requests and results within a day, a USD 30
+budget alarm, the same six invented prompts on each, the times and costs measured, the images on the owner's Mac,
+then a teardown that removes everything. A separate stack (`SoulDreamsImageTrial`), made only when asked; the
+server's own stack is unchanged. The app is unchanged.
+
+`life-context` is merged (`eaf0da1`): Life Context, the mechanical part (D110, head's message 24 item 2; C159-I item 1; D127; D128; D131; plan
 `docs/plans/life-context.md`): what counts as a sentence, the kept sentences on the phone, the Recent window's sweep,
 Off deleting what is kept, the page "What you've told Soul Dreams" from Settings, and SoulDreams Dev's invented kept
 sentences. Nothing calls the capture yet: a night holds only dreams, and its real sources come with Questions and
@@ -24,9 +31,11 @@ merge (this entry records it).
 
 ## Road ahead
 
-- `life-context`: the merge. The owner's by-eye review passed (plan Task 7, with D133 and D134; VoiceOver waits for
-  the full pass, D98) and the full mutation run is done: `app mutations: 726 run, 726 caught` at `46d5ebd` (9 min 1 s
-  on the owner's Mac, parallel). The Product questions are banked (items 167 and 169).
+- `image-trial`: the owner's AWS tasks (plan Part 3, Tasks 6 to 12), the founder's choice from the images and the
+  costs, then the teardown and its proof (Task 12). The plan's questions are its Part 4.
+- `life-context` (merged): the owner's by-eye review passed (plan Task 7, with D133 and D134; VoiceOver waits for
+  the full pass, D98) and the full mutation run was done: `app mutations: 726 run, 726 caught` at `46d5ebd` (9 min
+  1 s on the owner's Mac, parallel). The Product questions are banked (items 167 and 169).
 - Then "Made by AI"; Feedback, with its server change (D121 item 4). Life Context's sources (the opening's answers,
   what is said after it, the reflection, Waking Life) come with Questions and Reflection, and with them the mark on a
   tapped sentence's night (D131 item 3). The curated set of night paintings (about 60, the founder's)
@@ -391,9 +400,15 @@ merge (this entry records it).
   and that the log group is deleted with the stack (D44 a, b, c).
 - The CDK CLI's own synth was run once, with no credentials (Task 8, D45): the `Resources` section holds the nine
   types of `test/stack.test.ts` and no `AWS::CDK::Metadata`; `Parameters` holds only `BootstrapVersion`.
-- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 47 tests, and
-  30 mutation checks (S1 to S30) in `tool/server_mutations.py`, run by hand from the repository root with
-  `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 30 run, 30 caught`); `check_all.sh` does not
+- The image trial (D135, D136; `docs/plans/image-trial.md`), beside the server and not part of it:
+  `server/infra/image-trial.ts` (the stack `SoulDreamsImageTrial`, made by `infra/app.ts` only with
+  `-c imageTrial=...`), `server/trial/code/inference.py` (the serving code, run in AWS's Hugging Face container),
+  `server/trial/measure.ts` and `server/trial/run.ts` (the six invented prompts, the run on the owner's Mac and the
+  costs) and `server/trial/fetch-weights.sh` (the weights, from the model hub into the bucket, in CloudShell). Its
+  tests run with the server's, against fakes: no AWS, no network.
+- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 85 tests, and
+  63 mutation checks (S1 to S63) in `tool/server_mutations.py`, run by hand from the repository root with
+  `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 63 run, 63 caught`); `check_all.sh` does not
   call it (D43 Q3). It first runs the type check and the tests on the unbroken server, and stops with
   `server mutations: FAILED (the unbroken server fails)`, exit 1, if either fails (the final review, `2fbaad6`).
 
@@ -1072,6 +1087,17 @@ Banked in redesign-c (D91; none changes what the dreamer sees beyond D110, D121
      above the lists, or alone when nothing is kept, where MP·92 ("What you share about your waking life will appear
      here.") would stand (plan Part 4, question 5).
 
+Banked in image-trial (D91; nothing a dreamer sees changes):
+
+170. For Product, through the head, before any image model ships (licences read 2026-11-22 on each model's page):
+     SDXL's licence (CreativeML Open RAIL++-M) requires its use restrictions (Attachment A) as an enforceable
+     provision in the agreement with every user; FLUX.1 [schnell] is Apache-2.0 (its page; its LICENSE link gave 404)
+     and gated: the download needs a Hugging Face account that shares its contact details; SD 3.5 Medium, skipped
+     (D136), would have required registration and "Powered by Stability AI" shown publicly.
+171. The trial's price basis: AWS's Price List for eu-north-1 has no hosting or asynchronous-inference entry for any
+     g6e size (published 2026-11-22), though the console offers ml.g6e.xlarge (D136). The trial's g6e cost uses the
+     Training price, USD 2.7636 per hour, until the owner's bill shows the rate (plan Task 12).
+
 ## Before Cohort 1
 
 1. No tester build while `app/assets/words/pending-lines.csv` holds any line (the owner's ruling on Task 2's review,
@@ -1548,6 +1574,20 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   real `--dart-define-from-file` parsing); the one dependency that could have hidden them, the seed keeping
   sentences only while Life Context was On at that moment, is gone, and the seed logs `previewSeeded`.
 
+## Rulings during image-trial
+
+- `life-context` merged by the owner (`eaf0da1`).
+- D135 (owner, the brainstorm): (1) a trial of FLUX.1 [schnell] on ml.g6e.xlarge and SDXL on ml.g6.xlarge (SD 3.5
+  Medium if simple), each licence read on its own page; (2) eu-north-1 only; SageMaker asynchronous inference; the
+  requests and results in a private, encrypted bucket that deletes them within a day; no logging of prompts; (3) a
+  USD 30 budget alarm, at most one instance per endpoint, scale to zero after 10 idle minutes, a teardown removing
+  everything; (4) the owner runs every AWS step. Also: the cost per painting when each wakes the machine, at idle
+  times of 2 and 10 minutes, against warm, and a daily batch's.
+- D136 (owner, on the stop `.scratch/for-build-chat/image-trial-stop.md`): the console offers ml.g6e.xlarge in
+  eu-north-1. FLUX.1 [schnell] at full precision on ml.g6e.xlarge, SDXL on ml.g6.xlarge; SD 3.5 Medium skipped. The
+  plan's first AWS task proves g6e; if it fails as unsupported, FLUX in 8 bits on ml.g6.xlarge (one package inside
+  the serving container, pinned). The Hugging Face token, if needed, an owner task, kept in Parameter Store (R5).
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's `ac3a013`, in branch `redesign-b` (C18-P and C160-I); the
```

Checks: the hook's guards pass.

Commit: `Status.md: the image trial (D135, D136), the owner's AWS tasks next`

Then the Build chat reviews the branch before any owner task.

---

**The owner's tasks (6 to 12).** Every AWS step is the owner's (R13). In the pastes, replace `<workload>` with the
workload account's profile, `<workload id>` with its number, `<email>` with the address for the budget's alerts, and
`<B>` with the bucket's name from Task 7. Every command names eu-north-1 except the account-wide ones (IAM, Budgets).
If any output differs from the one expected, stop and bring it to the Build chat (R14).

### Task 6 · [OWNER] The Hugging Face token (D136)

1. On huggingface.co, logged in: open the FLUX.1 [schnell] page (`black-forest-labs/FLUX.1-schnell`) and accept its
   conditions (this shares the account's contact information with Black Forest Labs).
2. Settings → Access Tokens → Create new token → Fine-grained, with only "Read access to contents of all public gated
   repos you can access". Copy it.
3. Save it without a newline, put it in Parameter Store, and remove the local copy.

Paste 1 — Terminal (the token on the clipboard)
```
cd ~/.soul-dreams && umask 077 && pbpaste | tr -d '\n' > hf-token.txt && wc -c < hf-token.txt && pbcopy < /dev/null
```

Expected: one number, the token's length (about 37).

Paste 2 — Terminal
```
cd ~/.soul-dreams && aws ssm put-parameter --profile <workload> --region eu-north-1 --name /souldreams/trial/hf-token --type SecureString --value "file://$HOME/.soul-dreams/hf-token.txt" && aws ssm describe-parameters --profile <workload> --region eu-north-1 --parameter-filters 'Key=Name,Values=/souldreams/trial/hf-token' --query 'Parameters[].[Name,Type,Tier,KeyId]' --output text && rm hf-token.txt
```

Expected: put-parameter's answer (version 1, tier Standard), then `/souldreams/trial/hf-token  SecureString  Standard
alias/aws/ssm`, and no `hf-token.txt` left.

### Task 7 · [OWNER] The bucket and the budget (`imageTrial=bucket`)

Paste 1 — Terminal (always through the app, as banked item 49)
```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk deploy SoulDreamsImageTrial -c account=<workload id> -c imageTrial=bucket -c alertEmail=<email> --profile <workload>
```

Expected: the CDK lists the bucket policy's statement and asks to deploy (answer `y`); then `✅  SoulDreamsImageTrial`
and one output, `SoulDreamsImageTrial.BucketName = souldreamsimagetrial-bucket...`. That name is `<B>` from here on.
If the budget fails to create (for example the account's region rule refusing AWS Budgets, whose API is global),
CloudFormation rolls back: stop and bring the event's reason [ASSUMED: Budgets works from the workload account].

Paste 2 — Terminal (the bucket's settings and the budget)
```
aws s3api get-public-access-block --bucket <B> --profile <workload> --region eu-north-1 --output text && aws s3api get-bucket-encryption --bucket <B> --profile <workload> --region eu-north-1 --query 'ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm' --output text && aws s3api get-bucket-lifecycle-configuration --bucket <B> --profile <workload> --region eu-north-1 --query 'Rules' && aws budgets describe-budget --account-id <workload id> --budget-name souldreams-image-trial --profile <workload> --query 'Budget.BudgetLimit' --output text
```

Expected: `PUBLICACCESSBLOCKCONFIGURATION  True  True  True  True`; `AES256`; four rules, three expiring `in/`,
`out/` and `fail/` after 1 day and one aborting unfinished uploads after 1 day; `30.0  USD`.

### Task 8 · [OWNER] FLUX's weights into the bucket (CloudShell)

1. In the AWS console, region **Europe (Stockholm)**, open CloudShell. Actions → Upload file →
   `~/Developer/soul-dreams-app/server/trial/fetch-weights.sh`.
2. Run it. It takes roughly 10 to 30 minutes [ESTIMATE] for about 33.7 GB. CloudShell ends a session after 20 to 30
   minutes without a key press: press a key now and then. If the session ends, open it again and run the same paste:
   files already in the bucket are kept.

Paste 1 — CloudShell
```
bash fetch-weights.sh https://huggingface.co black-forest-labs/FLUX.1-schnell 169573f54945f633efbe126a40a5676b4228363c flux <B>
```

Expected: `fetched 23 kept 0` (or, after a cut, two numbers adding to 23; a second run prints `fetched 0 kept 23`).
`fetch-hash <file>`, `fetch-nothing` or a `curl:` error is a stop. The 23 are `model_index.json` and the files of
`scheduler`, `text_encoder`, `text_encoder_2`, `tokenizer`, `tokenizer_2`, `transformer` and `vae` [READ, the Hub's
file list at the pinned revision]; never `flux1-schnell.safetensors` or `ae.safetensors`.

Paste 2 — Terminal (the serving code beside the weights)
```
cd ~/Developer/soul-dreams-app/server && aws s3 cp trial/code/inference.py s3://<B>/models/flux/code/inference.py --profile <workload> --region eu-north-1 --only-show-errors && aws s3 ls s3://<B>/models/flux/ --recursive --summarize --profile <workload> --region eu-north-1 | tail -2
```

Expected: `Total Objects: 24` and `Total Size:` a little over 33 720 000 000 (the six large files are 33 720 953 870
bytes [READ]).

### Task 9 · [OWNER] FLUX's endpoint: the proof of g6e (D136)

Paste 1 — Terminal
```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk deploy SoulDreamsImageTrial -c account=<workload id> -c imageTrial=flux -c alertEmail=<email> --profile <workload>
```

Expected: the CDK lists the new role and its permissions and asks (answer `y`). Creating the endpoint starts a
g6e.xlarge, copies 34 GB to it and loads FLUX: allow up to 40 minutes [ESTIMATE]. Then `✅  SoulDreamsImageTrial`.

- **If it fails**: CloudFormation rolls the change back (the endpoint goes, no instance is left running; the bucket
  and weights stay). Console → CloudFormation → `SoulDreamsImageTrial` → Events: the first `CREATE_FAILED` names a
  resource and a reason. If the reason says the instance type is **not supported or not available in this region**,
  go to Fallback F. Any other reason (the model failing to load, a timeout, a permission) is a stop: bring the
  reason, and the last lines of `aws logs tail /aws/sagemaker/Endpoints/souldreams-trial-flux --since 1h --profile
  <workload> --region eu-north-1`.

Paste 2 — Terminal (once deployed)
```
aws sagemaker describe-endpoint --endpoint-name souldreams-trial-flux --profile <workload> --region eu-north-1 --query '[EndpointStatus,ProductionVariants[0].CurrentInstanceCount]' --output text
```

Expected: `InService  1`; about 12 minutes later, `InService  0` (scaled to zero, nothing asked).

### Task 10 · [OWNER] FLUX's run [SET ASIDE, D141: not run; Task 11 follows Task 9's removal, Part 6]

Paste 1 — Terminal (no output while it runs; about 1.5 to 3 hours [ESTIMATE, D140]: two cold starts of about 35 minutes and their tails, and a capacity wait if there is one; it waits up to 3 hours for each round's results)
```
cd ~/Developer/soul-dreams-app/server && AWS_PROFILE=<workload> node trial/run.ts flux <B> ~/Desktop/image-trial
```

It waits for the endpoint to have no instance, sends one painting, waits for it to scale back to none, sends the
six, waits again, then writes the results. Its progress, in another window:
`cat ~/Desktop/image-trial/flux-notes.txt` (lines `waitIdle`, `submitted 1`, `singleDone`, `submitted 6`,
`batchDone`, `finished`, each with its time). A stop prints `Error: trial-<code>` and exits 1: bring the code and
the notes file. A stop keeps `fail/`, and after `trial-no-result` also `in/` (D139, D140); what remains in the bucket
expires by its lifecycle rule within about two days.

Paste 2 — Terminal
```
ls ~/Desktop/image-trial/flux && cat ~/Desktop/image-trial/flux/results.md
```

Expected: `1.png` to `6.png`, `raw.json`, `results.json`, `results.md`, `wake-1.png`; then the table (Part 1, "The
measures"). Look at the images; bring `results.md`.

### Task 11 · [OWNER] SDXL, and the logs' proof

Paste 1 — CloudShell (about 13.9 GB)
```
bash fetch-weights.sh https://huggingface.co stabilityai/stable-diffusion-xl-base-1.0 462165984030d82259a11f4367a4eed129e94a7b sdxl <B>
```

Expected: `fetched 18 kept 0`: `model_index.json` and the files of `scheduler`, `text_encoder`, `text_encoder_2`,
`tokenizer`, `tokenizer_2`, `unet` and `vae`, full-precision copies only [READ, the Hub's file list].

Paste 2 — Terminal
```
cd ~/Developer/soul-dreams-app/server && aws s3 cp trial/code/inference.py s3://<B>/models/sdxl/code/inference.py --profile <workload> --region eu-north-1 --only-show-errors && aws s3 ls s3://<B>/models/sdxl/ --recursive --summarize --profile <workload> --region eu-north-1 | tail -2
```

Expected: `Total Objects: 19` and `Total Size:` a little over 13 875 000 000 (the four large files are 13 875 688 436
bytes [READ]).

Paste 3 — Terminal (adds SDXL; FLUX's endpoint unchanged)
```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk deploy SoulDreamsImageTrial -c account=<workload id> -c imageTrial=both -c alertEmail=<email> --profile <workload>
```

Expected: `✅  SoulDreamsImageTrial`, then, as Task 9's Paste 2 with `souldreams-trial-sdxl`, `InService  1`.

Paste 4 — Terminal (about 45 to 60 minutes)
```
cd ~/Developer/soul-dreams-app/server && AWS_PROFILE=<workload> node trial/run.ts sdxl <B> ~/Desktop/image-trial && cat ~/Desktop/image-trial/sdxl/results.md
```

Expected: as Task 10, under `sdxl/`.

Paste 5 — Terminal (no prompt word in either log; the toolkit's timings are there)
```
for m in flux sdxl; do for w in wheat cypress almond sunflowers olive canal impasto; do aws logs filter-log-events --log-group-name /aws/sagemaker/Endpoints/souldreams-trial-$m --filter-pattern "\"$w\"" --profile <workload> --region eu-north-1 --query 'length(events)' --output text; done; aws logs filter-log-events --log-group-name /aws/sagemaker/Endpoints/souldreams-trial-$m --filter-pattern '"Predict time"' --profile <workload> --region eu-north-1 --query 'length(events)' --output text; done
```

Expected: seven `0`, then a number of 7 or more (FLUX); the same for SDXL. A word found is a stop (D135 item 2).

### Task 12 · [OWNER] The teardown, its proof, and the bill

Do it once the images are on the Mac; the founder can choose from them after.

Paste 1 — Terminal (empty the bucket: CloudFormation cannot delete a bucket that holds anything)
```
aws s3 rm s3://<B> --recursive --profile <workload> --region eu-north-1 --only-show-errors && aws s3 ls s3://<B> --recursive --profile <workload> --region eu-north-1 | wc -l
```

Expected: `0`.

Paste 2 — Terminal
```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk destroy SoulDreamsImageTrial -c account=<workload id> -c imageTrial=both -c alertEmail=<email> --profile <workload>
```

Expected: asked to confirm (`y`), then `✅  SoulDreamsImageTrial: destroyed`. This removes the endpoints, endpoint
configurations, models, scaling, alarms, log groups, the role, the bucket and the budget.

Paste 3 — Terminal (the token and Application Auto Scaling's own role, which AWS made at the first deploy)
```
aws ssm delete-parameter --name /souldreams/trial/hf-token --profile <workload> --region eu-north-1 && aws iam delete-service-linked-role --role-name AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint --profile <workload> --query DeletionTaskId --output text
```

Expected: one line, a deletion task's id. A minute later:
`aws iam get-service-linked-role-deletion-status --deletion-task-id '<that id>' --profile <workload> --query Status --output text`
prints `SUCCEEDED`.

Paste 4 — Terminal (the proof: each line answers as shown)
```
aws cloudformation describe-stacks --stack-name SoulDreamsImageTrial --profile <workload> --region eu-north-1
aws sagemaker list-endpoints --name-contains souldreams-trial --profile <workload> --region eu-north-1 --query 'length(Endpoints)' --output text
aws sagemaker list-endpoint-configs --profile <workload> --region eu-north-1 --query 'length(EndpointConfigs)' --output text
aws sagemaker list-models --profile <workload> --region eu-north-1 --query 'length(Models)' --output text
aws s3api head-bucket --bucket <B> --profile <workload> --region eu-north-1
aws logs describe-log-groups --log-group-name-prefix /aws/sagemaker/Endpoints/souldreams-trial --profile <workload> --region eu-north-1 --query 'length(logGroups)' --output text
aws cloudwatch describe-alarms --alarm-name-prefix SoulDreamsImageTrial --profile <workload> --region eu-north-1 --query 'length(MetricAlarms)' --output text
aws application-autoscaling describe-scalable-targets --service-namespace sagemaker --profile <workload> --region eu-north-1 --query 'length(ScalableTargets)' --output text
aws budgets describe-budgets --account-id <workload id> --profile <workload> --query "length(Budgets[?BudgetName=='souldreams-image-trial'] || \`[]\`)" --output text
aws iam list-roles --profile <workload> --query "length(Roles[?starts_with(RoleName, 'SoulDreamsImageTrial') || RoleName=='AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint'])" --output text
aws ssm get-parameter --name /souldreams/trial/hf-token --profile <workload> --region eu-north-1
```

Expected, line by line: `Stack with id SoulDreamsImageTrial does not exist`; `0`; `0`; `0`; an error ending `(404)
... Not Found`; `0`; `0`; `0`; `0`; `0`; `ParameterNotFound`. The two SageMaker list lines count every
configuration and model in the account in eu-north-1: the trial's were its only ones [ASSUMED; if a number is not 0,
bring the names].

Then, by hand:
- CloudShell (Stockholm): `rm -f fetch-weights.sh && ls -la` shows no trial file.
- huggingface.co: Settings → Access Tokens → delete the trial's token.
- The Mac: `~/Desktop/image-trial` stays until the founder has chosen; then `rm -rf ~/Desktop/image-trial`.

**The bill, the next day** (billing lags up to a day): Billing and Cost Management → Bills → this month → SageMaker →
EU (Stockholm). Bring the lines for ml.g6e.xlarge and ml.g6.xlarge (hours and USD), and confirm nothing else of the
trial is charging. The g6e rate is its USD ÷ its hours. If it is not 2.7636, the Build chat scales the FLUX figures
in `results.md` by (that rate ÷ 2.7636): every cost there is proportional to the price. The hours, against the sum
of the rounds' billed seconds (and the deploy's first instance), show whether billing starts at the scale-out
(Part 1, D91 item 10).

### Fallback F · [OWNER] FLUX in 8 bits on ml.g6.xlarge (only if Task 9 fails as unsupported, D136)

The g6.xlarge quota is 1, so FLUX and SDXL run one after the other, never both.

Paste F1 — CloudShell (the pinned wheel, never installed in CloudShell)
```
python3 -m pip download bitsandbytes==0.50.2 --no-deps --only-binary=:all: --platform manylinux_2_24_x86_64 --python-version 3.12 -d wheels && ls wheels && sha256sum wheels/*.whl
```

Expected: `bitsandbytes-0.50.2-py3-none-manylinux_2_24_x86_64.whl` and its sha256, which must equal the one PyPI shows
for that file (pypi.org → bitsandbytes → 0.50.2 → Download files → that wheel → "view hashes"). A different name or
hash is a stop: `inference.py` loads that exact name.

Paste F2 — CloudShell
```
aws s3 cp wheels/bitsandbytes-0.50.2-py3-none-manylinux_2_24_x86_64.whl s3://<B>/models/flux/code/wheels/ --region eu-north-1 --only-show-errors && rm -rf wheels && aws s3 ls s3://<B>/models/flux/code/ --recursive --region eu-north-1
```

Expected: two objects, `code/inference.py` and `code/wheels/bitsandbytes-0.50.2-py3-none-manylinux_2_24_x86_64.whl`.

Paste F3 — Terminal (FLUX alone, in 8 bits)
```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk deploy SoulDreamsImageTrial -c account=<workload id> -c imageTrial=flux -c fluxEightBit=yes -c alertEmail=<email> --profile <workload>
```

Expected: as Task 9 (`InService  1` on ml.g6.xlarge). A failure here is a stop.

Paste F4 — Terminal: as Task 10, with `10 yes` after the folder:
```
cd ~/Developer/soul-dreams-app/server && AWS_PROFILE=<workload> node trial/run.ts flux <B> ~/Desktop/image-trial 10 yes
```

Then Task 11 with one change: in Paste 3 use `-c imageTrial=sdxl` instead of `both` (this removes FLUX's endpoint
and makes SDXL's). Task 12 as written.

## Part 4 · Questions (numbered; a blank is not a yes)

None stops the plan: each is built as leaned. All are the owner's.

1. **The weights in the same bucket.** D135 says the bucket deletes within a day. Built: requests, results and
   failures (`in/`, `out/`, `fail/`) expire after 1 day; the weights (`models/`, the public models, no dreamer's
   data) stay until the teardown, so a trial spread over two days need not copy 48 GB again. Lean: as built. If
   not: a second bucket for the weights, or the whole bucket expiring (the weights copied again each day).
2. **The budget is the account's month, not the trial's alone.** A tag filter would need a cost-allocation tag
   activated a day ahead. The account's other costs are small (one Lambda and two parameters) [ASSUMED; the owner
   sees the month so far in Billing]. AWS updates budgets up to three times a day [READ], so the alarm comes late:
   the real guards are one instance at most, scale to zero and the same-day teardown. Lean: as built.
3. **Hugging Face's address.** G9 keeps every address in the two hosts files, which list what the app and our
   Lambda talk to; this one is neither. Built: it appears only in the owner's CloudShell paste, as the script's
   argument; the endpoints themselves reach nothing. Lean: as built, no guard change. If not: a third hosts file for
   tools and a G9 change.
4. **The trial's dependencies** (R10; none reaches the app or our Lambda): AWS's Hugging Face container (exact tag),
   with `diffusers` 0.38.0 and PyTorch 2.6.0 inside; FLUX.1 [schnell] and SDXL base 1.0 at pinned revisions; a
   Hugging Face account and token; CloudShell; for the fallback only, `bitsandbytes` 0.50.2 (D136). Lean: approve for
   the trial.
5. **Idle 2 minutes, derived, not run.** Two one-minute datapoints are close to CloudWatch's own delay in
   publishing, and with no data counted as idle the endpoint could scale in while still painting. Built: the 2-minute
   cost is the measured 10-minute one less 8 minutes of instance time. Lean: as built; a later measured run is one
   deploy with `-c idleMinutes=2` and the run's fourth argument `2`, if the founder's choice depends on it.
6. **The settings.** 1024 × 1024; FLUX 4 steps, guidance 0; SDXL 50 steps, guidance 5; no negative prompt. Lean: as
   built. The production size for the night's header and rows is the design's (a later question).
7. **The first instance.** An endpoint is created with one instance, which runs until its first idle scale-in
   (about 12 minutes): about USD 0.55 on g6e and USD 0.25 on g6 [ESTIMATE], each counted as a third wake in the
   estimate above. Lean: accept.
8. **The g6e price basis.** AWS's price list has no hosting entry for g6e in eu-north-1; the trial uses the Training
   price and the bill confirms it (Task 12). Lean: as built.
9. **The container's own logs.** The toolkit logs timings only [READ]; the model server's own lines were not read.
   Task 11's Paste 5 proves no prompt word reached either log. Lean: as built.
10. **The trial's code after the teardown.** It stays in the repository (for a re-run, and as the base of the
    production painting) until the founder chooses; a later branch removes it or builds on it. Lean: keep.

## Part 5 · How this plan was proven

1. **The build.** Built in a copy of the tracked tree, `./.scratch/it/build`, from `git archive` of `eaf0da1`, with
   the server's `node_modules` linked. The per-task snapshots (`./.scratch/it/snaps/s0` to `s5`) were assembled from
   the finished build, file by file, each task's mutation rows cut to its own; `s5` equals the build exactly.
   - Each block in Part 3 is `git diff --no-index` between two snapshots, its `a/s<n>/` and `b/s<n>/` prefixes
     rewritten and its `index` lines left out.
   - Left out of every snapshot: `node_modules`, `dist`, `cdk.out` and Python's `__pycache__`.
2. **The counts on each snapshot:** server tests 47 (the baseline), 64, 69, 80, 85, 85, with `npm run check` clean at
   each.
3. **Test first.** Each task's new test files, put on the snapshot before it, failed: Task 1's and Task 3's at
   loading (their modules do not exist yet), Task 2's and Task 4's five cases each.
4. **Mutations on each snapshot** (D126, the task's rows): Task 1 `16 run, 16 caught`; Task 2 `4 run, 4 caught`;
   Task 3 `9 run, 9 caught`; Task 4 `4 run, 4 caught`. On the build, the whole set: `server mutations: 63 run, 63
   caught` (about 7 minutes).
5. **The guards** on each snapshot: `guards (walk): all passed`. During the build G4 refused ten literals of twelve
   words or more (test names, two fake programs, a `jq` program and a report row): the names and the row were
   shortened, the fakes moved to their own files, and the `jq` program cut to a short one with the choosing done in
   the shell.
6. **The guard tests** on the build: 274 run, all pass but `test_check_all`, which copies the tracked tree with git
   and cannot run in a copy with no repository (as in earlier plans).
7. **Replayed on a fresh copy**, `./.scratch/it/replay`, from `git archive` of `eaf0da1`: every block taken from
   this file and applied with `git apply` in order, with `GIT_CEILING_DIRECTORIES` set so `git apply` is not
   silently skipped inside the repository; after each block the tree equalled its snapshot. On the replayed tree:
   `guards (walk): all passed`, the type check clean, `ℹ tests 85`, `ℹ fail 0`.
8. **Found while building, and fixed before the blocks were cut:** macOS's `mktemp -d` ignores `$TMPDIR` without a
   template (the script now names one, which also works in CloudShell); the report test's daily-batch figure was my
   own arithmetic slip (USD 0.0163 is right: (980 + 59 × 5) ÷ 60 × 2.7636 ÷ 3600).
9. **Not run in the sandbox, by design:** anything in AWS (R13), CloudShell or Hugging Face; the real container
   (the serving code ran only against stand-ins, so the loading calls in `inference.py` are [ASSUMED until Task 9]
   and the fallback's until F3); the CDK CLI's own synth (the app's synth ran in-process, through the test that
   runs `infra/app.ts`); `tool/check_all.sh` whole (the owner's).

## Part 6 · Amendment D138: the Opus review's findings and the owner's rulings

Written 2026-11-23, after Tasks 1 to 5 were committed (`f456a0e`) and before any AWS task but Task 6. The Opus review
of the branch (read-only, under D91) found one blocker and four defects; the owner's `describe-type` proved the
blocker, and D138 ruled on three questions. **Where this part differs from Parts 1, 3 and 4, this part governs.**
Built as one batch, test-first; the counts: server tests 90, mutation rows S1 to S73 less S42 (72), all caught (D139 below changed one row and added S73). After D140: tests 93, rows S1 to S76 less S42 (75).

| Finding | What was done |
|---|---|
| **D1 · the budget cannot be a resource**: `AWS::Budgets::Budget` does not exist in eu-north-1 (`aws cloudformation describe-type`, the owner, 2026-11-23: `TypeNotFoundException`) | D138 (1): the resource, its test and row S42 are gone from the stack. `alertEmail`, which only the budget used, is gone from the context too. The owner makes the budget with `aws budgets create-budget` (Budgets' API is global) in Task 7, deletes it in Task 12, and Task 12's proof checks it is gone. |
| **D2 · a failed endpoint took its logs with it**: the log group was made in the same update as the endpoint, so a rollback deleted it | Both log groups are made with the bucket, in the first stage (`imageTrial=bucket`), and stay when an endpoint update rolls back. Rows S64 and S65. |
| **D3 · no step if an endpoint does not scale to zero** (about USD 2.76 an hour on g6e) | Task 9 and Fallback F3 gain the step below. |
| **D4 · a weights file cut during its check was kept by a rerun** | A large file goes up as `<key>.unchecked`, is read back and checked, and only then moved to `<key>` (`aws s3 mv`, server side); a mismatch removes the staging copy; a rerun removes a staging copy beside a kept file. Rows S71 and S72. |
| **D5 · "deletes within a day" is not what S3 does**: a lifecycle rule expires an object at its creation plus 1 day, rounded up to the next midnight UTC, and removes it asynchronously: up to about 48 hours | D138 (2): `run.ts` deletes the model's `in/`, `out/` and `fail/` objects when it ends, however it ends (after the images are saved); the rule stays as the backstop. Read D135's "deletes within a day" as: deleted by the run; expired by the rule within about two days if the run never ends. **D139:** a run that stops deletes only `in/` and `out/` and keeps `fail/`, the only record of a failure on SageMaker's side; the teardown empties the bucket. Rows S67 to S70 and S73. |
| **S2 · the model server's timeout** (unproven offline) | D138 (3): the model's environment gains `SAGEMAKER_MODEL_SERVER_TIMEOUT=3600`. Row S66. |

### The owner's tasks, corrected

In every paste, `<workload>`, `<workload id>`, `<email>` and `<B>` are as before. No cdk command takes
`-c alertEmail` any more. Tasks 6 and 8 are unchanged (Task 8's Paste 2: a count above 24 means a staging copy is
left: `aws s3 ls s3://<B>/models/flux/ --recursive | grep unchecked`; run Paste 1 again, which removes it).

**Task 7 · The bucket, the log groups and the budget (`imageTrial=bucket`)**

Paste 1 — Terminal
```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk deploy SoulDreamsImageTrial -c account=<workload id> -c imageTrial=bucket --profile <workload>
```
Expected: the CDK lists the bucket policy's statement and asks to deploy (answer `y`); then `✅  SoulDreamsImageTrial` and
one output, `SoulDreamsImageTrial.BucketName = souldreamsimagetrial-bucket...`: that is `<B>`.

Paste 2 — Terminal (the budget, USD 30 a month, three emails; the address stays on the Mac)
```
aws budgets create-budget --account-id <workload id> --profile <workload> --budget '{"BudgetName":"souldreams-image-trial","BudgetType":"COST","TimeUnit":"MONTHLY","BudgetLimit":{"Amount":"30","Unit":"USD"}}' --notifications-with-subscribers '[{"Notification":{"NotificationType":"ACTUAL","ComparisonOperator":"GREATER_THAN","Threshold":50,"ThresholdType":"PERCENTAGE"},"Subscribers":[{"SubscriptionType":"EMAIL","Address":"<email>"}]},{"Notification":{"NotificationType":"ACTUAL","ComparisonOperator":"GREATER_THAN","Threshold":100,"ThresholdType":"PERCENTAGE"},"Subscribers":[{"SubscriptionType":"EMAIL","Address":"<email>"}]},{"Notification":{"NotificationType":"FORECASTED","ComparisonOperator":"GREATER_THAN","Threshold":100,"ThresholdType":"PERCENTAGE"},"Subscribers":[{"SubscriptionType":"EMAIL","Address":"<email>"}]}]'
```
Expected: no output. An error (a missing permission, or the account's region rule refusing Budgets, whose API is
global) is a stop: bring it.

Paste 3 — Terminal (the bucket's settings, the log groups, the budget)
```
aws s3api get-public-access-block --bucket <B> --profile <workload> --region eu-north-1 --output text && aws s3api get-bucket-encryption --bucket <B> --profile <workload> --region eu-north-1 --query 'ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm' --output text && aws s3api get-bucket-lifecycle-configuration --bucket <B> --profile <workload> --region eu-north-1 --query 'Rules' && aws logs describe-log-groups --log-group-name-prefix /aws/sagemaker/Endpoints/souldreams-trial --profile <workload> --region eu-north-1 --query 'logGroups[].[logGroupName,retentionInDays]' --output text && aws budgets describe-budget --account-id <workload id> --budget-name souldreams-image-trial --profile <workload> --query 'Budget.BudgetLimit' --output text && aws budgets describe-notifications-for-budget --account-id <workload id> --budget-name souldreams-image-trial --profile <workload> --query 'Notifications[].[NotificationType,Threshold]' --output text
```
Expected: `PUBLICACCESSBLOCKCONFIGURATION  True  True  True  True`; `AES256`; four rules (`in/`, `out/` and `fail/`
expiring after 1 day, and unfinished uploads aborted after 1 day); `/aws/sagemaker/Endpoints/souldreams-trial-flux  1`
and the same for `-sdxl`; `30.0  USD` (`30  USD` is the same budget); the three notifications, in any order:
`ACTUAL  50.0`, `ACTUAL  100.0`, `FORECASTED  100.0`.

**Task 9 · FLUX's endpoint (changes)**: Paste 1 without `-c alertEmail`. If it fails, the log groups stay: read them
with the `aws logs tail` command given there. A g6e quota of 0 fails as `ResourceLimitExceeded`, not as
"unsupported": a stop (bring it), not Fallback F. Paste 2 gains:
- **If the count is still `1` after 20 minutes**: stop, and first collect the evidence, because the next step removes
  the alarms and the scaling target with it (a few minutes cost cents; the endpoint costs about USD 2.76 an hour):
  ```
  aws application-autoscaling describe-scaling-activities --service-namespace sagemaker --resource-id endpoint/souldreams-trial-flux/variant/main --profile <workload> --region eu-north-1 --max-items 5
  aws cloudwatch describe-alarms --alarm-name-prefix SoulDreamsImageTrial-IdleAlarm --profile <workload> --region eu-north-1 --query 'MetricAlarms[].[AlarmName,StateValue,StateReason]' --output text
  aws logs tail /aws/sagemaker/Endpoints/souldreams-trial-flux --since 1h --profile <workload> --region eu-north-1
  ```
  Then run Task 7's Paste 1 again (`imageTrial=bucket`). It removes the endpoint, its configuration, model, scaling,
  alarms and role, and leaves the bucket, the weights and the log groups. It does not ask `y`: removing resources
  is not a broadening. Bring the evidence.

**Task 10 · FLUX's run (changes)**: when the run ends it deletes the model's `in/`, `out/` and `fail/` objects; when
it stops (it prints its code) it deletes `in/` and `out/` and keeps `fail/` (D139): after a stop, read what is in
`s3://<B>/fail/flux/` (`aws s3 cp` it to the Mac's `~/Desktop/image-trial/`, and bring it), as well as the endpoint's log. Paste 3 — Terminal, after Paste 1 (after
a stop, first wait until the endpoint is back to `0` instances, since a painting already sent still finishes in
SageMaker, or fails there, and writes to `out/` or `fail/`; then run Paste 3, and the `rm` below for `in` or `out`
if it shows more than `0`; a `fail` count above `0` after a stop is expected, it is the kept failures):
```
for p in in out fail; do aws s3 ls s3://<B>/$p/flux/ --recursive --profile <workload> --region eu-north-1 | wc -l; done
```
Expected after a run that finished: `0`, `0`, `0`. `Error: trial-cleanup` means the run was good but a deletion failed: the images and
`results.md` are on the Mac; delete by hand, for each of `in`, `out` and `fail`:
```
aws s3 rm s3://<B>/in/flux/ --recursive --only-show-errors --profile <workload> --region eu-north-1
```

**Task 11 · SDXL (changes)**: Paste 3 without `-c alertEmail`; the same Paste 3 check as Task 10 after Paste 4, with
`sdxl` for `flux`.

**Task 12 · The teardown (changes)**: Paste 2 without `-c alertEmail`. Paste 3 deletes the budget as well:
```
aws budgets delete-budget --account-id <workload id> --budget-name souldreams-image-trial --profile <workload> && aws ssm delete-parameter --name /souldreams/trial/hf-token --profile <workload> --region eu-north-1 && aws iam delete-service-linked-role --role-name AWSServiceRoleForApplicationAutoScaling_SageMakerEndpoint --profile <workload> --query DeletionTaskId --output text
```
Expected: one line, a deletion task's id (the budget's deletion prints nothing). If the budget is already gone, its
`NotFound` stops the chain: run the other two commands alone. Paste 4's budget line then proves
the budget is gone (`0`); its log-group line proves the groups went with the stack (`0`).

**Fallback F3 (changes)**: without `-c alertEmail`; the same "still `1` after 20 minutes" step as Task 9.

### D140 · After Task 10's first attempt (the owner, 2026-11-23)

**What happened.** The run sent one painting at 15:59:46Z and stopped with `trial-no-result` an hour later: the wake
(`HasBacklogWithoutCapacity` alarm, 16:03:55Z) ended at 17:31:00Z, 87 minutes after it began. The endpoint's own
description says why: `FailureReason` "Unable to provision all the requested ML compute capacity due to
InsufficientInstanceCapacity error. We are working to provision the remaining capacity", last modified 16:41:36Z, 38
minutes into the wait. So SageMaker had no ml.g6e.xlarge to give, and kept trying.

**Where the time went.** The first deploy's container log stream began 33 minutes after the endpoint was created
(14:44Z create, 15:17Z stream), and the endpoint was in service about 3 minutes later (the first create took 36
minutes in all, with capacity at once). The wake's log stream began at 17:30:25Z, 35 seconds before the scale-out
ended: the 87 minutes were all before the container existed. If the preparation then took what it took at the deploy
(about 33 minutes: provisioning, the image and the 34 GB of weights), about 50 minutes of the wake were the
capacity wait [INFERRED from one create and one wake]. Whether SageMaker bills during the wait is [ASSUMED] not yet
known: Task 12's bill shows it.

**The cold start for the cost sheet.** Not yet measured cleanly: 36 minutes was a create, and 91 minutes (4 minutes
to the alarm, 87 to the instance) a wake with a capacity wait. The re-run measures a wake. For the founder's
decision (owner): g6e scale-to-zero in eu-north-1 risked a capacity wait of about 90 minutes in one sample.

**A second defect, mine.** The stop deleted `in/flux/` while SageMaker still held the queued request, so the endpoint
found no input when it came up; nothing was written to `fail/flux/` or `out/flux/` (read-only listings after the
instance had gone).

**Changes (D140, the wait then set by D141).** A stop with `trial-no-result` keeps `in/` and `fail/` and deletes
`out/`, every other stop as D139. `run.ts` first waited up to 3 hours for each round's results (was 1 hour); D141
below made it 20 minutes. Tests: a wake of 18 minutes still gets its result; one of 19 does not; a no-result stop
removes only `out/`. Rows S74 to S76. After a `trial-no-result` stop, `in` above `0` is expected in the bucket check
as well as `fail`: wait for the endpoint to be at `0` (a request already sent can still be processed), then delete
`in` by hand with the `rm` below.

### D141 · FLUX on g6e is set aside (the founder, 2026-11-23; replaces D140's three hours)

ml.g6e.xlarge in eu-north-1 showed a capacity wait of about 90 minutes in one sample, which rules it out for
on-demand paintings. So: Task 10 is not run; FLUX's endpoint is removed (`-c imageTrial=bucket`: the bucket, the
FLUX weights and the log groups stay until Task 12); Task 11 (SDXL on ml.g6.xlarge) follows. The first-result wait is
the trial's give-up time, **20 minutes**: if no result comes by then, the run stops with `trial-no-result`, which
keeps `in/` (D140) and is reported, since a capacity wait or a slow wake is itself the finding. Lean and fast is the
requirement. FLUX 8-bit on ml.g6.xlarge (Fallback F) stays as the fallback if SDXL's quality disappoints. **For the
cost sheet:** g6e scale-to-zero in eu-north-1 risked a capacity wait of about 90 minutes (one sample, 2026-11-23);
FLUX at full precision is set aside; the first FLUX create took 36 minutes (33 before its container started).
Task 11's Paste 3 is `-c imageTrial=sdxl` (not `both`), Paste 5 reads SDXL's log only, and Task 12's Paste 2 uses
`-c imageTrial=sdxl`, none with `-c alertEmail`. The 20 minutes may be shorter than SDXL's own cold start; if so the
stop is the answer, with the notes' times. Rows S74 and S75 follow the 20 minutes.

### Banked from the review (D91; nothing a dreamer sees changes)

- The CDK keeps a copy of the template in its staging bucket in the account after the teardown (no address in it now).
- AWS needs weeks of history to forecast, so a budget's FORECASTED alert is likely silent; the ACTUAL ones work.
- Fallback F's switch to `imageTrial=sdxl` makes SDXL's endpoint before it removes FLUX's: fine against the g6.xlarge
  quota of 1 only while FLUX's endpoint has no instance, which `run.ts` waits for.
- diffusers logs a warning with the cut-off words of a prompt over its token limit. The trial's prompts are far under
  it; for production it matters under R3 and D135's "no prompt logged".
- A multipart upload left by a cut weights session may block deleting the bucket [ASSUMED]; Task 12's `head-bucket`
  would show it.
- The role has no `logs:CreateLogGroup` or `logs:DescribeLogStreams` [ASSUMED enough, the groups exist]; Task 11's
  Paste 5 shows it (no "Predict time" lines would be the sign).
- The first instance's scale-in rests on SageMaker publishing `ApproximateBacklogSize` 0 when idle, or the policy
  running on missing data [ASSUMED]; Task 9's `InService  0` proves it. Proved: the owner read `InService  0` about
  15 minutes after the deploy ended (the `InService  1` reading was missed; `run.ts`'s scaling activities show both).
- The CDK prints "CfnResource#addDependency is deprecated" when the stack is made (owner, Task 9). Find which line of
  `server/infra/image-trial.ts` calls it, and replace it with the supported call, in a later task; nothing deployed
  changes.

*No matter where you are on your journey, the steps you take are equally important.*
