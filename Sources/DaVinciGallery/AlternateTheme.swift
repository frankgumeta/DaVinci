import SwiftUI
import DaVinciTokens

// MARK: - AlternateTheme

// MARK: - Alternate Brand & Feedback

private let alternateBrand = BrandColors(
    primary: Color(red: 0.91, green: 0.30, blue: 0.24),
    secondary: Color(red: 0.95, green: 0.50, blue: 0.40),
    tertiary: Color(red: 0.98, green: 0.72, blue: 0.65)
)

private let alternateFeedback = FeedbackColors(
    success: Color(red: 0.18, green: 0.70, blue: 0.49),
    warning: Color(red: 0.95, green: 0.65, blue: 0.12),
    error: Color(red: 0.80, green: 0.17, blue: 0.37),
    info: Color(red: 0.36, green: 0.42, blue: 0.75)
)

private let alternateTypography = DSTypography(
    family: FontFamily(brand: "Georgia"),
    display: DSTextStyle(size: 36, lineHeight: 44, weight: .bold),
    title: DSTextStyle(size: 26, lineHeight: 32, weight: .bold),
    headline: DSTextStyle(size: 20, lineHeight: 26, weight: .semibold),
    body: DSTextStyle(size: 16, lineHeight: 24, weight: .regular),
    callout: DSTextStyle(size: 14, lineHeight: 20, weight: .regular),
    caption: DSTextStyle(size: 12, lineHeight: 16, weight: .regular),
    overline: DSTextStyle(size: 11, lineHeight: 14, weight: .medium)
)

extension DSTheme {
    /// An alternate theme with a warm coral brand, adjusted feedback colors,
    /// and a rounded-friendly typography using Georgia.
    /// Provides both light and dark palettes.
    public static let alternate = DSTheme(
        name: "alternate",
        palette: DSPalette(
            light: DSColors(brand: alternateBrand, feedback: alternateFeedback),
            dark: DSColors(
                semantic: .darkDefaults,
                brand: alternateBrand,
                accent: AccentColors(
                    bgAccent: alternateBrand.tertiary.opacity(0.18),
                    strokeAccent: alternateBrand.secondary
                ),
                feedback: alternateFeedback
            )
        ),
        typography: alternateTypography
    )
}
