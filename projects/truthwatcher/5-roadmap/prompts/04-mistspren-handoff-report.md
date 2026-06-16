---
completion_marker: identity review handoff
required_adrs: ADR-0001, ADR-0002
action: Implement only a minimal Mistspren-aligned identity-review handoff report.
summary: Truthwatcher now has persisted identity candidates, review/audit, and deterministic auto-acceptance. The next implementation slice is a read-only Mistspren-aligned handoff report.
---
```text
You are operating inside the Truthwatcher repository.

README.md, CONTRIBUTING.md, steering-docs/*, docs/planning/identity-lifecycle-analysis.md, and the identity candidate/review/auto-acceptance implementation are authoritative. ADR-0001 and ADR-0002 are accepted in Mistspren.

Mission: implement the next ADR-0002 slice: a minimal Mistspren-aligned identity-review handoff report.

Implement only the smallest testable slice:
- Add a read-only export/report path for reviewed identity decisions and auto-accepted identity candidates.
- Include evidence references, parser/source metadata, review state, rationale/explanation, timestamps, and any resulting non-destructive identity effect.
- Make the report suitable for Mistspren intake/workbench review, not as an accepted ADR or authoritative Mistspren decision.
- Clearly label exported summaries as derived review output, not raw evidence.
- Add integrity-style checks or tests for missing evidence references, orphaned reviews, and unresolved conflicts where practical.
- Do not implement bidirectional sync.
- Do not make Truthwatcher the durable decision store.
- Do not merge assets or rewrite canonical identity.

Acceptance criteria:
- A user can generate or retrieve a concise identity-review handoff summary.
- Summary entries link back to evidence and candidate/review records.
- Exported summaries distinguish observed evidence, parser-derived candidates, review decisions, and auto-acceptance explanations.
- The implementation does not write into Mistspren directly.
```
