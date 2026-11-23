# Plan: the Nebius image test (image-trial branch)

> **SET ASIDE (D144).** Nebius no longer offers image generation: its Token Factory catalogue's Modality filter lists
> only Text-to-text, Embedding and Vision (the owner's console, 2026-11-23), and the test's 404 fits. Replaced by
> `docs/plans/bfl-test.md`. What follows is kept as it was written.

Governs: the founder's D142 (the night's painting uses Nebius Token Factory, an image API with zero data
retention, not our own AWS GPUs). It replaces the AWS trial (`docs/plans/image-trial.md`, set aside by D141 and
D142; its code stays in the branch, unused). Written by Claude Code on 2026-11-23. No AWS GPU, no CDK stack, no
change to the app or the server's own stack.

Markers: **[READ]** a fact read on Nebius's own page on 2026-11-23; **[GAP]** the pages do not say, with who finds
out; **[ASSUMED]** believed, with what proves it.

*No matter where you are on your journey, the steps you take are equally important.*

## What the pages say [READ]

| Question | What Nebius's pages say | Page |
|---|---|---|
| Are FLUX schnell and SDXL offered? | The image examples use `black-forest-labs/flux-schnell` (4 steps) and `stability-ai/sdxl` (30 steps). No page I read lists the image models: the models list shows text models only. **[GAP]** that "flux-schnell" is FLUX.1 [schnell]: the images and the owner's look at the model page settle it. | docs.tokenfactory.nebius.com `/api-reference/examples/image-generation`, `/examples/list-of-models` |
| Where are image requests processed? | **Not the EU, as far as public endpoints go**: "For public model endpoints, the Region field shows **Global**. The processing location is decided dynamically, is not tied to any single data center, and can change at any time without prior notice." Fixing a region needs a dedicated endpoint ("the data-center region is fixed as part of the endpoint configuration"). Data retained for speculative decoding is stored in Finland (EU), and fine-tuning data in EU data centers, "regardless of where real-time processing takes place". | `/legal/legal-quick-guide` |
| Does Zero Data Retention cover image requests? | ZDR "applies at the organization level and covers all projects and endpoints", and covers "your inputs (prompts) and outputs (responses)"; it is switched on at "your account profile page". It is off unless enabled. **[GAP]** Images are not named. | `/legal/legal-quick-guide` |
| Used for training? | "We do not use your content to train, fine-tune or improve any AI models." A generated image's link is not kept permanently: "Save the image once you receive the link." | same; image-generation page |
| The DPA | Processor: Nebius B.V. EU Standard Contractual Clauses incorporated (Implementing Decision (EU) 2021/914, modules two and three; Dutch law). A sub-processor list is linked from section 1.11. Published and effective 2026-11-18 (from a summary of the page, not verbatim). | `docs.nebius.com/legal/dpa`, `/legal/sub-processors_tofa` |
| Price per image | **[GAP]**: the pricing page refused my read (HTTP 403), and no page I could read states it. A search summary of a 2025 launch post gave about USD 0.0013 (FLUX schnell) and 0.003 (probably SDXL): stale, not to be relied on. The owner reads it (Task N1). | tokenfactory.nebius.com (prices) |
| Getting a key | Billing set-up with a bank card is mandatory to finish onboarding; no free credit or minimum top-up is stated. | `/quickstart` |
| The request | `POST` to the images address in `server/src/hosts.ts`, `Authorization: Bearer <key>`, fields `model`, `prompt`, `width`, `height`, `num_inference_steps`, `seed`, `response_format` (`b64_json`) and `response_extension` (`png`); the reply is `{"data":[{"b64_json": ...}], "id": ...}`. Limits are dynamic per minute; bursts may be throttled, so the script sends one at a time. | image-generation page; `/ai-models-inference/rate-limits` |

**D143 (the founder, 2026-11-23) settles this section's gate.** The painting's prompt is written inside our own
chain (the readings' model) as a neutral scenery description (no names, places, people, dates or anything
identifying; landscape, light, weather, colour and mood only), so no dreamer's words reach Nebius, and Nebius's
"Global" processing is not a blocker. ZDR stays on. The three questions below are sent to Nebius for the record, not
as a gate. The prompt-writing itself comes with the readings (R7: nothing is drafted here). The six invented scenes
of this test are already of that kind. What follows is the reading that led to D143, kept as it was written.

**What this meant for the founder's ruling.** The DPA and the retention terms look in order. But two things D142
rests on are **not shown** by Nebius's public pages: that image requests are processed in the EU (on public
endpoints the pages say the opposite: "Global", can change without notice), and that Zero Data Retention covers
image prompts and images. Neither is a thing the test can show. **Before any night's text is sent to Nebius**, the
founder (or the owner for him) needs Nebius's written answer to: (1) is the processing of image-generation requests
on public endpoints in the EU, and can it be fixed there; (2) does ZDR cover image prompts and images; (3) the
price and terms of a dedicated EU endpoint, if (1) is no. That is a separate step and plan; this test sends nothing
but the invented scenes.

## What the test does

`server/trial/nebius.ts`, run on the Mac: the trial's six invented scenes (`measure.ts`, R2: scenery, no person,
nothing from any dream), one request at a time, first FLUX schnell, then SDXL, each with its own steps and the same
seeds, 1024 x 1024. It saves `1.png` to `6.png`, `timings.json` and `results.md` (seconds from request to image)
under `~/Desktop/image-trial/nebius/flux-schnell/` and `.../sdxl/`. 12 images; the cost is cents. It writes no
prompt, no key and no reply anywhere; an error is a code (`nebius-http-401`, `nebius-network`, `nebius-not-png`,
`nebius-reply`, `nebius-usage`). The key comes from the environment, read from Parameter Store by the owner's own
command; it is never in the repository (R5).

It measures what a request costs in time with no cold start (Nebius's machines are always on) and gives the
founder the images to choose from. It does not measure cost (Task N1 reads the price), location or retention.

**Built, test-first (98 tests, rows S77 to S79):** the script, the address as `NEBIUS_IMAGES_URL` in
`server/src/hosts.ts` (R10, G9: every host lives in that file; kept out of `HOSTS`, which stays Soniox's, since the
server does not call Nebius), and the tests against a fake API (no key, no network).

**Numbered question for the owner (R10).** Q1: the Nebius address is in `hosts.ts` beside Soniox's. Lean: as built.
It is not a dependency (the script uses Node's own `fetch`). A server that calls Nebius for real is a later plan,
which adds the host to `HOSTS` and the legal answers above.

## The owner's tasks (one at a time)

**N1 · Nebius account, the price, ZDR (browser; about 15 minutes).**
1. Sign up at Nebius Token Factory and finish the billing set-up (a card is required).
2. Read, on its pricing page, the USD per image for FLUX schnell and for SDXL (and the unit, e.g. per image or per
   megapixel).
3. Find the Zero Data Retention switch on your account profile page, read me the words next to it, and switch it
   **on** before the run (production would run with it, and it may affect speed).
4. On the model pages, note the "Region" Nebius shows for the two image models.

Bring: the two prices with their unit; the words by the ZDR switch and whether it is on; the Region shown. Words
only: no screenshot with your account, card or key in it.

**N2 · The key in Parameter Store (Terminal).** Create an API key in Token Factory (name it for the trial). Then:
```
read -rs NEBIUS_KEY && aws ssm put-parameter --name /souldreams/trial/nebius-key --type SecureString --value "$NEBIUS_KEY" --overwrite --profile soul-dreams-workload --region eu-north-1 --query Version --output text; unset NEBIUS_KEY
```
Paste the key at the silent prompt, then Enter. Expected: `1`. Then its length, without the key:
```
aws ssm get-parameter --name /souldreams/trial/nebius-key --with-decryption --profile soul-dreams-workload --region eu-north-1 --query 'length(Parameter.Value)' --output text
```
Expected: the number of characters of the key you copied.

**N3 · The run (Terminal; a few minutes).**
```
cd ~/Developer/soul-dreams-app/server && NEBIUS_API_KEY=$(aws ssm get-parameter --name /souldreams/trial/nebius-key --with-decryption --query Parameter.Value --output text --profile soul-dreams-workload --region eu-north-1) node trial/nebius.ts ~/Desktop/image-trial/nebius && cat ~/Desktop/image-trial/nebius/*/results.md
```
Expected: two tables of six times each. Look at the twelve images and bring both tables and your verdict in your own
words. A stop prints `Error: nebius-<code>`: `http-401` the key, `http-402` or `403` billing or access, `http-404` a
model name, `http-429` a limit: bring the code.

**N4 · After the founder has looked.** Delete the parameter and revoke the key in Token Factory, or keep both if
the founder goes on to the production plan:
```
aws ssm delete-parameter --name /souldreams/trial/nebius-key --profile soul-dreams-workload --region eu-north-1
```
