import SwiftUI
import DaVinciTokens

// MARK: - DSBadgeResolvedStyle

internal struct DSBadgeResolvedStyle: Equatable {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
}

// MARK: - DSBadgeStyleResolver

internal enum DSBadgeStyleResolver {

    @MainActor
    static func resolve(
        tone: DSBadge.Tone,
        appearance: DSBadge.Appearance,
        theme: DSTheme,
        colorScheme: ColorScheme
    ) -> DSBadgeResolvedStyle {
        let toneColor = toneColor(for: tone, theme: theme)

        switch appearance {
        case .filled:
            let background = filledBackgroundColor(for: tone, theme: theme)
            return DSBadgeResolvedStyle(
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

        case .subtle:
            return DSBadgeResolvedStyle(
                backgroundColor: toneColor.opacity(OpacityTokens.subtleFill),
                foregroundColor: theme.colors.semantic.textPrimary,
                borderColor: toneColor.opacity(OpacityTokens.subtleStroke),
                borderWidth: StrokeTokens.hairline
            )

        case .outlined:
            return DSBadgeResolvedStyle(
                backgroundColor: .clear,
                foregroundColor: theme.colors.semantic.textPrimary,
                borderColor: toneColor,
                borderWidth: StrokeTokens.hairline
            )
        }
    }

    static func filledBackgroundColor(for tone: DSBadge.Tone, theme: DSTheme) -> Color {
        switch tone {
        case .brand:   return theme.colors.brand.primary
        case .success: return theme.colors.feedback.success
        case .warning: return theme.colors.feedback.warning
        case .error:   return theme.colors.feedback.error
        case .neutral: return theme.colors.semantic.bgTertiary
        }
    }

    static func toneColor(for tone: DSBadge.Tone, theme: DSTheme) -> Color {
        switch tone {
        case .brand:   return theme.colors.textEmphasis.brand
        case .success: return theme.colors.textEmphasis.success
        case .warning: return theme.colors.textEmphasis.warning
        case .error:   return theme.colors.textEmphasis.error
        case .neutral: return theme.colors.semantic.textSecondary
        }
    }
}
