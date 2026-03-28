#!/usr/bin/env python3
"""
Repo-local bridge to the installed system skill-creator scripts.

Use this when a Gemo skill needs to create or refresh skill artifacts while keeping
`agents/openai.yaml` aligned to the Gemo suite convention.
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path


def normalize_skill_name(skill_name: str) -> str:
    normalized = skill_name.strip().lower()
    normalized = re.sub(r"[^a-z0-9]+", "-", normalized)
    normalized = normalized.strip("-")
    normalized = re.sub(r"-{2,}", "-", normalized)
    return normalized


def resolve_skill_creator_scripts(skill_creator_dir: str | None) -> dict[str, Path]:
    if skill_creator_dir:
        scripts_dir = Path(skill_creator_dir).expanduser().resolve()
    else:
        codex_home = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
        scripts_dir = (codex_home / "skills" / ".system" / "skill-creator" / "scripts").resolve()

    scripts = {
        "init": scripts_dir / "init_skill.py",
        "generate": scripts_dir / "generate_openai_yaml.py",
        "validate": scripts_dir / "quick_validate.py",
    }
    missing = [name for name, path in scripts.items() if not path.exists()]
    if missing:
        names = ", ".join(sorted(missing))
        raise SystemExit(
            f"Missing skill-creator script(s): {names}. Looked in {scripts_dir}. "
            "Install or expose the system skill-creator first."
        )
    return scripts


def run_command(command: list[str], cwd: Path | None = None) -> None:
    subprocess.run(command, check=True, cwd=cwd)


def ensure_openai_policy(openai_yaml_path: Path, allow_implicit_invocation: bool) -> None:
    desired = "true" if allow_implicit_invocation else "false"
    content = openai_yaml_path.read_text()

    if "allow_implicit_invocation:" in content:
        content = re.sub(
            r"allow_implicit_invocation:\s*(true|false)",
            f"allow_implicit_invocation: {desired}",
            content,
        )
    else:
        if not content.endswith("\n"):
            content += "\n"
        content += "\npolicy:\n"
        content += f"  allow_implicit_invocation: {desired}\n"

    openai_yaml_path.write_text(content)


def build_interface_flags(items: list[str]) -> list[str]:
    flags: list[str] = []
    for item in items:
        flags.extend(["--interface", item])
    return flags


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Bridge repo-local skill authoring to the installed skill-creator scripts.",
    )
    parser.add_argument(
        "--repo-root",
        default=".",
        help="Path to the neo-gemo-skills repo root. Defaults to the current working directory.",
    )
    parser.add_argument("--skill-name", required=True, help="Skill name or title.")
    parser.add_argument(
        "--resources",
        default="",
        help="Comma-separated resource folders to create when the skill does not exist.",
    )
    parser.add_argument(
        "--interface",
        action="append",
        default=[],
        help="Pass-through interface override in key=value format. Repeat as needed.",
    )
    parser.add_argument(
        "--create-if-missing",
        action="store_true",
        help="Create the skill with init_skill.py when it does not already exist.",
    )
    parser.add_argument(
        "--install",
        action="store_true",
        help="Run ./scripts/install_skills.sh --force after validation succeeds.",
    )
    parser.add_argument(
        "--skill-creator-dir",
        help="Override the directory that contains init_skill.py, generate_openai_yaml.py, and quick_validate.py.",
    )
    parser.add_argument(
        "--allow-implicit-invocation",
        choices=("true", "false"),
        default="true",
        help="Normalize agents/openai.yaml to this allow_implicit_invocation value.",
    )
    args = parser.parse_args()

    repo_root = Path(args.repo_root).expanduser().resolve()
    if not repo_root.exists():
        raise SystemExit(f"Repo root not found: {repo_root}")

    skills_root = repo_root / "skills"
    if not skills_root.exists():
        raise SystemExit(f"skills directory not found under repo root: {skills_root}")

    skill_name = normalize_skill_name(args.skill_name)
    if not skill_name:
        raise SystemExit("Skill name resolved to an empty value after normalization.")

    skill_dir = skills_root / skill_name
    scripts = resolve_skill_creator_scripts(args.skill_creator_dir)
    interface_flags = build_interface_flags(args.interface)

    if skill_dir.exists():
        run_command(
            [
                sys.executable,
                str(scripts["generate"]),
                str(skill_dir),
                "--name",
                skill_name,
                *interface_flags,
            ]
        )
    else:
        if not args.create_if_missing:
            raise SystemExit(
                f"Skill directory does not exist: {skill_dir}. Pass --create-if-missing to create it."
            )
        command = [
            sys.executable,
            str(scripts["init"]),
            skill_name,
            "--path",
            str(skills_root),
        ]
        if args.resources:
            command.extend(["--resources", args.resources])
        command.extend(interface_flags)
        run_command(command)

    openai_yaml_path = skill_dir / "agents" / "openai.yaml"
    if not openai_yaml_path.exists():
        raise SystemExit(f"agents/openai.yaml was not created: {openai_yaml_path}")

    ensure_openai_policy(
        openai_yaml_path,
        allow_implicit_invocation=args.allow_implicit_invocation == "true",
    )

    run_command([sys.executable, str(scripts["validate"]), str(skill_dir)])

    if args.install:
        install_script = repo_root / "scripts" / "install_skills.sh"
        if not install_script.exists():
            raise SystemExit(f"Install script not found: {install_script}")
        run_command([str(install_script), "--force"], cwd=repo_root)

    print(f"[OK] Skill bridge completed for {skill_name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
