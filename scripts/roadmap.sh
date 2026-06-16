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
PROMPT_DIR="$PROJECT_ROOT/5-roadmap/prompts"
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

front_matter_value() {
  awk -F': ' -v key="$2" '
    $0 == "---" { fence++; next }
    fence == 1 && $1 == key { print substr($0, length($1) + 3); exit }
  ' "$1"
}

prompt_body() {
  awk '
    $0 == "---" { fence++; next }
    fence >= 2 { print }
  ' "$1"
}

marker_completed() {
  marker="$1"
  [ -z "$marker" ] && return 1
  find "$OUT_DIR" -maxdepth 1 -type f -name 'truthwatcher-review-*.md' -print0 2>/dev/null |
    xargs -0 grep -q "$marker" 2>/dev/null
}

adr_accepted() {
  adr="$1"
  [ -z "$adr" ] && return 0
  printf '%s\n' "$ACCEPTED" | grep -q "/$adr-"
}

missing_required_adrs() {
  requirements="$1"
  [ -z "$requirements" ] && return 0
  printf '%s' "$requirements" | tr ',' '\n' | while IFS= read -r adr; do
    adr=$(printf '%s' "$adr" | tr -d ' ')
    [ -z "$adr" ] && continue
    if ! adr_accepted "$adr"; then
      printf '%s\n' "$adr"
    fi
  done
}

ACCEPTED=$(list_md "$PROJECT_ROOT/4-decisions/accepted")
PROPOSED=$(list_md "$PROJECT_ROOT/4-decisions/proposed")
ROADMAP_ITEMS=$(find "$PROJECT_ROOT/5-roadmap" -type f -name '*.md' 2>/dev/null | sed "s#^$REPO_ROOT/##" | sort)

if [ -n "$PROPOSED" ]; then
  ACTIONS="1. Do not start Truthwatcher implementation from this roadmap yet.
2. Review the proposed ADRs listed in this file.
3. Accept, reject, or revise the ADRs before treating roadmap tasks as executable.
4. Run scripts/decide.sh --project truthwatcher after changing ADR status."
  THREAD_SUMMARY="There are still proposed ADRs. Proposed decisions are the current implementation gate."
  NEXT_PROMPT="No implementation prompt is available until proposed ADRs are resolved."
else
  SELECTED_PROMPT=""
  for prompt in "$PROMPT_DIR"/*.md; do
    [ -f "$prompt" ] || continue
    marker=$(front_matter_value "$prompt" "completion_marker")
    if ! marker_completed "$marker"; then
      SELECTED_PROMPT="$prompt"
      break
    fi
  done

  if [ -n "$SELECTED_PROMPT" ]; then
    action=$(front_matter_value "$SELECTED_PROMPT" "action")
    summary=$(front_matter_value "$SELECTED_PROMPT" "summary")
    required_adrs=$(front_matter_value "$SELECTED_PROMPT" "required_adrs")
    missing_adrs=$(missing_required_adrs "$required_adrs" || true)
    if [ -n "$missing_adrs" ]; then
      ACTIONS="1. Do not start this roadmap prompt yet.
2. Accept or replace the required ADRs listed below.
3. Run scripts/roadmap.sh --project truthwatcher after updating decisions.

Required ADRs not accepted:
$missing_adrs"
      THREAD_SUMMARY="The next configured roadmap prompt has unmet ADR prerequisites."
      NEXT_PROMPT="No implementation prompt is available until the required ADRs are accepted or replaced."
    else
      ACTIONS="1. Run the implementation prompt in this file inside the Truthwatcher repository.
2. $action
3. Keep code, tests, migrations, and product docs in Truthwatcher.
4. Bring resulting implementation observations back into Mistspren with make mistspren-run."
      THREAD_SUMMARY="$summary"
      NEXT_PROMPT=$(prompt_body "$SELECTED_PROMPT")
    fi
  else
    ACTIONS="1. All configured roadmap prompts appear complete.
2. Review Mistspren and Truthwatcher artifacts for any new architectural decision that should become an ADR.
3. Add the next roadmap prompt as a data file under projects/truthwatcher/5-roadmap/prompts/ when a new implementation slice is ready."
    THREAD_SUMMARY="All configured roadmap prompt completion markers appear in Mistspren review history."
    NEXT_PROMPT="No next prompt is configured."
  fi
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
