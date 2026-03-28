# Review Standards

Use this reference from reviewer skills and from the orchestrator when validating outputs.

## Review Principles

- findings first, summary second
- review for user and system risk, not stylistic preference
- call out uncertainty explicitly instead of bluffing
- tie every meaningful finding to consequence and required action
- block rollout when unresolved risk is material
- maximize closure per review round by surfacing materially related sibling issues you can
  substantiate, not only the first broken route or file you notice
- distinguish implementation bugs, verification gaps, and architecture gaps so rework lands at the
  right layer
- distinguish genuinely new blocker families from previously open blockers that still remain

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
- code complexity
- coding conventions

## Severity Levels

- `critical`: likely security incident, data loss, major authorization break, or release-blocking
  outage risk
- `high`: strong likelihood of broken behavior, unsafe migration, major regression, or material
  rollback risk
- `medium`: meaningful maintainability, correctness, or verification gap that should be fixed before
  confidence is high
- `low`: smaller issue, hardening recommendation, or gap with limited immediate risk

## Blocking Rule

- `critical` and `high` findings block rollout by default until explicitly resolved or consciously
  waived
- `medium` findings should be resolved unless there is a documented reason to defer
- `low` findings may be deferred if tracked clearly
- any deferred finding that creates technical debt must be converted into an explicit debt record
  with an owner, rationale, rollout posture, and retirement trigger

## Findings Format

Reviewers should lead with findings, not summaries.

Each finding should state:

- severity
- confidence
- impacted file or subsystem
- concrete issue
- practical consequence
- required action

Good reviews also note:

- whether the finding blocks rollout
- what evidence or missing evidence supports the finding
- whether the issue is design-level, implementation-level, or verification-level
- whether the issue is new, still open from a prior round, or part of the same blocker family
- which adjacent surfaces were checked when the risk depended on a shared boundary
- whether the issue must be fixed now, may be deferred as tracked debt, or requires human
  acceptance before rollout

## No-Findings Rule

If no findings are present:

- say that explicitly
- still mention residual risks or testing gaps
- avoid padding the response with generic praise

## Verification Expectations

- call out missing automated coverage when it matters
- call out missing manual verification when runtime behavior is risky
- distinguish proven behavior from assumed behavior
- ask for proof at the real boundary that creates the risk, not only at a mocked or narrower seam
- when debt is deferred, ask for the smallest evidence that supports the chosen debt posture and
  retirement trigger

## Review Loop Prevention

- when one finding reveals a broken invariant, inspect sibling routes, entry modes, helpers,
  environments, or states that depend on the same boundary before closing the review
- collapse same-root-cause sibling issues into one blocker family when the remediation is shared
- do not hold back an obvious adjacent blocker for a later round just because one surface already
  failed
- if a prior blocker still remains, say that directly rather than inventing a misleadingly new
  finding
- when verification is the main gap, name the smallest real-boundary evidence that would close the
  uncertainty

## Output Shape

Recommended output order:

1. findings
2. open questions or assumptions
3. residual risk or testing gaps
4. short summary only if useful

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
