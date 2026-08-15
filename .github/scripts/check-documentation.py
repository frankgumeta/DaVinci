#!/usr/bin/env python3
"""Reject public documentation that drifts back to removed pre-1.4 APIs."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


DOCUMENTATION_PATHS = (
    "README.md",
    "ACCESSIBILITY.md",
    "CONTRIBUTING.md",
    "Docs",
)

REMOVED_API_PATTERNS = {
    "button variant argument": re.compile(r"DS(?:Icon)?Button\([^\n]*\bvariant\s*:", re.MULTILINE),
    "button variant DocC link": re.compile(r"init\([^\n`]*:variant:"),
    "icon button raw systemName initializer": re.compile(
        r"DSIconButton\(\s*\n?\s*systemName\s*:", re.MULTILINE
    ),
    "text field showsLabel argument": re.compile(
        r"DSTextField\([\s\S]{0,300}?^\s*showsLabel\s*:", re.MULTILINE
    ),
    "remote image width initializer": re.compile(
        r"DSRemoteImage\([\s\S]{0,300}?^\s*width\s*:", re.MULTILINE
    ),
    "remote image legacy placeholder": re.compile(
        r"DSRemoteImage\([\s\S]{0,400}?^\s*placeholderSystemImage\s*:", re.MULTILINE
    ),
    "removed DSColors emphasis argument": re.compile(r"^\s*emphasis\s*:", re.MULTILINE),
}


def documentation_files(root: Path) -> list[Path]:
    files: list[Path] = []
    for relative in DOCUMENTATION_PATHS:
        path = root / relative
        if path.is_dir():
            files.extend(sorted(path.rglob("*.md")))
        elif path.is_file():
            files.append(path)
    return files


def find_removed_api_references(root: Path) -> list[str]:
    failures: list[str] = []
    for path in documentation_files(root):
        text = path.read_text(encoding="utf-8")
        for description, pattern in REMOVED_API_PATTERNS.items():
            for match in pattern.finditer(text):
                line = text.count("\n", 0, match.start()) + 1
                failures.append(f"{path.relative_to(root)}:{line}: {description}")
    return failures


def validate_release_floor(root: Path) -> list[str]:
    readme = (root / "README.md").read_text(encoding="utf-8")
    if 'from: "1.4.0"' not in readme:
        return ["README.md: installation example must start at the stable 1.4.0 API floor"]
    return []


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", nargs="?", type=Path, default=Path.cwd())
    args = parser.parse_args()
    root = args.root.resolve()

    failures = find_removed_api_references(root) + validate_release_floor(root)
    if failures:
        print("Documentation validation failed:", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    print("Documentation validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
