# Retool Review Playbook

Use this playbook as a Retool-host-aware reviewer, not a generic React reviewer.

Focus on:

- renderer correctness
- backend contract alignment
- resilience to malformed or partial data
- maintainability of custom component behavior
- operational usability inside Retool-hosted flows
- model and event contract clarity
- deterministic host/component state behavior

## Retool Stack In Scope

- `@tryretool/custom-component-support`
- Retool custom component manifest generation and deployment flow
- React 18 inside Retool-hosted surfaces
- Ant Design, Tailwind, Sass, and local design-system helpers used in Gemo Retool repos
- dynamic renderer patterns
- drag-and-drop interactions where present
- generated or typed data contracts where present

## Perfect Retool Component Must-Haves

- model names are explicit, stable, and documented
- event names are explicit, stable, and tied to clear operator-facing semantics
- component behavior is deterministic from Retool state and events
- malformed, missing, or partial inputs degrade gracefully instead of crashing or corrupting output
- local component state does not silently drift from Retool state without a deliberate contract
- hidden or internal state is used sparingly and intentionally
- layout remains usable inside realistic Retool containers without overflow or clipping surprises
- component APIs are understandable enough for Retool builders to wire correctly

## Model Contract Must-Haves

- every required Retool state or model field is named clearly and used consistently
- model parsing guards against invalid shapes and unexpected nullability
- assumptions about host data shape are either validated or safely defaulted
- component behavior does not depend on undocumented host-side preprocessing

## Event Contract Must-Haves

- emitted events have clear semantics and are not duplicated accidentally
- events fire at the correct time and with predictable sequencing
- event-triggering side effects do not depend on fragile timers or host quirks without justification
- operator-facing actions such as submit, edit, select, drag-end, or open are unambiguous

## Manifest / Build / Deploy Must-Haves

- generated manifest matches the actual component contract
- any manual manifest-fix step is necessary, correct, and kept in sync with the code
- state and event declarations remain compatible with Retool expectations
- build or deploy changes do not silently break component discoverability or configuration

## Embedded UX / Styling Must-Haves

- the component remains usable in constrained Retool layouts
- loading, empty, partial, and error states are clear for operators
- styling choices do not break host readability or interaction behavior
- keyboard and pointer interactions remain coherent for embedded workflows

## Data Integrity And Runtime Safety Must-Haves

- renderer output stays aligned with backend contract evolution
- derived display state does not hide data loss, mismatches, or stale data
- expensive transforms are controlled enough for realistic payload sizes
- drag-and-drop or selection interactions do not corrupt the visible or emitted state

## Test And Verification Must-Haves

- verification covers host-runtime behavior that matters, not just isolated pure rendering
- tests or manual evidence cover malformed data and key operator interactions
- reviewer distinguishes proven behavior from assumed behavior

Look hard at:

- assumptions about data shape without guards
- fragile renderer behavior tied to undocumented contract details
- event wiring that can fire too often, too late, or with ambiguous semantics
- manifest drift between code, config, and deployed component behavior
- local state that diverges from Retool-controlled state
- hidden state that obscures the true contract
- embedded layout or overflow issues that would hurt Retool operators
- weak verification for embedded interaction paths
