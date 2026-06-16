# Thread: Truthwatcher Implementation Roadmap

## Question

How should the current Truthwatcher ADRs be converted into an implementation sequence without skipping Mistspren's evidence-driven stages?

## Synthesis

The current ADRs support a conservative implementation path. ADR-0001 sets the broad product and architecture frame: Truthwatcher should remain a local-first, single-binary, PostgreSQL-backed evidence kernel with read-only discovery, raw evidence preservation, explicit uncertainty, human review, and boring operational deployment. ADR-0002 turns the next implementation concern into a concrete boundary: parser-derived identity clues must become evidence-backed candidates and reviewable decisions rather than silently mutating canonical asset identity.

The resulting implementation strategy should not begin with broad feature work. It should first map the existing Truthwatcher evidence-to-asset path, then persist identity candidates, then add reviewed resolution, then add narrow deterministic auto-acceptance, and only later define Mistspren-aligned handoff artifacts. This sequence keeps each milestone small and testable while protecting trust in canonical assets and graph relationships.

## Proposed Sequence

1. **Read-only identity lifecycle design skeleton.** Inspect Truthwatcher and document the current persistence, API, parser, graph, uncertainty, conflict, and audit touchpoints before changing code.
2. **Persist identity candidates.** Store parser-derived identity observations as evidence-backed candidates from fixture-backed parser output without canonical asset mutation.
3. **Add review and audit.** Route ambiguous matches, conflicts, proposed merges, and material canonical identity changes into a reviewable resolution model.
4. **Add safe auto-acceptance.** Define narrow, non-destructive auto-acceptance only after candidates and review boundaries are testable.
5. **Define Mistspren handoff.** Export or summarize reviewed identity decisions in a way that can enter the Mistspren pipeline without making Truthwatcher the durable decision authority.

## Traceability

- Roadmap workbench: [Truthwatcher Roadmap](../1-workbench/truthwatcher-roadmap.md)
- Architecture thread: [Truthwatcher Architecture Direction](truthwatcher-architecture-thread.md)
- Current-state workbench: [Truthwatcher Current State Workbench](../1-workbench/truthwatcher-current-state.md)
- Decision analysis: [Truthwatcher Decision Analysis 0002](../1-workbench/truthwatcher-decision-analysis-0002.md)
- ADR-0001: [Truthwatcher Initial Architecture Direction](../4-decisions/ADR-0001-truthwatcher-initial-architecture-direction.md)
- ADR-0002: [Reviewed Asset Identity Authority](../4-decisions/ADR-0002-reviewed-asset-identity.md)

## Conflicts and Tensions

No direct conflict exists between ADR-0001 and ADR-0002. ADR-0002 refines ADR-0001 by making reviewed asset identity the first implementation boundary. The main tension is procedural: Mistspren's README describes formal roadmap material as belonging under `5-roadmap/`, while the current task explicitly asks for a roadmap file under `1-workbench/`. The roadmap should therefore be treated as a workbench roadmap draft until a later roadmap agent or reviewer promotes formal execution items into `5-roadmap/`.

## Implementation Guardrails

- Do not write application code until the identity lifecycle has been mapped against the actual Truthwatcher implementation.
- Do not modify existing ADRs as part of the roadmap conversion.
- Do not let parser output directly overwrite canonical identity or merge assets.
- Do not expand scope into auth, source-of-truth export, graph databases, microservices, broad observability, chat-first UX, arbitrary command execution, or non-fake collector exposure.
- Prefer fixture-backed, deterministic, evidence-linked tests for each implementation milestone.

## Current Recommendation

The next action should be a Codex prompt in the Truthwatcher repository that performs read-only implementation analysis for ADR-0002. The prompt should inspect README, steering docs, migrations, parser, evidence, assets, graph, audit, and API paths, then produce a single Markdown analysis that separates observed facts from proposed implementation slices. This preserves Mistspren's staged method and prevents a premature jump from architectural decision to application code.
