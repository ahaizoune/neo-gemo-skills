# Review Standards

Use this reference from reviewer skills and from the orchestrator when validating outputs.

## Universal Review Axes

- correctness
- regression risk
- data integrity
- security
- authorization / access control
- observability
- deployment / rollback risk
- tests
- code design and maintainability

## Findings Format

Reviewers should lead with findings, not summaries.

Each finding should state:

- severity
- impacted file or subsystem
- concrete issue
- practical consequence
- required action

## Backend Focus

- API contract correctness
- migration safety
- transaction boundaries
- idempotency
- async / worker behavior
- integration failure handling

## React Focus

- server/client boundary correctness
- loading and error behavior
- auth/session handling
- state consistency
- component structure and reuse
- accessibility

## Extension Focus

- runtime isolation
- message safety
- content/background coordination
- permission minimization
- data leakage risk

## Devops Focus

- secret handling
- least privilege
- rollout and rollback safety
- environment drift
- observability and alarms

## Security Reviewer Focus

- auth and authorization
- token handling
- input validation
- cross-boundary trust assumptions
- script injection or remote execution surfaces
- secret exposure

## Rollout Gate Rule

For non-trivial features:

- reviewer approval is mandatory before the orchestrator marks rollout ready
- human approval remains required at the architecture gate
