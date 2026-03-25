# neo-gemo-skills

Canonical source of truth for Gemo agentic skills, orchestration contracts, traceability templates,
and Gemo-specific cmux collaboration guidance.

## Purpose

This repository defines a skill suite for feature delivery across the Gemo workspace:

- `gemo-orchestrator` as the main entry point
- `gemo-architect` for architecture framing and design review
- discipline specialists for backend, React, extension, devops, and Retool work
- reviewer skills for design, security, and implementation quality

The repository is also the canonical home for:

- feature-delivery lifecycle guidance
- agent traceability patterns
- Gemo-specific cmux topology and collaboration rules
- install/sync scripts for `~/.codex/skills`

## Source Of Truth Strategy

This repository is the canonical source for the Gemo skill suite and Gemo-specific cmux operating
model.

Installed copies under `~/.codex/skills` are artifacts.

If generic cmux materials in other locations need to stay aligned, they should be synced from this
repository instead of being maintained as separate authorities.

## Skill Suite

- `gemo-foundation`
- `gemo-orchestrator`
- `gemo-architect`
- `gemo-backend`
- `gemo-react`
- `gemo-extension`
- `gemo-devops`
- `gemo-retool`
- `gemo-backend-reviewer`
- `gemo-react-reviewer`
- `gemo-extension-reviewer`
- `gemo-devops-reviewer`
- `gemo-retool-reviewer`
- `gemo-security-reviewer`

## Repository Layout

```text
neo-gemo-skills/
├── README.md
├── scripts/
│   ├── install_skills.sh
│   ├── sync_skills.sh
│   └── scaffold_feature_trace.sh
├── templates/
│   └── feature-trace/
│       ├── feature-state.md
│       ├── decisions.md
│       ├── reviews.md
│       └── rollout.md
└── skills/
    ├── gemo-foundation/
    ├── gemo-orchestrator/
    ├── gemo-architect/
    ├── gemo-backend/
    ├── gemo-react/
    ├── gemo-extension/
    ├── gemo-devops/
    ├── gemo-retool/
    ├── gemo-backend-reviewer/
    ├── gemo-react-reviewer/
    ├── gemo-extension-reviewer/
    ├── gemo-devops-reviewer/
    ├── gemo-retool-reviewer/
    └── gemo-security-reviewer/
```

## Install

Install all skills into `~/.codex/skills`:

```bash
cd neo-gemo-skills
./scripts/install_skills.sh
```

Install into a custom Codex home:

```bash
./scripts/install_skills.sh --codex-home /path/to/codex-home
```

Force-sync installed skills and keep backups of replaced copies:

```bash
./scripts/sync_skills.sh
```

## Feature Trace Scaffolding

Create feature trace artifacts inside a target repo:

```bash
./scripts/scaffold_feature_trace.sh \
  --repo ../neo-gemo-scorecard \
  --feature interviewer-portal \
  --title "Interviewer Portal Migration"
```

This creates:

```text
docs/features/<feature-slug>/agentic/
├── feature-state.md
├── decisions.md
├── events.jsonl
├── reviews.md
└── rollout.md
```

## Operating Model

- The orchestrator owns task control, acceptance, and promotion to rollout.
- Peer-to-peer communication is disallowed by default.
- Exception: narrowly scoped clarification may happen directly, but it must be linked to a feature
  and task ID and summarized back into the feature trace.
- Claude is the default low-level coding worker layer.
- Codex owns orchestration, architecture synthesis, review authority, and final acceptance.

## Next Validation Steps

1. Install the skills locally with `./scripts/install_skills.sh`.
2. Run the orchestrator on one worked example.
3. Validate feature trace scaffolding inside one repo.
4. Validate the cmux workflow with one Codex orchestrator surface and one Claude worker surface.
