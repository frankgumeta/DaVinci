# DaVinci 2.0.0 release notes

DaVinci 2.0 is the first stable line after the 1.4 pre-adoption exception. It
requires Xcode 27.0, Swift tools 6.4, Swift 6 language mode, and sets iOS 18.0
as the deployment target. CI uses the iOS 27 SDK for current visual validation.

## Highlights

- New title, label, body-adjacent, digit, surface, list-row, action-row, selection,
  activity-indicator, and button-size APIs.
- Attributed text preserves inline formatting and links.
- Components include accessibility contracts, localized announcements, dark-mode
  themes, and Dynamic Type coverage.
- SwiftLint, DocC diagnostics, product coverage, API baseline, performance,
  snapshots, and external-consumer checks are release gates.

## Migration

See [Migrating from 1.4 to 2.0](Migration-2.0.md). In particular, replace the
removed `title` typography role, update button and symbol initializers, and review
button/card snapshots for the intentional rendering changes.

## Compatibility and support

The 1.4.x branch remains the LTS line. DaVinci 2.0.x accepts compatible fixes only;
new compatible APIs belong in 2.1, and source-breaking changes wait for 3.0.
