#!/bin/bash

set -euo pipefail

simctl_json="$(mktemp)"
trap 'rm -f "$simctl_json"' EXIT

xcrun simctl list --json > "$simctl_json"

selection="$({ python3 - "$simctl_json" <<'PY'
import json
import re
import sys

with open(sys.argv[1], encoding="utf-8") as file:
    data = json.load(file)


def version_key(runtime):
    version = runtime.get("version", "0")
    return tuple(int(part) for part in re.findall(r"\d+", version))


runtimes = [
    runtime
    for runtime in data.get("runtimes", [])
    if runtime.get("isAvailable", False)
    and (
        runtime.get("platform") == "iOS"
        or "SimRuntime.iOS" in runtime.get("identifier", "")
    )
]
if not runtimes:
    raise SystemExit("No available iOS Simulator runtime found")

runtime = max(runtimes, key=version_key)

device_types = [
    device
    for device in data.get("devicetypes", [])
    if "SimDeviceType.iPhone" in device.get("identifier", "")
]
if not device_types:
    raise SystemExit("No iPhone Simulator device type found")

preferred_names = (
    "iPhone 17 Pro",
    "iPhone 17",
    "iPhone 16 Pro",
    "iPhone 16",
)
device_type = next(
    (
        device
        for name in preferred_names
        for device in device_types
        if device.get("name") == name
    ),
    device_types[0],
)

print(runtime["identifier"])
print(device_type["identifier"])
print(runtime.get("name", runtime["identifier"]))
print(device_type.get("name", device_type["identifier"]))
PY
} 2>&1)" || {
    echo "$selection" >&2
    exit 1
}

runtime_identifier="$(printf '%s\n' "$selection" | sed -n '1p')"
device_type_identifier="$(printf '%s\n' "$selection" | sed -n '2p')"
runtime_name="$(printf '%s\n' "$selection" | sed -n '3p')"
device_type_name="$(printf '%s\n' "$selection" | sed -n '4p')"
simulator_name="DaVinci CI $(date +%s)-$$"

echo "Creating $device_type_name with $runtime_name" >&2
udid="$(xcrun simctl create \
    "$simulator_name" \
    "$device_type_identifier" \
    "$runtime_identifier")"

xcrun simctl boot "$udid"
xcrun simctl bootstatus "$udid" -b >&2

printf '%s\n' "$udid"
