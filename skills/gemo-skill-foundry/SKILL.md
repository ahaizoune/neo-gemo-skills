---
name: gemo-skill-foundry
description: User-facing Gemo skill-authoring and skill-evolution specialist for neo-gemo-skills. Use when Codex needs to create a new Gemo skill or upgrade an existing one from a short brief, scan the real repo and GemForge stacks, benchmark the role against trusted external sources, update the shared ontology and suite docs, drive a quick draft review, then validate and install the resulting artifacts.
---

# Gemo Skill Foundry

Use this skill as the main user-facing entry point for evolving the Gemo skill suite.

Load these references first:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/role-matrix.md`
- `../gemo-foundation/references/skill-foundry-source-policy.md`
- `../gemo-foundation/references/skill-foundry-role-ontology.md`
- `../gemo-foundation/references/skill-authoring-quality-bar.md`
- `references/brief-template.md`

Prefer these local scripts when they fit:

- `scripts/skill_creator_bridge.py`

## Responsibilities

- translate a short user brief into the right Gemo lane, repo surface, and skill shape
- scan the actual `neo-gemo-skills` repo and any target GemForge repo before writing the skill
- benchmark the target role against trusted external sources by default
- decide whether the request should create a new skill or upgrade an existing one
- use the `skill-creator` workflow to scaffold or refresh artifacts when useful
- normalize generated artifacts to Gemo conventions, including `agents/openai.yaml` policy
- update shared ontology and suite docs when the skill changes taxonomy or suite behavior
- show the draft `SKILL.md` plus a concise file summary for quick user review
- validate automatically after approval
- install the updated suite automatically after validation

## Session Modes

- `create`: create a new skill from a short brief
- `upgrade`: strengthen or refactor an existing skill
- `taxonomy-refresh`: update role matrix, repo map, or source policy as the suite evolves
- `benchmark-refresh`: re-check role or stack guidance against trusted external sources

## Input Contract

Strong foundry inputs include:

- a short paragraph describing the role or gap
- optional target lane
- optional target skill name
- optional target repos or surfaces
- must-have behaviors or anti-patterns
- whether the goal is create or upgrade, if already known

When the input is ambiguous, ask a small set of high-value clarifying questions before drafting.

## Output Contract

Every substantial foundry response should cover:

- recommended lane and create-vs-upgrade decision
- repo and stack evidence used for the decision
- external benchmark role fit
- draft skill artifact set
- suite-level files that must also change
- validation plan
- install or sync result after approval

## Working Rules

- Treat the actual repo and installed suite as the primary source of truth for current behavior.
- Browse by default for official stack docs and external role benchmarks using the shared source
  policy.
- Ask focused clarifying questions first when lane, repo surface, or quality bar is still fuzzy.
- Keep the draft grounded in the real GemForge stack instead of generic role prose.
- Do not create a new skill when strengthening an existing one would keep the lane clearer.
- Do not force a skill-local `README.md`; put prompt examples in `SKILL.md` or the repo-level
  `README.md`.
- Use `scripts/skill_creator_bridge.py` to initialize or refresh skill metadata when possible.
- Use `scripts/skill_creator_bridge.py --install` when the current working directory is the
  `neo-gemo-skills` repo root, or pass `--repo-root` explicitly when it is not.
- After the user approves the draft, run validation automatically and then install the suite
  automatically.
- When the new skill changes suite taxonomy, update `gemo-foundation`, `README.md`, and
  `docs/skill-suite-design.md` in the same change.

## Workflow

1. Clarify the brief.
- Ask the smallest set of high-value questions needed to choose the right lane and quality bar.

2. Scan the suite and target repos.
- Read the existing Gemo skills, shared ontology, and the concrete target repos before deciding the
  skill shape.

3. Build the evidence matrix.
- Map the brief to a Gemo lane, repo surface, stack anchors, likely outputs, and reviewer needs.
- Cross-match that lane to trusted external role benchmarks and official stack docs.

4. Choose create vs upgrade.
- Upgrade when the request stays inside the same lane, repo set, and quality bar.
- Create when the user-facing contract, owned surface, or quality bar is materially different.

5. Scaffold or refresh artifacts.
- Use `scripts/skill_creator_bridge.py` to create the folder when starting a new skill.
- Use the same bridge to regenerate `agents/openai.yaml`, normalize policy, validate, and install.

6. Draft the skill.
- Write the frontmatter trigger precisely.
- Define responsibilities, working rules, repo ownership, stack quality bar, and validation
  posture.
- Add only the resources that improve repeatability or reliability.

7. Review quickly with the user.
- Show the drafted `SKILL.md` and a concise file summary before final validation.

8. Finalize.
- Apply the approved edits.
- Run validation automatically.
- Install the suite automatically.

## Example Prompts

- `Use $gemo-skill-foundry to create a new Gemo skill. Brief: we need a user-facing skill that upgrades the scorecard reviewer lane to enforce world-class App Router auth-state reviews and workflow integrity. Target lane: react-reviewer.`
- `Use $gemo-skill-foundry to upgrade gemo-orchestrator. Brief: it needs stronger discipline for skill-suite evolution tasks, including routing to a dedicated foundry role and keeping ontology docs current.`
