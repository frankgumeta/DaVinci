import SwiftUI
import Testing
@testable import DaVinciTokens

@MainActor
@Suite("DSThemeValidator")
struct DSThemeValidatorTests {
    @Test func defaultThemeSatisfiesEveryContract() {
        #expect(DSThemeValidator.validate(.defaultTheme).isEmpty)
    }

    @Test func reportsIdentityTypographyAndMotionErrors() {
        let invalidStyle = DSTextStyle(
            size: 0,
            lineHeight: -1,
            weight: .regular
        )
        let typography = DSTypography(display: invalidStyle)
        let motion = DSMotion(fast: -.infinity, shimmerDuration: -1)
        let theme = DSTheme(
            name: "  ",
            colors: DSColors(),
            typography: typography,
            motion: motion
        )

        let issues = DSThemeValidator.validate(theme)

        #expect(issues.contains { $0.code == .emptyName })
        #expect(issues.contains { $0.code == .invalidTypography })
        #expect(issues.contains { $0.code == .invalidMotion })
    }

    @Test func reportsLowContrastInBothSchemes() {
        let white = Color.white
        let semantic = SemanticColors(
            textPrimary: white,
            textSecondary: white,
            textTertiary: white,
            textOnBrand: white,
            bgPrimary: white,
            surfacePrimary: white
        )
        let colors = DSColors(
            semantic: semantic,
            brand: BrandColors(primary: white, secondary: white, tertiary: white),
            accent: AccentColors(bgAccent: white, strokeAccent: white)
        )
        let issues = DSThemeValidator.validate(
            DSTheme(name: "Low contrast", colors: colors)
        )

        #expect(issues.contains { $0.code == .insufficientContrast && $0.scheme == .light })
        #expect(issues.contains { $0.code == .insufficientContrast && $0.scheme == .dark })
    }

    @Test func transparentPairsAreReportedAsUnresolvedWarnings() {
        let semantic = SemanticColors(textPrimary: .clear)
        let issues = DSThemeValidator.validate(
            DSTheme(name: "Transparent", colors: DSColors(semantic: semantic))
        )

        #expect(
            issues.contains {
                $0.code == .unresolvedColor && $0.severity == .warning
            }
        )
    }
}
