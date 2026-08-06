import SwiftUI
import DaVinciTokens

// MARK: - DSTextField

/// A themed text field component that reads tokens from the `DSTheme` environment.
///
/// `DSTextField` supports two visual appearances — `.filled` (the default,
/// matching v1.2.0) and `.outlined` — and derives its visual state from focus,
/// error, and the SwiftUI `.disabled(...)` modifier.
///
/// ## Basic Usage
///
/// ```swift
/// DSTextField("Email", text: $email, prompt: "you@example.com")
/// ```
///
/// ## Error State
///
/// ```swift
/// DSTextField("Email", text: $email, error: "Invalid email format")
/// ```
///
/// ## Appearance
///
/// The default appearance is `.filled`, which preserves the v1.2.0 render.
/// Additional appearances and accessories are introduced in later phases.
///
/// ## Topics
///
/// ### Creating a Text Field
/// - ``init(_:text:prompt:showsLabel:accessibilityLabel:accessibilityHint:error:)``
///
/// ### Appearance
/// - ``Appearance``
public struct DSTextField: View {

    /// Visual appearance of the field container.
    public enum Appearance: Sendable {
        /// Filled background with a subtle border (default, matches v1.2.0).
        case filled
        /// Transparent background with a neutral border.
        case outlined
    }

    /// Resolved visual state, ordered by precedence:
    /// `disabled > error > focused > normal`.
    internal enum FieldState: Sendable, Equatable {
        case disabled
        case error
        case focused
        case normal

        /// Derives the state from the given inputs, applying precedence.
        static func resolve(isEnabled: Bool, hasError: Bool, isFocused: Bool) -> FieldState {
            if !isEnabled { return .disabled }
            if hasError { return .error }
            if isFocused { return .focused }
            return .normal
        }
    }

    @Environment(\.dsTheme) private var theme
    @Environment(\.isEnabled) private var environmentIsEnabled

    private let label: String
    @Binding private var text: String
    private let prompt: String?
    private let showsLabel: Bool
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    private let error: String?
    private let appearance: Appearance

    @FocusState private var isFocused: Bool

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
        self.appearance = .filled
    }

    internal init(
        _ label: String,
        text: Binding<String>,
        prompt: String?,
        showsLabel: Bool,
        accessibilityLabel: String?,
        accessibilityHint: String?,
        error: String?,
        appearance: Appearance
    ) {
        self.label = label
        self._text = text
        self.prompt = prompt
        self.showsLabel = showsLabel
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.error = error
        self.appearance = appearance
    }

    public var body: some View {
        if showsLabel {
            VStack(alignment: .leading, spacing: SpacingTokens.space1) {
                labelRow
                fieldContainer
            }
        } else {
            fieldContainer
        }
    }

    // MARK: - Composed parts

    private var labelRow: some View {
        Text(label)
            .dsTextStyle(theme.typography.caption, family: theme.typography.family)
            .foregroundStyle(theme.colors.semantic.textSecondary)
    }

    private var fieldContainer: some View {
        inputField
            .padding(.horizontal, SpacingTokens.space3)
            .frame(minHeight: ControlHeightTokens.medium)
            .background(containerBackground)
            .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.small))
            .overlay(containerBorder)
            .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    private var inputField: some View {
        TextField(
            label,
            text: $text,
            prompt: prompt.map { Text($0).foregroundStyle(theme.colors.semantic.textTertiary) }
        )
        .dsTextStyle(theme.typography.body, family: theme.typography.family)
        .foregroundStyle(theme.colors.semantic.textPrimary)
        .focused($isFocused)
    }

    @ViewBuilder
    private var containerBackground: some View {
        switch appearance {
        case .filled:
            theme.colors.semantic.bgSecondary
        case .outlined:
            Color.clear
        }
    }

    @ViewBuilder
    private var containerBorder: some View {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: appearance,
            state: fieldState,
            theme: theme
        )
        RoundedRectangle(cornerRadius: RadiusTokens.small)
            .stroke(resolved.borderColor, lineWidth: resolved.borderWidth)
    }

    // MARK: - State

    internal var fieldState: FieldState {
        FieldState.resolve(
            isEnabled: environmentIsEnabled,
            hasError: error != nil,
            isFocused: isFocused
        )
    }

    // MARK: - Accessibility (preserved from v1.2.0)

    private var resolvedAccessibilityLabel: String {
        accessibilityLabel ?? label
    }

    internal var resolvedAccessibilityValue: String {
        let enteredValue = text.isEmpty ? (prompt ?? "Empty") : text
        if let error = error {
            return "\(enteredValue). Error: \(error)"
        }
        return enteredValue
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: resolvedAccessibilityLabel,
            value: resolvedAccessibilityValue,
            hint: accessibilityHint,
            isEnabled: environmentIsEnabled
        )
    }
}

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
                borderWidth: StrokeTokens.hairline
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

#Preview("DSTextField — Error") {
    @Previewable @State var text = "invalid@"
    VStack(spacing: 16) {
        DSTextField("Email", text: $text, error: "Invalid email format")
    }
    .padding()
}

#Preview("DSTextField — Disabled") {
    @Previewable @State var text = "Frank"
    VStack(spacing: 16) {
        DSTextField("Name", text: $text)
            .disabled(true)
    }
    .padding()
}
