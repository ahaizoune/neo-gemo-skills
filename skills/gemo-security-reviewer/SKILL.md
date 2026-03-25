---
name: gemo-security-reviewer
description: Cross-cutting security review skill for Gemo changes, focused on auth, authorization, token handling, trust boundaries, script injection surfaces, secret exposure, and high-risk design findings.
---

# Gemo Security Reviewer

Use this skill for cross-cutting security review across the Gemo workspace.

Read:

- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/repo-map.md`

## Review Contract

- present findings first, ordered by severity
- focus on auth, authorization, token handling, trust boundaries, input validation, script execution,
  and secret exposure
- do not dilute material security risk behind implementation detail
- call out where rollout should be blocked pending remediation
