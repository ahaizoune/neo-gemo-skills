# Gemo Product Feature Map

Use this reference when mapping a feature request to impacted repos and specialist roles.

## GemForge Onboarding

Likely repos:

- `neo-gemo-platform`
- `neo-gemo-talent-platform`

Common roles:

- `gemo-architect`
- `gemo-backend`
- `gemo-react`
- `gemo-backend-reviewer`
- `gemo-react-reviewer`

## Candidate Portal

Likely repos:

- `neo-gemo-platform`
- `neo-gemo-talent-platform`

## Scorecards / Interviewer Portal

Likely repos:

- `neo-gemo-scorecard`
- `neo-gemo-platform`
- possibly `gemo-devops` if environment, routing, secrets, or deployment shape changes

## Sourcing

Likely repos:

- `gemo-sourcing-extension`
- `neo-gemo-platform`

## Offers

Likely repos:

- `neo-gemo-platform`
- possibly `neo-gemo-talent-platform`

## Deliberation

Likely repos:

- `neo-gemo-platform`
- `retool-json-renderer`

## Talent Finder

Likely repos:

- `neo-gemo-platform`

## Engagement

Likely repos:

- `neo-gemo-platform`

## Timemanagement

Likely repos:

- `neo-gemo-platform`
- `neo-gemo-scorecard` when the scorecard app consumes related backend surfaces

## Retool Surfaces

Likely repos:

- `retool-json-renderer`
- `retool-kanban-ui`
- `neo-gemo-platform`

## Routing Rule

If a feature touches:

- multiple repos: start with `gemo-orchestrator` and involve `gemo-architect`
- one repo but multiple disciplines: start with `gemo-orchestrator`
- one repo and one discipline: direct specialist skill use is allowed after architecture is already
  clear
