# Figma Analysis Checklist

Use this reference when a product session is driven by Figma input.

## Extraction Steps

1. Identify the relevant pages, frames, or nodes.
2. List visible screens, actions, states, and transitions.
3. Group screens into candidate flows.
4. Group flows into candidate features and sub-features.
5. Mark what is explicit in the design.
6. Mark what must be inferred to make the workflow complete.

## Checks

- Which primary actor is implied by the screen?
- What action can the user take on this screen?
- What state is this screen representing?
- What happens immediately before and after this state?
- Are empty, error, loading, cancel, retry, or reschedule states shown?
- Are permissions or actor differences implied but not shown?
- What backend, scheduling, messaging, or status transitions are hidden behind the UI?

## Output Rule

After Figma analysis, convert the design into:

- product capabilities
- user flows
- required states
- open product questions
- hidden dependencies

Do not stop at a screen inventory.
