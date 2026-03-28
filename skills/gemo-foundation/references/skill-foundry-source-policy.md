# Skill Foundry Source Policy

Use this policy when `gemo-skill-foundry` creates or upgrades a Gemo skill.

Browse by default for external role benchmarks and official stack references, but keep source
priority strict.

## Source Order

1. First-party Gemo truth

- `neo-gemo-skills` is the canonical source for the current suite shape, role taxonomy, and shared
  doctrine.
- Existing Gemo skills, `agents/openai.yaml`, shared references, and suite docs are the first
  source of truth for how the suite currently behaves.
- The target repo's real code, manifests, tests, CI config, infra definitions, and docs are the
  first source of truth for the concrete stack and operating constraints.
- When external benchmark language conflicts with first-party repo reality, repo reality wins.

2. Official stack documentation

- Use official docs for frameworks, libraries, platforms, and services that the target repo
  actually uses or that the skill suite already treats as canonical.
- Backend examples: Python, FastAPI, Starlette, SlowAPI, SQLAlchemy, Alembic, Pydantic,
  PostgreSQL, Redis, RQ, httpx, pytest, and auth or token libraries when present.
- Frontend examples: React, Next.js, TypeScript, MDN, and W3C or WAI guidance.
- Extension examples: Chrome Extensions docs first, MDN WebExtensions docs second.
- Devops examples: Pulumi, AWS, AWS Well-Architected guidance, Cloudflare, and DORA guidance when
  relevant.
- Retool examples: Retool docs for host behavior, custom-component shape, and embedded runtime
  expectations.
- Security examples: OWASP Cheat Sheet Series, OWASP ASVS, and relevant RFCs for auth, session,
  token, or integration protocols.

3. External role benchmark frameworks

- Use O*NET OnLine and SFIA to benchmark role scope, vocabulary, and capability expectations.
- Use benchmark frameworks to improve role quality, not to replace the Gemo lane model.
- Keep benchmark material summarized and transformed for Gemo. Do not let generic benchmark prose
  override repo-specific responsibilities or workflow ownership.

4. Secondary calibration sources

- Use maintainer-authored deep dives, official project blog posts, and high-signal public role
  ladders only when they add clear value after the higher-priority sources are exhausted.
- Treat these as calibration aids for tone, examples, or maturity language. They are not the
  source of truth.

## Conflict Resolution

- first-party repo and suite truth
- official stack documentation
- external benchmark frameworks
- secondary calibration sources

Resolve contradictions in that order and make the chosen authority explicit when a decision matters
for the resulting skill design.

## Default Exclusions

Do not treat these as trusted sources by default:

- generic blog posts with no primary evidence
- random Reddit or forum advice
- generic AI-generated role descriptions
- copy-pasted prompt libraries
- vague "10x engineer" role templates
- job posts that do not match the actual GemForge stack or lane

## Licensing Notes

- Treat O*NET as reusable with attribution when the implementation flow stores benchmark-derived
  material.
- Treat SFIA as reference-only unless licensing is cleared. Do not vendor large verbatim excerpts
  into the repo by default.
