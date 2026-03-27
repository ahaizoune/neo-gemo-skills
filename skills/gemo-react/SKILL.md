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

## Review Loop Prevention

- When a feature trace exists under `docs/features/<feature>/agentic/`, read the latest
  `reviews.md`, `feature-state.md`, `decisions.md`, and the recent relevant `events.jsonl`
  entries before starting rework or auth / route-posture-sensitive implementation.
- Translate each serious reviewer finding into a frontend invariant matrix before editing: actor,
  entry mode, route, session source, loading state, empty state, unauthorized state, read-only or
  submitted posture, and legacy compatibility path.
- Fix the whole invariant family, not only the cited component. If a shared loader, auth callback,
  API client, route guard, navigation helper, or state-derivation utility is wrong, trace sibling
  consumers in your owned surface and close them in the same change.
- Prefer central enforcement in shared route guards, API adapters, normalization helpers, and
  state-derivation utilities when the same guarantee must hold across multiple screens or hooks.
- Escalate quickly when closing the whole blocker family requires a contract or architecture
  change. Do not hide a structural gap behind a narrow component patch.

## Validation And Handoff

- Prove the fix at the real boundary that created the risk: route, server action, auth callback,
  client navigation, API adapter, or state-derivation seam, not only an isolated helper.
- For auth, session, route-posture, or submitted/read-only changes, add negative coverage for the
  affected role, mode, lifecycle, and stale-session or reassignment branches.
- If mocked tests remain useful, pair them with at least one route-level or integration-style path
  when the risk depends on framework wiring or server/client composition.
- In the handoff, name the sibling screens or flows you closed, the exact tests that cover them,
  and any intentionally unclosed surfaces that still need escalation.

## Delivery Expectations

- maintain legible component structure
- preserve or improve accessibility
- be explicit about loading, error, and auth states
- prove risky auth or route-posture fixes at the real boundary
- report test and manual verification results back to the orchestrator
