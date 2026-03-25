# Compatibility And Deprecation Playbook

Use this reference when a design changes contracts, states, or consumer expectations.

## Compatibility Questions

- Which existing consumers depend on the current contract or workflow?
- Can the change be backward compatible?
- If not, what transition window is required?
- Which consumers need staged migration or dual behavior?
- What deprecation signal or cutoff should be documented?

## Output Rule

Every meaningful contract change should state:

- affected consumers
- compatibility posture
- migration strategy
- deprecation plan, if needed
