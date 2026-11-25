# The Design System

*The values the founder set in Framer, named by role, so Technology can build from them.*

**Product & Design**

*No matter where you are on your journey, the steps you take are equally important.*

**What kind of document this is.** A Playbook: current method, meant to change. It is replaced when the values change
in Framer, and the old text is archived verbatim. Whether it is filed is stated in product/product-change-record.md,
never here. Kit item 7. Pillars: visual design, UI design, systems design, accessibility.

**Whose it is.** The founder's. He set every value here in Framer [RELAYED, Head of Product & Design, its messages 1
and 2 to the Design Update chat, and its message 3 to it, carried at C11-P; Product messages 17 to 19 and Technology
Message 22 item 3, carried at C17-P; the founder's rulings of 2026-11-20 and 2026-11-21, Technology Message 24 and
Technology's Build worker, its Message 30, carried at C18-P]. Framer holds design in progress; this document records the values when they are
filed. Where Framer and this document differ, Framer is the work in progress and this is the record until the next
pass.

**What it does not do.** It draws no screen and writes no dreamer-facing line. Where a screen uses a value is
product/main-path.md's; the rules every value obeys are How the AI Appears' (product/how-the-ai-appears.md, §2 to §9).
A value not given is marked [to set in Framer], never guessed.

**Roles.** Every value is named by the role it plays, never by where it was first used. Framer's variables carry these
names, and they become Technology's design tokens.

**Units.** Sizes are in px, as Framer gives them. iOS points and Framer px are the same unit at 1x.

---

## 1. Type

The phone's own text-size setting is supported: every size below grows and shrinks with it. Line height is a multiple
of the size; letter spacing is in em.

| Role | Face | Weight | Size | Line | Letter | Used for |
|---|---|---|---|---|---|---|
| type.h1 | Tangerine | Regular | 77px | 1.2 | 0 | The wordmark, "SoulDreams", in onboarding only |
| type.h2 | Sorts Mill Goudy | Regular | 33px | 1.2 | −0.02em | Page titles; a night's date in its header |
| type.h3 | Sorts Mill Goudy | Regular | 24px | 1.2 | −0.01em | None: a row's date is type.row.date (C18-P) |
| type.h4 | Inter | Semibold | 24px | 1.4 | −0.02em | The month divider |
| type.h5 | Sorts Mill Goudy | Regular | 20px | 1.2 | −0.01em | None: naming a night is removed (C18-P) |
| type.h6 | Inter | Semibold | 18px | 1.4 | −0.02em | None: it named a Help resource, and there is no Help page (C147-I; C153-I) |
| type.voice.app | Bellefair | Regular | 22px | 1.5 | −0.04em | The app's voice: the app's lines; onboarding's text; the mirror until confirmed |
| type.voice.dreamer | Inter | Regular | 16px | 1.5 | 0.02em | The dreamer's voice: the dreamer's words |
| type.voice.readings | Sorts Mill Goudy | Regular | 18px | 1.5 | −0.02em | The traditions' voice: the readings, the arc, the series question |
| type.row.date | Inter | Semibold | 20px | [to set in Framer] | [to set in Framer] | A journal row's date, white, over the night's image |
| type.button | Inter | Regular | 14px | 1.4 | −0.02em | Buttons, placeholders, instructions, section labels, the line above the input field, the date under a name, a row's summary |
| type.button.small | Inter | Regular | 12px | 1.4 | −0.01em | Tradition labels, dream tags |

**The three voices** (founder-ruled 2026-11-20 [RELAYED, Head of Product & Design]; C18-P): the app's voice Bellefair, the dreamer's
voice Inter, the traditions' voice Sorts Mill Goudy. They replace Sorts Mill Goudy, Nunito and Habibi. The dreamer's
voice and a row's date are Inter where they were Inter Display, with the filed sizes, letter-spacing and line-height
(founder-ruled, D118 [RELAYED, Head of Product & Design]; C19-P).

**The italic.** Used only for the dreamer's own words quoted inside a reading or a reflection (How the AI Appears
§2.3). Inside a reading it is Sorts Mill Goudy's true italic (founder-ruled 2026-11-20). Inside a reflection it is the
italic of the voice the words sit in; where that face has no true italic, the dreamer voice's italic, Inter
Italic, is used instead. [ASSUMED] Bellefair has no true italic; the founder checks it in Framer. A slanted regular face
is never used.

---

## 2. Colour: the light theme

| Role | Value |
|---|---|
| color.page | #F5F5EC |
| color.surface (boxes, bubbles, journal rows) | #FFFFFF |
| color.surface.border | 1px #CCCCCC |
| color.field (search, type, feedback) | #FFFFFF |
| color.field.border | 1px #8A8A8A |
| color.text | #333333 |
| color.text.placeholder | #767676, only ever on white |
| color.text.summary (a row's summary) | #767676, only ever on white |
| color.button | #FFFFFF, border 1px #CCCCCC, text #333333 |
| color.button.filled (Submit) | #333333, text #FFFFFF |
| color.record (the record button) | gradient #8F3D24 → #6B2B18, text #FFFFFF [owed: unused since the round button is gone, C18-P] |
| color.label.tradition | gradient #8F3D24 → #6B2B18, text #FFFFFF |
| color.label.section | gradient #33691C → #1B3B0E, text #FFFFFF |
| color.tag.dream | gradient #425DAD → #253873, text #FFFFFF |
| color.destructive (Delete journal) | gradient #8F3D24 → #6B2B18, text #FFFFFF |
| color.line.state (the line above the input field) | #333333 |
| color.lifecontext.box (a kept sentence's box) | #FFFFFF, pure white |
| color.lifecontext.date (the date under a kept sentence) | #767676, on the white box only |
| color.lifecontext.delete (the delete icon) | #8F3D24 |
| color.label.questions (the jump button "Questions") | brown [to try: read from the founder's screens] |

## 3. Colour: the dark theme

| Role | Value |
|---|---|
| color.page | #0F0D29 |
| color.surface (bubbles, journal rows) | gradient #3D376E → #26214F, border #26214F |
| color.text | #F5F5EC, and on the bubble gradient everywhere, a row's summary included |
| color.field (search, type, feedback) | #CFCDC1, no border |
| color.field.text | #333333 |
| color.text.placeholder (in a field) | #555555 |
| color.button | gradient #F5F5EC → #ABAB93, border #CCCCCC, text #333333 |
| color.button.filled (Submit) | as color.button: gradient #F5F5EC → #ABAB93, text #333333 |
| color.record | as in the light theme |
| color.label.tradition | as in the light theme |
| color.label.section | as in the light theme |
| color.tag.dream | gradient #F5F5EC → #ABAB93, text #333333 |
| color.destructive | as in the light theme |
| color.line.state | #F5F5EC |
| color.lifecontext.box | as color.surface |
| color.lifecontext.text | #F5F5EC |
| color.lifecontext.date | #ABAB93 |
| color.lifecontext.delete | #8F3D24, as in the light theme (founder-ruled 2026-11-21; C19-P): below 3:1 here, a departure from the Principles' floor |
| color.label.questions | [to try: read from the founder's screens] |

**One colour shared by three roles.** The record button, the tradition labels and the destructive control share the
terracotta gradient. Each is told apart by its shape, its place and its word, never by colour alone (How the AI
Appears §2.8).

---

## 4. Contrast

Every text pair in §2 and §3 meets 4.5:1 at both ends of each gradient [RELAYED, Head of Product & Design, its
computation of 2026-10-29], on one condition: #767676 passes on white (4.54:1) and fails on the light page (4.14:1), so
it is used only on white [READ, the Design Update chat's computation, 2026-10-29]. The label and tag text, white, passes
on each end of each light-theme gradient: terracotta 7.34:1 and 10.59:1, green 6.61:1 and 12.51:1, blue 6.17:1 and
11.10:1. The dark theme's Submit, #333333, passes on each end of its gradient: 11.52:1 and 5.40:1 [READ, the Copy Pass
Filing chat's computation, 2026-11-05, WCAG 2.2 relative luminance].

A light-theme field's edge, #8A8A8A, meets 3:1 for the boundary of a control: 3.45:1 on the white field and 3.15:1 on
the page [RELAYED, Head of Product & Design, 2026-10-29; READ, the same computation]. WCAG 2.2 AA asks this of an input's
boundary (SC 1.4.11) [RELAYED, not read this session], and the Principles set AA as the floor (§3). Boxes and bubbles
keep #CCCCCC: they are not controls. Dark-theme fields need no border: the field itself stands at 11.85:1 against the
page [READ, the same computation].

**Life Context's page** [READ, the C18-P Filing chat's computation, 2026-11-21, WCAG 2.2 relative luminance]. Light: the
date, #767676 on the pure white box, 4.54:1; the delete icon, #8F3D24 on white, 7.34:1, where an icon needs 3:1
(SC 1.4.11). Dark: the date, #ABAB93, already the dark button's lighter end, on each end of the surface gradient,
4.56:1 and 6.35:1. The delete icon #8F3D24 fails on the dark surface, 1.45:1 and 2.02:1 [READ, recomputed by the C19-P Filing
chat]. It keeps #8F3D24 in both themes (founder-ruled 2026-11-21 [RELAYED, Head of Product & Design]; C19-P): a founder-ruled departure
from the AA floor the Principles set (§3), for the founder to judge on his phone in Cohort 0. The Principles change
only if the choice stands at Cohort 1. C18-P's proposed #D0775A, 3.28:1 and 4.58:1, is not used.

**Words over a picture** (founder-ruled 2026-11-21 [RELAYED, Head of Product & Design]): white, with a soft dark shadow behind them, so they
read on any painting. No ratio can be stated for a picture that changes; the shadow's size and strength are [to set in
Framer], judged on the palest painting in the set.

---

## 5. Spacing, radius and controls

| Role | Value |
|---|---|
| radius | 30, in both themes |
| space.page.side | 30px outer margins, left and right only |
| space.journal.row | 12px between journal rows |
| space.onboarding.box | 50px above and below, 30px left and right |
| space.mirror.box | 30px above and below, 20px left and right |
| size.field.search | 50px tall |
| space.bubble.dreamer | 30px from the left edge, 10px from the right |
| space.bubble.tradition | 10px from the left edge, 30px from the right |
| space.turn.app | 20px more space after the last reply, before each new turn of the app's |
| space.label.readings | 20px after "The Readings" label, before the image line |
| space.night.header | 20px above the header, 10px below, in both themes |
| space.journal.end | Space below the last row, so the list scrolls clear of the record button: [to set in Framer] |
| Everything else | [to set in Framer] |

| Control | Shape and size |
|---|---|
| control.record | A 120px circle, MP·11 in white inside it [owed: unused since the round button is gone, C18-P] |
| control.newdream | New Dream (MP·11), carrying a night-sky image the founder supplies; its shape [to set in Framer] |
| control.back | A thin chevron in a round bordered button of about 41px |
| control.row.chevron | A chevron at each journal row's trailing edge [owed: unused with the new rows, C18-P] |
| control.field.type | The typing field: a pill with the microphone inside it, growing as the dreamer types, capped at about 0.7 of the space above the buttons; never focused by itself |
| divider.month | The month divider, centred |
| journal.row | A rounded row carrying only the date (type.row.date), white, over the night's image; an unread night's row shows the painted gradient |
| night.header | The night's image and its date; jump buttons (MP·77) under it, above "Dreams", drawn as section labels |
| lifecontext.sentence | Each kept sentence in quotation marks in its box, its date beneath in small grey text |

---

## 6. The settings, where they are visual

- **Night/Day mode.** Automatic, or Manual: Day or Night. Automatic turns to the dark theme at 21:00 and the light
  theme at 08:00, by the phone's local time. If the change happens while the app is open, the colours fade over five
  seconds, ease-in-out; with Word Animation off or the phone's "Reduce motion" on, they change at once. The quick toggle at the top
  centre of the Settings page switches the theme; tapped while Automatic is set, it switches the mode to Manual.
- **Onboarding** is always in the light theme.
- **Above the greeting** (founder-ruled 2026-11-21, Technology's Build worker, its Message 30 [RELAYED, Head of Product & Design]): a sun by day
  and a moon by night, switching with Night/Day mode at 21:00 and 08:00; images the founder supplies.
- **The night's image.** Every night has one (C159-I item 4). The calm and Random paintings are a curated set of about
  60, made by the founder and shipped inside the app; nothing is sent for them. Only Personal paintings go out, to
  Google Vertex AI in an EU region (Technology Message 24, founder-ruled 2026-11-21 [RELAYED, Head of Product & Design]). A removed image
  becomes a gradient (C159-I item 4).
- **The painted gradient** (founder-ruled 2026-11-21 [RELAYED, Head of Product & Design]): a small set of gradient paintings the founder makes in
  night-sky colours, with the curated paintings; a plain stand-in until then.
- **Word Animation.** On or Off; On by default (founder-ruled 2026-11-20 [RELAYED, Head of Product & Design]; C18-P, replacing C17-P's
  Off). Word by word is only for the app's responses to the dreamer: the questions, the bridge, the reflections. The
  app's own lines appear whole. Off stops word by word and the waiting shimmer (How the AI Appears §4 and §5). The
  phone's "Reduce motion" does the same. When on, about one word every 60 ms.
- **The shimmer.** A highlight sweeping across a waiting label's text for five seconds at most; then the label stands
  still (How the AI Appears §5). Its speed, direction and curve: [to set in Framer].

---

## 7. Still to set in Framer

The space below the journal's last row; the shimmer's speed, direction and curve; every motion curve but the theme's
fade; and
any value not named above. Each is added here at the next pass.

---

## 8. To try on the founder's phone

Values the founder judges on his own phone before they are set (Technology's Build worker, its Message 30 [RELAYED, Head of Product & Design]):
the journal rows' height, edge and width; the night's header, about 240px tall, scrolling away as the dreamer reads;
the jump buttons' colours, read from the founder's screens: Dreams green as color.label.section, Questions brown (a new
role, color.label.questions), Readings terracotta, Reflection blue, in both themes.

*No matter where you are on your journey, the steps you take are equally important.*
