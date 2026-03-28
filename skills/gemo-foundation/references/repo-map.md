# Gemo Repo Map

## Core Repos

### `neo-gemo-platform`

Primary backend monorepo.

- `GemForge`: users, profiles, onboarding, candidate portal, pipelines, scorecards, offers,
  deliberation, talent finder, integrations
- `GemHub`: engagement, contracts, timemanagement
- language: Python
- runtime: FastAPI, workers, PostgreSQL, Redis

### `neo-gemo-talent-platform`

Candidate-facing Next.js application.

- onboarding
- candidate portal
- profile editing
- public profile surfaces
- integrates with GemForge APIs through App Router handlers and server-side normalization

### `neo-gemo-scorecard`

Interview and scorecard-oriented Next.js application.

- scorecards
- consultation views
- interviewer-facing flows
- Slack-based auth and backend JWT exchange

### `gemo-sourcing-extension`

Browser extension for LinkedIn sourcing.

- profile parsing
- candidate creation / assignment
- pipeline selection
- Chrome extension runtime concerns

### `gemo-devops`

Pulumi infrastructure for AWS and Cloudflare.

- networking
- PostgreSQL
- Redis
- App Runner
- ECS workers
- deployment workflows

### `retool-json-renderer`

Retool custom renderer package for JSON and deliberation surfaces.

### `retool-kanban-ui`

Retool kanban custom component package.

### `gemforge-embed`

Embed-oriented surface with smaller scope than the main product apps.

### `neo-gemo-skills`

Canonical skill-suite repo.

- skill definitions and `agents/openai.yaml`
- shared architecture, traceability, and cmux doctrine
- skill authoring ontology and source policy
- install and sync scripts for `~/.codex/skills`

## Specialist Ownership Defaults

- `gemo-backend`: `neo-gemo-platform`
- `gemo-react`: `neo-gemo-talent-platform`, `neo-gemo-scorecard`, `gemforge-embed`
- `gemo-extension`: `gemo-sourcing-extension`
- `gemo-devops`: `gemo-devops`
- `gemo-retool`: `retool-json-renderer`, `retool-kanban-ui`
- `gemo-skill-foundry`: `neo-gemo-skills`

Use `gemo-architect` when a feature crosses repo or domain boundaries.
