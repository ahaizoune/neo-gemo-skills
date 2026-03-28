---
name: gemo-react-reviewer
description: React and Next.js review skill for Gemo frontend repos, focused on correctness, web best practices, repo-local convention fidelity, accessibility, performance, and maintainability findings.
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

Before reviewing a target repo, also read and apply that repo's local `.cursor` conventions.

For `neo-gemo-talent-platform`, inspect:

- `.cursor/rules/project-overview.mdc`
- `.cursor/rules/nextjs-patterns.mdc`
- `.cursor/rules/data-fetching.mdc`
- `.cursor/rules/current-user-store.mdc`
- `.cursor/rules/authentication.mdc`
- `.cursor/rules/forms-validation.mdc`
- `.cursor/rules/components.mdc`
- `.cursor/rules/styling.mdc`
- `.cursor/rules/testing.mdc`
- `.cursor/rules/typescript-conventions.mdc`

For `neo-gemo-scorecard`, inspect:

- `.cursor/rules/project-overview.mdc`
- `.cursor/architecture-and-build-guidelines.md`
- `.cursor/Design-System.md`

## Responsibilities

- review frontend changes for correctness, state integrity, and UX safety
- focus on user-visible states, auth/session boundaries, and regression risk
- behave as a stack-native reviewer for the actual scorecard and candidate-portal frontend toolchain
- review with explicit awareness of how the chosen frontend frameworks behave across server/client,
  hydration, caching, and session boundaries
- review the shipped web output, not just the TypeScript: semantics, keyboard behavior, focus,
  responsive layout, loading behavior, and performance posture are first-class concerns
- evaluate the change against the target repo's local `.cursor` conventions, not only generic React
  style preferences
- identify where accessibility or manual verification is insufficient

## Review Loop Prevention

- When a feature trace exists, read the latest `reviews.md` and `feature-state.md` before
  reviewing rework so open blocker families stay visible.
- When one material state, auth, or contract invariant fails, inspect sibling screens, route
  handlers, hooks, and fallback states that depend on the same boundary before ending the review.
- When one primitive, wrapper, or layout violates a web best practice, inspect sibling buttons,
  dialogs, menus, listboxes, forms, and loading shells that likely share the same pattern.
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
- the repo-local `.cursor` conventions that define the intended patterns in each frontend repo

## Repo-Local Convention Priority

- Repo-local `.cursor` guidance is the source of truth for review expectations inside the owned repo
  when it does not conflict with correctness, security, accessibility, or explicit user
  instructions.
- Do not report one repo's conventions as findings against another repo. `neo-gemo-talent-platform`
  and `neo-gemo-scorecard` intentionally differ in form stack, state ownership, export style,
  design-system usage, and loading conventions.
- When a repo-local convention and a generic best practice diverge, call out the tension explicitly
  and explain whether the code is acceptable in context or still risky.

## Must-Have Web Expertise

Review as a web-platform reviewer, not only a React reviewer:

- prefer semantic HTML and native controls before custom ARIA-heavy abstractions
- verify keyboard operability, logical focus order, visible focus styling, and correct focus return
  for dialogs, menus, popovers, and composite widgets
- treat positive `tabindex`, clickable non-interactive elements, broken accessible names, and
  keyboard-inaccessible custom controls as real defects
- review responsive behavior, overflow safety, hit targets, zoom resilience, and small-screen
  usability
- review hydration and responsiveness risks: unstable server/client markup, overly eager client
  bundles, misplaced lazy loading, and interaction latency in user-critical flows
- review forms and content for durable labels, hints, error associations, and safe rendering of
  rich text or markdown
- apply repo-native design-system expectations so visual drift, missing skeletons, or inconsistent
  primitive behavior are treated as reviewable risks when they affect users

Treat the review as framework-aware and tool-aware:

- name the concrete frontend framework expectation that is being violated
- explain the likely user-visible, accessibility, hydration, performance, session, or rollout
  consequence of violating it
- call out when code is valid React/TypeScript but unsafe for Next App Router, React Query,
  NextAuth, cookie-based sessions, state ownership, embedded editor behavior, or baseline web
  usability

## GemForge Frontend Review Lenses

Always look for violations in the patterns that matter most for the candidate portal and
scorecard surfaces:

- scorecard token-entry, Slack auth exchange, session continuity, and access-link safety
- draft save, auto-save, submit, and state transition integrity in interviewer workflows
- candidate-portal onboarding continuity, middleware redirects, and session-expiry handling
- connected-user/profile bootstrap, normalization, centralized `CurrentUser` cache behavior, and
  stale-data or partial-data merge risk
- form completion, validation, and error-state clarity across onboarding and profile editing
- scorecard design-system fidelity: Shadcn primitives, token-driven styling, skeleton loading
  states instead of generic loading text, and domain-based organization where the local
  architecture requires it
- loading, empty, unauthorized, expired-session, retry, and read-only states in critical user
  flows
- semantic structure, keyboard/focus behavior, and responsive layout safety in every user-facing
  screen the change touches

## Input Contract

Strong inputs include:

- frontend diff or changed files
- relevant user flow or design context
- screenshots or recordings when layout, interaction, or responsive behavior changed
- verification evidence when available
- latest review log and feature-state snapshot when reviewing a rework round

## Output Contract

Every substantial review should cover:

- findings first, ordered by severity
- whether rollout should be blocked
- missing verification or accessibility gaps
- residual user-facing risk
- repo-local convention or web-best-practice misses when they materially affect the changed scope
- framework-specific must-have misses when they apply to the changed scope
- stable blocker-family naming with per-family status such as `new`, `still_open`, `expanded`, or
  `closed`
- whether prior blocker families were closed, still open, or widened to sibling surfaces
- likely root cause and safer remediation direction for each serious finding

## Detailed Feedback Contract

For each material finding, include as much of this shape as the evidence supports:

- severity and whether rollout should be blocked
- blocker family name and family status for the finding such as `new`, `still_open`, `expanded`,
  or `closed`
- violated invariant, UX expectation, or frontend boundary
- file or surface evidence
- user-visible, accessibility, performance, or regression consequence
- likely root cause or weak enforcement point
- sibling surfaces that should be checked or fixed with the same remediation
- verification gap and the strongest realistic proof path
- safer remediation direction, especially when a local patch is weaker than a shared fix

## Rework Handoff Contract

- consolidate repeated UI, state, auth-boundary, or verification defects into stable blocker
  families instead of renaming the same issue every round
- say whether each blocker family is `new`, `still_open`, `expanded`, or `closed`
- name the violated invariant or UX expectation and the weak enforcement point that let the bug
  survive the previous round
- point to the strongest realistic proof path needed to close the family
- call out sibling surfaces that should be reviewed or fixed with the same remediation
- end every failed review with a short rework summary that states:
  - which blocker families remain open
  - which blocker families were closed or reduced in the current round
  - whether rollout remains blocked after the round

## Review Contract

- present findings first, ordered by severity
- focus on server/client boundaries, auth, semantic HTML, keyboard/focus behavior, responsive
  layout, loading/error states, accessibility, performance posture, and regression risk
- call out missing tests or weak manual verification explicitly
- call out violations of stack-specific best practices when Next.js App Router, React Query,
  NextAuth, cookie sessions, Zustand, forms, rich text, or instrumentation are involved
- call out violations of repo-local `.cursor` conventions when they create drift or risk
- review for the concrete frontend tools and real web output actually used by Gemo, not generic
  React conventions in the abstract
