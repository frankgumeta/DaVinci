#!/usr/bin/env python3

"""Report and enforce per-target Xcode line coverage."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path


def parse_minimum(value: str) -> tuple[str, float]:
    try:
        target, percentage = value.rsplit("=", 1)
        minimum = float(percentage)
    except ValueError as error:
        raise argparse.ArgumentTypeError(
            "minimum must use TARGET=PERCENT format"
        ) from error

    if not target or not 0 <= minimum <= 100:
        raise argparse.ArgumentTypeError(
            "minimum must name a target and use a percentage from 0 to 100"
        )
    return target, minimum


def load_report(result_bundle: Path) -> dict:
    if not result_bundle.is_dir():
        raise RuntimeError(f"result bundle not found: {result_bundle}")

    command = [
        "xcrun",
        "xccov",
        "view",
        "--report",
        "--json",
        str(result_bundle),
    ]
    process = subprocess.run(command, capture_output=True, text=True, check=False)
    if process.returncode != 0:
        detail = process.stderr.strip() or process.stdout.strip()
        raise RuntimeError(f"xccov failed: {detail}")

    try:
        return json.loads(process.stdout)
    except json.JSONDecodeError as error:
        raise RuntimeError("xccov returned invalid JSON") from error


def markdown_report(targets: list[dict], minimums: dict[str, float]) -> tuple[str, bool]:
    rows = [
        "# DaVinci code coverage",
        "",
        "| Product target | Covered lines | Executable lines | Coverage | Minimum | Result |",
        "|---|---:|---:|---:|---:|---|",
    ]
    passed = True

    product_targets = [
        target
        for target in targets
        if target.get("name", "").startswith("DaVinci")
        and not target.get("name", "").endswith("Tests")
    ]
    for target in sorted(product_targets, key=lambda item: item["name"]):
        name = target["name"]
        coverage = float(target.get("lineCoverage", 0)) * 100
        covered = int(target.get("coveredLines", 0))
        executable = int(target.get("executableLines", 0))
        minimum = minimums.get(name)
        meets_minimum = minimum is None or coverage + 1e-9 >= minimum
        passed = passed and meets_minimum
        minimum_text = f"{minimum:.2f}%" if minimum is not None else "Report only"
        result = "Pass" if meets_minimum and minimum is not None else "Not gated"
        if not meets_minimum:
            result = "Fail"
        rows.append(
            f"| {name} | {covered} | {executable} | {coverage:.2f}% | "
            f"{minimum_text} | {result} |"
        )

    reported_names = {target.get("name") for target in targets}
    missing = sorted(set(minimums) - reported_names)
    for name in missing:
        rows.append(f"| {name} | — | — | — | {minimums[name]:.2f}% | Missing |")
        passed = False

    rows.extend(
        [
            "",
            "Only production targets are reported. Test bundle coverage is intentionally excluded.",
        ]
    )
    return "\n".join(rows) + "\n", passed


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("result_bundle", type=Path)
    parser.add_argument(
        "--minimum",
        action="append",
        default=[],
        type=parse_minimum,
        metavar="TARGET=PERCENT",
    )
    parser.add_argument("--output", type=Path)
    arguments = parser.parse_args()

    minimums = dict(arguments.minimum)
    try:
        report = load_report(arguments.result_bundle)
        markdown, passed = markdown_report(report.get("targets", []), minimums)
    except RuntimeError as error:
        print(f"Coverage error: {error}", file=sys.stderr)
        return 2

    print(markdown, end="")
    if arguments.output:
        arguments.output.write_text(markdown, encoding="utf-8")

    if not passed:
        print("Coverage thresholds failed.", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
