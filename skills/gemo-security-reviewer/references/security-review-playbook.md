# Security Review Playbook

Focus on:

- authentication and authorization integrity
- token handling and secret exposure
- cross-boundary trust assumptions
- input validation and execution surfaces
- privilege escalation paths
- trust-boundary coverage across all routes and actions that consume the same credential or claim
- likely future security regressions when the same weak pattern is repeated elsewhere in the stack

## Source-Of-Truth Zones

Before concluding a substantial review, orient against these repo surfaces when they are relevant to
the changed scope:

- `neo-gemo-platform`: backend routes, shared auth helpers, token utilities, jobs, webhooks,
  migrations, and observability surfaces
- `neo-gemo-talent-platform` and `neo-gemo-scorecard`: middleware, route handlers, auth/session
  helpers, cookies, redirects, client/server data boundaries, and untrusted rendering surfaces
- `gemo-sourcing-extension`: manifest permissions, host permissions, content scripts, service
  worker or background logic, message bridges, and privileged browser API calls
- config and verification files such as `package.json`, `pyproject.toml`, `next.config.*`,
  manifest files, and test or validation scripts

Use the changed files to choose where to look next, but do not assume the diff is the only surface
that matters when a shared trust model or security helper is involved.

## Security Review Loop Prevention

- build a trust-boundary matrix for auth-sensitive changes: actor or role, credential type, read
  paths, write paths, special mutations, lifecycle changes, and legacy or compatibility routes
- when one bypass exists, inspect sibling surfaces under the same trust model before concluding the
  review
- group same-root-cause bypasses into one blocker family and state whether it is new, still open,
  or resolved from prior rounds

## Web And Frontend Security Must-Haves

- auth, authorization, and session management logic are enforced consistently across middleware,
  route handlers, server actions, APIs, and client-visible redirects
- cookie scope, `Secure`, `HttpOnly`, and `SameSite` posture are coherent with the trust model
- cross-origin behavior such as CORS, postMessage, and embeddable surfaces does not widen the trust
  boundary unexpectedly
- user-controlled content, markdown, rich text, or HTML-like rendering paths have an explicit XSS
  and sanitization story
- CSP, framing posture, redirect handling, and third-party script usage do not silently weaken the
  browser security model
- tokens, session claims, secrets, or privileged identifiers are not exposed to the browser or
  client components unnecessarily

## Backend Security Must-Haves

- authorization checks exist at the real state-changing boundary, not only in one happy-path
  helper
- token scope, audience, issuer, expiry, revocation, and replay semantics stay coherent across all
  sibling routes and jobs
- provider callbacks, webhooks, and integration flows enforce trust checks such as signature or
  source validation when relevant
- query, persistence, and raw-input paths do not allow injection or unsafe trust widening
- logs, traces, and operational telemetry do not leak secrets or privileged data
- public or abuse-prone routes preserve intended rate limiting, validation, and anti-abuse posture

## Extension Security Must-Haves

- Manifest V3 permissions and `host_permissions` stay minimal and environment-appropriate
- privileged actions are not exposed to content scripts without strict validation
- extension messages validate sender, shape, and allowed action scope
- CSP and web-accessible resources do not widen the extension attack surface unnecessarily
- sensitive data is not leaked from service worker or extension storage into page context

## Detailed Finding Shape

For each material finding, try to state:

- what trust-boundary or security expectation is broken
- why it is unsafe in this concrete web, frontend, backend, or extension stack
- what the abuse path, data-exposure path, or rollout consequence is
- where the likely root cause or weak enforcement point lives
- which sibling surfaces probably share the same defect family
- what stronger remediation direction would reduce recurrence
- what proof path would validate the fix at the real boundary

## Proactive Prevention Lenses

Look beyond the changed line when the pattern suggests likely future defects:

- route-local auth or permission checks instead of central policy enforcement
- one secure route family while sibling routes still decode or trust the same token loosely
- cookies or session data used safely in one surface but exposed too broadly in another
- sanitization on one rendering path while sibling markdown, rich-text, or profile surfaces still
  trust user-controlled content
- extension messages or permissions that are tighter in one feature but still broad elsewhere
- security fixes that remove the immediate exploit but leave poor telemetry, weak verification, or
  incomplete rollback posture
- configuration or secret handling that is safe at runtime but still leaks through logs, browser
  bundles, manifests, or test fixtures

## Auth / Trust Must-Haves

- credential scope and trust assumptions remain consistent across every consumer of the credential
- read-scoped, preview-scoped, or role-scoped credentials do not widen into broader mutation
  privileges on sibling routes
- revocation, expiry, deletion, offboarding, role drift, ownership drift, reassignment, refresh,
  and invalidation semantics are enforced at every route that relies on the credential
- compatibility or legacy routes do not silently bypass the newer trust boundary

## Verification Must-Haves

- the review asks for proof at the real auth boundary that creates the risk, not only at a mocked
  service seam
- regression expectations name the exact privileged action, route family, or lifecycle branch that
  must be proven safe
- when the risk is browser-facing, the proof path should cover the actual middleware, cookie,
  redirect, route-handler, or rendering seam that creates the exposure

Look hard at:

- hidden trust assumptions between repos or services
- remote execution or injection surfaces
- XSS, unsafe HTML or markdown rendering, or client-side token leakage
- weak cookie or session posture in browser-facing auth flows
- missing authorization checks around state-changing actions
- rollout risk when security fixes are partial or unverifiable
- a credential that is validated strictly on one path but only decoded or loosely checked on a
  sibling path
- special-case actions that bypass the stricter dependency or policy used by the main read and
  write flows
- extension permissions, message handlers, or host access that exceed the actual feature need
