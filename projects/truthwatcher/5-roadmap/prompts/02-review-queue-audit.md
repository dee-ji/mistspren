---
completion_marker: identity_candidate_reviews
required_adrs: ADR-0001, ADR-0002
action: Implement only the minimal identity candidate review queue and resolution audit.
summary: Persisted identity candidates have landed. The next implementation slice is a minimal review queue and resolution audit, without asset merges or canonical identity rewrites.
---
```text
You are operating inside the Truthwatcher repository.

README.md, CONTRIBUTING.md, steering-docs/*, docs/planning/identity-lifecycle-analysis.md, and the existing identity_candidates implementation are authoritative. ADR-0001 and ADR-0002 are accepted in Mistspren.

Mission: implement the next ADR-0002 slice: a minimal review queue and resolution audit for identity candidates.

Implement only the smallest testable slice:
- Expose pending identity candidates as a review queue using existing project patterns.
- Add explicit review state transitions for accept, reject, defer, and request-more-evidence where they fit the current model.
- Persist audit metadata for reviewer/action/timestamp/rationale/source candidate/resulting effect.
- Keep all resolution behavior non-destructive in this slice.
- Do not merge canonical assets.
- Do not rewrite assets.identity_key.
- Do not expose non-fake collectors or any new execution path.
- Add tests proving ambiguous/conflicting candidates are queued and review actions are auditable.

Acceptance criteria:
- Pending identity candidates can be listed as a review queue.
- Review decisions are auditable and tied back to candidate/evidence records.
- Accept/reject/defer actions do not merge assets or rewrite canonical identity.
```
