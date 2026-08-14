#!/bin/bash

set -euo pipefail

simctl_json="$(mktemp)"
trap 'rm -f "$simctl_json"' EXIT

xcrun simctl list --json > "$simctl_json"

selector_arguments=("$simctl_json")
if [[ -n "${DAVINCI_IOS_RUNTIME_MAJOR:-}" ]]; then
    selector_arguments+=(--runtime-major "$DAVINCI_IOS_RUNTIME_MAJOR")
fi

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
