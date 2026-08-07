import SwiftUI
import DaVinciTokens

// MARK: - DSButtonIcon

/// Icon placement for `DSButton`.
/// Stores a SF Symbol name; the `Image` is created internally by `DSButton`.
public enum DSButtonIcon: Sendable {
    case leading(systemName: String)
    case trailing(systemName: String)

    /// Creates a leading icon from a validated `DSSymbol`.
    public static func leading(_ symbol: DSSymbol) -> DSButtonIcon {
        .leading(systemName: symbol.systemName)
    }

    /// Creates a trailing icon from a validated `DSSymbol`.
    public static func trailing(_ symbol: DSSymbol) -> DSButtonIcon {
        .trailing(systemName: symbol.systemName)
    }
}

// MARK: - DSButton

/// A themed button component with multiple variants and states.
///
/// `DSButton` provides a consistent button interface that automatically adapts to
/// your theme. It supports three visual variants, icon placement, loading states,
/// and disabled states.
///
/// ## Basic Usage
///
/// ```swift
/// DSButton("Submit", variant: .primary) {
///     submitForm()
/// }
/// ```
///
/// ## Variants
///
/// - **Primary**: Filled with brand color, high emphasis
/// - **Secondary**: Subtle surface color, medium emphasis
/// - **Outline**: Transparent with brand border, low emphasis
///
/// ```swift
/// DSButton("Primary", variant: .primary) { }
/// DSButton("Secondary", variant: .secondary) { }
/// DSButton("Outline", variant: .outline) { }
/// ```
///
/// ## Icons
///
/// Add SF Symbol icons before or after the button text. Prefer the typed
/// `DSSymbol` API — it validates the symbol at construction time:
///
/// ```swift
/// let plus = DSSymbol(systemName: "plus")!
/// DSButton("Add Item", icon: .leading(plus)) { }
///
/// let arrow = DSSymbol(systemName: "arrow.right")!
/// DSButton("Continue", icon: .trailing(arrow)) { }
/// ```
///
/// The string-based API from v1.2.0 remains available:
///
/// ```swift
/// DSButton("Add Item", icon: .leading(systemName: "plus")) { }
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
/// - ``init(_:variant:icon:isLoading:isDisabled:accessibilityLabel:accessibilityHint:action:)``
///
/// ### Button Variants
/// - ``Variant``
///
/// ### Icon Configuration
/// - ``DSButtonIcon``
public struct DSButton: View {

    /// Visual style for the button.
    public enum Variant: Sendable {
        /// Filled background with brand primary color.
        case primary
        /// Filled background with surface secondary color.
        case secondary
        /// Transparent background with brand border.
        case outline
    }

    @Environment(\.dsTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let title: String
    private let variant: Variant
    private let icon: DSButtonIcon?
    private let isLoading: Bool
    private let isDisabled: Bool
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    private let action: @MainActor () -> Void

    public init(
        _ title: String,
        variant: Variant = .primary,
        icon: DSButtonIcon? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                // Keep sizing stable by rendering content invisibly when loading
                buttonContent
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                }
            }
            .padding(.horizontal, SpacingTokens.space5)
            .padding(.vertical, SpacingTokens.space3)
            .frame(maxWidth: .infinity)
            .frame(minHeight: ControlHeightTokens.medium)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.medium))
            .overlay {
                if variant == .outline {
                    RoundedRectangle(cornerRadius: RadiusTokens.medium)
                        .stroke(theme.colors.brand.primary, lineWidth: StrokeTokens.default)
                }
            }
        }
        .buttonStyle(DSPressableButtonStyle(duration: theme.motion.fast))
        .disabled(!accessibilityDescriptor.isEnabled)
        .opacity(isDisabled ? OpacityTokens.disabled : 1.0)
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: accessibilityLabel ?? title,
            value: isLoading ? "Loading" : nil,
            hint: accessibilityHint,
            traits: isLoading ? [.isButton, .updatesFrequently] : .isButton,
            isEnabled: !isDisabled && !isLoading
        )
    }

    private var buttonContent: some View {
        HStack(spacing: SpacingTokens.space2) {
            if case .leading(let name) = icon {
                Image(systemName: name)
                    .dsTextStyle(iconTextStyle, family: theme.typography.family)
            }

            Text(title)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            if case .trailing(let name) = icon {
                Image(systemName: name)
                    .dsTextStyle(iconTextStyle, family: theme.typography.family)
            }
        }
        .dsTextStyle(theme.typography.headline, family: theme.typography.family)
    }

    private var iconTextStyle: DSTextStyle {
        DSTextStyle(
            size: theme.typography.headline.size,
            lineHeight: theme.typography.headline.lineHeight,
            weight: .medium,
            relativeTo: theme.typography.headline.relativeTo
        )
    }

    // MARK: - Private

    private var foregroundColor: Color {
        switch variant {
        case .primary:
            DSColorContrast.preferredForeground(
                on: theme.colors.brand.primary,
                candidates: [
                    theme.colors.semantic.textPrimary,
                    theme.colors.semantic.textOnBrand,
                    theme.colors.semantic.textInverse
                ],
                colorScheme: colorScheme
            )
        case .secondary:
            theme.colors.semantic.textPrimary
        case .outline:
            theme.colors.brand.primary
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary:
            theme.colors.brand.primary
        case .secondary:
            theme.colors.semantic.surfaceSecondary
        case .outline:
            .clear
        }
    }
}

// MARK: - Previews

#Preview("DSButton — Variants") {
    VStack(spacing: 12) {
        DSButton("Primary", variant: .primary) {}
        DSButton("Secondary", variant: .secondary) {}
        DSButton("Outline", variant: .outline) {}
    }
    .padding()
}

#Preview("DSButton — Leading Icon") {
    VStack(spacing: 12) {
        DSButton("Add Item", variant: .primary, icon: .leading(DSSymbol(systemName: "plus")!)) {}
        DSButton("Settings", variant: .secondary, icon: .leading(DSSymbol(systemName: "gearshape")!)) {}
        DSButton("Edit", variant: .outline, icon: .leading(DSSymbol(systemName: "pencil")!)) {}
    }
    .padding()
}

#Preview("DSButton — Trailing Icon") {
    VStack(spacing: 12) {
        DSButton("Continue", variant: .primary, icon: .trailing(DSSymbol(systemName: "arrow.right")!)) {}
        DSButton("Download", variant: .secondary, icon: .trailing(DSSymbol(systemName: "arrow.down.circle")!)) {}
        DSButton("Share", variant: .outline, icon: .trailing(DSSymbol(systemName: "square.and.arrow.up")!)) {}
    }
    .padding()
}

#Preview("DSButton — Loading") {
    VStack(spacing: 12) {
        DSButton("Primary", variant: .primary, isLoading: true) {}
        DSButton("Secondary", variant: .secondary, isLoading: true) {}
        DSButton("Outline", variant: .outline, isLoading: true) {}
        DSButton("With Icon", variant: .primary, icon: .leading(systemName: "plus"), isLoading: true) {}
    }
    .padding()
}

#Preview("DSButton — Dark") {
    VStack(spacing: 12) {
        DSButton("Primary", variant: .primary) {}
        DSButton("Secondary", variant: .secondary) {}
        DSButton("Outline", variant: .outline) {}
        DSButton("Disabled", variant: .primary, isDisabled: true) {}
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
