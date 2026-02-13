# Theming Guide

DaVinci provides a powerful theming system that allows you to customize the visual appearance of all components while maintaining consistency and accessibility.

## Table of Contents
- [Core Concepts](#core-concepts)
- [Using the Default Theme](#using-the-default-theme)
- [Creating Custom Themes](#creating-custom-themes)
- [Color System](#color-system)
- [Typography Customization](#typography-customization)
- [Motion Customization](#motion-customization)
- [Best Practices](#best-practices)

---

## Core Concepts

### DSTheme

`DSTheme` is the central configuration object that defines:
- **Palette**: Raw color values for light and dark modes
- **Colors**: Semantic color mappings (automatically resolved from palette)
- **Typography**: Font family, sizes, weights, and line heights
- **Motion**: Animation durations and timing

### Theme Injection

Themes are injected into the SwiftUI environment and automatically propagate to all child views:

```swift
ContentView()
    .dsTheme(.defaultTheme)
```

All DaVinci components read theme values via `@Environment(\.dsTheme)`:

```swift
@Environment(\.dsTheme) private var theme
// Access: theme.colors.brand.primary
```

---

## Using the Default Theme

The default theme provides a complete, production-ready design system:

```swift
import SwiftUI
import DaVinciTokens

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dsTheme(.defaultTheme)
        }
    }
}
```

### Automatic Dark Mode

The theme automatically adapts to the system color scheme:

```swift
// Light mode: uses palette.light
// Dark mode: uses palette.dark

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dsTheme) var theme
    
    var body: some View {
        Text("Hello")
            .foregroundStyle(theme.colors.semantic.textPrimary)
        // Automatically white in dark mode, black in light mode
    }
}
```

---

## Creating Custom Themes

### Step 1: Define Your Brand Palette

Create a custom `DSPalette` with your brand colors:

```swift
import DaVinciTokens

let myBrandPalette = DSPalette(
    // Light mode colors
    light: DSColors(
        semantic: SemanticColors(
            textPrimary: .black,
            textSecondary: Color(white: 0.4),
            textTertiary: Color(white: 0.6),
            textDisabled: Color(white: 0.7),
            textOnBrand: .white,
            bgPrimary: .white,
            bgSecondary: Color(white: 0.95),
            surfacePrimary: .white,
            surfaceSecondary: Color(white: 0.98),
            stroke: Color(white: 0.85),
            divider: Color(white: 0.9),
            skeleton: Color(white: 0.92)
        ),
        brand: BrandColors(
            primary: Color(red: 0.0, green: 0.48, blue: 0.87),    // Custom blue
            secondary: Color(red: 0.13, green: 0.59, blue: 0.95),
            tertiary: Color(red: 0.61, green: 0.79, blue: 0.98)
        ),
        accent: AccentColors(
            bgAccent: Color(red: 0.0, green: 0.48, blue: 0.87).opacity(0.1),
            strokeAccent: Color(red: 0.0, green: 0.48, blue: 0.87)
        ),
        feedback: FeedbackColors(
            success: Color(red: 0.13, green: 0.77, blue: 0.25),
            warning: Color(red: 1.0, green: 0.58, blue: 0.0),
            error: Color(red: 0.95, green: 0.27, blue: 0.21)
        ),
        emphasis: TextEmphasisColors.default
    ),
    // Dark mode colors (automatically inverted semantics)
    dark: DSColors(
        semantic: SemanticColors(
            textPrimary: .white,
            textSecondary: Color(white: 0.7),
            textTertiary: Color(white: 0.5),
            textDisabled: Color(white: 0.3),
            textOnBrand: .white,
            bgPrimary: Color(white: 0.07),
            bgSecondary: Color(white: 0.13),
            surfacePrimary: Color(white: 0.13),
            surfaceSecondary: Color(white: 0.17),
            stroke: Color(white: 0.3),
            divider: Color(white: 0.2),
            skeleton: Color(white: 0.15)
        ),
        brand: BrandColors(
            primary: Color(red: 0.13, green: 0.59, blue: 0.95),
            secondary: Color(red: 0.37, green: 0.71, blue: 0.96),
            tertiary: Color(red: 0.61, green: 0.79, blue: 0.98)
        ),
        accent: AccentColors(
            bgAccent: Color(red: 0.13, green: 0.59, blue: 0.95).opacity(0.2),
            strokeAccent: Color(red: 0.13, green: 0.59, blue: 0.95)
        ),
        feedback: FeedbackColors(
            success: Color(red: 0.19, green: 0.82, blue: 0.35),
            warning: Color(red: 1.0, green: 0.62, blue: 0.04),
            error: Color(red: 0.98, green: 0.37, blue: 0.33)
        ),
        emphasis: TextEmphasisColors.defaultDark
    )
)
```

### Step 2: Create Your Theme

```swift
let myTheme = DSTheme(
    name: "MyBrandTheme",
    palette: myBrandPalette,
    typography: .defaultTypography,  // Use default or customize
    motion: .defaultMotion            // Use default or customize
)
```

### Step 3: Apply Your Theme

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dsTheme(myTheme)
        }
    }
}
```

---

## Color System

### Color Hierarchy

DaVinci uses a three-tier color system:

#### 1. Palette (Raw Colors)
Raw RGB values for light and dark modes. **Never used directly in components.**

#### 2. Semantic Colors
Purpose-based colors that components use:

```swift
theme.colors.semantic.textPrimary    // Primary text color
theme.colors.semantic.bgPrimary      // Background color
theme.colors.semantic.surfacePrimary // Card/surface color
theme.colors.semantic.stroke         // Border color
```

#### 3. Role-Based Colors
Specific use cases:

```swift
theme.colors.brand.primary          // Brand primary color
theme.colors.feedback.error         // Error state color
theme.colors.accent.bgAccent        // Accent background
```

### Semantic vs Brand vs Accent

| Category | When to Use | Example |
|----------|-------------|---------|
| **Semantic** | UI structure (text, backgrounds, borders) | `textPrimary`, `bgSecondary` |
| **Brand** | Primary branding moments (CTAs, logos) | `brand.primary` |
| **Accent** | Highlights, selections, focus states | `accent.bgAccent` |
| **Feedback** | Status communication (success, error) | `feedback.success` |

### Creating Accessible Color Palettes

**Critical**: All colors must meet WCAG AA contrast ratios:
- **Text on background**: 4.5:1 minimum
- **Large text**: 3:1 minimum
- **UI components**: 3:1 minimum

Test your palette with contrast checkers before deploying.

---

## Typography Customization

### Custom Font Family

```swift
let customTypography = DSTypography(
    family: FontFamily(brand: "Poppins", fallback: "SF Pro"),
    display: DSTextStyle(size: 34, lineHeight: 41, weight: .bold),
    title: DSTextStyle(size: 24, lineHeight: 30, weight: .bold),
    headline: DSTextStyle(size: 20, lineHeight: 25, weight: .semibold),
    body: DSTextStyle(size: 16, lineHeight: 24, weight: .regular),
    callout: DSTextStyle(size: 14, lineHeight: 20, weight: .regular),
    caption: DSTextStyle(size: 12, lineHeight: 16, weight: .regular),
    overline: DSTextStyle(size: 11, lineHeight: 16, weight: .semibold)
)

let myTheme = DSTheme(
    name: "CustomFontTheme",
    palette: .defaultPalette,
    typography: customTypography,
    motion: .defaultMotion
)
```

### Typography Best Practices

1. **Maintain Scale**: Keep relative size relationships consistent
2. **Line Height**: 1.4-1.6x font size for body text
3. **Weight Hierarchy**: Use 2-3 weights maximum (regular, semibold, bold)
4. **Accessibility**: Support Dynamic Type scaling

---

## Motion Customization

Customize animation durations:

```swift
let customMotion = DSMotion(
    instant: 0.0,
    fast: 0.15,     // Quick interactions
    medium: 0.25,   // Default animations
    slow: 0.4,      // Deliberate transitions
    crawl: 0.6      // Emphasized movements
)

let myTheme = DSTheme(
    name: "CustomMotionTheme",
    palette: .defaultPalette,
    typography: .defaultTypography,
    motion: customMotion
)
```

### Motion Guidelines

- **Fast (0.15s)**: Button presses, toggles, immediate feedback
- **Medium (0.25s)**: Modal presentations, view transitions
- **Slow (0.4s)**: Drawer animations, large content shifts

**Accessibility**: Always respect `UIAccessibility.isReduceMotionEnabled`.

---

## Best Practices

### 1. Theme Switching at Runtime

```swift
struct ContentView: View {
    @State private var currentTheme: DSTheme = .defaultTheme
    
    var body: some View {
        VStack {
            Button("Switch Theme") {
                currentTheme = currentTheme.name == "default" 
                    ? myCustomTheme 
                    : .defaultTheme
            }
            
            DSButton("Themed Button", variant: .primary) {}
        }
        .dsTheme(currentTheme)
    }
}
```

### 2. Per-Screen Theme Overrides

```swift
struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
        }
        .dsTheme(settingsTheme) // Override for this screen only
    }
}
```

### 3. Token-First Design

**Always use tokens, never hard-coded values:**

```swift
// ✅ Good
.padding(SpacingTokens.space3)
.cornerRadius(RadiusTokens.medium)

// ❌ Bad
.padding(12)
.cornerRadius(14)
```

### 4. Test Both Modes

Always test your custom theme in both light and dark modes:

```swift
#Preview("Custom Theme — Light") {
    ComponentView()
        .dsTheme(myTheme)
        .preferredColorScheme(.light)
}

#Preview("Custom Theme — Dark") {
    ComponentView()
        .dsTheme(myTheme)
        .preferredColorScheme(.dark)
}
```

### 5. Brand Color Isolation

Keep brand-specific colors in the `brand` namespace, not `semantic`:

```swift
// ✅ Good
DSButton("Sign Up", variant: .primary) {}
// Uses theme.colors.brand.primary

// ✅ Good  
Text("Body text")
    .foregroundStyle(theme.colors.semantic.textPrimary)

// ❌ Avoid
Text("CTA text")
    .foregroundStyle(theme.colors.brand.primary)
```

---

## Example: Complete Custom Theme

```swift
import SwiftUI
import DaVinciTokens

// 1. Define brand palette
let acmePalette = DSPalette(
    light: DSColors(
        semantic: /* ... light mode semantics ... */,
        brand: BrandColors(
            primary: Color(hex: "FF6B35"),    // Acme orange
            secondary: Color(hex: "F7931E"),
            tertiary: Color(hex: "FDC830")
        ),
        accent: AccentColors(
            bgAccent: Color(hex: "FF6B35").opacity(0.1),
            strokeAccent: Color(hex: "FF6B35")
        ),
        feedback: .default,
        emphasis: .default
    ),
    dark: /* ... dark mode colors ... */
)

// 2. Create theme
let acmeTheme = DSTheme(
    name: "AcmeTheme",
    palette: acmePalette,
    typography: DSTypography(
        family: FontFamily(brand: "Inter", fallback: "SF Pro"),
        /* ... sizes ... */
    ),
    motion: .defaultMotion
)

// 3. Apply globally
@main
struct AcmeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dsTheme(acmeTheme)
        }
    }
}
```

---

## Troubleshooting

### Theme Not Applying

**Problem**: Components still show default colors.

**Solution**: Ensure `.dsTheme()` is applied above all DaVinci components:

```swift
VStack {
    DSButton(...) {}
}
.dsTheme(myTheme) // ✅ Correct placement
```

### Dark Mode Colors Wrong

**Problem**: Dark mode uses light mode colors.

**Solution**: Verify your palette has distinct `light` and `dark` color sets.

### Typography Not Changing

**Problem**: Custom font not loading.

**Solution**: 
1. Ensure font files are in app bundle
2. Add font to `Info.plist` under `Fonts provided by application`
3. Use exact font name (check Font Book)

---

## Further Reading

- [Apple HIG - Color](https://developer.apple.com/design/human-interface-guidelines/color)
- [WCAG Color Contrast](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
- [Material Design - Color System](https://m3.material.io/styles/color/overview)

---

**Next Steps**: See [Component Usage Guide](Usage.md) for practical component examples.
