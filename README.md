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

```text
mistspren/
├── 0-raw/
│   ├── articles/
│   ├── docs/
│   ├── meetings/
│   ├── logs/
│   └── ideas/
├── 1-workbench/
│   ├── extracts/
│   ├── claim-maps/
│   ├── questions/
│   └── candidate-atoms/
├── 2-atoms/
│   ├── networking/
│   ├── automation/
│   ├── inventory/
│   ├── source-of-truth/
│   ├── ai-agents/
│   ├── discovery/
│   └── architecture/
├── 3-threads/
│   ├── architecture/
│   ├── implementation/
│   ├── operations/
│   ├── risks/
│   └── strategy/
├── 4-decisions/
│   ├── accepted/
│   ├── superseded/
│   └── rejected/
├── 5-roadmap/
│   ├── initiatives/
│   ├── milestones/
│   ├── tasks/
│   └── backlog/
├── friction/
│   ├── open/
│   ├── resolved/
│   └── archived/
└── templates/
```

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

Mistspren is the knowledge substrate for the Truthwatcher app. The Truthwatcher app can act as the interface and automation layer, while this repository remains the durable, auditable intelligence store.

Recommended responsibility split:

- **Mistspren repository:** Markdown artifacts, source traceability, decisions, roadmap history, and Git-based change review.
- **Truthwatcher app:** Capture UI, review queues, agent orchestration, search, graph navigation, scheduled jobs, notifications, and dashboards.
- **Shared contract:** Truthwatcher should write into the Mistspren pipeline without bypassing stage rules. For example, a captured article enters `0-raw/`, an extraction job creates `1-workbench/` notes, a reviewer or agent promotes sourced claims into `2-atoms/`, and only synthesized threads can support decisions and roadmap changes.

This separation keeps Truthwatcher operationally useful without making it the only place where institutional knowledge lives. Git remains the audit trail; Truthwatcher becomes the workflow engine.

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

Use a cadence that matches how quickly evidence changes and how much human review capacity exists.

| Cadence | Job | Purpose |
| --- | --- | --- |
| Every 15 minutes | Intake sync | Pull new captures from Truthwatcher, inboxes, watched folders, and integrations into `0-raw/`. |
| Hourly | Extraction pass | Convert new raw items into `1-workbench/` claim maps, questions, and candidate atoms. |
| Twice daily | Atom promotion review | Promote high-confidence sourced claims into `2-atoms/`; create friction records for conflicts. |
| Daily | Integrity check | Validate links, sources, stage boundaries, and traceability rules. |
| Twice weekly | Synthesis pass | Update `3-threads/` from accumulated atoms and friction records. |
| Weekly | Decision review | Draft or revisit `4-decisions/` from mature threads. |
| Weekly | Roadmap reconciliation | Ensure `5-roadmap/` reflects accepted decisions and remove or flag orphaned execution items. |
| Monthly | Friction review | Resolve, archive, or escalate stale `friction/open/` records. |
| Quarterly | Architecture retrospective | Review decisions, superseded assumptions, roadmap outcomes, and operating cadence. |

Example cron sketch:

```cron
*/15 * * * * truthwatcher sync --target 0-raw/
0 * * * * truthwatcher extract --from 0-raw/ --to 1-workbench/
0 9,16 * * * truthwatcher promote-atoms --from 1-workbench/ --to 2-atoms/ --friction friction/open/
30 16 * * * truthwatcher integrity-check
0 10 * * 2,5 truthwatcher synthesize --atoms 2-atoms/ --threads 3-threads/
0 11 * * 5 truthwatcher decision-review --threads 3-threads/ --decisions 4-decisions/
0 13 * * 5 truthwatcher roadmap-reconcile --decisions 4-decisions/accepted/ --roadmap 5-roadmap/
0 10 1 * * truthwatcher friction-review --friction friction/
```

Treat these commands as interface suggestions for the Truthwatcher app or its worker CLI. If the app uses a queue-based scheduler instead of cron, keep the same cadence and stage boundaries.

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
