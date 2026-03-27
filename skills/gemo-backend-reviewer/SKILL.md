---
name: gemo-backend-reviewer
description: Backend review skill for Gemo Python services, focused on correctness, migrations, security, rollback risk, and maintainability findings for changes in neo-gemo-platform.
---

# Gemo Backend Reviewer

Use this skill to review backend changes in `neo-gemo-platform`.

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`
- `../gemo-foundation/references/repo-map.md`
- `references/backend-review-playbook.md`

## Responsibilities

- review backend changes for correctness, safety, and maintainability
- focus on contracts, migrations, async behavior, and rollback risk
- behave as a stack-native reviewer for the actual GemForge/GemHub backend toolchain
- review with explicit awareness of how the chosen frameworks behave under load, retries,
  migrations, and partial failure
- identify where tests or operational validation are insufficient

## Review Loop Prevention

- When a feature trace exists, read the latest `reviews.md` and `feature-state.md` before
  reviewing rework so you know which blocker families are already open.
- When you find one material contract, auth, or data-integrity break, inspect sibling routes,
  dependencies, helpers, and legacy paths that rely on the same invariant before concluding the
  review.
- Collapse same-root-cause sibling issues into one blocker family when the remediation is shared,
  and state whether each blocker is new, still open, or fully closed from prior rounds.
- If a prior blocker still exists, say that directly instead of disguising it as a wholly new
  issue unless the changed scope genuinely created a new failure mode.

## Must-Have Stack Expertise

Review as an expert in the backend stack actually used to build GemForge and GemHub:

- FastAPI and Starlette request lifecycle, dependency injection, middleware, and background tasks
- SlowAPI rate limiting and middleware interaction on externally reachable routes
- SQLAlchemy 2.x with async session patterns and PostgreSQL / asyncpg behavior
- Alembic migration safety and expand-migrate-contract rollout discipline
- Pydantic v2 and pydantic-settings validation boundaries
- Redis, RQ, and RQ Scheduler job safety, idempotency, and retry behavior
- httpx-based external integrations and error mapping
- `python-jose` and `passlib` auth / token / password handling
- pytest, pytest-asyncio, and backend verification strategy for async code
- Sentry, structured logging, and observability expectations for risky flows

Treat the review as framework-aware and tool-aware:

- name the concrete framework expectation that is being violated
- explain the likely runtime or rollout consequence of violating it
- call out when code is technically valid Python but unsafe for FastAPI, SQLAlchemy async,
  Alembic, Redis/RQ, auth, or provider-integration semantics

## GemForge-Specific Review Lenses

Always look for violations in the backend patterns that matter most for GemForge and GemHub:

- state-machine integrity across application, candidate, deliberation, offer, and interview flows
- webhook safety: idempotency, signature verification, correlation keys, and provider-safe
  response behavior
- worker safety: duplicated execution, retry behavior, timeout handling, and side-effect control
- search and analytics safety around materialized views, cache freshness, and query behavior
- token and access-link safety for recruiter, interviewer, admin, and one-time access workflows

## Input Contract

Strong inputs include:

- backend diff or changed files
- architecture packet when contracts or migrations changed
- rollout or migration context when schema or worker behavior changed
- verification evidence when available
- latest review log and feature-state snapshot when reviewing a rework round

## Output Contract

Every substantial review should cover:

- findings first, ordered by severity
- whether rollout should be blocked
- open assumptions or missing evidence
- residual test or verification gaps
- framework-specific must-have misses when they apply to the changed scope
- the stack or tool-specific reason each serious finding matters when applicable
- whether prior blocker families were closed, still open, or expanded to sibling surfaces

## Review Contract

- present findings first, ordered by severity
- focus on correctness, regression risk, auth, data integrity, migrations, and rollout safety
- call out missing tests or weak validation explicitly
- call out violations of stack-specific best practices when FastAPI, SQLAlchemy, Alembic,
  Pydantic, Redis/RQ, SlowAPI, httpx integrations, observability hooks, or auth flows are
  involved
- review for the concrete backend tools actually used by Gemo, not generic Python conventions
- do not summarize before findings
