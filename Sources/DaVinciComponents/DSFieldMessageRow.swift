import SwiftUI
import DaVinciTokens

// MARK: - DSFieldMessageRow

/// Renders a `DSFieldMessage` below a field control.
///
/// This is an internal renderer designed for reuse by future field-like
/// components. It handles both `.supporting` and `.error` messages,
/// wraps long text, supports Dynamic Type, and includes a leading icon
/// for error messages so the message does not rely exclusively on color.
///
/// The message row is hidden from VoiceOver as a standalone element —
/// the parent field is responsible for announcing the error via its
/// accessibility value. This prevents double announcements.
internal struct DSFieldMessageRow: View {

    @Environment(\.dsTheme) private var theme

    let message: DSFieldMessage

    internal init(_ message: DSFieldMessage) {
        self.message = message
    }

    internal var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: SpacingTokens.space1) {
            if message.isError {
                Image(systemName: DSSymbol.errorIndicator.systemName)
                    .font(.system(size: theme.typography.caption.size))
                    .foregroundStyle(theme.colors.feedback.error)
                    .accessibilityHidden(true)
            }

            Text(message.text)
                .dsTextStyle(theme.typography.caption, family: theme.typography.family)
                .foregroundStyle(messageColor)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityHidden(true)
        }
    }

    private var messageColor: Color {
        switch message {
        case .supporting:
            theme.colors.semantic.textTertiary
        case .error:
            theme.colors.feedback.error
        }
    }
}
