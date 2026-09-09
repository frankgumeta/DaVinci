#!/bin/bash

# Tear down a simulator created by create-ios-simulator.sh.
#
# Kept separate from the create script because that one prints the UDID for its
# caller to use: it cannot delete the simulator on exit without deleting the thing
# it was asked to produce. Callers own the lifetime, so callers do the teardown —
# in CI as a step with `if: always()`, locally after the test run.
#
# Refuses to delete anything the create script did not make, so a mistyped or
# stale UDID cannot take out a simulator someone was using.

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <udid>" >&2
    exit 2
fi

udid="$1"

# An empty UDID means the create step never ran — a job that failed earlier. That
# is a no-op, not an error: a teardown running with `if: always()` must not turn
# an already-failing job into a confusing second failure.
if [[ -z "$udid" ]]; then
    echo "No UDID given; the simulator was probably never created." >&2
    exit 0
fi

name="$(xcrun simctl list devices --json \
    | python3 -c '
import json
import sys

target = sys.argv[1]
devices = json.load(sys.stdin).get("devices", {})
for runtime_devices in devices.values():
    for device in runtime_devices:
        if device.get("udid") == target:
            print(device.get("name", ""))
            sys.exit(0)
' "$udid")"

if [[ -z "$name" ]]; then
    echo "No simulator with UDID $udid; nothing to delete." >&2
    exit 0
fi

if [[ "$name" != "DaVinci CI "* ]]; then
    echo "Refusing to delete '$name' ($udid): not created by create-ios-simulator.sh." >&2
    exit 1
fi

xcrun simctl shutdown "$udid" 2>/dev/null || true
xcrun simctl delete "$udid"
echo "Deleted $name ($udid)" >&2
