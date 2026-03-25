---
name: gemo-devops
description: Gemo devops implementation skill for the gemo-devops repo, covering Pulumi, AWS, Cloudflare, secrets, deployment shape, rollout safety, environment drift, and infrastructure changes under orchestrated ownership.
---

# Gemo Devops

Use this skill for low-level infrastructure and deployment work in `gemo-devops`.

Read these shared references as needed:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/traceability-model.md`

## Working Rules

- treat rollout and rollback as part of the implementation, not an afterthought
- call out secret, permissions, and environment drift implications explicitly
- do not make broad infra changes without clearly recorded intent
- keep rollout notes and verification notes current in the feature trace
- escalate blockers back through the orchestrator
