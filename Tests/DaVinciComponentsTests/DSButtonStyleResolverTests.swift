import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSButton Style Resolver")
@MainActor
struct DSButtonStyleResolverTests {

    @Test func textButtonLegacyAppearancesPreserveTheirTreatment() {
        let theme = DSTheme.defaultTheme.resolved(for: .light)

        let primary = DSButtonStyleResolver.resolve(
            appearance: DSButton.Appearance.primary,
            theme: theme,
            colorScheme: .light
        )
        #expect(primary.backgroundColor == theme.colors.brand.primary)
        #expect(primary.borderWidth == 0)

        let secondary = DSButtonStyleResolver.resolve(
            appearance: DSButton.Appearance.secondary,
            theme: theme,
            colorScheme: .light
        )
        #expect(secondary.backgroundColor == theme.colors.semantic.surfaceSecondary)
        #expect(secondary.foregroundColor == theme.colors.semantic.textPrimary)

        let outline = DSButtonStyleResolver.resolve(
            appearance: DSButton.Appearance.outline,
            theme: theme,
            colorScheme: .light
        )
        #expect(outline.backgroundColor == Color.clear)
        #expect(outline.foregroundColor == theme.colors.brand.primary)
        #expect(outline.borderColor == theme.colors.brand.primary)
        #expect(outline.borderWidth == StrokeTokens.default)
    }

    @Test func textButtonGhostIsTransparentAndBorderless() {
        for colorScheme in [ColorScheme.light, .dark] {
            let theme = DSTheme.defaultTheme.resolved(for: colorScheme)
            let style = DSButtonStyleResolver.resolve(
                appearance: DSButton.Appearance.ghost,
                theme: theme,
                colorScheme: colorScheme
            )
            #expect(style.backgroundColor == Color.clear)
            #expect(style.foregroundColor == theme.colors.semantic.textPrimary)
            #expect(style.borderWidth == 0)
        }
    }

    @Test func iconButtonLegacyAppearancesPreserveTheirTreatment() {
        let theme = DSTheme.defaultTheme.resolved(for: .light)

        let primary = DSButtonStyleResolver.resolve(
            appearance: DSIconButton.Appearance.primary,
            theme: theme
        )
        #expect(primary.backgroundColor == theme.colors.brand.primary)
        #expect(primary.foregroundColor == theme.colors.semantic.textOnBrand)

        let secondary = DSButtonStyleResolver.resolve(
            appearance: DSIconButton.Appearance.secondary,
            theme: theme
        )
        #expect(secondary.backgroundColor == theme.colors.semantic.surfaceSecondary)

        let outline = DSButtonStyleResolver.resolve(
            appearance: DSIconButton.Appearance.outline,
            theme: theme
        )
        #expect(outline.borderColor == theme.colors.brand.primary)
        #expect(outline.borderWidth == StrokeTokens.default)

        let accent = DSButtonStyleResolver.resolve(
            appearance: DSIconButton.Appearance.accent,
            theme: theme
        )
        #expect(accent.backgroundColor == theme.colors.accent.bgAccent)
        #expect(accent.foregroundColor == theme.colors.accent.strokeAccent)
        #expect(accent.borderColor == theme.colors.accent.strokeAccent)
    }

    @Test func iconButtonGhostMatchesTextButtonGhostTreatment() {
        for colorScheme in [ColorScheme.light, .dark] {
            let theme = DSTheme.defaultTheme.resolved(for: colorScheme)
            let textStyle = DSButtonStyleResolver.resolve(
                appearance: DSButton.Appearance.ghost,
                theme: theme,
                colorScheme: colorScheme
            )
            let iconStyle = DSButtonStyleResolver.resolve(
                appearance: DSIconButton.Appearance.ghost,
                theme: theme
            )
            #expect(iconStyle == textStyle)
        }
    }

    @Test func ghostForegroundMeetsTextContrast() throws {
        for colorScheme in [ColorScheme.light, .dark] {
            let theme = DSTheme.defaultTheme.resolved(for: colorScheme)
            let style = DSButtonStyleResolver.resolve(
                appearance: DSButton.Appearance.ghost,
                theme: theme,
                colorScheme: colorScheme
            )
            let ratio = DSColorContrast.ratio(
                foreground: style.foregroundColor,
                background: theme.colors.semantic.bgPrimary,
                colorScheme: colorScheme
            )
            #expect(try #require(ratio) >= 4.5)
        }
    }
}
