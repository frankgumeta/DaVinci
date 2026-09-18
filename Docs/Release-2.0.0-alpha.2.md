# DaVinci 2.0.0-alpha.2 release notes

Alpha.1 is closed and alpha.2 is the active 2.0 pre-release line. Further API,
rendering, and documentation adjustments remain allowed before the 2.0.0 stable
freeze. Do not use this pre-release as an LTS dependency.

## Included validation

- Xcode 27.0, Swift tools 6.4, Swift 6, and iOS 17 deployment target.
- iOS 27 visual validation and iOS 17.5 minimum-runtime compatibility validation.
- SwiftLint, DocC diagnostics, API drift checks, product coverage, performance,
  snapshots, and external-consumer compilation.

## Adoption

Pin this version explicitly in Swift Package Manager:

```swift
.package(url: "https://github.com/frankgumeta/DaVinci.git", exact: "2.0.0-alpha.2")
```

See [Migrating from 1.4 to 2.0](Migration-2.0.md) for source-breaking changes.
