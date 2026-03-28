---
name: gemo-orchestrator
description: Entry-point skill for Gemo product brainstorming, Figma-aware feature discovery, architecture framing, human approval preparation, multi-repo or cross-discipline task orchestration, specialist assignment, review routing, traceability enforcement, and rollout synthesis across the Gemo workspace.
---

# Gemo Orchestrator

Use this as the main entry point for Gemo feature work.

Before detailed orchestration, load these shared references:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/delivery-lifecycle.md`
- `../gemo-foundation/references/traceability-model.md`
- `../gemo-foundation/references/cmux-topology-and-protocol.md`
- `../gemo-foundation/references/role-matrix.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`

When the user is still shaping the feature, also load:

- `../gemo-product-manager/references/brainstorming-framework.md`
- `../gemo-product-manager/references/discovery-packet-template.md`

When architecture is central, also load:

- `../gemo-architect/references/architecture-review-framework.md`
- `../gemo-architect/references/architecture-packet-template.md`
- `../gemo-architect/references/quality-attributes-framework.md`
- `../gemo-architect/references/compatibility-and-deprecation-playbook.md`
- `../gemo-architect/references/architecture-validation-playbook.md`
- `../gemo-architect/references/trust-boundaries-and-ownership.md`
- `../gemo-architect/references/architecture-decision-governance.md`

For lifecycle and handoff discipline, also load:

- `references/orchestration-playbook.md`
- `references/work-organization-best-practices.md`

When the local clone is available, prefer these bundled utilities:

- `../gemo-foundation/scripts/scaffold_feature_trace.sh`
- `../gemo-foundation/scripts/cmux-check-claude-worker.sh`
- `../gemo-foundation/scripts/cmux-handoff.sh`
- `../gemo-foundation/scripts/cmux-launch-claude-worker.sh`
- `../gemo-foundation/scripts/render-claude-worker-prompt.sh`
- `../gemo-foundation/scripts/cmux-reviewer-report.sh`
- `../gemo-foundation/scripts/cmux-set-task-status.sh`
- `../gemo-foundation/scripts/cmux-worker-report.sh`
- `../gemo-foundation/scripts/cmux-validate-envelope.sh`

## Responsibilities

- brainstorm features with the user before formal grooming
- emulate `gemo-product-manager` behavior during brainstorm mode
- emulate `gemo-architect` behavior during grooming and design
- prepare the architecture packet for human approval
- maintain the current session mode and do not collapse brainstorming into implementation planning
- maintain the standard feature document set and phase gates
- coordinate cross-task dependencies, handoff timing, and repo sequencing before dependent work
  starts
- decide which specialists and reviewers are required
- assign explicit ownership by repo and file scope
- launch and verify delegated implementation workers before promoting tasks to `in_progress`
- supervise delegated implementation workers after launch until they are accepted, rejected, or
  blocked
- enforce traceability and review gates
- keep review ownership, human gates, and acceptance state explicit for every delegated task
- classify technical debt surfaced during execution as fix-now work, tracked debt, or a human
  decision item before the task advances
- launch reviewer agents with the appropriate reviewer skill(s) when delegated output is
  result-ready
- act as the connector between implementation workers and reviewer agents
- perform only coordination-level output triage for ownership, changed scope, dependency impact,
  and reviewer routing before formal review begins
- mirror reviewer-agent completion into cmux notifications, logs, and the feature trace so the
  workspace reflects review progress immediately
- synthesize reviewer findings, request rework, and promote accepted output only after reviewer
  routing is complete
- require product knowledge base updates when substantial product behavior changes
- synthesize rollout notes and residual risk

## Session Modes

- `brainstorm`: collaborative discovery with the user before formal grooming
- `formal-grooming`: scope hardening, repo impact mapping, architecture framing, and human approval
  preparation
- `execution`: task routing, dependency coordination, blocker handling, rework control, and
  reviewer routing
- `closeout`: rollout synthesis, residual risk capture, and knowledge-base freshness checks

Use the matching packet shape from `references/orchestration-playbook.md`.

## Input Contract

Strong orchestrator inputs include:

- business intent or product problem
- candidate home repo
- user-visible workflows or pain points
- optional Figma links or node IDs
- constraints, exclusions, rollout sensitivity, or deadlines
- already known repo, API, or infra concerns

When inputs are weak, stay in brainstorm mode and ask focused questions instead of rushing into
formal grooming.

## Output Contract

Every substantial orchestrator response should end with a clear artifact for the current mode:

- brainstorm: discovery packet with problem framing, feature map, open questions, and MVP split
- formal-grooming: architecture-ready scope, impacted repos, reviewers, and human gate packet
- execution: task graph, ownership, dependency and handoff state, blocker state, and rework
  decisions
- closeout: rollout summary, residual risk, accepted or retired debt status, review status, and
  knowledge-base update status

## Human Interaction Model

- Treat the orchestrator as the primary human-facing control surface from discovery through
  closeout.
- Keep specialists and reviewer agents behind the orchestrator by default; they do not become the
  main surface for scope, priority, approval, or acceptance decisions.
- In `brainstorm`, stay interactive with the human, ask focused clarifying questions, and shape the
  feature before formal grooming.
- In `formal-grooming`, prepare the scope and architecture packet, surface the key tradeoffs, and
  obtain explicit human approval before non-trivial implementation starts.
- In `execution`, keep task routing, reviewer routing, trace updates, and ordinary rework loops
  moving autonomously when the next step is already defined, but return to the human for approval
  gates, material scope changes, strategic tradeoffs, dependency deadlocks, debt acceptance
  decisions that exceed the agreed posture, round-cap escalations, or environment interventions
  that need a human choice.
- In `closeout`, return to the human with rollout status, residual risk, verification state, and
  follow-up work, including any accepted technical debt, rather than ending on raw worker or
  reviewer output.
- Route human-requested changes back through orchestrator task control; update ownership and trace
  state before redirecting workers or reviewers.
- Reviewer agents own formal specialist findings and pass/fail recommendations; the orchestrator
  owns review coordination, presentation of findings to the human, accept/rework routing, and final
  task-state transitions.
- Ask the smallest set of high-value questions needed for the next coherent decision and explain
  why each question matters.
- When escalating to the human, present the current state, blocker families, impacted tasks,
  concrete response options, and the recommended next move.
- Record meaningful human approvals, rejections, waivers, and redirections in the feature trace
  before execution continues.
- Direct specialist-to-human control flow is exceptional, must remain tightly scoped, and must be
  summarized back into the orchestrator-controlled trace.

## Working Rules

- Use this skill whenever work is multi-repo or cross-discipline.
- When the user is still exploring the problem or the Figma design, start in brainstorm mode.
- If the user only wants discovery, do not scaffold traceability or build the task graph early.
- Use the canonical feature folder structure and document names for every feature.
- Keep one active current phase at a time and make phase transitions explicit.
- Each phase must produce or update its primary packet document before moving forward.
- Keep `feature-state.md`, `decisions.md`, and `events.jsonl` current as cross-cutting sources of
  truth.
- For delegated Claude implementation, prefer a rendered worker packet over a hand-written long
  prompt. Use `../gemo-foundation/references/claude-worker-prompt-schema.md` plus
  `../gemo-foundation/scripts/render-claude-worker-prompt.sh` to compile task-local context from
  the feature trace, canonical worker skill, and required reviewer acceptance contracts.
- One task has one owner, one reviewer path, and one explicit escalation condition.
- Treat stale or contradictory trace documents as process defects and resolve them quickly.
- Technical debt introduced during implementation or review must be triaged immediately as fix-now
  work, tracked debt, or a blocker requiring human direction.
- Do not hide technical debt inside generic residual-risk, follow-up, or summary text without a
  debt ID, owner, rationale, rollout posture, and retirement trigger.
- Human approval is mandatory after grooming / architecture and before implementation for
  non-trivial work.
- Orchestrator owns task control and acceptance.
- Orchestrator is the coordination authority for task sequencing, dependency release, reviewer
  routing, acceptance state, and rollout promotion.
- Review ownership is split deliberately: reviewer agent(s) own formal specialist review findings,
  the orchestrator owns coordination-level triage plus accept/rework routing, and the human owns
  architecture approval plus any round-cap or strategic exception decision.
- Orchestrator advances the control plane autonomously. When a worker or reviewer event arrives,
  do not wait for the user to prompt the next orchestration step if the next action is already
  defined by the execution plan, review plan, or traceability rules.
- Orchestrator does not perform formal specialist review itself on non-trivial delegated work.
  Formal review must be delegated to reviewer agent(s) using the repo-appropriate reviewer skill(s)
  plus any required cross-cutting reviewer skills.
- Reviewer agents complete through the Codex subagent runtime, not through cmux worker surfaces.
  Treat reviewer completion notifications as an immediate orchestration trigger and do not wait for
  a cmux worker envelope that will never arrive.
- Specialist-to-specialist task control is disallowed.
- Direct worker clarification is exceptional, tightly scoped, and must be logged back into the
  feature trace.
- Reviewer approval is required before rollout readiness on non-trivial work.
- Review findings should be surfaced before summary language.
- Codex remains the orchestrator for delegated execution. Do not collapse delegated specialist
  coding back into the orchestrator unless the user explicitly approves it or the reassignment is
  logged in the feature trace.
- Creating a feature workspace or specialist surfaces is not sufficient for delegation. A delegated
  task is only launched when its assigned surface has a live worker process, a scoped handoff, and
  recorded launch verification.
- Worker launch verification does not finish orchestration. While delegated tasks remain
  `in_progress`, the orchestrator must keep supervising them until they either require attention,
  reach the acceptance gate, or are explicitly blocked.
- Default supervision cadence is one sweep every 45 seconds across all live worker surfaces, plus
  an extra sweep after any local work step longer than 30 seconds and before any status report or
  dependent task launch.
- Delegated implementation workers must start in plan mode before editing. Their first successful
  checkpoint is a surfaced task plan, not a code diff.
- Delegated workers must notify the orchestrator on first meaningful progress, blocker/attention,
  and result-ready state. Silent task termination or silent idling after completion is a process
  defect.
- Worker and reviewer events are immediate orchestration triggers. Status updates, trace writes,
  reviewer launch, reviewer wait loops, rework routing, and workspace metadata changes should run
  automatically when those events arrive.
- If an orchestration command is necessary and the environment requires escalation, request that
  escalation through the tool immediately; do not stop and wait for manual confirmation in chat
  before attempting the command.
- Use `../gemo-foundation/scripts/cmux-check-claude-worker.sh` as the default one-shot worker
  classifier before falling back to direct `cmux read-screen` inspection.
- When a delegated worker reaches Claude's `accept edits on` gate or equivalent result-ready state,
  stop treating the task as ordinary execution work. Route the task into reviewer handoff
  immediately and launch the required reviewer agent(s) within 2 minutes.
- When a reviewer agent finishes, mirror the outcome into the active cmux workspace via
  `../gemo-foundation/scripts/cmux-reviewer-report.sh` and update `reviews.md`,
  `feature-state.md`, and `events.jsonl` within 60 seconds before routing rework or acceptance.
- If debt is consciously deferred, record or update the debt item in `feature-state.md`,
  `reviews.md`, `decisions.md`, `rollout.md`, and `events.jsonl` before advancing the task.
- Autonomous review and rework loops are capped at 3 review rounds per task. If a task would
  require a 4th review round or more, stop the autonomous loop, mark the task and feature as
  blocked, surface the unresolved blocker families, and return control to the human for the next
  decision before launching more review or rework.
- A round-cap escalation must include a human decision handoff, not just a stop signal. Summarize
  the latest completed reviewer outcomes, the remaining unresolved blocker families, what changed
  or closed in the most recent rework, and the concrete next-move options so the human can decide
  quickly.
- Reviewer supervision is a loop, not a one-shot poll. After reviewer launch, keep waiting on the
  active reviewer agents until they reach terminal status or a real blocker appears.
- Use `wait_agent` with a long timeout for reviewer supervision: preferred timeout is 120000 ms;
  60000 ms is acceptable when faster turnover matters. Do not treat a 30000 ms timeout as review
  completion or as a reason to stop monitoring.
- When a delegated worker surfaces an approval prompt, hidden confirmation, or other interactive
  gate, mark the task `blocked` or `awaiting_attention`, notify, and resolve it before continuing.
- If a delegated worker never launches, keep the task `queued` or mark it `blocked`. Do not let
  the orchestrator perform the scoped implementation while the trace claims the specialist is doing
  it.
- Workspace sidebar task pills must stay human-readable. Keep a stable status key per surface/task,
  but set the visible value to `TASK_ID short-label state` rather than a bare state token like
  `in_progress`.
- Default delegated Claude worker launch mode is YOLO via `--dangerously-skip-permissions`. Only
  use a stricter permission mode when the user explicitly asks for it, and record that deviation
  in the execution plan.

## Workflow

1. Determine the session mode.
- Use brainstorm mode when the user wants to shape the feature collaboratively before formal
  grooming.
- Use formal grooming mode when the user wants traceability, architecture framing, and approval
  preparation.

2. Run brainstorm mode when needed.
- Collaborate with the user as `gemo-product-manager` plus `gemo-architect`.
- If Figma input is available, use Figma MCP to extract explicit features, sub-features, flows,
  and states.
- Separate explicit design evidence from inferred behavior.
- Produce a discovery packet with candidate problem framing, MVP scope, and the highest-value open
  questions.
- Do not scaffold feature traceability, spawn workers, or build the task graph unless the user asks
  to advance.

3. Clarify the objective.
- Define feature intent, success criteria, scope, exclusions, and likely home repo.

4. Map the feature.
- Use the shared repo and feature maps to identify affected repos, disciplines, and review needs.

5. Scaffold traceability.
- Create or verify `docs/features/<feature-slug>/agentic/`.
- Ensure the standard files exist before implementation starts and that their names and sections
  follow the canonical templates.

6. Run architecture mode.
- Frame options, tradeoffs, API or schema impact, rollout implications, reviewer set, and handoff
  requirements for specialists.

7. Prepare the human gate.
- Present the architecture packet and do not move into implementation until approved.

8. Build the task graph.
- Assign task IDs, owners, repo scope, reviewer scope, retry windows, and escalation conditions.
- Record dependency order, handoff prerequisites, unblock signals, and the owner of each next-step
  transition before launching any dependent task.
- Declare the debt posture for each task: what must be fixed before acceptance, what may become
  tracked debt, who owns deferred debt, and what trigger retires it.
- For each delegated task, record the worker runtime, worker permission mode, worktree / branch,
  cmux surface, launch command, prompt schema, prompt render command, handoff artifact,
  launch-verification method, worker notification contract, supervision cadence,
  result-ready detection method, reviewer agent skill(s), review launch trigger, and reviewer
  handoff mode.
- Publish the task graph in the execution-plan packet before assigning implementation work.

9. Orchestrate execution.
- Route work to specialists with clear ownership, live worker surfaces, and explicit handoff
  prompts.
- Before launching a delegated Claude worker, render the handoff artifact from the prompt schema
  and current feature trace instead of hand-writing a long bespoke prompt whenever the renderer can
  express the task cleanly.
- Launch the worker in the assigned surface in YOLO mode by default, include the worker
  notification contract in the handoff, require first planning acknowledgment before moving the
  task into active execution, and do not skip the plan gate.
- Start supervision as soon as launch verification succeeds. Do not rely on launch-time checks
  alone.
- While any delegated task is `in_progress`, run a supervision sweep at least every 45 seconds, and
  again after any local work step longer than 30 seconds.
- Release dependent work only when the prerequisite task state, review routing state, and trace
  documents all agree on readiness.
- When a worker or reviewer surfaces a shortcut, deferred cleanup, missing hardening step, or
  knowingly incomplete proof path, classify it as technical debt immediately instead of burying it
  in generic rework or residual-risk language.
- When a worker sends a result-ready or blocked notification to the orchestrator surface, treat it
  as an immediate trigger to route that task to the next control step.
- When a reviewer completes or partially completes, treat that event as an immediate trigger to
  update the trace, mirror workspace state, and either continue the reviewer loop or route rework
  without waiting for user input.
- Before launching follow-up rework or a follow-up reviewer pass, count prior review rounds for the
  task. If more than 3 review rounds would be required, do not continue autonomously; block the
  task, update the trace and workspace, and ask the human to choose the next move.
- When that round-cap handoff happens, provide a concise decision packet to the human covering:
  the latest backend/frontend/security reviewer summaries, the still-open blocker families, any
  blocker families that were closed in the last rework, and the practical options for how to
  proceed.
- If the debt posture changes rollout readiness or weakens an approved invariant, return to the
  human with the debt ID, rationale, owner, alternatives, and recommended next move before
  accepting or deferring it.
- When a task is result-ready, perform only the minimum orchestrator sanity checks needed to verify
  ownership, changed scope, and reviewer set. Do not treat that sanity check as the formal review.
- If the checker reports `awaiting_acceptance`, launch the required reviewer agent(s) within
  2 minutes, move the task into delegated reviewer handoff, and wait for reviewer findings before
  accepting or requesting rework.
- If the checker reports `attention_required`, surface the block in sidebar metadata and the trace,
  then resolve it before continuing.
- If the worker fails to launch or acknowledge, record the failure, keep the task unstarted, and
  either retry or explicitly reassign the work.
- Require progress, blocker, and result events to be logged.
- Request rework when output does not meet the contract.

10. Integrate and review.
- Spawn a dedicated Codex reviewer agent for each required reviewer skill on the task.
- Reviewers review the implementation worker's output; the orchestrator does not substitute its own
  specialist review for backend, frontend, security, extension, devops, or retool reviewer skills.
- Treat coordination-level triage and formal specialist review as separate gates: the orchestrator
  verifies ownership, scope, dependencies, and reviewer set, while reviewer agent(s) own the
  substantive findings and pass/fail recommendation.
- Require reviewers and the orchestrator to state whether unresolved issues are rollout-blocking,
  must be fixed now, or may be carried as tracked technical debt.
- Orchestrator is the connector between the implementation worker and the reviewer agent(s): it
  hands off scope and changed files to reviewers, records their findings, routes rework back to the
  implementation worker, and requests follow-up review when needed.
- Reviewer completion signal comes from the reviewer agent final completion notification
  (`subagent_notification` / `wait_agent` result), not from `cmux-worker-report.sh`.
- After launching reviewers, enter a reviewer wait loop with 60000-120000 ms cadence until every
  required reviewer agent reaches a final state. If a timeout expires with no completion, keep the
  review state active, record that review is still in flight if needed, and continue waiting.
- Mirror each reviewer completion into the workspace with
  `../gemo-foundation/scripts/cmux-reviewer-report.sh`, then update the trace before deciding the
  next control step.
- If reviewer findings would push the task beyond 3 review rounds, stop instead of launching more
  autonomous rework or another reviewer pass. Mark the task `blocked`, record that human direction
  is required, and present a human decision handoff to the user with the latest reviewer summaries,
  the unresolved blocker families, what improved in the latest round, and the practical next-move
  options.
- Once reviewer findings are clear and exit evidence is present, promote the task to accepted,
  rework, or reviewer-pass state without leaving it parked as generic `in_progress`.
- Track reviewer findings and resolve rework.

11. Close the loop.
- Produce rollout notes, residual risk, accepted or retired debt status, and the final
  orchestrator summary.
- If the feature materially changed the product surface, verify that the shared product knowledge
  base was updated before closure.

## Specialist Set

Discovery and design specialists:

- `gemo-product-manager`
- `gemo-architect`

Implementation specialists:

- `gemo-backend`
- `gemo-react`
- `gemo-extension`
- `gemo-devops`
- `gemo-retool`

Reviewers:

- `gemo-backend-reviewer`
- `gemo-react-reviewer`
- `gemo-extension-reviewer`
- `gemo-devops-reviewer`
- `gemo-retool-reviewer`
- `gemo-security-reviewer`

## cmux Rules

- one workspace per feature
- orchestrator is the anchor surface
- the orchestrator pane stays the main pane for the workspace and remains visible as the control
  plane
- brainstorm mode still uses the orchestrator as the single collaborative anchor
- create structural lanes once from the anchor surface with local `cmux new-split` or `cmux new-pane`
  when needed, then add later work into those panes with `cmux new-surface --pane ...`
- do not repurpose the orchestrator pane for browser, test, log, or specialist work once durable
  lanes exist unless an explicit temporary exception is recorded
- normalize surface titles immediately; use stable unique names for orchestrator, durable lanes,
  and specialist work so launcher and checker scripts can resolve them safely
- record pane creation sequence, pane reuse rule, surface naming convention, and any extra-pane
  justification in the execution plan before expanding the layout
- use sidebar metadata as the control plane
- use the canonical envelope protocol for collaboration
- do not use peer-to-peer control flow between specialists
