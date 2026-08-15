# Compatibility

DaVinci deliberately supports the following environment:

| Area | Supported baseline | How it is validated |
|---|---|---|
| Platform | iOS 17 or later | CI builds every package product with `IPHONEOS_DEPLOYMENT_TARGET=17.0` |
| SDK | SDK bundled with Xcode 26.6 | CI builds and runs the complete suite on each pull request |
| Swift tools | Swift tools 6.3 | Declared by `Package.swift` |
| Swift language | Swift 6 with complete strict concurrency | Language mode 6 makes complete checking the default |
| Xcode | Xcode 26.6 | CI pins `macos-26` and selects Xcode 26.6 explicitly |

## Why iOS 17

The minimum platform is determined by product APIs, not by Swift concurrency.
DaVinci's accessibility contracts use `AccessibilityTraits.isToggle`, which is
available starting in iOS 17. Swift 6 strict concurrency is enforced by the
compiler and does not require iOS 26.

## Concurrency checking

The package declares Swift language mode 6 explicitly. In Swift 6, complete
strict-concurrency checking is the default, so DaVinci does not use unsafe compiler
flags or the older `StrictConcurrency` upcoming feature to enable it.

## Platform scope

DaVinci is an iOS-only package. macOS is not declared as a supported platform,
and several sources and tests depend on UIKit or iOS-specific SwiftUI behavior.
For that reason, plain `swift test` is not a supported workflow: use the documented
`xcodebuild` commands with an iOS Simulator destination.

## CI matrix

CI performs two complementary checks:

1. A generic iOS Simulator build with deployment target 17.0, which verifies that
   all products compile for the minimum supported deployment target against the
   Xcode 26.6 SDK.
2. The complete test suite on a dynamically created iPhone Simulator using the
   newest iOS runtime installed on the macOS 26 runner.

The scheduled `LTS Compatibility` workflow additionally installs an iOS 17.5
Simulator runtime and executes the compatibility suite against the minimum
supported major version. All test sources compile there and behavioral tests run;
pixel snapshots execute only on the current CI runtime because SwiftUI rendering
is OS-specific. Time-based performance baselines also execute only on the current
runtime because first-boot legacy simulators can be throttled independently of
product behavior. The workflow can also be triggered manually before a patch release.

The helper at `.github/scripts/create-ios-simulator.sh` avoids assuming that a
particular simulator is already registered. It prefers a recent iPhone device type
that is compatible with the selected runtime and falls back to any supported
iPhone type. Set `DAVINCI_IOS_RUNTIME_MAJOR=17` to require the minimum runtime.
