# Compatibility

DaVinci deliberately supports the following environment:

| Area | Supported baseline | How it is validated |
|---|---|---|
| Platform | iOS 17 or later | CI builds every package product with `IPHONEOS_DEPLOYMENT_TARGET=17.0` |
| SDK | Current SDK in latest stable Xcode | CI builds and runs the complete suite on each pull request |
| Swift tools | Swift tools 6.0 or later | Declared by `Package.swift` |
| Swift language | Swift 6 with strict concurrency | Compiled in Swift 6 language mode |
| Xcode | Xcode 16 or later | Xcode 16 provides the required Swift 6 toolchain; CI uses latest stable Xcode |

## Why iOS 17

The minimum platform is determined by product APIs, not by Swift concurrency.
DaVinci's accessibility contracts use `AccessibilityTraits.isToggle`, which is
available starting in iOS 17. Swift 6 strict concurrency is enforced by the
compiler and does not require iOS 26.

## Platform scope

DaVinci is an iOS-only package. macOS is not declared as a supported platform,
and several sources and tests depend on UIKit or iOS-specific SwiftUI behavior.
For that reason, plain `swift test` is not a supported workflow: use the documented
`xcodebuild` commands with an iOS Simulator destination.

## CI matrix

CI performs two complementary checks:

1. A generic iOS Simulator build with deployment target 17.0, which verifies that
   all products compile for the minimum supported deployment target against the
   current SDK.
2. The complete test suite on a dynamically created iPhone Simulator using the
   newest iOS runtime installed on the selected runner.

The helper at `.github/scripts/create-ios-simulator.sh` avoids assuming that a
particular simulator is already registered. It prefers a recent iPhone device type
and falls back to any installed iPhone type.
