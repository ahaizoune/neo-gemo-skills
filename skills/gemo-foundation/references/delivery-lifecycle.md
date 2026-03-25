# Gemo Delivery Lifecycle

Use this reference when orchestrating or reviewing a feature.

## Phases

1. Intake and grooming
- define business objective
- define user impact
- define success criteria
- define scope and exclusions
- identify home repo and impacted repos

2. Architecture framing
- identify bounded contexts
- identify API, schema, workflow, and rollout implications
- decide required specialist roles and reviewers
- record options and tradeoffs

3. Human approval gate
- do not start implementation of non-trivial features before explicit human approval
- approval should reference the current architecture summary

4. Agentic execution plan
- assign owners
- set repo and file ownership
- define task IDs
- define cmux topology
- define retry and escalation windows

5. Implementation loop
- specialist workers implement within owned scope
- orchestrator reviews outputs
- rework is routed back to the same specialist unless scope changes materially

6. Integration and verification
- execute tests and manual verification
- check observability and rollout risk
- reviewers must sign off before rollout readiness

7. Rollout and closure
- capture deployment / release sequence
- capture rollback strategy
- capture residual risks and follow-up work

## Non-Negotiables

- orchestrator owns task control
- reviewers produce findings before summaries
- peer-to-peer control flow is disallowed
- direct worker clarification is exceptional, tightly scoped, and must be logged back
