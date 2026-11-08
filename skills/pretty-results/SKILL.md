---
name: pretty-results
description: >-
  Turn eval runs, agent research, quality checks, or any structured results into a
  polished, interactive HTML report and share it via a Cloudflare quick tunnel on the
  cloud agent VM. Use when the user asks for pretty results, a readable report link,
  /pretty-results, or wants to understand eval/research output without reading raw logs.
---

# Pretty Results (`/pretty-results`)

Deliver **one self-contained HTML file** plus a **public trycloudflare link** so the user can read outcomes in the browser: score at a glance, filter/search, expandable detail, and domain-specific blocks (rubrics, SMS, tasks, traces, tables) inferred from the source material.

**Design bar:** Read the `emil-design-eng` skill for motion, easing, and interaction polish (`cubic-bezier` eases, `:active` scale on buttons, staggered card entrance, `prefers-reduced-motion`). Keep the layout clean and information-dense — this is an internal reading surface, not marketing.

**Not in git:** Generated HTML/JSON/logs live under `/opt/cursor/artifacts/` unless the user explicitly wants a committed generator in the repo.

---



## When to use

- User ran or received **eval results**, **quality-agent output**, **research summaries**, **comparison tables**, or **multi-scenario pass/fail** data and wants to **read** them comfortably.
- User says **pretty results**, **HTML report**, **share a link**, `/pretty-results`, or references how a prior agent presented eval output.
- After **any long terminal log** where the user cares about **per-case status**, **why it failed**, and **evidence** (messages, tasks, snippets).

**Do not use** for product UI changes (use Playwright per `video-testing.md`). **Do not use** RecordScreen for this — static HTML + tunnel is the deliverable.

---



## End-to-end workflow



### 1. Collect and normalize

1. Identify the **source**: eval stdout/log, JSON export, rubric file, CSV, markdown tables, or MCP/API payloads.
2. Optionally write **normalized JSON** to `/opt/cursor/artifacts/<slug>-results.json` when it helps (eval matrices, many rows). For prose-heavy research, you can embed data straight in HTML or use `sections` only — see `references/data-schema.md` for shared field names, not a mandatory auto-reply/eval shape.
3. Strip **secrets** (API keys, tokens, full patient PII). Keep scenario ids and redacted snippets only.

**Infer structure from content:**


| If the data has…                      | Surface in the report                                                      |
| ------------------------------------- | -------------------------------------------------------------------------- |
| Pass/fail per row                     | Score header `passed/total`, pass/fail badges, filter buttons              |
| Named rubric / checks                 | Sidebar “Rubric” or “Checks” list; per-row chips (`OK` / `MISS` / neutral) |
| Human “why” / intent                  | Collapsed card body, lead with **Intent** callout                          |
| Nested artifacts (tasks, SMS, traces) | Expandable sections inside each row; SMS as message bubbles                |
| Single failure mode                   | Auto-expand failed rows; optional amber **coverage** / warning callout     |
| Run metadata                          | Sticky header subtitle: command, suite name, `runAt` ISO timestamp         |
| Long lists                            | Search box (match id, title, description, intent text)                     |
| Research / prose sections             | Top-level `<article>` sections or tabs if >3 major themes                  |
| Time series or metrics                | Simple inline sparkline or table — avoid chart libraries unless necessary  |


If the source is **only prose**, still use the same shell: title, summary bullets, expandable sections per finding, optional “Sources” list.

### 2. Build the HTML

Write `/opt/cursor/artifacts/<slug>-report.html` as **one file**:

- Embedded `const DATA = { ... }` from the JSON (escape `</script>` in strings).
- **No build step** — vanilla HTML/CSS/JS only.
- **Layout:** sticky header (title + score), two-column desktop (sidebar context + main list), single column on narrow viewports.
- **Interactivity:** `<details>`/summary cards or equivalent; filter All / Passed / Failed; search; re-render from `DATA` in JS.
- **Accessibility:** `aria-pressed` on filter toggles, semantic headings, sufficient contrast on light or dark themes.

Use a short slug: `procedure-approaching`, `auto-reply-eval`, `research-meta-ads-2026-10-05`, etc.

### 3. Serve locally on the VM

1. Pick a free port: `ss -tlnp | rg ':87'` or try `8799`, `8800`, …
2. Serve **only** the artifacts directory (no repo root):

```bash
ARTIFACTS=/opt/cursor/artifacts
SLUG=procedure-approaching
PORT=8799
SESSION="${SLUG}-report-http"

tmux -f /exec-daemon/tmux.portal.conf has-session -t "$SESSION" 2>/dev/null \
  || tmux -f /exec-daemon/tmux.portal.conf new-session -d -s "$SESSION" -c "$ARTIFACTS" -- \
  python3 -m http.server "$PORT" --bind 127.0.0.1
```

1. Verify: `curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:${PORT}/${SLUG}-report.html"` → `200`.



### 4. Cloudflare quick tunnel (public link)

**Local/staging only.** Never point a tunnel at production or staging Supabase/apps.

```bash
CLOUDFLARED="${CLOUDFLARED:-$HOME/cloudflared}"
if ! command -v cloudflared >/dev/null 2>&1 && [ -x "$CLOUDFLARED" ]; then
  export PATH="$HOME:$PATH"
fi
# Install once if missing (linux amd64):
# curl -L -o "$HOME/cloudflared" https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
# chmod +x "$HOME/cloudflared"

TUNNEL_SESSION="${SLUG}-tunnel"
tmux -f /exec-daemon/tmux.portal.conf has-session -t "$TUNNEL_SESSION" 2>/dev/null \
  || tmux -f /exec-daemon/tmux.portal.conf new-session -d -s "$TUNNEL_SESSION" -- \
  "$CLOUDFLARED" tunnel --url "http://127.0.0.1:${PORT}" --no-autoupdate
```

Read the tunnel URL from tmux pane output (`https://*.trycloudflare.com`). Full link:

`https://<host>.trycloudflare.com/<slug>-report.html`

Tell the user the link may **die** when the tunnel process stops; they can ask to regenerate.

### 5. Hand off to the user

In the chat response, include:

- The **trycloudflare URL** (markdown link).
- **Score / headline** (e.g. 7/8 passed).
- **One sentence** on what failed or what to read first.
- Paths to **artifacts** on the VM if they want the JSON/log: `/opt/cursor/artifacts/`.

Optional: attach a screenshot to the PR only when this work is part of a repo change; the skill itself usually needs no PR artifact.

---



## Quality checklist (before saying done)

- [ ] Failed scenarios expanded by default; passed collapsed
- [ ] Rubric / check dimensions documented in sidebar when present
- [ ] No secrets in HTML/JSON
- [ ] Tunnel returns 200 for the report path
- [ ] User can filter pass/fail and search without reading raw logs

---



## Related files

- `references/data-schema.md` — optional JSON vocabulary (`scenarios` vs `sections`); examples are generic, not tied to auto-reply
- `AGENTS.md` → **Cursor Cloud Environment** → quick tunnels (auth spoof rules apply to **apps**, not static artifact HTML)

