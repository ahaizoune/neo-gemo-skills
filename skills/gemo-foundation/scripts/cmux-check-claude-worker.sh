#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  cmux-check-claude-worker.sh --surface <surface-or-title> [--workspace <id|ref>]
    [--lines <n>] [--json]

Classifies the visible Claude worker state for a cmux surface.

Statuses:
  running              worker appears active or has no actionable gate visible
  awaiting_plan_approval  Claude produced an initial plan and is waiting at the execution gate
  awaiting_acceptance  Claude is waiting at the "accept edits on" review gate
  attention_required   Claude is waiting on an approval or other interactive prompt
  unknown              no clear classification could be made

Exit codes:
  0  running
  15 awaiting_plan_approval
  10 awaiting_acceptance
  20 attention_required
  30 unknown
EOF
}

fail() {
  echo "cmux-check-claude-worker: $*" >&2
  exit 1
}

require_bin() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

resolve_surface() {
  local query="$1"
  if [[ "$query" =~ ^surface:[0-9]+$ ]]; then
    printf '%s\n' "$query"
    return 0
  fi

  local matches count
  matches="$(cmux tree --json | jq -r --arg name "$query" '
    [.windows[].workspaces[].panes[].surfaces[]
     | {ref, title, lower: (.title | ascii_downcase)}] as $surfaces
    | ($name | ascii_downcase) as $needle
    | ([$surfaces[] | select(.lower == $needle)]) as $exact
    | if ($exact | length) == 1 then
        $exact[0] | "\(.ref)\t\(.title)"
      else
        [$surfaces[] | select(.lower | contains($needle))] | .[]? | "\(.ref)\t\(.title)"
      end
  ')"

  [[ -n "$matches" ]] || fail "no surface found matching '$query'"
  count="$(printf '%s\n' "$matches" | wc -l | tr -d ' ')"
  if [[ "$count" -gt 1 ]]; then
    fail "ambiguous surface '$query': $(printf '%s' "$matches" | paste -sd ',' -)"
  fi

  printf '%s\n' "${matches%%$'\t'*}"
}

SURFACE_QUERY=""
WORKSPACE_REF=""
LINES=160
JSON_OUTPUT=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --surface)
      [[ $# -ge 2 ]] || fail "--surface requires a value"
      SURFACE_QUERY="$2"
      shift 2
      ;;
    --workspace)
      [[ $# -ge 2 ]] || fail "--workspace requires a value"
      WORKSPACE_REF="$2"
      shift 2
      ;;
    --lines)
      [[ $# -ge 2 ]] || fail "--lines requires a value"
      LINES="$2"
      shift 2
      ;;
    --json)
      JSON_OUTPUT=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown option: $1"
      ;;
  esac
done

[[ -n "$SURFACE_QUERY" ]] || fail "--surface is required"
[[ "$LINES" =~ ^[0-9]+$ ]] || fail "--lines must be an integer"

require_bin cmux
require_bin jq

surface_ref="$(resolve_surface "$SURFACE_QUERY")"

declare -a cmux_scope=()
if [[ -n "$WORKSPACE_REF" ]]; then
  cmux_scope+=(--workspace "$WORKSPACE_REF")
fi

screen="$(cmux read-screen "${cmux_scope[@]}" --surface "$surface_ref" --scrollback --lines "$LINES" || true)"
screen_lc="$(printf '%s' "$screen" | tr '[:upper:]' '[:lower:]')"

status="running"
reason="no_actionable_gate_detected"
matched=""

if [[ -z "${screen//[[:space:]]/}" ]]; then
  status="unknown"
  reason="empty_screen"
elif [[ "$screen_lc" == *"written up a plan"* || "$screen_lc" == *"ready to execute"* ]]; then
  status="awaiting_plan_approval"
  reason="claude_plan_gate"
  matched="ready to execute"
elif [[ "$screen_lc" == *"accept edits on"* ]]; then
  status="awaiting_acceptance"
  reason="claude_accept_gate"
  matched="accept edits on"
elif [[ "$screen_lc" == *"do you want to allow"* \
     || "$screen_lc" == *"do you want to proceed"* \
     || "$screen_lc" == *"permission required"* \
     || "$screen_lc" == *"approval required"* \
     || "$screen_lc" == *"allow this action"* \
     || "$screen_lc" == *"enter your choice"* \
     || "$screen_lc" == *"press enter to confirm"* \
     || "$screen_lc" == *"allow once"* \
     || "$screen_lc" == *"deny once"* ]]; then
  status="attention_required"
  reason="interactive_approval_prompt"
  matched="approval prompt"
elif [[ "$screen_lc" == *$'\n❯ '* || "$screen_lc" == *$'\n› '* ]]; then
  status="running"
  reason="claude_prompt_visible_without_gate"
fi

if (( JSON_OUTPUT )); then
  jq -n \
    --arg surface "$surface_ref" \
    --arg status "$status" \
    --arg reason "$reason" \
    --arg matched "$matched" \
    '{surface: $surface, status: $status, reason: $reason, matched: $matched}'
else
  printf 'surface=%s\n' "$surface_ref"
  printf 'status=%s\n' "$status"
  printf 'reason=%s\n' "$reason"
  printf 'matched=%s\n' "$matched"
fi

case "$status" in
  running) exit 0 ;;
  awaiting_plan_approval) exit 15 ;;
  awaiting_acceptance) exit 10 ;;
  attention_required) exit 20 ;;
  *) exit 30 ;;
esac
