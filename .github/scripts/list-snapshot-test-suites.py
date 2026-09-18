#!/usr/bin/env python3
"""List snapshot-test suite type names declared in Swift source files."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


SUITE_DECLARATION = re.compile(
    r"^\s*(?:final\s+)?(?:class|struct)\s+([A-Za-z0-9_]+SnapshotTests)\b",
    re.MULTILINE,
)


def suites_in(source: str) -> list[str]:
    return SUITE_DECLARATION.findall(source)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("sources", nargs="+", type=Path)
    args = parser.parse_args()

    for source in args.sources:
        for suite in suites_in(source.read_text(encoding="utf-8")):
            print(suite)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
