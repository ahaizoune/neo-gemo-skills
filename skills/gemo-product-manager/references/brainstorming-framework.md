# Product Brainstorming Framework

Use this reference when the user is exploring a feature before formal grooming.

## Session Goals

- clarify the problem worth solving
- make the current pain or opportunity explicit
- identify the primary user or actor set
- compare current workflow to desired workflow
- derive candidate features and sub-features
- identify key flows, states, and dependencies
- split MVP versus later-phase scope
- surface unanswered questions before architecture hardens

## Valid Inputs

- a feature idea or business objective
- pain points in an existing workflow
- an existing product surface
- a Figma design or specific Figma nodes

## Figma-First Workflow

1. Identify the relevant page, frame, or node.
2. Extract visible screens, actions, states, and transitions.
3. Group them into candidate features and sub-features.
4. Separate explicit design evidence from inferred behavior.
5. Call out missing states, permissions, edge cases, and integration assumptions.
6. Translate the design into product capabilities and user outcomes, not only UI elements.

## High-Value Questions

- Who is the primary actor and what job are they trying to complete?
- What is broken, slow, confusing, or missing in the current workflow?
- What decisions or actions must the product enable?
- What happens before, during, and after the core flow?
- What states are required for success, failure, empty, loading, reschedule, cancel, and retry?
- What parts of the experience are critical for MVP versus safely deferrable?
- What backend, scheduling, notification, or data dependencies are implied?

## Output Checklist

- problem statement
- current workflow versus desired workflow
- actor map
- feature map
- sub-feature map
- key flows and states
- explicit versus inferred behavior
- dependencies and hidden implications
- MVP recommendation
- unresolved questions for formal grooming
