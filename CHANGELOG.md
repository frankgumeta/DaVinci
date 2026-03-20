# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
