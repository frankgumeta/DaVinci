import SwiftUI
import DaVinciTokens

// MARK: - DSActionRow

/// A row that performs an action when tapped.
///
/// This is the interactive wrapper around ``DSListRow``: the row supplies the layout,
/// `DSActionRow` supplies the button semantics, press feedback, disabled and loading
/// states. Splitting them means a new accessory never requires a new row type.
///
/// ```swift
/// DSActionRow(action: openLanguageSettings) {
///     DSListRow(
///         leading: { Image(systemName: "globe") },
///         trailing: { DSRowAccessory(.chevron) }
///     ) {
///         DSText("Language", role: .body)
///     }
/// }
/// ```
///
/// ## Accessibility
///
/// Carries the `isButton` trait, exposes `hint`, and reports the disabled state.
/// While `isLoading` is true the row is non-interactive and announces itself as busy,
/// so a second tap cannot start the same work twice.
public struct DSActionRow<Content: View>: View {

    @Environment(\.dsTheme) private var theme

    private let content: Content
    private let isDisabled: Bool
    private let isLoading: Bool
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    private let action: @MainActor () -> Void

    public init(
        isDisabled: Bool = false,
        isLoading: Bool = false,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action
        self.content = content()
    }

    public var body: some View {
        Button(action: action) {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                // Inside the label and before the content shape, so the whole
                // minimum height is tappable, not just the text.
                .frame(minHeight: ControlHeightTokens.minimumHitTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(DSPressableButtonStyle(duration: theme.motion.fast))
        .disabled(!isInteractive)
        .opacity(isDisabled ? OpacityTokens.disabled : 1)
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    /// Loading rows are inert, so the same action cannot be triggered twice.
    internal var isInteractive: Bool {
        !isDisabled && !isLoading
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: accessibilityLabel,
            value: isLoading ? DSLocalizedStrings.value(.loading) : nil,
            hint: accessibilityHint,
            traits: .isButton,
            isEnabled: isInteractive,
            children: .combine
        )
    }
}

// MARK: - DSSelectableRow

/// A row that represents one choice among several.
///
/// Distinct from ``DSActionRow`` because the semantics differ: a selectable row is not
/// "do a thing", it is "this is the current choice". VoiceOver must announce it as
/// selected or not, which a plain button trait does not convey.
///
/// ```swift
/// ForEach(themes) { option in
///     DSSelectableRow(
///         isSelected: option == selection,
///         action: { selection = option },
///         leading: { ThemeSwatch(option) }
///     ) {
///         DSText(option.name, role: .body)
///     }
/// }
/// ```
///
/// ## Accessibility
///
/// Carries `isButton` plus `isSelected` when chosen, and exposes a localized
/// "Selected" / "Not selected" value so the state is announced even when the checkmark
/// is the only visual cue.
public struct DSSelectableRow<Leading: View, Content: View>: View {

    @Environment(\.dsTheme) private var theme

    private let isSelected: Bool
    private let isDisabled: Bool
    private let leading: Leading
    private let content: Content
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    private let action: @MainActor () -> Void

    public init(
        isSelected: Bool,
        isDisabled: Bool = false,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder content: () -> Content
    ) {
        self.isSelected = isSelected
        self.isDisabled = isDisabled
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action
        self.leading = leading()
        self.content = content()
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: SpacingTokens.space3) {
                leading
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                DSRowAccessory(.selection(isSelected: isSelected))
            }
            .padding(.vertical, SpacingTokens.space2)
            .frame(minHeight: ControlHeightTokens.minimumHitTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(DSPressableButtonStyle(duration: theme.motion.fast))
        .disabled(isDisabled)
        .opacity(isDisabled ? OpacityTokens.disabled : 1)
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    internal var selectionValue: String {
        DSLocalizedStrings.value(isSelected ? .selected : .notSelected)
    }

    internal var resolvedTraits: AccessibilityTraits {
        isSelected ? [.isButton, .isSelected] : [.isButton]
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: accessibilityLabel,
            value: selectionValue,
            hint: accessibilityHint,
            traits: resolvedTraits,
            isEnabled: !isDisabled,
            children: .combine
        )
    }
}

// MARK: - Convenience

public extension DSSelectableRow where Leading == EmptyView {

    /// A selectable row with no leading content.
    init(
        isSelected: Bool,
        isDisabled: Bool = false,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            isSelected: isSelected,
            isDisabled: isDisabled,
            accessibilityLabel: accessibilityLabel,
            accessibilityHint: accessibilityHint,
            action: action,
            leading: { EmptyView() },
            content: content
        )
    }
}
