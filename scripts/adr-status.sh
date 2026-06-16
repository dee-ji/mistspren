#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECT="truthwatcher"
ADR_ID=""
STATUS=""

usage() {
  cat <<USAGE
Usage: $0 --project truthwatcher --adr ADR-0001 --status accepted

Moves a Truthwatcher ADR between status folders and updates its Status field.
Supported statuses: proposed, accepted, rejected, superseded
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --project) PROJECT="${2:-}"; shift 2 ;;
    --adr) ADR_ID="${2:-}"; shift 2 ;;
    --status) STATUS="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[ "$PROJECT" = "truthwatcher" ] || { echo "Only --project truthwatcher is supported." >&2; exit 2; }
[ -n "$ADR_ID" ] || { echo "Missing --adr ADR-000N." >&2; usage >&2; exit 2; }
[ -n "$STATUS" ] || { echo "Missing --status." >&2; usage >&2; exit 2; }

case "$STATUS" in
  proposed|accepted|rejected|superseded) ;;
  *) echo "Unsupported status: $STATUS" >&2; usage >&2; exit 2 ;;
esac

DECISIONS_DIR="$REPO_ROOT/projects/truthwatcher/4-decisions"
TARGET_DIR="$DECISIONS_DIR/$STATUS"
[ -d "$TARGET_DIR" ] || { echo "Missing ADR status directory: $TARGET_DIR" >&2; exit 1; }

MATCHES=$(find "$DECISIONS_DIR" -mindepth 2 -maxdepth 2 -type f -name "$ADR_ID-*.md" | sort)
COUNT=$(printf '%s\n' "$MATCHES" | sed '/^$/d' | wc -l | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
  echo "No ADR found for $ADR_ID under $DECISIONS_DIR." >&2
  exit 1
fi
if [ "$COUNT" -gt 1 ]; then
  echo "Multiple ADRs found for $ADR_ID:" >&2
  printf '%s\n' "$MATCHES" >&2
  exit 1
fi

SOURCE_FILE="$MATCHES"
BASENAME=$(basename "$SOURCE_FILE")
TARGET_FILE="$TARGET_DIR/$BASENAME"

if [ "$SOURCE_FILE" != "$TARGET_FILE" ] && [ -e "$TARGET_FILE" ]; then
  echo "Target already exists: $TARGET_FILE" >&2
  exit 1
fi

case "$STATUS" in
  proposed) STATUS_LABEL="Proposed" ;;
  accepted) STATUS_LABEL="Accepted" ;;
  rejected) STATUS_LABEL="Rejected" ;;
  superseded) STATUS_LABEL="Superseded" ;;
esac
export STATUS_LABEL
perl -0pi -e 'BEGIN { $status = $ENV{"STATUS_LABEL"} } s/(^## Status\n\n?)[^\n]+/${1}${status}/m or die "No status field updated\n"' "$SOURCE_FILE"

if [ "$SOURCE_FILE" != "$TARGET_FILE" ]; then
  mv "$SOURCE_FILE" "$TARGET_FILE"
fi

printf 'Updated %s to %s\n' "projects/truthwatcher/4-decisions/$STATUS/$BASENAME" "$STATUS"
