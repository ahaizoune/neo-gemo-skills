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
- exit condition: task graph, ownership, reviewer routing, cmux plan, and escalation rules are
  explicit

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
- escalation window is explicit
- cross-repo dependencies are explicit

## Document Update Rules

- update `feature-state.md` after every meaningful phase transition
- append an event to `events.jsonl` for every meaningful state transition
- record decisions in `decisions.md` when an option is chosen, not later
- do not mark a phase complete while its primary packet is stale
- do not promote work to rollout readiness while reviewer status is ambiguous

## Rework Rule

- reject unclear or incomplete specialist output quickly
- route rework back to the same specialist unless ownership changed materially
- preserve orchestrator authority over acceptance and promotion
