# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `DSBadge.Tone` and independent filled, subtle, and outlined badge appearances
- `OpacityTokens.subtleFill` and `subtleStroke` for consistent low-emphasis tinted surfaces
- Borderless ghost appearances for `DSButton` and `DSIconButton`

### Changed
- The pre-1.4 `DSBadge.Variant` and `variant:` API now forward compatibly to a filled semantic tone
- `DSButton.Appearance` and `DSIconButton.Appearance` are now the canonical visual-style names; `Variant` remains an alias

## [1.3.0] - 2026-08-09

> **Codex Forma**

### Added
- `DSSymbol`, a failable runtime-validated SF Symbol reference without a closed catalog
- Typed symbol overloads for buttons, segmented controls, remote-image placeholders, and text fields
- Reusable `DSTextField.Configuration` presets for filled and outlined appearances
- Leading symbols, trailing clear action, supporting/error messages, and grapheme-safe character limits
- RTL and accessibility-size Gallery scenarios and snapshot coverage for the new text-field layouts

### Changed
- Text-field state styling now resolves disabled, error, focused, and normal states consistently
- Focused errors retain the semantic error color while reinforcing the border
- Supporting text is exposed as an accessibility hint; errors and character progress are exposed in the value
- Disabled messages and counters use an attenuated semantic treatment
- Existing String-based symbol APIs and the v1.2 text-field initializer remain available

### Fixed
- Negative character limits are normalized safely instead of reaching `String.prefix(_:)`
- Initial and subsequent over-limit text is constrained without splitting extended grapheme clusters
- `DSTextField` snapshots once again compare committed references instead of recording unconditionally

### Migration
- Prefer `DSSymbol(systemName:)` and handle its optional result when adopting typed symbol overloads
- Existing v1.2 call sites require no source changes

## [1.2.0] - 2026-08-05

> **Codex Tutela**

### Added
- Reproducible per-product coverage reporting and CI thresholds for the core libraries
- Explicit semantic-versioning and compatibility-change policy
- Deduplicated `DSRemoteImage` pipeline with HTTP/MIME validation, off-main decoding, and payload limits
- Cost-limited 50 MB LRU cache for validated decoded images
- `DSImageLoading.cacheIdentity` scopes cached and in-flight image results per loader,
  so unrelated loaders requesting the same URL no longer share a payload
- `DSDefaultImageLoader(session:maximumPayloadBytes:cacheNamespace:)` exposes the
  transfer ceiling and explicit cache scoping, with a documented 20 MB default
- Tests covering loader isolation, custom cache identities, declared-length rejection,
  and mid-transfer abort for undeclared payloads
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
- README component and gallery inventories now match the current source tree
- Coverage claims now exclude test bundles and disclose the ungated gallery target
- Public DocC symbol links now match the current accessibility-aware initializers
- CI now verifies that API documentation builds without DocC diagnostics
- Reduced the supported deployment target from iOS 26 to the API-driven minimum, iOS 17
- Set the supported toolchain to Xcode 26.6 and Swift tools 6.3 with explicit Swift 6 language mode
- Swift 6 complete strict-concurrency checking is enforced without unsafe package flags
- Immutable skeleton multiplier tables are explicitly nonisolated under Swift 6.3
- Pure text-style mapping is explicitly nonisolated under Swift 6.3
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
- `DSDefaultImageLoader` enforces its payload ceiling *during* the transfer: a declared
  `Content-Length` above the limit is rejected from response metadata, and a response
  without a declared length is aborted as soon as the limit is exceeded
- Image caching and deduplication are keyed by URL, loader identity, and payload policy;
  distinct default-loader sessions are isolated automatically

### Fixed
- `DSRemoteImage` with a `nil` URL now renders its placeholder synchronously instead of
  briefly showing a shimmering skeleton, making the rendered output deterministic
- `DSRemoteImage` no longer announces "Image failed to load" when no URL was provided;
  it reports the documented "Placeholder image" label with no failure value

### Migration
- This release intentionally adopts Xcode 26.6 and Swift tools 6.3. Update
  development and CI environments before adopting it; the Swift language mode
  remains Swift 6.
- The minimum deployment target moves from iOS 26 down to iOS 17, expanding the
  supported device range.
- Existing `DSImageLoading` conformers remain source-compatible through default
  implementations. Override `cacheIdentity` and `maximumPayloadBytes` when a custom
  loader has user-, tenant-, session-, or policy-specific behavior.
- Existing `DSTextStyle` initializer calls remain source-compatible; pass `relativeTo`
  explicitly for custom styles that should follow a semantic Dynamic Type curve.

### Removed
- Unrelated template MCP notes server from the `github/` directory
- Per-release `RELEASE_1.1.0.md` report, superseded by `CHANGELOG.md`,
  `README.md`, and `Docs/Compatibility.md`

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
- **Core-library coverage measurements** (test targets excluded from the claim)
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
