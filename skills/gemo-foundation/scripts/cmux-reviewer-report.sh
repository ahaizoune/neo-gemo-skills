#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  cmux-reviewer-report.sh --workspace <workspace-ref> [--no-notify] [--no-log] \
    <passed|failed|blocked> <task-id> <reviewer-agent> <reviewer-skill> [message]

Examples:
  cmux-reviewer-report.sh --workspace workspace:1 failed IP-EXEC-01 Laplace \
    gemo-backend-reviewer "3 blocking findings returned"
  cmux-reviewer-report.sh --workspace workspace:1 passed IP-EXEC-01 Herschel \
    gemo-security-reviewer "security review passed with no blocking findings"
EOF
}

fail() {
  echo "cmux-reviewer-report: $*" >&2
  exit 1
}

require_bin() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

ensure_single_line() {
  local text="$1"
  [[ "$text" != *$'\n'* ]] || fail "message must be a single line"
}

WORKSPACE_REF=""
SHOULD_NOTIFY=1
SHOULD_LOG=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      [[ $# -ge 2 ]] || fail "--workspace requires a value"
      WORKSPACE_REF="$2"
      shift 2
      ;;
    --no-notify)
      SHOULD_NOTIFY=0
      shift
      ;;
    --no-log)
      SHOULD_LOG=0
      shift
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

[[ -n "$WORKSPACE_REF" ]] || fail "--workspace is required"
[[ $# -ge 4 ]] || fail "expected <passed|failed|blocked> <task-id> <reviewer-agent> <reviewer-skill> [message]"

STATUS="$1"
TASK_ID="$2"
REVIEWER_AGENT="$3"
REVIEWER_SKILL="$4"
shift 4
MESSAGE="${*:-}"
ensure_single_line "$MESSAGE"

require_bin cmux

case "$STATUS" in
  passed)
    NOTIFY_TITLE="$TASK_ID review passed"
    NOTIFY_BODY="${MESSAGE:-$REVIEWER_AGENT ($REVIEWER_SKILL) approved the output}"
    LOG_LEVEL="progress"
    ;;
  failed)
    NOTIFY_TITLE="$TASK_ID review failed"
    NOTIFY_BODY="${MESSAGE:-$REVIEWER_AGENT ($REVIEWER_SKILL) returned blocking findings}"
    LOG_LEVEL="error"
    ;;
  blocked)
    NOTIFY_TITLE="$TASK_ID reviewer blocked"
    NOTIFY_BODY="${MESSAGE:-$REVIEWER_AGENT ($REVIEWER_SKILL) needs orchestrator attention}"
    LOG_LEVEL="error"
    ;;
  *)
    fail "unknown status '$STATUS'"
    ;;
esac

if [[ "$SHOULD_NOTIFY" == "1" ]]; then
  cmux notify \
    --workspace "$WORKSPACE_REF" \
    --title "$NOTIFY_TITLE" \
    --subtitle "$REVIEWER_AGENT -> orchestrator" \
    --body "$NOTIFY_BODY"
fi

if [[ "$SHOULD_LOG" == "1" ]]; then
  cmux log --workspace "$WORKSPACE_REF" --level "$LOG_LEVEL" --source "$REVIEWER_AGENT" -- "$NOTIFY_BODY"
fi

printf 'status=%s\n' "$STATUS"
printf 'task_id=%s\n' "$TASK_ID"
printf 'reviewer_agent=%s\n' "$REVIEWER_AGENT"
printf 'reviewer_skill=%s\n' "$REVIEWER_SKILL"
printf 'workspace=%s\n' "$WORKSPACE_REF"
