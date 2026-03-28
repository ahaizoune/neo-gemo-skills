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
- the orchestrator pane is the main pane for the workspace and must remain the visible control
  plane rather than being repurposed for docs, tests, logs, or specialist work
- use one right lane for browser/docs as needed
- use one bottom lane for debug/test/log surfaces
- do not create extra splits casually; reuse panes via `new-surface --pane ...`

## Primitive Mapping

- `cmux new-workspace` creates the feature workspace and its initial anchor surface
- `cmux new-split <left|right|up|down> --surface <anchor-surface>` is the preferred way to create
  the structural right or bottom lane from a known anchor surface
- `cmux new-pane --direction <left|right|up|down> --workspace <workspace>` is acceptable when
  automation only has workspace context and no reliable anchor surface ref yet
- `cmux new-surface --pane <pane>` is the preferred way to add more terminal or browser tabs into
  an existing lane without changing the layout
- `cmux rename-tab --surface <surface> <title>` is the canonical way to normalize surface titles
  after creation
- the local CLI does not expose `split-pane`; use `new-split`, `new-pane`, and `new-surface`

## Pane And Surface Creation Protocol

- create the feature workspace once with `cmux new-workspace`
- normalize the initial anchor surface title to `orchestrator` as soon as the workspace is created
- preserve the anchor pane as the main pane for the life of the workspace; do not move the
  orchestrator surface out of it or hide the control loop behind secondary tabs in that pane
- create the right lane once from the anchor surface when docs, browser, or visual verification is
  needed
- create the bottom lane once from the anchor surface when tests, logs, debug probes, or one-shot
  validation need a dedicated visible lane
- after the structural panes exist, open later work into those lanes with `cmux new-surface --pane`
  instead of creating more panes
- do not open specialist, browser, or debug surfaces into the orchestrator pane once the durable
  lanes exist unless the human explicitly wants a temporary exception
- create an extra pane only when the right and bottom lanes are both already serving durable roles
  and another always-visible lane is required; record the reason in the execution plan before doing
  it
- when a surface is created in the wrong pane, fix it with `move-surface` or `drag-surface-to-split`
  instead of normalizing the mistake into a new layout convention

## Naming Convention

- workspace title: use the feature slug or `FEATURE_ID feature-slug`; keep it stable for the life
  of the feature
- anchor surface title: `orchestrator`
- anchor pane role: `main`
- right-lane default titles: `docs`, `browser-verify`, `figma`
- bottom-lane default titles: `tests`, `logs`, `debug`
- specialist surface titles: use a stable lowercase hyphenated form of `task-id + role`, for
  example `t03-backend-auth` or `ip-exec-01-frontend-portal`
- keep titles unique within a workspace; avoid ambiguous titles like `backend`, `backend-2`, or
  repeated `terminal`
- rename surfaces immediately after creation when the default title is too generic for the worker
  launcher and checker scripts to resolve safely

## Role Layout

Recommended feature workspace layout:

- anchor pane: orchestrator main pane
- right pane: browser / docs / visual verification
- bottom pane: debug, tests, logs, one-shot validation
- additional terminal surfaces in existing panes for specialists

## Worker Launch Contract

- Creating a workspace, pane, or surface is not the same thing as launching a worker.
- `cmux claude-hook ...` updates lifecycle metadata for an existing Claude session. It does not
  start Claude.
- For delegated implementation work, the orchestrator must launch a live worker in the assigned
  surface by using `cmux new-workspace --command ...`, `cmux respawn-pane --surface ... --command ...`,
  or the bundled `scripts/cmux-launch-claude-worker.sh` helper.
- Prefer a generated worker packet over a hand-written long prompt. Render the handoff artifact
  from `references/claude-worker-prompt-schema.md` via
  `scripts/render-claude-worker-prompt.sh`, then pass that artifact to the Claude launcher.
- Default delegated Claude launch mode is YOLO: use `--dangerously-skip-permissions` unless the
  user explicitly requires a stricter permission model for that task.
- The launch contract for each delegated task includes:
  - worker runtime
  - worker permission mode
  - worktree / branch
  - owning cmux surface
  - launch command
  - initial handoff prompt or prompt artifact
  - launch verification method
  - worker notification contract
- Do not mark a delegated task `in_progress` until the worker launch is verified. Preferred
  verification is a first worker acknowledgment through the canonical envelope protocol. Explicit
  manual verification of the live surface is acceptable when the worker cannot emit an envelope yet.
- If the worker never launches or never acknowledges, keep the task `queued` or mark it `blocked`.
  Do not let the orchestrator silently absorb the scoped implementation while the trace still
  claims the task is delegated.

## Worker Supervision Contract

- Launch verification is the beginning of delegated supervision, not the end of it.
- After `worker_launch_verified`, the orchestrator must supervise every delegated worker until the
  output is accepted, rejected, or explicitly blocked.
- Default supervision cadence is one sweep every 45 seconds while any delegated task is
  `in_progress`.
- Run an extra sweep immediately after any orchestrator-local step that took longer than 30
  seconds, before reporting feature status, and before launching dependent or reviewer work.
- Preferred one-shot checker is `scripts/cmux-check-claude-worker.sh`; direct `cmux read-screen`
  inspection is acceptable when deeper context is needed.
- Canonical supervision states are:
  - `running`: no visible interactive gate; task remains `in_progress`
  - `awaiting_plan_approval`: Claude completed the required initial plan and is waiting at the
    execution gate before any edits
  - `attention_required`: Claude is waiting on an approval or other interactive prompt
  - `awaiting_acceptance`: Claude reached the `accept edits on` result gate and is waiting for
    orchestrator review
  - `unknown`: no trustworthy classification; inspect the live surface directly
- Implementation workers should begin in plan mode before editing. A plan gate right after launch
  is expected behavior, not a worker defect.
- When a worker is `awaiting_plan_approval`, route the plan to the human or orchestrator decision
  path, keep the task out of ordinary implementation status until approval, and only then allow
  edits to begin.
- When a worker is `attention_required`, surface it immediately in sidebar metadata, logs, and the
  feature trace. Treat it as blocked until the prompt is resolved.
- When a worker is `awaiting_acceptance`, stop treating the task as ordinary `in_progress` work.
  Review the worktree diff immediately, accept or reject within 2 minutes, then route either review
  or rework before starting unrelated specialist work.
- `claude-hook` lifecycle events such as `session-start`, `prompt-submit`, `notification`, and
  `stop` are useful hints, but they are not a substitute for supervision sweeps. They do not tell
  the orchestrator whether Claude is waiting on an internal accept/reject gate.

## Worker Notification Contract

- A delegated worker must not finish or block silently.
- Every delegated task must tell the worker how to notify the orchestrator when:
  - the first meaningful checkpoint lands
  - the worker is blocked or needs attention
  - the owned output is ready for orchestrator acceptance
- Preferred helper is `scripts/cmux-worker-report.sh`.
- Recommended status mapping:
  - `progress` -> sends `INFO` with `status=progress`
  - `blocked` or `attention` -> sends `ERR` with `status=blocked` or `status=attention_required`
  - `result-ready` -> sends `RES` with `status=result_ready`
- Worker notifications complement supervision sweeps; they do not replace orchestrator authority.

## Reviewer Completion Contract

- Reviewer agents are launched through the Codex subagent runtime, not inside cmux worker
  surfaces.
- Do not expect reviewer agents to call `scripts/cmux-worker-report.sh`; that helper is only for
  live cmux worker surfaces.
- Reviewer completion source of truth is the reviewer agent final completion notification
  (`subagent_notification` / `wait_agent` result).
- Reviewer supervision should use a long-running wait loop rather than short polling.
- Preferred loop is `wait_agent` with `timeout_ms=120000`; `timeout_ms=60000` is acceptable when a
  shorter cadence is useful.
- A timed-out wait does not mean review failed or finished; it only means the reviewer is still in
  progress and the orchestrator should continue waiting.
- When a reviewer completes, the orchestrator must:
  - mirror the outcome to the active workspace with `scripts/cmux-reviewer-report.sh`
  - append `review_agent_completed` to `events.jsonl`
  - update `reviews.md` and `feature-state.md`
  - route either rework, follow-up review, or acceptance without leaving the task idle
- Recommended reviewer status mapping:
  - `passed` -> non-blocking review completion
  - `failed` -> blocking findings returned
  - `blocked` -> reviewer could not complete and needs orchestrator attention

## Sidebar Status Contract

- Keep a stable status key per task or role so the orchestrator can overwrite the same sidebar pill
  over time.
- Do not use a bare state token such as `in_progress` or `queued` as the visible value.
- Preferred visible value format is `TASK_ID short-label state`.
- Example mappings:
  - key `backend-auth` -> value `IP-EXEC-01 backend auth/session in_progress`
  - key `frontend-portal` -> value `IP-EXEC-03 portal shell/dashboard queued`
  - key `orchestrator` -> value `IP-EXEC-05 review routing in_progress`
- Use `scripts/cmux-set-task-status.sh` when available so icon/color/state mapping stays
  consistent.

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
cmux new-workspace --cwd /repo --command "claude -n orchestrator --dangerously-skip-permissions"
main="$CMUX_SURFACE_ID"
cmux rename-tab --surface "$main" "orchestrator"
cmux new-split right --surface "$main"
cmux new-split down --surface "$main"
# inspect pane refs before opening more surfaces into the durable lanes
cmux tree --json
cmux new-surface --pane pane:<right-pane-ref>
cmux new-surface --type browser --pane pane:<right-pane-ref> --url http://localhost:3000
cmux rename-tab --surface surface:<docs-surface-ref> "docs"
cmux rename-tab --surface surface:<browser-surface-ref> "browser-verify"
cmux respawn-pane --surface surface:21 --command "cd /repo && claude -n backend-auth --dangerously-skip-permissions"
cmux workspace-action --help
cmux tab-action --help
cmux claude-hook --help
cmux set-status role "orchestrator" --icon sparkle --color "#0a84ff"
cmux set-progress 0.4 --label "backend implementation"
cmux log --level progress --source orchestrator "review round 1 in progress"
cmux sidebar-state
./scripts/cmux-check-claude-worker.sh --workspace workspace:1 --surface backend-auth --json
./scripts/cmux-launch-claude-worker.sh --surface backend-auth --cwd /repo --name backend-auth --task-id IP-EXEC-01
./scripts/cmux-set-task-status.sh --workspace workspace:1 backend-auth IP-EXEC-01 "backend auth/session" in_progress
./scripts/cmux-worker-report.sh progress IP-EXEC-01 "first meaningful checkpoint landed"
./scripts/cmux-worker-report.sh result-ready IP-EXEC-01 "routes and tests ready for orchestrator review"
./scripts/cmux-reviewer-report.sh --workspace workspace:1 failed IP-EXEC-01 Laplace gemo-backend-reviewer "3 blocking findings returned"
```
