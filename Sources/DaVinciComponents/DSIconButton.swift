import SwiftUI
import DaVinciTokens

// MARK: - DSIconButton

/// A themed icon-only button component that reads tokens from the `DSTheme` environment.
public struct DSIconButton: View {

    public enum Variant: Sendable {
        case primary
        case secondary
        case outline
        case accent
    }

    public enum Size: Sendable {
        case small
        case medium
        case large

        var dimension: CGFloat {
            switch self {
            case .small:  ControlHeightTokens.small
            case .medium: ControlHeightTokens.medium
            case .large:  ControlHeightTokens.large
            }
        }
    }

    @Environment(\.dsTheme) private var theme

    private let systemName: String
    private let accessibilityTitle: String
    private let accessibilityHint: String?
    private let variant: Variant
    private let size: Size
    private let isLoading: Bool
    private let isDisabled: Bool
    private let action: @MainActor () -> Void

    public init(
        systemName: String,
        titleForAccessibility: String,
        variant: Variant = .secondary,
        size: Size = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.systemName = systemName
        self.accessibilityTitle = titleForAccessibility
        self.accessibilityHint = accessibilityHint
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                } else {
                    Image(systemName: systemName)
                        .font(.system(size: iconFontSize, weight: .medium))
                }
            }
            .frame(width: size.dimension, height: size.dimension)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.medium))
            .overlay {
                switch variant {
                case .outline:
                    RoundedRectangle(cornerRadius: RadiusTokens.medium)
                        .stroke(theme.colors.brand.primary, lineWidth: StrokeTokens.default)
                case .accent:
                    RoundedRectangle(cornerRadius: RadiusTokens.medium)
                        .stroke(theme.colors.accent.strokeAccent, lineWidth: StrokeTokens.default)
                default:
                    EmptyView()
                }
            }
        }
        .buttonStyle(DSPressableButtonStyle(duration: theme.motion.fast))
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? OpacityTokens.disabled : 1.0)
        .accessibilityLabel(accessibilityTitle)
        .modifier(AccessibilityHintModifier(hint: accessibilityHint))
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Private

    /// Icon font size derived from the button dimension (~40% of control height).
    private static let iconSizeRatio: CGFloat = 0.4

    private var iconFontSize: CGFloat {
        size.dimension * Self.iconSizeRatio
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary:
            theme.colors.semantic.textOnBrand
        case .secondary:
            theme.colors.semantic.textPrimary
        case .outline:
            theme.colors.brand.primary
        case .accent:
            theme.colors.accent.strokeAccent
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
        case .accent:
            theme.colors.accent.bgAccent
        }
    }
}

// MARK: - Previews

#Preview("DSIconButton — Variants") {
    HStack(spacing: 12) {
        DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .primary) {}
        DSIconButton(systemName: "gearshape", titleForAccessibility: "Settings", variant: .secondary) {}
        DSIconButton(systemName: "pencil", titleForAccessibility: "Edit", variant: .outline) {}
        DSIconButton(systemName: "star.fill", titleForAccessibility: "Accent", variant: .accent) {}
    }
    .padding()
}

#Preview("DSIconButton — Sizes") {
    HStack(spacing: 12) {
        DSIconButton(systemName: "heart.fill", titleForAccessibility: "Like", variant: .primary, size: .small) {}
        DSIconButton(systemName: "heart.fill", titleForAccessibility: "Like", variant: .primary, size: .medium) {}
        DSIconButton(systemName: "heart.fill", titleForAccessibility: "Like", variant: .primary, size: .large) {}
    }
    .padding()
}

#Preview("DSIconButton — States") {
    HStack(spacing: 12) {
        DSIconButton(systemName: "trash", titleForAccessibility: "Delete", variant: .primary) {}
        DSIconButton(systemName: "trash", titleForAccessibility: "Delete", variant: .primary, isDisabled: true) {}
        DSIconButton(systemName: "trash", titleForAccessibility: "Delete", variant: .primary, isLoading: true) {}
    }
    .padding()
}

#Preview("DSIconButton — All Variants + Sizes") {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .primary, size: .small) {}
            DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .secondary, size: .small) {}
            DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .outline, size: .small) {}
            DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .accent, size: .small) {}
        }
        HStack(spacing: 12) {
            DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .primary, size: .large) {}
            DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .secondary, size: .large) {}
            DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .outline, size: .large) {}
            DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .accent, size: .large) {}
        }
    }
    .padding()
}

#Preview("DSIconButton — Dark") {
    HStack(spacing: 12) {
        DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .primary) {}
        DSIconButton(systemName: "gearshape", titleForAccessibility: "Settings", variant: .secondary) {}
        DSIconButton(systemName: "pencil", titleForAccessibility: "Edit", variant: .outline) {}
        DSIconButton(systemName: "star.fill", titleForAccessibility: "Accent", variant: .accent) {}
        DSIconButton(systemName: "trash", titleForAccessibility: "Delete", variant: .primary, isDisabled: true) {}
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

// MARK: - Accessibility Modifiers

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
