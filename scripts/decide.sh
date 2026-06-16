#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECT="truthwatcher"
DRY_RUN=0
NAME="decide"

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
REVIEW_FILE="$OUT_DIR/decision-review-$STAMP.md"
LATEST_REVIEW_FILE="$OUT_DIR/latest-decision-review.md"
log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" | tee -a "$LOG_FILE"; }

list_md() {
  find "$1" -maxdepth 1 -type f -name '*.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort
}

PROPOSED=$(list_md "$PROJECT_ROOT/4-decisions/proposed")
ACCEPTED=$(list_md "$PROJECT_ROOT/4-decisions/accepted")
THREADS=$(find "$PROJECT_ROOT/3-threads" -type f -name '*.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort)
WORKBENCH=$(find "$PROJECT_ROOT/1-workbench" -type f -name '*.md' ! -name 'README.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort)

if [ -n "$PROPOSED" ]; then
  DECISION_ACTIONS="1. Review each proposed ADR for current evidence, alternatives, risks, and review trigger.
2. For any ADR that is still correct, change its status to Accepted and move it from 4-decisions/proposed/ to 4-decisions/accepted/.
3. For any ADR that is wrong or premature, change its status to Rejected or keep it Proposed with explicit missing evidence.
4. After at least one ADR is accepted, run scripts/roadmap.sh --project truthwatcher to generate the next implementation action plan."
else
  DECISION_ACTIONS="1. Read the synthesis threads and workbench notes listed below.
2. Draft a proposed ADR only where a concrete architectural choice is blocking implementation.
3. Use templates/decision.md and store the draft under projects/truthwatcher/4-decisions/proposed/.
4. Do not create roadmap tasks until an ADR has been accepted."
fi

CONTENT="# Decision Review Queue - $STAMP

## Purpose

This file is the decision-stage output for the Truthwatcher Mistspren workflow. It surfaces human review work from existing threads, workbench notes, and ADRs. It does not accept decisions automatically.

## Proposed ADRs

\`\`\`text
${PROPOSED:-No proposed ADRs found.}
\`\`\`

## Accepted ADRs

\`\`\`text
${ACCEPTED:-No accepted ADRs found.}
\`\`\`

## Supporting Threads

\`\`\`text
${THREADS:-No synthesis threads found.}
\`\`\`

## Workbench Inputs

\`\`\`text
${WORKBENCH:-No workbench Markdown files found.}
\`\`\`

## Human Decision Actions

$DECISION_ACTIONS

## Guardrails

- Do not auto-accept ADRs.
- Do not create Truthwatcher implementation changes from this script.
- Do not treat roadmap files as authoritative until their linked ADRs are accepted.
- Record rejected or deferred decisions explicitly instead of silently dropping them.
"

RUN_CONTENT="# Run Report - $NAME $STAMP

- Script: scripts/$NAME.sh
- Project: $PROJECT
- Dry run: $DRY_RUN
- Decision review target: $REVIEW_FILE
"

if [ "$DRY_RUN" -eq 1 ]; then
  printf '%s\n' "DRY RUN: would write $REVIEW_FILE, update $LATEST_REVIEW_FILE, write $RUN_REPORT, and write $LOG_FILE"
  printf '%s\n' "$CONTENT"
else
  log "Writing decision review queue to $REVIEW_FILE"
  printf '%s\n' "$CONTENT" > "$REVIEW_FILE"
  printf '%s\n' "$CONTENT" > "$LATEST_REVIEW_FILE"
  printf '%s\n' "$RUN_CONTENT" > "$RUN_REPORT"
fi
