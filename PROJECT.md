# Mistspren Project

## Mission

Mistspren keeps durable, practical project intelligence for Truthwatcher and future supporting projects. It should make the next development loop easier by preserving context, decisions, risks, progress, and recommended next actions in a form a human can understand in five minutes.

## Operating rules

1. Keep the system small and readable.
2. Prefer one maintained file over a folder hierarchy.
3. Record durable decisions as ADRs in `DECISIONS/`.
4. Record stable project facts in `KNOWLEDGE/`.
5. Record dated assessments in `REVIEWS/`.
6. Record current risks in `RISKS/`.
7. Keep only short, actionable tasks in `NEXT_ACTIONS.md`.
8. Keep current loop context in `ACTIVE_CONTEXT.md`.
9. Do not move Truthwatcher runtime logic into Mistspren.
10. Do not require Truthwatcher to read or depend on Mistspren at runtime.

## Truthwatcher boundary

Mistspren may inspect Truthwatcher, summarize changes, identify risks, propose ADRs, and recommend implementation prompts. Truthwatcher owns application code, schema migrations, tests, product documentation, releases, and runtime behavior.

Any future integration should be a one-way report or export that Mistspren can review. It must not make Mistspren a production dependency of Truthwatcher.

## ADR rule

Create or update an ADR only when a durable architectural choice is being made, confirmed, reversed, or superseded. Do not create ADRs for ordinary task tracking.

## Review loop output rule

Every review loop should update or explicitly confirm these six items:

- Truthwatcher changes observed.
- Decision made or confirmed.
- Risk discovered or changed.
- Recommended next action.
- Whether an ADR is needed.
- Whether Truthwatcher needs a bug fix, feature refinement, security improvement, or documentation update.
