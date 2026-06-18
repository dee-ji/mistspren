# Mistspren

Mistspren is a small, Git-backed project intelligence workspace. Its job is to help Truthwatcher and future related projects preserve useful context across agentic loops: decisions, durable knowledge, active work, risks, reviews, and next actions.

Mistspren is not a runtime dependency, plugin framework, or large knowledge-management hierarchy. Truthwatcher must remain production-decoupled from Mistspren. Mistspren may inspect Truthwatcher and recommend work, but implementation, tests, migrations, product docs, and releases stay in Truthwatcher.

## Read in this order

1. `PROJECT.md` — mission, rules, and operating boundaries.
2. `ACTIVE_CONTEXT.md` — what is currently being worked on.
3. `NEXT_ACTIONS.md` — short prioritized task list.
4. `DECISIONS/` — accepted durable ADRs.
5. `KNOWLEDGE/truthwatcher.md` — stable Truthwatcher facts and context.
6. `RISKS/truthwatcher-risks.md` — active risks to watch.
7. `REVIEWS/` — dated project assessments and loop outputs.
8. `PROMPTS/agentic-loop.md` — reusable prompt for the next review loop.

## Repository layout

```text
mistspren/
├── README.md
├── PROJECT.md
├── ACTIVE_CONTEXT.md
├── NEXT_ACTIONS.md
├── DECISIONS/
├── KNOWLEDGE/
├── REVIEWS/
├── RISKS/
├── PROMPTS/
└── scripts/
```

## Agentic review loop

Each loop should answer six practical questions:

1. What changed in Truthwatcher?
2. What decision was made or confirmed?
3. What risk was discovered?
4. What next action is recommended?
5. Is an ADR needed?
6. Does Truthwatcher need a bug fix, feature refinement, security improvement, or documentation update?

Run the local review helper when a Truthwatcher checkout is available:

```bash
TRUTHWATCHER_HOME=~/GolandProjects/truthwatcher ./scripts/run-review.sh
```

The script writes a dated Markdown review under `REVIEWS/` and reminds the reviewer to update `ACTIVE_CONTEXT.md`, `NEXT_ACTIONS.md`, `RISKS/`, `KNOWLEDGE/`, or `DECISIONS/` when the findings are durable.

## What belongs here

- Architecture decisions that should survive across agents.
- Stable project knowledge that helps future implementation work.
- Current context and concise next actions.
- Risks, vulnerabilities, delivery blockers, and safety boundaries.
- Dated review outputs that summarize what changed and what to do next.
- Reusable prompts for repeatable Codex review loops.

## What does not belong here

- Truthwatcher runtime code or runtime dependencies.
- Timestamped scratch output that nobody will read again.
- Multi-stage note taxonomies without practical use.
- Unused shell scaffolds.
- Plugin frameworks, sync daemons, or abstractions that couple projects.
