import SwiftUI

// MARK: - DSPalette

/// A light/dark color pair. `DSTheme` stores a palette and resolves
/// the active `DSColors` based on the current `ColorScheme`.
public struct DSPalette: Sendable {
    public let light: DSColors
    public let dark: DSColors

    public init(light: DSColors, dark: DSColors) {
        self.light = light
        self.dark = dark
    }

    /// Convenience initializer for themes that share the same colors
    /// across both schemes (legacy / single-mode themes).
    public init(uniform colors: DSColors) {
        self.light = colors
        self.dark = colors
    }

    /// Resolve the correct `DSColors` for the given color scheme.
    public func resolved(for scheme: ColorScheme) -> DSColors {
        switch scheme {
        case .dark:  dark
        case .light: light
        @unknown default: light
        }
    }
}

// MARK: - Default Dark SemanticColors

extension SemanticColors {
    /// Dark-mode semantic defaults — inverted gray scale.
    ///
    /// Background hierarchy (darkest → lightest):
    /// - `bgPrimary`        gray900 — deepest app background
    /// - `bgSecondary`      gray800 — grouped / inset background
    /// - `bgTertiary`       gray700 — tertiary / nested background
    ///
    /// Surface hierarchy:
    /// - `surfacePrimary`   gray800 — cards sitting on bgPrimary
    /// - `surfaceSecondary` gray700 — secondary cards / wells
    /// - `surfaceElevated`  gray600 — modals / popovers (clearly floats)
    ///
    /// Separators:
    /// - `divider`          gray800 — subtle, low-contrast separator
    /// - `stroke`           gray700 — borders / outlines (higher contrast than divider)
    public static let darkDefaults = SemanticColors(
        textPrimary: GrayScale.gray050,
        textSecondary: GrayScale.gray300,
        textTertiary: GrayScale.gray400,
        textDisabled: GrayScale.gray500,
        textInverse: GrayScale.gray900,
        textOnBrand: GrayScale.gray050,
        bgPrimary: GrayScale.gray900,
        bgSecondary: GrayScale.gray800,
        bgTertiary: GrayScale.gray700,
        surfacePrimary: GrayScale.gray800,
        surfaceSecondary: GrayScale.gray700,
        surfaceElevated: GrayScale.gray600,
        bgScrim: GrayScale.gray900.opacity(OpacityTokens.scrim),
        stroke: GrayScale.gray700,
        divider: GrayScale.gray800,
        skeleton: GrayScale.gray700
    )
}

// MARK: - Default Palette

extension DSPalette {
    /// Dark-mode accent opacity — higher than light (0.12) for visibility
    /// on dark backgrounds.
    private static let darkAccentOpacity: Double = 0.18

    /// The built-in default palette with light and dark variants.
    public static let `default`: DSPalette = {
        let brand = BrandColors()
        return DSPalette(
            light: DSColors(),
            dark: DSColors(
                semantic: .darkDefaults,
                brand: brand,
                accent: AccentColors(
                    bgAccent: brand.tertiary.opacity(darkAccentOpacity),
                    strokeAccent: brand.secondary
                )
            )
        )
    }()
}
