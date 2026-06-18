#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TRUTHWATCHER_PATH="${TRUTHWATCHER_HOME:-$HOME/GolandProjects/truthwatcher}"
DATE=$(date -u +%F)
OUT="$REPO_ROOT/REVIEWS/$DATE-truthwatcher-review.md"

usage() {
  cat <<USAGE
Usage: TRUTHWATCHER_HOME=/path/to/truthwatcher $0

Creates or overwrites a dated read-only Truthwatcher review scaffold in REVIEWS/.
USAGE
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  "") ;;
  *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
esac

[ -d "$TRUTHWATCHER_PATH" ] || { echo "Truthwatcher path not found: $TRUTHWATCHER_PATH" >&2; exit 2; }
git -C "$TRUTHWATCHER_PATH" rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a Git repository: $TRUTHWATCHER_PATH" >&2; exit 2; }

mkdir -p "$REPO_ROOT/REVIEWS"
REMOTE=$(git -C "$TRUTHWATCHER_PATH" remote get-url origin 2>/dev/null || true)
HEAD=$(git -C "$TRUTHWATCHER_PATH" rev-parse --short HEAD)
BRANCH=$(git -C "$TRUTHWATCHER_PATH" branch --show-current 2>/dev/null || true)
STATUS=$(git -C "$TRUTHWATCHER_PATH" status --short)
RECENT=$(git -C "$TRUTHWATCHER_PATH" log --oneline --decorate -n 10)
CHANGED=$(git -C "$TRUTHWATCHER_PATH" diff --name-status HEAD~1..HEAD 2>/dev/null || true)

cat > "$OUT" <<REVIEW
# Truthwatcher Review — $DATE

## Scope

- Truthwatcher path: $TRUTHWATCHER_PATH
- Remote: ${REMOTE:-unknown}
- Branch: ${BRANCH:-unknown}
- Head: $HEAD
- Review mode: read-only; no Truthwatcher files were modified by this script.

## What changed in Truthwatcher

### Last commit changed files

\`\`\`text
${CHANGED:-Unable to compare HEAD~1..HEAD, or no changed files found.}
\`\`\`

### Recent commits

\`\`\`text
$RECENT
\`\`\`

### Working tree status

\`\`\`text
${STATUS:-Clean working tree.}
\`\`\`

## Decision made or confirmed

- TODO: State whether ADR-0001 and ADR-0002 still fit the observed code and docs.

## Risk discovered

- TODO: Record any security, architecture, operational, delivery, or coupling risk.

## Recommended next action

- TODO: Identify the single most useful next Truthwatcher action.

## ADR needed?

- TODO: Yes/No. If yes, describe the decision. If no, name the existing ADR that covers the situation.

## Truthwatcher work classification

- TODO: Choose one or more: bug fix, feature refinement, security improvement, documentation update, no implementation change.

## Durable Mistspren updates needed

- TODO: List updates needed to ACTIVE_CONTEXT.md, NEXT_ACTIONS.md, KNOWLEDGE/, RISKS/, or DECISIONS/.
REVIEW

printf 'Wrote %s\n' "$OUT"
printf 'Next: edit the TODOs, then update ACTIVE_CONTEXT.md and NEXT_ACTIONS.md if needed.\n'
