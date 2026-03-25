# Architecture Review Framework

Use this reference when `gemo-architect` is brainstorming or reviewing a design.

## Required Output

Every architecture response should cover:

1. Context
2. Objective
3. Current state and source-of-truth map
4. Impacted repos and domains
5. Constraints and non-goals
6. Architecture drivers / quality attributes
7. Options considered
8. Recommended option
9. Compatibility and deprecation strategy
10. API / schema / workflow implications
11. Trust boundaries and authorization implications
12. Validation plan for risky assumptions
13. Rollout and rollback implications
14. Reviewer set required before rollout

## Design Heuristics

- prefer the smallest coherent change that preserves long-term structure
- avoid pushing cross-repo coupling into ad hoc utility layers
- call out contract drift risk explicitly
- call out compatibility and consumer impact explicitly
- separate short-term delivery expedience from durable architecture
- identify what must be decided now versus what can be deferred safely

## Output Quality Bar

- be concrete about affected repos and modules
- be explicit about tradeoffs
- do not bury unresolved risk
- make source-of-truth ownership explicit
- make trust boundaries explicit when auth or cross-system assumptions matter
- make the implementation handoff legible to specialists
