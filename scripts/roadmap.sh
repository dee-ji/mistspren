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
log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" | tee -a "$LOG_FILE"; }

list_md() {
  find "$1" -maxdepth 1 -type f -name '*.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort
}

ACCEPTED=$(list_md "$PROJECT_ROOT/4-decisions/accepted")
PROPOSED=$(list_md "$PROJECT_ROOT/4-decisions/proposed")
ROADMAP_ITEMS=$(find "$PROJECT_ROOT/5-roadmap" -type f -name '*.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort)
IMPLEMENTATION_THREAD="$PROJECT_ROOT/3-threads/implementation/truthwatcher-implementation-thread.md"
IDENTITY_ROADMAP="$PROJECT_ROOT/5-roadmap/initiatives/truthwatcher-identity-roadmap.md"

NEXT_PROMPT="No implementation prompt was found in projects/truthwatcher/5-roadmap/initiatives/truthwatcher-identity-roadmap.md."
if [ -f "$IDENTITY_ROADMAP" ]; then
  NEXT_PROMPT=$(sed -n '/^## Next Codex Prompt/,$p' "$IDENTITY_ROADMAP" | sed '1d')
fi

if [ -n "$ACCEPTED" ]; then
  ACTIONS="1. Pick the smallest accepted-ADR-backed roadmap item.
2. Run the linked implementation prompt in the Truthwatcher repository, not in Mistspren.
3. Keep code, tests, migrations, and product docs in Truthwatcher.
4. Bring resulting implementation observations back into Mistspren with scripts/truthwatcher-review.sh."
else
  ACTIONS="1. Do not start Truthwatcher implementation from this roadmap yet.
2. Review the proposed ADRs listed in this file.
3. Accept, reject, or revise the ADRs before treating roadmap tasks as executable.
4. The current likely next human action is to review ADR-0002 and decide whether the identity lifecycle boundary should be accepted."
fi

THREAD_SUMMARY="No implementation thread found."
if [ -f "$IMPLEMENTATION_THREAD" ]; then
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
  printf '%s\n' "DRY RUN: would write $ACTION_FILE, $RUN_REPORT, and $LOG_FILE"
  printf '%s\n' "$CONTENT"
else
  log "Writing roadmap next actions to $ACTION_FILE"
  printf '%s\n' "$CONTENT" > "$ACTION_FILE"
  printf '%s\n' "$RUN_CONTENT" > "$RUN_REPORT"
fi
