import SwiftUI
import DaVinciTokens

// MARK: - DSButtonResolvedStyle

internal struct DSButtonResolvedStyle: Equatable {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
}

// MARK: - DSButtonStyleResolver

internal enum DSButtonStyleResolver {

    @MainActor
    static func resolve(
        appearance: DSButton.Appearance,
        theme: DSTheme,
        colorScheme: ColorScheme
    ) -> DSButtonResolvedStyle {
        switch appearance {
        case .primary:
            let background = theme.colors.brand.primary
            return DSButtonResolvedStyle(
                backgroundColor: background,
                foregroundColor: DSColorContrast.preferredForeground(
                    on: background,
                    candidates: [
                        theme.colors.semantic.textPrimary,
                        theme.colors.semantic.textOnBrand,
                        theme.colors.semantic.textInverse
                    ],
                    colorScheme: colorScheme
                ),
                borderColor: .clear,
                borderWidth: 0
            )
        case .secondary:
            return DSButtonResolvedStyle(
                backgroundColor: theme.colors.semantic.surfaceSecondary,
                foregroundColor: theme.colors.semantic.textPrimary,
                borderColor: .clear,
                borderWidth: 0
            )
        case .outline:
            return DSButtonResolvedStyle(
                backgroundColor: .clear,
                foregroundColor: theme.colors.brand.primary,
                borderColor: theme.colors.brand.primary,
                borderWidth: StrokeTokens.default
            )
        case .ghost:
            return DSButtonResolvedStyle(
                backgroundColor: .clear,
                foregroundColor: theme.colors.semantic.textPrimary,
                borderColor: .clear,
                borderWidth: 0
            )
        }
    }

    static func resolve(
        appearance: DSIconButton.Appearance,
        theme: DSTheme
    ) -> DSButtonResolvedStyle {
        switch appearance {
        case .primary:
            return DSButtonResolvedStyle(
                backgroundColor: theme.colors.brand.primary,
                foregroundColor: theme.colors.semantic.textOnBrand,
                borderColor: .clear,
                borderWidth: 0
            )
        case .secondary:
            return DSButtonResolvedStyle(
                backgroundColor: theme.colors.semantic.surfaceSecondary,
                foregroundColor: theme.colors.semantic.textPrimary,
                borderColor: .clear,
                borderWidth: 0
            )
        case .outline:
            return DSButtonResolvedStyle(
                backgroundColor: .clear,
                foregroundColor: theme.colors.brand.primary,
                borderColor: theme.colors.brand.primary,
                borderWidth: StrokeTokens.default
            )
        case .accent:
            return DSButtonResolvedStyle(
                backgroundColor: theme.colors.accent.bgAccent,
                foregroundColor: theme.colors.accent.strokeAccent,
                borderColor: theme.colors.accent.strokeAccent,
                borderWidth: StrokeTokens.default
            )
        case .ghost:
            return DSButtonResolvedStyle(
                backgroundColor: .clear,
                foregroundColor: theme.colors.semantic.textPrimary,
                borderColor: .clear,
                borderWidth: 0
            )
        }
    }
}
