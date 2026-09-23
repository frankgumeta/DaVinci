#!/bin/bash

set -euo pipefail

simctl_json="$(mktemp)"
trap 'rm -f "$simctl_json"' EXIT

xcrun simctl list --json > "$simctl_json"

# Reap simulators this script created and nobody deleted. A caller that exits
# without running delete-ios-simulator.sh — an interrupted test run, a killed CI
# job — leaves one booted forever, and they accumulate silently.
#
# Only simulators older than the threshold are removed, so a concurrent run's
# simulator is never taken out from under it. The creation time comes from the
# name this script assigns below.
stale_seconds="${DAVINCI_SIMULATOR_MAX_AGE:-7200}"
stale_udids="$(python3 -c '
import json
import sys
import time

cutoff = time.time() - float(sys.argv[1])
devices = json.load(open(sys.argv[2])).get("devices", {})

for runtime_devices in devices.values():
    for device in runtime_devices:
        name = device.get("name", "")
        if not name.startswith("DaVinci CI "):
            continue
        stamp = name.removeprefix("DaVinci CI ").split("-", 1)[0]
        try:
            created = float(stamp)
        except ValueError:
            # An older naming scheme with no timestamp: leave it for a human.
            continue
        if created < cutoff:
            print(device["udid"])
' "$stale_seconds" "$simctl_json")"

if [[ -n "$stale_udids" ]]; then
    while IFS= read -r stale_udid; do
        echo "Reaping stale simulator $stale_udid" >&2
        xcrun simctl shutdown "$stale_udid" 2>/dev/null || true
        xcrun simctl delete "$stale_udid" 2>/dev/null || true
    done <<< "$stale_udids"
fi

selector_arguments=("$simctl_json")

selection="$(python3 "$(dirname "$0")/select-ios-simulator.py" "${selector_arguments[@]}" 2>&1)" || {
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
