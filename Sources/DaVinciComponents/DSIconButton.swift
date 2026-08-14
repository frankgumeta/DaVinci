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

    private let symbol: DSSymbol
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
        self.symbol = symbol
        self.accessibilityTitle = titleForAccessibility
        self.accessibilityHint = accessibilityHint
        self.appearance = appearance
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        let style = DSButtonStyleResolver.resolve(appearance: appearance, theme: theme)

        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(style.foregroundColor)
                } else {
                    symbol.image
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
            value: isLoading ? DSLocalizedStrings.value(.loading) : nil,
            hint: accessibilityHint,
            traits: isLoading ? [.isButton, .updatesFrequently] : .isButton,
            isEnabled: !isDisabled && !isLoading
        )
    }

    private var iconFontSize: CGFloat {
        size.dimension * Self.iconSizeRatio
    }

}
