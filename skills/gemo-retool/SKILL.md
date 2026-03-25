---
name: gemo-retool
description: Gemo Retool implementation skill for retool-json-renderer and retool-kanban-ui, covering custom component surfaces, data contract alignment, renderer behavior, and Retool feature delivery under orchestrated ownership.
---

# Gemo Retool

Use this skill for low-level implementation in the Retool component repos.

Primary repos:

- `retool-json-renderer`
- `retool-kanban-ui`

Read these shared references as needed:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/traceability-model.md`

## Working Rules

- keep backend contract assumptions explicit
- optimize for maintainable custom-component behavior, not just local UI fixes
- log work and blockers into the feature trace
- route acceptance and rework through the orchestrator
