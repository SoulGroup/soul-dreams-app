# Plan: the Black Forest Labs image test (image-trial branch)

> **D145 (the founder): the night's painting uses Black Forest Labs' `flux-2-klein-4b` on the EU endpoint
> (`api.eu.bfl.ai`): about 4 seconds and 1.4 US cents per 1024 x 1024 painting in the test.** The BFL key stays in
> Parameter Store for the build (renamed when the painting is built). The AWS GPU trial and the Nebius test stay set
> aside in the branch. **D146 (revised): the style stays the original Van Gogh-like painterly one** that
> `flux-2-klein-4b` was chosen on (`STYLE` in `server/trial/measure.ts`, the one style constant); the two dreamlike
> blends tried after it are set aside: see "AC1 and AC2, tried and set aside" below.

Governs: the founder's D144 (the test moves to Black Forest Labs' own API, FLUX, EU endpoint), under D143 (only a
neutral scenery description leaves our chain, so the provider's terms on prompts matter less). It replaces the
Nebius test (`docs/plans/nebius-test.md`, set aside: Nebius's catalogue no longer lists image generation). Written by
Claude Code on 2026-11-23. No AWS GPU, no CDK stack, no change to the app or the server's own stack.

Markers: **[READ]** a fact read on BFL's own pages on 2026-11-23 (docs.bfl.ai, bfl.ai); **[GAP]** the pages do not
say; **[ASSUMED]** believed, with what proves it.

*No matter where you are on your journey, the steps you take are equally important.*

## What the pages say [READ]

| Question | What BFL's pages say |
|---|---|
| The EU endpoint | `api.eu.bfl.ai`: "Multi-cluster routing limited to EU regions", "GDPR compliant". **[GAP]** The pages do not say processing is in the EU, only that routing is limited to EU regions. Other endpoints: `api.bfl.ai` (global) and `api.us.bfl.ai`. **[GAP]** whether the EU endpoint takes the same key. |
| The models | `flux-3-image-klein` (FLUX 3 Image Klein, open weights, 5.6B parameters), `flux-2-klein-4b` and `flux-2-klein-9b` (FLUX.2 [klein]), and the dearer `flux-2-pro`, `flux-2-flex`, `flux-2-max`. FLUX.2 [dev] is "Local only": no hosted API. The test uses the two cheapest. |
| The price | One credit is USD 0.01. FLUX 3 Image Klein by resolution tier: 768x768 USD 0.008, 1K 0.009, 1.5K 0.011, 2K 0.014, 4K 0.036. FLUX.2 [klein] 4B: first megapixel USD 0.014, each added megapixel 0.001; 9B: 0.015 and 0.002. Rejected, failed or moderated requests are not charged. **[GAP]** a minimum credit purchase for a key (the quick start suggests "$10-20 to experiment", as a tip). The 12 test images cost about USD 0.14. |
| The request | `POST` to `<EU endpoint>/v1/<model>`, header `x-key`, JSON. FLUX 3 Image Klein: `prompt`, `resolution` (`1k`), `aspect_ratio` (`1:1`), `seed`, `output_format` (`png`), `steps` (1 to 16, default 16); no other field is allowed. FLUX.2 [klein] 4B: `prompt`, `width`, `height`, `seed`, `output_format`. The reply is at once: `id`, `polling_url`, `cost` (credits). |
| The result | Asynchronous: `GET` the `polling_url` with `x-key` until `status` is `Ready`; the image's address is `result.sample`, and expires after 10 minutes. Other statuses: `Pending`, `Reasoning`, `Generating`, `Request Moderated`, `Content Moderated`, `Error`, `Task not found`. Moderated or failed requests are not charged. |
| Limits | "Maximum 24 concurrent requests for most endpoints"; "Implement exponential backoff for 429 responses." The test sends one at a time. |
| Data | The privacy policy (revised 2026-08-01) and the API terms (2026-08-04; EU, 2026-08-26, section 2(b)) say BFL "may use Inputs and Outputs to train and improve its artificial intelligence models". Opt-out: an email to the privacy address on its privacy page, subject "Training Opt Out". Retention "for as long as is reasonably necessary". **[GAP]** any zero-retention statement for the API, and where data is stored. BFL GmbH is the controller for the EEA. |
| A DPA | **[GAP]** None found on any page read; the privacy policy says transfers outside the EEA use the Commission's standard contractual clauses; no sub-processor list found. BFL's trust page (`trust.bfl.ai`: ISO 27001, SOC 2) was not read and may hold the DPA. |

**Under D143** the prompt that reaches BFL is a neutral scenery description, so training on inputs and the missing
zero-retention statement and DPA are not blockers; the three **[GAP]**s (EU processing, a DPA, zero retention) and
the opt-out email are for the record with the founder, not a gate. One more fact worth the founder's eye: BFL's
terms allow training on the *outputs* too, which are only the scenery paintings. Nothing here is decided by this
test.

## What the test does

`server/trial/bfl.ts`, run on the Mac: the trial's six invented scenes (`measure.ts`, R2: scenery, no person,
nothing from any dream), one at a time, first `flux-3-image-klein` (1k, square), then `flux-2-klein-4b` (1024 by
1024), the same seeds. For each painting it posts, polls once a second (it gives up after 2 minutes), fetches the
image and saves `1.png` to `6.png`, `timings.json` (milliseconds and credits) and `results.md` (a table with the
seconds, the credits and the USD) under `~/Desktop/image-trial/bfl/<model>/`. 12 images. The key is read from the
environment; it is sent only to the API's host and to the polling address, which must be https on a `.bfl.ai` host,
and never to the address the image is fetched from. It writes no prompt, key or reply; an error is a code
(`bfl-http-401`, `bfl-network`, `bfl-polling`, `bfl-moderated`, `bfl-failed`, `bfl-no-result`, `bfl-not-png`,
`bfl-reply`, `bfl-usage`).

It measures the time from request to image (a warm service, no cold start) and the credits the API itself reports, so
the price per image comes from BFL's own reply, not from a page. It does not settle location or retention.

**Built, test-first (100 tests, rows S77 to S81):** the script, the EU address and the host suffix in
`server/src/hosts.ts` (outside `HOSTS`, which stays Soniox's; the owner's D143 answer on R10 stands), and the tests
against a fake API (no key, no network). `nebius.ts` and its tests are gone.

**[ASSUMED] until the first run proves it:** the exact endpoint path and field names, which were read from BFL's
reference by a fetch of each page. A wrong path or field comes back as `bfl-http-404` or `bfl-http-422`: bring the
code, and nothing was charged.

## AC1 and AC2, tried and set aside (D146)

The founder first asked for more dreamlike paintings, a blend of "dreamlike Van Gogh" and "ethereal", and a small
style test was built (`4e77e9f`): the same six invented scenes on `flux-2-klein-4b` in two strengths, the same
seeds. **AC1 (more Van Gogh):** "swirling impasto brushwork and glowing light, softened by a gentle dreamy haze, edges
dissolving, slightly surreal". **AC2 (more ethereal):** "hazy, luminous, floating, soft focus, gentle colour, like a
half-remembered dream, with swirling Van Gogh brushwork still visible underneath". Both ended in "no people, no
text". The founder judged that neither looked painted enough, so the style stays as in the first BFL test, and the
test's code (the two styles, the `style` run mode, their tests and rows S82 to S85) was removed again; it stays in
the branch's history at `4e77e9f`. The next change of style is a change of the one constant. After this, the full
server mutation run once (D126), then the merge, which is the owner's.

## The owner's steps

**B1 · A BFL account, credits, a key (browser).** Make an account on BFL's API site (docs.bfl.ai, "Get started"),
add a small amount of credit (USD 10 is plenty: the test costs about 14 cents), and create an API key. Copy it.
Words only: no screenshot with the key or your card in it.

**B2 · The key to Parameter Store, and the Nebius key gone (Terminal).**
```
read -rs BFL_KEY && aws ssm put-parameter --name /souldreams/trial/bfl-key --type SecureString --value "$BFL_KEY" --overwrite --profile soul-dreams-workload --region eu-north-1 --query Version --output text; unset BFL_KEY
```
Paste the key at the silent prompt, then Enter. Expected: `1`. Then its length, and the Nebius key's removal:
```
aws ssm get-parameter --name /souldreams/trial/bfl-key --with-decryption --profile soul-dreams-workload --region eu-north-1 --query 'length(Parameter.Value)' --output text
aws ssm delete-parameter --name /souldreams/trial/nebius-key --profile soul-dreams-workload --region eu-north-1
aws ssm get-parameter --name /souldreams/trial/nebius-key --profile soul-dreams-workload --region eu-north-1
rm -rf ~/Desktop/image-trial/nebius
```
Expected: the BFL key's length; nothing printed; `ParameterNotFound`; nothing. Then, in Nebius's Token Factory,
revoke the trial's API key (and its billing is yours to keep or close).

**B3 · The run (Terminal; a few minutes).**
```
cd ~/Developer/soul-dreams-app/server && BFL_API_KEY=$(aws ssm get-parameter --name /souldreams/trial/bfl-key --with-decryption --query Parameter.Value --output text --profile soul-dreams-workload --region eu-north-1) node trial/bfl.ts ~/Desktop/image-trial/bfl && cat ~/Desktop/image-trial/bfl/*/results.md
```
Expected: two tables of six, with seconds and credits, and a total in USD. Look at the twelve images and bring both
tables and your verdict in your own words. A stop prints `Error: bfl-<code>`: bring the code.

**B4 · After the founder has looked.** Delete the key from Parameter Store and revoke it on BFL's site, or keep both
if the founder goes on to the production plan:
```
aws ssm delete-parameter --name /souldreams/trial/bfl-key --profile soul-dreams-workload --region eu-north-1
```
