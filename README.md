# DaVinci Design System

<div align="center">

![DaVinci Framework Icon](assets/davinci-framework-icon.svg)

[![Swift](https://img.shields.io/badge/Swift-6.3-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CI](https://github.com/frankgumeta/DaVinci/actions/workflows/ci.yml/badge.svg)](https://github.com/frankgumeta/DaVinci/actions/workflows/ci.yml)

</div>

A Swift Package providing a modular design system for iOS 17+, built entirely with SwiftUI and Swift 6 strict concurrency.

DaVinci requires iOS 17 because its accessibility contracts use the toggle trait
introduced in that release. Swift 6 strict concurrency is a compiler and language
requirement; it does not require a matching iOS deployment target. See the
[compatibility matrix](Docs/Compatibility.md) for the supported toolchain and test
strategy.

## Features

- 🎨 **Complete Token System**: Colors, typography, spacing, radius, elevation, motion, and more
- 🧩 **Reusable Components**: Buttons, cards, text fields, images, skeletons
- 🌓 **Dark Mode Native**: Optimized palettes for light and dark themes
- 🔒 **Type-Safe**: Swift 6 strict concurrency with `Sendable` types
- 🎭 **Themeable**: Custom themes via SwiftUI environment
- ✅ **Tested**: CI-gated core-library coverage plus behavioral, snapshot, and accessibility contracts
- 📱 **Live Preview**: Interactive gallery for visual verification

## Installation

### Swift Package Manager

Add DaVinci to your project using Xcode:

1. Open your project in Xcode
2. Select **File** → **Add Package Dependencies...**
3. Enter the repository URL (or local path for development)
4. Select the package products you need:
   - `DaVinciTokens` - Token system only
   - `DaVinciComponents` - Components (includes Tokens)
   - `DaVinciGallery` - Visual gallery (includes Tokens + Components)

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/frankgumeta/DaVinci.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "DaVinciComponents", package: "DaVinci")
        ]
    )
]
```

## Quick Start

### 1. Import and Apply Theme

```swift
import SwiftUI
import DaVinciTokens
import DaVinciComponents

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dsTheme(.defaultTheme) // Apply theme to entire app
        }
    }
}
```

### 2. Use Components

```swift
import SwiftUI
import DaVinciComponents

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            DSText("Welcome to DaVinci", role: .title)
            DSText("A modern design system", role: .body)
            
            DSButton("Get Started", appearance: .primary) {
                print("Button tapped!")
            }
        }
        .padding()
    }
}
```

### 3. Custom Theming

```swift
import DaVinciTokens

// Create a custom theme
let customTheme = DSTheme(
    name: "custom",
    colors: DSColors(
        brand: BrandColors(
            primary: .purple,
            secondary: .blue,
            tertiary: .indigo
        )
    )
)

// Apply it
ContentView()
    .dsTheme(customTheme)
```

## Usage Examples

### Buttons

```swift
// Primary button
DSButton("Submit", appearance: .primary) {
    submitForm()
}

// With icon (validated DSSymbol)
let plus = DSSymbol(systemName: "plus")!
DSButton("Add Item", appearance: .secondary, icon: .leading(plus)) {
    addItem()
}

// Loading state
DSButton("Saving...", appearance: .primary, isLoading: true) {
    // Action disabled during loading
}

// Icon-only button
let gear = DSSymbol(systemName: "gear")!
DSIconButton(
    symbol: gear,
    titleForAccessibility: "Settings",
    appearance: .ghost
) {
    openSettings()
}
```

### Text Fields

`DSTextField` keeps the v1.2 filled appearance by default and adds reusable
configurations for outlined and underlined fields, validated leading symbols, clear actions,
supporting or error messages, and character limits.

```swift
let searchConfiguration: DSTextField.Configuration = .outlined
    .labelVisibility(.hidden)
    .trailing(.clear)
    .message(.supporting("Search by title or author"))
    .characterLimit(80)

if let search = DSSymbol(systemName: "magnifyingglass") {
    DSTextField(
        "Search",
        text: $query,
        prompt: "Search…",
        configuration: searchConfiguration.leading(search)
    )
}
```

Use `.underlined` for a transparent field with state-aware emphasis along its
bottom edge only.

Supporting text is announced as an accessibility hint. Errors and character
progress are included in the field's accessibility value. Character limits
truncate by Swift `Character`, preserving extended grapheme clusters.

Errors are configured through the same typed initializer:

```swift
DSTextField(
    "Email",
    text: $email,
    configuration: .filled.message(.error("Invalid email address"))
)
```

### Cards

```swift
DSCard(style: .standard) {
    VStack(alignment: .leading, spacing: 8) {
        DSText("Card Title", role: .headline)
        DSText("Card content goes here", role: .body)
    }
}
```

### Remote Images

```swift
DSRemoteImage(
    url: URL(string: "https://example.com/image.jpg"),
    geometry: .rounded(
        size: CGSize(width: 120, height: 80),
        cornerRadius: RadiusTokens.large
    ),
    contentMode: .fill
)

DSRemoteImage(
    url: avatarURL,
    geometry: .circle(diameter: 80),
    accessibilityLabel: "User avatar"
)
```

### Skeleton Loading

```swift
// Single skeleton row
DSSkeletonRow(showLeading: true, showTrailing: false)

// Full skeleton list
DSSkeletonList(count: 5, showLeading: true, isShimmering: true)

// Skeleton card
DSSkeletonCard(showFooter: true)
```

### Using Tokens Directly

```swift
VStack(spacing: SpacingTokens.space4) {
    Text("Custom View")
        .foregroundColor(theme.colors.semantic.textPrimary)
        .dsTextStyle(theme.typography.headline, family: theme.typography.family)
}
.padding(SpacingTokens.space5)
.background(theme.colors.semantic.surfacePrimary)
.cornerRadius(RadiusTokens.medium)
```

## Targets

### DaVinciTokens

The foundational layer of the design system. Contains **immutable, value-driven, testable tokens** with no dependency on components.

| File | Purpose |
|---|---|
| `DSColors` | GrayScale primitives, SemanticColors, BrandColors, AccentColors, FeedbackColors, TextEmphasisColors, DSColors |
| `DSTypography` | Semantic Dynamic Type roles, font families, weights, and scaled line-height support |
| `DSSpacing` | Consistent spacing scale from 2pt to 64pt |
| `DSRadius` | Corner radius scale (`extraSmall` through `large`) |
| `DSElevation` | Shadow parameters (`none`, `small`, `medium`) |
| `DSMotion` | Animation duration and curve tokens (`fast`, `normal`, `slow`) |
| `DSOpacity` | Interaction and surface opacity tokens (`disabled`, `pressed`, `scrim`, `subtleFill`, `subtleStroke`) |
| `DSControlHeight` | Control height scale (`small`, `medium`, `large`) |
| `DSStroke` | Stroke width tokens |
| `DSTheme` | Root theme container with SwiftUI `EnvironmentValues` integration |

**Import:** `import DaVinciTokens`

### DaVinciComponents

Reusable SwiftUI components that consume tokens from `DaVinciTokens`.

| Component | Description |
|---|---|
| `DSButton` | Themed button with primary, secondary, outline, and ghost appearances, icons, loading, and disabled states |
| `DSIconButton` | Icon-only button with aligned appearances, size, loading, and disabled support |
| `DSText` | Semantic text component mapping roles (`.display`, `.title`, `.headline`, `.body`, `.callout`, `.caption`, `.overline`) to typography tokens |
| `DSCard` | Compact, standard, prominent, and outlined surface containers |
| `DSTextField` | Themed text field with label and prompt |
| `DSSwitch` | Themed toggle with label, disabled state, and accessibility value |
| `DSSegmentedControl` | Text or icon segments with filled and subtle appearances |
| `DSProgressBar` | Continuous, stepped, striped, and shimmer progress in three sizes |
| `DSBadge` | Text and dot badges with independent semantic tones, visual appearances, and sizes |
| `DSDivider` | Horizontal or vertical semantic divider |
| `DSRemoteImage` | Validated remote loading with rectangle, rounded, and circle geometry |
| `DSSkeletonBlock`, `DSSkeletonRow`, `DSSkeletonCard`, `DSSkeletonList` | Loading placeholders with optional shimmer |
| `dsShimmering(_:)` | Reduce-Motion-aware shimmer modifier |
| `DSPressableButtonStyle` | Shared `ButtonStyle` applying `OpacityTokens.pressed` with configurable duration |

**Import:** `import DaVinciComponents`

**Depends on:** `DaVinciTokens`

### DaVinciGallery

Interactive gallery screens for visual verification of all tokens and components. Includes a theme switcher (default / alternate).

| Screen | Purpose |
|---|---|
| `GalleryHomeScreen` | Navigation hub with theme picker |
| `ColorGalleryScreen` | Semantic, brand, accent, and feedback color swatches |
| `TypographyGalleryScreen` | Type scale preview |
| `LayoutGalleryScreen` | Spacing and radius demos |
| `EffectsGalleryScreen` | Elevation shadow demos |
| `ComponentsListScreen` | Navigation to text, controls, feedback, and structure galleries |
| `SkeletonGalleryScreen` | Skeleton block, row, card, and list examples |

**Import:** `import DaVinciGallery`

**Depends on:** `DaVinciTokens`, `DaVinciComponents`

### DaVinciDemo

Executable app target that hosts the gallery. Useful for visual verification during development.

**Depends on:** `DaVinciTokens`, `DaVinciComponents`, `DaVinciGallery`

## Architecture

```
DaVinciTokens          (no dependencies)
       ↑
DaVinciComponents      (depends on Tokens)
       ↑
DaVinciGallery         (depends on Tokens + Components)
       ↑
DaVinciDemo            (depends on all)
```

- **All token structs are immutable** (`public let`) and `Sendable` — safe to use from any isolation context.
- **`DSTheme`** is injected via the `.dsTheme` SwiftUI environment value.
- **Swift 6 strict concurrency** is enforced across all targets (`swift-tools-version: 6.3`, language mode 6).
- **No `Equatable` on Color-containing types** — structs with `SwiftUI.Color` fields omit `Equatable` to avoid unstable equality.

## Testing

Run the test suite to validate tokens and components:

```bash
# Create and boot an iPhone using the latest installed iOS runtime
SIMULATOR_UDID="$(bash .github/scripts/create-ios-simulator.sh)"

# Run all tests on that simulator
xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID"

# Run with verbose output
xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID" \
  -verbose
```

The package is iOS-only, so plain `swift test` is not a supported validation
command. CI also compiles all products with an iOS 17 deployment target against
the current SDK:

```bash
xcodebuild build \
  -scheme DaVinci-Package \
  -destination 'generic/platform=iOS Simulator' \
  IPHONEOS_DEPLOYMENT_TARGET=17.0
```

### Test Coverage

Coverage is reported only for production targets; test bundles are deliberately
excluded from the metric. With Xcode 26.6, the current reproducible line coverage is:

| Product target | Covered lines | Executable lines | Coverage | CI policy |
|---|---:|---:|---:|---|
| `DaVinciTokens` | 238 | 238 | 100.00% | Minimum 100% |
| `DaVinciComponents` | 2866 | 2995 | 95.69% | Minimum 95% |
| `DaVinciGallery` | 0 | 5827 | 0.00% | Reported, not currently gated |

There is no aggregate “overall” claim: including test targets would inflate it,
while including the currently unexercised gallery would conceal the actual gap.

**DaVinciTokens** coverage includes:
- Token scale ordering (spacing, radius, font sizes, control heights are ascending)
- Token value correctness (semantic defaults, opacity, motion, stroke)
- Semantic color default mappings
- TextEmphasis derivation from brand and feedback colors
- Theme override propagation
- Dark mode palette resolution

**DaVinciComponents** coverage includes:
- **Behavioral tests**: Component logic, state management, accessibility label resolution, theme integration
- **Snapshot tests**: Visual regression coverage for all component variants in light/dark modes
- **Accessibility tests**: Semantic contracts, contrast pairs, touch targets, and manual VoiceOver checklist

To reproduce the CI coverage run and enforce the same thresholds:

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

### Snapshot Testing

Visual regression tests normalize reference and received images to RGBA8 and compare
their pixels. Missing references fail by default; recording is always explicit.

```bash
# Record new snapshots
RECORD_SNAPSHOTS=1 xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID"

# Compare against references (default)
xcodebuild test \
  -scheme DaVinci-Package \
  -destination "platform=iOS Simulator,id=$SIMULATOR_UDID"
```

Snapshots are stored in `Tests/DaVinciComponentsTests/__Snapshots__/` and cover all component variants in light and dark modes.

The comparator treats channel deltas up to `2/255` as rendering noise and accepts at
most 0.5% differing pixels with a 0.1% normalized mean channel difference. When a
comparison fails, expected, received, and visual diff images are written to
`.build/snapshot-failures/`. CI uploads that directory as the `snapshot-failures`
artifact on failed runs.

Snapshot rendering fixes the canvas size, 2x scale, `en_US_POSIX` locale, UTC time
zone, theme, and color scheme. Layout defaults to left-to-right and Dynamic Type
`.large`; individual tests can override both for RTL and accessibility-size
baselines. Use the repository simulator helper and Xcode 26.6, matching CI, when
approving baselines.

## Best Practices

### Theme Management

Always inject the theme at the app root level:

```swift
@main
struct YourApp: App {
    @State private var currentTheme = DSTheme.defaultTheme
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dsTheme(currentTheme) // Single source of truth
        }
    }
}
```

### Using Tokens vs Components

**Use components when possible:**
```swift
// ✅ Preferred
DSButton("Submit", appearance: .primary) { }

// ❌ Avoid rebuilding components
Button("Submit") { }
    .padding(.horizontal, SpacingTokens.space5)
    .background(theme.colors.brand.primary)
    // ... manual styling
```

**Use tokens for custom views:**
```swift
// ✅ Good - custom layout with tokens
VStack(spacing: SpacingTokens.space4) {
    CustomHeader()
        .foregroundColor(theme.colors.semantic.textPrimary)
}
.padding(SpacingTokens.space5)
```

### Accessibility

Components provide testable accessibility semantics and are designed with WCAG 2.1
Level AA criteria in mind. This is not a certification; VoiceOver focus order,
announcements, and keyboard navigation still require manual validation in the host app.

```swift
// Icon buttons require accessibility labels
let trash = DSSymbol(systemName: "trash")!
DSIconButton(
    symbol: trash,
    titleForAccessibility: "Delete item", // VoiceOver reads this
    appearance: .secondary
) { deleteItem() }

// Remote images support custom labels
DSRemoteImage(
    url: avatarURL,
    geometry: .circle(diameter: 80),
    accessibilityLabel: "User profile picture"
)

// Decorative images are removed from the accessibility tree
DSRemoteImage(
    url: backgroundURL,
    geometry: .rectangle(size: CGSize(width: 120, height: 80)),
    isDecorative: true
)
```

**Key Features:**
- ✅ Automated 4.5:1 text and 3:1 interactive-outline checks for documented pairs
- ✅ Dynamic Type support
- ✅ Labels, values, hints, traits, grouping, and loading/disabled contracts
- ✅ Reduce Motion respected
- ✅ Minimum 44pt touch targets

For complete accessibility guidelines, color contrast ratios, and testing procedures, see [ACCESSIBILITY.md](ACCESSIBILITY.md).

### Performance

**DSRemoteImage** uses a shared validated image pipeline:
```swift
// First load: fetches from network
DSRemoteImage(url: imageURL, geometry: .circle(diameter: 100))

// Subsequent loads: instant from cache
DSRemoteImage(url: imageURL, geometry: .circle(diameter: 100))
```

Concurrent requests for the same URL and loader share one load. The default loader
accepts successful HTTP responses with supported image MIME types; payloads must also
decode as images before reaching success or the cache. Decoding runs away from the main
actor, payloads are limited to 20 MB and 40 megapixels, and the shared decoded-image
LRU cache has a 50 MB cost budget. Failed requests are not cached, so recreating the
view or changing its URL can retry them.

The default 20 MB ceiling is enforced during the transfer, not after it: a declared
`Content-Length` above the limit is rejected from the response metadata, and a response
without a declared length is aborted as soon as the limit is exceeded. Override it with
`DSDefaultImageLoader(maximumPayloadBytes:)`.

Caching and deduplication are scoped by URL, loader identity, and payload limit. The
default loader isolates distinct `URLSession` instances automatically. Use
`cacheNamespace` when credentials can change within one session or when equivalent
sessions should intentionally share cached results. A custom loader that returns
different bytes for the same URL should override `cacheIdentity`:

```swift
struct AuthenticatedImageLoader: DSImageLoading {
    let userID: String

    var cacheIdentity: String { "authenticated-\(userID)" }

    func loadImageData(from url: URL) async throws -> Data { /* ... */ }
}
```

## Documentation

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines, coding standards, and development workflow
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[ACCESSIBILITY.md](ACCESSIBILITY.md)** - Accessibility guarantees, limitations, and testing procedures
- **[Docs/Compatibility.md](Docs/Compatibility.md)** - Supported toolchain, platform, and CI matrix
- **[Docs/Usage.md](Docs/Usage.md)** - Component composition and usage patterns
- **[Docs/Theming.md](Docs/Theming.md)** - Theme and token customization
- **[Docs/Versioning.md](Docs/Versioning.md)** - Compatibility and semantic-versioning policy

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Development workflow and branch naming
- Coding standards and best practices
- Testing requirements and coverage
- Pull request process
- Semantic versioning policy

## License

DaVinci is available under the MIT license. See [LICENSE](LICENSE) for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.
