---
completion_marker: identity_candidates
required_adrs: ADR-0001, ADR-0002
action: Implement only persisted identity candidates from parser evidence.
summary: ADR-0001 and ADR-0002 are accepted. The next implementation slice is persisted parser-derived identity candidates with evidence references, without merging or rewriting canonical assets.
---
```text
You are operating inside the Truthwatcher repository.

README.md, CONTRIBUTING.md, steering-docs/*, and docs/planning/identity-lifecycle-analysis.md are authoritative. ADR-0001 and ADR-0002 are accepted in Mistspren.

Mission: implement the first code-bearing ADR-0002 slice: persisted identity candidates from parser evidence.

Implement only the smallest testable slice:
- Add an identity_candidates persistence model.
- Store parser-derived identity candidates linked to discovery_run_id, evidence_id, parser_name, asset_type, candidate_identity_key, identity attributes, strength, confidence, reason, review_state, metadata, and created_at.
- Preserve current raw evidence, parser result, asset, fact, and relationship behavior for this slice.
- Do not merge assets.
- Do not rewrite assets.identity_key.
- Do not add identity approval/rejection workflows yet.
- Do not expose non-fake collectors or any new execution path.
- Add a read-only inspection path for identity candidates using the existing project style, preferably API and/or CLI only if it fits current surfaces.
- Add fixture-backed tests proving candidates are persisted and deduplicated without mutating canonical assets.

Acceptance criteria:
- A parser run can persist identity candidates with evidence references.
- Hostname/name candidates are pending or provisional, not silently authoritative.
- Strong vendor+serial or system-MAC candidates are represented as strong candidates.
- Re-running parse for the same evidence/parser/candidate key does not duplicate candidates.
- Existing canonical assets are not merged, overwritten, or identity-rewritten by candidate persistence.
```
