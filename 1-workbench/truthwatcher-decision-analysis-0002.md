# Truthwatcher Decision Analysis 0002: Implementation Blocker

## Question

Using the current Mistspren artifacts about Truthwatcher, what is the single most important architectural decision blocking implementation?

## Inputs Reviewed

- `1-workbench/truthwatcher-current-state.md`
- `3-threads/truthwatcher-architecture-thread.md`
- `4-decisions/ADR-0001-truthwatcher-initial-architecture-direction.md`
- `README.md` for Mistspren stage and decision rules

No Truthwatcher application code was modified.

## Candidate Blocking Decisions

### 1. Human-reviewed identity acceptance boundary

Truthwatcher stores raw evidence before parser-derived facts and represents uncertainty through confidence, state, and evidence references. The current artifacts repeatedly identify identity fragmentation, merge review, parser warnings, and human approval as the next unresolved architecture area.

This blocks implementation because many tempting next features depend on whether Truthwatcher may automatically promote discovered observations into canonical asset identity or must first stage them for review. Without that boundary, implementation choices for schemas, APIs, UI queues, audit records, parser persistence, exports, and Mistspren handoff can all drift in incompatible directions.

### 2. Authentication and authorization model

The current API lacks authentication, and broader API/UI execution surfaces are risky before auth exists. This is important, but the current artifacts still allow constrained local and fake-collector workflows while auth remains deferred. Auth becomes the primary blocker before exposing non-local or non-fake execution surfaces, not before every implementation step.

### 3. Mistspren/Truthwatcher source-of-truth boundary

Mistspren remains the durable Git-auditable knowledge substrate, while Truthwatcher should act as workflow/interface/automation. This is important for integration work, but it is less immediately blocking for the core evidence kernel than deciding how discovered identities become accepted operational knowledge.

### 4. PostgreSQL relational graph versus graph database

ADR-0001 already selected PostgreSQL-first relational graph modeling for the near term. This is not the current blocker unless topology requirements exceed relational projections.

## Selected Blocker

The most important architectural decision blocking implementation is the promotion boundary between discovered evidence and accepted asset identity:

> Truthwatcher must not automatically merge or canonize discovered asset identities. It should stage identity candidates and conflicts for human-reviewed acceptance, while preserving raw evidence and uncertainty.

## Why This Is the Single Most Important Blocker

- It protects Truthwatcher's core promise: evidence before truth.
- It prevents unsafe automation from turning parser output, seeds, imports, or partial observations into authoritative inventory.
- It determines the shape of near-term implementation across data model, API, UI, audit, parser persistence, export, and Mistspren handoff.
- It gives developers a safe implementation path that remains useful without requiring broad auth, integrations, graph database adoption, or production deployment decisions first.
- It aligns with ADR-0001's direction to focus on evidence traceability, identity review, safety boundaries, and approval before new application features.

## Decision Record Produced

- `4-decisions/ADR-0002-human-reviewed-identity-promotion.md`
