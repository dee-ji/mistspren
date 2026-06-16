# ADR-0002: Reviewed Asset Identity Authority

## Status

Proposed

## Date

2026-06-16

## Context

Truthwatcher is being treated as an evidence-kernel-first, local-first, single-binary Go application backed by PostgreSQL. ADR-0001 established that raw evidence must come before derived truth, uncertainty must remain explicit, and human review boundaries are part of the architecture.

The next implementation blocker is narrower: parser outputs can observe hostnames, IP addresses, MAC addresses, serial numbers, vendors, platforms, interfaces, neighbors, and other identity clues. Those clues may be incomplete, stale, duplicated, or contradictory. If implementation work lets parser-derived claims directly overwrite or merge canonical assets, Truthwatcher can quickly lose trust: duplicate devices may proliferate, unrelated devices may be incorrectly merged, and graph relationships may attach to unstable identities.

The existing Mistspren artifacts repeatedly identify identity lifecycle, provisional identities, conflicts, merge candidates, and human review as the next area to resolve before application code is proposed.

## Supporting Threads

- [Truthwatcher Architecture Thread](../3-threads/truthwatcher-architecture-thread.md)
- [Truthwatcher Decision Analysis 0002](../1-workbench/truthwatcher-decision-analysis-0002.md)
- [Truthwatcher Current State Workbench](../1-workbench/truthwatcher-current-state.md)

## Alternatives Considered

### Option A: Parser outputs directly upsert canonical assets

Parser persistence would immediately create or update canonical assets using the best identifiers available in each discovery result.

Pros:

- Simple implementation path.
- Fast feedback in early demos.
- Fewer workflow concepts for users to understand.

Cons:

- High risk of duplicate or incorrectly merged devices.
- Weak boundary between observed evidence and accepted inventory truth.
- Hard to explain or reverse mistaken identity changes after relationships are attached.
- Conflicts with the project direction of explicit uncertainty and human review.

### Option B: Fully manual asset creation only

Truthwatcher would store evidence and parser output, but humans would create every canonical asset manually.

Pros:

- Strong human control.
- Very low risk of silent incorrect merges.
- Clear distinction between observed evidence and accepted assets.

Cons:

- Too slow for network cartography and source-of-truth bootstrap workflows.
- Fails to benefit from high-confidence identifiers that can be safely proposed or accepted.
- Makes parser persistence less useful.

### Option C: Reviewed identity resolution boundary

Parser outputs create evidence-backed identity candidates and may create low-risk provisional records, but ambiguous matches, conflicts, merges, and canonical identity changes require an explicit reviewed identity resolution step.

Pros:

- Preserves evidence before truth.
- Supports useful automation without making uncertain identity changes silently authoritative.
- Gives UI/API/CLI implementation a concrete boundary for review queues, audit records, and conflict handling.
- Protects future graph relationships and source-of-truth export behavior from unstable identity assumptions.

Cons:

- Requires more product and data-model work than direct upserts.
- Early workflows need review concepts before they feel fully automated.
- Requires careful criteria for what can be auto-accepted versus queued for review.

## Decision

Adopt a reviewed identity resolution boundary for Truthwatcher canonical assets.

Parser-derived observations must not silently merge canonical assets or overwrite stronger canonical identity attributes. Parser and discovery workflows may produce evidence-backed identity candidates, provisional records, confidence scores, and proposed matches. Canonical identity merges, ambiguous matches, conflicting identifiers, and changes that would materially alter an existing asset’s identity must be represented as reviewable identity resolution decisions with evidence references and audit metadata.

Narrow deterministic auto-acceptance is allowed only for cases that are explicitly defined as low risk, evidence-backed, and non-destructive. Auto-acceptance must not collapse two existing canonical assets into one, discard stronger identifiers, or hide conflicting evidence.

## Rationale

This is the smallest decision that unblocks safe implementation while preserving ADR-0001. Truthwatcher’s value depends on users trusting that canonical assets and graph relationships are traceable to evidence. Identity is the point where raw observations become inventory-like truth; if that boundary is wrong, later features inherit unstable assumptions.

A reviewed identity boundary allows implementation to proceed on parser persistence, asset APIs, graph relationship handling, and UI review flows without pretending that every observed hostname, IP address, or serial number is immediately authoritative. It also gives future source-of-truth bootstrap and export workflows a safer foundation.

## Expected Outcome

Future implementation work should model identity as a lifecycle rather than a direct parser upsert:

- raw evidence remains durable and separate from canonical truth;
- parsed identifiers become evidence-backed candidates;
- confidence and conflict state are visible;
- safe provisional records are possible;
- risky merges and canonical identity changes become reviewed decisions;
- graph relationships remain traceable to evidence even when canonical identity changes later.

## Risks

- Review queues could slow early user workflows if too many cases require manual review.
- Overly conservative matching rules could create excessive provisional duplicates.
- Overly permissive auto-acceptance rules could recreate the silent-merge risk this decision is intended to avoid.
- The boundary may need refinement after real fixture and lab data reveal common identity patterns.

## Review Trigger

Revisit this decision when Truthwatcher has implemented at least one end-to-end evidence-to-asset workflow with persisted parser output and reviewed identity resolution, or when real lab discovery shows that the proposed review boundary creates unacceptable duplicate volume or operator friction.
