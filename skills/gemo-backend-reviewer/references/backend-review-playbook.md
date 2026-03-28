# Backend Review Playbook

Use this playbook as a GemForge/GemHub stack-aware reviewer, not a generic Python reviewer.

## Backend Stack In Scope

- FastAPI / Starlette
- SlowAPI
- SQLAlchemy 2.x async ORM
- PostgreSQL via asyncpg
- Alembic
- Pydantic v2 and pydantic-settings
- Redis, RQ, and RQ Scheduler
- httpx-based external integrations
- `python-jose` and `passlib`
- pytest and pytest-asyncio
- Sentry, logging, and backend observability hooks

Focus on:

- API contract correctness
- migration safety and downgrade impact
- transaction boundaries and partial-failure behavior
- async or worker idempotency
- authorization and data isolation
- observability for risky flows
- state-machine integrity for pipeline, interviews, deliberation, and offers
- integration safety for Calendly, Google Calendar, Slack, and webhook flows
- likely future regression vectors when the same pattern is repeated elsewhere in the monorepo

## Source-Of-Truth Zones

Before concluding a substantial review, orient against these repo surfaces:

- `apps/gemforge/src/gemforge`
- `apps/gemhub/src/gemhub`
- `libs/core/src/core`
- `libs/shared/src/shared`
- `libs/notification/src/notification`
- `migrations/`
- `scripts/`
- root and app-local `tests/`

Use the changed files to choose where to look next, but do not assume the diff is the only surface
that matters when a shared invariant is involved.

## FastAPI / Starlette / SlowAPI Must-Haves

- dependency injection and request-scoped session handling are correct
- response models, status codes, and exception behavior stay consistent
- background tasks are safe for the intended durability guarantees
- middleware, rate limiting, and request validation are not bypassed accidentally
- auth and role checks are enforced at the right boundary
- route handlers do not hide service or persistence bugs behind broad exception handling
- public or abuse-prone routes preserve intended rate limiting and request guards

## SQLAlchemy 2 Async / Postgres Must-Haves

- `AsyncSession` usage respects transaction boundaries and lifecycle rules
- queries avoid obvious N+1 or lazy-load surprises on async boundaries
- state transitions and writes are atomic enough for the business flow
- raw SQL, if any, is parameterized and safe
- Postgres-specific behavior such as constraints, indexes, materialized views, and locks is
  considered during review
- writes do not depend on implicit flush / refresh behavior in fragile ways
- repository and service layers do not leak session-lifecycle assumptions across boundaries

## Alembic Must-Haves

- migrations are rollout-safe and ordered coherently
- destructive schema changes are not introduced without transition strategy
- backfills, defaults, nullability changes, and unique constraints are safe under real data
- downgrade or rollback posture is explicit, even if full reversal is not practical
- index creation, lock duration, and data-volume sensitivity are considered explicitly
- expand / migrate / contract posture is used when compatibility matters across deploy windows

## Pydantic v2 Must-Haves

- external input validation is explicit and located at the right boundary
- request, response, domain, and persistence models are not blurred carelessly
- serialization and deserialization behavior is intentional
- settings changes remain safe and environment-aware
- model defaults, aliases, and coercion behavior do not accidentally weaken contracts

## Redis / RQ Must-Haves

- jobs are idempotent enough for retry or duplicate execution scenarios
- lock, deduplication, or correlation-key behavior is safe
- retry and failure handling are explicit
- worker-side side effects are observable and not silently dropped
- queue timeout, retry count, and failure semantics match business criticality
- jobs do not assume in-request state or DB session context that will not exist in workers

## httpx / External Integration Must-Haves

- timeouts, error mapping, and provider failure handling are explicit
- auth material is handled safely
- webhook or callback behavior is idempotent and provider-safe
- external API failures do not corrupt internal state silently
- client creation and reuse patterns are sane for the code path
- provider-specific trust checks such as signature validation or callback verification are enforced

## Auth / Token / Access-Link Must-Haves

- token scope, expiry, audience, issuer, and trust assumptions are explicit
- authorization checks exist on state-changing actions
- password or credential handling remains safe
- one-time or privileged links cannot be replayed or widened accidentally
- key rotation or verification behavior is not broken by the change
- live revalidation semantics stay coherent across every consumer of the credential, including
  legacy read paths, special mutations, and compatibility routes
- role drift, ownership drift, revocation, deletion, reassignment, refresh, and token invalidation
  semantics are handled consistently across read and write paths that share the same credential

## Observability Must-Haves

- exceptions that matter are logged or captured with enough context to debug safely
- sensitive data is not leaked into logs, traces, or error payloads
- high-risk flows emit enough telemetry to validate rollout behavior
- new failure modes have a realistic path to detection in production

## Domain And Workflow Safety Must-Haves

- application, candidate, deliberation, offer, and interview transitions preserve domain invariants
- side effects triggered by stage changes or decisions are not duplicated or skipped accidentally
- calendaring or webhook flows remain consistent under reordering, duplication, or stale events
- cached or denormalized search data remains coherent enough for the user-facing workflow

## Test And Verification Must-Haves

- async paths have meaningful async test coverage when behavior is non-trivial
- migrations or contract changes have verification evidence
- worker or integration failure paths are covered when risk is meaningful
- reviewer distinguishes proven behavior from assumed behavior
- tests exercise the framework behavior that creates the risk, not just happy-path business logic
- auth and route-contract fixes prove behavior at the real FastAPI dependency, router, or DAO
  boundary when that boundary is where the risk lives

## Review Loop Prevention

- when a shared dependency, helper, or auth boundary is involved, inspect every sibling route and
  mutation that consumes it before ending the review
- when one route-specific fix is proposed for a broader invariant, look for the shared enforcement
  point that should have changed instead
- group same-root-cause sibling issues together and say whether a blocker is new, still open, or
  resolved from prior rounds

## Detailed Finding Shape

For each material finding, try to state:

- what invariant or framework expectation is broken
- why it is unsafe in this concrete backend stack
- what the runtime, data, security, or rollout consequence is
- where the likely root cause or weak enforcement point lives
- which sibling surfaces probably share the same defect family
- what stronger remediation direction would reduce recurrence
- what test, migration rehearsal, or operational verification would prove the fix

## Proactive Prevention Lenses

Look beyond the changed line when the pattern suggests likely future defects:

- local auth checks instead of central policy enforcement
- route-local validation or permission logic copied across handlers
- AsyncSession usage that works in one request path but is unsafe under concurrency or worker reuse
- migrations that technically apply but leave the next schema change or rollback brittle
- worker code that passes happy-path tests but lacks idempotency, retry clarity, or side-effect
  guards
- provider integrations that handle the current path but still lack reusable timeout, verification,
  or error-mapping discipline
- logging or Sentry coverage that would make the next production defect hard to diagnose
- fixes that close one state transition while sibling transitions still bypass the same invariant

Look hard at:

- schema changes without safe rollout or backfill strategy
- contract changes without compatibility handling
- async session misuse or transaction leaks
- worker-side duplication or retry hazards
- external integration code without explicit timeout / failure handling
- rate-limited or public routes that accidentally bypass abuse controls
- auth changes without boundary or permission review
- auth fixes that only close one route while sibling routes still use the same unsafe helper or
  stale claim model
- logging or Sentry changes that reduce diagnosability or leak secrets
- state transitions that can violate application / candidate / offer invariants
- missing tests around state transitions or failure paths
