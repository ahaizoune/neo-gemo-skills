#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  cmux-launch-claude-worker.sh --surface <surface-or-title> --cwd <path> --name <session-name>
    [--workspace <id|ref>] [--prompt-file <path>] [--prompt <text>] [--task-id <id>]
    [--notify-peer <surface-or-title>] [--no-yolo] [--claude-arg <arg> ...]

Launches a Claude session inside an existing cmux surface and optionally submits an initial prompt.
YOLO mode is enabled by default via `--dangerously-skip-permissions`.

Examples:
  cmux-launch-claude-worker.sh \
    --surface backend-auth \
    --cwd /repo \
    --name backend-auth

  cmux-launch-claude-worker.sh \
    --surface surface:21 \
    --cwd /repo \
    --name backend-auth \
    --task-id IP-EXEC-01 \
    --prompt-file /tmp/backend-auth-prompt.md \
    --claude-arg --model --claude-arg sonnet

  cmux-launch-claude-worker.sh \
    --surface backend-auth \
    --cwd /repo \
    --name backend-auth \
    --no-yolo
EOF
}

fail() {
  echo "cmux-launch-claude-worker: $*" >&2
  exit 1
}

require_bin() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

cmux_run() {
  if [[ ${#cmux_scope[@]} -gt 0 ]]; then
    cmux "$@" "${cmux_scope[@]}"
  else
    cmux "$@"
  fi
}

shell_join() {
  local out="" part
  for part in "$@"; do
    if [[ -n "$out" ]]; then
      out+=" "
    fi
    out+="$(printf '%q' "$part")"
  done
  printf '%s\n' "$out"
}

append_collaboration_footer() {
  local payload="$1"
  local report_script footer

  [[ -n "$TASK_ID" ]] || {
    printf '%s' "$payload"
    return 0
  }

  report_script="$SCRIPT_DIR/cmux-worker-report.sh"
  footer="$(cat <<EOF

## Collaboration Protocol

Use \`bash $report_script\` to notify the orchestrator surface \`$NOTIFY_PEER\`.

- After the first meaningful implementation checkpoint:
  \`bash $report_script --peer $NOTIFY_PEER progress $TASK_ID "first meaningful checkpoint landed"\`
- If blocked or waiting on approval/clarification:
  \`bash $report_script --peer $NOTIFY_PEER blocked $TASK_ID "short blocker summary"\`
- When your owned output is ready for orchestrator acceptance:
  \`bash $report_script --peer $NOTIFY_PEER result-ready $TASK_ID "completed work and validation summary"\`
- Do not finish or idle silently. Always notify the orchestrator with \`result-ready\`, \`blocked\`,
  or \`progress\` before waiting.
EOF
)"

  printf '%s%s' "$payload" "$footer"
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

accept_yolo_prompt_if_present() {
  local attempts delay post_delay screen down_key i
  attempts="${CMUX_CLAUDE_YOLO_CONFIRM_MAX_ATTEMPTS:-12}"
  delay="${CMUX_CLAUDE_YOLO_CONFIRM_DELAY_SEC:-1}"
  post_delay="${CMUX_CLAUDE_YOLO_POST_CONFIRM_DELAY_SEC:-2}"
  down_key="j"

  for ((i = 0; i < attempts; i++)); do
    screen="$(cmux_run read-screen --surface "$surface_ref" --lines 60 2>/dev/null || true)"
    if printf '%s' "$screen" | grep -q "Yes, I accept"; then
      cmux_run send --surface "$surface_ref" "$down_key"
      cmux_run send-key --surface "$surface_ref" enter
      sleep "$post_delay"
      return 0
    fi
    sleep "$delay"
  done

  return 0
}

SURFACE_QUERY=""
WORKSPACE_REF=""
CWD_PATH=""
SESSION_NAME=""
PROMPT_FILE=""
PROMPT_TEXT=""
TASK_ID=""
NOTIFY_PEER="orchestrator"
YOLO_MODE="${CMUX_CLAUDE_YOLO_MODE:-1}"
declare -a CLAUDE_ARGS=()

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
    --cwd)
      [[ $# -ge 2 ]] || fail "--cwd requires a value"
      CWD_PATH="$2"
      shift 2
      ;;
    --name)
      [[ $# -ge 2 ]] || fail "--name requires a value"
      SESSION_NAME="$2"
      shift 2
      ;;
    --prompt-file)
      [[ $# -ge 2 ]] || fail "--prompt-file requires a value"
      PROMPT_FILE="$2"
      shift 2
      ;;
    --prompt)
      [[ $# -ge 2 ]] || fail "--prompt requires a value"
      PROMPT_TEXT="$2"
      shift 2
      ;;
    --task-id)
      [[ $# -ge 2 ]] || fail "--task-id requires a value"
      TASK_ID="$2"
      shift 2
      ;;
    --notify-peer)
      [[ $# -ge 2 ]] || fail "--notify-peer requires a value"
      NOTIFY_PEER="$2"
      shift 2
      ;;
    --no-yolo)
      YOLO_MODE="0"
      shift
      ;;
    --claude-arg)
      [[ $# -ge 2 ]] || fail "--claude-arg requires a value"
      CLAUDE_ARGS+=("$2")
      shift 2
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
[[ -n "$CWD_PATH" ]] || fail "--cwd is required"
[[ -n "$SESSION_NAME" ]] || fail "--name is required"
[[ -d "$CWD_PATH" ]] || fail "cwd does not exist: $CWD_PATH"
[[ -z "$PROMPT_FILE" || -z "$PROMPT_TEXT" ]] || fail "use only one of --prompt-file or --prompt"
[[ -z "$PROMPT_FILE" || -f "$PROMPT_FILE" ]] || fail "prompt file does not exist: $PROMPT_FILE"
[[ "$YOLO_MODE" == "0" || "$YOLO_MODE" == "1" ]] || fail "CMUX_CLAUDE_YOLO_MODE must be 0 or 1"

require_bin cmux
require_bin jq
require_bin claude

surface_ref="$(resolve_surface "$SURFACE_QUERY")"

declare -a cmux_scope=()
if [[ -n "$WORKSPACE_REF" ]]; then
  cmux_scope+=(--workspace "$WORKSPACE_REF")
fi

declare -a claude_cmd=(claude -n "$SESSION_NAME")
if [[ "$YOLO_MODE" == "1" ]]; then
  claude_cmd+=(--dangerously-skip-permissions)
fi
if [[ ${#CLAUDE_ARGS[@]} -gt 0 ]]; then
  claude_cmd+=("${CLAUDE_ARGS[@]}")
fi

launch_command="cd $(printf '%q' "$CWD_PATH") && $(shell_join "${claude_cmd[@]}")"
if [[ ${#cmux_scope[@]} -gt 0 ]]; then
  cmux respawn-pane "${cmux_scope[@]}" --surface "$surface_ref" --command "$launch_command"
else
  cmux respawn-pane --surface "$surface_ref" --command "$launch_command"
fi

if [[ "$YOLO_MODE" == "1" ]]; then
  accept_yolo_prompt_if_present
fi

if [[ -n "$PROMPT_FILE" || -n "$PROMPT_TEXT" ]]; then
  prompt_payload="$PROMPT_TEXT"
  if [[ -n "$PROMPT_FILE" ]]; then
    prompt_payload="$(cat "$PROMPT_FILE")"
  fi
  prompt_payload="$(append_collaboration_footer "$prompt_payload")"

  sleep "${CMUX_CLAUDE_BOOT_DELAY_SEC:-2}"
  buffer_name="claude-launch-${surface_ref//[: ]/_}"
  cmux set-buffer --name "$buffer_name" "$prompt_payload"
  cmux_run paste-buffer --name "$buffer_name" --surface "$surface_ref"
  cmux_run send-key --surface "$surface_ref" Return
fi

printf 'surface=%s\n' "$surface_ref"
printf 'command=%s\n' "$launch_command"
printf 'yolo=%s\n' "$YOLO_MODE"
printf 'task_id=%s\n' "$TASK_ID"
printf 'notify_peer=%s\n' "$NOTIFY_PEER"
