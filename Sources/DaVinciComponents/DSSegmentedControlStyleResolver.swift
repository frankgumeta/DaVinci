import SwiftUI
import DaVinciTokens

// MARK: - Segmented Control Style Resolver

internal enum DSSegmentedControlStyleResolver {

    internal struct ResolvedStyle: Equatable {
        let containerBackground: Color
        let selectedBackground: Color
        let selectedForeground: Color
        let selectedBorder: Color
        let selectedBorderWidth: CGFloat
    }

    @MainActor
    internal static func resolve(
        appearance: DSSegmentedControl.Appearance,
        theme: DSTheme,
        colorScheme: ColorScheme
    ) -> ResolvedStyle {
        switch appearance {
        case .filled:
            return ResolvedStyle(
                containerBackground: theme.colors.semantic.bgSecondary,
                selectedBackground: theme.colors.brand.primary,
                selectedForeground: DSColorContrast.preferredForeground(
                    on: theme.colors.brand.primary,
                    candidates: [
                        theme.colors.semantic.textPrimary,
                        theme.colors.semantic.textOnBrand,
                        theme.colors.semantic.textInverse
                    ],
                    colorScheme: colorScheme
                ),
                selectedBorder: .clear,
                selectedBorderWidth: 0
            )
        case .subtle:
            return ResolvedStyle(
                containerBackground: .clear,
                selectedBackground: theme.colors.brand.primary.opacity(OpacityTokens.subtleFill),
                selectedForeground: theme.colors.semantic.textPrimary,
                selectedBorder: theme.colors.brand.primary.opacity(OpacityTokens.subtleStroke),
                selectedBorderWidth: StrokeTokens.hairline
            )
        }
    }
}
