import SwiftUI
import DaVinciTokens

// MARK: - DSIconButton

/// A themed icon-only button component that reads tokens from the `DSTheme` environment.
public struct DSIconButton: View {

    public enum Appearance: CaseIterable, Hashable, Sendable {
        case primary
        case secondary
        case outline
        case accent
        case ghost
    }

    /// Backward-compatible name for the visual appearance.
    public typealias Variant = Appearance

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
    private let appearance: Appearance
    private let size: Size
    private let isLoading: Bool
    private let isDisabled: Bool
    private let action: @MainActor () -> Void

    /// Creates an icon button from a validated `DSSymbol`.
    public init(
        symbol: DSSymbol,
        titleForAccessibility: String,
        appearance: Appearance = .secondary,
        size: Size = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.init(
            systemName: symbol.systemName,
            titleForAccessibility: titleForAccessibility,
            appearance: appearance,
            size: size,
            isLoading: isLoading,
            isDisabled: isDisabled,
            accessibilityHint: accessibilityHint,
            action: action
        )
    }

    public init(
        systemName: String,
        titleForAccessibility: String,
        appearance: Appearance = .secondary,
        size: Size = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.systemName = systemName
        self.accessibilityTitle = titleForAccessibility
        self.accessibilityHint = accessibilityHint
        self.appearance = appearance
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    /// Creates a typed icon button using the API published before DaVinci 1.4.
    public init(
        symbol: DSSymbol,
        titleForAccessibility: String,
        variant: Variant,
        size: Size = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.init(
            symbol: symbol,
            titleForAccessibility: titleForAccessibility,
            appearance: variant,
            size: size,
            isLoading: isLoading,
            isDisabled: isDisabled,
            accessibilityHint: accessibilityHint,
            action: action
        )
    }

    /// Creates a string-based icon button using the API published before DaVinci 1.4.
    public init(
        systemName: String,
        titleForAccessibility: String,
        variant: Variant,
        size: Size = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        accessibilityHint: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.init(
            systemName: systemName,
            titleForAccessibility: titleForAccessibility,
            appearance: variant,
            size: size,
            isLoading: isLoading,
            isDisabled: isDisabled,
            accessibilityHint: accessibilityHint,
            action: action
        )
    }

    public var body: some View {
        let style = DSButtonStyleResolver.resolve(appearance: appearance, theme: theme)

        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(style.foregroundColor)
                } else {
                    Image(systemName: systemName)
                        .font(.system(size: iconFontSize, weight: .medium))
                }
            }
            .frame(width: size.dimension, height: size.dimension)
            .foregroundStyle(style.foregroundColor)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.medium))
            .overlay {
                if style.borderWidth > 0 {
                    RoundedRectangle(cornerRadius: RadiusTokens.medium)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                }
            }
        }
        .buttonStyle(DSPressableButtonStyle(duration: theme.motion.fast))
        .disabled(!accessibilityDescriptor.isEnabled)
        .opacity(isDisabled ? OpacityTokens.disabled : 1.0)
        .frame(minWidth: minimumHitDimension, minHeight: minimumHitDimension)
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    // MARK: - Private

    /// Icon font size derived from the button dimension (~40% of control height).
    private static let iconSizeRatio: CGFloat = 0.4

    internal var minimumHitDimension: CGFloat { 44 }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: accessibilityTitle,
            value: isLoading ? "Loading" : nil,
            hint: accessibilityHint,
            traits: isLoading ? [.isButton, .updatesFrequently] : .isButton,
            isEnabled: !isDisabled && !isLoading
        )
    }

    private var iconFontSize: CGFloat {
        size.dimension * Self.iconSizeRatio
    }

}

// MARK: - Previews

private let previewPlus = DSSymbol(systemName: "plus")!
private let previewGearshape = DSSymbol(systemName: "gearshape")!
private let previewPencil = DSSymbol(systemName: "pencil")!
private let previewStarFill = DSSymbol(systemName: "star.fill")!
private let previewHeartFill = DSSymbol(systemName: "heart.fill")!
private let previewTrash = DSSymbol(systemName: "trash")!

#Preview("DSIconButton — Variants") {
    HStack(spacing: 12) {
        DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .primary) {}
        DSIconButton(symbol: previewGearshape, titleForAccessibility: "Settings", variant: .secondary) {}
        DSIconButton(symbol: previewPencil, titleForAccessibility: "Edit", variant: .outline) {}
        DSIconButton(symbol: previewStarFill, titleForAccessibility: "Accent", variant: .accent) {}
        DSIconButton(symbol: previewHeartFill, titleForAccessibility: "Ghost", appearance: .ghost) {}
    }
    .padding()
}

#Preview("DSIconButton — Sizes") {
    HStack(spacing: 12) {
        DSIconButton(symbol: previewHeartFill, titleForAccessibility: "Like", variant: .primary, size: .small) {}
        DSIconButton(symbol: previewHeartFill, titleForAccessibility: "Like", variant: .primary, size: .medium) {}
        DSIconButton(symbol: previewHeartFill, titleForAccessibility: "Like", variant: .primary, size: .large) {}
    }
    .padding()
}

#Preview("DSIconButton — States") {
    HStack(spacing: 12) {
        DSIconButton(symbol: previewTrash, titleForAccessibility: "Delete", variant: .primary) {}
        DSIconButton(symbol: previewTrash, titleForAccessibility: "Delete", variant: .primary, isDisabled: true) {}
        DSIconButton(symbol: previewTrash, titleForAccessibility: "Delete", variant: .primary, isLoading: true) {}
    }
    .padding()
}

#Preview("DSIconButton — All Variants + Sizes") {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .primary, size: .small) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .secondary, size: .small) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .outline, size: .small) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .accent, size: .small) {}
        }
        HStack(spacing: 12) {
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .primary, size: .large) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .secondary, size: .large) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .outline, size: .large) {}
            DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .accent, size: .large) {}
        }
    }
    .padding()
}

#Preview("DSIconButton — Dark") {
    HStack(spacing: 12) {
        DSIconButton(symbol: previewPlus, titleForAccessibility: "Add", variant: .primary) {}
        DSIconButton(symbol: previewGearshape, titleForAccessibility: "Settings", variant: .secondary) {}
        DSIconButton(symbol: previewPencil, titleForAccessibility: "Edit", variant: .outline) {}
        DSIconButton(symbol: previewStarFill, titleForAccessibility: "Accent", variant: .accent) {}
        DSIconButton(symbol: previewTrash, titleForAccessibility: "Delete", variant: .primary, isDisabled: true) {}
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
