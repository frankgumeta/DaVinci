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

// MARK: - DSTextStyle

/// A single text style definition combining size, line height, and weight.
public struct DSTextStyle: Sendable, Equatable {
    public let size: CGFloat
    public let lineHeight: CGFloat
    public let weight: Font.Weight
    public let relativeTo: Font.TextStyle

    public init(
        size: CGFloat,
        lineHeight: CGFloat,
        weight: Font.Weight,
        relativeTo: Font.TextStyle = .body
    ) {
        self.size = size
        self.lineHeight = lineHeight
        self.weight = weight
        self.relativeTo = relativeTo
    }

    /// The additional spacing needed to achieve the token's line height.
    public var lineSpacing: CGFloat { max(0, lineHeight - size) }

    /// Build a Dynamic Type-aware `Font` from this style using the given family.
    public func font(family: FontFamily) -> Font {
        Font.custom(family.resolved, size: size, relativeTo: relativeTo)
            .weight(weight)
    }
}

// MARK: - Typography View Modifier

public extension View {
    /// Applies a typography token, including Dynamic Type and scaled line spacing.
    func dsTextStyle(_ style: DSTextStyle, family: FontFamily) -> some View {
        modifier(DSTextStyleModifier(style: style, family: family))
    }
}

private struct DSTextStyleModifier: ViewModifier {
    let style: DSTextStyle
    let family: FontFamily
    @ScaledMetric private var scaledLineSpacing: CGFloat

    init(style: DSTextStyle, family: FontFamily) {
        self.style = style
        self.family = family
        _scaledLineSpacing = ScaledMetric(
            wrappedValue: style.lineSpacing,
            relativeTo: style.relativeTo
        )
    }

    func body(content: Content) -> some View {
        content
            .font(style.font(family: family))
            .lineSpacing(scaledLineSpacing)
    }
}

// MARK: - DSTypography

/// Complete typography token set used by `DSTheme`.
public struct DSTypography: Sendable, Equatable {
    public let family: FontFamily

    public let display: DSTextStyle
    public let title: DSTextStyle
    public let headline: DSTextStyle
    public let body: DSTextStyle
    public let callout: DSTextStyle
    public let caption: DSTextStyle
    public let overline: DSTextStyle

    public init(
        family: FontFamily = FontFamily(),
        display: DSTextStyle = DSTextStyle(size: 34, lineHeight: 40, weight: .bold, relativeTo: .largeTitle),
        title: DSTextStyle = DSTextStyle(size: 24, lineHeight: 30, weight: .bold, relativeTo: .title),
        headline: DSTextStyle = DSTextStyle(size: 20, lineHeight: 26, weight: .semibold, relativeTo: .headline),
        body: DSTextStyle = DSTextStyle(size: 16, lineHeight: 22, weight: .regular, relativeTo: .body),
        callout: DSTextStyle = DSTextStyle(size: 14, lineHeight: 20, weight: .regular, relativeTo: .callout),
        caption: DSTextStyle = DSTextStyle(size: 12, lineHeight: 16, weight: .regular, relativeTo: .caption),
        overline: DSTextStyle = DSTextStyle(size: 11, lineHeight: 14, weight: .semibold, relativeTo: .caption2)
    ) {
        self.family = family
        self.display = display
        self.title = title
        self.headline = headline
        self.body = body
        self.callout = callout
        self.caption = caption
        self.overline = overline
    }
}
