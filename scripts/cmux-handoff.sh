#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATOR="$SCRIPT_DIR/cmux-validate-envelope.sh"

usage() {
  cat <<'EOF'
Usage:
  cmux-handoff.sh --dry-run <command> ...
  cmux-handoff.sh resolve <peer>
  cmux-handoff.sh read <peer> [--lines N] [--scrollback]
  cmux-handoff.sh hello <peer> [--agent NAME] [--role ROLE]
  cmux-handoff.sh hello-ack <peer> [--agent NAME] [--role ROLE]
  cmux-handoff.sh ack <peer> <cid> [message]
  cmux-handoff.sh busy <peer> <cid> [message]
  cmux-handoff.sh info <peer> <cid> [--file PATH] <message>
  cmux-handoff.sh req <peer> <cid> <size:S|M|L> [--file PATH] <message>
  cmux-handoff.sh res <peer> <cid> [--file PATH] <message>
  cmux-handoff.sh err <peer> <cid> [--file PATH] <message>
EOF
}

fail() {
  echo "cmux-handoff: $*" >&2
  exit 1
}

require_bin() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

now_ms() {
  python3 - <<'PY'
import time
print(int(time.time() * 1000))
PY
}

CURRENT_LOCK_DIR=""

cleanup_current_lock() {
  local lock_dir owner_pid
  lock_dir="${CURRENT_LOCK_DIR:-}"
  [[ -n "$lock_dir" ]] || return 0

  if [[ -d "$lock_dir" ]]; then
    owner_pid=""
    [[ -f "$lock_dir/owner.pid" ]] && owner_pid="$(cat "$lock_dir/owner.pid" 2>/dev/null || true)"
    if [[ -z "$owner_pid" || "$owner_pid" == "$$" ]]; then
      rm -rf "$lock_dir"
    fi
  fi

  CURRENT_LOCK_DIR=""
}

trap cleanup_current_lock EXIT INT TERM

caller_surface() {
  cmux identify --json | jq -r '.caller.surface_ref'
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
    fail "ambiguous peer '$query': $(printf '%s' "$matches" | paste -sd ',' -)"
  fi

  printf '%s\n' "${matches%%$'\t'*}"
}

socket_slug() {
  local socket_path
  socket_path="$(cmux identify --json | jq -r '.socket_path // "/tmp/cmux.sock"')"
  printf '%s\n' "$socket_path" | tr -c 'A-Za-z0-9._-' '_'
}

ensure_single_line() {
  local text="$1"
  [[ "$text" != *$'\n'* ]] || fail "message body must be a single line; use --file for multiline payloads"
}

acquire_target_lock() {
  local to_ref="$1"
  local timeout_ms="${CMUX_SEND_LOCK_TIMEOUT_MS:-5000}"
  local stale_ms="${CMUX_SEND_LOCK_STALE_MS:-30000}"
  local lock_dir socket_ns start_ms now owner_pid owner_started age_ms

  socket_ns="$(socket_slug)"
  lock_dir="/tmp/cmux-skill-send-${socket_ns}-${to_ref//[: ]/_}.lock"
  start_ms="$(now_ms)"

  while ! mkdir "$lock_dir" 2>/dev/null; do
    owner_pid=""
    owner_started=""
    [[ -f "$lock_dir/owner.pid" ]] && owner_pid="$(cat "$lock_dir/owner.pid" 2>/dev/null || true)"
    [[ -f "$lock_dir/owner.started_ms" ]] && owner_started="$(cat "$lock_dir/owner.started_ms" 2>/dev/null || true)"

    if [[ -n "$owner_pid" ]] && ! kill -0 "$owner_pid" 2>/dev/null; then
      rm -rf "$lock_dir"
      continue
    fi

    if [[ "$owner_started" =~ ^[0-9]+$ ]]; then
      now="$(now_ms)"
      age_ms=$((now - owner_started))
      if (( age_ms >= stale_ms )); then
        rm -rf "$lock_dir"
        continue
      fi
    fi

    now="$(now_ms)"
    if (( now - start_ms >= timeout_ms )); then
      fail "timed out waiting to send to $to_ref; another envelope is still in flight"
    fi

    sleep 0.05
  done

  printf '%s\n' "$$" > "$lock_dir/owner.pid"
  printf '%s\n' "$(now_ms)" > "$lock_dir/owner.started_ms"
  CURRENT_LOCK_DIR="$lock_dir"
}

send_line() {
  local to_ref="$1"
  local line="$2"
  "$VALIDATOR" "$line" >/dev/null
  acquire_target_lock "$to_ref"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    printf '%s\n' "$line"
    cleanup_current_lock
    return 0
  fi
  cmux send --surface "$to_ref" "$line"
  cmux send-key --surface "$to_ref" Return
  printf '%s\n' "$line"
  cleanup_current_lock
}

build_body_from_args() {
  local file_path="$1"
  shift
  if [[ -n "$file_path" ]]; then
    [[ -f "$file_path" ]] || fail "file does not exist: $file_path"
    printf '%s\n' "$file_path"
  else
    local text="$*"
    [[ -n "$text" ]] || fail "missing message body"
    ensure_single_line "$text"
    printf '%s\n' "$text"
  fi
}

build_line() {
  local to_ref="$1"
  local type="$2"
  local cid="$3"
  local body="$4"
  local from_ref ts
  from_ref="$(caller_surface)"
  ts="$(now_ms)"

  if [[ -n "$cid" ]]; then
    printf '[FROM=%s TO=%s TYPE=%s CID=%s TS=%s] %s\n' "$from_ref" "$to_ref" "$type" "$cid" "$ts" "$body"
  else
    printf '[FROM=%s TO=%s TYPE=%s TS=%s] %s\n' "$from_ref" "$to_ref" "$type" "$ts" "$body"
  fi
}

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
  shift
fi

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

require_bin cmux
require_bin jq
require_bin python3
require_bin "$VALIDATOR"

cmd="$1"
shift

case "$cmd" in
  resolve)
    [[ $# -eq 1 ]] || fail "resolve requires exactly one peer name"
    resolve_surface "$1"
    ;;
  read)
    [[ $# -ge 1 ]] || fail "read requires a peer name"
    peer="$1"; shift
    ref="$(resolve_surface "$peer")"
    args=(--surface "$ref")
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --lines) [[ $# -ge 2 ]] || fail "--lines requires a value"; args+=(--lines "$2"); shift 2 ;;
        --scrollback) args+=(--scrollback); shift ;;
        *) fail "unknown read option: $1" ;;
      esac
    done
    cmux read-screen "${args[@]}"
    ;;
  hello|hello-ack)
    [[ $# -ge 1 ]] || fail "$cmd requires a peer name"
    peer="$1"; shift
    agent="Codex"
    role="pending"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --agent) [[ $# -ge 2 ]] || fail "--agent requires a value"; agent="$2"; shift 2 ;;
        --role) [[ $# -ge 2 ]] || fail "--role requires a value"; role="$2"; shift 2 ;;
        *) fail "unknown $cmd option: $1" ;;
      esac
    done
    ref="$(resolve_surface "$peer")"
    type="HELLO"
    [[ "$cmd" == "hello-ack" ]] && type="HELLO_ACK"
    line="$(build_line "$ref" "$type" "" "agent=$agent role=$role")"
    send_line "$ref" "$line"
    ;;
  ack)
    [[ $# -ge 2 ]] || fail "ack requires <peer> <cid> [message]"
    peer="$1"; cid="$2"; shift 2
    body="${*:-received}"
    ensure_single_line "$body"
    ref="$(resolve_surface "$peer")"
    line="$(build_line "$ref" "ACK" "$cid" "$body")"
    send_line "$ref" "$line"
    ;;
  busy)
    [[ $# -ge 2 ]] || fail "busy requires <peer> <cid> [message]"
    peer="$1"; cid="$2"; shift 2
    body="${*:-deferred}"
    ensure_single_line "$body"
    ref="$(resolve_surface "$peer")"
    line="$(build_line "$ref" "BUSY" "$cid" "$body")"
    send_line "$ref" "$line"
    ;;
  info|req|res|err)
    [[ $# -ge 2 ]] || fail "$cmd requires at least <peer> <cid> ..."
    peer="$1"; cid="$2"; shift 2
    size=""
    file_path=""
    if [[ "$cmd" == "req" ]]; then
      [[ $# -ge 1 ]] || fail "req requires <size>"
      size="$1"
      [[ "$size" =~ ^(S|M|L)$ ]] || fail "req size must be one of S, M, L"
      shift
    fi
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --file) [[ $# -ge 2 ]] || fail "--file requires a value"; file_path="$2"; shift 2 ;;
        *) break ;;
      esac
    done
    body="$(build_body_from_args "$file_path" "$@")"
    if [[ "$cmd" == "req" ]]; then
      body="size=$size $body"
    fi
    ref="$(resolve_surface "$peer")"
    type="$(printf '%s' "$cmd" | tr '[:lower:]' '[:upper:]')"
    line="$(build_line "$ref" "$type" "$cid" "$body")"
    send_line "$ref" "$line"
    ;;
  *)
    usage
    fail "unknown command: $cmd"
    ;;
esac
