# Traceability Model

Use this reference when implementing the feature trace system.

## Model

Apply a lightweight CQRS-style split:

- command side: append-only execution events in `events.jsonl`
- read side: curated current state in `feature-state.md`

This is not full event sourcing. The goal is durable traceability with low ceremony.

## Required Artifacts

Inside the feature's home repo:

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

## Artifact Roles

- `feature-state.md`: current read model and document index
- `01-discovery.md`: brainstorm and discovery packet
- `02-grooming.md`: scoped feature packet and human gate preparation
- `03-architecture.md`: architecture packet
- `04-execution-plan.md`: task graph, ownership, review plan, and cmux plan
- `decisions.md`: chronological decision ledger
- `events.jsonl`: append-only event log
- `reviews.md`: review findings, verification evidence, and sign-off status
- `rollout.md`: rollout sequence, rollback, residual risk, and knowledge-base update status

## Event Rules

Every meaningful state transition should append one JSON line.

Recommended fields:

- `ts`
- `feature_id`
- `feature_slug`
- `actor`
- `role`
- `phase`
- `event_type`
- `status`
- `summary`
- `repo`
- `task_id`
- `artifact_path`

Good event types:

- `feature_trace_initialized`
- `discovery_started`
- `discovery_completed`
- `grooming_completed`
- `architecture_option_recorded`
- `architecture_decision_approved`
- `human_gate_approved`
- `execution_plan_published`
- `task_assigned`
- `implementation_started`
- `implementation_progress`
- `blocker_raised`
- `clarification_requested`
- `review_requested`
- `review_failed`
- `review_passed`
- `verification_passed`
- `knowledge_base_updated`
- `rollout_ready`

## Curated Read Model Rules

`feature-state.md` must answer:

- what the feature is
- which phase it is in
- which primary packet is current for each phase
- who owns which tasks
- what is blocked
- what has been approved
- what remains before rollout

The orchestrator is responsible for keeping the read model current.

## Direct Clarification Rule

If workers exchange a narrowly scoped technical clarification directly:

- it must still have a feature ID and task ID
- it must be summarized back into the feature trace
- it must not transfer ownership or bypass orchestrator control
