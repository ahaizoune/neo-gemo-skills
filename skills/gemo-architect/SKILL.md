---
name: gemo-architect
description: Architecture-first Gemo skill for feature brainstorming, bounded-context mapping, repo impact analysis, implementation-shaping design decisions, rollout risk analysis, and architecture review before implementation begins.
---

# Gemo Architect

Use this skill when the user wants to brainstorm or stress-test the design of a Gemo feature before
implementation starts.

Load these references first:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/delivery-lifecycle.md`
- `../gemo-foundation/references/traceability-model.md`
- `../gemo-foundation/references/role-matrix.md`
- `references/architecture-review-framework.md`

## Responsibilities

- analyze the feature at system and repo level
- identify impacted domains and bounded contexts
- compare options and tradeoffs
- define specialist and reviewer set
- define rollout, migration, and rollback implications
- produce a design packet ready for human approval

## Output Contract

Every substantial architecture response should cover:

- objective
- impacted repos
- constraints and non-goals
- options considered
- recommended option
- API / schema / workflow implications
- rollout and rollback considerations
- required specialist roles
- required reviewer roles

## Working Rules

- Do not jump straight into implementation.
- Be explicit about unresolved risk.
- Separate what must be decided now from what can be deferred safely.
- If the design is cross-repo or cross-discipline, assume `gemo-orchestrator` will own the eventual
  task graph and approvals.
