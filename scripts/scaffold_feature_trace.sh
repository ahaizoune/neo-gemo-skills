#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scaffold_feature_trace.sh --repo PATH --feature SLUG [--title TEXT] [--feature-id ID]

Creates the standard agentic feature trace structure inside:
  <repo>/docs/features/<feature>/agentic/
EOF
}

fail() {
  echo "scaffold_feature_trace: $*" >&2
  exit 1
}

require_bin() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_ROOT="$REPO_ROOT/templates/feature-trace"

TARGET_REPO=""
FEATURE_SLUG=""
FEATURE_TITLE=""
FEATURE_ID=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      [[ $# -ge 2 ]] || fail "--repo requires a value"
      TARGET_REPO="$2"
      shift 2
      ;;
    --feature)
      [[ $# -ge 2 ]] || fail "--feature requires a value"
      FEATURE_SLUG="$2"
      shift 2
      ;;
    --title)
      [[ $# -ge 2 ]] || fail "--title requires a value"
      FEATURE_TITLE="$2"
      shift 2
      ;;
    --feature-id)
      [[ $# -ge 2 ]] || fail "--feature-id requires a value"
      FEATURE_ID="$2"
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

[[ -n "$TARGET_REPO" ]] || fail "--repo is required"
[[ -n "$FEATURE_SLUG" ]] || fail "--feature is required"
[[ -d "$TARGET_REPO" ]] || fail "repo does not exist: $TARGET_REPO"
[[ -d "$TEMPLATE_ROOT" ]] || fail "template root not found: $TEMPLATE_ROOT"

require_bin python3

if [[ -z "$FEATURE_TITLE" ]]; then
  FEATURE_TITLE="$FEATURE_SLUG"
fi

if [[ -z "$FEATURE_ID" ]]; then
  FEATURE_ID="$(date +%Y%m%d)-$FEATURE_SLUG"
fi

TARGET_DIR="$TARGET_REPO/docs/features/$FEATURE_SLUG/agentic"
mkdir -p "$TARGET_DIR"

export FEATURE_ID FEATURE_SLUG FEATURE_TITLE TARGET_REPO

render_template() {
  local src="$1"
  local dst="$2"
  python3 - "$src" "$dst" <<'PY'
from pathlib import Path
import os
import sys

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
text = src.read_text()
for key in ("FEATURE_ID", "FEATURE_SLUG", "FEATURE_TITLE", "TARGET_REPO"):
    text = text.replace("{{" + key + "}}", os.environ[key])
dst.write_text(text)
PY
}

render_template "$TEMPLATE_ROOT/feature-state.md" "$TARGET_DIR/feature-state.md"
render_template "$TEMPLATE_ROOT/01-discovery.md" "$TARGET_DIR/01-discovery.md"
render_template "$TEMPLATE_ROOT/02-grooming.md" "$TARGET_DIR/02-grooming.md"
render_template "$TEMPLATE_ROOT/03-architecture.md" "$TARGET_DIR/03-architecture.md"
render_template "$TEMPLATE_ROOT/04-execution-plan.md" "$TARGET_DIR/04-execution-plan.md"
render_template "$TEMPLATE_ROOT/decisions.md" "$TARGET_DIR/decisions.md"
render_template "$TEMPLATE_ROOT/reviews.md" "$TARGET_DIR/reviews.md"
render_template "$TEMPLATE_ROOT/rollout.md" "$TARGET_DIR/rollout.md"

python3 - "$TARGET_DIR/events.jsonl" <<'PY'
from datetime import datetime, timezone
from pathlib import Path
import json
import os
import sys

path = Path(sys.argv[1])
event = {
    "ts": datetime.now(timezone.utc).isoformat(),
    "feature_id": os.environ["FEATURE_ID"],
    "feature_slug": os.environ["FEATURE_SLUG"],
    "actor": "system",
    "role": "trace-scaffold",
    "phase": "discovery",
    "event_type": "feature_trace_initialized",
    "status": "completed",
    "summary": "Initialized standard feature trace scaffold.",
    "repo": os.path.basename(os.environ["TARGET_REPO"]),
    "task_id": None,
    "artifact_path": "docs/features/{}/agentic".format(os.environ["FEATURE_SLUG"]),
}
path.write_text(json.dumps(event) + "\n")
PY

printf 'Scaffolded feature trace at %s\n' "$TARGET_DIR"
