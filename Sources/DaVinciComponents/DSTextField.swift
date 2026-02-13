import SwiftUI
import DaVinciTokens

// MARK: - DSTextField

/// A themed text field component that reads tokens from the `DSTheme` environment.
public struct DSTextField: View {

    @Environment(\.dsTheme) private var theme

    private let label: String
    @Binding private var text: String
    private let prompt: String?
    private let showsLabel: Bool
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    private let error: String?

    public init(
        _ label: String,
        text: Binding<String>,
        prompt: String? = nil,
        showsLabel: Bool = true,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        error: String? = nil
    ) {
        self.label = label
        self._text = text
        self.prompt = prompt
        self.showsLabel = showsLabel
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.error = error
    }

    public var body: some View {
        if showsLabel {
            VStack(alignment: .leading, spacing: SpacingTokens.space1) {
                Text(label)
                    .font(theme.typography.caption.font(family: theme.typography.family))
                    .foregroundStyle(theme.colors.semantic.textSecondary)

                textField
            }
        } else {
            textField
        }
    }

    private var textField: some View {
        TextField(
            label,
            text: $text,
            prompt: prompt.map { Text($0).foregroundStyle(theme.colors.semantic.textTertiary) }
        )
        .font(theme.typography.body.font(family: theme.typography.family))
        .foregroundStyle(theme.colors.semantic.textPrimary)
        .padding(.horizontal, SpacingTokens.space3)
        .frame(minHeight: ControlHeightTokens.medium)
        .background(theme.colors.semantic.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.small))
        .overlay(
            RoundedRectangle(cornerRadius: RadiusTokens.small)
                .stroke(error != nil ? theme.colors.feedback.error : theme.colors.semantic.stroke, lineWidth: StrokeTokens.hairline)
        )
        .accessibilityLabel(resolvedAccessibilityLabel)
        .modifier(AccessibilityHintModifier(hint: accessibilityHint))
        .accessibilityValue(resolvedAccessibilityValue)
    }
    
    private var resolvedAccessibilityLabel: String {
        accessibilityLabel ?? label
    }
    
    private var resolvedAccessibilityValue: String {
        if let error = error {
            return "Error: \(error)"
        }
        return text.isEmpty ? (prompt ?? "Empty") : text
    }
}

// MARK: - Previews

#Preview("DSTextField") {
    @Previewable @State var text = ""
    VStack(spacing: 16) {
        DSTextField("Email", text: $text, prompt: "you@example.com")
        DSTextField("Name", text: .constant("Frank Gumeta"))
        DSTextField("Search", text: $text, prompt: "Search…", showsLabel: false)
    }
    .padding()
}

#Preview("DSTextField — Dark") {
    @Previewable @State var text = ""
    VStack(spacing: 16) {
        DSTextField("Email", text: $text, prompt: "you@example.com")
        DSTextField("Name", text: .constant("Frank Gumeta"))
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

// MARK: - AccessibilityHintModifier

private struct AccessibilityHintModifier: ViewModifier {
    let hint: String?
    
    func body(content: Content) -> some View {
        if let hint = hint {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}
