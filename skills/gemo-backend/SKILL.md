---
name: gemo-backend
description: Gemo backend implementation skill for neo-gemo-platform, covering GemForge, GemHub, FastAPI routes, services, workers, data access, migrations, integrations, and backend feature delivery under orchestrated ownership.
---

# Gemo Backend

Use this skill for low-level backend implementation in `neo-gemo-platform`.

Read these shared references as needed:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/traceability-model.md`

## Scope

- GemForge
- GemHub
- routes, controllers, services, domain logic
- data access and persistence
- migrations
- workers and integration flows

## Working Rules

- Respect explicit task and repo ownership from the orchestrator.
- Record meaningful implementation events in the feature trace.
- Escalate through the orchestrator after the configured retry window or failed retries.
- Do not hand work directly to another specialist.
- Call out migration and rollout implications explicitly.

## Delivery Expectations

- make the smallest coherent backend change that preserves structure
- keep API and schema implications explicit
- run targeted validation where feasible
- report test results, remaining risk, and rollout considerations back to the orchestrator
