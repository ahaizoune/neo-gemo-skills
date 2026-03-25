# Architecture Packet Template

Use this reference when `gemo-architect` needs to produce a durable handoff or approval artifact.

## Required Sections

1. Objective
2. Current state
3. Source-of-truth map
4. Target state
5. Impacted repos and domains
6. Boundaries, trust zones, and contracts affected
7. Architecture drivers and quality attributes
8. Options considered
9. Recommended option and why
10. Compatibility and deprecation strategy
11. API, schema, workflow, and state implications
12. Validation plan for risky assumptions
13. Failure modes and operational concerns
14. Rollout, migration, and rollback plan
15. Decision ledger updates
16. Specialist set
17. Reviewer set
18. Open questions and deferred decisions

## Architecture Checks

- Which existing contract is the source of truth?
- Which repo or service owns each critical state and contract?
- Where could contract drift emerge between repos?
- What state transitions become newly valid or invalid?
- Which consumers require backward compatibility or migration support?
- What migrations, flags, or staged rollout steps are needed?
- What trust boundaries or authorization assumptions matter?
- What observability or audit signals are needed to operate the change safely?
- What must be validated before broad implementation or rollout?
- What part of the design must remain stable for downstream teams or surfaces?

## Handoff Quality Bar

- specialists can tell which seams and contracts matter
- reviewers can see the risk concentration quickly
- unresolved decisions are visible and not buried
- decision ledger updates are obvious
