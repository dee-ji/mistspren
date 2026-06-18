# ADR-0001: Truthwatcher Initial Architecture Direction

## Status

Accepted

## Date

2026-06-16

## Context

Truthwatcher is an external, early-stage project intended to be a Go-based, single-binary, evidence-first network cartography platform for service-provider-style environments. Its current kernel emphasizes safe read-only discovery, raw evidence preservation, parser-derived assets/facts/relationships, PostgreSQL-backed graph modeling, deterministic planning, and an embedded UI/API/CLI workflow.

Mistspren is the durable knowledge substrate and requires staged movement from evidence to workbench analysis, synthesis, and decisions. This first loop inspected Truthwatcher read-only and did not modify application code.

## Supporting Threads

- [Truthwatcher Architecture Thread](../REVIEWS/2026-06-18-mistspren-simplification-audit.md)

## Decision

For the initial Mistspren architecture direction, treat Truthwatcher as an evidence-kernel-first, local-first, single-binary Go application backed by PostgreSQL. Near-term architectural attention should preserve the existing constraints: read-only discovery, raw evidence before derived truth, relational graph modeling, explicit uncertainty states, human review boundaries, and boring operational deployment.

Do not steer Truthwatcher toward microservices, a separate graph database, broad observability, chat-first UX, arbitrary command execution, or source-of-truth replacement behavior until the evidence kernel, identity review, safety model, and approval boundaries are demonstrably mature.

## Consequences

Positive consequences:

- Reinforces Truthwatcher’s strongest current design principle: evidence before inventory and automation.
- Keeps the implementation surface small and reviewable.
- Maintains alignment between Truthwatcher and Mistspren: operational workflows can be app-driven while durable decisions and knowledge remain Git-auditable.
- Reduces safety risk by prioritizing review, traceability, and policy boundaries before broader execution.
- Avoids premature infrastructure complexity.

Negative consequences and tradeoffs:

- Some attractive features, such as integrations, observability overlays, agentic execution, and service-aware modeling, remain deferred.
- PostgreSQL-first graph modeling may require careful query and projection design as relationship complexity grows.
- Human review workflows may slow perceived velocity compared with fully automated discovery or merge behavior.
- Without early auth work, local API/UI workflows must remain constrained and treated as non-production surfaces.

## Alternatives Considered

### Alternative A: Push immediately toward integrations and source-of-truth export

This could make Truthwatcher useful sooner for NetBox/Nautobot-style workflows. It was not selected because the current evidence kernel, identity lifecycle, and proof boundaries should be stable before exporting or syncing derived knowledge elsewhere.

### Alternative B: Introduce a graph database early

A graph database could model topology naturally. It was not selected because Truthwatcher explicitly states PostgreSQL is the only database in the current kernel and graph relationships are relational first. Adding another database now would increase operational complexity before the relational model is exhausted.

### Alternative C: Make the agent/chat interface the primary product surface

A chat-first UX could be compelling. It was not selected because Truthwatcher explicitly is not a chat-first AI application, and agentic features should remain constrained to planning and review until safety and audit paths are mature.

### Alternative D: Optimize for live network discovery immediately

Live SSH discovery may be important eventually. It was not selected as the immediate architectural emphasis because fixture-backed, policy-gated, evidence-preserving workflows are safer for hardening parser, identity, and review behavior first.

## Follow-up Actions

- Create a focused workbench on Truthwatcher identity lifecycle and merge/review workflows.
- Inspect the steering documents in the external Truthwatcher repository before proposing any implementation prompt.
- Map the current evidence-to-asset path, including parser warnings, conflict states, and evidence references.
- Define the minimum human approval model needed before any non-fake collector is exposed through API/UI flows.
- Clarify how Truthwatcher should write to or reference Mistspren without bypassing Mistspren stage rules.
