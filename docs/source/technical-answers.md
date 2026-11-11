# Technical Answers

*A Playbook (C3-T item 7). When an answer changes, it is replaced, and the old text is archived verbatim under
technology/archive/. Owner: Technology & Development. It implements and never governs.*

*No matter where you are on your journey, the steps you take are equally important.*

**What this is.** Technology's answers to the technical questions in C1-T item 3.3 (a to t) and in C3-T item 5 (HI1 to
HI9). The questions live there; this file points to them and does not restate them. Each answer gives:

- its status: ANSWERED; ANSWERED IN PART, naming what waits; or WAITING, naming the decision it waits on;
- its basis, with a provenance mark on every fact;
- the part of the tester disclosure (W27) it bears on.

Technology writes no dreamer-facing words. The disclosure is W27, written in its parts in product/places-register.csv,
and the parts that depend on the build are listed in product/technology-handover.md §8. Where an answer finds a part
untrue, that goes to Product & Design before anything is built (handover §8).

**Order.** Product & Design's order of priority (its message 1, item 8): b; e and p; a; d; i; k; l and m. Then the
rest of a to t, then HI1 to HI9, then two answers the handover adds.

**Rulings this file rests on.**

- In technology/technology-change-record.md: C1-T, C2-T and C3-T; C4-T, which approves the head's package as rulings
  (its item 2) and holds the rulings of 2026-11-03 to 2026-11-07; C5-T, which replaces this file's first filing and
  holds the rulings since.
- In interpretation/change-record.md: C140-I to C153-I.
- The handover in its version at C15-P (product/technology-handover.md, sha256 7e659f47…), read by this worker for
  every citation in this file.

**No distress check, no Help, no crisis material** (C5-T, founder-ruled 2026-11-07; C153-I item 1). Nothing in this file
classifies a night for distress, counts a firing, or points to help. Where an earlier version did, the answer is
retired. The founder's stated intention, not a ruling and not planned: a support feature may be built one day, if
pursued. The architecture keeps that door open; nothing is designed for it.
- **The stack** (C4-T, the stack): Flutter for the app; TypeScript on AWS Lambda in eu-north-1 for the server, deployed
  with AWS CDK. Its research is technology/stack-research.md.

**Two kinds of check.** Several answers turn on this distinction.

- **A rule check** tests text by plain rules. Is this quotation word for word in the lens file? Does this line contain
  a word from a fixed list? It is exact, cheap and testable.
- **A model check** asks an AI to judge another AI's text. One was measured once at 45% wrong on 20 cases in the old
  build [RELAYED, old-build-report.md §6].

So each answer says what a rule check can guarantee, and what only a model check can attempt. Failures a model check
misses will sometimes reach a dreamer; failures a rule check covers never will. Every list is a floor (C142-I item 2).

**Vendor pages** were read on 2026-11-03 by the Technical Answers worker, unless marked otherwise. Their addresses are
at the end of this file and at C3-T item 8. Facts relayed in Technology's messages to Product that this worker has not
read are marked [RELAYED, the head].

---

## b. The AI company — ANSWERED; three account checks before any dreamer's words pass through

**The answer.** Claude, in Amazon Bedrock, through the EU geographic inference profile. It is called from Stockholm
(eu-north-1), where our server runs (o). Claude Opus 5.5 makes the readings; Claude Sonnet 5.5 and Haiku 5.5 run the
checks. Retention mode `none` is set in Stockholm, the Region requests are sent from. Rulings: C3-T 2c, 2d and 2e.

**Two AWS accounts** (C4-T, two accounts). A management account holds billing, the organization, the AI services
opt-out (C3-T 2k) and the budgets. A workload account holds Bedrock, and later the server. A service control policy on
the workload account locks retention at `none`. Bedrock is never called from the management account, which service
control policies do not cover [READ, AWS Security Blog, as above].

- **What it keeps.** Under mode `none`, AWS writes no request or response data to durable storage and shares none with
  the model provider [READ, AWS data retention]. The mode is set per Region and does not carry to other Regions [READ,
  same]. It is evaluated in the Region a request is sent from, so destination Regions need no setting; a new account
  starts at "inherit", not "none", so the build sets it before anything else [READ, AWS Security Blog, "Enforce zero
  data retention on Amazon Bedrock with Bedrock Projects and service control policies", updated 2026-08-13]. A service
  control policy then stops anyone setting any other mode [READ, same]. The management account is exempt from service
  control policies [READ, same], which is one reason Bedrock lives only in the workload account (below).
- **Who looks at it.** AWS's abuse detection page names stored or reviewed content only for Claude Fable 5 and 5.1,
  OpenAI models other than four it names, and apparent child sexual abuse material in image inputs or outputs [READ,
  AWS abuse detection, 2026-11-03]. **AWS's Security Blog says Bedrock uses automated mechanisms to identify such
  material in model input and output, and may store and review flagged content, even when the mode is `none`** [READ,
  AWS Security Blog, as above]. It is not limited to images. The two pages differ; the wider one governs what may be
  said. C3-T item 3 recorded images only. **C3-T 2c now names this one exception** (C4-T, the exception).
- **Where.** From an EU source Region, the EU profile routes only to EU Regions [READ, AWS blog; AWS geographic
  cross-Region inference].
- **Training.** Bedrock does not use inputs or outputs to train models [READ, AWS re:Post Knowledge Center, a page that
  predates the retention modes]. Whether the AWS Service Terms say so too is [ASSUMED], to be read there.
- **Subprocessors.** On Bedrock, AWS is the data processor, not Anthropic [READ, Anthropic API and data retention].
  Model providers have no access to the deployment accounts, Bedrock's logs, the prompts or the completions [READ, AWS
  data protection]. Anthropic's staff have no access to the inference infrastructure [READ, Anthropic's Bedrock page].
  AWS's own list of subprocessors is [ASSUMED], not read.
- **Logging.** Bedrock's model invocation logging stays off, which is AWS's default [READ, AWS blog]. CloudTrail records
  that calls were made, not their content [READ, same].

**What waits, before any dreamer's words pass through** (C3-T 2d, 2e), each settled on the founder's account by the
Build worker's account test (setup guide 3.8), not by any page:

- that each of the three models allows mode `none` [ASSUMED]. **The pages contradict each other:** AWS's data retention
  page in English listed Claude Opus 4.8 with `none` among its allowed modes [READ, 2026-11-03], and was C3-T 2d's basis;
  a German-locale copy of the page lists Opus 4.8's allowed modes without `none` [RELAYED, the head, from the Build
  worker's reading of 2026-11-06]. Neither page settles our three models;
- that the EU profile offers all three [ASSUMED];
- that the account has access to them [ASSUMED].

If any fails, it comes back to the founder before anything else is built on it.

**The gate.** No dreamer's words or voice pass through, the founder's own included, until he confirms that AWS's and
Soniox's data processing agreements are saved, and Technology's record holds that confirmation (C4-T, the controller).

**Disclosure.** W27·2's "Nothing keeps them", and its half sentence that a night's words go to an outside AI service
(C144-I condition 2); and W27·3.

**FOR PRODUCT & DESIGN AND INTERPRETATION: "keeps nothing" carries one exception** (C4-T, the exception). W27·2 to
W27·4 say nothing keeps a night's words. A provider's automated systems may flag content as possible child sexual abuse
material, which it may then store and review (above). The precise words live only here and in Technology's record. **No
words about child abuse appear anywhere in the app** (founder-ruled 2026-11-07): the disclosure names the exception in
neutral words, and the exact words are Product's. Technology tells Product next [RELAYED, the head].

**What the neutral words can truly say.** AWS's post says Bedrock may store and review flagged content "to determine if
it is CSAM for reporting purposes" [READ, AWS Security Blog, as above]. It does not say the law requires the keeping.
So a sentence such as "except where the law requires our provider to keep content its automated safety systems flag
for review" says more than the page does. A sentence that stays true to it: our provider may keep, for review, content
its automated safety systems flag. The words are Product's; this is the fact they are written from.

**FOR PRODUCT & DESIGN: W27·3's "no training is ever conducted on anything you share".** It rests on Bedrock's page for
the readings, and on Soniox's pages for recordings (a). It does not cover a tester's emailed TestFlight feedback, which
reaches the founder's Gmail (C4-T, the feedback address); whether Gmail trains on mail is [ASSUMED], not read. Whether
"anything you share" is too wide is Product's (Technology Message 7 item 3 [RELAYED, the head]).

---

## e and p. The totals; network addresses — ANSWERED; one point for Interpretation

**The answer** (C4-T item 2, package item 4; C5-T).

- **What is counted,** each stored with the night and counted only across all dreamers [READ, the entries named]:
  - whether a tradition read because of the bridge (C80-I item 1);
  - how much the dreamer said in answer about each image (C85-I);
  - whether the dreamer answered at all (C83-I item 4);
  - how often each tradition is chosen (HI5);
  - the press's failures, as counts (C141-I item 2).
- **No longer counted:** distress firings (C62-I), because nothing is classified (C5-T; C153-I item 1); and the age band,
  which never leaves the phone (C146-I item 1).
- **Whether the four redrafts keep each count** is [ASSUMED], read against them by the Model Work worker (kit item 3).
  If a redraft drops one, it leaves this list.
- **Where the counts wait.** On the phone, until the cohort ends.
- **How they leave.** Once, automatically, as one packet of counts.
- **What the server does.** It adds each packet to the combined totals and discards the packet at once. Nothing logs
  network addresses.
- **What the founders see.** Only the combined totals, and only after the review date.
- **No identifier** travels with the packet, or with any request (q).
- **The press's failure** is also kept in that night's own record on the phone, with the press's audit (C141-I item 2).

**The honest limit.** In a cohort of four, the server holds one phone's counts for a moment. "Carry nothing that
identifies anyone" is never said (C140-I item 1).

**Network addresses.**

- Any server a phone connects to sees the phone's network address while the connection lasts [ASSUMED, how the
  internet works].
- Our server is built so that nothing records it: no access logs, and no load-balancer or gateway logs [ASSUMED until
  built and shown].
- Bedrock never sees the phone's address. The phone talks to our server, and our server talks to Bedrock (o).
- Soniox does see the phone's address, because audio goes there directly (a). Whether Soniox records it is not on the
  pages read [ASSUMED, open].

**The age band never leaves the phone** (C146-I item 1). It serves the under-18 gate on the phone and nothing else.
This settles the point this answer raised in its first filing.

**Disclosure.** W27·6 holds as written: apart from what is read and recorded, the only thing that leaves is a few
counts, sent once at the end of each cohort, and only the combined totals are kept. The counts are those above.

---

## a. Speech to text — ANSWERED; provisional until Cohort 0's comparison

**The answer.** Soniox, in its EU region, with real-time streaming (C3-T 2g, 2j and 2l).

- **The route.** The phone streams the audio directly to Soniox's EU endpoint. Our server issues a short-lived key for
  each recording, so the audio never touches our server (C4-T item 2, package item 6).
- **The keys.** Soniox offers such keys. A key can be limited to one service, made single-use, set to expire, and capped
  in session length [READ, Soniox temporary API keys]. This settles the package's [ASSUMED].
- **No tracking reference, a build rule.** A Soniox key may carry a `client_reference_id`, which Soniox records in its
  usage logs [READ, Soniox temporary API keys]. The build never sets one (C4-T, item 10's rule; q).
- **What Soniox keeps.** It stores nothing for real-time streams [READ, Soniox privacy policy; Soniox security and
  privacy]. Audio and transcripts stay in the EU region [READ, Soniox data residency]. It uses no customer content for
  training [READ, same pages].
- **The recording** is deleted from the phone once transcribed (C3-T 2g; X9).

**When transcription fails or the phone is offline,** the recording stays on the phone and is sent again (handover §5;
MP·54). It is sent again through the same real-time connection, never through Soniox's asynchronous API, which keeps
files until they are deleted [ASSUMED, from the Async API's role on Soniox's security page]. Streaming a saved recording
in real time is [ASSUMED] feasible; the Build worker shows it. If it cannot, it comes back before it is built.

**What waits.**

- The EU region is enabled only on request [READ, Soniox data residency].
- Soniox's DPA is countersigned in its Console, and the founder confirms it is saved before any voice passes through
  (C4-T, the controller).
- The side-by-side comparison runs before Cohort 0, and may reopen the choice (C3-T 2j, as C4-T amends it; handover
  §11). Amazon Transcribe's real-time service is not offered in Stockholm, so its part of the comparison runs in
  Frankfurt or Ireland [RELAYED, the head, from the Build worker's reading of 2026-11-06].
- "A handful of seconds" is stated as a number once measured (C2-T item 3).

**Disclosure.** W27·2 and W27·4. Both hold, provisionally, as the handover §11 says.

---

## d. Crash reports — ANSWERED

**The answer** (C4-T item 2, package item 2).

- **Apple's own crash reports only.** No third-party crash or analytics tool.
- **Apple collects crash logs automatically.** It shares them, with usage information, with the developer, and testers
  cannot opt out [READ, Apple, TestFlight & Privacy].
- **In-app feedback is disabled for the tester group.** That stops screenshots and in-app feedback, including crash
  details sent with comments [READ, App Store Connect Help, view tester feedback].
- **Email feedback cannot be disabled.** All testers can still send it from the TestFlight app [READ, same]. W27·11 asks
  testers never to send screenshots of their nights.
- **The guard** (C1-T item 3.3; C126-I item 2; C4-T, the build rule). No dreamer's word ever enters an error message, an
  exception's text or a log, and a check in the code enforces it. A crash log can carry an exception's message, so this
  is what keeps words out of Apple's crash reports [ASSUMED, how crash logs are made]. The guard holds from Cohort 0.
  Technology shows it before Cohort 1.
- **No install ID exists** to reach a crash report (q).

**Disclosure.** W27·10 and W27·11.

---

## i. Feedback — ANSWERED

**The answer** (C4-T item 2, package item 3; C126-I item 4).

- Feedback goes from the app to our server.
- It carries no name, no ID and no link to a night, and no network address is recorded.
- The founders read it as it arrives.
- It is never given to a model.
- It is deleted after the cohort's review.
- It is never called "anonymous" (C140-I item 1; HI9).
- Dream material that arrives in feedback never enters any shared document (C126-I item 4).
- It is one of the routes by which a person reads a dreamer's words, and the dreamer chooses it (C4-T, the build
  rule).

**Disclosure.** W27·9 and MP·46. Both hold.

---

## k. Building the design — ANSWERED

**The answer** (C4-T item 2, package item 10). The build works from the handover in its version at C15-P, Product's filed documents,
and the founder's screenshots of every screen. No Framer access is needed. Technology reads Product's documents at their
filed hashes, and reads the new hash when Product files again (handover §1).

**The stack** (C4-T, the stack; founder-ruled 2026-11-06, on the Architecture worker's recommendation in its
stack-research-draft-1.md, filed as technology/stack-research.md with C4-T): Flutter for the app; TypeScript on AWS
Lambda in eu-north-1 for the server, calling Bedrock's EU inference profile, and deployed with AWS CDK in TypeScript. Android from Cohort 2 is the founder's stated goal, not a ruling;
Cohorts 0 and 1 are iPhone only (C3-T 2m).

**What the stack leaves to show.** Several answers rest on the iPhone's own features: the on-device voice (f), file
protection (c), and exclusion from backups (r). A Flutter app reaches them through plugins or a little native code
[ASSUMED]. The Build worker shows, for each, that it uses the iPhone's own feature, so the answers' Apple facts still
hold.

**Disclosure.** None.

---

## l. Platforms; how testers receive the app — ANSWERED; one fact in W27·10 is untrue, and one choice remains

**The answer** (C3-T 2m; C4-T item 2, package item 1).

- Cohorts 0 and 1 are iPhone only.
- Cohort 0 is installed from Xcode onto the founder's iPhone 14, with no TestFlight.
- Cohort 1 uses TestFlight external testing, on a personal Apple Developer account, at $99 a year [RELAYED, the head].
- The first build needs Beta App Review, typically 24 to 48 hours [RELAYED, the head].
- A beta description (MP·56) and a feedback email are required [RELAYED, the head]. The feedback email is the founder's
  personal Gmail for Cohort 1 (C4-T, the feedback address).
- Builds expire 90 days after upload [RELAYED, the head].

**What Apple collects** [READ, Apple, TestFlight & Privacy]:

- crash logs and usage information, collected automatically and shared with the developer; testers cannot opt out;
- the tester's name and email, when the tester is invited by email;
- with a public-link invitation, the tester's name and email are not visible to the developer;
- an emailed feedback message always shows the tester's email [READ, App Store Connect Help].

**How long Apple keeps it** [READ, same page]: beta feedback for one year; crash logs and usage data until bugs are
resolved. The package's "keeps them one year" held for feedback only.

**Invitations are by public link** (C4-T, invitations). Testers are asked not to share it. By Apple's page, a public
link gives the founder no tester's name or email [READ, Apple, TestFlight & Privacy]; an emailed feedback message
still shows the sender's email [READ, App Store Connect Help].

**W27·10, as filed at C14-P** [READ, the Places Register]: its retention now matches Apple's page. Its "Apple collects
crash logs, name, email" is untrue for name and email under a public link, as the founder sees them; its last sentence,
that TestFlight feedback shows who sent it, stays true. FOR PRODUCT & DESIGN (Technology Message 7 item 1 [RELAYED,
the head]).

**The founder's two apps** (C4-T, two apps). His phone carries a development app, "SoulDreams Dev" (app.souldreams.dev),
holding
invented nights only and used for every test; and his Cohort 0 app (app.souldreams.founder), installed from Xcode only, as release builds
only, and updated only by a checked release step that never deletes. Testers' builds, and the store's later, are
app.souldreams (C4-T, the identifiers). Nothing from the Cohort 0 app (screenshot, recording or console output) is ever pasted into a Product or
Technology chat, or into Claude Code. That an update installed over the Cohort 0 app keeps its journal is [ASSUMED]; the
Build worker shows it before the first update.

**Disclosure.** W27·10, which changes again (above). W27·11. MP·56 carries both (C144-I).

---

## m. Cost and time to Cohort 0 — ANSWERED AS ESTIMATES; measured in Cohort 0

**Time** (C4-T item 2, package item 11; C4-T, how Cohort 0 starts).

- Preparation starts now, from the handover: the accounts, the setup guide, and the code repository with its standing
  rules and workflow (C4-T, the code repository).
- The build starts now too.
- **The four redrafts are filed:** The Opening Draft 8 (C143-I, corrected at C145-I), Lens Practice Draft 11 (C149-I),
  The Close Draft 5 (C150-I), and Recurrence & the Series Draft 4 (C151-I).
- **Cohort 0 starts when all four are built into the app** (C4-T item 4, its last condition).
- **The Model Work worker** (kit item 3) writes each document's model instructions, The Opening first. Each set goes
  through Product to Interpretation for one review of its faithfulness to the practice, before Cohort 0 (C153-I item 4;
  C5-T).
- Cohort 1 follows 10 to 14 days after Cohort 0 starts.
- No calendar date is given until the build and the four reviews give one.
- Testing the machinery with invented dreams and placeholder instructions is testing. It is not Cohort 0 and not a
  provisional practice.
- The transcription comparison runs before Cohort 0 (C4-T, the comparison).
- **The build:** about 4 to 6 weeks to Cohort 0's build, and 1 to 2 weeks for Android at Cohort 2, on the stack as
  ruled (k) [ASSUMED, the head's estimates]. The build is separate from the redrafts; Cohort 0 starts from whichever
  finishes last.

**Cost.** Estimates, to be measured in Cohort 0 [ASSUMED unless marked].

- **Apple:** $99 a year [RELAYED, the head].
- **Readings, Claude Opus 5.5:** $4 per million input tokens and $20 per million output [READ, Anthropic's model pages,
  as listed in search results; not the pricing page itself]. On Bedrock, the same prices are [ASSUMED]. About $0.30 to
  $0.60 a night [ASSUMED, the head's estimate].
- **Checks, Claude Haiku 5.5:** $0.10 and $0.50 per million tokens for prompts up to 100,000 tokens, and five times that
  above [READ, same]. Checks are short, so the step should not apply.
- **Soniox:** cents a night [ASSUMED].
- **AWS for the server:** a few dollars a month [ASSUMED].
- **In all:** about $300 to $500 to the end of Cohort 1, mostly development testing [ASSUMED].
- **Bedrock's EU routing.** Anthropic's Bedrock page puts a 10% premium on regional endpoints over global ones [READ].
  Whether the EU profile counts as regional is [ASSUMED].

**The spending limit.** When it is reached, the night stays as recorded and EM·8 shows (handover §5).

- **AWS's backstop:** billing alerts at €100 and €250 a month, on the management account (C4-T, billing alerts). AWS
  Budgets show US dollars only, so they are set at 110 and 275 dollars, at 1.10 to the euro, and fire before the euro
  figures [RELAYED, the head, from the Build worker]. They warn; they do not stop spending [ASSUMED, not read].
- **The app's own hard stop** is a build task. Its figure is set once a night's cost is measured in Cohort 0.
- Soniox limits how many short-lived keys can be created, in its Console [READ, Soniox direct stream]; whether it
  offers a spending cap is [ASSUMED].

**Disclosure.** None.

---

## c. Encryption — ANSWERED

**The answer** (C4-T item 2, package item 7).

- **In transit:** encrypted everywhere.
- **On the phone:** protected by iPhone file protection, and kept out of backups (r). Which file-protection class the
  build uses is stated in the build [ASSUMED, not read on Apple's pages].
- **On the server:** what it stores, feedback and combined totals, is encrypted at rest by AWS's default [ASSUMED, not
  read].

**Disclosure.** W27·8, "encrypted on the way and on your phone". It holds. Never "end-to-end", and never "only you can
read it": the server and the AI company read a night's words in order to read it.

---

## f. The mirror read aloud — ANSWERED

**The answer** (C3-T 2a and 2m). The voice is made on the phone, with the iPhone's built-in Swedish and English voices.
Apple says its speech generation occurs on the device and is not sent to a server [READ, Apple, Speech synthesis].
Cost: the voices may sound flatter than paid online voices [ASSUMED until heard]; Product accepts this (its message 1,
item 6).

**For Cohort 2.** Android is the founder's stated goal for Cohort 2, not a ruling. Google's ML Kit GenAI
`SpeechSynthesizer` is documented as on-device, with voices downloaded per language [RELAYED, the head; READ by the
Architecture worker, developers.google.com, 2026-11-06]. That supersedes this worker's earlier [ASSUMED] that ML Kit
offers no voice. Whether Swedish and Spanish voices exist there, and whether Android's older text-to-speech engine can
be held to "never sends text", is [ASSUMED]. Both are re-read before Android is ruled.

**Disclosure.** None. The words never leave the phone for the voice (C132-I item 3).

---

## g. Offline — ANSWERED

**The answer** (C126-I item 5; C3-T 2g; handover §5).

- Recording works with no connection, and the recording waits on the phone until it can be transcribed (a).
- Text appears only with a connection.
- No reading happens without one, and no reading is queued.
- A reading that cannot complete leaves the night as recorded, to be read later; EM·8 shows.

**Disclosure.** W27·2. MP·54 and EM·8 are the screens' own lines.

---

## h. Deletion — ANSWERED

**The answer** (C4-T item 2, package item 8; X11).

- Deleting a night removes it from the phone.
- Removing the app removes the journal.
- Nothing is kept elsewhere: not at the AI company (b), not at Soniox (a), not on our server (o).

**The exceptions, each said plainly:**

- feedback, until the cohort's review (i);
- the combined totals (e);
- what Apple keeps through TestFlight (l);
- the founder's own Cohort 0 exports (C4-T, the export).

**The founder's export, as built** (C142-I item 3; handover §9; C4-T, the export):

- A button in each night's ⋯ menu, in the founder's Cohort 0 app only. It is absent from every tester build, and a
  check in the build confirms it.
- There are no distress results to include or leave out: nothing is classified (C5-T). C4-T item 8's "leaving out the
  distress results" is moot.
- **It travels by AirDrop,** from his phone to his Mac, device to device, never through our server or any service.
  That AirDrop uses no server is [ASSUMED]; the Build worker reads Apple's page.
- **He moves the file into restricted/,** at /Users/ludvig/Developer/soul-dreams-docs/restricted. It sits inside the
  documents repository's folder, untracked.
- **What keeps it out of the repository** is git's ignore rule for restricted/ [ASSUMED until his check shows it]. Every
  filing script checks that restricted/ is ignored and that nothing under it is tracked, and refuses otherwise.
- **Claude Code is never opened** in ~/Developer, in ~/Developer/soul-dreams-docs, or in any folder that contains
  restricted/.
- **As a safety copy** (C4-T, the export; founder-ruled 2026-11-07): before a change to how the app stores the journal
  on the phone, the founder may export his nights by the same button and route, into restricted/, and delete those
  copies once the update is checked. Interpretation is told through Product as a note.
- **What a safety copy can and cannot do.** The export is one night at a time, and the app has no way to read a night
  back in. So a safety copy keeps the nights' words if an update fails, but it cannot
  put them back into the app; restoring would need an import, which is not built and would need its own ruling. Until
  then, the release step that never deletes (C4-T, two apps) is what protects the journal, and the safety copy is a
  last resort for the words alone.

**Disclosure.** W27·12. It holds. The export is in no tester build, so testers are told nothing about it.

---

## j. Language; settings — ANSWERED

**The answer** (C4-T item 2, package item 9; C5-T; C152-I item 3).

- The app follows the phone's language; Settings changes it.
- There are three settings: Language, Word Animation, and Night/Day. There is no Region setting: it was removed with
  Help (C152-I item 3).
- The app never asks for location (X12).
- The phone's local time decides when a night closes (below, what one night is).

**Disclosure.** None.

---

## n. The distress classification — RETIRED

**Nothing is classified for distress, indefinitely** (C5-T, founder-ruled 2026-11-07; C153-I item 1). There is no check,
no Help page, no crisis material, and nothing is built for them. The previous answer (C141-I item 9) is archived with
this file's first filing. X3 and X4 do not apply while this stands; whether the Requirements List changes is
Interpretation's.

**What stays** (C147-I, as C153-I item 1 keeps it): the rules that keep a reading from hurting anyone, which are how the
readings behave and not a monitoring system (the law document §2); and the not-therapy line (W27·15, C152-I item 1).

**The door left open.** A support feature may be built one day, if the founder pursues it [his stated intention, not a
ruling]. The architecture does nothing to close it, and nothing is designed for it. Evidence of need that reaches the
company goes to the founder (C153-I item 1).

**Disclosure.** W27·6 and W27·17 say nothing about distress. W27·15 is the not-therapy line alone.

---

## o. Our server — ANSWERED

**The answer** (C2-T item 1; C4-T item 2, package item 6).

- **Where:** AWS Lambda, in Stockholm (eu-north-1), an EU Region, consistent with C3-T 2d; written in TypeScript; in
  the workload account (b).
- **What it does:** it relays a night's words to Bedrock and returns the reading. It issues Soniox's short-lived keys
  (a), receives feedback (i), and adds up the totals (e). It classifies nothing for distress (n).
- **What it keeps:** only feedback, until the review, and the combined totals. It writes no night's words to disk.
- **Logs, a build rule:** AWS's own logging for the server is set to counts only, with no request bodies and no network
  addresses [RELAYED, the head, from the Architecture worker]. They never hold words (p).
- **The opt-out:** it runs under the AWS AI services opt-out (C3-T 2k).
- **The build rule** (C4-T item 10): nothing built stores or logs a dreamer's words off their phone, and nothing built
  gives anyone but the dreamer a way to open them, except by a route the dreamer chooses.

**Disclosure.** W27·2's "Nothing keeps them", and W27·17, hold for the server.

---

## q. The install ID — ANSWERED (C141-I item 1)

**The answer** (C4-T, no install ID; package item 5).

- There is no install ID in Cohorts 0 and 1, and no identifier travels with any request. Soniox's keys carry no
  `client_reference_id` (a).
- Abuse is limited by a shared key in the beta build, changed each cohort, and by spending caps (m).
- A shared key built into an app can be extracted by anyone who takes the app apart [ASSUMED, general]. So the caps,
  not the key, are the real limit.

**Disclosure.** W27·9's "phone ID" holds: there is none.

---

## r. Backups; removing the app — ANSWERED

**The answer.**

- **Backups.** The journal is kept out of iCloud backups from the first build (C2-T item 2), on iPhone only (C3-T 2m).
  How: the files are marked to be excluded from backup [ASSUMED, the iOS mechanism, not read on Apple's pages].
- **Removing the app** removes its data from the phone [ASSUMED, not read].
- **The backup setting** is designed for Cohort 2 (C3-T 2h; handover §11). When it is, deletion says truly what it
  removes from the phone, and that copies already backed up stay in the dreamer's Apple cloud until they remove them
  there (C140-I item 8).

**Disclosure.** W27·5. It holds.

---

## s. A spoken "interpret now" — ANSWERED

**The answer** (C130-I item 2; HI3).

- The phrase is recognised in the transcript once speaking ends: the whole answer is the command, or its last words
  are.
- It works only in the opening's answers, never in a dream being told. It is not offered at the mirror; it starts at
  "what stood out" (C143-I, Q7).
- The command words are removed from the kept answer.
- This is a rule check, and exact.
- It does not take effect while the dreamer is still speaking.

**The cost.** It depends on transcription hearing the phrase right. When it does not, the words stay as the dreamer's
answer, and the tap still works. The command words are TECH·2 in product/founder-lists-for-technology.md.

**Disclosure.** None.

---

## t. Readings across nights — WAITING on the Model Work worker

**Waits on:** Recurrence & the Series Draft 4 is filed (C151-I). Which earlier words are sent is set by it and by the
other three documents, and the Model Work worker writes it into the instructions (kit item 3).

**The basis for cost, once known.** Opus 5.5's price is the same per token at any prompt length [READ, Anthropic's model
pages, via search], so cost grows in step with the earlier words sent. Under shape A, every earlier night sent is resent
each time (C2-T item 1).

**Disclosure.** W27·2: earlier nights' words leave the phone again only to be read.

---

## HI1 to HI9

**HI1. The mirror read aloud.** See f.

**HI2. Composed lines with a check.**

- **Cost.** Each night adds model calls to compose and check these lines. Time and money per night are measured in
  Cohort 0 before any figure is stated (m).
- **What a rule check guarantees:**
  - length;
  - that the bridge and image lines carry the dreamer's word as spelled;
  - that a line which must echo nothing of the dream holds no word of it, in exact and plain forms;
  - that no word from TECH·3 appears.
- **What only a model check attempts:** "hints at", "suggests a feeling", "flatters". These are unreliable.
- **The reflection** is composed freely (C140-I item 3):
  - A rule check catches every word on TECH·4, and on TECH·3 except its time words for this night (C142-I item 1).
  - A model check attempts the rest.
  - When the check fails, the closed-set form stands in: AI·12 to AI·17, and quotation only (handover §5).
  - In Cohort 0, a relation the check missed puts its words on TECH·4. Only the words are filed, never the reflection
    (C140-I item 3).
- **On failure, every other composed line** takes the founder's stand-in, except the press and the series question
  (handover §5; HI6; C141-I item 6).

**HI3. Spoken "interpret now".** See s.

**HI4. Quotations.**

- **The rule check.** Every passage set apart as a source's appears word for word in the lens file's passages, with
  provenance, and the source named is the one the file names. It is exact.
- **On failure** (C140-I item 4a): the reading is composed again with no quotation. Only if that fails is the tradition
  replaced for the night.
- **Swedish** (C140-I item 4b): a Swedish reading quotes only a passage its lens file holds in Swedish, from a named
  translation with provenance. Until the files hold one, Swedish readings do not quote. Whether a modern translation
  may be quoted is counsel's.

**HI5. Selection.**

- "Would need what the dreamer did not tell" is a model check, and unreliable.
- Its backstop: every reading is instructed never to rest on what was not told, and to decline in its own voice instead
  (C140-I item 7).
- The Freudian lens is not in the list the build holds, so it cannot be selected.
- How often each tradition is chosen is one of the totals (e).

**HI6. The press.**

- A rule check catches every phrasing on TECH·5, including its ranking and truth words (C142-I item 2). A model check
  attempts paraphrase. No check makes "never" absolute for freely written text.
- On failure it is composed again. On a second failure, the press does not show that night (C140-I item 5).
- The failure is kept in that night's own record on the phone, with the press's audit, and may be counted among the
  combined totals (C141-I item 2).

**HI7. Names kept apart.**

- The two answers are separate fields with different names: "the stood-out answer" in the opening, and "the dreamer's
  response" in the close (C143-I, Q5). Nothing that reads the first reads the second, and a test in the code confirms
  it.
- The mirror addition (C143-I, Q4) is recorded as its own kind, as a correction is, so the capture layer stays
  separable. It is not a late telling.
- The "added later" mark is kept with the dream, and shown wherever the night's dreams show.

**HI8. The journal row and search.**

- **The row.** Framing is left off only where the text matches TECH·1, at the very start. Otherwise nothing is left off.
- **Search** runs on the phone. It finds the first place in a night, and the highlight is gone on leaving.
- **Plain forms** are the same word with a different ending, and only that; when in doubt, no match (C140-I item 6).
  - A stemming tool would sometimes join related words, so the build uses a list of each word's forms instead [ASSUMED
    available for Swedish and English; the source is chosen in the build].
  - Cost: heavier than a stemmer, and exact.

**HI9. What leaves the phone, said truly** (C140-I item 1).

- A typed night leaves the phone only to be read.
- A spoken night leaves at recording, to be turned into text, and the recording is then deleted.
- Nothing keeps a night's words: the server (o), the AI company (b), Soniox (a).
- "Carry nothing that identifies anyone" is never said (e).
- "Anonymous" is never used.

---

## Three answers the handover and later entries add

**Technical failure — ANSWERED** (handover §5; Technology Message 5 item 1, founder-ruled 2026-11-05 [RELAYED, the
handover]).

- Transcription breaks off or fails: the recording stays on the phone and is sent again (a); MP·54 shows.
- A reading cannot complete (the server or the AI unreachable, or a timeout): the night stays as recorded and can be
  read later; EM·8 shows.
- The spending limit is reached: as above; EM·8 shows (m).

**What one night is — ANSWERED** (C152-I item 2, founder-ruled; C5-T). A night stays open until the first 21:00 after
its first recording, by the phone's local time. A dream at 23:00 and one at 07:00 the next morning are one night. The
phone's clock decides; nothing leaves the phone to decide it.

**The app's face — ANSWERED** (handover §10). The name under the icon is MP·55. The icon is the founder's moon, and the
launch screen is the page colour with the moon. Placeholders serve Cohort 0. The icon and launch screen files come from
the founder (handover §11).

---

## The pages read

Each was read on 2026-11-03 by the Technical Answers worker unless marked. Pages already listed at C3-T item 8 are not
repeated.

- Soniox, Temporary API keys: https://docs.soniox.com/authentication/temporary-api-keys
- Apple, TestFlight & Privacy: https://apple.com/legal/privacy/data/en/test-flight (read in search results)
- App Store Connect Help, View tester feedback:
  https://www.developer.apple.com/help/app-store-connect/test-a-beta-version/view-tester-feedback (read in search
  results)
- Anthropic, model overview pages for Claude Sonnet 5.5 and Haiku 5.5, as shown in search results:
  https://platform.claude.com/docs/en/models/sonnet-5-5/overview;
  https://platform.claude.com/docs/en/models/haiku-5-5/overview
- Soniox, Direct stream: https://soniox.com/docs/stt/guides/direct-stream (read in search results)
- AWS Security Blog, "Enforce zero data retention on Amazon Bedrock with Bedrock Projects and service control
  policies", updated 2026-08-13, read in the session that wrote draft 6:
  https://aws.amazon.com/blogs/security/enforce-zero-data-retention-on-amazon-bedrock-with-bedrock-projects-and-service-control-policies/
