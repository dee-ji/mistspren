# Truthwatcher Memory

This folder is Mistspren's durable memory for Truthwatcher architecture and planning. It should answer three questions for a human reader:

1. What do we currently believe about Truthwatcher?
2. Which architecture decisions are proposed, accepted, rejected, or superseded?
3. What implementation direction should Truthwatcher take next?

## Current State

Truthwatcher is currently treated as an evidence-first network cartography kernel: local-first, single-binary Go, PostgreSQL-backed, read-only by default, and centered on raw evidence before derived truth.

The current recommendation is to resolve the asset identity lifecycle before broader feature work. Parser-derived identity clues should become evidence-backed candidates and reviewed resolutions, not silent mutations of canonical assets.

## Read In This Order

1. [Current State Workbench](1-workbench/extracts/truthwatcher-current-state.md)
2. [Architecture Thread](3-threads/architecture/truthwatcher-architecture-thread.md)
3. [ADR-0001: Initial Architecture Direction](4-decisions/proposed/ADR-0001-truthwatcher-initial-architecture-direction.md)
4. [Decision Analysis 0002](1-workbench/claim-maps/truthwatcher-decision-analysis-0002.md)
5. [ADR-0002: Reviewed Asset Identity Authority](4-decisions/proposed/ADR-0002-reviewed-asset-identity.md)
6. [Implementation Thread](3-threads/implementation/truthwatcher-implementation-thread.md)
7. [Identity Roadmap](5-roadmap/initiatives/truthwatcher-identity-roadmap.md)

## Durable Versus Local

Commit curated memory:

- named workbench analyses;
- claim maps that support decisions;
- synthesis threads;
- ADRs;
- roadmap initiatives, milestones, and tasks that link back to ADRs;
- friction records that capture real conflicts.

Do not commit local generated workflow output by default:

- timestamped Truthwatcher review snapshots;
- decision review queues;
- next-action scratch files;
- run reports;
- integrity reports;
- logs;
- `.mistspren/` state.

Generated output belongs under `.mistspren/review/` unless a human rewrites it into a durable artifact with a stable name and clear purpose.

## Current Human Action

Review ADR-0002. If the reviewed identity lifecycle boundary is correct, move it from `4-decisions/proposed/` to `4-decisions/accepted/` and change its status to `Accepted`.

After ADR-0002 is accepted, the next Truthwatcher action is the read-only identity lifecycle implementation analysis described in [Identity Roadmap](5-roadmap/initiatives/truthwatcher-identity-roadmap.md).
