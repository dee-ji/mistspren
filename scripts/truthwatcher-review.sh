#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECT="truthwatcher"
DRY_RUN=0
TRUTHWATCHER_PATH="${TRUTHWATCHER_REPO_PATH:-}"

usage() {
  cat <<USAGE
Usage: $0 --project truthwatcher --truthwatcher-path /path/to/truthwatcher [--dry-run]

Creates a Mistspren workbench extraction note reviewing Truthwatcher Git changes.
This script never modifies Truthwatcher code, never accepts ADRs, and never creates production PRs.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --project) PROJECT="${2:-}"; shift 2 ;;
    --truthwatcher-path) TRUTHWATCHER_PATH="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[ "$PROJECT" = "truthwatcher" ] || { echo "Only --project truthwatcher is supported by this scaffold." >&2; exit 2; }
WORKSPACE="$REPO_ROOT/projects/truthwatcher/workspace.yml"
[ -f "$WORKSPACE" ] || { echo "Missing workspace routing file: $WORKSPACE" >&2; exit 1; }
[ -n "$TRUTHWATCHER_PATH" ] || { echo "Provide --truthwatcher-path or set TRUTHWATCHER_REPO_PATH." >&2; exit 2; }
[ -d "$TRUTHWATCHER_PATH/.git" ] || git -C "$TRUTHWATCHER_PATH" rev-parse --git-dir >/dev/null 2>&1 || { echo "Not a Git repository: $TRUTHWATCHER_PATH" >&2; exit 1; }

mkdir -p "$REPO_ROOT/logs" "$REPO_ROOT/reports/runs" "$REPO_ROOT/projects/truthwatcher/1-workbench/extracts" "$REPO_ROOT/.mistspren/state"
STAMP=$(date -u +%Y%m%d-%H%M%S)
LOG_FILE="$REPO_ROOT/logs/truthwatcher-review-$STAMP.log"
RUN_REPORT="$REPO_ROOT/reports/runs/truthwatcher-review-$STAMP.md"
NOTE_FILE="$REPO_ROOT/projects/truthwatcher/1-workbench/extracts/truthwatcher-review-$STAMP.md"
STATE_FILE="$REPO_ROOT/.mistspren/state/truthwatcher-last-reviewed"

log() { printf '%s %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" | tee -a "$LOG_FILE"; }

git -C "$TRUTHWATCHER_PATH" fetch --quiet --all --prune >/dev/null 2>&1 || log "Warning: git fetch failed or no remote was reachable; continuing with local metadata."
HEAD_COMMIT=$(git -C "$TRUTHWATCHER_PATH" rev-parse HEAD)
BASE_COMMIT=""
if [ -f "$STATE_FILE" ]; then
  BASE_COMMIT=$(cat "$STATE_FILE")
fi
if [ -z "$BASE_COMMIT" ] || ! git -C "$TRUTHWATCHER_PATH" cat-file -e "$BASE_COMMIT^{commit}" 2>/dev/null; then
  BASE_COMMIT=$(git -C "$TRUTHWATCHER_PATH" rev-list --max-parents=0 HEAD | tail -n 1)
fi

CHANGED_FILES=$(git -C "$TRUTHWATCHER_PATH" diff --name-status "$BASE_COMMIT" "$HEAD_COMMIT" || true)
DIFF_STAT=$(git -C "$TRUTHWATCHER_PATH" diff --stat "$BASE_COMMIT" "$HEAD_COMMIT" || true)
SHORT_LOG=$(git -C "$TRUTHWATCHER_PATH" log --oneline --decorate --no-merges "$BASE_COMMIT..$HEAD_COMMIT" || true)
REMOTE_URL=$(git -C "$TRUTHWATCHER_PATH" remote get-url origin 2>/dev/null || printf 'unknown')

render_note() {
  cat <<NOTE
# Truthwatcher Review — $STAMP

## Scope

- Project: truthwatcher
- Source repository path: $TRUTHWATCHER_PATH
- Source repository remote: $REMOTE_URL
- Base commit: $BASE_COMMIT
- Head commit: $HEAD_COMMIT
- Workspace routing: projects/truthwatcher/workspace.yml

## Safety Statement

No Truthwatcher code was modified by this Mistspren review script. This report is a human-reviewable Mistspren workbench extract only. It does not accept ADRs, create implementation changes, or open production pull requests.

## Changed Files

\`\`\`text
${CHANGED_FILES:-No changed files since the last reviewed commit.}
\`\`\`

## Git Diff Summary / Stat

\`\`\`text
${DIFF_STAT:-No diff stat since the last reviewed commit.}
\`\`\`

## Commit Summary

\`\`\`text
${SHORT_LOG:-No new commits since the last reviewed commit.}
\`\`\`

## Initial Review Notes

- Treat the Truthwatcher repository as implementation reality.
- Compare notable implementation changes against accepted Mistspren ADRs before creating roadmap changes.
- Record contradictions as friction rather than silently changing decisions.

## Next Suggested Mistspren Stage

Next stage: projects/truthwatcher/1-workbench/claim-maps for claim/evidence analysis, then projects/truthwatcher/3-threads/implementation if patterns are mature enough for synthesis.
NOTE
}

NOTE_CONTENT=$(render_note)
RUN_CONTENT="# Run Report — truthwatcher-review $STAMP

- Script: scripts/truthwatcher-review.sh
- Project: truthwatcher
- Dry run: $DRY_RUN
- Note target: $NOTE_FILE
- Base commit: $BASE_COMMIT
- Head commit: $HEAD_COMMIT
"

if [ "$DRY_RUN" -eq 1 ]; then
  printf '%s\n' "DRY RUN: would write $NOTE_FILE, $RUN_REPORT, $LOG_FILE and update $STATE_FILE to $HEAD_COMMIT"
  printf '%s\n' "--- note preview ---"
  printf '%s\n' "$NOTE_CONTENT"
else
  log "Writing Truthwatcher review note to $NOTE_FILE"
  printf '%s\n' "$NOTE_CONTENT" > "$NOTE_FILE"
  printf '%s\n' "$RUN_CONTENT" > "$RUN_REPORT"
  printf '%s\n' "$HEAD_COMMIT" > "$STATE_FILE"
  log "Updated last-reviewed state to $HEAD_COMMIT"
fi
