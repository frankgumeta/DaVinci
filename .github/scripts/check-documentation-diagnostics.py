#!/usr/bin/env python3
"""Fail when DocC reports warnings or errors from DaVinci-owned sources."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from urllib.parse import unquote, urlparse


OWNED_SOURCE_MARKER = "/Sources/DaVinci"
BLOCKING_SEVERITIES = {"error", "warning"}


def diagnostics_files(root: Path) -> list[Path]:
    return sorted(root.rglob("*-diagnostics.json"))


def source_path(source: str) -> str:
    parsed = urlparse(source)
    return unquote(parsed.path) if parsed.scheme == "file" else source


def owned_failures(root: Path) -> list[str]:
    failures: list[str] = []
    for path in diagnostics_files(root):
        payload = json.loads(path.read_text(encoding="utf-8"))
        for diagnostic in payload.get("diagnostics", []):
            severity = diagnostic.get("severity", "").lower()
            source = source_path(diagnostic.get("source", ""))
            if severity not in BLOCKING_SEVERITIES or OWNED_SOURCE_MARKER not in source:
                continue
            line = diagnostic.get("range", {}).get("start", {}).get("line", "?")
            failures.append(
                f"{source}:{line}: {severity}: {diagnostic.get('summary', 'DocC diagnostic')}"
            )
    return failures


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("docbuild", type=Path, help="DocC derived-data directory")
    args = parser.parse_args()
    root = args.docbuild.resolve()
    if not root.exists():
        print(f"DocC diagnostics directory does not exist: {root}", file=sys.stderr)
        return 2

    failures = owned_failures(root)
    if failures:
        print("DocC diagnostics failed:", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    print(f"DocC diagnostics passed ({len(diagnostics_files(root))} diagnostics files scanned)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
