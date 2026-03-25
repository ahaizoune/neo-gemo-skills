---
name: gemo-extension
description: Gemo browser extension implementation skill for gemo-sourcing-extension, covering background and content flows, message routing, parsing, Chrome runtime concerns, and sourcing feature delivery under orchestrated ownership.
---

# Gemo Extension

Use this skill for low-level implementation in `gemo-sourcing-extension`.

Read these references as needed:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/traceability-model.md`

## Focus Areas

- background / content coordination
- parser behavior and resilience
- extension auth and API interaction
- runtime permissions and messaging
- safe DOM interaction

## Working Rules

- treat message safety and permission scope as primary concerns
- call out security and runtime implications explicitly
- log implementation progress and blockers to the feature trace
- route ownership and acceptance back through the orchestrator
