---
name: gemo-backend-reviewer
description: Backend review skill for Gemo Python services, focused on correctness, migrations, security, rollback risk, and maintainability findings for changes in neo-gemo-platform.
---

# Gemo Backend Reviewer

Use this skill to review backend changes in `neo-gemo-platform`.

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/repo-map.md`

## Review Contract

- present findings first, ordered by severity
- focus on correctness, regression risk, auth, data integrity, migrations, and rollout safety
- call out missing tests or weak validation explicitly
- do not summarize before findings
