# Thread: Truthwatcher Architecture Direction

## Question

What does the current Truthwatcher repository imply about the safest initial architecture direction for future Mistspren-guided work?

## Concise Synthesis

Truthwatcher is currently best understood as an evidence-first network cartography kernel, not a general automation, observability, chat, or source-of-truth replacement product. Its architecture is intentionally conservative: single Go binary, CLI/API/embedded UI, embedded migrations, PostgreSQL, read-only discovery boundaries, fake fixture workflows, parser-derived facts, and relational graph projections.

The first useful Mistspren loop should therefore preserve the boring kernel and focus future investigation on identity resolution, human review, safety boundaries, and evidence traceability rather than new application features.

## Major Architectural Themes

### Evidence before truth

Truthwatcher’s dominant theme is that raw evidence must be stored before assets, facts, relationships, or graph views claim knowledge. Parser persistence is intentionally separate from discovery execution so raw evidence survives even when parsing is incomplete or warning-prone.

### Read-only safety model

Discovery is constrained by built-in safe profiles, dangerous command denial, fake fixture workflows, collector boundaries, and policy checks. This argues for approval and audit design before expanded execution.

### Boring deployment and storage

The current kernel favors a single Go binary with embedded UI assets and migrations backed by PostgreSQL. A separate graph database, Kubernetes-first deployment, or microservice split would be premature relative to the documented direction.

### Explicit uncertainty

Assets, facts, relationships, seeded architecture hints, imported graph data, provisional identities, and conflicts all need explicit state and confidence handling. This should remain a first-class architecture concern.

### Mistspren/Truthwatcher separation of concerns

Mistspren should remain the durable, Git-auditable knowledge and decision substrate. Truthwatcher should remain the workflow/interface/automation layer that can feed staged Mistspren artifacts without bypassing evidence, synthesis, and decision rules.

## Unresolved Tensions

- Truthwatcher needs useful workflows, but early usefulness must not collapse into unsafe network execution.
- Architecture seeds and imports can guide planning, but they must not become proof.
- PostgreSQL-first graph modeling is operationally simple, but future topology questions may stress relational projections.
- Identity merge automation could reduce duplicate assets, but incorrect merges would damage trust in the evidence model.
- Mistspren and Truthwatcher both discuss decisions and architecture; the authoritative boundary between app steering docs and Mistspren decision records needs explicit rules.
- Lack of authentication is compatible with local early development, but conflicts with any broader API/UI execution surface.

## References

- Workbench: [Truthwatcher Current State Workbench](../1-workbench/truthwatcher-current-state.md)
- Decision: [ADR-0001: Truthwatcher Initial Architecture Direction](../4-decisions/ADR-0001-truthwatcher-initial-architecture-direction.md)

## Current Interpretation

The current evidence supports a conservative architecture direction: continue treating Truthwatcher as a safe, local-first evidence kernel and investigate identity/review/safety questions before proposing application code. The most valuable next Codex prompt should be a read-only analysis prompt focused on Truthwatcher’s identity lifecycle and human approval model.
