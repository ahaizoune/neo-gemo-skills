# Review Methodology

Use this reference when a reviewer needs a consistent process, not only a checklist.

## Review Flow

1. Understand scope, change intent, and whether the task is a fresh review or a rework round.
2. When a feature trace exists, read the latest `reviews.md`, `feature-state.md`, and any recent
   relevant `events.jsonl` entries so open blocker families are visible before you inspect the diff.
3. Identify the highest-risk subsystems and the invariants that must still hold.
4. Build a sibling-surface map for the risky boundary: shared helpers, routes, entry modes, state
   transitions, lifecycle paths, and compatibility surfaces.
5. Review against shared and role-specific axes, using the sibling map to collapse the whole
   blocker family rather than only the first failing surface.
6. Compare the current result with prior findings and classify each blocker as new, still open, or
   resolved.
7. Write findings with severity, consequence, required action, and precise missing evidence.
8. Note verification gaps, residual risk, and whether rollout should be blocked.

## Inputs To Prefer

- diff or changed files
- relevant architecture packet when available
- execution plan or rollout context when available
- test or verification evidence when available
- latest review log and feature-state snapshot when reviewing a rework round

## Loop Prevention Rules

- if one issue points to a broken invariant, inspect sibling consumers of the same dependency,
  helper, trust boundary, state machine, environment assumption, or host contract before ending the
  review
- prefer grouped blocker families over a sequence of narrowly scoped route-by-route findings when
  the same remediation should close them together
- do not spend a new round rediscovering a blocker that was already open; instead, say the prior
  blocker remains open and explain why the attempted fix still does not close it
- separate implementation-level defects from verification-only gaps so rework is scoped correctly

## Risk-Family Heuristics

- auth, session, or token changes: inspect role or actor changes, credential types, read and write
  paths, special mutations, revocation, expiry, reassignment, offboarding, and legacy or fallback
  routes
- contract changes: inspect DTOs, route docs, dependencies, controllers, clients, and tests that
  consume the contract
- state-machine changes: inspect every transition that shares the same invariant, not just the path
  exercised by the changed test
- rollout or infra changes: inspect sibling environments, automation paths, rollback hooks, and
  observability surfaces that share the same deployment assumption

## Escalation Rules

- escalate to security review when trust boundaries, auth, token handling, or script execution
  surfaces are involved
- escalate to architect or orchestrator when the issue appears structural, not local
- escalate rollout blocking when confidence is high and impact is material
- when the same task reaches more than 3 review rounds and blocker families remain open, escalate
  back to the human decision-maker instead of expecting another autonomous rework loop to continue
- when escalating back to the human after the round cap, summarize the latest reviewer conclusions
  and consolidate the still-open findings into stable blocker families instead of forwarding raw
  repeated findings from every review round

## Anti-Patterns

- reviewing only for style
- burying real findings under summary text
- assuming a test exists because the code looks clean
- treating missing verification as acceptable without saying so
- reviewing only the changed line while ignoring sibling consumers of the same risky boundary
- emitting a fresh finding name every round for what is really the same unresolved blocker family
