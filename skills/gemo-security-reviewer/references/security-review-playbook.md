# Security Review Playbook

Focus on:

- authentication and authorization integrity
- token handling and secret exposure
- cross-boundary trust assumptions
- input validation and execution surfaces
- privilege escalation paths
- trust-boundary coverage across all routes and actions that consume the same credential or claim

## Security Review Loop Prevention

- build a trust-boundary matrix for auth-sensitive changes: actor or role, credential type, read
  paths, write paths, special mutations, lifecycle changes, and legacy or compatibility routes
- when one bypass exists, inspect sibling surfaces under the same trust model before concluding the
  review
- group same-root-cause bypasses into one blocker family and state whether it is new, still open,
  or resolved from prior rounds

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

Look hard at:

- hidden trust assumptions between repos or services
- remote execution or injection surfaces
- missing authorization checks around state-changing actions
- rollout risk when security fixes are partial or unverifiable
- a credential that is validated strictly on one path but only decoded or loosely checked on a
  sibling path
- special-case actions that bypass the stricter dependency or policy used by the main read and
  write flows
