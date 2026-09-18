#!/usr/bin/env python3
"""Remove known SDK-owned diagnostics from swift-api-digester output."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


SDK_CONFORMANCE_CHANGE = re.compile(
    r"^API breakage: extension (?P<type>\S+) has removed conformance to "
    r"(?P<protocol>\S+)$"
)
ALLOWED_SDK_DELTAS = {
    ("EnvironmentValues", "Sendable"),
    ("EnvironmentValues", "SendableMetatype"),
}
DAVINCI_MODULES = {"DaVinciTokens", "DaVinciComponents", "DaVinciGallery"}


def declarations(document: object) -> list[dict]:
    found: list[dict] = []

    def visit(value: object) -> None:
        if isinstance(value, dict):
            if value.get("kind") == "TypeDecl":
                found.append(value)
            for child in value.values():
                visit(child)
        elif isinstance(value, list):
            for child in value:
                visit(child)

    visit(document)
    return found


def has_conformance(declaration: dict, protocol: str) -> bool:
    return any(
        conformance.get("name") == protocol
        for conformance in declaration.get("conformances", [])
    )


def is_verified_sdk_delta(
    type_name: str,
    protocol: str,
    baseline: object,
    current: object,
) -> bool:
    if (type_name, protocol) not in ALLOWED_SDK_DELTAS:
        return False

    baseline_types = [
        declaration
        for declaration in declarations(baseline)
        if declaration.get("name") == type_name
    ]
    current_types = [
        declaration
        for declaration in declarations(current)
        if declaration.get("name") == type_name
    ]
    if len(baseline_types) != 1 or len(current_types) != 1:
        return False

    previous = baseline_types[0]
    latest = current_types[0]
    sdk_owned = all(
        declaration.get("isExternal") is True
        and declaration.get("moduleName") not in DAVINCI_MODULES
        for declaration in (previous, latest)
    )
    return (
        sdk_owned
        and has_conformance(previous, protocol)
        and not has_conformance(latest, protocol)
    )


def filter_diagnostics(
    diagnostics: str,
    baseline: object,
    current: object,
) -> tuple[str, list[str]]:
    kept: list[str] = []
    ignored: list[str] = []
    for line in diagnostics.splitlines():
        match = SDK_CONFORMANCE_CHANGE.fullmatch(line)
        if match and is_verified_sdk_delta(
            match.group("type"),
            match.group("protocol"),
            baseline,
            current,
        ):
            ignored.append(line)
        else:
            kept.append(line)
    filtered = "\n".join(kept)
    if filtered and diagnostics.endswith("\n"):
        filtered += "\n"
    return filtered, ignored


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("baseline", type=Path)
    parser.add_argument("current", type=Path)
    parser.add_argument("diagnostics", type=Path)
    parser.add_argument("--output", required=True, type=Path)
    arguments = parser.parse_args()

    baseline = json.loads(arguments.baseline.read_text(encoding="utf-8"))
    current = json.loads(arguments.current.read_text(encoding="utf-8"))
    diagnostics = arguments.diagnostics.read_text(encoding="utf-8")
    filtered, ignored = filter_diagnostics(diagnostics, baseline, current)
    arguments.output.write_text(filtered, encoding="utf-8")

    for diagnostic in ignored:
        print(f"Ignored SDK-owned API diagnostic: {diagnostic}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
