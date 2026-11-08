---
name: world-class-ai-design
description: >-
  Router for distinctive AI UI design (Anshu Chimala / Lenny's Newsletter): Discover → Define →
  Deliver. Use when building landing pages or app UI with coding agents and output looks like
  generic AI slop. Loads child skills (design-seed-strings, prototype, design-critic,
  design-media-gen) by phase — not the full playbook inline.
---

# World-Class AI Design

Most people see ~1% of AI's creative potential. LLMs are next-token predictors — at every design decision they pick the statistically safest token. The result is design-by-committee: repetitive, bland, emotionally flat.

Great design starts with **feeling**, bends rules, and makes memorable choices. With the right agent workflow you can reach the other 99%.

This skill is the **index** for Anshu Chimala's process ([Lenny's Newsletter](https://www.lennysnewsletter.com/p/how-to-turn-your-ai-into-a-world)), loosely mapped to Double Diamond:

| Phase        | Goal                                                          |
| ------------ | ------------------------------------------------------------- |
| **Discover** | Escape the AI SaaS basin — explore bold, varied directions    |
| **Define**   | Give the design individual personality beyond stale skeletons |
| **Deliver**  | Polish: subtract, remove tells, own the copy                  |

**Child skills hold the procedures.** This file routes when to load each one.

## Operating principles

1. **Go broad before deep**
2. **Import randomness and taste from outside the model** — shells, screenshots, references, your edits
3. **Separate builder from critic** — see `design-critic`
4. **Add richness with media, not more divs** — see `design-media-gen`
5. **Finish by subtracting** — AI over-builds; premium design is often what you remove
6. **Own the words** — rewrite headlines and CTAs by hand last

## Skill map

| Technique                  | Phase    | Skill                                                        |
| -------------------------- | -------- | ------------------------------------------------------------ |
| 1. Seed strings            | Discover | `design-seed-strings` (opt-in via `prototype` seed keywords) |
| 2. Ambitious prompts       | Discover | _below — stays here_                                         |
| 3. Design critic loop      | Define   | `design-critic`                                              |
| 4. Image generation        | Define   | `design-media-gen` § Part A                                  |
| 5. Video generation        | Define   | `design-media-gen` § Part B                                  |
| 6–8. Subtract, tells, copy | Deliver  | _below — stays here_                                         |

**Also:** `prototype` for side-by-side variant exploration (seed mode opt-in). **After direction is set:** `emil-design-eng`, `apple-design`, `animation-vocabulary` for motion craft.

## Which phases to run

| Situation                             | Run                                                         |
| ------------------------------------- | ----------------------------------------------------------- |
| Greenfield landing page / app shell   | Discover → Define → Deliver (full)                          |
| Compare directions before committing  | `prototype` (+ seed keywords if you want random divergence) |
| Have a first build that feels generic | `design-critic` → Deliver                                   |
| Layout good, visuals flat             | `design-media-gen` → `design-critic` → Deliver              |
| Polish existing screen before ship    | Deliver only (+ optional `design-critic`)                   |

---

## Discover (Technique 2 — ambitious prompts)

Seeds inject variety; **ambition** supplies spine. Weak: "modern, clean, professional." Strong: concrete worlds the model can execute:

- Pixel-art landing where each section feels like a game still but functions as marketing
- Isometric living 3D city where features map to neighborhoods or buildings
- Radically asymmetric layout, dissonant color and type, uncomfortable negative space — break rules, still cohesive

**Finding ideas without recycling AI slop** (your taste is the differentiator):

1. **Brainstorm wide, shallow** — many short high-level concepts, not deep specs  
   _"I want a bold, unique design language for my product. List as many ideas as you can, short high-level descriptions. Go broad, not deep."_
2. **React with taste** — visualize favorites; note what feels tacky, what needs texture  
   _"Gray gradients would look boring. Need more texture. Maybe incorporate color while retaining the control-panel feel? Sharpen based on my tastes."_
3. **Iterate** until one direction is crisp
4. **Compress** — _"Write a concise prompt an AI agent could use to build an initial POC."_

Pasting AI ideas into AI without steering produces average output anyone could get. **Push scary ideas** — if you think "there's no way this will work," try it. Save failed prompts and retry on newer models later.

Technique 1 (seed strings): **`design-seed-strings`**. Via **`prototype`**, only when user includes a seed keyword (`make it random`, `be imaginative`, `use seed strings`, `seed mode`).

---

## Define

Load **`design-critic`** after a promising first build. Even seed-based designs often keep stale skeletons (nav top, text left + CTA, graphic right) — the critic loop breaks that.

Load **`design-media-gen`** when layout passes critic but visuals are still code-only (gradients, shapes, patterns).

Typical sequence:

```text
Build → design-critic (≥ 9/10) → design-media-gen → design-critic (if layout shifted) → Deliver
```

---

## Deliver (Techniques 6–8)

Unique visuals still fail if cluttered or full of tells. **Your judgment** decides what stays.

### Technique 6: Cut what doesn't add value

AI adds; it rarely removes. Restraint reads premium. Audit and remove:

- Decorative glows, gradients, random color highlights on text
- Redundant labels when images already communicate
- Custom controls worse than platform-native components
- Empty space that doesn't serve rhythm

**Calorie app example (from article):** despite asking for "clean, minimalist," the first pass had pink glows, random text colors, extra labels, and custom iOS controls that looked worse than native. Dial-back direction:

- Image-centric grid
- No gradients, glows, or unnecessary containers
- Truly minimal, Apple-native feel
- Smaller, tighter type; visuals carry the story

Ask: **what must be here?** Models won't aggressively delete code on their own — deleting feels risky to a predictor. **Direct subtraction.**

### Technique 7: Remove AI tells

Dedicated pass after layout works. Compare screenshots to 2–3 products you admire; list anything that could live in a "1000 AI startups" template; remove or replace (prefer remove). Re-run **`design-critic`** with explicit instruction to penalize remaining tells.

Common tells: purple-blue hero gradients, Inter/Geist-only type, centered hero + three equal cards, `rounded-2xl shadow-md` grids, thin generic icons everywhere, fade-up on every scroll section, sparkle emoji for "AI" features, vague copy ("Unlock your potential"), `gray-50` + floating gradient blobs.

### Technique 8: Rewrite copy by hand

Headlines, CTAs, feature names, and microcopy are the highest-entropy layer — models regress to "Streamline your workflow" instantly.

- AI scaffolds layout; **you** rewrite hero, subhead, buttons, section titles, key proof points
- One human sentence beats three AI paragraphs
- Read aloud — if you wouldn't say it to a colleague, rewrite

Copy is where taste is most visible. Unchanged AI body text undoes distinctive visuals.

---

## End-to-end workflow

```text
DISCOVER
  ├─ design-seed-strings OR prototype (± seed keywords)
  └─ ambitious brief (+ idea-refinement chat above)

DEFINE
  ├─ design-critic until ≥ 9/10
  └─ design-media-gen (image → video as needed)

DELIVER
  ├─ Subtract non-value
  ├─ Tells pass
  └─ Hand-write primary copy

SHIP
  └─ Platform-native components where they win
      Verify in browser; frame-by-frame for motion (Playwright)
```

## Repo notes

- Screenshots / demos: `playbooks/guides/video-testing.md`, AGENTS.md
- Agent API keys: gitignored `.env.agents`; never ship in product
- Techniques 7–8 body text in the newsletter is paywalled; Deliver content above follows article framing plus Lenny's published technique list

## Sources

- [How to turn your AI into a world-class designer](https://www.lennysnewsletter.com/p/how-to-turn-your-ai-into-a-world)
- [String Seed of Thought](https://sakana.ai/)
