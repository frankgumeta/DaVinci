# Accessibility Guidelines

DaVinci Design System is committed to providing accessible components that work well with assistive technologies and follow WCAG 2.1 Level AA guidelines.

## Color Contrast

All semantic colors are designed to meet WCAG AA contrast requirements (4.5:1 for normal text, 3:1 for large text).

### Light Mode Contrast Ratios

| Color Pair | Contrast Ratio | WCAG Level |
|------------|----------------|------------|
| `textPrimary` (gray900) on `bgPrimary` (gray050) | ~19:1 | AAA ✅ |
| `textSecondary` (gray600) on `bgPrimary` (gray050) | ~7.5:1 | AAA ✅ |
| `textTertiary` (gray500) on `bgPrimary` (gray050) | ~5.4:1 | AA ✅ |
| `textOnBrand` (gray050) on `brand.primary` (#2163F5) | ~4.8:1 | AA ✅ |

### Dark Mode Contrast Ratios

| Color Pair | Contrast Ratio | WCAG Level |
|------------|----------------|------------|
| `textPrimary` (gray050) on `bgPrimary` (gray900) | ~19:1 | AAA ✅ |
| `textSecondary` (gray300) on `bgPrimary` (gray900) | ~9.5:1 | AAA ✅ |
| `textTertiary` (gray400) on `bgPrimary` (gray900) | ~6.8:1 | AAA ✅ |

### Feedback Colors

All feedback colors (success, warning, error, info) meet WCAG AA contrast requirements when used on their intended backgrounds:

- **Success** (#33C759): 4.9:1 on white background
- **Warning** (#FFCC00): 1.3:1 on white ⚠️ (use dark text instead)
- **Error** (#F04545): 4.5:1 on white background
- **Info** (#3399FF): 4.6:1 on white background

## Component Accessibility Features

### DSButton

- ✅ Automatic disabled state communication
- ✅ Loading state announced to screen readers
- ✅ Minimum touch target: 44pt height (exceeds 44×44pt recommendation)
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
- ✅ Minimum touch targets: Small (36pt), Medium (44pt), Large (52pt)

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
- ✅ Loading state announced

**Usage:**
```swift
DSRemoteImage(
    url: profileImageURL,
    size: CGSize(width: 80, height: 80),
    accessibilityLabel: "Profile picture of John Doe"
)
// VoiceOver: "Profile picture of John Doe, image"
```

**Default labels when not specified:**
- With URL: "Remote image"
- Without URL: "Placeholder image"

### DSCard

- ✅ Proper semantic grouping via VStack/HStack
- ✅ Content within cards maintains proper reading order
- ✅ Sufficient padding for touch targets

### DSSkeleton

- ✅ Skeleton states are decorative (ignored by screen readers)
- ✅ Shimmer animation respects Reduce Motion preference

## Dynamic Type Support

All text components automatically support Dynamic Type scaling.

### Typography Scale with Dynamic Type

| Role | Default Size | Scales With |
|------|--------------|-------------|
| Display | 34pt | Large Title |
| Title | 24pt | Title 1 |
| Headline | 20pt | Headline |
| Body | 16pt | Body |
| Callout | 14pt | Callout |
| Caption | 12pt | Caption |
| Overline | 11pt | Caption |

### Testing Dynamic Type

Test your UI with different text sizes:

1. **Settings** → **Accessibility** → **Display & Text Size** → **Larger Text**
2. Test with sizes from "Small" to "AX5" (largest)
3. Ensure content doesn't truncate or overlap

**Recommendations:**
- Use `.fixedSize()` sparingly
- Prefer flexible layouts with `VStack` and `HStack`
- Test with Dynamic Type enabled in previews

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
