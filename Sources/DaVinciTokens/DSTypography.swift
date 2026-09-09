import SwiftUI

// MARK: - FontFamily

/// Font family tokens. Brand font can be overridden per-theme;
/// fallback is always the system font.
public struct FontFamily: Sendable, Equatable {
    public let brand: String?
    public var fallback: String { Font.systemFontFamilyName }

    public init(brand: String? = nil) {
        self.brand = brand
    }

    /// Resolved family name — brand if set, otherwise system fallback.
    public var resolved: String { brand ?? fallback }
}

extension Font {
    /// The platform system font family name.
    nonisolated static var systemFontFamilyName: String { ".AppleSystemUIFont" }
}

// MARK: - AllowedWeights

/// The set of weights permitted in the design system.
public enum AllowedWeight: String, CaseIterable, Sendable {
    case regular
    case medium
    case semibold
    case bold

    public var fontWeight: Font.Weight {
        switch self {
        case .regular:  .regular
        case .medium:   .medium
        case .semibold: .semibold
        case .bold:     .bold
        }
    }
}

// MARK: - DSDigitStyle

/// How numerals are advanced within a text style.
///
/// Digit rendering is orthogonal to typographic role: any role may need
/// tabular figures when its numbers update in place — timers, counters,
/// metrics and table columns — so this is a property of the style rather
/// than a separate set of roles.
public enum DSDigitStyle: String, CaseIterable, Sendable {
    /// Numerals use the font's natural, proportional widths. The default.
    case proportional
    /// Numerals share a fixed advance width so changing digits do not shift layout.
    case monospaced
}

// MARK: - DSTextStyle

/// A single text style definition combining size, line height, weight, and digit advance.
public struct DSTextStyle: Sendable, Equatable {
    public let size: CGFloat
    public let lineHeight: CGFloat
    public let weight: Font.Weight
    public let relativeTo: Font.TextStyle
    public let digitStyle: DSDigitStyle

    public init(
        size: CGFloat,
        lineHeight: CGFloat,
        weight: Font.Weight,
        relativeTo: Font.TextStyle = .body,
        digitStyle: DSDigitStyle = .proportional
    ) {
        self.size = size
        self.lineHeight = lineHeight
        self.weight = weight
        self.relativeTo = relativeTo
        self.digitStyle = digitStyle
    }

    /// The additional spacing needed to achieve the token's line height.
    public var lineSpacing: CGFloat { max(0, lineHeight - size) }

    /// A copy of this style that advances numerals on a fixed width.
    ///
    /// Use for values that update in place, so digit changes do not shift layout.
    public func monospacedDigits() -> DSTextStyle {
        DSTextStyle(
            size: size,
            lineHeight: lineHeight,
            weight: weight,
            relativeTo: relativeTo,
            digitStyle: .monospaced
        )
    }

    /// Build a Dynamic Type-aware `Font` from this style using the given family.
    public func font(family: FontFamily) -> Font {
        let base = Font.custom(family.resolved, size: size, relativeTo: relativeTo)
            .weight(weight)

        switch digitStyle {
        case .proportional: return base
        case .monospaced:   return base.monospacedDigit()
        }
    }
}

// MARK: - Typography View Modifier

public extension View {
    /// Applies a typography token, including Dynamic Type and scaled line spacing.
    func dsTextStyle(_ style: DSTextStyle, family: FontFamily) -> some View {
        modifier(DSTextStyleModifier(style: style, family: family))
    }

    /// Applies only the scaled line spacing of a typography token, leaving the font alone.
    ///
    /// Use this when the font has already been resolved into the content itself — as with
    /// `AttributedString`, where applying `.font()` to the whole view would flatten the
    /// per-run fonts that carry inline bold, italic and link styling.
    func dsLineSpacing(_ style: DSTextStyle) -> some View {
        modifier(DSLineSpacingModifier(style: style))
    }
}

private struct DSLineSpacingModifier: ViewModifier {
    @ScaledMetric private var scaledLineSpacing: CGFloat

    init(style: DSTextStyle) {
        _scaledLineSpacing = ScaledMetric(
            wrappedValue: style.lineSpacing,
            relativeTo: style.relativeTo
        )
    }

    func body(content: Content) -> some View {
        content.lineSpacing(scaledLineSpacing)
    }
}

private struct DSTextStyleModifier: ViewModifier {
    let style: DSTextStyle
    let family: FontFamily

    func body(content: Content) -> some View {
        content
            .font(style.font(family: family))
            .modifier(DSLineSpacingModifier(style: style))
    }
}

// MARK: - DSTypography

/// Complete typography token set used by `DSTheme`.
///
/// The scale is organised into five families:
///
/// - **Display** — a single hero level for the largest text on a screen.
/// - **Title** — three levels of document and section hierarchy, all bold.
/// - **Heading** — `headline` and `subheadline` for headers inside flowing content.
/// - **Body** — reading text, from `body` down to `caption`.
/// - **Label** — control text: buttons, chips, badges and form labels. Labels use
///   `medium` weight and tighter line heights because they are single-line and often
///   sit on coloured backgrounds, where reading text would be too light.
///
/// `overline` stands apart as a utility role for small all-caps eyebrow text.
public struct DSTypography: Sendable, Equatable {
    public let family: FontFamily

    // Display
    public let display: DSTextStyle

    // Title
    public let titleLarge: DSTextStyle
    public let titleMedium: DSTextStyle
    public let titleSmall: DSTextStyle

    // Heading
    public let headline: DSTextStyle
    public let subheadline: DSTextStyle

    // Body
    public let body: DSTextStyle
    public let callout: DSTextStyle
    public let footnote: DSTextStyle
    public let caption: DSTextStyle

    // Label
    public let labelLarge: DSTextStyle
    public let labelMedium: DSTextStyle
    public let labelSmall: DSTextStyle

    // Utility
    public let overline: DSTextStyle

    public init(
        family: FontFamily = FontFamily(),
        display: DSTextStyle = DSTextStyle(size: 34, lineHeight: 40, weight: .bold, relativeTo: .largeTitle),
        titleLarge: DSTextStyle = DSTextStyle(size: 28, lineHeight: 34, weight: .bold, relativeTo: .title),
        titleMedium: DSTextStyle = DSTextStyle(size: 24, lineHeight: 30, weight: .bold, relativeTo: .title2),
        titleSmall: DSTextStyle = DSTextStyle(size: 20, lineHeight: 26, weight: .bold, relativeTo: .title3),
        headline: DSTextStyle = DSTextStyle(size: 20, lineHeight: 26, weight: .semibold, relativeTo: .headline),
        subheadline: DSTextStyle = DSTextStyle(size: 15, lineHeight: 20, weight: .regular, relativeTo: .subheadline),
        body: DSTextStyle = DSTextStyle(size: 16, lineHeight: 22, weight: .regular, relativeTo: .body),
        callout: DSTextStyle = DSTextStyle(size: 14, lineHeight: 20, weight: .regular, relativeTo: .callout),
        footnote: DSTextStyle = DSTextStyle(size: 13, lineHeight: 18, weight: .regular, relativeTo: .footnote),
        caption: DSTextStyle = DSTextStyle(size: 12, lineHeight: 16, weight: .regular, relativeTo: .caption),
        labelLarge: DSTextStyle = DSTextStyle(size: 16, lineHeight: 20, weight: .medium, relativeTo: .body),
        labelMedium: DSTextStyle = DSTextStyle(size: 14, lineHeight: 18, weight: .medium, relativeTo: .callout),
        labelSmall: DSTextStyle = DSTextStyle(size: 12, lineHeight: 16, weight: .medium, relativeTo: .caption),
        overline: DSTextStyle = DSTextStyle(size: 11, lineHeight: 14, weight: .semibold, relativeTo: .caption2)
    ) {
        self.family = family
        self.display = display
        self.titleLarge = titleLarge
        self.titleMedium = titleMedium
        self.titleSmall = titleSmall
        self.headline = headline
        self.subheadline = subheadline
        self.body = body
        self.callout = callout
        self.footnote = footnote
        self.caption = caption
        self.labelLarge = labelLarge
        self.labelMedium = labelMedium
        self.labelSmall = labelSmall
        self.overline = overline
    }

    /// Every style in the scale paired with its token name, in visual hierarchy order.
    ///
    /// Validation, documentation and gallery screens iterate this rather than listing
    /// roles by hand, so adding a role cannot silently skip any of them.
    public var namedStyles: [(name: String, style: DSTextStyle)] {
        [
            ("display", display),
            ("titleLarge", titleLarge),
            ("titleMedium", titleMedium),
            ("titleSmall", titleSmall),
            ("headline", headline),
            ("subheadline", subheadline),
            ("body", body),
            ("callout", callout),
            ("footnote", footnote),
            ("caption", caption),
            ("labelLarge", labelLarge),
            ("labelMedium", labelMedium),
            ("labelSmall", labelSmall),
            ("overline", overline)
        ]
    }

    /// Every style in the scale, in visual hierarchy order.
    public var allStyles: [DSTextStyle] { namedStyles.map(\.style) }
}
