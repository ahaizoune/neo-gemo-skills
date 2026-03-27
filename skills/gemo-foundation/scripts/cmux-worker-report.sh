#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDOFF="$SCRIPT_DIR/cmux-handoff.sh"

usage() {
  cat <<'EOF'
Usage:
  cmux-worker-report.sh [--peer <surface-or-title>] [--no-notify] [--no-log] \
    <progress|blocked|attention|required|result-ready|done> <task-id> [message]

Examples:
  cmux-worker-report.sh progress IP-EXEC-01 "portal DTOs landed"
  cmux-worker-report.sh blocked IP-EXEC-01 "missing backend contract detail"
  cmux-worker-report.sh result-ready IP-EXEC-01 "routes and tests ready for orchestrator review"
EOF
}

fail() {
  echo "cmux-worker-report: $*" >&2
  exit 1
}

require_bin() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

caller_surface() {
  cmux identify --json | jq -r '.caller.surface_ref // empty'
}

caller_workspace() {
  cmux identify --json | jq -r '.caller.workspace_ref // empty'
}

ensure_single_line() {
  local text="$1"
  [[ "$text" != *$'\n'* ]] || fail "message must be a single line"
}

STATUS=""
TASK_ID=""
MESSAGE=""
PEER="orchestrator"
SHOULD_NOTIFY=1
SHOULD_LOG=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --peer)
      [[ $# -ge 2 ]] || fail "--peer requires a value"
      PEER="$2"
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

[[ $# -ge 2 ]] || fail "expected <status> <task-id> [message]"
STATUS="$1"
TASK_ID="$2"
shift 2
MESSAGE="${*:-}"
ensure_single_line "$MESSAGE"

require_bin cmux
require_bin jq
[[ -f "$HANDOFF" ]] || fail "missing handoff helper: $HANDOFF"

FROM_REF="$(caller_surface)"
WORKSPACE_REF="$(caller_workspace)"

[[ -n "$FROM_REF" ]] || fail "unable to resolve caller surface; run this inside a cmux surface"

case "$STATUS" in
  progress)
    HandoffVerb="info"
    BodyPrefix="status=progress next=continue"
    NotifyTitle="$TASK_ID progress"
    NotifyBody="${MESSAGE:-worker checkpoint landed}"
    LogLevel="progress"
    ;;
  blocked)
    HandoffVerb="err"
    BodyPrefix="status=blocked next=orchestrator_attention"
    NotifyTitle="$TASK_ID blocked"
    NotifyBody="${MESSAGE:-worker is blocked}"
    LogLevel="error"
    ;;
  attention|required)
    HandoffVerb="err"
    BodyPrefix="status=attention_required next=orchestrator_attention"
    NotifyTitle="$TASK_ID attention required"
    NotifyBody="${MESSAGE:-worker requires orchestrator attention}"
    LogLevel="error"
    ;;
  result-ready|done)
    HandoffVerb="res"
    BodyPrefix="status=result_ready next=orchestrator_review"
    NotifyTitle="$TASK_ID result ready"
    NotifyBody="${MESSAGE:-worker output is ready for orchestrator review}"
    LogLevel="progress"
    ;;
  *)
    fail "unknown status '$STATUS'"
    ;;
esac

EnvelopeBody="$BodyPrefix from=$FROM_REF"
if [[ -n "$MESSAGE" ]]; then
  EnvelopeBody="$EnvelopeBody $MESSAGE"
fi

bash "$HANDOFF" "$HandoffVerb" "$PEER" "$TASK_ID" "$EnvelopeBody"

if [[ "$SHOULD_NOTIFY" == "1" && -n "$WORKSPACE_REF" ]]; then
  cmux notify \
    --workspace "$WORKSPACE_REF" \
    --title "$NotifyTitle" \
    --subtitle "$FROM_REF -> $PEER" \
    --body "$NotifyBody"
fi

if [[ "$SHOULD_LOG" == "1" && -n "$WORKSPACE_REF" ]]; then
  cmux log --workspace "$WORKSPACE_REF" --level "$LogLevel" --source "$TASK_ID" -- "$NotifyBody"
fi

printf 'status=%s\n' "$STATUS"
printf 'task_id=%s\n' "$TASK_ID"
printf 'peer=%s\n' "$PEER"
