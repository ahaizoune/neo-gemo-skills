---
name: gemo-foundation
description: Shared Gemo architecture, feature map, delivery lifecycle, traceability model, and cmux collaboration references for the Gemo skill suite. Use when a Gemo skill needs common repo knowledge, feature knowledge, review standards, traceability rules, or the canonical Gemo cmux operating model.
---

# Gemo Foundation

This skill is the shared doctrine for the Gemo skill suite.

Load only the references you need:

- Repo map: [references/repo-map.md](references/repo-map.md)
- Product feature map: [references/product-feature-map.md](references/product-feature-map.md)
- Delivery lifecycle: [references/delivery-lifecycle.md](references/delivery-lifecycle.md)
- Skill source policy: [references/skill-foundry-source-policy.md](references/skill-foundry-source-policy.md)
- Skill role ontology: [references/skill-foundry-role-ontology.md](references/skill-foundry-role-ontology.md)
- Skill authoring quality bar: [references/skill-authoring-quality-bar.md](references/skill-authoring-quality-bar.md)
- Traceability model: [references/traceability-model.md](references/traceability-model.md)
- cmux topology and protocol: [references/cmux-topology-and-protocol.md](references/cmux-topology-and-protocol.md)
- Claude worker prompt schema: [references/claude-worker-prompt-schema.md](references/claude-worker-prompt-schema.md)
- Role matrix: [references/role-matrix.md](references/role-matrix.md)
- Review standards: [references/review-standards.md](references/review-standards.md)
- Review methodology: [references/review-methodology.md](references/review-methodology.md)

## Working Rules

- Treat `gemo-orchestrator` as the main user-facing entry point for feature delivery.
- Treat `gemo-architect` as the architecture-first sibling that the orchestrator can emulate or
  explicitly invoke.
- Use Codex as orchestrator, architecture synthesizer, and acceptance authority.
- Use Claude as the default low-level implementation worker runtime for delegated coding tasks
  unless the user explicitly overrides the worker model.
- Launch delegated Claude workers in YOLO mode by default via
  `--dangerously-skip-permissions` unless the user explicitly asks for a stricter permission model.
- Do not treat workspace creation, pane creation, surface creation, sidebar metadata, or
  `claude-hook` status updates as equivalent to launching a worker.
- A delegated implementation task is not `in_progress` until its assigned cmux surface has a live
  worker process and launch verification is recorded in the feature trace.
- Worker launch verification starts the supervision phase. The orchestrator must keep checking each
  delegated worker until the output is accepted, rejected, or blocked.
- Delegated workers must not finish or block silently. They must notify the orchestrator when they
  reach a meaningful checkpoint, become blocked, or reach result-ready state.
- Do not allow peer-to-peer task control between specialist workers.
- Persist feature trace artifacts in the feature's home repo under:
  `docs/features/<feature-slug>/agentic/`

## Feature Trace Minimum

Every non-trivial feature should maintain:

- `feature-state.md`
- `01-discovery.md`
- `02-grooming.md`
- `03-architecture.md`
- `04-execution-plan.md`
- `decisions.md`
- `events.jsonl`
- `reviews.md`
- `rollout.md`

When available, use the bundled scaffold script:

- `scripts/scaffold_feature_trace.sh`

Bundled cmux utilities:

- `scripts/cmux-handoff.sh`
- `scripts/cmux-check-claude-worker.sh`
- `scripts/cmux-launch-claude-worker.sh`
- `scripts/render-claude-worker-prompt.sh`
- `scripts/cmux-worker-report.sh`
- `scripts/cmux-validate-envelope.sh`
