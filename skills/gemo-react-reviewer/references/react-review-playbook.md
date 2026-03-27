# React Review Playbook

Use this playbook as a scorecard/candidate-portal stack-aware reviewer, not a generic React
reviewer.

Focus on:

- server/client boundary correctness
- state integrity across loading, error, empty, and success states
- auth and session safety
- accessibility and keyboard/screen-reader impact
- regression risk in user-critical flows
- cache and normalization integrity across server and client data sources
- observability for risky or high-friction flows

## Frontend Stack In Scope

- Next.js App Router
- React 18 and React 19
- TypeScript
- TanStack React Query
- NextAuth
- `jose`-backed signed cookie sessions
- Zustand
- React Hook Form, Mantine Form, Formik, Zod, and Yup
- Radix UI, Headless UI, and shadcn-style primitives
- Tailwind CSS and design tokens
- Tiptap, markdown rendering, and sanitization-sensitive content
- Sentry, OpenTelemetry, Vitest, React Testing Library, and MSW

## Next.js App Router Must-Haves

- server-only code stays on the server side and is not imported into client components
- `cookies()`, headers, redirects, middleware, and route behavior are used at the correct boundary
- caching, `no-store`, and fetch behavior match the freshness requirements of the flow
- route-segment, layout, and client-component composition do not create hydration or auth leaks
- loading, unauthorized, expired-session, and error handling remain coherent across navigation

## React 18 / 19 Must-Haves

- effects, derived state, and controlled inputs do not create hydration or stale-closure bugs
- client state is not duplicating authoritative server state without a clear reason
- interaction-heavy flows do not regress due to unnecessary rerenders or fragile effect timing
- transitions, async UI, and event ordering behave predictably under slow or failed requests

## React Query Must-Haves

- query keys are stable and scoped correctly
- invalidation or refetch behavior matches the mutation side effects
- optimistic or cached state does not drift from server truth
- error and retry behavior is explicit for user-critical flows

## Auth / Session Must-Haves

- NextAuth session assumptions remain valid in scorecard flows
- Slack OAuth token exchange and session JWT handling are not weakened accidentally
- cookie-backed session behavior in candidate portal stays server-safe and expiry-aware
- redirects and guarded routes do not leak protected content or create redirect loops
- token, access-link, and preview flows do not widen access accidentally

## Forms / Validation Must-Haves

- form state ownership is clear and not split unsafely across multiple abstractions
- client validation and server expectations stay aligned
- permissive draft-save behavior vs strict submit behavior is preserved where required
- error messages, field states, and disabled/loading states are coherent

## UI Primitives / Styling Must-Haves

- Radix or Headless UI primitives remain accessible when wrapped or restyled
- dialog, popover, tooltip, select, and focus behavior remain correct
- Tailwind and token usage preserve the existing design system instead of introducing drift
- responsive behavior and overflow handling are safe for desktop and smaller screens

## Rich Text / Content Must-Haves

- Tiptap or markdown content remains sanitized and safe
- serialization/deserialization does not lose user input or formatting unexpectedly
- editor state changes do not break autosave, submit, or preview flows

## Observability Must-Haves

- meaningful errors still reach Sentry or local observability hooks
- high-risk flows remain traceable enough to debug in production
- sensitive data is not leaked into logs, traces, or client-visible error payloads

## Test And Verification Must-Haves

- tests cover the state transitions or edge cases created by the change
- interaction-heavy changes have meaningful RTL/MSW/manual verification evidence
- reviewer distinguishes proven behavior from assumed behavior
- tests exercise the framework boundary that creates the risk, not just the happy path

## Domain And Workflow Safety Must-Haves

- scorecard preview, auth, draft save, autosave, and submit flows preserve the intended contract
- onboarding, profile bootstrap, and candidate-portal redirects stay coherent under expired sessions
- merged or normalized profile data does not silently drop or overwrite higher-quality data
- unauthorized, empty, partial, or degraded states are handled intentionally in user-critical flows

Look hard at:

- missing states in user workflows
- stale or duplicated client state
- auth assumptions crossing server/client boundaries
- cache invalidation gaps after mutation
- hydration or client/server leakage caused by wrong imports or boundaries
- form behavior that diverges between draft save and final submit
- rich text or markdown flows that lose sanitization or content integrity
- instrumentation regressions that make critical flows harder to debug
- weak manual verification for interaction-heavy changes
