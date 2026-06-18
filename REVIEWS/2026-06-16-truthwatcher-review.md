# Truthwatcher Decision Analysis 0002: Implementation Blocker

## Source Scope

- Primary workbench: [Truthwatcher Current State Workbench](../extracts/truthwatcher-current-state.md)
- Synthesis thread: [Truthwatcher Architecture Thread](../REVIEWS/2026-06-18-mistspren-simplification-audit.md)
- Prior decision: [ADR-0001: Truthwatcher Initial Architecture Direction](../DECISIONS/ADR-0001-truthwatcher-initial-architecture-direction.md)
- Analysis date: 2026-06-16
- Truthwatcher repository status: external and read-only for this Mistspren loop; no Truthwatcher code was modified.

## Question

What is the single most important architectural decision blocking implementation work on Truthwatcher?

## Short Answer

The blocking decision is the authority boundary for asset identity: Truthwatcher must decide whether parser-derived identity candidates can directly mutate canonical assets, or whether they must enter a human-reviewed identity resolution queue before becoming canonical inventory state.

This is narrower and more implementation-blocking than the general evidence-kernel direction from ADR-0001 because many next features depend on it: parser persistence, duplicate handling, conflict surfacing, graph relationship integrity, API/UI review behavior, source-of-truth bootstrap trust, and future integration/export safety.

## Evidence From Existing Mistspren Artifacts

### Current-state workbench signals

The current-state workbench identifies that:

- Raw discovery evidence is stored before parser-derived facts are created.
- Parser persistence is a separate step after raw evidence collection.
- Assets, facts, and relationships include uncertainty fields such as confidence, confidence reason, and state.
- Architecture seeds are planning context only, not observed proof.
- The recommended next investigation is the identity lifecycle and human review boundary before writing application code.
- A listed open question asks how provisional hostname/IP identities should be reconciled with stronger serial/vendor/system MAC identities.
- A listed risk warns that identity fragmentation may create duplicate device records unless merge/review is deliberately designed.

These points imply that implementation cannot safely proceed by simply “upserting devices” from each parser output. The repo direction already separates evidence from truth, but it does not yet settle who or what is allowed to promote conflicting identity claims into canonical assets.

### Architecture-thread signals

The architecture thread identifies identity merge automation as a central unresolved tension: automation reduces duplicate assets, but incorrect merges damage trust in the evidence model. It also states that the most valuable next prompt should be read-only analysis focused on the identity lifecycle and human approval model.

This makes identity authority the narrowest decision that both preserves the initial architecture direction and unblocks concrete design choices.

### ADR-0001 signals

ADR-0001 already decided the broad direction: Truthwatcher should remain an evidence-kernel-first, local-first, single-binary Go application backed by PostgreSQL, with raw evidence before derived truth, explicit uncertainty, and human review boundaries.

ADR-0002 should therefore not repeat that broad position. It should turn one unresolved boundary into an actionable implementation rule.

## Candidate Blocking Decisions Considered

### Candidate A: Authentication before any API/UI work

Authentication is important, especially before non-fake collectors become network-accessible. However, the current artifacts indicate local early workflows and fake fixture-backed discovery are acceptable while auth is absent. Auth blocks production exposure, not all implementation.

### Candidate B: PostgreSQL relational graph versus graph database

ADR-0001 already rejects an early separate graph database and commits to PostgreSQL-first graph modeling for the current kernel. This is not the immediate blocker.

### Candidate C: Mistspren versus Truthwatcher decision authority

The Mistspren/Truthwatcher boundary matters for long-term knowledge governance. However, Truthwatcher can still implement local evidence and review workflows while Mistspren remains the durable Markdown decision substrate. This boundary is important, but it does not block the core evidence-to-asset implementation as directly as identity authority.

### Candidate D: Collector approval model before live discovery

Approval is critical before broader live discovery. Yet fake and fixture-backed workflows can proceed without solving full live-discovery approval. Identity handling blocks both fake and live workflows because parser outputs must be reconciled into assets either way.

### Candidate E: Canonical asset identity and merge authority

This decision determines whether Truthwatcher treats parser-derived identities as direct canonical mutations or as candidates requiring review when evidence is ambiguous or conflicting. It affects schema shape, APIs, parser contracts, UI workflows, graph relationships, audit trails, and source-of-truth trust. It is the most important implementation blocker.

## Decision Recommendation

Create ADR-0002 to decide that Truthwatcher must use a human-reviewed identity resolution boundary for canonical asset mutation. Parser-derived evidence may create identity candidates and low-risk provisional records, but ambiguous matches, conflicts, merges, and canonical identity changes must be represented as reviewable resolution decisions rather than silently applied updates.

## Implementation Implications Without Writing Code

If accepted, future implementation work should be constrained as follows:

1. Preserve raw evidence and parser output separately from canonical asset identity.
2. Represent candidate identities explicitly, including source evidence, observed identifiers, confidence, and reasons.
3. Allow deterministic auto-acceptance only for narrowly defined, high-confidence cases that do not merge existing canonical assets or overwrite stronger identifiers.
4. Route ambiguous matches, conflicting identifiers, duplicate candidates, and proposed merges into a review queue or equivalent persisted review model.
5. Maintain auditability for who or what accepted an identity resolution.
6. Ensure graph relationships attach to identities in a way that can survive later canonical merge decisions without losing evidence traceability.
7. Defer broad source-of-truth export/import behavior until the identity review path is trustworthy.

## Non-Goals

- Do not choose a final database schema in this ADR.
- Do not design the full UI review experience in this ADR.
- Do not implement code in Truthwatcher.
- Do not decide authentication, live discovery approval, or external integration behavior except where those concerns depend on identity authority.

## Confidence

High. The available artifacts repeatedly identify identity lifecycle, duplicate risk, uncertainty handling, and human review as the next architectural concern. Among unresolved topics, identity authority is the one most directly blocking safe implementation of the evidence-to-asset path.
