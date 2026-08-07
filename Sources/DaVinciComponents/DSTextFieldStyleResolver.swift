import SwiftUI
import DaVinciTokens

// MARK: - Style Resolver

/// Resolves concrete colors and stroke widths from an appearance and state.
///
/// Precedence: `disabled > error > focused > normal`. Focus does not
/// eliminate the error indication — when both are present, error wins
/// but the border reinforces.
internal enum DSTextFieldStyleResolver {

    internal struct ResolvedStyle: Equatable {
        let borderColor: Color
        let borderWidth: CGFloat
    }

    @MainActor
    internal static func resolve(
        appearance: DSTextField.Appearance,
        state: DSTextField.FieldState,
        isFocused: Bool = false,
        theme: DSTheme
    ) -> ResolvedStyle {
        switch state {
        case .disabled:
            return ResolvedStyle(
                borderColor: theme.colors.semantic.textTertiary.opacity(0.5),
                borderWidth: StrokeTokens.hairline
            )
        case .error:
            return ResolvedStyle(
                borderColor: theme.colors.feedback.error,
                borderWidth: isFocused ? StrokeTokens.hairline * 1.5 : StrokeTokens.hairline
            )
        case .focused:
            switch appearance {
            case .filled:
                return ResolvedStyle(
                    borderColor: theme.colors.brand.primary,
                    borderWidth: StrokeTokens.hairline
                )
            case .outlined:
                return ResolvedStyle(
                    borderColor: theme.colors.brand.primary,
                    borderWidth: StrokeTokens.hairline * 1.5
                )
            }
        case .normal:
            switch appearance {
            case .filled:
                return ResolvedStyle(
                    borderColor: theme.colors.semantic.textTertiary,
                    borderWidth: StrokeTokens.hairline
                )
            case .outlined:
                return ResolvedStyle(
                    borderColor: theme.colors.semantic.textTertiary,
                    borderWidth: StrokeTokens.hairline
                )
            }
        }
    }
}
