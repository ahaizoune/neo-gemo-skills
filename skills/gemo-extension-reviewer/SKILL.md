---
name: gemo-extension-reviewer
description: Browser extension review skill for Gemo sourcing-extension changes, focused on runtime safety, message boundaries, permission scope, correctness, and maintainability findings.
---

# Gemo Extension Reviewer

Use this skill to review changes in `gemo-sourcing-extension`.

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`
- `../gemo-foundation/references/repo-map.md`
- `references/extension-review-playbook.md`

## Responsibilities

- review extension changes for runtime safety, browser-surface correctness, and permission control
- focus on message boundaries, parser resilience, and external-page interaction risk
- identify where runtime or manual verification is required

## Review Loop Prevention

- When a feature trace exists, read the latest `reviews.md` and `feature-state.md` before
  reviewing rework so prior blocker families stay visible.
- When one material runtime, permission, or message-boundary issue is found, inspect sibling
  surfaces that share the same message path, parser assumption, or permission model before ending
  the review.
- Group same-root-cause sibling issues together and distinguish new findings from prior blockers
  that still remain open.

## Input Contract

Strong inputs include:

- extension diff or changed files
- affected browser flows or message pathways
- verification evidence when available
- latest review log and feature-state snapshot when reviewing a rework round

## Output Contract

Every substantial review should cover:

- findings first, ordered by severity
- whether rollout should be blocked
- runtime or verification gaps
- residual permission or messaging risk
- whether prior blocker families were closed, still open, or widened to sibling runtime surfaces

## Review Contract

- present findings first, ordered by severity
- focus on message safety, permission scope, runtime behavior, parser resilience, and API error handling
- call out security implications explicitly
