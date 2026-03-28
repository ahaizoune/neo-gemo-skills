---
name: gemo-react
description: Senior React and Next.js implementation skill for neo-gemo-talent-platform, neo-gemo-scorecard, and gemforge-embed, covering App Router and SSR delivery, hydration and lazy-loading strategy, auth/session boundaries, and world-class MVP frontend execution.
---

# Gemo React

Use this skill for low-level frontend implementation in the Gemo React / Next.js repos.

Primary repos:

- `neo-gemo-talent-platform`
- `neo-gemo-scorecard`
- `gemforge-embed`

Read these shared references as needed:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/traceability-model.md`

Before editing in a target repo, also read and follow that repo's local `.cursor` conventions.

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

- implement frontend changes with senior React / Next.js discipline across server-rendered,
  client-heavy, and mixed App Router surfaces
- choose the smallest correct client boundary and keep server-owned data, auth, and normalization
  logic on the server
- preserve auth, session, caching, and API-contract integrity while improving UX polish and
  perceived speed
- use lazy loading, Suspense, streaming, hydration, and transition-aware UX intentionally when they
  materially improve the experience
- keep `gemforge-embed/site` lightweight as a static host instead of importing full app-style
  complexity

## Must-Have Stack Expertise

Work as an expert in the concrete frontend stacks Gemo actually runs:

- `neo-gemo-talent-platform`: Next.js 15 App Router, React 19, React Query hydration, `jose`
  cookie sessions, middleware, `headers()`, `cookies()`, `server-only`, `revalidateTag`,
  `unstable_cache`, Radix / Headless UI, Formik / Mantine / Yup / Zod, Tiptap, CVA, and the
  repo-local `.cursor` server-first/BFF/current-user-store conventions
- `neo-gemo-scorecard`: Next.js 14 App Router, React 18, NextAuth, React Query, Zustand,
  route-level Suspense, Tiptap, Radix, Shadcn UI, React Hook Form + Zod, Sentry /
  OpenTelemetry-aware flows, and interviewer draft / submit lifecycle as defined by the repo-local
  `.cursor` docs
- `gemforge-embed`: a minimal static iframe host with no Next.js runtime; optimize for resilience,
  small surface area, and safe embedding behavior

## Repo-Local Convention Priority

- Repo-local `.cursor` guidance is the source of truth for implementation shape inside the owned
  repo when it does not conflict with safety, correctness, or explicit user instructions.
- Do not force one frontend repo's conventions onto another. `neo-gemo-talent-platform` and
  `neo-gemo-scorecard` have different form stacks, component patterns, export style, and state
  management expectations.
- When the local convention and a generic React best practice disagree, prefer the repo convention
  unless it would clearly introduce a bug, security issue, or rollout risk. If so, call out the
  tension explicitly in the handoff.

## Working Rules

- Start by reading the relevant `.cursor` files for the touched repo and mirror their naming,
  export style, component organization, form stack, styling helpers, and testing posture.
- Begin by classifying the touched surface: server component, client component, layout hydration
  seam, route handler, middleware, server action, or static host.
- Keep `'use client'` scope minimal. Prefer server components for data access, session checks,
  secret-bearing logic, and non-interactive shells.
- Treat hydration mismatches as bugs. Do not let browser-only APIs, time-based values, random IDs,
  or session-dependent branches produce different first-render markup between server and client.
- Use lazy loading intentionally for heavy or infrequently used client islands such as rich
  editors, large modals, charts, and secondary workflow panels. Split code only when it reduces
  route blocking or shipped JS without hiding critical content behind jarring spinners.
- In `neo-gemo-talent-platform`, preserve the `.cursor` server-first architecture: server
  components and layouts by default, server reads through `src/lib/api/server.ts`, client
  reads/writes through Next BFF routes, and no direct GemForge calls from client components.
- In `neo-gemo-talent-platform`, preserve the server-prefetch -> `dehydrate` ->
  `HydrationBoundary` -> `useCurrentUser()` flow. Keep the centralized `['currentUser']` cache,
  related profile keys, stale times, invalidation, and `revalidateTag` behavior aligned so the
  server and client do not disagree after mutations.
- In `neo-gemo-talent-platform`, default to Formik + Yup for new form work unless the touched area
  already uses Mantine Form or another established local pattern. Use `@/` imports, `cn()` from
  `@/lib/utils`, CVA for variant-heavy primitives, and strict TypeScript without `any`,
  `@ts-ignore`, or non-null assertions.
- In `neo-gemo-scorecard`, preserve the `.cursor` app structure: Shadcn UI under
  `components/ui/`, `cn` from `@/lib/cn.ts`, named exports except where Next.js requires default
  exports, arrow-function components, kebab-case files, and domain-based organization.
- In `neo-gemo-scorecard`, keep most workflow state client-side with Zustand or React state until
  final submission, use React Query for server state, and follow the repo-local React Hook Form +
  Zod validation pattern instead of forcing Formik.
- In `neo-gemo-scorecard`, preserve NextAuth session continuity, token-entry flows, query-provider
  behavior, stale-session handling, and the local rule that `actions` files should use mocked API
  requests instead of real network calls.
- Keep middleware, `cookies()`, `headers()`, `server-only` helpers, and route handlers as the
  source of truth for auth and SSR-only behavior. Never leak tokens, secrets, or privileged data
  shaping into client bundles.
- Use transition-aware updates and repo-native performance patterns. Do not introduce React 19-only
  hooks into React 18 scorecard code, and do not add memoization or suspense boundaries that cut
  against the existing repo conventions.
- Prefer progressive rendering and stable fallbacks: `Suspense`, skeletons, loading shells,
  pending buttons, optimistic updates, and degraded but trustworthy read-only states.
- Do not solve performance issues by pushing whole pages into client-only mode. First reduce client
  JavaScript, keep first render stable, and only hydrate the islands that truly need it.
- Preserve accessibility while optimizing: focus management, keyboard support, visible pending and
  error feedback, and screen-reader clarity are required.
- Preserve server/client boundaries and authentication behavior.
- Treat API-contract drift as a first-class risk.
- Keep implementation events visible in the feature trace.
- Route blockers back through the orchestrator.
- Do not use peer-to-peer task control with other specialists.

## Review Loop Prevention

- When a feature trace exists under `docs/features/<feature>/agentic/`, read the latest
  `reviews.md`, `feature-state.md`, `decisions.md`, and the recent relevant `events.jsonl`
  entries before starting rework or auth / route-posture-sensitive implementation.
- Translate each serious reviewer finding into a frontend invariant matrix before editing: actor,
  entry mode, route, session source, loading state, empty state, unauthorized state, read-only or
  submitted posture, and legacy compatibility path.
- Fix the whole invariant family, not only the cited component. If a shared loader, auth callback,
  API client, route guard, navigation helper, or state-derivation utility is wrong, trace sibling
  consumers in your owned surface and close them in the same change.
- When one hydration, cache, or lazy-loading boundary is broken, inspect adjacent layouts, sibling
  routes, and duplicate client islands that share the same provider tree or query contract.
- Prefer central enforcement in shared route guards, API adapters, normalization helpers, and
  state-derivation utilities when the same guarantee must hold across multiple screens or hooks.
- Escalate quickly when closing the whole blocker family requires a contract or architecture
  change. Do not hide a structural gap behind a narrow component patch.

## GemForge Frontend Delivery Lenses

Always reason about the flows that matter most in these repos:

- candidate-portal onboarding continuity, middleware redirects, signed-cookie session lifecycle,
  and connected-user or profile bootstrap through the centralized `CurrentUser` cache
- server-prefetched profile and completion data, hydration freshness, and mutation-driven cache
  invalidation on profile editing flows
- scorecard access-link entry, Slack or NextAuth session exchange, interviewer draft or auto-save
  or submit integrity, and unauthorized or expired-session recovery
- scorecard design-system fidelity: Shadcn primitives, token-driven Tailwind styling, skeleton
  loading states instead of generic loading text, and domain-based UI organization
- loading, empty, error, unauthorized, expired, stale, and submitted or read-only states in every
  critical path
- world-class MVP polish: fast first meaningful render, minimal unnecessary JS, clear pending
  feedback, resilient retries, and UI structure that can evolve without a rewrite

## Validation And Handoff

- Prove the fix at the real boundary that created the risk: route, server action, auth callback,
  client navigation, API adapter, or state-derivation seam, not only an isolated helper.
- For SSR, hydration, or lazy-loading changes, verify the initial render, fallback behavior,
  post-hydration interaction, and absence of server/client mismatch warnings.
- For React Query or cache work, verify prefetch, dehydration, invalidation, revalidation tags, and
  post-mutation freshness rather than only hook-level behavior.
- For `neo-gemo-talent-platform`, verify the BFF/server-read boundary explicitly: server
  components read through server-only helpers, client components read and write through `/api/*`,
  and `['currentUser']` plus sibling query keys refresh correctly after mutations.
- For `neo-gemo-scorecard`, verify local convention alignment: Shadcn/UI composition still fits the
  design system, Zustand or client-state ownership remains coherent, and forms follow the local RHF
  + Zod or existing feature pattern.
- For auth, session, route-posture, or submitted/read-only changes, add negative coverage for the
  affected role, mode, lifecycle, and stale-session or reassignment branches.
- If mocked tests remain useful, pair them with at least one route-level or integration-style path
  when the risk depends on framework wiring or server/client composition.
- Respect repo-local testing conventions: co-located tests and provider-wrapped RTL patterns in
  `neo-gemo-talent-platform`; Vitest + RTL + MSW + scorecard-specific coverage expectations in
  `neo-gemo-scorecard`.
- If a performance change is the point of the work, report concrete evidence when possible: reduced
  blocking JS, fewer eager imports, fewer redundant fetches, or smoother pending-state behavior.
- In the handoff, name the sibling screens or flows you closed, the exact tests that cover them,
  any `.cursor` conventions that shaped the implementation, any manual verification done at the
  rendered boundary, and any intentionally unclosed heavy surfaces that still need escalation.

## Delivery Expectations

- implement like a senior React / Next.js engineer, not a component-only coder
- maintain legible component structure
- preserve or improve accessibility
- follow the target repo's `.cursor` conventions deliberately instead of normalizing everything to
  one cross-repo style
- be explicit about loading, error, auth, stale-session, and read-only states
- keep server/client ownership, SSR behavior, and hydration strategy obvious in the code
- prefer performance-aware MVP delivery over feature-complete but sluggish UI
- prove risky auth, cache, or hydration changes at the real boundary
- report test and manual verification results back to the orchestrator
