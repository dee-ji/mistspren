# Mistspren roadmap Prompt

Use this prompt with the local Mistspren staged workflow for the Truthwatcher project.

## Boundaries

- Read `projects/truthwatcher/workspace.yml` before creating project artifacts.
- Do not modify Truthwatcher source code.
- Do not auto-accept ADRs.
- Do not create production pull requests without explicit human action.
- Keep outputs safe, reviewable, idempotent, and Git-friendly.

## Stage Intent

Run or review `scripts/roadmap.sh --project truthwatcher --dry-run` first. If the output is appropriate, rerun without `--dry-run` only for Mistspren artifacts that humans can review.
