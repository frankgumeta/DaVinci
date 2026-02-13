import SwiftUI

// MARK: - GrayScale

/// Shared, immutable gray scale palette. These are the raw primitive values
/// that semantic tokens map to. Never use directly in views.
public enum GrayScale: Sendable {
    public static let gray900 = Color(white: 0.07)
    public static let gray800 = Color(white: 0.13)
    public static let gray700 = Color(white: 0.23)
    public static let gray600 = Color(white: 0.35)
    public static let gray500 = Color(white: 0.46)
    public static let gray400 = Color(white: 0.60)
    public static let gray300 = Color(white: 0.74)
    public static let gray200 = Color(white: 0.85)
    public static let gray100 = Color(white: 0.93)
    public static let gray050 = Color(white: 0.97)
}

// MARK: - SemanticColors

/// Semantic color roles for text, backgrounds, and UI elements.
///
/// `SemanticColors` provides named, purpose-driven colors that automatically
/// work in both light and dark modes. Use these instead of raw color values
/// to ensure consistent, accessible UI.
///
/// ## Text Colors
///
/// - ``textPrimary``: Main body text (gray900 in light, gray050 in dark)
/// - ``textSecondary``: Secondary labels (gray600 in light, gray300 in dark)
/// - ``textTertiary``: Tertiary/hint text (gray500 in light, gray400 in dark)
/// - ``textDisabled``: Disabled state text (gray400 in light, gray500 in dark)
/// - ``textInverse``: Text on opposite scheme backgrounds
/// - ``textOnBrand``: Text on brand-colored backgrounds (always readable)
///
/// ## Backgrounds
///
/// - ``bgPrimary``: Main app background
/// - ``bgSecondary``: Grouped/inset backgrounds
/// - ``bgTertiary``: Tertiary/nested backgrounds
/// - ``bgScrim``: Modal overlay background
///
/// ## Surfaces
///
/// - ``surfacePrimary``: Cards and containers
/// - ``surfaceSecondary``: Secondary cards/wells
/// - ``surfaceElevated``: Modals and popovers (floats above primary)
///
/// ## Separators
///
/// - ``stroke``: Borders and outlines
/// - ``divider``: Subtle list separators
/// - ``skeleton``: Skeleton loading placeholder fill
///
/// - Note: All defaults are optimized for WCAG AA contrast ratios.
public struct SemanticColors: Sendable {
    public let textPrimary: Color
    public let textSecondary: Color
    public let textTertiary: Color
    public let textDisabled: Color

    /// Text color for inverted contrast scenarios.
    /// This represents the readable text color when content is placed on a surface
    /// using the opposite color scheme.
    /// - Light mode → light text on dark surfaces
    /// - Dark mode → dark text on light surfaces
    /// Not for brand surfaces; use `textOnBrand` for brand-colored backgrounds.
    public let textInverse: Color
    public let textOnBrand: Color

    public let bgPrimary: Color
    public let bgSecondary: Color
    public let bgTertiary: Color

    public let surfacePrimary: Color
    public let surfaceSecondary: Color
    public let surfaceElevated: Color

    public let bgScrim: Color

    public let stroke: Color
    public let divider: Color

    /// Placeholder fill for skeleton / shimmer loading states.
    public let skeleton: Color

    public init(
        textPrimary: Color = GrayScale.gray900,
        textSecondary: Color = GrayScale.gray600,
        textTertiary: Color = GrayScale.gray500,
        textDisabled: Color = GrayScale.gray400,
        textInverse: Color = GrayScale.gray050,
        textOnBrand: Color = GrayScale.gray050,
        bgPrimary: Color = GrayScale.gray050,
        bgSecondary: Color = GrayScale.gray100,
        bgTertiary: Color = GrayScale.gray200,
        surfacePrimary: Color = GrayScale.gray050,
        surfaceSecondary: Color = GrayScale.gray100,
        surfaceElevated: Color = GrayScale.gray050,
        bgScrim: Color = GrayScale.gray900.opacity(OpacityTokens.scrim),
        stroke: Color = GrayScale.gray200,
        divider: Color = GrayScale.gray100,
        skeleton: Color = GrayScale.gray200
    ) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.textDisabled = textDisabled
        self.textInverse = textInverse
        self.textOnBrand = textOnBrand
        self.bgPrimary = bgPrimary
        self.bgSecondary = bgSecondary
        self.bgTertiary = bgTertiary
        self.surfacePrimary = surfacePrimary
        self.surfaceSecondary = surfaceSecondary
        self.surfaceElevated = surfaceElevated
        self.bgScrim = bgScrim
        self.stroke = stroke
        self.divider = divider
        self.skeleton = skeleton
    }
}

// MARK: - BrandColors

/// Per-theme brand colors used for theme configuration.
/// App code should prefer semantic roles (`accent.bgAccent`, `accent.strokeAccent`)
/// rather than referencing `brand.*` directly.
public struct BrandColors: Sendable {
    public let primary: Color
    public let secondary: Color
    public let tertiary: Color

    public init(
        primary: Color = Color(red: 0.13, green: 0.39, blue: 0.96),
        secondary: Color = Color(red: 0.30, green: 0.55, blue: 0.98),
        tertiary: Color = Color(red: 0.55, green: 0.73, blue: 0.99)
    ) {
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
    }
}

// MARK: - AccentColors

/// Semantic accent roles derived from brand colors.
/// Use these in UI instead of referencing `brand.*` directly.
/// - `bgAccent`: soft tinted background for selections, chips, highlights.
/// - `strokeAccent`: border color for selected/focused elements.
public struct AccentColors: Sendable {
    public let bgAccent: Color
    public let strokeAccent: Color

    public init(
        bgAccent: Color,
        strokeAccent: Color
    ) {
        self.bgAccent = bgAccent
        self.strokeAccent = strokeAccent
    }
}

// MARK: - FeedbackColors

/// Feedback status colors. Shared defaults, but overridable via theme.
public struct FeedbackColors: Sendable {
    public let success: Color
    public let warning: Color
    public let error: Color
    public let info: Color

    public init(
        success: Color = Color(red: 0.20, green: 0.78, blue: 0.35),
        warning: Color = Color(red: 1.00, green: 0.80, blue: 0.00),
        error: Color = Color(red: 0.94, green: 0.27, blue: 0.27),
        info: Color = Color(red: 0.20, green: 0.60, blue: 1.00)
    ) {
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
    }
}

// MARK: - TextEmphasisColors

/// Emphasis text colors that derive from brand and feedback by default.
/// Override individual values to customise per-theme.
public struct TextEmphasisColors: Sendable {
    public let brand: Color
    public let success: Color
    public let warning: Color
    public let error: Color
    public let info: Color

    public init(
        brand: Color,
        feedback: FeedbackColors
    ) {
        self.brand = brand
        self.success = feedback.success
        self.warning = feedback.warning
        self.error = feedback.error
        self.info = feedback.info
    }

    public init(
        brand: Color,
        success: Color,
        warning: Color,
        error: Color,
        info: Color
    ) {
        self.brand = brand
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
    }
}

// MARK: - DSColors

/// Aggregated color container used by `DSTheme`.
public struct DSColors: Sendable {
    public let semantic: SemanticColors
    public let brand: BrandColors
    public let accent: AccentColors
    public let feedback: FeedbackColors
    public let textEmphasis: TextEmphasisColors

    public init(
        semantic: SemanticColors = SemanticColors(),
        brand: BrandColors = BrandColors(),
        accent: AccentColors? = nil,
        feedback: FeedbackColors = FeedbackColors(),
        textEmphasis: TextEmphasisColors? = nil
    ) {
        self.semantic = semantic
        self.brand = brand
        self.accent = accent ?? AccentColors(
            bgAccent: brand.tertiary.opacity(0.12),
            strokeAccent: brand.secondary
        )
        self.feedback = feedback
        self.textEmphasis = textEmphasis ?? TextEmphasisColors(
            brand: brand.primary,
            feedback: feedback
        )
    }
}
