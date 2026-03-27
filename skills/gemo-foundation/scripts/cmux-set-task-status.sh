#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  cmux-set-task-status.sh [--workspace <workspace-ref>] [--icon <name>] [--color <#hex>] \
    <status-key> <task-id> <short-label> <state>

Examples:
  cmux-set-task-status.sh --workspace workspace:1 backend-auth IP-EXEC-01 "backend auth/session" in_progress
  cmux-set-task-status.sh frontend-portal IP-EXEC-03 "portal shell/dashboard" queued
EOF
}

fail() {
  echo "cmux-set-task-status: $*" >&2
  exit 1
}

ensure_single_line() {
  local text="$1"
  [[ "$text" != *$'\n'* ]] || fail "arguments must be single-line"
}

WORKSPACE_REF="${CMUX_WORKSPACE_ID:-}"
ICON=""
COLOR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      [[ $# -ge 2 ]] || fail "--workspace requires a value"
      WORKSPACE_REF="$2"
      shift 2
      ;;
    --icon)
      [[ $# -ge 2 ]] || fail "--icon requires a value"
      ICON="$2"
      shift 2
      ;;
    --color)
      [[ $# -ge 2 ]] || fail "--color requires a value"
      COLOR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      break
      ;;
  esac
done

[[ -n "$WORKSPACE_REF" ]] || fail "--workspace is required when CMUX_WORKSPACE_ID is not set"
[[ $# -eq 4 ]] || fail "expected <status-key> <task-id> <short-label> <state>"

STATUS_KEY="$1"
TASK_ID="$2"
SHORT_LABEL="$3"
STATE="$4"

ensure_single_line "$STATUS_KEY"
ensure_single_line "$TASK_ID"
ensure_single_line "$SHORT_LABEL"
ensure_single_line "$STATE"

command -v cmux >/dev/null 2>&1 || fail "missing required command: cmux"

if [[ -z "$ICON" || -z "$COLOR" ]]; then
  case "$STATE" in
    queued)
      : "${ICON:=clock.fill}"
      : "${COLOR:=#6B7280}"
      ;;
    in_progress)
      : "${ICON:=hammer.fill}"
      : "${COLOR:=#2563EB}"
      ;;
    review_requested|awaiting_acceptance)
      : "${ICON:=magnifyingglass}"
      : "${COLOR:=#F59E0B}"
      ;;
    rework|rework_requested)
      : "${ICON:=arrow.triangle.2.circlepath}"
      : "${COLOR:=#F97316}"
      ;;
    blocked|attention_required)
      : "${ICON:=exclamationmark.triangle.fill}"
      : "${COLOR:=#DC2626}"
      ;;
    completed|accepted|review_passed)
      : "${ICON:=checkmark.circle.fill}"
      : "${COLOR:=#16A34A}"
      ;;
    *)
      : "${ICON:=circle.fill}"
      : "${COLOR:=#6B7280}"
      ;;
  esac
fi

VISIBLE_VALUE="$TASK_ID $SHORT_LABEL $STATE"

cmux set-status "$STATUS_KEY" "$VISIBLE_VALUE" \
  --workspace "$WORKSPACE_REF" \
  --icon "$ICON" \
  --color "$COLOR"

printf 'status_key=%s\n' "$STATUS_KEY"
printf 'task_id=%s\n' "$TASK_ID"
printf 'short_label=%s\n' "$SHORT_LABEL"
printf 'state=%s\n' "$STATE"
printf 'workspace=%s\n' "$WORKSPACE_REF"
