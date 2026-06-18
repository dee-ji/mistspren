# Truthwatcher Risks

## Current high-priority risks

### Identity fragmentation and unsafe merges

Parser-derived hostnames, IPs, MAC addresses, serial numbers, and platform hints may be incomplete or contradictory. Truthwatcher should not silently merge canonical assets or overwrite stronger identifiers from weak parser output. ADR-0002 requires evidence-backed identity candidates and reviewed resolution for ambiguous identity changes.

### Production exposure before safety controls

Truthwatcher currently fits local, fixture-backed, read-only workflows best. Authentication, broader live discovery approvals, and audit boundaries should be settled before expanding API/UI execution surfaces beyond constrained local use.

### Evidence/truth boundary erosion

If derived parser state, imported data, or planning hints are treated as observed proof, the system loses its core value. Raw evidence, parser candidates, reviewed facts, and durable architecture decisions must remain visibly separate.

### Mistspren/Truthwatcher coupling

Mistspren may inspect Truthwatcher and record decisions, but Truthwatcher must not depend on Mistspren at runtime. Any future handoff should be export/report based, not a runtime dependency or bidirectional sync.

## Watch list

- PostgreSQL-first graph modeling may need careful projection and query design as topology complexity grows.
- Review workflow concepts may feel heavy until fixture data demonstrates practical value.
- Roadmap prompts can become stale unless each review loop updates `NEXT_ACTIONS.md`.
