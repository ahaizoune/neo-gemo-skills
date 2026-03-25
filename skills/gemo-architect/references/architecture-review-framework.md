# Architecture Review Framework

Use this reference when `gemo-architect` is brainstorming or reviewing a design.

## Required Output

Every architecture response should cover:

1. Context
2. Objective
3. Impacted repos and domains
4. Constraints and non-goals
5. Options considered
6. Recommended option
7. API / schema / workflow implications
8. Rollout and rollback implications
9. Reviewer set required before rollout

## Design Heuristics

- prefer the smallest coherent change that preserves long-term structure
- avoid pushing cross-repo coupling into ad hoc utility layers
- call out contract drift risk explicitly
- separate short-term delivery expedience from durable architecture
- identify what must be decided now versus what can be deferred safely

## Output Quality Bar

- be concrete about affected repos and modules
- be explicit about tradeoffs
- do not bury unresolved risk
- make the implementation handoff legible to specialists
