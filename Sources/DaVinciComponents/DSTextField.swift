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
        VStack(alignment: .leading, spacing: SpacingTokens.space1) {
            if showsLabel { labelRow }
            fieldContainer
            if let message = fieldMessage {
                DSFieldMessageRow(message)
            }
            if let limit = characterLimit {
                characterCounterRow(limit)
            }
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
        HStack(spacing: SpacingTokens.space2) {
            if let symbol = leadingSymbol {
                leadingAccessory(symbol)
            }
            inputField
            if let action = trailingAction, showsTrailingAction {
                trailingAccessory(action)
            }
        }
        .padding(.horizontal, SpacingTokens.space3)
        .frame(minHeight: ControlHeightTokens.medium)
        .background(containerBackground)
        .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.small))
        .overlay(containerBorder)
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
        .onAppear(perform: enforceCharacterLimit)
    }

    private var showsTrailingAction: Bool {
        switch trailingAction {
        case .clear: return !text.isEmpty
        case .none: return false
        }
    }

    private func leadingAccessory(_ symbol: DSSymbol) -> some View {
        Image(systemName: symbol.systemName)
            .font(.system(size: theme.typography.body.size))
            .foregroundStyle(accessoryColor)
            .accessibilityHidden(true)
    }

    private func trailingAccessory(_ action: DSTextFieldTrailingAction) -> some View {
        switch action {
        case .clear:
            Button {
                clearText()
                isFocused = true
            } label: {
                Image(systemName: DSSymbol.clear.systemName)
                    .font(.system(size: theme.typography.body.size))
                    .foregroundStyle(accessoryColor)
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Clear text")
            .accessibilityHint("Removes the entered text")
        }
    }

    private var accessoryColor: Color {
        switch fieldState {
        case .disabled:
            theme.colors.semantic.textTertiary.opacity(0.5)
        case .error:
            theme.colors.feedback.error
        default:
            theme.colors.semantic.textTertiary
        }
    }

    private var inputField: some View {
        TextField(
            label,
            text: constrainedText,
            prompt: prompt.map { Text($0).foregroundStyle(theme.colors.semantic.textTertiary) }
        )
        .dsTextStyle(theme.typography.body, family: theme.typography.family)
        .foregroundStyle(theme.colors.semantic.textPrimary)
        .focused($isFocused)
    }

    // MARK: - Character Limit

    private var constrainedText: Binding<String> {
        Binding(
            get: { text },
            set: { text = Self.constrainedText($0, limit: characterLimit) }
        )
    }

    internal static func constrainedText(_ value: String, limit: Int?) -> String {
        guard let limit else { return value }
        return String(value.prefix(max(0, limit)))
    }

    private func enforceCharacterLimit() {
        let constrained = Self.constrainedText(text, limit: characterLimit)
        if constrained != text {
            text = constrained
        }
    }

    internal func clearText() {
        text = ""
    }

    @ViewBuilder
    private func characterCounterRow(_ limit: Int) -> some View {
        HStack {
            Spacer()
            Text("\(text.count)/\(limit)")
                .dsTextStyle(theme.typography.caption, family: theme.typography.family)
                .foregroundStyle(counterColor(limit))
                .accessibilityHidden(true)
        }
    }

    private func counterColor(_ limit: Int) -> Color {
        if fieldState == .disabled {
            return theme.colors.semantic.textTertiary.opacity(0.5)
        }

        let count = text.count
        if count > limit {
            return theme.colors.feedback.error
        }
        if count >= limit - 5 {
            return theme.colors.semantic.textSecondary
        }
        return theme.colors.semantic.textTertiary
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
            isFocused: isFocused,
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
        var parts = [enteredValue]

        if let limit = characterLimit {
            parts.append("\(min(text.count, limit)) of \(limit) characters")
        }

        if let message = fieldMessage, message.isError {
            parts.append("Error: \(message.text)")
        }

        return parts.joined(separator: ". ")
    }

    internal var resolvedAccessibilityHint: String? {
        let supportingText: String?
        if case .supporting(let text) = fieldMessage {
            supportingText = text
        } else {
            supportingText = nil
        }

        let parts = [accessibilityHint, supportingText]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return parts.isEmpty ? nil : parts.joined(separator: ". ")
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: resolvedAccessibilityLabel,
            value: resolvedAccessibilityValue,
            hint: resolvedAccessibilityHint,
            isEnabled: environmentIsEnabled
        )
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

#Preview("DSTextField — Accessories") {
    @Previewable @State var text = "Frank"
    let person = DSSymbol(systemName: "person")!
    VStack(spacing: 16) {
        DSTextField(
            "Name",
            text: $text,
            configuration: .filled.leading(person).trailing(.clear)
        )
        DSTextField(
            "Search",
            text: $text,
            configuration: .outlined
                .labelVisibility(.hidden)
                .leading(DSSymbol(systemName: "magnifyingglass")!)
                .trailing(.clear)
        )
    }
    .padding()
}

#Preview("DSTextField — Outlined") {
    @Previewable @State var text = ""
    VStack(spacing: 16) {
        DSTextField("Email", text: $text, prompt: "you@example.com", configuration: .outlined)
        DSTextField("Name", text: .constant("Frank"), configuration: .outlined)
        DSTextField("Error", text: .constant("bad@"), configuration: .outlined.message(.error("Invalid")))
    }
    .padding()
}

#Preview("DSTextField — Messages") {
    @Previewable @State var text = "invalid@"
    VStack(spacing: 16) {
        DSTextField(
            "Email",
            text: $text,
            configuration: .filled.message(.supporting("We will never share your email"))
        )
        DSTextField(
            "Email",
            text: $text,
            configuration: .filled.message(.error("Invalid email format"))
        )
        DSTextField(
            "Email",
            text: $text,
            configuration: .outlined.message(.error("Invalid email format"))
        )
    }
    .padding()
}

#Preview("DSTextField — Character Limit") {
    @Previewable @State var text = "Hello"
    VStack(spacing: 16) {
        DSTextField(
            "Title",
            text: $text,
            configuration: .filled.characterLimit(10)
        )
        DSTextField(
            "Bio",
            text: $text,
            configuration: .outlined
                .characterLimit(20)
                .message(.supporting("Max 20 characters"))
        )
    }
    .padding()
}
