---
name: babysit-pr
description: >-
  Babysit a pull request until merge-ready: resolve merge conflicts, fix scoped
  CI failures, address human review comments, and triage Bugbot findings using
  the two-gate workflow (real + impactful only). Use when the user says /babysit,
  babysit PR, monitor PR, get PR merge-ready, or links a GitHub PR to watch
  until green and comments are handled.
---

# Babysit PR

Get the linked PR to a **merge-ready** state. Work in loops: check status → fix
what's in scope → push → re-check until done or blocked.

## Input

User provides a PR URL or number (e.g. `https://github.com/Org/repo/pull/1400`
or `PR #1400`). If missing, ask once.

## Stop conditions (all must be true to finish)

1. **No merge conflicts** with the PR base branch (or merge/rebase completed).
2. **CI green** — all required checks passing on the latest commit.
3. **Human review** — no unresolved change requests or bug reports from
   reviewers that are valid and in scope.
4. **Bugbot triaged** — every active Bugbot finding has been through the
   two-gate workflow below; fixes pushed for Action = **Fix**; Action =
   **Ignore** documented in the triage table (no code change required).

Stop early only when **all four** are satisfied. If blocked (conflicting
intents, failing CI outside PR scope, needs human decision), report clearly and
stop.

## Workflow loop

Each iteration:

1. Fetch PR state: mergeable?, checks, unresolved review threads (skip resolved).
2. **Merge conflicts** — resolve intelligently; preserve intent of both sides.
   If intents conflict, abort and ask for clarification.
3. **CI** — fix failures caused by this PR's changes. Do not weaken CI or make
   unrelated fixes. If failure seems unrelated, merge latest base branch first
   (another PR may have fixed it).
4. **Comments** — handle active unresolved threads:
   - **Human reviewers** — address valid in-scope requests; reply or resolve
     when done.
   - **Cursor Bugbot** — follow **Bugbot triage** (required; do not fix every
     Bugbot report by default).
5. Commit, push, update PR if needed, re-check from step 1.

## Bugbot triage (required)

Before changing code for any Bugbot finding, **read and follow**
`.cursor/skills/triage-bugbot-findings/SKILL.md` in full.

Summary (full gates and table format live in that skill):

- **Gate 1 — Real?** Verify in code; Bugbot is not ground truth.
- **Gate 2 — Impactful?** Only fix production-meaningful issues.
- Default to **ignore** unless both gates pass.
- Output the **triage table** before implementing fixes.
- Implement **only** findings marked **Fix**; document **Ignore** with rationale.

Do not expand scope beyond triaged Bugbot findings. Do not add tests unless
the user explicitly asks.

## Out of scope

- Merging the PR (unless the user explicitly asks, with repo safety gates).
- Fixing CI or code unrelated to this PR to make checks pass.
- Applying every Bugbot suggestion without triage.

## Team prompt

**`/babysit https://github.com/Org/repo/pull/1234`** — no extra instructions
needed; Bugbot handling uses the triage skill automatically.
