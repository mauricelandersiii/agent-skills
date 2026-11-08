---
name: triage-bugbot-findings
description: >-
  Triage Cursor Bugbot PR review findings before fixing anything. Use when the
  user asks to fix Bugbot, review Bugbot reports, triage Bugbot comments,
  address PR review findings from Cursor Bugbot, or run "fix bugbot" on a PR.
  Also use when Cursor Bugbot triggers Fix in Cursor, Fix in Web, Fix All,
  Bugbot Autofix, or asks to fix a bugbot finding (or bugbot findings) on a PR.
  Only fix findings that are both real and impactful; ignore the rest with a
  short rationale. Do not fix drive-by issues or expand scope beyond triaged
  findings.
---

# Triage Cursor Bugbot Findings

Specialized workflow for **Cursor Bugbot** PR review comments. Do not treat Bugbot output as ground truth — verify each finding in the codebase before changing anything.

## Operating posture

Default to **ignore** unless a finding survives both gates below. Bugbot often flags theoretical issues, stale assumptions, or deliberate product choices. Fixing noise wastes review time and adds regression risk.

**Do not:**

- Fix every Bugbot report because the user said "fix bugbot"
- Refactor unrelated code while addressing a finding
- Add tests unless the user explicitly asks
- Expand scope beyond findings that pass both gates

**Do:**

- Read the cited files and trace the actual runtime path
- Separate "technically true in isolation" from "matters in production"
- Report back with a triage table before or alongside fixes

## Two gates (both required to fix)

### Gate 1 — Is it real?

Confirm in code, not from the Bugbot description alone.

- Read the cited locations and callers
- Check whether the described failure mode can actually happen (auth, RLS, session, race, env)
- Distinguish current-branch behavior from staging/main if the report references old code
- Mark **not real** when the report misreads control flow, ignores an existing guard, or describes impossible state

### Gate 2 — Is it impactful?

Only fix if the bug affects something that matters in production for this product.

**Usually impactful:**

- Wrong attribution, conversion tracking, or billing/payment math
- Data loss, silent no-ops (e.g. RLS blocking a write the feature depends on)
- Security / authz / PII exposure
- User-visible broken flows on primary paths (intake, checkout, auth)
- Double-counting or duplicate side effects (webhooks, CAPI, emails)

**Usually not impactful (ignore even if technically true):**

- Edge cases on paths the team does not use
- Logged-in-only gaps when ads/intake target anonymous users
- Deliberate product/config choices (e.g. cookie TTL the team chose)
- Theoretical races with negligible probability and no observed harm
- Style, naming, or "could be clearer" without behavioral bug
- Findings that duplicate an existing webhook/server path that already handles the event correctly

When unsure, bias toward **ignore** and explain what would need to be true for it to matter.

## Required workflow

1. **List every Bugbot finding** (title + location).
2. **Triage each** with Gate 1 and Gate 2.
3. **Respond with the triage table** (see format below) before implementing fixes.
4. **Implement only** findings marked Fix.
5. **Summarize** what was fixed vs ignored and why.

If the user only pasted findings without a PR link, ask for the PR or branch if needed to verify context.

## Required output format

### Part 1 — Triage table (required)

| # | Title | Real? | Impactful? | Action | Rationale |
|---|-------|-------|------------|--------|-----------|
| 1 | … | Yes / No | Yes / No | **Fix** / **Ignore** | One sentence |

### Part 2 — Fixes (only for Action = Fix)

Brief description of each change and why it addresses the finding.

### Part 3 — Ignored (optional, brief)

One line per ignored finding so reviewers know it was considered, not missed.

## Examples (calibration)

| Finding | Real? | Impactful? | Action | Why |
|---------|-------|------------|--------|-----|
| Sync uses session client but TEXT_VERIFY has no Supabase session → RLS blocks preference write | Yes | Yes | **Fix** | Defeats the feature; delayed CAPI attribution never persists |
| Success page re-sends CAPI Purchase on every revisit with same `event_id` | Yes | Yes | **Fix** | Inflates conversion metrics past Meta dedup window |
| Cookie max-age 45 days vs comment saying 90 | No | — | **Ignore** | Deliberate product choice, not a bug |
| `fbc` regenerated from `fbclid` on merge while `capturedAt` preserved | Barely | No | **Ignore** | First-touch `fbclid` retained; minor timestamp drift |
| Skip attribution capture for logged-in users on influencer landing | Yes | No | **Ignore** | Primary ad funnel is anonymous intake/checkout |

## Team prompt (optional)

Users can say: **"Triage and fix Bugbot on PR #1234"** — no long preface needed; this skill supplies the criteria.
