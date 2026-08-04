# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Deduplicated `DSRemoteImage` pipeline with HTTP/MIME validation, off-main decoding, and payload limits
- Cost-limited 50 MB LRU cache for validated decoded images
- Shared, testable accessibility contracts for labels, values, hints, traits, enabled state, and grouping
- Automated contrast coverage for default and alternate themes in light and dark modes
- Rendered 44pt minimum-target checks for primary interactive controls
- Decorative-image support through `DSRemoteImage(isDecorative:)`
- Semantic Dynamic Type mapping for every typography role
- Scaled line-height support through the `dsTextStyle(_:family:)` modifier
- AX3 typography and control examples in DaVinciGallery
- Rendering tests for Dynamic Type, line height, and custom font weights
- Pixel-level RGBA snapshot comparison with explicit, documented tolerances
- Expected, received, and visual diff artifacts for snapshot failures
- CI upload of snapshot failure artifacts
- Unit tests covering the snapshot comparator and missing-reference contract

### Changed
- Reduced the supported deployment target from iOS 26 to the API-driven minimum, iOS 17
- Set the supported toolchain to Xcode 26.6 and Swift tools 6.3 with explicit Swift 6 language mode
- Swift 6 complete strict-concurrency checking is enforced without unsafe package flags
- Immutable skeleton multiplier tables are explicitly nonisolated under Swift 6.3
- CI now pins macOS 26 and Xcode 26.6, builds for iOS 17, and tests on the latest available iOS runtime
- CI and release workflows dynamically create a compatible simulator instead of requiring a preinstalled device name
- Documented the iOS-only SwiftPM workflow and compatibility matrix
- `DSRemoteImage` reaches success and cache only after image decoding succeeds
- Failed and cancelled image consumers no longer publish stale success states
- Loading buttons and images now expose explicit accessibility values and traits
- Text fields preserve entered content when announcing validation errors
- Badges and brand-filled controls choose the highest-contrast semantic foreground
- Tertiary text and interactive outlines use stronger contrast
- Text-bearing components now preserve custom font weights and wrap at accessibility sizes
- Custom typography examples now declare their semantic `relativeTo` text style
- Missing snapshot references now fail unless `RECORD_SNAPSHOTS=1` is explicitly set
- Snapshot rendering now fixes locale, time zone, layout direction, Dynamic Type size, and scale

---

## [1.1.0] - 2026-03-20

### Added
- **DSSwitch**: Themed toggle switch component with label support, disabled state, and accessibility
- **DSProgressBar**: Linear progress bar with determinate and indeterminate states, size variants, and reduce motion support
- **DSDivider**: Horizontal and vertical divider with regular and hairline styles
- **DSBadge**: Badge component with multiple variants (brand, success, warning, error, neutral) and sizes (small, medium, large)
- **DSSegmentedControl**: Segmented picker with support for text labels and SF Symbol icons
- **DSRemoteImage**: Async image loader with skeleton loading, placeholder support, and automatic caching
- **DSSkeleton**: Skeleton loading components (DSSkeletonBlock, DSSkeletonRow, DSSkeletonCard, DSSkeletonList) with shimmer animation
- **DSShimmering**: View modifier for shimmer loading effects with reduce motion support
- All new components added to DaVinciGallery for visual verification
- **Comprehensive test coverage**: >95% code coverage across all targets
  - DaVinciTokens: 100% coverage
  - DaVinciComponents: >92% coverage
- **Behavioral tests**: 180+ tests covering component logic, state management, accessibility, and theme integration
- **Snapshot tests**: 80+ visual regression tests covering all component variants in light and dark modes
- Internal static helper methods for testable pure functions (DSBadge color mapping, DSText style mapping)

### Changed
- **Test infrastructure improvements**: Eliminated Environment access warnings by extracting pure mapping logic to internal static helpers
- Auto-record missing snapshots on first run (no manual RECORD_SNAPSHOTS flag needed for initial recording)
- Improved snapshot test reliability with deterministic rendering

### Removed
- **Breaking**: Removed deprecated `DSBadge.Variant.default` (use `.brand` instead)

---

## [1.0.1] - 2025-03-19

### Added
- Merge conflict validation job in CI workflow
- Git pre-commit hook instructions for automatic SwiftLint enforcement
- Comprehensive SwiftLint setup documentation for Swift Packages in CONTRIBUTING.md

### Fixed
- Corrected iOS version inconsistency between README (iOS 18+) and Package.swift (iOS 26+)
- Updated repository URLs from placeholder to actual GitHub repository
- Fixed SwiftLint configuration (removed invalid rules, resolved conflicts)
- Fixed all SwiftLint violations (11 violations → 0)

### Changed
- CI now installs and runs SwiftLint as mandatory step
- SwiftLint file_length limits adjusted to 650/800 for comprehensive test files

### Documentation
- Added explanation for iOS 26+ requirement in README
- Improved snapshot testing troubleshooting documentation
- Added SwiftLint Xcode integration guide

---

## [1.0.0] - 2025-03-19

### Added
- Initial design system implementation
- DaVinciTokens: Complete token system with colors, typography, spacing, radius, elevation, motion, opacity, control heights, and stroke tokens
- DaVinciComponents: Core components (DSButton, DSIconButton, DSText, DSCard, DSTextField, DSRemoteImage, DSSkeleton with variants)
- DaVinciGallery: Interactive visual gallery for tokens and components
- DaVinciDemo: Executable demo application
- Swift 6 strict concurrency support
- Dark mode support with optimized palettes
- Comprehensive token tests (432 test cases)
- **Snapshot testing system** (34 visual regression tests) for components in light/dark modes
- **Accessibility tests** for all interactive components
- SwiftUI environment-based theming system
- In-memory image caching for DSRemoteImage
- Shimmer loading animations for skeleton states
- CI/CD workflow with automated testing on iOS Simulator
- MIT License

### Changed
- **Platform support limited to iOS 26+ only** (removed macOS support for focused development)
- Test execution now uses `xcodebuild test` on iOS Simulator instead of `swift test`
- CI workflow updated to Node.js 24 for future compatibility
- Codecov integration updated to v4
- All test `@State` bindings replaced with `Binding.constant()` to eliminate warnings

### Fixed
- CI warnings about unhandled snapshot PNG files (declared as test resources)
- Node.js 20 deprecation warnings in GitHub Actions
- State access warnings in test files
- CI builds now correctly target iOS Simulator

### Removed
- macOS platform support (Package.swift now iOS-only)
- Documentation generation job from CI (command not available)

---

## Release Notes Template

For future releases, use this structure:

## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Vulnerability fixes
