# Gemo Product Feature Map

Use this reference as the shared product knowledge base when mapping a feature request to impacted
repos, specialist roles, and adjacent platform workflows.

## Platform Picture

The product-manager and orchestrator skills should maintain an end-to-end understanding of the
GemForge platform, not only isolated features.

Key platform capability areas:

- sourcing and lead capture
- pipeline processing and candidate progression
- scorecards and interviewer workflows
- interview scheduling, tracking, and rescheduling
- deliberation and hiring decisions
- offers and downstream candidate communication
- onboarding and candidate portal experiences
- talent finder and internal search workflows
- engagement and contract-oriented operations
- time management and interview-related coordination
- Retool-based internal operational surfaces

When brainstorming or grooming a change, check whether it affects upstream or downstream workflow
stages in this broader chain.

## GemForge Onboarding

Typical concerns:

- candidate profile completion
- onboarding step progression
- onboarding data dependencies with GemForge user and profile surfaces

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

Typical concerns:

- profile and application surfaces
- authenticated user bootstrap and session continuity
- candidate-facing workflow visibility

Likely repos:

- `neo-gemo-platform`
- `neo-gemo-talent-platform`

## Scorecards / Interviewer Portal

Typical concerns:

- interviewer dashboard and interview queue
- scorecard completion and review state
- interview tracking, status changes, and rescheduling
- interviewer-facing workflow visibility
- integration with backend interview lifecycle data

Likely repos:

- `neo-gemo-scorecard`
- `neo-gemo-platform`
- possibly `gemo-devops` if environment, routing, secrets, or deployment shape changes

## Sourcing

Typical concerns:

- LinkedIn parsing and enrichment
- source-to-candidate creation flow
- sourcing signals passed into GemForge pipeline workflows

Likely repos:

- `gemo-sourcing-extension`
- `neo-gemo-platform`

## Pipeline Processing

Typical concerns:

- candidate stage progression
- routing between recruiter, interviewer, and hiring decision flows
- dependencies between sourcing, scorecards, interviews, deliberation, and offers

Likely repos:

- `neo-gemo-platform`
- `neo-gemo-scorecard` when interviewer-facing progress or state is exposed
- possibly `retool-kanban-ui` or `retool-json-renderer` when internal pipeline views are affected

## Offers

Typical concerns:

- offer readiness after deliberation
- offer-state transitions and downstream candidate communication
- interactions with candidate portal or internal operations

Likely repos:

- `neo-gemo-platform`
- possibly `neo-gemo-talent-platform`

## Deliberation

Typical concerns:

- scorecard and interview outcomes feeding decision-making
- internal collaboration on final hiring signals
- operational views for decision support

Likely repos:

- `neo-gemo-platform`
- `retool-json-renderer`

## Talent Finder

Typical concerns:

- recruiter or operator search workflows
- filtering, ranking, and pipeline-aware candidate discovery

Likely repos:

- `neo-gemo-platform`

## Engagement

Typical concerns:

- post-selection or contract-oriented workflows
- downstream operational lifecycle beyond hiring decision

Likely repos:

- `neo-gemo-platform`

## Timemanagement

Typical concerns:

- interview coordination
- availability-sensitive workflow steps
- reschedule and time tracking implications for interviewer flows

Likely repos:

- `neo-gemo-platform`
- `neo-gemo-scorecard` when the scorecard app consumes related backend surfaces

## Retool Surfaces

Typical concerns:

- operational dashboards
- internal workflow visualizations
- contract alignment with GemForge backend data

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

## Knowledge Base Maintenance Rule

This file is a living product knowledge base.

When a feature adds, removes, renames, or materially changes a product capability, workflow, or
cross-feature dependency:

- update this file in the same body of work
- update any more specific skill references that are now stale
- ensure `gemo-product-manager` and `gemo-orchestrator` can reason about the new platform picture
  on the next feature

Do not close substantial product work while leaving the product knowledge base stale.
