---
name: gemo-retool-reviewer
description: Retool review skill for Gemo custom-component repos, focused on renderer correctness, contract alignment, maintainability, and UI behavior findings.
---

# Gemo Retool Reviewer

Use this skill to review changes in:

- `retool-json-renderer`
- `retool-kanban-ui`

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`
- `../gemo-foundation/references/repo-map.md`
- `references/retool-review-playbook.md`

## Responsibilities

- review Retool component changes for renderer behavior, contract integrity, and maintainability
- focus on backend contract alignment, runtime behavior, and operational usability
- behave as a host-aware reviewer for the actual Retool custom-component stack used in Gemo
- review with explicit awareness of Retool model/event semantics, manifest behavior, and embedded
  host constraints
- identify missing verification for embedded or Retool-hosted behavior

## Review Loop Prevention

- When a feature trace exists, read the latest `reviews.md` and `feature-state.md` before
  reviewing rework so prior blocker families stay visible.
- When one material contract, host-runtime, or event-semantics issue is found, inspect sibling
  models, emitted events, and embedded states that rely on the same assumption before ending the
  review.
- Group same-root-cause sibling issues together and distinguish new findings from prior blockers
  that still remain open.

## Must-Have Stack Expertise

Review as an expert in the Retool component stack actually used in
`retool-json-renderer` and `retool-kanban-ui`:

- `@tryretool/custom-component-support` state and event hooks, manifest generation, and Retool
  host behavior
- React 18 embedded inside Retool-hosted custom components
- Retool model/event contracts, inspector configuration, hidden/internal state, and event payload
  semantics
- manifest and deployment safety, including custom manifest-fix steps when the generated output is
  insufficient
- resilience to partial, malformed, stale, or undocumented host-provided data
- styling and layout behavior inside Retool-hosted surfaces using Ant Design, Tailwind, Sass, and
  local design-system helpers
- interaction-heavy Retool components such as drag-and-drop boards and dynamic JSON renderers
- verification expectations for embedded runtime behavior, not just standalone React behavior

Treat the review as Retool-host-aware:

- name the exact Retool or custom-component expectation being violated
- explain the likely host-runtime or operator-facing consequence
- call out when code is valid React but unsafe for Retool model binding, event delivery, manifest
  generation, or embedded layout constraints

## Perfect Retool Component Review Lenses

Always look for the properties a high-quality Retool component must preserve:

- explicit, stable, and documented input model names and shapes
- explicit, stable, and semantically correct event names and payload behavior
- graceful handling of empty, partial, malformed, or stale input data
- deterministic rendering from host state with no accidental local/host drift
- hidden/internal state used intentionally and not as a substitute for clear contracts
- host-friendly layout, styling, and performance in realistic Retool usage

## Input Contract

Strong inputs include:

- Retool component diff or changed files
- expected data contract or API assumptions
- verification evidence when available
- latest review log and feature-state snapshot when reviewing a rework round

## Output Contract

Every substantial review should cover:

- findings first, ordered by severity
- whether rollout should be blocked
- contract or verification gaps
- residual runtime risk
- Retool-specific must-have misses when they apply to the changed scope
- whether prior blocker families were closed, still open, or widened to sibling host surfaces

## Review Contract

- present findings first, ordered by severity
- focus on renderer correctness, contract alignment, and maintainability
- call out weak verification coverage explicitly
- call out violations of Retool-specific best practices when model contracts, event wiring,
  manifest generation, embedded layout, or host-runtime semantics are involved
- review for the concrete Retool component environment actually used by Gemo, not generic React
  conventions
