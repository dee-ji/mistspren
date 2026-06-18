# Mistspren Simplification Audit — 2026-06-18

## Current structure audit

The previous repository used a numbered pipeline: `0-raw`, `1-workbench`, `2-atoms`, `3-threads`, `4-decisions`, `5-roadmap`, `friction`, project-local mirrors, templates, docs, prompts, and many shell scripts. That structure was coherent as a knowledge-management theory, but too complex for the amount of useful content actually present.

## Useful files preserved

- ADR-0001 and ADR-0002 were preserved as durable decisions in `DECISIONS/`.
- The Truthwatcher current-state workbench was promoted to `KNOWLEDGE/truthwatcher.md` because it contains stable project context.
- The ADR-0002 decision analysis was preserved as a dated review in `REVIEWS/2026-06-16-truthwatcher-review.md`.
- The identity, evidence, and coupling risks were preserved and condensed into `RISKS/truthwatcher-risks.md`.
- The roadmap prompts were merged into a single reusable loop prompt at `PROMPTS/agentic-loop.md` instead of preserving a prompt queue hierarchy.

## Confusing, redundant, or unused files removed

- Empty root numbered folders and mirrored project folders were removed.
- Stage-specific scripts such as intake, extract, promote, synthesize, decide, roadmap, integrity, and ADR status were removed because most only generated scaffolds or local reports and did not create a useful agentic loop by themselves.
- Templates for atoms, threads, friction, and roadmap items were removed because the simplified workflow no longer uses those artifact types.
- `projects/truthwatcher/workspace.yml` was removed because the new layout no longer needs routing metadata for a mirrored hierarchy.
- `docs/cron.md` was removed because cron-oriented staged automation was not aligned with the new small manual review loop.

## Workflow assessment

The old workflow did preserve decisions, but it required too many folders before a reviewer reached practical guidance. It also made generated local outputs look like a workflow result even when they were only scaffolds. The simplified workflow makes the useful loop explicit: inspect Truthwatcher, write a dated review, update knowledge/risks/decisions only when durable, then refresh next actions.

## Proposed simplified structure

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
└── scripts/run-review.sh
```

## Migration plan applied

1. Preserve accepted ADRs in `DECISIONS/`.
2. Promote stable Truthwatcher facts into `KNOWLEDGE/truthwatcher.md`.
3. Preserve decision-support analysis as a dated review.
4. Condense active risks into `RISKS/truthwatcher-risks.md`.
5. Replace the prompt queue with one reusable loop prompt.
6. Replace many scaffold scripts with one read-only review script.
7. Remove empty folders, stale routing metadata, unused templates, and cron/stage automation docs.

## Keep / merge / delete / rename list

### Keep

- `LICENSE`
- `.gitignore`
- `DECISIONS/ADR-0001-truthwatcher-initial-architecture-direction.md`
- `DECISIONS/ADR-0002-reviewed-asset-identity.md`

### Merge or rename

- `projects/truthwatcher/1-workbench/extracts/truthwatcher-current-state.md` → `KNOWLEDGE/truthwatcher.md`
- `projects/truthwatcher/1-workbench/claim-maps/truthwatcher-decision-analysis-0002.md` → `REVIEWS/2026-06-16-truthwatcher-review.md`
- Project roadmap/prompt concepts → `NEXT_ACTIONS.md` and `PROMPTS/agentic-loop.md`
- Risk and friction concepts → `RISKS/truthwatcher-risks.md`

### Delete

- Empty numbered pipeline folders.
- Mirrored `projects/truthwatcher` hierarchy.
- Unused stage scripts and templates.
- Cron/staged workflow documentation.
- Routing metadata that existed only to support the removed hierarchy.
