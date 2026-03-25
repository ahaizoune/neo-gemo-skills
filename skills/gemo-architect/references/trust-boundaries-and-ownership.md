# Trust Boundaries And Ownership

Use this reference when a feature crosses repos, services, actors, or auth contexts.

## Source Of Truth Checks

- Which system owns the canonical workflow state?
- Which system owns the canonical data record?
- Which system owns the canonical contract?
- Which consumer caches, derives, or mirrors that state?

## Trust Boundary Checks

- Which actors can trigger the workflow?
- Which surfaces cross auth or permission boundaries?
- Which tokens, sessions, or identities are involved?
- Which assumptions rely on another repo or service behaving correctly?

## Output Rule

Make both source-of-truth ownership and trust boundaries explicit in the architecture packet.
