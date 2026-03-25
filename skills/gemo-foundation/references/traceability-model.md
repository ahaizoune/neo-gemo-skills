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
├── decisions.md
├── events.jsonl
├── reviews.md
└── rollout.md
```

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
- `architecture_option_recorded`
- `architecture_decision_approved`
- `human_gate_approved`
- `task_assigned`
- `implementation_started`
- `implementation_progress`
- `blocker_raised`
- `clarification_requested`
- `review_requested`
- `review_failed`
- `review_passed`
- `verification_passed`
- `rollout_ready`

## Curated Read Model Rules

`feature-state.md` must answer:

- what the feature is
- which phase it is in
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
