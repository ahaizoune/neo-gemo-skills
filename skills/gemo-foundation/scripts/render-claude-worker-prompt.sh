#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  render-claude-worker-prompt.sh --feature-dir <path> --task-id <id> --worker-skill <skill-name>
    [--output <path>] [--recent-events <n>] [--recent-review-rounds <n>] [--recent-decisions <n>]

Renders a Claude worker prompt packet from the canonical Gemo feature trace and worker skill.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

export GEMO_RENDER_CLAUDE_WORKER_PROMPT_SCRIPT_PATH="$0"

python3 - "$@" <<'PY'
import argparse
import json
import os
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

SCHEMA_VERSION = "1.1"
DEFAULT_RECENT_EVENTS = 6
DEFAULT_RECENT_REVIEW_ROUNDS = 2
DEFAULT_RECENT_DECISIONS = 6
WORKER_SECTION_PRIORITY = {
    "gemo-backend": [
        "Working Rules",
        "Output Contract",
        "Backend Engineering Best Practices",
        "Stack-Specific Must-Haves",
        "Review Loop Prevention",
        "Validation And Handoff",
        "Delivery Expectations",
    ],
    "gemo-react": [
        "Working Rules",
        "Output Contract",
        "Review Loop Prevention",
        "Validation And Handoff",
        "Delivery Expectations",
    ],
}

REVIEWER_SECTION_PRIORITY = [
    "Review Loop Prevention",
    "Output Contract",
    "Detailed Feedback Contract",
    "Rework Handoff Contract",
    "Review Contract",
]


def fail(message: str) -> None:
    raise SystemExit(f"render-claude-worker-prompt: {message}")


def read_text(path: Path, required: bool = True) -> str:
    if not path.exists():
        if required:
            fail(f"missing required file: {path}")
        return ""
    return path.read_text(encoding="utf-8")


def collapse(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def parse_top_level_bullets(text: str) -> dict[str, str]:
    fields: dict[str, str] = {}
    current_key = None
    current_lines: list[str] = []

    def commit() -> None:
        nonlocal current_key, current_lines
        if current_key is not None:
            value = "\n".join(line.rstrip() for line in current_lines).strip()
            fields[current_key] = value
        current_key = None
        current_lines = []

    for raw_line in text.splitlines():
        line = raw_line.rstrip("\n")
        match = re.match(r"^- ([^:]+):\s*(.*)$", line)
        if match:
            commit()
            current_key = match.group(1).strip()
            current_lines = [match.group(2).rstrip()]
            continue
        if current_key is not None and (line.startswith("  ") or line.startswith("\t")):
            current_lines.append(line.strip())
            continue
        if current_key is not None and line.strip() == "":
            current_lines.append("")
            continue
        if line.startswith("#"):
            commit()
            continue
        if current_key is not None:
            commit()

    commit()
    return {key: value for key, value in fields.items() if value}


def split_level_blocks(text: str, level: int, title: str) -> list[str]:
    pattern = rf"(?m)^{'#' * level}\s+{re.escape(title)}\s*$"
    return re.split(pattern, text)[1:]


def extract_level_section(text: str, level: int, title: str) -> str:
    match = re.search(rf"(?m)^{'#' * level}\s+{re.escape(title)}\s*$", text)
    if not match:
        return ""
    start = match.end()
    next_match = re.search(rf"(?m)^{'#' * level}\s+\S", text[start:])
    end = start + next_match.start() if next_match else len(text)
    return text[start:end].strip()


def parse_execution_task(execution_plan_text: str, task_id: str) -> dict[str, str]:
    for block in split_level_blocks(execution_plan_text, 3, "Task"):
        fields = parse_top_level_bullets(block)
        if fields.get("Task ID") in {task_id, f"`{task_id}`"}:
            return fields
    fail(f"task id not found in execution plan: {task_id}")


def parse_decisions(decisions_text: str) -> list[dict[str, str]]:
    decisions = []
    for block in split_level_blocks(decisions_text, 3, "Decision"):
        fields = parse_top_level_bullets(block)
        if fields:
            decisions.append(fields)
    return decisions


def parse_findings(findings_text: str) -> list[dict[str, str]]:
    findings = []
    current = {}
    current_key = None

    def commit() -> None:
        nonlocal current, current_key
        if current:
            findings.append({key: value.strip() for key, value in current.items() if value.strip()})
        current = {}
        current_key = None

    for raw_line in findings_text.splitlines():
        line = raw_line.rstrip("\n")
        match = re.match(r"^- ([^:]+):\s*(.*)$", line)
        if match:
            key = match.group(1).strip()
            value = match.group(2).rstrip()
            if key == "Severity" and current:
                commit()
            current[key] = value
            current_key = key
            continue
        if current and current_key and (line.startswith("  ") or line.startswith("\t")):
            current[current_key] += "\n" + line.strip()

    commit()
    return findings


def parse_review_rounds(reviews_text: str) -> list[dict[str, object]]:
    rounds = []
    for block in split_level_blocks(reviews_text, 3, "Review Round"):
        findings_marker = re.search(r"(?m)^### Findings\s*$", block)
        outcome_marker = re.search(r"(?m)^### Outcome\s*$", block)
        metadata_text = block
        findings_text = ""
        outcome_text = ""

        if findings_marker:
            metadata_text = block[: findings_marker.start()]
            if outcome_marker and outcome_marker.start() > findings_marker.start():
                findings_text = block[findings_marker.end() : outcome_marker.start()]
                outcome_text = block[outcome_marker.end() :]
            else:
                findings_text = block[findings_marker.end() :]
        elif outcome_marker:
            metadata_text = block[: outcome_marker.start()]
            outcome_text = block[outcome_marker.end() :]

        metadata = parse_top_level_bullets(metadata_text)
        if not metadata:
            continue
        rounds.append(
            {
                "metadata": metadata,
                "outcome": parse_top_level_bullets(outcome_text),
                "findings": parse_findings(findings_text),
            }
        )
    return rounds


def parse_events(events_text: str) -> list[dict[str, object]]:
    events = []
    for line in events_text.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        try:
            events.append(json.loads(stripped))
        except json.JSONDecodeError:
            continue
    return events


def extract_named_sections(skill_text: str, desired: list[str]) -> list[tuple[str, str]]:
    sections = []
    for title in desired:
        body = extract_level_section(skill_text, 2, title)
        if body:
            sections.append((title, body.strip()))
    return sections


def extract_skill_sections(skill_text: str, worker_skill: str) -> list[tuple[str, str]]:
    desired = WORKER_SECTION_PRIORITY.get(
        worker_skill,
        [
            "Working Rules",
            "Output Contract",
            "Review Loop Prevention",
            "Validation And Handoff",
            "Delivery Expectations",
        ],
    )
    return extract_named_sections(skill_text, desired)


def strip_ticks(value: str) -> str:
    value = value.strip()
    if value.startswith("`") and value.endswith("`"):
        return value[1:-1]
    return value


def plain(value: str) -> str:
    return collapse(strip_ticks(value))


def split_list_field(value: str) -> list[str]:
    items = []
    normalized = value.replace(" and ", ",").replace(";", ",")
    for part in re.split(r",|\n", normalized):
        candidate = strip_ticks(part.strip())
        if candidate and candidate.lower() != "n/a":
            items.append(candidate)
    return items


def split_file_field(value: str) -> list[str]:
    return split_list_field(value)


def render_bullets(items: list[str]) -> list[str]:
    return [f"- {item}" for item in items] if items else ["- none"]


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--feature-dir", required=True)
    parser.add_argument("--task-id", required=True)
    parser.add_argument("--worker-skill", required=True)
    parser.add_argument("--output")
    parser.add_argument("--recent-events", type=int, default=DEFAULT_RECENT_EVENTS)
    parser.add_argument("--recent-review-rounds", type=int, default=DEFAULT_RECENT_REVIEW_ROUNDS)
    parser.add_argument("--recent-decisions", type=int, default=DEFAULT_RECENT_DECISIONS)
    parser.add_argument("-h", "--help", action="store_true")
    args = parser.parse_args(argv)

    if args.help:
        print("See --help on the shell wrapper.")
        return 0

    feature_dir = Path(args.feature_dir).resolve()
    if not feature_dir.is_dir():
        fail(f"feature directory does not exist: {feature_dir}")

    execution_plan_path = feature_dir / "04-execution-plan.md"
    decisions_path = feature_dir / "decisions.md"
    feature_state_path = feature_dir / "feature-state.md"
    reviews_path = feature_dir / "reviews.md"
    events_path = feature_dir / "events.jsonl"

    script_path = Path(os.environ["GEMO_RENDER_CLAUDE_WORKER_PROMPT_SCRIPT_PATH"]).resolve()
    foundation_root = script_path.parents[1]
    skill_root = foundation_root.parent / args.worker_skill
    skill_path = skill_root / "SKILL.md"
    if not skill_path.exists():
        fail(f"worker skill not found: {skill_path}")

    execution_plan_text = read_text(execution_plan_path)
    decisions_text = read_text(decisions_path)
    feature_state_text = read_text(feature_state_path)
    reviews_text = read_text(reviews_path, required=False)
    events_text = read_text(events_path, required=False)
    skill_text = read_text(skill_path)

    task = parse_execution_task(execution_plan_text, args.task_id)
    reviewer_skill_names = split_list_field(task.get("Reviewer Agent Skills", "")) or split_list_field(
        task.get("Reviewer", "")
    )
    decisions = [
        decision
        for decision in parse_decisions(decisions_text)
        if plain(decision.get("Status", "")).lower() == "accepted"
    ][-args.recent_decisions :]
    review_rounds = [
        round_info
        for round_info in parse_review_rounds(reviews_text)
        if strip_ticks(str(round_info["metadata"].get("Developer Task ID", ""))) == args.task_id
    ][-args.recent_review_rounds :]
    recent_events = [
        event for event in parse_events(events_text) if event.get("task_id") == args.task_id
    ][-args.recent_events :]

    relevant_files = []
    for round_info in review_rounds:
        for finding in round_info["findings"]:
            relevant_files.extend(split_file_field(str(finding.get("File", ""))))
    relevant_files = list(dict.fromkeys(relevant_files))

    objective = collapse(extract_level_section(feature_state_text, 2, "Objective"))
    architecture_fields = parse_top_level_bullets(
        extract_level_section(feature_state_text, 2, "Current Architecture Decision")
    )
    architecture_summary = plain(architecture_fields.get("Summary", ""))
    current_blockers_text = extract_level_section(feature_state_text, 2, "Current Blockers")
    current_blocker_fields = parse_top_level_bullets(current_blockers_text)
    skill_sections = extract_skill_sections(skill_text, args.worker_skill)
    reviewer_sections = []
    for reviewer_skill in list(dict.fromkeys(reviewer_skill_names)):
        reviewer_skill_path = foundation_root.parent / reviewer_skill / "SKILL.md"
        if not reviewer_skill_path.exists():
            fail(f"reviewer skill not found: {reviewer_skill_path}")
        reviewer_sections.append(
            (
                reviewer_skill,
                extract_named_sections(read_text(reviewer_skill_path), REVIEWER_SECTION_PRIORITY),
            )
        )

    relevant_decisions = []
    for decision in decisions:
        chosen = plain(decision.get("Chosen Option", ""))
        consequence = plain(decision.get("Consequences", ""))
        summary = f"{plain(decision.get('Decision ID', ''))} ({plain(decision.get('Phase', ''))}): {chosen}"
        if consequence:
            summary += f" Consequence: {consequence}"
        relevant_decisions.append(summary)

    event_lines = []
    for event in recent_events:
        event_lines.append(
            f"{collapse(str(event.get('ts', '')))} {collapse(str(event.get('event_type', '')))}: "
            f"{collapse(str(event.get('summary', '')))}"
        )

    lines = []
    append = lines.append
    task_title = plain(task.get("Title", ""))
    append(f"# Claude Worker Packet: {args.task_id} {task_title}")
    append("")
    append(
        "This packet is generated by gemo-orchestrator from the canonical feature trace and worker "
        "skill. It intentionally omits workspace ids, sidebar metadata, reviewer agent ids, and "
        "closed historical detail outside the latest review delta."
    )
    append("")
    append("## Document Control")
    append("")
    append(f"- Schema Version: `{SCHEMA_VERSION}`")
    append(f"- Generated At: `{datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}`")
    append(f"- Feature Directory: `{feature_dir}`")
    append(f"- Task ID: `{args.task_id}`")
    append(f"- Task Title: `{task_title}`")
    append(f"- Worker Skill: `{args.worker_skill}`")
    if reviewer_skill_names:
        append(f"- Reviewer Skills: {', '.join(f'`{name}`' for name in reviewer_skill_names)}")
    append(f"- Role: `{plain(task.get('Role', 'implementation'))}`")
    append(f"- Repo / Scope: {collapse(task.get('Repo / Scope', '').strip())}")
    append(f"- Worktree / Branch: {collapse(task.get('Worktree / Branch', '').strip())}")
    append("")
    append("## Execution Control")
    append("")
    append("- Start in plan mode before any edits.")
    append("- Read the required files and inspect the highest-risk invariants first.")
    append("- Reply with a concise execution plan scoped to the owned task.")
    append("- Stop at the execution approval gate before making code changes.")
    append("- If a contract gap or runtime blocker appears during planning, escalate immediately.")
    append("")
    append("## Task Goal")
    append("")
    append(f"- Goal: `{task_title}`")
    append(f"- Depends On: {collapse(task.get('Depends On', 'none').strip() or 'none')}")
    append(f"- Exit Evidence: {collapse(task.get('Exit Evidence', 'not specified').strip())}")
    if current_blocker_fields:
        append("- Current Blockers:")
        for key, value in current_blocker_fields.items():
            append(f"  - {key}: {collapse(value)}")
    else:
        current_blockers = collapse(current_blockers_text)
        if current_blockers and current_blockers.lower() not in {"- `none`", "- none", "none"}:
            append(f"- Current Blockers: {current_blockers}")
    append("")
    append("## Files To Read First")
    append("")
    base_files = [str(execution_plan_path), str(decisions_path), str(feature_state_path)]
    if review_rounds:
        base_files.append(str(reviews_path))
    if recent_events:
        base_files.append(str(events_path))
    for item in base_files:
        append(f"- `{item}`")
    if relevant_files:
        append("")
        append("### Review-Surfaced Files")
        append("")
        for path in relevant_files:
            append(f"- `{path}`")
    append("")
    append("## Feature Context")
    append("")
    if objective:
        append(f"- Objective: {objective}")
    if architecture_summary:
        append(f"- Architecture Summary: {architecture_summary}")
    append("")
    append("## Relevant Decisions")
    append("")
    lines.extend(render_bullets(relevant_decisions))
    append("")
    append("## Recent Review Delta")
    append("")
    if not review_rounds:
        append("- No prior review rounds are recorded for this task.")
        append("")
    else:
        for round_info in review_rounds:
            metadata = round_info["metadata"]
            outcome = round_info["outcome"]
            findings = [
                finding
                for finding in round_info["findings"]
                if plain(str(finding.get("Status", ""))).lower() != "closed"
            ]
            append(
                f"### {plain(str(metadata.get('Review ID', 'review')))} - "
                f"{plain(str(metadata.get('Reviewer', 'reviewer')))}"
            )
            append("")
            append(f"- Outcome: `{plain(str(outcome.get('Status', 'unknown')))}`")
            summary = collapse(str(metadata.get("Summary", "")))
            if summary:
                append(f"- Summary: {summary}")
            if not findings:
                append("- Open Findings: none")
                append("")
                continue
            append("- Open Findings:")
            for index, finding in enumerate(findings, start=1):
                append(
                    f"  - Finding {index} [{plain(str(finding.get('Severity', 'unknown')))}]: "
                    f"{plain(str(finding.get('Issue', '')))}"
                )
                blocker_family = plain(str(finding.get("Blocker Family", "")))
                if blocker_family:
                    append(f"    Blocker Family: {blocker_family}")
                family_status = plain(str(finding.get("Family Status", "")))
                if family_status:
                    append(f"    Family Status: {family_status}")
                invariant = plain(str(finding.get("Violated Invariant / Expectation", "")))
                if invariant:
                    append(f"    Violated Invariant / Expectation: {invariant}")
                root_cause = plain(str(finding.get("Weak Enforcement Point / Root Cause", "")))
                if root_cause:
                    append(f"    Weak Enforcement Point / Root Cause: {root_cause}")
                siblings = plain(str(finding.get("Sibling Surfaces To Check", "")))
                if siblings:
                    append(f"    Sibling Surfaces To Check: {siblings}")
                proof_path = plain(str(finding.get("Strongest Proof Path", "")))
                if proof_path:
                    append(f"    Strongest Proof Path: {proof_path}")
                action = plain(str(finding.get("Required Action", "")))
                if action:
                    append(f"    Required Action: {action}")
                file_list = plain(str(finding.get("File", "")))
                if file_list:
                    append(f"    Files: {file_list}")
            append("")
    append("## Recent Event Context")
    append("")
    lines.extend(render_bullets(event_lines))
    append("")
    append(f"## Implementation Doctrine From `{args.worker_skill}`")
    append("")
    for title, body in skill_sections:
        append(f"### {title}")
        append("")
        append(body)
        append("")
    append("## Reviewer Acceptance Contract")
    append("")
    if not reviewer_sections:
        append("- No reviewer skills are declared for this task.")
        append("")
    else:
        for reviewer_skill, sections in reviewer_sections:
            append(f"### `{reviewer_skill}`")
            append("")
            if not sections:
                append("- No acceptance-shaping sections are available for this reviewer skill.")
                append("")
                continue
            for title, body in sections:
                append(f"#### {title}")
                append("")
                append(body)
                append("")
    append("## Validation Required")
    append("")
    append(f"- Task Exit Evidence: {collapse(task.get('Exit Evidence', 'not specified').strip())}")
    review_actions = []
    review_proof_paths = []
    for round_info in review_rounds:
        for finding in round_info["findings"]:
            if plain(str(finding.get("Status", ""))).lower() == "closed":
                continue
            action = plain(str(finding.get("Required Action", "")))
            if action:
                review_actions.append(action)
            proof_path = plain(str(finding.get("Strongest Proof Path", "")))
            if proof_path:
                review_proof_paths.append(proof_path)
    review_actions = list(dict.fromkeys(review_actions))
    review_proof_paths = list(dict.fromkeys(review_proof_paths))
    if review_actions:
        append("- Latest Review Obligations:")
        for action in review_actions:
            append(f"  - {action}")
    if review_proof_paths:
        append("- Reviewer Proof Paths:")
        for proof_path in review_proof_paths:
            append(f"  - {proof_path}")
    append("")
    append("## Escalation Contract")
    append("")
    append(f"- Retry Window: {collapse(task.get('Retry Window', 'not specified').strip())}")
    append(f"- Escalation Condition: {collapse(task.get('Escalation Condition', 'not specified').strip())}")
    append("")
    append("## First Response")
    append("")
    append("- Reply with: scope acknowledged, first files or invariants to inspect, the initial implementation plan, and any immediate blocker.")
    append("- Do not start implementation until that plan has been surfaced and approved.")
    append("")
    append("## Collaboration Note")
    append("")
    append(
        "- The launcher appends the cmux reporting footer. Use that reporting contract exactly and "
        "do not finish or idle silently."
    )

    rendered = "\n".join(lines).rstrip() + "\n"
    if args.output:
        output_path = Path(args.output).resolve()
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(rendered, encoding="utf-8")
        print(str(output_path))
    else:
        sys.stdout.write(rendered)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
PY
