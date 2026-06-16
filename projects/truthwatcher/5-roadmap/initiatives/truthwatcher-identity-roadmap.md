# Truthwatcher Roadmap

## Current Architectural Decisions

ADR-0001 establishes Truthwatcher as an evidence-kernel-first, local-first, single-binary Go application backed by PostgreSQL. The decision preserves read-only discovery, raw evidence before derived truth, relational graph modeling, explicit uncertainty, human review boundaries, and boring deployment. It explicitly defers microservices, a separate graph database, broad observability, chat-first UX, arbitrary command execution, source-of-truth replacement behavior, and production-like API/UI exposure until the evidence kernel, identity review, safety model, and approval boundaries are mature.

ADR-0002 narrows the next implementation boundary to canonical asset identity. Parser-derived observations must not silently merge canonical assets or overwrite stronger canonical identity attributes. Instead, parser outputs should produce evidence-backed identity candidates, provisional records, confidence signals, proposed matches, and reviewable resolution decisions when ambiguity, conflicts, merges, or material identity changes are involved. Deterministic auto-acceptance is allowed only for explicitly low-risk, evidence-backed, non-destructive cases that do not collapse existing canonical assets, discard stronger identifiers, or hide conflicting evidence.

No direct ADR conflict is visible in the current Mistspren records. ADR-0002 is a refinement of ADR-0001: it converts the broad evidence-before-truth and human-review direction into an implementation boundary for asset identity. This roadmap now lives in the Truthwatcher project roadmap area, `projects/truthwatcher/5-roadmap/initiatives/`, so it can be treated as a project-scoped initiative rather than a root-level or workbench artifact.

## Implementation Phases

### Phase 1: Identity lifecycle design skeleton

- **Goal:** Convert the reviewed identity boundary into a small, testable design slice without writing application code prematurely.
- **Deliverables:**
  - Read-only map of the current evidence-to-parser-to-asset path in Truthwatcher.
  - Inventory of existing schema/API/CLI/UI concepts related to assets, facts, relationships, parser warnings, provisional identities, conflicts, audit records, and review state.
  - Proposed minimal vocabulary for identity candidates, provisional assets, canonical assets, conflicts, and reviewed resolutions.
  - Acceptance criteria for what may be auto-accepted versus queued for review.
- **Out of scope:**
  - Application code changes.
  - Database migrations.
  - UI implementation.
  - Auth, live SSH expansion, source-of-truth export, graph database evaluation, or Mistspren sync automation.
- **Risks:**
  - The existing Truthwatcher implementation may already encode assumptions that bypass the reviewed identity boundary.
  - The design could become too broad if it tries to solve all asset modeling instead of only identity lifecycle.
  - Fixture data may be too thin to expose realistic duplicate or conflict cases.
- **Definition of done:**
  - A concise implementation thread or design note identifies current touchpoints, missing pieces, first schema/API candidates, and test fixtures needed for the first code slice.
  - The note clearly separates facts observed in the codebase from proposed design.
  - No Truthwatcher application code or ADRs are modified.

### Phase 2: Persist identity candidates from parser evidence

- **Goal:** Store parser-derived identity observations as evidence-backed candidates without treating them as canonical truth.
- **Deliverables:**
  - Minimal persistence model for identity candidates linked to raw evidence and parser output.
  - Deterministic candidate creation for fixture-backed parser runs.
  - Tests proving raw evidence remains durable and candidates reference their source evidence.
  - CLI or API inspection path for candidate records, if one already fits existing surfaces.
- **Out of scope:**
  - Human review UI.
  - Canonical asset merge automation.
  - External source-of-truth integration.
  - Non-fake collector exposure through UI/API.
- **Risks:**
  - Candidate storage could duplicate existing asset/fact records unless naming and ownership are clear.
  - Candidate records may accidentally look authoritative to existing graph or asset consumers.
  - Over-modeling confidence too early could slow the slice.
- **Definition of done:**
  - A fixture-backed parser run can produce inspectable identity candidates with evidence references.
  - Existing canonical assets are not silently merged or overwritten by those candidates.
  - Tests cover at least one normal candidate and one ambiguous or conflicting candidate case.

### Phase 3: Review queue and resolution audit

- **Goal:** Represent identity decisions as explicit reviewable records with audit metadata.
- **Deliverables:**
  - Minimal review queue for ambiguous matches, conflicts, proposed merges, and material canonical identity changes.
  - Resolution actions for accept, reject, defer, and request-more-evidence, scoped to the smallest useful workflow.
  - Audit metadata for actor, timestamp, source candidates, rationale, and resulting asset identity effect.
  - Tests for non-destructive resolution behavior.
- **Out of scope:**
  - Full UI polish.
  - Role-based access control.
  - Bulk review workflows.
  - Auto-remediation or network execution.
- **Risks:**
  - Review concepts may feel heavy before the app has enough data to justify them.
  - Poorly designed audit records may be hard to query later.
  - Accepting a resolution could still mutate too much canonical state if the action model is too broad.
- **Definition of done:**
  - Ambiguous identity candidates are queued rather than silently applied.
  - A reviewer can resolve one candidate or conflict through an existing interface surface.
  - The resolution is auditable and tied back to evidence.
  - Tests prove review is required for merge/conflict cases.

### Phase 4: Narrow deterministic auto-acceptance

- **Goal:** Add safe automation only after candidate persistence and review boundaries exist.
- **Deliverables:**
  - Explicit low-risk auto-acceptance rules.
  - Tests showing auto-acceptance is evidence-backed, non-destructive, and does not merge two existing canonical assets.
  - Conflict detection that prevents auto-acceptance when stronger identifiers disagree.
  - Operator-visible explanation for why a candidate was auto-accepted or queued.
- **Out of scope:**
  - Machine-learning identity scoring.
  - Broad deduplication sweeps.
  - Source-of-truth export.
  - Live discovery expansion.
- **Risks:**
  - Rules may be too conservative and produce excessive review volume.
  - Rules may be too permissive and recreate silent-merge risk.
  - Explanation text may lag behind implementation behavior.
- **Definition of done:**
  - Only explicitly allowed low-risk candidates are auto-accepted.
  - Existing canonical assets are never collapsed by auto-acceptance.
  - Queued versus auto-accepted behavior is covered by tests and documented examples.

### Phase 5: Mistspren-aligned operational handoff

- **Goal:** Connect Truthwatcher identity workflows to Mistspren's staged knowledge process without bypassing repository authority.
- **Deliverables:**
  - Minimal export or report format for evidence-backed identity decisions suitable for Mistspren intake or workbench review.
  - Documentation of which artifacts remain authoritative in Truthwatcher versus Mistspren.
  - Integrity checks for orphaned decisions, missing evidence references, or unresolved conflicts in exported summaries.
- **Out of scope:**
  - Bidirectional sync.
  - Automated ADR creation.
  - Truthwatcher becoming the authoritative decision store.
  - Full knowledge graph synchronization.
- **Risks:**
  - Boundary between app workflow state and Git-audited knowledge may blur.
  - Exported summaries could be mistaken for raw evidence.
  - Too much automation could violate the Mistspren pipeline.
- **Definition of done:**
  - Truthwatcher can produce a small, auditable identity-review summary that can enter Mistspren at the correct stage.
  - Documentation states that Mistspren remains authoritative for durable decisions and roadmap history.
  - No roadmap item lacks a decision reference.

## First Implementation Slice

The smallest useful thing to build first is **a read-only identity lifecycle design skeleton**: inspect the current Truthwatcher codebase and document exactly where parser-derived identifiers enter persistence, how assets/facts/relationships currently represent uncertainty, and where a reviewed identity candidate boundary should be inserted. This slice intentionally avoids code changes because ADR-0002 defines a new authority boundary that should be mapped before schema, API, or UI implementation begins.

The first code-bearing slice after that should be **persisting identity candidates from fixture-backed parser output without mutating canonical assets**. That is small, testable, aligned with ADR-0001 and ADR-0002, and creates a concrete substrate for later review queues.

## Next Codex Prompt

```text
You are operating inside the Truthwatcher repository.

README.md and the steering documents are authoritative. Do not write application code yet.

Read:
1. README.md
2. CONTRIBUTING.md
3. docs/api.md if present
4. steering-docs/*
5. migrations/*
6. internal/parser/*
7. internal/evidence/*
8. internal/assets/*
9. internal/graph/*
10. internal/audit/*
11. internal/api/* paths that expose discovery, parser persistence, assets, facts, relationships, or review-like state

Mission: produce a read-only identity lifecycle implementation analysis for ADR-0002.

Create a single Markdown file under the most appropriate planning/docs location in the Truthwatcher repo. Do not modify ADRs and do not change application code.

The analysis must include:
- Current evidence-to-parser-to-asset flow
- Current tables/types/API routes involved in raw evidence, parser output, assets, facts, relationships, uncertainty, conflicts, provisional state, and audit metadata
- Where parser-derived identity clues currently become persistent state
- Whether any current behavior risks silently mutating canonical asset identity
- Proposed minimal identity lifecycle vocabulary
- Proposed first implementation slice for persisted identity candidates
- Candidate tests for fixture-backed parser output
- Explicit non-goals
- Open questions and conflicts

Rules:
- Preserve raw evidence before derived truth.
- Do not introduce a graph database, microservices, source-of-truth export, broad observability, chat UX, or arbitrary command execution.
- Do not expose non-fake collectors through new API/UI flows.
- Prefer the smallest testable milestone.
- Clearly distinguish observed code facts from implementation proposals.
```
