# Architecture Validation Playbook

Use this reference when the design carries meaningful uncertainty or operational risk.

## Validation Options

- sequence walkthrough
- interface or contract test
- migration rehearsal
- architecture spike
- staged rollout
- feature-flagged dark launch
- telemetry-first release gate

## Questions

- What assumption is risky enough to validate early?
- What is the cheapest reliable way to validate it?
- What evidence would change the design choice?
- What must be proven before broad rollout?

## Output Rule

For risky architecture choices, specify:

- assumption at risk
- validation method
- owner
- success / failure signal
