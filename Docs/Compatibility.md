# Compatibility

DaVinci deliberately supports the following environment:

| Area | Supported baseline | How it is validated |
|---|---|---|
| Platform | iOS 18 or later | CI builds every package product with `IPHONEOS_DEPLOYMENT_TARGET=18.0` |
| SDK | iOS 27.0 SDK bundled with Xcode 27.0 | CI builds and runs the complete suite on each pull request |
| Swift tools | Swift tools 6.4 | Declared by `Package.swift` |
| Swift language | Swift 6 with complete strict concurrency | Language mode 6 makes complete checking the default |
| Xcode | Xcode 27.0, build 27A266a | CI uses the dedicated `xcode-27` image and verifies the installed build explicitly |

## Why iOS 18

The 2.0 line raises the deployment baseline to iOS 18 as a product decision.
The accessibility contracts still build on the toggle trait introduced in
iOS 17, and consumers that cannot adopt the new baseline are served by the
1.4.x LTS line.

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

1. A generic iOS Simulator build with deployment target 18.0, which verifies that
   all products compile for the minimum supported deployment target against the
   Xcode 27.0 SDK.
2. The complete test suite on a dynamically created iPhone Simulator using the
   newest iOS runtime installed on the `xcode-27` runner image.

The helper at `.github/scripts/create-ios-simulator.sh` avoids assuming that a
particular simulator is already registered. It prefers a recent iPhone device type
that is compatible with the selected runtime and falls back to any supported
iPhone type.

## Development and LTS toolchains

The 2.0 development line requires Xcode 27.0 and Swift tools 6.4 and raises the
iOS deployment target to 18.0. The 1.4.x LTS line remains on its dedicated
`release/1.4.x` branch with its published Xcode 26.6 and Swift tools 6.3
contract; fixes begin on the oldest affected supported line and are then
forward-ported to 2.x.
