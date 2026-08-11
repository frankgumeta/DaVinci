import SwiftUI
import DaVinciTokens

// MARK: - DSTextField

/// A themed text field component that reads tokens from the `DSTheme` environment.
///
/// `DSTextField` supports three visual appearances — `.filled` (the default,
/// matching v1.2.0), `.outlined`, and `.underlined` — and derives its visual
/// state from focus, error, and the SwiftUI `.disabled(...)` modifier.
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
        /// Transparent background with a border along the bottom edge only.
        case underlined
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
    private let visualStateOverride: FieldState?

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

    /// Creates a configured field with a deterministic visual state for
    /// internal previews and snapshot coverage.
    internal init(
        _ label: String,
        text: Binding<String>,
        prompt: String? = nil,
        configuration: Configuration,
        visualStateOverride: FieldState
    ) {
        self.init(
            label,
            text: text,
            prompt: prompt,
            labelVisibility: configuration.labelVisibility,
            accessibilityLabel: nil,
            accessibilityHint: nil,
            fieldMessage: configuration.message,
            appearance: configuration.appearance,
            leadingSymbol: configuration.leading,
            trailingAction: configuration.trailingAction,
            characterLimit: configuration.characterLimit,
            visualStateOverride: visualStateOverride
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
        characterLimit: Int?,
        visualStateOverride: FieldState? = nil
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
        self.visualStateOverride = visualStateOverride
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
        .padding(.leading, SpacingTokens.space3)
        .padding(.trailing, showsTrailingAction ? SpacingTokens.space1 : SpacingTokens.space3)
        .frame(minHeight: ControlHeightTokens.medium)
        .background(containerBackground)
        .clipShape(containerShape)
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
        case .outlined, .underlined:
            Color.clear
        }
    }

    private var containerShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: appearance == .underlined ? 0 : RadiusTokens.small)
    }

    @ViewBuilder
    private var containerBorder: some View {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: appearance,
            state: fieldState,
            isFocused: isFocused,
            theme: theme
        )
        switch appearance {
        case .filled, .outlined:
            RoundedRectangle(cornerRadius: RadiusTokens.small)
                .stroke(resolved.borderColor, lineWidth: resolved.borderWidth)
        case .underlined:
            Rectangle()
                .fill(resolved.borderColor)
                .frame(height: resolved.borderWidth)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }

}

// MARK: - State and Accessibility

extension DSTextField {

    internal var fieldState: FieldState {
        visualStateOverride ?? FieldState.resolve(
            isEnabled: environmentIsEnabled,
            hasError: fieldMessage?.isError ?? false,
            isFocused: isFocused
        )
    }

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
