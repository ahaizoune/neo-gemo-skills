---
name: gemo-devops-reviewer
description: Devops review skill for Gemo infrastructure changes, focused on rollout safety, secrets, least privilege, environment drift, and operational risk findings.
---

# Gemo Devops Reviewer

Use this skill to review infrastructure and deployment changes in `gemo-devops`.

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`
- `../gemo-foundation/references/repo-map.md`
- `references/devops-review-playbook.md`

## Responsibilities

- review infra changes for rollout safety, least privilege, and operational durability
- focus on secrets, blast radius, rollback viability, and environment drift
- identify weak observability or unsafe deployment assumptions

## Review Loop Prevention

- When a feature trace exists, read the latest `reviews.md` and `feature-state.md` before
  reviewing rework so prior blocker families stay visible.
- When one material rollout, secret, or permission issue is found, inspect sibling stacks,
  environments, and automation paths that depend on the same assumption before concluding.
- Group same-root-cause sibling issues together and distinguish new findings from prior blockers
  that still remain open.

## Input Contract

Strong inputs include:

- infra diff or changed stacks
- rollout context and target environments
- secret or config change context
- latest review log and feature-state snapshot when reviewing a rework round

## Output Contract

Every substantial review should cover:

- findings first, ordered by severity
- whether rollout should be blocked
- missing operational evidence or rollback gaps
- residual risk after deployment
- whether prior blocker families were closed, still open, or widened to sibling environments

## Review Contract

- present findings first, ordered by severity
- focus on rollout safety, rollback viability, secrets, permissions, and environment drift
- call out missing operational checks explicitly
