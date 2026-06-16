# Truthwatcher Current State Workbench

## Source Scope

- External repository inspected read-only: <https://github.com/dee-ji/truthwatcher>
- Mistspren workflow authority: `README.md`
- Inspection date: 2026-06-16
- Note: direct `git clone` from this environment failed with `CONNECT tunnel failed, response 403`, so this loop used GitHub web/raw/API views and did not modify Truthwatcher.

## What Truthwatcher Currently Is

Truthwatcher is an early-stage, Go-based, single-binary, evidence-first network cartography platform for service-provider-style environments. Its stated purpose is to collect safe read-only discovery evidence, store raw outputs before deriving facts, model assets and relationships, and expose the resulting knowledge through a CLI, HTTP API, and embedded UI.

Current positioning from the repository README:

- Read-only network evidence engine.
- Source-of-truth bootstrap tool.
- Relational network graph model backed by PostgreSQL.
- Single Go binary with embedded migrations and embedded UI assets.
- CLI and HTTP server for local, inspectable workflows.
- Foundation for safe discovery planning and future adapters.

Truthwatcher explicitly is not currently positioned as a monitoring/alerting platform, configuration deployment tool, Kubernetes/Docker-first application, NetBox/Nautobot replacement, chat-first AI app, or arbitrary network command runner.

## Current Repo Structure

Observed top-level structure from GitHub:

```text
truthwatcher/
├── .idea/
├── cmd/truthwatcher/
├── docs/
├── examples/
├── internal/
├── migrations/
├── prompts/
├── steering-docs/
├── web/
├── .gitignore
├── CONTRIBUTING.md
├── LICENSE
├── Makefile
├── README.md
├── go.mod
└── go.sum
```

Observed internal package structure:

```text
internal/
├── agent/
├── api/
├── app/
├── assets/
├── audit/
├── config/
├── db/
├── discovery/
├── evidence/
├── extensibility/
├── graph/
├── logging/
├── parser/
├── planner/
├── policy/
└── seeding/
```

## Existing Language and Framework Choices

- Primary language: Go.
- Module name: `truthwatcher`.
- Go version declared in `go.mod`: `1.26`.
- Direct dependencies observed in `go.mod`:
  - `github.com/lib/pq` for PostgreSQL driver support.
  - `golang.org/x/crypto`.
- Indirect dependency observed:
  - `golang.org/x/sys`.
- Database: PostgreSQL only for the current kernel.
- UI: embedded static frontend assets under `web/`; GitHub language breakdown shows JavaScript and CSS in addition to Go.
- Build/test orchestration: Makefile targets include `fmt`, `test`, `lint`, `build-ui`, `build`, `release-local`, and `run`.
- Architecture style: single binary with CLI commands, HTTP API, embedded UI, embedded migrations, and PostgreSQL.

## Architecture Assumptions

Facts from inspected materials:

- Raw discovery evidence is stored before parser-derived facts are created.
- Discovery is designed to be read-only and policy-gated.
- Fake fixture-backed discovery is supported for local workflows without touching a network.
- Parser persistence is a separate step after raw evidence collection.
- Assets, facts, and relationships include uncertainty fields such as confidence, confidence reason, and state.
- Graph relationships are modeled in relational tables first; no separate graph database is part of the current kernel.
- Architecture seeds are planning context only, not observed proof.
- Discovery plans require approval and are not executable approvals.

Inferences that should be validated before implementation:

- The core product boundary is still the evidence kernel rather than integrations, observability, or agent automation.
- PostgreSQL is intended to remain the durable system of record for both relational asset data and graph-like projections through the near-term roadmap.
- The safest next architectural work should improve evidence traceability, identity resolution, review workflows, and planner boundaries before expanding command execution or integrations.

## Known Constraints

- Truthwatcher repo is external and read-only for this Mistspren loop.
- Mistspren README requires staged, evidence-driven knowledge flow and warns against jumping directly from raw information to implementation.
- Truthwatcher is GPL-3.0-or-later licensed.
- No Docker, Kubernetes, Helm, or microservice-first architecture is intended for the current kernel.
- No authentication exists yet for discovery APIs according to `docs/api.md`; audit metadata identifies the initiator as `api` until auth exists.
- Discovery execution endpoint is intentionally constrained to the fake collector, fixture targets, built-in profiles, and explicitly provided tasks in the documented API.
- Optional SSH collection exists behind collector and policy boundaries, but the current safe workflow remains strongly read-only.
- Imported JSON does not persist records or treat imported data as observed proof in the documented flow.

## Open Questions

- What exact production target is most important first: lab fixture workflows, a single real seed device, source-of-truth bootstrap, or Mistspren capture/review integration?
- How should human approval for discovery execution be represented: CLI prompt, API review record, UI workflow, or persisted approval model?
- What identity merge workflow should reconcile provisional hostname/IP identities with stronger serial/vendor/system MAC identities?
- What authentication and authorization model is appropriate before any non-fake collector is exposed through API/UI workflows?
- What is the minimum useful Mistspren integration contract: direct Markdown writing, export snapshots, review queue handoff, or only evidence references?
- Should architecture decisions continue to live inside Truthwatcher `steering-docs/`, in Mistspren `4-decisions/`, or be mirrored with explicit source-of-truth rules?
- What level of parser coverage is needed before the evidence kernel can be considered v0.1 complete?
- How should conflicts and stale evidence be surfaced operationally without becoming a full observability platform?

## Risks

- Scope drift from evidence kernel into chat, automation, observability, or integrations before safety and identity-review foundations are mature.
- Treating seeded/imported/user-provided context as proof rather than low-confidence planning context.
- Premature graph database or microservice adoption could conflict with the stated boring single-binary/PostgreSQL architecture.
- Lack of authentication is acceptable for local early workflows but risky if API/UI execution paths become network-accessible.
- Identity fragmentation may create duplicate device records unless the merge/review workflow is designed deliberately.
- Parser warnings or partial parses could be mistaken for authoritative truth unless UI/API surfaces uncertainty clearly.
- Mistspren/Truthwatcher responsibility overlap may blur whether Git or the app is authoritative for decisions and durable knowledge.

## Recommended Next Investigation

Investigate the identity lifecycle and human review boundary before writing application code:

1. Read Truthwatcher steering docs for project constitution, safety model, MVP spec, data model, and architecture decisions.
2. Map the current evidence-to-asset lifecycle from fake discovery through parser persistence into assets/facts/relationships.
3. Identify where provisional identities, conflicts, parser warnings, and merge candidates are represented today.
4. Draft a small Mistspren follow-up workbench focused only on identity merge/review and approval workflow options.
5. Only after that, consider a bounded Truthwatcher prompt for one reviewed workflow or one documentation clarification.
