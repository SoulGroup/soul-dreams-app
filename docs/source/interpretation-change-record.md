# Change Record

*One dated block per change to a governing document. What changed, what it was
before, who ruled it, why, and what depended on it. Append-only.*

**Created** 2026-09-09 · **Owned by** Audit & Measurement, Interpretation ·
**Founder-ruled** 2026-09-09

**This is not the audit log.** No findings here, and no reasoning about method —
that lives in the document's own reasoning section. This file answers one
question: what changed, and what else did that break or repair?

---

## Conventions

**Every block carries a required field: WHAT DEPENDED ON THIS.** The documents
and claims this change makes false, or makes true again. **A block without that
field is not filed.** Adopted 2026-09-09 from a proposal by this chat, made
smaller by Head of Interpretation.

The reason it is a field and not a check: it is the department's first mechanism
that catches a *class* of error rather than an instance. Three wrong claims on
2026-09-08 were all the same shape — a ruling in one document silently made a
claim in another false, and both documents still read correctly on their own. No
recount catches that. A required field does. Audit log A12-I, class 3.

- **Never edit inside a dated block.** A correction or reversal is an appended
  dated block that names the block it reverses. **The earlier block is left
  exactly as written.** The build side spent a whole arc undoing a document that
  recorded its own history in layers, where the last layer by position was dated
  earliest and was wrong.
- **Blocks are read in ordinal order, never positional.**
- **Ordinals are assigned by whoever files**, against the file as it stands at
  that moment. A drafting chat writes `BLOCK UNNUMBERED — drafted <date>,
  <department>`. *C1-I to C16-I below were assigned at creation against an empty
  file, where no collision was possible. Every later block follows the unnumbered
  convention.* Adopted after two departments both claimed BLOCK 4 in
  `where-we-stop.md` and neither could see the other.
- **Every block carries a department mark**: `-I` Interpretation, `-T`
  Technology.
- **Provenance on every claim**, marked when it is written: `[READ]`,
  `[RELAYED]`, `[ASSUMED]`.
- **Filed** means handed to the founder with a sha256 hash, held in the project,
  and the hash recorded here. Ruled 2026-09-09, replacing "a commit reaching
  main" — there is no longer a repository to land in. **The department's
  documents live in the project *and* in a versioned backup the founder
  controls**, because the risk that produced the old rule has not gone away.

### Fingerprints of the documents this file governs

| Document | sha256 | Recorded |
|---|---|---|
| `audit-log.md` | *(recorded by the founder on receipt — see C16-I)* | 2026-09-09 |
| `change-record.md` | *cannot state its own hash; reported to the founder with the handover* | 2026-09-09 |
| `dream-journal_14_07_2026_snapshot_.md` | `3a7d600a561597d0e878fd872e6941f7053a7442eac245bd81ae77f0419bb197` | 2026-09-09 `[READ]` |

---

## C1-I — Foundations §3: "and in order" struck

**Founder-ruled 2026-09-08.**

**Was:** *"Fit is expressed in words and in order only."*
**Became:** *"Fit is expressed in words only."*

**Why.** Lens Practice ordered lenses by tradition age, which made the order
carry no information about the reading, and the sentence therefore false.

**Consequence noted at the time:** the why-line now carries the whole of the
app's authority claim.

**WHAT DEPENDED ON THIS.** Three claims, all of which became false and none of
which was noticed for a day:
1. `product-principles.md` §5 — *interpretations are offered ranked by fit*.
2. `marking-and-what-we-watch.md` — its stated reason for marking while reading,
   which is that the lens order is the grounding order, so late marks would
   systematically favour the least-grounded reading.
3. Watch item **W7** — *where do marks land relative to grounding order?* —
   which had nothing left to measure against.

**All three are restored by C8-I.** This block is left as written.

---

## C2-I — no summary passage after the lenses is CURRENT METHOD, not a permanent commitment

**Founder-ruled 2026-09-08.**

**Was:** treated as a permanent commitment. **Became:** current method,
revisitable in Wave 0.

**Why.** It was never in the governing set. An earlier claim that Foundations §8
forbade it was false and is withdrawn — §8 carries no such line `[READ,
2026-09-09]`.

**WHAT DEPENDED ON THIS.** `marking-and-what-we-watch.md` rules it out flatly
under *Ruled out*, dated 2026-09-04, and states that none is to be added. Both
documents are live and they read differently. **Reconciliation assigned to the
instruments chat, 2026-09-09.**

---

## C3-I — the 1–5 depth scale retained, mapping to three distinct lens counts

**Founder-ruled 2026-09-08.** Scores 1 to 5 map to lens counts 1, 2, 3, 3, 3.
Fuller scores buy longer readings, not more lenses.

**WHAT DEPENDED ON THIS.** Lens Practice D2's mapping arithmetic. Nothing else.

---

## C4-I — ordinals are assigned at filing and department-marked

**Founder-ruled 2026-09-08.** A drafting chat picks no number.

**Why.** Two departments both claimed BLOCK 4 in `where-we-stop.md` and neither
could see the other.

**WHAT DEPENDED ON THIS.** Every cross-reference in every append-only file in
this department. References must carry the ordinal and the department mark.

---

## C5-I — ownership of The Opening transferred to Head of Interpretation

**Ruled 2026-09-08**, on the closure of that chat.

**WHAT DEPENDED ON THIS.** Nothing else. Recorded so that proposed changes to
The Opening go to the right owner.

---

## C6-I — Framework v2 and Adaptive Scaffolding v1 replaced entirely

**Ruled 2026-09-08.** Replaced by Interpretation Framework v3 and Adaptive
Scaffolding v2. Not amended; replaced.

**⚠️ Noted at the time** `[RELAYED, Head of Technology, 2026-09-08]`: the
repository still held the superseded versions and the replacements were not in
main. **Superseded by C14-I** — there is no longer a repository, and the
project now holds the current versions.

**WHAT DEPENDED ON THIS.** Any chat citing v2 or v1 is reading the archive.
**One exception, deliberate:** audit log A1-I quotes framework v2 §4, because
the old rule is the *evidence* for what the journal contains. The archive is
legitimately read by the audit and by nobody else here.

---

## C7-I — a lens is a named tradition; the grounding check and the Recurrence engine are never counted as lenses

**Ruled 2026-09-09** by Head of Interpretation from Foundations §4.6, extended
by founder ruling the same day.

**Was:** lens count taken as every tradition token in a lens section, so
*Freudian / continuity* counted as two readings.
**Became:** the count of distinct **named traditions**. `Continuity` and
`Series` / `Recurrence` are never lenses, **whether stapled to a tradition or
standing under their own label.**

**Why.** Foundations §4.6: the grounding check "is not a lens — it answers why
is this dream here, not what does it mean — and it is never ranked among them."
Counting it as a reading counts something a governing document forbids counting.
This is not a competing definition; it was a rule being broken.

**The extension matters and was not in the original ruling.** Keeping only the
first half of a compound label fixes the stapled case and leaves the standalone
case — a bare `Continuity` label, or `Series / continuity` where the first half
is the engine. That is 4 further nights `[READ, audit log A7-I]`.

**Still open, bookkeeping only, and both options give the same number:** whether
the set-aside half is dropped or counted in a grounding-check column. Assigned
to Lens Practice. No filing waits on it.

**WHAT DEPENDED ON THIS.**
- The Opening §11's lens-count column, overstated by one on 11 of 15 nights. A
  block against The Opening is owed by Head of Interpretation. Audit log A7-I.
- The Opening §11.2's correlation figures, computed against that column and
  withdrawn in audit log A1-I.
- `lens-practice-tests-2026-09-08.py`'s `distinct` definition, which implements
  the stapled fix only.
- Lens Practice Test 1's "reduces on 12 of 15 nights", computed against the
  first-half column.

---

## C8-I — lenses are ordered by grounding; and the struck §3 clause returns

**Founder-ruled 2026-09-09, both parts. Reverses C1-I. C1-I is left as
written.**

**Part one.** The lenses a dreamer is shown are ordered by **grounding**, best
grounded first. Ordering by tradition age is overturned.

**The precision, without which this will be re-derived wrongly.** Foundations §3
splits fit in two: grounding is the app's, landing is the dreamer's, and the app
never has it. So the app orders by the half it is answerable for. **It cannot
order by how strongly a reading will land**, because it cannot know, and trying
would be the app guessing at the dreamer's own authority.

**Part two.** *"Fit is expressed in words and in order only"* **returns** to
Foundations §3. It was struck only because order carried no fit information, and
that reason is gone.

**The founder's own reasoning, recorded so it is not re-litigated:** readers
privilege the first item whatever we do, so the effect should serve the
best-grounded reading rather than the oldest tradition.

**Two costs, recorded so this is not read as free.**
1. **It can never be shown to be working.** Ordering by grounding is a model
   judgement, like the grounding check, which The Opening §11 already accepts as
   never validatable. The audit can record that an order was produced and what
   it was; it cannot say the order was right. Nobody should mistake a count of
   orderings for evidence they were well made.
2. **It reintroduces a dependency Wave 0 cannot test.** Tradition age needed
   nothing from The Opening. Grounding order does, and the priority metric is not
   testable against the frozen journal — the journal records associations as one
   paragraph a night, with no question turns and nothing attributing the
   dreamer's words to a named image `[READ]`. First observable in Wave 0.

**WHAT DEPENDED ON THIS.**
- Restores `product-principles.md` §5 — correct as written, no change needed.
- Restores `marking-and-what-we-watch.md`'s reason for marking while reading.
- Makes watch item **W7** answerable again: mark position against lens position.
- **Overturns Lens Practice D8′**, which ordered oldest tradition first.
  Re-derivation assigned to Lens Practice.

---

## C9-I — Test 4's tradition percentages withdrawn

**Ruled 2026-09-09** by Head of Interpretation.

**Was:** Adlerian 93%, Jungian 93%, Sufi 73%, and the same 73–93% range in Lens
Practice open item 2, which is these numbers.
**Became:** withdrawn in percentage form entirely.

**Why.** They rest on fit signatures that
`lens-practice-tests-2026-09-08.py` itself labels as written for that one test
and explicitly not Lens Register work, computed over one dreamer. They are the
most quotable numbers in the set and they measure a mapping invented to run a
test.

**What survives, qualitatively:** most nights meet the signals for most
traditions, so the signals alone cannot tell traditions apart — which is why
each lens file now carries its own question.

**WHAT DEPENDED ON THIS.** Lens Practice open item 2. Nothing in the audit log
was built on them.

---

## C10-I — the seventeen-tradition denominator withdrawn, not corrected

**Ruled 2026-09-09** by the founder.

**Was:** "eleven of seventeen traditions appear zero times", corrected once to
"nine of seventeen", and recomputed by this chat as "ten of seventeen".
**Became:** withdrawn. **No fraction over seventeen may be stated.**

**Why.** There was never a list of seventeen. The traditions came from a prompt
inside a chat, not from a document `[READ, from the founder, 2026-09-09]`.

**What replaces it:** seven named traditions appear anywhere in the fifteen
nights, and three carried almost everything `[READ]`. Audit log A4-I.

**WHAT DEPENDED ON THIS.** Every statement of that fraction, wherever it
appears. It is also a new error class — the wrong denominator, where the
arithmetic was correct three times over a number that never existed and no
recount could have caught it. Audit log A12-I, class 2.

---

## C11-I — deletion of a night cascades onto figures held about it

**Founder-ruled 2026-09-09.**

**Was:** unaddressed. An append-only log holding per-night figures derived from a
dreamer's material could not be reached by deletion.
**Became:** deletion cascades to held figures. **This log holds definitions,
commands and fingerprints. It holds actual values only for the frozen journal**,
which is the founder's own and offered as evidence.

**Why.** `privacy-ethics-safety.md` commits that deletion propagates to derived
data. Harmless in Wave 0, where the only dreamer is the founder. Binding from
Wave 1.

**And a new watch item, drafted by this chat at the founder's request.**
`W — UNNUMBERED, drafted 2026-09-09, Interpretation`. *The list currently runs
W1 to W16* `[READ]`; the ordinal is assigned by whoever files.

> **Why does a night get deleted?** To stop seeing it, or to have it not have
> happened. The two behave differently and matter differently.

**Observable:** that a deletion happened, when in the flow, how long after
capture, and whether before or after interpretation. Nothing about content.

**Not observable, at all: the reason.** Motive is not recoverable from behaviour,
and inferring it would be the app deciding who the dreamer has become — which
Foundations §4.4 forbids in the plainest language it uses anywhere.

**A permanent structural limit.** A deleted night is exactly what we can no
longer look at. The audit can count that a deletion occurred and can never study
what was deleted. Retaining enough to answer *why* would mean the deletion was
not real. **This watch item is bounded by the commitment that created it**, and
that is the right outcome rather than a gap to be closed later.

**Two costs.**
1. **Asking has a price.** The only route to a reason is an optional, skippable
   invitation at the moment of deletion — the app asking a dreamer to account for
   removing their own material, at the moment it should be most out of the way.
   **A deletion must never be conditioned on answering anything.** Dreamer-facing
   copy is founder-authored.
2. **The ego hypothesis is a reading, and of the dreamer rather than the dream.**
   Held as the founder's own view it costs nothing `[ASSUMED, founder,
   2026-09-09]`. Built into the instrument it costs a great deal, because an
   instrument built to find ego will find ego and nothing in this practice could
   contradict it. **It stays out of the measurement.**

   And one reason to delete that is not ego and would be badly misread as such:
   **protection.** A dreamer who dreamt of being harmed, or who fears someone
   else reading their phone, may delete for reasons that are simply sound. Our
   own commitment is that no friction goes onto accounts of harm `[READ]`. **A
   deletion is not an occasion to press.**

**Settled by:** deletion timing and position across many sessions, plus whatever
dreamers volunteer unprompted. **Never closed** by an inference about motive.

**WHAT DEPENDED ON THIS.** The audit log's own conventions — what it may
contain. `privacy-ethics-safety.md`'s deletion clause now has a named
consequence inside this department's own files.

---

## C12-I — RENAME: the engine is RECURRENCE; "continuity" means only the day-residue account

**Founder-ruled 2026-09-09.**

**Was:** one word for three unrelated things.
**Became:**

| Term | Meaning |
|---|---|
| **Recurrence** | the engine that tracks what returns across nights — motifs, figures, feeling-tone. The moat. |
| **Continuity** | only the account that says this dream was your day, processed. |
| **Series** | unchanged — the third scale, in the Foundations §5 sense. |

**Why.** The word produced a wrong figure four times, including inside the script
pair written to prevent it, on the same day, in the adjacent file. Audit log
Standing Note 1-I and A12-I.

**WHAT DEPENDED ON THIS.** Scan of every document in the project, this session
`[READ, 2026-09-09]`. **The fifth wrong figure will be a document that did not
take the rename.**

*Engine sense — must become Recurrence (7 uses, 4 documents):*

| Document | Uses | Note |
|---|---|---|
| `product-principles.md` | 2 — including the §2 heading *"The continuity engine* is *the product"* | **Law.** Highest priority; a section title now means something else. |
| `privacy-ethics-safety.md` | 2 — the `[P2]` phase annotation, and the fluency-signal clause | **Law.** |
| `interpretation-framework-v3.md` | 2 — "continuity recap"; the §"Continuity across dreams" heading | |
| `ui-ux-design.md` | 1 — "there is no continuity engine" | |

*Account sense — stays "continuity" (3 uses, 2 documents):* `the-foundations-draft-2.md`
×1 (quoting a journal label), `interpretation-framework-v3.md` ×2 (a journal
label; and the list of contemporary-research accounts).

*Owed, not yet split by sense:* `lens-practice.md`, 27 uses `[RELAYED — counted
mechanically, not read line by line]`. Assigned to Lens Practice.

*Not to be edited:* the **frozen journal**, 12 uses. Its labels predate the
rename; *Series / continuity* and *Jungian / series* there are the Recurrence
engine `[READ]`. Editing it would break every fingerprint in the audit log.

*Behaviour only:* the three scripts. The guard in
`lens-practice-check-2026-09-08.py` is named `ENGINE`; the name is now wrong and
the behaviour is right.

---

## C13-I — §4.4 challenged and upheld: the app remembers dream material, never the dreamer

**Founder-ruled 2026-09-09.** Foundations §4.4 unchanged.

**The challenge.** Whether the app should remember across sessions.

**The split, from Lens Practice:** remembering **dream material** — allowed, and
is the Recurrence engine — from remembering **the dreamer** — forbidden. The
first proceeds; the second does not.

**The reasoning, recorded so it is not re-litigated.** A learning loop can only
learn from what landed. What lands tracks prior belief rather than fit — Hill et
al. 2001; Morewedge & Norton 2009 `[RELAYED from Lens Practice; cited as they
cited]`. So an app that learns from a dreamer drifts toward flattery **by
construction**, not by poor implementation. That is the one thing this product is
defined against.

**WHAT DEPENDED ON THIS.** Nothing changes, because §4.4 stands. Had it gone the
other way: Lens Practice §4.2, §7 and §10, and the blind read's power to
discriminate at all.

---

## C14-I — the rebuild: what it withdraws, and what it converts

**Ruled 2026-09-09** by Head of Interpretation, via the founder. The app is being
rebuilt from first principles and **this department's documents are the
principles.**

**Withdrawn:**
- The paired-diff rule — that a framework change and the prompt change
  implementing it must land as one reviewed diff. There is no repository for
  them to land in.
- The Opening's status table as ruled on 2026-09-08.
- All messages to Head of Technology.

**Converted, unchanged in substance:** every "behaviour for Head of Technology"
section becomes a **requirement for the new build**. Interpretation still leads
and states behaviour, never implementation.

**And one defect becomes a requirement.** The earlier finding that disagreement
between traditions was unmeasurable in production — no database column, no client
payload, no log line — is no longer a bug in code we own. **The new build must
record which traditions were shown and whether they disagreed, measurable by
design.** Restated as audit log A9-I.

**WHAT DEPENDED ON THIS.** C6-I's note about the repository holding superseded
versions. Every routing convention in this department. And the closing condition
of the chat that wrote these two files — see C16-I.

---

## C15-I — governing status is a founder ruling recorded here, not a code commit

**Ruled 2026-09-09.**

**Was:** a document's status was tied to what was in the repository.
**Became:** a founder ruling, recorded in this file.

**Current status:** **The Opening** and **Lens Practice** are both *not yet
governing* until the founder says otherwise.

**WHAT DEPENDED ON THIS.** Every chat that reads either document must read it as
the current draft and propose changes to its owner rather than treating it as
law. And this file becomes the only place a document's status can be established.

---

## C16-I — what "filed" means

**Ruled 2026-09-09**, replacing the rule that only a commit reaching main counts.

**Was:** *"A document written to disk is not filed. Only a commit reaching main
is filed."*
**Became:** **filed** means handed to the founder with a sha256 hash, held in the
project, and the hash recorded in this file.

**And the convention that keeps the old rule's protection.** The risk that
produced it — three documents reported filed and untracked on one machine — has
not gone away. **The department's documents live in the project *and* in a
versioned backup the founder controls.**

**One honest limit, stated because it cannot be engineered away.** This file
cannot record its own hash. `audit-log.md`'s hash is recorded here on receipt;
this file's hash travels with the handover message and is recorded by the
founder. **A hash a document states about itself would be worthless, and a hash
nobody records is not a check.**

**WHAT DEPENDED ON THIS.** The closing condition of the chat that wrote these two
files: it closes when both are held in the project under this definition, with
hashes recorded. Not when they are written to disk.

---

## C17-I — Foundations §9: the seventeen-tradition denominator withdrawn and replaced with a counted figure

**Filed 2026-09-10.** *Drafted 2026-09-09 as `BLOCK UNNUMBERED` in
`archive/blocks-drafted-2026-09-09.md`, Check 2 site A. Ordinal assigned at filing.*

**Was.** *"Jungian appears in 15 of 15 entries, Adlerian in 15 of 15,
existential–phenomenological in 13 of 15… **Nine of the seventeen traditions then
admitted appear zero times.**"*

**Became.** Seven interpretive traditions appear anywhere in the fifteen entries —
Jungian 15, Adlerian 15, existential–phenomenological 13, Sufi 6, Freudian 5,
Biblical 2, Gestalt 1. Six further traditions searched for appear nowhere. **No
fraction is stated over a register, because no register existed.**

**Why.** The denominator was withdrawn, not corrected — C10-I. Seven agrees with the
earlier count of eight once the deflationary ruling is applied: continuity was the
eighth and is no longer a tradition.

**Replaced text archived verbatim** at
`archive/the-foundations-draft-2-replaced-2026-09-10.md`.

**WHAT DEPENDED ON THIS.** The withdrawn figure had three dependent sites, not the
one the 2026-09-08 dependency record named — see C24-I. Site two is C18-I below.
Site three is `head-of-interpretation-briefing.md` line 418, which is **not in this
repository** and is therefore **still uncorrected**; its replacement text is drafted
in the blocks file, FINDING 2, and is owed by whoever holds that document.

---

## C18-I — Foundations §10: the "seventeen traditions" row replaced

**Filed 2026-09-10.** *Drafted 2026-09-09, Check 2 site B. Ordinal assigned at filing.*

**Was.** `| Seventeen traditions in three families | A candidate list of roughly
25–30, with the *shamanic and animist* bucket split. §7.2 |`

**Became.** `| A prose list of traditions in three families, never totalled in the
document itself | A candidate list of roughly 25–30, derived from the lens files,
each carrying a status and a date. §7.2 |`

**Why.** Framework v2 was recovered and read. It contains three family lines totalling
17 entries, **and the figure "seventeen" appears nowhere in it.** The list existed and
the number never did: the seventeen was arithmetic performed in a chat over a prose
list and then treated as a register. Two of the 17 entries are buckets rather than
traditions, so the total was never stable enough to be a register even in principle —
Foundations §7.2 now forbids exactly that bucketing.

**Replaced text archived verbatim** at
`archive/the-foundations-draft-2-replaced-2026-09-10.md`.

**WHAT DEPENDED ON THIS.** Site B was drafted as dependent on confirming the archive
existed. That dependency is discharged two ways: the founder supplied v2 directly, and
v2 is now **archived in this repository** at `archive/interpretation-framework-v2.md`,
sha256 `1c1cbee126e7e661`. FINDING 1's open question is therefore closed — v3 line 8's
assertion that "v2's text is in the archive" is now **true**, where before this filing
it was a filed document asserting something unverified.

---

## C19-I — Framework v3 line 56: "continuity recap" → "recurrence recap"

**Filed 2026-09-10.** *Drafted 2026-09-09. Ordinal assigned at filing.*

**Was.** *"capture always precedes any motif surfacing or continuity recap"*
**Became.** *"…or recurrence recap"*

**Why.** Engine sense. C12-I: the engine is **Recurrence**; "continuity" now means only
the day-residue account.

**Replaced line archived verbatim** at
`archive/interpretation-framework-v3-replaced-2026-09-10.md`.

**WHAT DEPENDED ON THIS.** Nothing cites this line. It is one of the four v3 uses
audited in the blocks file; the other engine use is C20-I, and lines 157 and 306 are
the deflationary sense and are **deliberately unchanged**.

---

## C20-I — Framework v3 line 235: the ledger heading renamed

**Filed 2026-09-10.** *Drafted 2026-09-09. Ordinal assigned at filing.*

**Was.** `## Continuity across dreams — the ledger`
**Became.** `## Recurrence across dreams — the ledger`

**Why.** Engine sense, C12-I. A section title now means something else, which is the
case the rename exists for.

**Replaced line archived verbatim** at
`archive/interpretation-framework-v3-replaced-2026-09-10.md`.

**WHAT DEPENDED ON THIS.** Any cross-reference to v3 by this heading's old name. None
found in this repository `[READ 2026-09-10, grep across every file]`.

---

## C21-I — privacy-ethics-safety.md: both engine-sense uses renamed, after a full-document audit

**Filed 2026-09-10.** *Founder-ruled 2026-09-10.*

**How this was done, and it is the point of the block.** The filing instruction named
a header annotation "line ~180". **Those are two different sites and the line number
was wrong.** Head of Interpretation ruled 2026-09-10: *read the whole document, list
every use of "continuity" with its sense, change only the engine-sense uses, and do not
edit against any line number I gave.* That was done. **Every occurrence in the document
is listed below.** There are two. Both are the engine sense. Both were replaced.

| Line | Text | Sense | Action |
|---|---|---|---|
| 2 | header phase annotation, *"**[P2]** needs the continuity engine"* | **Engine** | Replaced → *Recurrence engine* |
| 180 | deletion-cascade bullet, *"nontrivial with the continuity engine"* | **Engine** | Replaced → *Recurrence engine* |

**There is no account-sense use in this document, no journal quotation and no
contemporary-research listing.** Nothing was touched that the rename forbids touching.

**A correction to C12-I's own dependency table, which is why the audit was ruled.**
C12-I describes this document's two uses as *"the `[P2]` phase annotation, and the
fluency-signal clause."* **There is no fluency-signal clause carrying the word.** The
phrase "fluency signals" appears inside the line-180 deletion-cascade bullet, so C12-I
was pointing at the right paragraph by the wrong feature. The table was right about the
count and wrong about the identification. Recorded rather than edited: C12-I is a dated
block and is left exactly as written.

**Replaced lines archived verbatim** at
`archive/privacy-ethics-safety-replaced-2026-09-10.md`.

**WHAT DEPENDED ON THIS.** The `[P2]` annotation is the key the whole document's phase
marks are read against, so every `[P2]` in it now resolves to the Recurrence engine.

---

## C22-I — ui-ux-design.md: the single engine-sense use renamed

**Filed 2026-09-10.** *Founder-ruled 2026-09-10. Same full-document method as C21-I.*

| Line | Text | Sense | Action |
|---|---|---|---|
| 313 | *"there is no continuity engine to make them meaningful"* | **Engine** | Replaced → *Recurrence engine* |

One occurrence in the document; no account sense, no journal quotation, no
contemporary-research listing. Agrees with C12-I's count of 1.

**Replaced line archived verbatim** at `archive/ui-ux-design-replaced-2026-09-10.md`.

**WHAT DEPENDED ON THIS.** Nothing cites this bullet by its wording.

**`product-principles.md` was NOT renamed, deliberately.** C12-I assigns it 2 engine-
sense uses including the §2 heading, and it is the highest-priority law document. It
enters this repository as **`restricted/product-principles-2026-06.md`, a dated
snapshot of the June 2026 text**. A dated archival snapshot is not edited — editing it
would destroy the thing it was filed to preserve. **The rename is therefore still owed
on the live `product-principles.md`, wherever that is maintained**, and the two sites
are the §2 heading and the implication paragraph at line 21.

---

## C23-I — THE FILING: the repository, what it holds, and the one artefact that did not survive it

**Filed 2026-09-10.** *This block is what "filed" means under C16-I: hashes recorded
here, documents held in the project, handed to the founder.*

**The repository.** `~/Developer/soul-dreams-docs` — lowercase, founder-ruled
2026-09-10, reached by a two-step rename because the filesystem is case-insensitive and
`Soul-Dreams-Docs` and `soul-dreams-docs` were **the same directory**, not two. Six
directories: `interpretation/ product/ organisation/ technology/ archive/ restricted/`,
plus `interpretation/lens-register/`. `git init` was run after the rename, never before.

**`restricted/` is versioned and never distributed.** It is in no `.gitignore` — it must
be under version control — and it is excluded from any shared export or kit. It holds the
two documents that carry the founder's own dream material.

### Hashes, sha256 first 16, verified at placement

**Supplied by the founder in the resume instruction — all twelve verified before
placement, none mismatched:**

| File | Hash |
|---|---|
| `interpretation/opening-check-2026-09-09.py` | `8000385a602fda33` |
| `interpretation/lens-register/lens-talmudic.md` | `c3b8dd4211747307` |
| `interpretation/lens-register/lens-islamic-tabir.md` | `f16a3fd1eaf78141` |
| `interpretation/lens-register/lens-sufi.md` | `43726a1518a0587c` |
| `interpretation/lens-register/lens-artemidorus.md` | `5b8fd5eb9a26ef48` |
| `interpretation/lens-register/lens-sami.md` | `8d8233cf332f1b62` |
| `interpretation/lens-register/lens-aboriginal-australian.md` | `fa373040e61bf9b2` |
| `interpretation/lens-register/lens-register-wave-2-handover.md` | `b9249e3853b4a14c` |
| `interpretation/lens-register/lens-register-findings.md` | `f76b862fefeed8cd` |
| `interpretation/lens-register/extract-fields-2026-09-10.py` | `6a14500f4877bd26` |
| `interpretation/lens-register/gate-tests-2026-09-10.py` | `f5cf06be7cf24c9a` |
| `interpretation/lens-register/sufi-nights-2026-09-10.py` | `dd7999604a5fbf8c` |

**Named with hashes in the original filing pass — all verified:**
`the-opening-draft-5.md` `68a486e566b20f9f` · `opening-research-2026-09-07.md`
`e548bee5605fc210` · `lens-practice.md` `4143264e4bd718c8` ·
`lens-practice-archive.md` `052aa555ec0d69a3` · `lens-practice-research-2026-09-08.md`
`bab7508a01480783` · `lens-practice-check-2026-09-08.py` `c49c603d01fcd331` ·
`lens-practice-tests-2026-09-08.py` `92e1b1f4ec87ac9b` ·
`transcript-pass-preregistration-2026-09-09.md` `f84900f7b1dd71d3` · `audit-log.md`
`c356124ac62c0a9c` · `markers_check.py` `26b64792159fe400` ·
`archive/interpretation-framework-v2.md` `1c1cbee126e7e661` ·
`archive/blocks-drafted-2026-09-09.md` `e7b9f7ef2b0e4740` · Wave 1 lens files
`7d05dc065ebdffd6` `58ec16a9abb70cba` `5f1544ee92f42e74` `37518cb1fe2e925c`
`dba3978fea42ce17`, handover `8c5489c6f457a522` · `adaptive-scaffolding.md` (v1)
`e99b338f` — **recovered, no "not recovered" note owed** · `product-principles-2026-06.md`
`a1a23c24f0168bc0`.

**Placed without a stated hash, so verified by nothing but their own content** — recorded
here so the gap is visible: `wave1-nights-2026-09-09.py` `62fb2c7cfa7d629c` ·
`extract-fields-2026-09-09.py` `af1c7da917e3fe31` · `gate-tests-2026-09-09.py`
`163a777268256cf9` · `organisation-project-handover.md` `7c3b9008fa90073f`.

**This file's own hash, as the founder states it: `64f603f2f6817e36`.** That is its hash
**before** the blocks C17-I to C24-I were appended; appending changes it, and the new hash
travels with this handover. C16-I's limit stands: this file cannot record its own hash.

### What moved, and why

- **`ui-ux-design.md`** — Interpretation → `product/`. It is a product document.
- **`dream-journal_14_07_2026_snapshot_.md`** — `interpretation/` → `restricted/`, so it
  can never enter a kit. The founder keeps a separate copy in the Interpretation project
  as its measurement artefact.
- **`product-principles.md`** → `restricted/product-principles-2026-06.md`. Confirmed as
  the June 2026 text by content, not by hash alone: it contains a person's name from the founder's material ⟦FM-001 · moved to restricted/ on 2026-10-03⟧ and the
  **graduation motif**, and the §2 heading *"The continuity engine is the product"*.
- **`opening-check-2026-09-07.py`** — the `interpretation/` copy removed as a byte-identical
  duplicate (`9f28144ace054d05`) of the archived one; the archive copy is the superseded
  record. **Moved aside, not deleted**, with the stray `transcript-pass-preregistrat.textClipping`
  — a 344-byte macOS clipping containing only a filename, superseded by the real document.

### ⚠️ THE FROZEN JOURNAL DID NOT SURVIVE, AND NOTHING IN THIS FILING REPAIRS IT

**The recovery archive `recovery-2026-09-10.zip` does not exist, and neither does
`MANIFEST-sha256-first16.txt`.** The recovered material was found loose in `~/Downloads`,
in duplicate, and was verified file-by-file against the hashes in the instruction instead.
**Three items the archive was said to contain were not among it: the frozen journal,
`SHARED-CORE.md`, and the old-build-report.** SHARED-CORE.md is therefore **not at the
repository root** and the original pass's step 1 is unsatisfied.

**The journal in `restricted/` is `80b1d2f67ccae7ed`. The frozen artefact is
`3a7d600a…19bb197`** — the fingerprint `markers_check.py` names as its own input at line
13, and the fingerprint every figure in audit log A1-I, A7-I and A8-I is stamped with.
**`3a7d600a` exists nowhere on this machine.** The founder's separate copy in
`~/Documents/Projects/My Dreams/` is byte-identical to the repository copy at `80b1d2f`,
with the same modification time — **both copies drifted together**, so there is no second
copy to restore from. The drift is not cosmetic: normalising the 177 trailing-whitespace
lines gives `b4ea8e11f1fc196f`, not the target.

**The modified copy was NOT discarded**, against the instruction to discard it, because
discarding it would have left no journal at all.

**What the gates say about it, which is the useful half.** Every figure in A1-I, A7-I and
A8-I reproduces exactly against `80b1d2f` — see C24-I. So no figure this department holds
is known to depend on the difference. **That is evidence of equivalence, not proof of it**:
the frozen artefact is still formally unrecovered, and a re-count claiming the `3a7d600a`
fingerprint may not be filed until it is.

**WHAT DEPENDED ON THIS.** Every figure in the audit log carries the `3a7d600a`
fingerprint. Until the artefact is recovered, that fingerprint names a file nobody holds,
and A1-I, A7-I and A8-I cannot be independently re-verified by anyone the department hands
them to — which is the whole purpose of stamping a figure with a fingerprint.

---

## C24-I — three conventions adopted at this filing, and the gate results they rest on

**Filed 2026-09-10.**

### 1. A dependency check covers drafts, not only filed documents

**Adopted.** The dependency record given on 2026-09-08 said the withdrawn seventeen-
tradition figure was *confined to The Foundations*. It was not: a third dependent site
existed in `head-of-interpretation-briefing.md` line 418. **The grep had covered the
project folder and not Interpretation's own drafts.**

**The error under the error, which is the part worth keeping: a dependency check has to
cover everything a claim was written into, not everything it currently governs.** A draft
about to become a filed document is exactly where a withdrawn figure survives.

**WHAT DEPENDED ON THIS.** C17-I's dependent-site list, and every future block's required
WHAT DEPENDED ON THIS field. This is the second mechanism in this file that catches a
*class* of error rather than an instance.

### 2. The Lens Register's "§7.6" is a section-reference error, corrected on re-cite

**Five Wave 1 files and the Wave 1 handover cite "Foundations §7.6, historical
standing"** — `lens-jungian.md` line 12, `lens-gestalt.md` lines 14 and 403,
`lens-freudian.md` line 23, `lens-adlerian.md` line 12,
`lens-existential-phenomenological.md` line 12, `lens-register-wave-1-handover.md`
lines 10, 240, 243, 245.

**There is no §7.6.** Foundations §7 has exactly two subsections, §7.1 (the anti-recency
rule) and §7.2 (two structural rules), and the phrase "historical standing" appears
nowhere in the document as a heading. **Historical standing is criterion 6 of the numbered
list inside §7.** The citation read a list item as a subsection number.

**This is the section-reference class** — audit log A12-I. It is a citation defect and not
a substantive one: the criterion exists, it says what the files say it says, and every
status ruling resting on it stands. **The correct citation is *Foundations §7, criterion 6
(historical standing)*.**

**Corrected on re-cite, not by editing the files** — which is also what convention 3
requires. No lens file was edited at this filing.

**WHAT DEPENDED ON THIS.** Nothing substantive. Every Wave 1 status of *candidate* rests on
the criterion, which is intact; only the pointer to it was wrong. The open question the
handover raises — whether the criterion needs amendment so that recent traditions are not
permanently barred — is Head of Interpretation's and is untouched by this correction.

### 3. Wave 2's Q7 ruling: corrections to handed-over files go to the findings file

**Founder-ruled, Wave 2 Q7.** A correction to an already-handed-over lens file is recorded
in **`interpretation/lens-register/lens-register-findings.md`**, and **never written into
the file itself.**

**Why it matters here.** It is the same shape as this file's own "never edit inside a dated
block": a handed-over artefact is a record of what was handed over, and editing it destroys
the evidence of what the receiver actually received. It is also what made convention 2's
handling automatic — the §7.6 defect was found in six handed-over files and not one of them
was touched.

**WHAT DEPENDED ON THIS.** Every future correction to a Wave 1 or Wave 2 lens file. The
§7.6 correction above is the first entry that belongs under it.

### The gates, run at this filing

| Gate | Result |
|---|---|
| `lens-register/gate-tests-2026-09-09.py` on Wave 1 | **T3 PASS, 5/5**, 12/12 sections in order in every file |
| `lens-register/gate-tests-2026-09-10.py` on Wave 2 | **T3 PASS, 6/6**, 12/12 sections in order in every file |
| `markers_check.py` on the journal | ran; **every figure in A1-I, A7-I and A8-I appears** |
| `lens-practice-tests-2026-09-08.py` on the journal | ran; **every figure in Lens Practice §12 appears** |
| `opening-check-2026-09-09.py` on the journal | ran; agrees with A7-I night for night |

**No figure in any of these documents is absent from its script's output.** Recorded
against the original pass's step 6, which asked for exactly that report.

**Both gate scripts glob a hardcoded `/home/claude/lens-*.md`.** They were run from staged
copies of each wave with that path redirected and **no other change**; the scripts as filed
are unmodified. The filed scripts' own SHA256 blocks independently re-printed all eleven
lens-file hashes, matching the founder's list exactly — a second verification the filer did
not perform.

**A defect in the Wave 1 gate script, resolved by choosing between two copies.** Two
divergent copies of `gate-tests-2026-09-09.py` were recovered and **no hash was ever stated
for it.** They differ by one line: the later copy excludes the handover from the
`lens-*.md` glob, with the comment *"the handover matches lens-\*.md and is not a lens
file."* **The later copy was filed**, because it is the one that yields the 5/5 the original
pass specified; the earlier would count six files. **Recorded because the choice was the
filer's and rested on no stated hash.** Note that `lens-register-findings.md` also matches
`lens-*.md` and is excluded by neither copy — a live defect in both gate scripts, owed to
Wave 3.

**`numpy` and `scipy` were installed into a throwaway virtual environment**, not into the
system interpreter, so `markers_check.py` could run. Nothing in the repository depends on
that environment.

**WHAT DEPENDED ON THIS.** The original pass's step 6, which is discharged by the table
above with the one standing exception recorded in C23-I: the journal these gates ran
against is `80b1d2f`, not the `3a7d600a` the figures are stamped with.
---

## C25-I — REVERSAL of C23-I: `restricted/` is not versioned at all, and was rewritten out of history

**Filed 2026-09-10. Founder-ruled 2026-09-10.** *This block reverses the
`restricted/` disposition recorded in C23-I. **C23-I is left exactly as written**,
per this file's own convention; read this block for the governing rule.*

**What C23-I got wrong.** It recorded `restricted/` as *"versioned and never
distributed"*, kept out of shared exports by a `.gitattributes` `export-ignore` rule,
and deliberately absent from `.gitignore`. **The mechanism does not do the job it was
added for.** `export-ignore` excludes a path from `git archive`. **It does not stop a
push.** Under C23-I's arrangement the founder's dream material would have been committed
and pushed to a code host in full, with a rule in the tree that reads as protection and
is not.

**This is the department's own recorded error class: a mechanism verified to exist
rather than verified to do the thing it was added for.** The filer checked that
`git archive` emitted zero restricted files and treated that as the control working. The
control was never tested against the operation that actually leaves the machine.

**The rule, replacing C23-I's.** `restricted/` is **excluded from version control
entirely**, by `.gitignore`. The files **stay on disk** at `restricted/`. **They are
backed up by the founder, separately, and never to a code host.**

**Why, stated so nobody later "fixes" the omission.** The restricted tier exists so this
material never enters anything shared with a collaborator. **A private organisation
repository that colleagues are granted access to is shared.** An empty `restricted/` in a
clone is the tier working, not a packaging bug. Both `.gitignore` and `.gitattributes`
carry this reason at the site, so it is answerable without finding this block.

**History was rewritten, not just untracked.** The material had already been committed
once. `git rm --cached` would have left it in the commit object and in every clone of it.
There was one commit and no remote, so the repository was re-initialised from the working
tree with the exclusion already in place — cheap at this moment and painful at any later
one. **Verified afterwards: no object in history contains the restricted material.**

**WHAT DEPENDED ON THIS.** C23-I's `restricted/` paragraph, which is superseded. C16-I's
definition of *filed* — the restricted material is filed by being held and hashed and
backed up by the founder, and is **not** filed by reaching a commit. And the manifest,
which is corrected in C26-I: **a listing of this repository is no longer a listing of the
department's documents.**

---

## C26-I — the manifest splits in two: what is in the repository, and what is local-only

**Filed 2026-09-10.** *Consequence of C25-I. Recorded because C23-I's hash list can now
be misread as a complete inventory, and it is not.*

**Local-only, present on disk, excluded from version control, backed up by the founder:**

| File | sha256 (first 16) |
|---|---|
| `restricted/dream-journal_14_07_2026_snapshot_.md` | `80b1d2f67ccae7ed` — **and see C23-I: this is not the frozen `3a7d600a` artefact** |
| `restricted/product-principles-2026-06.md` | `a1a23c24f0168bc0` |

**In the repository:** every other file recorded in C23-I, plus the four
`*-replaced-2026-09-10.md` archive files this pass created. Their hashes are in C23-I and
in the handover listing that accompanies this filing.

**So: a clone of this repository is not the department's full holdings**, and a manifest
generated from the repository must say so or it is a false inventory. The two files above
are the entire difference.

**WHAT DEPENDED ON THIS.** Any future statement of the form "the documents are filed,
here is the tree." That statement is now incomplete by design and must name the restricted
tier as held separately.

---

## C27-I — the findings ledger is append-only; its hash moves once per wave and may not be frozen

**Filed 2026-09-10. Founder-ruled 2026-09-10, Wave 2 Q8.**

**`interpretation/lens-register/lens-register-findings.md` is append-only by design.** It
is the destination for corrections to already-handed-over lens files (Wave 2 Q7, recorded
at C24-I convention 3), so **it is expected to change every wave** — that is the file
working, not drift.

**Therefore its hash must not be recorded in any frozen manifest as though it were
fixed.** The current hash travels in each wave's handover message instead.

**The hash recorded for it in C23-I, `f76b862fefeed8cd`, is the Wave 2 hand-over value and
is already provisional.** Wave 2 will hand over a new hash shortly, which **supersedes**
it. A later reader finding `f76b862f` in C23-I's table and treating a mismatch as
corruption would be reading a moving file as a frozen one.

**WHAT DEPENDED ON THIS.** C23-I's hash table, which carries this file among frozen
artefacts without distinguishing it. Every future filing manifest, which must exclude the
findings ledger from its frozen set or mark it explicitly as append-only. And the gate
defect recorded at C24-I — `lens-register-findings.md` matches the `lens-*.md` glob in
both gate scripts and is excluded by neither — which is the same file causing a second,
unrelated problem.
---

## C28-I — D17 RULED: grounding within one image is ordered, never graded

**Filed 2026-09-10. Founder-ruled.** *Recorded 2026-09-11. The delay between the ruling
and this block is itself the finding — see WHAT DEPENDED ON THIS.*

**The decision.** How grounding is graded when more than one tradition stands in front of
the same image.

**Ruled:**

- **Anchor before spill**, and then **a signal carrying no quality claim.**
- **No graded measure of how fully an account satisfies a tradition's conditions.**
- **Not the model's own grounding judgement as tiebreak.**

**Why the two exclusions matter more than the rule.** A graded measure of how fully an
account satisfies a tradition's conditions is a certainty value wearing different
clothes, and Foundations §3 rules those out permanently — *fit is expressed in words and
in order only*. Using the model's grounding judgement as the tiebreak would make the app
the authority on which tradition has the better claim on an image, which is the one thing
the ordering is built not to say.

**Evidence.** Lens Register **Wave 1 handover §2.2** — the traditions the app can verify
are not the traditions with the strongest claim, so any ordering that grades how fully an
account satisfies a tradition's conditions rewards verifiability rather than fit. **Wave 2
handover §2.1** — the same result reached again, stated as a rule by the sources
themselves, which the handover records as strengthening Wave 1's recommendation.

**WHAT DEPENDED ON THIS.**

- **`lens-practice.md` §7.3 still reads "D17 is open"** — at lines 19, 509, 1100 and 1137
  `[READ 2026-09-11]`. It is being re-derived in **Draft 6** and is not edited here;
  Draft 6 carries the correction.
- **The Interpretation project instructions still read "D17 open."** Not in this
  repository; owed wherever they are held.
- **⚠️ Wave 2's and Wave 3's briefs stated D17 as RULED while it was unrecorded.** Two
  waves were briefed against a decision that existed only in the founder's ruling and in
  no filed document, so nothing the waves produced could be checked against it. **That is
  the error, and it was Head of Interpretation's.** It is the same shape as the error this
  file's required WHAT DEPENDED ON THIS field exists to catch — a ruling in one place
  silently governing documents that still read the other way — except that here the ruling
  was in no document at all. **A decision is ruled when it is recorded, not when it is
  said.**

---

## C29-I — the frozen journal is recovered; the drifted copy is discarded

**Filed 2026-09-11.** *Closes the failure recorded in C23-I.*

**The founder placed a verified copy at `restricted/dream-journal_14_07_2026_snapshot_.md`.
Verified before anything else was done with it:**

```
3a7d600a561597d0e878fd872e6941f7053a7442eac245bd81ae77f0419bb197
```

**This is the artefact.** It matches the fingerprint `markers_check.py` declares as its
input at line 13 — `3a7d600a…19bb197` — and the fingerprint every figure in audit log
A1-I, A7-I and A8-I is stamped with. **The audit log's fingerprint names a file the
department holds again.** The drifted `80b1d2f67ccae7ed` copy is discarded; it was
overwritten in place by the verified copy.

**Every figure reproduced against the drifted copy as well, and that is recorded
deliberately.** Re-run 2026-09-11 against the frozen artefact, the output of
`markers_check.py`, `lens-practice-tests-2026-09-08.py`,
`lens-practice-check-2026-09-08.py` and `opening-check-2026-09-09.py` is **identical, figure
for figure**, to the output the drifted copy gave on 2026-09-10 — signals (a)–(d) at 0.26,
0.19, 0.74, 0.23; the drop table at 0.61/0.51/0.47/0.41/0.38; both lens-count columns;
0.65 and 0.51 with their ranges; the withdrawn pair 0.69 and 0.49; 11 of 15 inflated
nights with every delta exactly −1; Test 1 at 11/15, 9/15, 8 cap, 3 score; 10 deflationary
nights, 7 absorbed, 3 own label.

**What that licenses and what it does not.** It is **equivalence in output, not identity
of bytes.** The two files differ; no figure this department holds distinguishes them. So
the 2026-09-10 gate run was not invalid, and no figure needs re-deriving — but the
equivalence was established *by running both*, and it is not a general licence to treat a
fingerprint mismatch as cosmetic. **The next mismatch is unverified until someone runs it.**

**⚠️ One copy is still drifted and it is the measurement artefact.** The founder's separate
copy at `~/Documents/Projects/My Dreams/dream-journal(14:07:2026snapshot).md` is still
`80b1d2f67ccae7ed` `[READ 2026-09-11]`. C23-I records that copy as the Interpretation
project's measurement artefact. **It is outside this repository and was not touched.** It
should be replaced with the verified copy, or it will be the next thing a figure is
computed against.

**WHAT DEPENDED ON THIS.** C23-I's standing exception, which is now closed for the
repository copy and open for the founder's. A1-I, A7-I and A8-I can be independently
re-verified by anyone the department hands them to, which was the purpose of stamping them.

---

## C30-I — SHARED-CORE.md and the old build report placed

**Filed 2026-09-11.** *Closes the second half of C23-I's missing-material note.*

| File | Hash | Verified |
|---|---|---|
| `SHARED-CORE.md` (repository root) | `dbaeed3034567709` | ✅ |
| `technology/old-build-report.md` | `ee7191ef8c493b34` | ✅ |

Both were absent from the 2026-09-10 recovery and are now supplied by the founder and
verified. **`SHARED-CORE.md` is at the repository root**, satisfying the original filing
pass's step 1, which stood unsatisfied. `technology/` now holds a document and is no
longer an empty directory kept by a placeholder.

**WHAT DEPENDED ON THIS.** The original pass's step 1 root placement, and C23-I's record
that three items were missing. **One of the three remains missing: nothing.** All three are
now held — the journal at C29-I, these two here.

---

## C31-I — the `product-principles.md` rename is MOOT and owed nowhere

**Filed 2026-09-11. Founder-ruled 2026-09-11.** *Discharges the outstanding item recorded
at C22-I.*

C22-I recorded the engine-sense rename as **still owed** on the live `product-principles.md`
at two sites: the §2 heading *"The continuity engine is the product"* and the implication
paragraph at line 21.

**It is owed nowhere.** The document is being **written fresh by Product & Design**, and
the only surviving copy of the old text is the dated snapshot
`restricted/product-principles-2026-06.md`, which is not edited because editing a dated
snapshot destroys what it was filed to preserve.

**So both sites are closed for opposite reasons and neither is an edit:** the new document
will not inherit the old wording, and the old document is an archival record of what the
June 2026 text said — **including that it called the engine "continuity", which is the
fact the snapshot exists to preserve.**

**WHAT DEPENDED ON THIS.** C22-I's closing paragraph and C12-I's rename table, which lists
`product-principles.md` as the highest-priority law document still carrying the engine
sense. **That table is now fully discharged**: framework v3 at C19-I/C20-I,
privacy-ethics-safety at C21-I, ui-ux-design at C22-I, product-principles here. No
engine-sense "continuity" is owed in any document this repository holds `[READ 2026-09-11]`.

---

## C32-I — `head-of-interpretation-briefing.md` is owed, and how its correction must be applied

**Filed 2026-09-11. Founder-ruled 2026-09-11.** *The file is not yet supplied; this block
records the disposition so it is not decided again at placement.*

**It is a dated record that has never been filed.** It belongs in `interpretation/` **as a
RECORD** — a document of what was briefed on its date, not a governing document.

**Its line-418 error is corrected as an appended dated block, never as an edit.** The
briefing says *"nine of seventeen traditions appear zero times, not eleven."* C17-I
withdrew that denominator. The replacement text is drafted in
`archive/blocks-drafted-2026-09-09.md`, FINDING 2.

**⚠️ THE REPLACEMENT IS APPLIED BY FINDING THE TEXT, NEVER BY LINE NUMBER.** "Line 418"
came from a **different copy of the document** than the one that will be supplied. The
method is: **search for "nine of seventeen" and replace the sentence containing it.** This
is the third time in this filing that a supplied line number pointed at the wrong place —
C21-I's privacy-ethics-safety sites and C17-I's §9 paragraph were the first two — and it is
now a standing method, not a one-off instruction.

**WHAT DEPENDED ON THIS.** C17-I's dependent-site list, which names this as the third site
and the only one still uncorrected. Until the file is placed and the block appended,
**C17-I's withdrawal is complete in two of three sites.**
---

## C33-I — the briefing is filed as a record, and C17-I's third dependent site is closed

**Filed 2026-09-11.** *Discharges C32-I and completes C17-I.*

**Placed** at `interpretation/head-of-interpretation-briefing.md`, sha256 as supplied
`3f5d0e18c9ba2d98`, **as a RECORD** — a dated account of what was briefed on its date, not
a governing document. No hash was stated for it in advance; the supplied value is recorded
here as received.

**The correction is an appended dated block. Nothing in the document above it was
edited.** Its own §7 lists, among the errors this department made, *"A paragraph was
rewritten instead of appended and lost its best sentence… **Append; do not rewrite.**"*
**Editing the sentence in place would have committed the exact error the document records
against itself**, which settles it more firmly than the convention alone does.

**The line number was wrong for the fourth time, and the text search found it
immediately.** The correction arrived addressed to **line 418**. **This document is 213
lines long.** The sentence is at **line 187**, located by searching for *"nine of
seventeen"*. The four wrong line numbers in this filing are now: privacy-ethics-safety's
two sites (C21-I), The Foundations §9 (C17-I, off by twenty), and this one (off by more
than the document's length). **Locating by text is no longer a fallback; it is the
method** — C32-I.

**What the appended block does.** Quotes the standing sentence verbatim, then states
C17-I's replacement as superseding it, with the reason the denominator was withdrawn
rather than corrected: framework v2 carries the prose list of seventeen entries and **the
figure "seventeen" appears nowhere in it**, and two of its entries are buckets that
Foundations §7.2 now forbids.

**WHAT DEPENDED ON THIS.** C17-I named three dependent sites for the withdrawn figure.
Two were closed on 2026-09-10 in The Foundations, at §9 (C17-I) and §10 (C18-I). **This is
the third and last. C17-I's withdrawal is now complete in every site it named**, and
C32-I's outstanding item is discharged.

**One thing this does not close.** The 2026-09-08 dependency record was wrong because it
searched the filed documents and not the drafts. **This document was found because it was
named in a draft**, not because a search found it. C24-I convention 1 states the rule;
**nothing yet enforces it**, and a fourth dependent site in an unfiled draft would be found
the same way — by someone remembering it.

---

## C34-I — THE FOUNDATIONS IS GOVERNING; the Technology header is removed and archived

**Filed 2026-09-12. Founder-ruled 2026-09-12.**

**The ruling, in the founder's words:** as governing as it can be at this moment; treated
as a real foundations document; open to improvement as the interpretation framework
develops. Governing status is a founder ruling recorded here, per C15-I — not a header
and not a commit.

**What this closes.** `the-foundations-draft-2.md` carried a twenty-line header added by
Technology reading "⚠️ DRAFT — NOT GOVERNING" `[READ 2026-09-12]`. It was added so code
sessions would not treat an unpromoted draft as law, which was a reasonable intent. But
it asserted the status of Interpretation's governing document from outside this
department, which is the act C15-I exists to prevent.

**It was also false in its second claim.** The header stated "the body below is
byte-for-byte as Interpretation drafted it… this header is the only addition." C17-I and
C18-I corrected §9 and §10 on 2026-09-09, after the 2026-09-08 filing the header cites
`[READ, diff, Register Read 2026-09-12]`.

**Disposition.** The header is removed. It was never part of the document, so this is not
an amendment to The Foundations. The removed text is archived verbatim at
`archive/foundations-technology-header-removed-2026-09-12.md`, because an assertion made
in this repository is part of the record.

**⚠️ ONE SITE REMAINS AND IS NOT CLOSED HERE.** The document's own subtitle line reads
"Draft 2 · 2026-09-05 · Interpretation · not yet governing." That is inside the body and
is now false. Changing it is an edit to The Foundations and requires a dated block from
both founders. It is routed to Foundation & Charter with the ordering block.

**WHAT DEPENDED ON THIS.** C15-I's governing-status list, which named The Opening and
Lens Practice and was silent on The Foundations. The Register Read's restriction on
proposing Foundations changes, which stands — but now on the correct grounds. And the
requirement that any future status claim about an Interpretation document is a founder
ruling recorded here, whatever any header says.

---

## C35-I — D17b: THE ORDER OF READINGS. Grounding where it separates, a seeded sequence where it does not

**Filed 2026-09-12. Founder-ruled 2026-09-12.** *Supersedes D17a as recorded at C28-I.*

**The problem.** D17 ruled anchor before spill, then a signal carrying no quality claim.
D17a made that signal oldest-tradition-first. The founder then caught that the signal
decided almost every order, and a fallback deciding everything is a principle — which
reinstated by tiebreak the oldest-first ordering he had overturned on 2026-09-09.

**Every candidate was then rejected, each for a stated reason, and the ruling rests on
that exhaustion rather than on the merits of a winner.** A graded measure of how fully an
account satisfies a tradition's conditions: a certainty value in other clothes, forbidden
by D17. The model's own grounding judgement: self-certification. Missing-premise or
decline status, proposed by Head of Interpretation and withdrawn: it sorts traditions by
what the app collects, which is the bias D17 exists to prevent, quantised rather than
cured — and it contradicts the rule that nothing may move a declining lens to the end.

**Ruled.**

- **Step 1, anchor before spill, stands.** Readings of the image the dreamer kept
  returning to precede readings of an image the session reached for. This is real
  grounding information and the dreamer authored it.
- **Step 2, within each group, a seeded arbitrary sequence.** Derived from the night's
  own identifier. Stable across languages, fixed at first render, reproducible for audit.
- **No position within a group carries any claim.**

**Why seeding rather than oldest-first.** Oldest-first is constant across nights, so a
dreamer who notices it sees a stable ranking and may read age as depth. A seeded order
varies, so a dreamer who goes looking for a pattern finds none and concludes correctly
that there is none. It is the only candidate that teaches the truth by its own behaviour
rather than by copy this department has forbidden.

**⚠️ THE LIMIT, STATED SO IT CAN BE WATCHED.** Seeding delivers unreadability WITHIN a
group and not ACROSS groups. On a spill night the readings above the fold are the
better-grounded ones, so a dreamer reading into first position there is reading something
true. The risk is not that they read something false — it is that they learn the rule on
spill nights and carry it to nights where it means nothing. **The Cohort 0 watch item is
therefore spill frequency, which has never been measured.**

**Founder's ruling on the underlying question:** order is PERMITTED to carry fit; it is
not REQUIRED to. A statement that order does not carry fit would be false, because step 1
carries grounding.

**WHAT DEPENDED ON THIS.** C28-I's D17a. Lens Practice's ordering section, replaced whole
in its closing pass at `bd4dd30e` and filed 2026-09-12. The date field in every lens file,
demoted from serving-gate to admission-gate. D21, which moves from declined to moot. The
seed itself, which is an instrument and whose failure is SILENT — a recomputed seed
renders every session normally while making every past order unreproducible. And two
sentences in The Foundations whose stated reasoning assumes position carries fit, routed
to Foundation & Charter as a dated block for both founders.

---

## C36-I — COHORT replaces the stage sense of WAVE

**Filed 2026-09-12. Founder-ruled 2026-09-12.**

**Ruled.** The stages of the app's life are **COHORT 0** — the founder alone, who wrote
the framework — then **COHORT 1**, the first people who did not write it, then **COHORT
2a** onward. **WAVE belongs to the lens register alone**: waves are groups of lens files.

**Why not "Wave" for both, which was proposed and rejected.** Lens Practice Draft 6 used
"Wave 0" for the founder-alone stage 23 times and "Wave 1/2/3" for lens register waves 35
times, in one document `[READ, counted 2026-09-12]`. The collision was already live. And
it could not be resolved by renaming the register's waves, because eleven handed-over lens
files and three handovers cite "Wave 1 handover §2.2" and similar, `lens-register-wave-1-
handover.md` is a permanent filename cited inside C28-I, and Wave 2 Q7 forbids editing
handed-over files. "Wave 1" will mean lens register Wave 1 in the record forever.

**Why "Cohort".** It is the standard term for a group of people in a release stage, so
Technology reads it without translation, and it collides with nothing in this repository.

**WHAT DEPENDED ON THIS.** The Interpretation project instructions, which named the stages
and are replaced by the founder. Lens Practice, renamed in its closing pass: 20 live sites
plus 1 in the archive's own prose; 5 occurrences inside quoted verbatim blocks stay wrong
on purpose, because correcting a quotation makes it a record of what we wish had been
written, and the archive says so in one line. The safety ruling, whose trigger is Cohort
1 and not any wave.

---

## C37-I — THE LEDGER'S CADENCE: C27-I was departed from, not applied. The error is Head of Interpretation's

**Filed 2026-09-12.** *Corrects a claim by Head of Interpretation that is recorded in a
filed document.*

**What I told Wave 3 on 2026-09-12:** that C27-I "does not cap the ledger at one move per
wave" and that "once per wave" was the wave's own paraphrase. **C27-I's heading reads:
"the findings ledger is append-only; its hash moves once per wave and may not be frozen"**
`[READ, change-record.md line 907, Register Read 2026-09-12]`. I read the body, formed a
view, and stated what the entry said without reading its title. **That is the
section-reference class — a relayed claim restated without checking it at its location —
and it is mine.**

**It is in a filed document.** W3-15 in the findings ledger records the claim, correctly
marked as relayed from me. The ledger is append-only and is not edited; this entry is the
correction and the Register Read's RR findings carry it forward.

**THE SUBSTANTIVE RULING STANDS, ON THE CORRECT GROUNDS.** W3-15 was appended as a second
move within one wave, because the mechanisation limit is an instrument-class finding and
those apply immediately, and parking it in a Wave 4 brief parks it in a wave that may not
exist. **That is a DEPARTURE from C27-I's stated cadence, knowingly made, not an
application of it.** The operative rule going forward: the ledger's hash moves per APPEND
and must never sit in a frozen manifest as fixed. The cadence sentence in C27-I is
descriptive of the expected rhythm and is not a cap.

**WHAT DEPENDED ON THIS.** C27-I's cadence sentence. W3-15's standing defect note, which
describes the paraphrase's fault as invention when it was omission. The Register Read's
RR-1 onward, which append outside any wave. And the general lesson, which is the one the
department already records fifteen times: **a Head routes, routing means restating, and a
restated claim without its mark is laundered into fact.** Sixteenth instance. Caught, as
every previous one was, by a worker chat reading the document.

---

## C38-I — C24-I's outstanding gate defect is answered by ledger W3-11

**Filed 2026-09-12.** *Discharges the item left open at C24-I.*

C24-I recorded that `lens-register-findings.md` matches the `lens-*.md` glob in both gate
scripts and is excluded by neither — a live defect in both, owed to Wave 3.

**W3-11 answers it**, together with Wave 3's Q10: the gate runs in a directory containing
lens files only, and the run condition is stated wherever a T3 result is published. Wave
3's T3 pass of 17 of 17 was run under that condition.

**The general form is what matters and it has now recurred twice more.** A glob written to
match a class of file will match anything named like one. The Register Read reported a
third instance against itself on 2026-09-12: `ls lens-*.md | grep -v '^lens-register-'`
returned 17 one day and 18 the next, with no error, because `lens-practice.md` had entered
the directory `[READ, self-reported]`. **Same command, same intent, different number, no
failure signal.**

**WHAT DEPENDED ON THIS.** C24-I's closing note. Every future count over the lens files,
which states the command that produced it and the condition it ran under. And the next
revision of the gate scripts, if any — not made now, because byte-identity of the gate
across waves is worth more than a fix to a defect that is recorded and worked around.


---

## C39-I — C34-I's removal claim was filed before the act; the act is now done

**Filed 2026-09-12.** *Corrects C34-I and the commit message of `4e1ab6f`, both of which
state the Technology header was removed and archived when it had not been.*

**What happened.** C34-I was written and filed on the same day the removal was instructed.
The removal command tested for a line beginning `# ⚠️ DRAFT`. The header is a blockquote —
every line begins `> ` — so the test matched nothing, the command printed *header already
gone*, and the commit proceeded. **A check that ran and reported success without doing
anything.** It is the department's third-class error: verified to run, not verified to
detect. Written by Head of Interpretation.

**So two filed records described a repository state that did not exist**, for the interval
between commit `4e1ab6f` and this entry. The header was removed at this filing; the removed
text is archived verbatim at `archive/foundations-technology-header-removed-2026-09-12.md`.

**The general rule this adds, which is narrower than "check your commands" and therefore
useful:** a change record entry describing a change to a file is written AFTER the change
is verified in the file, never in the same pass that instructs it. C34-I's substance — the
founder's ruling that The Foundations is governing — is unaffected and stands.

**WHAT DEPENDED ON THIS.** C34-I's disposition paragraph. The Foundation & Charter brief,
which attaches the document and would have attached it with the header still on. And the
self-description rule recorded in the findings ledger at RR-1, which now has a fourth
instance of a different shape: not a document describing itself, but a record describing a
document.


---

## C40-I — the frozen journal holds fifteen of sixteen entries; 2026-06-27 was written and never transferred

**Filed 2026-09-12.** *A fact about the evidence base every figure in this department is
measured against. No figure is withdrawn.*

**What was found.** The transcript set holds seventeen sessions; the frozen journal holds
fifteen entries. 2026-07-15 postdates the snapshot and is explained. **2026-06-27 sits
inside the journal's range and its entry is absent** `[READ, founder 2026-09-12: grep for
that date in the journal returns nothing]`.

**The entry was written.** The 2026-06-27 session's own journal-entry section is 824 words,
against 540 for the adjacent night `[READ, counted this session]`. It was produced and
never reached the journal. The journal was assembled by hand, entry by entry, after each
session; the founder identifies manual transfer as the likely cause and no other
explanation is proposed.

**WHAT THIS MEANS FOR EVERY FIGURE, STATED PRECISELY SO IT IS NOT OVERREAD.** Figures of the
form *X of 15* remain exactly true of the journal and nothing in the audit log is
withdrawn. What was false was an assumption nobody wrote down: that the journal was the
complete record of the practice for its period. **It is fifteen of sixteen.** The
denominator is correct for the artefact and was never correct for the practice.

**THE JOURNAL IS NOT EDITED.** It is frozen at `3a7d600a…19bb197` and every figure in
A1-I, A7-I and A8-I is stamped with that fingerprint. Adding the sixteenth entry changes
the hash and detaches every number in the department from its evidence. A sixteen-night
journal, if ever wanted, is a new artefact with its own fingerprint.

**WHAT DEPENDED ON THIS.** The transcript pass, which had proposed writing *no journal
counterpart* for 2026-06-27 — the true fact is *entry produced, never transferred*, and
that night is read in full. Any future statement that the journal is the practice's
complete record. And the recording protocol for Cohort 1, where an entry that exists in a
session and not in the journal must be impossible by construction rather than by care.


---

## C41-I — the journal's associations were composed after the readings, on every night

**Filed 2026-09-13.** *A fact about the evidence base, established structurally. No figure
is withdrawn and nothing in the app's design is at fault.*

**What was found.** In all seventeen session transcripts, the journal entry is composed
after the readings — section 5 follows section 4 with no exception `[READ, Transcript
Pass, positional, no prose read]`. The Associations and Charge notes fields were written
at the end of a session in which four or five traditions had already spoken.

**How much of that material the readings shaped is not knowable from here.** A word-level
check puts at least 17% of association vocabulary as first appearing inside the readings,
against a 42% baseline for app-composed text and 62% for a field that must derive from the
telling — twenty points apart, so the instrument discriminates weakly and the figures are
shapes, not quantities. **17% is a FLOOR, not an estimate**: a dreamer can agree with a
frame entirely in their own words and import no vocabulary at all, and nothing in the check
would see it.

**THE APP'S DESIGN IS NOT AT FAULT AND ALREADY FORBIDS THIS.** The Opening collects
image-anchored association in the opening, before any tradition speaks, and names this
exact harm in its own words — that a dreamer's associations stop being evidence about the
dream and become agreement with a frame. The mirror-back offers nothing precisely so that
what follows is still the dreamer's. **The journal inherited a defect the app does not
have.** This entry exists so that the two are never confused, in either direction.

**WHAT DEPENDED ON THIS.** Three of the four unresolved-image markers fire only on dreamer
statements, which live in the affected fields — so every marker figure in this department
rests partly on material the app had already shaped. None is withdrawn; all are softer than
they have been treated. The blind reference reading now in progress is the first to measure
how much.

**A HARD REQUIREMENT FOR COHORT 1, recorded so it is not loosened by convenience:**
association is captured before any lens is applied. Not as a preference and not as an
ordering suggestion — if it is ever collected after, the dreamer's own words are partly the
app's and no figure computed from them means what it says.

**AND ONE THING TO WATCH THAT IS NOT MEASURABLE HERE.** The share of association vocabulary
first appearing in the readings has a rising floor across the seventeen nights — five of the
first nine below 10%, none after 2026-07-04 below 24%. Seventeen numbers, and the Transcript
Pass correctly refused to call it a trend. **But a dreamer's language drifting toward the
app's over weeks is what §4.4 exists to prevent, arriving with no profile stored anywhere.**
Not a finding. A Cohort 1 watch item, and the sharpest argument yet for watching one.


---

## C41-I — the journal's associations were composed after the readings, on every night

**Filed 2026-09-13.** *A fact about the evidence base, established structurally. No figure
is withdrawn and nothing in the app's design is at fault.*

**What was found.** In all seventeen session transcripts, the journal entry is composed
after the readings — section 5 follows section 4 with no exception `[READ, Transcript
Pass, positional, no prose read]`. The Associations and Charge notes fields were written
at the end of a session in which four or five traditions had already spoken.

**How much of that material the readings shaped is not knowable from here.** A word-level
check puts at least 17% of association vocabulary as first appearing inside the readings,
against a 42% baseline for app-composed text and 62% for a field that must derive from the
telling — twenty points apart, so the instrument discriminates weakly and the figures are
shapes, not quantities. **17% is a FLOOR, not an estimate**: a dreamer can agree with a
frame entirely in their own words and import no vocabulary at all, and nothing in the check
would see it.

**THE APP'S DESIGN IS NOT AT FAULT AND ALREADY FORBIDS THIS.** The Opening collects
image-anchored association in the opening, before any tradition speaks, and names this
exact harm in its own words — that a dreamer's associations stop being evidence about the
dream and become agreement with a frame. The mirror-back offers nothing precisely so that
what follows is still the dreamer's. **The journal inherited a defect the app does not
have.** This entry exists so the two are never confused, in either direction.

**WHAT DEPENDED ON THIS.** Three of the four unresolved-image markers fire only on dreamer
statements, which live in the affected fields — so every marker figure in this department
rests partly on material the app had already shaped. None is withdrawn; all are softer than
they have been treated. The blind reference reading now in progress is the first to measure
how much.

**A HARD REQUIREMENT FOR COHORT 1, recorded so it is not loosened by convenience:**
association is captured before any lens is applied. Not a preference and not an ordering
suggestion — if it is ever collected after, the dreamer's own words are partly the app's and
no figure computed from them means what it says.

**AND ONE THING TO WATCH THAT IS NOT MEASURABLE HERE.** The share of association vocabulary
first appearing in the readings has a rising floor across the seventeen nights — five of the
first nine below 10%, none after 2026-07-04 below 24%. Seventeen numbers, and the Transcript
Pass correctly refused to call it a trend. **But a dreamer's language drifting toward the
app's over weeks is what §4.4 exists to prevent, arriving with no profile stored anywhere.**
Not a finding. A Cohort 1 watch item, and the sharpest argument yet for watching one.


---

## C42-I — the journal's dreamer-voice fields are app-composed prose; marker (c) is split in two

**Filed 2026-09-13.** *Supersedes C41-I's characterisation. C41-I is not edited; read this
block for the governing statement. No figure is withdrawn.*

**TWO CHATS FOUND THIS FROM OPPOSITE DIRECTIONS AND NEITHER COULD SEE THE OTHER.**

The Transcript Pass, measuring the transcripts: the journal's Associations and Charge-notes
fields share **2.2% of their five-word sequences** with anything the dreamer actually said —
3,065 sequences, seventeen nights, range 0.0% to 8.2%, four nights at 0.0% — against **59%
shared vocabulary** `[READ, fingerprint 45852cb9]`. The fields carry the session's words and
almost none of its sentences. **They are app-composed prose, written in the dreamer's first
person**, and on five nights labelled "Dreamer's own associations / reflections". One verified
instance at 2026-06-18: a charge note records as the dreamer's an observation that originated
in the app's own question turn.

The blind reference reading, measuring the journal and knowing none of the above: **marker
(c1) fires zero times in fifteen nights.** Charge is named six times and every one is
accounted for in the same sentence. Its words: *a field written after the readings have been
given is a field where nothing stays unaccounted for* `[READ, aaf27927]`.

**WHAT FOLLOWS.** Markers (b), (c1), (c2) and (d) fire only on dreamer statements, which live
in these fields. Every figure those markers produced across three waves was computed on the
app's summary of what a dreamer said.

**WHAT DOES NOT FOLLOW, and the Transcript Pass was right to refuse it.** Paraphrase is not
falsification. A faithful summary of the dreamer's answers would also score about 2% on
five-word sequences. **The words are the app's. This does not establish that the content is
wrong.** Separating those requires reading each entry against its own session and is not
within any current pass.

**MARKER (c) IS SPLIT, ruled 2026-09-13**, because its name and its written test fire on
different conditions and two independent readers found so from the text alone:

- **(c1) CHARGE WITHOUT ACCOUNT** — the dreamer names an image as strongest, or as staying
  with them, and cannot say why.
- **(c2) NO ASSOCIATION OFFERED** — the dreamer says outright the image has no association.

**EVERY EXISTING (c) FIGURE IN THIS DEPARTMENT IS NOW UNINTERPRETABLE RATHER THAN WRONG.** It
cannot be known which of the two tests produced it. This includes the ρ = +0.743 against dream
words recorded in The Opening §5.1 — the highest correlation the department holds, already on
watch, judged by one reader looking at fields now established as app-written.

**WHAT DEPENDED ON THIS.** Every marker figure in the audit log; the score that sets lens
count, whose inputs are these markers; The Opening §5.1's watch items; and the reference
reading at `aaf27927`, the first table produced under a specified instrument with every
judgement call declared.

**THE EVIDENCE BASE MOVES, PROSPECTIVELY ONLY.** The frozen journal remains the record of what
the old practice PRODUCED and stays frozen at `3a7d600a`; nothing is re-derived and no stamped
figure is withdrawn. **The seventeen session transcripts are the record of what the dreamer
SAID** — 78,617 words against the journal's 8,835, verbatim. No new figure about what a
dreamer gives is computed from the journal's dreamer-voice fields again.

**ONE MEASUREMENT OUTSTANDING AND IT DECIDES THE SCOPE.** Only Associations and Charge notes
were measured. The Dream field — where marker (a) fires and where all seventeen traditions'
account conditions are matched — was not. If it is also app-composed, the whole journal is app
prose and every T1 figure in the register rests on it. Commissioned 2026-09-13.


---

## C43-I — the Dream field is substantially the dreamer's; the damage stops at the associations

**Filed 2026-09-14.** *Answers the measurement C42-I left outstanding. Narrows C42-I; withdraws
nothing in it.*

**THE COMMISSIONED METHOD COULD NOT ANSWER THE QUESTION, AND THE CONTROL IS WHY.** Head of
Interpretation asked for the Dream field measured by five-word-sequence overlap, the method
that established the Associations finding. Run as asked it returns 0.5%. **The mirror-back — an
app condensation written from the telling alone, before any lens speaks — returns 0.4%**
`[READ, fingerprint 45852cb9]`. A faithful condensation and an invented one score identically,
because both are rewordings. The Transcript Pass ran the commissioned measure, recorded it, and
replaced it with one that survives rewording: each distinct content word classified by where it
first occurs in the same session.

**THE ANSWER.**

| field | traceable to the dreamer | app, pre-lens | app, post-lens | novel |
|---|---|---|---|---|
| **Dream** | **59%** | 22% | **9%** | 11% |
| Associations + Charge notes | 36% | 22% | 17% | 25% |
| *control — mirror-back* | *43%* | *21%* | *—* | *35%* |

**The Dream field is more traceable to the dreamer than a pre-lens condensation of his own
telling is.** The frozen journal is not app prose throughout. Marker (a) and all seventeen
traditions' account conditions matched against material that is substantially the dreamer's.
**The Associations and Charge notes are an outlier field, not the entry's character.**

**One night is reported rather than averaged away.** 2026-07-04 contributes 48 of the Dream
field's 75 post-lens words; across the other sixteen the share is 3.6%, on that night 38%.
Unexplained, and read in sequence rather than investigated out of order.

**WHERE IT MEETS THE BLIND READER.** (c1) reads the charge notes — the 36%-dreamer field. The
two instruments agree, and agree about that field specifically. **They do not between them
convict the entry.** The narrowing is the result.

**⚠️ A SECOND FINDING, SPECIFIC TO MARKER (a), RUNNING THE OPPOSITE WAY.** 16% of the Dream
field's content vocabulary first appears in the dreamer's ANSWERS rather than his telling. The
journal's dream account is the account **after questioning** — on some nights after twenty or
thirty questions. Marker (a) asks whether an account ends with its outcome unstated. **It is
being asked of an account that had up to thirty chances to be closed before it was written
down. Under a three-turn budget it will have three.** Not the contamination that was
commissioned, and not fixed by the Dream field being clean of the readings: it is the ASKING
closing the account the marker exists to find open. A fact about the material. Whether it is a
defect in (a) is The Opening's owner's to judge, and it bears directly on the budget ruling.

**TWO LIMITS FROM C42-I, NEITHER WITHDRAWN.** All of section 5 is app-WRITTEN — 0.5% of the
Dream field's phrasing is the dreamer's — so what differs between fields is where the CONTENT
came from, never who wrote the sentences. And vocabulary is not content: a frame adopted in the
dreamer's own words is invisible to this measure.

**WHAT DEPENDED ON THIS.** Every T1 figure in the register, which stands. Marker (a)'s standing,
which does not change but acquires a named confound. The question budget, now carrying evidence
from a second direction. And C42-I's outstanding measurement, which is discharged.

**THE REFERENCE READING IS REVISED** to `5eab2faa`, superseding `aaf27927`, held in
`restricted/`. It carries both vignette tie-breaks written out, a scene-level appendix, and a
self-corrected figure — the night count moves 9 to 11 under the opposite tie-break, not 9 to 13
as first relayed; the error is named in the document rather than replaced.


---

## C44-I — the distress apparatus is DEFERRED, not ruled out; and what replaces it

**Filed 2026-09-14. Founder-ruled 2026-09-14, routed through Core Commitments.** *Supersedes
parts of `privacy-ethics-safety.md`, which Interpretation owns. Recorded here because the ruling
governs this department's own law document and existed in no entry of ours — found by The Close
asking for the ordinal rather than accepting a brief.*

**The state, stated precisely because two readings of it lead to different designs.**

- **DEFERRED to Cohort 2 at the earliest, not ruled out:** the graded distress apparatus — the
  classifier, the three tiers, the holding register and its separate ending, the log-only
  meters. **Suspended with restoration reconsidered, never removed.** A design that assumes the
  question is closed forever is designing against this entry.
- **NEVER CUTTABLE, recorded as product rather than safety**, so that no future reading of the
  deferral can reach them: the discernment pass, the entry lock, friction at any strength.
- **NEVER CUTTABLE, recorded as not a mechanism:** static crisis resources reachable from the
  app at all times. **No classifier, no detection, nothing calling it.** The dreamer fetches
  them; nothing offers them.
- **REPLACING DETECTION:** every tester is told in writing, before recording anything, that the
  app does not detect distress and will not stop.
- **THE GATE:** nothing changes before or during Cohort 0, the founder alone. All of it binds at
  the first person who is not the founder — the clinical advisor and psychologist testers
  included.

**THE PRINCIPLE THAT GOVERNS ALL OF IT, founder-ruled and wider than the apparatus: THE LIMIT IS
ON PRESSING, NEVER ON HEARING.** The app never shies away from, or designs away from, a dreamer
opening up and being fully honest. An app that avoids hearing something has decided in advance
what a dreamer may bring. Deferring detection is consistent with this; designing to avoid
disclosure would not be.

**ONE DEFECT IN OUR OWN LAW DOCUMENT, FOUND WHILE ANSWERING THIS.** `privacy-ethics-safety.md`
§2's heading says friction operates on readings, closures and defenses and **never on the
person**. The enumeration beneath narrows it: limits 1, 2, 3 and 6 are each written in terms of
the discernment pass, while limit 4 is written app-wide. **A list that narrowed its own
heading.** One sentence restores the heading's scope to the limits below it. This is needed
because a question about waking life is being admitted BEFORE the discernment pass, so pressing
could occur where no limit currently reaches.

**TWO SWEDISH ITEMS LEAVE AND TWO ARRIVE.** The holding declaration and the holding-end
invitation go with the apparatus and return with it. **But the static crisis resources and the
tester disclosure must exist in Swedish, founder-written, before the first person who is not the
founder.** Net zero in count, different in shape, and the new two sit on the critical path where
the old two did not.

**WHAT DEPENDED ON THIS.** `privacy-ethics-safety.md`, which owes two renames on the same pass —
the app-stage sense of "Wave" to Cohort, and "continuity engine" to RECURRENCE. The Close, which
may not design an ending that assumes the question is permanently closed. And Core Commitments
§6, which was held pending this response.


---

## C45-I — nothing is released to Product until the ending is settled; the requirements split is refused

**Filed 2026-09-14. Founder-ruled 2026-09-14.** *Answers the proposal made to Organisation on
2026-09-13, which was carried into two briefs as established while it existed only in a message.
That was Head of Interpretation's error and The Close refused it correctly, by asking for the
ordinal.*

**RULED.** The Requirements List is NOT split. Nothing goes to Product & Design until the
ending is settled. The founder's reason, recorded in his words: it is still possible the opening
and the readings change slightly, and it is better to be accurate and slow than to move fast and
redo work.

**WHAT THE CLOSE FOUND THE SAME DAY, WHICH MAKES THE RULING LOAD-BEARING RATHER THAN CAUTIOUS.**
The ending is not an empty hole. `privacy-ethics-safety.md` §1 describes a full close — three to
five reflective questions, a MANDATORY charge-note question, a resolved / partly / resists
endings screen, an entry carrying the app's own invisible resolution read, and a resolution the
dreamer may set later `[READ, af7714e2]`. **Four of those five asks are founder-authored.** So
"the app asks for nothing new at the end" is not a description of the present design; it is a
proposed change removing five founder-authored asks, and must be ruled as a change.

**AND TWO NEEDS LAND IN THE READINGS HALF, NOT THE OPENING.** The half that was thought safe to
release is the one at risk:

- **The order as rendered must be retained as rendered.** C35-I names the seed's failure as
  SILENT — a recomputed seed renders every session normally while making every past order
  unreproducible. A dreamer returning to a night must see the order they saw. Not in the current
  requirements.
- **The grounding check is owned by nobody.** It runs below the readings, outside the ordered
  list, and asks the one waking-life question the opening is forbidden to ask. It sits in
  neither half cleanly.

**WHAT DEPENDED ON THIS.** Head of Organisation's sequencing, which was resting on the split.
The Close, which was briefed that its first deliverable decided whether Product waited — it no
longer does, and the question it asks is decided on merits rather than schedule. And the
standing instruction, restated because this is the second time in four days a Head has done it:
**a proposal does not become a decision by being repeated in a brief.**


---

## C46-I — C41-I appears twice under one ordinal; the second instance governs

**Filed 2026-09-14.** *A defect in this record, found by The Close reading it rather than
trusting it.*

**What happened.** The C41-I block was written by Head of Interpretation in two consecutive
messages and the founder ran both. Two texts now sit under one permanent ordinal, at the copy's
lines 1382 and 1428, both 46 lines `[READ, diff 2026-09-14]`. They differ in three phrasings —
"so that the two" against "so the two"; "Not as a preference and not as an ordering suggestion"
against "Not a preference and not an ordering suggestion"; and a line break — and in nothing of
substance. **No claim, figure, or dependency differs between them.**

**Disposition.** Neither is deleted. An append-only record does not become append-only-except-
for-mistakes. **The second instance governs**, as the later append, and any citation of C41-I
resolves to it. The first stands as a record of the duplication.

**The general form, which is the part worth keeping.** A drafting chat that re-sends a block it
has already sent creates a duplicate the moment the founder runs it, and nothing in the filing
routine catches two headings with one ordinal. Added to the listing command: `grep -oE "^## C[0-
9]+-[A-Z]" change-record.md | sort | uniq -d` must return nothing before any commit.

**WHAT DEPENDED ON THIS.** Every citation of C41-I, which now resolves to the second instance.
The listing command in the role block, which gains the duplicate check.


---

## C47-I — the tester disclosure specification is filed; the consent lives inside it

**Filed 2026-09-15.** *Discharges requirement 2 of Core Commitments' routing of 2026-09-14.*

**Placed** at `interpretation/tester-disclosure-specification.md`, commit `a7f90ce`, verified
from the repository by Head of Organisation this session `[RELAYED]`.

**Consent for stored gate classifications lives inside the disclosure, not beside it.** A
tester's distress classification is stored with nothing acting on it, so it is agreed to in
advance or it does not happen. You cannot honestly tell someone their sessions are classified
and stored without asking permission in the same breath — so they are one document by nature,
not by economy.

**⚠️ THE SPECIFICATION CORRECTS A FALSE SENTENCE HEAD OF INTERPRETATION HAD ALREADY SENT TO
ANOTHER DEPARTMENT.** The disclosure must never say the app does not detect distress. The gate
classifies every capture and every dreamer turn and records every firing; what is deferred is
the CONSEQUENCE, not the detection. A tester told nothing is watching, who later learns their
sessions were classified and stored, has been misled by us. Found by The Close reading the law
document rather than the brief that summarised it.

**WHAT DEPENDED ON THIS.** Core Commitments §6, which was held pending Interpretation's
response and is now closed. Head of Organisation's count of founder-written texts before the
first non-founder dreamer: **two, not three** — this disclosure and the always-reachable crisis
resources surface. Both are Cohort 1 blockers and both are the founders' to write, in each
language independently.


---

## C48-I — §2.3's scope stated; R7's authority corrected; the series question's home

**Filed 2026-09-15. Founder-ruled 2026-09-15.** *Three corrections arising from The Close's
design work, none of which changes a rule. Two are citation defects by Head of Interpretation.*

**1. THE OPENING §2.3 GOVERNS THE APP ARRANGING, NOT THE APP FOLLOWING.** §2.3 rules that the
mirror may not say how dreams relate, because *placement, movement, what was put beside what —
the night's arc — is a conclusion*. That was written for the mirror-back, BEFORE the dreamer
has spoken, where any arrangement is the app's own. **In the close, the dreamer has already put
something beside something by writing it in the space, and the app follows their arrangement
rather than making one.** §2.3 stands unchanged and does not reach the reflection. Recorded at
the founder's instruction so it is not misread later as forbidding the reflection entirely; a
pointer is owed in The Opening.

**2. ⚠️ FOUNDATIONS §4.4 WAS CITED FOR A RULE IT DOES NOT CONTAIN AND ARGUES AGAINST.** Head of
Interpretation wrote that §4.4 permits knowing something tonight and forbids carrying it
forward. **§4.4 verbatim says the opposite about material:** *the series is material; it is not
a profile. The app may know that a motif returned and bring it as a question.* §4.4 governs how
a session is READ — no familiarity, no depth earned over time, a tenth session read exactly as a
first — and forbids a PROFILE, meaning the app adjusting how far it presses on the basis of who
it has decided the dreamer has become.

**The rule stands; its authority changes.** That the reflection space feeds nothing across
nights rests on **C41-I** — material written after four traditions have spoken is partly the
app's, and no figure computed from it means what it says — and on **the promise made to the
dreamer**, which binds by having been said. §4.4 is cited only for the pass it genuinely gives:
nothing in the reflection adjusts how far the app presses, and a tenth session is read as a
first. Found by The Close, which refused to write a hard requirement on a section it had not
read.

**3. THE SERIES QUESTION'S HOME, RULED.** §4.4 permits the app to bring a returned motif as a
question; The Opening §10 places it after the lenses; after the lenses is The Close's territory;
and recurrence was ruled not The Close's work. The one thing The Foundations positively permits
about what returns across nights was therefore owned by nobody. **Ruled: THE CLOSE OWNS THE
SLOT, RECURRENCE OWNS WHAT FILLS IT** — the same split already made for the grounding check,
whose form is Lens Practice's and whose behaviour is The Close's. The Close specifies the moment
and its constraints: one tradition's voice and never the app's, a question and never an
announcement, empty on a first night. It does not write the question.

**WHAT DEPENDED ON THIS.** The Close's document, which carries a named, bounded gap rather than
an absence — a settled design, not an unsettled one. **And the sequencing: Recurrence & the
Series may need to open before Product receives final wording rather than after.** Raised twice
by The Close before it was ruled, which is Head of Interpretation's failure to route.


---

## C49-I — C44-I's disclosure line is false; statuses are internal and never shown

**Filed 2026-09-15.** *Two items. The first corrects this record; the second is founder-ruled.*

**1. ⚠️ C44-I CARRIES A SENTENCE THAT IS FALSE AND MUST NOT BE BUILT FROM.** Its fifth bullet
reads *every tester is told in writing, before recording anything, that the app does not detect
distress and will not stop.* **The app detects.** The gate classifies every capture and every
dreamer turn and records every firing; what is deferred is the CONSEQUENCE. The correction was
established the same day, written into
`interpretation/tester-disclosure-specification.md` and recorded at C47-I — and never carried
back to the entry that holds the original. C44-I is not edited. **Read C47-I and the
specification for what the disclosure must say; C44-I's bullet is superseded and is retained
only as the record of what was ruled before the correction.**

Everything else in C44-I stands, including the principle that governs it: the limit is on
pressing, never on hearing.

**The general form, third instance this week: a correction made in one place and not carried to
the place that holds the original.** C41-I's duplicate, C43-I's narrowing of C42-I, and now
this. A correction is not complete until every entry that states the corrected claim points at
it.

**2. SESSION STATUSES ARE THE APP'S AND ARE NEVER SHOWN TO THE DREAMER. Founder-ruled
2026-09-15.** RECORDED, OPEN and ENTERED are internal states. They are not badges, labels, or
anything a dreamer sees on a night.

**Why, and it reverses a ruling of the same day made on Head of Interpretation's
recommendation.** OPEN sitting beside ENTERED in a list of nights says *this one is not done*.
RECORDED is permanent for a capture-only night, which would make the journal a visible ledger of
which nights the dreamer did properly — directly against the ruling that a capture-only night is
a whole use of the app. And OPEN exists for under a day and then never again; a state that
transient is not information anyone needs carried on a night forever. **A status informs; it
never grades. Shown to a dreamer, these grade by adjacency.** Found by The Close.

**What the dreamer needs instead:** whether the app will still respond here, said at the space,
in the moment, and not carried on the night afterwards.

**WHAT DEPENDED ON THIS.** The Close's document. And the earlier ruling of 2026-09-15 that the
three statuses would be shown, which is superseded.


---

## C50-I — the close is unaided from Cohort 1; C44-I's stated reason corrected; "discernment" keeps one meaning

**Filed 2026-09-15.** *Three items, all found by The Close reading C44-I after it was pasted to
it. Two are Head of Interpretation's errors.*

**1. FROM COHORT 1 THERE IS NO REGISTER THAT CATCHES ANYONE, AND THE ENDING MUST BE DESIGNED
KNOWING IT.** C44-I defers the holding register and its separate ending with the rest of the
apparatus, to Cohort 2 at the earliest, binding at the first person who is not the founder.
**So from Cohort 1, every dreamer in every state receives the full close, the space and three
reflections.** The drop-to-holding branch has nothing to drop to.

This is consistent with the founder's rulings and is not an argument for restoring detection. It
is recorded so that **every rule in The Close's document is marked where it is
cohort-conditional**, and so that no builder implements a branch to nowhere. The rule accepted
on 2026-09-14 — that the reflection does not run in the holding register — is live for Cohort 0
and dormant from Cohort 1 until the apparatus returns.

**2. ⚠️ A SPECIFIC GAP THE REFLECTION OPENS, AND THE STRUCTURE THAT CLOSES MOST OF IT.** The
space is the only surface where a dreamer writes about present life rather than a dream. The
reflection sets what is written beside a span from the night. A plain present statement —
about a person, a loss, something being done to them — would be quoted verbatim and paired with
a dream image: **a live fact read as an image**, which `privacy-ethics-safety.md` §1 names the
worse of the two mirror mistakes, arriving with no lens, at the last turn, in the app's own
voice.

**And no limit reaches it.** §2's limits 1, 2, 3 and 6 are each written as binding the
discernment pass. The reflection is not the pass.

**RULED: THE ANCHOR REQUIREMENT IS STRICT AND THE EMPTY CASE IS A SAFETY STRUCTURE, NOT AN EDGE
CASE.** A connection requires a real verbatim tie between what the dreamer wrote and something
in the night. Present-life material with no tie to the dream emits nothing, by construction — no
detection, no classifier, no judgement about content. The empty-case line is load-bearing and
its threshold is a design decision.

**⚠️ ONE CASE THE STRUCTURE DOES NOT CLOSE, ROUTED TO THE FOUNDER.** A dreamer writes about a
real person and the dream contains that person. The tie is genuine; the pairing is still a live
fact beside a dream image. Raised before Cohort 1 rather than found in it.

**3. C44-I'S STATED REASON FOR THE §2 HEADING FIX IS WRONG; THE FIX STANDS.** C44-I says the fix
is needed because a waking-life question is being admitted BEFORE the discernment pass. **The
Opening's ruling D5 moves the day-context question to the grounding check, after the readings,
and the pipeline runs gate → interpret → prosecute → entry, so the pass is upstream of the
readings.** The gap is real and runs the other way: it is AFTER the pass, where the grounding
check and the whole of the ending sit. Head of Interpretation's error. C44-I is not edited; this
block carries the correct reason.

**4. "DISCERNMENT" KEEPS ONE MEANING. Ruled.** The DISCERNMENT PASS is the app pressing on a
comfortable reading, inside the readings, and is never-cuttable per C44-I. Head of
Interpretation then wrote that "discernment is what the dreamer does in the space" — same word,
opposite agents, both permanent. **The pass keeps the word. The dreamer's side gets no term at
all**, and is described in words every time. A second term invites a third meaning, which is the
failure the role block records.

**WHAT DEPENDED ON THIS.** The Close's document, which marks cohort-conditional rules and
specifies the anchor threshold as a safety decision. `privacy-ethics-safety.md`, whose §2
heading fix now has its correct reason. And three items on the Requirements List's critical path
that belong to no chat: the two founder-written Swedish texts, the §2 heading fix, and the law
document's two renames.


---

## C51-I — detection runs, consequence is deferred; the reflection may pair a live fact with a dream image

**Filed 2026-09-15. Founder-ruled 2026-09-15.** *Resolves an ambiguity in C44-I and answers the
case The Close routed upward at C50-I. Narrows C50-I item 2; withdraws nothing.*

**1. THE LINE IS DETECTION AGAINST CONSEQUENCE, NOT CLASSIFIER AGAINST NO CLASSIFIER.** C44-I's
deferral list names *the classifier* and *the log-only meters* alongside the tiers and the
holding register, while `privacy-ethics-safety.md` §1 records the gate classifying every capture
and every dreamer turn and recording every firing, and C47-I's disclosure specification tells
testers exactly that. **Those could not both be true.** Ruled:

- **DETECTION RUNS** — classification and recording, from Cohort 0 onward, log-only, with
  nothing acting on it. The founder's reason: it is worth having so we can measure how often it
  fires, and any later decision about building the apparatus should rest on that number.
- **CONSEQUENCE IS DEFERRED** — the tiers, the holding register, its separate ending, and
  anything a dreamer experiences. Unchanged from C44-I.

**This makes the tester disclosure honest rather than contradictory**: classifications are
stored, so consent for storing them is required, which is Core Commitments' precondition and
lives inside the disclosure (C47-I).

**2. THE REFLECTION MAY PAIR A LIVE FACT WITH A DREAM IMAGE. Founder-ruled.** C50-I routed the
case upward: a dreamer writes about a real person and the dream contains that person, so the
quotation structure will set a present-life statement beside a dream image.

**Ruled that it proceeds, and the reasoning is the founder's.** The rule this appeared to
breach — that a live fact read as an image is the worse mirror mistake — was written for an app
that interprets. **Under the quotation structure the app cannot say what a pairing means.** It
sets two of the dreamer's own sentences beside each other with joining words bounded to location
and sequence. The harmful form is structurally impossible.

The founder's wider position, recorded because it governs more than this case: **the app never
tells anyone what to do or how to act**, that is designed in rather than policed, and **a
dreamer who wants to bring their most intimate fears and thoughts should be allowed to.** An app
that designs away from disclosure has decided in advance what a dreamer may bring — the
principle already recorded at C44-I.

**⚠️ THE RESIDUAL, STATED SO IT IS NOT MISTAKEN FOR SOLVED: THE APP CANNOT STOP, BECAUSE IT
DOES NOT KNOW.** A person told something serious changes what they do next. The app will emit a
connection or emit nothing, and both are mechanical. This is not fixable without consequence-
bearing detection, which is deferred for good reasons. **It is answered by telling people the
truth rather than by a mechanism**, and by measuring how often the situation arises.

**3. THE ANCHOR REQUIREMENT IS STRICT, AND ITS REASON IS QUALITY, NOT SAFETY.** C50-I recorded
the strict anchor as a safety structure. **That framing is withdrawn.** The anchor is strict
because a loose one manufactures connections, and a manufactured connection reads exactly like a
real one. It happens also to produce silence where present-life material has no tie to the
dream, and that is a consequence rather than its purpose.

**Why the distinction is kept:** a rule filed as the department's safety structure becomes
something the department leans on without understanding, and the first person who loosens it for
fluency will not know what they have loosened. Safety here is onboarding, the absence of
direction by construction, and measurement.

**4. ONBOARDING STATES WHAT THE APP IS NOT FOR. Founder-ruled.** Dreamers are told plainly, at
onboarding, that this is not therapy and that there are things the app is not meant to hold.
**For Cohort 1 this lives inside the tester disclosure** — the same document that already states
what the app will not do — and adds no fourth founder-written text. For later cohorts it is
onboarding copy, founder-written, batched to Product & Design's Copy Register.

**WHAT DEPENDED ON THIS.** C44-I's deferral list, whose classifier and log-only entries are
read under item 1. C50-I item 2's framing of the empty case. The tester disclosure
specification, which gains the onboarding requirement. The Close's document. And Head of
Organisation's count of founder-written texts, which stays at two.


---

## C52-I — The Close, draft 2, filed; C46-I's duplicate check corrected

**Filed 2026-09-15.** *Two items.*

**1. THE CLOSE, DRAFT 2, IS FILED** at `interpretation/the-close-draft-2.md`, sha256
`97cd075afeffd075`, 725 lines. Draft 1 at `8f4d061a74558496` goes to `archive/` intact —
replacement, never layering. **This is the document the ending is designed in**, and the last
piece before the Requirements List can be written whole (C45-I).

Founder-ruled on its five questions, 2026-09-15: the asking IS shown in the mirror; the
clarifying questions are NOT; the promise persists while the dreamer writes and only the
permission vanishes; the capture-only night's window opens on first write; **the holding
register has no space** — the invitation that already ends a holding session does that work, is
said once, makes *no* the easiest answer, and is founder-authored.

**⚠️ THE COUNT OF FOUNDER-WRITTEN LINES IS SIX, OR SEVEN IF FOUNDATIONS ITEM 4 LANDS AS (a′).**
Head of Interpretation relayed "no seventh line", which was a miscount rather than a ruling —
the holding-register line was never among them. **The conditional seventh is the waking-life
invitation, which is the only question the app asks after the readings.** Recorded because a
count carried in a message and a count in a document diverging is how a copy register ends up
short by one, and this is the one it would be short of.

**2. C46-I's DUPLICATE CHECK CAN NEVER PASS, AND IS CORRECTED HERE.** C46-I added
`grep -oE "^## C[0-9]+-[A-Z]" change-record.md | sort | uniq -d` to the filing routine, and also
ruled that neither instance of C41-I is deleted. **So the check returns `## C41-I` permanently.**
A check that always reports a failure is read for a week and ignored after, and the next genuine
duplicate arrives under a light nobody looks at. Found by The Close running it.

**The corrected check, which excludes the known duplicate by name so that anything it returns is
real:**
grep -oE "^## C[0-9]+-[A-Z]" interpretation/change-record.md
| sort | uniq -d | grep -v '^## C41-I$'

**WHAT DEPENDED ON THIS.** C46-I's remedy paragraph. The filing routine. The Requirements List,
which waits on this document and on Recurrence's. And Product & Design's Copy Register, which
receives six or seven lines from this department's ending and must not receive "seven" as a flat
number.


---

## C53-I — C52-I's copy of the corrected check lost its line continuation

**Filed 2026-09-15.** *Cosmetic correction to C52-I. The check itself is unchanged and was
verified working at that filing.*

**What happened.** C52-I's corrected duplicate-ordinal check was written across two lines with a
backslash continuation inside a fenced block. The fence and the backslash did not survive the
heredoc that appended the entry, so the command now sits in C52-I as two bare lines, the second
beginning with a pipe. **Copied from the entry as it stands, it fails.** The entry that fixes a
broken check carries a broken copy of the fixed check.

**The check, stated as one line and as prose so that no shell character has to survive a future
append.** Take every change-record heading matching the ordinal pattern, sort them, keep only
values appearing more than once, and exclude the known permanent duplicate C41-I. On one line:

    grep -oE "^## C[0-9]+-[A-Z]" interpretation/change-record.md | sort | uniq -d | grep -v "C41-I"

Run before any commit that appends to this record. Anything it returns is a real duplicate. It
returned clean at C52-I's filing and at this one.

**The general form, and it is the filing routine's rather than the record's.** A change-record
entry containing a shell command is a filing hazard: backticks, fences, backslashes and pipes
each have to survive being written by a shell into a file. **Entries describe commands in words
and give them as a single indented line.** Third mechanism this week that produced a failure of
its own — C46-I's check could never pass, C50-I's correcting entry was filed against a stated
reason that was backwards, and now this.

**WHAT DEPENDED ON THIS.** C52-I item 2, whose command text is superseded by the line above.
C46-I's remedy paragraph, already superseded. And the filing routine, which gains the rule that
entries carry no fenced blocks.


---

## C54-I — the series question cannot be asked; the speaker rule ruled; the readable set closed

**Filed 2026-09-15. Founder-ruled 2026-09-15.** *Three items. Both worker chats closed by
reporting defects in their own filed work.*

**1. NO LENS FILE CAN DECLARE AN ACCOUNT OF RETURN, BECAUSE THE FIELD DOES NOT EXIST.** Lens
Practice §11 lists twelve items a lens file must contain. Item 10 declares whether a tradition
has an account of a NIGHT — relations between dreams in one sitting — and gates §9. **There is
no item for whether a tradition has an account of what returns ACROSS separate nights** `[READ,
Recurrence & the Series, lens-practice 0f074dae]`.

So the count of files declaring such an account is **zero by construction**, and would be zero
if every file were perfect. Read from the template rather than counted from the files, which is
why it is a structural finding rather than a low number.

**CONSEQUENCE: the series question is silent on every night, in every cohort**, until the
specification gains an item and the seventeen files are re-read against it. The Close's filed
constraint 6 records this as *empty on a first night* — an edge case where it is the permanent
state. **The night's arc is unaffected and can run today**, because §11.10 exists and its
capability filter works. Recurrence owns two slots: one operable, one not.

**RULED: the specification item is added and applied as a focused pass, not a wave.** The
register stays closed at three waves. One chat, one question per file, no new traditions.

**What the item must do, so that it does not admit everyone:** ask whether the tradition has an
account of an image RETURNING TO A DREAMER ACROSS SEPARATE NIGHTS, in its own sources. A
tradition that merely says dreams may be read in groups does not qualify. Nearly every tradition
says something adjacent; few hold the account.

**2. WHO SPEAKS THE SERIES QUESTION — RULED, AND NO SHAPE WAS RULED BEFORE.** C48-I item 3 lists
the slot's constraints and **the seeded arbitrary choice is not among them** `[READ, both chats
independently]`. C35-I rules the order of readings within groups and contains no instance of
*series*, *speaker* or *spoken*. The Close's filed §6 constraint 3 cites C35-I for a rule C35-I
does not contain.

**Ruled: the series question is spoken by a lens selected from tonight's lenses whose file
declares an account of return, seeded only to break ties.** Selection by the tradition's own
competence, not by fit to the dreamer, so C35-I's concern is not engaged. **Attribution failure
is worse than any position effect** — a seeded choice across all traditions would put a claim
about recurrence into the mouth of a tradition that does not hold one.

**The error's origin is Head of Interpretation's**, in Recurrence's brief, where an ordering
ruling was extended into a selection ruling. The Close had already filed it by the time
Recurrence caught it. **The Close named the shape of the error itself: it is the same move C35-I
was written to reverse, one scale over.**

**3. THE READABLE SET IS CLOSED.** Nineteen candidates — The Opening §6's eight and The Close
§7.1B's eleven. Three admitted, one admitted as a filter, fifteen excluded, each with a stated
reason `[READ, Recurrence & the Series]`. **The line, in one sentence: a later night reads only
what the dreamer said before the app said anything.**

**Two exclusions with named costs, both accepted.** Return-and-emphasis is given up, so **every
appearance counts the same** — weighting by emphasis is weighting by behaviour, and behaviour
accumulated across nights is the profile. And the waking-life answer is excluded **on grounds
independent of The Close's**: The Close excludes it because the words come after the traditions
spoke, which is contingent on where the invitation sits; Recurrence excludes it because a record
of waking-life answers across nights is a file of what has been happening in a person's life,
and is the shortest path to a profile in the system, requiring no interpretive step. **Both
reasons are kept.**

**AND ONE STANDING LIMIT, RECORDED AS PERMANENT RATHER THAN AS A WATCH ITEM.** The dreamer
re-reads each night through the app's arrangement of it, so a dreamer may write a later night in
words they first met in the app. No rule can filter this, because the path runs through a
person. **Therefore the app can never know whether a returning word is the dream's or its own
echo, and the only honest thing it can do with one is ask.** If recurrence is ever proposed as a
count, a report or a finding, this is the answer.

**WHAT DEPENDED ON THIS.** The Close's filed §6 constraints 3 and 6, both now superseded — the
document is not reopened and the corrections live here. Lens Practice §11's item list. The
Requirements List, which can be written with the slot specified and inoperable.


---

## C55-I — the recurrence ledger is replaced by nothing; Tier 3 cannot be built on this design

**Filed 2026-09-15. Founder-ruled 2026-09-15 on items 1 and 2; item 3 is routed to both founders
and is not ruled here.**

**1. THE BOUNDARY DOCUMENT IS PLACED** at `interpretation/recurrence-and-the-series-draft-1.md`,
sha256 `07cdf863e2561b0a`, 809 lines, 19 sections. Its two negative checks were run before its
covering message and reproduce independently.

**2. THE LEDGER IS REPLACED BY NOTHING, AND THAT IS THE DESIGN.** Framework v3's recurrence
ledger — motifs with dates, absence rules, evolving figures, feeling-tone arc, live tensions with
opened and last-tested dates, and a stale-deferral flag escalating an untested item into the next
session's discernment pass — is replaced. **Nothing takes its place.**

The app holds no object about recurrence: no motif file, no status, no dates, no trend. **The
question is computed once per night from the nights themselves and leaves nothing behind but
itself. The memory is the nights, which are the dreamer's.**

**What follows is the part that makes it more than a simplification.** There is no derived layer
about the dreamer for anyone to read, export, optimise, or be compelled to produce. A deleted
night simply stops being one of the nights the computation runs over, leaving no orphaned record.
**The refusal to learn a dreamer becomes structural rather than promised** — nothing is stored
that would have to be trusted not to be used.

**Lens Practice §16.5's inherited open question is answered:** the night's arc never reads the
series, on four independent grounds at the document's §6.2, any one of which would suffice. That
question had been open since before the current Head's appointment.

**3. ⚠️ TIER 3 CANNOT BE BUILT ON THIS DESIGN, AND THE GAP IT REVEALS IS IN OUR OWN RULES.**
`privacy-ethics-safety.md` Tier 3, pattern-level concern, is marked as needing the recurrence
engine and names: negative affect trending across sessions; session frequency spikes suggesting
the app is becoming a sole confidant; recurring crisis-adjacent content; charge notes reading as
deterioration `[READ, af7714e2]`. **Every one is a profile of the dreamer**, and this design
removes the thing they would be computed from.

C44-I and C51-I make this non-urgent — the tiers are deferred, detection runs log-only. **They do
not make it go away, and the reason is a gap between two of our own rules:**

> **Foundations §4.4 forbids the app ADJUSTING on the basis of who it has decided the dreamer has
> become. The Shared Core refuses MEMORY OF THE DREAMER outright. A log-only cross-session affect
> trend passes the first as written and fails the second as written.**

So a future session could build exactly that, cite The Foundations, and be correct by the letter.
Raised by the chat whose design removes the capability, which is the position with the least
interest in widening it.

**HEAD OF INTERPRETATION'S POSITION, NOT A RULING.** The Shared Core governs and The Foundations
is the narrower statement of the same refusal. Memory of dreams is the product; memory of the
dreamer is refused, and a cross-session affect trend is memory of the dreamer whether or not
anything acts on it. Log-only does not rescue it: the data exists, is stored, and is one ruling
from being used. **On that reading Tier 3 as written cannot be built, and if the tiers return at
Cohort 2 that tier returns as something else or not at all** — working on what a dreamer tells us
directly rather than on what has been inferred about them over weeks.

**ROUTED TO BOTH FOUNDERS AND TO CORE COMMITMENTS.** It is a narrowing of a law document and
belongs with the founders. Core Commitments holds the never-optimised list, and this is the
clearest case yet of a figure that must never EXIST rather than never be optimised.

**TWO THINGS LEFT OPEN AND NOT RULED.** Whether recurrence has a horizon — holding nothing means
nothing expires, a horizon is permitted because it is a parameter about material rather than
about a person, and every candidate is arbitrary. And whether a dreamer may search their own
journal for their own word, proposed as the only cross-night visibility that neither announces
nor grades because the dreamer selects. **Its named danger travels with it: the first feature
request against it will be for the app to suggest words, which is a one-line change that converts
the whole design.**

**WHAT DEPENDED ON THIS.** Framework v3's recurrence section, replaced. `privacy-ethics-safety.md`
Tier 3, which cannot be built as written and is on that document's next pass. Lens Practice
§16.5's open question, answered. And the Requirements List, which waits on this document filing.


---

## C56-I — memory of the dreamer is refused even when nothing acts on it; Tier 3; horizon; search

**Filed 2026-09-15. Founder-ruled 2026-09-15.** *Rules the items C55-I routed.*

**1. A PILLAR, STATED SO IT CANNOT BE READ NARROWLY.** Memory of dreams is the product. Memory
of the dreamer is refused — **and a cross-session record about the dreamer is memory of the
dreamer whether or not anything acts on it.** Log-only does not rescue it: the data exists, is
stored, and is one ruling from being used. The Shared Core governs; Foundations §4.4 is the
narrower statement of the same refusal and may not be cited against it.

A sentence in The Foundations closing this gap in its own text is owed to the next Foundations
block, which needs both founders. Until then this entry governs.

**2. TIER 3 AS WRITTEN CANNOT BE BUILT.** If the tiers return at Cohort 2, pattern-level concern
returns as something else or not at all — working on what a dreamer tells us directly, not on
what has been inferred about them over weeks. **The founder's framing, recorded as the posture
for all deferred safety work:** we are building for this moment, and the beta will let us make
better decisions than we can make now. Deferred decisions are deferred to evidence, not to
convenience.

**3. RECURRENCE HAS NO HORIZON FOR NOW.** Left open deliberately. The first cohorts will show
whether a year-old echo reads as a gift or a reach, and the decision is made on that.

**4. A DREAMER MAY SEARCH THEIR OWN JOURNAL FOR THEIR OWN WORD.** The only cross-night visibility
that neither announces nor grades, because the dreamer selects. **PERMANENT REFUSAL, not a
preference: the app never suggests the word.** That is a one-line change that converts the whole
design, and it is the first request this feature will receive.

**WHAT DEPENDED ON THIS.** `privacy-ethics-safety.md` Tier 3, on that document's next pass.
The next Foundations block. Core Commitments' never-optimised list, which gains a figure that must
never exist. The Requirements List, which gains the search.


---

## C57-I — entry dates written by this Head are superseded by commit dates

**Filed 2026-09-28.** *A Shared Core violation: dates are facts.*

Head of Interpretation wrote filing dates into entry headings from a date carried in
conversation rather than read from the machine. The founder corrected it on 2026-09-28. The
headings from C34-I to C56-I may not match when those entries were filed.

**THE REPOSITORY'S COMMIT DATES ARE AUTHORITATIVE for when each of those entries was filed.**
The headings are not edited. The commit log for this file, as it stood at this filing, follows
indented below, so the true dates live in the record itself rather than in a command someone has
to remember to run.

**From this entry onward, every date is read from the machine at the moment of writing.**

**WHAT DEPENDED ON THIS.** Every date in C34-I to C56-I. Any document citing one of those
entries by its date rather than its ordinal.

Commit log for interpretation/change-record.md at this filing:
    2026-09-28  8c009fb  C56-I: memory of the dreamer is refused even when nothing acts on it
    2026-09-28  a526b8d  C55-I: the recurrence ledger is replaced by nothing; Tier 3 cannot be built
    2026-09-15  badcfd7  C54-I: the series question cannot be asked; speaker rule ruled; readable set closed
    2026-09-15  369a9ae  C53-I: C52-I's copy of the corrected check lost its continuation
    2026-09-15  ab140ae  C52-I: The Close draft 2 filed at 97cd075a; duplicate check corrected
    2026-09-15  217cfb1  C51-I: detection runs, consequence deferred; the reflection may pair a live fact with a dream image
    2026-09-15  a1b4dba  C50-I: the close is unaided from Cohort 1; two corrections
    2026-09-15  9def906  C49-I: C44-I's disclosure line is false; statuses internal, never shown
    2026-09-15  9815b9d  C48-I: §2.3's scope, §4.4's authority corrected, the series question's home
    2026-09-15  00d8cef  C47-I: tester disclosure specification filed, consent inside it
    2026-09-14  6f434df  C46-I: C41-I appears twice; second instance governs, neither deleted
    2026-09-14  7db6e52  C45-I: no split; nothing to Product until the ending is settled
    2026-09-14  07796f4  C44-I: the distress apparatus is deferred, not ruled out
    2026-09-14  cd8b3bb  C43-I: the Dream field is substantially the dreamer's
    2026-09-14  e03e4eb  C42-I: the journal's dreamer-voice fields are app-composed prose; marker (c) split
    2026-09-13  b53a262  C41-I: the journal's associations were composed after the readings
    2026-09-13  7770d73  C41-I: the journal's associations were composed after the readings
    2026-09-13  aa42f27  C40-I: the frozen journal holds fifteen of sixteen entries
    2026-09-12  6cebcda  Remove the Technology header from The Foundations; C39-I records that C34-I claimed it first
    2026-09-12  4e1ab6f  C34-I to C38-I; Technology header removed from The Foundations and archived
    2026-09-11  a880a37  File the Head of Interpretation briefing as a record; close C17-I's third site
    2026-09-11  d707ebf  Frozen journal recovered; SHARED-CORE and old build report placed; D17 recorded
    2026-09-10  8ff9db3  Filing pass 2026-09-10: structure, recovered material, four blocks, rename

---

## C58-I — Recurrence & the Series, Draft 2, placed

**Filed 2026-09-28.**

**PLACED** at interpretation/recurrence-and-the-series-draft-2.md, sha256 123ea64b26b95c89,
822 lines. **The unplaced 8c49cb41 is not this file** and appears nowhere else in the record.
Draft 1 at 07cdf863 goes to archive/ intact.

**Every ruling it carries was read in its entry, not taken from a message.** Six marks point to
C56-I and two to C54-I, where the focused-pass ruling actually sits. Head of Interpretation's
relay had attributed that ruling to C56-I; the document's own pre-placement check caught it, and
the document then corrected Head of Interpretation's count of the marks as well. Both were the
same error: a figure carried in a message rather than taken from the file it describes.

**Two marks stay [RELAYED] deliberately.** One is the provenance legend, which defines the mark.
The other is The Close's answer that the night's arc is the last of the readings rather than the
first of the ending, given in correspondence and not yet read in a filed document.

**This completes the department's design documents.** The opening, the readings, the ending and
what returns across nights are now each designed in a filed document. What remains before the
Requirements List is not design: the specification pass on seventeen lens files, and the law
document's pass.

**WHAT DEPENDED ON THIS.** Framework v3's recurrence section, now replaced by this document's
§9. The Requirements List, which waits only on the two passes above.


---

## C59-I — two items Head of Interpretation dropped, routed into the specification pass

**Filed 2026-09-28.**

**1. The Register Read's three proposed blocks for Lens Practice were delivered and never ruled.**
lens-practice-blocks-register-read.md, sha256 22f1f5e2, proposed against Lens Practice 0f074dae.
They arrived in the same message as The Close's first deliverable and were not answered. Their
central finding: the lens file template in Lens Practice §11 lists twelve items while every lens
file has fourteen headings, and the evidence section — where test surfaces A and B are defined —
has no template item. **That unguarded section is why two waves gave one letter to two surfaces
(RR-7).** Placed now as a proposal, not applied.

**2. RR-7 part (4) was reported to the Register Read as commissioned. It was not.** The check:
whether Wave 1's five files took feeling-in-dream from the Dream narration, which C43-I clears,
or from the Charge notes, which C42-I names as app-composed.

**Both are routed into the specification pass**, which reads the same seventeen files and
changes the same template. Lens Practice moves once.

**WHAT DEPENDED ON THIS.** RR-7, whose part (4) has been open since 2026-09-14. Lens Practice
§11, which receives this pass's item and the Register Read's blocks in one revision.


---

## C60-I — five rulings that existed only in conversation; the specification pass's rulings

**Filed 2026-09-28.** *Head of Interpretation carried these in messages to worker chats without
entries — the error class the handover names first: a ruling in no file does not exist.*

**1. FOUNDER RULINGS GIVEN IN CONVERSATION, NOW ENTERED.**

(a) **THE QUESTION BUDGET: THREE IS NOT A CEILING.** A fixed cap fights the dials that follow the
material. The founder's addition: through the early cohorts our job is to learn how many
questions get answered, when dreamers move to the readings, and where the sweet spot sits — which
differs between thin and rich nights — and a cap now would prevent learning it. The number, and
whether there is a cap at all, is The Opening's to decide with the Transcript Pass's findings.

(b) **ZHUANGZI–LIEZI CLAUSE 2 KEEPS ITS SOURCE'S CONDITION.** Rank, as the Liezi has it. Not
widened to any waking state the dream inverts; a tradition is not widened to make it readable.
Its readability may change when the opening changes, without its condition changing.

(c) **THE BRIDGE IS A DIFFERENT QUESTION, NOT A REVERSAL.** The Opening's founder ruling that
Delaney's bridge belongs after the readings stands. "What does this image MEAN in your life" asks
for a conclusion and stays after. "What does this image TOUCH in your waking life" asks for
material and may sit before. The distinction is the form, so the wording is load-bearing.

(d) **SÁMI AND ABORIGINAL AUSTRALIAN ARE NOT CANDIDATES.** Ruled by Head of Interpretation
2026-09-14, to Core Commitments. A candidate could be selected; neither writes an account
condition. Each file's status is stated in its own reason, which is standing rather than
scarcity. The correction goes to the findings ledger; the files are not edited.

**2. HEAD OF INTERPRETATION'S METHOD RULING, NOW ENTERED.** The Register Read's three blocks for
Lens Practice (sha256 22f1f5e2, C59-I) are ACCEPTED. The surface definitions stay in Lens
Practice; no conventions file is created. The §8 block stays scoped and unpriced pending the
Transcript Pass. Add, do not renumber.

**3. THE SPECIFICATION PASS.** Its ledger prefix is SP. Its item is named **an account of an image
recurring across separate nights** — C54-I's phrase "account of return" is read in that sense,
because "return" is Lens Practice's within-session word. The pass's document is the single
source for the seventeen answers while the register is closed.

**4. OWED, NOT DONE.** One small chat, after the Transcript Pass files: whether mirror
corrections are separable from answers in the transcripts; Recurrence's prediction PR3, testing
its definition on the first telling; and RR-8, whether marker (a) fires differently on the
first telling than on the journal's written account. The Transcript Pass's filed turn-count block
already establishes that all seventeen transcripts separate the first telling from the
exchanges.

**WHAT DEPENDED ON THIS.** The Opening's redesign, which receives (a) and (c). Lens Practice's
revision now being drafted. The findings ledger, which receives (d).


---

## C61-I — the specification pass filed; the series question is operable

**Filed 2026-09-28.**

**FILED.** Lens Practice Draft 7 at a125da11, superseding Draft 6 (0f074dae, now in archive/, with
every replaced passage appended verbatim to lens-practice-archive.md). The findings ledger at
19616845, carrying SP-1 to SP-3. The pass document lens-register-recurring-image-pass.md at
a9807509. The dated prediction, the RR-7 part (4) script and its output beside them.

**THE RESULT, AND WHY IT IS THE METHOD WORKING.** Prediction published before reading: three files
would declare an account of an image recurring across separate nights — Jungian, Adlerian, Islamic
ta'bir. Result: three declare — Asclepian (narrowly), Freudian, Zhuangzi–Liezi. **The count was
right and every name was wrong, and the prediction was not moved.** Two DOES NOT, ten SILENT, two
NOT APPLICABLE. Jungian is SILENT: its across-nights material is a series correcting a reading,
the adjacent thing C54-I excludes.

**THE SERIES QUESTION IS OPERABLE.** Its speaker filter (C54-I item 2) reads the pass document. It
will run on few nights; on the frozen journal the speaker would in practice be Zhuangzi–Liezi; a
seeded tie-break will almost never be reached.

**RULINGS ON THE PASS'S FIVE QUESTIONS, Head of Interpretation, 2026-09-28.** Q1 — the Register
Read's §7.1 replacement rides in Draft 7; those were the three live instances of the overturned
ordering rule. Q2 — Asclepian DECLARES narrowly, on the tradition's own account that a dream is a
command and one that returns is a command not yet obeyed. Q3 — Talmudic SILENT; the file
establishes within-night only. Q4 — the closed sentence is replaced by a pointer. **Q5 — Lens
Practice §11 item 1 gains a fourth status, NOT A CANDIDATE — STANDING,** for a file whose
condition is unreachable by any route we hold and whose tradition's own institutions have not been
asked; standing, not scarcity; cannot be selected. Sámi and Aboriginal Australian take it. **This
entry is Q5's entry.**

**RR-7 PART (4) CLOSES AT SP-2, AND THE QUESTION WAS WRONG.** No Wave 1 B figure moves. Wave 1 never
drew on the charge notes; where it drew on app-composed material, it was the associations field,
and key images supplied words to four of five files. The either/or put in the brief was not
exhaustive.

**A WORKING PRACTICE, RECORDED BECAUSE IT COST FIFTEEN DAYS.** A worker chat does not work between
messages. The Transcript Pass ended a message on 2026-09-13 with "next: 06-19, 06-23, 06-24" and
read nothing further until a turn arrived on 2026-09-28; one night of seventeen is read. **A
worker's "next" is waiting for a turn, not work under way.** The Opening's redesign waits on that
chat.

**WHAT DEPENDED ON THIS.** C54-I, whose speaker filter now has something to read. The Close §15's
two dependencies on Lens Practice, discharged at Draft 7 §4.2. C60-I's routing of the Sámi and
Aboriginal Australian correction, discharged at SP-3. And the lens-file template, which now has
fifteen items and four statuses.


---

## C62-I — distress firings are stored per night and counted only as a population

**Filed 2026-09-28. Founder-ruled 2026-09-28.** *Resolves a conflict between C51-I and C56-I,
found by Head of Organisation.*

**The conflict.** C51-I: detection runs from Cohort 0, log-only, recording every firing, so any
later decision rests on a measured rate. C56-I: a cross-session record about the dreamer is memory
of the dreamer whether or not anything acts on it. **A per-dreamer history of distress firings is
the trend C56-I forbids, waiting to be computed.**

**RULED.** Each firing is stored with the session it occurred in — part of that dreamer's night.
**The rate is computed only in aggregate, across all sessions, with no join across one dreamer's
sessions.** Nothing indexes firings by dreamer. The measurement survives, because a population rate
is all that "how often does it fire" requires; the pillar survives, because no per-person history
exists to compute from.

**What it costs, accepted:** the app cannot see one person deteriorating over time. That is
already the residual recorded at C51-I — the app cannot stop, because it does not know.

**A REQUIREMENT FOR TECHNOLOGY, WHEN IT OPENS.** A dreamer's nights all sit in their journal, so a
join is possible in principle. The guarantee must be structural: **the rate computation takes no
dreamer identifier as input.** The same kind of guarantee as the reflection's writer, whose input
has no parameter the rest could arrive through.

**WHAT DEPENDED ON THIS.** The tester disclosure specification, whose statement of what is stored
narrows to per-session and aggregate. What the company tells anyone about the app never learning
the dreamer, which holds. Core Commitments' never-optimised list.


---

## C63-I — rulings for the law document pass; one figure not to be quoted

**Filed 2026-09-28.** Head of Interpretation rulings on the Law Document Pass's questions, and two
corrections found by worker chats. Three further questions are with the founder and are not ruled
here.

**1. A RENAME CARRIED AS OWED WAS ALREADY DONE.** C44-I listed "continuity engine" in
privacy-ethics-safety.md as owed to RECURRENCE. The document contains no instance of "continuity";
the rename was made at C21-I, as C31-I records. C44-I carried the item from a relay through Head of
Organisation without checking the document. Recorded as found done.

**2. COHORT 2 MEANS COHORT 2a.** C36-I names Cohort 0, Cohort 1, then Cohort 2a onward. C44-I's
"Cohort 2 at the earliest" is read as Cohort 2a.

**3. A FIRING IS STORED WITH THE NIGHT IT OCCURRED IN.** Clarifies C62-I, whose heading says night
and whose body says session. The gate runs at capture as well as in session; a capture-time firing
has a night and may have no session. Night governs.

**4. C62-I'S DEPENDENTS INCLUDE THE LAW DOCUMENT AND THE REVIEW SHEET.** privacy-ethics-safety.md
says gate logs are reviewed during beta and names a founder's review sheet. Reviewing one night's
firing is not a join. The reviewer never assembles one dreamer's nights. At four testers, anonymity
is impossible and is not claimed; the protection is the rule, the consent, and the disclosure.

**5. SMALL POPULATIONS.** In Cohort 0 the aggregate is the founder's own material, consented to. In
Cohort 1 the firing rate is read only as one total across the cohort — never sliced by time and
never by tester — because a rate over a handful of people, sliced, is close to per-person.

**6. STATIC CRISIS RESOURCES ARE REACHABLE FROM THE APP AT ALL TIMES.** The entry page and the space
are instances, not the rule. The law document holds the line; Core Commitments points at it,
owed to Organisation on reopening.

**7. THE PHASE LEGEND GOES.** Framework v3 removed phase annotations as build sequencing belonging
to Technology. Every [P1], [P2] and [SPEC] mark goes, replaced by cohort-conditional marking
(C50-I). The deletion cascade into ledger motifs, tensions and feeling-tone arcs is replaced by
C55-I's line: a deleted night simply stops being one of the nights.

**8. THE FOUNDER'S DREAM MATERIAL LEAVES THE LAW DOCUMENT.** Limits 1 and 4 cite it as reason; the
Shared Core forbids it; the rules stand without it. **The removed text goes to restricted/, not to
archive/**, because the archive is in the shared repository. The archive note records only that
text was removed and where it is held.

**9. CRISIS NUMBERS MOVE OUT OF THE LAW DOCUMENT.** They belong to the resources surface, whose
content is founder-written in each language (C44-I), and are verified current before Cohort 1 —
never relied on from memory.

**10. BUILD STATE IS UNTOUCHED IN THIS PASS.** File paths, line numbers, migrations and build notes
in the law document are owed to Technology when it opens. The "scaffolding ratchet" it cites was
removed in Adaptive Scaffolding v2.

**11. ⚠️ A FIGURE NOT TO BE QUOTED UNTIL RECOUNTED.** The turn-count block (7d69e493) counts every
question marker as a question the practice asked. On 2026-06-27, twenty of thirty were questions
the dreamer asked the app to set him, about love, ego and soul rather than the dream, and all
nineteen unanswered were among them; the session's own ten were all answered. "Six to thirty a
night" overstates what the practice asked. The direction stands — the session's own questions
exceeded three on every night read — and C60-I (a) rules the budget's shape, not its number. The
Transcript Pass's final recount gives both definitions.

**WHAT DEPENDED ON THIS.** The Law Document Pass's replacement draft. The tester disclosure
specification, which receives the per-night and cohort-total wording. The Opening's redesign,
which receives item 11 and must set its budget with both counts.


---

## C64-I — three founder rulings; the law document pass's open items; C43-I's figures corrected

**Filed 2026-09-28. Items 1 to 3 founder-ruled 2026-09-28.**

**1. THE APP NEVER ACTS IN A DREAMER'S WAKING LIFE ON THEIR BEHALF, EVEN WHEN ASKED.** The session
stays with the dream. The app never drafts, words or weighs an action toward a real person in the
dreamer's life. C51-I rules that the app never tells anyone what to do; this is the neighbouring
case, the app doing it for them. The old practice did so, and the evidence is the founder's own
material, held in restricted/ (Transcript Pass, batch 2) and not described here, per the Shared
Core. **This belongs in privacy-ethics-safety.md limit 4**, which already forbids behavioural
prescription app-wide; the Law Document Pass carries it there.

**2. THE QUESTION "DOES A DREAMER'S ASSOCIATIVE WORK DEEPEN AS THEY KEEP GOING" IS RETIRED.** It is
a per-person trend across sessions, which C56-I forbids. Fluency signals are stored with the night
they arise in and counted only across all dreamers, the shape of C62-I. Adaptive Scaffolding v2
states the question and owes a correction.

**3. THE INHERITED NON-NEGOTIABLE IS SUPERSEDED.** The rule that no one but the founder uses the app
until both distress branches exist was superseded by the founder's ruling of 2026-09-14, recorded
at C44-I, which never named it. The single-user guard's purpose is withdrawn; **what replaces it is
the tester disclosure.** Head of Interpretation's answer to Core Commitments on 2026-09-14 — that the
suppressed-consequence mode cannot be active for any user who is not the founder — was backwards:
under the deferral it is active for Cohort 1. Core Commitments is closed; the correction is owed to
Organisation on reopening.

**4. ITEMS THE LAW DOCUMENT PASS FOUND WITHOUT AN ENTRY, NOW ENTERED.** A write in the close's space
is a dreamer turn and is classified like every turn (C51-I). The tester disclosure absorbs the beta
access consent — one document, one consent. **The law document governs itself and may not yield to
a file absent from the repository**; the clause deferring Tier 1 scope to such a file is removed,
and Tier 1 scope stays target state. The holding ending's description of the old close is replaced
by a pointer to The Close, draft 2. Removed text replaces the intact archived copy for this document
only, because an intact copy would put the founder's material back into the shared archive.

**5. C43-I's FIGURES ARE CORRECTED; ITS CONCLUSION IS STRONGER.** C43-I reported one night,
2026-07-04, contributing 48 of the Dream field's 75 post-lens words, unexplained. **The cause was the
extractor, not the material:** that night's entry labels its lens takeaways by dream, and a match on
any label containing "dream" swept the readings into the Dream field. No other night carries such a
label. The script, lost at a container reset, was rebuilt from the Transcript Pass's own code of
2026-09-13, reproduced the filed figures exactly, and was then changed in one respect only — the
Dream field matched by its exact label (interpretation/authorship-rebuilt-2026-09-28.py, sha256
526d8a0b). **Corrected: the Dream field is 62% traceable to the dreamer, 24% app pre-lens, 4%
post-lens, 10% novel, over 801 words, against the 43% control; 2026-07-04 is 3 of 49 post-lens.**
C43-I's sentence that one night is an exception is withdrawn: there is no exception. C43-I is not
edited.

**6. ROUTED TO BOTH FOUNDERS, NOT RULED.** The founder's material removed from the law document
remains in every commit holding its earlier version and in the project mirrors. C25-I rewrote history
when the repository had one commit and no remote. Whether to rewrite it now, before any third person
has repository access, is theirs.

**WHAT DEPENDED ON THIS.** privacy-ethics-safety.md, whose held items are now writable. Adaptive
Scaffolding v2, owed a correction. The framework pass. C43-I's figures, wherever they have been
quoted. And Organisation's reopening, owed two corrections: this item 3, and C63-I item 6.


---

## C66-I — the transcript pass filed; the law document level; rulings entered for The Opening

**Filed 2026-09-28.**

**1. THE TRANSCRIPT PASS IS COMPLETE.** Seventeen nights read against the pre-registration of
2026-09-09. Findings at interpretation/transcript-pass-findings-2026-09-28.md (71c27f3a). The
turn-count block is corrected once, with the full count, at
interpretation/transcript-pass-freeze-appendix-correction-2026-09-28.md (88d78c8a). The per-night
field records are in restricted/ only. Neither filed document contains dream material.

**In one line each, and all consistent-with rather than confirming — one dreamer, an abandoned
regime:** return within a session, one clean instance, on a closed image; the priority chain agrees
with the practice on 12 of 15 journal nights but resolves by volume on 14, confounded by the
questions asked, and never finds an image the practice under-read; no answer introduced a new dream
image on 11 of 17 nights, and where one did the reply-event and question-number counts diverge;
nomination twice, both inside the telling; the asking never observed, so one of the depth score's
two inputs has not been seen in any material this department holds; reaching for waking-life
explanation on all 17 nights from the first reply; degradation on one night only. **One correction
found after the practice side was opened is declared and not counted.**

**2. THE RECOUNT REPLACES EVERY QUESTION-VOLUME FIGURE PREVIOUSLY QUOTED.** The session's own
questions: 175, six to eighteen a night, median ten, more than three on all seventeen. Unanswered: 58,
of which 27 are the session's own. Answered: 171. The asymmetric statement stands (C63-I item 11).

**3. THE LAW DOCUMENT IS FILED** at interpretation/privacy-ethics-safety.md (abafbaaf), carrying
C44-I, C50-I, C51-I, C56-I, C62-I, C63-I and C64-I. The removed founder material is in restricted/
only; the archive note replaces the intact copy for this document (C64-I item 4). Four small rulings
on the pass's closing questions: Tier 1 classification runs now as detection and only the decline is
target state; C63-I item 5's small-cohort rule extends to fluency signals; the four remaining
citations of a file absent from the repository are owed to Technology with the build state; the
archive note sits where the founder's listing placed it.

**4. FOUNDER RULINGS ENTERED SO WORKER CHATS MAY CITE THEM BEFORE THE FOUNDATIONS BLOCK IS SIGNED.**
The Foundations text changes only on both signatures; these rulings bind Interpretation's method now.
(a) The app never tells a dreamer what its order means, in either direction, on any night. (b) No
question the app asks about waking life names a day or a period; how far back the dreamer's life
reaches is theirs to decide. (c) The label "the day-context question" is withdrawn, because it names
a period.

**5. THE MARKER RULINGS, ENTERED FOR THE OPENING TO ADOPT.** Given to the blind reference reading
(5eab2faa) and not entered until now. Marker (d) fires only where a feeling is stated and does not
fit its event; a stated absence of feeling is a distinct value, not a mismatch; where no feeling is
recorded, (d) is not applicable. Markers are scored per dream and the night derived. Marker (c) is
split into (c1) and (c2) (C42-I). Marker (b)'s split into marked strangeness and a contrast supplied
in passing is a candidate, not ruled. **All six worked examples in the four-signal list come from the
founder's material** and are replaced by invented ones (C65-I).

**6. ROUTED TO THE OPENING.** The closed-image return; the gap in the return definition where the
app names the image in commentary in the same turn; both counts for the budget; the chain's inability
to reach an image carrying no unresolved signal; the asking unobserved. And one fact for the
readings and the law document together: it concerns two sessions, which differed on it, one each way
⟦FM-002 · moved to restricted/ on 2026-10-03⟧.

**WHAT DEPENDED ON THIS.** The Opening's redesign, which now opens. Lens Practice, whose priority
chain the findings bear on and which is re-derived after The Opening. The founder-material pass.


---

## C65-I — the history rewrite is deferred to one pass before the handoff to Product

**Filed 2026-09-28. Founder-ruled 2026-09-28.** *Answers C64-I item 6. Written before C66-I and
appended after it: the block was not run when written. C66-I cites this ordinal, which is why it
keeps it.*

**RULED.** The repository's history is rewritten once, after the interpretation work is finished and
before the Requirements List goes to Product & Design — not now.

**Why once, at the end.** The founder's material is not confined to the passages removed from the law
document. The Opening's marker definitions use journal images as worked examples; the change record
names a real person from the founder's sessions; the lens files' evidence sections quote the frozen
journal throughout. A rewrite now would be the first of several.

**Conditions.** No one other than the founders has repository access until the rewrite is complete.
It precedes the handoff, because Product & Design will read these documents.

**What it is, when it comes.** A founder-material pass first: every instance of journal or transcript
material, and every named person from the sessions, found in filed documents and decided case by case
— moved to restricted/, replaced by an invented example, or reduced to a count. The lens files'
evidence sections need a ruling of their own, because handed-over files are never edited (C24-I
convention 3). Then one history rewrite, with the old-to-new commit mapping filed so every commit ID
cited in this record still resolves.

**WHAT DEPENDED ON THIS.** C64-I item 6. The Opening's redesign, which replaces its worked examples
with invented ones as it goes. The Requirements List, which waits on this pass.


---

## C67-I — rulings that existed only in documents and messages; corrections to The Opening's brief

**Filed 2026-09-28.** *All found by The Opening before it began. Five are Head of Interpretation's
errors.*

**1. THE OPENING DRAFT 5'S OWN RULINGS ARE ENTERED, BY POINTER.** The rulings of 2026-09-07 (D1 to
D11 and the unnumbered rulings of that date) and the table of 2026-09-09, as recorded under the
Rulings heading of the-opening-draft-5.md at 68a486e5, are founder rulings. Their text is Draft 5's.
They stand except where later entries move them: D4 is narrowed by C60-I (c); D8 is superseded by
C60-I (a); D5's label is withdrawn by C66-I item 4 (c). **D3, the unit is the turn, stands** until
ruled otherwise; The Opening proposes a unit with both counts in hand.

**2. HEAD OF INTERPRETATION'S RULINGS OF 2026-09-12 TO THE REGISTER READ, ENTERED.** The stance
question comes before the readings, at the close of the opening, once, and only after the account is
settled. The anchored bridge is asked once per session, on the concentrated image. Anchored means
pointed at by something the dreamer has recorded this session, in any turn. The Register Read's R1
to R5 were accepted as proposals to The Opening, not adopted. The Register Read labels the first two
ruled; they were, and had no entry.

**3. WITHDRAWN FROM THE OPENING'S BRIEF.** The bridge wording test — a candidate fails if answerable
by "is" or "means" with the image as subject — has no source in the Register Read or in this record,
and fails the form C60-I (c) rules. The pile the brief called the fourth is the second of five. The
return finding was inverted: The Opening records returns only for unresolved images, so the one clean
return would never have been recorded. The asking contributes at most one of the depth score's five
points, and was unobserved because the old regime never issued the invitation. "The charge needs no
place" was not ruled and is with the founder. Removing recorded results from the marker definitions
is Head of Interpretation's instruction, not a ruling. Marker (b)'s split is proposed by The Opening
and ruled by the founder.

**4. THE CAPTURE LAYER IS RECURRENCE'S RQ1: what arrived before the app asked anything, and mirror
corrections.** C54-I item 3's one-line summary is the short form and RQ1 governs. C60-I item 4's
first question is answered by the Transcript Pass: the old record does not mark mirror corrections
apart from answers. The new record must keep the telling, a mirror correction, an answer, and bridge
and stance answers apart — The Opening's to specify. The two counts C60-I item 4 names remain owed.

**5. C66-I ITEM 6 DESCRIBES AN IMAGE FROM THE FOUNDER'S MATERIAL.** It is in the scope of the
founder-material pass (C65-I). It is not repeated here.

**6. THE FILING CHECK IS REPLACED.** The check in C53-I excluded C41-I by name, so a third instance
of C41-I would pass, and it could not detect a missing ordinal. The replacement reports any ordinal
appearing more often than it should (C41-I is permitted twice) and any gap in the sequence:

    grep -oE "^## C[0-9]+-I" interpretation/change-record.md | sed 's/## C//;s/-I//' | sort -n | uniq -c | awk '($2==41 && $1>2) || ($2!=41 && $1>1) {print "DUPLICATE C"$2"-I"} NR>1 && $2!=p+1 {print "GAP after C"p"-I"} {p=$2}'

It prints nothing when the record is sound. It printed nothing at this filing.

**WHAT DEPENDED ON THIS.** The Opening's redesign, whose map now has its ruled set. C53-I's check.
Two founder questions routed today: whether charge is invited anywhere, and whether superseded drafts
carrying founder material archive with that material moved to restricted/.


---

## C69-I — where the stood-out question sits is left to The Opening, without a steer

**Filed 2026-09-28. Founder-ruled 2026-09-28.** *Settles how C68-I item 1's placement is decided.*

**RULED: the placement is The Opening's to argue from evidence, with no lean from the founder or from
Head of Interpretation.** Head of Interpretation's lean recorded at C68-I is withdrawn as guidance. The
founder's reason for leaving it open: to see what the chat that owns the opening concludes on its
own.

**Two things are fixed, because they define the question rather than its position.** It comes before
any tradition speaks. And it must meet the founder's goal for it: the answer should not simply be the
last images the dreamer saw before waking.

**WHAT DEPENDED ON THIS.** C68-I item 1. The Opening's Draft 6, which proposes the position as a
numbered founder question.


---

## C68-I — what stood out is invited openly; founder material never enters the archive

**Filed 2026-09-28. Founder-ruled 2026-09-28.** *Written before C69-I and appended after it: the
block was not run when written. C69-I cites this ordinal and withdraws the lean recorded in item 1.*

**1. THE DREAMER IS INVITED TO SAY WHAT STOOD OUT.** Not which image mattered most, but whether any
images or moments stood out — no limit on how many, and none a complete answer. **The founder's
reasons:** dreamers react more strongly to some parts of a dream than others, and a ranking would
force one answer and a limit; and the answer should not simply be the last images before waking.

**What follows from existing entries, not new rulings.** The question names no image, so it produces
no attention on any image of the app's choosing — the confound the Transcript Pass found in the
priority chain. Nothing is the easiest answer and is complete. The answer comes after the app's first
turn, so it is an answer and not the capture layer, and no later night reads it: which images stood
out, accumulated across nights, is the emphasis C54-I item 3 refuses. The words are the founder's.

**This answers C67-I item 3's routed question.** The charge is not dropped; it has a place, here,
invited rather than required.

**Placement:** before the readings. Head of Interpretation leaned toward placing it before the
clarifying questions; C69-I withdraws that lean and leaves the position to The Opening.

**2. A SUPERSEDED DOCUMENT CARRYING FOUNDER MATERIAL IS ARCHIVED WITH THAT MATERIAL MOVED TO
restricted/.** archive/ keeps a note of what was removed and where it is held. This generalises C64-I
item 4 to every document. Files already in archive/ are handled by the founder-material pass (C65-I).

**WHAT DEPENDED ON THIS.** The Opening's Draft 6. Marker (c1), which gains an invitation it can fire
on. The Close's mirror, which may show the dreamer's answer among their own words — owed to its draft
3. Every future archiving in this department.


---

## C70-I — The Opening's nine questions ruled

**Filed 2026-09-28. Founder-ruled 2026-09-28**, except the two Head of Interpretation rulings at the
end. *The Opening's map, received 2026-09-29 by its machine date.*

**1. WHAT STOOD OUT IS ASKED RIGHT AFTER THE MIRROR AND ITS CORRECTIONS, BEFORE THE FIRST CLARIFYING
QUESTION.** Reached by The Opening without a steer (C69-I). The reason: it is then the one input to
the priority chain the app's own questions cannot have shaped, and the clarifying questions can follow
what the dreamer pointed at. The founder's goal that the answer not simply be the last images before
waking is met by the line's specification — moments as well as images, any number — and by a Cohort 0
watch item: the share of stood-out answers that are the night's final image.

**2. THE UNIT IS THE APP'S QUESTION TURN.** One question per turn; an unanswered turn counts. D3 made
precise, not reopened.

**3. NO CAP IN COHORTS 0 AND 1.** The questions stop when the dreamer signals, or when two consecutive
turns yield neither a new image nor a new association. Four counts are recorded per night — turns
asked, the turn of the last new image, the turn of the last new association, the turn the dreamer
signalled — never per dreamer across nights, and in Cohort 1 read only as a cohort total (C63-I item
5). **The founder's intent:** to see how many questions dreamers naturally lean toward.
**The dreamer's signal** is an affordance on every question turn and saying so in words. The founder
frames it as "interpret now"; Draft 5's "go on" affordance is the same act. One affordance; its words
are the founder's.

**4. A NEW ASSOCIATION COUNTS AS YIELD,** not only a new image.

**5. THE THREE FIXED INVITATIONS — stood-out, stance, asking — run on every night the dreamer chose to
interpret, outside the budget.** They are the dreamer's authorship, and the budget governs the app's
curiosity. **Stood-out runs only where the night holds more than one image.** The founder's caution,
binding on the specification: the number of images is not judged too early, because a dreamer may
bring more during the questions. The Opening specifies what happens when a night that held one image
at the mirror gains more.

**6. THE STANCE QUESTION STAYS**, as placed, with its watch item on answers that are already
interpretations. The founder's reason: it is a good question and an important one.

**7. THE BRIDGE TEST IS ADOPTED.** A candidate passes if a complete answer can be given by naming
something in waking life — a person, a place, an event — without any claim about what the image is or
means.

**8. MARKER (b) STAYS WHOLE** until a count shows a split would discriminate.

**9. RETURNS ARE RECORDED FOR EVERY IMAGE**, unresolved or not. Their use is Lens Practice's.

**HEAD OF INTERPRETATION'S RULINGS.** Where the priority chain runs — the end of the opening or the
start of the readings — changes nothing a dreamer experiences and is Lens Practice's. And the form
rule: a clarifying question may be anchored on an image the stood-out answer names, because that image
is dream material; the stood-out answer itself is not dream material and nothing is anchored on its
words.

**WHAT DEPENDED ON THIS.** The Opening's Draft 6. Lens Practice, owed the chain's inputs with their
marks, returns per image, and the finding that volume in answers measures the app's attention. The
Close, draft 3: whether the reflection may pair a stance or bridge answer with a dream image, where
C51-I item 2 bears. The law document's next pass: one sentence naming the bridge and stance as presses
before the readings.


---

## C71-I — The Opening, Draft 6, filed; Draft 5 held whole in restricted/

**Filed 2026-09-29.**

**FILED.** interpretation/the-opening-draft-6.md, sha256 c38207e6. Written to the map ruled at C70-I.
It carries no section numbers, none of the founder's material, and invented examples only; every
change-record ordinal it cites resolves. It states no hash or length of itself.

**DRAFT 5 IS HELD WHOLE IN restricted/, with a note in archive/.** Head of Interpretation's method
ruling applying C68-I item 2: moving a superseded document whole satisfies the rule without editing a
record's text, and loses nothing. The Opening's index of the founder passages in Draft 5 (sha256
ab15a12c) sits beside it in restricted/.

**FOUNDER-CONFIRMED 2026-09-29: after "interpret now", the stance and asking invitations still appear
— together, once, and doing nothing proceeds to the readings.** The dreamer's signal ends the app's
questions, not the dreamer's chance to say what they made of the dream. The Opening resolved the
tension between C70-I item 5 and Draft 5's rule that nothing is asked after the dreamer's signal.

**THREE THINGS THE DRAFT DID BEYOND THE MAP, recorded so they are not mistaken for rulings.** A night
counts as holding one image by the mix table's fragment row, judged from the account as settled at
the mirror; the late stood-out offer runs once when the questions end, recorded with its position so
it is not read as question-free. Marker (c1) is re-derived for the invitation: the dreamer offers no
association in any answer, since the app never asks why. The asking's second route — a question to
the app about the dream — is kept, with its divergence from the pre-registration marked as assumed.

**WHAT DEPENDED ON THIS.** Lens Practice, owed the chain's inputs, returns per image and the volume
finding. Recurrence & the Series, owed the record kinds. The Close's draft 3. The law document's next
pass. The Requirements List. The founder-material pass, which has Draft 5 in restricted/ already.


---

## C72-I — rulings for three open chats; nine corrections, two to filed entries

**Filed 2026-09-29.** *Every item found by Lens Practice Draft 8, The Close Draft 3 or the Framework
Pass before beginning. Founder rulings are marked; the rest are Head of Interpretation's method
rulings, open to the founder.*

**1. TWO FILED ENTRIES CORRECTED.** C50-I item 3 says the discernment pass is "upstream of the
readings". It presses on readings and so comes after them: **after the traditions have read, before
the grounding check.** C70-I and The Opening's map call the stood-out answer a ranking. **It is an
unordered set, possibly empty, possibly late** (C68-I item 1); no rule may pick one image from
several by first-named or most-said.

**2. THE DISCERNMENT PASS HAS NO OWNER AND NO FILED DESIGN.** Never cuttable (C44-I). **Owner: Lens
Practice**, which owns the readings phase. Two of its five vectors — the deferred-tension audit and
the narrative-fit check aimed at an accumulated arc — retire with the ledger (C55-I). Draft 8 states
what remains, or holds it open in those words. The interpreter's-narrative guard aims within the
session, at the app's own earlier turns tonight.

**3. LENS PRACTICE'S OWN RULINGS ENTERED BY POINTER**, as C67-I item 1 did for The Opening: the
decision record D1 onward under Lens Practice's Rulings heading at a125da11 are founder rulings and
stand except where later entries move them. Changing D13 is a founder question.

**4. RETURN, FOR THE PRIORITY CHAIN.** The Opening's definition has two holes: the mirror names every
image, so no correction can be a return under it; and the stood-out invitation names none, so every
image it draws would be. **Ruled: for the chain, a return is an image the dreamer raises in an answer
to a clarifying question that did not name it.** Mirror corrections are their own kind, not returns.
Stood-out, stance and asking answers are not returns. The Opening's text is owed the correction.

**5. THE CHAIN'S INPUTS, BY DIRECTION.** Exclude any input whose value the app's attention can RAISE
— volume, and a late stood-out answer unmarked. Admit inputs the app's attention can only suppress —
returns — marked. The bias runs toward images the app asked about less.

**6. THE CHAIN RUNS BEFORE THE BRIDGE, at the end of the opening**; nothing else is live, since the
bridge needs an image. Where purchase and spill are computed relative to the bridge is Draft 8's.
Newly owed: the case where no lens has purchase on the chosen image.

**7. THE OPENING'S BEHAVIOUR 18** ("what they pointed at is where the readings look first") is that
document's statement of intent. How the stood-out set enters selection is Lens Practice's; if it
cannot be honoured without ranking, Draft 8 says so and The Opening is corrected.

**8. R4 IS NOT RULED.** Lens Practice proposes what a tradition may read from stance and bridge
answers; the founder rules. The risk is named: a stance answer supplying a stated waking attitude
moves the intake bias D17 exists to prevent.

**9. THE VOLUME FIGURE.** "Resolved by volume on 14 of 15 nights" is wrong in the brief and in The
Opening Draft 6. The findings' 14 covers all seventeen nights. Settled from the Transcript Pass's
batch tallies: **volume on 12 of 15 journal-sourced nights and 2 of 2 transcript-sourced.** Draft 6 is
owed the correction.

**10. THE CANONICAL ACCOUNT IS LAYERED.** Dream material arriving in answers enters the account with
its provenance; the capture layer is the telling and corrections; waking material never enters it.
The night mirror shows the account whole, so Draft 2's reason for not showing the clarifying questions
holds. **The mirror questions for the founder are three: stood-out, stance, bridge.** Head of
Interpretation's steer on stood-out is withdrawn under C69-I's reason; The Close argues each as a
founder question, as does the pairing question in its two cases.

**11. THE NIGHT'S ARC IS THE LAST OF THE READINGS, above the grounding check.** The band stays three
deep; the watch becomes four app-authored things in a row. Draft 3 files the position; Recurrence's
relayed mark becomes a pointer.

**12. TWO ADJACENT SLOTS HAVE OPPOSITE RULES FOR ABSENCE** — no arc "stated in one line" (Lens
Practice §9); no series question, silent (C48-I; Recurrence RQ11). Routed to Draft 8 to harmonise,
with the silence rule as the ruled precedent.

**13. ARCHIVING.** When founder material is found in a superseded draft, **the whole draft goes to
restricted/ with a note in archive/** (C71-I's method) — the standing method, since it edits no text.
Replaced passages without founder material are appended to the document's archive as usual.

**14. NO DOCUMENT STATES ITS OWN GOVERNING STATUS.** "Not yet governing" is a self-stated property a
later ruling falsifies. Status lives in this record. Draft 6 is owed the removal; Draft 3 drops it.

**15. THE FRAMEWORK AND THE SCAFFOLDING.** The map states no reason for the grounding check's
position; it points at The Foundations' open item and Lens Practice §8. The second per-person
question — whether non-resolution becomes easier to sit with — is retired with the first (C64-I item
2), and "quarterly" goes. **Fluency signals are read only from the dreamer's turns before any
tradition speaks, never from the space** (C41-I, C48-I item 2). The characterising sentence about the
founder goes to restricted/. The blind-read audit's approval of 2026-09-05 is entered by pointer to
v3's text at 1ca2693c; its owner is named as the Audit Log names it; "only genuine measurement" is
dropped; whether it has run is not established. New files are interpretation-framework-v4.md and
adaptive-scaffolding-v3.md.

**16. THE RECURRING-IMAGE PASS DOCUMENT** stated of itself "written, not yet filed"; a dated note is
appended saying it was filed and its questions ruled at C61-I. Its hash moves; the listing shows it.

**17. OWED — ONE CONSISTENCY PASS BEFORE THE OVERVIEW.** Recurrence & the Series is stale against
C61-I (its empty pool). The Opening Draft 6 owes items 4, 9 and 14 above and the (c1) sentence — the
stood-out answer is not a direct score input but (c1) fires on it. The law document points at "The
Close, draft 2" by number. And C60-I item 4's two counts, still not run.

**WHAT DEPENDED ON THIS.** Lens Practice Draft 8, The Close Draft 3, the Framework Pass, the
consistency pass, and the two founder questions carried by Lens Practice (D13; R4) and three by The
Close (the mirror kinds; the two pairing cases).


---

## C73-I — the framework and the scaffolding filed; the founder's answers on the Foundations block and the labels

**Filed 2026-09-29.** *Item 2 and item 3 are the founder's, given 2026-09-29. Eva's signatures on
the Foundations block are owed.*

**1. FILED.** interpretation/interpretation-framework-v4.md (ad0a22ee), the map, pointing at each
owning document by name and heading and holding no method they own. interpretation/adaptive-scaffolding-v3.md
(b7008848). Framework v3 (1ca2693c) is held whole in restricted/, because it carried founder material,
with an index beside it and a note in archive/ mapping each of its subjects to its new home. Scaffolding
v2 held none and is carried whole in its archive note. **Head of Interpretation's rulings on the pass's
questions:** the map holds the discernment pass's rule text until Lens Practice's next draft states the
pass, then becomes a pointer; the reading-time mark rule belongs to Lens Practice; C72-I item 3's
"Rulings heading" is Lens Practice's decision record heading; C50-I item 4's "inside the readings" is
read as the readings phase, which C72-I item 1's position satisfies; the entry artefact and the lens
feature guide are not carried, superseded by The Close's record and by Lens Practice's selection. The
Close's second surface is named THE LOOK BACK. The law document's pointer to Adaptive Scaffolding by
version joins C72-I item 17's list.

**2. THE FOUNDATIONS BLOCK — THE FOUNDER'S ANSWERS.** Items 1, 2, 3 and 5: sign. **Item 4: option
(a′)** — every session asks the dreamer, after the readings, how much of the dream is accounted for by
their waking life, bound by the form constraint. The founder's reason: it belongs to the integration of
the dream, at the close. Consequences: The Close's waking-life invitation is live, making seven founder
lines; a night asks two waking-life questions, the bridge before the readings and this after; the
Foundations' ruling that the check is model-judged is reversed. **Item 6: sign, with its first site
changed. No cohort is held back pending the distress apparatus; its consequences return when the evidence
shows they are needed.** Unchanged: detection runs (C51-I), testers are told in writing (C47-I), crisis
resources stay reachable (C44-I), and the never-cuttable items stand.
**The block is reissued once, as a one-page signing sheet,** adding the Foundations' §5 definition of
the series — which still names evolving figures and feeling-tone across nights, refused at C55-I and
C56-I — and the sentence C56-I item 1 owes The Foundations.

**3. LABELS, FOUNDER-CHOSEN, IN ENGLISH.** Biblical, knowing both its flaws. Asclepian. Tibetan Dream
Yoga — the file's recommendation that Tibetan teachers or institutions be asked remains open, before
any public use. **Open:** the Zhuangzi–Liezi label, the Advaita label, and whether Egyptian is brought to
readability. Every label in each language is founder-written independently.

**WHAT DEPENDED ON THIS.** The Foundations' signing sheet. The Close's Draft 3 and its seventh line.
Lens Practice's Draft 8, which takes the discernment pass and the mark rule from the map, and whose
grounding-check question is reopened by item 2. The Copy Register.


---

## C74-I — the founder's rulings on The Close, Lens Practice and two labels

**Filed 2026-09-29. Founder-ruled 2026-09-29.**

**1. LABELS.** Advaita Vedanta. **Egyptian is not brought to readability now**; it waits until there is
more real material on the tradition, and stays insufficient material and unserved. The Zhuangzi–Liezi
label remains open: Taoism and Daoism are one word in two romanisations and make the same claim.

**2. THE CLOSE.** **The look back shows what stood out, the stance, and the bridge answer marked as
waking words.** The founder's governing intent for the ending: its weight is the space, for
integration and reflection; the full look back's main home is the journal, where the dreamer returns to
see the night clearly. The look back and the night as it sits in the journal are one thing, stored as
shown and never recomputed. It is the dreamer's own words and the readings as shown, each marked by
voice — never the app's prose in the dreamer's person (C42-I).
**The reflection never uses a stance or bridge answer as the night-side span**, in either case.
**The design stands against The Foundations §5's letter**: the night's arc and the series question come
after the readings and before the dreamer's turn, and nothing written after the readings is used as
evidence. §5's wording is brought to match on the Foundations signing sheet.

**3. LENS PRACTICE — the Draft 8 map's questions.** Yes to Q1 (candidates: unresolved images, any
stood-out image, any image with a return), Q2 (ties seeded, never told order), Q3 (a late stood-out
answer admitted, marked), Q4 (option B: the readings stay with the dreamer's image when no lens has
purchase, and say so), Q6 (waking material read only where a tradition's condition names it, for
purchase only, never quoted, never to prefer a lens) and Q7 (no arc: nothing said). **Q5 is reopened
by C73-I item 2:** under (a′) the grounding check asks the dreamer directly after the readings, so its
form and what it reads are re-derived.

**4. THE FOUNDATIONS SIGNING SHEET carries eight items:** the six answered at C73-I item 2; §5's
definition of the series, with C56-I item 1's owed sentence; and §5's ordering sentence brought to match
the design. Both founders sign item by item.

**WHAT DEPENDED ON THIS.** The Close's Draft 3, revised once to these rulings and filed. Lens Practice
Draft 8. The Foundation & Charter reissue. The Copy Register.


---

## C75-I — The Close, Draft 3, filed; one label; items for the consistency pass

**Filed 2026-09-29.**

**1. FILED.** interpretation/the-close-draft-3.md (434d3616), written to C72-I, C73-I and C74-I. Draft 2
(97cd075a) is archived intact at archive/the-close-draft-2.md — its founder-material scan found none —
with a note (8fbdee67) carrying every replaced passage verbatim, checked by script. The Close's first
handback (13066d09) was superseded before filing and never filed. **One dependency is open and named in
the document:** whether the app renders a grounding check beside the dreamer's answer, which Lens
Practice Draft 8 proposes and the founder is ruling. Five sites are written to hold either way.

**2. THE FORM CONSTRAINT IS THE FOUNDATIONS ITEM 5:** no question the app puts to a dreamer names a
period of their life, entered as a founder ruling at C66-I item 4(b). Both The Close and Lens Practice
read it without that text in hand; The Close marked it relayed, Lens Practice read it as the bridge
test's rule. The bridge test is a separate rule (C70-I item 7).

**3. LABEL, FOUNDER-CHOSEN:** Zhuangzi–Liezi. Daoism may be looked at later. Every label for dreamers
is now chosen in English except Egyptian, which is not served (C74-I item 1).

**4. ADDED TO THE CONSISTENCY PASS (C72-I item 17):** framework v4's two lines made stale by C73-I item 1
("owner is not named"; "Who owns the reading-time mark"), which leave with the held passages when Lens
Practice's pointer block is applied; framework v4's name for The Close's surface; and Lens Practice
Draft 8's proposals to The Close and The Opening, once Draft 8 files.

**WHAT DEPENDED ON THIS.** Lens Practice Draft 8. The Foundations signing sheet. The consistency pass.


---

## C76-I — the dreamer's answer is the grounding check; Lens Practice, Draft 8, filed

**Filed 2026-09-30.** *Item 1 founder-ruled 2026-09-30.*

**1. THE DREAMER'S ANSWER IS THE GROUNDING CHECK. The app renders no check of its own.** Lens Practice's
reading of (a′), adopted: an app-side check placed before the dreamer's answer suggests the answer,
and one placed after argues with the dreamer about their own life. The model-judged form retires
whole. The question itself carries the counterweight, and the dreamer does the weighing. **The
discernment pass remains the app's own press on a reading that is too comfortable.** The Close's five
sites written to hold either way now resolve to no check rendered; the consistency pass writes them so.

**2. FILED.** interpretation/lens-practice.md (95950574), Draft 8, carrying C72-I, C73-I, C74-I item 3
and item 1 above. Draft 7 (a125da11) is archived intact at archive/lens-practice-draft-7.md — its
founder-material read found none — and its replaced passages are appended to lens-practice-archive.md
from the note at efa8b7da. Lens Practice now owns and states the discernment pass and the reading-time
mark rule.

**3. THE FORM CONSTRAINT, BY POINTER.** Its governing text is The Foundations §4.5 as signed — the
signing sheet's Item 5. Until both founders sign, C66-I item 4(b) binds method. C75-I item 2 restated
it more widely than C66-I and is superseded by this pointer. Lens Practice Draft 8 §8 labels the bridge
test (C70-I item 7) "the form constraint", under an assumed mark; the consistency pass relabels it, and
the test may stand as Lens Practice's own rule for the invitation.

**4. THE SIGNING SHEET GAINS A NINTH ITEM:** The Foundations §11's first item records the check as
model-judged and never validatable; after Item 4 appends, that contradicts §4.6 inside one document.
Marked reversed, in the same sitting.

**5. OWED BEFORE THE HANDOFF.** A small waking-material pass: Lens Practice §16.9 proposes a lens-file
template field saying whether a tradition's condition names waking material, which C74-I item 3's Q6
needs answered file by file. Applied to the seventeen files as a pass, like C61-I, never by editing
them. Lens Practice §16.10 to §16.12 go to the consistency pass with the items C72-I item 17 and C75-I
item 4 list.

**WHAT DEPENDED ON THIS.** The Close's band. The signing sheet. The waking-material pass. The
consistency pass. The Requirements List.


---

## C77-I — the Foundations signing: eight items signed by the founder; the series widened to a feeling the dreamer named

**Filed 2026-09-30. Founder-ruled 2026-09-30.** *The founder has signed Items 1 to 6, 8 and 9 of the
signing sheet (6775f8ee). The block appends only when both founders have signed.*

**ITEM 7, OPTION 2.** The series is what returns across nights **in the dreamer's own words — an image,
or a feeling the dreamer named in telling the dream** — brought as a question. **Never how the dreamer
is changing:** no evolving figures, no feeling-tone arc, no trend. Item 7's second half — §4.4's
sentence that a cross-session record about the dreamer is memory of the dreamer whether or not anything
acts on it — is unchanged and signed with it.

**The founder's reason:** how a dreamer feels in their dreams, in different situations, and how that
changes over time, is valuable. **Where that value lives:** in the journal, where every night is kept
in the dreamer's own words and can be searched by them (C56-I item 4). The dreamer noticing their own
change is the practice working; the app computing it is memory of the dreamer.

**What the widening does not widen.** The series question is still spoken only by a tonight's lens
whose file declares an account of something recurring across separate nights (C54-I item 2, C61-I). If
no such lens's account reaches a returning feeling, the slot is silent. The question never sets two
nights' feelings against each other and never characterises a change. The feeling counts only as named
in the capture layer — the telling and its corrections — never from answers, and never a waking feeling.

**WHAT DEPENDED ON THIS.** Foundation & Charter reissues Item 7's first half. Recurrence & the Series'
definition of what recurs — at present, a word the dreamer used for an unresolved image — widens to
match, in the consistency pass. The recurring-image pass's speaker filter, which is read for whether an
account reaches a feeling as well as an image.


---

## C78-I — The Foundations changes: a dated block of nine items, signed by both founders

**Filed 2026-09-30. Signed by Ludvig and Eva, 2026-09-30.** *Written after the append was verified in
the file (C39-I).*

**THE FIRST CHANGE TO THE GOVERNING DOCUMENT SINCE IT WAS RULED GOVERNING (C34-I).** A dated block
(cdd06a71) is appended to interpretation/the-foundations-draft-2.md, which now hashes to 59a62f57. The
body above it is unchanged to the byte (its first 21,323 bytes still hash to bbac3a78). Nothing is
edited in place; each item quotes the text it changes and gives the text that replaces it.

**The nine items, in one line each.** (1) Two clauses in §11 that assumed a position carries fit are
replaced. (2) The subtitle's status claim is deleted. (3) §3: order may carry fit, is never required
to, and the app never tells a dreamer what its order means. (4) §4.6: every session asks the dreamer,
after the readings, how much of the dream their waking life accounts for — option (a′). (5) §4.5: no
question the app puts to a dreamer names a period of their life. (6) Wave becomes Cohort; the distress
apparatus is deferred, not ruled out, and no cohort is held back waiting for it. (7) §5: the series is
what returns in the dreamer's own words, an image or a feeling they named, never how they are
changing; §4.4 gains C56-I's sentence. (8) §5's ordering sentence is brought to the design. (9) §11's
first item is brought to C76-I: the dreamer's answer is the grounding check.

**ITEM 4'S THREE UNSIGNED OPTIONS, kept here and not in the document.** (a) as (a′) without the
constraint — made unavailable by Item 5. (b) "asks" rewritten to describe an internal check put to the
readings and answered from the dreamer's account, keeping the check model-judged — not taken. (c) no
change here, with the repair at The Opening — not taken, because "asks" had been read two ways inside
the department within a week.

**THE FORM CONSTRAINT NOW HAS ITS GOVERNING TEXT** at §4.5 (Item 5). C66-I item 4(b) and C76-I item 3's
pointer resolve to it.

**OWED TO THE NEXT FOUNDATIONS BLOCK.** The founder's north star, which the Shared Core says every
document carries verbatim and The Foundations does not. And the word RECURRENCE, which the governing
document still never uses.

**THE WAKING-MATERIAL PASS — Head of Interpretation's rulings on method.** A condition whose object is
waking but which it locates in the dreamer's account is DOES NOT: waking material never enters the
account (C72-I item 10), so no stance is read into it. The template line Lens Practice §16.9 proposes
is written by the consistency pass and points at the pass's document.

**WHAT DEPENDED ON THIS.** Every document that cites The Foundations by hash. The consistency pass,
whose list included the form constraint's label and §5's wording. The Close, whose band C76-I and Item
9 now settle.


---

## C79-I — which waking answers a tradition may use; two routed items found done

**Filed 2026-09-30. Items 1 and 2 founder-ruled 2026-09-30.** *Extends C74-I item 3's Q6, on the
Waking-Material Pass's questions.*

**1. THE ASKING COUNTS.** What the dreamer says they want from this session may supply a tradition's
condition that names the asking of the night — under the same limits as the stance and the bridge:
only to decide whether a tradition can read, never quoted, never to prefer one tradition over another.

**2. AN ANSWER SUPPLIES ONLY WHAT ITS QUESTION WAS BUILT TO DRAW.** The stance draws the dreamer's
stance tonight; the bridge draws the waking thing one image touches; the asking draws what the dreamer
wants from the session. Anything else an answer happens to carry — station, history, an event — is
recorded as a substitute only and supplies nothing. **The reason:** otherwise traditions read dreamers
who disclose more about their lives, which rewards disclosure and teaches dreamers to tell the app
more. C60-I (b) — a tradition is not widened to make it readable — is the same rule from the other
side.

**3. FOUND DONE.** Foundation & Charter routed two items on closing, both already discharged: The
Opening's "day-context" label, withdrawn at C66-I item 4 (c) and absent from Draft 6; and the law
document's stage-sense "Wave" and "continuity engine", settled when it filed at C66-I item 3 (the
second found done at C63-I item 1).

**WHAT DEPENDED ON THIS.** The Waking-Material Pass's table. Lens Practice's §11 item 5 line, written
by the consistency pass.


---

## C80-I — the bridge may feed a day-residue condition, on every night including fragments; C79-I's description corrected

**Filed 2026-09-30.** *Item 1 founder-ruled 2026-09-30.*

**1. THE BRIDGE MAY SUPPLY A CONDITION THAT LOOKS FOR ITS WAKING OBJECT IN THE ACCOUNT, where that object
is the kind the bridge draws — the waking thing an image touches.** C78-I's rule that such a condition is
DOES NOT now applies to the stance only. In practice this reopens the Freudian day-residue clause. **The
bridge supplies the waking thing and never its recency**, because no question may name a period of the
dreamer's life (The Foundations §4.5). The limits of C74-I item 3 and C79-I hold: only to decide whether a
tradition can read, never quoted, never to prefer one tradition over another; it adds a tradition's
ability to read and never removes it.
**The bridge is asked on every night the dreamer chose to interpret, one-image fragments included**,
replacing any document's exclusion of fragments.
**The founder's reason:** some dreams have less depth than others, and on those a waking-life
perspective can help. **Provisional:** observed in the app and removed if it clouds the readings.
**So that it can be observed,** each night records whether a tradition read because of the bridge —
stored with the night, counted only across all dreamers (C62-I, C63-I item 5). **What clouding would
look like:** on nights where the bridge let a tradition in, that reading leans on the dreamer's waking
life rather than the dream. A Cohort 0 watch item, looked for first on fragments, where a waking answer
is largest beside the dream.

**2. C79-I ITEM 1 DESCRIBED A KIND WRONGLY.** Lens Practice's "the asking of the night" is an intention
formed before sleep — the dreamer seeking a dream — which the Asclepian condition reads. The Opening's
asking is what the dreamer wants from the session, said after waking. Head of Interpretation's
question to the founder treated them as one. **C79-I item 2 governs:** the asking supplies the Biblical
clause that reads it, and not the Asclepian, whose condition nothing supplies. This keeps shut what the
law document forbids — the app helping a dreamer seek a dream. The founder's ruling that the asking
counts stands, for what the asking draws.

**3. HEAD OF INTERPRETATION'S RULINGS ON THE PASS'S QUESTIONS.** A condition is read route by route: a
route that cannot be met without waking material names it. The stance may add a tradition's ability to
read and never remove it; a decline keyed to a dreamer sounding distraught would be a distress route.
Where a lens file says in its own words whether its object sits inside the account, the file's line
governs.

**4. FOUNDER MATERIAL IN TWO FILED REGISTER DOCUMENTS** — register-read.md and one evidence passage of
the specification pass's ledger entries — found by the Waking-Material Pass and not quoted. Both are in
the founder-material pass's scope (C65-I).

**WHAT DEPENDED ON THIS.** The Waking-Material Pass's table, revised on two rows. The Opening, The Close,
Lens Practice and the law document, wherever they exclude the bridge on fragments or state what the
bridge feeds — for the consistency pass, with the question of which image a purchase from a night-level
answer attaches to. The Requirements List, which carries the per-night bridge record.


---

## C81-I — rulings for Consistency Pass A

**Filed 2026-09-30.** *Head of Interpretation's rulings on method, open to the founder.*

**1. LENS PRACTICE §16.11 AND §16.12 ARE ADOPTED.** §16.11 follows from C76-I and The Foundations Item 9:
the band's grounding check and the waking-life invitation are one thing. §16.12 follows from C74-I Q4
option B: The Opening softens "the image the readings will stand in front of" for nights where no
tradition has purchase on it.

**2. THE BRIDGE NEEDS AN IMAGE.** C80-I's "fragments included" means every interpreted night that holds
an image, fragments included. A night with no image — a feeling alone — is not asked the bridge,
because the question has nothing to point at. The waking-life question after the readings still runs on
it. C80-I item 1's rule is general; the Freudian day-residue clause is the case it reopens in practice,
and The Opening states the rule and points at the Waking-Material Pass's table.

**3. "IN TELLING THE DREAM" INCLUDES MIRROR CORRECTIONS.** The capture layer is the telling and its
corrections (RQ1; C67-I item 4). A feeling named in a correction counts.

**4. A FEELING THE DREAMER NAMED IS ANCHORED TO MARKER (d)'S STATED FEELING**: a feeling the dreamer
states the dream-self had, in the capture layer. Not any feeling word, which would make nearly
everything recur.

**5. WHEN AN IMAGE AND A FEELING BOTH QUALIFY, THE SPEAKER IS CHOSEN FIRST**, and then a candidate that
the speaker's account reaches. Competence gates the candidate set (C54-I item 2).

**6. C72-I ITEM 11'S COUNT IS CORRECTED.** Under C76-I and item 1 above, at most three app-authored things
stand in a row before the dreamer's turn: the arc, the invitation that is now the check, and the series
question. The discernment pass is not a visible step.

**7. THE CLOSE'S B3 IS RETIRED IN PLACE**, so that B4 to B11 keep their addresses.

**8. DOCUMENTS CITE EACH OTHER BY NAME AND HEADING, NEVER BY HASH OR DRAFT NUMBER.** The filing entry
records which draft read which. Any heading another document points at stays unchanged.

**9. ROUTING.** Which image a purchase from a night-level answer attaches to is Lens Practice's, for
Consistency Pass B. The two counts owed since C60-I item 4 — Recurrence's test of its definition on the
first telling, and marker (a) on the first telling against the written account — go to one small chat
after both consistency passes file, because the first tests the definition this pass widens.

**WHAT DEPENDED ON THIS.** Consistency Pass A's three replacements. Consistency Pass B, which receives
item 9's first question.


---

## C82-I — the Waking-Material Pass filed

**Filed 2026-09-30.**

**FILED.** interpretation/lens-register/lens-register-waking-material-pass.md (32eeb771), the single
source for whether each lens file's condition names waking material. The findings ledger (5f487108)
gains WM-1 to WM-5; its earlier bytes are unchanged, identical to 19616845. The dated prediction
(140829e5) beside them. The first handback (3898feeb) was superseded before filing and never filed.

**THE RESULT.** Seventeen files: seven NAMES, eight DOES NOT, two NOT APPLICABLE. **Waking material can
change whether a tradition reads for three served files** — Talmudic through the stance, Biblical
through the asking, Freudian through the bridge — and it can only add a reading, never remove one. The
other three NAMES files need a social station, which no question is built to draw, so nothing supplies
them (C79-I item 2). Egyptian is answered and unserved. The prediction, published before reading and
not moved, had all four counts right before C80-I moved one file.

**WHAT DEPENDED ON THIS.** Lens Practice's §11 item 5 line and the question of which image a
night-level purchase attaches to, both for Consistency Pass B. The Requirements List, which carries the
per-night bridge record. WM-1 to WM-5.


---

## C83-I — C82-I corrected; rulings for both consistency passes

**Filed 2026-09-30.** *Head of Interpretation's rulings on method, open to the founder. The founder's
question on the feeling half of the series (Consistency Pass A's F2) is not ruled here.*

**1. C82-I CORRECTED.** Its "the other three NAMES files need a social station ... so nothing supplies
them" reads: **the other four NAMES files are supplied by nothing — three need a station, and the
Asclepian an intention formed before sleep** (C80-I item 2). Found by the Waking-Material Pass on
closing; WM-1 and its table read "nothing 4".

**2. A TRADITION WHOSE ACCOUNT IS NOT ESTABLISHED TO REACH A RETURNING FEELING DOES NOT ASK ABOUT ONE.**
Not established is operated as does not reach (C54-I item 2: competence gates who may speak). On
Consistency Pass A's reading, none of the three DECLARES files is established to reach a feeling; the
feeling half of what recurs is silent on every night until a row changes.

**3. CITATION (C81-I item 8), HOW FAR IT REACHES.** Live pointers go by name and heading. A [READ] mark
names the document and heading; the hash it was read at moves to the filing entry. A sentence that
describes what a past version said keeps that version's name, since renaming it would falsify it.

**4. THE GROUNDING CHECK'S INSTRUMENT.** The count of what the dreamer's answer concluded is retired
(The Foundations Item 9, Where D). **Whether a dreamer answered at all may be counted** — presence
only, stored with the night, counted only across all dreamers, reported and never optimised.

**5. A PURCHASE THAT COMES FROM WAKING MATERIAL GROUNDS ON THE CONCENTRATED IMAGE AND IS ORDERED WITH
SPILL, NEVER WITH ANCHOR.** A general rule: waking material may let a tradition read, and may never move
it ahead of traditions grounded in the dream (C74-I item 3 Q6). Answers C81-I item 9's question.

**6. LENS PRACTICE §11 ITEM 5 GAINS A SIXTH KIND: THE SESSION'S ASKING** — what the dreamer wants from
this session — distinct from the asking of the night, an intention formed before sleep. The two were
conflated at C79-I and corrected at C80-I; the template now names them apart. **§11 item 15** reads an
account of an image or a feeling recurring across separate nights (C77-I).

**7. THE LIMITS REACH EVERY QUESTION AND INVITATION THE APP PUTS TO A DREAMER**, before the readings or
after them. The law document's sentence names them as that, not as a list.

**8. THE PER-NIGHT BRIDGE RECORD** (C80-I) is named among the law document's stored data and in the
tester disclosure, which must say what is stored.

**9. THE TESTER DISCLOSURE SPECIFICATION IS REPLACED, NOT CHECKED.** Its appended block of 2026-09-15 is
folded in and archived verbatim. It says firings are stored with the night and read in Cohort 1 as one
cohort total (C63-I items 3 and 5), that a reviewer reads one night at a time and anonymity is not
claimed at four testers (C63-I item 4), and that no cohort waits on the distress apparatus (The
Foundations Item 6).

**10. EVERY REPLACEMENT CARRIES THE FOUNDER'S NORTH STAR**, verbatim, as the Shared Core requires. The
clouding watch item (C80-I) is held in Lens Practice's watch list.

**WHAT DEPENDED ON THIS.** Consistency Pass A and B's replacements.


---

## C84-I — the feeling half's source work; rulings for both consistency passes

**Filed 2026-09-30.** *Item 1 founder-ruled 2026-09-30.*

**1. THE RULE STANDS, AND THE FREUDIAN SOURCE IS READ WHOLE — AFTER THE HANDOFF.** Consistency Pass A's
option (b). One chapter of Freud's 1920 text is read whole to settle whether his account reaches a
returning feeling; the lens file read it in excerpt only. It is done after the handoff to Product,
alongside the Egyptian source work (C74-I item 1). Until then the feeling half of what recurs is silent,
and the journal carries its value: the dreamer can search their own feeling words across nights.

**2. REGISTER DOCUMENTS KEEP THEIR HASH ANCHORS.** C83-I item 3 moves hashes out of pointers and marks in
method documents. A register document's rows record what file was read at what hash; those anchors are
its method and stay.

**3. RECURRENCE'S ANSWER TO LENS PRACTICE'S OPEN QUESTION NOW RESTS ON THREE GROUNDS, NOT FOUR.** Under The
Foundations §5 as signed, the order ground no longer stands alone; the other three each suffice. C55-I's
outcome does not move. C54-I item 3's count describes Recurrence Draft 2's readable set, which has since
grown with the records; Recurrence Draft 3 holds the current set.

**4. A PURCHASE FROM WAKING MATERIAL IS SPENT AFTER EVERY DREAM-GROUNDED PURCHASE,** anchor and spill,
never before. And **a tradition that has purchase only through waking material has purchase**: that night
is not the no-purchase case of C74-I item 3 Q4. Both follow from C74-I item 3 Q6 and from the founder's
reason for the bridge at C80-I — thin nights.

**5. NOT RULED, RECORDED FOR THE OVERVIEW.** How long distress firings are stored. The tester disclosure
requires the founders' text to state it and to promise nothing it cannot keep.

**6. NOTED.** The law document's line that its constraints override the framework is an authority
claim consistent with the role block, not a self-stated status, and stays. Script fingerprints are
provenance for figures, not citations. Lens Practice §9A's first held question, which says the stance is
the only reading of the dreamer's own the session holds, is now outdated by the session's asking; it
stays held for Lens Practice's next draft. The Close's "Then the entry" goes to Consistency Pass A.

**WHAT DEPENDED ON THIS.** Consistency Pass A and B's replacements, which file together. The list of work
after the handoff.


---

## C85-I — volume in answers is kept as a measure of the app's own attention

**Filed 2026-09-30.** *Head of Interpretation's ruling, open to the founder. Found by Consistency Pass A:
no ruling covered whether to keep recording something no reading uses.*

**KEPT.** The Opening records how much the dreamer said in answer about each image, and hands it on marked
confounded. Lens Practice receives it and does not consume it (C72-I item 5). **It is kept as a measure of
the app's own attention — measurement, never input** — so that whether the app's questions are driving
where attention goes can be seen, which is the confound the Transcript Pass found (C66-I item 1). Stored
with the night, counted only across all dreamers (C62-I; C63-I item 5).

**WHAT DEPENDED ON THIS.** The Opening's "What is handed on", which states it. The Requirements List.


---

## C86-I — both consistency passes filed in one commit

**Filed 2026-09-30.** *The last design work before the handoff: seven documents brought level with each
other and with every ruling since each was filed. No new design; every change carries an entry.*

**FILED.** Recurrence & the Series, Draft 3 (4a273d5c). The Close, Draft 4 (b2708555). The Opening,
Draft 7 (da8dba85). Lens Practice, Draft 9 (cddb4beb). Interpretation Framework v5 (77178b99). The law
document, privacy-ethics-safety.md (4f83555e). The tester disclosure specification (f28b64e1), its
appended block of 2026-09-15 folded in (C83-I item 9).

**SUPERSEDED, WHOLE TO archive/,** each checked by hash before the move: Recurrence Draft 2 (123ea64b),
The Close Draft 3 (434d3616), The Opening Draft 6 (c38207e6), Lens Practice Draft 8 (95950574, as
lens-practice-draft-8.md), framework v4 (ad0a22ee). Founder-material scans of each, against the journal
and — for Consistency Pass A's three — against the transcripts, found no dream material. Archive notes
carry every replaced passage verbatim, each checked by script with none missing; Lens Practice's are
appended to lens-practice-archive.md. The superseded signing draft foundations-block-draft-for-founders.md
(bfdc1e43), never filed, moves to archive/.

**THE RECURRING-IMAGE PASS** gains Consistency Pass A's dated note: none of the three DECLARES files is
established to reach a returning feeling. A dated line records its two questions ruled. Its hash moves;
the listing shows it. The prediction the note was read against sits beside it (a797b867).

**WHICH DRAFT READ WHICH (C81-I item 8; C83-I item 3).** Consistency Pass A's three read The Foundations
at 59a62f57, Lens Practice at 95950574, the law document at abafbaaf, the Waking-Material Pass at
32eeb771, the Transcript Pass findings at 71c27f3a and its correction at 88d78c8a, and the Asclepian,
Freudian and Zhuangzi–Liezi lens files at c9de45f9, 5f1544ee and 2a19447b. Consistency Pass B's four
read The Foundations at 59a62f57, The Opening at c38207e6, The Close at 434d3616, Adaptive Scaffolding at
b7008848, the Register Read's blocks at 22f1f5e2, the Waking-Material Pass at 32eeb771 and the Audit Log
at c356124a. The hashes moved out of Lens Practice's marks read: The Opening Draft 6 c38207e6 and Draft 4
25a7512c; the Transcript Pass findings 71c27f3a; The Close Draft 2 97cd075a; Recurrence Draft 2
123ea64b; the law document abafbaaf; framework v3 1ca2693c; Lens Practice Drafts 7 and 6 a125da11 and
bd4dd30e. **Final cross-check:** Consistency Pass B re-ran every pointer in both directions, content as
well as headings, against Recurrence at 4a273d5c, The Opening at da8dba85 and The Close at b2708555 —
all hold.

**WHAT DEPENDED ON THIS.** Every document cites the others by name and heading now, so none of these hashes
appears in their text. The small counts chat, which tests Recurrence Draft 3's definition. The
founder-material pass. The overview. The Requirements List.


---

## C87-I — the founder-material pass may edit handed-over files and records, once, for that reason only

**Filed 2026-09-30. Founder-ruled 2026-09-30**, with its reach to records as Head of Interpretation's
reading of C65-I, open to the founder.

**RULED: OPTION (a).** The lens files' evidence sections quote the frozen journal, because that is how each
tradition was tested. Handed-over lens files are never edited (C24-I convention 3); the Shared Core forbids
the founder's material in any shared document. **The founder-material pass edits the lens files once, for
this reason only:** each quoted passage of the founder's material moves verbatim to a file in restricted/,
a pointer takes its place, and a dated line in the lens file records the removal. **Every figure stays.**
Nothing else in the files changes. C24-I convention 3 exists to protect a file's findings, and this leaves
them untouched.

**THE SAME EXCEPTION REACHES THE APPEND-ONLY RECORDS** — this change record, the findings ledger and the
audit log — because C65-I named the change record among the places the material sits. A passage is
replaced in place by a pointer to restricted/, and a dated line records it. This is the only edit an
append-only record is ever permitted.

**WHAT DEPENDED ON THIS.** The founder-material pass. The history rewrite that follows it.


---

## C88-I — rulings for the founder-material pass and the counts chat

**Filed 2026-09-30.** *Head of Interpretation's rulings on method, open to the founder. Two questions —
whether C87-I's reach to the append-only records stands, and whether a sealed copy of the history is kept
before the rewrite — are with the founder and not ruled here.*

**THE FOUNDER-MATERIAL PASS.**
1. The shared manifest locates each instance by an identifier, the file, and the nearest non-material
   text as its anchor. The exact string sits only against that identifier, in restricted/.
2. **The closing condition:** zero hits on the restricted string list across every tracked file outside
   restricted/, except a named report-only set; and a reading record showing every candidate read and its
   disposition. A string scan cannot see paraphrase, so the reading record is what the claim rests on.
3. Every tracked file of every type is scanned, not only Markdown.
4. **A night's date used only as the key to a figure is not founder material.** A date that carries
   content — an image, an event — loses the content; the date may stay.
5. Where a moved passage held a count, the pointer restates the count.
6. **No cuts.** Every removal is a move to restricted/ with a pointer, an invented example, or a count.
   Nothing silently disappears.
7. **This pass issues the replacements** of live documents for founder material only — removal,
   invented examples and counts, and nothing else. Each new draft is a change-record entry with its
   dependents.
8. A file moved whole from archive/ to restricted/ leaves a note at its exact former path, so every
   pointer to it still resolves. Files in archive/ belonging to Product & Design or Organisation, like
   their live documents, are report-only; the founders rule on them.
9. The string list uses short distinctive phrases, not whole passages, so earlier wordings are caught.
   A founder-run count over every past commit measures the rewrite before and after.
10. restricted/ is not tracked (C25-I). Every file this pass creates there has its hash in the restricted
    manifest.
11. **The split is adopted:** this chat takes inventory and the archive moves; a second pass the lens
    register and ledger; a third the live documents and the records.

**THE COUNTS CHAT.** Both consistency passes filed at C86-I; the definitions it tests are Recurrence
Draft 3 and The Opening Draft 7 as filed there. Marker (a) is scored from The Opening's text, at night and
scene level, with "ends in waking" counted apart. Count 1 reports the telling alone and the telling with
corrections, never pooled; Count 2's "before" is the telling alone, with the corrected figure beside it.
The image half is reported against the prediction in its own terms; the feeling half gets its own dated
prediction, never presented as the original's. The term list for the negative check lives in restricted/
with its hash. **2026-07-04 is not an exception**: C43-I's post-lens figure for it was an extractor
error, corrected at C64-I item 5.

**WHAT DEPENDED ON THIS.** The founder-material pass and its two successors. The counts chat.


---

## C89-I — the records exception confirmed; a sealed copy of the history is kept

**Filed 2026-09-30. Founder-ruled 2026-09-30.** *Answers the two questions C88-I left open.*

**1. C87-I'S REACH TO THE APPEND-ONLY RECORDS IS CONFIRMED.** The change record, the findings ledger and
the audit log may each be edited once, for founder material only: the passage moves verbatim to
restricted/, a pointer takes its place, a dated line records it. It is no longer a reading open to the
founder.

**2. A SEALED COPY OF THE HISTORY AS IT STANDS IS KEPT, BEFORE THE REWRITE.** One complete copy of the
repository's unrewritten history is made and held in restricted/, founders and counsel only, never pushed
and never shared. Every figure in the department carries the command that produced it; after the rewrite,
that copy is the only place the original inputs survive, so the figures stay checkable against it. **This
reverses the earlier plan to delete the backup once the rewrite was verified.**

**THE FOUNDER'S OWN ACTION, NOT A RULING:** restricted/ is outside version control (C25-I). Everything
moved there, the sealed copy included, is kept safe only by the founders' own encrypted copy off this
machine.

**WHAT DEPENDED ON THIS.** The founder-material pass and its two successors. The history rewrite.


---

## C88-I — rulings for the founder-material pass and the counts chat

**Filed 2026-09-30.** *Head of Interpretation's rulings on method, open to the founder. Two questions —
whether C87-I's reach to the append-only records stands, and whether a sealed copy of the history is kept
before the rewrite — are with the founder and not ruled here.*

**THE FOUNDER-MATERIAL PASS.**
1. The shared manifest locates each instance by an identifier, the file, and the nearest non-material
   text as its anchor. The exact string sits only against that identifier, in restricted/.
2. **The closing condition:** zero hits on the restricted string list across every tracked file outside
   restricted/, except a named report-only set; and a reading record showing every candidate read and its
   disposition. A string scan cannot see paraphrase, so the reading record is what the claim rests on.
3. Every tracked file of every type is scanned, not only Markdown.
4. **A night's date used only as the key to a figure is not founder material.** A date that carries
   content — an image, an event — loses the content; the date may stay.
5. Where a moved passage held a count, the pointer restates the count.
6. **No cuts.** Every removal is a move to restricted/ with a pointer, an invented example, or a count.
   Nothing silently disappears.
7. **This pass issues the replacements** of live documents for founder material only — removal,
   invented examples and counts, and nothing else. Each new draft is a change-record entry with its
   dependents.
8. A file moved whole from archive/ to restricted/ leaves a note at its exact former path, so every
   pointer to it still resolves. Files in archive/ belonging to Product & Design or Organisation, like
   their live documents, are report-only; the founders rule on them.
9. The string list uses short distinctive phrases, not whole passages, so earlier wordings are caught.
   A founder-run count over every past commit measures the rewrite before and after.
10. restricted/ is not tracked (C25-I). Every file this pass creates there has its hash in the restricted
    manifest.
11. **The split is adopted:** this chat takes inventory and the archive moves; a second pass the lens
    register and ledger; a third the live documents and the records.

**THE COUNTS CHAT.** Both consistency passes filed at C86-I; the definitions it tests are Recurrence
Draft 3 and The Opening Draft 7 as filed there. Marker (a) is scored from The Opening's text, at night and
scene level, with "ends in waking" counted apart. Count 1 reports the telling alone and the telling with
corrections, never pooled; Count 2's "before" is the telling alone, with the corrected figure beside it.
The image half is reported against the prediction in its own terms; the feeling half gets its own dated
prediction, never presented as the original's. The term list for the negative check lives in restricted/
with its hash. **2026-07-04 is not an exception**: C43-I's post-lens figure for it was an extractor
error, corrected at C64-I item 5.

**WHAT DEPENDED ON THIS.** The founder-material pass and its two successors. The counts chat.


---

## C89-I — the records exception confirmed; a sealed copy of the history is kept

**Filed 2026-09-30. Founder-ruled 2026-09-30.** *Answers the two questions C88-I left open.*

**1. C87-I'S REACH TO THE APPEND-ONLY RECORDS IS CONFIRMED.** The change record, the findings ledger and
the audit log may each be edited once, for founder material only: the passage moves verbatim to
restricted/, a pointer takes its place, a dated line records it. It is no longer a reading open to the
founder.

**2. A SEALED COPY OF THE HISTORY AS IT STANDS IS KEPT, BEFORE THE REWRITE.** One complete copy of the
repository's unrewritten history is made and held in restricted/, founders and counsel only, never pushed
and never shared. Every figure in the department carries the command that produced it; after the rewrite,
that copy is the only place the original inputs survive, so the figures stay checkable against it. **This
reverses the earlier plan to delete the backup once the rewrite was verified.**

**THE FOUNDER'S OWN ACTION, NOT A RULING:** restricted/ is outside version control (C25-I). Everything
moved there, the sealed copy included, is kept safe only by the founders' own encrypted copy off this
machine.

**WHAT DEPENDED ON THIS.** The founder-material pass and its two successors. The history rewrite.


---

## C90-I — a dream told late; unresolved status for recurrence; the counts chat's paths

**Filed 2026-10-01.** *Head of Interpretation's rulings on method, open to the founder. Found by the
counts chat.*

**1. A DREAM TOLD UNPROMPTED AFTER THE QUESTIONS BEGIN IS A LATE TELLING.** The Opening's record kinds
have no place for it: it is neither a mirror correction nor an answer. It is the dreamer's own dream
material and enters the account with its provenance marked late. **It is not the capture layer**,
because it came after the app had spoken: no later night reads it for recurrence (RQ1; C67-I item 4).
The Opening's list of record kinds gains it at its next revision; the Requirements List carries it
meanwhile.

**2. FOR RECURRENCE, WHETHER AN IMAGE IS UNRESOLVED IS JUDGED ON THE CAPTURE LAYER ONLY.** The Opening's
markers (c1) and (c2) read answers; Recurrence's definition reads only the capture layer. So an image's
status for recurrence may not depend on material the definition excludes.

**3. THE COUNTS CHAT FILES** its page at interpretation/counts-2026-09-30.md and its predictions beside
it; its field records and its term list in restricted/ only.

**WHAT DEPENDED ON THIS.** The counts chat's page. The Opening's next revision. The Requirements List.


---

## C91-I — C88-I and C89-I appear twice; commits now wait on the check; rulings owed

**Filed 2026-10-01.**

**1. C88-I AND C89-I EACH APPEAR TWICE, and the second instance of each governs** (C46-I's precedent). The
two instances are byte-identical, so no citation changes meaning. Neither is deleted. **The cause:** the
filing check printed both duplicates and the commit ran regardless, because nothing tied the commit to the
check's result. **From this entry, every filing command commits only if the check prints nothing.** The
check now permits C41-I, C88-I and C89-I twice each, and catches any other duplicate or gap:

    grep -oE "^## C[0-9]+-I" interpretation/change-record.md | sed 's/## C//;s/-I//' | sort -n | uniq -c | awk '{k=($2==41||$2==88||$2==89)?2:1} $1>k {print "DUPLICATE C"$2"-I"} NR>1 && $2!=p+1 {print "GAP after C"p"-I"} {p=$2}'

**2. TWO ACCEPTANCES FOR THE COUNTS CHAT, ENTERED.** For Count 2, the telling alone is what the dreamer said
before the first question. And Count 1 reports against Recurrence's own predictions PR1, PR3 and PR4, with
the chat's predictions beside them and never presented as theirs.

**3. THE FOUNDER-MATERIAL PASS'S THREE QUESTIONS.** technology/old-build-report.md and SHARED-CORE.md are
report-only. archive/foundations-block-draft-for-founders.md and
archive/foundations-technology-header-removed-2026-09-12.md are archive files, moved whole under C88-I item 8
if they hold material. The scripts in interpretation/lens-register/ go to the second pass and those in
interpretation/ to the third, under C87-I; the dated line is a code comment, and the originals stay runnable
in the sealed copy (C89-I item 2).

**4. THE FROZEN JOURNAL HOLDS FIFTEEN ENTRIES.** One labels its fields with a colon, which is why a count of
one label form finds fourteen (found by the specification pass, SP-2).

**5. PROPOSED TO THE FOUNDERS:** the role block's listing command gains a line showing modified files not
yet committed. Its "written but not filed" line lists untracked files only and cannot see an edited tracked
file — found by the founder-material pass.

**WHAT DEPENDED ON THIS.** Every citation of C88-I and C89-I. Every filing command from here.


---

## C92-I — the counts filed

**Filed 2026-10-01.**

**FILED.** interpretation/counts-2026-09-30.md (4fc7b73a), carrying no dream material, its negative check at
zero; the predictions beside it (c1ba48c0), locked before any transcript was read; the Count 1 script and
output and the negative-check script. The field records, term list and anchors are in restricted/ only.

**COUNT 2 — MARKER (a), RR-8.** It fires on 7 of 15 written accounts against 4 of 15 first tellings. Every
night open in the telling stays open; the questions added unresolved material and did not close it — the
opposite of the confound C43-I named. Consistent-with only: one dreamer, one reader, a separation the
chat discloses as partial. RR-8 is answered by this page.

**COUNT 1 — RECURRENCE'S DEFINITION ON THE CAPTURE LAYER.** On the twelve nights that can have a prior
night, an image recurs on 4 under a strict reading of which of the dreamer's words count, 8 under a broad
one; the feeling half fires on 7. **If both nights must hold the image unresolved, on none.** PR1 and PR4
hold under one reading and fail under the other.

**TWO FINDINGS FOR RECURRENCE'S OWNER, NOT RULED:** which of the dreamer's words for an image count; and
whether one side of a recurrence must be anchored or both. **Carried to the overview.**

**WHAT DEPENDED ON THIS.** Recurrence & the Series' definition of what recurs. The findings ledger's RR-8.
The question budget. The overview.


---

## C93-I — C92-I corrected in three places

**Filed 2026-10-01.** *Found by the counts chat on closing. The page, interpretation/counts-2026-09-30.md,
was right; C92-I's summary of it was not.*

**1.** C92-I's "on the twelve nights that can have a prior night" reads: **on the twelve nights past the
fifth, which are the prediction's own terms.** Sixteen nights can have a prior night; over those the figures
are 5 strict, 10 broad, and 8 for the feeling half.

**2.** C92-I's "if both nights must hold the image unresolved, on none" reads: **under the strict reading,
on none; under the broad, on 5 of 12, and on 4 of 12 for the feeling half.**

**3.** C92-I's "every night open in the telling stays open" reads: **on the scored rule.** Counting a dream
that ends in waking, one night is open in the telling only through that line and closed in the written
account, and the figures become 7 against 5.

**THE PRACTICE, FROM THIS ENTRY:** an entry filing a finding points at the finding's page for its figures,
rather than restating them. Three restatements in one entry went wrong in one afternoon.

**WHAT DEPENDED ON THIS.** The overview, which reads the counts page and not C92-I.


---

## C94-I — the cost test's wording is founder material; the rule is not

**Filed 2026-10-01.** *Head of Interpretation's ruling, open to the founder. The Founder-Material Pass's
R-1.*

**RULED: THE WORDING ONLY.** One clause of the discernment pass's cost test, in Lens Practice, shares nine
words in order with a line in the frozen journal, carried through earlier framework versions. **The
wording is reworded; the rule stands.** It rests in Lens Practice on its own reasons — the calibration
clause and the two recorded problems — and nothing offers the journal as its reason, so the Shared Core's
"as principle" is not engaged. The journal line sits in its associations field, which C42-I found to be
app-composed prose in the dreamer's first person.

**WHICH DRAFT.** The current Lens Practice is Draft 9 (C86-I). The reworded document is Draft 10, issued
by the third pass under the split (C88-I item 11), and Draft 9 then goes whole to restricted/ with a note
in archive/ (C72-I item 13). The same run in archived files — framework v2 and v4, the framework's v4-to-v5
note, Lens Practice Draft 8 — follows the archive rule (C88-I item 8).

**WHAT DEPENDED ON THIS.** The third pass. Lens Practice's §9A held questions are not touched.


---

## C95-I — C86-I's clean scans of two archived drafts, overtaken by C94-I

**Filed 2026-10-02.** *Found by the Founder-Material Pass reading archive/.*

**WHAT C86-I SAID.** That founder-material scans of each superseded draft found no dream material before
it went whole to archive/. **True on its own terms, and overtaken:** C94-I, a day later, ruled the cost
test's wording founder material. Lens Practice Draft 8 and Interpretation Framework v4 both carry it. So
both entered archive/ holding founder material, which C72-I item 13 does not permit. Neither scan was wrong;
the ruling that made them insufficient came after.

**WHAT FOLLOWS.** Both move whole to restricted/ with a note at their former paths, as the Founder-Material
Pass records (its FM-011 and FM-013). C86-I's statement stands for The Opening Draft 6, The Close Draft 3
and Recurrence Draft 2, which the pass's reading confirms hold none. **Lens Practice Draft 9 says Draft 8
went to archive/ carrying no founder material; Draft 10 does not repeat that statement.**

**ALSO RECORDED.** The four archive files replaced on 2026-09-10 hold no founder material. The brief to the
pass listed them among the known sites; C65-I did not, and the reading shows they hold none.

**WHAT DEPENDED ON THIS.** The third pass's Draft 10 of Lens Practice. Anything citing C86-I as showing
archive/ clean.


---

## C96-I — the founder-material inventory filed; eight archive files moved whole to restricted/

**Filed 2026-10-02.** *The Founder-Material Pass, inventory. Under C65-I, C87-I to C89-I, C94-I and C95-I.*

**WHAT WAS DONE.** fm_scan.py, version 2, ran once on the repository against the frozen journal and the
seventeen transcripts, the transcripts never entering a chat. Every candidate in the records, the live
documents, archive/ and the report-only files was read, with two supplementary searches for paraphrase:
1,592 rows, each with a disposition, in the reading records. **Fourteen instances in thirteen files.** Two
were found by reading and not by any scan.

**MOVED WHOLE TO restricted/archive/ (C88-I item 8)**, a note left at each former path so every pointer
resolves: The Opening Draft 4, the superseded Advaita, Asclepian and Zhuangzi–Liezi lens files, framework
v2, framework v4, the framework's v4-to-v5 archive note, and Lens Practice Draft 8. The manifest gives each
file's hash before and after.

**FILED** in interpretation/founder-material-pass/: the manifest, the four reading records, the widened
search, the lens-register candidate list for the second pass, the judgement files and build script, and
the scan, search and move scripts. None holds a restricted string. The instances themselves are held only
in restricted/founder-material-instances.md.

**HANDED ON.** The second pass: the lens register and its ledger. The third pass: the records' four
instances under C87-I, and the cost test's wording under C94-I. **Report-only, to the founders:** one
instance in Technology's old build report, and a record in it that the build repository's test fixtures
hold condensations of the founder's real dream accounts — outside this department, and to be replaced
before anyone else has access to that repository.

**WHAT DEPENDED ON THIS.** The second and third passes. The history rewrite's strings list. Every pointer to
the eight archive paths, which now resolve to notes. The build repository.


---

## C97-I — Technology's old build report is cleaned; the old build repository is left as it is

**Filed 2026-10-02. Founder-ruled 2026-10-02.**

**1. THE THIRD PASS CLEANS technology/old-build-report.md** under C87-I's method, as it does the records:
the passages holding the founder's material (the Founder-Material Pass's FM-014) move verbatim to
restricted/, a pointer takes their place, a dated line records it. Technology is closed, and the file sits
in the repository that goes to Product & Design.

**2. THE OLD BUILD REPOSITORY IS NOT CLEANED.** Its test fixtures hold condensations of the founder's real
dream accounts. The founders are replacing that build rather than carrying it forward, and it is held by
them alone. **The condition that stands:** if any part of it is carried into a new build or shared with
anyone, the Shared Core applies and the fixtures are replaced first.

**WHAT DEPENDED ON THIS.** The third pass. Technology, when it reopens.


---

## C98-I — C96-I and the founder-material manifest corrected in two statements

**Filed 2026-10-03.** *Found by the Founder-Material Pass on closing.*

**1.** C96-I says the manifest gives each moved file's hash before and after. It gives neither. Both are in
interpretation/founder-material-pass/fm_archive_moves.py (409e6f56); each before-hash is also in that file's
note at its former path.

**2.** The manifest (d85e135d) says no detector could see one of its instances, and C96-I says two instances
were found "not by any scan". **What is true:** both were missed by fm_scan.py and found by the
supplementary paraphrase searches — one by the first, one by the widened search — and reading decided both.
The manifest stays as filed; this entry is its correction. The conclusion holds more strongly: the
paraphrase searches are what found them, so they run in every area.

**WHAT DEPENDED ON THIS.** The second pass, which runs both searches in the lens register on this ground. The
third pass, which reads the manifest beside this entry. Anything citing the manifest for the moves' hashes.


---

## C99-I — rulings for Founder-Material Passes 2 and 3

**Filed 2026-10-03.** *Head of Interpretation's rulings on method, open to the founder.*

**FOR PASS 2 — THE LENS REGISTER.**
1. **C87-I's method reaches every handed-over file in the lens register,** not only the lens files and the
   ledger: the three wave handovers, register-read.md, the Register Read's blocks, the recurring-image and
   waking-material pass documents, and the three locked prediction files. None is a live playbook. In a
   prediction file the pointer leaves every predicted figure and its date untouched, so the lock holds.
2. **A generated output may move whole to restricted/**, with a note at its exact path, when more than half
   of its non-blank lines are founder material and it can be regenerated from its filed script in the sealed
   copy (C89-I item 2). The note restates every figure the output held (C88-I item 5).
3. **The widened paraphrase search was described and never filed.** Pass 2 reconstructs it as
   fm_widened_search.py, marked as a reconstruction, and it passes only if it reproduces the sixteen rows of
   fm-widened-search.tsv at their lines.
4. In a text output with no comment syntax, the dated line is a plain line at the top, in the same words.
5. **Numbering:** Pass 2 takes FM-015 to FM-099; Pass 3 takes FM-101 onward.
6. **The closing scan for both passes is one founder-run scan** — fm_scan.py with the transcripts, and every
   restricted string from all three passes, over every tracked file outside restricted/ — after both have
   applied their edits. Neither pass closes on its own partial scan.

**FOR PASS 3 — THE LIVE DOCUMENTS AND RECORDS.**
7. **Lens Practice Draft 10 changes the cost-test clause and every sentence in which Draft 9 describes
   itself or Draft 8's founder material** — its header, its changes paragraph, its history sentence, its
   founder-material paragraph and its closing — so that it states nothing false about itself. Nothing else.
8. **A second sentence in the same passage characterises the founder from the journal's record, with a
   count.** It is founder material offered as evidence, which the Shared Core forbids, as with the sentence
   moved out of the framework at C72-I item 15. It moves to restricted/; the pointer keeps the problem in
   general words and restates its count without the founder. The cost test's other two clauses are not
   changed (C94-I).
9. **Draft 9 goes to restricted/archive/lens-practice-draft-9.md, with its note at
   archive/lens-practice-draft-9.md.** Replaced passages without founder material are appended to
   interpretation/lens-practice-archive.md as usual (C72-I item 13); the reworded clause goes to restricted/
   only, and the archive entry points at it.
10. Every figure inside a moved passage is restated in its pointer, as a count with no wording (C88-I item 5).
11. In Technology's old build report, only the characterisations of the founder's dreams move. Every count,
    the fixture's name, the finding about the prompt and the date stay.
12. **The pointer is the dated line:** one line in place, carrying the date and the FM identifier.
13. The change record is edited only if its earlier lines still hash as they did when read — only appends
    have happened since — and the file is re-read immediately before the write. The other files take a
    full-hash check.
14. The restricted manifest is the shared manifest addendum: it lists each restricted file a pass creates,
    with its hash and no content.

**WHAT DEPENDED ON THIS.** Both passes' plans and scripts. The closing scan before the history rewrite.


---

## C100-I — one more correction to the manifest; rulings for Pass 3's plan

**Filed 2026-10-03.** *Head of Interpretation's rulings on method, open to the founder.*

**1. THE MANIFEST'S CLAIM THAT THE COST TEST'S WORDING IS CARRIED INTO lens-jungian.md AND
sp-rr7-part4-output.txt IS NOT TRUE OF EITHER FILE.** Found by Pass 2: neither shares a run of four or more
content words with the passage, tested line by line and across line breaks. The lens register had not moved
since the scan, so the claim was not true when written. The manifest stays as filed; this entry is its
correction.

**2. PASS 3'S PLAN, RULED.**
- **interpretation/lens-practice-archive.md takes C87-I's method once**, a pointer in place: it holds, from
  Lens Practice Draft 8, the sentence C99-I item 8 moves, and moving the whole file would take every Lens
  Practice replacement's archive with it.
- **Pass 3 moves any file in archive/ that holds that sentence**, whole, under C88-I item 8, after a
  founder-run locate step that prints file names only.
- **Pass 3's instances are numbered FM-101 onward** (C99-I item 5).
- In Technology's old build report, the sentence quoting the shipped prompt restates by inference what the
  first sentence of the same paragraph removes: **it is reworded, and the quoted prompt text moves to
  restricted/**.
- Draft 10's changes to its archive rule, its heading, the line about "this draft", and the filing table are
  within C99-I item 7: each is a statement the document makes about itself.
- The audit log and change-record pointers keep "not a count of dreams", the unit of the count, which is not
  founder material.

**WHAT DEPENDED ON THIS.** Pass 3's script. The manifest, read beside C98-I and this entry.


---

## C101-I — one pointer form for both passes; the closing scan's exceptions; C100-I narrowed

**Filed 2026-10-03.** *Head of Interpretation's rulings on method, open to the founder.*

**1. C99-I ITEM 12 BINDS BOTH PASSES.** Every pointer in a file Pass 2 or Pass 3 edits takes one form —
the FM identifier and the date, dated from the founder's machine at run time — so that the closing scan
and the history rewrite read every pointer alike.

**2. A MANIFEST ADDENDUM CARRIES BOTH** the instance table C88-I item 1 requires and each restricted file's
hash, with no content (C99-I item 14).

**3. THE CLOSING SCAN NAMES TWO EXCEPTIONS.** The first pass's fm-manifest.md and judgements_reportonly.py
each hold one of the build report's scrub strings, inside a description of method. They are not founder
material where they sit; the closing scan reports them as named exceptions, and the history rewrite treats
them like any other occurrence. **The closing scan normalises whitespace**, so a string broken across a
line is still found (found by Pass 2).

**4. C100-I's LAST BULLET NARROWED.** Only the audit log's pointers carry "not a count of dreams"; the change
record's never did (found by Pass 3).

**WHAT DEPENDED ON THIS.** Pass 2's apply script, re-issued. The closing scan.


---

## C102-I — Founder-Material Pass 3 applied: the records, Lens Practice Draft 10, Technology's report

**Filed 2026-10-03.** *Under C87-I, C89-I, C94-I, C95-I, C97-I and C99-I to C101-I.*

**APPLIED** by fm_pass3_apply.py, which checked every file's hash before writing, built and checked every
change in memory, wrote the change record last after a second read, and rolls back on any failure. The
change record and the audit log take pointers for FM-001 to FM-004. **Lens Practice becomes Draft 10:** the
cost test's clause is reworded with its rule unchanged (C94-I); the sentence characterising the founder
moves, its problem kept in general words and its count restated (FM-101; C99-I item 8); every statement the
document makes about itself is brought level (C99-I item 7). The same sentence in lens-practice-archive.md
takes a pointer (FM-102; C100-I). Technology's old build report takes five pointers; its figures, fixture
name and findings stay (FM-014; C97-I). **Draft 9 is held whole in restricted/archive/, with a note at
archive/lens-practice-draft-9.md** (C72-I item 13).

**EVERY HASH BEFORE AND AFTER, and each restricted file's, is in
interpretation/founder-material-pass/fm-manifest-addendum-pass-3.md**, written by the script from what is
on disk. This entry points at it rather than restating them (C93-I).

**STILL TO DO.** Any file in archive/ the locate step shows holding the moved sentence goes whole to
restricted/ in Pass 3's next script (FM-103 onward). Then the one closing scan for every pass.

**WHAT DEPENDED ON THIS.** Anything citing Lens Practice by draft number. Anything relying on Draft 9's
statement that Draft 8 carried no founder material (C95-I). The history rewrite's strings list, which gains
Pass 3's additions. The closing scan.


---

## C103-I — the widened search cannot be reproduced; what replaces it in the lens register

**Filed 2026-10-03.** *Head of Interpretation's ruling, open to the founder. Found by Founder-Material Pass 2.*

**THE RECONSTRUCTION FAILED C99-I ITEM 3's TEST** — nine of sixteen rows reproduced, seven missing, twenty-three
extra — **so it does not stand.** The first pass's widened pattern was described and never filed, and no
honest route to it remains: a pattern tuned until it reproduced the sixteen rows would prove only that it had
been tuned. The reconstruction is kept, its header recording the failed check, as a record of the attempt;
nothing rests on it.

**IN THE LENS REGISTER, WHAT THE WIDENED SEARCH WAS FOR IS MET** by a deliberately over-wide search for death
content and for references to the founder's own dreams as real, every hit read, together with the reading of
every evidence section in full. Its pattern is in Pass 2's addendum. The first pass's sixteen rows stand, as
reading decided them.

**POINTER FORM.** Pass 3 applied first, so its form governs; Pass 2 matches it exactly (C101-I item 1).

**WHAT DEPENDED ON THIS.** Pass 2's addendum and apply script. The closing scan.


---

## C104-I — the Head of Interpretation briefing takes C87-I's method once

**Filed 2026-10-03.** *Head of Interpretation's ruling, open to the founder. Found by Founder-Material Pass 3.*

**interpretation/head-of-interpretation-briefing.md** holds, in a run of thirteen of its twenty-two words, the
sentence C99-I item 8 moved out of Lens Practice. The first pass read the live area before that sentence was
ruled founder material, so nothing judged it there. **The briefing is a record (C33-I),** corrected only by
appended dated blocks (C32-I), and an appended block cannot remove material. **It takes C87-I's method once,
as lens-practice-archive.md did (C100-I item 2):** the passage moves verbatim to restricted/, one dated pointer
in the same general words and count takes its place, and nothing else in the briefing changes. If its wording
differs from Lens Practice's, the history rewrite gains a scrub string for it, held in restricted/ only.

**WHAT DEPENDED ON THIS.** Pass 3's last script. The history rewrite's strings list.


---

## C105-I — the lens register cleaned of founder material (Founder-Material Pass 2)

**Filed 2026-10-03.** *Under C65-I, C87-I to C89-I, C91-I item 3, C94-I, C96-I, C98-I to C101-I and C103-I.*

**WHAT WAS DONE.** All 37 files of interpretation/lens-register/ were read, unchanged since the scan's commit:
every candidate (936 distinct lines), both paraphrase patterns, every lens file's evidence section in full, and
the four files without candidates in full. The reading record has 2,003 rows, each with a disposition. In place
of the widened search, which could not be reproduced (C103-I), an over-wide search was run and every hit read.
**240 passages in 16 files moved verbatim to restricted/ under C87-I** (FM-015 to FM-030), each replaced by a
pointer in Pass 3's form, dated from the founder's machine (C99-I item 12; C101-I item 1); every figure stays.
**One generated output moved whole** (FM-031; C99-I item 2), with a note at its path restating every figure.
**17 of the register's 37 files held founder material:** 14 of the 17 lens files, all in their evidence
sections; the findings ledger; register-read.md; and the output. 188 strings were added to the rewrite's list.

**APPLIED** once by the founder, 2026-10-03, by fm_lens_register_apply.py (8da199bd), which checked every hash
before writing and its pointer form against Pass 3's. The negative check found none of 246 restricted strings,
and no pointer was left undated. **Every after-hash, and each restricted file's hash, is in
fm-manifest-addendum-lens-register.md**, each reproduced independently by Pass 2; this entry points at it
rather than restating them (C93-I).

**FOUND, AND RULED ELSEWHERE.** The first pass's carry claim for the cost test's wording (C100-I item 1). The
first pass's two files holding a build-report scrub string (C101-I item 3). The widened reconstruction's failed
check (C103-I).

**FILED** in interpretation/founder-material-pass/: the addendum, the reading record, the judgements file,
build_record_lr.py, fm_widened_search.py (the failed reconstruction, kept as its record) and
fm_lens_register_apply.py.

**WHAT DEPENDED ON THIS.** The closing scan for every pass. The history rewrite, whose strings list gains Pass
2's. Every citation into the edited files' evidence tables, which now resolve to pointers. sp-rr7-part4.py,
which reproduces its output only in the sealed copy (C91-I item 3). wave3-gate-2026-09-11.txt's hash list,
which records the lens files as they were and no longer matches them, by design.


---

## C106-I — the Head of Interpretation briefing cleaned; no archive file held the sentence

**Filed 2026-10-03.** *Founder-Material Pass 3, under C99-I item 8, C100-I item 2 and C104-I.*

**APPLIED** by fm_pass3_briefing.py: the one passage in interpretation/head-of-interpretation-briefing.md moved
verbatim to restricted/, replaced by one dated pointer in the same general words and count as FM-101 and FM-102
(FM-103). Nothing else in the briefing changed; the script checked that before writing. **No new scrub string
was owed:** the existing one already occurs in the passage.

**NO ARCHIVE FILE HELD THE SENTENCE.** Pass 3's locate step found no file in archive/ above its threshold, so no
archive move was owed and its archive-moves script was not run or filed. **The limit, stated:** the locate step
sees the sentence's words in order and in loose windows; a paraphrase avoiding most of them would pass it, and
the closing scan's reading is the backstop (C98-I).

**HASHES** before and after are in the last section of fm-manifest-addendum-pass-3.md.

**WHAT DEPENDED ON THIS.** The closing scan for every pass.


---

## C107-I — three ordinary words are not scrub strings; who reads the pointers' own lines

**Filed 2026-10-03.** *Head of Interpretation's rulings on method, open to the founder. Found by Founder-Material
Pass 3 while building the closing scan.*

**1. THREE SINGLE WORDS ON THE FIRST PASS'S STRING LIST ARE ORDINARY ENGLISH,** extracted from longer quotations.
**They are not scrub strings, for the closing scan or for the history rewrite:** in the scan they flag every
ordinary use, and in the rewrite they would strip those words from every file in the history. The longer
strings that contain them stay, and so do single words that are names from the material. The three are held in
restricted/fm-closing-scan-exclusions.txt, so that no shared file names them, and the closing scan pins its hash.

**2. THE POINTERS' OWN LINES ARE READ BY PASS 3.** The passes' edits created lines no reading record has seen.
The closing scan lists them by file and line, counts only, and every one is read. Pass 2 has closed, and a
pointer carries no material by construction, so Pass 3 reads all of them.

**WHAT DEPENDED ON THIS.** The closing scan. The history rewrite's strings list.


---

## C108-I — every line written since the scan is read before the closing condition can be met

**Filed 2026-10-03.** *Head of Interpretation's ruling, open to the founder. Extends C107-I item 2.*

**C107-I item 2 reaches every candidate line written since the original scan's commit that no reading record has
seen** — new entries, both addenda, the passes' scripts, Lens Practice Draft 10, the briefing, the edited lens
files — not only the pointers. These lines were written by the passes and the head, not taken from the material,
and Pass 3 reads all of them. **Any it finds to be founder material takes an FM disposition, and the closing
condition is not met until it moves.** The first run of the closing scan is therefore expected to report the
condition not met.

**WHAT DEPENDED ON THIS.** The closing scan and its reading record.


---

## C109-I — four lines in the lens register, judged at the closing scan

**Filed 2026-10-03.** *Head of Interpretation's rulings, open to the founder, on four judgement calls Founder-Material
Pass 3 made reading the closing scan's unread lines. The line drawn is C99-I item 11's: what a dream contained
moves; its form stays.*

**THREE ARE FORM, AND STAY.** A line in lens-artemidorus.md saying a night's third dream was words without a scene;
a line in lens-biblical.md counting a night as two rounds with many scenes — a count of rounds is a count; and a
line in lens-biblical.md saying a message was seen rather than spoken. Each describes how a dream came, not what
it held.

**ONE IS CONTENT, AND MOVES.** A line in lens-talmudic.md explains its verdict by naming the emotion the dream held.
Naming what a dream held is founder material (FM-104). Only the three words naming it move, under C87-I, which
already covers lens files; the verdict, both existing pointers and the remaining clause stay.

**WHAT DEPENDED ON THIS.** The closing scan's judgements file. FM-104's move.


---

## C110-I — FM-104 moved; the closing scan reads the addendum's last listing

**Filed 2026-10-03.** *Founder-Material Pass 3, under C87-I and C109-I.*

**APPLIED** by fm_pass3_fm104.py: three words in lens-talmudic.md naming the emotion a dream held moved verbatim to
restricted/, one dated pointer in place. The verdict, the two existing pointers and the remaining clause stand;
the script checked that nothing else changed before writing. The three words are added as one scrub string, in
restricted/ only. **Every hash before and after is in the last section of fm-manifest-addendum-pass-3.md.**

**THE CLOSING SCAN IS REVISED** (fm_closing_scan.py, now 1a0213e5): Pass 3's addendum is read from the committed tree
and its strings file must match the addendum's last listing, because each Pass 3 move changes both. Pass 2's
addendum stays pinned in full.

**WHAT DEPENDED ON THIS.** The closing scan. The history rewrite's strings list.


---

## C111-I — entry dates since C99-I corrected by the commit log

**Filed 2026-10-05, by this machine.**

**Entries C99-I to C110-I carry 2026-10-03 in their headings.** Head of Interpretation carried a stale date from
earlier in its conversation into them, the failure C57-I recorded and ruled against. Several were filed on
2026-10-05: the pointer FM-104 placed is dated 2026-10-05 by the founder's machine, as is Pass 3's addendum.
**Per C57-I, commit dates govern** where a heading disagrees. The headings are not edited. **From this entry, every
entry's date is written by the founder's machine at the moment of filing**, never typed by the head. Found by
Founder-Material Pass 3.

Commit log for interpretation/change-record.md, the last twenty-five commits, at this filing:
    2026-10-05  867f743  C110-I: FM-104 moved
    2026-10-05  48f53cd  C109-I: four lines judged at the closing scan
    2026-10-05  8223fe1  C108-I: every line written since the scan is read
    2026-10-03  a842a76  C107-I: three ordinary words are not scrub strings
    2026-10-03  50ec5b4  C106-I: the briefing cleaned; no archive file held the sentence
    2026-10-03  962fbdf  C105-I: the lens register cleaned of founder material
    2026-10-03  a23046d  C104-I: the briefing takes C87-I's method once
    2026-10-03  5c6c47a  C103-I: the widened search cannot be reproduced
    2026-10-03  abd80f0  C102-I: Founder-Material Pass 3 applied
    2026-10-03  f9f2878  C101-I: one pointer form; the closing scan's exceptions
    2026-10-03  42d31dd  C100-I: one more manifest correction; rulings for Pass 3's plan
    2026-10-03  6c736fe  C99-I: rulings for Founder-Material Passes 2 and 3
    2026-10-03  894b6bc  C98-I: C96-I and the founder-material manifest corrected
    2026-10-03  5f8e42d  C97-I: Technology's old build report cleaned; the old build left as it is
    2026-10-03  bd8d636  C96-I: the founder-material inventory filed; eight archive files moved whole
    2026-10-03  7485c4b  C95-I: C86-I's clean scans of two archived drafts, overtaken by C94-I
    2026-10-03  b29916f  C94-I: the cost test's wording is founder material; the rule is not
    2026-10-01  98c5995  C93-I: C92-I corrected in three places
    2026-10-01  94eded3  C91-I and C92-I: duplicates recorded, commits gated; the counts filed
    2026-10-01  0d2b1cc  C90-I: a dream told late; unresolved status for recurrence
    2026-10-01  e82eebb  C89-I: the records exception confirmed; a sealed copy of the history is kept
    2026-10-01  1a3cd8b  C88-I: rulings for the founder-material pass and the counts chat
    2026-09-30  d02996d  C89-I: the records exception confirmed; a sealed copy of the history is kept
    2026-09-30  71146f7  C88-I: rulings for the founder-material pass and the counts chat
    2026-09-30  2c529e8  C87-I: the founder-material pass may edit handed-over files and records, once

---

## C112-I — the founder-material work closes: the closing condition met

**Filed 2026-10-05, by this machine.** *Founder-Material Passes 1 to 3, under C65-I and C87-I to C110-I.*

**CLOSING CONDITION MET at commit ea450e7**, by fm_closing_scan.py run once by the founder with the settings of the
first scan: the frozen journal, the seventeen transcripts, and the same turn and dreamer patterns. The scan proved those
settings by reproducing every unchanged file's original scan rows exactly before trusting anything else.

**WHAT IT SHOWED.** No string from any pass's list stands in any tracked file outside restricted/, whitespace-normalised,
beyond C101-I item 3's two named exceptions, each used once. No line any reading record judged founder material
stands anywhere. Every candidate line written since the original scan has been read and recorded, in
fm-reading-record-closing-1.tsv. Its last lines are below.

**WHAT THE THREE PASSES DID, IN ONE PLACE.** The inventory (C96-I) read every area outside the lens register and moved
eight archive files whole; the second pass cleaned the lens register (C105-I); the third pass cleaned the records,
Lens Practice, Technology's old report, the briefing and one more lens line (C102-I, C106-I, C110-I). Every passage
moved is held verbatim in restricted/ only, with its strings. **The founder's material is out of every shared
document in this repository.** The old build repository is outside this department and was left as C97-I rules.

**THE LIMIT, STATED ONCE MORE.** Scans find strings and runs; reading decides. Paraphrase that avoids every searched
word could pass both, and is answered only by the reading records, which cover every candidate the scans raised.

**WHAT DEPENDED ON THIS.** The sealed copy of the history, then the history rewrite, which is built from the three
passes' restricted string lists less C107-I's three ordinary words. The overview. The Requirements List.

The closing scan's final lines at this commit:
      fm_scan: self-match	PASS	1.000 of eligible lines hit
      fm_scan: negative	PASS	0 tier-A hits (expect 0)
      fm_scan: listed=148	restricted_excluded=0	source_excluded=0	scanned=148
      fm_scan: target_lines_read=55354	binary=0	undecodable=0
      fm_scan: == OK ==
    reproduction: 86 files unchanged since 98c5995; 0 differ from their reading records
    lines read as founder material still standing: 0
    candidate lines: 2001; read: 2001; UNREAD: 0
    unread lines written, without text, to restricted/fm-closing-unread.tsv
    
    PART A: MET   PART B: MET
    CLOSING CONDITION: MET

---

## C113-I — C112-I narrowed to what the closing scan showed

**Filed 2026-10-05, by this machine.** *Found by Founder-Material Pass 3 on closing.*

C112-I's sentence "The founder's material is out of every shared document in this repository" reads: **at the commit
C112-I names, no string on any pass's list and no line any reading record judged founder material stands in a tracked
file outside restricted/, and every candidate line the scans raised has been read and recorded.** It is a statement of
what the closing scan showed, not a property of the repository. Stated as a property, it is the kind of sentence a later
finding falsifies and a later chat trusts — the shape that produced two of the instances the passes removed. C112-I's
limit paragraph stands beside it: paraphrase that avoids every searched word could pass both scans.

**WHAT DEPENDED ON THIS.** Any later citation of C112-I's sentence. The overview, which states the result this way.


---

## C114-I — rulings for the history rewrite

**Filed 2026-10-05, by this machine.** *Head of Interpretation's rulings on method, open to the founder, on the History Rewrite's fourteen items.*

**1. THE INPUT IS EVERY FILE IN restricted/, NOT ONLY THE THREE PASSES' LISTS.** Material moved to restricted/ before
the founder-material passes — the law document's removed text (C63-I item 8), The Opening Draft 5 (C71-I), the
framework's sentence about the founder (C72-I item 15), framework v3 (C73-I), and any other — is on no list. Each
restricted file is tested against history; any passage found joins the rewrite's input.

**2. THE REWRITE RUNS IN FOUR LAYERS THROUGH ONE MATCHER:** every moved passage verbatim; the strings, to catch earlier
wordings; whole-path handling; and a residual check over every rewritten blob. History is to hold no more of any passage
than the current tree does.

**3. FILES MOVED WHOLE.** At an archive path, every historic version that is not the note is dropped, checked by blob,
and the note survives byte-identical. At every live path where those documents once stood, the other layers apply.

**4. THE FOUNDER'S RULINGS D1 TO D11 AND THE TABLE OF 2026-09-09 ARE CARRIED INTO THIS RECORD BEFORE THE REWRITE.**
C67-I item 1 entered them by pointer to a file now held in restricted/; after the rewrite that pointer resolves nowhere
a later chat can read. The History Rewrite drafts an entry carrying their text, checked against every restricted
string, for Head of Interpretation to file. The Opening Draft 5's path is then cleaned like any live path, not dropped.

**5. THE CLOSING SCAN IS RE-RUN AT THE SEALED COPY'S COMMIT, and nothing is committed from then until the push.**

**6. THE REWRITE CHANGES TWO FILES AT THE CURRENT TREE, as C101-I item 3 says:** fm-manifest.md and
judgements_reportonly.py. A check says whether the script's occurrence is in a comment or docstring only; the entry
filing the rewrite records both new hashes; and every other tracked file is byte-identical before and after.

**7. THE PROOF:** every string counted across every revision, before (each at least one) and after (each zero); the
original scan's tier A at zero over every blob, with the transcripts; commit messages, notes and tags included. **Lines
that exist only in history before the original scan were never read.** They are counted first. If 600 distinct lines or
fewer, they are read, as under C108-I; if more, any historic version holding one is replaced whole by a one-line
marker, and the sealed copy keeps the original.

**8. MATCHING.** Single words on word boundaries; longest first; one replacement marker for everything, dated by the
founder's machine and distinct from the FM pointers. **Each string's reach outside paths that ever held an instance is
shown first; any string reaching ordinary text comes to Head of Interpretation before the rewrite**, ruled as C107-I was.

**9. EVERY OLD COMMIT MAPS.** Empty-commit pruning is off; the mapping has one row per old commit and none null; every
commit ID cited in the current tree is checked to map. "Resolves" means the same message, author, date and files, with
removed material gone. Figures computed over removed material reproduce only in the sealed copy (C89-I item 2).

**10. THE SEALED COPY** is the whole repository database archived byte for byte, plus a bundle of all references, both
hashed and verified, held in restricted/. The rewrite runs in a fresh clone elsewhere, never in the working repository.

**11. THE REMOTE.** The commits not yet pushed are not pushed before the rewrite. Server references a clone does not
fetch are checked. GitHub's retention and purge procedure is taken from its current documentation.

**12. OTHER COPIES.** Every other clone, the co-founder's included, is deleted and cloned fresh after the push, never
pulled or pushed from. The working copies on the founder's machine are cleared in one clean-up step after the push.

**13. THE PROJECT MIRRORS** are replaced from the new tree after the push and hash-checked.

**14. NOT THE ROOT-COMMIT METHOD** of C25-I, unless item 7 finds history that cannot otherwise be cleaned.

**WHAT DEPENDED ON THIS.** The History Rewrite's plan, discovery script and rewrite.


## C115-I — The Opening Draft 5's rulings carried into this record; three rulings for the history rewrite

**Filed 2026-10-05, by this machine.** *Items 1 to 3 carry the founders' rulings of 2026-09-07 and 2026-09-09
verbatim. Item 4 is Head of Interpretation's rulings of 2026-10-05, open to the founder. Drafted by the History
Rewrite; the ordinal is Head of Interpretation's to confirm at filing.*

**1. WHY THIS ENTRY CARRIES TEXT.** C67-I item 1 entered the rulings of 2026-09-07 (D1 to D11 and the unnumbered
rulings of that date) and the table of 2026-09-09 by pointer to the Rulings heading of the-opening-draft-5.md
(68a486e5). Draft 5 has been held whole in restricted/ since C71-I, and its archive note,
archive/the-opening-draft-5-archive-note-2026-09-29.md, carries no Rulings section (the founder's check,
2026-10-05). So the pointer resolves nowhere a later chat can read. Under C114-I item 4 the text is carried here,
verbatim from Draft 5's §12, read in the restricted copy whose sha256 begins 68a486e5. **C67-I item 1 still says
which of these rulings stand and which later entries move them; this entry restates none of that.** Section signs
below are Draft 5's sections; "this document" in the table is Draft 5.

**2. THE RULINGS OF 2026-09-07, as Draft 5 records them.**

**2026-09-07** — D1 mirror names neither tone nor charged image · D2 mirror spoken and
text · D3 the unit is the turn · D4 association image-anchored, no waking-life bridge
· D5 day-context moves to the grounding check · D6 one fixed invitation for the asking
· D7 series-blind by construction · D8 three question turns per night · **D9 overturned:
a computed 1–5 score, not two settings** · D10 completion is signal, then no-new-image,
then budget · D11 the a–d criterion adopted, (d) on watch · the mirror shows the dreams
in order · §3 is *The Clarifying Questions* · the record is correctable at the mirror ·
**Foundations §5 governs the questions, not the mirror; the amendment withdrawn; the
mirror's limit is transcribed-not-concluded** · the gate keeps what it has and stops
being terminal · E1 direct text editing, every edit recorded · E2 structural
corrections applied, wording applied literally, the app never composes · the score is
computed after editing.

**3. THE TABLE OF 2026-09-09, as Draft 5 records it.**

**2026-09-09**

| | Ruled |
|---|---|
| A lens is a named tradition | Continuity and Series are never lenses, stapled or standing alone. §11's column corrected on 11 of 15 nights. |
| Watch item 3 widens | Signal (c) joins (d) under watch; (c) is the only door detail volume can enter through. §5.1 |
| Signal (d) stays | And the argument for dropping it does not survive checking. §5.1 |
| Return and emphasis | Carried from Lens Practice §16.2 as §6.8 and behaviour item 13. A requirement; without it concentration is inoperative. |
| The paired-diff rule is withdrawn | With the app rebuilt from first principles there is no prior prompt to pair a diff with. §17.2 |
| The 2026-09-08 status table is withdrawn | §17.3 |
| The motif engine is RECURRENCE | *Continuity* now names only the day-residue account. **This document contains no instance of the word to replace** `[READ, counted 2026-09-09]`. §2.3 |
| Blocks fold into the body | This document is a method document; its convention is replacement, not layering. Header. |

**4. RULED FOR THE HISTORY REWRITE (C114-I).**
- **Q1. Multi-word strings match regardless of capitals;** single words stay case-sensitive and word-bounded (C114-I
  item 8). Found by the History Rewrite's rehearsal: a string at a sentence start, capitalised, was missed.
- **Q2. C114-I item 7 counts the scan candidates among the lines that exist only before 98c5995,** not every such
  line, as every pass read the same words, C108-I included. The 600 threshold applies to candidates.
- **Q3. The plan, its prediction and its scripts are filed together in interpretation/history-rewrite/.**
- **Stage 2 of the history rewrite, ruled by Head of Interpretation, open to the founder.** S1: the three-word phrase of this department's method vocabulary that the closing scan could not see in its capitalised form is excluded from the scrub strings as C107-I's three words were, held by hash in a second pinned exclusions file in restricted/, once the History Rewrite has read its two occurrences outside the instance paths and confirmed them method text; the proof gains a line that every remaining occurrence stands on a line also present in the current tree. S2: all 1,336 lines that exist only before the original scan's commit are read, more than C114-I item 7 as narrowed requires; no version is replaced by a marker unless the reading finds material. S3: the one non-text version in the history is named, and if it is a document format its text is extracted and checked like any other. S4: runs left after the passages and strings are removed are counted and read; those judged method text are cleared by hash in a pinned restricted file, and the proof is zero uncleared runs beside the original scan's tier A at zero.

**WHAT DEPENDED ON THIS.** C67-I item 1, whose pointer now has its text in this record. The History Rewrite: The
Opening Draft 5's path is cleaned, not dropped (C114-I item 4); its matcher (Q1); its reading of item 7 (Q2); its
filing (Q3). The sealed copy, which is made only after this entry is filed (C114-I item 5).

---

## C116-I — the cache file untracked; the rewrite's tools filed; what "tier A at zero" means

**Filed 2026-10-06, by this machine.** *Head of Interpretation's rulings, open to the founder, on the History Rewrite's S3 and Q4.*

**1. 1 TRACKED CACHE FILE(S) UNDER __pycache__/ ARE UNTRACKED, and .gitignore ignores __pycache__/.** The one that entered after the closing scan read NOT CLEAN against its source: two six-word runs shared with a
restricted file, cause undetermined. So the rewrite drops every version of every path under __pycache__/ from the
whole history, and its proof fails if any such path remains. Untracking it now keeps an unread binary out of the
current tree and out of the sealed copy's closing scan, and stops it being added again.

**2. THE HISTORY REWRITE'S TOOLS ARE FILED** in interpretation/history-rewrite/ (C115-I, Q3): its plan, its prediction
and the scored prediction, its reading record of the 1,336 lines that exist only in early history, and its scripts —
each checked to hold no restricted string, no moved passage and no run of the journal. Filed before the seal, so the
sealed copy holds the tools that made it.

**3. "THE ORIGINAL SCAN'S TIER A AT ZERO" (C114-I item 7) MEANS ZERO ONCE TWO KINDS OF LINE ARE SET ASIDE:** lines
that stand in the current tree, which the closing scan read; and lines read by the History Rewrite and cleared by hash
in a pinned restricted file (C115-I, S4). The transcripts hold the app's own turns as well as the dreamer's, so the
app's method language matches method text in the documents; without this, the proof could not pass even on the
current tree.

**WHAT DEPENDED ON THIS.** The closing scan at the sealed copy's commit. The proof. The rewrite.


## C117-I — The history rewrite: done once, proved, pushed; its record

**Filed 2026-10-07, by this machine.** *Drafted by the History Rewrite; the ordinal is Head of Interpretation's to
confirm at filing. Every figure is the founder's own run, relayed, unless marked otherwise. No founder material
appears here.*

**1. WHAT WAS DONE.** The repository's history was rewritten once, under C114-I, so that no revision holds more of
any moved passage than the current tree does. Every commit was kept and mapped. The rewritten main was pushed on
2026-10-06 with a lease on the commit it replaced (90b8829), and the server was verified by a fresh clone: same
commits, same tree. The server's main is now 051519f.

**2. THE SEALED COPY (C89-I item 2; C114-I item 10).** Made at S = 8c6beec, 2026-10-05, after the closing scan was
MET there (C114-I item 5), and held in restricted/history-rewrite/sealed/:
- the whole .git, byte for byte: 10,588,160 bytes, sha256 81889cc9a03c273710cdfa81b3fc43776c529f86c734a5ce4c761d66d84abe55;
- a bundle of every reference: 1,495,435 bytes, sha256 1052edeae360333b7a92f93f71c1d78d401a3332f25ee5716da76e08f2acc0e4;
- its manifest: sha256 46e1ea8c2a4aa36e03994e89da69a73cb4fa07bb6d758d6b83ee7924cf7aedb0.
Verified at sealing: 128 of 128 commits in the bundle; 769 objects, identical in the archive; fsck clean; 84 cited
commits resolve; no revision ever tracked restricted/. Every figure computed over removed material reproduces only
here.

**3. WHAT THE REWRITE APPLIED.** 589 rules through one matcher: 246 strings (the three passes' lists, less C107-I's
three words and string 200, C115-I S1) and 343 passages (every passage file, pinned, read by hr_passages.py; C71-003
withdrawn, item 6 below). Overlapping matches merge into one marker; versions under __pycache__/ are dropped (C116-I
item 1); at each archive path of a file moved whole, only its note remains. Run: 103 versions rewritten, 9 archive
versions and 1 cache version dropped, 0 messages changed, 1,010 replacements.

**4. THE PROOF (C114-I item 7; C116-I item 3).** hr_proof.py, over the rewritten clone against the working
repository at S, returned PROOF: MET:
- exactness: 0 versions, 0 messages and 0 authorship records differ from the original with the rules applied;
- every rule at 0 in every version and message; string 200 only on lines standing at HEAD;
- 14 six-word runs shared with restricted files were read and judged method text, and cleared by hash
  (restricted/history-rewrite/cleared.txt, sha256 16542996d1b332d12a85266f239e130781865e2b927ae5dca4b989777fa4b2bb);
- fm_scan's tier A: 10 hits, all on lines standing at HEAD, 0 uncleared; its controls passed over 331 versions;
- 128 commits mapped, none null; all 84 commits cited at HEAD map;
- no restricted/ or cache path in any commit; refs: main only; no unreachable object.

**5. THE MAPPING (C65-I; C114-I item 9).** interpretation/history-rewrite/commit-map-2026-10-06.tsv, 128 rows of old
and new commit IDs, sha256 37bed3088384553cc5603a41f758c48aec9b9d6ade0f8ca3faef2e5e26de9818, committed alone as
051519f. **Every commit ID cited in this record before this entry is an old ID; it resolves through that file.**
Messages kept their old IDs, as the files did.

**6. RULINGS ENTERED HERE.**
- **Q5.** fm-reading-record-closing-2.tsv (sha256 9dd9ece0019b5f47f977d41ccba1db6ba3a17cedcc5ebfc9966a9cad7bc2d1bb,
  13 rows, 0 founder material) was committed alone, with no entry, so no new entry's lines could reopen the scan.
  It is entered here.
- **Q6.** Passage C71-003 is withdrawn: ordinary method text standing in The Opening Draft 7 and the archived Draft 6,
  split out of Draft 5's removed-material file by the extractor. Withdrawals file sha256
  180ad04d3138b765b45641ec29e3340e83d9569891431d713ad26b2d6b0c9bd1; passages file then 343, sha256
  13b8cb7361ff40bbfb8ff88432c2eaddc0c97b82d6dbe05d3802a902acb4e682. The before-count now stops if any rule matches the
  current tree outside the two named exceptions; at S it matched none.

**7. AT HEAD, TWO FILES CHANGED, AS C101-I ITEM 3 SAID THEY WOULD.** Each held one occurrence of one FM-014 string.
- interpretation/founder-material-pass/fm-manifest.md: was d85e135d, now
  ee08c891d61cc51812ea27febb59bf07ad512a3299d054990b8f3babda63ad85. Every citation of d85e135d, in the addenda and in
  C98-I and C100-I, names the file as it stood; it is in the seal.
- interpretation/founder-material-pass/judgements_reportonly.py: now
  4dba147d5c7fb9ebba8ba287fb7080cced5cc24a1c301c370607fa1d2c2ead8a. The occurrence was in a comment (discovery's check).
Every other tracked file at HEAD is byte-identical to S.

**8. FILED WITH THIS ENTRY, in interpretation/history-rewrite/, superseding their C116-I versions where named:**
hr_proof.py d65baf34 (supersedes 7c3768e9); hr_passages.py 84ce05d4 (supersedes 15cd14cc); hr_rehearse_proof.py
fd68fcc6 (supersedes 64f71775); history-rewrite-plan.md 2c25c6fc (supersedes 3c17530e); and, new: hr_seal.py
c41cf1f5, hr_rehearse_seal.py 4145e694, hr_map_commit.py 0580b536, hr_push.py 126df46c, hr_rehearse_push.py
d95db774, hr_replace.py 41646045, hr_rehearse_replace.py 2c0e8896. hr_rewrite.py stays as filed,
1b4ae036: it is the version that ran. Its environment line printed git's version badly; the rehearsal's line has it,
git 2.50.1. Filed as run, not corrected.

**9. ON GITHUB'S SIDE.** The old commits are unreachable from any ref on the server but may persist in its cached
views until GitHub Support removes them. A request naming the first changed commit, 8ff9db3 (now 0f231c8), was
not yet sent; to be recorded in a later entry. GitHub's documentation says Support assists only where the risk cannot be removed by rotating
credentials `[READ 2026-10-05]`; personal material cannot be rotated. Their answer is theirs.

**10. THE FOUNDER'S MACHINE (C114-I item 12).** The working copy was replaced from the server by hr_replace.py:
restricted/ moved across in one rename, every file's sha256 identical before and after; the unrewritten copy kept
beside it until the founder removes it, as his own step, after re-checking the seal's hashes in their new place.
Still the founder's, after this entry: the encrypted off-machine copy of restricted/, the seal included (C89-I); the
project mirrors, refreshed from the new tree and hash-checked (C114-I item 13); and the deletion of this project's
past chats once the rewrite is verified.

**WHAT DEPENDED ON THIS.** Every commit ID in every record: resolved through item 5's file. Every figure computed
over removed material: reproduced only in item 2's seal. C98-I and C100-I, which cite fm-manifest.md's earlier hash:
item 7. C112-I's closing condition: re-run and MET at S before the seal. The project mirrors and the founder's working
copy: item 10. Anything Technology or Product holds that cites a commit ID of this repository: resolves through item
5. The old build repository: out of scope (C97-I), unchanged by this.

No matter where you are on your journey, the steps you take are equally important.

---

## C118-I — the founder's rulings at the overview; the Support decision and the access condition it sets

**Filed 2026-10-07, by this machine.** *Items 1 to 6 founder-ruled 2026-10-07. Items 7 and 8 Head of Interpretation's, open to the founder.*

**1. WHAT COUNTS AS RETURNING: THE BROAD READING.** Of the two readings of which of the dreamer's words for an image
count, defined on the counts page (interpretation/counts-2026-09-30.md, C92-I as corrected at C93-I), the founder
chooses the broad one. **Only the earlier night must hold the image unresolved** — Head of Interpretation's reading of
the founder's choice, since requiring both nights leaves the series question all but silent. It is watched in Cohort
0 for ordinary words firing as returns. Recurrence & the Series' definition is brought to this in its next revision;
the Requirements List carries it meanwhile.

**2. DISTRESS FIRINGS ARE KEPT ONLY UNTIL THE REVIEW OF THE COHORT IN WHICH THEY OCCURRED.** The tester disclosure
states it, and promises nothing beyond it (C84-I item 5).

**3. TIBETAN DREAM YOGA IS SERVED IN THE PRIVATE COHORTS.** Tibetan teachers or institutions are asked before any public
use of the tradition or its label, as its own file requires.

**4. THE NEXT FOUNDATIONS BLOCK IS APPROVED IN PRINCIPLE:** the founder's north star, verbatim, and the word RECURRENCE
(C78-I). A Foundation & Charter session writes it; both founders sign the words before it appends.

**5. THE DREAMER-FACING WORDS ARE WRITTEN AFTER PRODUCT & DESIGN HAS THE SCREENS** they sit on, and before Cohort 0.
Every line by a person, in each language independently (the Shared Core).

**6. AFTER THE HANDOFF:** the Freudian chapter read whole (C84-I item 1), the Egyptian sources (C74-I item 1), and the
Daoism label.

**7. THE GITHUB SUPPORT REQUEST IS NOT PURSUED** (founder, 2026-10-06). The repository is private and only the founder
has access. **The consequence, stated:** until GitHub collects them, the old commits may remain reachable on GitHub by
their IDs, and the filed commit map (C117-I) lists every old ID. **So no one else is granted access to the repository
until an old ID from the map is shown not to resolve there**, or GitHub has purged the old objects. The check: the
first changed commit's old ID, opened on GitHub while signed in; a "not found" page means it is gone.

**8. A FILE C117-I NAMED BEFORE IT WAS FILED.** C117-I item 8 lists hr_rehearse_replace.py as filed with it; it was not
placed until this entry's commit (found by the History Rewrite on closing).

**9. THE LOOSE METHOD THREADS GO TO THE REQUIREMENTS LIST:** The Opening's record kind for a late telling (C90-I), and
Lens Practice's held questions in §9A (C84-I item 6).

**WHAT DEPENDED ON THIS.** Recurrence & the Series. The tester disclosure. The Foundation & Charter session. The
Requirements List. Every future grant of access to the repository.


---

## C119-I — rulings for the Requirements List; the Foundations signing sheet filed before signature

**Filed 2026-10-07, by this machine.** *Head of Interpretation's rulings on method, open to the founder. Item 3 is routed to
the founders, not ruled.*

**1. THE REQUIREMENTS LIST — EIGHT ANSWERS GIVEN 2026-10-07, ENTERED.**
- It is written now, with the threads still open carried as open slots. **C86-I meets C45-I's condition**: the ending
  was settled when The Close reached its Draft 4.
- Lens Practice §9A's three held questions are each labelled with their owner: the first Interpretation's, the second
  Product & Design's, the third a founder copy slot. Product designs the slot with its function unsettled; **the
  precedent is C54-I**, not C47-I as first relayed (found by the Requirements List).
- Each behaviour is stated once, in one plain line, pointing at its source. **Where the list and a source differ, the
  source governs, or a later entry.** The list is one document, written in one chat.
- Lens Practice §14's heading routes behaviour to Technology; the list routes it to Product & Design, and the heading
  is flagged for Lens Practice's next draft.
- It names every place the practice needs words and what each must do; the screens decide how many lines.
- Core Commitments' measures are carried by pointer; The Foundations §8 governs where the two differ.
- C118-I item 1's two halves are shown with their authorship, and the Cohort 0 watch is attached to the requirement.
- It files at interpretation/requirements-list.md.

**2. NO PER-NIGHT RECORD FOR THE STANCE OR THE ASKING.** The bridge has a record of whether a tradition read because of
it because it is provisional and watched (C80-I). Nothing is watched on the stance or the asking, so nothing is
recorded; if a watch is ever set on either, its record comes with it.

**3. ROUTED TO THE FOUNDERS: A MEASURE IN CORE COMMITMENTS' UNSIGNED BLOCK OF 2026-09-28** would count the share of
sessions in which a dreamer writes in the close's space. The Close forbids that figure, and the Shared Core forbids
optimising the dreamer's own space as engagement. Head of Interpretation's view: struck before either founder signs
that block. Found by the Requirements List.

**4. THE FOUNDATIONS SIGNING SHEET OF 2026-10-07 IS FILED BEFORE SIGNATURE** (fa25944d), as the sheet C77-I cites was,
so the founders sign a file whose hash is on record. It carries the block C118-I item 4 approved in principle.

**WHAT DEPENDED ON THIS.** The Requirements List. The Foundations block. Core Commitments' unsigned block.


---

## C120-I — The Foundations changes: a dated block of two items, the north star and RECURRENCE, signed by both founders

**Filed 2026-10-07, by this machine. Signed by Ludvig and Eva, 2026-10-07.** *Written after the append was verified in
the file (C39-I). The rulings on form, place and §4.4 are Head of Interpretation's, given 2026-10-07.*

**THE SECOND DATED BLOCK.** A dated block, 2026-10-07, is appended to
interpretation/the-foundations-draft-2.md, which now hashes to cc32ecb4 (36,658 bytes). Everything
above it is unchanged to the byte: its first 34,054 bytes still hash to 59a62f57, the file as C78-I
left it, and its first 21,323 bytes still hash to bbac3a78. Thirty-six lines added, none removed (git
diff --numstat). The append took the block from the signing sheet filed at C119-I item 4 (fa25944d),
whose block region hashes to 0af295f6, and the verification compared the appended text with it byte
for byte: eight checks, all passed, run once by the founder on 2026-10-07.

**The two items, in one line each.** (1) The founder's north star is carried verbatim, directly
beneath the title. (2) §5's third line separates the series from recurrence: the series is the scale
at which recurrence is read, and recurrence is what returns across nights in the dreamer's own words.
Every word Item 7 of the 2026-09-30 block signed stands. The Foundations now uses the word
recurrence; before this block it never did.

**HEAD OF INTERPRETATION'S RULINGS, 2026-10-07, which the block names as recorded here.**
- Form: capitalised and italic, as Core Commitments carries it.
- Place: directly beneath the bold line under the title, the line Item 2 of the 2026-09-30 block
  calls the subtitle, where no later block moves it.
- §4.4 is left alone on purpose: "the series" there reads as the scale.
- The Reason states that neither item corrects the practice and that both bring the governing
  document to the Shared Core, with that block's Item 6 as precedent.

**C12-I'S DEFINITION OF RECURRENCE IS READ AT C77-I AND AT §5 AS AMENDED.** C12-I's table defines
recurrence as the engine that tracks motifs, figures and feeling-tone. Evolving figures and
feeling-tone were refused at C55-I, C56-I and C77-I, and C55-I left recurrence no object. C12-I's
rename stands. What counts as returning is not The Foundations' to define: it stays with Recurrence
& the Series, whose definition is brought to C118-I item 1 in its next revision.

**PAID.** The item C78-I owed to the next Foundations block. C118-I item 4.

**WHAT DEPENDED ON THIS.** Every document that cites The Foundations by hash, now cc32ecb4 where it
was 59a62f57. Recurrence & the Series, whose next revision points at §5 as amended. C12-I, read as
above. The project mirror of The Foundations, stale until refreshed. The Foundation & Charter
session, which closes when this entry and its commit are filed.

Also citing the old hash or the old wording, outside archive/, at filing: foundations-signing-sheet-2026-10-07.md 

---

## C121-I — the Requirements List filed

**Filed 2026-10-07, by this machine.** *Under C45-I, C86-I, C118-I and C119-I.*

**FILED.** interpretation/requirements-list.md (22f742c7) and the check script beside it, interpretation/rl_negcheck.py
(c43b83fa). Seventy-two requirements; thirty places the practice needs words, and two deliberate prohibitions; twelve
open slots, one since closed (C119-I item 2); an index of what a night keeps and what may be counted only across all
dreamers; what Product & Design must bring back to Interpretation; and eight findings for owners. **Where the list and
a source differ, the source governs, or a later entry** (C119-I item 1).

**CHECKED, BEFORE FILING.** Against the frozen journal: no shared six-word sequence and no journal-only word
(rl_negcheck.py). **Against every restricted file, the seventeen transcripts included:** the History Rewrite's
check-text, run by the founder at this filing — clean by strings and runs. **This replaces the transcripts check the
list's §12 names**, which could not run: counts_negcheck.py reads a path that existed only in the counts chat's own
working environment, so the counts page's own check cannot be reproduced from the repository. That is recorded for
its owner, as C103-I recorded the widened search. The §12 line is superseded by this entry, not edited.

**SUPPLIED.** The founder was told of the ordinary-words finding under C118-I item 1 before this filing. This
supplies the list's S1 mark, which stays as it was placed.

**OPEN, WITH THE FOUNDERS.** The measure in Core Commitments' unsigned block of 2026-09-28 (C119-I item 3).

**THE HANDOVER.** The list goes to Product & Design from this commit.

**WHAT DEPENDED ON THIS.** Product & Design, which designs from the list. The founders, who write the thirty places
once the screens exist (C118-I item 5). Lens Practice's next draft. The tester disclosure specification. The law
document's next pass. Core Commitments' unsigned block. The Opening's next revision. Recurrence & the Series' next
revision.

---

## C122-I — answers to Product & Design's first questions

**Filed 2026-10-07, by this machine.** *Head of Interpretation's rulings, open to the founder, on Product & Design's first
message (its items 1 to 10). Items 11 to 13 are routed to the founders, not ruled.*

**NOTED, FOUNDER-RULED IN PRODUCT.** The old build's design moves to archive/ in Product's first filing; the entries
that cite it are untouched and resolve through its archive note. No export and no sharing; nights live in the app on
one device only. Adults only, with no sign-up and no account. Research is the founder's own design research, plus three
people outside the beta clicking through a prototype that holds only invented dreams.

**1. THE AGE.** The app asks it once, before anything is recorded, for the gate only. **Only the gate's result is kept —
eighteen or over — never the age itself, and it never reaches any reading, lens or question.** A stored fact about the
dreamer is memory of the dreamer, refused whether or not anything acts on it (The Foundations §4.4; C56-I).

**2. "ON ANOTHER DEVICE" (the Requirements List, L8) IS A DESCRIPTION, NOT A RULE.** The rule beneath it: a kept night's
order never changes when it is viewed again, in any language. With no account and one device, the other-device case
does not arise. Deleting the journal, or removing the app, removes every night (X11 read so).

**3. A DREAM TOLD LATE** (C90-I; the list's O17 and Q4) takes its place after the dreams already mirrored, numbered in
the order told. It never reorders what was mirrored and receives no second mirror. Its provenance is recorded as late;
whether and how that shows is Product's to design. The readings may read it as the dreamer's own material; no later
night reads it for recurrence.

**4. A NIGHT IS READ ONCE, IN ONE LANGUAGE, AND KEPT IN IT.** Changing the app's language changes its fixed words only,
never a kept night. No reading is generated twice or translated (the Shared Core).

**5. READING LATER.** A night captured and not yet read may be read later, at the dreamer's choice; a night that is only
captured stays a whole use. The capture layer — the telling and the mirror's corrections — is made at capture; the
opening's remaining questions, the readings and the close happen when the dreamer chooses to be read. **For the series,
"an earlier night" means a night with an earlier date, not one read earlier.** A reading that fails is never shown in
part: one plain sentence, and the night stays as captured, to be read again.

**6. THE FOUR VOICES** — the dreamer, the app, the app through a named tradition, a quoted source — must each be
recognisable. The practice already draws five lines Product's treatment must keep: the app never writes in the
dreamer's person (C42-I); the dreamer's waking words are marked as waking in the look back; the reading-time mark sits
on claims and never on questions (Lens Practice); a tradition always speaks under its own label and never as the app;
and **no voice or tradition is styled as more important than another** — order carries no claim and the app never
explains it (The Foundations §3), so size, emphasis or placement may not rank the readings.

**7. THE DISCERNMENT PASS'S VISIBILITY** (Lens Practice §9A, its second question, Product's). Early answer: if its press
appears as text it is the app speaking, so it takes the app's own voice treatment and is never disguised as a
tradition's passage. It need not be labelled as a press; its audit stays in the record. Ruled when How the AI Appears
returns.

**8. RESOLUTION.** No resolution control exists in the design and none returns. The practice's own documents set no
dreamer-set resolution status, and no night state a dreamer can read (the list's C9).

**9. THE LABEL SET** stays open (the list's Q5, Q6); Product designs the lens labels to fit any set in both languages.

**10. THE REVISIONS INTERPRETATION OWES** run in parallel with Product. Item 3 above answers the one Product asked to land
before the flows are drawn.

**ROUTED TO THE FOUNDERS, NOT RULED.**
**11. EXPORT AND THE LAW.** Data-protection law may give a dreamer a right to receive their own data in a portable form.
Whether it applies to an anonymous, single-device app is for counsel, before Cohort 1. Head of Interpretation's view:
design with no export meanwhile.
**12. WHAT LEAVES THE DEVICE.** Several of the practice's records are counted only across all dreamers (C62-I; C63-I;
C80-I; C83-I item 4; C85-I). On an anonymous, device-only app those totals must still leave the device, without
any night's content and without identifying anyone, and the tester disclosure must say so. Head of Interpretation's
view: yes, totals only, stated plainly.
**13. TWO LINES WITH NO SOURCE IN THE DESIGN.** The Foundations §4.5's "tracked as an outcome" for non-resolution, and Core
Commitments §3.1's resolution rate. A resolution rate is kin to the share of readings that land, which the Shared Core
refuses. Head of Interpretation's view: retire both — The Foundations' line in its next signed block, Core Commitments'
row with the measure routed at C119-I item 3.

**WHAT DEPENDED ON THIS.** Product & Design's experience map, flows and How the AI Appears. The Opening's next revision
(item 3). The tester disclosure specification (item 12). The next Foundations block and Core Commitments' unsigned block
(item 13). Counsel (item 11).


---

## C123-I — what leaves the device; the install ID; age as an anonymous band; no export for now; three lines retired

**Filed 2026-10-07, by this machine. Founder-ruled 2026-10-07.** *Answers C122-I items 11 to 13.*

**1. NO EXPORT, FOR NOW.** Product & Design designs with none; it can be added later. Whether the law gives a dreamer a
right to receive their own data stays a question for counsel before Cohort 1 (C122-I item 11).

**2. WHAT LEAVES THE DEVICE: TOTALS ONLY.** Every record the practice counts only across all dreamers is collected
(C62-I; C63-I; C80-I; C83-I item 4; C85-I) and leaves the device as totals — never a night's content, never anything
that identifies a dreamer. The tester disclosure says so plainly.

**3. THE INSTALL ID.** Each install carries an ID string for the app's own working. **It is never attached to any
night's data that leaves the device, and no total carries it.** An optional account, created from within the app,
comes in Cohort 3; Cohorts 1 and 2 prove the app itself. What an account may store is ruled before Cohort 3, against
The Foundations §4.4.

**4. AGE, AS AN ANONYMOUS BAND.** The app asks the age once, before anything is recorded; on the device only the gate's
result is kept, eighteen or over (C122-I item 1). **For demographics, the age is sent once as a band, as an anonymous
count — never stored with the ID, never linked to any night, never reaching any reading, lens or question.** Bands,
not the exact age, because an exact age beside an ID in a small cohort comes close to identifying a person.
**The founder's reason:** insight into who the app serves. **Why this form:** a stored age, or any per-dreamer record
on a server, is memory of the dreamer whether or not anything acts on it — the pillar of The Foundations §4.4 and
C56-I. An unlinked count is not a record about anyone, so the pillar holds and the insight is kept.

**5. THREE LINES RETIRED.** The Foundations §4.5's "tracked as an outcome" for non-resolution, in its next signed block.
Core Commitments §3.1's resolution rate, and the measure in its unsigned block of 2026-09-28 counting the share of
sessions in which a dreamer writes in the close's space (C119-I item 3): both struck, by Core Commitments' own method.
A resolution rate is kin to the share of readings that land, which the Shared Core refuses; the close's space is the
dreamer's, never an engagement figure.

**WHAT DEPENDED ON THIS.** Product & Design's flows for the age gate and what the dreamer is told about data. Technology,
which sends the totals and keeps the ID apart from them. The tester disclosure specification. The next Foundations
block. Core Commitments. Cohort 3.


---

## C124-I — capture is capture only; the mirror is the first step of being read; Products**C122-I ITEM 5 TURNED A KIND INTO A TIME, AND IS CORRECTED.** Its sentence "the capture layer — the telling and the
mirror's corrections — is made at capture" reads: **the capture layer is a kind of material — the dreamer's telling and
their corrections at the mirror — whenever the mirror happens.** Everywhere else the term has named a kind, never a time
(C67-I item 4; C90-I item 2).

**THE ORDER.**
- **Capture is capture only.** It asks nothing and adds nothing; recording and closing the app is a whole use
  (the Requirements List, O1 and O2).
- **The mirror is the first step of being read**, whenever the dreamer chooses to be read; choosing to be read at once
  brings the mirror at once. The account stays the dreamer's to edit until the session opens (The Foundations §3).
- **Corrections at the mirror remain capture layer**, whenever they are made. A night never read has the telling alone
  as its capture layer.
- C122-I item 5's other rulings stand: reading later at the dreamer's choice; for the series, an earlier night means an
  earlier date; a failed reading is never shown in part.

**THE COST, AND ITS GUARD.** Corrections made hours after capture may carry waking material into what recurrence reads.
The risk is bounded: recurrence reads only the dreamer's own words for unresolved images and the feelings they named in
the dream. **The guard is the mirror's place, not a clock:** it asks only for what the mirror got wrong about the dream,
never for more, and waking material never enters the account (C72-I item 10). When the founders write that place's
line, that is the one thing it must do.

**THE FOUNDER'S REASON.** A dreamer who wakes in the night wants to record and go back to sleep, not to meet the mirror.

**ALSO ANSWERED HERE — PRODUCT & DESIGN'S MESSAGE 3.**
- **The rulings C122-I notes as founder-ruled in Product were agreed by both founders**, adults-only included (the
  Requirements List, Q11). Product records them at its own C2-P.
- **The Places Register** is the name of Product's kit item 5 (founder-ruled). The Requirements List §7 and the tester
  disclosure specification §4 call it the "Copy Register"; both are brought to the new name at their next pass.
- **The app is never described as anonymous.** C122-I items 11 and 12 used the word loosely. An install ID exists
  (C123-I item 3) and the Requirements List's X2 forbids the disclosure claiming anonymity. The honest description is: no
  sign-up, no account, nothing identifying leaves the device. C123-I item 4's "anonymous count" describes a count, not
  the app, and stands.
- **The law document's pointer to the old build's design for "the read-only night"** (its Tier 1 paragraph) is
  narration of the old build, not a rule (the list's F7). The read-only night is a consequence of distress detection,
  and those consequences are deferred (The Foundations §6, as amended); Product designs nothing for it now. The pointer
  goes to the old design's archive note at the law document's next pass.
- Product's project mirror of this record is named interpretation-change-record.md; the repository path is unchanged.

**WHAT DEPENDED ON THIS.** Product & Design's capture and mirror flows. The Opening's next revision. The place for the
mirror's invitation in the Places Register. The Requirements List and the tester disclosure specification, at their next
pass. The law document's next pass.


---

## C125-I — C124-I's heading restored; its last bullet overtaken; the mirror's place

**Filed 2026-10-07, by this machine.** *Head of Interpretation; item 3 open to the founder. Found by Product & Design, its
message 4.*

**1. C124-I'S HEADING AND FILED LINE WERE MANGLED WHEN IT WAS FILED.** An unescaped apostrophe broke the quoting in the
filing script, so the heading runs into the body and the filed line was lost. Head of Interpretation's error. C124-I's
body stands as filed. Its heading and filed line read, as written:

    ## C124-I — capture is capture only; the mirror is the first step of being read; Product's message 3
    Filed 2026-10-07, by this machine. Founder-ruled 2026-10-07. Corrects C122-I item 5, and answers Product &
    Design's message 3. Brought under the Requirements List §9 item 5, before any flow was drawn.

The commit date governs where any heading disagrees (C57-I). **From this entry, every filing script checks, before it
commits, that the new heading stands alone on its line and that the next line is its filed line.** The ordinal check
proves only that numbers are in order; it could not see this.

**2. C124-I'S LAST BULLET IS OVERTAKEN** by the founder's ruling of the same day: Interpretation's record appears in
Product & Design's project as change-record.md, uploaded as it is, and Product's own record files in the repository as
product/product-change-record.md.

**3. THE MIRROR'S PLACE IS A NEW PLACE, THE THIRTY-FIRST,** on every night that is mirrored. Its one job is C124-I's:
ask only what the mirror got wrong about the dream, never for more. The Requirements List's W6, the record line on
nights with several dreams, is unchanged. Product carries the new place in its Places Register until the list's §7
gains it at its next pass.

**WHAT DEPENDED ON THIS.** C124-I, read as above. The Places Register. The Requirements List's next pass. Every filing
script from here.


---

## C126-I — what leaves the device, said truly; crash reports; no notifications; the feedback surface; offline voice

**Filed 2026-10-08, by this machine.** *Items 2, 3 and 4 founder-ruled 2026-10-08; the rules in item 4 and items 1, 5 and 6 are
Head of Interpretation's, open to the founder. Product & Design, its message 5.*

**1. "NOTHING IDENTIFYING LEAVES THE DEVICE" IS NOT TRUE, AND C124-I'S ADOPTION OF IT IS CORRECTED.** A night's words
leave the device to be read (the Requirements List, X10), and a dream can name real people. Found by Product & Design,
correcting its own wording. **The honest description, used everywhere:** no sign-up, no account; a night's words leave
the device only to be read; the totals that leave carry nothing that identifies anyone (C123-I item 2). Where a night is
read, and what is kept there, is for the tester disclosure to state, from Technology's and counsel's answers.

**2. CRASH AND ERROR REPORTS MAY LEAVE THE DEVICE** (founder-ruled), with no night content and no install ID, and the
tester disclosure says so. This adds to C123-I item 2. **The guard:** reporting is configured so that it cannot carry
the dreamer's words — no logs holding text, no screenshots — and Technology shows this before Cohort 1.

**3. NO NOTIFICATIONS** (founder-ruled). The app never notifies and never asks for notification permission; the
allowance in the Requirements List's X7 and Core Commitments §4.1 stands unused. The microphone permission is asked
when voice is first used.

**4. THE FEEDBACK SURFACE FOR COHORT 1** (founder-ruled: giving feedback is very easy during the beta). **Its rules:**
- It asks about the app, and never invites a dream. Words a tester chooses to write about a dream are theirs and are
  respected; the surface never asks for them.
- What a tester writes goes to the founders only. It is never attached to the install ID or to any night, never given
  to a model, and never used to shape a reading.
- It is kept until the review of that cohort, then deleted, as distress firings are (C118-I item 2).
- It is not a session turn, so distress detection does not run on it; the crisis page is reachable from it, as from
  every screen.
- The tester disclosure says plainly that feedback is read by a person, who reads it, and how long it is kept.
- Dream material that arrives in feedback never enters any shared document (the Shared Core).

**5. OFFLINE VOICE.** Capture works with no connection, so a voice recording waits on the device until it can be
transcribed. It waits there only until transcription, and is then deleted (the Requirements List, X9). The law
document's next pass, and the place W29, cover the wait. Found by Product & Design's Principles worker; for Technology.

**6. THE SURFACES NO REQUIREMENT COVERS** — the age question, the disclosure's screen, how-to-use, settings and
language, deletion with one confirmation (founder-ruled), empty states, failure states, the feedback surface, and the
screen showing what is kept and what leaves — come to Interpretation with their designs in the Experience Map before
anything is built (the list's §9). **The crisis page stays as filed for Cohort 1**: one static page, reachable from
every screen, never offered (the list's X1; Core Commitments §6.3).

**WHAT DEPENDED ON THIS.** The tester disclosure specification. The law document's next pass. Product & Design's
Experience Map and Places Register. Technology, which configures crash reporting and the offline wait.


---

## C127-I — answers to the twelve questions the Experience Map raised

**Filed 2026-10-10, by this machine.** *Head of Interpretation's rulings, open to the founder. Product & Design, its message 6,
under the Requirements List §9. The moments named are the Experience Map's.*

**I1. A DETECTED SPLIT IS KEPT SILENTLY AT RECORDING.** Confirming or undoing it moves to the mirror, where merging and
splitting are already corrections (the list's O5) and the night is shown numbered (W6). Recording asks nothing (C124-I).

**I2. AN EDIT BEFORE BEING READ IS THE TELLING ITSELF**, changed by its author (The Foundations §3). Nothing records the
edit; recurrence reads the telling as it stands when the session opens, or as it stands on a night never read.

**I3. A CAPTURE-ONLY NIGHT WRITTEN IN, THEN READ LATER.** Writing in the space never closes the choice to be read (O2).
Earlier writes and reflections stay in time order, and once read the look back holds them with the rest of the night;
at most three reflections in all (C6). **The rule this adds: what the dreamer wrote in the space before being read is
never read by the readings, by the opening's questions, or by the series question.** It is waking material, and waking
material never enters the account (C72-I item 10). It stays the dreamer's.

**I4. A FAILED READING.** What stays is the capture layer — the telling and any mirror corrections (C124-I). Nothing else
from the failed session is kept with the night or counted, except distress firings, kept as the list's X4 says. Reading
again starts at the mirror. A night never has two sittings.

**I5. NO CONNECTION WHEN CHOOSING TO BE READ.** One plain sentence that the night cannot be read now; it stays as
captured. Nothing is queued, and the app never starts a reading by itself when the connection returns. It is its own
place, not the failure sentence, because no reading began.

**I6. A PERSON UNDER EIGHTEEN.** One plain sentence that the app is for adults. Nothing recorded, nothing kept, no age
band sent; the question is asked again the next time the app opens. The crisis page stays within reach.

**I7. DECLINING THE DISCLOSURE.** Nothing recorded, nothing kept. The person may read it again or close the app; nothing
asks them to reconsider. The crisis page stays within reach.

**I8. HOW TO USE THE APP TEACHES THE CONTROLS ONLY** — recording, choosing to be read, interpret now, the space and
entering a night, search, deletion, and the way to the crisis page. It says nothing about what any step of the practice
is for, and promises nothing about meaning. How the practice is described is The Foundations' to govern.

**I9. THE CHOICE TO BE READ** is one place, met at the end of recording and on a captured night in the journal. It
offers and never nudges; doing nothing — closing the app — is the easiest path.

**I10. THE SEARCH FIELD** carries a plain label for what it does, never an example word; an example is a suggestion
(the list's S6).

**I11. THE WAY IN TO THE CRISIS PAGE** is its own place, apart from the page's content (W26): short, the same at every
moment, naming what it reaches, never inviting (X1). **It never changes with anything the dreamer has written**:
distress detection runs log-only (C51-I), so nothing may make the way in more prominent.

**I12. PRODUCT'S OWN PLACES.** The microphone's purpose text and the deletion controls do not touch the practice. **What
a screen reader is told does, wherever it concerns the night:** every announcement of a reading, the mirror, the band
or the series question says which of the four voices is speaking, as the screen shows it (C122-I item 6), and the
series question's silence is never announced. Announcements of everything else are Product's.

**FOUND, FOR THE REQUIREMENTS LIST'S NEXT PASS.** Its §0 points at §4 for the places; they are in §7. Its Q11 is
overtaken by C122-I item 1 and C123-I item 4. It read The Foundations at 59a62f57; since C120-I it is cc32ecb4, and
Product reads it there.

**WHAT DEPENDED ON THIS.** Product & Design's Experience Map and Places Register, and the drawing of a capture-only night,
a night read later and a failed reading. The Requirements List's next pass.


---

## C128-I — the opening: four framing lines composed each night, under rules; Interpret Now; pausing; filler sounds; what one night is

**Filed 2026-10-19, by this machine. Items 1, 3, 4 and 6 founder-ruled 2026-10-19.** *Items 2, 5 and 7 Head of Interpretation's,
open to the founder. Product & Design, its message 7.*

**1. THE FOUR FRAMING LINES — what stood out, the stance, the asking, the bridge — ARE COMPOSED BY THE APP EACH NIGHT,
never the same words twice.** The founder's reason: fixed lines turn the opening into a routine the dreamer can run
alone, and dull the curiosity the practice depends on. Their order stays as The Opening sets it; answers are recorded
verbatim as now. **By this they stop being founder copy and become practice turns**, as the clarifying questions and the
readings already are. **The rules each composed line is held to:**
- **It echoes no content of the dream.** What stood out, the stance and the asking never name, hint at or echo any
  image, moment, feeling or word of the dream. The bridge names the one concentrated image, in the dreamer's own word,
  and nothing else. The variation is in the wording, never in what the line points at: the dreamer brings what is
  relevant.
- It draws on nothing else: no earlier answer in the opening, nothing written in the space, no other night.
- Each keeps its job: whether anything stood out, taking none, one or many; what the dreamer made of it on waking,
  "nothing" being complete; what, if anything, they want from this one; what the one image touches in waking life.
- It never suggests an answer, an option, a feeling, a meaning or a tradition; never names a period of the dreamer's
  life (The Foundations §4.5); never flatters; never speaks in the dreamer's person (C42-I); makes no claim.
- **Before it is shown, each composed line passes a check written from these rules; when the check fails, a
  founder-written line stands in.** Each language is composed independently.
- Each composed line is kept verbatim with its answer in the night's record, so leading can be read for later.
The Opening's next draft carries this. Lens Practice's rules for questions reach these turns.
**The Shared Core's line that dreamer-facing words are written by a person:** the founder does not want to keep it.
The Shared Core changes only by both founders, in all four projects in one pass, recorded in each project's change
record; until that pass the line stands. Item 1 does not wait on it, because practice turns were never within it.

**2. SPOKEN "INTERPRET NOW"** starts the readings, as The Opening allows. For Technology: it is a command only when said
on its own, never inside a dream being told.

**3. INTERPRET NOW GOES STRAIGHT TO THE READINGS FROM ANY POINT IN THE OPENING** (founder-ruled). A dreamer who taps it
or says it at the stance or the asking means the readings, not the next question; the remaining invitations, questions
and the bridge are passed over, and the close follows the readings as always. No separate way of moving past one
invitation exists, and no words are owed for one. The Opening's "doing nothing proceeds and the dreamer is never held"
reads: at every invitation the dreamer answers, goes to the readings, or leaves; nothing holds them.

**4. LEAVING MID-OPENING PAUSES THE SESSION** (founder-ruled). It is not a failed reading. The session keeps its answers
exactly as the dreamer left it and opens exactly there when the dreamer returns: one session paused, not a second
sitting (C127-I I4 unchanged).

**5. FILLER SOUNDS.** Dropping filler sounds and plain stutters from the mirror's read-back is transcription, not
rewriting, and is allowed. Grammar, word order, odd phrasing, contradictions and gaps stay exactly as said. Any
repetition that could carry meaning stays; when unsure, it is kept.

**6. WHAT ONE NIGHT IS** (founder-ruled). A night is dated by the day of its first recording. Everything recorded before
the dreamer chooses to be read, and before 21:00, joins the same night; at 21:00 the recording screen starts fresh, and
anything saved and unread stays its own night, to be read later. Once a night is read, the next recording starts a new
night. To add to an older night the dreamer opens it and records more; the app never guesses. A dream added after the
mirror is a late telling (C122-I item 3). **No conflict with the practice. One refinement:** two nights may now share a
date, so for the series "an earlier night" means an earlier first recording — date and time (C122-I item 5 read so).

**7. THE NAMES.** Product's design calls the stretch "the opening" and the read-back "the mirror", as this department
does.

**WHAT DEPENDED ON THIS.** The Opening's next draft, which carries item 1's rules, item 3 and item 4. Recurrence & the
Series' next revision (item 6). Product & Design's opening flows and Places Register, from which four places leave.
Technology, which builds the composition, its check and the command. The Shared Core, by the founders' own pass.


---

## C129-I — the end of a session: the close invites a response; waking life after it; marks in the close; the close weaves by placement

**Filed 2026-10-19, by this machine. The purpose in item 2, the choice in item 4 and item 5 founder-ruled 2026-10-19.** *Items 1 and 3, the order in item 2 and the rules in item 4 are Head of Interpretation's, open to the founder. Product & Design, its message 8, under the Requirements List §9, before anything is drawn.*

**1. THE CLOSE INVITES THE DREAMER TO RESPOND, AND RESPONDING IS THE PATH THE DESIGN ENCOURAGES.** After the readings,
the arc and any series question, the dreamer is invited to say what stood out to them and what they make of the night;
it may read as a short sequence. Responding is the work (the Shared Core's one-line test). **The rules:**
- Moving on is one tap at every invitation and never reads as skipping, failing or lesser. The Close's design goal
  stands: saying nothing and saying something must both feel like a right move. Encouraged is not required (The
  Foundations §4.3).
- It is a space, never a form: nothing shows progress or how many invitations remain.
- No invitation names an image, a reading, a tradition, a time or a period of the dreamer's life, or suggests an answer,
  a feeling or a meaning.
- The encouragement is in the design, never in a consequence: nothing is rewarded, and nothing is withheld from a
  dreamer who moves on. Whether a dreamer responded is presence only, counted across all dreamers, reported and never
  optimised (C123-I item 5).
- What the dreamer writes is theirs, is never evidence (The Foundations, dated block 2026-09-30, Item 8), and is never
  read by a later night. The promise at the space stands.
- **The waking-life invitation is met on every night that is read**, whatever the dreamer taps before it: every
  session asks (The Foundations §4.6). Found here: if the one control for moving on were the entering control, a
  dreamer who used it at the first invitation would never meet it. No control passes over it; how is Product's.
Changes: the Requirements List C3 and the job of W19; The Close §1 ("without asking for it"), §3.3, and §10's line on
what the close asks.

**2. THE WAKING-LIFE INVITATION COMES AFTER THE DREAMER'S RESPONSE.** The order: the readings; the arc, where there is
one; the series question, on the nights it runs; the dreamer's response; the waking-life invitation; the reflections.
Every rule of The Foundations on order holds (§4.6 as amended; dated block 2026-09-30, Item 8). The Requirements List
B2's "the app's final word is never a question" is retired as written, because every invitation is now followed by the
dreamer's turn; "the dreamer's turn still comes last" stands.
**Its purpose, founder-ruled:** it stays the grounding check and the guard against inflation (§4.6), and it helps the
dreamer see where the dream's material comes from. It asks about waking life and names no time: never the day, never
yesterday, because a time sets a limit the dream does not have. It leaves both doors equally open, that the dream
connects to waking life and that it comes from it, and an answer that waking life accounts for all of it is as whole as
none of it. No Foundations change: §4.6 already says waking life.
**The cost, stated:** asked after the dreamer has said what the night means to them, the plain waking-life account may
be harder to give. It cannot be measured, because nothing is computed from the answer (The Close H13). It is accepted.
Changes: the Requirements List B1, B2 and the job of W17; The Close §3.1; Lens Practice §8 and §14 item 9.

**3. THE CLOSE MAY USE THE DREAMER'S MARKS, WITHIN THE NIGHT.** The Foundations §8 already allows it: a mark may be
questioned, never rewarded; the close may ask what in the dream makes a marked sentence true; it may not give more of
what landed. **The founder's limits:** this night only; never read by a later night; never counted per dreamer; the
readings never change because of a mark. **Three more:** a mark never leads the app to say more of its kind; the app
never treats a mark as agreement, because it does not know which chord was struck, comfortable or not; and whatever the
dreamer is told about marking says truly that the close may use marks tonight. Product & Design's concern, that a mark
the app reads becomes a signal of what landed, is answered by §8's line and watched under item 4.
Changes: the Requirements List L18 ("nothing changes because of a mark" reads: nothing about the readings changes
because of a mark); Lens Practice §9B and §14 item 16.

**4. THE CLOSE WEAVES THE NIGHT BY PLACEMENT** (founder-ruled: Product & Design's middle path; the founder's first
statement of the item withdrawn). A synthesis in the app's voice would make the app the interpreter, against the Shared
Core (the app holds the traditions up; the dreamer is the one who looks) and The Close §3.5. **What stands instead:**
starting from what the dreamer wrote, the app sets their words beside specific lines from the dream, the readings, the
arc and the series question, as many as the night supports, and says nothing about what any of them mean. **The rules:**
its own words say only where and when; every placed line keeps its own voice; nothing is summarised, condensed or
blended (the Requirements List C1); it never uses the stance, the bridge, the asking or the waking-life answer (C74-I
item 2, founder-ruled, unchanged); it may place marked sentences (item 3).
**The founder's purpose, recorded:** the close is the part of the session that helps the dreamer make sense of all the
material, by setting it where they can see it. It is not small, and it is not the interpreter. The sense made is the
dreamer's.
**On watch through Cohort 0 and Cohort 1:** whether the close carries too little to help, and whether placement starts
to read as the app interpreting, or as the app giving back what was marked. Read by the founder in Cohort 0 and from
what testers say in Cohort 1 (C126-I item 4). No figure of what landed is computed.
Changes: the Requirements List C5 (one pairing becomes as many placements as the night supports) and the shape of C6,
which Product & Design designs; the app's part still ends; The Close §3.5.

**5. THE CLOSE'S INVITATIONS ARE COMPOSED EACH NIGHT** (founder-ruled), as the opening's framing lines are: what stood
out, what the dreamer makes of the night, and the waking-life invitation. C128-I item 1's rules reach them, read for the
close: each keeps its job; names no image, reading, tradition or time; draws on no earlier answer and no other night;
suggests nothing; passes a check before it is shown, with a founder-written line standing in when the check fails; each
language composed independently; each kept verbatim with its answer. They are practice turns (C128-I item 1). They leave
the Places Register as written lines; their stand-in lines are founder copy.

**WHAT IN THE CLOSE AND LENS PRACTICE CHANGES.** The Close: §1, §3.1, §3.3, §3.5, §10 and §11. Lens Practice: §8, §9B
and §14 items 9 and 16. The Requirements List: B1, B2, C3, C5, C6, L18, W17 and W19. Each is brought to this entry at its
next draft; until then this entry governs.

**WHAT DEPENDED ON THIS.** Product & Design's design of the band and the close, and its Places Register. The Close's next
draft. Lens Practice's Draft 11. The Requirements List's Draft 2. Technology, which builds the composition and its check
for the close, and the placement.


---

## C130-I — the founder signs alone; C128-I's open items confirmed, and Interpret Now extended

**Filed 2026-10-19, by this machine. The founder's statements and rulings, 2026-10-19.** *The last sentence of item 2 is Head of Interpretation's, open to the founder.*

**1. THE FOUNDER SIGNS ALONE.** The founder states that Eva has signed her agreement that he signs alone, because she is
away and cannot be active in the project now, and that she will come in later. The signed agreement is not in the
repository. From this date, wherever the Shared Core, The Foundations or Core Commitments call for both founders, the
founder's signature alone suffices. **The documents' own words are not edited here.** The Shared Core still reads "both
founders" until it is changed in all four projects in one pass, recorded in each project's change record; that pass is
now the founder's alone, and until it is made this entry governs for this department. The Shared Core change owed at
C128-I item 1, on dreamer-facing words, can go in the same pass. Filing the signed agreement is Organisation's, since
Core Commitments governs the company. What changes when Eva returns is not ruled.

**2. C128-I ITEMS 2, 5 AND 7 CONFIRMED BY THE FOUNDER.** Filler sounds and plain stutters may be dropped from the
mirror's read-back, and nothing else (item 5). "The opening" and "the mirror" are how the company speaks (item 7).
**Item 2 is extended** (founder-ruled): spoken "interpret now" is a command when said on its own, and also when it is the
very last thing said in a response. Anywhere else inside a dream being told, it is never a command. The command's words
are not recorded as part of the answer they end.

**WHAT DEPENDED ON THIS.** The Shared Core's pass, now the founder's alone, with C128-I item 1's line. The next
Foundations block (C123-I item 5). Core Commitments' two struck measures (C123-I item 5). Organisation, which files the
signed agreement. Technology, which builds the spoken command. The Opening's next draft. Product & Design's opening.

---

## C131-I — the journal: the row's line, month dividers, search passages; the close's controls; the crisis way in

**Filed 2026-10-19, by this machine. Items 1 and 5 founder-ruled 2026-10-19.** *Items 2, 3 and 4, and the conditions under items 1 and 5, are Head of Interpretation's, open to the founder. Product & Design, its message 9.*

**1. THE ROW'S LINE IN THE JOURNAL LIST** (founder-ruled). Its only job is to remind the dreamer which dream it was.
**The night's main images are refused.** Choosing them by how much the dreamer spoke of each is the app deciding what
mattered; the images a dreamer dwells on are the ones that return, so they would surface row after row, and the list
would show recurrence drawn by the app (Recurrence & the Series §8.1; the Requirements List S5). **What stands:**
- **The dreamer may name a night, in their own words, at any time.** It is never asked for and never prompted, and
  capture stays capture only (C124-I). A name is never read by a reading or by a later night. It is the dreamer's
  writing, so search finds it.
- **When a night is unnamed, the row shows the first dream's opening as the dreamer told it, with only the framing left
  off**: verbatim, unbroken, in their order. What is left off holds nothing of the dream itself; when unsure, nothing is
  left off.
- A named row and an unnamed row look alike, and a night that was read looks like one that was not (S5).
**The line, for every later design of the list:** the app may show the dreamer's words in the dreamer's order; it never
chooses among them by importance.

**2. MONTH DIVIDERS ARE ALLOWED.** A divider orders by time and groups nothing in the nights; S5's "grouping" is
grouping by what the nights hold. No divider carries a count, and no divider stands over a month with no nights.

**3. A SEARCH RESULT MAY SHOW THE PASSAGE AROUND THE SEARCHED WORD, HIGHLIGHTED.** The dreamer searched and the app
selected nothing (Recurrence & the Series §8.2; S6). **The conditions:** the passage is only the dreamer's own words,
never a reading's or the app's; within a night it is the first place the word appears, never the best one, because best
is ranking; the search matches the word as typed and its plain forms, never a synonym or a related word, which would be
the app proposing a connection (S7); opening the night from a result highlights the word there, and the highlight is
gone when the dreamer leaves it. The night itself never changes (C8).

**4. THE CLOSE'S CONTROLS.** Product & Design's reading of C7 is right: "from the moment the readings end" reads "from
the waking-life invitation on". C7's purpose is that the dreamer is never held, and with "Next" one tap at every
invitation the entering control is never more than a few taps away, so the purpose holds beside C129-I item 1. "Next"
never reads as skipping, and nothing shows how many invitations remain (C129-I item 1). **The rule binds the app's
controls, not the dreamer:** a dreamer who leaves the app before the waking-life invitation has not met it, and leaving
is always allowed.

**5. THE WAY IN TO THE CRISIS PAGE IS THE ICON WITH THE WORD "HELP"** (founder-ruled), top right on every screen, the
same at every moment; a screen reader is told it reaches the crisis page. This meets C127-I I11, which stands in full:
it never changes with anything the dreamer has written. **The conditions:** nothing else in the app is called Help, and
"how to use the app" (C127-I I8) carries another name; the feedback surface (C126-I item 4) uses nothing that looks like
this icon, so no one in crisis sends their words to feedback by mistake; the word is founder-written in each language.
**A check before Cohort 1:** the three click-through testers are shown the way in, untold, and asked what it reaches. If
any takes it for the app's instructions, the word changes.

**WHAT DEPENDED ON THIS.** Product & Design's journal list, search, the close's controls and the crisis way in, and its
Places Register. Recurrence & the Series' Draft 4 (§8.1 and §8.2). The Close's next draft (§3.7). The Requirements List's
Draft 2 (S5, S6, C7, X1). The tester disclosure, which tells testers where Help is. Technology, which builds the framing
left off, the search's matching and the highlight.

---

## C132-I — the main path: the line before the readings; Interpret Now from the start; the heard mirror; two answers, two names; the choice to be read named; the note; the way to Help taught

**Filed 2026-10-20, by this machine. Items 5, 6 and 7 founder-ruled 2026-10-20.** *Items 1 to 4 are Head of Interpretation's, open to the founder; item 8 is a note, not a ruling. Product & Design, its message 10: the main path, filed at C6-P as product/main-path.md, sha256 e4fe1e7ca424edac0ff8c3834c326e8dd4a95e8ebef06724ad0fb0aadd6dc676, read whole.*

Everything else in the main path that touches the practice follows C128-I to C131-I as they read. What follows is only
what it changes or leaves open.

**1. THE LINE BEFORE THE READINGS.** The founder's draft names the traditions "the most relevant" and speaks of "today".
Both go. "Most relevant" says the app chose and ranked the readings, which they never read as (the Requirements List L1
and L7). "Today" names a time, and is wrong on a night read days after it was recorded. The rest of the line, "it's
what you make of it that matters" included, is the founder's.

**2. INTERPRET NOW FROM THE FIRST THING THE OPENING ASKS**, "what stood out" included, not "from the first question".
C128-I item 3 already rules it: from any point in the opening.

**3. THE MIRROR HEARD.** A voice can set a tone, and the mirror never names or adds one (O3). The voice reads exactly
the words on the screen, level, adding no feeling and no emphasis. Whether that voice is made on the phone or off it is
Technology's to say; if the words leave the phone for it, the disclosure says so.

**4. TWO ANSWERS, TWO NAMES.** The opening asks what stood out before the readings, and the readings stand in front of
that answer (C72-I item 1; L1). The close asks what stood out after them, and that answer is never evidence (The
Foundations, dated block 2026-09-30, Item 8) and never read by a later night. They carry different names in every
document and in the build, so nothing that reads the first ever reads the second. Recurrence & the Series §3.6 gains the
close's answers at its next draft.

**5. THE CHOICE TO BE READ IS NAMED FOR THE CHOICE** (founder-ruled). "Questions" named the next step; the button now
reads "Start Interpretation" [founder's draft copy]. It is the choice to be read (C124-I), the one that lets a night's
words leave the phone to be read (C126-I item 1). In the Places Register it is checked beside "Interpret Now" so the two
read as a pair: one begins, the other goes straight to the readings. The recording screen's top line, which speaks of
going on to questions, follows it.

**6. THE NOTE** (founder-ruled). It passes the Shared Core's never-a-verdict line and puts the authority with the
dreamer. "What our dreams truly mean" becomes, in the founder's words, what our dreams mean to us: a true meaning is a
claim, and the traditions that read a dream as memory doing its work dispute it. The app holds them with the same respect.

**7. THE WAY TO HELP IS TAUGHT IN THE NOT-THERAPY PARAGRAPH** (founder-ruled). The main path teaches each control the
first time it is met and has no section on how to use the app, so C127-I I8's teaching of the way to the crisis page
lands here. The paragraph says where it is: the Help button, top right, on every screen, one tap away. It replaces "a
few taps away", which was untrue.

**8. A NOTE FOR "HOW THE AI APPEARS", NOT A RULING** (C122-I item 7; the Principles §4a). Three things to carry into it.
The app's own lines appear word by word, as speech, while the readings arrive whole: the app becomes the most alive
voice on the screen, where the Shared Core makes it the one holding the traditions up. The mirror shows the dreamer's
own words in the app's look, so the dream reads as the app's version of it. The press's look (L17) is the one decision
there that Interpretation rules; the main path's "the app's look, if it shows" holds the place and decides nothing.

**WHAT DEPENDED ON THIS.** Product & Design's main path and its Places Register. How the AI Appears. The Opening's next
draft (items 2, 4 and 5). The Close's next draft (item 4). Recurrence & the Series' Draft 4 (item 4). The tester
disclosure (items 3, 5 and 7). Technology: the heard read-back's voice (item 3) and the two answers' names (item 4).

---

## C133-I — the close's fixed lines after C129-I: the permission retired; the promise kept; the waking-life heading retired

**Filed 2026-10-20, by this machine.** *Head of Interpretation's, open to the founder; item 3 departs from Product & Design's view. Product & Design, its message 11, from the Places Register.*

**1. W19, THE PERMISSION INSIDE THE SPACE, IS RETIRED**, as Product & Design proposes. Its job was to make writing
nothing the easiest thing to do (The Close §11 item 1), which C129-I item 1 reverses. What it protected is now carried
by the controls, not by a line: moving on is one tap at every invitation and never reads as skipping or lesser (C129-I
item 1; C131-I item 4). The space on an unread night (C10) has no invitation and needs no permission line: a space
that asks nothing is permission enough.

**2. W20, THE PROMISE, STAYS**: a fixed line, founder copy, met where the dreamer writes in the close; how often it is
shown is Product & Design's. Its job is unchanged and now matters more: it says that their words stay with this night
and that nothing in them shapes a later one, a statement about use, not retention (The Close §11 item 2). It never says
that nothing reads what they write: the close now sets their words beside the night (C129-I item 4) and may use their
marks (C129-I item 3), so that claim would be false.

**3. W17'S HEADING IS RETIRED**; only the waking-life invitation remains, composed (C129-I item 5). Product & Design
proposed keeping it. The heading's one job was to make the check visibly not a lens (Lens Practice §15 item 5; §14 item
9), when it sat directly beneath the readings. It now follows the dreamer's response, among the app's other
invitations, and the main path gives every invitation the app's own look, never a reading's (C132-I; product/main-path.md).
The look now does the heading's job. A fixed heading over this one invitation would single it out among the app's
invitations as a different kind of step, the test the founder asked it not to read as (C129-I item 2). **If How the AI
Appears ever gives the app's lines a look that could be taken for a reading's, this reopens.**

**WHAT DEPENDED ON THIS.** Product & Design's Places Register: two places leave (W19, and W17's heading), one stays
(W20). The Requirements List's Draft 2 (C3, W17, W19, W20). The Close's next draft (§3.3 and §11 items 1, 2 and 7).
Lens Practice's Draft 11 (§15 item 5; §14 item 9). How the AI Appears (item 3's condition).

---

## C134-I — the Places Register: composed image and series lines; no hypotheticals and no questions in the readings; the silences shown by design; This is mine now; night, not session; the Freudian lens retired

**Filed 2026-10-22, by this machine. Items 1, 2, 4, 5 and 9 founder-ruled 2026-10-22.** *Items 3 and 6, and the conditions and watch under items 1 and 2, are Head of Interpretation's, open to the founder; items 7 and 8 are Product & Design's notice. Product & Design, its message 12, from the Places Register filed at C8-P.*

**1. W8, W9 AND W18 ARE COMPOSED EACH NIGHT** (founder-ruled), under C128-I item 1's rules, each with a founder-written
stand-in. The concentration line and its second form name the image in the dreamer's own word and nothing else from the
night. **The series question's frame is the one exception to "draws on no other night"**, because it exists only when a
word has returned: it carries the dreamer's word, spelled as they spelled it, and its tradition, and nothing else. Never
which night, how many, when, a comparison, or what the return means (the Requirements List S2). The word is still chosen
as Recurrence & the Series rules it; composing the line changes nothing about the choice.

**2. THE READINGS NEVER ASK AND NEVER SPEAK IN HYPOTHETICALS** (founder-ruled). A reading reads the dream fully from what
the dreamer told. **W15, the named missing premise, is retired**: no reading says what an image would signify for a
position it has not been told. This reverses the founder's ruling of 2026-09-10 (Lens Practice D18). **A tradition whose
reading would need what the dreamer did not tell is not chosen that night**, and another takes its place; no reading
ever rests on a quiet assumption, which would be invention. **W14, the decline in a tradition's own voice, stays**
(founder-ruled), with Lens Practice's rules for it (D19). **The opening is not widened to gather more:** its questions
gather the dream and what the dreamer offers, never questions about the dreamer's life put in to serve a tradition
(C128-I item 1; The Foundations §4.5).
**The cost, and a watch:** traditions that need a dreamer's situation will be chosen less often. How often each
tradition is chosen is on watch through Cohort 0 and Cohort 1, counted across all dreamers, never per dreamer. It is
reported, never optimised.

**3. W21 AND W22 MAY BE SAID BY DESIGN, WITHOUT SENTENCES.** A visual state can meet the Requirements List C4 (three
silences told apart: composing, nothing connected, nothing saved) and C12 (the dreamer knows before writing whether the
app will respond), on two conditions. **No state ever looks like disapproval**: nothing dims, greys, strikes or marks
the dreamer's words. **A check before Cohort 1:** the three click-through testers are shown each state untold and asked
what it means. If they cannot tell them apart, or any state reads as a judgement on what was written, the sentence
returns.

**4. W24 STAYS "THIS IS MINE NOW"** (founder-ruled; the founder's "Thank you" withdrawn). The control is the dreamer
taking the night as theirs.

**5. THE DREAMER READS "NIGHT", NEVER "SESSION"** (founder-ruled), everywhere: "Name this night", "Add a dream to this
night". "Session" names a sitting with someone, which the app says plainly it is not, and on a night never read it
implies something happened that did not. Inside the company's documents "session" keeps its meaning, a night being read
(C127-I I4).

**6. A WORD ON ONE NIGHT ONLY**: a result list holding one night says so by itself, and needs no line (S6). **W25 is the
search's empty result**, which this does not reach: no night at all must still be told apart from searching and from
failing, and must not imply they searched wrongly or suggest another word. A line or a design state may do it.

**7. THE DISCLOSURE IS ONE PLACE**, readable again beside the settings (Product & Design's notice). What it must contain
is still the tester disclosure specification's.

**8. THE JOURNAL SHOWS DATES, NEVER TIMES** (Product & Design's notice). Two nights may share a date (C128-I item 6), so
two rows may show the same date; their lines tell them apart, and the time of first recording is still kept.

**9. THE FREUDIAN LENS IS RETIRED** (founder-ruled; the founder's decision, no reason recorded). Its lens file moves to
the archive unchanged, by this entry's commit. It is never selected and never asks the series question. The work owed
under C84-I item 1, Freud's chapter read whole, is no longer owed. The Foundations' mentions of Freudian readings record
the old journal's history and stand as they are.

**WHAT DEPENDED ON THIS.** Product & Design's Places Register: W15 leaves; W8, W9 and W18 become composed with stand-ins;
W21 and W22 may leave as sentences; W24 stays. Lens Practice's Draft 11 (D18 reversed; selection excludes a tradition
whose reading needs the untold; the Freudian lens). Recurrence & the Series' Draft 4 (the Freudian row; its owed source
work). The Requirements List's Draft 2 (L11, S2, S6, C4, C12, W8, W9, W14, W15, W18, W21, W22, W24, W25, Q5). The Close's
next draft (§11 items 3, 4 and 6). The Opening's next draft (item 2). The lens register's findings and handovers, which
name the Freudian lens as history. Technology: the lens set, the composition of three more lines, the selection rule.

*The Freudian lens file, moved by this commit: archive/lens-freudian-retired-2026-10-22.md, sha256 3d7da244cd2200e40a992063de23c30a96a16e38b90b2cf9ad4fb2c61c4bd71f, unchanged.*

---

## C135-I — How the AI Appears: the quoted source; the press's look; the traditions' tones; the app's voice and honesty; the AI sentence; the composing labels; the mirror; the series question; the cap note

**Filed 2026-10-22, by this machine.** *Head of Interpretation's, open to the founder; it rules the practice under the founder's positions of 2026-10-22 and changes none of them. Product & Design, its message 13, on product/how-the-ai-appears.md, drafted and not filed. Under the Requirements List §9; the press's look under C122-I item 7.*

**A. THE QUOTED SOURCE FOLDS INTO THE TRADITION'S VOICE, AND STAYS RECOGNISABLE AS A QUOTATION.** The founder's model
stands: a tradition reads a source in its own way of speaking, inside its own reading, with no look of its own. **Found
here: the practice had no rule for how a reading quotes a text,** so a reading could put invented words in the mouth of
scripture or a classic, which is false and a disrespect to the traditions the practice holds. **The rule:** a reading
quotes a source only word for word, only from a passage its lens file holds with its provenance, and always names the
source. Anything else is the tradition's own words and is never presented as the source's. The quotation is set apart
inside the reading, so the dreamer can always tell the source's words from the tradition's. Product & Design's
Principles §4a and the Places Register's EM·10 change with this; that is Product & Design's.

**B. THE PRESS IS B1:** the app's own look, plain, at its place after the arc (Lens Practice §9A), never set beneath a
reading and never in a tradition's look. B2 would show the app correcting one tradition, against equal weight (C122-I
item 6). B3, a press that never shows, is not possible: §9A's calibration clause requires the pass to be able to state
that the comfortable reading is the true one, and a press that never shows either does nothing or changes a reading
unseen, which the app never does to a tradition's words. It may speak of what a reading said; it never says which
tradition was right, never ranks one reading above another, and never presses on the dreamer's stance answer by itself
(§9A, its first question, the belief stated there). It need not be labelled as a press; its audit stays in the record.
This answers §9A's second question. W16 is the press's words.

**C. THE TRADITIONS' TONES.** What Lens Practice sets for each tradition: its account of what a dream is, in its own
voice; its vocabulary, with distinctive terms; its characteristic question; and that no reading uses another admitted
lens's distinctive vocabulary (the lens file fields 3 to 5; §5.2). A tradition is recognised first by these, which are
substance. **Idiom is allowed where it comes from the tradition's own vocabulary and sources, and never as a costume**:
no archaic, exotic or mock-sacred diction performed to sound like a tradition, which Lens Practice already names as the
risk of a costume without vocabulary. This weighs most for living traditions (C118-I item 3). **Equal weight reaches
tone**, as Product & Design believes: no tradition more vivid, more certain or more intimate with the dreamer than
another. Length is already set by the budget (Lens Practice §3.2): one paragraph each, and the one cell that may have a
second is chosen by the image, never by the tradition.

**D1. THE APP'S VOICE AND HONESTY,** under the founder's positions of 2026-10-22.
- **(a) holds.** The app is a facilitator: no judgement, no flattery, no topic of its own, never interpreting, never
  continuing a thread on its own. The press is the one place it pushes, and it pushes on the readings, never on the
  dreamer (B).
- **(b) is worded:** the app brings no topic of its own. Its clarifying questions start from what the dreamer offered;
  its framing lines and invitations point at nothing in particular, so the dreamer brings what matters (C128-I item 1;
  C129-I item 5).
- **(c) arises in two places,** and both say plainly where things come from: every reading shows which of the dreamer's
  words it stands on, and a quotation names its source (A). No new place is needed.
- **(d):** asked what it is, the app says plainly that it is an AI, in a fixed line the founder writes in each language:
  a new place. Spoken to as a person, thanked or praised, it never takes the credit and never praises back; at most once
  a night it may say the sense is the dreamer's own, composed under C128-I item 1's rules with a founder-written
  stand-in: a second new place. Otherwise it simply goes on with its job. No voice ever implies a person behind it, and
  nothing in the look suggests one typing.

**D2. THE TESTER DISCLOSURE SAYS ONCE, PLAINLY, THAT AN AI COMPOSES WHAT THE APP SAYS** each night: its questions, the
readings and the reflections. The tester disclosure specification is this department's; this entry adds the sentence to
its list, and its next draft carries it. Product & Design carries it to the Requirements List. Whether the law requires
more is counsel's.

**D3. THE COMPOSING LABELS (AI·5, AI·8) MEET C4.** A few words naming the app's work are neither a sentence of the kind
C4 reserves for "nothing connected" nor an acknowledgement of the dreamer's words. They name the work, never a mental
act ("thinking", "considering"), which would imply a mind (D1 (d)), and never the dreamer's words.

**D4. THE MIRROR KEEPS THE APP'S LOOK.** This revises C132-I item 8's note. Until the dreamer confirms it, the read-back
is the app's version of their dream; that is why they check it, and the app's look says so truly. **Once confirmed, the
dream is the dreamer's:** everywhere after, the readings' quoted lines, the look back and the journal, it shows in the
dreamer's voice. A screen reader names the mirror as the app reading back (C127-I I12).

**D5. THE SERIES QUESTION** keeps its place and carries no mark. Its label says the tradition asks, so it never reads as
one of the night's readings, which never ask (C134-I item 2). "Next" passes it like any invitation (C131-I item 4).

**D6. W7, THE CAP NOTE, IS THE APP'S VOICE**, outside any reading's look: it speaks about the readings, never as one. Its
words say "night", never "session" (C134-I item 5).

**WHAT DEPENDED ON THIS.** Product & Design's How the AI Appears, its Principles §4a and its Places Register (EM·10; two
new places under D1 (d); W7, W16). Lens Practice's Draft 11 (A's quotation rule, which every lens file's sources serve;
B; C). The lens register: a passage a reading may quote must be held in the lens file with its provenance. The tester
disclosure specification's next draft (D2). The Requirements List's Draft 2. Technology: the quotation check against the
lens file, and the composing labels.

---

## C136-I — no part of the app says a reading is true: C135-I item B and Lens Practice §9A's calibration clause corrected

**Filed 2026-10-22, by this machine. Raised by the founder 2026-10-22.** *Head of Interpretation's correction, under the Shared Core's never-a-verdict line; it changes no ruling of the founder's.*

**WHAT WAS WRONG.** Lens Practice §9A's calibration clause says the discernment pass "must be able to conclude, and when
true must state, that the comfortable reading is the true one", inherited from Framework v3. C135-I item B repeated it as
its reason against B3. Both declare a reading true. The Shared Core forbids it: no tradition is declared right, the app
gives no verdict, and the dreamer is the final authority on their own dream. The founder raised it.

**WHAT STANDS INSTEAD.** The clause's purpose is kept: a press that can never let a comfortable reading stand is a bias,
and a detectable one. Its rule now reads: **the press must be able to leave a comfortable reading standing, because being
comfortable is never evidence against a reading. No part of the app ever says that a reading is true, right or the one;
what holds is the dreamer's alone.** Lens Practice's Draft 11 carries this in §9A's place, and the old wording goes to its
archive with the rest of Draft 10.

**C135-I ITEM B, RE-GROUNDED.** The press is still B1, and B3 is still not possible, on C135-I's second ground alone: a
press that never shows either does nothing or changes a reading unseen, and the app never changes a tradition's words
unseen. Its first ground is withdrawn. Nothing else in C135-I changes.

**WHAT DEPENDED ON THIS.** Lens Practice's Draft 11 (§9A). Product & Design's How the AI Appears, which read C135-I's
reply. Technology, whose press must never produce a sentence that declares a reading true. Every later brief that
carries §9A.

---

## C137-I — the reflection as one paragraph in the app's voice; italics for the dreamer's words; W21 and W22 as sentences; white bubbles

**Filed 2026-10-27, by this machine.** *Item 1 is Head of Interpretation's, open to the founder; items 2, 3 and 4 are the founder's rulings, received as notice. Product & Design, its message 14.*

**1. THE REFLECTION AS ONE PARAGRAPH IN THE APP'S VOICE MEETS C1**, the Requirements List's four unblended voices. A line
quoted word for word, in quotation marks, with where it comes from named, is not a blend, as C135-I A holds for a source
quoted inside a tradition's reading. **The paragraph brings one risk placement did not: the app writes the words between
the quotations, and that is where interpretation enters.** So, on two conditions:
- **The app's own words in the paragraph say only where and when**: you wrote tonight, in the dream, the Jungian
  reading, the arc. Never a word that names a relation between the quoted lines: no echoing, mirroring, answering,
  recalling or connecting, no because, so or as if. Claiming a link is interpreting (C5; C129-I item 4).
- **The dreamer's words come first.** The reflection begins from what the dreamer wrote and never from the night (The
  Close §10).
Everything else C5 and C129-I item 4 hold stands: it never says what anything means, never praises or characterises the
dreamer, never asks, and ends in a full stop. How the AI Appears §3 changes with this; that is Product & Design's.

**2. ITALICS FOR THE DREAMER'S QUOTED WORDS, UPRIGHT FOR A SOURCE'S** (founder-ruled), inside readings and reflections.
In a reflection the dreamer's dream lines and what they wrote after the readings may both appear in italics; **each
quoted line of theirs says which it is**, so their waking words stay marked as waking (C122-I item 6). The attribution
the founder's design already carries does this.

**3. W21 AND W22 RETURN AS SENTENCES** (founder-ruled). C134-I item 3's allowance is not used, and the click-through
check it set for a design-only version is not needed. C4 and C12 apply as written. W22's line never reads as a judgement
on what the dreamer wrote.

**4. EVERY READING SITS IN THE SAME WHITE BUBBLE**, its tradition's name on a terracotta label (founder-ruled). Equal
weight is unchanged (C122-I item 6). The series question's label still says the tradition asks (C135-I D5).

**WHAT DEPENDED ON THIS.** Product & Design's How the AI Appears §3 and its Places Register (W21, W22). The Close's next
draft (§3.5, the reflection's form). The Requirements List's Draft 2 (C1, C5, W21, W22). Technology: the reflection's
composition and its check, which tests the connecting words against item 1.

---

## C138-I — the founder's Framer rulings at C10-P: the journal's rows; the mirror's boxes and the late dream; the arc inside the readings; the unread night's reflection; Help; feedback; settings

**Filed 2026-11-02, by this machine.** *The founder's rulings, received as notice; the conditions, and item 3, are Head of Interpretation's, open to the founder. Product & Design, its message 15, on the files filed at C10-P (commit fcaa808).*

**1. THE JOURNAL'S ROWS: NAMED AND UNNAMED NIGHTS MAY LOOK DIFFERENT** (founder-ruled). This replaces C131-I item 1's
"a named row and an unnamed row look alike", which asked more than the practice needs: a name is the dreamer's own act in
their own words, so showing it is no highlight offered by the app (the Requirements List S5). What stands from C131-I
item 1: a night that was read looks like one that was not; no row shows a time; the app never chooses among the
dreamer's words by importance. **One condition:** an unnamed row never shows an empty name slot or an invitation to
name it, which would be the app nudging.

**2. THE MIRROR'S BOXES AND "DREAM n" TAGS** are the app's look, as How the AI Appears §2.6 allows; C135-I D4 holds.
**A dream added after the mirror, the late telling, keeps its mark wherever the night's dreams are shown** (C90-I item 1;
C122-I item 3): its label says it was added later, and never that it is lesser. "Extra" is not used; the founder's words
come at the copy pass.

**3. THE ARC SITS INSIDE "THE READINGS", AS THE LAST OF THEM, WITH NO SECTION LABEL OF ITS OWN.** A section of its own, at
the level of the readings together, marks it as a different and weightier thing, closest to a conclusion, which L16
forbids. It keeps the same white bubble and size as every reading. **Its terracotta label may name its kind beside its
tradition**, for example "The Arc · Jungian": naming what it reads is honest, because it reads the night's dreams
together. The label never says or suggests it is a summary or a conclusion. "The Arc" as the founder's word meets that.
The section labels for the readings, the series question and the night's dreams stand.

**4. THE REFLECTION IN AN UNREAD NIGHT'S SPACE** takes the close's form (founder-ruled), under C137-I item 1's two
conditions, which reach it in full: the app's own words say only where and when, and the dreamer's words come first.
What it may quote is what that night holds: the dream and what the dreamer wrote.

**5. THE DARK THEME'S BUBBLES** (founder-ruled): the same for every reading. Equal weight is unchanged.

**6. THE HELP PAGE** (founder-ruled; X1, W26, C127-I I11, C131-I item 5). Static, uncounted, on the phone, opening offline:
right. The region from the phone's own setting, never location, never leaving the phone: right. **Gentlest first is
allowed on one condition, the check already in the design:** on the smallest phone the app supports, all three resources
show without scrolling. If that check fails, urgent help comes first. **The fallback says truly what 112 is**, the
European emergency number, and the international directory carries every other region.

**7. FEEDBACK ON THE SETTINGS PAGE** (founder-ruled) keeps C126-I item 4's rules. Anyone other than the founders reading
feedback comes to this department first.

**8. THE SETTINGS AND THE NIGHT/DAY SCHEDULE** (founder-ruled; the surfaces C126-I item 6 sends here): none changes the
practice. Word Animation Off answers C132-I item 8's note on the app's words appearing as speech, for any dreamer who
wants it.

**WHAT DEPENDED ON THIS.** Product & Design's main path, How the AI Appears and Places Register: the arc's section label
leaves, the late telling's label is written, the Help fallback's line. C131-I item 1's "look alike". The Close's next
draft. The Requirements List's Draft 2 (S5, L16, X1, W26). The law document's next draft (the Help page). The tester
disclosure (the Cohort 1 regions). Technology: the late telling's mark carried through the night's display.

*Read against product/main-path.md as filed at C10-P, sha256 d31d7ed017a336b0557f8d905d5d7223919752684612c74b8dddcac045b757aa.*

---

## C139-I — one click-through person before Cohort 1; the Help check made with them; C131-I item 5 amended

**Filed 2026-11-02, by this machine. Founder-ruled, received as notice.** *What the later checks can mean is Head of Interpretation's, open to the founder. Product & Design, its message 16.*

**THE THREE CLICK-THROUGH TESTERS BECOME ONE PERSON** (founder-ruled), who is not a beta tester. C122-I's conditions
carry over whole: invented dreams only, and nothing of theirs is kept except what they say about the design.

**C131-I ITEM 5'S CHECK ON "HELP" IS MADE WITH THAT ONE PERSON, UNTOLD.** They are the only one who can meet it cold:
Cohort 0 is the founder, who chose the word, and in Cohort 1 the disclosure tells every tester where Help is. So in both
cohorts the check means this: **if anyone takes "Help" for the app's instructions, in what they say, in feedback, or by
tapping it to look for them, the word changes.** One untold person is thinner evidence than three; the watching that
follows is what backs it.

**C134-I ITEM 3'S CHECK NO LONGER APPLIES**: it was for W21 and W22 said by design alone, and they are sentences again
(C137-I item 3).

**WHAT DEPENDED ON THIS.** C131-I item 5 and C134-I item 3, amended here. Product & Design's plan for the click-through.
The tester disclosure, which still tells testers where Help is.

---

## C140-I — Technology's first questions, through Product: what leaves the phone, said truly; one phone; the reflection composed freely; quotations; the press; plain forms; selection's backstop; the redrafts begin

**Filed 2026-11-03, by this machine. Items 3 and 11 founder-ruled.** *The rest is Head of Interpretation's, open to the founder. Product & Design, its message 17, carrying Technology Message 1 and technology/technology-change-record.md at sha256 42f03365c760e901f49fcc44cffca8c44b96df346da66bd93308e5369d0634ce (C1-T, C2-T).*

**1. WHAT LEAVES THE PHONE, SAID TRULY.** Speech is turned into text by an online service (founder-ruled 2026-11-03;
C2-T). C126-I item 1's sentence no longer holds, and Product & Design's draft says too much: a typed night never leaves
the phone unless it is read, and a spoken night leaves at recording, whether or not it is ever read. The dreamer is
told so, because it is a choice they have. **The substance, for the disclosure and wherever the company says it; the
founder's words to follow:** no sign-up, no account; a night's words leave this phone only to be read; if they are
spoken, the recording also leaves to be turned into text, and is then deleted; nothing keeps them. **Two conditions.**
"Nothing keeps them", and the recording's part, are said only once the transcription service is chosen and its terms
are read. **"The totals that leave carry nothing that identifies anyone" stays out of the disclosure until Technology's
design makes it true** (Technology's items e and p): in a cohort of four, one phone's totals arriving as that phone's
own record is close to identifying a person. This replaces C126-I item 1's sentence.

**2. THE JOURNAL LIVES ONLY ON THIS PHONE: AN ITEM IN THE DISCLOSURE SPECIFICATION'S §2.** A lost or broken phone loses
the journal; it is kept out of the phone's own backups; it cannot move to a new phone before Cohort 3 (C2-T items 1 and
2). Anyone trusting the app with real dreams must know it first.

**3. THE REFLECTION IS COMPOSED FREELY** (founder-ruled 2026-11-03), and that is accepted. C137-I item 1 stands as the
rule the app is built to, so a reflection that names a relation is a defect when it happens, never the design. When the
check fails, the closed-set form stands in: founder-written where-and-when phrases, everything else quotation, the form
of C129-I item 4's placement. **The list grows:** in Cohort 0, a relation the check missed puts its words on the list,
in every language. Only the words are filed, never the reflection. In Cohort 1 no one reads a tester's night, so the only
signal there is what testers say.

**4. QUOTATIONS** (C135-I A). (a) When a quotation fails its check, the reading is composed again without any quotation,
since a reading needs none. Only if that fails is the tradition replaced for the night. (b) A Swedish reading quotes only
a passage its lens file holds in Swedish, from a named translation with provenance; until the files hold one, Swedish
readings do not quote. A source is never machine-translated and presented as its own words. Whether a modern
translation may be quoted is counsel's.

**5. THE PRESS, WHEN IT FAILS TWICE, DOES NOT SHOW THAT NIGHT**, and the failure is recorded. No stand-in: a generic
press would be rote. C135-I item B, as re-grounded at C136-I, refuses a press designed never to show; it does not reach
one night's failure. The press is never a visible step, so nothing visibly goes missing.

**6. PLAIN FORMS IN SEARCH: THE SAME WORD WITH A DIFFERENT ENDING, AND ONLY THAT** (hus, huset, husen). When in doubt,
no match. Never a related word (S7).

**7. SELECTION'S BACKSTOP.** Selection's model check will sometimes let through a tradition whose reading would need
what the dreamer did not tell. **Every reading is instructed never to rest on what was not told, and to decline in its
own voice instead** (W14; C134-I item 2). So what reaches a dreamer when selection misjudges is a decline, never a reading
built on an assumption.

**8. BACKUP, WHEN IT IS DESIGNED FOR COHORT 2.** Deleting says truly that it removes the journal from this phone, and that
copies already backed up stay in the dreamer's Apple or Google cloud until they remove them there (X11). It never claims
more.

**9. TECHNOLOGY'S CORRECTIONS TO THE ORIENTATION MESSAGE OF 2026-11-02 ARE RIGHT.** How the AI Appears was filed (C9-P,
C10-P), not drafted. The filed rule is no per-person trend, score or measure (the law document §4, citing C56-I);
recurrence reads one dreamer's nights by design.

**10. C1-T ITEM 4'S FINDINGS ARE KNOWN.** X11's "the account" becomes the journal at the Requirements List's Draft 2; the
law document's narration of the old build as current is separated from its rules at its next draft (C124-I).

**11. THE REDRAFTS BEGIN** (founder-ruled), so the model's instructions are built from current documents and not from
documents plus every later entry. Lens Practice's Draft 11 first, then The Opening's Draft 8, then The Close's next
draft; each through a worker chat that closes when its replacement is filed. Technology's model work waits for them, as
it proposed.

**WHAT DEPENDED ON THIS.** The disclosure, which Product & Design writes from items 1 and 2. The tester disclosure
specification's next draft (items 1 and 2). C126-I item 1's sentence. Technology's build of items 3 to 7. Lens Practice's
Draft 11 (items 4, 5 and 7). The lens register: Swedish passages with provenance (item 4). The Requirements List's Draft 2
and the law document's next draft (items 8 and 10). Technology's model work, which waits on item 11.

---

## C141-I — Product's messages 18 and 19: no install ID; the press's failure; four redrafts; Help; Add to Journal; the series question; the screen reader; distress out of onboarding; the distress check narrowed

**Filed 2026-11-05, by this machine. The founder's rulings as marked.** *The rest is Head of Interpretation's, open to the founder. Product & Design, its messages 18 and 19, the second on the files filed at C11-P (commit 9840ed0); Technology's record through C3-T, sha256 6a10dfd3.*

**1. NO INSTALL ID IN COHORTS 0 AND 1.** Technology proposes none is needed: no request carries an identifier. Agreed;
it is strictly more private than C123-I item 3, which it suspends for those cohorts.

**2. "THE FAILURE IS RECORDED" (C140-I item 5)** means kept in that night's own record on the phone, with the press's
audit, where anyone checking the press for bias would look; in Cohort 0 that is the founder, on his own nights. It may
also be counted among the combined totals. Nothing more, and nothing per dreamer.

**3. FOUR REDRAFTS BEFORE COHORT 0.** Cohort 0 starts only once the redrafts are filed and built in, and Cohort 1 follows
10 to 14 days later (founder-ruled 2026-11-03). **Recurrence & the Series' Draft 4 joins C140-I item 11's three**: it
too feeds the model's instructions, through the series question and what a later night may read. The Opening's Draft 8
runs alongside Lens Practice's Draft 11, since the two do not overlap; The Close and Recurrence follow. All four filed
around the end of November is an estimate, not a date: it depends on how fast each worker's scripts are run.

**4. THE HELP PAGE** (founder-ruled, twice). Each region's cards run a therapist, the suicide line, the emergency number,
whether or not all three fit without scrolling. C138-I item 6's condition is withdrawn. **Recorded beside the ruling:**
Mind Självmordslinjen reports far more missed calls than answered, and Swedish public sources advise 112 in an acute
situation; on a small phone that card may sit below the fold. One number per card, text only, Chat on Mind's card alone,
and the fallback page with 112 said as Europe's emergency number: as ruled. **Each card says truly what it reaches**:
1177 is healthcare advice and a way to care, and the NHS Talking Therapies card says it serves England only.

**5. W24 READS "ADD TO JOURNAL"** (founder-ruled 2026-11-03), replacing C134-I item 4. The founder's reason: "This is
mine now" leaves unclear what is the dreamer's. The Requirements List W24's "never read as save" is set aside by this
ruling. A night the dreamer never adds is still kept, and the app's part in it still ends after 24 hours (C7).

**6. W18, THE SERIES QUESTION, HAS NO STAND-IN** (founder-ruled); when its composing fails, it is silent that night and
nothing shows it. This changes C134-I item 1 for W18 only.

**7. THE SCREEN READER'S DREAMER-OR-APP LABEL (EM·10) IS PAUSED** (founder-ruled) for Cohort 0. **If any Cohort 1 tester
uses a screen reader, the label is written before they begin**: a dreamer who cannot tell their own words from the app's
has lost what the practice rests on. C127-I I12 is met in part until then.

**8. NOTHING ABOUT DISTRESS IS SAID IN ONBOARDING** (founder-ruled 2026-11-05). The app is not built to meet a crisis, and
the beta does not press distress signals on anyone. Onboarding keeps what does the work: it is not therapy, and there
are things the app is not meant to hold (W27·15); Help is top right, on every screen (W27·16). **The full account lives
in the privacy and disclosure page beside the settings, and there one rule holds: that the distress signals run and
that nothing responds to them are always said together, never one without the other.** A tester told only that signals
run may believe something is watching over them, and nothing is. The specification's §2 items 1, 2 and 5 leave
onboarding by this ruling. The specification's next draft carries this item, the AI sentence (C135-I D2; W27·14) and
item 9.

**9. THE DISTRESS CHECK, AS TECHNOLOGY DESIGNS IT, NARROWS C63-I ITEMS 3 AND 4, AND BOTH NARROWINGS STAND.**
(a) **A night that is only recorded is not checked**, in Cohorts 0 and 1. Checking it would send off the phone the words
of a night the dreamer chose not to have read, against C140-I item 1; and since nothing responds to the check in these
cohorts, what is lost is data, not protection. **Before the app is built to respond to distress at recording, this
returns.**
(b) **No reviewer reads a single night's firing.** This must hold: the disclosure tells testers no one reads their
dreams (W27·17), and a reviewer reading a firing would make that false. The signals are tuned from counts in Cohort 1,
and in Cohort 0 from the founder's own nights on his own phone.

**WHAT DEPENDED ON THIS.** Product & Design's onboarding, its privacy and disclosure page, its Places Register (W18, W24,
W27, EM·10) and the Help page. The tester disclosure specification's next draft (items 8 and 9). The law document's next
draft (item 9; C63-I). The Requirements List's Draft 2 (W24, X1). Recurrence & the Series' Draft 4 (item 3). Technology:
no install ID; the press's failure kept in the night's record; the distress check as designed.

---

## C142-I — the check lists approved against the practice; their approval delegated; the founder's own Cohort 0 export, and the study of it

**Filed 2026-11-06, by this machine. Item 0 and the export are founder-ruled.** *The lists' words and the conditions on the export and its study are Head of Interpretation's, open to the founder. Product & Design, its message 21, carrying Technology Message 5's questions (C3-T 2i).*

**0. THE CHECK LISTS ARE APPROVED BY HEAD OF INTERPRETATION** (founder-ruled, delegated). TECH·3, TECH·4 and TECH·5 in
product/founder-lists-for-technology.md, now and as they grow. No dreamer ever sees them; they are rules for the app's
checks, not dreamer-facing words, so the Shared Core's line that dreamer-facing words are written by a person does not
reach them. TECH·1 and TECH·2 stay with the founder: the first trims the dreamer's own opening, the second is the
control's own words.

**1. TECH·4, THE REFLECTION'S LIST, IS CONFIRMED, WITH ONE GAP CLOSED.** It caught words that link the quotations, but
not words that say what something means, nor praise: TECH·3 held those and checked only the other composed lines. The
reflection never says what anything means and never praises or characterises the dreamer (C137-I item 1).
**(a) TECH·3 checks the reflection's own words too**, every entry except the time words that place it in the night:
today, tonight, this morning; idag, i natt, inatt, ikväll, i morse. Its words that reach outside the night (yesterday,
lately, recently, this week; igår, på sistone, nyligen, den här veckan) and childhood / barndom do check the
reflection: it speaks only of this night.
**(b) TECH·4 gains, in English:** remind, reminds, reminded, reminds of, evoke, evokes, evoked, suggest, suggests,
suggested, hint, hints, hints at, hinted.
**(c) TECH·4 gains, in Swedish,** the reminding and suggesting verbs: påminde om, antyder, antydde, väcker, väckte; and,
because a Swedish entry matches only the form written, the past forms its verbs lacked: svarade på, återkallade,
kopplade, hängde ihop, länkade, relaterade, motsvarade, liknade, pekade på, talade till, återvände till.

**2. TECH·5, THE PRESS'S LIST, IS CONFIRMED, WITH ONE GAP CLOSED.** The press never ranks one reading above another
(C135-I item B), so it also refuses ranking and truth words. **In English:** the better reading, a better reading, fits
best, best fits, fits better, more fitting, most fitting, truer, closer to the truth, nearer the truth, the truth.
**In Swedish:** bättre tydning, den bättre tydningen, passar bäst, passar bättre, bäst passande, mer passande, mest
passande, sannare, närmare sanningen, sanningen.

**Every list stays a floor.** A word on a list is refused every time; what a list does not hold is caught only by a model
check, which fails sometimes (C140-I item 3).

**3. THE FOUNDER'S COHORT 0 EXPORT** (founder-ruled). In the founder's own Cohort 0 build only, a night may be sent from
his phone to restricted/ for study, never through a server or any service, and absent from every tester build. He rules
that his own exported nights may be read by anyone he chooses, Claude chats included, and accepts that reading one in an
AI chat sends it to that chat's AI company. **Technology's three questions:**
(a) **It fits the Shared Core**: restricted/ is not a shared document, and this project already holds the founder's
frozen journal there on the same footing.
(b) **They are read in this department's study chat**, never in a Product or Technology chat. The founder may read them
anywhere he likes; this governs the company's chats.
(c) **The export leaves out the distress results (X3, X4): confirmed.** The founder reads those on his own phone, where
Cohort 0's tuning happens (C141-I item 9).
**The conditions on the study:**
- restricted/ stays outside the repository, as it is (checked by this entry's script). Nothing from it enters a shared
  document as evidence, example or principle, including anything the study finds. **Findings leave the study only as
  rule changes or as words for a list**, never as a night's content, as C140-I item 3 does for the reflection.
- **The study never computes what share of readings land**, or any figure of the kind, on the founder's nights or any
  others (the Shared Core). The founder's marks and responses are never taken as proof that a rule works: agreeing with
  the founder is not passing, as agreeing with the journal is not.
- It never generalises from his nights about what a symbol means (the role block).
- restricted/ is backed up to the founder's encrypted cloud store; exported nights go there too. Recorded so it is known.
**The study chat** opens under Head of Interpretation, reporting to it, once Cohort 0 has nights to export; its brief is
written then.

**WHAT DEPENDED ON THIS.** product/founder-lists-for-technology.md, at its next filing (items 0 to 2). Technology's checks
for the reflection and the press. Technology's export, built only for the founder's Cohort 0 build. The study chat's
brief, when Cohort 0 begins.

*Read against product/founder-lists-for-technology.md, sha256 798a750c227e9486a266d80bdf2f33d5b3b50234fb3d9256a47708d1ccac9182.*

---

## C143-I — The Opening, Draft 8, filed; Draft 7 whole to archive; the mirror's place invites additions; the rulings it was written to

**Filed 2026-11-06, by this machine.** *Head of Interpretation's method rulings of 2026-11-05; Q2, Q3, Q4, Q6, Q7 and Q8 founder-ruled
2026-11-06 as F1 to F6, F2 with an amendment of C124-I's guard and C125-I item 3. Written by The Opening Draft 8 worker
to Head of Interpretation's brief of 2026-11-05.*

**FILED.** interpretation/the-opening-draft-8.md, sha256 d2613ac83c8cbe4a5d255b44389731319a86c7698f2c5df07b82bd3afe55d026 (as corrected; see the entry correcting it).
Draft 7 (da8dba85c8a197bae8e4c36f437afa344bbe38c553a9786a8dc334744575eeeb) moves whole to archive/the-opening-draft-7.md,
with archive/the-opening-draft-7-archive-note-2026-11-06.md beside it, sha256
074df873bd0ad7524827eb527eaf340d6455245b77b37c6208b86b8033b77ac7: every Draft 7 block Draft 8 does not carry, verbatim,
with its reason. Of Draft 7's 277 blocks, 204 are carried verbatim and 73 are in the note; none is missing and none
altered (check_blocks.py, run on the three files above; the block definition is in blocks.py and in the note). Draft 8
was written against change-record.md at c14c00a8 and The Foundations at cc32ecb4, the repository at commit 19c162c.

**THE METHOD RULINGS, BY NUMBER** (Head of Interpretation, 2026-11-05).
- **A1.** What one night is: Draft 8 points at C128-I item 6 in one line; Recurrence & the Series' Draft 4 states it.
- **A5.** Draft 8 points at Lens Practice, Recurrence & the Series and The Close by name and by the thing named, never by
  heading or section number. Head of Interpretation reconciles Draft 8 with Lens Practice Draft 11 at filing.
- **Q2 (F4, founder-ruled 2026-11-06).** A late telling is only a dream the dreamer adds after the mirror is
  confirmed, by their own act. A dream told inside an
  answer stays that answer, verbatim; nothing reclassifies it. A late telling never enters the markers or the score.
  This narrows C90-I item 1's "told unprompted after the questions begin".
- **Q3 (F1, founder-ruled 2026-11-06).** C128-I item 5, confirmed at C130-I item 2, governs the mirror's form: the telling in the dreamer's own words,
  person and tense as said, not shortened; only filler sounds and plain stutters dropped. Splits and numbering are
  structure. Draft 7's "second person, present tense, shorter than the account" is retired.
- **Q4 (F2, founder-ruled 2026-11-06).** The mirror's seam mark is retired. **The founder adds, amending C125-I item 3
  and C124-I's guard ("never for more"): THE MIRROR'S PLACE HAS TWO JOBS.** It asks what the mirror got wrong, and it
  invites the dreamer, in general, to add anything they missed: people often miss details in a first telling, and the
  dreamer decides what was missing. It never points at a gap, never names a part of the dream, never suggests what
  might be missing; pointing at a spot would be the app deciding which part matters before any tradition has spoken,
  which is the seam, and it stays retired. What the dreamer adds there is part of the telling, before the mirror is
  confirmed. It is recorded exactly as a correction is: its own kind (Draft 8 names it the *mirror addition*), so the
  capture layer stays separable, and the readings read it. It is not a late telling, which comes only after
  confirmation (Q2). The place stays one fixed founder line, the thirty-first; its Must and Fails if gain the
  invitation and the never-points rule. **The cost, stated:** C124-I's cost grows. Additions made at a mirror met hours
  after waking may carry waking material into what recurrence reads; the guard is now that the place points at
  nothing, not that it asks for nothing more.
- **Q5.** The opening's answer keeps the name "the stood-out answer". The close's answer is named "the dreamer's
  response" when The Close is redrafted (C132-I item 4).
- **Q6 (F6, founder-ruled 2026-11-06).** "Passed over", "none" and "not asked (one image)" are three distinct values. The markers and the score compute
  from what exists; a passed-over bridge supplies nothing that night.
- **Q7 (F3, founder-ruled 2026-11-06).** Interpret Now is not offered at the mirror; it starts at "what stood out". Moving on from the mirror into the
  opening confirms it, by whatever control (C135-I D4). Leaving the app at the mirror pauses the night and does not
  confirm it.
- **Q8 (F5, founder-ruled 2026-11-06).** Each composed line is held to C128-I item 1's rules and to its own Must and Fails if in The Opening's founder
  copy; the bridge also to C70-I item 7's test, every night. Stated once in The Opening; those items are both the
  stand-ins' spec and the check's source.
- **Q9.** The entrance line before the mirror and C125-I item 3's thirty-first place are one place, with the two jobs
  Q4 gives it.
- **Q10.** The Opening's research note, interpretation/opening-research-2026-09-07.md, is not re-read in this pass; its
  path is named once in "The marks" as what would settle the [RELAYED, Draft 5] marks.
- **P1.** In blocks carried verbatim from Draft 7, a [READ] mark is Draft 7's reading at the hashes C86-I records, and
  stands in Draft 8 as [RELAYED, Draft 7]. Marks in new text are this session's.
- **P2.** The history of Drafts 5 and 6 leaves Draft 8; Draft 7, which carried it, is in archive whole.
- **P3.** Carried blocks keep their lowercase "interpret now"; new text uses the control's name, "Interpret Now".
The brief's other corrections (A2 to A4, A6, A7) and the memo's points 12 to 29 are carried out in the text and need no
ruling of their own.

**FOUND.**
- Draft 7's last block had lost its opening words: it began ", kept verbatim: no matter where…". No entry recorded it.
  Draft 8 restores the north star whole, in The Close Draft 4's form; the mangled block is in the note (R19).
- Draft 7 cited the old build's design for the capture-review screen and for "one thing per turn"
  (archive/ui-ux-design-old-build-superseded-2026-10-07.md). Draft 8 cites neither; "one thing per turn" stands as
  its own rule.
- Draft 7 pointed at Draft 5's rulings "by pointer (C67-I item 1)", which resolves nowhere (C115-I item 1). Draft 8
  points at C115-I, where the text is carried.

**WHAT DEPENDED ON THIS.**
- **Technology.** The model's instructions for the mirror and the opening's questions, held until this draft was current
  (C140-I item 11; C141-I item 3): the mirror's form (Q3), the mirror's place and the mirror addition (Q4, Q9), the
  composed lines and their check (Q8), Interpret Now and passed over (Q6, Q7), the late telling (Q2), the record kinds.
- **Interpretation.** Lens Practice Draft 11: "the stood-out answer" kept; passed over as a value the chain may
  receive; its rules for questions reach the composed lines; pointed at by name. Recurrence & the Series Draft 4: what
  one night is (A1); the capture layer as a kind; RQ1 gains the mirror addition (Q4); RQ1's stated ground, "before the app
  asked anything", no longer covers it, and restating that ground is Recurrence's; the
  late telling as Q2 defines it; RQ1 and its waking-life ruling
  pointed at by name. The Close's next draft: "the dreamer's response" (Q5); its per-night bridge record pointed at by
  name. The law document's next pass: Draft 8 still points at "The line friction cannot cross", and C83-I item 7's
  sentence is still owed. The Requirements List's next pass: the behaviour list; four places composed with stand-ins;
  the thirty-first place, with its two jobs; W7 says "night".
- **Product & Design.** The mirror screen gains the invitation to add anything missed, and a way to add (Q4). The
  Places Register: the four framing lines composed with founder-written stand-ins; the mirror's place, the
  thirty-first, one fixed line with two jobs, pointing at nothing; Interpret Now from "what stood out", not at the mirror; the late
  telling marked as added later. The mirror's design: the telling as told, not shortened (Q3).
- **Organisation & Strategies.** Nothing.
- **The founder.** Founder copy: the stand-ins for items 1, 3, 4 and 5; Interpret Now; the record line; the cap note,
  saying "night"; the mirror's place, now asking what the mirror got wrong and inviting additions in general.

**HEAD OF INTERPRETATION, ON THE WORKER'S THREE OPEN POINTS** (2026-11-06, open to the founder).
- **G1. The mirror addition is capture layer**, as the founder's "part of the telling" says. RQ1's old ground, "before
  the app asked anything", no longer explains it. The ground Recurrence & the Series' Draft 4 states instead: **the
  capture layer is what the dreamer told of the dream before the app said anything of its own about it.** The mirror's
  read-back is only the dreamer's own words, and its invitation points at nothing. A late telling stays outside the
  capture layer: it comes after the app's readings or questions have spoken (C90-I).
- **G2.** The name "mirror addition" stands.
- **G3.** Watch item 3 stands as written: whether additions carry waking material, or grow into what the dreamer now
  thinks rather than what they dreamt. Read on the founder's own nights in Cohort 0.
- **A5 is carried out at Lens Practice Draft 11's filing.** Draft 8 points at Lens Practice by the thing meant in four
  places; Draft 11 keeps each findable, and its first section is reconciled against Draft 8's "What the opening records
  and hands on" at this filing's hash.

*Filed with Draft 8: its tools, at interpretation/opening-draft-8-tools/, so a fresh session can re-run the block check; their output is check-output.txt beside them.*

---

## C144-I — the disclosure in two layers: what onboarding carries, and what is one tap away before consent

**Filed 2026-11-06, by this machine. The founder's ruling in intent (2026-11-06).** *The conditions are Head of Interpretation's, open to the founder: the tester disclosure specification is this department's. Product & Design, its message 22, on the Places Register at C13-P (commit 36f7f46).*

**THE DISCLOSURE MAY BE LAYERED.** The founder rules that onboarding must not carry technical detail to someone who has
just come to share their dreams, as C141-I item 8 already did for W27·6. The tester disclosure specification's §2 is met
by a first layer in onboarding with the full text one tap away, **on three conditions:**
1. **The "read everything" link opens the full disclosure before the one consent (MP·8)**, and the consent says it
   covers the whole text.
2. **The first layer says that a night's words go to an outside AI service.** As proposed, onboarding said only that
   they leave the phone to be read and that an AI composes; that they go to another company was only in W27·3. Half a
   sentence in W27·2, in the founder's words, says it (for example: to an AI service in the EU, which keeps nothing).
   The companies' names stay on the full page. For someone about to share their dreams, this is the fact that matters
   before agreeing.
3. **W27·10 says plainly that feedback sent through TestFlight shows who sent it**, since Apple attaches the tester's
   email, so it is never confused with the in-app feedback, which W27·9 says carries no name.
**The first layer:** W27·1, ·2 (with condition 2), ·5, ·13, ·14, ·15, ·16, ·17, and the link. **The full page only:**
W27·3, ·4, ·6, ·8, ·9, ·10, ·11, ·12, with every part in full. W27·10 and ·11 are also carried in the TestFlight
description (MP·56), where testers meet TestFlight. W27·10's correction, in the founder's words: received. **Counsel
confirms the layered form before Cohort 1.**

**WHAT DEPENDED ON THIS.** Product & Design's onboarding, its disclosure and privacy page, its Places Register (W27·2,
W27·10, the new link place) and the TestFlight description. The tester disclosure specification's next draft, which
states the two layers. Counsel, before Cohort 1.

---

## C145-I — The Opening Draft 8 corrected, one paragraph replaced; the flagged text scrubbed from the repository's history

**Filed 2026-11-07, by this machine. The scrub is founder-ruled 2026-11-07, on Head of Interpretation's advice; the rest is Head of Interpretation's.**

**WHAT WENT WRONG.** The Opening Draft 8 was filed as C143-I with one paragraph that shares a run of words with a
restricted file holding founder material removed from Draft 5. The founder-material check said "VERDICT NOT CLEAN: do not
file" and exited 0; the filing script read only the exit code. Head of Interpretation's error. Checked afterwards in place,
the filed file read clean, because the check passes over text already in the repository; checked against the repository as
it was before the filing, the verdict reproduced. Paragraph by paragraph, one was flagged: new text from Draft 8's template,
not a block carried from Draft 7. The template filed with Draft 8's tools carried it too.

**THE CORRECTION.** The paragraph is rewritten in new words with the same rule: what the dreamer writes in the space before
being read is waking material the opening's questions never draw on (C127-I I3), and a night's name is not dream material,
so nothing in the opening anchors on it (C131-I item 1; C128-I item 1). No run of four or more words is kept. The archive
note for Draft 7 is unchanged. Every corrected file was checked against the repository as it was before the filing, and
reads clean.

**THE SCRUB** (founder-ruled). The history was rebuilt from the commit before the filing: the filing commit was made again
with the corrected files, every later commit was replayed on top unchanged, and the script proved that no flagged file is
reachable from the new history before pushing. Inside the rebuilt filing commit, C143-I's hash for Draft 8 now names the
corrected text; that is the only change made to a filed entry, made to keep founder material out, and recorded here. **The
old filing commit joins C118-I item 7's list:** no one else is granted access to the repository until its ID, like the
October rewrite's, is shown gone from GitHub. The flagged files are held in restricted/ by pointer, quoted nowhere.

**FROM NOW ON** the founder-material check is read by its verdict line, never its exit code, and a corrected file is
checked against the repository as it was before the flagged version entered it.

**WHAT DEPENDED ON THIS.** C143-I, whose Draft 8 hash is now the corrected one. Technology: anything taken from the flagged
paragraph takes the new text; the rule is unchanged. Every machine holding a copy of the repository resets to the new
history. C118-I item 7's list of commit IDs.

*Rebuilt commits, old -> new: 8af88f3 -> 84a7812. Draft 8 now sha256 d2613ac83c8cbe4a5d255b44389731319a86c7698f2c5df07b82bd3afe55d026. Flagged files kept in restricted/opening-draft-8-flagged-2026-11-07/.*

---

## C146-I — the age band stays on the phone; the founder's distress results in his own export; the one exception to keeps nothing

**Filed 2026-11-07, by this machine. Items 1 and 2 founder-ruled 2026-11-06.** *Item 3 and the condition under item 2 are Head of Interpretation's, open to the founder. Product & Design, its message 23, from Technology Messages 7 and 8.*

**1. THE AGE BAND NEVER LEAVES THE PHONE** (founder-ruled). It serves the under-18 gate on the phone and nothing else. With
a cohort's other counts it came close to a per-person record. C123-I item 4's count of age bands no longer exists.

**2. THE FOUNDER'S DISTRESS RESULTS GO INTO HIS OWN EXPORT** (founder-ruled), in his Cohort 0 build only, with the turn at
which a signal fired; he does not see them while using the app. This reverses C142-I item 3c. C142-I item 3's conditions on
the study hold. **One more:** signals tuned on one person's nights fit that person; the study never tunes the distress
signals to the founder's own patterns as though they were everyone's. Tester builds are unchanged (C141-I item 9).

**3. "KEEPS NOTHING" HAS ONE EXCEPTION, AND BOTH LAYERS SAY SO TRULY.** The reading service may store and review content its
automated systems flag as possible child sexual abuse material. **The full page (W27·3)** gains one plain sentence saying
so, in the founder's words. **The first layer (W27·2)** says "nothing keeps them", which is then not true in every case: it
gains a few words in the founder's words, for example "except where the law requires it", so it stays true without
technical detail. Counsel confirms both before Cohort 1.

**WHAT DEPENDED ON THIS.** Technology: the age band never sent; the distress results in the founder's export. Product &
Design: W27·2 and W27·3. The tester disclosure specification's next draft. Counsel.

---

## C147-I — through Cohort 2, no distress check and no Help page; nothing of either in onboarding; support returns later, through partnerships

**Filed 2026-11-07, by this machine. Founder-ruled 2026-11-07.** *Head of Interpretation advised keeping a static support page in Settings; the founder ruled otherwise, for the reason below, and the advice is not raised again.*

**THE RULING.** For Cohorts 0, 1 and 2 the app is purely a dream interpretation app. **There is no distress check**: it is
not built and does not run, and nothing about a night is classified for distress. **There is no Help page and no Help
icon.** **Onboarding carries nothing about distress or help**, and neither does anything else in the app. **The founder's
reason:** a support page will come later, built through Soul Dreams and through partnerships with the right organisations;
designing it now would close directions the company wants open until there are real users, findings and feedback to
decide from. The direction is decided after Cohort 2.

**WHAT STAYS, UNCHANGED.** The rules that keep a reading from hurting anyone are how the readings behave, not a monitoring
system, and they stand in full (the law document §2): never pressing toward the wound; no friction on an account of harm
or on fresh grief; no behavioural prescription, ever; inner figures, not real people; "no" is final; warmth never withheld;
discomfort never gamified. **The therapy boundary stands** (the law document §2 and §3): the plain statement that the app
is not therapy stays in onboarding, in its gentlest form, and is expanded on the privacy page (founder-ruled), because
that boundary governs everything the company says publicly. The Foundations §6 already holds the distress apparatus as deferred, returning
when evidence shows it is needed; this ruling is within it.

**WHAT THIS SETS ASIDE, THROUGH COHORT 2.** The law document's standing rule that static crisis resources are reachable
from the app at all times (C44-I), and its distress-signal gate (§1; C51-I). **What it overtakes**, which stays in the
record as history: the Help word, page, order, cards and check (C127-I I11, C131-I item 5, C138-I item 6, C139-I, C141-I
item 4, C144-I's W27·16); the distress check and its disclosure (C141-I items 8 and 9); the founder's distress results in
his export (the entry recording Product's message 23, item 2). Nothing filed needs undoing.

**WHAT DEPENDED ON THIS.** Product & Design: the Help page and icon, W26 and its parts, W27·6's distress sentences,
W27·16, W27·17's words on firings, onboarding (the not-therapy line kept, in its gentlest form), the privacy page (the line expanded), the handover to Technology (its Help screen, and its §8
rows for W27·6 and W27·17). Technology: the distress check and the Help page are not built; the founder's export carries
no distress results. The law document's next draft (§1 and its standing rule, set aside through Cohort 2). The tester
disclosure specification's next draft. Before Cohort 3, the founder decides what support looks like and how it is built.

---

## C148-I — the waking-life invitation's heading returns: "Waking Life" / "Det vakna livet"; C133-I item 3 withdrawn

**Filed 2026-11-07, by this machine. Founder-ruled 2026-11-05.** *Filed on its own so The Close's and Lens Practice's next drafts can cite it; it had been held for Lens Practice Draft 11's filing entry, and a ruling with no entry does not exist.*

**THE RULING.** The waking-life invitation keeps its own heading: one fixed founder line, **"Waking Life" in English and
"Det vakna livet" in Swedish**. The invitation under it stays composed each night (C129-I item 5).

**WHY.** The Foundations §11 item 1 requires the grounding check to be visibly not a lens, with its own heading, its own
shape, plainly outside the list, and calls that condition not optional. C133-I item 3 retired the heading on the ground
that the app's look now did its job; it never weighed §11 item 1, and an entry cannot set aside The Foundations. Head of
Interpretation's error, found by the Lens Practice Draft 11 worker. **C133-I item 3 is withdrawn.** Its other items stand.

**WHAT DEPENDED ON THIS.** The Close's next draft (the heading is its place). Lens Practice Draft 11 (§8, and §15 item 5
as a founder copy place). Product & Design's Places Register, where the heading returns over W17, as its message 21
already registered. The Requirements List's Draft 2 (W17).

---

## C149-I — Lens Practice Draft 11 filed: no questions and no hypotheticals in a reading; the decline composed and its limits; quotations; the press settled; the waking-life invitation after the response; the arc inside the readings; §14 to Product & Design

**Filed 2026-11-07, by this machine.** *Head of Interpretation's method rulings of 2026-11-05 and 2026-11-07, open to the founder. Written by the Lens Practice Draft 11 worker to Head of Interpretation's brief of 2026-11-05.*

**FILED.** interpretation/lens-practice.md, sha256 6c77a3238bc478edb70f680655f9faccd6fef70ff35fcc4f915a2fca28090660 (Draft 11). It replaces Draft 10, dc08a7f20622cadae2072df14d520423ff4344a7b98756aefc6e02e14597ef73, which is not copied whole anywhere else. Every Draft 10 block Draft 11 does not carry is in interpretation/lens-practice-archive.md, sha256 2431b086a6fe646f00b3a99afc4a16273a03a6cf5b5d1821ad292dbcb39aea08, under the note of 2026-11-07, verbatim, each with why it left; the archive before it is an exact prefix of the new file (checked at filing). Of Draft 10's 324 blocks, 277 are carried verbatim and 47 are in the note; none is missing (check_blocks.py; the tools at interpretation/lens-practice-draft-11-tools/, filed from lens-practice-draft-11-tools.zip, sha256 1d2df9cf45db71f2938c6d0571012d03de7661b7fadeda47996135209fb2eecc). Written against change-record.md at 3bb1f14e, The Opening Draft 8 at d2613ac8, The Foundations at cc32ecb4, the repository at 239e8e4. The waking-life heading is C148-I's, cited and not re-recorded here.

**THE RULINGS IT WAS WRITTEN TO, BY NUMBER** (Head of Interpretation).
- **P1-1 to P1-8** (2026-11-05): §14 stays the source statement, numbers stable, routed to Product & Design; W7 is not
  Lens Practice's; "rules for questions" means §8's bridge test and its "what is not asked" list, reaching the waking-life
  questions; the arc's kind-label is carved out of §5.1; C122-I item 3, C127-I I3, C132-I item 4, C128-I item 3 and
  C134-I item 2's watch are carried; §1 is written against The Opening Draft 8, reconciled at filing, and points at it by
  name.
- **Part 2 items 1 to 17 and point B** (2026-11-05): the stale lines corrected; the Freudian labels kept as history.
- **Q2.** The press is composed, a practice turn, with no stand-in; W16 holds no words.
- **Q3.** It presses on the readings and their relation to the stance and asking answers, never on either by itself.
- **Q4.** The press cannot be marked.
- **Q5.** Every tradition declining is a valid landing. Any span failure with none passing is C122-I item 5's failed
  reading: read again, no declines shown.
- **Q6.** A second decline is replaced by the next with purchase; if none, the slot is empty.
- **Q7.** The concentration line's second form names both images, in the dreamer's words, and nothing else.
- **Q9.** One archive place: the dated note appended to lens-practice-archive.md.
- **Q10.** §14's form. **Q11.** "Night" only in dreamer-facing words, by one rule.
- **Q12.** The founder-material check decides; a night date is not founder material.
- **Q13** (2026-11-07). The decline is composed, with no stand-in; when composing it fails, the next with purchase, or an
  empty slot.
- **Q14** (2026-11-07). The record keeps that the press held back, never why on grounds of harm or grief (C147-I).
- **Q15** (2026-11-07). The chain receives the composed lines and never consumes them.
- **Q16** (2026-11-07). A late telling may be mentioned by a reading but never grounds a paragraph or gets a reading of its
  own: it is outside the canonical account and never enters the markers. Draft 11 adds nothing about it.
- (2026-11-07) With no distress gate through Cohort 2 (C147-I), the press never presses on an account of harm or fresh
  grief, or toward the wound, by its own judgement, pointing at the law document §2.
- (2026-11-07) The "Why:" line per archive passage; The Opening Draft 8's nine pointers kept findable.

**FOUND.** Draft 10 watched "whether age reads as depth" (§13 item 5) while its §7.3 said that residual was gone. §12 Test
5 named oldest-first, withdrawn 2026-09-12, as current. §16.8 called proposed a block The Foundations' 2026-09-30 Items 1
and 3 had already carried. §16.4 said audit-log.md and change-record.md did not exist. §11 item 5 said "five kinds" and
listed six. C133-I item 3 had retired a heading The Foundations §11 item 1 requires; withdrawn at C148-I.

**WHAT DEPENDED ON THIS.**
- **Technology.** The AI's instructions for the readings, held until this draft was current (C140-I item 11; C141-I item
  3): selection's not-told rule and its backstop; no questions or hypotheticals in a reading; the decline, composed;
  quotations and their fallback; the two empty nights told apart; the press, composed, with its limits and its record of
  holding back; marks; the chain's inputs, including passed over and the composed lines received and not consumed.
- **Interpretation.** The Lens Register, by a pass: lens files' §7 sections drop any named missing premise (§11 item 7);
  quotable passages held with provenance, and in Swedish from a named translation (§11 item 12). The Close's next draft:
  the heading, the dreamer's response, the marking rule's wording. The Requirements List's next pass: §14's rebuilt items
  with stable numbers; items 18 to 20 new; W14 composed; W15 retired; W16 holds no words; W17's heading; §15.15 new. The
  Opening: W7 says "night". Recurrence & the Series: nothing.
- **Product & Design.** The Places Register: W14, W15, W16, W17 and the marking line; how either empty night is shown;
  the press's look (B1), unlabelled.
- **Organisation & Strategies.** Nothing.
- **The founder.** Founder copy: the stand-ins for §15 items 1 and 13; the waking-life heading in both languages
  (C148-I); §15.15, what the dreamer is told about marking.

---

## C150-I — The Close, Draft 5, filed; Draft 4 whole to archive; the rulings it was written to

**Filed 2026-11-07, by this machine.** *Head of Interpretation's method rulings of 2026-11-07, open to the founder.
Written by The Close Draft 5 worker to Head of Interpretation's brief of 2026-11-07.*

**FILED.** interpretation/the-close-draft-5.md, sha256 fa23d0e8d92a0f570f55736c8cf0c6a31c075af57d8e7f2e82070ecce3e7353d.
Draft 4 (b2708555bf78690f5700e18694ef6bf51dd0fa334dc9c3af7dc4256358e9829f) moves whole to archive/the-close-draft-4.md,
with archive/the-close-draft-4-archive-note-2026-11-07.md beside it, sha256
a6fd225d169f02f66d1a4ac308a5a4fd0af6921ad531d8e0c6e54e1206acbf3f: every Draft 4 block Draft 5 does not carry,
verbatim, with its reasons. Of Draft 4's 251 blocks, 125 are carried verbatim and 126 are in the note; none is missing,
altered or stray (check_blocks.py, run on the three files above; the block definition is The Opening Draft 8's
blocks.py, unchanged, and is stated in the note). Draft 5 was written against change-record.md at f4273d3d (commit
20c5d3c), whose first 388,601 bytes hash to 3bb1f14e, the record at which C118-I to C147-I were read whole; C148-I was
read at f4273d3d. Also read: The Foundations at cc32ecb4; The Opening Draft 8 at d2613ac8; the Requirements List at
22f742c7 (its close rows); the law document at 4f83555e; interpretation-framework-v5 at 77178b99 (by grep).

**HEAD OF INTERPRETATION'S RULINGS, 2026-11-07, BY NUMBER.**
- **1.** The waking-life heading is C148-I's, cited; it is founder place 1, written.
- **2.** The press's place is C135-I item B as re-grounded at C136-I, and C140-I item 5; the arc's is C138-I item 3.
- **3.** The draft states the reflection's rule, and one sentence that the lists approved under C142-I item 0 hold its
  words; no list content.
- **4.** Each quoted line of the dreamer's says truly whether it is from the dream or written after the readings, and
  names no time it cannot know. Product & Design's closed-set phrases follow.
- **5.** W7, the cap note, is The Opening's founder copy; The Close points at it.
- **6.** "Add to Journal" is offered from the waking-life invitation on (C131-I item 4); "never read as save" leaves
  (C141-I item 5).
- **7.** *The dreamer's response* names everything the dreamer writes in the close except the waking-life answer, each
  write kept separately (B7).
- **8.** Marks are used by placement only; the reflection never says a line was marked; its attribution names where
  the line comes from.
- **9.** C147-I reaches every place Draft 4 leaned on detection or Help. The not-therapy line is pointed at through
  C147-I's ruling; no onboarding words are quoted.
- **10.** H- and B-numbers are stable; a retired one stays retired in place; new ones are appended; headings other
  documents name keep their words; section numbers go.
- **A6.** The press stays off the reflection's list.
- **A8.** The look back shows the answers to the close's invitations without the invitations; the record keeps them
  (B15).
- **A10. C127-I I3's "at most three reflections in all" is amended:** the close's reflections are counted apart from
  those made before the night was read. At most three before; the close has its own three. The reason: the founder's
  purpose for the close (C129-I item 4) is that it helps the dreamer make sense of the night, and a read night with no
  reflection would defeat it.
- **Q8.** The holding register stays, dormant, with one line pointing at C147-I. **Q9.** "Through Cohort 2" covers
  every stage of Cohort 2. **Q10.** "Add to Journal" fails if it implies that a night never added is lost or
  incomplete.
- **P1.** The reflection's writer is told which sentences were marked; the guards stand. **P2.** What was written
  before the night was read stays off the close's list, for the stance's reason (C74-I item 2), and stays in the look
  back in time order. **P3.** No response, no reflection, no empty-case line.

**FOUND, AND CARRIED IN THE TEXT.**
- Draft 4 called the series question a question "asked as a reading through a named tradition", against C134-I item
  2 and C135-I D5. Draft 5: asked by a named tradition, never one of the readings.
- The series question's silence has a fourth cause, its composing failed (C141-I item 6): constraint 6, and new
  constraints 10 and 11.
- Draft 4 called the reflection's harmful form "structurally impossible". Under C140-I item 3 it is forbidden by H7
  and looked for by the check, and a slip is a defect when it happens.
- Draft 4's residual leaned on measuring distress; through Cohort 2 nothing measures it (C147-I).
- C129-I item 3 lets the close use marks, while C129-I item 1 forbids any invitation naming a reading, so the close
  cannot ask about a mark. Ruled at 8 above.
- The Foundations' signed block of 2026-09-30, Item 9, cites "The Close, H13": the H-numbers are kept.
- Draft 4 cited interpretation-framework-v4.md, now in archive. The law document points at this document by heading,
  not by draft number, so C72-I item 17's owed pointer is paid.
- 43 of the 126 noted blocks left only for section numbers: 27 headings retyped with the same words, 16 prose
  pointers retyped as names (plan_map.py, counting blocks whose only reason is R2).

**WHAT DEPENDED ON THIS.**
- **Technology.** The model's instructions for the close, held until this draft was current (C140-I item 11; C141-I
  item 3): the three composed invitations and their check, whose source is founder places 7 to 9; the reflection's
  rules (H6 to H8), its writer's closed list with the marks, and the closed-set stand-in (place 10); the press's place
  and its silent failure; the series question's voice, frame and silence; records B8, B12, B14, B15 and B16; the
  close's three reflections counted apart from those made before the night was read; "Add to Journal" from the
  waking-life invitation on.
- **Interpretation.** Lens Practice Draft 11: its end of the Waking Life heading (C148-I); where a dreamer is told
  that the close may use marks that night (C129-I item 3); the readings, the arc, the press and marks, pointed at by
  name. Recurrence & the Series Draft 4: the dreamer's response excluded by name (C132-I item 4); B14 to B16; the
  series slot's constraint 6 and new constraints 10 and 11; its pointers to "Return" and the slot by heading, not
  by section number. The law document's next pass: its holding-register pointer stays good; C147-I's set-asides. The
  Requirements List's Draft 2: B1, B2, C1 to C12 (C6 by A10), W17's heading, W19 retired, W21 and W22 as sentences,
  W24, and the behaviour list. The interpretation framework's next pass: its account of the close's order. The
  Opening: nothing new; *the stood-out answer* and *the dreamer's response* now stand at both ends.
- **Product & Design.** The Places Register: the Waking Life heading over the waking-life invitation (C148-I); the
  close's three composed invitations, each with a founder-written stand-in; the closed-set where-and-when phrases; W19
  gone; W24 "Add to Journal" and its fail condition; the respond-state line saying truly that the close has its own
  three. The look back: the press, the dreamer's response, late tellings and what was written before the night was
  read.
- **Organisation & Strategies.** Nothing.
- **The founder.** Founder copy places 7 to 10, in each language. A10 and P1 to P3 are open to him like the rest.

*Filed with Draft 5: its tools, at interpretation/the-close-draft-5-tools/ (blocks.py, plan_map.py, template.md,
assemble.py, build_note.py, check_blocks.py), so a fresh session can rebuild both files and re-run the block check;
their outputs are check-output.txt and plan-map-output.txt beside them.*

**HEAD OF INTERPRETATION, ON THE WORKER'S THREE POINTS AT DELIVERY** (2026-11-07, open to the founder).
- "Across the three reflections" is read per budget: the close's own, and the unread night's, each of three.
- The look back shows the Waking Life heading with the waking-life answer, as it was shown; nothing more is needed.
- The two response invitations stay two places, as C129-I items 1 and 5 have them; whether the founder wants them as
  one is his, at the copy pass.

**THE FLAGGED OPENING COPIES LEAVE restricted/.** The first run of this filing stopped: Draft 5 shared runs of words with
the two copies of the flagged Opening files that C145-I had placed in restricted/opening-draft-8-flagged-2026-11-07/,
and with nothing else. It shared none with the restricted file the founder material came from. The flagged paragraph
held a few words of founder material and ordinary words stating a rule that Draft 5 also states; anything of founder
material in Draft 5 would have matched the source file too. The copies made the rule's ordinary wording read as
restricted, so every later statement of that rule would have tripped the check. Head of Interpretation's error at
C145-I. **They are moved out of restricted/, unchanged, to a folder beside the repository**
(soul-dreams-flagged-copies/), where the check does not read them; the source file keeps catching the founder material
itself. C145-I's pointer reads accordingly. This filing's check then ran against restricted/ without them, and passed.

*Filed with Draft 5: its tools, at interpretation/the-close-draft-5-tools/, from the-close-draft-5-tools.zip, sha256 cbfd9cbca058c274b9ca5ed8ebb1b465b1c368d9a53a90cda81284984391a85c; blocks.py is identical to The Opening Draft 8's (checked at filing).*

---

## C151-I — Recurrence & the Series, Draft 4, filed; Draft 3 whole to archive; the anchor's side corrected; the rulings it was written to

**Filed 2026-11-07, by this machine.** *Head of Interpretation's method rulings of 2026-11-07, open to the founder.
Written by the Recurrence & the Series Draft 4 worker to Head of Interpretation's brief of 2026-11-07.*

**FILED.** interpretation/recurrence-and-the-series-draft-4.md, sha256
7dec55e9f884a082d45a8b0434240978239ade6f42ae93536ece9189e02d3bcc. Draft 3
(4a273d5c8e6d97d517ee902b1d0e93c0d7197d40272e53d54c467ba55406957c) moves whole to
archive/recurrence-and-the-series-draft-3.md, with archive/recurrence-and-the-series-draft-3-archive-note-2026-11-07.md
beside it, sha256 1782f1fc9f13220159f945ed536956984b3b8c83e36637b98012d7c55f8ef4fe: every Draft 3 block Draft 4 does
not carry, verbatim, each with why it left. Of Draft 3's 252 blocks, 206 are carried verbatim and 46 are in the note;
none is missing, altered or stray (check_blocks.py, run on the three files above; the block definition is The Opening
Draft 8's blocks.py, bbe08104, unchanged, and is stated in the note). Draft 4 was written against change-record.md at
487697bc, whose first 5,985 lines hash to 7d572feb, the record at which C118-I to C149-I were read whole; C150-I was
read at 487697bc. Also read: The Close Draft 5 at fa23d0e8; The Opening Draft 8 at d2613ac8; The Foundations at
cc32ecb4; the counts page at 4fc7b73a; the recurring-image pass document at 0489f0c7; the Requirements List at 22f742c7
(S1, S2, Q5); and, by search for headings, Lens Practice at 6c77a323, the law document at 4f83555e and
interpretation-framework-v5 at 77178b99. The repository listing was at commit f9388fc.

**HEAD OF INTERPRETATION'S RULINGS, 2026-11-07, BY NUMBER** (the pre-work memo's items, then the plan's).
- **A1.** Recurrence judges an image unresolved on the capture layer itself (C90-I item 2).
- **A2.** The one-sided anchor stays, its ground corrected: it is kept so the question runs often enough to be judged in
  Cohort 0, and it tightens to both nights if Cohort 0 shows it firing on ordinary words.
- **A3.** The feeling half stays written and silent; no work now owed will voice it; the journal's search carries its
  value meanwhile. The Foundations §5 is unchanged.
- **A4.** Ownership stays as Draft 3 has it. The Close owns the series slot's constraints: the question's form, its
  frame, and the one silence with all its causes. Draft 4 owns the word: which word, which nights anchor it, who may ask.
- **A5 to A7, A9 to A11, A13, A14.** As the memo proposed: The Close cited by name and stable B-number; the press's
  record excluded as RQ1's consequence, with no entry of its own; C134-I item 6 applied to the search's empty result;
  no position stated for the arc; "the band" named by thing; C147-I applied; Draft 3's two owed counts recorded as paid;
  section numbers and named headings kept.
- **A8.** RQ3 is read under C134-I item 1: nothing in the question changes with how often the word returned or how many
  nights there are.
- **A12.** The one line reads: "A later night reads only the dreamer's own account, as they told it, set it right and
  added to it at the mirror, before the app said anything of its own about it."
- **B1.** Markers (a), (b), (c2) and (d) are applied to the capture layer; (c1) only where the capture layer itself
  names an image as standing out and offers no association for it.
- **B2.** Recurrence matches as search does: the same word, or the same word with a different ending; when in doubt, no
  match. The question carries tonight's spelling.
- **B3.** A night stays open until the first 21:00 after its first recording, by the phone's local time. Flagged to the
  founder.
- **B4.** A dream recorded into a night paused at its unconfirmed mirror joins the telling, and the mirror reads it back
  when the night resumes.
- **B5.** Only a lens whose reading was shown tonight may ask.
- **Plan 1. THE ANCHOR'S SIDE IS TONIGHT'S.** C118-I item 1's reading, "only the earlier night must hold the image
  unresolved", was this department's and is corrected: only tonight's appearance is anchored, and the earlier night's
  may be any use of the word. The reasons: it is the side the counts measured, and tonight's lens asks about an image
  tonight's account leaves unresolved. B1 reaches only tonight's capture layer.
- **Plan 2.** §6.2's ground 4 is reworded to the arc's present position.
- **Plan 4.** Draft 3 goes whole to archive, with the note beside it.
- **Plan 5.** blocks.py at bbe08104 is the filed copy.

**THIS DRAFT'S OWN READING, OPEN TO HEAD OF INTERPRETATION.** "A capital letter does not make a different word": the
counts matched case-folded, and B2 did not say. If struck, §4.1's matching sentence loses that clause.

**FOUND, AND CARRIED IN THE TEXT.**
- **The counts anchored tonight's side; C118-I item 1's reading anchored the earlier night's.** The counts page's
  operation: a night fires "when a word that qualifies on N appears anywhere in the capture layer of an earlier night".
  The Requirements List S1 states the earlier side and cites the counts' figure for it: the figure is the other side's.
  Corrected above; S1 is its owner's.
- C90-I item 2 had never entered this document: Draft 3 is dated the day before it was filed.
- Draft 3's §17 item 3 listed as owed the two counts filed at C92-I.
- Draft 3's §13 item 3 defined the search's empty result against C134-I item 6.
- Draft 3's §4.1 called the feeling half's silence a gap with a known closing condition; after C134-I item 9 nothing owed
  closes it.
- Draft 3's §6.1 and §6.2 ground 4 stated an arc position that C129-I item 2 and C138-I item 3 had changed.
- Draft 3's §14 said "PR4 is new in this draft", true of Draft 3 only.
- **Because C150-I keeps The Close's constraint numbers and B-numbers stable**, RQ7, RQ11, §3.4's list of B-numbers and
  §9 carry verbatim, where the plan had RQ7 and RQ11 retyped.
- **§7.2's first paragraph and §7.3 stay here**, because The Close Draft 5 does not carry them whole. It lacks "It asks
  what that tradition asks of a thing that comes back", "one night's feeling set against another's", "a
  characterisation of the dreamer's material as a whole", and "any statement that something has changed, developed or
  progressed". §7.1 says The Close governs where the two overlap, and each line leaves here once The Close carries it.
- **The Close Draft 5's constraint 3 states who may ask**, which A4 gives this document, and does not carry B5.

**WHAT DEPENDED ON THIS.**
- **Technology.** The AI's instructions for what a later night may read and for the series question's word, held until
  this draft was current (C140-I item 11; C141-I item 3):
  - RQ1's three kinds, and the exclusions by name;
  - the anchor, on tonight's side only, judged on tonight's capture layer by the markers as B1 rules;
  - the broad word rule, and matching by plain forms with tonight's spelling;
  - what one night is, the 21:00 boundary, and an earlier night by first recording, unread nights included;
  - a recording into a night paused at its unconfirmed mirror joining the telling;
  - only a lens whose reading was shown tonight may ask.
- **Interpretation.**
  - The Close's next pass: constraint 3 points here and gains B5; the lines of §7.2 and §7.3 named above, after which
    they leave here.
  - The Requirements List's Draft 2: S1 (three kinds; tonight's side; the figure's side; the word rule; plain forms), S2
    (no fixed length; the frame is The Close's), S3 (B5), S5 and S6 (rows and search), Q2 closed, Q5 (no work owed).
  - The lens register: the pass document's Freudian row stands as history, and its note on feelings has no work owed.
  - The Opening: nothing required. B4 sits with its late telling and may be pointed at by name at its next pass.
- **Product & Design.** The journal list and search as §8 states them (C131-I; C138-I); W25; the behaviour list's items
  4, 5, 9 and 10.
- **Organisation & Strategies.** Nothing.
- **The founder.** B3, the 21:00 boundary.

*Filed with Draft 4: its tools, at interpretation/recurrence-draft-4-tools/ (blocks.py, pin.py, template.md, build.py,
reasons.md, note_intro.md, build_note.py, check_blocks.py, edit.py, outbound.py, inbound.py), so a fresh session can
rebuild both files and re-run the block check; their output is check-output.txt beside them. Every tool runs with
python3 -B.*

**HEAD OF INTERPRETATION, ON THE WORKER'S DELIVERY** (2026-11-07, open to the founder).
- **A capital letter does not make a different word**, for recurrence as for search: matching is case-folded, as the
  counts were.
- **The Close Draft 5's constraint 3 states who may ask**, which this document owns (the answer to A4), and lacks B5
  (only a lens whose reading was shown tonight may ask). For The Close's next pass; until then this document governs who
  may ask.
- **The 21:00 boundary (B3)** is written as Head of Interpretation's reading of C128-I item 6, flagged to the founder:
  a night stays open until the first 21:00 after its first recording, by the phone's local time.
- **The flagged Opening copies are deleted** (the founder, 2026-11-07). C145-I placed them in restricted/; C150-I moved
  them beside the repository. They held nothing the restricted source file does not already hold, so they were deleted
  rather than kept outside the protected set. Those entries' pointers now name copies that no longer exist, by design.

*Filed with Draft 4: its tools, at interpretation/recurrence-draft-4-tools/, from recurrence-draft-4-tools.zip (sha256 858899a7ae19b7b11565ead2bf3915502ba137e8b114408f08e1a7a02e62cbab); blocks.py is identical to The Opening Draft 8's (checked at filing).*

---

## C152-I — Product's message 24: onboarding never signals what not to bring; the not-therapy line alone; the 21:00 boundary confirmed

**Filed 2026-11-07, by this machine. Items 1 and 2 founder-ruled 2026-11-07.** *The rest is Head of Interpretation's, open to the founder. Product & Design, its message 24, from C15-P (commit bfa7f6c).*

**1. W27·15 KEEPS ONLY THE NOT-THERAPY LINE, IN ITS GENTLEST FORM** (founder-ruled). Its words "certain things it's not
meant to hold" leave it, in onboarding and on the privacy page. **Why:** Core Commitments §6 closes, permanently, "an
onboarding that signals what not to bring", and the law document §2 holds that the limit is on pressing, never on
hearing: the app never designs away from a dreamer being fully honest (the founder's ruling of 2026-09-14; C44-I).
While a Help page existed, the line at least pointed somewhere; with none through Cohort 2 (C147-I), it only told a
dreamer to hold back before telling a single dream. Saying the app is not therapy says what the app is, not what to
withhold, and stays (C147-I). Product & Design's question 9 believed the two did not collide; they do, and this
resolves it.

**2. THE 21:00 BOUNDARY IS THE FOUNDER'S RULING** (founder-confirmed). A night stays open until the first 21:00 after its
first recording, by the phone's local time: a dream at 23:00 and one at 07:00 the next morning are one night. C151-I
recorded this as Head of Interpretation's reading of C128-I item 6; it is now the founder's.

**3. MESSAGE 24'S NOTICES ARE RECEIVED.** Every Product document agrees with C147-I through Cohort 2; the Region setting
is removed with Help (founder-ruled); W27·15's fuller form waits until the app is running, which defers C147-I's
privacy-page expansion without contradicting it; the "keeps nothing" exception goes into W27·2 and W27·3 in the
founder's words without naming the material, which meets C146-I item 3, and counsel confirms; Core Commitments gains
its dated block suspending crisis-resource and distress-check lines through Cohort 2, §6.0's rule and §6.2 standing;
Organisation's record is renamed. **The founder's direction on how departments work** (each moves on its own; a filing
checks only that what it read from another department is unchanged, and names anything newer as not yet read) fits this
department's filing: its scripts stop only on changes to its own record.

**WHAT DEPENDED ON THIS.** Product & Design: W27·15 in onboarding and on the privacy page; the Places Register. The tester
disclosure specification's next draft. Recurrence & the Series' next pass (the 21:00 sentence's attribution). Technology:
what one night is, as in Recurrence & the Series Draft 4, now founder-ruled.

---

## C153-I — Product's message 25: crisis material and Help scrapped indefinitely; the exception's fact; the founder's safety copy; the model's instructions reviewed here

**Filed 2026-11-09, by this machine. Items 1, 3 and 4 founder-ruled 2026-11-07.** *Head of Interpretation's readings under them, open to the founder. Product & Design, its message 25, carrying Technology Messages 9 and 10.*

**1. CRISIS MATERIAL, THE DISTRESS CHECK AND THE HELP PAGE ARE SCRAPPED INDEFINITELY** (founder-ruled). Not only through
Cohort 2: no department plans for their return, and only a new founder ruling could change this. C147-I's "through
Cohort 2", "decided after Cohort 2" and "before Cohort 3, the founder decides what support looks like" no longer hold,
and the law document's standing rule on crisis resources (C44-I) and its distress-signal gate (§1; C51-I) are set aside
without a date. **What C147-I keeps stands:** the rules that keep a reading from hurting anyone (the law document §2) and
the not-therapy line; and C152-I item 1: onboarding never signals what not to bring. **Within The Foundations:** §6, as
amended by the 2026-09-29 block, holds the distress apparatus as "DEFERRED, not ruled out", its consequences returning
"when the evidence shows they are needed". This ruling is within it: nothing is ruled out, and the way back is a new
founder ruling. What The Foundations still binds is that evidence: if evidence of need reaches the company, from feedback
or otherwise, it goes to the founder for that ruling. Recorded so that "scrapped" is never read as "ruled out".

**2. THE "KEEPS NOTHING" EXCEPTION, ITS FACT.** Amazon's automated safety systems may flag content, which may then be kept
and reviewed; Amazon does not say that the law requires it (Technology Message 10 item 2). C146-I item 3's suggested words
"except where the law requires it" are withdrawn, since they would state a reason that is not given. W27·2 and W27·3 say
only the fact, in the founder's words, never naming the material, before Cohort 1. Both layers stay true. Counsel
confirms.

**3. THE FOUNDER'S SAFETY COPY** (founder-ruled). Before an update changes how the app stores the journal, the founder may
export his nights as a safety copy, deleted once the update is checked. It is C142-I item 3's export, by the same button
and route, to restricted/, under the same conditions. One night at a time; no import is built, so it keeps his words but
cannot restore his journal. Noted.

**4. THE MODEL'S INSTRUCTIONS ARE REVIEWED HERE** (founder-ruled). Technology writes them one document at a time, The
Opening first; each comes through Product & Design for one review of its faithfulness to the practice, before Cohort 0,
one at a time. Each review is answered in one entry. Where a set of instructions is too large for this head chat to read
whole, it goes to a review worker chat under Head of Interpretation, which reads it against the filed document and the
entries and closes when its review is filed.

**WHAT DEPENDED ON THIS.** The law document's next draft (its standing rule and §1, set aside without a date). Product &
Design: its documents and the Core Commitments block filed at C15-P (item 1); W27·2 and W27·3 (item 2). Technology: the
export (item 3); the instructions and their order (item 4). Counsel, before Cohort 1 (item 2).

---

## C154-I — Product's message 26: the Shared Core pass recorded; the marking line; the night where every tradition declines; what the blind comparison judges; the split found at Start Interpretation

**Filed 2026-11-09, by this machine. Items 1, 2 and 5 founder-ruled.** *Items 3 and 4, and the condition under item 2, are Head of Interpretation's, open to the founder. Product & Design, its message 26, from C16-P.*

**1. THE SHARED CORE PASS, RECORDED HERE AS THE SHARED CORE REQUIRES** (founder-approved 2026-11-09; C16-P item 18;
signed by the founder alone, C130-I item 1). Three changes:
- The line on dreamer-facing words now reads: "Fixed dreamer-facing words are written by a person, in each language
  independently, never machine-translated, never model-drafted. The app's composed lines are practice turns: written each
  night under the practice's rules, each language on its own, and checked before they show. Where a composed line has a
  stand-in, a person writes it." This settles what C128-I item 1 left open.
- New, under how we keep from drifting: "Move fast and stay lean." Each department moves on its own and never waits on
  another; a filing checks only that what it read from others is still there, unchanged, names anything filed since as
  not read, and still stops for a change to text already filed, a dirty tree, or a failing check.
- New, under how chats work: each head sends another department one batch a week; only a question that stops work goes
  sooner, marked BLOCKING; notices need no reply; a head chat grown heavy is replaced by a fresh one that reads the
  repository and its record.
The Shared Core's opening still says it changes "only by both founders"; C130-I item 1 governs that line until the
founder's next pass words it.
The repository's SHARED-CORE.md does not yet carry all three (checked at filing, sha256 dbaeed30): updating it, and each project's instructions, is the founder's pass.

**2. THE MARKING LINE STAYS AS WRITTEN** (founder-ruled 2026-11-07). MP·24 keeps its unit, any sentence, word or
paragraph, and gains no sentence about the close: a dreamer who has not reached the close does not know what it is. C129-I
item 3's "what the dreamer is told about marking says truly that the close may use marks tonight" bends to the line.
**One condition, Head of Interpretation's:** the line never implies that marks are private or go unused; it may say how to
mark and nothing that would be untrue once a marked line returns in the reflection. Brought to it at their next passes:
Lens Practice §9B, §14 item 16 and §15 item 15; The Close Draft 5; the Requirements List's L18.

**3. A NIGHT WHERE EVERY CHOSEN TRADITION DECLINES** is a valid night with no reading (The Foundations §4.5), and the
close comes. The response invitations, then Waking Life, which every read night meets (C129-I item 1), then the
reflections as on any night, then Add to Journal. **What does not come:** the arc, which reads the night's readings
together and has none; the press, which has no reading to press on; and the series question, since only a lens whose
reading was shown may ask, and a tradition asking right after saying it could not read would press where it said it
could not (C151-I's B5). Product & Design draws it.

**4. WHAT COHORT 0'S BLIND COMPARISON OF CLAUDE AND GEMINI JUDGES A READING AGAINST.** Never which resonates more: no
figure of what lands is computed (the Shared Core), and the founder's own response is never proof that a rule works
(C142-I item 3). A reading is judged against the practice's own rules: first the Shared Core's one promise, that every
reading is built from what the dreamer recorded; then each rule a reading must keep: no questions and no hypotheticals
(C134-I item 2); quotations word for word, from the lens file, named (C135-I item A); no verdict, and no reading called
true (C136-I); the tradition's own vocabulary, never a costume (C135-I item C); equal weight; no flattery. Counting each
model's rule failures is allowed and useful; counting what landed never is.

**5. A SPLIT BETWEEN DREAMS IS FOUND WHEN THE DREAMER TAPS START INTERPRETATION** (founder-ruled 2026-11-09), never at
recording: finding it needs the model, and a typed night leaves the phone only to be read (C140-I item 1). This changes
C127-I I1's "a detected split is kept silently at recording". The dreamer meets nothing different: they confirm or undo
the split at the mirror, as before.

**6. RECEIVED, NO ANSWER NEEDED.** Message 26's items 2, 4 to 8, 10, 12 and 13. Item 12: the four sets of the model's
instructions arrive together, and their review goes to a review worker chat under Head of Interpretation (C153-I item 4).
Item 8 matches Recurrence & the Series Draft 4's anchor and its plain forms.

**OWED AT THE NEXT PASSES, LISTED SO NOTHING IS LOST.** The Opening: its two distress items overtaken by C153-I, and the
split found at Start Interpretation (item 5). The Close: the privacy-page expansion overtaken by C152-I, constraint 3 and
B5 (C151-I), the marking line (item 2). Lens Practice: the marking line (item 2). The Requirements List's Draft 2: L18,
X6, and its §1's three differences from The Opening Draft 8, where the Draft governs. The law document's next draft (C153-I
item 1). The tester disclosure specification's next draft.

**WHAT DEPENDED ON THIS.** The Shared Core in all four projects (item 1). Product & Design: MP·24 and its condition, the
all-declines night, the split at Start Interpretation. Technology: the blind comparison's measure; the split; the
all-declines night. The next passes listed above.
