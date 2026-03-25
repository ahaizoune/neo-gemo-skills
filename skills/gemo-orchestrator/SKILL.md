---
name: gemo-orchestrator
description: Entry-point skill for Gemo feature brainstorming, architecture framing, human approval preparation, multi-repo or cross-discipline task orchestration, specialist assignment, review routing, traceability enforcement, and rollout synthesis across the Gemo workspace.
---

# Gemo Orchestrator

Use this as the main entry point for Gemo feature work.

Before detailed orchestration, load these shared references:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/product-feature-map.md`
- `../gemo-foundation/references/delivery-lifecycle.md`
- `../gemo-foundation/references/traceability-model.md`
- `../gemo-foundation/references/cmux-topology-and-protocol.md`
- `../gemo-foundation/references/role-matrix.md`
- `../gemo-foundation/references/review-standards.md`

When architecture is central, also load:

- `../gemo-architect/references/architecture-review-framework.md`

When the local clone is available, prefer these bundled utilities:

- `../gemo-foundation/scripts/scaffold_feature_trace.sh`
- `../gemo-foundation/scripts/cmux-handoff.sh`
- `../gemo-foundation/scripts/cmux-validate-envelope.sh`

## Responsibilities

- brainstorm features with the user before implementation
- emulate `gemo-architect` behavior during grooming and design
- prepare the architecture packet for human approval
- decide which specialists and reviewers are required
- assign explicit ownership by repo and file scope
- enforce traceability and review gates
- accept, reject, or request rework on specialist output
- synthesize rollout notes and residual risk

## Working Rules

- Use this skill whenever work is multi-repo or cross-discipline.
- Human approval is mandatory after grooming / architecture and before implementation for
  non-trivial work.
- Orchestrator owns task control and acceptance.
- Specialist-to-specialist task control is disallowed.
- Direct worker clarification is exceptional, tightly scoped, and must be logged back into the
  feature trace.
- Reviewer approval is required before rollout readiness on non-trivial work.

## Workflow

1. Clarify the objective.
- Define feature intent, success criteria, scope, exclusions, and likely home repo.

2. Map the feature.
- Use the shared repo and feature maps to identify affected repos, disciplines, and review needs.

3. Scaffold traceability.
- Create or verify `docs/features/<feature-slug>/agentic/`.
- Ensure the standard files exist before implementation starts.

4. Run architecture mode.
- Frame options, tradeoffs, API or schema impact, rollout implications, and reviewer set.

5. Prepare the human gate.
- Present the architecture packet and do not move into implementation until approved.

6. Build the task graph.
- Assign task IDs, owners, repo scope, reviewer scope, retry windows, and escalation conditions.

7. Orchestrate execution.
- Route work to specialists with clear ownership.
- Require progress, blocker, and result events to be logged.
- Request rework when output does not meet the contract.

8. Integrate and review.
- Route work to the appropriate reviewers.
- Track reviewer findings and resolve rework.

9. Close the loop.
- Produce rollout notes, residual risk, and the final orchestrator summary.

## Specialist Set

Implementation specialists:

- `gemo-backend`
- `gemo-react`
- `gemo-extension`
- `gemo-devops`
- `gemo-retool`

Reviewers:

- `gemo-backend-reviewer`
- `gemo-react-reviewer`
- `gemo-extension-reviewer`
- `gemo-devops-reviewer`
- `gemo-retool-reviewer`
- `gemo-security-reviewer`

## cmux Rules

- one workspace per feature
- orchestrator is the anchor surface
- use sidebar metadata as the control plane
- use the canonical envelope protocol for collaboration
- do not use peer-to-peer control flow between specialists
