#!/bin/bash

set -euo pipefail

expected_xcode_version="${DAVINCI_XCODE_VERSION:-27.0}"
expected_xcode_build="${DAVINCI_XCODE_BUILD:-27A266a}"
expected_swift_version="${DAVINCI_SWIFT_VERSION:-6.4}"

xcode_output="$(xcodebuild -version)"
swift_output="$(xcrun swift --version)"
sdk_version="$(xcrun --sdk iphonesimulator --show-sdk-version)"

if ! grep -Fxq "Xcode $expected_xcode_version" <<< "$xcode_output"; then
    echo "Expected Xcode $expected_xcode_version, received:" >&2
    echo "$xcode_output" >&2
    exit 1
fi

if ! grep -Fxq "Build version $expected_xcode_build" <<< "$xcode_output"; then
    echo "Expected Xcode build $expected_xcode_build, received:" >&2
    echo "$xcode_output" >&2
    exit 1
fi

if ! grep -Fq "Apple Swift version $expected_swift_version " <<< "$swift_output"; then
    echo "Expected Apple Swift $expected_swift_version, received:" >&2
    echo "$swift_output" >&2
    exit 1
fi

echo "$xcode_output"
echo "$swift_output"
echo "iPhone Simulator SDK $sdk_version"
echo "Available iOS simulator runtimes:"
xcrun simctl list runtimes available | sed -n '/^iOS /p'
