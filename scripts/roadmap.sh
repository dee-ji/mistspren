#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECT="truthwatcher"
DRY_RUN=0
NAME="roadmap"

usage() { echo "Usage: $0 --project truthwatcher [--dry-run]"; }
while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --project) PROJECT="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[ "$PROJECT" = "truthwatcher" ] || { echo "Only --project truthwatcher is supported by this scaffold." >&2; exit 2; }
WORKSPACE="$REPO_ROOT/projects/truthwatcher/workspace.yml"
[ -f "$WORKSPACE" ] || { echo "Missing workspace routing file: $WORKSPACE" >&2; exit 1; }

PROJECT_ROOT="$REPO_ROOT/projects/truthwatcher"
OUT_DIR="$REPO_ROOT/.mistspren/review"
mkdir -p "$REPO_ROOT/logs" "$REPO_ROOT/reports/runs" "$OUT_DIR"

STAMP=$(date -u +%Y%m%d-%H%M%S)
LOG_FILE="$REPO_ROOT/logs/$NAME-$STAMP.log"
RUN_REPORT="$REPO_ROOT/reports/runs/$NAME-$STAMP.md"
ACTION_FILE="$OUT_DIR/next-actions-$STAMP.md"
LATEST_ACTION_FILE="$OUT_DIR/latest-next-actions.md"
log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" | tee -a "$LOG_FILE"; }

list_md() {
  find "$1" -maxdepth 1 -type f -name '*.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort
}

ACCEPTED=$(list_md "$PROJECT_ROOT/4-decisions/accepted")
PROPOSED=$(list_md "$PROJECT_ROOT/4-decisions/proposed")
ROADMAP_ITEMS=$(find "$PROJECT_ROOT/5-roadmap" -type f -name '*.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort)
IMPLEMENTATION_THREAD="$PROJECT_ROOT/3-threads/implementation/truthwatcher-implementation-thread.md"
IDENTITY_ROADMAP="$PROJECT_ROOT/5-roadmap/initiatives/truthwatcher-identity-roadmap.md"
ADR_0002_ACCEPTED=0
if printf '%s\n' "$ACCEPTED" | grep -q 'ADR-0002-'; then
  ADR_0002_ACCEPTED=1
fi
IDENTITY_CANDIDATES_IMPLEMENTED=0
LATEST_TRUTHWATCHER_REVIEW=$(find "$REPO_ROOT/.mistspren/review" -maxdepth 1 -type f -name 'truthwatcher-review-*.md' 2>/dev/null | sort | tail -n 1 || true)
if [ -n "$LATEST_TRUTHWATCHER_REVIEW" ] && grep -q 'identity_candidates' "$LATEST_TRUTHWATCHER_REVIEW"; then
  IDENTITY_CANDIDATES_IMPLEMENTED=1
fi

NEXT_PROMPT="No implementation prompt was found in projects/truthwatcher/5-roadmap/initiatives/truthwatcher-identity-roadmap.md."
if [ -f "$IDENTITY_ROADMAP" ]; then
  NEXT_PROMPT=$(sed -n '/^## Next Codex Prompt/,$p' "$IDENTITY_ROADMAP" | sed '1d')
fi

IMPLEMENTATION_PROMPT='```text
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

Read before editing:
1. docs/planning/identity-lifecycle-analysis.md
2. migrations/*
3. internal/parser/*
4. internal/evidence/*
5. internal/assets/*
6. internal/db/*
7. internal/api/* paths related to discovery parsing, evidence, assets, facts, and relationships
8. existing tests for parser persistence and assets

Acceptance criteria:
- A parser run can persist identity candidates with evidence references.
- Hostname/name candidates are pending or provisional, not silently authoritative.
- Strong vendor+serial or system-MAC candidates are represented as strong candidates.
- Re-running parse for the same evidence/parser/candidate key does not duplicate candidates.
- Existing canonical assets are not merged, overwritten, or identity-rewritten by candidate persistence.
- Tests cover at least one fixture-backed hostname candidate, one strong inventory candidate, deduplication, and no canonical identity mutation.

Non-goals:
- No graph database.
- No microservices.
- No source-of-truth export or sync.
- No broad observability or chat UX.
- No arbitrary command execution.
- No SSH/non-fake collector exposure through new API/UI flows.
- No destructive merge or review-resolution workflow in this slice.

After implementation, summarize:
- Files changed.
- Schema/API/service changes.
- Tests added.
- Any deviations from docs/planning/identity-lifecycle-analysis.md.
- Remaining follow-up work for review queue and audit.
```'

REVIEW_QUEUE_PROMPT='```text
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

Read before editing:
1. docs/planning/identity-lifecycle-analysis.md
2. internal/db/identity_candidates.go
3. internal/parser/identity_candidates.go
4. internal/api/identity_candidates.go
5. internal/audit/*
6. migrations/000010_identity_candidates.*
7. tests added for identity candidate persistence

Acceptance criteria:
- Pending identity candidates can be listed as a review queue.
- A reviewer can record accept/reject/defer/request-more-evidence decisions, scoped to existing API/CLI surfaces.
- Review decisions are auditable and tied back to candidate/evidence records.
- Accept/reject/defer actions do not merge assets or rewrite canonical identity.
- Tests cover queued candidates, at least two review actions, audit metadata, and non-destructive behavior.

Non-goals:
- No automatic asset merge.
- No canonical identity rewrite.
- No bulk review workflow.
- No role-based access control.
- No UI polish unless an existing surface makes this trivial.
- No source-of-truth export or sync.
- No new non-fake collector exposure.

After implementation, summarize:
- Files changed.
- Schema/API/service changes.
- Tests added.
- How review decisions remain non-destructive.
- Remaining follow-up work for deterministic auto-acceptance.
```'

if [ -n "$PROPOSED" ]; then
  ACTIONS="1. Do not start Truthwatcher implementation from this roadmap yet.
2. Review the proposed ADRs listed in this file.
3. Accept, reject, or revise the ADRs before treating roadmap tasks as executable.
4. The current likely next human action is to review ADR-0002 and decide whether the identity lifecycle boundary should be accepted."
elif [ -n "$ACCEPTED" ]; then
  if [ "$ADR_0002_ACCEPTED" -eq 1 ]; then
    if [ "$IDENTITY_CANDIDATES_IMPLEMENTED" -eq 1 ]; then
      ACTIONS="1. Run the implementation prompt in this file inside the Truthwatcher repository.
2. Implement only the minimal identity candidate review queue and resolution audit.
3. Keep code, tests, migrations, and product docs in Truthwatcher.
4. Bring resulting implementation observations back into Mistspren with make mistspren-run."
      THREAD_SUMMARY="ADR-0001 and ADR-0002 are accepted, and the persisted identity candidates slice has landed in Truthwatcher. The next implementation slice is a minimal review queue and resolution audit, without asset merges or canonical identity rewrites."
      NEXT_PROMPT="$REVIEW_QUEUE_PROMPT"
    else
      ACTIONS="1. Run the implementation prompt in this file inside the Truthwatcher repository.
2. Implement only persisted identity candidates from parser evidence.
3. Keep code, tests, migrations, and product docs in Truthwatcher.
4. Bring resulting implementation observations back into Mistspren with make mistspren-run."
      THREAD_SUMMARY="ADR-0001 and ADR-0002 are accepted. The read-only identity lifecycle analysis has identified the first implementation slice: persist parser-derived identity candidates with evidence references, without merging or rewriting canonical assets."
      NEXT_PROMPT="$IMPLEMENTATION_PROMPT"
    fi
  else
    ACTIONS="1. Pick the smallest accepted-ADR-backed roadmap item.
2. Run the linked implementation prompt in the Truthwatcher repository, not in Mistspren.
3. Keep code, tests, migrations, and product docs in Truthwatcher.
4. Bring resulting implementation observations back into Mistspren with scripts/truthwatcher-review.sh."
  fi
else
  ACTIONS="1. Do not start Truthwatcher implementation from this roadmap yet.
2. Draft or accept an ADR before treating roadmap tasks as executable.
3. Use projects/truthwatcher/1-workbench and projects/truthwatcher/3-threads to decide what architectural choice is blocking implementation.
4. Run scripts/decide.sh --project truthwatcher after adding or updating proposed ADRs."
fi

if [ -z "${THREAD_SUMMARY:-}" ]; then
  THREAD_SUMMARY="No implementation thread found."
fi
if [ "$ADR_0002_ACCEPTED" -eq 0 ] && [ -f "$IMPLEMENTATION_THREAD" ]; then
  THREAD_SUMMARY=$(sed -n '/^## Current Recommendation/,$p' "$IMPLEMENTATION_THREAD" | sed '1d')
fi

CONTENT="# Roadmap Next Actions - $STAMP

## Purpose

This file is the roadmap-stage output for the Truthwatcher Mistspren workflow. It translates current decision state into human action. It does not create implementation changes.

## Decision State

### Accepted ADRs

\`\`\`text
${ACCEPTED:-No accepted ADRs found.}
\`\`\`

### Proposed ADRs

\`\`\`text
${PROPOSED:-No proposed ADRs found.}
\`\`\`

## Existing Roadmap Artifacts

\`\`\`text
${ROADMAP_ITEMS:-No roadmap Markdown files found.}
\`\`\`

## Human Roadmap Actions

$ACTIONS

## Current Implementation Recommendation

$THREAD_SUMMARY

## Candidate Prompt For Truthwatcher

$NEXT_PROMPT

## Guardrails

- Do not execute implementation tasks unless the linked ADR has been accepted.
- Do not modify Truthwatcher code from this Mistspren script.
- Do not add roadmap items without a decision reference.
- Feed implementation reality back through workbench review before changing decisions.
"

RUN_CONTENT="# Run Report - $NAME $STAMP

- Script: scripts/$NAME.sh
- Project: $PROJECT
- Dry run: $DRY_RUN
- Roadmap action target: $ACTION_FILE
"

if [ "$DRY_RUN" -eq 1 ]; then
  printf '%s\n' "DRY RUN: would write $ACTION_FILE, update $LATEST_ACTION_FILE, write $RUN_REPORT, and write $LOG_FILE"
  printf '%s\n' "$CONTENT"
else
  log "Writing roadmap next actions to $ACTION_FILE"
  printf '%s\n' "$CONTENT" > "$ACTION_FILE"
  printf '%s\n' "$CONTENT" > "$LATEST_ACTION_FILE"
  printf '%s\n' "$RUN_CONTENT" > "$RUN_REPORT"
fi
