---
name: gemo-react-reviewer
description: React and Next.js review skill for Gemo frontend repos, focused on correctness, UX state integrity, auth flow safety, accessibility, and maintainability findings.
---

# Gemo React Reviewer

Use this skill to review frontend changes in:

- `neo-gemo-talent-platform`
- `neo-gemo-scorecard`
- `gemforge-embed`

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/repo-map.md`

## Review Contract

- present findings first, ordered by severity
- focus on server/client boundaries, auth, loading/error states, accessibility, and regression risk
- call out missing tests or weak manual verification explicitly
