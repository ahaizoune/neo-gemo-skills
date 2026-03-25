#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  install_skills.sh [--codex-home PATH] [--force]

Installs all skill folders from this repository into <codex-home>/skills.

Options:
  --codex-home PATH   Override CODEX_HOME (default: $CODEX_HOME or $HOME/.codex)
  --force             Replace existing installed skills without stopping
EOF
}

fail() {
  echo "install_skills: $*" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --codex-home)
      [[ $# -ge 2 ]] || fail "--codex-home requires a value"
      CODEX_HOME="$2"
      shift 2
      ;;
    --force)
      FORCE=1
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

[[ -d "$SKILLS_SRC" ]] || fail "skills source directory not found: $SKILLS_SRC"

TARGET_ROOT="$CODEX_HOME/skills"
mkdir -p "$TARGET_ROOT"

timestamp="$(date +%Y%m%d-%H%M%S)"
backup_root="$TARGET_ROOT/.backup-$timestamp"
installed=()

for skill_path in "$SKILLS_SRC"/*; do
  [[ -d "$skill_path" ]] || continue
  skill_name="$(basename "$skill_path")"
  target_path="$TARGET_ROOT/$skill_name"

  if [[ -e "$target_path" ]]; then
    if [[ "$FORCE" -ne 1 ]]; then
      fail "skill already installed: $skill_name (use --force to replace)"
    fi

    mkdir -p "$backup_root"
    mv "$target_path" "$backup_root/$skill_name"
  fi

  cp -R "$skill_path" "$target_path"
  installed+=("$skill_name")
done

printf 'Installed %d skills into %s\n' "${#installed[@]}" "$TARGET_ROOT"
printf 'Skills:\n'
for name in "${installed[@]}"; do
  printf '  - %s\n' "$name"
done

if [[ -d "$backup_root" ]]; then
  printf 'Backups:\n  %s\n' "$backup_root"
fi
