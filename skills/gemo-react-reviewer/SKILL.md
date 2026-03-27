---
name: gemo-react-reviewer
description: React and Next.js review skill for Gemo frontend repos, focused on correctness, UX state integrity, auth flow safety, accessibility, and maintainability findings.
---

# Gemo React Reviewer

Use this skill to review frontend changes in:

- `neo-gemo-talent-platform`
- `neo-gemo-scorecard`
- `gemforge-embed`

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`
- `../gemo-foundation/references/repo-map.md`
- `references/react-review-playbook.md`

## Responsibilities

- review frontend changes for correctness, state integrity, and UX safety
- focus on user-visible states, auth/session boundaries, and regression risk
- behave as a stack-native reviewer for the actual scorecard and candidate-portal frontend toolchain
- review with explicit awareness of how the chosen frontend frameworks behave across server/client,
  hydration, caching, and session boundaries
- identify where accessibility or manual verification is insufficient

## Review Loop Prevention

- When a feature trace exists, read the latest `reviews.md` and `feature-state.md` before
  reviewing rework so open blocker families stay visible.
- When one material state, auth, or contract invariant fails, inspect sibling screens, route
  handlers, hooks, and fallback states that depend on the same boundary before ending the review.
- Group same-root-cause sibling issues together and distinguish genuinely new findings from prior
  blockers that still remain open.

## Must-Have Stack Expertise

Review as an expert in the frontend stack actually used to build `neo-gemo-scorecard`,
`neo-gemo-talent-platform`, and `gemforge-embed`:

- Next.js App Router in both Next 14 and Next 15, including route handlers, middleware,
  `cookies()`, redirects, caching, and server-only boundaries
- React 18 and React 19 rendering behavior, hydration constraints, hook semantics, and
  client/server composition
- TypeScript strict-mode expectations for UI, API normalization, and prop/data contracts
- TanStack React Query cache behavior, invalidation, server-state ownership, and stale-data risk
- scorecard auth with NextAuth and Slack OAuth plus candidate-portal session handling with
  `jose`-backed signed cookies
- Zustand usage in scorecard and local/client state ownership boundaries
- form and validation stacks used in Gemo: React Hook Form, Mantine Form, Formik, Zod, and Yup
- Radix, Headless UI, and shadcn-style composition, including a11y and controlled/uncontrolled
  behavior
- Tailwind CSS, Tailwind Merge, and design-token driven styling
- Tiptap, markdown rendering, and sanitization-sensitive rich text flows
- Sentry / OpenTelemetry instrumentation and user-flow observability expectations
- Vitest, React Testing Library, MSW, and manual verification discipline for interaction-heavy UI

Treat the review as framework-aware and tool-aware:

- name the concrete frontend framework expectation that is being violated
- explain the likely user-visible, hydration, session, or rollout consequence of violating it
- call out when code is valid React/TypeScript but unsafe for Next App Router, React Query,
  NextAuth, cookie-based sessions, state ownership, or embedded editor behavior

## GemForge Frontend Review Lenses

Always look for violations in the patterns that matter most for the candidate portal and
scorecard surfaces:

- scorecard token-entry, Slack auth exchange, session continuity, and access-link safety
- draft save, auto-save, submit, and state transition integrity in interviewer workflows
- candidate-portal onboarding continuity, middleware redirects, and session-expiry handling
- connected-user/profile bootstrap, normalization, and stale-data or partial-data merge risk
- form completion, validation, and error-state clarity across onboarding and profile editing
- loading, empty, unauthorized, expired-session, and retry states in critical user flows

## Input Contract

Strong inputs include:

- frontend diff or changed files
- relevant user flow or design context
- verification evidence when available
- latest review log and feature-state snapshot when reviewing a rework round

## Output Contract

Every substantial review should cover:

- findings first, ordered by severity
- whether rollout should be blocked
- missing verification or accessibility gaps
- residual user-facing risk
- framework-specific must-have misses when they apply to the changed scope
- whether prior blocker families were closed, still open, or widened to sibling surfaces

## Review Contract

- present findings first, ordered by severity
- focus on server/client boundaries, auth, loading/error states, accessibility, and regression risk
- call out missing tests or weak manual verification explicitly
- call out violations of stack-specific best practices when Next.js App Router, React Query,
  NextAuth, cookie sessions, Zustand, forms, rich text, or instrumentation are involved
- review for the concrete frontend tools actually used by Gemo, not generic React conventions
