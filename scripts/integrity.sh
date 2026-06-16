#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECT="truthwatcher"; DRY_RUN=0
usage() { echo "Usage: $0 --project truthwatcher [--dry-run]"; }
while [ "$#" -gt 0 ]; do case "$1" in --dry-run) DRY_RUN=1; shift ;; --project) PROJECT="${2:-}"; shift 2 ;; -h|--help) usage; exit 0 ;; *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;; esac; done
[ "$PROJECT" = "truthwatcher" ] || { echo "Only --project truthwatcher is supported by this scaffold." >&2; exit 2; }
WORKSPACE="$REPO_ROOT/projects/truthwatcher/workspace.yml"
[ -f "$WORKSPACE" ] || { echo "Missing workspace routing file: $WORKSPACE" >&2; exit 1; }
mkdir -p "$REPO_ROOT/logs" "$REPO_ROOT/reports/runs" "$REPO_ROOT/reports/integrity"
STAMP=$(date -u +%Y%m%d-%H%M%S)
LOG_FILE="$REPO_ROOT/logs/integrity-$STAMP.log"
REPORT="$REPO_ROOT/reports/integrity/integrity-$STAMP.md"
RUN_REPORT="$REPO_ROOT/reports/runs/integrity-$STAMP.md"
log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" | tee -a "$LOG_FILE"; }
required='0-raw 1-workbench 2-atoms 3-threads 4-decisions 5-roadmap friction 1-workbench/extracts 4-decisions/proposed 4-decisions/accepted 4-decisions/rejected 4-decisions/superseded 5-roadmap/backlog 5-roadmap/initiatives 5-roadmap/milestones 5-roadmap/tasks'
missing=""
for d in $required; do [ -d "$REPO_ROOT/projects/truthwatcher/$d" ] || missing="$missing
- projects/truthwatcher/$d"; done
count_md() { find "$1" -maxdepth 1 -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' '; }
PROPOSED=$(count_md "$REPO_ROOT/projects/truthwatcher/4-decisions/proposed")
ACCEPTED=$(count_md "$REPO_ROOT/projects/truthwatcher/4-decisions/accepted")
REJECTED=$(count_md "$REPO_ROOT/projects/truthwatcher/4-decisions/rejected")
SUPERSEDED=$(count_md "$REPO_ROOT/projects/truthwatcher/4-decisions/superseded")
ROADMAP=$(find "$REPO_ROOT/projects/truthwatcher/5-roadmap" -type f -name '*.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort || true)
FLAG="No roadmap/ADR consistency warning."
if [ "$ACCEPTED" -eq 0 ] && [ -n "$ROADMAP" ]; then FLAG="Warning: roadmap files exist but there are no accepted ADRs."; fi
CONTENT="# Mistspren Integrity Report — $STAMP

## Workspace

- Project: truthwatcher
- Workspace file: projects/truthwatcher/workspace.yml

## Required Folder Check

${missing:-All required project folders exist.}

## ADR Counts

- Proposed: $PROPOSED
- Accepted: $ACCEPTED
- Rejected: $REJECTED
- Superseded: $SUPERSEDED

## Roadmap Files

\`\`\`text
${ROADMAP:-No roadmap Markdown files found.}
\`\`\`

## Roadmap / ADR Consistency

$FLAG

## Safety

This integrity check did not modify Truthwatcher code, accept ADRs, or create production pull requests.
"
if [ "$DRY_RUN" -eq 1 ]; then printf '%s\n' "DRY RUN: would write $REPORT, $RUN_REPORT, and $LOG_FILE"; printf '%s\n' "$CONTENT"; else log "Writing integrity report to $REPORT"; printf '%s\n' "$CONTENT" > "$REPORT"; printf '# Run Report — integrity %s\n\n- Report: %s\n' "$STAMP" "$REPORT" > "$RUN_REPORT"; fi
