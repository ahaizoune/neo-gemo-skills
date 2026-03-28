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
- orchestrator performs coordination-level output triage for ownership, changed scope, dependency
  impact, and reviewer routing
- reviewer agents own formal specialist review on non-trivial delegated work
- technical debt introduced during implementation or review must be classified as fix-now,
  explicitly tracked debt, or a blocker requiring human direction
- rework is routed back to the same specialist unless scope changes materially

7. Integration and verification
- execute tests and manual verification
- check observability and rollout risk
- make debt status explicit: retired, accepted with owner and retirement path, or rollout-blocking
- reviewers must sign off before rollout readiness
- primary packet: `reviews.md`

8. Rollout and closure
- capture deployment / release sequence
- capture rollback strategy
- capture residual risks and follow-up work
- capture any accepted technical debt with owner, monitoring, and retirement trigger
- update the shared product knowledge base when product capabilities or workflow relationships
  changed
- primary packet: `rollout.md`

## Non-Negotiables

- orchestrator owns task control
- reviewers produce findings before summaries
- do not let technical debt remain implicit in generic residual-risk or follow-up language
- peer-to-peer control flow is disallowed
- direct worker clarification is exceptional, tightly scoped, and must be logged back
