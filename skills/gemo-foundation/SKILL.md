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
- Traceability model: [references/traceability-model.md](references/traceability-model.md)
- cmux topology and protocol: [references/cmux-topology-and-protocol.md](references/cmux-topology-and-protocol.md)
- Role matrix: [references/role-matrix.md](references/role-matrix.md)
- Review standards: [references/review-standards.md](references/review-standards.md)

## Working Rules

- Treat `gemo-orchestrator` as the main user-facing entry point for feature delivery.
- Treat `gemo-architect` as the architecture-first sibling that the orchestrator can emulate or
  explicitly invoke.
- Use Codex as orchestrator, architecture synthesizer, and acceptance authority.
- Use Claude primarily for low-level implementation workers.
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
- `scripts/cmux-validate-envelope.sh`
