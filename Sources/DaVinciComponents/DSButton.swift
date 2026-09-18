import SwiftUI
import DaVinciTokens

// MARK: - DSButtonIcon

/// Icon placement for `DSButton`.
/// Stores a validated SF Symbol and its placement.
public enum DSButtonIcon: Sendable {
    case leading(DSSymbol)
    case trailing(DSSymbol)
}

// MARK: - DSButton

/// A themed button component with multiple appearances and states.
///
/// `DSButton` provides a consistent button interface that automatically adapts to
/// your theme. It supports four visual appearances, icon placement, loading states,
/// and disabled states.
///
/// ## Basic Usage
///
/// ```swift
/// DSButton("Submit", appearance: .primary) {
///     submitForm()
/// }
/// ```
///
/// ## Appearances
///
/// - **Primary**: Filled with brand color, high emphasis
/// - **Secondary**: Subtle surface color, medium emphasis
/// - **Outline**: Transparent with brand border, low emphasis
/// - **Ghost**: Transparent without a border, minimal emphasis
///
/// ```swift
/// DSButton("Primary", appearance: .primary) { }
/// DSButton("Secondary", appearance: .secondary) { }
/// DSButton("Outline", appearance: .outline) { }
/// DSButton("Ghost", appearance: .ghost) { }
/// ```
///
/// ## Icons
///
/// Add SF Symbol icons before or after the button text. Prefer the typed
/// `DSSymbol` API — it validates the symbol at construction time:
///
/// ```swift
/// if let plus = DSSymbol(systemName: "plus") {
///     DSButton("Add Item", icon: .leading(plus)) { }
/// }
///
/// if let arrow = DSSymbol(systemName: "arrow.right") {
///     DSButton("Continue", icon: .trailing(arrow)) { }
/// }
/// ```
///
/// ## States
///
/// Buttons automatically handle loading and disabled states:
///
/// ```swift
/// DSButton("Saving...", isLoading: true) {
///     // Action disabled while loading
/// }
///
/// DSButton("Submit", isDisabled: !formValid) {
///     // Action disabled when form invalid
/// }
/// ```
///
/// - Note: The button maintains its size during loading by keeping the text
///   invisibly rendered while showing a `ProgressView`.
///
/// ## Topics
///
/// ### Creating Buttons
/// - ``init(_:appearance:icon:isLoading:isDisabled:accessibilityLabel:accessibilityHint:action:)``
///
/// ### Button Appearances
/// - ``Appearance``
///
/// ### Icon Configuration
/// - ``DSButtonIcon``
public struct DSButton: View {

    /// Visual style for the button.
    public enum Appearance: CaseIterable, Hashable, Sendable {
        /// Filled background with brand primary color.
        case primary
        /// Filled background with surface secondary color.
        case secondary
        /// Transparent background with brand border.
        case outline
        /// Transparent background without a border.
        case ghost
    }

    /// How much space the button occupies.
    public enum Size: Sendable, CaseIterable {
        /// Full-width button at the medium control height. The default.
        case regular
        /// Hugs its content at ``ControlHeightTokens/compact`` height.
        ///
        /// The *painted* control is 36pt tall, but its interactive area is expanded to
        /// ``ControlHeightTokens/minimumHitTarget`` in both dimensions. A compact button
        /// therefore looks small without becoming hard to hit — which is the whole point
        /// of the size, and the part hand-rolled compact buttons usually get wrong by
        /// constraining only the height and leaving a narrow label narrow.
        case compact
    }

    @Environment(\.dsTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let title: String
    private let appearance: Appearance
    private let icon: DSButtonIcon?
    private let size: Size
    private let isLoading: Bool
    private let isDisabled: Bool
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    private let action: @MainActor () -> Void

    public init(
        _ title: String,
        appearance: Appearance = .primary,
        size: Size = .regular,
        icon: DSButtonIcon? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.appearance = appearance
        self.icon = icon
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    public var body: some View {
        let style = DSButtonStyleResolver.resolve(
            appearance: appearance,
            theme: theme,
            colorScheme: colorScheme
        )

        Button(action: action) {
            ZStack {
                // Keep sizing stable by rendering content invisibly when loading
                buttonContent
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .tint(style.foregroundColor)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: size == .regular ? .infinity : nil)
            .frame(minHeight: paintedHeight)
            .foregroundStyle(style.foregroundColor)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                if style.borderWidth > 0 {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                }
            }
            // Expanded after the background so the touch area grows without the
            // painted control growing with it. Only compact buttons expand: the
            // frame also affects layout, and regular buttons keep their 1.x size.
            .frame(
                minWidth: hitTargetMinimum,
                minHeight: hitTargetMinimum
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(DSPressableButtonStyle(duration: theme.motion.fast))
        .disabled(!accessibilityDescriptor.isEnabled)
        .opacity(isDisabled ? OpacityTokens.disabled : 1.0)
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: accessibilityLabel ?? title,
            value: isLoading ? DSLocalizedStrings.value(.loading) : nil,
            hint: accessibilityHint,
            traits: isLoading ? [.isButton, .updatesFrequently] : .isButton,
            isEnabled: !isDisabled && !isLoading
        )
    }

    private var buttonContent: some View {
        HStack(spacing: SpacingTokens.space2) {
            if case .leading(let symbol) = icon {
                symbol.image
                    .dsTextStyle(iconTextStyle, family: theme.typography.family)
            }

            Text(title)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            if case .trailing(let symbol) = icon {
                symbol.image
                    .dsTextStyle(iconTextStyle, family: theme.typography.family)
            }
        }
        .dsTextStyle(labelStyle, family: theme.typography.family)
    }

    // MARK: - Size Metrics

    private var horizontalPadding: CGFloat {
        switch size {
        case .regular: SpacingTokens.space5
        case .compact: SpacingTokens.space4
        }
    }

    private var verticalPadding: CGFloat {
        switch size {
        case .regular: SpacingTokens.space3
        case .compact: SpacingTokens.space2
        }
    }

    internal var paintedHeight: CGFloat {
        switch size {
        case .regular: ControlHeightTokens.medium
        case .compact: ControlHeightTokens.compact
        }
    }

    internal var hitTargetMinimum: CGFloat? {
        switch size {
        case .regular: nil
        case .compact: ControlHeightTokens.minimumHitTarget
        }
    }

    private var cornerRadius: CGFloat {
        switch size {
        case .regular: RadiusTokens.medium
        case .compact: RadiusTokens.small
        }
    }

    /// Button text uses the label family at both sizes.
    ///
    /// Labels exist for control text specifically: single-line, tightly leaded and
    /// `medium` weight, which stays legible at small sizes and on coloured fills.
    /// Before 2.0 buttons borrowed `headline`, a section-header role — the workaround
    /// that appears when a scale has no label family at all.
    internal var labelStyle: DSTextStyle { theme.typography.labelLarge }

    private var iconTextStyle: DSTextStyle {
        DSTextStyle(
            size: labelStyle.size,
            lineHeight: theme.typography.headline.lineHeight,
            weight: .medium,
            relativeTo: theme.typography.headline.relativeTo
        )
    }

}
