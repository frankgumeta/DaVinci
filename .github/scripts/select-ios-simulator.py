#!/usr/bin/env python3
"""Select a compatible iPhone device type for an installed iOS runtime."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


PREFERRED_DEVICE_NAMES = (
    "iPhone 17 Pro",
    "iPhone 17",
    "iPhone 16 Pro",
    "iPhone 16",
    "iPhone 15 Pro",
    "iPhone 15",
    "iPhone 14 Pro",
    "iPhone 14",
)


def version_key(runtime: dict) -> tuple[int, ...]:
    return tuple(int(part) for part in re.findall(r"\d+", runtime.get("version", "0")))


def select_runtime(data: dict, runtime_major: int | None) -> dict:
    runtimes = [
        runtime
        for runtime in data.get("runtimes", [])
        if runtime.get("isAvailable", False)
        and (
            runtime.get("platform") == "iOS"
            or "SimRuntime.iOS" in runtime.get("identifier", "")
        )
    ]
    if runtime_major is not None:
        runtimes = [
            runtime
            for runtime in runtimes
            if version_key(runtime) and version_key(runtime)[0] == runtime_major
        ]
    if not runtimes:
        requested = f" {runtime_major}" if runtime_major is not None else ""
        raise ValueError(f"No available iOS{requested} Simulator runtime found")
    return max(runtimes, key=version_key)


def select_device_type(runtime: dict) -> dict:
    supported = [
        device
        for device in runtime.get("supportedDeviceTypes", [])
        if device.get("productFamily") == "iPhone"
        or "SimDeviceType.iPhone" in device.get("identifier", "")
    ]
    if not supported:
        raise ValueError("Selected runtime has no compatible iPhone device type")
    return next(
        (
            device
            for name in PREFERRED_DEVICE_NAMES
            for device in supported
            if device.get("name") == name
        ),
        supported[0],
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("inventory", type=Path)
    parser.add_argument("--runtime-major", type=int)
    args = parser.parse_args()

    with args.inventory.open(encoding="utf-8") as file:
        data = json.load(file)

    runtime = select_runtime(data, args.runtime_major)
    device = select_device_type(runtime)
    print(runtime["identifier"])
    print(device["identifier"])
    print(runtime.get("name", runtime["identifier"]))
    print(device.get("name", device["identifier"]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
