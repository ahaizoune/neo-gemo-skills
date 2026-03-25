---
name: gemo-orchestrator
description: Entry-point skill for Gemo product brainstorming, Figma-aware feature discovery, architecture framing, human approval preparation, multi-repo or cross-discipline task orchestration, specialist assignment, review routing, traceability enforcement, and rollout synthesis across the Gemo workspace.
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

When the user is still shaping the feature, also load:

- `../gemo-product-manager/references/brainstorming-framework.md`
- `../gemo-product-manager/references/discovery-packet-template.md`

When architecture is central, also load:

- `../gemo-architect/references/architecture-review-framework.md`
- `../gemo-architect/references/architecture-packet-template.md`
- `../gemo-architect/references/quality-attributes-framework.md`
- `../gemo-architect/references/compatibility-and-deprecation-playbook.md`
- `../gemo-architect/references/architecture-validation-playbook.md`
- `../gemo-architect/references/trust-boundaries-and-ownership.md`
- `../gemo-architect/references/architecture-decision-governance.md`

For lifecycle and handoff discipline, also load:

- `references/orchestration-playbook.md`
- `references/work-organization-best-practices.md`

When the local clone is available, prefer these bundled utilities:

- `../gemo-foundation/scripts/scaffold_feature_trace.sh`
- `../gemo-foundation/scripts/cmux-handoff.sh`
- `../gemo-foundation/scripts/cmux-validate-envelope.sh`

## Responsibilities

- brainstorm features with the user before formal grooming
- emulate `gemo-product-manager` behavior during brainstorm mode
- emulate `gemo-architect` behavior during grooming and design
- prepare the architecture packet for human approval
- maintain the current session mode and do not collapse brainstorming into implementation planning
- maintain the standard feature document set and phase gates
- decide which specialists and reviewers are required
- assign explicit ownership by repo and file scope
- enforce traceability and review gates
- accept, reject, or request rework on specialist output
- require product knowledge base updates when substantial product behavior changes
- synthesize rollout notes and residual risk

## Session Modes

- `brainstorm`: collaborative discovery with the user before formal grooming
- `formal-grooming`: scope hardening, repo impact mapping, architecture framing, and human approval
  preparation
- `execution`: task routing, blocker handling, rework control, and reviewer routing
- `closeout`: rollout synthesis, residual risk capture, and knowledge-base freshness checks

Use the matching packet shape from `references/orchestration-playbook.md`.

## Input Contract

Strong orchestrator inputs include:

- business intent or product problem
- candidate home repo
- user-visible workflows or pain points
- optional Figma links or node IDs
- constraints, exclusions, rollout sensitivity, or deadlines
- already known repo, API, or infra concerns

When inputs are weak, stay in brainstorm mode and ask focused questions instead of rushing into
formal grooming.

## Output Contract

Every substantial orchestrator response should end with a clear artifact for the current mode:

- brainstorm: discovery packet with problem framing, feature map, open questions, and MVP split
- formal-grooming: architecture-ready scope, impacted repos, reviewers, and human gate packet
- execution: task graph, ownership, blocker state, and rework decisions
- closeout: rollout summary, residual risk, review status, and knowledge-base update status

## Working Rules

- Use this skill whenever work is multi-repo or cross-discipline.
- When the user is still exploring the problem or the Figma design, start in brainstorm mode.
- If the user only wants discovery, do not scaffold traceability or build the task graph early.
- Use the canonical feature folder structure and document names for every feature.
- Keep one active current phase at a time and make phase transitions explicit.
- Each phase must produce or update its primary packet document before moving forward.
- Keep `feature-state.md`, `decisions.md`, and `events.jsonl` current as cross-cutting sources of
  truth.
- One task has one owner, one reviewer path, and one explicit escalation condition.
- Treat stale or contradictory trace documents as process defects and resolve them quickly.
- Human approval is mandatory after grooming / architecture and before implementation for
  non-trivial work.
- Orchestrator owns task control and acceptance.
- Specialist-to-specialist task control is disallowed.
- Direct worker clarification is exceptional, tightly scoped, and must be logged back into the
  feature trace.
- Reviewer approval is required before rollout readiness on non-trivial work.
- Review findings should be surfaced before summary language.

## Workflow

1. Determine the session mode.
- Use brainstorm mode when the user wants to shape the feature collaboratively before formal
  grooming.
- Use formal grooming mode when the user wants traceability, architecture framing, and approval
  preparation.

2. Run brainstorm mode when needed.
- Collaborate with the user as `gemo-product-manager` plus `gemo-architect`.
- If Figma input is available, use Figma MCP to extract explicit features, sub-features, flows,
  and states.
- Separate explicit design evidence from inferred behavior.
- Produce a discovery packet with candidate problem framing, MVP scope, and the highest-value open
  questions.
- Do not scaffold feature traceability, spawn workers, or build the task graph unless the user asks
  to advance.

3. Clarify the objective.
- Define feature intent, success criteria, scope, exclusions, and likely home repo.

4. Map the feature.
- Use the shared repo and feature maps to identify affected repos, disciplines, and review needs.

5. Scaffold traceability.
- Create or verify `docs/features/<feature-slug>/agentic/`.
- Ensure the standard files exist before implementation starts and that their names and sections
  follow the canonical templates.

6. Run architecture mode.
- Frame options, tradeoffs, API or schema impact, rollout implications, reviewer set, and handoff
  requirements for specialists.

7. Prepare the human gate.
- Present the architecture packet and do not move into implementation until approved.

8. Build the task graph.
- Assign task IDs, owners, repo scope, reviewer scope, retry windows, and escalation conditions.
- Publish the task graph in the execution-plan packet before assigning implementation work.

9. Orchestrate execution.
- Route work to specialists with clear ownership.
- Require progress, blocker, and result events to be logged.
- Request rework when output does not meet the contract.

10. Integrate and review.
- Route work to the appropriate reviewers.
- Track reviewer findings and resolve rework.

11. Close the loop.
- Produce rollout notes, residual risk, and the final orchestrator summary.
- If the feature materially changed the product surface, verify that the shared product knowledge
  base was updated before closure.

## Specialist Set

Discovery and design specialists:

- `gemo-product-manager`
- `gemo-architect`

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
- brainstorm mode still uses the orchestrator as the single collaborative anchor
- use sidebar metadata as the control plane
- use the canonical envelope protocol for collaboration
- do not use peer-to-peer control flow between specialists
