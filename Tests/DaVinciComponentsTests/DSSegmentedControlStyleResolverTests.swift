import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSSegmentedControl Style Resolver")
@MainActor
struct DSSegmentedControlStyleResolverTests {

    private let theme = DSTheme.defaultTheme

    @Test func filledPreservesLegacyContainerAndSelection() {
        let style = DSSegmentedControlStyleResolver.resolve(
            appearance: .filled,
            theme: theme,
            colorScheme: .light
        )
        #expect(style.containerBackground == theme.colors.semantic.bgSecondary)
        #expect(style.selectedBackground == theme.colors.brand.primary)
        #expect(style.selectedBorderWidth == 0)
    }

    @Test func subtleUsesTransparentContainerAndLowEmphasisCapsule() {
        let style = DSSegmentedControlStyleResolver.resolve(
            appearance: .subtle,
            theme: theme,
            colorScheme: .light
        )
        #expect(style.containerBackground == .clear)
        #expect(style.selectedForeground == theme.colors.semantic.textPrimary)
        #expect(style.selectedBackground == theme.colors.brand.primary.opacity(OpacityTokens.subtleFill))
        #expect(style.selectedBorder == theme.colors.brand.primary.opacity(OpacityTokens.subtleStroke))
        #expect(style.selectedBorderWidth == StrokeTokens.hairline)
    }

    @Test func subtleUsesResolvedDarkPrimaryText() {
        let darkTheme = theme.resolved(for: .dark)
        let style = DSSegmentedControlStyleResolver.resolve(
            appearance: .subtle,
            theme: darkTheme,
            colorScheme: .dark
        )
        #expect(style.selectedForeground == darkTheme.colors.semantic.textPrimary)
    }
}
