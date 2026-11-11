# The Design System

*The values the founder set in Framer, named by role, so Technology can build from them.*

**Product & Design**

*No matter where you are on your journey, the steps you take are equally important.*

**What kind of document this is.** A Playbook: current method, meant to change. It is replaced when the values change
in Framer, and the old text is archived verbatim. Whether it is filed is stated in product/product-change-record.md,
never here. Kit item 7. Pillars: visual design, UI design, systems design, accessibility.

**Whose it is.** The founder's. He set every value here in Framer [RELAYED, Head of Product & Design, its messages 1
and 2 to the Design Update chat, and its message 3 to it, carried at C11-P]. Framer holds design in progress; this document records the values when they are
filed. Where Framer and this document differ, Framer is the work in progress and this is the record until the next
pass.

**What it does not do.** It draws no screen and writes no dreamer-facing line. Where a screen uses a value is
product/main-path.md's; the rules every value obeys are How the AI Appears' (product/how-the-ai-appears.md, §2 to §9).
A value not given is marked [to set in Framer], never guessed.

**Roles.** Every value is named by the role it plays, never by where it was first used. Framer's variables carry these
names, and they become Technology's design tokens.

---

## 1. Type

The phone's own text-size setting is supported: every size below grows and shrinks with it. Line height is a multiple
of the size; letter spacing is in em.

| Role | Face | Weight | Size | Line | Letter | Used for |
|---|---|---|---|---|---|---|
| type.h1 | Tangerine | Regular | 77px | 1.2 | 0 | The wordmark, "SoulDreams", in onboarding only |
| type.h2 | Sorts Mill Goudy | Regular | 33px | 1.2 | −0.02em | Page titles; a night's date or name |
| type.h3 | Sorts Mill Goudy | Regular | 24px | 1.2 | −0.01em | An unnamed row's date |
| type.h4 | Inter | Semibold | 24px | 1.4 | −0.02em | The month divider |
| type.h5 | Sorts Mill Goudy | Regular | 20px | 1.2 | −0.01em | A named row's name |
| type.h6 | Inter | Semibold | 18px | 1.4 | −0.02em | None: it named a Help resource, and there is no Help page (C147-I; C153-I) |
| type.voice.app | Sorts Mill Goudy | Regular | 18px | 1.5 | −0.02em | The app's lines; onboarding's text; the mirror until confirmed |
| type.voice.dreamer | Nunito | Regular | 16px | 1.5 | 0 | The dreamer's words |
| type.voice.readings | Habibi | Regular | 15px | 1.5 | 0 | The readings, the arc, the series question |
| type.button | Inter | Regular | 14px | 1.4 | −0.02em | Buttons, placeholders, instructions, section labels, the line above the input field, the date under a name |
| type.button.small | Inter | Regular | 12px | 1.4 | −0.01em | Tradition labels, dream tags |

**The italic.** Used only for the dreamer's own words quoted inside a reading or a reflection (How the AI Appears
§2.3). It is the italic of the voice the words sit in. Where that face has no true italic, the dreamer voice's italic,
Nunito Italic, is used instead. [ASSUMED] Habibi has no true italic; the founder checks it in Framer. A slanted
regular face is never used.

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
| color.record (the record button) | gradient #8F3D24 → #6B2B18, text #FFFFFF |
| color.label.tradition | gradient #8F3D24 → #6B2B18, text #FFFFFF |
| color.label.section | gradient #33691C → #1B3B0E, text #FFFFFF |
| color.tag.dream | gradient #425DAD → #253873, text #FFFFFF |
| color.destructive (Delete journal) | gradient #8F3D24 → #6B2B18, text #FFFFFF |
| color.line.state (the line above the input field) | #333333 |

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

---

## 5. Spacing and radius

| Role | Value |
|---|---|
| radius | 30, in both themes |
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

---

## 6. The settings, where they are visual

- **Night/Day mode.** Automatic, or Manual: Day or Night. Automatic turns to the dark theme at 21:00 and the light
  theme at 08:00, by the phone's local time. If the change happens while the app is open, the colours fade over five
  seconds; with Word Animation off or the phone's "Reduce motion" on, they change at once. The quick toggle at the top
  centre of the Settings page switches the theme; tapped while Automatic is set, it switches the mode to Manual.
- **Onboarding** is always in the light theme.
- **Word Animation.** On or Off. Off stops the app's own words appearing word by word, and the waiting shimmer (How the
  AI Appears §4 and §5). The phone's "Reduce motion" does the same.
- **The shimmer.** A highlight sweeping across a waiting label's text for five seconds at most; then the label stands
  still (How the AI Appears §5). Its speed, direction and curve: [to set in Framer].

---

## 7. Still to set in Framer

The space below the journal's last row; the shimmer's speed, direction and curve; every motion curve; and
any value not named above. Each is added here at the next pass.

*No matter where you are on your journey, the steps you take are equally important.*
