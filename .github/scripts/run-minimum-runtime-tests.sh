#!/bin/bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <simulator-udid> <result-bundle-path>" >&2
    exit 2
fi

root="$(cd "$(dirname "$0")/../.." && pwd)"
simulator_udid="$1"
result_bundle_path="$2"
test_skips=("-skip-testing:DaVinciComponentsTests/DSPerformanceBaselineTests")
code_signing_allowed="${DAVINCI_CODE_SIGNING_ALLOWED:-YES}"

# Pixel snapshots are intentionally recorded and compared on the current CI
# runtime. The minimum-runtime lane still compiles them, but skips execution so
# OS rendering differences do not masquerade as compatibility regressions.
# Performance baselines also remain on the current runtime: a freshly installed
# legacy simulator can be heavily throttled even when product behavior is valid.
for file in "$root"/Tests/DaVinciComponentsTests/*SnapshotTests.swift; do
    suite="$(basename "$file" .swift)"
    test_skips+=("-skip-testing:DaVinciComponentsTests/$suite")
done

xcodebuild test \
    -scheme DaVinci-Package \
    -destination "platform=iOS Simulator,id=$simulator_udid" \
    -resultBundlePath "$result_bundle_path" \
    -derivedDataPath "$root/.build" \
    "${test_skips[@]}" \
    "CODE_SIGNING_ALLOWED=$code_signing_allowed"
