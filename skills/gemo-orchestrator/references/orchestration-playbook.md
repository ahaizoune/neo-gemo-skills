# Orchestration Playbook

Use this reference to keep the orchestrator mode-aware, artifact-driven, and consistent across
features.

## Canonical Feature Folder

Every orchestrated feature should use the same folder layout:

```text
docs/features/<feature-slug>/agentic/
├── feature-state.md
├── 01-discovery.md
├── 02-grooming.md
├── 03-architecture.md
├── 04-execution-plan.md
├── decisions.md
├── events.jsonl
├── reviews.md
└── rollout.md
```

Do not invent alternative file names unless there is a compelling reason and the orchestrator
records the exception.

## Cross-Cutting Documents

- `feature-state.md`: current status, phase, ownership, approvals, blockers, and document index
- `decisions.md`: append-only decision ledger
- `events.jsonl`: append-only event stream

These three documents are updated throughout the lifecycle.

## Phase Framework

### 1. Discovery

- primary mode: `brainstorm`
- primary owner: orchestrator acting with product-manager and architect behavior
- primary document: `01-discovery.md`
- supporting documents: `feature-state.md`, `events.jsonl`
- exit condition: problem framing, feature map, MVP split, and open questions are explicit enough
  to move into formal grooming

### 2. Formal Grooming

- primary mode: `formal-grooming`
- primary owner: orchestrator
- primary document: `02-grooming.md`
- supporting documents: `feature-state.md`, `decisions.md`, `events.jsonl`
- exit condition: scope, non-goals, success criteria, repos, disciplines, and reviewer set are
  explicit enough to frame architecture and request the human gate

### 3. Architecture

- primary mode: `formal-grooming`
- primary owner: orchestrator with architecture focus
- primary document: `03-architecture.md`
- supporting documents: `feature-state.md`, `decisions.md`, `events.jsonl`
- exit condition: a recommended option exists, risks are visible, and the human approval packet is
  ready

### 4. Execution Plan

- primary mode: `execution`
- primary owner: orchestrator
- primary document: `04-execution-plan.md`
- supporting documents: `feature-state.md`, `decisions.md`, `events.jsonl`
- exit condition: task graph, ownership, reviewer routing, reviewer-agent launch strategy, cmux
  plan, worker-launch strategy, worker-supervision cadence, and escalation rules are explicit

### 5. Review And Verification

- primary mode: `execution`
- primary owner: orchestrator with reviewers
- primary document: `reviews.md`
- supporting documents: `feature-state.md`, `events.jsonl`
- exit condition: required findings are resolved or consciously deferred and reviewer status is
  explicit

### 6. Rollout And Closeout

- primary mode: `closeout`
- primary owner: orchestrator
- primary document: `rollout.md`
- supporting documents: `feature-state.md`, `decisions.md`, `events.jsonl`
- exit condition: rollout sequence, rollback, residual risk, and product knowledge base update
  status are explicit

## Packet Templates

Use these canonical template files when scaffolding or refreshing a feature:

- `templates/feature-trace/feature-state.md`
- `templates/feature-trace/01-discovery.md`
- `templates/feature-trace/02-grooming.md`
- `templates/feature-trace/03-architecture.md`
- `templates/feature-trace/04-execution-plan.md`
- `templates/feature-trace/decisions.md`
- `templates/feature-trace/reviews.md`
- `templates/feature-trace/rollout.md`

## Human Gate Checklist

- scope is explicit
- non-goals are explicit
- impacted repos are named
- architecture option is chosen
- reviewer set is known
- rollout sensitivity is called out

## Task Graph Quality Bar

- each task has one owner
- repo or file scope is explicit
- reviewer path is explicit
- reviewer agent skill set and review launch trigger are explicit
- escalation window is explicit
- cross-repo dependencies are explicit
- delegated tasks have explicit worker runtime, worker permission mode, worktree / branch, cmux
  surface, launch command, prompt schema, prompt render command, launch verification, worker
  notification contract, supervision cadence, result-ready detection, review handoff mode,
  next-step trigger, stable sidebar status key, and task-labeled sidebar value format

## Worker Prompt Rendering Rule

- for delegated Claude implementation, prefer generated worker packets over hand-written long
  prompts
- canonical schema lives in `../gemo-foundation/references/claude-worker-prompt-schema.md`
- canonical renderer lives in `../gemo-foundation/scripts/render-claude-worker-prompt.sh`
- the renderer compiles only implementation-relevant context:
  - task contract from `04-execution-plan.md`
  - accepted decisions from `decisions.md`
  - current blockers and architecture summary from `feature-state.md`
  - latest review delta from `reviews.md`
  - recent task-local chronology from `events.jsonl`
  - doctrine sections from the canonical worker skill
- omit orchestration-only metadata that does not change implementation decisions:
  - workspace ids
  - sidebar keys and progress values
  - reviewer agent ids
  - old closed review history outside the latest active delta
- regenerate the same handoff artifact path on each rework round instead of creating ad hoc prompt
  variants

## Worker Launch Default

- delegated Claude workers launch in YOLO mode by default via `--dangerously-skip-permissions`
- only deviate to a stricter permission model when the user explicitly asks for it
- when a task deviates from the default, record the reason in the execution plan before launch
- preferred launch path is:
  - render worker packet with `render-claude-worker-prompt.sh`
  - pass the rendered artifact to `cmux-launch-claude-worker.sh --prompt-file ...`

## Worker Notification Rule

- every delegated worker must notify the orchestrator on:
  - first meaningful implementation checkpoint
  - blocked or attention-required state
  - result-ready state before idling
- preferred path is `scripts/cmux-worker-report.sh`
- the launch command or handoff contract must include the task ID and orchestrator peer so the
  worker can report without improvising
- silent worker completion is a delivery defect; do not rely only on polling when the worker can
  proactively signal the next step

## Worker Supervision Rule

- after `worker_launch_verified`, start active supervision immediately
- while any delegated task is `in_progress`, sweep worker status at least every 45 seconds
- run an extra sweep after any orchestrator-local step longer than 30 seconds and before reporting
  status or launching dependent work
- when the orchestrator surface receives a `RES` or `ERR` worker notification, inspect that task
  before unrelated work
- use `scripts/cmux-check-claude-worker.sh` as the default fast-path classifier and inspect the
  live surface directly when the result is `unknown` or the context is ambiguous
- if a worker reaches `awaiting_acceptance`, route it into delegated reviewer handoff and launch
  the required reviewer agent(s) within 2 minutes
- if a worker reaches `attention_required`, log it, surface it in sidebar metadata, and treat the
  task as blocked until the prompt is cleared
- do not leave a completed delegated output parked as generic `in_progress`; it must move to
  `awaiting_acceptance`, delegated reviewer handoff, rework, or reviewer pass
- do not wait for a user nudge after a worker or reviewer event arrives if the next control action
  is already implied by the task graph or review plan; run the orchestration step immediately

## Reviewer Delegation Rule

- formal review of delegated implementation must be performed by reviewer agent(s), not by the
  orchestrator surface itself
- spawn one reviewer agent per required reviewer skill, and run independent reviewer skills in
  parallel when possible
- examples:
  - backend task with auth impact: `gemo-backend-reviewer` plus `gemo-security-reviewer`
  - frontend task with auth impact: `gemo-react-reviewer` plus `gemo-security-reviewer`
  - infra task: `gemo-devops-reviewer`
- orchestrator may do a light ownership / scope / dependency sanity check to route the review, but
  that is not the formal code review
- orchestrator is the connector between implementation and reviewers:
  - hand off scope, changed files, and result-ready summary to reviewer agents
  - collect reviewer findings
  - write findings into `reviews.md` and `events.jsonl`
  - relay rework instructions back to the implementation worker
  - relaunch follow-up review after rework when needed
- reviewer agents do not notify through `cmux-worker-report.sh`; they complete through the Codex
  subagent runtime
- reviewer completion source of truth is the reviewer agent final completion notification
  (`subagent_notification` / `wait_agent` result)
- reviewer supervision must run as a wait loop, not a one-off short poll
- preferred reviewer wait cadence is one `wait_agent` call every 120000 ms; 60000 ms is an
  acceptable shorter cadence when needed
- a reviewer wait timeout means only "still in progress"; keep the review active and continue the
  loop until all required reviewer agents resolve or a blocker is raised
- if a reviewer returns early with a partial finding while another reviewer is still running, update
  the trace and workspace immediately, keep the remaining reviewer loop active, and do not wait for
  the user to ask what happened
- within 60 seconds of reviewer completion, mirror the outcome into the active workspace via
  `scripts/cmux-reviewer-report.sh`, then update `reviews.md`, `feature-state.md`, and
  `events.jsonl` before routing the next step

## Document Update Rules

- update `feature-state.md` after every meaningful phase transition
- append an event to `events.jsonl` for every meaningful state transition
- record decisions in `decisions.md` when an option is chosen, not later
- do not mark delegated implementation tasks `in_progress` until worker launch is verified
- append explicit events when delegated work becomes `attention_required`, `awaiting_acceptance`,
  accepted, or routed to rework
- append explicit events when reviewer agents are requested, when findings are received, and when
  review passes or fails
- do not leave reviewer completion visible only in the assistant runtime; mirror it into cmux
  notifications/logs and the feature trace immediately
- sidebar task statuses must stay readable to a human scanning the workspace panel: keep the key
  stable per task/surface, but set the visible value to `TASK_ID short-label state`
- if the orchestrator temporarily absorbs a delegated task, record explicit reassignment before
  coding begins
- do not mark a phase complete while its primary packet is stale
- do not promote work to rollout readiness while reviewer status is ambiguous

## Rework Rule

- reject unclear or incomplete specialist output quickly
- route reviewer findings and rework back to the same specialist unless ownership changed
  materially
- preserve orchestrator authority over acceptance and promotion
