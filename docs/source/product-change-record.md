# Change Record — Product & Design

*No matter where you are on your journey, the steps you take are equally important.*

*One dated block per change ruled in Product & Design: what changed, who ruled it, and what depended
on it. Append-only.*

**Created** 2026-10-07, by this machine · **Owned by** Head of Product & Design

---

## C1-P — the record opened; the old build's design archived whole

**Filed 2026-10-07, by this machine.** *Head of Product & Design's rulings of 2026-10-07 on the archive's
name and form and on this record's check [RELAYED, Head of Product & Design]. The supersession the
archive rests on is the founders' ruling at C2-P item 2.*

**1. THIS RECORD** keeps the Conventions of interpretation/change-record.md and does not restate them.
Three things are Product's own: its mark, its first two ordinals, and its check.

- **The mark is -P.**
- **C1-P and C2-P are numbered at creation,** against an empty file, as C1-I to C16-I were. Every later
  block is drafted unnumbered and numbered by whoever files, under the same Conventions.

**Product's own check.** Interpretation's check (C91-I) reads only its own file and its -I blocks. This
one also reports a block without its WHAT DEPENDED field, and an unnumbered block heading left in. Run
from the repository root, it prints nothing when the record is sound:

    f=product/change-record.md
    grep -oE "^## C[0-9]+-P" "$f" | sed 's/## C//;s/-P//' | sort -n | uniq -c | awk '$1>1 {print "DUPLICATE C"$2"-P"} NR==1 && $2!=1 {print "FIRST BLOCK IS NOT C1-P"} NR>1 && $2!=p+1 {print "GAP after C"p"-P"} {p=$2}'
    awk '/^## C[0-9]+-P/ {if (h != "" && !w) print "NO WHAT DEPENDED IN "h; h=$2; w=0} /^\*\*WHAT DEPENDED ON THIS\.\*\*/ {w=1} END {if (h != "" && !w) print "NO WHAT DEPENDED IN "h}' "$f"
    grep -n "^## BLOCK UNNUMBERED" "$f"

Every Product filing commits only if it prints nothing. It printed nothing at this filing.

**2. THE OLD BUILD'S DESIGN, ARCHIVED WHOLE.** product/ui-ux-design.md, "UI/UX Design — Phase 1" [READ,
its first line], moves to archive/ui-ux-design-old-build-superseded-2026-10-07.md. It is carried whole in
an archive note: a few lines at the top say what it is, that it is superseded (C2-P item 2), its former
path and its original hash, and the original text follows, unchanged. This is the archive note C122-I
says the entries citing the file resolve through, and the one C124-I sends the law document's pointer to.

| The old design | sha256 |
|---|---|
| Original, at product/ui-ux-design.md | `a75a1e291b5f069d68add87163c330b65a928e688f4da9f4156fc6942ec06794` |
| Archived file, note included | `093b382f7ee1adcfb592b3483dfc853c43ae4d791c5f19a813be79807e546273` |

The original is intact. This prints the original's hash, and printed it at filing [READ, by the filing
script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/ui-ux-design-old-build-superseded-2026-10-07.md | shasum -a 256

This record cannot state its own hash, as C16-I found for Interpretation's. The filing script prints it.

**3. CHECKED BEFORE FILING,** by the filing script [READ, by the script]: the tree clean, and these files
at these hashes.

| File | sha256 |
|---|---|
| product/ui-ux-design.md | `a75a1e291b5f069d68add87163c330b65a928e688f4da9f4156fc6942ec06794` |
| interpretation/change-record.md | `94654ac9254320f0889b2c3eb73f5b100e5e76f4030a6627fc41cb17227c7eff` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

**WHAT DEPENDED ON THIS.** *From the founder's repository-wide search at db3ea0a [RELAYED, the founder's
output], found unchanged at filing by the script's search of every tracked file [READ, by the script].
restricted/ is untracked and was not searched.*

- **Records citing the path product/ui-ux-design.md** stand as written: C23-I's "What moved", and
  interpretation/founder-material-pass/judgements_reportonly.py lines 6 and 7 with
  fm-reading-record-reportonly.tsv lines 138 to 169. Re-run, judgements_reportonly.py would fail on the
  old path.
- **Records citing the file by name** stand, and resolve through the archive note: C12-I's rename table,
  C22-I and C31-I; interpretation/founder-material-pass/fm-manifest.md lines 144 and 160.
- **Archived text citing it by name** is not edited: archive/lens-practice-draft-6.md line 523,
  archive/lens-practice-draft-7.md line 544, archive/the-opening-draft-6.md line 84,
  archive/blocks-drafted-2026-09-09.md line 219, interpretation/lens-practice-archive.md line 2220.
- **C122-I's NOTED line** named this archive note before it existed, and C124-I sends the law document's
  pointer to it. It exists now.
- **technology/old-build-report.md** holds no citation. Nothing there depended on this move.
- **This project's mirror of the old design** was removed by the founder before this filing [RELAYED,
  Head of Product & Design].
- **Not dependents.** C22-I's archived line, archive/ui-ux-design-replaced-2026-09-10.md, is a different
  file; fm-manifest.md line 137, judgements_archive.py lines 7 and 8, and fm-reading-record-archive.tsv
  lines 720 to 729 cite that file, not this one. Live documents that cite the old design as a source
  depend on C2-P item 2, not on this move.

---

## C2-P — the founders' rulings of 2026-10-07

**Filed 2026-10-07, by this machine.** *Ruled by both founders, Ludvig and Eva, 2026-10-07 [RELAYED, Head of
Product & Design].*

**1. THE PRODUCT PRINCIPLES IS A COMMITMENTS DOCUMENT,** signed by both founders when it files. It points
at the Requirements List.

**2. THE OLD DESIGN IS SUPERSEDED BY THE REQUIREMENTS LIST.** The old design is the old build's
product/ui-ux-design.md, archived whole at C1-P.

**3. RESEARCH** means the founder's own design research. A low-fidelity prototype is clicked through by
three people who are not beta testers, using invented dreams only. *Head of Product & Design, the same
day [RELAYED, Head of Product & Design]:* the prototype is Product's, in Figma. No reading runs on anyone's
own dream, so no disclosure is needed. Who writes its invented dreams and readings is decided later,
with the fixture set.

**4. KIT ITEM 5 IS CALLED THE PLACES REGISTER.**

**5. SCOPE.** Everything Cohort 1 needs, built fully. Nothing for later cohorts.

**6. SIGN-UP, ACCOUNTS, AGE AND DATA.** No sign-up, no account, no name or email asked. The rest is ruled
in Interpretation's record and pointed at here, not restated:

- the age: C122-I item 1 and C123-I item 4;
- no sharing, and nights on one device: C122-I, its NOTED line;
- deletion: C122-I item 2;
- no export, for now: C123-I item 1, with the law a question for counsel before Cohort 1 (C122-I item 11);
- what leaves the device: C123-I item 2;
- the install ID, and the optional account in Cohort 3: C123-I item 3;
- no resolution control: C122-I item 8.

**WHAT DEPENDED ON THIS.**

1. The role block's section on the governing document, which now has its kind. C31-I, which records the
   document being written fresh by Product & Design. Six entries in Interpretation's record cite
   product-principles.md: C1-I, C8-I, C12-I, C22-I, C23-I and C31-I [READ, interpretation/change-record.md
   at 94654ac9]. They mean the old build's June 2026 text, held in restricted/, and never this document.
   Its filename is chosen when it files.
2. C1-P, whose archive name and note rest on this ruling. Live documents that cite the old design as a
   source stand as written and now point at a superseded document [RELAYED, the founder's search at
   db3ea0a, unchanged at filing]: interpretation/privacy-ethics-safety.md line 58, whose Tier 1 paragraph
   places the read-only night in it, answered at C124-I as narration of the old build and not a rule (the
   Requirements List, F7), its pointer going to the archive note at the law document's next pass;
   interpretation/the-opening-draft-7.md line 101; interpretation/lens-practice.md line 655;
   organisation/decision-record.md line 220.
3. The role block's kit item 3, a research plan for Cohort 1, and kit item 8, a prototype tested with
   Cohort 1. Neither describes the work any more. C122-I's NOTED line already holds this ruling.
4. The role block's kit item 5, the places-for-words register. The Requirements List §7, the tester
   disclosure specification §4, and C51-I, C52-I, C73-I and C74-I call it the Copy Register [READ; the
   specification's from C124-I]. The entries stand. C124-I brings the list and the specification to the
   new name at their next pass.
5. Paused, and designed by no one now: the later-cohort onboarding copy the Requirements List §7 sends to
   Product; how distress detection looks when its consequences return (the role block's safety
   surfaces); the read-only night, part of the old held-night design (privacy-ethics-safety.md line 58,
   item 2; C124-I); and the optional account C123-I item 3 brings in Cohort 3.
6. The role block's data-and-privacy line, changed by the founder from "see, delete and export"
   [RELAYED, the brief] to "see and delete" [READ, the project instructions]. The Requirements List's X11,
   which C122-I item 2 reads for a journal with no account.
7. C124-I, which records that both founders agreed the rulings C122-I noted, and points here for them.

---

## C3-P — this record renamed to product/product-change-record.md; the hash C1-P owed; the heading check

**Filed 2026-10-07, by this machine.** *Head of Product & Design's ruling, founder-confirmed 2026-10-07 [RELAYED, Head of
Product & Design, its message 5]. Interpretation records the same ruling at C125-I item 2.*

**1. RENAMED.** This record moves from product/change-record.md to product/product-change-record.md, the path the
project instructions name. Interpretation's record stays interpretation/change-record.md. The brief that opened this
record named the old path; the file is renamed to match the ruling, and nothing already in it is edited. Its text up to
this block is byte for byte what was filed at 8b27e21 [READ, by the filing script].

**2. THE HASH C1-P OWED.** At 8b27e21 this record was
`d2f75ebc79ccf1ba65a94798574cb1b1fcb438ae24a903308671c329125ce897` [READ, by the filing script, which refused unless
the file still had it]. This record still cannot state its own current hash. The filing script prints it, and the next
Product filing records it.

**3. PRODUCT'S CHECK, AT THE NEW PATH.** C1-P item 1's three lines run unchanged except their first, which now reads:

    f=product/product-change-record.md

C1-P is not edited. The check printed nothing at this filing.

**4. THE HEADING CHECK** (C125-I item 1). Every Product filing script runs this as well, before it commits. It reads
every block, not only the new one, and prints nothing when each heading stands alone on its line and the next line
that is not empty is the block's filed line:

    f=product/product-change-record.md
    awk '/^## C[0-9]+-P/ {h=$2; if (index($0, "**")) print "HEADING RUNS ON: "h; want=1; next} want && NF {if ($0 !~ /^\*\*Filed /) print "NO FILED LINE AFTER "h; want=0} END {if (want) print "NO FILED LINE AFTER "h}' "$f"

It printed nothing at this filing.

**WHAT DEPENDED ON THIS.** *The lines naming the old path, from the filing script's search of every tracked file before
the rename [READ, by the script]; restricted/ is untracked and was not searched.*

- **C1-P item 1**, whose check names the old path. It stands as written; item 3 gives the path that runs.
- **The archive note**, archive/ui-ux-design-old-build-superseded-2026-10-07.md, which names the old path as where
  C2-P sits. It stands as written, at its filed hash `093b382f7ee1adcfb592b3483dfc853c43ae4d791c5f19a813be79807e546273`.
- **No other tracked line names the old path.** C2-P does not name it.
- **C125-I item 2**, which this makes true in the repository.
- **The project instructions**, which already name the new path [RELAYED, Head of Product & Design].
- **The project mirror**, which keeps its name product-change-record.md and is replaced by this version.
- **Every Product filing script from here**, which runs item 4's check as well as item 3's.

---

## C4-P — The Product Principles filed at product/product-and-design-principles.md, signed by both founders; the hash C3-P owed; three rulings of Product's own

**Filed 2026-10-09, by this machine. Signed by Ludvig and Eva, 2026-10-09.** *Drafted by the Product Principles worker chat from
Head of Product & Design's brief (its message 1) and its messages 2, 3 and 5 [RELAYED, Head of Product & Design]. Head of
Product & Design settled form and filename, and checked the draft before signing.*

**1. THE DOCUMENT.** product/product-and-design-principles.md, a Commitments document (C2-P item 1), written fresh
(C31-I); the June 2026 text in restricted/ was not opened. Its hash at signing and at filing:
`4fb6e47efc631ed7b10296fb74493e64a2e7930d58bce3f0b13a6b6c8f825684` [READ, by the filing script, which refused unless the file still had the hash both
founders said yes to]. This is the one filing: no unsigned draft was filed first. It points at the Requirements List and
restates nothing of it; it carries the north star verbatim.

**2. THE NAME.** Not product-principles.md. Six Interpretation entries cite that name and mean the old build's June
2026 text (C1-I, C8-I, C12-I, C22-I, C23-I, C31-I; C2-P item 1). The name the brief proposed, the-product-principles.md,
contains product-principles.md as a substring, so a search for the old name would have found the new file. The rename
C22-I recorded as owed on the old file was closed at C31-I; nothing is owed on this document.

**3. THE HASH C3-P OWED.** At d731059 this record was
`867e2ee5a77e8db13c011a587964c10bbc0de33eca4bab04d9160719fcd9b19f` [READ, by the filing script: the file at that commit
hashes so, and d731059 is the commit that last changed it before this one]. This record still cannot state its own
current hash; the filing script prints it, and the next Product filing records it.

**4. THREE RULINGS OF PRODUCT'S OWN,** carried in the document and recorded nowhere else. Ruled by both founders,
Ludvig and Eva [RELAYED, Head of Product & Design].
- Review prompts and sharing are refused everywhere in the app. Nothing is sold inside the practice; the rest is decided
  when there is something to sell (the document, §4f).
- The speech bubble for the dreamer's words is not in the Principles; it goes to How the AI Appears as the founder's
  starting design (§4a).
- The one deletion confirmation (C126-I item 6) covers a night, or the whole journal; nowhere else does the app ask
  "are you sure" (§2).

**5. EVERYTHING ELSE THE DOCUMENT CARRIES IS INTERPRETATION'S RECORD'S, by pointer, with no ruling date of its own
here:** what leaves the device, said truly (C126-I item 1); crash reports and their guard (item 2); no notifications, and
the microphone at first voice use (item 3); the feedback surface's rules (item 4); offline voice (item 5); the surfaces no
requirement covers, which come to Interpretation in the Experience Map, and the crisis page kept as filed (item 6).

**6. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the target path absent, and these files at
these hashes.

| File | sha256 |
|---|---|
| product/product-change-record.md, before this block | `867e2ee5a77e8db13c011a587964c10bbc0de33eca4bab04d9160719fcd9b19f` |
| interpretation/change-record.md, through C126-I | `07c004ff10a5ce24a9a8e68f2074f9e9c69320970fbc3a505010c38d2f270c69` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

Product's check (C1-P item 1, at the path C3-P item 3 gives), the heading check (C3-P item 4) and the document's word
check (filed beside it as product/check-principles.sh) all printed nothing.

**WHAT DEPENDED ON THIS.**

- **The role block's governing-document section.** The Product Principles now exists as a filed document; the listing
  says so.
- **C2-P item 1.** Its six citing entries stand and still mean the old text; the name chosen here keeps a search for
  the old name from finding this file. C31-I stands.
- **Every kit item after this one.** The Experience Map, which carries the document's §5 surfaces to Interpretation
  (C126-I item 6). How the AI Appears, which receives the look of the four voices, what shows that the app is working
  (§4b), and the founder's speech-bubble design (§4a). The design system and screens.
- **The Places Register.** The document holds no founder-copy placeholders beyond §6's example of the marker; every
  place its surfaces need is held in the Register. These eight are carried there from the draft, each with what its
  line must do:
  1. The screen-reader announcement (§3): say, for a screen reader, that the readings are now on the screen, in one
     plain sentence that reports and does not reward.
  2. The age question (§5): ask the age once, plainly, and say what is kept.
  3. How to use the app (§5): teach use, per language, and set nothing up for the dreamer.
  4. The deletion confirmation (§2, §5): one plain confirmation before deleting a night, and before deleting the
     whole journal.
  5. The empty journal (§5): say what is there, never that something should be.
  6. The failure sentence (§5; C122-I item 5): one plain sentence when a reading fails; the failure is the app's.
  7. What is kept and what leaves (§5): say it as C126-I item 1 says it, with X9 and X10.
  8. How to give feedback (§5; C126-I item 4): very easy; asks about the app, never invites a dream.
- **C126-I**, which the document points at six times and never restates. The Requirements List X7 and Core
  Commitments §4.1, whose allowance stands unused (C126-I item 3); neither document changes.
- **Requirements List X13.** The document names English and Swedish as where the app starts, and sends any new
  language to Interpretation first.
- **Technology.** Crash reporting configured as C126-I item 2 guards; no notification code; the offline wait (item 5).
- **The project mirrors.** product-and-design-principles.md is added; product-change-record.md is replaced by this
  version.

---

## C5-P — The Experience Map filed at product/experience-map.md, with its card sheet and check; the hash C4-P could not state; three corrections to C4-P

**Filed 2026-10-10, by this machine.** *Drafted by the Experience Map worker chat from Head of Product & Design's brief (its
message 1) and its messages 2 and 3 [RELAYED, Head of Product & Design], with Interpretation's C127-I folded in as
its message 3 asked. Head of Product & Design checked the draft and
its re-issue. The founder read it as material and answered two of its three questions to him (item 4).*

**1. THE MAP.** product/experience-map.md, a Playbook, replaced when the founder's designs exist. Beside it,
product/experience-map-cards.csv, the card sheet, one card per row of the map's placement table, and
product/check-experience-map.sh, the map's ID check. Their hashes
at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/experience-map.md | `43434fd1ebce8c886ea1de3a4f38b5c58ca96cf399c63711b559ec6355090be2` |
| product/experience-map-cards.csv | `f3be5ae3b97620045b2b743687c9db9719903ffe983b75ad7f12fbd9c87cc0b8` |
| product/check-experience-map.sh | `a0116945b8a34e62b6d8a06120d3d1f410aa480a6ce7cbea2b2a9e0ff05aa6f1` |

The surfaces no requirement covers go to Interpretation in two steps (C126-I item 6; the Principles §5). Step one is
this map: what each must do, and the questions. Step two is the founder's designs, when he has drawn his flows; the
map is replaced then. Nothing is built before step two.

**2. THE HASH C4-P COULD NOT STATE.** At 6b2b4b1 this record was
`30aded4d46c0de4290eb716d460bb7338426453c956447f0ac4bc37ff53e302a` [READ, by the filing script: the file at that commit
hashes so, and 6b2b4b1 is the commit that last changed it before this one]. This record still cannot state its own
current hash; the filing script prints it, and the next Product filing records it.

**3. THREE CORRECTIONS TO C4-P,** which is not edited.

- **Its drafting line.** C4-P's drafting line names Head of Product & Design's messages 2, 3 and 5. The document was
  drafted from its brief (message 1) and its messages 2, 3, 4, 5 and 7. Message 4 set the both-founders line; message 7
  made the language change [RELAYED, Head of Product & Design].
- **What was checked before signing** [RELAYED, Head of Product & Design]. The founders signed draft 4fb6e47e… before
  Head of Product & Design had checked it. Head of Product had checked draft
  `7955d71703f258c69557af77dd66088ecd15629818db0a942d2fc3fd422e946f`, and checked 4fb6e47e… after filing: the three
  language changes asked in its message 7 were in, word for word. The rest was not compared line by line. C4-P's
  drafting line, "checked the draft before signing", is untrue of the signed text.
- **The check filed beside the Principles.** C4-P item 6 names product/check-principles.sh as filed beside the
  document, and records no hash for it. It was
  `368d92df1a5517217f1c8dec55efa0d129057af94b437d9ddb3cc198f891cadd` [RELAYED, the C4-P filing script's output], and is
  `368d92df1a5517217f1c8dec55efa0d129057af94b437d9ddb3cc198f891cadd` at this filing [READ, by the filing script].

**4. THE FOUNDER'S ANSWERS** to the map's questions to him, and one confirmation. Answered by the founder, Ludvig
[RELAYED, Head of Product & Design, its message 3]. The map carries each where it applies.

- **F2.** Feedback is within reach from everywhere except inside a night (the map's M4 to M8).
- **F3.** The app opens in the phone's language if the app offers it, and otherwise in English. The language can be
  changed later. Whether the first screen also offers a language switch is the founder's to draw.
- **F1 is open.** Whether C4-P·7, W27, W29 and W30 are one place stays open until the founder draws and writes. The map
  keeps them separate.
- **Confirmed, for the map's I2:** the dreamer can edit the transcribed text, by typing, before being read.

**5. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the three target paths absent, and these
files at these hashes.

| File | sha256 |
|---|---|
| product/product-change-record.md, before this block | `30aded4d46c0de4290eb716d460bb7338426453c956447f0ac4bc37ff53e302a` |
| product/product-and-design-principles.md | `4fb6e47efc631ed7b10296fb74493e64a2e7930d58bce3f0b13a6b6c8f825684` |
| interpretation/change-record.md, through C127-I | `9538a42bf837157f5193782c42534437807aee8b09954dfa9a3626f29d316f40` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

Product's check (C1-P item 1, at the path C3-P item 3 gives), the heading check (C3-P item 4) and the map's ID check
all printed nothing.

**WHAT DEPENDED ON THIS.**

- **C126-I item 6 and the Principles §5.** Step one is delivered. Step two, the founder's designs in the map, is owed
  before anything is built.
- **Interpretation.** The map's questions I1 to I12, under the Requirements List §9, went to Interpretation in Head of
  Product & Design's message 6 [RELAYED, Head of Product & Design, its message 3], and were answered at C127-I, filed
  before this block. The map points at each answer and restates none; C127-I's rulings are open to the founder. Two
  changes to the map follow from them: EM·2 is retired (C127-I I1), and EM·10 is placed at the mirror and the band
  (C127-I I12). Product's definition of a failed reading went with I4; C127-I does not address it.
- **The Places Register.** The 31st place (C125-I item 3), C4-P's eight, and the eleven places the map finds (EM·1 to
  EM·11) are placed in the map by handle. The Register numbers what it keeps. C4-P and C125-I say the Register holds
  these places; until it exists, the map is where they are held.
- **How the AI Appears.** It receives the moment while the readings are made (M5), Q1b, and the look of the four voices.
- **The founder's flows and information architecture,** drawn from the map's moments. Nothing in the map is a screen.
- **The project instructions,** whose kit items 2 and 4 the founder changed to match this shape [RELAYED, Head of
  Product & Design, its message 2].
- **C4-P,** corrected by item 3 and not edited.
- **Technology.** Nothing yet. The map goes to Technology only with the founder's designs.
- **The project mirrors.** experience-map.md and experience-map-cards.csv are added; product-change-record.md is replaced
  by this version.

---

## C6-P — The main path filed at product/main-path.md; the Principles' dated block; the founder's decisions since C5-P; the hash C5-P could not state

**Filed 2026-10-20, by this machine. The Principles' block signed by Ludvig, 2026-10-20.** *Drafted by the Main Path worker
chat from Head of Product & Design's brief (its message 1) and its messages 3 and 4; message 3 replaced message 2
[RELAYED, Head of Product & Design]. Head of Product & Design checked the draft before Ludvig filed; the filing script
refused unless main-path.md was written at the hash it checked.*

**1. THE MAIN PATH.** product/main-path.md, a Playbook, replaced as the design evolves, the old text archived verbatim.
The founder's designs for the main path, from the first time the app is opened to a night landing in the journal, in
his seven pages and his order: Every Screen, Onboarding, Recording, The Mirror, The Opening, The Readings & Close, The
Journal [RELAYED, the founder's Notion pages, pasted to the worker chat]. Kit item 4, in its first full form. Its hash at
filing: `e4fe1e7ca424edac0ff8c3834c326e8dd4a95e8ebef06724ad0fb0aadd6dc676` [READ, by the filing script].

- **Assembled faithfully.** Formatting and list numbers fixed; the "(HoP)" suffixes dropped from the page headings; no
  design, rule or pointer changed. The worker chat compared it word by word with the pasted pages [READ, in that chat].
- **Founder's draft copy** is kept word for word and marked where it first stands on each page. The onboarding note is
  marked open, to check against the Shared Core's never-a-verdict line in the Places Register. The not-therapy
  paragraph keeps the founder's own label, "founder's text, final".
- **Three corrections, made by the founder in his pages after they were pasted, applied as Head of Product & Design's
  message 3 states them** [RELAYED]: no "Last updated" anywhere, so the Nights line reads "The journal shows the date.";
  the empty journal's line reads "will appear" on both pages; the swipe on a row is gone (item 5).
- **Who drafted the pages.** The founder designed onboarding, recording, the mirror, the opening, and the readings and
  close; Head of Product & Design wrote those pages up in this format from his notes and decisions. The Journal page
  began as a draft by Head of Product & Design, which the founder reworked and adopted. The Every screen page was
  assembled by Head of Product & Design from the founder's decisions [RELAYED, Head of Product & Design].

**2. STEP TWO OF C126-I ITEM 6 AND C5-P ITEM 1, DELIVERED.** The founder's designs now exist. The Experience Map stays as
filed, as the requirements by moment; main-path.md is where the designs are [RELAYED, Head of Product & Design, its
brief]. This changes C5-P item 1, which said the map is replaced at step two. C5-P is not edited.

**3. THE PRINCIPLES' DATED BLOCK.** Appended to product/product-and-design-principles.md, signed by Ludvig alone. The text
above it is byte for byte as filed at C4-P [READ, by the filing script]. The document's hash after the block:
`8beb1d776c3fad7b064765cdba42333610767a10ac2f7ee4b85dca26b210debd` [READ, by the filing script].

- The document is the founder's own: Ludvig changes and signs it alone (C130-I item 1). Replaces "both founders" in
  "What kind of document this is".
- Settings hold only what the dreamer sets for themselves and never change how the practice works; today the language
  and the word-by-word setting. Replaces §5's "Language is the one setting." and that line's test; §4d gains the
  word-by-word setting.
- Deleting the whole journal sits beside the settings but is deletion, under §2 and §4h, not a setting.

**4. THE HASH C5-P COULD NOT STATE.** At d07cf72 this record was
`caccbce768d29b8e000e8f5e74da024afcc8215c51c8410a6e113177e8d5a329` [READ, by the filing script: the file at that commit
hashes so, and d07cf72 is the commit that last changed it before this one]. This record still cannot state its own
current hash; the filing script prints it, and the next Product filing records it.

**5. THE FOUNDER'S DECISIONS SINCE C5-P THAT ARE PRODUCT'S OWN.** Each ruled by the founder, Ludvig [RELAYED, Head of
Product & Design]. main-path.md holds each in full; this lists them.

- **The Principles become his alone** (item 3; C130-I item 1).
- **A second setting:** word by word, on by default. Screen readers always get each line whole.
- **Feedback sits on the journal only,** top left, with the settings, never inside a night, its icon nothing like Help.
  This replaces C5-P item 4's F2 (within reach from everywhere except inside a night). Its rules stay C126-I item 4.
- **The recording screen's controls:** Save (sleeping-person icon) bottom right, back to the journal; Questions bottom
  left, to the mirror; the back arrow top left saves as Save does; the record button only adds text and never takes a
  command; the text is edited with a tap.
- **Next and This is mine now:** Next at every invitation in the close; This is mine now appears with the waking-life
  invitation and stays through the reflections, ending the session and keeping the night. The rule they meet is
  C131-I item 4.
- **The journal list's placements:** settings and feedback top left; Help top right; the search field at the top;
  the record button bottom centre, the biggest thing on the screen; rows newest first; no month divider for the current
  month. The row's line, the dividers and the search passages are C131-I items 1 to 3.
- **Search:** no suggestions, no autocomplete, no recent searches; results newest first. Its conditions are C131-I
  item 3.
- **A night is deleted from inside the night only,** with one plain confirmation; the swipe on a row is dropped
  (Principles §4h, one obvious place).
- **No "Last updated"** on any night, and the empty journal's line is "will appear" (item 1).

**6. THE LOOK OF THE VOICES: THE FOUNDER'S STARTING DESIGN, NOT A RULING.** The app's own words plain, centred, no
bubble, word by word; the dreamer's words in bubbles from the right; readings in terracotta bubbles from the left, each
labelled with its tradition in a slightly darker shade, each arriving whole; the arc in the readings' look; the press
in the app's look; the series question as a labelled terracotta bubble. Delivered to How the AI Appears, where it is
decided with Interpretation (the Principles §4a; C4-P item 4). Not decided here.

**7. WHAT INTERPRETATION RULED, BY POINTER ONLY.** C128-I (the opening's framing lines, Interpret Now, pausing, filler
sounds, and what one night is: item 6 holds the night rules main-path.md carries). C129-I (the close). C130-I (the
founder signs alone; Interpret Now extended). C131-I (the journal's line, dividers and search; the close's controls;
the crisis way in). None is restated here.

**8. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, product/main-path.md absent, and these files at
these hashes.

| File | sha256 |
|---|---|
| product/product-change-record.md, before this block | `caccbce768d29b8e000e8f5e74da024afcc8215c51c8410a6e113177e8d5a329` |
| product/product-and-design-principles.md, before its block | `4fb6e47efc631ed7b10296fb74493e64a2e7930d58bce3f0b13a6b6c8f825684` |
| product/experience-map.md | `43434fd1ebce8c886ea1de3a4f38b5c58ca96cf399c63711b559ec6355090be2` |
| product/experience-map-cards.csv | `f3be5ae3b97620045b2b743687c9db9719903ffe983b75ad7f12fbd9c87cc0b8` |
| product/check-principles.sh | `368d92df1a5517217f1c8dec55efa0d129057af94b437d9ddb3cc198f891cadd` |
| product/check-experience-map.sh | `a0116945b8a34e62b6d8a06120d3d1f410aa480a6ce7cbea2b2a9e0ff05aa6f1` |
| interpretation/change-record.md, through C131-I | `7c92f04e8c72aa2fcf4111ba02f621b988d8430d5bb98951bdbd2a8f20a1982f` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

Product's check (C1-P item 1, at the path C3-P item 3 gives), the heading check (C3-P item 4), the map's ID check and
product/check-principles.sh on the amended Principles all printed nothing.

**WHAT DEPENDED ON THIS.**

- **Interpretation.** The founder's designs are now with them (C126-I item 6, step two), in Product & Design's message to
  Interpretation 10. Anything in them that changes what a dreamer experiences of the practice is theirs to answer
  (the Requirements List §9).
- **The Places Register,** next, built from main-path.md's WORDS TO WRITE and its marked founder's draft copy, with the
  places C5-P lists. The onboarding note and the readings' draft line are open there.
- **How the AI Appears.** It receives item 6: the voices' look, word by word, the reading bubbles, the press, and the
  series question's bubble, which the Readings & Close page sends there to check.
- **The Experience Map.** It stays as filed. Its line "It is replaced when the founder's designs exist" no longer holds
  and stands as written until the map's next pass. C5-P item 1 is changed by item 2.
- **C5-P item 4's F2,** replaced by the feedback placement in item 5.
- **The Principles §4d and §5,** changed by their dated block (item 3); the text above it is not edited.
- **What main-path.md leaves open:** what the crisis page holds (W26); whether the first screen offers a language
  switch; the disclosure's full text; from Technology, the AI company's name and how long it keeps the words; the
  Help word, tested with the three click-through testers before Cohort 1 (C131-I item 5).
- **Technology,** later, with the handover: design plus behaviour. Nothing goes to Technology at this filing.
- **The project mirrors.** main-path.md is added; product-and-design-principles.md and product-change-record.md are
  replaced by these versions.

---

## C7-P — The Places Register filed at product/places-register.md, with its sheet and check; the age bands; C132-I and C133-I carried; the hash C6-P could not state

**Filed 2026-10-20, by this machine. The age bands founder-ruled 2026-10-20.** *Drafted by the Places Register worker chat from
Head of Product & Design's brief (its message 1) and its messages 2 and 3 [RELAYED, Head of Product & Design], with C133-I,
filed while it was drafted, folded in [READ]. Head of Product & Design checked the draft before Ludvig filed; the filing script refused unless the three files were written at
the hashes it checked.*

**1. THE REGISTER.** product/places-register.md, a Playbook, kit item 5: every place in the app where a dreamer meets
words, what its line must do and must never do, how long it may be, its status, the founder's draft verbatim, and empty
English and Swedish columns for the founders. Beside it, product/places-register.csv, the same rows, for the founder to
import into Notion and write in; and product/check-places-register.sh, its check. Their hashes at filing [READ, by the
filing script]:

| File | sha256 |
|---|---|
| product/places-register.md | `948c4e47183ea910c16650987561b75d82d404d54b33cf1c8db5b1281ac642e2` |
| product/places-register.csv | `6f08484a6ef65d4f3d45d0b6dbd089659dd5a0e1c1dd37cabcf2350bd3d1996a` |
| product/check-places-register.sh | `c3f604d7dab2731d3bd6410c4fecc88137840492b5566ec9aaeae1e64c27ad6f` |

- **81 places** [READ, `bash product/check-places-register.sh --count`, its line "places 81"]: one row per handle,
  grouped by the pages of product/main-path.md in its order, then a last group, Not on a screen yet. A place on several
  screens is one row, at the screen where it first stands, with the others under "Also on".
- **Where they come from:** the Requirements List §7, W1 to W30, P1 and P2; C125-I item 3; C4-P's eight; the map's EM·1
  to EM·11; and twenty-nine places product/main-path.md adds, MP·1 to MP·29. P1 and P2 are rows with no line, so nobody
  writes them in good faith. EM·2 and W19 are rows marked retired, so neither is revived.
- **The check** prints nothing when every place the list's §7 and the map name is in the register; every [founder's draft
  copy] mark and every WORDS TO WRITE bullet in main-path.md is placed; every draft is verbatim from main-path.md, or
  from C132-I where C132-I gives the founder's words; statuses, lengths, screens and moments come from fixed lists; and
  the .md and the .csv hold the same rows in the same order. Its list of expected handles is hand-made, and was checked
  by Head of Product & Design [RELAYED, Head of Product & Design].
- **How written lines come back from Notion** is in the register's intro, as Head of Product & Design set it (its message
  2, item 11) [RELAYED, Head of Product & Design].

**2. C132-I, CARRIED.** main-path.md still holds the drafts as they stood before C132-I. The register holds them as C132-I
leaves them [READ, C132-I]:

- **The note** (MP·4): "what our dreams truly mean" becomes the founder's "what our dreams mean to us" (item 6). The
  note's open mark is closed.
- **The choice to be read** (EM·1): "Start Interpretation", English written (item 5), not yet checked beside Interpret Now
  (W2). The recording screen's top line (MP·10) is to rewrite.
- **The line before the readings** (MP·20): to rework; "most relevant" and "today" go (item 1). Its draft is kept verbatim
  with that flag.
- **The not-therapy paragraph** (MP·7): final, one sentence to rewrite, to say where Help is (item 7).
- **Interpret Now** (W2): from the first thing the opening asks (item 2).
- **The close's two invitations without a §7 handle** are MP·21 and MP·22, named apart from the opening's stood-out line
  (item 4).

**3. C133-I, CARRIED** [READ, C133-I]. W19, the permission inside the space, is retired (item 1). W20, the promise,
stays, met where the dreamer writes in the close (item 2). W17's heading is retired, and has no row; W17's row carries
item 3's condition, that it reopens if How the AI Appears gives the app's lines a look that could be taken for a
reading's.

**4. THE AGE BANDS** (founder-ruled 2026-10-20) [RELAYED, Head of Product & Design, its message 3]: under 18; 18–24;
25–34; 35–44; 45–54; 55–64; 65+. "Under 18" leads to the gate's answer, and no band is sent for it (C127-I I6). The six
from 18–24 up are the bands C123-I item 4 sends once as a count. Their labels are a place in the register (MP·6), to
write. The age question (C4-P·2) keeps its flag: it must say what is kept.

**5. WHAT THE REGISTER FOUND, OPEN.** Each is flagged on its row. None is ruled here.

- **Places on no screen in main-path.md:** W7, W12, W14 and W15, inside the readings and not drawn; W16, waiting on Q1;
  W20, which C133-I places in the close and main-path.md does not draw; C4-P·3 beyond its first two lines (MP·7, MP·9);
  C4-P·7.
- **Controls drawn without words:** the record button (MP·11), typing a dream (MP·12), merge and split (MP·17), hearing
  the read-back (MP·18), the input field (MP·19), the way in to the settings (MP·25), naming a night (MP·28). How a person
  declines the disclosure (EM·6) is not drawn.
- **The way back to the journal** (MP·14) saves, pauses or leaves the night open, by screen: whether one name says all
  three truly.
- **F1** (C5-P item 4): whether W27, W29, W30 and C4-P·7 are one place.
- **The marking line** (MP·24): where it sits.
- **F3:** whether the first screen offers a language switch (EM·9).

**6. THE HASH C6-P COULD NOT STATE.** At 290dacb this record was
`c2191537dec5a57a148617fb160e7f4d76653f55494e1a0005818f7d632d7987` [READ, by the filing script: the file at that commit
hashes so, and 290dacb is the commit that last changed it before this one]. This record still cannot state its own
current hash; the filing script prints it, and the next Product filing records it.

**7. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the three target paths absent, and these files at
these hashes.

| File | sha256 |
|---|---|
| product/product-change-record.md, before this block | `c2191537dec5a57a148617fb160e7f4d76653f55494e1a0005818f7d632d7987` |
| product/product-and-design-principles.md | `8beb1d776c3fad7b064765cdba42333610767a10ac2f7ee4b85dca26b210debd` |
| product/main-path.md | `e4fe1e7ca424edac0ff8c3834c326e8dd4a95e8ebef06724ad0fb0aadd6dc676` |
| product/experience-map.md | `43434fd1ebce8c886ea1de3a4f38b5c58ca96cf399c63711b559ec6355090be2` |
| product/experience-map-cards.csv | `f3be5ae3b97620045b2b743687c9db9719903ffe983b75ad7f12fbd9c87cc0b8` |
| product/check-principles.sh | `368d92df1a5517217f1c8dec55efa0d129057af94b437d9ddb3cc198f891cadd` |
| product/check-experience-map.sh | `a0116945b8a34e62b6d8a06120d3d1f410aa480a6ce7cbea2b2a9e0ff05aa6f1` |
| interpretation/change-record.md, through C133-I | `e891aad97444802101acc92247159c356264fef8925b11ac1347ea03ee26e17a` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

Product's check (C1-P item 1, at the path C3-P item 3 gives), the heading check (C3-P item 4), the map's ID check,
product/check-principles.sh on the Principles as file-c6p-main-path.sh ran it, and the register's own check all printed
nothing.

**WHAT DEPENDED ON THIS.**

- **The founders' writing.** The founder imports places-register.csv into Notion and writes there. Lines come back by the
  method in the register's intro. Nothing is written until he writes.
- **product/main-path.md.** Its next pass aligns with C132-I: the note, Start Interpretation, the recording screen's top
  line, the line before the readings, the not-therapy sentence, and Interpret Now from the start. Until then the
  register's check reads the note through C132-I item 6 and Start Interpretation from C132-I. When main-path.md changes,
  the register's check runs, and the register follows.
- **Interpretation.** C133-I's three items are open to the founder; if he overturns any, W19, W20 or W17's heading
  changes here. The Requirements List's next pass: its §7 gains the mirror's place (C125-I item 3) and the close's
  invitations, retires W19 and W17's heading, and its composed lines leave it as written lines (C128-I item 1; C129-I
  item 5; C133-I). The ⚠ in four of §7's titles is not defined in the list.
- **Technology.** The AI company's name and how long it keeps the words (W30, blocked); whether the heard mirror's voice
  is made off the phone (C132-I item 3; W27, MP·18); the microphone text's length limit (EM·3).
- **How the AI Appears.** The announcements that say which voice is speaking (EM·10, C4-P·1) meet the voices' look there.
  C133-I item 3's condition: a look for the app's lines that could be taken for a reading's reopens W17's heading.
- **The three click-through testers,** before Cohort 1: the Help word (EM·7; C131-I item 5).
- **The Experience Map.** It stays as filed. The register keeps its handles and adds MP·1 to MP·29. Two moments differ
  from the map's: W17 sits at M8, because C129-I item 2 put it after the dreamer's response, where the map has M7; and
  C4-P·8 sits at M10, on the journal only (C6-P item 5), where the map has M0.
- **The tester disclosure.** W27's must points at its specification's §2, not read for the register.
- **The project mirrors.** places-register.md and places-register.csv are added; product-change-record.md is replaced by
  this version.

---

## C8-P — The founder's lines filed in the Places Register; "written"; the founder's decisions and positions; the register as filed at C7-P archived; the hash C7-P could not state

**Filed 2026-10-21, by this machine.** *Drafted by the Places Register worker chat from Head of Product & Design's message 5, its
note naming the export, and its message 6 [RELAYED, Head of Product & Design]. Head of Product & Design checked the draft before Ludvig
filed; the filing script refused unless the three files were written at the hashes it checked.*

**1. THE FOUNDER'S LINES.** The founder wrote his lines in Notion, in the table imported from places-register.csv, in English
and in Swedish [RELAYED, Head of Product & Design]. His export, places-register_-_places-register_76fe53.csv, sha256
`b2130a44145f862de32f4694d1024f99f069ecf8ee584af142f850b6582b3237` [READ, the worker chat], replaced an earlier export,
9d790f, and differs from it only in three of his fixes (MP·3's Swedish, W10, W7) [RELAYED, Head of Product & Design]. It
was brought into the register as follows [READ, the worker chat, cell by cell against the register as filed at C7-P]:

- **Taken from it:** the English and Swedish columns only, as he wrote them. 55 rows hold both languages; no row holds
  one alone.
- **Restored:** the register's column order, row order and line endings. The export carried CRLF line endings and no
  byte-order mark.
- **Trimmed:** a space at the end of 15 cells, none inside a line: EM·5, MP·10 (both), EM·8 (both), W6, C4-P·6, W10,
  W11, C4-P·1, W24, W23, C4-P·8 and W7 (both).
- **Not taken:** four draft cells edited in Notion (MP·1, MP·2, MP·4, MP·6). The draft column keeps main-path.md's
  drafts, as filed at C7-P; his words for those places are in the English and Swedish columns.
- **Every other cell** of the export equals the register as filed at C7-P.

**2. "WRITTEN", AND THE STATUSES** [RELAYED, Head of Product & Design, its message 5].

- **"Written"** is added: both English and Swedish filled, and final. The register's check requires both.
- **Every row with both languages filled is "written"**, except four. W27, the disclosure: its first sentence is written,
  and the rest waits on Technology and is completed before Cohort 1. W29 and W30: blocked, waiting on Technology (where
  transcription happens; the AI company, its retention and its training terms). W24: blocked, with Interpretation
  (decision 2). In W24, W29 and W30 the English and Swedish are drafts, not final.
- **W8, W9 and W18** are composed, with stand-ins to write (decision 6). **W14, W15, W21 and W22** are unchanged and
  flagged as with Interpretation. **C4-P·3** is paused until the screens are drawn and the click-through has run.
  **C4-P·7** has no line, by decision 5.
- **The counts** [READ, `bash product/check-places-register.sh --count`]: 81 places; written 51; composed, stand-in to
  write 10; blocked 8; to write 5; no line 3 (one prohibition, two by decision); retired 2; paused 2.

**3. THE FOUNDER'S DECISIONS AND POSITIONS.** From the founder, Ludvig [RELAYED, Head of Product & Design]. Three are ruled
by him: 1, 3 and 5. Four are his position, to go to Interpretation, and nothing here treats them as ruled: 2, 4, 6 and 7
(the Requirements List §9). The register carries each on its row.

1. **The age question only asks** (C4-P·2). What is kept is said in the disclosure that follows. This replaces C4-P·2's
   "and say what is kept"; C4-P is not edited.
2. **His position: the entering control reads "Thank you"** (W24), replacing "This is mine now". To Interpretation in its
   next batch; until it answers, W24 is blocked and his lines are drafts.
3. **The journal shows each night's date only, never its time** (MP·27). The time of first recording is still kept, for
   the series' order (C128-I item 6).
4. **His position: "session" is the dreamer-facing word for a night**, in every line. To Interpretation with W25 in its
   next batch. The lines he wrote with it stand as written (MP·28, MP·29).
5. **F1 is answered** (C5-P item 4): C4-P·7, W27, W29 and W30 are one place, the disclosure. The disclosure is readable
   again beside the settings: in the same top-left place as the settings, deletion and feedback, not as a setting. No
   Principles block is owed (the Principles, dated block items 2 and 3).
6. **His position: W8, W9 and W18 are composed, with stand-ins.** With Interpretation.
7. **His position: W25's word found on one night only is shown by the results themselves**, one night listed, with no
   extra line. To Interpretation in its next batch.

**4. THE REGISTER AS FILED AT C7-P, ARCHIVED WHOLE.** Its two files move to the archive, each carried whole in an archive
note, as C1-P item 2 archived the old build's design: a few lines at the top say what it is, that it is superseded here,
its former path and its original hash, and the original text follows, unchanged. The new register takes their paths.

| File | sha256 |
|---|---|
| Original, product/places-register.md | `948c4e47183ea910c16650987561b75d82d404d54b33cf1c8db5b1281ac642e2` |
| Archived, archive/places-register-superseded-2026-10-21.md, note included | `c0e6507ec66893eb9456323b3b76fcb9a7c622de5b10dce92cf0ed569d3d0471` |
| Original, product/places-register.csv | `6f08484a6ef65d4f3d45d0b6dbd089659dd5a0e1c1dd37cabcf2350bd3d1996a` |
| Archived, archive/places-register-superseded-2026-10-21.csv, note included | `bf7c0f7b52e6f7797fe6a09ca7e93c0c9077f726042d5cf9f4afabeab91fbb39` |

The originals are intact. Each of these prints its original's hash, and printed it at filing [READ, by the filing
script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-10-21.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-10-21.csv | shasum -a 256

**5. THE REGISTER NOW, AND ITS CHECK.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/places-register.md | `2a765f09bc081116e116c8af44659d1bf2aae1d01e014a9095a251959c74e309` |
| product/places-register.csv | `db9dab196f00c084414ba010db5da09efe7b24f368a60ec81eaac2c075d74fb7` |
| product/check-places-register.sh | `9fa60eb6f3b338ad0c14784c46cc4fbd306963499853f53c4eb80f10643cc2bb` |

The register's intro gains "written" among its statuses, W8, W9 and W18 among its composed places, and C8-P beside C7-P
in its provenance. The check, which was `c3f604d7dab2731d3bd6410c4fecc88137840492b5566ec9aaeae1e64c27ad6f`, gains five
rules: a written row holds both languages; a row whose Swedish is filled is not still "Swedish to write"; English or
Swedish may sit only in a row that is written, final, English written, blocked or composed; no line begins or ends with
a space; and "written" is a status. The old check stays in the repository's history.

**6. THE HASH C7-P COULD NOT STATE.** At b6059bd this record was
`b48c596bc370fcc706c450e1c52c45191d06044892a724c4ed3eb3e89c5c4b4f` [READ, by the filing script: the file at that commit
hashes so, and b6059bd is the commit that last changed it before this one]. This record still cannot state its own
current hash; the filing script prints it, and the next Product filing records it.

**7. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the two archive paths absent, and these files at
these hashes.

| File | sha256 |
|---|---|
| product/product-change-record.md, before this block | `b48c596bc370fcc706c450e1c52c45191d06044892a724c4ed3eb3e89c5c4b4f` |
| product/places-register.md, before this filing | `948c4e47183ea910c16650987561b75d82d404d54b33cf1c8db5b1281ac642e2` |
| product/places-register.csv, before this filing | `6f08484a6ef65d4f3d45d0b6dbd089659dd5a0e1c1dd37cabcf2350bd3d1996a` |
| product/check-places-register.sh, before this filing | `c3f604d7dab2731d3bd6410c4fecc88137840492b5566ec9aaeae1e64c27ad6f` |
| product/product-and-design-principles.md | `8beb1d776c3fad7b064765cdba42333610767a10ac2f7ee4b85dca26b210debd` |
| product/main-path.md | `e4fe1e7ca424edac0ff8c3834c326e8dd4a95e8ebef06724ad0fb0aadd6dc676` |
| product/experience-map.md | `43434fd1ebce8c886ea1de3a4f38b5c58ca96cf399c63711b559ec6355090be2` |
| product/experience-map-cards.csv | `f3be5ae3b97620045b2b743687c9db9719903ffe983b75ad7f12fbd9c87cc0b8` |
| product/check-principles.sh | `368d92df1a5517217f1c8dec55efa0d129057af94b437d9ddb3cc198f891cadd` |
| product/check-experience-map.sh | `a0116945b8a34e62b6d8a06120d3d1f410aa480a6ce7cbea2b2a9e0ff05aa6f1` |
| interpretation/change-record.md, through C133-I | `e891aad97444802101acc92247159c356264fef8925b11ac1347ea03ee26e17a` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

Product's check (C1-P item 1, at the path C3-P item 3 gives), the heading check (C3-P item 4), the map's ID check,
product/check-principles.sh on the Principles as file-c6p-main-path.sh ran it, and the register's own check, as amended
here, all printed nothing.

**WHAT DEPENDED ON THIS.**

- **Interpretation.** W8, W9 and W18 composed (Head of Product & Design's messages 12 and 13); W14, W15, W21 and W22
  (message 12); in its next batch, "Thank you" (W24), "session", and W25's one-night case (decisions 2, 4 and 7). Each row stays as recorded here until
  Interpretation answers, and changes if it does not agree.
- **Technology.** The rest of the disclosure (W27), where transcription happens (W29), and the AI company, its retention
  and its training terms (W30). Each is completed before Cohort 1.
- **C4-P·2,** whose "and say what is kept" is replaced by decision 1. C4-P is not edited.
- **F1** (C5-P item 4), answered by decision 5. The Experience Map stays as filed and keeps the four handles apart; the
  register marks C4-P·7 as said in the disclosure.
- **product/main-path.md.** Its next pass carries decisions 1, 3 and 5, and C132-I as C7-P already asked: the age question
  only asks; the date without its time; the disclosure readable again beside the settings. Decisions 2 and 4 wait on
  Interpretation.
- **The three click-through testers,** before Cohort 1: the Help word (EM·7; C131-I item 5), and how-to-use's first-time
  lines, once drawn (C4-P·3).
- **The next filing of lines,** by the same method: the founder exports from Notion, and the filing archives this
  version whole.
- **The project mirrors.** places-register.md, places-register.csv and product-change-record.md are replaced by these
  versions.

---

## C9-P — How the AI Appears filed at product/how-the-ai-appears.md; C135-I folded in; the Principles' dated block; the places it adds; C134-I carried into the register; the register as filed at C8-P archived; the hash C8-P could not state

**Filed 2026-10-23, by this machine.** *Drafted by the How the AI Appears worker chat from Head of Product & Design's messages 1, 3, 4, 5 and 6 [RELAYED, Head of Product & Design]. Head of Product & Design checked the draft before Ludvig filed; the filing script refused unless every file was written at the hashes it checked.*

**1. HOW THE AI APPEARS, FILED** at product/how-the-ai-appears.md, sha256 `453094380e13fd35b57682131abfc91b68607ab2a782c8b51a7c92eee2650499` [READ, by the filing script]. Kit
item 6, a Playbook. It is built on the founder's decisions of 2026-10-22 [RELAYED, Head of Product & Design]. It sets the
look of the three voices, how words arrive, the waiting shimmer, the silences and the states shown by design, and what
it leaves to Figma. It draws no screen and writes no dreamer-facing line.

**2. COPY IS WRITTEN IN ONE PASS** (founder-ruled 2026-10-22) [RELAYED, Head of Product & Design, its message 4]. Every
dreamer-facing line still to write or rewrite is written in one copy pass at the end of Product & Design, before the
handover to Technology; the Places Register is that pass's list.

**3. TWO READINGS, NO DATED BLOCK OWED.** Ruled by Head of Product & Design, its message 3, items 2 and 11 [RELAYED].
- The Principles §4a refuses the chat thread and a persona, not motion; §4b gives the look of the app's work to How the
  AI Appears.
- The Principles' dated block, item 2: the setting the founder calls "Animation" (MP·26) changes how the app's own words
  appear, and the shimmer is that. It stops word by word and the shimmer; the phone's "Reduce motion" stops both.

**4. WORD BY WORD IS THE FOUNDER'S TRIAL FOR COHORT 0.** No preset signs: it stays until the founder, using the app in
Cohort 0, judges that it is not right; his judgement is the test [RELAYED, Head of Product & Design, its message 5,
G2]. Interpretation's note (C132-I item 8) sits beside it in How the AI Appears §4. If it ends, a later Product entry
records it.

**5. THE FOUNDER'S OTHER ANSWERS** [RELAYED, Head of Product & Design, its message 5]. The sweep runs five seconds at
most, then the label stands still (G1). W25 keeps its line until he chooses, in the copy pass (G3). W21 and W22 are
shown by design, their lines kept as what a screen reader is told (G4).

**6. C135-I AND C136-I FOLDED IN** [READ, interpretation/change-record.md at `28270aa8...`]. Every question How the AI
Appears sent was answered at C135-I; C136-I re-grounds its item B, and no part of the app ever says a reading is true,
right or the one: the press's paragraph and W16's row carry it. Where each answer stands: A, three voices, a quotation inside the tradition's voice (§2, §2.3);
B, the press is B1 and W16 its words (§3); C, the tones (§2.2); D1, the app's honesty and two new places, AI·9 and
AI·10 (§1); D2, the disclosure's AI sentence, on W27's row (§1); D3, labels name work (§5); D4, the mirror, and the
dream in the dreamer's voice once confirmed (§2.7, §3); D5, the series question's label, a new place, AI·11 (§3); D6,
the cap note in the app's voice (§3).

**7. THE PRINCIPLES' DATED BLOCK, SIGNED BY LUDVIG ALONE** (C135-I A; C130-I item 1). §4a's four voices become three,
and a quotation sits inside the tradition's voice, set apart and named. Appended; nothing above it edited [READ, by the
filing script: the bytes above the block hash as before].

| File | sha256 |
|---|---|
| product/product-and-design-principles.md, before | `8beb1d776c3fad7b064765cdba42333610767a10ac2f7ee4b85dca26b210debd` |
| product/product-and-design-principles.md, after | `3f5453b2ace4e4c72696404212ad06e0fa8521cafdd6511d4bdc29bc7ff555fe` |

**8. THE PLACES REGISTER.**
- **Eleven new places, AI·1 to AI·11.** AI·1 to AI·8 are the waiting labels. AI·1 to AI·6 carry the founder's drafts: AI·1, AI·5 and AI·6
  "founder's draft"; AI·2, AI·3 and AI·4 "founder's draft, to rewrite", each flag saying why. AI·7 (the mirror being
  prepared) and AI·8 (a reflection in an unread night's space) are "to write", by the founder's answer [RELAYED, Head
  of Product & Design, its message 4]. Every waiting label's row says it never names a mental act (C135-I D3). AI·9
  (the app is an AI, when asked) is "to write"; AI·10 (the sense is the dreamer's own) is "composed (stand-in to
  write)"; AI·11 (the series question's label) is "to write".
- **A new status, "to rewrite":** a line stands as written until the copy pass rewrites it (item 2).
- **C135-I on its rows:** W16 is "to write", its look B1 (B); W27 carries the AI sentence (D2); EM·10 counts three
  voices, names the mirror as the app reading back, and tells quotations from prose (A, D4); W7 is the app's voice
  (D6); W18 points at AI·11 (D5). EM·10 also tells "nothing saved".
- **The handle paragraph** gains AI·n for places How the AI Appears adds, numbered as the document lists them.
- **C134-I carried:** W8, W9 and W18 composed, with stand-ins (item 1); W15 retired and W14 kept in the tradition's own
  voice (item 2); W21 and W22 shown on screen by design, their lines kept as what a screen reader is told (item 3); W24
  "This is mine now", English written, Swedish to write (item 4); W25's design-state option (item 6).
- **"Session" in a dreamer's line** (C134-I item 5): MP·24, W23, MP·28, MP·29, W7 and W20 are "to rewrite", each flag
  saying why. Their lines stand as written until the copy pass.
- **No Freudian lens** appears in the register (C134-I item 9) [READ, by the worker chat].
- **The counts** [READ, `bash product/check-places-register.sh --count`]:

    places 92
    screen Every Screen 3
    screen Onboarding 15
    screen Recording 11
    screen The Mirror 6
    screen The Opening 11
    screen The Readings & Close 23
    screen The Journal 12
    screen Not on a screen yet 11
    status written 45
    status blocked 6
    status to write 9
    status founder's draft 3
    status composed (stand-in to write) 11
    status founder's draft, to rewrite 3
    status no line: prohibition 1
    status no line: by decision 2
    status English written, Swedish to write 1
    status to rewrite 6
    status retired 3
    status paused 2

**9. THE REGISTER AS FILED AT C8-P, ARCHIVED WHOLE,** each file in an archive note in the form C8-P's took. The new
register takes their paths.

| File | sha256 |
|---|---|
| Original, product/places-register.md | `2a765f09bc081116e116c8af44659d1bf2aae1d01e014a9095a251959c74e309` |
| Archived, archive/places-register-superseded-2026-10-23.md, note included | `bf16148fb3852d0f6b35956cef6b3b0eb8ae9724e7fc1e6ffd08e0b32586b76f` |
| Original, product/places-register.csv | `db9dab196f00c084414ba010db5da09efe7b24f368a60ec81eaac2c075d74fb7` |
| Archived, archive/places-register-superseded-2026-10-23.csv, note included | `e390175e7f67b947de861da466acc3cc262b80b77f086e93763a942007c2b5cf` |

The originals are intact. Each of these prints its original's hash, and printed it at filing [READ, by the filing
script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-10-23.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-10-23.csv | shasum -a 256

**10. THE REGISTER NOW, AND ITS CHECK.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/places-register.md | `feac216e1d1b64c0ca925532c653c0347479ad2f9cba96675386612142c5f3f7` |
| product/places-register.csv | `21ed8417f60ce399097bd2c120ef161c4004a21f8ccc64934e9fd4262333948a` |
| product/check-places-register.sh | `b43ab94884446c018c1d86fe6818b820dc8640fa0ce50ceac50b664b85b3e08e` |

The register's intro gains "to rewrite" among its statuses, AI·n among its handles, and the one copy pass in "How
lines come back". The check, which was `9fa60eb6f3b338ad0c14784c46cc4fbd306963499853f53c4eb80f10643cc2bb`, gains six
rules: AI·1 to AI·11 in its expected list; "to rewrite" is a status, and its rows may hold their lines; a "to rewrite"
row must hold one; every AI· handle stands in a table of How the AI Appears, numbered 1 to n in the order the document
lists them; an AI· draft is
verbatim in that document, marked [founder's draft copy]; and a waiting label naming a mental act, in the plainest
words of either language, is caught (C135-I D3). The old check stays in the repository's history.

**11. THE HASH C8-P COULD NOT STATE.** At d2da93a this record was `84372991dfb10c8f7d5c5998b7ade7717b0d7e74a2c7cde32f0fc81ee7645add` [READ, by the filing script: the
file at that commit hashes so, and d2da93a is the commit that last changed it before this one]. This record still
cannot state its own current hash; the filing script prints it, and the next Product filing records it.

**12. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the new paths absent, and these files at these
hashes.

| File | sha256 |
|---|---|
| product/product-change-record.md, before this block | `84372991dfb10c8f7d5c5998b7ade7717b0d7e74a2c7cde32f0fc81ee7645add` |
| product/places-register.md, before this filing | `2a765f09bc081116e116c8af44659d1bf2aae1d01e014a9095a251959c74e309` |
| product/places-register.csv, before this filing | `db9dab196f00c084414ba010db5da09efe7b24f368a60ec81eaac2c075d74fb7` |
| product/check-places-register.sh, before this filing | `9fa60eb6f3b338ad0c14784c46cc4fbd306963499853f53c4eb80f10643cc2bb` |
| product/product-and-design-principles.md, before its dated block | `8beb1d776c3fad7b064765cdba42333610767a10ac2f7ee4b85dca26b210debd` |
| product/main-path.md | `e4fe1e7ca424edac0ff8c3834c326e8dd4a95e8ebef06724ad0fb0aadd6dc676` |
| product/experience-map.md | `43434fd1ebce8c886ea1de3a4f38b5c58ca96cf399c63711b559ec6355090be2` |
| product/experience-map-cards.csv | `f3be5ae3b97620045b2b743687c9db9719903ffe983b75ad7f12fbd9c87cc0b8` |
| product/check-principles.sh | `368d92df1a5517217f1c8dec55efa0d129057af94b437d9ddb3cc198f891cadd` |
| product/check-experience-map.sh | `a0116945b8a34e62b6d8a06120d3d1f410aa480a6ce7cbea2b2a9e0ff05aa6f1` |
| interpretation/change-record.md, through C136-I | `28270aa804b26d05fd78b49ad4a7c8e97ba00119aa913a41b24a3f7edeff38f4` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

Product's check (C1-P item 1, at the path C3-P item 3 gives), the heading check (C3-P item 4), the map's check,
product/check-principles.sh on the Principles, with their dated block, as file-c6p-main-path.sh ran it, and on How the AI
Appears, and the
register's own check, as amended here, all printed nothing.

**WHAT DEPENDED ON THIS.**

- **Interpretation.** C135-I answered every question, and C136-I corrected its ground for B; nothing here waits on
  Interpretation. Its own WHAT DEPENDED
  names Lens Practice's Draft 11, the lens register's provenance, the tester disclosure specification's next draft and
  the Requirements List's Draft 2: those are Interpretation's.
- **The Places Register's statuses** (item 2). Every line still to write or rewrite is marked so, and each flag sits on
  its row, for the one copy pass.
- **The handover to Technology** (kit item 9), which waits on the copy pass.
- **The founder.** Whether W25 becomes a design state, in the copy pass (item 5). Word by word, his to judge in Cohort
  0 (item 4).
- **The disclosure.** W27 carries the sentence that an AI composes what the app says each night (C135-I D2); main-path.md's
  fact list carries it at its next pass; whether the law requires more, to counsel.
- **The three click-through testers,** before Cohort 1: the states shown by design (W21, W22, and W25 if chosen),
  untold, on C134-I item 3's conditions. If they fail, the sentences return.
- **product/main-path.md.** Its next pass carries: the "Animation" name for the setting; a pointer to How the AI Appears
  for the look of the voices; the press drawn as B1; the series question's label (AI·11); the dream in the dreamer's
  voice in the look back and the journal once confirmed (C135-I D4); the AI sentence in its fact list (C135-I D2).
- **Figma.** The design system takes its rules from How the AI Appears §2 to §9.
- **Technology.** How the AI Appears §11: AI·2's label before the app knows what comes next; the heard mirror's voice;
  AI·6 inside the night only; Animation and "Reduce motion"; status messages naming their voice; the quotation check
  against the lens file (C135-I A); a press that never declares a reading true (C136-I).
- **The project mirrors.** how-the-ai-appears.md is added; places-register.md, places-register.csv,
  product-and-design-principles.md and product-change-record.md are replaced by these versions.

---

## C10-P — The founder's design since C9-P: main-path.md and How the AI Appears in their next passes; the Design System filed; the Principles' dated block; the places the screens add; C137-I carried; the three documents as filed before archived; the hash C9-P could not state

**Filed 2026-10-29, by this machine.** *Drafted by the Design Update worker chat from Head of Product & Design's messages 1 and 2 [RELAYED, Head of Product & Design]. Head of Product & Design checked the draft before Ludvig filed; the filing script refused unless every file was written at the hashes it checked.*

**1. THE MAIN PATH, NEXT PASS,** at product/main-path.md, sha256 `d31d7ed017a336b0557f8d905d5d7223919752684612c74b8dddcac045b757aa` [READ, by the filing script]. Kit item 4, a
Playbook; the version filed at C6-P is archived whole (item 9). It carries the founder's decisions since C9-P (item 5)
and every debt earlier filings named: C7-P's (C132-I: the note, Start Interpretation, the recording screen's top line,
the line before the readings, the not-therapy sentence, Interpret Now from the first thing the opening asks); C8-P's
decisions 1, 3 and 5; C134-I (W24 stays, "night" and never "session", the composed lines, a word on one night shown by
the results themselves); C9-P's (the setting's name, now as the founder's screen shows it, Word Animation; How the AI
Appears for the look of the voices; the press drawn as B1; the series question's label, AI·11; the dream in the
dreamer's voice once confirmed; the AI sentence in the disclosure's fact list); and C137-I. It gains two pages, Help
and Settings: nine in all. The founder's drafts stay as drawn. Where a ruling changed one (the note, the line before
the readings, the not-therapy paragraph, the recording screen's top line), the change stands beside it, and the
written line is its row in the register. "Questions" gives way to "Start Interpretation", the founder's words that
C132-I item 5 records.

**2. HOW THE AI APPEARS, NEXT PASS,** at product/how-the-ai-appears.md, sha256 `4e615060aabda2b204c5de2cfe7153422df556a163a4713db8bb9c8d78bb69b4` [READ, by the filing
script]. Kit item 6, a Playbook; the version filed at C9-P is archived whole (item 9). It carries C137-I whole (item 7)
and the founder's decisions that touch the voices: the mirror's boxes in the app's voice until "Looks right", and the
section labels, neither a reading's look (§2.6); the dark theme's bubbles; Word Animation, and the theme's change
(§4); Framer, with the values in product/design-system.md (§9). AI·1 to AI·11 keep their numbers, their order and
their drafts.

**3. THE DESIGN SYSTEM, FILED** at product/design-system.md, sha256 `66d0010b128702799959b6c04786120a42348d5bd49b16d271e9c7de4a705bdf` [READ, by the filing script]. Kit item
7, a Playbook. The values the founder set in Framer, named by role: the type scale and the three voices, both colour
themes, spacing and radius, and the settings where they are visual. Contrast is Head of Product & Design's computation
[RELAYED], with the grey's one condition [READ, the Design Update chat's computation]. Every value not given is marked
[to set in Framer].

**4. THE PRINCIPLES' DATED BLOCK, SIGNED BY LUDVIG ALONE** (C130-I item 1). Settings hold four things; the test on
§5's line rewritten; the region from the phone, never location, and never leaving it; deletion, the disclosure and
feedback on the Settings page; Framer in place of Figma. Appended; nothing above it edited [READ, by the filing
script: the bytes above the block hash as before].

| File | sha256 |
|---|---|
| product/product-and-design-principles.md, before | `3f5453b2ace4e4c72696404212ad06e0fa8521cafdd6511d4bdc29bc7ff555fe` |
| product/product-and-design-principles.md, after | `98166005088bd6bbfadf4796a5dda7f90553a88d5ec400e43ab37cd77e0b7028` |

**5. THE FOUNDER'S DECISIONS SINCE C9-P.** Each ruled by the founder, Ludvig [RELAYED, Head of Product & Design].
- **Framer,** not Figma: kit item 7 and the role block's Tools line. Framer's variables, named by role, are the bridge to
  Technology's tokens.
- **Every screen.** Help, top right, unchanged; on its own page, "Change region" takes its spot. On a night, a "⋯" menu
  just left of Help: name this night, delete this night. No italics anywhere except the dreamer's own words quoted in
  a reading or a reflection (C137-I item 2). Dates always day/month/year.
- **Onboarding.** Always in the light theme. The welcome: the logo, the welcome line into the wordmark, the second
  line, Next. The note, signed by the founder. The age question as a dropdown of the bands, then Next; under 18, one
  card and "I understand". The disclosure across two pages: Next on the first; "I agree" and "I don't agree" only on
  the last; one consent (X2).
- **Recording.** The full instruction on first use, then one short line. The choice to be read is "Start
  Interpretation" everywhere. Save and Start Interpretation of equal weight. Recording by voice shows a waveform and a
  running timer, never a saved file.
- **The mirror.** Each dream in its own box with a numbered "Dream n" tag, in the app's voice and face until "Looks
  right", in the dreamer's voice everywhere after (C135-I D4). Move up, merge and move down between dreams; a scissor
  to split a dream where the text is tapped.
- **The readings and the close.** After "The Readings" label, 20px, then the image line. Section labels in the green
  gradient; tradition labels in the terracotta gradient. Reading bubbles white in the light theme and the bubble
  gradient in the dark theme; the arc carries its tradition's label; the series question's label says the tradition
  asks (C135-I D5). The dreamer's quoted words in italics and quotation marks, a source's upright, in quotation marks,
  named in the sentence (C135-I A; C137-I item 2). The reflection as one composed paragraph in the app's voice
  (C137-I item 1). W21 a line above the input field in the button style (C137-I item 3). Spacing: the dreamer's
  bubbles 30px from the left edge and 10px from the right, the traditions' 10px and 30px, 20px more before each new
  turn of the app's.
- **The journal.** Month dividers: the month alone in the current year, month and year in an earlier one; no count;
  none over an empty month (C131-I item 2). No row ever shows a time. An unnamed night's row: its date (h3), then the
  dream's opening line. A named night's row: its name (h5), the date under it in the button style, then the opening
  line; on the night's page, the name (h2) with the date under it. **This departs from C131-I item 1** ("named and
  unnamed rows look alike"); Interpretation's entry for it is still to come. The summary always three lines; the list
  scrolls clear of the record button; the record button a terracotta gradient with "Record dream" in white.
- **A night in the journal.** A read night opens at the bottom, at the space, with the night above, at rest: none of
  the reading's controls, no motion, the dreams in the dreamer's look, the waking answer marked as waking. The header:
  the date or name as h2, 20px above and 10px below. An unread night's space answers in the same composed paragraph as
  the close.
- **Help.** Title in h2; text in the button style at 14px; each resource's name in h6. Three resources per region,
  gentlest first: a therapist, then urgent help, then for someone feeling suicidal: graded, not alarming. No
  dream-science resource for Cohort 1. The region from the phone's own region setting, never location. Each resource:
  a prompt line, a logo or a placeholder, its name, a short description, and Call, Chat and Read, each an icon with a
  word. Call always dials, online or offline; only Chat and Read lead to a no-connection page offline. The page lives on
  the phone and opens offline. Static; nothing on it changes with what the dreamer writes; opening it is never counted.
  Cohort 1's regions: Sweden, Spain, Italy and the United Kingdom, three resources each, twelve cards in English and in
  Swedish, each checked as current before Cohort 1; any other region a general fallback, 112 and an international
  helpline directory chosen in the copy pass.
- **Settings.** Four: Language; Region; Word Animation, On or Off, stopping word by word and the shimmer; Night/Day mode,
  Automatic or Manual (Day or Night, Day first), Automatic dark at 21:00 and light at 08:00 by the phone's local time,
  a change while the app is open fading over five seconds. A quick light/dark toggle at the top centre. Feedback on the
  Settings page: an intro, the field, Submit. "Read disclosure & privacy", with no consent. "Delete journal", set apart,
  in the destructive style, one confirmation.
- **The design system's values,** as product/design-system.md records them (item 3).

**6. HEAD OF PRODUCT & DESIGN'S ANSWERS** [RELAYED, Head of Product & Design, its message 2 to the Design Update chat].
The feedback line keeps "our team": for Cohort 1 the team is the founders, so it is true; the disclosure says the
founders read it and that it is deleted after the cohort's review (C126-I item 4); if anyone else ever reads
feedback, that goes to Interpretation first. The Principles' block in four parts (item 4). The drafts kept, and each
row whose screen words differ "to rewrite" (item 8). The register's check amended (item 10). W26 "to write". A
light-theme field's border #8A8A8A; #767676 only ever on white; the other values as item 3. With Word Animation off or
"Reduce motion" on, the theme changes at once; the quick toggle, tapped under Automatic, switches to Manual. The "⋯"
menu on a night opened from the journal only. "No live controls" on a read night means the reading's own; the space,
W21 and This is mine now stay live. W22 where a reflection would stand, in the app's voice. After "I understand", the
card stays until the app closes (C127-I I6); "I don't agree" leads back to the disclosure's first page (C127-I I7).
The current month has its divider. A check before Cohort 1 that the three resources show without scrolling on the
smallest phone. The hashes checked at filing are today's.

**7. C137-I CARRIED** [READ, interpretation/change-record.md at `be88586b…`]. Item 1, the reflection as one paragraph
on its two conditions: How the AI Appears §3, main-path.md's The Readings & Close. Item 2, italics for the dreamer's
quoted words and upright for a source's: How the AI Appears §2.3, §2.7 and §2.8, main-path.md's Every Screen. Item 3,
W21 and W22 as sentences: How the AI Appears §6 and both rows. Item 4, white bubbles: How the AI Appears §2 and §2.1.

**8. THE PLACES REGISTER.**
- **Nineteen new places, MP·30 to MP·48,** each "to write". Onboarding: its Next (MP·30), the under-18 card's control
  (MP·31). Recording: the short line after first use (MP·32), what a screen reader is told while a recording runs
  (MP·33). The mirror: the dream tag (MP·34), move up and move down (MP·35). The readings: the section labels The
  Readings (MP·36) and The Arc (MP·37). The journal: the section label Dreams (MP·38), the night's menu (MP·39). Help:
  Change region (MP·40), Call, Chat and Read (MP·41), the no-connection page (MP·42). Settings: Region (MP·43),
  Night/Day mode (MP·44), the quick toggle (MP·45), the feedback field's line (MP·46), Submit (MP·47), the way to read
  the disclosure again (MP·48).
- **Places reused,** not added: the settings' title (MP·25), Language (EM·9), Word Animation (MP·26), the feedback intro
  (C4-P·8), naming a night (MP·28), deleting (EM·11) and its confirmation (C4-P·4), the scissor (MP·17), the input
  field's words (MP·19), the series question's label (AI·11), the choice to be read (EM·1), "I don't agree" (EM·6).
- **W26,** the Help page's words, is "to write", on the new page Help, holding each region's resources; its OPEN in
  main-path.md is answered.
- **"To rewrite" where the screen's words differ** from a written line, each flag naming the screen's words: MP·2,
  EM·6, MP·10, MP·11, MP·26, EM·11 and C4-P·8.
- **Two new pages,** Help and Settings. W26 moves to Help; EM·9, MP·26 and C4-P·8 to Settings.
- **W21 and W22** are sentences on screen (C137-I item 3); their flags say where each stands.
- **Flags and fields brought up to date:** W13, W27, AI·11, EM·5, MP·17, MP·19, MP·25, MP·27, MP·28, C4-P·4.
- **The intro:** a new MP handle is numbered on from the highest given; the provenance names C10-P's hashes.
- **The counts** [READ, `bash product/check-places-register.sh --count`]:

    places 111
    screen Every Screen 2
    screen Onboarding 17
    screen Recording 13
    screen The Mirror 8
    screen The Opening 11
    screen The Readings & Close 25
    screen The Journal 11
    screen Help 4
    screen Settings 9
    screen Not on a screen yet 11
    status written 38
    status to rewrite 13
    status blocked 5
    status to write 29
    status founder's draft 3
    status composed (stand-in to write) 11
    status founder's draft, to rewrite 3
    status no line: prohibition 1
    status no line: by decision 2
    status English written, Swedish to write 1
    status retired 3
    status paused 2

**9. THREE DOCUMENTS ARCHIVED WHOLE,** each in an archive note in the form C8-P's and C9-P's took. The new versions
take their paths.

| File | sha256 |
|---|---|
| Original, product/main-path.md, as filed at C6-P | `e4fe1e7ca424edac0ff8c3834c326e8dd4a95e8ebef06724ad0fb0aadd6dc676` |
| Archived, archive/main-path-superseded-2026-10-29.md, note included | `e70322eb7944adc5c3e30e3a18192cac86463497c3665b62c9f40b3d97796063` |
| Original, product/how-the-ai-appears.md, as filed at C9-P | `453094380e13fd35b57682131abfc91b68607ab2a782c8b51a7c92eee2650499` |
| Archived, archive/how-the-ai-appears-superseded-2026-10-29.md, note included | `27b4568e18e811140ade36f0134fadb3d5e5c120ad6b2153e029349c522ce48b` |
| Original, product/places-register.md, as filed at C9-P | `feac216e1d1b64c0ca925532c653c0347479ad2f9cba96675386612142c5f3f7` |
| Archived, archive/places-register-superseded-2026-10-29.md, note included | `feb9f61de166b68ace2c36621e7a7a2e3ff467774eda27b4afb5ef4cc40b6575` |
| Original, product/places-register.csv, as filed at C9-P | `21ed8417f60ce399097bd2c120ef161c4004a21f8ccc64934e9fd4262333948a` |
| Archived, archive/places-register-superseded-2026-10-29.csv, note included | `c85332121ce6ad75ef3e84e9868dbb9b377ed9b5f455f97726f6f674a9e73ef3` |

Each of these prints its original's hash, and printed it at filing [READ, by the filing script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/main-path-superseded-2026-10-29.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/how-the-ai-appears-superseded-2026-10-29.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-10-29.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-10-29.csv | shasum -a 256

**10. THE REGISTER NOW, AND ITS CHECK.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/places-register.md | `c0c8eb239682daf6e37b2147832b1a24c64b48ba5b0a07828bd88a0405272d5c` |
| product/places-register.csv | `b3a2c26feacb24a11a6464c0c37e52d4addd7d58481e199075bbd838f0112ad4` |
| product/check-places-register.sh | `0817f630e35fd417e332ff17d844dd3bb8a2d9d39f4b57c7124fab63a48e3aac` |

The check, which was `b43ab94884446c018c1d86fe6818b820dc8640fa0ce50ceac50b664b85b3e08e`, gains MP·30 to MP·48 in its
expected list and the pages Help and Settings; reads "Start Interpretation" where it read "Questions" (C132-I item 5);
knows each page's WORDS TO WRITE as main-path.md now holds them, Help, Settings and The Journal included; and asks that
MP numbers run 1 to n with no gap and no duplicate, in place of asking that they run in row order, so a place keeps its
handle when it moves page. The old check stays in the repository's history.

**11. THE HASH C9-P COULD NOT STATE.** At 1018920 this record was `27287a41f84dc692c119c6cd82aeed27a0b1f1117c22fcb9822c99b519b38f11` [READ, by the filing script: the
file at that commit hashes so, and 1018920 is the commit that last changed it before this one]. This record still
cannot state its own current hash; the filing script prints it, and the next Product filing records it.

**12. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the new paths absent, and these files at these
hashes.

| File | sha256 |
|---|---|
| product/product-change-record.md, before this block | `27287a41f84dc692c119c6cd82aeed27a0b1f1117c22fcb9822c99b519b38f11` |
| product/main-path.md, before this filing | `e4fe1e7ca424edac0ff8c3834c326e8dd4a95e8ebef06724ad0fb0aadd6dc676` |
| product/how-the-ai-appears.md, before this filing | `453094380e13fd35b57682131abfc91b68607ab2a782c8b51a7c92eee2650499` |
| product/places-register.md, before this filing | `feac216e1d1b64c0ca925532c653c0347479ad2f9cba96675386612142c5f3f7` |
| product/places-register.csv, before this filing | `21ed8417f60ce399097bd2c120ef161c4004a21f8ccc64934e9fd4262333948a` |
| product/check-places-register.sh, before this filing | `b43ab94884446c018c1d86fe6818b820dc8640fa0ce50ceac50b664b85b3e08e` |
| product/product-and-design-principles.md, before its dated block | `3f5453b2ace4e4c72696404212ad06e0fa8521cafdd6511d4bdc29bc7ff555fe` |
| product/experience-map.md | `43434fd1ebce8c886ea1de3a4f38b5c58ca96cf399c63711b559ec6355090be2` |
| product/experience-map-cards.csv | `f3be5ae3b97620045b2b743687c9db9719903ffe983b75ad7f12fbd9c87cc0b8` |
| product/check-principles.sh | `368d92df1a5517217f1c8dec55efa0d129057af94b437d9ddb3cc198f891cadd` |
| product/check-experience-map.sh | `a0116945b8a34e62b6d8a06120d3d1f410aa480a6ce7cbea2b2a9e0ff05aa6f1` |
| interpretation/change-record.md, through C137-I | `be88586bfec491cbdd36c8412c7d54b518f6d1ca1200239c9ebc28f20d7cf1ec` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

Product's check (C1-P item 1, at the path C3-P item 3 gives), the heading check (C3-P item 4), the map's check, the
register's own check as amended here, and product/check-principles.sh, as file-c6p-main-path.sh ran it, on the
Principles with their dated block, on How the AI Appears and on the Design System, all printed nothing.
**check-principles.sh was not run on main-path.md,** as neither C6-P's nor C9-P's script ran it there [READ, both
scripts]: it finds three words there, each used rightly. "anonymous" stands in the list of words the disclosure must
not say; "unfinished" in the rules that nothing treats a night as unfinished (O1, O2; C10); "your dreams" in the
founder's note, kept as drawn, which the register's check requires word for word.

**WHAT DEPENDED ON THIS.**

- **Interpretation.** A message of notices, which Head of Product & Design numbers and sends after this filing: the
  journal's rows (against C131-I item 1), whose entry is still to come; the mirror's boxes (C135-I D4; How the AI
  Appears §2.6); "The Arc" as a section label (L16); the reflection in an unread night's space (C137-I item 1; C10);
  the dark theme's bubbles (C137-I item 4); the Help page's order, categories, regions and region source (X1; W26);
  Help's no-connection page; feedback on the Settings page (C126-I items 4 and 6); the night/day schedule. C126-I item
  6 asks that the surfaces no requirement covers come to Interpretation with their designs before anything is built:
  the notice carries Help and Settings.
- **Organisation.** A notice: the Help page's logos and actions go beyond Core Commitments §6.3's "a screen with text
  on it", with nothing that offers the page and nothing on it that answers the dreamer; and the Swedish obligation
  there now reaches four regions, in English and in Swedish, twelve resource cards, founder-written.
- **The founder, in Framer.** Whether Habibi has a true italic (How the AI Appears §2.3); that the three resources show
  without scrolling on the smallest phone; the values marked [to set in Framer] (product/design-system.md §7).
- **The copy pass.** Every row marked "to write" or "to rewrite" (item 8's counts), the twelve resource cards and the
  fallback among them.
- **The three click-through testers,** before Cohort 1: the Help word (C131-I item 5), unchanged. The states shown by
  design are now nothing saved, and W25 if chosen; W21 and W22's check is no longer needed (C137-I item 3).
- **The Experience Map,** at its next pass: "Figma" in its intro becomes Framer, and Help and Settings come to it as
  surfaces with their designs.
- **Technology.** product/design-system.md's roles become its tokens. Call dials with no data; the Help page and its
  content live on the phone; the region is read from the phone's region setting and never leaves it; the theme's
  schedule and its fade, at once under Word Animation off or "Reduce motion"; the italic, with its fallback; the
  reflection's check (C137-I item 1); How the AI Appears §11. The handover to Technology still waits on the copy pass.
- **The project mirrors.** design-system.md is added; main-path.md, how-the-ai-appears.md, places-register.md,
  places-register.csv, product-and-design-principles.md and product-change-record.md are replaced by these versions.

---

## C11-P — The copy pass filed: every line in the Places Register; the Help page and the disclosure as places in parts; the founder's lists for Technology; main-path.md, How the AI Appears and the Design System in their next passes; C138-I to C140-I carried; the founder's rulings since C10-P; the hash C10-P could not state

**Filed 2026-11-05, by this machine.** *Drafted by the Copy Pass Filing worker chat from Head of Product & Design's brief (its message 1) and its messages 2, 3 and 4 to it [RELAYED, Head of Product & Design]. Head of Product & Design checked the draft before Ludvig filed; the filing script refused unless every file was written at the hashes it checked.*

**1. THE PLACES REGISTER, EVERY LINE FILED,** at product/places-register.md and product/places-register.csv (item 10).
Kit item 5, a Playbook; the version filed at C10-P is archived whole (item 9). Its lines come from the founder's copy
pass, copy-pass-final.csv, sha256 `20b841186622faa4c10ea6580f81fda4a7b170da5201b333817520b580f41790` [READ, the
Copy Pass Filing chat, 2026-11-05]: its working English and Swedish become each row's English and Swedish. Every line
is the founder's, written in each language independently; item 3 names every line Head of Product & Design corrected
at his request, and the two it proposed and withdrew.
- **New places.** MP·49, the feedback section's title; MP·50, the age dropdown's placeholder; MP·51, the late
  telling's tag (C138-I item 2); MP·52, the arc's tradition label naming its kind (C138-I item 3). AI·12 to AI·17, the
  reflection's closed-set where-and-when phrases (C140-I item 3), numbered as How the AI Appears adds them.
- **Two places in parts.** The Help page, W26, in parts W26·1 to W26·19: title, intro, three prompts, twelve region
  cards, two fallback cards. The disclosure, W27, in parts W27·1 to W27·17. The disclosure is one place, as C134-I
  item 7 rules, so its parts are not places of their own: the place carries one status for the whole text. W27·7 is
  merged into W27·6 and keeps its row; a part's number is never reused.
- **Not added again.** The copy pass's NEW·1 is MP·25 and its NEW·4 is MP·30: C10-P item 8 had already named both.
- **Retired.** MP·7 (founder-ruled 2026-11-03: its Help sentence lives in W27·16, X6 is met by W27·15, feedback by
  W27·9); MP·37 (C138-I item 3); W29 and W30, carried by W27·2 to W27·4. A retired row keeps no line; the archive
  keeps the old text.
- **Statuses.** Every row the copy pass wrote is "written", or "composed (stand-in written)". W16 and W18 are
  "composed, no stand-in". W12 and W13 stay blocked. EM·10 is paused (item 4). The Help page and the disclosure are
  "written, in its parts": each place's own row holds no words, and each part is written. W27·7 is "merged into
  W27·6".
- **How a line is written.** " ¶ " stays the register's mark for a paragraph break inside a line: a row is one
  line in the CSV and one bullet in this file, and a real line break would break both. A slot is in braces: {n},
  {tradition}, {region}, {pointed image}, {read image}. A place with several short lines separates them with " / ",
  and its flag says where each shows. Moved to fit these forms, with no word changed: "(wordmark)" out of MP·2;
  MP·34's "Dream 1, Dream 2 …" to "Dream {n}"; MP·40's region to {region}; the where-notes of MP·19, MP·27 and
  EM·11 to their flags; NEW·LATE's "#" and NEW·ARC's "Tradition" to {n} and {tradition}. Spaces at a line's ends
  are removed.
- **Flags.** Every flag that named copy-pass debt is cleared; every flag that names a lasting fact stays. EM·7's flag
  carries C139-I. MP·18's says the mirror's voice is made on the phone (Technology Message 4 item 10). W5's says its
  stand-in has no slot for the dreamer's word, which C128-I item 1 asks of it (item 12).
- **The counts** [READ, `bash product/check-places-register.sh --count`]:

    places 157
    screen Every Screen 2
    screen Onboarding 35
    screen Recording 13
    screen The Mirror 9
    screen The Opening 11
    screen The Readings & Close 32
    screen The Journal 11
    screen Help 23
    screen Settings 10
    screen Not on a screen yet 11
    status written 127
    status written, in its parts 2
    status merged into W27·6 1
    status retired 7
    status paused 3
    status composed (stand-in written) 10
    status blocked 2
    status no line: prohibition 1
    status composed, no stand-in 2
    status no line: by decision 2

**2. THE REGISTER'S CHECK, AMENDED** at product/check-places-register.sh (item 10). Every test it ran at C10-P runs
unchanged. It gains: MP·49 to MP·52, AI·12 to AI·17, W26·1 to W26·19 and W27·1 to W27·17 in its expected list; the
statuses "composed (stand-in written)", "composed, no stand-in", "written, in its parts" and "merged into" a part; a
length ending ", in parts" only on a place in parts; a place in parts holding no words of its own, its parts running 1
to n, each written or merged into a part that stands; a part only under a place in parts; the paragraph mark only as
" ¶ " inside a line; slots only in braces and only {n}, {tradition}, {region}, {pointed image} and {read image}; no
stray brace, "#" or "[founder copy" in a line; and WORDS TO WRITE as main-path.md now holds it (MP·49, MP·50, MP·51,
MP·52 with MP·37, AI·12 to AI·17, and the parts). Before filing, it printed nothing on these files, and caught each of
seven faults put into a copy on purpose: a paragraph mark out of form, an unknown slot, a stray brace, "#" in a line,
words on a place in parts, a part not written, a part merged into none [READ, the Copy Pass Filing chat, 2026-11-05].
The old check stays in the repository's history.

**3. HEAD OF PRODUCT & DESIGN'S CORRECTIONS, AT THE FOUNDER'S REQUEST** [RELAYED, Head of Product & Design].
- **In the copy pass**, each named in its changed_by_head column: MP·5, MP·10, MP·15, EM·3, W3, W4, AI·10, MP·21,
  MP·22, W24, W21, W22, W23, MP·27, AI·8, MP·44, W7, W14, W20, W27·1, W27·4, W27·5, W27·6, W27·10, W27·12, W27·13,
  W27·14. Twenty-seven rows [READ, the count of non-empty cells]: facts, "session" to "night", typos, and his own
  words reused.
- **Since:** W27·6's first sentence, both languages, so it says only the combined totals are kept (Technology Message
  4 item 6); W27·5's promise of a backup in Cohort 2 and a move to a new phone in Cohort 3 cut, both languages; the
  fallback's 112 card (W26·18), "the single emergency number in EU" to "the emergency number across Europe" and
  "EU's" to "EU:s"; W27·16, the founder's own MP·7 Help sentence, its Swedish first letter capitalised.
- **The founder's own words, appended:** MP·10's Swedish gains two sentences, each its own paragraph, naming the
  button as EM·1 reads.
- **Two lines proposed and withdrawn.** Head of Product & Design proposed a second sentence for W27·16 ("The app itself
  won't notice how you're doing.") and a line for W27·17, and the founder adopted them on 2026-11-03. Both were
  withdrawn: the Shared Core forbids model-drafted lines, adoption included, and the first also said the app does not
  notice, where the specification §1 says it detects and does nothing. The founder ruled on 2026-11-05: W27·16's second
  sentence is retired; W27·17 is his own words, "No one reads your dreams." and "Ingen läser dina drömmar."
  [RELAYED, Head of Product & Design, its message 4].

**4. THE FOUNDER'S DECISIONS SINCE C10-P,** one line each. Each ruled by the founder, Ludvig [RELAYED, Head of Product &
Design].
- Label text white on the terracotta, green and blue labels; the dark theme's Submit the light button with #333333 text;
  MP·20 above "The Readings" label (Head of Product & Design's message 3 to the Design Update chat).
- The arc has no section label: the last reading inside "The Readings", its label naming its kind beside its
  tradition; MP·37 retires (C138-I item 3).
- A dream added after the mirror keeps its mark wherever the night's dreams show (C138-I item 2).
- An unnamed journal row never shows an empty name slot or an invitation to name it (C138-I item 1).
- One click-through person, with invented dreams only; the Help check made with them untold, then in Cohorts 0 and 1
  (C139-I). Kit item 8's findings go to the next filing.
- Help: each region's cards in this order, a therapist, the suicide line, the emergency number, whether or not all three
  fit without scrolling; this departs from C138-I item 6's condition, which Interpretation's record keeps or replaces.
- Help regions: Sweden, the United Kingdom, Italy, Spain; any other region the fallback: 112 as Europe's emergency
  number, with Call in every region it serves, and findahelpline.com.
- One number per card: Sweden 1177, 90101, 112; the United Kingdom the NHS Talking Therapies finder (Read only),
  116 123, 999; Italy the local CSM (Read only), 02 2327 2327, 112; Spain the local centro de salud (Read only), 024,
  112. Call always dials, with or without data.
- Cards text only for Cohort 0: no logos, no images; images are decided before Cohort 1.
- Chat for Cohort 0 on Mind Självmordslinjen only; every other card Call and Read, or Read only.
- Every line is the founder's, in each language independently; Head of Product & Design's corrections are item 3's.
- W24 is "Add to Journal"; this replaces "This is mine now" (C134-I item 4) in Product's documents.
- W18, the series question, composed with no stand-in; if composing fails, it is silent that night.
- W16, the press, composed with no fixed line; failing twice, it does not show (C140-I item 5).
- The reflection composed freely, with the closed-set fallback; its six phrases are AI·12 to AI·17 (C140-I item 3).
- EM·10 paused: for Cohorts 0 and 1 the visible labels serve as screen-reader labels; a dreamer-or-app label before
  each bubble is written before the app opens wider. C127-I I12 is met only in part.
- The disclosure is its parts, written from Technology Message 4 and C140-I; the backup setting is designed for Cohort
  2, not now.
- The disclosure does not say that the app will not respond (the specification §2 item 1; ruled 2026-11-05), nor the
  bridge record (§2 item 2), nor that stopping is the tester's and costs nothing (§2 item 5), nor that there is no
  export. W27·16 names where Help is; W27·17 says no one reads the dreams.
- MP·7 retires; MP·10's Swedish gains two sentences; MP·11's "Record dream" and "Spela in" both stand; MP·25 is
  settled.
- The Technology lists: "so" and "så" dropped from TECH·4; "because", "therefore", "eftersom" and "därför"
  stay. Each list checks only the lines its section names; quotations are never checked.

**5. THE MAIN PATH, NEXT PASS,** at product/main-path.md (item 10). Kit item 4, a Playbook; the version filed at C10-P is
archived whole (item 9). It carries item 4's decisions and C138-I to C140-I: the arc inside "The Readings" and MP·20
above it; the late telling's tag; the unnamed row; one click-through person; the Help order, cards, numbers, actions and
fallback; the disclosure as its parts, with what it does not say; "Encrypted on the way and on your phone" now
allowed; "no export" gone from the disclosure's list; Add to Journal; the series question, the press and the
reflection as composed. Its founder's draft copy stays as drawn.

**6. HOW THE AI APPEARS, NEXT PASS,** at product/how-the-ai-appears.md (item 10). Kit item 6, a Playbook; the version
filed at C10-P is archived whole (item 9). It carries C138-I items 2 to 5, C139-I, C140-I items 3 and 5, the series
question with no stand-in, EM·10 paused (§2 and §8), Add to Journal, and AI·12 to AI·17 (§12).

**7. THE DESIGN SYSTEM, NEXT PASS,** at product/design-system.md (item 10). Kit item 7, a Playbook; the version filed at
C10-P is archived whole (item 9). White text on the terracotta, green and blue labels; the dark theme's Submit. Their
contrast [READ, the Copy Pass Filing chat's computation, 2026-11-05]: white on the terracotta 7.34:1 and 10.59:1, on
the green 6.61:1 and 12.51:1, on the blue 6.17:1 and 11.10:1; #333333 on the dark Submit 11.52:1 and 5.40:1.

**8. THE FOUNDER'S LISTS FOR TECHNOLOGY, FILED** at product/founder-lists-for-technology.md (item 10). Kit item 9, in
part; a Playbook. TECH·1 to TECH·5 from the copy pass, approved by the founder on 2026-11-03, each in English and
Swedish, matched as whole words or phrases, ignoring case, each checking only the lines its section names.

**9. FIVE FILES ARCHIVED WHOLE,** each in an archive note in the form C8-P's to C10-P's took. The new versions take
their paths.

| File | sha256 |
|---|---|
| Original, product/main-path.md, as filed at C10-P | `d31d7ed017a336b0557f8d905d5d7223919752684612c74b8dddcac045b757aa` |
| Archived, archive/main-path-superseded-2026-11-05.md, note included | `f510ebf6bea4c44560a621a3afb0bc6192431ac0513a788f2ef2cd14dcf793e5` |
| Original, product/how-the-ai-appears.md, as filed at C10-P | `4e615060aabda2b204c5de2cfe7153422df556a163a4713db8bb9c8d78bb69b4` |
| Archived, archive/how-the-ai-appears-superseded-2026-11-05.md, note included | `a754c5280fa1ca6a6c5d2b1677199be1aed66a07e743c45945bacac7515563fe` |
| Original, product/design-system.md, as filed at C10-P | `66d0010b128702799959b6c04786120a42348d5bd49b16d271e9c7de4a705bdf` |
| Archived, archive/design-system-superseded-2026-11-05.md, note included | `0c6f6ad8f2829b499d911a1cf6ddc063d10b612f50552084c9e52248b1e87d25` |
| Original, product/places-register.md, as filed at C10-P | `c0c8eb239682daf6e37b2147832b1a24c64b48ba5b0a07828bd88a0405272d5c` |
| Archived, archive/places-register-superseded-2026-11-05.md, note included | `e6c6d83bbecca16c9fdb8311479e768aa3c7b8e49aaa15d43fb7cb3c77425088` |
| Original, product/places-register.csv, as filed at C10-P | `b3a2c26feacb24a11a6464c0c37e52d4addd7d58481e199075bbd838f0112ad4` |
| Archived, archive/places-register-superseded-2026-11-05.csv, note included | `462beb01e0b0317ee8c84625223d51a9d444c40e153bc0dea473b2c612e5c772` |

Each of these prints its original's hash, and printed it at filing [READ, by the filing script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/main-path-superseded-2026-11-05.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/how-the-ai-appears-superseded-2026-11-05.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/design-system-superseded-2026-11-05.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-05.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-05.csv | shasum -a 256

**10. THE FILES NOW.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/places-register.md | `99f06d72c8ca6aa83b48cac351417247a5e68ecd08838e15195dce9e2baf2f24` |
| product/places-register.csv | `ddae0531eafa0b1821c4930acf0706fcd2d0982c24014375e7fded2a1943add5` |
| product/check-places-register.sh | `f729e664ebaa48960f9fe1e3fa4f144f7b13ae65cc08ac9729e6fb5a9aa9c1b5` |
| product/main-path.md | `0904d30d8a6815c621c9f88f433d1247ba5e6af1e5c421185a220639b928af45` |
| product/how-the-ai-appears.md | `da04f6b40631e092e55dd772d37590908bbb395aa5b8d503e26fdd898cb701f4` |
| product/design-system.md | `3f4a0dcd58f1d52e9e683c4d5af373c137304cd5fe72b71b9a23f6af2f770974` |
| product/founder-lists-for-technology.md | `798a750c227e9486a266d80bdf2f33d5b3b50234fb3d9256a47708d1ccac9182` |

The check was `0817f630e35fd417e332ff17d844dd3bb8a2d9d39f4b57c7124fab63a48e3aac`.

**11. THE HASH C10-P COULD NOT STATE.** At fcaa808 this record was
`2151ddea72eafb83be2c3b3909d8909c6b217cd015f085eb60de39d782ad2b3a` [READ, by the filing script: the file at that commit hashes so, and fcaa808 is the commit that last
changed it before this one]. This record still cannot state its own
current hash; the filing script prints it, and the next Product filing records it.

**12. FOUND AND NOT DECIDED HERE.**
- **The disclosure without §2 item 1.** The specification calls the app's not responding the single fact the
  disclosure exists to convey. The founder ruled it unsaid; Interpretation is told in those words.
- **W27·17,** "No one reads your dreams." It stands near the phrase W27's never forbids, "no one else can read it", and
  is true of people only: the readings and the transcription are machines (W27·3, W27·4), and feedback a tester writes
  is read by the founders (W27·9). Its row's flag says so.
- **W24's never** (Requirements List §7 W24) says it must not read as save, submit or finish. "Add to Journal" may
  read as save. Interpretation is told.
- **W5's stand-in** has no slot for the dreamer's word for the image, which C128-I item 1 asks of it.
- **Lines for the founder's hand, unchanged here:** MP·32's Swedish "Klick"; MP·46's Swedish "läses av från";
  C4-P·8's Swedish "platform"; W27·16's Swedish "Hjälp knapp"; MP·5's English "-Ludvig , Founder".
- **check-principles.sh on main-path.md** finds the same three words as on the version filed at C10-P, each in its old
  place: "wave" (waveform), "anonymous" (in the list of what the disclosure must not say), "unfinished" (the rules that
  nothing treats a night as unfinished). It is not run there, as no earlier filing ran it there.

**13. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the new paths absent, and these files at these
hashes.

| File | sha256 |
|---|---|
| product/product-change-record.md, before this block | `2151ddea72eafb83be2c3b3909d8909c6b217cd015f085eb60de39d782ad2b3a` |
| product/main-path.md, before this filing | `d31d7ed017a336b0557f8d905d5d7223919752684612c74b8dddcac045b757aa` |
| product/how-the-ai-appears.md, before this filing | `4e615060aabda2b204c5de2cfe7153422df556a163a4713db8bb9c8d78bb69b4` |
| product/design-system.md, before this filing | `66d0010b128702799959b6c04786120a42348d5bd49b16d271e9c7de4a705bdf` |
| product/places-register.md, before this filing | `c0c8eb239682daf6e37b2147832b1a24c64b48ba5b0a07828bd88a0405272d5c` |
| product/places-register.csv, before this filing | `b3a2c26feacb24a11a6464c0c37e52d4addd7d58481e199075bbd838f0112ad4` |
| product/check-places-register.sh, before this filing | `0817f630e35fd417e332ff17d844dd3bb8a2d9d39f4b57c7124fab63a48e3aac` |
| product/product-and-design-principles.md | `98166005088bd6bbfadf4796a5dda7f90553a88d5ec400e43ab37cd77e0b7028` |
| product/experience-map.md | `43434fd1ebce8c886ea1de3a4f38b5c58ca96cf399c63711b559ec6355090be2` |
| product/experience-map-cards.csv | `f3be5ae3b97620045b2b743687c9db9719903ffe983b75ad7f12fbd9c87cc0b8` |
| product/check-principles.sh | `368d92df1a5517217f1c8dec55efa0d129057af94b437d9ddb3cc198f891cadd` |
| product/check-experience-map.sh | `a0116945b8a34e62b6d8a06120d3d1f410aa480a6ce7cbea2b2a9e0ff05aa6f1` |
| interpretation/change-record.md, through C140-I | `2247f32717f44ee31d8be5ce4ca01f85c5562702de7011ec85ad6fe9b1e5a056` |
| interpretation/requirements-list.md | `22f742c740ab640352883a45af4ecf9708c16d7c07df57d329bedde6c51e64c5` |
| interpretation/the-foundations-draft-2.md | `cc32ecb430890e564fb29d6c633b8ef39501de32c7cbb57612282afc58be91fa` |
| interpretation/tester-disclosure-specification.md | `f28b64e16cc8b4df3598d6dd86447645eceba2a48b2594682fc4f0bfb6981ff3` |
| technology/technology-change-record.md, through C3-T | `6a10dfd38bf1bede6307a396691a9685f4482d5bff01ae91aeb0367e45de4971` |
| organisation/core-commitments.md | `3f1e8e5cda370ac9e7eb6d0f63cb947d2f437440bc4857dfc68c3c1fa3562ba8` |

Interpretation's record was read through C140-I, its last block, for this filing; the script refused unless it still
held exactly that. Product's check (C1-P item 1, C3-P item 3), the heading check (C3-P item 4), the map's check, the
register's own check as amended here, and product/check-principles.sh on the Principles, on How the AI Appears, on the
Design System and on the founder's lists for Technology, all printed nothing.

**WHAT DEPENDED ON THIS.**

- **Interpretation.** A message of notices, which Head of Product & Design numbers and sends after this filing: W24's
  words, and its never; W18 with no stand-in; EM·10 paused, C127-I I12 met only in part; the Help order without C138-I
  item 6's condition; one number per card, text-only cards, Chat on one card; the fallback page; the disclosure's three
  departures from the specification (§2 items 1, 2 and 5); MP·7 retired, X6 met by W27·15, Help named by W27·16; and a
  question: Technology's design narrows C63-I items 3 and 4 and the specification §1 and §2 item 2, since a night only
  recorded is never classified and no reviewer reads a single night's firing. W27·6 stands as written until
  Interpretation rules. The specification's next draft, which is Interpretation's. The Requirements List's Draft 2
  (W18, W24, X1, W26).
- **Technology.** A message, which Head of Product & Design numbers and sends after this filing: the lists file; the
  register's lines and their forms (¶, slots, " / "); the same narrowing as above, which may change the build and
  W27·6 with it; W27·4 checked again if Soniox changes; the Help page's numbers and actions, and Call on the fallback's
  112 in every region; the reflection's closed-set form; the press's failure recorded; the series question silent on
  failure; the late telling's tag carried through the night's display; the label text and the dark Submit as tokens;
  EM·10 paused. The handover to Technology (kit item 9) is not complete with this.
- **Organisation and counsel.** The disclosure names the founder as personally responsible while no company exists
  (W27·13); consent and any formal risk assessment are with Organisation and counsel before Cohort 1 (Technology
  Message 4 item 3). The Help cards are text only for Cohort 0; images, when decided, go to Organisation as a notice.
- **The founder.** W5's stand-in; item 12's lines. Kit item 8 in the project instructions, which still says three people: the founder
  edits it. The one click-through person's findings, to the next filing.
- **The Experience Map,** at its next pass: the Help and disclosure surfaces as they now stand.
- **The project mirrors.** founder-lists-for-technology.md is added; main-path.md, how-the-ai-appears.md,
  design-system.md, places-register.md, places-register.csv and product-change-record.md are replaced by these
  versions.

---

## C12-P — The Handover to Technology filed at product/technology-handover.md; the click-through; C141-I carried; six corrections and five flags in the Places Register; the register as filed at C11-P archived; the hash C11-P could not state

**Filed 2026-11-05, by this machine.** *Drafted by Head of Product & Design in its standing chat, at the founder's request that no worker chat be opened for it [RELAYED, the founder, 2026-11-05]. The filing script refused unless every file was written at the hashes Head of Product & Design checked, and every check printed nothing on a test copy of the repository built from the project mirrors at C11-P.*

**1. THE HANDOVER TO TECHNOLOGY, FILED** at product/technology-handover.md, sha256 `0fd61ee0c0450ff7e808db8e2941b7f522fe097f29aaff0702780faeeafe6b71` [READ, by the
filing script]. Kit item 9, a Playbook. It decides nothing: it says what to build, screen by screen, and points at the
filed document that holds each rule; where it and that document differ, that document governs. It names what can be
built now (C141-I's note for Technology), what the disclosure depends on in the build, what the app never has, and
what is still open.

**2. THE CLICK-THROUGH, RUN** (kit item 8; C139-I). One person who is not a beta tester, with invented dreams only. The
founder reports it went well, and that the person, asked untold where they would go for support, found Help and read
it as support, not as the app's instructions [RELAYED, the founder, 2026-11-05]. C131-I item 5's check, as C139-I
amended it, is met for the click-through; it holds on in Cohorts 0 and 1. No finding changes a design.

**3. C141-I CARRIED** [READ, interpretation/change-record.md through C141-I].
- Help's order stands, and C138-I item 6's condition is withdrawn (item 4). Each card says truly what it reaches: the
  1177 card already says healthcare advice, and the NHS card England only.
- "Add to Journal" stands; a night never added is still kept, and nothing may suggest otherwise (item 5). W21's third
  state was read against this by the founder and stands [RELAYED, the founder, 2026-11-05].
- W18 with no stand-in stands (item 6).
- EM·10 is paused for Cohort 0; if any Cohort 1 tester uses a screen reader, the dreamer-or-app label is written
  before they begin (item 7). EM·10's status and flag now say so.
- Nothing about distress in onboarding (item 8, founder-ruled). W27·6 now shows in two forms, with no new words: in
  onboarding its first sentence only; on the disclosure and privacy page (MP·48) whole, so that the distress signals
  run and that nothing about them affects the app or the tester's experience are always said together. The founder
  ruled this split on 2026-11-05 [RELAYED, the founder]. W27·6's and MP·48's flags say so.
- Technology's distress check stands as designed (item 9). W27·6's flag now says Interpretation ruled.
- No install ID in Cohorts 0 and 1; a press failure kept in the night's record on the phone; four redrafts, not three
  (items 1 to 3). The handover carries them.

**4. THE PLACES REGISTER,** at product/places-register.md and .csv (item 6). Six corrections Head of Product & Design
made at the founder's request on 2026-11-05 [RELAYED, the founder], each of a slip C11-P item 12 named:
- MP·5, English: "-Ludvig , Founder" to "-Ludvig, Founder".
- MP·32, Swedish: "Klick spela in" to "Klicka på spela in", and a closing full stop, as MP·10's Swedish reads.
- MP·46, Swedish: "läses av från vårt team" to "läses av vårt team".
- C4-P·8, Swedish: "platform" to "plattform", twice.
- W27·16, Swedish: "Hjälp knapp" to "Hjälp-knapp".
- W5, both languages: the founder's stand-in gains the slot for the dreamer's word, "this image, {pointed image},",
  as C128-I item 1 asks; no word is changed.
Flags and one status: EM·7 (the click-through, item 2); W5 (the slot); W27·6 and MP·48 (the two forms, item 3);
EM·10 (item 3). Thirteen cells changed, nothing else [READ, Head of Product & Design's count, 2026-11-05].
The counts [READ, `bash product/check-places-register.sh --count`]:

    places 157
    screen Every Screen 2
    screen Onboarding 35
    screen Recording 13
    screen The Mirror 9
    screen The Opening 11
    screen The Readings & Close 32
    screen The Journal 11
    screen Help 23
    screen Settings 10
    screen Not on a screen yet 11
    status written 127
    status written, in its parts 2
    status merged into W27·6 1
    status retired 7
    status paused 3
    status composed (stand-in written) 10
    status blocked 2
    status no line: prohibition 1
    status composed, no stand-in 2
    status no line: by decision 2

**5. THE REGISTER AS FILED AT C11-P, ARCHIVED WHOLE,** each file in an archive note in the form C8-P's to C11-P's took.
The new register takes their paths.

| File | sha256 |
|---|---|
| Original, product/places-register.md | `99f06d72c8ca6aa83b48cac351417247a5e68ecd08838e15195dce9e2baf2f24` |
| Archived, archive/places-register-superseded-2026-11-05-at-C12-P.md, note included | `3275651a8488e4fe56b8f4ba8927e5fcd63acd0cfd9093d8489b943c8d0f66d7` |
| Original, product/places-register.csv | `ddae0531eafa0b1821c4930acf0706fcd2d0982c24014375e7fded2a1943add5` |
| Archived, archive/places-register-superseded-2026-11-05-at-C12-P.csv, note included | `03815c6bb47a0e4f0920c4f594b024cace0df3b6ccb58212063f550daca7db2e` |

Each of these prints its original's hash, and printed it at filing [READ, by the filing script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-05-at-C12-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-05-at-C12-P.csv | shasum -a 256

**6. THE FILES NOW.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/technology-handover.md | `0fd61ee0c0450ff7e808db8e2941b7f522fe097f29aaff0702780faeeafe6b71` |
| product/places-register.md | `fd94a47564f8fb4fb6741d740d921e48dcc87e733a51569af361fde8a52af1fb` |
| product/places-register.csv | `6a5d7e1e0042d2034af8ec1148a1c6ab12e17de0f3a63d26bc05cc2489ae68c7` |

The register's check is unchanged, at `f729e664ebaa48960f9fe1e3fa4f144f7b13ae65cc08ac9729e6fb5a9aa9c1b5`.

**7. THE HASH C11-P COULD NOT STATE.** At 9840ed0 this record was `eb293bc95f12e17820d34099b72eeae697a0e74d2e7ce38d9bdbe02a5300e529` [READ, by the filing script: the
file at that commit hashes so, and 9840ed0 is the commit that last changed it before this one]. This record still
cannot state its own current hash; the filing script prints it, and the next Product filing records it.

**8. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the new paths absent, Interpretation's record
through C141-I at `c14c00a87038e86dea05519f93b683216b72db4dc83ff5236705e0e6a2ecfec2`, and every Product file at its
C11-P hash. Product's check (C1-P item 1, at the path C3-P item 3 gives), the heading check (C3-P item 4), the map's
check, the register's check, and product/check-principles.sh on the Principles, How the AI Appears, the Design System,
the founder's lists and the handover all printed nothing.

**WHAT DEPENDED ON THIS.**

- **Technology.** The handover, with the register at this filing. Head of Product & Design sends it after the push,
  numbered, with the files it names. W27·6's two forms change what the build shows in onboarding and on the privacy
  page.
- **Interpretation.** A notice: the click-through's result for C131-I item 5 as C139-I amended it; W27·6's two forms,
  where "nothing that affects the app or your experience" is the founder's words for "nothing responds to them"
  (C141-I item 8), which Interpretation may ask to be plainer; the handover filed.
- **product/main-path.md,** at its next pass: W27·6's two forms in Onboarding and Settings; the click-through run.
- **The founder.** C4-P·3, how to use the app, now due: whether it is needed. main-path.md's Onboarding OPEN, the
  language switch. Kit item 8 in the project instructions, which still says three people.
- **The project mirrors.** technology-handover.md is added; places-register.md, places-register.csv and
  product-change-record.md are replaced by these versions.

---

## C13-P — The Handover to Technology's next version; the founder's lists as C142-I approved them; four new places and three rows in the Places Register, and its check taught them; the founder's rulings of 2026-11-05; the handover and the register as filed at C12-P archived; the hash C12-P could not state

**Filed 2026-11-06, by this machine.** *Drafted by Head of Product & Design in its standing chat, at the founder's request [RELAYED, the founder, 2026-11-05]. The filing script refused unless every file was written at the hashes Head of Product & Design checked, and every check printed nothing on a test copy of the repository built from the project mirrors at C12-P.*

**1. THE HANDOVER TO TECHNOLOGY, NEXT VERSION,** at product/technology-handover.md, sha256 `77ea3b17cd087a8a84c6d2c18482fb6e6b434ee4e502ad9416106bd509955db1` [READ, by
the filing script]. Kit item 9, a Playbook; the version filed at C12-P is archived whole (item 6). It carries:
- Interpretation's three corrections [RELAYED, Head of Interpretation, its answer to Product's message 20,
  2026-11-05]: what governs the practice, with the Requirements List as its index (C119-I); the rule against any
  per-person trend, score or measure, in the law document's words (C140-I item 9); the mirror's read-back as the
  dreamer's own words as told, and Interpret Now from "what stood out" (C128-I item 5; C130-I item 2; C132-I item 2).
- Technology's five additions [RELAYED, Technology Message 5, 2026-11-05]: what the dreamer sees when the technology
  fails; the app's face; TestFlight's texts; the founder's own export; Call as one confirming tap.
- The Waking Life heading (item 3).
- C142-I item 3: the founder's own export may be built, for his Cohort 0 build only, and is read only in
  Interpretation's study chat.

**2. THE PLACES REGISTER,** at product/places-register.md and .csv (item 7).
- **Four new places.** MP·53, the waking-life heading, "Waking Life" / "Det vakna livet", written. MP·54, the
  transcription failure line, written. MP·55, the app's name under its icon, "SoulDreams" in both languages, written.
  MP·56, the TestFlight beta description, to write before Cohort 1.
- **Three rows.** W17's flag: its heading returns as MP·53. EM·8's flag: also shown when a reading cannot complete or
  the beta's spending limit is reached. W27·6's must: "until the review" to "until the end of the cohort", as its line
  already says ("until then"); the line is unchanged.
- **The check,** product/check-places-register.sh, taught MP·53 to MP·56, and nothing else: it was
  `f729e664ebaa48960f9fe1e3fa4f144f7b13ae65cc08ac9729e6fb5a9aa9c1b5` and is `707d1dbf3c5ff181fff4f826ad7ca90ffe2cd6e2bf04cdec13bfd06ad7ab42bf`. Run on the new register
  without its amendment, it names exactly the four new places [READ, Head of Product & Design's test, 2026-11-05].
- **The counts** [READ, `bash product/check-places-register.sh --count`]:

    places 161
    screen Every Screen 2
    screen Onboarding 35
    screen Recording 14
    screen The Mirror 9
    screen The Opening 11
    screen The Readings & Close 33
    screen The Journal 11
    screen Help 23
    screen Settings 10
    screen Not on a screen yet 13
    status written 130
    status written, in its parts 2
    status merged into W27·6 1
    status retired 7
    status paused 3
    status composed (stand-in written) 10
    status blocked 2
    status no line: prohibition 1
    status composed, no stand-in 2
    status no line: by decision 2
    status to write 1

**3. THE FOUNDER'S RULINGS OF 2026-11-05,** each ruled by the founder, Ludvig [RELAYED, Head of Product & Design].
- When transcription fails, the recording stays on the phone and is sent again, and MP·54 shows. MP·54 is the
  founder's line, adapted from Head of Product & Design's description of its job; its Swedish is his own.
- When a reading cannot complete, or the beta's spending limit is reached, the night stays as recorded and can be
  read later, and EM·8 shows. No new words.
- The app's face: the name under the icon "SoulDreams" in both languages; the icon the founder's moon; the launch
  screen the page colour with the moon.
- TestFlight: the beta description is founder copy, written before Cohort 1. The feedback email is set by the founder
  and is not recorded here.
- The founder's own export: a button in each night's ⋯ menu, in his own Cohort 0 build only, to the restricted folder;
  no export in any tester build. There is no limit on who may read his own exported nights, Claude chats included; he
  proposes a study chat inside Interpretation, reporting to its head. Interpretation is asked in Product's message 21;
  nothing is built for the export until it answers.
- The Waking Life heading returns: "Waking Life" / "Det vakna livet", one fixed founder line over W17. C133-I item 3,
  which retired it, is withdrawn; Interpretation records it at Lens Practice Draft 11's filing [RELAYED, Head of
  Interpretation, 2026-11-05].

**4. FROM INTERPRETATION'S ANSWER TO MESSAGE 20** [RELAYED, Head of Interpretation, 2026-11-05]. The click-through meets
C131-I item 5's check as C139-I amended it. W27·6's full form meets C141-I item 8.

**5. FROM TECHNOLOGY MESSAGE 5** [RELAYED, 2026-11-05]. The handover is read whole and built from. TECH·4 and TECH·5
went to Interpretation for confirmation (C3-T 2i), in Product's message 21, and are confirmed at C142-I (item 6 here). A recording made offline can take longer to
appear than a live one; MP·15 promises no speed, and stands.

**6. THE FOUNDER'S LISTS FOR TECHNOLOGY, NEXT VERSION,** at product/founder-lists-for-technology.md, sha256
`4326cfcc5cb804344eb456a65ab56cbc4d8ccd2aa175214aff9253ee25d92500` [READ, by the filing script], carrying C142-I [READ, interpretation/change-record.md through C142-I]:
TECH·3, TECH·4 and TECH·5 approved by Head of Interpretation by the founder's delegation, now and as they grow (item
0); TECH·3 now also checks the reflection's own words, except the time words that place it in the night (item 1a);
TECH·4 gains fourteen English and seventeen Swedish entries (items 1b and 1c); TECH·5 gains eleven English and ten
Swedish entries (item 2); every list is a floor. TECH·1 and TECH·2 stay the founder's, unchanged.

**7. FOUR FILES ARCHIVED WHOLE,** each in an archive note in the form C8-P's to C12-P's took. The new
versions take their paths.

| File | sha256 |
|---|---|
| Original, product/technology-handover.md | `0fd61ee0c0450ff7e808db8e2941b7f522fe097f29aaff0702780faeeafe6b71` |
| Archived, archive/technology-handover-superseded-2026-11-06-at-C13-P.md, note included | `4cefadf1ec40a4a76dba20e820af1aece79b1b79f1b021f3db60456fda00597e` |
| Original, product/places-register.md | `fd94a47564f8fb4fb6741d740d921e48dcc87e733a51569af361fde8a52af1fb` |
| Archived, archive/places-register-superseded-2026-11-06-at-C13-P.md, note included | `2c97421d09a6a25e40993f7c505fb340b86e05b65b39a3e6f9b27468ef90245f` |
| Original, product/places-register.csv | `6a5d7e1e0042d2034af8ec1148a1c6ab12e17de0f3a63d26bc05cc2489ae68c7` |
| Archived, archive/places-register-superseded-2026-11-06-at-C13-P.csv, note included | `2301c4f9392defdf49baa8d0274a7d57b022e2b94ea41bbceebb8302af0047cb` |
| Original, product/founder-lists-for-technology.md | `798a750c227e9486a266d80bdf2f33d5b3b50234fb3d9256a47708d1ccac9182` |
| Archived, archive/founder-lists-for-technology-superseded-2026-11-06-at-C13-P.md, note included | `ea8fc46b2f238edd32f48c811aef4f7db29d648f1cc0996f9e171877a675fd4a` |

Each of these prints its original's hash, and printed it at filing [READ, by the filing script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/technology-handover-superseded-2026-11-06-at-C13-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-06-at-C13-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-06-at-C13-P.csv | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/founder-lists-for-technology-superseded-2026-11-06-at-C13-P.md | shasum -a 256

**8. THE FILES NOW.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/technology-handover.md | `77ea3b17cd087a8a84c6d2c18482fb6e6b434ee4e502ad9416106bd509955db1` |
| product/places-register.md | `114944e66154213e64a536fe29a8cbbf9b3c70d8314c64bd61df7af39119d0c5` |
| product/places-register.csv | `b2345711468f52d90f9d8f315b589dba19ae13a5b239511b0cbb2b8b9c30ea4f` |
| product/check-places-register.sh | `707d1dbf3c5ff181fff4f826ad7ca90ffe2cd6e2bf04cdec13bfd06ad7ab42bf` |
| product/founder-lists-for-technology.md | `4326cfcc5cb804344eb456a65ab56cbc4d8ccd2aa175214aff9253ee25d92500` |

**9. THE HASH C12-P COULD NOT STATE.** At fe285fe this record was `d62b5b86fb392ff322ae4fe1b8f5f729fe00330f74eb4e227d46b4808fce379d` [READ, by the filing script: the
file at that commit hashes so, and fe285fe is the commit that last changed it before this one]. This record still
cannot state its own current hash; the filing script prints it, and the next Product filing records it.

**10. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the new paths absent, Interpretation's record
through C142-I at `ddc8f78d96d6cbdf50e812126c2a30636cda22d8ae0af5c20dd176e02084f792`, and every Product file at its
C12-P hash. Product's check, the heading check, the map's check, the register's check as amended, and
product/check-principles.sh on the Principles, How the AI Appears, the Design System, the founder's lists and the
handover all printed nothing.

**WHAT DEPENDED ON THIS.**

- **Technology.** One message from Head of Product & Design after the push, replacing Product Message 6, which was not
  sent: the handover's next version, the register and the lists at this filing; the failure behaviours (MP·54, EM·8),
  the app's face (MP·55), the Waking Life heading (MP·53), Call as one confirming tap, the lists' new scope and
  words, and the founder's export, which may now be built for his Cohort 0 build only.
- **Interpretation.** Nothing is asked. Its entry for the Waking Life heading comes at Lens Practice Draft 11's
  filing; the study chat opens when Cohort 0 has nights to export (C142-I item 3).
- **product/main-path.md,** at its next pass: the Waking Life heading; the failure lines; W27·6's two forms; the
  founder's export in his own build; the click-through run.
- **The founder.** MP·56, the TestFlight description, before Cohort 1; the icon and launch screen files; the restricted
  folder for the export, outside every folder a Claude Code session is opened in, and never pushed.
- **The project mirrors.** technology-handover.md, places-register.md, places-register.csv,
  founder-lists-for-technology.md and product-change-record.md are replaced by these versions.

---

## C14-P — The disclosure in two layers; five founder lines and three new places; how to use the app retired; no language switch; the handover's next version; the handover and the register as filed at C13-P archived; the hash C13-P could not state

**Filed 2026-11-06, by this machine.** *Drafted by Head of Product & Design in its standing chat, at the founder's request [RELAYED, the founder, 2026-11-06]. The filing script refused unless every file was written at the hashes Head of Product & Design checked, and every check printed nothing on a test copy of the repository built from the project mirrors at C13-P.*

**1. THE DISCLOSURE IN TWO LAYERS** (founder-ruled 2026-11-06; allowed by Interpretation's answer to Product's message
22, which Interpretation records with The Opening Draft 8's filing [RELAYED, Head of Interpretation, 2026-11-06]).
Onboarding shows the first layer: W27·1, W27·2, W27·5 and W27·13 to W27·17, then MP·57, MP·58 and MP·59. MP·58 opens
the full disclosure, the disclosure and privacy page (MP·48), before the consent (MP·8), and MP·59 says the consent
covers it. W27·3, W27·4, W27·6, W27·8, W27·9, W27·10, W27·11 and W27·12 show only on that page; W27·10 and W27·11
also stand in the TestFlight description (MP·56). Each part's flag says where it shows. Counsel confirms the layered
form before Cohort 1.
Interpretation's three conditions, and how they are met:
- the link opens the full text before the consent, and the consent says it covers the whole text: MP·58 and MP·59.
  MP·59 says "these terms"; its flag records that this is the founder's words for the whole disclosure;
- the first layer says a night's words go to an outside AI service: W27·2 gains the founder's sentence;
- W27·10 says plainly that feedback sent through TestFlight shows who sent it: W27·10, corrected.

**2. THE FOUNDER'S LINES** [RELAYED, the founder, 2026-11-06].
- W27·2 gains: "They go to an AI service within the EU, which keeps nothing." / "Dom går även till en AI-tjänst inom
  EU, där de sedan raderas." Three small fixes the founder accepted from Head of Product & Design: "a AI" to "an
  AI", "who keep" to "which keeps", and in Swedish "som sedan raderas" to "där de sedan raderas", with "AI-tjänst".
- MP·57: "If you want to read the full details, click on Read everything." / "Om du vill läsa de exakta detaljerna,
  klicka på Läs allt." MP·58: "Read everything" / "Läs allt".
- MP·59: "By clicking I agree, you agree to these terms." / "Genom att klicka på Jag samtycker så godkänner du dessa
  användarvillkor." The comma moved and "användarvillkoren" to "användarvillkor", at his request.
- W27·10: Head of Product & Design corrected the facts in the founder's own line, in both languages, at his request:
  Apple keeps crash logs and usage until the bugs are fixed, and feedback for one year (Technology's Build worker,
  from Apple's terms [RELAYED]); feedback sent through TestFlight shows who sent it, and reaches the founder's personal
  email (Technology Message 6 item 2). His first two sentences are unchanged.

**3. TWO FOUNDER RULINGS OF 2026-11-06** [RELAYED, the founder].
- C4-P·3, how to use the app, is retired: no instructions screen.
- No language switch on the first screen: the app follows the phone's language, and Settings changes it. This settles
  main-path.md's Onboarding OPEN, which its next pass records.

**4. THE PLACES REGISTER,** at product/places-register.md and .csv (item 7). Three new places, MP·57 to MP·59; W27·2
and W27·10 rewritten; C4-P·3 retired; the layer on every part's flag, and on W27's, W27·6's, MP·48's and MP·56's. The
check, product/check-places-register.sh, is taught MP·57 to MP·59 and nothing else: it was
`707d1dbf3c5ff181fff4f826ad7ca90ffe2cd6e2bf04cdec13bfd06ad7ab42bf` and is `c7a29abea4e27087e009ff7481aec46284fff46005ddc23b2dc88a4abcb0c839`.
The counts [READ, `bash product/check-places-register.sh --count`]:

    places 164
    screen Every Screen 2
    screen Onboarding 38
    screen Recording 14
    screen The Mirror 9
    screen The Opening 11
    screen The Readings & Close 33
    screen The Journal 11
    screen Help 23
    screen Settings 10
    screen Not on a screen yet 13
    status written 133
    status written, in its parts 2
    status merged into W27·6 1
    status retired 8
    status paused 2
    status composed (stand-in written) 10
    status blocked 2
    status no line: prohibition 1
    status composed, no stand-in 2
    status no line: by decision 2
    status to write 1

**5. THE HANDOVER TO TECHNOLOGY, NEXT VERSION,** at product/technology-handover.md, sha256 `c263f865717165c1191c0b949227dc15138893e5dcf059e5fe9e348f91b6e353`: onboarding's
two layers, the two rulings, MP·56 carrying W27·10 and W27·11, and §11 without the two settled items.

**6. THREE FILES ARCHIVED WHOLE,** each in an archive note in the form C8-P's to C13-P's took.

| File | sha256 |
|---|---|
| Original, product/technology-handover.md | `77ea3b17cd087a8a84c6d2c18482fb6e6b434ee4e502ad9416106bd509955db1` |
| Archived, archive/technology-handover-superseded-2026-11-06-at-C14-P.md, note included | `12f6f83888f53ee367a6cfa81f50840ac98f905432f34a2667f03c8ffce53b26` |
| Original, product/places-register.md | `114944e66154213e64a536fe29a8cbbf9b3c70d8314c64bd61df7af39119d0c5` |
| Archived, archive/places-register-superseded-2026-11-06-at-C14-P.md, note included | `5e4dceea97eb2483e7629cb7dae2834f4a5742e9052696d688f8cf40b78743e4` |
| Original, product/places-register.csv | `b2345711468f52d90f9d8f315b589dba19ae13a5b239511b0cbb2b8b9c30ea4f` |
| Archived, archive/places-register-superseded-2026-11-06-at-C14-P.csv, note included | `85fe4e02ad6609a92ae88c1b842c6babceb0feda743b542a59520790ed221ab5` |

Each of these prints its original's hash, and printed it at filing [READ, by the filing script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/technology-handover-superseded-2026-11-06-at-C14-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-06-at-C14-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-06-at-C14-P.csv | shasum -a 256

**7. THE FILES NOW.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/technology-handover.md | `c263f865717165c1191c0b949227dc15138893e5dcf059e5fe9e348f91b6e353` |
| product/places-register.md | `155f65088f0995ae0b140f0a2d6ac5c7e9a491bfa79519053a6b3eebd8c2fb97` |
| product/places-register.csv | `b3b34988591f66362f01c90080bc7b89f2a6b05d8b0688bb8552360c5ea3a0ad` |
| product/check-places-register.sh | `c7a29abea4e27087e009ff7481aec46284fff46005ddc23b2dc88a4abcb0c839` |

**8. THE HASH C13-P COULD NOT STATE.** At 36f7f46 this record was `d7421a0a7d1d1abb28eaa4a143772cee4cd500135216de89331cae11d5ec765c` [READ, by the filing script: the
file at that commit hashes so, and 36f7f46 is the commit that last changed it before this one]. This record still
cannot state its own current hash; the filing script prints it, and the next Product filing records it.

**9. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the new paths absent, Interpretation's record
through C142-I at `ddc8f78d96d6cbdf50e812126c2a30636cda22d8ae0af5c20dd176e02084f792`, and every Product file at its
C13-P hash. Product's check, the heading check, the map's check, the register's check as amended, and
product/check-principles.sh on the Principles, How the AI Appears, the Design System, the founder's lists and the
handover all printed nothing.

**WHAT DEPENDED ON THIS.**

- **Technology.** One message from Head of Product & Design after the push, replacing Product Message 8, which was not
  sent: the two layers, which parts show where, MP·57 to MP·59, W27·2 and W27·10, the two rulings.
- **Interpretation.** Its entry for the layered disclosure, with The Opening Draft 8's filing. MP·59's "these terms"
  is the founder's words for the whole text; if Interpretation reads it otherwise, it says so.
- **Organisation and counsel.** The layered form, before Cohort 1.
- **product/main-path.md,** at its next pass: the two layers in Onboarding and Settings; Onboarding's OPEN settled;
  C4-P·3 retired; with the items C12-P and C13-P named.
- **The founder.** MP·56, the TestFlight description, which now carries W27·10 and W27·11, before Cohort 1.
- **The project mirrors.** technology-handover.md, places-register.md, places-register.csv and product-change-record.md
  are replaced by these versions.

---

## C15-P — Cohesion through Cohort 2: no Help page, no Help icon and nothing about distress, carried into every Product document; main-path.md's next pass; the handover's next version; the Experience Map; the Principles' and Core Commitments' dated blocks; Organisation's record renamed; the files as filed before archived; the hash C14-P could not state

**Filed 2026-11-07, by this machine.** *Drafted by Product & Design's Cohesion Filing chat, briefed by Head of Product & Design (its brief, and its message 2 answering the chat's message 1) [RELAYED, Head of Product & Design]. The filing script refused unless every file was written at the hashes the Cohesion Filing chat checked, and every check printed nothing on a test copy of the repository built from the project mirrors at C14-P.*

**1. C147-I CARRIED** [READ, interpretation/change-record.md through C149-I]. Through Cohort 2 the app is purely a dream
interpretation app: no distress check, no Help page, no Help icon, nothing about distress or help in onboarding or
anywhere in the app. The rules that keep a reading from hurting anyone stand in full, and so does the therapy boundary.

**2. C146-I CARRIED** [READ, as above]. The age band never leaves the phone (item 1). "Keeps nothing" has one exception,
said in W27·2 and W27·3 in the founder's words before Cohort 1 (item 3). The founder's distress results in his export
(item 2) are overtaken by C147-I: none exist.

**3. THE FOUNDER'S RULINGS OF 2026-11-06 AND 2026-11-07** [RELAYED, Head of Product & Design, its brief and message 2],
one line each:
- The Region setting is removed; Settings are three: Language, Word Animation, Night/Day mode.
- W27·15 stays as written, in onboarding and on the privacy page alike; its fuller form for the privacy page is founder
  copy, written once the app is running. This defers C147-I's fuller form and does not contradict it.
- The exception to "keeps nothing" is said in both layers in the founder's words, never naming the material; W27·2 and
  W27·3 are to rewrite, their lines standing until he writes it, before Cohort 1. Counsel confirms before Cohort 1.
- W27·3: "anything you share" is now "anything you share in the app" / "något du delar i appen" (founder-approved
  2026-11-06).
- W27·10 is to rewrite: public-link TestFlight invitations may give the founder no tester's name or email (Technology
  Message 7 item 1a); Technology checks in setup, then the founder rewrites. MP·56's must now asks testers not to share
  the link.
- W27·2's "an AI service" stays, though two services exist (Technology Message 7 item 0).
- W27·6 keeps its first sentence only, in both languages (founder-ruled 2026-11-07). C147-I's WHAT DEPENDED names
  "W27·6's distress sentences": the second, on the signals, and the third, "Nothing that affects the app or your
  experience", the founder's words for "nothing responds to them" (C141-I item 8; C12-P). Counts still leave, the
  tradition-choice counts among them (Technology Message 7 item 4); Technology confirms in setup exactly which, before
  Cohort 1.
- The ⋯ menu sits top right on a night's page, where Help was; on every other screen the top right is empty
  (founder-ruled 2026-11-07).
- The founder's export: in his Cohort 0 build only, in each night's menu, to restricted/; read only in
  Interpretation's study chat (C142-I item 3). It carries no distress results, since none exist (C147-I).
- The stack is Flutter (Technology Message 8 item 2); nothing in the design changes. The founder intends Spanish and
  Android at Cohort 2 and more languages at Cohort 3 (Technology Message 8 item 3): noted, nothing planned.
- Organisation's change record is renamed organisation/organisation-change-record.md (founder-ruled 2026-11-07): two
  records named change-record.md collide in the project mirrors, as Product's did before C3-P.

**4. THE PLACES REGISTER,** at product/places-register.md and .csv.
- **Retired, keeping no line:** W26 and its parts W26·1 to W26·19; EM·7; MP·1, which the brief did not name and which
  named the Help button for a screen reader; MP·40, MP·41 and MP·42; MP·43; W27·16. A retired row keeps its must and
  never as history, as MP·7's and C4-P·3's do. The rows of the Help page, which no longer exists, move to Not on a
  screen yet, as C4-P·3 did at C14-P; the others stay on their pages.
- **To rewrite:** W27·2, W27·3 and W27·10, each flag saying why. W27·6 keeps its first sentence, its name, must and
  length to match.
- **Struck, pointing at C147-I:** the Help and crisis-page clauses in EM·5's, EM·6's, MP·47's, MP·49's and C4-P·8's
  never; MP·39's flag (where the ⋯ menu sits); W27's and MP·48's flags. MP·7's flag stays as history.
- **Two corrections:** EM·9's flag, which still called the language switch open after C14-P ruled it; and the closing
  line of product/places-register.md, which C13-P's new rows had been placed after, is back at the end.
- **The header:** W26's line notes its retirement; {region} is out of the header's list of slots, as no line uses it.
  The check's own list of slots is unchanged.
- **The check,** product/check-places-register.sh, amended for this filing and nothing else: it was
  `c7a29abea4e27087e009ff7481aec46284fff46005ddc23b2dc88a4abcb0c839` and is
  `2c6d1e38e22a3d6b1a1c5a63a4964d7f0b20e745a0f8b7fdbd938835bcad8b04`. Four rules changed. (a) The page
  Help is gone from its list of screens, so the counts no longer name it. (b) WORDS TO WRITE as main-path.md now holds
  it: no Help page; Onboarding's five bullets with MP·57 to MP·59; Recording's five with MP·54; MP·53 beside AI·11; the
  settings without MP·43. (c) A part of a place in parts may be "to rewrite" or retired, as well as written or merged.
  (d) The parts of a retired place may be retired with it. Every other test runs unchanged. On the new register it
  printed nothing; on copies broken on purpose it caught each of eight faults: a part of W27 marked to write, a part of
  retired W26 marked written, a row on the Help page, a retired part holding words, a part to rewrite with no line,
  MP·54 dropped from WORDS TO WRITE, MP·43 put back, and the Help draft mark removed [READ, the Cohesion Filing chat's
  test, on a copy built from the project mirrors at C14-P]. The old check stays in the repository's history.
- **The counts** [READ, `bash product/check-places-register.sh --count`]:

    places 164
    screen Every Screen 2
    screen Onboarding 38
    screen Recording 14
    screen The Mirror 9
    screen The Opening 11
    screen The Readings & Close 33
    screen The Journal 11
    screen Settings 10
    screen Not on a screen yet 36
    status retired 35
    status written 104
    status written, in its parts 1
    status to rewrite 3
    status merged into W27·6 1
    status paused 2
    status composed (stand-in written) 10
    status blocked 2
    status no line: prohibition 1
    status composed, no stand-in 2
    status no line: by decision 2
    status to write 1

**5. product/main-path.md, NEXT PASS.** Eight pages: the Help page is gone, and as drawn it is in the archived pass
(item 12). Carried: the Waking Life heading (MP·53); the failure lines (MP·54, EM·8); the app's face (MP·55) and
TestFlight (MP·56); the founder's export; the disclosure in two layers (MP·57 to MP·59); no instructions screen; no
language switch, so Onboarding's OPEN is settled; the click-through run (C12-P item 2). And this filing's rulings:
Help, its icon and the crisis page gone from Every Screen, Onboarding, Recording, The Mirror, The Opening, The Readings
& Close, The Journal and Settings; Region gone; nothing about distress; the age band on the phone; the ⋯ menu top
right. The founder's draft words stay as drawn, all 22 marks: the Help word is kept on Every Screen, said not to be
built, and the not-therapy paragraph keeps his text, with a note that none of it is shown. Its WORDS TO WRITE now name MP·53, MP·54, MP·57, MP·58 and MP·59, and no longer W26, MP·40 to MP·43.

**6. product/technology-handover.md, NEXT VERSION:** §2 (no Help, no distress check; Flutter); §3 (Every screen, Onboarding,
the Journal's menu, Settings; the Help screen gone); §4 (places in parts; "to rewrite" as a status the build meets);
§8 (W27·2 to W27·4, W27·6, W27·10, W27·17, no row resting on a firing); §9 (no distress check, no Help page; the
export with no distress results); §10 (MP·56); §11 (Help's images gone; W27·2, W27·3, W27·6 and W27·10; Cohort 2's
languages; support after Cohort 2).

**7. product/experience-map.md and its card sheet.** X1, X3, X4, W26 and EM·7 are placed as "Not met in Cohort 1",
each with C147-I in its note, so each stays placed and the map's check still finds every ID; the lists in §2 and §4,
and §6's crisis-resources row and I11, say so. Nothing else moved; the map's counts are unchanged. C14-P's two
rulings, no language switch and no instructions screen, are not carried here (WHAT DEPENDED).

**8. product/design-system.md.** type.h6 has no use through Cohort 2; type.button no longer names Help's body text.

**9. product/how-the-ai-appears.md is untouched.** At `da04f6b40631e092e55dd772d37590908bbb395aa5b8d503e26fdd898cb701f4`, it names no Help, crisis, distress or region
[READ, by the filing script].

**10. THE PRINCIPLES' DATED BLOCK,** appended to product/product-and-design-principles.md, signed by Ludvig alone
(C130-I item 1): Settings hold three things; the 2026-10-29 block's region item no longer applies; §5's crisis-resources
line, and any line naming crisis resources or the distress check, set aside through Cohort 2 (C147-I).

**11. CORE COMMITMENTS' DATED BLOCK,** appended to organisation/core-commitments.md, signed by Ludvig alone (C130-I item 1),
drafted here for Ludvig, who holds Organisation's items himself (Technology Message 7 item 1c). It suspends, for a
period and by the founder's ruling, lines Core Commitments calls never cuttable; it is not a correction. Set aside
through Cohort 2: §2.2's last bullet, its second and third sentences; §6.0's plainest statement; §6.1's "running now";
§6.3 whole; §6.4's lines on noticing and classifications; §6.5's enforcement requirement; §6.6 item 1; §9 items 1
(second paragraph) and 8; the 2026-09-14 correction block's "What is true"; the 2026-09-28 block's ruling on firings.
§6.0's rule, "the limit is on pressing, never on hearing", and §6.2 stand. It says Eva's agreement is not in the
repository. Nothing above it is edited.

**12. ORGANISATION'S RECORD, RENAMED** with git mv, so its history is kept: organisation/change-record.md is now
organisation/organisation-change-record.md. Two rows added in its own form, for the rename and for item 11, each with
"C15-P's" in its commit column; the hash goes in its next row. Its earlier rows each name their own commit; how they
came to is not recorded, so this filing follows Head of Product & Design's ruling (its message 2, item 8).
**Every line naming the old path**, from the filing script's search of every tracked file before the rename [READ, by
the script]; none is edited (Head of Product & Design, its message 2, answering A7):

- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 26
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 27
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 28
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 29
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 30
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 31
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 32
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 33
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 34
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 35
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 36
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 37
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 38
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 39
- `interpretation/founder-material-pass/fm-reading-record-reportonly.tsv`, line 40
- `interpretation/founder-material-pass/judgements_reportonly.py`, line 6
- `interpretation/history-rewrite/reading-record-history-only-2026-10-05.tsv`, line 1259
- `interpretation/history-rewrite/reading-record-history-only-2026-10-05.tsv`, line 1260
- `interpretation/history-rewrite/reading-record-history-only-2026-10-05.tsv`, line 1261
- `interpretation/history-rewrite/reading-record-history-only-2026-10-05.tsv`, line 1262
- `interpretation/history-rewrite/reading-record-history-only-2026-10-05.tsv`, line 1295
- `interpretation/history-rewrite/reading-record-history-only-2026-10-05.tsv`, line 1296
- `interpretation/history-rewrite/reading-record-history-only-2026-10-05.tsv`, line 1336
- `interpretation/history-rewrite/reading-record-history-only-2026-10-05.tsv`, line 1337
- `organisation/core-commitments.md`, line 749
- `organisation/decision-record.md`, line 177
- `organisation/head-of-organisation-handover.md`, line 22

**13. SEVEN FILES ARCHIVED WHOLE,** each in an archive note. The new versions take their paths.

| File | sha256 |
|---|---|
| Original, product/places-register.md | `155f65088f0995ae0b140f0a2d6ac5c7e9a491bfa79519053a6b3eebd8c2fb97` |
| Archived, archive/places-register-superseded-2026-11-07-at-C15-P.md, note included | `89ed3e8a31cac4ccc42e55b4e20c9fb480025b4400001d03fba804fbcda6be68` |
| Original, product/places-register.csv | `b3b34988591f66362f01c90080bc7b89f2a6b05d8b0688bb8552360c5ea3a0ad` |
| Archived, archive/places-register-superseded-2026-11-07-at-C15-P.csv, note included | `4db4cfdf9a053f72a3ae559ab0b372815c6867e491838aa0d9ec2ae208a0f889` |
| Original, product/main-path.md | `0904d30d8a6815c621c9f88f433d1247ba5e6af1e5c421185a220639b928af45` |
| Archived, archive/main-path-superseded-2026-11-07-at-C15-P.md, note included | `70f07f97bf47ea6e093b47ac4dc1038cb03818036f4fab6855c9886bf71e2459` |
| Original, product/technology-handover.md | `c263f865717165c1191c0b949227dc15138893e5dcf059e5fe9e348f91b6e353` |
| Archived, archive/technology-handover-superseded-2026-11-07-at-C15-P.md, note included | `cb345fe715b8d3fe3094e1e65dac737fe5ecbda38c27a070ea99e682d38eb2e2` |
| Original, product/design-system.md | `3f4a0dcd58f1d52e9e683c4d5af373c137304cd5fe72b71b9a23f6af2f770974` |
| Archived, archive/design-system-superseded-2026-11-07-at-C15-P.md, note included | `252e0e36c6e0dee2dd360ef714a0cd2e297634c6580b232698be219102176e0e` |
| Original, product/experience-map.md | `43434fd1ebce8c886ea1de3a4f38b5c58ca96cf399c63711b559ec6355090be2` |
| Archived, archive/experience-map-superseded-2026-11-07-at-C15-P.md, note included | `77e1eda56c9a59319133734ac2c881024ca4c91cd2ae52f50b2552334a179609` |
| Original, product/experience-map-cards.csv | `f3be5ae3b97620045b2b743687c9db9719903ffe983b75ad7f12fbd9c87cc0b8` |
| Archived, archive/experience-map-cards-superseded-2026-11-07-at-C15-P.csv, note included | `66bd2abaf0048416fcc856bbf2a57bd0066ecfb1c6c7a08f6cf09dd7299609fe` |

Each of these prints its original's hash, and printed it at filing [READ, by the filing script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-07-at-C15-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-07-at-C15-P.csv | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/main-path-superseded-2026-11-07-at-C15-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/technology-handover-superseded-2026-11-07-at-C15-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/design-system-superseded-2026-11-07-at-C15-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/experience-map-superseded-2026-11-07-at-C15-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/experience-map-cards-superseded-2026-11-07-at-C15-P.csv | shasum -a 256

**14. THE FILES NOW.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/places-register.md | `107fca4e5b0f2676015adf3d401da73d534c6d001f841b73813d29d1386f2543` |
| product/places-register.csv | `d2b5e14a92b210db2a006b0deefcd40029f56a33ced808562c1242d5689c4383` |
| product/main-path.md | `7140f9456d19a012951bafba38b882ef246ec9313d753e2e46e04ebf2fa32139` |
| product/technology-handover.md | `7e659f472e8cd80dec99af1fb6a0bdbcbb25aee5d73231ba5d7b09bd9d07fced` |
| product/design-system.md | `822c7e0fe42eecb0150d3815e0ae95ccf2e8d45a0810ae7705bcb3183cb50ba3` |
| product/experience-map.md | `5ddbf849e1b61b14c107be9b20bca32e5da8e67c517cf98033d3c7b843ad174c` |
| product/experience-map-cards.csv | `f33df39267e8f328fe530a7768c37c877e12e35f4d8c4e023c38313605cc560d` |
| product/check-places-register.sh | `2c6d1e38e22a3d6b1a1c5a63a4964d7f0b20e745a0f8b7fdbd938835bcad8b04` |
| organisation/organisation-change-record.md | `b576da548e75265f8b04ff7159ba28320d55a2d28b93a29c8ee361303987f74a` |
| organisation/core-commitments.md | `0713208b07d38152bab48f215df6c5a6c2abaf86501e2e50b5b98a4bbbef4477` |
| product/product-and-design-principles.md | `08c3987c8b81facfbc5669b95cbea731de9d5f294ecf28a296c88a0f60b04c53` |

**15. THE HASH C14-P COULD NOT STATE.** At f0c1d48 this record was `c13aa265bf1ae257d178a61c16393c95d48f8244ae985d53e4ca203147d20e95` [READ, by the filing script: the
file at that commit hashes so, and f0c1d48 is the commit that last changed it before this one]. This record still
cannot state its own current hash; the filing script prints it, and the next Product filing records it.

**16. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean, the new paths absent, Interpretation's record
as read, through C149-I at `7d572feb259504fdd8e9da989134cfe6ad865fb2ee1613b7e3234eba93740dda`, the exact start of the record at filing, Core Commitments and Organisation's record at the hashes the chat read, and every
Product file at its C14-P hash. Product's check, the heading check, the map's check, the register's check as amended,
product/check-principles.sh on the Principles, How the AI Appears, the Design System, the founder's lists and the
handover, and each archive note's original hash all printed nothing or matched. The word check is not run on main-path.md,
the register or the map, as at every earlier filing; each already held words it lists, in the founder's own lines
and in the disclosure's nevers, and this filing adds none.

**WHAT DEPENDED ON THIS.**

- **Technology.** One message from Head of Product & Design after the push: no Help screen and no distress check; three
  settings; the ⋯ menu top right; W27·2, W27·3 and W27·10 to rewrite and what Technology checks in setup for W27·6 and
  W27·10; MP·56; the export with no distress results; the age band on the phone; Organisation's record's new name.
- **Interpretation.** A notice from Head of Product & Design after the push: the Region setting removed; W27·15 on both
  pages until its fuller form; the exception said without naming the material; the Core Commitments block;
  Organisation's record's new name. And one question: whether W27·15's second clause collides with Core Commitments §6.0
  now that it stands with no Help page. W27·15 stands as written meanwhile.
- **Organisation, for Ludvig.** Its record's next row states C15-P's commit hash. Filing Eva's agreement (C130-I item 1).
  The unfilled row in its record, "DATE | organisation/decision-record.md, entry N | fc8960c".
- **Counsel.** W27·2 and W27·3, once the founder writes the exception; the layered disclosure, before Cohort 1.
- **The founder.** W27·2, W27·3 and W27·10 to rewrite, and MP·56, before Cohort 1; W27·15's fuller form once the app is
  running; the project instructions' role block, which still names crisis resources among the safety surfaces, changed
  the day this is pushed.
- **product/experience-map.md,** at its next pass: C14-P's rulings, no language switch at M1 and F3, and C4-P·3 retired.
- **Interpretation's entries filed after C149-I,** while this filing waited. Not read for it: the founder ruled that a
  Product filing need not wait on Interpretation's record, only check that what it read is unchanged (2026-11-07
  [RELAYED, the founder, in the Cohesion Filing chat]). At filing, the record read, through C149-I, was the exact start
  of the record [READ, by the filing script]. Each is read at the next Product filing:

- C150-I — The Close, Draft 5, filed; Draft 4 whole to archive; the rulings it was written to

- **C148-I and C149-I,** filed after this filing was drafted and read before it was filed [READ, interpretation/change-record.md
  through C149-I]. Nothing in either is carried here, and nothing here contradicts them. Owed to the next Product filing,
  as C149-I routes it: the Places Register's W14 (the decline, now composed with no stand-in, Q13), W15, W16, W17 and
  the marking line (MP·24); how either empty night is shown; the press's look (B1), unlabelled. And MP·53's and W17's
  flags, which still say Interpretation records the heading at Lens Practice Draft 11's filing: it is recorded at C148-I.
- **The project mirrors.** places-register.md and .csv, main-path.md, technology-handover.md, design-system.md,
  experience-map.md, experience-map-cards.csv, product-and-design-principles.md, core-commitments.md and
  product-change-record.md are replaced by these versions.

---

## C16-P — Lens Practice Draft 11 and C148-I to C153-I carried; crisis material and Help scrapped indefinitely, in every Product document; the marking line and the two empty nights; How the AI Appears' next pass; the Principles' and Core Commitments' dated blocks; the Shared Core's two lines; the files as filed before archived; the hash C15-P could not state

**Filed 2026-11-10, by this machine.** *Drafted by Product & Design's C16-P Filing chat, briefed by Head of Product & Design (its brief, and its message 2 answering the chat's message 1) [RELAYED, Head of Product & Design]. The filing script refused unless every file it reads was at the hash the chat read, and every check printed nothing on a test copy of the repository built from the project mirrors at C15-P.*

**1. THE METHOD: THE FOUNDER'S LEAN CHECK** (founder-ruled 2026-11-07 [RELAYED, Head of Product & Design]). In his words:
move fast and be lean; each department moves efficiently on its own, checks another department's work when something
there changes, and wastes no time on strict checks that slow everyone down. How a filing does it: it reads what another
department has filed up to the moment it is drafted; at filing it checks only that what it read is still there,
unchanged, and names anything filed since as not read, to be read at the next filing. It never waits on another
department. It still stops for what would make the record false: a change to text already filed, a dirty tree, or a
check that fails. This filing is built so. Interpretation records the same direction at C152-I item 3.

**2. C148-I CARRIED** [READ, interpretation/change-record.md through C153-I]. MP·53's and W17's flags point at C148-I,
where the Waking Life heading is recorded, not at Lens Practice Draft 11's filing.

**3. C149-I AND LENS PRACTICE DRAFT 11, §14 AND §15** [READ, interpretation/lens-practice.md at `6c77a323`].
- W14, the decline: composed each night, with no stand-in (Q13; §15 item 11). Its founder line retires; its status is
  "composed, no stand-in". If composing it fails, the next tradition with purchase reads, or the slot is empty (Q6).
- W15 stays retired. W16 holds no words. The press is unlabelled (§14 item 15). main-path.md and How the AI Appears
  already said so [READ].
- The press, the questions and the invitations cannot be marked (§14 item 16). main-path.md and How the AI Appears
  named the series question and the invitations, not the press [READ]; both now name it.
- THE TWO EMPTY NIGHTS (§14 item 19), as the founder ruled 2026-11-07 [RELAYED, Head of Product & Design]. When every
  chosen tradition declines, the night shows the declines themselves, each in its reading's look with its label, and
  nothing else marks it. When readings fail and none passes, the failure sentence (C4-P·6) shows, no decline shows,
  the night stays unread, and the dreamer reads again with Start Interpretation. No new place and no new words. What
  follows a night of declines (the close, Waking Life, Add to Journal) is not ruled here: it goes to Interpretation as
  a question.

**4. THE MARKING LINE, FOUNDER-RULED** (2026-11-07 [RELAYED, Head of Product & Design]). MP·24 stays as written, its unit
included ("any sentence, word or paragraph"), and no sentence about the close is added. The founder's reason: a dreamer
who has not reached the close does not know what "the close" is. He rules that the rule bends to the line, not the line
to the rule. This is recorded as the founder's ruling, not as a departure. The rule stands today in C129-I item 3, Lens
Practice §9B, §14 item 16 and §15 item 15, the Requirements List's L18, and The Close Draft 5 [READ]; Interpretation is
asked to bring each to the line. MP·24's must and main-path.md's Marks section now point at the ruling.

**5. C150-I AND THE CLOSE DRAFT 5** [READ, interpretation/the-close-draft-5.md at `fa23d0e8`]. Carried, as the direct
contradictions that need no new words (Head of Product & Design, its message 2, item 2):
- AI·17, "A marked sentence", is retired: the reflection never says a line was marked (H8; its copy item 10; C150-I
  ruling 8). Its row stays, so How the AI Appears keeps its numbers.
- W24's never loses "read as save" (C150-I ruling 6) and gains Q10: it fails if it implies a night never added is lost
  or incomplete (copy item 6).
- AI·12, "Tonight you wrote", names a time it cannot know, since a reflection may come days later (H7; copy item 10;
  ruling 4). It is "to rewrite", its line standing until then. OWED BY THE FOUNDER: a phrase, in each language, saying
  the words are what the dreamer wrote after the readings, naming no time.
- W22, the empty case, stays: The Close keeps it (copy item 4). P3, no response and so no empty-case line, is behaviour,
  owed below.
- OWED TO THE NEXT PRODUCT FILING, not carried here: the close's three invitations' stand-ins against copy items 7 to 9;
  the respond-state line saying truly that the close has its own three reflections (A10); P3 in main-path.md; the look
  back as The Close's "The look back" holds it (the press, the dreamer's response, late tellings, what was written
  before the night was read); "Add to Journal" from the waking-life invitation on, checked against main-path.md.

**6. C151-I** [READ]. Carried: a capital letter does not make a different word, in search (main-path.md, The Journal; the
handover). The 21:00 boundary is carried through C152-I item 2 (item 7). OWED TO THE NEXT PRODUCT FILING: the journal list
and search as its §8 states them; W25; the behaviour list's items 4, 5, 9 and 10; B4, a recording into a night paused
at its unconfirmed mirror joining the telling.

**7. C152-I** [READ]. W27·15 is now "This app is not therapy." / "Den här appen är inte terapi.", in onboarding and on
the privacy page alike: a cut of the founder's own line, no new words (item 1, founder-ruled). Its must points at
C152-I item 1, and its flag drops the fuller form C15-P left owed, which C152-I overtakes. X6 still names the second
clause; that goes to Interpretation. A night stays open until the first 21:00 after its first recording, by the phone's
local time (item 2, founder-ruled): main-path.md's Nights and the handover's Recording say so.

**8. C153-I** [READ]. Crisis material, the distress check and Help are scrapped indefinitely (item 1, founder-ruled).
Nothing is ruled out (The Foundations §6), and the way back is a new founder ruling. Every Product document now says so
where C15-P wrote "through Cohort 2" or "decided after Cohort 2" in that sense; Spanish, Android and the backup setting
at Cohort 2 stay, and records and archives are never edited (Head of Product & Design, its message 2, item 5).
W27·2's and W27·3's flags give the fact to write from, "our provider may keep, for review, content its automated
safety systems flag" (Technology Message 10 item 2 [RELAYED]), in the founder's words, never naming the material; both
stay "to rewrite". C146-I's suggested "except where the law requires it" is withdrawn (item 2). W27·4 is the
recording service and is not affected. The founder's safety copy (item 3) is in main-path.md's export section and the
handover's §9. The model's instructions come through Product to Interpretation for review, one document at a time
(item 4): the handover's §2 and §11 say so.

**9. THE FAILURE LINES** (Head of Product & Design, its message 2, item 3). When every reading fails, C4-P·6 shows alone.
EM·8 stays for no connection and the spending limit; its flag loses "a reading cannot complete". main-path.md and the
handover's failure table say so.

**10. TECHNOLOGY MESSAGES 11 AND 12 (2026-11-09)** [RELAYED, Head of Product & Design, its messages 4 and 5].
- W27·6 and W27·17 become "to rewrite", their lines standing until the founder rewrites them before Cohort 1, with
  W27·2, W27·3 and W27·10. W27·6 promises too little leaves: feedback (W27·9), crash reports through Apple (W27·10) and
  the phone's request for a transcription key, carrying no content, also leave (Message 11 item 1). W27·17, "No one
  reads your dreams", sits beside the exception, under which flagged content may be kept for review, and a review is a
  person; the founder writes it again in neutral words, never naming the material (Message 11 item 2).
- Message 11 item 3 (W27·15) is answered by item 7.
- FOUNDER-RULED 2026-11-09: recurring images are matched on the phone. The model chooses tonight's anchor, and the phone
  matches it against earlier nights by the same rule as search (same word, different ending; C140-I item 6). No
  earlier night leaves the phone (Message 11 item 4). A notice to Interpretation; nothing in a Product document said
  otherwise.
- Carried to Interpretation as a question (Message 11 item 5; C3-T 2e): in Cohort 0's blind comparison of Claude and
  Gemini, what is a reading judged against? Technology holds that no "which resonates more" figure is computed.
- FOUNDER-RULED 2026-11-09: the split between dreams is detected when the dreamer taps Start Interpretation, never at
  recording, because a typed night's words leave the phone only to be read (C140-I item 1; Message 12 item 1).
  main-path.md's Recording and Mirror, the handover's §3 and the Experience Map's O1 row at M2 now say so. EM·2's title
  and I1's heading, both history, keep their words.
- W7's must says "night", not "session" (C134-I item 5; Message 12 item 2).
- The stand-ins' lengths agree with their lines as written: W1, W3 and MP·21 are two sentences, so "a paragraph"; no
  line changes (Message 12 item 3). W7 and the mirror's line also hold two sentences at "one sentence"; neither is a
  stand-in, and both are left for the founder's copy pass.
- W1's stand-in is "to rewrite": it says "images", where The Opening Draft 8 fails a line steering toward images over
  moments (Message 12 item 4).
- The mirror's line (C125-I·3) predates the founder's two-jobs ruling of 2026-11-06: flagged for his copy pass before
  Cohort 1; its status stands (Message 12 item 5).
- W27·2's Swedish, "där de sedan raderas", says the service deletes the words, where under retention "none" nothing is
  stored; Head of Product suggested that wording at C14-P, and it goes with the rewrite (Message 12 item 6).

**11. THE PLACES REGISTER,** at product/places-register.md and .csv. Changed: W14, W16, W17, MP·53, MP·24, W27·15,
W27·2, W27·3, EM·8, C4-P·6, AI·12, AI·17, W24 (items 2 to 9); W27·6, W27·17, W1, W3, MP·21, W7 and C125-I·3 (item 10); W26's flag, and every row and header line that said
"through Cohort 2" in the crisis sense, now "indefinitely" with C153-I (C15-P's retired rows among them: EM·7, MP·1,
MP·40 to MP·42, W26 and its parts, W27·16; EM·5's and EM·6's never; W27's flag). The header's composed places name
W14. The check is unchanged and printed nothing. The counts [READ, `bash product/check-places-register.sh --count`]:

    places 164
    screen Every Screen 2
    screen Onboarding 38
    screen Recording 14
    screen The Mirror 9
    screen The Opening 11
    screen The Readings & Close 33
    screen The Journal 11
    screen Settings 10
    screen Not on a screen yet 36
    status retired 36
    status written 99
    status written, in its parts 1
    status to rewrite 7
    status merged into W27·6 1
    status paused 2
    status composed (stand-in written) 9
    status blocked 2
    status no line: prohibition 1
    status composed, no stand-in 3
    status no line: by decision 2
    status to write 1

**12. product/main-path.md, NEXT PASS.** Its "Whose it is" names this pass. Every Screen and its rules: no Help and no
distress check, indefinitely. Onboarding's not-therapy note: W27·15's cut. Recording's Nights: the 21:00 boundary. The
Opening's failed reading: C4-P·6 alone. Recording and The Mirror: the split detected at Start Interpretation. The Readings & Close: the decline and the night of declines; the press
unmarkable; the Marks section and the founder's ruling; AI·17 retired and AI·12 to rewrite. The Journal: search's
capital letters; the founder's safety copy. The founder's draft words and every [founder's draft copy] mark are as
they were.

**13. product/technology-handover.md, NEXT VERSION:** "Whose it is"; §2 (indefinitely; the four redrafts filed; the
instructions' review route); §3 (the 21:00 boundary; the split at Start Interpretation; the declines and the two empty nights; the press; marking; search);
§4 (W26 indefinitely; W14's failure; the places to rewrite); §5 (the reflection without AI·17; W14's row; the failure
table); §8 (the exception's fact; W27·6 and W27·17 to rewrite); §9 (indefinitely; the safety copy); §11 (AI·12, W27·6, W27·17 and W1's stand-in; the night of declines; the
instructions; support after Cohort 2 removed).

**14. product/how-the-ai-appears.md, NEXT PASS,** untouched since C11-P: "Whose it is" names this pass; §2.5 (the press
cannot be marked; the reflection never says a line was marked); §3 (the decline and the two empty nights; the press;
the closed-set form without AI·17); §11's reflection line; the table's AI·17 row says it is retired.

**15. product/experience-map.md and its card sheet.** C14-P's two rulings carried: no instructions screen, so C4-P·3 is
retired and placed once, as "Not met in Cohort 1", with its ruling; no language switch, so EM·9 is met at M0 only and its
M1 row and card go. X1, X3, X4, W26 and EM·7 say "indefinitely" with C153-I, as do the pass note, I11 and §6's
crisis-resources row. O1's note at M2: nothing is detected at recording (item 10). The label "Not met in Cohort 1" stays (its message 2, item 7). The map's check printed nothing.
Its counts [READ, `bash product/check-experience-map.sh --count`]:

    requirements 72
    places 32
    slots 15
    handles 9
    found 11
    total 139
    placement rows 183

**16. product/design-system.md.** type.h6: "None", with C153-I, not "None through Cohort 2".

**17. THE PRINCIPLES' DATED BLOCK,** appended to product/product-and-design-principles.md, signed by Ludvig alone (C130-I
item 1): the 2026-11-07 block's item 3 reads without a date; nothing is ruled out, and the way back is a new founder
ruling (C153-I item 1).

**18. CORE COMMITMENTS' DATED BLOCK,** appended to organisation/core-commitments.md, signed by Ludvig alone (C130-I item 1),
drafted here for Ludvig: the 2026-11-07 block's set-asides hold until a new founder ruling, not through Cohort 2
(C153-I); evidence of need goes to the founder for that ruling; the 2026-11-07 block's open question is answered by
C152-I item 1. Nothing above it is edited. Its row in organisation/organisation-change-record.md, in that record's
form, states bfa7f6c as the commit of the two rows C15-P added, as they promised [READ, by the filing script: the
commit that last changed that record before this filing, its message beginning "C15-P:"].

**19. THE SHARED CORE, TWO LINES, AND THE ROLE BLOCK** (founder-approved 2026-11-09, word for word as drafted
[RELAYED, Head of Product & Design, its message 4]). The Shared Core changes in all four projects in one pass, recorded in each
project's change record; the pass is the founder's alone (C130-I item 1). Recorded here; the founder pastes them. The
Shared Core is not a filed document.
- Added under "How we keep from drifting":
  · Move fast and stay lean. Each department moves on its own and never waits on another. A filing reads what other
    departments have filed up to the moment it is drafted; at filing it checks only that what it read is still there,
    unchanged, and names anything filed since as not read, to be read at the next filing. It still stops for a change
    to text already filed, a dirty tree, or a check that fails.
- Replacing, under "What we never do, anywhere", the line "Dreamer-facing words are written by a person, in each
  language independently, never machine-translated, never model-drafted" (C128-I item 1; C130-I item 1):
  · Fixed dreamer-facing words are written by a person, in each language independently, never machine-translated,
    never model-drafted. The app's composed lines are practice turns: written each night under the practice's rules,
    each language on its own, and checked before they show. Where a composed line has a stand-in, a person writes it.
- This project's role block, "The pillars of UX", the safety surfaces: "the safety surfaces (none is built: crisis
  material, the distress check and Help are scrapped indefinitely, and nothing is ruled out; the way back is a new
  founder ruling, C153-I. What stands is the not-therapy line and the rules that keep a reading from hurting anyone,
  C147-I; C152-I)". And "UX WRITING", its first sentence: "Every fixed dreamer-facing word is written by the founders, by
  hand, in each language independently, never model-drafted, never machine-translated; the app's composed lines are
  practice turns, and their stand-ins are the founders'."

**20. EIGHT FILES ARCHIVED WHOLE,** each in an archive note. The new versions take their paths.

| File | sha256 |
|---|---|
| Original, product/places-register.md | `107fca4e5b0f2676015adf3d401da73d534c6d001f841b73813d29d1386f2543` |
| Archived, archive/places-register-superseded-2026-11-10-at-C16-P.md, note included | `861d28ce507238db7f3278391d1e08751e9b0bd440cb46bdafa2e445f9f90435` |
| Original, product/places-register.csv | `d2b5e14a92b210db2a006b0deefcd40029f56a33ced808562c1242d5689c4383` |
| Archived, archive/places-register-superseded-2026-11-10-at-C16-P.csv, note included | `db93fb72640e09d18972e4bc9b1103665a3779706707cc7a12b57dd72829f490` |
| Original, product/main-path.md | `7140f9456d19a012951bafba38b882ef246ec9313d753e2e46e04ebf2fa32139` |
| Archived, archive/main-path-superseded-2026-11-10-at-C16-P.md, note included | `029998e35cb27b1a47509710464c221ca15e7fd05171cd9953b28998216eccdb` |
| Original, product/technology-handover.md | `7e659f472e8cd80dec99af1fb6a0bdbcbb25aee5d73231ba5d7b09bd9d07fced` |
| Archived, archive/technology-handover-superseded-2026-11-10-at-C16-P.md, note included | `e57e038289f6387beece2ad39f05cec6f2ae3dde330b16727882deea9c935858` |
| Original, product/how-the-ai-appears.md | `da04f6b40631e092e55dd772d37590908bbb395aa5b8d503e26fdd898cb701f4` |
| Archived, archive/how-the-ai-appears-superseded-2026-11-10-at-C16-P.md, note included | `3c7116dda936eb765cb03e0f570263f6dc06d2e351eb31b01b95c0a10aa9f6ee` |
| Original, product/design-system.md | `822c7e0fe42eecb0150d3815e0ae95ccf2e8d45a0810ae7705bcb3183cb50ba3` |
| Archived, archive/design-system-superseded-2026-11-10-at-C16-P.md, note included | `f4ed5d49b39e62da20545e1d7ec338e5475406ba1e649d97fa798617090ba88e` |
| Original, product/experience-map.md | `5ddbf849e1b61b14c107be9b20bca32e5da8e67c517cf98033d3c7b843ad174c` |
| Archived, archive/experience-map-superseded-2026-11-10-at-C16-P.md, note included | `1effcb44dcc0180493932f67f87fe41e736438fd1d15f2dd2b604796be083eb3` |
| Original, product/experience-map-cards.csv | `f33df39267e8f328fe530a7768c37c877e12e35f4d8c4e023c38313605cc560d` |
| Archived, archive/experience-map-cards-superseded-2026-11-10-at-C16-P.csv, note included | `60afb265c7e0619fbb9d1020dff3a37eaba686ddb59f3ca442f4de6fa5a54e05` |

Each of these prints its original's hash, and printed it at filing [READ, by the filing script]:

    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-10-at-C16-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/places-register-superseded-2026-11-10-at-C16-P.csv | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/main-path-superseded-2026-11-10-at-C16-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/technology-handover-superseded-2026-11-10-at-C16-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/how-the-ai-appears-superseded-2026-11-10-at-C16-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/design-system-superseded-2026-11-10-at-C16-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/experience-map-superseded-2026-11-10-at-C16-P.md | shasum -a 256
    sed '1,/^=== ORIGINAL TEXT BELOW, UNCHANGED ===$/d' archive/experience-map-cards-superseded-2026-11-10-at-C16-P.csv | shasum -a 256

**21. THE FILES NOW.** Their hashes at filing [READ, by the filing script]:

| File | sha256 |
|---|---|
| product/places-register.md | `c1019ce0f0f79de9a03abe9f58e0dc89e7f76ac6ea9b8289e6f20d0fcd85b026` |
| product/places-register.csv | `b2bd53188762db71e58078c2634d6e455dcff3561010d78cb8f4d46ad85e59df` |
| product/main-path.md | `6d503665ef9e86228672c1b8e0fea578bd8109d51e18259d6fc5f754e218ab19` |
| product/technology-handover.md | `0f40be6b5c8061d7afa1fc7cf1d29b5f080ebe5f6b61f713c7feff4cd90a1576` |
| product/how-the-ai-appears.md | `a7279784886b17364d84fd7f99b7dc5e15a4ee11f9a8e732a2a746fe84c324db` |
| product/design-system.md | `fcf8e8140d2b743ae58ad0431d15e43e099fbc60db8dcb2109f76040143748fe` |
| product/experience-map.md | `3c8878f6f03b6f75d460c13d7b85293f8da6edff8af94cb07799294e847e6a41` |
| product/experience-map-cards.csv | `4254e601c5394011058f15f81fd10e7ab0bf6c586d8f6d03bb74446bf727f823` |
| product/product-and-design-principles.md | `1f8992a7ec513553f5c08742244a304bc9d8d8dd9531c167d138230ba6a82a00` |
| organisation/core-commitments.md | `f1e71c260881d7b5909fc28b3960d104485ce082fc539bae66242cbd5666abdf` |
| organisation/organisation-change-record.md | `8af1425206cce15d30f43538c7a1cb628fe851426c3fae6796ca39004015e28e` |

**22. THE HASH C15-P COULD NOT STATE.** At bfa7f6c this record was `be1857280de9a1ec09b2198afefda0f11006f31efe539a0dd9a14a5d79e0a106` [READ, by the filing script: the
file at that commit hashes so, and bfa7f6c is the commit that last changed it before this one]. This record still
cannot state its own current hash; the filing script prints it, and the next Product filing records it.

**23. CHECKED BEFORE FILING** [READ, by the filing script]: the tree clean; the new paths absent; Interpretation's record
as read, through C153-I at `86f848ab0eaff1d969bd22f07fabcc2e5a8fb5ec897c1090b6a6752f02ff5876`, the exact start of the record at filing; Lens Practice, The Close Draft 5
and the Requirements List at the hashes the chat read; Core Commitments and Organisation's record at their C15-P
hashes; every Product file at its C15-P hash. Product's heading check, the dated blocks' heading check, the map's
check, the register's check, product/check-principles.sh on the Principles, How the AI Appears, the Design System, the
founder's lists and the handover, and each archive note's original hash all printed nothing or matched. The word check
is not run on main-path.md, the register or the map, as at every earlier filing.

**WHAT DEPENDED ON THIS.**

- **Interpretation.** One notice from Head of Product & Design after the push. The marking line, founder-ruled: C129-I
  item 3, Lens Practice §9B, §14 item 16 and §15 item 15, L18 and The Close Draft 5 to be brought to the line, its unit
  included. The two empty nights as shown, and one question: what follows a night where every chosen tradition
  declines. W14's founder line retired. AI·17 retired and AI·12 to rewrite, under The Close Draft 5. X6, which still
  names the second clause C152-I item 1 removed. The Core Commitments block. The lean-check direction and the Shared
  Core's two lines, to record at its next entry. W27·17 and the flagged review (item 10). The notice that recurring
  images are matched on the phone (item 10). The question on Cohort 0's blind comparison (item 10).
- **Technology.** One message from Head of Product & Design after the push: the decline composed with no stand-in, and
  its failure; the two empty nights; C4-P·6 for a reading that cannot complete, EM·8 only for no connection and the
  spending limit; the press unmarkable; the marking line; AI·17 retired, AI·12 to rewrite; W24's never; W27·15 cut; the
  21:00 boundary; the split at Start Interpretation; capital letters in search; W27·6 and W27·17 to rewrite; the exception's fact for W27·2 and W27·3; the safety copy; the
  instructions' review route.
- **Organisation, for Ludvig.** Its record's next row states C16-P's commit hash. Filing Eva's agreement (C130-I item
  1). The unfilled row in its record, "DATE | organisation/decision-record.md, entry N | fc8960c".
- **Counsel.** W27·2 and W27·3, once the founder writes the exception from its fact, before Cohort 1.
- **The founder.** AI·12, in each language. W27·2, W27·3, W27·6, W27·10 and W27·17, W1's stand-in, and MP·56, before
  Cohort 1; the mirror's line, W7 and their lengths at his copy pass. The Shared Core's two
  lines pasted into all four projects, and the role block's two lines into this one, the day this is pushed.
- **The next Product filing.** C150-I's items named in item 5, and C151-I's in item 6. The Requirements List's Draft 2,
  when it files.
- **Interpretation's entries filed after this filing was drafted.** Not read for it (item 1). At filing, the record
  read, through C153-I, was the exact start of the record [READ, by the filing script]. Each is read at the next
  Product filing:

- C154-I — Product's message 26: the Shared Core pass recorded; the marking line; the night where every tradition declines; what the blind comparison judges; the split found at Start Interpretation

- **The project mirrors.** places-register.md and .csv, main-path.md, technology-handover.md, how-the-ai-appears.md,
  design-system.md, experience-map.md, experience-map-cards.csv, product-and-design-principles.md, core-commitments.md
  and product-change-record.md are replaced by these versions.

---
