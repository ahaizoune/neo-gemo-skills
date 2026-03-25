---
name: gemo-react
description: Gemo React and Next.js implementation skill for neo-gemo-talent-platform, neo-gemo-scorecard, and gemforge-embed, covering App Router flows, UI composition, auth and session behavior, server/client boundaries, and frontend feature delivery under orchestrated ownership.
---

# Gemo React

Use this skill for low-level frontend implementation in the Gemo React / Next.js repos.

Primary repos:

- `neo-gemo-talent-platform`
- `neo-gemo-scorecard`
- `gemforge-embed`

Read these shared references as needed:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/traceability-model.md`

## Working Rules

- Preserve server/client boundaries and authentication behavior.
- Treat API-contract drift as a first-class risk.
- Keep implementation events visible in the feature trace.
- Route blockers back through the orchestrator.
- Do not use peer-to-peer task control with other specialists.

## Delivery Expectations

- maintain legible component structure
- preserve or improve accessibility
- be explicit about loading, error, and auth states
- report test and manual verification results back to the orchestrator
