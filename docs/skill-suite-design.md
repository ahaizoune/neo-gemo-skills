# Gemo Skill Suite Design

## Goal

Create a versioned skill suite that gives Gemo a single orchestration entry point while keeping
product brainstorming, specialist execution, review, traceability, and cmux collaboration explicit
and reusable.

## Primary Design Decisions

### 1. One canonical repo

`neo-gemo-skills` is the source of truth.

- installed skill copies under `~/.codex/skills` are artifacts
- Gemo-specific cmux protocol and scripts live here
- generic cmux materials elsewhere should sync from here when they must remain aligned

### 2. Entry point plus specialist skills

`gemo-orchestrator` is the main user-facing entry point.

Supporting skills:

- `gemo-skill-foundry`
- `gemo-product-manager`
- `gemo-architect`
- implementation specialists by discipline
- reviewers by discipline and security
- `gemo-foundation` as shared doctrine

The orchestrator can start in brainstorm mode before formal grooming and architecture approval.

### 3. Hybrid Codex / Claude model

- Codex: orchestrator, architect, review coordination, final acceptance
- Claude: low-level coding workers

The protocol, traceability model, and ownership rules are vendor-neutral.

### 4. Lightweight CQRS trace model

Per feature, persist:

- append-only `events.jsonl`
- curated current state in `feature-state.md`
- decision log
- review log
- rollout log
- standardized phase packets for discovery, grooming, architecture, and execution planning

### 5. Strict task-control authority

- orchestrator owns task routing and acceptance
- peer-to-peer worker control flow is disallowed
- only tightly scoped clarification may happen directly
- direct clarification must be logged back into the feature trace

### 6. Mandatory approval and review gates

- human approval after grooming / architecture and before implementation
- reviewer approval before rollout readiness on non-trivial work
- technical debt introduced during execution must be either retired or consciously accepted with an
  explicit owner and follow-up path before rollout

## Role Taxonomy

### Foundation

- `gemo-foundation`

### Entry and design

- `gemo-orchestrator`
- `gemo-skill-foundry`
- `gemo-product-manager`
- `gemo-architect`

### Implementation

- `gemo-backend`
- `gemo-react`
- `gemo-extension`
- `gemo-devops`
- `gemo-retool`

### Review

- `gemo-backend-reviewer`
- `gemo-react-reviewer`
- `gemo-extension-reviewer`
- `gemo-devops-reviewer`
- `gemo-retool-reviewer`
- `gemo-security-reviewer`

## cmux Model

The suite assumes:

- one workspace per feature
- orchestrator surface as the anchor
- sidebar metadata used as the control plane
- disciplined `HELLO / REQ / ACK / BUSY / INFO / RES / ERR` collaboration envelopes
- one right lane and one bottom lane reused instead of endless splits

## Why This Shape

This separates:

- durable role knowledge
- runtime delegation
- review coordination
- traceability

without making the orchestrator a giant untestable prompt blob.
