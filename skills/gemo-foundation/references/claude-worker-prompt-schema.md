# Claude Worker Prompt Schema

This schema defines the canonical handoff packet that `gemo-orchestrator` renders for delegated
Claude implementation workers.

The schema is intentionally task-local. It must include the context that changes implementation
decisions and omit orchestration-only metadata that does not help Claude write better code.

Use `../scripts/render-claude-worker-prompt.sh` to generate packets that follow this schema.

## Compatibility Rules

- `gemo-orchestrator` remains the control plane.
- The renderer only compiles worker context. It does not launch workers, update trace files,
  route review, or change task state.
- The rendered packet is the content for the execution-plan `Initial Handoff Artifact`.
- `cmux-launch-claude-worker.sh` remains the launch mechanism and appends the collaboration footer.
- Rework rounds regenerate the same artifact path with fresh review delta instead of hand-editing a
  long bespoke prompt.

## Omit By Default

Do not include these unless they directly change code behavior:

- workspace IDs
- pane or surface IDs
- sidebar status keys or progress values
- reviewer agent IDs
- old closed review rounds outside the latest open or recent delta
- cmux notification details already handled by the launcher footer
- generic orchestration commentary that does not change implementation choices

## Canonical Packet Shape

The rendered markdown packet must contain these sections in order.

### 1. Document Control

Required fields:

- `Schema Version`
- `Generated At`
- `Feature Directory`
- `Task ID`
- `Task Title`
- `Worker Skill`
- `Role`
- `Repo / Scope`
- `Worktree / Branch`

### 2. Task Goal

Required fields:

- short task goal derived from `Title`
- `Depends On`
- `Exit Evidence`

Optional:

- `Current Blockers` from `feature-state.md` when they materially constrain the implementation

### 3. Files To Read First

Required:

- `04-execution-plan.md`
- `decisions.md`
- `feature-state.md`

Conditional:

- `reviews.md` when recent review rounds exist for the task
- `events.jsonl` when recent task events exist
- source files named by the latest review delta when available

### 4. Relevant Decisions

Required:

- recent accepted feature decisions that constrain the task

Recommended shape:

- one line per decision with `Decision ID`, `Phase`, chosen option, and consequence

### 5. Recent Review Delta

Required when review history exists for the task:

- latest review rounds for the task
- reviewer name
- outcome status
- summary
- open findings only
- per-finding `Severity`, `Issue`, `Required Action`, and `File`

Rules:

- default to the latest two review rounds for the task
- include passed rounds only when they close a sibling blocker family relevant to the current
  rework
- do not paste the whole review log

### 6. Recent Event Context

Required:

- last few task-local events that explain why the task is in its current state

Recommended shape:

- timestamp, event type, summary

Rules:

- default to the latest six events for the task
- omit unrelated feature events

### 7. Implementation Doctrine

Required:

- selected sections from the canonical worker skill

Recommended extraction:

- `Working Rules`
- `Review Loop Prevention`
- `Validation And Handoff`
- `Delivery Expectations`
- any stack-specific must-have section for the chosen worker skill

Rules:

- the skill remains the source of truth
- render only the sections that materially guide implementation
- do not duplicate orchestration-only rules here

### 8. Validation Required

Required:

- task `Exit Evidence`
- review-driven regression obligations from the latest open findings

### 9. Escalation Contract

Required:

- `Retry Window`
- `Escalation Condition`

### 10. First Response

Required instructions:

- acknowledge scope
- name the first files or invariants to inspect
- report any immediate blocker if one exists

### 11. Collaboration Note

Required:

- short note that the launcher appends the cmux reporting footer and that the worker must use it

## Determinism Rules

- same task, same feature trace state, and same worker skill should render the same section order
  and the same selected context
- prompt regeneration should overwrite the prior artifact path, not create ad hoc variants
- the renderer should degrade cleanly when reviews or events are empty

## Recommended CLI

```bash
render-claude-worker-prompt.sh \
  --feature-dir /repo/docs/features/<slug>/agentic \
  --task-id IP-EXEC-01 \
  --worker-skill gemo-backend \
  --output /repo/docs/features/<slug>/agentic/handoffs/IP-EXEC-01-backend-auth.md
```

## Source Of Truth

- worker policy lives in the worker skill
- task policy lives in `04-execution-plan.md`
- feature state lives in `feature-state.md`
- review delta lives in `reviews.md`
- event chronology lives in `events.jsonl`
- decision constraints live in `decisions.md`

The rendered prompt is only a compiled projection of those sources.
