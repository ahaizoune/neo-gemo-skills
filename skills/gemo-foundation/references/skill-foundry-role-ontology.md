# Skill Foundry Role Ontology

Use this ontology to map a short user brief into the right Gemo skill shape.

## Ontology Axes

- role family
- primary lane
- primary repo or repo set
- user-facing vs delegated posture
- canonical stack anchors
- source-of-truth surfaces
- output artifacts
- review mapping
- quality-bar themes

## Role Families

### User-Facing Entry Roles

- `gemo-orchestrator`: multi-repo entry point for brainstorming, grooming, execution routing, and
  closeout synthesis
- `gemo-product-manager`: discovery, feature shaping, user-flow mapping, and MVP slicing
- `gemo-architect`: architecture options, source-of-truth ownership, quality attributes, and risk
  retirement
- `gemo-skill-foundry`: skill-suite evolution, role benchmarking, ontology refresh, and
  skill-authoring workflow control

### Implementation Specialists

- `gemo-backend`: `neo-gemo-platform`
- `gemo-react`: `neo-gemo-talent-platform`, `neo-gemo-scorecard`, `gemforge-embed`
- `gemo-extension`: `gemo-sourcing-extension`
- `gemo-devops`: `gemo-devops`
- `gemo-retool`: `retool-json-renderer`, `retool-kanban-ui`

### Reviewers

- `gemo-backend-reviewer`
- `gemo-react-reviewer`
- `gemo-extension-reviewer`
- `gemo-devops-reviewer`
- `gemo-retool-reviewer`
- `gemo-security-reviewer`

## Lane Cards

### `gemo-orchestrator`

- family: user-facing entry
- repo surface: cross-repo
- outputs: discovery, grooming, architecture, execution, and closeout packets
- quality bar: correct mode selection, explicit ownership, traceability, reviewer routing

### `gemo-product-manager`

- family: user-facing entry
- repo surface: cross-repo discovery
- outputs: discovery packet, feature map, MVP framing, open questions
- quality bar: product clarity, actor and workflow mapping, scope discipline

### `gemo-architect`

- family: user-facing entry
- repo surface: cross-repo design
- outputs: architecture packet, tradeoffs, validation plan, reviewer set
- quality bar: source-of-truth clarity, compatibility posture, trust-boundary visibility

### `gemo-skill-foundry`

- family: user-facing entry
- primary repo: `neo-gemo-skills`
- outputs: new or updated skill folders, ontology updates, suite-doc updates, validation and
  install results
- quality bar: accurate lane mapping, world-class role benchmark fit, concrete stack grounding,
  precise triggers, and low-genericity skill prose

### `gemo-backend`

- family: implementation specialist
- primary repo: `neo-gemo-platform`
- stack anchors: FastAPI, workers, PostgreSQL, Redis, integrations
- quality bar: boundary clarity, rollout-safe migrations, auth and state-machine integrity

### `gemo-react`

- family: implementation specialist
- primary repos: `neo-gemo-talent-platform`, `neo-gemo-scorecard`, `gemforge-embed`
- stack anchors: Next.js App Router, React 18/19 UI, SSR and hydration, auth, and client/server
  boundaries
- quality bar: flow integrity, SSR and hydration correctness, performance-aware interactivity,
  auth posture, contract alignment, and accessibility

### `gemo-extension`

- family: implementation specialist
- primary repo: `gemo-sourcing-extension`
- stack anchors: background and content scripts, Chrome runtime, message routing, parser safety
- quality bar: permission discipline, runtime safety, parser resilience

### `gemo-devops`

- family: implementation specialist
- primary repo: `gemo-devops`
- stack anchors: Python Pulumi, AWS networking and runtime services, Cloudflare DNS, GitHub
  Actions, secrets, and monitoring
- quality bar: rollout safety, rollback posture, cost efficiency, observability, least privilege,
  scalable service posture, and environment fidelity

### `gemo-retool`

- family: implementation specialist
- primary repos: `retool-json-renderer`, `retool-kanban-ui`
- stack anchors: Retool custom components, host behavior, backend contract alignment
- quality bar: contract discipline, embedded runtime correctness, degraded-data resilience

### Reviewer Lanes

- reviewer lanes inherit the owned repo set and stack anchors from their implementation sibling
- `gemo-security-reviewer` is the cross-cutting reviewer for auth, authorization, token handling,
  trust boundaries, execution surfaces, and rollout-blocking security risk

## Mapping Heuristics

- Choose the primary lane from the repo surface plus the main job-to-be-done, not only from the
  user's wording.
- Keep a skill user-facing when it needs to ask clarifying questions, shape ambiguity, or produce
  a structured packet before implementation.
- Keep a skill delegated or specialist when repo ownership and file zones are already explicit.
- Create a new skill when the requested surface changes user-facing contract, primary repo set,
  output artifact shape, or quality bar enough that extending an existing lane would blur its
  identity.
- Extend an existing skill when the request strengthens the same lane, repo set, and quality bar
  without changing the core contract.

## Review Mapping

- implementation lane -> matching reviewer lane
- auth, token, session, permission, or trust-boundary sensitivity -> add
  `gemo-security-reviewer`
- multi-repo or cross-discipline workflow shifts -> involve `gemo-architect` or
  `gemo-orchestrator` in the design phase before implementation
