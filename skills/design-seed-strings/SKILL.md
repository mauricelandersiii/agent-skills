---
name: design-seed-strings
description: >-
  Break AI design out of generic purple-gradient slop using the String Seed of Thought
  method (Sakana AI / Anshu Chimala). Use when building or redesigning landing pages,
  apps, or UI where outputs look like every other AI-generated site, when you need
  genuinely varied design directions from the same brief, or when "make it unique" /
  "be creative" prompts keep producing the same layout and palette.
---

# Design Seed Strings

LLMs cannot be random — they predict the most likely next token. Asking for "something totally unique" or "completely random" still produces statistically average design: purple gradients, text-left/graphic-right heroes, Inter, three feature cards.

The problem is that the model can't inherently act randomly. It can only predict the most likely token. If we want variety, we have to bring it from outside the model. One technique for this is **String Seed of Thought**, published by Sakana AI.

Asking for variety without a real seed still fails — the model predicts tokens that _sound_ random (same color scheme, structure, even repeated awkward metaphors like pottery) but aren't.

Source: [Anshu Chimala via Lenny's Newsletter](https://www.lennysnewsletter.com/p/how-to-turn-your-ai-into-a-world) (String Seed of Thought, [Sakana AI](https://sakana.ai/)).

## When to use

- First pass on a landing page, marketing site, or app shell where the brief is open-ended
- Comparing multiple design directions before committing to one
- The user (or you) already tried "make it unique" and got the same AI slop
- Prototyping or variant exploration where divergence matters more than polish — when using `prototype`, **only** if the user included a seed keyword (`make it random`, `be imaginative`, `use seed strings`, `seed mode`)

**Do not use alone when:** the product already has a locked brand system — derive from brand tokens instead. Pair with `world-class-ai-design` for the full Discover → Define → Deliver pipeline after seeding direction.

## Core procedure

Run this sequence every time you apply the method:

### 1. Generate a true random seed

Use the shell — not the model's imagination:

```bash
openssl rand -hex 32
# or
head -c 48 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 48
```

Copy the full string. Do not truncate or "clean up" the seed.

### 2. Derive creative direction from the seed

Read the string for inspiration beyond surface characters:

- **Color:** hex-like substrings, digit sums mapping to hue, vowel/consonant ratios suggesting warm vs cool
- **Layout:** length, symmetry, repeating pairs → asymmetric vs grid vs editorial vs immersive
- **Typography:** character variety → serif vs sans vs mono vs display; tight vs airy tracking
- **Mood:** entropy, clusters of numbers, palindromes, runs of same character → playful, brutalist, organic, technical
- **Motifs:** treat letter groups as shapes, numbers as scale or rhythm

Use judgment. The seed is a **constraint generator**, not a literal color picker. One strong read beats listing every subpattern.

### 3. Build without exposing the seed

Implement the design from the derived direction. The seed must **never** appear in the UI, copy, or comments — it is inspiration only.

### 4. Screenshot and sanity-check

Before calling the direction done, capture the result and ask:

- Would this be mistaken for a default v0 / Lovable / "AI SaaS" template?
- Is the palette, type, and layout clearly different from the last seed run?
- Does it have a named aesthetic (e.g. "brutalist terminal", "warm editorial") rather than "generic startup"?

If it still looks like slop, **generate a new seed** and rerun — do not iterate the same seed into conformity.

## Prompt template

Give the implementing agent this structure (adapt the product name):

```
I want you to build me a landing page for my productivity app.

Follow this procedure:

1. Generate a long, random alphanumeric string using a shell script.

2. Define the creative direction (color scheme, layout, typography, etc.) based on the string. Look beyond the surface for subpatterns, special numbers, anything that inspires you.

3. Use your judgment to bring this direction to life and make it look great.

4. Don't reveal the string in the design. It's only for your inspiration.
```

Successful runs produce one-of-a-kind results — no two runs should look the same. Default prompts without seeds converge on purplish gradients, text left, graphic right, identical structure.

## What "good" looks like

| Failure (no seed / fake random) | Success (real seed)                              |
| ------------------------------- | ------------------------------------------------ |
| Purple-blue gradient hero       | Distinct palette tied to a named mood            |
| Text left, illustration right   | Layout that fits the aesthetic, not the template |
| Inter / system-ui only          | Intentional type pairing                         |
| Three rounded feature cards     | Structure that serves the concept                |
| Same result on every rerun      | Different identity each new seed                 |

## Anti-patterns

- **"Make every design decision at random"** — the model fakes randomness and still averages out.
- **Picking the seed yourself** — `abc123` or a "creative" hand-picked string removes the point.
- **Reusing one successful seed** — seeds are for exploration; brand work needs a chosen direction, not a lucky string.
- **Stopping at seed-only** — seeds fix variety in Discover; polish still needs `design-critic`, `design-media-gen`, and Deliver (`world-class-ai-design`).

## Combining with ambitious prompts

Seed strings work best **with** a strong product brief. Optionally add a wild constraint on top of the seed:

- "…with a bold pixel-art theme where each section feels like a game still"
- "…as an isometric living 3D city where features are neighborhoods"
- "…radically asymmetric layout, dissonant colors, uncomfortable negative space — break rules but make it work"

The seed supplies variety; the ambition supplies spine. If both are missing, expect mediocrity.

## Quick reference

```text
Shell random string → derive direction → build → hide seed → screenshot check
         ↑
    non-negotiable; model cannot skip this step
```
