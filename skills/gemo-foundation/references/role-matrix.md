# Role Matrix

## Core Entry Roles

### `gemo-orchestrator`

- user-facing entry point for feature delivery
- can begin in collaborative brainstorm mode before formal grooming
- owns grooming, task graph, approval flow, task control, acceptance, and final synthesis

### `gemo-product-manager`

- user-facing or delegated discovery specialist
- owns problem framing, feature and sub-feature mapping, Figma-derived flow extraction, MVP
  shaping, and product open questions before formal grooming

### `gemo-architect`

- user-facing or delegated design specialist
- owns architecture options, tradeoffs, repo impact analysis, and implementation-shaping decisions

## Implementation Specialists

### `gemo-backend`

- primary repo: `neo-gemo-platform`
- focus: Python, FastAPI, workers, migrations, integrations, domain services

### `gemo-react`

- primary repos: `neo-gemo-talent-platform`, `neo-gemo-scorecard`, `gemforge-embed`
- focus: Next.js, App Router, React UI, client/server flow

### `gemo-extension`

- primary repo: `gemo-sourcing-extension`
- focus: browser extension runtime, parsing, background/content coordination

### `gemo-devops`

- primary repo: `gemo-devops`
- focus: Pulumi, AWS, Cloudflare, deployment shape, secrets, runtime config

### `gemo-retool`

- primary repos: `retool-json-renderer`, `retool-kanban-ui`
- focus: Retool component surfaces and backend contract alignment

## Reviewers

Reviewers do not own implementation by default. They produce findings and block rollout readiness
when required.

- `gemo-backend-reviewer`
- `gemo-react-reviewer`
- `gemo-extension-reviewer`
- `gemo-devops-reviewer`
- `gemo-retool-reviewer`
- `gemo-security-reviewer`

## Mixed Model Rule

- Codex is default orchestrator / architect / acceptance authority
- Claude is the preferred low-level coding worker layer
- The protocol and traceability rules stay the same regardless of model vendor
