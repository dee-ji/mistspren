# Mistspren

Mistspren is a Git-friendly structured intelligence workspace for turning technical information into durable understanding, defensible decisions, and executable roadmaps.

It is designed for long-running architecture and engineering work around networking, network automation, service-provider infrastructure, inventory systems, source-of-truth platforms, discovery systems, intent-based networking, AI agents, and knowledge engineering.

Mistspren is not a note dump. It is an evidence-driven decision engine.

## First Ideal

> Information before opinion. Evidence before inference. Understanding before action.

Mistspren should prevent jumps from raw information directly to implementation. Inputs are staged, sourced, linked, challenged, and promoted only when they earn the next level of confidence.

## Core Pipeline

All knowledge moves through the same path:

```text
0-raw/
→ 1-workbench/
→ 2-atoms/
→ 3-threads/
→ 4-decisions/
→ 5-roadmap/
```

Do not skip stages.

| Stage | Purpose | Answer |
| --- | --- | --- |
| `0-raw/` | Captured, uninterpreted source material | What was observed or collected? |
| `1-workbench/` | Temporary extraction and analysis | What claims, evidence, contradictions, and questions exist? |
| `2-atoms/` | Permanent sourced knowledge units | What single durable thing do we know? |
| `3-threads/` | Synthesis across atoms | What does this mean? |
| `4-decisions/` | Recorded conclusions and tradeoffs | What should we do? |
| `5-roadmap/` | Execution planning | What happens next? |
| `friction/` | Conflicting evidence and unresolved tension | What must be resolved or tracked? |

## Repository Layout

Mistspren separates project knowledge, reusable templates, executable workflow scaffolding, prompts, and generated run evidence. The numbered folders exist both at the repository root for global or cross-project memory and under `projects/<project>/` for project-scoped memory.

```text
mistspren/
├── 0-raw/                 # Global or cross-project source material.
│   ├── articles/
│   ├── docs/
│   ├── ideas/
│   ├── logs/
│   └── meetings/
├── 1-workbench/           # Global or cross-project extraction and analysis.
│   ├── extracts/
│   ├── claim-maps/
│   ├── questions/
│   └── candidate-atoms/
├── 2-atoms/               # Global durable sourced knowledge, grouped by topic.
├── 3-threads/             # Global synthesis threads, grouped by topic.
├── 4-decisions/           # Global ADRs, grouped by status.
├── 5-roadmap/             # Global roadmap items, grouped by planning level.
├── friction/              # Global conflicts and unresolved tensions.
├── docs/                  # Operator documentation such as cron guidance.
├── logs/                  # Generated script logs.
├── prompts/               # Prompt text paired with workflow stages.
├── reports/
│   ├── integrity/         # Integrity reports created by scripts/integrity.sh.
│   └── runs/              # Per-run reports created by workflow scripts.
├── scripts/               # Safe shell scaffolds for the staged workflow.
├── templates/             # Reusable Markdown templates for durable artifacts.
├── Makefile               # Convenience targets for common Mistspren workflows.
└── projects/
    └── truthwatcher/
        ├── 0-raw/         # Truthwatcher-specific captured source material.
        ├── 1-workbench/   # Truthwatcher-specific extraction and analysis.
        ├── 2-atoms/       # Truthwatcher-specific sourced knowledge.
        ├── 3-threads/     # Truthwatcher-specific synthesis.
        ├── 4-decisions/   # Truthwatcher-specific ADRs by status.
        ├── 5-roadmap/     # Truthwatcher-specific execution planning.
        ├── friction/      # Truthwatcher-specific conflicts.
        └── workspace.yml  # Truthwatcher routing metadata for agents.
```

Generated files under `logs/` and `reports/` are evidence of workflow runs. Review them before committing, and keep only reports that are useful for audit or handoff.


## Project Memory Routing

Mistspren supports both global memory and project-scoped memory. The numbered folders at the repository root are reserved for material that applies across multiple projects or to Mistspren itself. Work for a named project must live under that project's directory in `projects/<project>/` and then follow the same staged pipeline inside that project.

For Truthwatcher, create and update artifacts under `projects/truthwatcher/`:

```text
projects/truthwatcher/
├── 0-raw/
├── 1-workbench/
│   ├── extracts/          # Source extractions, current-state notes, and evidence summaries.
│   ├── claim-maps/        # Claim/evidence analysis and decision-prep notes.
│   ├── questions/         # Open investigation prompts and unresolved questions.
│   └── candidate-atoms/   # Draft atoms not yet promoted to durable knowledge.
├── 2-atoms/
├── 3-threads/
│   ├── architecture/      # Architecture synthesis threads.
│   ├── implementation/    # Implementation-sequencing synthesis threads.
│   ├── operations/
│   ├── risks/
│   └── strategy/
├── 4-decisions/
│   ├── proposed/
│   ├── accepted/
│   ├── rejected/
│   └── superseded/
├── 5-roadmap/
│   ├── backlog/
│   ├── initiatives/
│   ├── milestones/
│   └── tasks/
└── friction/
    ├── open/
    ├── resolved/
    └── archived/
```

Routing rules:

1. If an artifact is about exactly one named project, put it under `projects/<project>/`, not in the root stage folders.
2. Use the deepest meaningful subdirectory; for example, Truthwatcher architecture threads belong in `projects/truthwatcher/3-threads/architecture/`, and proposed Truthwatcher ADRs belong in `projects/truthwatcher/4-decisions/proposed/`.
3. Use root stage folders only for cross-project knowledge, Mistspren operating guidance, reusable research, or material that intentionally has no single project owner.
4. When promoting an artifact to a later stage, move it to the appropriate later-stage project subdirectory and update links rather than leaving durable project artifacts in a staging folder.
5. `projects/<project>/workspace.yml` is the routing anchor agents should read before creating project memory.

## Knowledge Integrity Rules

1. No source, no atom.
2. No atom, no thread.
3. No thread, no decision.
4. No decision, no roadmap change.
5. Never silently overwrite knowledge.
6. Preserve superseded decisions instead of deleting them.
7. Link related concepts.
8. Separate facts, assumptions, hypotheses, and decisions.
9. Create friction records for conflicts.
10. Favor operational reality over theoretical elegance.

## Stage Guidance

### `0-raw/` — intake

Use this for original source material such as articles, vendor docs, meeting notes, CLI output, logs, screenshots, transcripts, research, and rough ideas.

Rules:

- Preserve the original context.
- Do not rewrite the source into conclusions.
- Record source metadata when available.
- Suggested filename: `YYYY-MM-DD_source_topic.md`.

### `1-workbench/` — analysis

Use this for temporary thinking: claim extraction, evidence mapping, questions, contradictions, and candidate atoms.

Rules:

- Workbench notes may be messy.
- Workbench notes are not permanent knowledge.
- Important findings must graduate into atoms.
- Suggested filename: `YYYY-MM-DD_workbench_topic.md`.

### `2-atoms/` — permanent knowledge

Use this for one sourced concept per note. Every atom must trace to evidence.

Use `templates/atom.md` when creating a new atom.

### `3-threads/` — synthesis

Use this to connect atoms into understanding. Threads identify patterns, relationships, tradeoffs, risks, and emerging architecture.

Use `templates/thread.md` when creating a new thread.

### `4-decisions/` — decisions

Use this for recorded conclusions. Decisions must be backed by threads and include alternatives considered, rationale, expected outcome, risks, and a review trigger.

Use `templates/decision.md` when creating a new decision.

### `5-roadmap/` — execution

Use this for initiatives, milestones, tasks, priorities, and validation plans. Roadmap items must trace to decisions.

Use `templates/roadmap-item.md` when creating a new roadmap item.

### `friction/` — conflict handling

Create a friction record when sources disagree, assumptions collide with operational reality, evidence is incomplete, or vendor claims may be hype.

Use `templates/friction.md` when creating a new friction record.

## Connection to the Truthwatcher App

Mistspren is the architectural workbench and agentic decision system for Truthwatcher. Truthwatcher is the product being designed, implemented, and evolved.

Repository roles:

- **Mistspren owns:** architectural reasoning, ADRs, implementation analysis, agentic loops, planning artifacts, research, tradeoff analysis, and decision history.
- **Mistspren produces:** ADRs, implementation recommendations, design reviews, architectural critiques, project plans, and other durable planning artifacts.
- **Truthwatcher owns:** source code, tests, migrations, APIs, product documentation, releases, and deployment artifacts.
- **Truthwatcher consumes:** accepted architectural decisions, implementation guidance, and project plans.

Authority model:

- **Mistspren is authoritative for architectural intent.**
- **Truthwatcher is authoritative for implementation reality.**
- If code behavior conflicts with an ADR, record the conflict, analyze the reason, and update the ADR or implementation plan as appropriate. Do not silently assume either the ADR or the code is correct.

Recommended responsibility split:

- **Mistspren repository:** Markdown artifacts, source traceability, decisions, roadmap history, architectural critique, implementation analysis, and Git-based change review.
- **Truthwatcher app/repository:** Product code, tests, migrations, APIs, releases, deployment artifacts, capture UI, review queues, search, graph navigation, scheduled jobs, notifications, and dashboards.
- **Shared contract:** Truthwatcher should use accepted Mistspren decisions and plans without bypassing stage rules. For example, a captured article enters `0-raw/`, an extraction job creates `1-workbench/` notes, a reviewer or agent promotes sourced claims into `2-atoms/`, and only synthesized threads can support decisions and roadmap changes.

This separation keeps Truthwatcher operationally useful without making it the only place where institutional knowledge lives. Git remains the audit trail; Truthwatcher becomes the workflow engine.

### Truthwatcher Workspace Configuration

Truthwatcher-specific workspace metadata lives at `projects/truthwatcher/workspace.yml`. That file declares the Truthwatcher project, points agents to the Truthwatcher repository metadata, identifies Mistspren as the ADR source, and records that analysis deliverables belong in Mistspren while implementation deliverables belong in Truthwatcher.

Agents working across Mistspren and Truthwatcher should use `projects/truthwatcher/workspace.yml`, repository metadata, Git remotes, mounted workspaces, or explicit user instructions to discover the Truthwatcher repository. Do not assume a fixed filesystem path.

When working on Truthwatcher:

- Read relevant ADRs from Mistspren before proposing implementation.
- Treat ADRs as design intent, not executable truth.
- Verify assumptions against the actual Truthwatcher code.
- Preserve separation between Mistspren workflow artifacts and Truthwatcher product artifacts.
- Do not introduce Mistspren-specific commands, workflows, prompts, or agent scaffolding into Truthwatcher.
- Store planning artifacts, analyses, critiques, and architectural investigations in Mistspren. Store code, tests, migrations, and product documentation in Truthwatcher. When uncertain, prefer storing work in Mistspren until implementation begins.


## Scripts and Makefile Usage

The `scripts/` directory contains conservative workflow scaffolds. They create Mistspren notes, run reports, integrity reports, and logs; they do not edit Truthwatcher source code, accept ADRs automatically, open production pull requests, or perform destructive file operations.

All scripts currently support the Truthwatcher project only and accept `--project truthwatcher`. Start with `--dry-run` to preview generated content before writing files.

### Makefile targets

Use the `Makefile` for the common operator path:

```bash
# Review Truthwatcher Git changes into a Mistspren workbench extract.
export TRUTHWATCHER_REPO_PATH=/path/to/truthwatcher
make mistspren-review

# Run the project integrity check and write reports.
make mistspren-integrity

# Preview review, synthesis, and integrity steps without keeping generated artifacts.
TRUTHWATCHER_REPO_PATH=/path/to/truthwatcher make mistspren-dry-run
```

`mistspren-review` requires `TRUTHWATCHER_REPO_PATH` because the Truthwatcher application repository is discovered from operator configuration rather than a hard-coded filesystem path.

### Manual workflow commands

Run each step manually when debugging automation, reviewing a single stage, or building a cron job incrementally:

```bash
# 1. Intake scaffold: document that reviewed captures are ready for raw storage.
./scripts/intake.sh --project truthwatcher --dry-run
./scripts/intake.sh --project truthwatcher

# 2. Extraction scaffold: document raw-to-workbench extraction intent.
./scripts/extract.sh --project truthwatcher --dry-run
./scripts/extract.sh --project truthwatcher

# 3. Truthwatcher implementation review: create a workbench extract from Git changes.
./scripts/truthwatcher-review.sh --project truthwatcher --truthwatcher-path /path/to/truthwatcher --dry-run
./scripts/truthwatcher-review.sh --project truthwatcher --truthwatcher-path /path/to/truthwatcher

# 4. Atom promotion scaffold: record reviewed promotion intent; automatic promotion is disabled.
./scripts/promote.sh --project truthwatcher --dry-run
./scripts/promote.sh --project truthwatcher

# 5. Synthesis scaffold: record thread update intent from reviewed atoms/workbench notes.
./scripts/synthesize.sh --project truthwatcher --dry-run
./scripts/synthesize.sh --project truthwatcher

# 6. Decision scaffold: draft proposed ADR work only; never auto-accept decisions.
./scripts/decide.sh --project truthwatcher --dry-run
./scripts/decide.sh --project truthwatcher

# 7. Roadmap scaffold: reconcile accepted ADRs into planning artifacts only.
./scripts/roadmap.sh --project truthwatcher --dry-run
./scripts/roadmap.sh --project truthwatcher

# 8. Integrity check: validate required folders and ADR/roadmap consistency.
./scripts/integrity.sh --project truthwatcher --dry-run
./scripts/integrity.sh --project truthwatcher
```

The scaffold scripts write timestamped logs to `logs/` and run reports to `reports/runs/`. The integrity script also writes detailed reports to `reports/integrity/`. The Truthwatcher review script writes workbench extracts to `projects/truthwatcher/1-workbench/extracts/` and updates `.mistspren/state/truthwatcher-last-reviewed` after a non-dry run.

### Cron schedule example

Use `docs/cron.md` as the canonical cron reference. A safe starting schedule is:

```cron
0 8 * * * /path/to/mistspren/scripts/truthwatcher-review.sh --project truthwatcher --truthwatcher-path /path/to/truthwatcher
0 9 * * * /path/to/mistspren/scripts/synthesize.sh --project truthwatcher
0 12 * * * /path/to/mistspren/scripts/integrity.sh --project truthwatcher
0 8 * * 1 /path/to/mistspren/scripts/decide.sh --project truthwatcher
0 13 * * 1 /path/to/mistspren/scripts/roadmap.sh --project truthwatcher
```

Cron should prepare reviewable Mistspren artifacts only. Keep stage advancement, ADR acceptance, and implementation changes human-reviewed.

## Agentic Workflow Suggestions

A practical agentic workflow should be staged and reviewable rather than fully magical.

### 1. Intake agent

- Watches inboxes, bookmarks, uploaded files, meeting transcripts, issue comments, and Truthwatcher captures.
- Writes raw, unmodified material to `0-raw/`.
- Adds metadata such as source, capture date, owner, and topic.
- Does not summarize into decisions.

### 2. Extraction agent

- Reads new `0-raw/` items.
- Produces `1-workbench/` extraction notes containing claims, evidence, assumptions, contradictions, and open questions.
- Flags missing source metadata.
- Suggests candidate atoms but does not promote unsourced claims.

### 3. Atom promotion agent

- Reviews workbench candidate atoms.
- Creates one sourced note per durable concept in `2-atoms/`.
- Links related atoms.
- Creates `friction/open/` records when evidence conflicts.
- Sends low-confidence or unsourced material back to workbench.

### 4. Synthesis agent

- Periodically scans related atoms.
- Creates or updates `3-threads/` documents with patterns, tradeoffs, risks, and interpretations.
- Clearly separates facts, assumptions, hypotheses, and interpretations.

### 5. Decision agent

- Identifies threads that are ready for action.
- Drafts `4-decisions/` records with alternatives, rationale, expected outcomes, risks, and review triggers.
- Requires human approval before moving major decisions to `accepted/`.

### 6. Roadmap agent

- Converts accepted decisions into `5-roadmap/` initiatives, milestones, and tasks.
- Verifies that every roadmap item links back to a decision.
- Reports orphaned tasks that do not trace to decisions.

### 7. Integrity agent

- Checks for broken links, unsourced atoms, decisions without supporting threads, roadmap items without decisions, stale friction records, and superseded decisions that were edited instead of moved.
- Opens pull requests with small, reviewable fixes.

## Recommended Cron Cadence

Use `docs/cron.md` for the cron-ready schedule that maps to the scripts in this repository. The older product-level cadence remains a useful conceptual target, but runnable cron entries should call the checked-in scripts or the `Makefile` targets documented above.

A practical operating rhythm is:

| Cadence | Runnable step | Purpose |
| --- | --- | --- |
| Daily | `scripts/truthwatcher-review.sh` | Capture implementation-reality changes from the Truthwatcher Git repository into a Mistspren workbench extract. |
| Daily | `scripts/synthesize.sh` | Record synthesis-pass intent for reviewed atoms and workbench notes. |
| Daily | `scripts/integrity.sh` or `make mistspren-integrity` | Validate required folders and ADR/roadmap consistency. |
| Weekly | `scripts/decide.sh` | Draft proposed ADR work from mature threads only. |
| Weekly | `scripts/roadmap.sh` | Reconcile accepted decisions into planning artifacts. |

Start new schedules with `--dry-run`, inspect the preview and generated reports, then enable non-dry mode only for artifacts that should enter Git review.


## Templates

Templates are available in `templates/`:

- `templates/atom.md`
- `templates/thread.md`
- `templates/decision.md`
- `templates/roadmap-item.md`
- `templates/friction.md`

Copy a template into the appropriate stage directory and fill it in rather than creating free-form records.

## Operating Biases

Favor simplicity, extensibility, observability, operational safety, clear ownership, reproducibility, single-purpose artifacts, human-readable Markdown, and Git-friendly workflows.

Avoid magic agents, hidden state, vendor lock-in, premature abstraction, hype-driven decisions, unverifiable claims, and roadmap churn without decision records.
