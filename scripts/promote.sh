#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECT="truthwatcher"
DRY_RUN=0
NAME="promote"

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
mkdir -p "$REPO_ROOT/logs" "$REPO_ROOT/reports/runs"
STAMP=$(date -u +%Y%m%d-%H%M%S)
LOG_FILE="$REPO_ROOT/logs/$NAME-$STAMP.log"
RUN_REPORT="$REPO_ROOT/reports/runs/$NAME-$STAMP.md"
log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" | tee -a "$LOG_FILE"; }

# This scaffold is intentionally conservative: it records intent and routing only.
# It does not modify Truthwatcher code, auto-accept ADRs, or create production PRs.
case "$NAME" in
  intake) INTENT="Move new captured raw inputs into projects/truthwatcher/0-raw after human review." ;;
  extract) INTENT="Convert raw notes into projects/truthwatcher/1-workbench extraction notes after human review." ;;
  promote) INTENT="Promote sourced claims into atoms, but automatic promotion is intentionally disabled." ;;
  synthesize) INTENT="Update project synthesis threads from reviewed atoms and workbench notes." ;;
  decide) INTENT="Draft proposed ADRs from mature threads only; never accept ADRs automatically." ;;
  roadmap) INTENT="Reconcile accepted ADRs into roadmap items without creating implementation PRs." ;;
  *) INTENT="Run a safe Mistspren scaffold step." ;;
esac

CONTENT="# Run Report — $NAME $STAMP

- Script: scripts/$NAME.sh
- Project: $PROJECT
- Dry run: $DRY_RUN
- Workspace routing: projects/truthwatcher/workspace.yml
- Intent: $INTENT

## Not Automated Yet

- No autonomous source-code edits.
- No automatic ADR acceptance.
- No production pull requests.
- No destructive file operations.
"

if [ "$DRY_RUN" -eq 1 ]; then
  printf '%s\n' "DRY RUN: would write $RUN_REPORT and $LOG_FILE"
  printf '%s\n' "$CONTENT"
else
  log "Writing scaffold run report to $RUN_REPORT"
  printf '%s\n' "$CONTENT" > "$RUN_REPORT"
fi
