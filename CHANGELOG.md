# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
