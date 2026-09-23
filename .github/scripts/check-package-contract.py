#!/usr/bin/env python3
"""Validate the toolchain-facing SwiftPM contract for the 2.0 development line."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path


EXPECTED_PRODUCTS = {
    "DaVinciTokens",
    "DaVinciComponents",
    "DaVinciGallery",
}


def load_manifest(path: Path | None) -> dict:
    if path is not None:
        return json.loads(path.read_text(encoding="utf-8"))

    process = subprocess.run(
        ["swift", "package", "dump-package"],
        capture_output=True,
        text=True,
        check=False,
    )
    if process.returncode != 0:
        detail = process.stderr.strip() or process.stdout.strip()
        raise RuntimeError(f"swift package dump-package failed: {detail}")
    return json.loads(process.stdout)


def validate_manifest(manifest: dict) -> list[str]:
    failures: list[str] = []

    tools_version = manifest.get("toolsVersion", {}).get("_version")
    if tools_version != "6.4.0":
        failures.append(f"expected Swift tools 6.4.0, found {tools_version!r}")

    language_versions = manifest.get("swiftLanguageVersions", [])
    if language_versions != ["6"]:
        failures.append(
            f"expected Swift language mode 6, found {language_versions!r}"
        )

    platforms = {
        item.get("platformName"): item.get("version")
        for item in manifest.get("platforms", [])
    }
    if platforms != {"ios": "18.0"}:
        failures.append(f"expected only iOS 18.0, found {platforms!r}")

    products = {item.get("name") for item in manifest.get("products", [])}
    if products != EXPECTED_PRODUCTS:
        failures.append(
            "expected public products "
            f"{sorted(EXPECTED_PRODUCTS)!r}, found {sorted(products)!r}"
        )

    return failures


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input",
        type=Path,
        help="Validate a saved dump-package JSON document instead of invoking Swift.",
    )
    arguments = parser.parse_args()

    try:
        manifest = load_manifest(arguments.input)
    except (OSError, RuntimeError, json.JSONDecodeError) as error:
        print(f"Package contract error: {error}", file=sys.stderr)
        return 2

    failures = validate_manifest(manifest)
    if failures:
        print("Package contract validation failed:", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    print("Package contract passed: Swift tools 6.4, Swift 6, iOS 18.0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
