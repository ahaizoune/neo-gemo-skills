# Skill Authoring Quality Bar

Use this reference when creating or upgrading a Gemo skill.

The goal is not a passable skill. The goal is a skill that produces world-class output for the
actual GemForge lane it owns.

## Mandatory Quality Properties

- precise trigger description in frontmatter
- explicit repo and lane ownership
- concrete stack grounding from real repo evidence
- role language benchmarked against trusted external sources
- working rules that prevent generic or unsafe execution
- validation and handoff expectations that prove risky behavior at the real boundary
- `agents/openai.yaml` aligned to Gemo metadata conventions
- only the minimum bundled resources that materially improve repeatability or reliability

## Generated Skill Checklist

Every generated or upgraded skill should answer these questions clearly:

- What user request or execution context should trigger this skill?
- Which repo or repo set does it own?
- Which stack, runtime, or platform assumptions define expert behavior here?
- What output artifact or end-state does the skill own?
- What are the role-specific quality bars and anti-patterns?
- How should the skill validate risky changes before handoff?
- Which shared Gemo references should it load first?

## Artifact Expectations

Required:

- `SKILL.md`
- `agents/openai.yaml`

Optional, only when they materially improve the role:

- `references/`
- `scripts/`
- `assets/`

When the skill changes suite taxonomy or shared doctrine, also update:

- `gemo-foundation` references
- `README.md`
- `docs/skill-suite-design.md`
- role matrix or repo map entries when ownership changed

## Anti-Patterns

Do not ship a skill that:

- repeats generic engineering advice with no GemForge specificity
- names a lane but never defines its owned repo surfaces
- lists tools without describing the quality bar for using them
- hides the trigger in the body instead of frontmatter
- copies benchmark role prose without adapting it to Gemo
- introduces resource folders that are not used
- relies on unstated repo assumptions instead of scanning the actual codebase

## Finalization Flow

1. gather first-party repo evidence
2. benchmark the role externally
3. draft or update the skill artifacts
4. show the user the draft `SKILL.md` and concise file summary
5. apply the review edits
6. validate automatically
7. install or sync automatically when the user approved the draft
