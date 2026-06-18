# Next Actions

1. Run a fresh read-only Truthwatcher review with `TRUTHWATCHER_HOME=~/GolandProjects/truthwatcher ./scripts/run-review.sh`.
2. Check whether Truthwatcher has implemented persisted identity candidates, review/audit, or auto-acceptance since ADR-0002.
3. If identity candidates are not implemented, use `PROMPTS/agentic-loop.md` to generate the next Truthwatcher Codex prompt for the smallest persisted-candidate slice.
4. Update `RISKS/truthwatcher-risks.md` if the review finds unsafe identity mutation, auth exposure, missing evidence references, or stale roadmap assumptions.
5. Update `KNOWLEDGE/truthwatcher.md` only with stable facts observed in the Truthwatcher repository.
6. Create a new ADR only if the review reveals a durable architectural decision not covered by ADR-0001 or ADR-0002.
