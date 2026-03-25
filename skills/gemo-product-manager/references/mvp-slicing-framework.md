# MVP Slicing Framework

Use this reference when deciding what belongs in MVP versus later phases.

## MVP Principles

- ship one coherent workflow, not a scattered collection of partial features
- include the states required to make the workflow trustworthy
- defer breadth before you defer core workflow integrity
- prefer slices that prove product value and surface real usage quickly

## Slicing Questions

- What is the smallest workflow that creates real user value?
- Which states are mandatory for that workflow to be credible?
- Which adjacent capabilities can safely wait?
- Which dependencies make the first release too risky or too broad?
- What can be phased later without invalidating the user promise?

## Typical Cuts

- keep core create/view/act flows together
- defer advanced filtering, analytics, or admin controls when they are not core to the first user
  promise
- defer low-frequency edge-case automation if manual handling is acceptable temporarily

## Output Rule

Every MVP recommendation should include:

- what is in MVP
- what is out of MVP
- why the cut preserves a coherent product promise
