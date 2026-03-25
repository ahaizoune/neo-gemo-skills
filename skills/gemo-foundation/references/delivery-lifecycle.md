# Gemo Delivery Lifecycle

Use this reference when orchestrating or reviewing a feature.

## Phases

1. Brainstorm and discovery
- collaborate with the user before formal grooming begins
- use product-manager and architect behavior to shape the feature
- if Figma input exists, use Figma MCP to extract explicit features, sub-features, flows, and
  states
- separate what is explicit in the design from what is inferred
- identify assumptions, unknowns, and MVP versus later-phase scope
- primary packet: `01-discovery.md`
- do not scaffold traceability, spawn workers, or start implementation by default

2. Intake and grooming
- define business objective
- define user impact
- define success criteria
- define scope and exclusions
- identify home repo and impacted repos
- primary packet: `02-grooming.md`

3. Architecture framing
- identify bounded contexts
- identify API, schema, workflow, and rollout implications
- decide required specialist roles and reviewers
- record options and tradeoffs
- primary packet: `03-architecture.md`

4. Human approval gate
- do not start implementation of non-trivial features before explicit human approval
- approval should reference the current architecture summary

5. Agentic execution plan
- assign owners
- set repo and file ownership
- define task IDs
- define cmux topology
- define retry and escalation windows
- primary packet: `04-execution-plan.md`

6. Implementation loop
- specialist workers implement within owned scope
- orchestrator reviews outputs
- rework is routed back to the same specialist unless scope changes materially

7. Integration and verification
- execute tests and manual verification
- check observability and rollout risk
- reviewers must sign off before rollout readiness
- primary packet: `reviews.md`

8. Rollout and closure
- capture deployment / release sequence
- capture rollback strategy
- capture residual risks and follow-up work
- update the shared product knowledge base when product capabilities or workflow relationships
  changed
- primary packet: `rollout.md`

## Non-Negotiables

- orchestrator owns task control
- reviewers produce findings before summaries
- peer-to-peer control flow is disallowed
- direct worker clarification is exceptional, tightly scoped, and must be logged back
