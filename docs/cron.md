# Cron-Ready Mistspren Workflow

Mistspren uses a staged, human-reviewable workflow rather than an unsafe autonomous implementation loop:

```text
0-raw/ -> 1-workbench/ -> 2-atoms/ -> 3-threads/ -> 4-decisions/ -> 5-roadmap/
```

Each stage should preserve evidence and routing. Cron may prepare review notes, run integrity checks, and draft Mistspren planning artifacts, but humans should decide when material advances to durable knowledge, decisions, and implementation.

## Safety Boundary

Cron jobs in this repository must not directly modify Truthwatcher code. Truthwatcher owns source code, tests, migrations, APIs, product docs, and releases. Mistspren owns architecture reasoning, ADRs, workbench notes, synthesis threads, roadmap, critiques, and analysis.

The provided scripts intentionally do **not** auto-accept ADRs, create production pull requests, call external LLM APIs, or perform destructive file operations.

## Example Cron Schedule

```cron
0 8 * * * /path/to/mistspren/scripts/truthwatcher-review.sh --project truthwatcher --truthwatcher-path /path/to/truthwatcher
0 9 * * * /path/to/mistspren/scripts/synthesize.sh --project truthwatcher
0 12 * * * /path/to/mistspren/scripts/integrity.sh --project truthwatcher
0 8 * * 1 /path/to/mistspren/scripts/decide.sh --project truthwatcher
0 13 * * 1 /path/to/mistspren/scripts/roadmap.sh --project truthwatcher
```

## Beginner Schedule

A slower schedule is safer while the workflow is being tuned:

- Daily Truthwatcher review to create a workbench extract from Git changes.
- Daily integrity check to catch routing and roadmap/ADR consistency issues.
- Weekly decision review to draft proposed ADRs from mature threads only.
- Weekly roadmap reconciliation after accepted ADRs exist.

## Recommended Use

Start every new automation with `--dry-run`. Review the generated preview, then run non-dry mode only when the output is a Mistspren artifact that should be committed for human review.
