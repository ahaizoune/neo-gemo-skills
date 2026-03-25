# Gemo cmux Topology And Protocol

Use this reference for the canonical Gemo cmux operating model.

The installed local `cmux` build currently supports:

- `cmux version`: `0.62.0`
- `cmux capabilities --json`: `access_mode=cmuxOnly`
- sidebar metadata commands such as `set-status`, `set-progress`, `log`, and `sidebar-state`
- `claude-hook` subcommands including `session-start`, `active`, `stop`, `idle`, `notification`,
  `notify`, and `prompt-submit`

## Authority Model

- Orchestrator is the only authority for task control.
- Specialists do not hand tasks to each other directly.
- Specialists may send a tightly scoped clarification directly only when the orchestrator would add
  unnecessary latency.
- Any allowed direct clarification must be logged back to the feature trace.

## Workspace Model

- one `cmux workspace` per feature
- orchestrator surface is the anchor surface
- keep the anchor pane visible
- use one right lane for browser/docs as needed
- use one bottom lane for debug/test/log surfaces
- do not create extra splits casually; reuse panes via `new-surface --pane ...`

## Role Layout

Recommended feature workspace layout:

- anchor pane: orchestrator or architect
- right pane: browser / docs / visual verification
- bottom pane: debug, tests, logs, one-shot validation
- additional terminal surfaces in existing panes for specialists

## Protocol

Base protocol is the proven envelope model:

```text
[FROM=<surface> TO=<surface> TYPE=<type> CID=<id> TS=<epoch_ms>] <body>
```

Lifecycle:

```text
HELLO -> HELLO_ACK -> REQ -> ACK|BUSY -> INFO* -> RES|ERR
```

Rules:

- `REQ`, `ACK`, `BUSY`, `INFO`, `RES`, and `ERR` require `CID`
- `REQ` body starts with `size=S|M|L`
- do not assume acceptance until `ACK`
- do not use scrollback as a fake inbox
- serialize sends per target

## Gemo-Specific Constraints

- orchestrator assigns work and owns acceptance
- reviewer findings route back through orchestrator
- direct worker clarification cannot:
  - assign work
  - reassign work
  - approve work
  - reject work
  - change rollout state

## Escalation

Recommended default:

- retry twice on a blocked subtask
- escalate after failed retries or when the retry window expires
- record escalation in `events.jsonl` and `feature-state.md`

## Useful Local Commands

```bash
cmux identify --json
cmux tree --json
cmux workspace-action --help
cmux tab-action --help
cmux claude-hook --help
cmux set-status role "orchestrator" --icon sparkle --color "#0a84ff"
cmux set-progress 0.4 --label "backend implementation"
cmux log --level progress --source orchestrator "review round 1 in progress"
cmux sidebar-state
```
