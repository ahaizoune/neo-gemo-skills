---
name: gemo-backend
description: Gemo backend implementation skill for neo-gemo-platform, covering GemForge, GemHub, FastAPI routes, domain services, monorepo libraries, workers, data access, migrations, integrations, auth-sensitive flows, and rollout-safe backend feature delivery under orchestrated ownership.
---

# Gemo Backend

Use this skill for low-level backend implementation in `neo-gemo-platform`.

Read these shared references as needed:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/role-matrix.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`
- `../gemo-foundation/references/traceability-model.md`
- `../gemo-backend-reviewer/references/backend-review-playbook.md`

## Scope

- GemForge
- GemHub
- routes, controllers, services, domain logic
- data access and persistence
- migrations
- workers and integration flows

## Source-Of-Truth Zones

Ground backend work in the actual `neo-gemo-platform` monorepo surface before editing:

- `apps/gemforge/src/gemforge`: main GemForge application modules, routes, services, policies, and
  persistence seams
- `apps/gemhub/src/gemhub`: GemHub application modules and route behavior
- `libs/core/src/core`: shared infrastructure, settings, auth, database, and runtime helpers
- `libs/shared/src/shared`: cross-app shared models, utilities, and contract helpers
- `libs/notification/src/notification`: notification flows, queues, and message-delivery logic
- `migrations/`: Alembic history and rollout-sensitive schema changes
- `scripts/`: repo-native CLI and operational commands such as DB, worker, token, and test flows
- `tests/` and app-local test trees: route, integration, worker, and migration-adjacent coverage

## Working Rules

- Respect explicit task and repo ownership from the orchestrator.
- Inspect the owned app, library, migration, and test zones before editing so stack assumptions
  come from repo evidence, not memory.
- Record meaningful implementation events in the feature trace.
- Escalate through the orchestrator after the configured retry window or failed retries.
- Do not hand work directly to another specialist.
- Call out migration and rollout implications explicitly.
- Treat `core`, `shared`, and `notification` as contract surfaces when the same invariant is used
  by multiple routes, jobs, or apps.

## Input Contract

Strong inputs include:

- task scope or owned file/module zone inside `neo-gemo-platform`
- feature trace packet when the work is non-trivial
- architecture packet when contracts, auth, jobs, or migrations are changing
- current backend diff or target modules when this is a rework round
- rollout, migration, provider, or token context when the risk depends on environment behavior

## Output Contract

Every substantial backend implementation handoff should cover:

- owned repo and module zones changed
- contract, migration, worker, and auth implications
- validation run at the real risk boundary
- remaining rollout or compatibility risk
- follow-up escalation needs when architecture or shared-contract decisions remain open

## Stack Best Practices

Implement for the concrete backend stack used by `neo-gemo-platform`, not generic Python patterns:

- FastAPI / Starlette / SlowAPI
- SQLAlchemy 2.x async ORM with PostgreSQL / asyncpg
- Alembic
- Pydantic v2 and pydantic-settings
- Redis, RQ, and RQ Scheduler
- httpx-based external integrations
- `python-jose` and `passlib`
- pytest and pytest-asyncio
- Sentry, structured logging, and backend observability hooks

## Backend Engineering Best Practices

- Keep API, domain, persistence, worker, and integration boundaries explicit.
- Prefer the smallest coherent change that preserves existing structure and ownership.
- Put shared invariants in shared dependencies, services, or policy helpers instead of duplicating
  route-local logic.
- Make failure behavior explicit: validation, auth denial, provider failure, retry, and
  partial-failure semantics should be designed, not incidental.
- Preserve contract compatibility when deploy windows or sibling consumers depend on it; call out
  deliberate contract breaks explicitly.
- Treat authorization, data isolation, idempotency, and state-machine integrity as first-class
  constraints while designing the fix.
- Add or preserve observability for risky paths and do not leak sensitive data into logs, traces,
  or error payloads.
- Self-review against the backend reviewer playbook before handoff and close obvious stack-level
  gaps yourself.

## Stack-Specific Must-Haves

- FastAPI / Starlette / SlowAPI:
  Use dependency injection and request-scoped sessions correctly, keep response contracts and
  exception behavior intentional, and do not bypass auth guards, middleware, or rate limiting on
  externally reachable routes.
- SQLAlchemy 2 Async / PostgreSQL:
  Keep transaction boundaries explicit, avoid fragile implicit flush or refresh assumptions and
  async lazy-load traps, and make writes atomic enough for the business flow.
- Alembic:
  Make migrations rollout-safe, prefer additive or expand-migrate-contract posture when
  compatibility matters, and call out backfills, lock sensitivity, nullability/default/unique
  changes, and rollback posture explicitly.
- Pydantic v2:
  Validate external input at the boundary, keep request/response/domain/persistence models distinct
  when they have different semantics, and keep defaults, aliases, and coercion behavior
  intentional.
- Redis / RQ:
  Keep jobs idempotent enough for retry or duplicate execution, make retry and deduplication
  behavior explicit, and do not rely on in-request DB session or request state inside workers.
- httpx integrations:
  Use explicit timeouts and error mapping, keep provider auth material safe, enforce provider trust
  checks when relevant, and do not let provider failures silently corrupt internal state.
- Auth / tokens / access links:
  Keep token scope, expiry, issuer/audience, and trust assumptions explicit; enforce authorization
  on every mutating or special-case route; and keep revocation, revalidation, role drift, ownership
  drift, and legacy compatibility semantics coherent across every consumer.
- Testing / observability:
  Prove risky behavior at the real boundary that creates the risk, add route-level or
  integration-style coverage when framework wiring matters, and make new failure modes observable.

## Review Loop Prevention

- When a feature trace exists under `docs/features/<feature>/agentic/`, read the latest
  `reviews.md`, `feature-state.md`, `decisions.md`, and the recent relevant `events.jsonl`
  entries before starting rework or auth / contract-sensitive implementation.
- Translate each serious reviewer finding into an invariant matrix before editing: actors and
  roles, credential or token types, entry modes, routes, mutating actions, lifecycle transitions,
  and legacy or compatibility paths.
- Fix the whole invariant family, not only the cited line. If a shared dependency, helper, route
  contract, or trust boundary is wrong, trace sibling consumers in your owned surface and close
  them in the same change.
- Prefer central enforcement in shared dependencies, services, or policy helpers when the same
  guarantee must hold across multiple routes.
- Escalate quickly when closing the whole blocker family requires an architecture or contract
  decision. Do not hide a structural gap behind a narrow local patch.

## Validation And Handoff

- Prove the fix at the real boundary that created the risk: router, dependency, middleware, DAO,
  service seam, or migration path, not only a mocked unit path.
- For auth, session, route-contract, or state-machine changes, add negative coverage for the
  affected role, mode, lifecycle, and reassignment or revocation branches.
- If mocked tests remain useful, pair them with at least one route-level or integration-style path
  that exercises real wiring when the risk depends on framework behavior.
- In the handoff, name the sibling surfaces you closed, the exact tests that cover them, and any
  intentionally unclosed surfaces that still need escalation.

## Repo-Native Validation Hints

- Prefer repo-native commands when they prove the risk cleanly, for example targeted `pytest`
  paths, `poetry run test-unit`, `poetry run test-pipeline`, `poetry run test-e2e`, or DB status
  and migration commands such as `poetry run db-status`.
- When the risk depends on app wiring, prefer validation that crosses the real app, dependency,
  worker, queue, or migration seam instead of isolated helper tests.

## Delivery Expectations

- make the smallest coherent backend change that preserves structure
- keep API and schema implications explicit
- run targeted validation where feasible
- report test results, remaining risk, and rollout considerations back to the orchestrator
