# Contributing to DaVinci Design System

Thank you for your interest in contributing to DaVinci! This document provides guidelines and instructions for contributing.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)

## Code of Conduct

Be respectful, inclusive, and collaborative. We aim to maintain a welcoming environment for all contributors.

## Getting Started

### Prerequisites
- Xcode 26.6
- Swift tools 6.3
- Swift language mode 6 with complete strict concurrency
- iOS 17.0+ (iOS-only package)

See [Docs/Compatibility.md](Docs/Compatibility.md) for the compatibility matrix
and the distinction between toolchain, SDK, and deployment requirements.

### Setup

1. Clone the repository:
```bash
git clone https://github.com/frankgumeta/DaVinci.git
cd DaVinci
```

2. Open the package in Xcode:
```bash
open Package.swift
```

3. Build and test:
```bash
xcodebuild build \
  -scheme DaVinci-Package \
  -destination 'generic/platform=iOS Simulator' \
  IPHONEOS_DEPLOYMENT_TARGET=17.0

SIMULATOR_UDID="$(bash .github/scripts/create-ios-simulator.sh)"

xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID"
```

DaVinci intentionally supports iOS only. Plain `swift test` attempts a host build
and is not a supported validation command for this package.

## Development Workflow

### Branch Naming Convention
- `feature/component-name` - New components or features
- `fix/issue-description` - Bug fixes
- `docs/what-changed` - Documentation updates
- `refactor/what-changed` - Code refactoring
- `test/what-added` - Test additions

### Making Changes

1. Create a new branch from `main`:
```bash
git checkout -b feature/your-feature-name
```

2. Make your changes following our [Coding Standards](#coding-standards)

3. Add tests for your changes

4. Run tests locally:
```bash
SIMULATOR_UDID="$(bash .github/scripts/create-ios-simulator.sh)"
xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID"
```

5. Update documentation if needed

6. Commit your changes with a descriptive message:
```bash
git commit -m "feat: add DSCheckbox component with checked/unchecked states"
```

### Commit Message Format

Follow conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `test:` - Adding or updating tests
- `refactor:` - Code refactoring
- `style:` - Code style changes (formatting)
- `chore:` - Maintenance tasks

## Pull Request Process

1. Update the README.md with details of changes if applicable
2. Update the CHANGELOG.md under `[Unreleased]`
3. Ensure all tests pass
4. Request review from maintainers
5. Address review feedback
6. Once approved, a maintainer will merge your PR

### PR Checklist
- [ ] Tests added/updated and passing
- [ ] Documentation updated (README, DocC comments)
- [ ] CHANGELOG.md updated
- [ ] No breaking changes (or documented if necessary)
- [ ] Code follows project style guidelines
- [ ] All previews work correctly

## Coding Standards

### Swift Style
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use Swift 6 strict concurrency (`Sendable` types where appropriate)
- Make tokens immutable (`public let` for token values)
- Use semantic naming over implementation details

### SwiftLint Enforcement

**Install SwiftLint**:
```bash
brew install swiftlint
```

**For DaVinci development** (this Swift Package):

Since Swift Packages don't support build phases, use one of these approaches:

1. **Manual check before committing** (recommended):
   ```bash
   swiftlint lint --strict
   ```

2. **Git pre-commit hook** (automatic):
   ```bash
   # Setup once
   cat > .git/hooks/pre-commit << 'EOF'
   #!/bin/bash
   if command -v swiftlint >/dev/null 2>&1; then
       swiftlint lint --strict
       if [ $? -ne 0 ]; then
           echo "❌ SwiftLint violations detected. Fix them before committing."
           exit 1
       fi
   fi
   EOF
   chmod +x .git/hooks/pre-commit
   ```

3. **CI enforcement** (already configured):
   - CI runs SwiftLint on every push/PR
   - Violations will fail the build

**For apps using DaVinci as dependency**:

Add a Run Script Phase to your app target:
- Build Phases → + → New Run Script Phase
- Name: "SwiftLint"
- Script:
  ```bash
  if command -v swiftlint >/dev/null 2>&1; then
      swiftlint lint --strict
  else
      echo "warning: SwiftLint not installed"
  fi
  ```
- Drag before "Compile Sources"

### Token Guidelines
- All tokens must be immutable and `Sendable`
- Token values must be testable and documented
- Scales must be ascending and consistent
- Default values must work in both light and dark modes

### Component Guidelines
- All components must read from `@Environment(\.dsTheme)`
- Support all theme variants (light/dark)
- Include comprehensive previews
- Add accessibility labels where appropriate
- Support loading and disabled states
- Document all public APIs with DocC comments

### File Organization
```
Sources/
  DaVinciTokens/        # Token definitions only
  DaVinciComponents/    # Reusable components
  DaVinciGallery/       # Visual gallery screens
  DaVinciDemo/          # Demo app
Tests/
  DaVinciTokensTests/   # Token validation tests
  DaVinciComponentsTests/ # Component behavior tests
```

## Testing Guidelines

### Required Tests
1. **Token Tests**: Validate token values, scales, and rendered typography behavior
2. **Component Tests**: Test instantiation, states, and behavior
3. **Snapshot Tests**: Pixel-based visual regression tests for UI consistency
4. **Integration Tests**: Test component composition
5. **Accessibility Tests**: Validate semantic contracts, contrast, touch targets, and the manual assistive-technology matrix

### Test Structure
```swift
@Suite("ComponentName")
struct ComponentNameTests {
    @Test func descriptiveTestName() {
        // Arrange
        let component = DSButton("Test") {}
        
        // Act & Assert
        #expect(component != nil)
    }
}
```

### Running Tests
```bash
SIMULATOR_UDID="$(bash .github/scripts/create-ios-simulator.sh)"

# Run all tests
xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID"

# Record new snapshots (when UI changes are intentional)
RECORD_SNAPSHOTS=1 xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID"

# Run with verbose output
xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID" \
  -verbose
```

### Product Coverage

CI measures production targets only and does not combine test-bundle lines into an
aggregate percentage. `DaVinciTokens` must remain at 100% and
`DaVinciComponents` at or above 95%. `DaVinciGallery` is reported transparently
but is not yet gated.

```bash
RESULT_BUNDLE=".build/TestResults-$(date +%s).xcresult"

xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID" \
  -enableCodeCoverage YES \
  -resultBundlePath "$RESULT_BUNDLE" \
  -derivedDataPath .build

python3 .github/scripts/check-code-coverage.py \
  "$RESULT_BUNDLE" \
  --minimum DaVinciTokens=100 \
  --minimum DaVinciComponents=95 \
  --output coverage.md
```

### Snapshot Testing Guidelines
- Snapshots are stored in `Tests/DaVinciComponentsTests/__Snapshots__/`
- Each component has snapshots for light and dark modes
- A missing reference is a test failure; snapshots are never recorded implicitly
- When intentionally changing UI, run with `RECORD_SNAPSHOTS=1` to update references
- Recording mode rewrites every snapshot exercised by the selected test run
- Review the changed PNG files visually before committing them
- Use the repository simulator helper with Xcode 26.6, matching CI
- Failure artifacts are written under `.build/snapshot-failures/`, which is ignored by Git
- CI uploads failure artifacts for 14 days as `snapshot-failures`
- Ensure snapshots render consistently on the helper-created simulator

The in-repository comparator normalizes images to RGBA8. Per-channel differences up
to `2/255` are treated as antialiasing noise. A comparison passes only when no more
than 0.5% of pixels exceed that threshold and the normalized mean channel difference
is no more than 0.1%. These thresholds allow small renderer variance while detecting
localized and broad visual changes. A failure produces expected, received, and diff
PNGs; changed pixels are highlighted in the diff.

For deterministic output, the helper fixes 2x scale, `en_US_POSIX`, UTC,
left-to-right layout, Dynamic Type `.large`, the theme, and color scheme. Device and
SDK rendering still matter, so baseline approval must use the same simulator and
Xcode configuration as CI.

#### Snapshot Testing Troubleshooting

**Snapshots failing after intentional UI changes?**
```bash
# Re-record snapshots with your changes
RECORD_SNAPSHOTS=1 xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID"
```

After recording, inspect `git diff --stat` and every changed PNG. A green test run in
recording mode means the files were written successfully; it does not approve their
visual result.

Some Xcode/simulator combinations do not propagate the shell's
`RECORD_SNAPSHOTS` variable to XCTest. Confirm that the output contains
`Recorded snapshot:` lines. If it does not, temporarily pass `record: true` only
in the owning snapshot suite, run that suite, and revert the flag before the final
comparison run. Never commit a hard-coded recording flag.

**Snapshots differ slightly between machines?**
- Create the simulator with `.github/scripts/create-ios-simulator.sh`, as CI does
- Check Xcode version matches CI (26.6)
- Verify simulator is clean: `xcrun simctl erase all`
- Font rendering can vary - ensure system fonts are up to date

**Snapshot test passes locally but fails in CI?**
- Check that local Xcode and the installed iOS runtime match CI
- Reproduce with a simulator created by the repository helper
- Verify `__Snapshots__/` directory is committed to git
- Download the `snapshot-failures` artifact and compare expected, received, and diff

**Need to update a single snapshot?**
- Run only the owning snapshot test from Xcode with `RECORD_SNAPSHOTS=1`
- Do not delete the reference first; missing references intentionally fail outside recording mode

## Documentation

### DocC Comments
All public APIs must have documentation comments:

```swift
/// A themed button component with multiple variants and states.
///
/// Use `DSButton` to create buttons that automatically adapt to your theme:
///
/// ```swift
/// DSButton("Submit", variant: .primary) {
///     submitForm()
/// }
/// ```
///
/// ## Topics
/// ### Creating Buttons
/// - ``init(_:variant:icon:isLoading:isDisabled:accessibilityLabel:accessibilityHint:action:)``
///
/// ### Variants
/// - ``Variant``
///
/// - Parameters:
///   - title: The button's text label
///   - variant: Visual style (`.primary`, `.secondary`, `.outline`)
///   - action: Closure to execute when tapped
public struct DSButton: View { ... }
```

Validate symbol links and generated API documentation before opening a PR:

```bash
xcodebuild docbuild \
  -scheme DaVinci-Package \
  -destination 'generic/platform=iOS Simulator'
```

### Preview Requirements
Each component must include:
- Basic usage preview
- All variant previews
- State previews (loading, disabled)
- Dark mode preview

### README Updates
When adding significant features, update the README:
- Add to component list
- Update architecture diagram if needed
- Add usage examples

## Versioning Policy

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes
- **MINOR** (0.X.0): New features, backwards compatible
- **PATCH** (0.0.X): Bug fixes, backwards compatible

### Breaking Changes
Breaking changes require:
1. Major version bump
2. Migration guide in CHANGELOG
3. Deprecation warnings in previous minor version (if possible)
4. Clear documentation of the change

Examples of breaking changes:
- Removing public APIs
- Changing function signatures
- Renaming token values
- Changing default token values that affect visual appearance

### Non-Breaking Changes
These can be added in minor versions:
- New components
- New token values
- New optional parameters with defaults
- New convenience initializers
- Performance improvements
- Bug fixes

## Questions?

If you have questions, please:
1. Check existing issues and discussions
2. Review the documentation
3. Ask in discussions or create an issue

Thank you for contributing to DaVinci! 🎨
