# Pretty Results — optional JSON shape

Agents **do not** use one fixed schema for every `/pretty-results` run. Infer fields from whatever the user gave you (research memo, audit table, eval log, API dump). This file is a **shared vocabulary** so HTML reports stay consistent when you choose to normalize to JSON first.

Pick **one primary layout**:

| Source shape | Use in `DATA` | Typical UI |
| ------------ | ------------- | ---------- |
| Pass/fail matrix, eval scenarios, test cases | `scenarios[]` | Score, filters, expandable rows, check chips |
| Research, Q&A, quality review, narrative findings | `sections[]` | Summary header, article blocks, bullets, source links |
| Mixed | Both arrays | Score (if any scenarios) + prose sections below |

Omit keys you do not need. Extra domain fields belong in `extras` on a row or section.

## Top level (all optional except something to render)

```json
{
  "runAt": "2026-10-05T12:00:00Z",
  "title": "Weekly Meta Ads readout",
  "subtitle": "Quality agent summary · last 7 days",
  "command": "optional: how this was produced",
  "suite": "optional: eval or job name",
  "summary": { "passed": 7, "total": 8 },
  "rubric": [
    { "id": "accuracy", "label": "Accuracy", "description": "Claims match source data" }
  ],
  "scenarios": [],
  "sections": []
}
```

`summary.passed` / `total` — only when you have countable pass/fail rows. Research-only reports can use `summary: { "headline": "3 risks, 2 opportunities" }` or skip `summary` and lead with `sections[0].summary`.

## Scenario row (evals, tests, checklists — not auto-reply-specific)

```json
{
  "id": "case_03",
  "passed": false,
  "description": "Short title on the card",
  "why": "What this case is testing or why it matters",
  "checks": {
    "criterion_a": "OK",
    "criterion_b": "MISS"
  },
  "warnings": [],
  "artifacts": [
    { "kind": "message", "label": "Output", "text": "…" },
    { "kind": "code", "label": "Snippet", "text": "…" }
  ],
  "extras": {}
}
```

Use **`artifacts`** for anything row-specific (SMS, email draft, tool output, SQL row). Older eval HTML may use `tasks` with `brief` / `sms`; that is one eval profile, not a global requirement.

## Research section (default for quality-agent / research output)

```json
{
  "title": "Finding title",
  "summary": "One paragraph takeaway",
  "body": "Longer markdown or plain text",
  "bullets": ["Evidence 1", "Evidence 2"],
  "sources": [{ "label": "PostHog insight", "url": "https://..." }]
}
```

## HTML embedding

- Embed with `JSON.stringify` in a `<script>`; escape `</script>` in strings.
- Escape text in JS templates (`escapeHtml`).
- Huge raw logs: keep in `<slug>.log`, set `"truncated": true` in JSON.

## Files

| File | Purpose |
| ---- | ------- |
| `<slug>-results.json` | Normalized data (optional) |
| `<slug>-report.html` | Deliverable |
| `<slug>.log` | Optional raw archive |
