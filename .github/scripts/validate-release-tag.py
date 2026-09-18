#!/usr/bin/env python3
"""Validate a release tag and expose its SemVer channel to GitHub Actions."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


SEMVER = re.compile(
    r"^v(?P<version>0|[1-9]\d*)\.(?P<minor>0|[1-9]\d*)\.(?P<patch>0|[1-9]\d*)"
    r"(?:-(?P<channel>alpha|beta|rc)\.(?P<iteration>0|[1-9]\d*))?$"
)


def validate(tag: str, changelog: str) -> tuple[list[str], dict[str, str]]:
    match = SEMVER.fullmatch(tag)
    if match is None:
        return ["tag must match vMAJOR.MINOR.PATCH or vMAJOR.MINOR.PATCH-(alpha|beta|rc).N"], {}

    base_version = ".".join(
        [match.group("version"), match.group("minor"), match.group("patch")]
    )
    channel = match.group("channel")
    iteration = match.group("iteration")
    version = f"{base_version}-{channel}.{iteration}" if channel else base_version
    if f"## [{version}]" not in changelog:
        return [f"CHANGELOG.md is missing a heading for [{version}]"], {}

    return [], {
        "version": version,
        "prerelease": "true" if channel else "false",
        "channel": channel or "stable",
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("tag")
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--github-output", type=Path)
    args = parser.parse_args()

    changelog = (args.root / "CHANGELOG.md").read_text(encoding="utf-8")
    errors, metadata = validate(args.tag, changelog)
    if errors:
        print("Release tag validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    for key, value in metadata.items():
        print(f"{key}={value}")
    if args.github_output:
        with args.github_output.open("a", encoding="utf-8") as output:
            for key, value in metadata.items():
                output.write(f"{key}={value}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
