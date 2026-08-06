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
/// ## Reusable Configuration
///
/// For fields that share appearance, accessories or messages, build a
/// ``Configuration`` once and pass it to multiple fields:
///
/// ```swift
/// let accountField: DSTextField.Configuration = .outlined
///     .labelVisibility(.hidden)
///     .leading(DSSymbol(systemName: "person")!)
///     .trailing(.clear)
///     .message(.supporting("Helper text"))
///
/// DSTextField("Email", text: $email, configuration: accountField)
/// ```
///
/// ## Topics
///
/// ### Creating a Text Field
/// - ``init(_:text:prompt:showsLabel:accessibilityLabel:accessibilityHint:error:)``
/// - ``init(_:text:prompt:configuration:accessibilityLabel:accessibilityHint:)``
///
/// ### Appearance
/// - ``Appearance``
///
/// ### Configuration
/// - ``Configuration``
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
    private let labelVisibility: DSTextFieldLabelVisibility
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    private let fieldMessage: DSFieldMessage?
    private let appearance: Appearance
    private let leadingSymbol: DSSymbol?
    private let trailingAction: DSTextFieldTrailingAction?
    private let characterLimit: Int?

    @FocusState private var isFocused: Bool

    // MARK: - v1.2.0 Initializer (forwarding)

    public init(
        _ label: String,
        text: Binding<String>,
        prompt: String? = nil,
        showsLabel: Bool = true,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        error: String? = nil
    ) {
        self.init(
            label,
            text: text,
            prompt: prompt,
            labelVisibility: showsLabel ? .visible : .hidden,
            accessibilityLabel: accessibilityLabel,
            accessibilityHint: accessibilityHint,
            fieldMessage: error.map { .error($0) },
            appearance: .filled,
            leadingSymbol: nil,
            trailingAction: nil,
            characterLimit: nil
        )
    }

    // MARK: - Configuration Initializer

    public init(
        _ label: String,
        text: Binding<String>,
        prompt: String? = nil,
        configuration: Configuration,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil
    ) {
        self.init(
            label,
            text: text,
            prompt: prompt,
            labelVisibility: configuration.labelVisibility,
            accessibilityLabel: accessibilityLabel,
            accessibilityHint: accessibilityHint,
            fieldMessage: configuration.message,
            appearance: configuration.appearance,
            leadingSymbol: configuration.leading,
            trailingAction: configuration.trailingAction,
            characterLimit: configuration.characterLimit
        )
    }

    // MARK: - Internal Canonical Initializer

    internal init(
        _ label: String,
        text: Binding<String>,
        prompt: String?,
        labelVisibility: DSTextFieldLabelVisibility,
        accessibilityLabel: String?,
        accessibilityHint: String?,
        fieldMessage: DSFieldMessage?,
        appearance: Appearance,
        leadingSymbol: DSSymbol?,
        trailingAction: DSTextFieldTrailingAction?,
        characterLimit: Int?
    ) {
        self.label = label
        self._text = text
        self.prompt = prompt
        self.labelVisibility = labelVisibility
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.fieldMessage = fieldMessage
        self.appearance = appearance
        self.leadingSymbol = leadingSymbol
        self.trailingAction = trailingAction
        self.characterLimit = characterLimit
    }

    // MARK: - Body

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

    private var showsLabel: Bool { labelVisibility == .visible }

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
            hasError: fieldMessage?.isError ?? false,
            isFocused: isFocused
        )
    }

    // MARK: - Accessibility (preserved from v1.2.0)

    private var resolvedAccessibilityLabel: String {
        accessibilityLabel ?? label
    }

    internal var resolvedAccessibilityValue: String {
        let enteredValue = text.isEmpty ? (prompt ?? "Empty") : text
        if let message = fieldMessage, message.isError {
            return "\(enteredValue). Error: \(message.text)"
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

// MARK: - Configuration Support Types

/// Whether the field label is rendered above the input.
public enum DSTextFieldLabelVisibility: Sendable {
    case visible
    case hidden
}

/// Trailing accessory action. Only ``clear`` is supported in 1.3.0.
public enum DSTextFieldTrailingAction: Sendable {
    /// Clears the text binding and retains focus.
    case clear
}

// MARK: - Configuration

extension DSTextField {

    /// Reusable, value-type configuration for ``DSTextField``.
    ///
    /// Build a configuration once and share it across multiple fields. Each
    /// builder method returns a copy with the requested change applied,
    /// leaving the original unchanged.
    ///
    /// ```swift
    /// let account: DSTextField.Configuration = .outlined
    ///     .labelVisibility(.hidden)
    ///     .leading(DSSymbol(systemName: "person")!)
    ///     .trailing(.clear)
    ///     .message(.supporting("Enter your account email"))
    /// ```
    ///
    /// `DSFieldMessage` is an enum, so ``supporting`` and ``error`` are
    /// mutually exclusive by construction — a configuration cannot hold
    /// both at the same time.
    ///
    /// ## Topics
    ///
    /// ### Presets
    /// - ``filled``
    /// - ``outlined``
    ///
    /// ### Builders
    /// - ``labelVisibility(_:)``
    /// - ``leading(_:)``
    /// - ``trailing(_:)``
    /// - ``message(_:)``
    /// - ``characterLimit(_:)``
    public struct Configuration: Sendable {

        /// Visual appearance of the field container.
        public let appearance: DSTextField.Appearance

        /// Whether the label row is rendered.
        public let labelVisibility: DSTextFieldLabelVisibility

        /// Optional leading decorative symbol.
        public let leading: DSSymbol?

        /// Optional trailing action.
        public let trailingAction: DSTextFieldTrailingAction?

        /// Optional auxiliary message (supporting or error).
        public let message: DSFieldMessage?

        /// Optional maximum character count. When set, the binding is
        /// prevented from exceeding this count.
        public let characterLimit: Int?

        private init(
            appearance: DSTextField.Appearance,
            labelVisibility: DSTextFieldLabelVisibility,
            leading: DSSymbol? = nil,
            trailingAction: DSTextFieldTrailingAction? = nil,
            message: DSFieldMessage? = nil,
            characterLimit: Int? = nil
        ) {
            self.appearance = appearance
            self.labelVisibility = labelVisibility
            self.leading = leading
            self.trailingAction = trailingAction
            self.message = message
            self.characterLimit = characterLimit
        }

        /// Filled appearance with a visible label (default, matches v1.2.0).
        public static let filled = Configuration(
            appearance: .filled,
            labelVisibility: .visible
        )

        /// Outlined appearance with a visible label.
        public static let outlined = Configuration(
            appearance: .outlined,
            labelVisibility: .visible
        )

        /// Returns a copy with the given label visibility.
        public func labelVisibility(_ visibility: DSTextFieldLabelVisibility) -> Configuration {
            Configuration(
                appearance: appearance,
                labelVisibility: visibility,
                leading: leading,
                trailingAction: trailingAction,
                message: message,
                characterLimit: characterLimit
            )
        }

        /// Returns a copy with the given leading symbol.
        public func leading(_ symbol: DSSymbol) -> Configuration {
            Configuration(
                appearance: appearance,
                labelVisibility: labelVisibility,
                leading: symbol,
                trailingAction: trailingAction,
                message: message,
                characterLimit: characterLimit
            )
        }

        /// Returns a copy with the given trailing action.
        public func trailing(_ action: DSTextFieldTrailingAction) -> Configuration {
            Configuration(
                appearance: appearance,
                labelVisibility: labelVisibility,
                leading: leading,
                trailingAction: action,
                message: message,
                characterLimit: characterLimit
            )
        }

        /// Returns a copy with the given field message.
        public func message(_ newMessage: DSFieldMessage) -> Configuration {
            Configuration(
                appearance: appearance,
                labelVisibility: labelVisibility,
                leading: leading,
                trailingAction: trailingAction,
                message: newMessage,
                characterLimit: characterLimit
            )
        }

        /// Returns a copy with the given character limit.
        public func characterLimit(_ limit: Int) -> Configuration {
            Configuration(
                appearance: appearance,
                labelVisibility: labelVisibility,
                leading: leading,
                trailingAction: trailingAction,
                message: message,
                characterLimit: limit
            )
        }
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

#Preview("DSTextField — Configuration") {
    @Previewable @State var text = ""
    let config: DSTextField.Configuration = .outlined
        .labelVisibility(.visible)
        .message(.supporting("Enter your account email"))

    VStack(spacing: 16) {
        DSTextField("Email", text: $text, prompt: "you@example.com", configuration: config)
        DSTextField("Username", text: $text, configuration: .filled.message(.error("Already taken")))
    }
    .padding()
}
