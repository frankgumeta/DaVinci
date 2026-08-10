# Accessibility Guidelines

DaVinci components are designed with WCAG 2.1 Level AA criteria in mind and expose
explicit SwiftUI accessibility semantics. This document states what is automated,
what remains manual, and is not an accessibility certification for a host app.

## Verification Scope

Automated tests currently verify:

- component labels, values, hints, traits, enabled state, and child grouping through
  the same semantic descriptors consumed by production modifiers;
- documented text/background pairs at 4.5:1 or greater;
- documented interactive outlines at 3:1 or greater;
- default and alternate themes in light and dark modes;
- rendered minimum dimensions of primary controls at 44×44pt;
- Dynamic Type growth and representative AX3 layouts.

SwiftUI does not expose its synthesized accessibility tree to this package's unit-test
target. Before release, validate the actual tree with Accessibility Inspector and
VoiceOver using the manual matrix below. Focus order, spoken localization, Switch
Control, and Full Keyboard Access depend on the host app and remain manual checks.

## Color Contrast

The following opaque pairs are calculated from sRGB values in automated tests.

### Light Mode Contrast Ratios

| Color Pair | Contrast Ratio | WCAG Level |
|------------|----------------|------------|
| `textPrimary` (gray900) on `bgPrimary` (gray050) | ~17.6:1 | AAA |
| `textSecondary` (gray600) on `bgPrimary` (gray050) | ~6.5:1 | AA |
| `textTertiary` (gray500) on `bgPrimary` (gray050) | ~5.0:1 | AA |
| Preferred text on default `brand.primary` | ~4.7:1 | AA |

### Dark Mode Contrast Ratios

| Color Pair | Contrast Ratio | WCAG Level |
|------------|----------------|------------|
| `textPrimary` (gray050) on `bgPrimary` (gray900) | ~17.6:1 | AAA |
| `textSecondary` (gray300) on `bgPrimary` (gray900) | ~10.0:1 | AAA |
| `textTertiary` (gray400) on `bgPrimary` (gray900) | ~6.6:1 | AA |

### Feedback Colors

Feedback and brand fills are not assumed to work with one fixed text color.
`DSButton`, filled `DSBadge`, and `DSSegmentedControl` select the highest-contrast
option from the theme's semantic foregrounds. Subtle and outlined badges use the
primary semantic text color over the surrounding surface while tone remains visible
through tint and border. Tests require at least 4.5:1 for badge and control text
across supported color schemes. Custom themes must run the same tests with their
own palette.

## Component Accessibility Features

### DSButton

- ✅ Automatic disabled state communication
- ✅ Loading state announced to screen readers
- ✅ Rendered minimum height of 44pt
- ✅ Clear focus indicators via system default

**Usage:**
```swift
DSButton("Submit Form", variant: .primary) {
    submitForm()
}
// VoiceOver: "Submit Form, button"
```

### DSIconButton

- ✅ **Required** accessibility label via `titleForAccessibility`
- ✅ Screen readers announce icon purpose, not icon name
- ✅ Visual sizes remain semantic; every interaction frame is at least 44×44pt

**Usage:**
```swift
DSIconButton(
    systemName: "trash",
    titleForAccessibility: "Delete item", // Required!
    variant: .secondary
) { deleteItem() }
// VoiceOver: "Delete item, button"
```

**⚠️ Important:** Always provide descriptive labels, not just icon names:
- ✅ Good: "Delete item", "Add to favorites", "Share post"
- ❌ Bad: "Trash icon", "Star", "Square and arrow"

### DSText

- ✅ Semantic roles map to appropriate text styles
- ✅ Supports Dynamic Type (scales with user preferences)
- ✅ Proper heading hierarchy when using `.display`, `.title`, `.headline`

**Heading Usage:**
```swift
DSText("Page Title", role: .title)        // Acts as h1
DSText("Section Header", role: .headline) // Acts as h2
DSText("Body content", role: .body)       // Regular text
```

### DSRemoteImage

- ✅ Configurable accessibility labels
- ✅ Automatic fallback labels for missing images
- ✅ Loading/failure values and image traits
- ✅ Decorative images can be removed from the accessibility tree
- ✅ Success is exposed only after the payload has decoded as an image
- ✅ A missing URL is announced as a placeholder, not as a failed load

**Usage:**
```swift
DSRemoteImage(
    url: profileImageURL,
    size: CGSize(width: 80, height: 80),
    accessibilityLabel: "Profile picture of John Doe"
)
// VoiceOver: "Profile picture of John Doe, image"
```

Use `isDecorative: true` only when the image communicates no information.

**Default labels when not specified:**
- With URL: "Remote image"
- Without URL: "Placeholder image"
- With URL, after a failed load: "Image failed to load", value "Failed to load"

A `nil` URL resolves to the placeholder immediately, so assistive technologies never
announce a loading state for content that can never load.

### DSCard

- ✅ Proper semantic grouping via VStack/HStack
- ✅ Content within cards maintains proper reading order
- ✅ Sufficient padding for touch targets

### DSSkeleton

- ✅ Skeleton states are decorative (ignored by screen readers)
- ✅ Shimmer animation respects Reduce Motion preference

## Dynamic Type Support

All text components automatically support Dynamic Type scaling.

Each typography token stores its semantic `Font.TextStyle`. DaVinci scales both
the font and the extra spacing derived from `lineHeight - size`; custom font
families retain the token's weight. `DSButton`, `DSBadge`, `DSTextField`, and
`DSSegmentedControl` use flexible vertical layouts so accessibility sizes can wrap.

### Typography Scale with Dynamic Type

| Role | Default Size | Scales With |
|------|--------------|-------------|
| Display | 34pt | Large Title |
| Title | 24pt | Title 1 |
| Headline | 20pt | Headline |
| Body | 16pt | Body |
| Callout | 14pt | Callout |
| Caption | 12pt | Caption |
| Overline | 11pt | Caption 2 |

### Testing Dynamic Type

Test your UI with different text sizes:

1. **Settings** → **Accessibility** → **Display & Text Size** → **Larger Text**
2. Test with sizes from "Small" to "AX5" (largest)
3. Ensure content doesn't truncate or overlap

**Recommendations:**
- Apply custom typography with
  `.dsTextStyle(style, family: theme.typography.family)` so line height is preserved
- Use `.fixedSize(horizontal: false, vertical: true)` when a control label may wrap
- Prefer flexible layouts with `VStack` and `HStack`
- Test regular and accessibility categories; the Typography gallery includes an AX3 example

## Manual Assistive-Technology Matrix

Run this matrix with Accessibility Inspector and VoiceOver on an iPhone simulator
or device. Repeat keyboard checks on iPad when the host app supports it.

| Component | Required states | Verify manually |
|-----------|-----------------|-----------------|
| `DSButton`, `DSIconButton` | normal, disabled, loading | label, hint, “dimmed”, loading value, focus order |
| `DSSwitch` | on, off, disabled, no visible label | toggle trait, value, activation, fallback label |
| `DSSegmentedControl` | every selection | container grouping, selected trait, change announcement |
| `DSTextField` | filled, outlined, prompt, value, supporting, error, clear, limit, disabled, RTL | label/value/hint order, character progress, typing, clear focus retention, IME composition |
| `DSProgressBar` | determinate, indeterminate, Reduce Motion | percentage/loading value and update frequency |
| `DSRemoteImage` | loading, success, failure, decorative | image trait, state value, decorative omission |
| `DSBadge`, `DSCard`, `DSText` | representative content | grouping, reading order, heading/static traits |

Also verify Full Keyboard Access traversal and activation for every interactive row.

### Text field announcements

- Supporting text is attached to the field's accessibility hint instead of
  becoming a duplicate focusable element.
- Error text and character progress are included in the field's accessibility
  value so they remain available while editing.
- The visible message and counter rows are hidden as standalone accessibility
  elements to prevent duplicate announcements.
- Leading symbols are decorative. The clear action remains a separate button
  with its own label and hint.
- Validate marked-text composition manually with the keyboards used by the host
  application; grapheme-safe truncation tests do not replace an IME test.

## VoiceOver Testing Checklist

When building with DaVinci components:

- [ ] All interactive elements have clear labels
- [ ] Icon buttons use `titleForAccessibility`
- [ ] Images have descriptive `accessibilityLabel`
- [ ] Heading hierarchy makes sense (title → headline → body)
- [ ] Disabled states are announced
- [ ] Loading states are communicated
- [ ] Focus order is logical
- [ ] No "button button" announcements (avoid nested buttons)

## Reduce Motion

DaVinci respects the system Reduce Motion setting:

- ✅ Skeleton shimmer animation automatically pauses
- ✅ Button press animations simplify
- ✅ Theme transitions respect motion preferences

**Testing:**
1. **Settings** → **Accessibility** → **Motion** → **Reduce Motion**
2. Verify animations are reduced or removed

## Color Blindness Considerations

### Don't Rely on Color Alone

Always combine color with another indicator:

- ✅ Error: Red color **+** icon **+** error message
- ❌ Error: Only red color

**Example:**
```swift
HStack {
    Image(systemName: "exclamationmark.circle.fill")
        .foregroundColor(theme.colors.feedback.error)
    DSText("Error: Invalid email", role: .callout)
        .foregroundColor(theme.colors.feedback.error)
}
```

### Testing for Color Blindness

Use Xcode's Accessibility Inspector:

1. **Xcode** → **Open Developer Tool** → **Accessibility Inspector**
2. Enable color filters (Protanopia, Deuteranopia, Tritanopia)
3. Verify UI remains usable

## Best Practices Summary

### DO ✅

- Use semantic color roles (`semantic.textPrimary`, not raw colors)
- Provide accessibility labels for all non-text UI
- Test with VoiceOver enabled
- Support Dynamic Type
- Maintain proper heading hierarchy
- Combine color with text/icons for state

### DON'T ❌

- Use color as the only indicator of state
- Skip accessibility labels on icon buttons
- Ignore Dynamic Type in custom layouts
- Create touch targets smaller than 44×44pt
- Nest interactive elements (button inside button)

## Resources

- [Apple Human Interface Guidelines - Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [VoiceOver Testing Guide](https://developer.apple.com/documentation/accessibility/voiceover)
- [Dynamic Type](https://developer.apple.com/design/human-interface-guidelines/typography)

## Reporting Accessibility Issues

If you discover accessibility issues in DaVinci components:

1. Check if it's already reported in Issues
2. Create a new issue with:
   - Component name
   - Accessibility feature affected (VoiceOver, Dynamic Type, etc.)
   - Steps to reproduce
   - Expected vs actual behavior
   - iOS version and device

Accessibility improvements are high priority and will be addressed quickly.
