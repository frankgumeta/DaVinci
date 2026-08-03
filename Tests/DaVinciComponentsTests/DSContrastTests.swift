import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciGallery
@testable import DaVinciTokens

@MainActor
@Suite("Automated Contrast")
struct DSContrastTests {
    @Test func semanticTextMeetsNormalTextContrast() throws {
        for theme in [DSTheme.defaultTheme, DSTheme.alternate] {
            for scheme in [ColorScheme.light, .dark] {
                let resolvedTheme = theme.resolved(for: scheme)
                let colors = resolvedTheme.colors.semantic
                let pairs = [
                    (colors.textPrimary, colors.bgPrimary),
                    (colors.textSecondary, colors.bgPrimary),
                    (colors.textTertiary, colors.bgPrimary),
                    (colors.textPrimary, colors.surfacePrimary),
                    (colors.textSecondary, colors.surfacePrimary)
                ]

                for (foreground, background) in pairs {
                    let ratio = try #require(
                        DSColorContrast.ratio(
                            foreground: foreground,
                            background: background,
                            colorScheme: scheme
                        )
                    )
                    #expect(ratio >= 4.5)
                }
            }
        }
    }

    @Test func componentForegroundSelectionMeetsNormalTextContrast() throws {
        for theme in [DSTheme.defaultTheme, DSTheme.alternate] {
            for scheme in [ColorScheme.light, .dark] {
                let resolvedTheme = theme.resolved(for: scheme)
                let backgrounds = [
                    resolvedTheme.colors.brand.primary,
                    resolvedTheme.colors.feedback.success,
                    resolvedTheme.colors.feedback.warning,
                    resolvedTheme.colors.feedback.error,
                    resolvedTheme.colors.semantic.bgTertiary
                ]

                for background in backgrounds {
                    let foreground = DSColorContrast.preferredForeground(
                        on: background,
                        candidates: [
                            resolvedTheme.colors.semantic.textPrimary,
                            resolvedTheme.colors.semantic.textOnBrand,
                            resolvedTheme.colors.semantic.textInverse
                        ],
                        colorScheme: scheme
                    )
                    let ratio = try #require(
                        DSColorContrast.ratio(
                            foreground: foreground,
                            background: background,
                            colorScheme: scheme
                        )
                    )
                    #expect(ratio >= 4.5)
                }
            }
        }
    }

    @Test func interactiveOutlinesMeetNonTextContrast() throws {
        for theme in [DSTheme.defaultTheme, DSTheme.alternate] {
            for scheme in [ColorScheme.light, .dark] {
                let resolvedTheme = theme.resolved(for: scheme)
                let colors = resolvedTheme.colors
                let pairs = [
                    (colors.brand.primary, colors.semantic.bgPrimary),
                    (colors.semantic.textTertiary, colors.semantic.bgPrimary),
                    (colors.feedback.error, colors.semantic.bgPrimary)
                ]

                for (foreground, background) in pairs {
                    let ratio = try #require(
                        DSColorContrast.ratio(
                            foreground: foreground,
                            background: background,
                            colorScheme: scheme
                        )
                    )
                    #expect(ratio >= 3.0)
                }
            }
        }
    }
}
