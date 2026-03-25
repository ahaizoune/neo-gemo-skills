#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  cmux-validate-envelope.sh "<envelope>"
  printf '%s' "<envelope>" | cmux-validate-envelope.sh

Validates a single-line cmux collaboration envelope.
EOF
}

fail() {
  echo "invalid envelope: $*" >&2
  exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

line="${1:-}"
if [[ -z "$line" && ! -t 0 ]]; then
  line="$(cat)"
fi

[[ -n "$line" ]] || fail "missing input"
[[ "$line" != *$'\n'* ]] || fail "envelope must be a single line"

python3 - "$line" <<'PY'
import re
import sys

line = sys.argv[1]
match = re.match(r"^\[([^\]]+)\](?:\s(.*))?$", line)
if not match:
    print("invalid envelope: expected leading [KEY=VALUE ...] envelope", file=sys.stderr)
    sys.exit(1)

header = match.group(1)
body = match.group(2) or ""

fields = {}
for token in header.split():
    if "=" not in token:
        print(f"invalid envelope: header token '{token}' is not KEY=VALUE", file=sys.stderr)
        sys.exit(1)
    key, value = token.split("=", 1)
    if not key or not value:
        print(f"invalid envelope: header token '{token}' has an empty key or value", file=sys.stderr)
        sys.exit(1)
    if key in fields:
        print(f"invalid envelope: duplicate header field '{key}'", file=sys.stderr)
        sys.exit(1)
    fields[key] = value

for required in ("FROM", "TO", "TYPE", "TS"):
    if not fields.get(required):
        print(f"invalid envelope: missing required field '{required}'", file=sys.stderr)
        sys.exit(1)

allowed = {"HELLO", "HELLO_ACK", "REQ", "ACK", "INFO", "RES", "ERR", "BUSY"}
msg_type = fields["TYPE"]
if msg_type not in allowed:
    print(f"invalid envelope: unsupported TYPE '{msg_type}'", file=sys.stderr)
    sys.exit(1)

surface_pattern = re.compile(r"^surface:\d+$")
for ref_key in ("FROM", "TO"):
    if not surface_pattern.match(fields[ref_key]):
        print(f"invalid envelope: {ref_key} must look like surface:N", file=sys.stderr)
        sys.exit(1)

if not re.fullmatch(r"\d{10,16}", fields["TS"]):
    print("invalid envelope: TS must be a numeric epoch timestamp", file=sys.stderr)
    sys.exit(1)

if msg_type in {"REQ", "ACK", "INFO", "RES", "ERR", "BUSY"} and not fields.get("CID"):
    print(f"invalid envelope: TYPE {msg_type} requires CID", file=sys.stderr)
    sys.exit(1)

if msg_type == "REQ" and not re.match(r"^size=(S|M|L)(?:\s|$)", body):
    print("invalid envelope: REQ body must begin with size=S|M|L", file=sys.stderr)
    sys.exit(1)

print(f"valid TYPE={msg_type} FROM={fields['FROM']} TO={fields['TO']}")
PY
