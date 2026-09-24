# DaVinci 2.0.0-rc.1 release notes

RC1 is the release candidate for the first stable 2.0 line. It requires Xcode
27.0, Swift tools 6.4, Swift 6 language mode, and sets iOS 18.0 as the
deployment target; consumers still on iOS 17 are served by the 1.4.x LTS line.
Do not use this candidate as an LTS dependency.

## Included validation

- Xcode 27.0, Swift tools 6.4, Swift 6, and iOS 18 deployment target.
- Full suite, product coverage, API baseline, DocC diagnostics, external
  consumer, and visual validation on the iOS 27 runtime.

## Adoption

Pin this candidate explicitly in Swift Package Manager:

```swift
.package(url: "https://github.com/frankgumeta/DaVinci.git", exact: "2.0.0-rc.1")
```

See [Migrating from 1.4 to 2.0](Migration-2.0.md) for source-breaking changes,
including the raised iOS 18.0 deployment target.
