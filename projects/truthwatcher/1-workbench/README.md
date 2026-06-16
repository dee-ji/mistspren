# Truthwatcher Workbench

The workbench is for curated analysis that has not yet become durable synthesis, an ADR, or roadmap work.

Track files here when they explain reasoning a future human should rely on, such as:

- `extracts/truthwatcher-current-state.md`: observed project facts and constraints;
- `claim-maps/truthwatcher-decision-analysis-0002.md`: evidence and reasoning for ADR-0002.

Do not use this folder as a dump for timestamped script output. Generated review snapshots and queues belong in `.mistspren/review/` and should only be promoted here after a human rewrites them into a stable analysis file with a clear title.

## Promotion Rule

Workbench material should move forward only when it has a clear role:

- unresolved question -> `questions/`;
- candidate durable claim -> `candidate-atoms/`;
- decision support -> `claim-maps/`;
- synthesized architecture or implementation position -> `../3-threads/`;
- actual decision -> `../4-decisions/`;
- executable planning -> `../5-roadmap/`.
