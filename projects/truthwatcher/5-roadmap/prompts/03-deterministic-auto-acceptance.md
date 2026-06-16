---
completion_marker: identity_candidate_auto_acceptance
required_adrs: ADR-0001, ADR-0002
action: Implement only narrow deterministic auto-acceptance for low-risk identity candidates.
summary: Truthwatcher now has persisted identity candidates plus a minimal review/audit path. The next implementation slice is narrow deterministic auto-acceptance for low-risk candidates.
---
```text
You are operating inside the Truthwatcher repository.

README.md, CONTRIBUTING.md, steering-docs/*, docs/planning/identity-lifecycle-analysis.md, and the existing identity_candidates / identity_candidate_reviews implementation are authoritative. ADR-0001 and ADR-0002 are accepted in Mistspren.

Mission: implement the next ADR-0002 slice: narrow deterministic auto-acceptance for low-risk identity candidates.

Implement only the smallest testable slice:
- Add explicit auto-acceptance rules for evidence-backed, non-destructive identity candidates.
- Auto-accept only candidates that are strong, have no plausible conflict, and do not collapse or rewrite existing canonical assets.
- Preserve pending review for hostname/name/weak/provisional/ambiguous/conflicting candidates.
- Record an auditable auto-acceptance decision using the existing review/audit path.
- Expose operator-visible explanation for why a candidate was auto-accepted or queued.
- Do not merge canonical assets.
- Do not rewrite assets.identity_key.
- Do not discard stronger identifiers or hide conflicting evidence.

Acceptance criteria:
- Strong vendor+serial or system-MAC candidates with no plausible conflict can be auto-accepted.
- Hostname/name/provisional candidates remain queued for review.
- Any candidate that conflicts with an existing canonical asset or stronger identifier remains queued.
- Auto-acceptance creates auditable review metadata.
```
