---
name: gemo-extension-reviewer
description: Browser extension review skill for Gemo sourcing-extension changes, focused on runtime safety, message boundaries, permission scope, correctness, and maintainability findings.
---

# Gemo Extension Reviewer

Use this skill to review changes in `gemo-sourcing-extension`.

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/repo-map.md`

## Review Contract

- present findings first, ordered by severity
- focus on message safety, permission scope, runtime behavior, parser resilience, and API error handling
- call out security implications explicitly
