---
name: design-media-gen
description: >-
  Enrich AI-built UI with image and video generation instead of CSS gradients and shapes
  (Anshu Chimala). Use when a design looks plain or code-only, for hero loops, glass/refraction
  effects, chroma-keyed animations, or scroll-scrubbed state transitions via fal.ai or built-in
  image/video tools. Includes API key hygiene for agent-local keys.
---

# Design Media Generation

Coding agents default to **gradients, shapes, and basic patterns** — strong AI tells. They **underutilize image tools** even when available. Explicitly instruct image and video generation to add personality that code alone cannot match.

Source: [Anshu Chimala via Lenny's Newsletter](https://www.lennysnewsletter.com/p/how-to-turn-your-ai-into-a-world), Techniques 4 and 5.

## When to use

- Design feels plain after layout is set — critic loop may pass but visuals lack depth
- Hero needs a focal asset beyond CSS
- Product storytelling needs **looping motion** or **scroll-scrubbed transitions**
- User asks for generated imagery, video backgrounds, or "make it less code-looking"

**Typical order:** build layout → `design-critic` loop → **this skill** → Deliver polish (`world-class-ai-design`).

---

## Part A: Image generation

### Why

Images and effects (especially combined with shaders or 3D) demonstrate more than surface-level effort and read less obviously AI-generated than gradient heroes.

### Builder prompt template

```
The design is pretty plain. Add more personality using image generation. Consider shaders or 3D effects in combination with images to create more interesting visuals.

For image generation, use [provider — see wiring table]. Verify that your work looks right frame-by-frame in the browser.
```

### Wiring by environment

| Setup                                             | Approach                                                                                                           |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Codex, Antigravity, or Grok Build**             | Tell the agent to use **built-in image generation**. It knows how but rarely does until instructed.                |
| **Claude Code (or other) + ChatGPT subscription** | "Use the Codex CLI to generate images. Help me install it if needed. Bill my **subscription**, not an API key."    |
| **API-only (Claude-only, etc.)**                  | OpenAI or Gemini API key with a **tight spend limit** — revoke without disrupting other work if leaked or misused. |

### API key hygiene

- **Never commit keys** to the repo or ship them in product code.
- Prefer a dedicated key with spend limits for agent use only.
- If pasting keys into chats repeatedly, create gitignored **`.env.agents`** and document in `AGENTS.md` that keys are for agent local dev only — must not ship with the product.

---

## Part B: Video generation

Video models are not only for ads. Use them for **everyday motion design** in product UI.

### Aggregator: fal.ai

Best video models change frequently. A single **fal.ai** API key lets the agent pick current models for generation and background removal without multiple integrations.

### Use case 1: Looping hero graphics

1. Generate a **looping clip** on a **solid/chroma background**.
2. **Chroma key** or, for complex cases, a **video matting model** to remove background.
3. Layer in UI — the animation should not read as a obvious video rectangle.

**Glass / refraction:** render the glass object **over the page background colors first** (bakes refraction into the clip), **then** remove background with matting.

**Example prompt (crystal hero):**

```
Can you replace the image on this page with a looping video clip that does something more interesting? Have the crystal splinter apart and slowly spin around. It should have awesome glassy effects that refract the page background and cast shadows and light around it.

To get convincing glass refraction effects, render the video of the glass over the page background colors first (so it bakes in the refraction effects), then remove the background with a video matting model.

Use this fal.ai API key: [key — local only, do not commit]

Find appropriate recent models for video generation and background removal.
```

### Use case 2: Fluid transitions between states

Many video models **interpolate between keyframe images**. Workflow:

1. Generate **still A** (image gen).
2. Video clip from still A → animates to **still B**.
3. Use **final frame** of that video to seed the **next** transition (seamless chain).
4. Play on user action (navigation) or **scrub frame-by-frame** on scroll/swipe.

**Example prompt (suitcase scroll demo):**

```
Build a demo page for a suitcase that uses a video model to create interactive transitions between a couple of screens. Each screen should show the suitcase in a different state, with vertical motion that feels appropriate for scrolling:

- Initially, have the suitcase floating high up in the air
- Then have it land on the floor and pop open
- Finally, have its contents neatly land into it from the top

Generate the initial frame using your image generation skill. Then, generate a video clip that starts from that frame and animates to the next state. Use the final frame of that video to seed the next transition so that it continues seamlessly. Scrub through the transitions one by one as the user scrolls.

Use this fal.ai API key: [key — local only, do not commit]

Use a video model with strong physics and consistency, like Seedance 2.5.
```

Good scroll-scrubbed transitions make users want to keep exploring — often achievable in a single well-structured prompt.

---

## Verification

- **Images:** check in browser; no broken assets or wrong aspect ratios.
- **Video loops:** seamless loop point; matting edges clean on target background.
- **Transitions:** no visible jump between chained segments; scroll scrub feels tied to gesture.
- **Performance:** lazy-load heavy media; respect `prefers-reduced-motion`.

## Repo integration

- Demo motion: Playwright screencast per `video-testing.md`
- After media pass: `design-critic` again if composition changed significantly
- Animation timing/easing on UI chrome: `emil-design-eng`, `apple-design`

## Sources

- [How to turn your AI into a world-class designer](https://www.lennysnewsletter.com/p/how-to-turn-your-ai-into-a-world) — Techniques 4 and 5
