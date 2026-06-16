# ADR-0002: Human-Reviewed Identity Promotion

## Status

Proposed

## Date

2026-06-16

## Context

Truthwatcher is currently framed as an evidence-first network cartography kernel. The existing Mistspren artifacts emphasize raw evidence preservation before derived facts, explicit uncertainty, read-only and policy-gated discovery, fake fixture workflows, PostgreSQL-backed graph projections, and a conservative single-binary architecture.

The most repeated unresolved implementation tension is not whether Truthwatcher should collect evidence, parse facts, or store graph relationships. Those directions are already established by ADR-0001. The blocking question is when discovered observations become accepted asset identity.

Truthwatcher will see provisional identifiers such as hostnames, IP addresses, interface data, serial numbers, vendor details, system MACs, parser-derived facts, seeded planning context, and imported graph hints. Some will be partial, stale, duplicated, conflicting, or low confidence. If implementation begins without a promotion boundary, future code may accidentally treat parser output, imports, or seeds as canonical inventory.

## Supporting Threads

- [Truthwatcher Architecture Thread](../3-threads/truthwatcher-architecture-thread.md)

## Alternatives Considered

### Option A: Automatically merge identities when confidence is high

Truthwatcher could automatically merge discovered records into canonical assets when parser confidence or identifier strength crosses a threshold.

Pros:

- Reduces manual review work.
- Makes the product feel useful sooner.
- Simplifies early UI flows by showing one apparent asset record.

Cons:

- Incorrect merges damage trust in the evidence model.
- Confidence thresholds can hide parser, seed, import, or stale-evidence mistakes.
- Rollback and audit requirements become harder once canonical identity has been mutated automatically.
- It conflicts with the current emphasis on explicit uncertainty and human review boundaries.

### Option B: Never merge identities; keep every observation separate

Truthwatcher could avoid canonical identity entirely and expose only evidence records plus parser-derived observations.

Pros:

- Maximizes evidence preservation.
- Avoids false merges.
- Keeps early implementation simple in the parser and persistence path.

Cons:

- Produces duplicate apparent devices and fragmented topology.
- Makes graph navigation and source-of-truth bootstrap workflows much less useful.
- Pushes identity reconciliation work onto every downstream consumer.
- Does not provide a practical path from evidence to operational knowledge.

### Option C: Stage identity candidates and require human-reviewed promotion

Truthwatcher can preserve raw evidence and parser-derived observations, generate identity candidates and conflicts, and require explicit human review before promoting any candidate into accepted canonical asset identity.

Pros:

- Preserves evidence-first behavior while still allowing useful inventory convergence.
- Makes uncertainty, conflicts, parser warnings, and evidence references visible before acceptance.
- Creates a clear implementation boundary for API, UI, audit, export, and Mistspren handoff work.
- Allows safe fixture-backed implementation before non-fake collectors or broad auth are expanded.

Cons:

- Adds review workflow complexity.
- Slows fully automated inventory convergence.
- Requires careful modeling of candidate state, acceptance events, and superseded identities.

## Decision

Truthwatcher should use a human-reviewed identity promotion boundary.

Discovery, parsing, seeding, and import flows may create evidence records, observations, provisional identities, candidate matches, and conflict records. They must not silently promote or merge those records into accepted canonical asset identity.

Canonical asset identity should change only through an explicit reviewed promotion action that records the evidence considered, the reviewer or initiator available at that stage, the accepted identity fields, any rejected candidates or conflicts, and the uncertainty that remains.

## Rationale

This is the smallest decision that unlocks safe implementation without violating the architectural direction already recorded in ADR-0001. It answers the question most likely to affect many future code paths: whether Truthwatcher is allowed to turn observations into truth automatically.

A reviewed promotion boundary keeps Truthwatcher useful as a cartography workflow while protecting its evidence model. It also preserves Mistspren alignment: operational workflows can stage and review candidates, while durable decisions and knowledge promotion remain explicit and auditable.

## Expected Outcome

Near-term implementation should focus on:

- Representing provisional identity candidates separately from accepted canonical asset identity.
- Preserving evidence references and parser warnings through the review flow.
- Surfacing conflicts and duplicate candidates before merge or acceptance.
- Recording reviewed promotion events in an audit-friendly form.
- Keeping fixture-backed and local workflows useful while broader auth and non-fake collector exposure remain constrained.

## Risks

- Review queues may become noisy if candidate generation is too aggressive.
- Human reviewers may rubber-stamp promotions unless the UI makes uncertainty and evidence clear.
- The first model may be too conservative and slow down source-of-truth bootstrap workflows.
- If authentication remains absent, reviewed promotion actions must remain local/constrained and should not be exposed as production API behavior.

## Review Trigger

Review this decision when one of the following occurs:

- Truthwatcher exposes non-fake discovery or identity promotion through a network-accessible API/UI.
- A source-of-truth export or sync feature is proposed.
- Parser coverage becomes strong enough that automatic promotion thresholds are proposed again.
- Operational use shows that manual review volume prevents useful inventory convergence.
