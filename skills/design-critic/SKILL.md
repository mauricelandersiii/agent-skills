---
name: design-critic
description: >-
  Improve AI-generated UI with a screenshot-only design critic subagent loop (Anshu Chimala).
  Use when a design feels generic or cookie-cutter after a first build, when polishing before
  ship, or when the user asks for a design critique, quality bar, or iterate until 9/10. Pair
  with world-class-ai-design for full pipeline context; runnable alone on any existing UI.
---

# Design Critic Loop

Coding agents cannot objectively review their own work — they defend past decisions, code, and rationale. A **design critic** in a **fresh context** that sees **only screenshots** breaks that bias.

Source: [Anshu Chimala via Lenny's Newsletter](https://www.lennysnewsletter.com/p/how-to-turn-your-ai-into-a-world), Technique 3.

## When to use

- First AI build still feels generic (nav + left copy + CTA + right graphic skeleton)
- Before ship on any marketing page, app screen, or component
- After `design-seed-strings` or `prototype` — seeds explore direction; critic deepens identity
- User asks to "critique this design", "make it less AI", or "polish until it's great"

**Do not use when:** no UI exists yet — build a direction first (`design-seed-strings`, ambitious brief, or `prototype`).

## Cost pattern

Use a **strong model for the critic**, a **capable but faster model for the builder**. The critic only runs on executive screenshot reviews; in Anshu's runs it accounted for **under 10% of output tokens** vs having the strong model rebuild the page directly (roughly half the cost and time).

| Role    | Model tier         | Why                                                                   |
| ------- | ------------------ | --------------------------------------------------------------------- |
| Critic  | Strong / expensive | Taste, composition, AI-tell detection                                 |
| Builder | Fast / capable     | Implements feedback; must execute direction well — don't go too small |

## Loop (each iteration)

1. **Screenshot** the current design (browser or Playwright).
2. **Spawn critic** in a **fresh context** with **only the screenshot** — no code, implementation details, or earlier critiques.
3. Critic evaluates and returns feedback (see **Critic prompt** below).
4. **Builder implements** feedback.
5. Repeat until **builder-side** stopping rule is met.

## Stopping rule

**Builder only (never put this in the critic prompt):** your work is complete when the critic independently scores **≥ 9/10**. Keep the critic's scoring objective — do not tell it "pass at 9."

**Avoid infinite loops:** start with **1–2 iterations**, check convergence, then extend. Without a cap, the critic may never be satisfied and the agent burns tokens.

Use the **same critic prompt every iteration** for consistent scoring.

## Builder prompt template

Adapt model name as needed:

```
I want you to improve this design. To figure out what to focus on, use a [strong model] subagent as a design critic.

Follow this procedure at each iteration:

1. Capture a screenshot of the current design
2. Invoke the critic in a fresh context, with just the screenshot — not the code, implementation details, or earlier iterations/critiques
3. Ask it to evaluate the aesthetic the design is going for, imagine how a top design studio would execute this aesthetic, then outline the biggest gaps
4. Lastly, it should provide a score out of 10 indicating how close the current design is to that studio-level quality bar

Your work is only complete when the critic independently deems it 9/10 or higher. Do not put that criterion in the critic prompt; keep it objective in its scoring. Use the same critic prompt each time.
```

## Critic prompt (give this to the subagent)

```
You are a design critic. You only see a screenshot — not code, effort, or prior iterations.

1. Name the aesthetic this design is attempting.
2. Imagine how a top design studio would execute that aesthetic.
3. Outline the biggest gaps between this design and that bar.
4. Score the design out of 10 for studio-level polish.

Guidance:
- Think high-level about overall structure and composition AND fine details.
- Watch out for patterns that feel overdone, excessive, or obviously AI-generated — penalize them.
- Give tight, specific feedback, not vague prose.
- Be bold and opinionated; do not recommend what's merely safe or easy.
```

## Critic criteria quality

| Quality   | Example                                                                                                                                                                   |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Bad**   | "Judge if our design looks beautiful and not AI-generated." Too subjective; scores vary wildly.                                                                           |
| **OK**    | "Review the aesthetic we're going for, visualize how a top design studio would execute it, then judge our design's quality against that bar." Mushy but consistent frame. |
| **Great** | "Here are 5 designs: 4 professional examples and 1 screenshot of our product. Rank them by polish and taste level." Concrete, visual baseline.                            |

## Reference images

Provide **moodboard or comparable screenshots** as a **quality floor**, not a copy target. Instruct the critic: treat references as baseline polish level — do not recommend copying layouts outright. AI-generated concept art works as reference too.

## What good output looks like

After the loop, the design should have **its own identity** while keeping the original high-level aesthetic — not the same cookie-cutter layout (text left, CTA below, nav top, graphic right) repeated with different colors.

## Repo integration

- Screenshots: Playwright per `video-testing.md` / AGENTS.md
- After critic loop passes: run Deliver techniques in `world-class-ai-design` (subtract, tells pass, hand-written copy)
- Motion craft: `emil-design-eng`, `apple-design` after composition is settled

## Sources

- [How to turn your AI into a world-class designer](https://www.lennysnewsletter.com/p/how-to-turn-your-ai-into-a-world) — Technique 3
