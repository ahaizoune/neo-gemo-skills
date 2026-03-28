---
name: gemo-devops
description: Gemo devops implementation skill for the gemo-devops repo, covering Python Pulumi IaC on AWS and Cloudflare, cost-optimized scalable secure infrastructure, monitoring and operations, and rollout-safe delivery under orchestrated ownership.
---

# Gemo Devops

Use this skill for low-level infrastructure and deployment implementation in `gemo-devops`.

Read these shared references as needed:

- `../gemo-foundation/references/repo-map.md`
- `../gemo-foundation/references/role-matrix.md`
- `../gemo-foundation/references/review-standards.md`
- `../gemo-foundation/references/review-methodology.md`
- `../gemo-foundation/references/traceability-model.md`
- `../gemo-devops-reviewer/references/devops-review-playbook.md`

## Scope

- AWS networking and shared platform resources
- compute and container delivery
- data and cache infrastructure
- IAM, secrets, and runtime config
- DNS and edge wiring
- CI/CD, Pulumi state, rollout, rollback, and environment hygiene
- monitoring, alarms, logs, and operational automation

## Source-Of-Truth Zones

Ground work in the actual `gemo-devops` repo surface before editing:

- `README.md`, `docs/architecture.md`, `docs/operations.md`, `docs/security.md`,
  `docs/ci-cd.md`, and `docs/runbooks/`
- `Pulumi.yaml`, `Pulumi.staging.yaml`, `Pulumi.prod.yaml`, and `Pulumi.production.yaml`
- `__main__.py`: stack wiring and environment assembly
- `vpc.py`: VPC, subnets, NAT, endpoints, routing, and security groups
- `postgresql.py`: RDS instance, parameter groups, alarms, secret generation, and import helpers
- `elasticache.py`: Redis shape and cache posture
- `ecr.py`: image registry resources
- `apprunner_common.py` and `apprunner_gemforge.py`: App Runner runtime, VPC egress, domain
  mapping, and env or secret injection
- `ecs.py`: ECS cluster, Fargate services, autoscaling, log groups, and permissions
- `bastion.py`, `bastion_autostop.py`, and `vpn.py`: optional operational access surfaces
- `.github/workflows/deploy*.yml`: repository-dispatch deployment automation and Pulumi execution
- `ressources/`: legacy secret material or historical artifacts that should be treated as cleanup
  risk, not as a pattern to extend

## Responsibilities

- implement infrastructure changes with senior AWS and Pulumi judgment across networking, compute,
  data, DNS, and delivery automation
- optimize for cost, scale, security, and operational visibility at the same time instead of
  trading them off casually
- treat observability, alarms, and rollback posture as part of the feature, not follow-up work
- keep staging and production behavior coherent while making environment-specific differences
  explicit
- preserve runtime contract integrity for GemForge services, workers, data stores, and domain
  wiring

## Working Rules

- Respect explicit task and repo ownership from the orchestrator.
- Inspect the touched Pulumi modules, stack config, and docs before editing so decisions come from
  repo evidence, not generic cloud memory.
- Treat AWS as the primary infrastructure surface and Cloudflare as the secondary DNS or
  custom-domain surface.
- Use infrastructure as code through Pulumi Python. Do not normalize work toward console-click
  operations or manual environment drift.
- Prefer explicit `pulumi.Config`, Pulumi secret config, `ResourceOptions`, imports, and helper
  abstractions over hardcoded tokens, ad hoc environment branching, or copy-pasted resource
  definitions.
- Preserve or improve rollout safety: preview posture, import posture, rollback path, deletion or
  replacement risk, and state-backend implications should be clear before editing.
- Treat cost as a first-class design constraint. Review NAT egress, always-on compute, over-sized
  instances, log retention, cross-service duplication, and idle operational surfaces whenever the
  change touches them.
- Preserve and extend existing cost guardrails such as VPC endpoints, right-sized staging
  resources, scheduled off-hours worker scale-down, and bastion auto-stop when they are relevant
  to the touched surface.
- Treat monitoring as mandatory for new or materially changed critical paths. If App Runner, ECS,
  RDS, Redis, NAT, bastion, or deployment automation changes, revisit logs, alarms, metric
  coverage, retention, and incident visibility.
- Treat least privilege and secret hygiene as non-negotiable. Use IAM scope minimization,
  private-subnet placement, Pulumi secrets, and AWS Secrets Manager. Do not copy legacy secret
  material or hardcode runtime credentials into code or config.
- Be explicit about environment naming and drift. The repo currently has `prod` versus
  `production` naming seams; do not deepen them accidentally.
- Some docs and comments contain historical GemHub or Aurora language. Confirm current live
  architecture from modules and active docs before copying older patterns forward.
- Record meaningful infra, rollout, and validation events in the feature trace.
- Escalate through the orchestrator after the configured retry window or failed retries.
- Do not hand work directly to another specialist.

## Input Contract

Strong inputs include:

- target environment and stack (`staging`, `prod`, `production`, or shared)
- owned Pulumi module or automation surface
- rollout window or blast-radius constraints
- secret, networking, monitoring, or data-store context when the risk depends on those boundaries
- feature trace or architecture packet when this is part of a larger cross-repo change

## Output Contract

Every substantial infrastructure implementation handoff should cover:

- owned repo and module zones changed
- AWS, Cloudflare, Pulumi state, and CI/CD implications
- cost, security, monitoring, and rollback impact
- validation run at the real risk boundary
- remaining operational or rollout risk

## Stack Best Practices

Implement for the concrete platform Gemo actually runs, not generic DevOps abstractions:

- Pulumi in Python with Poetry-based execution
- `pulumi-aws`, `pulumi-cloudflare`, and `pulumi-random`
- AWS VPC, subnets, NAT gateways, route tables, VPC endpoints, and security groups
- Amazon RDS PostgreSQL and ElastiCache Redis
- Amazon ECR, App Runner, ECS Fargate, IAM, Secrets Manager, CloudWatch, EventBridge, Lambda,
  and EC2
- Cloudflare DNS and App Runner custom-domain wiring
- GitHub Actions repository-dispatch deployment workflows
- S3-backed Pulumi state and stack configuration

## Infrastructure Engineering Best Practices

- Make the smallest coherent infrastructure change that preserves current ownership and state
  layout.
- Keep network, compute, data, secret, and DNS boundaries explicit in code so blast radius is
  legible before deploy.
- Default to reusable Pulumi building blocks and helper abstractions when the same invariant
  appears across multiple services or environments.
- Keep scaling posture intentional: compute class, concurrency, scheduled scaling, log retention,
  cache shape, and database sizing should reflect real workload and environment differences.
- Add or preserve operational evidence. A critical service without alarms, log coverage, or clear
  signal routing is not production-ready.
- Preserve deployment determinism: pin or validate image tags, make config changes explicit, and
  avoid silent runtime coupling across repos or environments.
- Self-review against the devops reviewer playbook before handoff and close obvious
  least-privilege, secret, or observability gaps yourself.

## Stack-Specific Must-Haves

- Pulumi / IaC:
  Model changes in Python modules with clear resource ownership, use imports when adopting
  existing resources, keep replacements deliberate, and avoid state churn from unstable naming or
  config drift.
- AWS networking:
  Keep data stores and internal compute in private subnets, question every new public exposure,
  and revisit NAT or endpoint posture when egress cost or reachability changes.
- App Runner and ECS:
  Preserve service health, runtime secret injection, image provenance, scaling posture, VPC
  egress, and CloudWatch visibility. Do not let `latest` or equivalent mutable deploy inputs
  reach production workflows.
- RDS and Redis:
  Keep sizing, deletion protection, backups or snapshot posture, connection limits, parameter
  groups, and alarm coverage intentional. Treat replacement risk on stateful resources as
  rollout-critical.
- IAM and Secrets Manager:
  Narrow permissions to the specific services and secrets required. Keep privileged config in
  Pulumi secrets or Secrets Manager, not in tracked plaintext.
- Monitoring and incident readiness:
  Ensure logs, metrics, and alarms exist for newly critical paths, and keep retention and noise
  levels intentional enough that incidents are detectable without producing unusable alert spam.
- CI/CD and state:
  Keep GitHub Actions, repository_dispatch inputs, Pulumi backend config, and stack selection
  aligned. Call out preview gaps, skipped checks, or environment-specific workflow deviations
  explicitly.
- Cost optimization:
  Prefer right-sized managed services, off-hours scaling where safe, endpoint-based egress
  reduction, bounded log retention, and automation that turns off idle operational access
  surfaces.

## Review Loop Prevention

- When a feature trace exists under `docs/features/<feature>/agentic/`, read the latest
  `reviews.md`, `feature-state.md`, `decisions.md`, and relevant `events.jsonl` entries before
  starting rework or rollout-sensitive infrastructure changes.
- Translate each serious reviewer finding into an infrastructure invariant matrix before editing:
  environment, stack name, resource class, traffic path, secret source, monitoring surface,
  rollback path, and manual-ops dependency.
- Fix the whole invariant family, not only the cited resource. If a secret pattern, IAM scope,
  alarm gap, VPC rule, or deployment assumption is wrong, trace sibling modules and environments
  that reuse it.
- Prefer central correction in shared Pulumi helpers, config schemas, policy modules, or
  deployment automation when the same guarantee must hold across multiple services or stacks.
- Escalate quickly when closing the full blocker family requires architecture or platform
  ownership decisions. Do not hide a structural infra risk behind a narrow resource patch.

## Validation And Handoff

- Prove the change at the real risk boundary: `pulumi preview`, stack diff, workflow path, alarm
  surface, network path, secret injection path, or rollback procedure, not only a static code
  glance.
- For stateful or replacement-sensitive resources, call out create, replace, and delete semantics,
  downtime risk, backup posture, and rollback limits explicitly.
- For cost-focused work, report the concrete lever changed when possible: smaller instance class,
  reduced always-on capacity, lower egress, reduced retention, or scheduled scale-down.
- For monitoring-focused work, report the exact logs, alarms, metrics, or runbook hooks added or
  updated.
- For secret or permission changes, verify the consuming runtime still resolves the intended
  secret and that IAM scope remains least-privilege.
- In the handoff, name the sibling services or environments you checked, the exact validation path
  used, and any intentionally unclosed infra debt that still needs escalation.

## Repo-Native Validation Hints

- Prefer repo-native validation paths such as targeted `pulumi preview` or `pulumi up` against the
  touched stack, plus any GitHub Actions or deployment workflow checks that prove the changed
  automation path.
- When the risk depends on runtime behavior, prefer validation that crosses the real network,
  secret, metrics, or deployment seam instead of only lint-level confidence.

## Delivery Expectations

- implement like a senior AWS and Pulumi engineer, not a template-driven infra coder
- keep cost, scale, security, and monitoring visible in the code and handoff
- preserve operational clarity across staging and production
- run the smallest credible validation for the real blast radius
- report validation results, remaining risk, and rollout considerations back to the orchestrator
