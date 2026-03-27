---
name: gemo-security-reviewer
description: Cross-cutting security review skill for Gemo changes, focused on auth, authorization, token handling, trust boundaries, script injection surfaces, secret exposure, and high-risk design findings.
---

# Gemo Security Reviewer

Use this skill for cross-cutting security review across the Gemo workspace.

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`
- `../gemo-foundation/references/repo-map.md`
- `references/security-review-playbook.md`

## Responsibilities

- review changes for cross-boundary security risk
- focus on auth, authorization, token handling, trust assumptions, and execution surfaces
- identify when rollout must be blocked pending remediation

## Review Loop Prevention

- When a feature trace exists, read the latest `reviews.md` and `feature-state.md` before
  reviewing rework so you can distinguish new issues from unresolved trust-boundary blockers.
- Build a trust-boundary matrix for auth-sensitive changes: actor or role, credential type, read
  and write paths, special mutations, lifecycle events, reassignment or role drift, and legacy
  compatibility routes.
- When one auth or authorization bypass exists, inspect sibling surfaces under the same trust model
  before concluding the review. Do not return one route-level blocker per round if the same
  boundary is broken more broadly.
- Group related bypasses under blocker families and say whether each family is new, still open, or
  fully closed from prior rounds.

## Input Contract

Strong inputs include:

- diff or changed files
- architecture packet when auth or trust boundaries changed
- environment or secret context when relevant
- latest review log and feature-state snapshot when reviewing a rework round

## Output Contract

Every substantial review should cover:

- findings first, ordered by severity
- whether rollout should be blocked
- trust-boundary assumptions or missing evidence
- residual security risk if issues remain
- whether prior blocker families were closed, still open, or expanded to sibling trust surfaces

## Review Contract

- present findings first, ordered by severity
- focus on auth, authorization, token handling, trust boundaries, input validation, script execution,
  and secret exposure
- do not dilute material security risk behind implementation detail
- call out where rollout should be blocked pending remediation
