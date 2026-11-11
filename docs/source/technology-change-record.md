# Change Record — Technology & Development

*No matter where you are on your journey, the steps you take are equally important.*

*One dated block per change ruled in Technology & Development: what changed, who ruled it, and what
depended on it. Append-only.*

**Created** 2026-11-03, by this machine · **Owned by** Head of Technology

---

## C1-T — the record opened; what exists; the founder's rulings of 2026-11-02; found for Interpretation; raised on the role block

**Filed 2026-11-03, by this machine.** *Items 1 to 3 are the founder's rulings of 2026-11-02, relayed by Head of
Technology in its messages 1 and 2 to the change-record worker, and confirmed by the founder in these words before
filing [RELAYED, Head of Technology; the founder]. Items 4 and 5 are findings and are not ruled.*

**1. THIS RECORD** keeps the Conventions of interpretation/change-record.md and does not restate them. Three things are
Technology's own: its mark, its first two ordinals, and its check.

- **The mark is -T.**
- **C1-T and C2-T are numbered at creation,** against an empty file, as C1-P and C2-P were. Every later block is
  drafted unnumbered and numbered by whoever files, under the same Conventions.

**Technology's own check.** Adapted from Product's (C1-P item 1, at the path C3-P item 3 gives, and C3-P item 4's
heading check). Run from the repository root, it prints nothing when the record is sound. It reports a duplicate
ordinal, a gap, a first block that is not C1-T, a block without its WHAT DEPENDED field, an unnumbered block heading
left in, a heading that runs on, and a block whose filed line does not follow its heading:

    f=technology/technology-change-record.md
    grep -oE "^## C[0-9]+-T" "$f" | sed 's/## C//;s/-T//' | sort -n | uniq -c | awk '$1>1 {print "DUPLICATE C"$2"-T"} NR==1 && $2!=1 {print "FIRST BLOCK IS NOT C1-T"} NR>1 && $2!=p+1 {print "GAP after C"p"-T"} {p=$2}'
    awk '/^## C[0-9]+-T/ {if (h != "" && !w) print "NO WHAT DEPENDED IN "h; h=$2; w=0} /^\*\*WHAT DEPENDED ON THIS\.\*\*/ {w=1} END {if (h != "" && !w) print "NO WHAT DEPENDED IN "h}' "$f"
    grep -n "^## BLOCK UNNUMBERED" "$f"
    awk '/^## C[0-9]+-T/ {h=$2; if (index($0, "**")) print "HEADING RUNS ON: "h; want=1; next} want && NF {if ($0 !~ /^\*\*Filed /) print "NO FILED LINE AFTER "h; want=0} END {if (want) print "NO FILED LINE AFTER "h}' "$f"

Every Technology filing commits only if it prints nothing. It printed nothing at this filing.

This record cannot state its own hash, as C16-I found for Interpretation's. The filing script prints it, and the next
Technology filing records it.

**2. WHAT EXISTS.**

- **technology/old-build-report.md** was placed before this record existed, at
  `a2227a8775e4688459ef6598f1e5ff0d842988e4b78e12ae9a7696462a14b22a` [READ, by the filing script]. It is evidence,
  not a decision: its Status line says nothing in it is a decision for the new build, and its §0 says every claim in
  it is relayed testimony [READ, both].
- **technology/.gitkeep** is an empty file and is left as it is.
- **The old build's code repository** is at ~/Developer/soul-dreams on the founder's machine, remote
  https://github.com/SoulGroup/soul-dreams.git, on branch docs/interpretation-filing at commit e233b51 [RELAYED, the
  founder's outputs where-things-are.txt and tech-check.txt, 2026-11-02]. This is its location only. Nothing in this
  record is read from it.

**3. THE FOUNDER'S RULINGS OF 2026-11-02.**

**3.1 The founder signs alone in Technology.** C130-I item 1 lets the founder's signature alone suffice wherever the
Shared Core, The Foundations or Core Commitments call for both founders, and says it governs Interpretation until the
Shared Core pass is made. The founder rules the same for Technology, on that basis. The role block's words, which
still say "both founders", are not edited here.

**3.2 Who writes the code.** The founder writes the code, in Claude Code sessions.

- **The documents repository** is private and only the founder has access [RELAYED, C118-I item 7]. No one else is
  given access until an old commit ID from the commit map is shown not to resolve on GitHub. That condition is Head of
  Interpretation's, open to the founder (C118-I item 7) [READ, its filed line]; it is not ruled here.
- **The new code repository** does not exist yet. Who may access it is ruled when it is created, with its name and
  place (3.5).

**3.3 The technical questions are these twenty, a to t.** This item is where the list lives. technology/technical-
answers.md points here and does not restate it.

*Items a to m, verbatim from the founder's brief to Head of Technology of 2026-11-02, a chat message; this is the
first file to hold them [RELAYED, Head of Technology, its message 2]:*

> a. Where does speech become text: on the phone or on a server? Which service? Does the audio ever leave the phone?
> When is it deleted? (W29.)
> b. Which AI company runs the readings? What does it keep, for how long, where (EU or not), and under what training
> terms? Who are its subprocessors? (W30; X10.)
> c. Is anything encrypted, at rest and in transit? The disclosure may say "encrypted" only if you confirm it.
> d. Crash reports: which tool, and how is it guaranteed that no dreamer's words, no screenshots and no install ID ever
> reach it? (C126-I item 2.)
> e. The totals that leave the device: exactly which, how they are sent, and how the install ID is kept apart from
> them. The age band, sent once as a count. (C123-I items 2 to 4.)
> f. The mirror read aloud: does the text leave the phone for the voice? (C132-I item 3.)
> g. Offline: recording with no connection, the audio waiting until transcription, no reading without a connection,
> nothing queued. (C126-I item 5; C127-I I5.)
> h. Deletion: when a dreamer deletes a night or the journal, or removes the app, what is really gone, including at
> the AI company and in any backup? (X11.)
> i. Feedback: where it goes, who can read it, how it is deleted after the cohort's review, and that it is never
> linked to the install ID or a night. (C126-I item 4.)
> j. The region from the phone's region setting, never location; the language from the phone's language. (C10-P.)
> k. Can you build from Framer links, or what do you need from Product instead? design-system.md holds every value by
> role.
> l. Platforms for Cohort 0 and Cohort 1, and how testers receive the app.
> m. Rough cost and time to Cohort 0, with their basis.
> And, for every answer: say which line of the disclosure it changes, so Product can write it.

*Items n to t, the founder's rulings of 2026-11-02:*

- **n.** The distress classification: where it runs, what it sends, where firings are kept until the cohort's review,
  and how they are counted (Requirements List X3, X4; tester disclosure specification §1). Three rules pull against
  each other, and the answer meets all three or says which it cannot: X3 stores each firing with the night it occurred
  in; C123-I item 2 lets only totals leave the device; X4 keeps firings only until the review of the cohort they
  occurred in [READ, all three].
- **o.** A server of our own between the phone and the AI company, as a party that sees a night's words [ASSUMED until
  the architecture is ruled].
- **p.** Network addresses on every request, and how totals avoid becoming a per-phone record (C123-I item 2; C126-I
  item 1).
- **q.** What the install ID is for. C123-I item 3 gives it "for the app's own working", never attached to any night's
  data that leaves the device, and in no total; C126-I item 2 keeps it out of crash reports [READ, both]. Whether it
  can protect against abuse and cost without travelling with a night's words, and what the other ways cost if it
  cannot. No use is assumed.
- **r.** The phone's own backups, and what survives removing the app (X11).
- **s.** How a spoken "interpret now" is recognised as C130-I item 2 rules it: a command when said on its own, or as
  the very last thing said in a response, and nowhere else [READ]. A constraint on item a. Whether it must take effect
  while the dreamer is still speaking is [ASSUMED] open.
- **t.** Readings across nights: which earlier words are sent, and the cost.

**Item c, restated.** Encryption in transit and at rest is required (law document §4) [READ]. Item c asks what may
honestly be claimed of it.

**The guard.** The guard keeping a dreamer's words out of logs and crash reports holds from Cohort 0, because the
founder's own dreams pass through from the first night. C126-I item 2 sets when Technology shows the guard, before
Cohort 1; this sets when it holds. The two do not conflict.

**3.4 Who does what.** The head reads and brings decisions; worker chats write and file.

**3.5 The two code repositories.** The new build's code starts in a new, empty repository. Its name, place and access
are ruled when it is created. The old build's repository is left untouched and is never opened in a Claude Code
session: its test fixtures hold condensations of the founder's dream accounts (C97-I item 2) [READ], and Claude Code
sends what it reads to the AI company. This goes further than C97-I item 2, whose condition is that the fixtures are
replaced first if any part is carried forward or shared; it rests on that item's reason. It speaks from this date. It
does not claim the fixtures never reached the AI company: the old build was worked in Claude Code sessions [RELAYED,
technology/old-build-report.md §1.1].

**4. FOUND, FOR INTERPRETATION** — not ruled here. Technology takes neither as current state.

- **Requirements List X11** says "Deleting a night or the account" [READ]. There is no account before Cohort 3
  (C123-I item 3) [READ].
- **The law document** describes the old build's code as current: server file paths, database migrations, and
  classifyForConsequence (interpretation/privacy-ethics-safety.md §1, §2, §4 and §6) [READ].

**5. RAISED, NOT RULED** — Head of Technology's corrections to the project's role block. Owner: the founder.

- Kit item 2's "word for word". Proposed: every claim in the disclosure is true of the architecture, and checkable
  line by line.
- Linear is named for the work, and GitHub for the code, without a decision. The new repository's place is ruled at
  3.5.
- The state command: no guard that the cd succeeded; "ahead" compares to the last fetch, not to GitHub now; its
  fingerprints cover too few files.

**6. CHECKED BEFORE FILING,** for this block and C2-T, by the filing script [READ, by the script]: the tree clean; no
technology/technology-change-record.md; no tracked line naming that path or carrying a -T ordinal; and these files at
these hashes.

| File | sha256 |
|---|---|
| technology/old-build-report.md | `a2227a8775e4688459ef6598f1e5ff0d842988e4b78e12ae9a7696462a14b22a` |
| interpretation/change-record.md | `b697217809cf4b942d48d914916c22c5756a17dde358bd90e7c0e0ce6a23f065` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/privacy-ethics-safety.md | `4f83555ec7fa3b6d488994523d9e81dd12780a2bbe4aa4554cae80f8fbbcef09` |
| interpretation/tester-disclosure-specification.md | `f28b64e16cc8b4df3598d6dd86447645eceba2a48b2594682fc4f0bfb6981ff3` |
| product/product-change-record.md | `2151ddea72eafb83be2c3b3909d8909c6b217cd015f085eb60de39d782ad2b3a` |
| product/main-path.md | `d31d7ed017a336b0557f8d905d5d7223919752684612c74b8dddcac045b757aa` |
| product/product-and-design-principles.md | `98166005088bd6bbfadf4796a5dda7f90553a88d5ec400e43ab37cd77e0b7028` |

**WHAT DEPENDED ON THIS.** *No tracked file named this record's path or held a -T ordinal before this filing [READ, by
the filing script's search of every tracked file]; restricted/ is untracked and was not searched.*

- **technology/technical-answers.md**, which answers 3.3's twenty items and points to them.
- **Product & Design's copy pass**, W27, W29 and W30, and **the tester disclosure**, which wait on those answers.
- **Interpretation**, for item 4, told by Head of Technology in a numbered message after this filing.
- **The founder's code work and the new code repository** (3.2, 3.5).
- **The role block**, for item 5, and its "both founders", which 3.1 leaves standing as words.
- **The Shared Core pass** that C130-I item 1 names; when it is made, 3.1 has done its work.
- **Organisation**, which files Eva's signed agreement (C130-I item 1), on which 3.1 rests.

---

## C2-T — the founder's rulings later on 2026-11-02: shape A; the phone's backups; what transcription must meet

**Filed 2026-11-03, by this machine.** *The founder's rulings and direction of 2026-11-02, relayed by Head of
Technology in its message 2 to the change-record worker, and confirmed by the founder in these words before filing
[RELAYED, Head of Technology; the founder]. Item 2 is direction, ruled only where it says so. Checked before filing
with C1-T, at its item 6.*

**1. SHAPE A** (founder-ruled). **The journal lives only on the phone.** A night's words leave the phone to be read: to
a server of our own, which runs the practice's steps and returns the result, and to the AI company. **Neither keeps
them.** The server holds them only while a reading is made and writes none to disk. The AI company reads under
zero-data-retention terms, which law document §4 already requires [READ].

- **Basis.** C126-I item 1: a night's words leave the device only to be read [READ]. A journal kept on a server would
  keep them off the phone, and would need the install ID, or something like it, attached to night data, which C123-I
  item 3 forbids [READ].
- **Two other ways words could leave, both open.** Speech becoming text off the phone (item a), and the mirror's voice
  made off the phone (item f; C132-I item 3). Either would send a night's words somewhere that is not a reading. If
  either is answered "off the phone", C126-I item 1's sentence no longer holds as written, and goes to Interpretation
  before it is built.
- **"Only on the phone" holds because item 2 keeps the journal out of the phone's own backups,** which otherwise copy
  an app's data [ASSUMED: the platforms' default; settled at item r].
- **The costs, stated.** A lost or broken phone loses the journal. There is no moving it to a new phone before Cohort
  3's account. Reading across nights resends earlier nights' words (item t). There is no server copy to debug from;
  debugging is on the founder's own data or explicitly shared excerpts, as law document §4's access discipline says
  [READ].
- **What "keeps nothing" means precisely** — logs, network addresses, the hosting provider's own logs — is answered
  at items o and p. Until then it is [ASSUMED] achievable.

**2. THE PHONE'S BACKUPS.** **The journal is kept out of iCloud and Google backups from the first build**
(founder-ruled). The founder proposes a setting a dreamer may turn on to include it. That is his direction, not ruled
here, and goes to Product & Design and Interpretation before anything is built.

- **Not ruled here.** The setting would be a fifth beside the four the Product Principles' dated block of 2026-10-29
  names [READ]; that is Product & Design's. It changes what deletion means for a dreamer who turns it on (X11); that is
  Interpretation's.
- **Whether it can be built as a switch:** [ASSUMED] on iPhone; [ASSUMED], with more work, on Android. Answered at item
  r once the platforms are ruled (item l).
- **When.** The founder's direction is that the setting, if it is ruled in, is built after the first version: Cohort
  0 does not need it, and perhaps Cohort 1 does not either. That last is not decided.

**3. WHAT TRANSCRIPTION MUST MEET** (founder-ruled). Accuracy first. Speed, in the founder's words: "we cannot have
people wait for more than a handful of seconds MAX for the transcription". Whether it runs on the phone or on a server
is open. Working offline is wanted, not required. Item a is answered against these, and "a handful of seconds" is
stated as a number, with its basis, when it is measured.

**WHAT DEPENDED ON THIS.**

- **technology/technical-answers.md**: items a, b, f, g, h, o, p, r and t.
- **C1-T item 3.3, item o**, whose server is [ASSUMED until the architecture is ruled]. Item 1 rules it. C1-T is not
  edited; what o still asks is what "keeps nothing" means.
- **Product's offline line** (product/main-path.md, the Offline section; it carries W29) [READ], which says recordings
  are transcribed once back online. If transcription runs on the phone, that line changes.
- **The tester disclosure** (W27, W29, W30).
- **Interpretation**: C126-I item 1, if item a or f is answered "off the phone"; X11, for item 2.
- **Product & Design**: the settings (the Principles' dated block of 2026-10-29), for item 2, told by Head of
  Technology in a numbered message after this filing.
- **The first build**, which keeps the journal out of the phone's backups (item 2).
- **This block's item 1**, if the backup setting is ruled in: "only on the phone" is then corrected by a later block.

---

## C3-T — the record's hash; the founder's rulings of 2026-11-03: the readings' route and models, transcription online and its service, the AI opt-out, the conditions on every service, iPhone only; HI1 to HI9; found on what is kept

**Filed 2026-11-03, by this machine.** *Item 2 holds the founder's rulings of 2026-11-03, relayed by Head of Technology in
its messages 1 to 4 to the Technical Answers worker, and confirmed by the founder in these words before filing [RELAYED,
Head of Technology; the founder]. 2a to 2h came in messages 1 and 2. 2c's final wording, and 2i to 2l, came in messages 3
and 4. 2j's last line and 2m came in messages 5 and 6. 2g and 2h were made in Product & Design's chat [RELAYED, Product & Design's message 1 to Technology, 2026-11-03]. Every vendor fact was read on the vendor's own page on 2026-11-03 by the Technical Answers
worker; the pages are listed at item 8. Items 3 to 7 are findings, records of where things stand, and matters raised; none
is ruled here.*

**1. THE RECORD'S HASH.** As C1-T item 1 requires, this filing records the record's hash after C1-T and C2-T:
`42f03365c760e901f49fcc44cffca8c44b96df346da66bd93308e5369d0634ce`. The C1-T/C2-T filing script printed it, and a mock run
matched it [RELAYED, the change-record worker's closing message]. This filing's script checked it before writing [READ, by
the script].

**2. THE FOUNDER'S RULINGS OF 2026-11-03.** He signs alone (C1-T item 3.1).

**2a. The mirror's voice must be made on the phone.** The read-back's words do not leave the phone for the voice. If a
platform cannot guarantee this, it comes back before it is built. Cohorts 0 and 1 are iPhone only (2m). Apple says the
iPhone's built-in speech generation runs on the device and is not sent to a server [READ, Apple, Speech synthesis]. The
rule closes the open way of item f in C2-T item 1.

**2b. The route for Technology's answers.** Technology sends one message to Product & Design. Items marked FOR
INTERPRETATION are Product's to bring to Interpretation. This answers Head of Interpretation's orientation message of
2026-11-02 [RELAYED]. It departs from the order of authority; see item 6.

**2c. A US-owned provider is acceptable when processing stays in the EU and nothing is kept.** Nothing is kept means no
request or response is written to durable storage; a model that cannot run that way is not used without a new ruling. The
founder: "it should stay if we can keep it true whilst operating from the best possible practice for our product." Its
last clause is how it is kept true. No exception is made for flagged content (item 3).

**2d. The route for the readings** (C1-T item 3.3, item b). Claude in Amazon Bedrock. The EU geographic inference profile,
called from an AWS Region inside the EU, never from London (eu-west-2) or Zurich (eu-central-2). Bedrock's data retention
mode `none`. No training on prompts or outputs.

- **Where the words are processed.** When a request comes from a source Region in the EU, the EU profile routes it only to
  other EU Regions. London and Zurich receive EU-profile traffic only when they are the source [READ, AWS blog]. The
  alternative, not chosen, is in-Region inference in Stockholm (eu-north-1) alone. Anthropic's Bedrock page lists
  eu-north-1 as in-Region capable [READ].
- **What is kept.** Under mode `none`, AWS writes no request or response data to durable storage and shares none with the
  model provider [READ, AWS data retention]. The mode is set per Region and does not carry to other Regions [READ, same].
  A model can run under `none` only if it allows that mode. AWS names Claude Opus 4.8 as allowing it, and Claude Fable 5
  and 5.1 as not [READ, same]. Whether Claude Opus 5.5, Sonnet 5.5 and Haiku 5.5 allow it is [ASSUMED]. It is settled by
  reading each model's allowed modes on the company's account before any dreamer's words pass through.
- **Who can see the words.** On Bedrock, AWS is the data processor, not Anthropic [READ, Anthropic API and data
  retention]. Model providers have no access to the deployment accounts, the Bedrock logs, the prompts or the completions
  [READ, AWS data protection]. Anthropic's staff have no access to the inference infrastructure [READ, Anthropic's
  Bedrock page].
- **Training.** AWS says Bedrock does not use customers' inputs or outputs to train models [READ, AWS re:Post Knowledge
  Center; the page predates the retention modes]. This is [ASSUMED] in the AWS Service Terms until read there, before W30
  is written.
- **Whether the EU profile offers the three models** is [ASSUMED]. It is settled from the account's list of inference
  profiles. If the profile does not offer them, the matter comes back to the founder.
- **The direct Anthropic API is not used.** Its inference geography is "us" or "global" only, and its storage geography
  is "us" only [READ, Anthropic data residency].

**2e. The models.** Claude Opus 5.5 runs the readings. Claude Sonnet 5.5 and Haiku 5.5 run the checks. They are chosen for
Cohort 0.

- **Covered Models are not used.** These are Claude Fable 5 and 5.1 and Claude Mythos 5 and 5.1. Anthropic requires at
  least 30 days' retention for them on every platform [READ, Covered Models; Anthropic API and data retention]. On Bedrock
  they also require mode `aws_review`: up to 30 days' retention, with possible human review by AWS [READ, AWS data
  retention; AWS abuse detection].
- **Access.** Amazon sets access to the three chosen models model by model, and Anthropic's page does not mark them open
  [READ, Anthropic's Bedrock page]. Access is confirmed on the account [ASSUMED].
- **The comparison.** A blind comparison against Gemini, on invented dreams, runs during Cohort 0, and the founder judges
  it. Its result can reopen 2d and 2e. Two things are FOR INTERPRETATION: what a reading is judged against, and that no
  "which resonates more" figure is computed.

**2f. How Technology's chats work.** Each job has one standing worker. The worker keeps its chat open, files as the job
goes, and closes when the job's document is filed. The head writes no record entries itself, so a second chat reads every
entry before the founder confirms it. This departs from the role block's words; see item 6.

**2g. Transcription runs online.** This closes C2-T item 3's "on the phone or on a server is open".

- The recording leaves the phone to be turned into text, and is deleted from the phone once transcribed. Text appears only
  with a connection. Product's offline line stands.
- The service is chosen at 2j, provisionally. C2-T item 3's accuracy and speed criteria stand.
- C2-T item 3's "working offline is wanted" is not met. No text is made without a connection.
- This is item a's audio leaving the phone, so C2-T item 1's open bullet applied. C126-I item 1's sentence went to
  Interpretation, carried by Product in its message 17, and C140-I item 1 replaces it [READ, its filed text].
- 2c's conditions bind the transcription service (2l).

**2h. The backup setting is built for Cohort 2, not before.** This settles C2-T item 2's "When", which left Cohort 1
undecided. Whether the setting is ruled in at all is still Product's and Interpretation's (C2-T item 2).

**2i. Words no dreamer sees.** All of the app's internal words that no dreamer sees live in a Technology document the
founder fills, in each language: the lists the checks use, and the like. Interpretation confirms the lists that carry
practice rules: the relation words and the press's phrasings. Company documents are not in scope.

**2j. The transcription service, provisional: Soniox, in its EU region, with real-time streaming.** A side-by-side
comparison in Cohort 0 confirms it or reopens it: invented dreams, spoken by the founder, against Speechmatics and Amazon
Transcribe. The founder judges. The comparison is not held to 2l: it may send the founder's voice, reading invented
dreams, to all three services under their default terms.

- **In the EU region,** a project's audio and transcripts stay in that region for processing and storage. They never
  leave the chosen region, and there is no fallback to a US endpoint [READ, Soniox data residency; Soniox Europe]. The
  region is enabled on request [READ, same].
- **Nothing kept.** Real-time requests are processed transiently and are not stored [READ, Soniox privacy policy]. Audio
  and transcripts are stored only through a service that supports storage, which is the Async API, and the real-time
  stream is not one [READ, Soniox security and privacy].
- **Logs.** Logs never contain audio or transcripts [READ, same].
- **System data.** Account and project metadata, usage statistics and billing data may be processed outside the region
  [READ, Soniox data residency]. None of these is a dreamer's words or voice.
- **Training.** Customer content is never used to train or improve Soniox's models [READ, Soniox privacy policy; Soniox
  security and privacy].
- **The DPA.** A data processing agreement is self-serve in the Soniox Console, pre-signed by Soniox and countersigned with
  one click [READ, Soniox Europe].
- **Ownership.** Soniox Inc. is based in the United States, at Foster City, California [READ, Soniox privacy policy].
  Who owns it is [ASSUMED], not read. Its subprocessors, including which infrastructure runs the EU region, are listed
  only behind the Console's login and are [ASSUMED] until read there.

**2k. AWS's AI services opt-out policy is set on the company's AWS organization from the start,** before any dreamer's
words pass through.

- **What it does.** AWS AI services may otherwise store and use customer content for service improvement, including
  outside the Region in use [READ, AWS opt-out policies]. Opting out from all services covers current and future
  supported services [READ, AWS opt-out from all].
- **What it requires.** It is set from the organization's management account [READ, same].
- **Scope.** Amazon Transcribe is within its scope. Amazon Bedrock is not on AWS's list [READ, same]; Bedrock is covered by
  2d instead. It is a safeguard either way.
- **Transcribe's default.** By default, Amazon Transcribe stores and uses the voice inputs it processes to improve the
  service [RELAYED, Head of Technology from AWS's Transcribe opt-out page; not read here].

**2l. 2c's conditions bind every service that receives a dreamer's words or voice,** transcription included: processing
in the EU, nothing kept, no training. This holds while the app is offered in Europe only. Before Cohort 3, these
conditions are reviewed. That the founder plans to open Cohort 3 worldwide is his stated intention, not a ruling. On the
pages read, Soniox's EU region meets 2l (2j).

**2m. Cohorts 0 and 1 are iPhone only.** This answers the platform half of C1-T item 3.3, item l. How testers receive the
app, the other half of item l, is not ruled here. Keeping the journal out of the phone's backups (C2-T item 2) is now an
iPhone question only.

**3. FOUND, FOR PRODUCT & DESIGN AND INTERPRETATION — what may be said about keeping.** Not ruled here.

- **Anthropic.** On its own API, Anthropic may keep inputs and outputs that its automated safety systems flag for up to
  2 years, or where the law requires, under any arrangement [READ, Anthropic API and data retention].
- **AWS, for Bedrock.** Under mode `none`, AWS writes no request or response to durable storage [READ, AWS data retention].
  AWS names storage for abuse detection in three cases only: OpenAI models other than four it names; Claude Fable 5 and
  5.1; and apparent child sexual abuse material in image inputs or outputs [READ, AWS abuse detection]. The readings send
  text only [ASSUMED until the architecture is ruled].
- **The law.** No AWS page read says AWS keeps Bedrock content because the law requires it. AWS's Supplementary Addendum
  commits it to redirect, notify and challenge when it is compelled to disclose customer data [READ, AWS DPA page].
  Whether a legal order could reach the words while a reading is being made is [ASSUMED] possible, and is not settled
  here.
- **So:** if the three models allow mode `none`, W30 may be able to say more than that no promise can be made. How it is
  worded is Interpretation's and Product's.
- **W30's present drafts are untrue under 2d,** in English and in Swedish (product/places-register.csv, row W30) [READ].
  They name Anthropic and the Claude API, and deletion "within X". Under 2d, AWS is the processor, Anthropic does not see
  the words, and nothing is written to storage to be deleted.

**4. OWED TO ORGANISATION.** The data processing agreements for both services.

- **AWS.** AWS's data processing addendum is part of the AWS Service Terms. It applies automatically
whenever a customer uses AWS to process customer data, together with its Supplementary Addendum [READ, AWS DPA page].
Nothing is signed. Organisation files three things: the addendum and its Supplementary Addendum as in force; which account
  accepted the Service Terms; and when it did.
- **Soniox.** Soniox's DPA is countersigned in its Console (2j). Organisation files the signed copy.
- **When.** Both are filed before any dreamer's words or voice pass through, the founder's own included. Filing them is
  Organisation's (Core Commitments).

**5. HI1 TO HI9 — Head of Interpretation's questions for Technology.** This is the first file to hold them. Their source is
Head of Interpretation's orientation message to Head of Technology of 2026-11-02, §3 "THE QUESTIONS THE ENTRIES LEAVE FOR
TECHNOLOGY", items a to i, a chat message relayed by the founder [RELAYED, Head of Technology, its message 2]. Technology's
message 1 to Product, and Product's message 1 in reply, called them I1 to I9. They are not C127-I's I1 to I9.
technology/technical-answers.md points here and does not restate them.

> HI1. The mirror read aloud: is the voice made on the phone, or do the words leave it? If they leave, the disclosure must
> say so. (C132-I item 3)
> HI2. Composed lines with a check. Composed fresh each night, each passing a check written from its rules before it shows,
> with a founder-written stand-in when the check fails, each language composed independently: the opening's four framing
> lines (C128-I item 1); the close's invitations (C129-I item 5); the image line, its second form and the series
> question's frame (C134-I item 1); the reflection (C137-I item 1). What does this cost, and what can a check reliably
> test? Above all, the reflection's rule that the app's own words between quotations say only where and when, never a
> relation.
> HI3. Spoken "interpret now": a command when said on its own or as the very last thing in a response; never inside a
> dream being told; the command words are not kept with the answer. (C128-I item 2; C130-I item 2)
> HI4. Quotations: a reading quotes a source only word for word, only from a passage its lens file holds with provenance,
> and names it. How does the build check a quote against the lens file? (C135-I item A)
> HI5. Selection: a tradition whose reading would need what the dreamer did not tell is not chosen that night. How often
> each tradition is chosen is counted across all dreamers, never per dreamer. The Freudian lens is retired and is never
> selected. (C134-I items 2 and 9)
> HI6. The press never produces a sentence that declares a reading true, right or the one. (C136-I)
> HI7. Names that must stay apart in the build: the opening's "what stood out" answer and the close's (C132-I item 4). A
> dream added after the mirror carries its "added later" mark wherever a night's dreams show (C138-I item 2).
> HI8. The journal row: the first dream's opening, verbatim, with only the framing left off; when unsure, nothing is left
> off (C131-I item 1). Search: the word as typed and its plain forms, never synonyms; the first place it appears in a
> night, never the "best"; the highlight is gone when the dreamer leaves the night (C131-I item 3).
> HI9. What leaves the phone, said truly: a night's words leave it only to be read; the totals that leave carry nothing
> that identifies anyone. Never call anything "anonymous". (C123-I; C126-I)

**6. RAISED, NOT RULED.** Owner: the founder.

- **2b departs from the Shared Core.** The Shared Core gives Interpretation the first say, and the role block sends
  practice matters to Interpretation first. 2b routes them through Product. 2b also rules a route between chats, where the
  Shared Core says heads talk through the files, never chat to chat.
- **2f departs from the role block's words.** The role block says "worker chats each close when their document is
  filed". 2f applies this to a whole job. Proposed correction: "worker chats each close when their job's document is
  filed". The role block's words are not edited here.

**7. technology/technical-answers.md is a Playbook.** When an answer changes, the old answer is replaced and archived
verbatim.

**8. THE PAGES READ,** each on 2026-11-03, by the Technical Answers worker:

- Anthropic, Claude in Amazon Bedrock: https://platform.claude.com/docs/en/build-with-claude/claude-in-amazon-bedrock
- Anthropic, Covered Models: https://support.claude.com/en/articles/15425695-covered-models
- Anthropic, API and data retention: https://platform.claude.com/docs/en/manage-claude/api-and-data-retention
- Anthropic, Data residency: https://platform.claude.com/docs/en/manage-claude/data-residency
- AWS, Data retention: https://docs.aws.amazon.com/bedrock/latest/userguide/data-retention.html
- AWS, Abuse detection: https://docs.aws.amazon.com/bedrock/latest/userguide/abuse-detection.html
- AWS, Data protection: https://docs.aws.amazon.com/bedrock/latest/userguide/data-protection.html
- AWS, Geographic cross-Region inference: https://docs.aws.amazon.com/bedrock/latest/userguide/geographic-cross-region-inference.html
- AWS blog, cross-Region inference for EU data processing, 2026-06-08:
  https://aws.amazon.com/blogs/machine-learning/unlocking-ai-flexibility-in-europe-a-guide-to-cross-region-inference-for-eu-data-processing-and-model-access/
- AWS re:Post Knowledge Center, Bedrock model data use: https://www.repost.aws/knowledge-center/amazon-bedrock-model-data-use
- AWS whitepaper, the AWS DPA: https://docs.aws.amazon.com/whitepapers/latest/navigating-gdpr-compliance/aws-data-processing-addendum-dpa.html
- AWS, AI services opt-out policies: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out.html
- AWS, Opt out from all supported AI services: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_ai-opt-out_all.html
- Soniox, Security and privacy: https://docs.soniox.com/security-and-privacy (reached from https://soniox.com/docs/stt/security-and-privacy)
- Soniox, Data residency: https://docs.soniox.com/data-residency
- Soniox, Europe: https://soniox.com/europe
- Soniox, Privacy policy, last updated 2026-06-29: https://soniox.com/policies/privacy-policy
- Apple, Speech synthesis: https://developer.apple.com/documentation/avfoundation/speech-synthesis.md

**9. CHECKED BEFORE FILING,** by the filing script [READ, by the script]: the tree was clean; no C3-T existed; and these
files were at these hashes.

| File | sha256 |
|---|---|
| technology/technology-change-record.md | `42f03365c760e901f49fcc44cffca8c44b96df346da66bd93308e5369d0634ce` |
| product/places-register.csv | `b3a2c26feacb24a11a6464c0c37e52d4addd7d58481e199075bbd838f0112ad4` |
| product/product-change-record.md | `2151ddea72eafb83be2c3b3909d8909c6b217cd015f085eb60de39d782ad2b3a` |
| interpretation/privacy-ethics-safety.md | `4f83555ec7fa3b6d488994523d9e81dd12780a2bbe4aa4554cae80f8fbbcef09` |
| interpretation/change-record.md (its last block C140-I) | `2247f32717f44ee31d8be5ce4ca01f85c5562702de7011ec85ad6fe9b1e5a056` |
| interpretation/tester-disclosure-specification.md | `f28b64e16cc8b4df3598d6dd86447645eceba2a48b2594682fc4f0bfb6981ff3` |

**WHAT DEPENDED ON THIS.**

- **technology/technical-answers.md**: item b (2d, 2e); item a (2g, 2j); item f (2a); item l, its platform half (2m); item r (2h, 2m); HI1 to HI9 (item 5); its
  kind (item 7).
- **W30**, with its English and Swedish drafts in product/places-register.csv, which are untrue under 2d (item 3). **W29**
  (2g: the audio leaves the phone to be transcribed; 2j: the service's name and terms). **W27 and the tester disclosure.**
- **Law document §4** (Interpretation's): its "zero-data-retention API terms" hold under 2d only if the three models allow
  mode `none` (2d; item 3).
- **C2-T item 1**: its "Neither keeps them" holds under the same condition; if the condition fails, a later block corrects
  it. Its open way for item f is closed by 2a. Its open way for item a is answered "off the phone" by 2g.
- **C2-T item 2** (2h; and 2m, which makes the backups an iPhone question only) and **C2-T item 3** (2g).
- **C1-T item 3.3, item l's second half**: how testers receive the app, not ruled (2m).
- **C1-T item 3.3, item m**: cost and time to Cohort 0, which now assume one platform (2m).
- **C140-I item 1**, which replaces C126-I item 1's sentence. It says "nothing keeps them", and the recording's part, only
  once the transcription service is chosen and its terms are read. 2j chooses it provisionally and reads its terms; if
  the comparison reopens 2j, that condition is open again. For the AI company, "nothing keeps them" rests on 2d's
  condition that the three models allow mode `none`.
- **Product's offline line** (product/main-path.md, the Offline section; MP·15), which stands (2g).
- **Organisation**, for item 4: AWS's DPA and Soniox's DPA.
- **The Cohort 0 build**: the account checks named at 2d and 2e; the opt-out at 2k; and the Soniox EU region at 2j. All of
  these come before any dreamer's words pass through. Also the two comparisons, models (2e) and transcription (2j).
- **The review before Cohort 3** (2l).
- **The founder-filled document of internal words** (2i), Technology's, not yet written.
- **The role block and the Shared Core**, for item 6.
- **Technology's message to Product**, sent after this filing.

---

## C4-T — the record's hash; the head's package approved; the founder as controller, and the gate; how Cohort 0 starts; no install ID; the word lists; the code repository; the founder's export; the feedback address; no one reads a dreamer's words; the comparison before Cohort 0; public-link invitations; two apps; the stack and stack-research.md filed; two AWS accounts; billing alerts; the apps' names and identifiers; one exception to "nothing is kept"; technical-answers.md filed

**Filed 2026-11-09, by this machine.** *Items 2 to 18 hold the founder's rulings of 2026-11-03 to 2026-11-07, relayed
by Head of Technology in its messages 10 to 15 of 2026-11-06 and 2026-11-07 to the Technical Answers worker, and confirmed by the
founder in these words before filing [RELAYED, Head of Technology; the founder]. technology/technical-answers.md and technology/stack-research.md
are filed with this block, in the same commit.*

**1. THE RECORD'S HASH.** As C1-T item 1 requires, this filing records the record's hash after C3-T:
`6a10dfd38bf1bede6307a396691a9685f4482d5bff01ae91aeb0367e45de4971`. The C3-T filing script printed it [READ, the
founder's output, 2026-11-03]. This filing's script checked it before writing [READ, by the script].

**2. THE HEAD'S PACKAGE IS APPROVED AS RULINGS** (the founder, 2026-11-03). It has eleven items. Their text is
technology/technical-answers.md as filed with this block, at sha256 `782a7e9482657f830ce7eff89fd0762bba59c9d98a199052adc7b9a10ebfaff3`, under these answers:

| Package item | Answer |
|---|---|
| 1 | l |
| 2 | d |
| 3 | i |
| 4 | n, e and p |
| 5 | q |
| 6 | o and a |
| 7 | c |
| 8 | h |
| 9 | j |
| 10 | k |
| 11 | m |

**Where the pages said otherwise.** technical-answers.md holds what the vendors' pages say, marked, where they differ
from the package as approved:

- Apple keeps TestFlight feedback for one year, and may keep crash logs and usage data until bugs are resolved [READ,
  Apple, TestFlight & Privacy]. The package said one year for all of it (l). W27·10 was corrected at C14-P.
- Soniox does offer short-lived keys [READ, Soniox temporary API keys]. The package marked it [ASSUMED] (a).

**3. THE FOUNDER IS THE DATA CONTROLLER** for testers' data while no company exists (founder-ruled 2026-11-03), **and
holds Organisation's open items himself** (founder-ruled 2026-11-06).

- The Apple, AWS and Soniox accounts are in his name, and he accepts their data processing agreements.
- **The gate, replacing C3-T item 4's.** No dreamer's words or voice, his own included, pass through until he confirms
  that AWS's and Soniox's data processing agreements are saved, and that confirmation is recorded in this record.
- He reopens an Organisation chat when needed, and before Cohort 1.
- **Counsel, before Cohort 1:** explicit consent for the special-category data a dream may reveal; whether a data
  protection impact assessment is required; which supervisory authority applies; and the layered disclosure (C144-I).
  Each is [ASSUMED] until counsel settles it.

**4. HOW COHORT 0 STARTS** (founder-ruled 2026-11-03; four redrafts, C141-I item 3). In his words: "we only start
cohort 0 when all of the interpretation done is in, we will start from the full thing, not with a provisional thing, we
test the real thing."

- Cohort 0 starts only when Lens Practice's Draft 11, The Opening's Draft 8, The Close's next draft and Recurrence &
  the Series' Draft 4 are filed and built into the app.
- Each document's model instructions start the day it files. The Opening's Draft 8 filed at C143-I.
- No provisional instructions are used. C140-I item 11 stands.

**5. NO INSTALL ID IN COHORTS 0 AND 1.** Technology's proposal, agreed by Interpretation (C141-I item 1). C1-T item
3.3's item q is answered.

**6. THE WORD LISTS** (founder-ruled 2026-11-05). They stay in product/founder-lists-for-technology.md. C3-T 2i is met
by Technology building from that file at its filed hash, rather than from a Technology document. TECH·3 to TECH·5 are
approved by Head of Interpretation, by the founder's delegation (C142-I item 0).

**7. THE CODE REPOSITORY** (founder-ruled 2026-11-05). It is private, on GitHub, under SoulGroup, and named
soul-dreams-app. This settles C1-T item 3.5.

**8. THE FOUNDER'S COHORT 0 EXPORT MAY BE BUILT,** for his Cohort 0 app only (C142-I item 3; handover §9; the route
founder-ruled 2026-11-06).

- A button in each night's ⋯ menu sends the night from his phone, leaving out the distress results. It is absent from
  every tester build.
- **It travels by AirDrop,** from his phone to his Mac, device to device, never through a server or any service. That
  AirDrop uses no server is [ASSUMED]; the Build worker reads Apple's page.
- **He moves the file into restricted/,** at /Users/ludvig/Developer/soul-dreams-docs/restricted: inside the documents
  repository's folder, untracked (C142-I item 3's check).
- Exported nights are read only in Interpretation's study chat.
- **Claude Code is never opened** in ~/Developer, in ~/Developer/soul-dreams-docs, or in any folder that contains
  restricted/.
- The founder accepts that reading a night in an AI chat sends it to that chat's AI company (C142-I item 3).
- **As a safety copy** (founder-ruled 2026-11-07): before a change to how the app stores the journal on the phone, the
  founder may export his nights by the same button and route, into restricted/, and delete those copies once the update
  is checked. It is the export as C142-I item 3 rules it. Interpretation is told through Product as a note. The app
  cannot read a night back in, so the copy keeps the words but cannot restore the journal (technical-answers.md, h).

**9. THE TESTFLIGHT FEEDBACK ADDRESS** (founder-ruled 2026-11-06). It is the founder's personal Gmail address for
Cohort 1, changed later. This is an exception to C3-T 2l: a tester's emailed TestFlight feedback, sent by the tester's
choice, reaches a service that does not meet 2l. W27·10 says so.

**10. A BUILD RULE: NO ONE READS A DREAMER'S WORDS** (from W27·17, "No one reads your dreams"; C141-I item 9).
Nothing built stores or logs a dreamer's words off their phone, and nothing built gives anyone but the dreamer, on their
own phone, a way to open them, except by a route the dreamer chooses: in-app feedback (MP·46 says it is read);
TestFlight's email feedback (W27·11 asks testers never to send their nights); and the founder's own Cohort 0 export
(item 8).

Two build rules follow from it (technical-answers.md, a and o): Soniox's keys never carry a `client_reference_id`, and
AWS's own logging for the server holds counts only, with no request bodies and no network addresses.

**11. THE TRANSCRIPTION COMPARISON RUNS BEFORE COHORT 0,** not in it (founder-ruled 2026-11-06). This amends C3-T 2j's
"in Cohort 0"; the handover §11 already says "before". C3-T 2j's line that the comparison is not held to 2l stands.

**12. TESTFLIGHT INVITATIONS ARE BY PUBLIC LINK** (founder-ruled 2026-11-06). Testers are asked not to share it. By
Apple's page, a public link gives the founder no tester's name or email [READ, Apple, TestFlight & Privacy].

**13. TWO APPS ON THE FOUNDER'S PHONE** (founder-ruled 2026-11-06).

- A development app, with its own ID and name, holds invented nights only and is used for every test.
- His Cohort 0 app is updated only by a checked release step that never deletes.
- Nothing from the Cohort 0 app (screenshot, recording or console output) is ever pasted into a Product or Technology
  chat, or into Claude Code.

**14. THE STACK** (founder-ruled 2026-11-06). Flutter for the app; TypeScript on AWS Lambda in eu-north-1 for the
server, calling Bedrock's EU inference profile, and deployed with AWS CDK in TypeScript. It was recommended in the
Architecture worker's stack-research-draft-1.md, **filed with this block as technology/stack-research.md**, a Record
frozen as filed, at sha256 `db0130d51ce0aa6578032e279e993fca6ab844e7819cbe0543f26d428783fed6` [READ, the attached
file]. Its opening says "not filed"; that describes the draft when written, and the text is filed unchanged. It
answers k's and m's open point. m's estimates, about 4 to 6 weeks to Cohort 0's build and 1 to 2 weeks for Android
at Cohort 2, are [ASSUMED].

**15. TWO AWS ACCOUNTS** (founder-ruled 2026-11-06).

- A management account holds billing, the organization, the AI services opt-out (C3-T 2k) and the budgets.
- A workload account holds Bedrock, and later the server.
- A service control policy on the workload account locks retention at `none`. AWS exempts the management account from
  service control policies [READ, AWS Security Blog, "Enforce zero data retention on Amazon Bedrock", updated
  2026-08-13], so Bedrock is never called from it.

**16. BILLING ALERTS AT €100 AND €250 A MONTH** (founder-ruled 2026-11-06), as AWS's backstop. AWS Budgets show US
dollars only, so they are set at 110 and 275 US dollars, at 1.10 to the euro, and fire before the euro figures
[RELAYED, the head, from the Build worker]. They warn and do not stop spending [ASSUMED]. The app's own hard stop is a build task, and its figure is set once a night's cost is measured.

**17. THE APPS' NAMES AND IDENTIFIERS** (founder-ruled 2026-11-06; item 13).

- app.souldreams: testers' builds, and the store's later.
- app.souldreams.founder: the founder's Cohort 0 app, installed from Xcode only, as release builds only.
- app.souldreams.dev: the development app, named "SoulDreams Dev".

**18. ONE EXCEPTION TO "NOTHING IS KEPT"** (founder-ruled 2026-11-06; corrected 2026-11-07). Bedrock stays. **C3-T 2c
is amended to read: nothing is kept, except what a provider's automated systems flag as possible child sexual abuse
material, which it may store and review.**

- These precise words live only in this record and in technology/technical-answers.md.
- **No words about child abuse appear anywhere in the app.** The disclosure names the exception in neutral words, and
  the exact words are Product's. Whatever they say stays true to AWS's page, which gives review for reporting as the
  purpose and does not say the law requires the keeping (technical-answers.md, b).

- **The basis.** AWS's Security Blog says Bedrock uses automated mechanisms to identify such material in model input
  and output, and may store and review flagged content, even when the mode is `none` [READ, as at item 15]. C3-T item
  3 recorded this for image inputs and outputs only [READ, AWS abuse detection, 2026-11-03]. The wider page governs.
- **The pages disagree on Claude Opus 4.8's allowed modes,** which C3-T 2d cited. The English page listed `none` [READ,
  2026-11-03]; a German-locale copy does not [RELAYED, the head, from the Build worker's reading of 2026-11-06]. Our
  three models are settled by the account test, not by either page (technical-answers.md, b).

**19. technology/technical-answers.md IS FILED,** a Playbook (C3-T item 7), at sha256 `782a7e9482657f830ce7eff89fd0762bba59c9d98a199052adc7b9a10ebfaff3`. It
answers C1-T item 3.3 and C3-T item 5, each answer marked ANSWERED, ANSWERED IN PART, or WAITING with the decision it
waits on. It folds in C140-I to C144-I by number. Its items FOR INTERPRETATION and FOR PRODUCT & DESIGN are carried by
Product (C3-T 2b).

**20. CHECKED BEFORE FILING,** by the filing script [READ, by the script]: the tree was clean; no C4-T, no
technology/technical-answers.md and no technology/stack-research.md existed; restricted/ was ignored by git, with nothing under it tracked; interpretation/change-record.md and
product/product-change-record.md each held, unchanged, the text the Technical Answers worker read (the C153-I and C15-P
states), with any later blocks only appended after it; and these files were at these hashes.

| File | sha256 |
|---|---|
| technology/technology-change-record.md | `6a10dfd38bf1bede6307a396691a9685f4482d5bff01ae91aeb0367e45de4971` |
| interpretation/change-record.md (its last block C153-I) | `86f848ab0eaff1d969bd22f07fabcc2e5a8fb5ec897c1090b6a6752f02ff5876` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/privacy-ethics-safety.md | `4f83555ec7fa3b6d488994523d9e81dd12780a2bbe4aa4554cae80f8fbbcef09` |
| interpretation/tester-disclosure-specification.md | `f28b64e16cc8b4df3598d6dd86447645eceba2a48b2594682fc4f0bfb6981ff3` |
| product/product-change-record.md (its last block C15-P) | `be1857280de9a1ec09b2198afefda0f11006f31efe539a0dd9a14a5d79e0a106` |
| product/technology-handover.md | `7e659f472e8cd80dec99af1fb6a0bdbcbb25aee5d73231ba5d7b09bd9d07fced` |
| product/founder-lists-for-technology.md | `4326cfcc5cb804344eb456a65ab56cbc4d8ccd2aa175214aff9253ee25d92500` |
| product/places-register.csv | `d2b5e14a92b210db2a006b0deefcd40029f56a33ced808562c1242d5689c4383` |
| technology/stack-research.md (filed in this commit; checked after writing) | `db0130d51ce0aa6578032e279e993fca6ab844e7819cbe0543f26d428783fed6` |

**WHAT DEPENDED ON THIS.**

- **technology/technical-answers.md,** filed with this block (items 2 and 19).
- **C3-T 2c**, amended by item 18. **technology/stack-research.md**, filed with this block (item 14).
- **The Build worker's setup and build** (items 3 to 8, 10, 11 and 13; item 10's two build rules). Before any dreamer's words pass through, it
  settles:
  - the three account checks (technical-answers.md, b);
  - whether AWS offers a true hard spending cap (m);
  - that offline recordings stream and are never stored (a);
  - that AirDrop uses no server (item 8);
  - that an update keeps the Cohort 0 app's journal (item 13).
- **The Build worker's setup guide v2, and its jobs 2 and 3** (items 14 to 17), including that each iPhone feature the
  answers rely on is reached through the iPhone's own feature under Flutter (technical-answers.md, k).
- **The Architecture worker's next job** (kit item 2), on the stack as ruled (item 14).
- **Product & Design**, via Technology Message 7 [RELAYED, the head]: W27·10 under public links (item 12); W27·3's
  "anything you share", against item 9 (technical-answers.md, b); and W27·2 to W27·4's "keeps nothing", which names item 18's exception in neutral words,
  which Technology tells Product next (item 18).
- **Interpretation, via Product:** a note that the export may serve as a safety copy (item 8); the age band, which Technology proposes leaves alone, at the age gate
  (technical-answers.md, e). If ruled in, W27·6 changes.
- **C3-T**: item 4's gate, replaced by item 3; 2j's timing, amended by item 11; 2i, met as item 6 says.
- **C1-T item 3.5**, settled by item 7.
- **This record**, which must hold the founder's confirmation that both data processing agreements are saved before any
  dreamer's words or voice pass through (item 3).
- **The four redrafts** (item 4).
- **Counsel, before Cohort 1** (item 3).

---

## C5-T — the record's hash; no distress check, no Help and no crisis material, indefinitely; the counts that remain; three settings; what one night is; the four redrafts filed and reviewed; Organisation's record; technical-answers.md replaced

**Filed 2026-11-09, by this machine.** *Items 2 and 6 hold the founder's rulings of 2026-11-07, relayed by Head of
Technology in its message 16 to the Technical Answers worker, and confirmed by the founder in these words before filing
[RELAYED, Head of Technology; the founder]. Items 3 to 5 record what Interpretation and Product have filed. The
replacement of technology/technical-answers.md is filed with this block, in the same commit, and its first filing is
archived verbatim.*

**1. THE RECORD'S HASH.** As C1-T item 1 requires, this filing records the record's hash after C4-T:
`aa3f3c17fb701d28ffa00abecd46fa4169189feba8f2d47edeec9c5e0c645ca5`. The C4-T filing script printed it, and the project
mirror matched it [READ, the founder's output and the mirror, 2026-11-09]. This filing's script checked it before
writing [READ, by the script].

**2. NO DISTRESS CHECK, NO HELP, NO CRISIS MATERIAL, INDEFINITELY** (founder-ruled 2026-11-07). In his words to the
Build worker: "we are not doing distress calls at all anymore; don't build anything for this." The crisis check, crisis
material and the Help page are scrapped, not through a cohort but indefinitely, and nothing about them is built.

- **It goes further than C147-I** ("through Cohort 2"). Interpretation has recorded it at C153-I item 1, which keeps
  The Foundations §6's way back: a new founder ruling, on evidence of need.
- **In technology/technical-answers.md:** it answers n, now RETIRED; it removes every distress count from e; it makes
  C4-T item 8's "leaving out the distress results" moot; and it retires every Help part of every answer.
- **What stays** (C147-I; C153-I item 1): the rules that keep a reading from hurting anyone (the law document §2), and
  the not-therapy line.
- **The founder's stated intention, recorded here only, not a ruling and not planned:** a support feature, for example
  booking therapy or reaching people through the app, may be built one day, if pursued. The architecture keeps that
  door open; nothing is designed for it.

**3. THE COUNTS THAT REMAIN** (C146-I item 1; item 2 above). The age band never leaves the phone. Each of these is
stored with the night and counted only across all dreamers, and leaves once, at the end of each cohort, in the packet
technology/technical-answers.md (e) describes:

- whether a tradition read because of the bridge (C80-I item 1);
- how much the dreamer said in answer about each image (C85-I);
- whether the dreamer answered at all (C83-I item 4);
- how often each tradition is chosen (HI5);
- the press's failures, as counts (C141-I item 2).

Whether the four redrafts keep each count is [ASSUMED], and is read against them by the Model Work worker. W27·6 holds
as written (Product's message 10 asks Technology to confirm it [RELAYED, the head]).

**4. THREE SETTINGS, AND WHAT ONE NIGHT IS.**

- There are three settings: Language, Word Animation, and Night/Day. There is no Region setting (C152-I item 3).
- A night stays open until the first 21:00 after its first recording, by the phone's local time (C152-I item 2,
  founder-ruled).
- W27·15 is "This app is not therapy." (C152-I item 1).

**5. THE FOUR REDRAFTS ARE FILED,** so C4-T item 4's condition is now only that they are built into the app:

- The Opening, Draft 8 (C143-I, corrected at C145-I);
- Lens Practice, Draft 11 (C149-I);
- The Close, Draft 5 (C150-I);
- Recurrence & the Series, Draft 4 (C151-I).

A Model Work worker opens for kit item 3.

**6. EACH DOCUMENT'S MODEL INSTRUCTIONS ARE REVIEWED BEFORE COHORT 0** (founder-ruled 2026-11-07; C153-I item 4).
Technology writes them one document at a time, The Opening first. Each set goes through Product & Design to
Interpretation for one review of its faithfulness to the practice, before Cohort 0.

**7. ORGANISATION'S RECORD** is organisation/organisation-change-record.md (C15-P; C152-I item 3).

**8. technology/technical-answers.md IS REPLACED,** a Playbook (C3-T item 7), at sha256 `c6b1d05a56a08deb90e2709f96fc4038a99f108b2cb6e2e0021df93aac7bdca5`. Its
first filing, at sha256 `782a7e9482657f830ce7eff89fd0762bba59c9d98a199052adc7b9a10ebfaff3`, is archived verbatim as
technology/archive/technical-answers-at-C4-T.md. The replacement folds in items 2 to 7, and C145-I to C153-I by number.

**9. CHECKED BEFORE FILING,** by the filing script [READ, by the script]: the tree was clean; no C5-T and no
technology/archive/technical-answers-at-C4-T.md existed; technology/technical-answers.md was at its first filing's hash;
restricted/ was ignored by git, with nothing under it tracked; the two change records each held, unchanged, the text the
Technical Answers worker read, with any later blocks only appended after it; and these files were at these hashes.

| File | sha256 |
|---|---|
| technology/technology-change-record.md | `aa3f3c17fb701d28ffa00abecd46fa4169189feba8f2d47edeec9c5e0c645ca5` |
| technology/technical-answers.md (its first filing, now archived) | `782a7e9482657f830ce7eff89fd0762bba59c9d98a199052adc7b9a10ebfaff3` |
| interpretation/change-record.md (its last block C153-I) | `86f848ab0eaff1d969bd22f07fabcc2e5a8fb5ec897c1090b6a6752f02ff5876` |
| product/product-change-record.md (its last block C15-P) | `be1857280de9a1ec09b2198afefda0f11006f31efe539a0dd9a14a5d79e0a106` |
| product/places-register.csv | `d2b5e14a92b210db2a006b0deefcd40029f56a33ced808562c1242d5689c4383` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |

**WHAT DEPENDED ON THIS.**

- **technology/technical-answers.md,** replaced with this block, and its archived first filing (item 8).
- **The Build worker's CLAUDE.md:** its rules R8, R9 and R10 [RELAYED, the head], which change with item 2.
- **The Model Work worker** (kit item 3): the instructions and their order (item 6); which counts the redrafts keep
  (item 3); what earlier words a reading sends (technical-answers.md, t).
- **Product & Design:** W27·6, confirmed as written (item 3); W27·17, whose basis in C141-I item 9 is retired (item 2).
- **Interpretation, through Product:**
  - C147-I's scope, which item 2 goes beyond, recorded at C153-I item 1;
  - the law document's next draft (its standing rule on crisis resources and its §1, set aside);
  - the tester disclosure specification, which rests on the distress check, to redraft or retire;
  - whether the Requirements List's X3 and X4 change (technical-answers.md, n).
- **C4-T item 4** (item 5) and **C4-T item 8** (item 2).
