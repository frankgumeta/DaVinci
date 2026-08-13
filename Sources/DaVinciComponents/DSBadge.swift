import SwiftUI
import DaVinciTokens

// MARK: - DSBadge

/// A themed badge component for displaying counts or status labels.
///
/// `DSBadge` provides a consistent badge interface that automatically adapts to
/// your theme. Tone communicates status while appearance controls visual emphasis.
///
/// ## Basic Usage
///
/// ```swift
/// DSBadge("New")
/// DSBadge("5")
/// ```
///
/// ## Tones and Appearances
///
/// ```swift
/// DSBadge("New", tone: .brand, appearance: .filled)
/// DSBadge("Active", tone: .success, appearance: .subtle)
/// DSBadge("Failed", tone: .error, appearance: .outlined)
/// ```
///
/// ## Sizes
///
/// ```swift
/// DSBadge("S", size: .small)
/// DSBadge("M", size: .medium)
/// DSBadge("L", size: .large)
/// ```
///
/// ## Dot Badge
///
/// ```swift
/// DSBadge(tone: .error) // Shows just a dot indicator
/// ```
public struct DSBadge: View, Sendable {
    @Environment(\.dsTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private let text: String?
    private let tone: Tone
    private let appearance: Appearance
    private let size: Size
    private let accessibilityLabel: String?

    /// Semantic color intent of the badge.
    public enum Tone: CaseIterable, Hashable, Sendable {
        case brand
        case success
        case warning
        case error
        case neutral
    }

    /// Visual emphasis of the badge.
    public enum Appearance: CaseIterable, Hashable, Sendable {
        /// Solid semantic fill with contrast-selected foreground.
        case filled
        /// Low-emphasis tinted fill with a subtle border.
        case subtle
        /// Transparent fill with a semantic outline.
        case outlined
    }

    /// Semantic size of the badge.
    public enum Size: Sendable {
        case small
        case medium
        case large

        var textStyle: KeyPath<DSTypography, DSTextStyle> {
            switch self {
            case .small:  return \.overline
            case .medium: return \.caption
            case .large:  return \.callout
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small:  return SpacingTokens.space2
            case .medium: return SpacingTokens.space3
            case .large:  return SpacingTokens.space4
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small:  return SpacingTokens.space1
            case .medium: return SpacingTokens.space1
            case .large:  return SpacingTokens.space2
            }
        }

        var dotSize: CGFloat {
            switch self {
            case .small:  return SpacingTokens.space2      // 8pt
            case .medium: return SpacingTokens.space3      // 12pt
            case .large:  return SpacingTokens.space4      // 16pt
            }
        }
    }

    /// Creates a themed badge with independently configurable tone and appearance.
    ///
    /// - Parameters:
    ///   - text: Text to display in the badge (nil for dot badge)
    ///   - tone: Semantic color intent
    ///   - appearance: Visual emphasis
    ///   - size: Semantic size of the badge
    ///   - accessibilityLabel: Optional override for the accessibility label
    public init(
        _ text: String? = nil,
        tone: Tone = .brand,
        appearance: Appearance = .filled,
        size: Size = .medium,
        accessibilityLabel: String? = nil
    ) {
        self.text = text
        self.tone = tone
        self.appearance = appearance
        self.size = size
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        let style = DSBadgeStyleResolver.resolve(
            tone: tone,
            appearance: appearance,
            theme: theme,
            colorScheme: colorScheme
        )

        Group {
            if let text {
                let textStyle = theme.typography[keyPath: size.textStyle]
                Text(text)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .dsTextStyle(textStyle, family: theme.typography.family)
                    .foregroundStyle(style.foregroundColor)
                    .padding(.horizontal, size.horizontalPadding)
                    .padding(.vertical, size.verticalPadding)
                    .background(style.backgroundColor)
                    .clipShape(Capsule())
                    .overlay {
                        Capsule()
                            .strokeBorder(style.borderColor, lineWidth: style.borderWidth)
                    }
            } else {
                Circle()
                    .fill(style.backgroundColor)
                    .frame(width: size.dotSize, height: size.dotSize)
                    .overlay {
                        Circle()
                            .strokeBorder(style.borderColor, lineWidth: style.borderWidth)
                    }
            }
        }
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: resolvedAccessibilityLabel,
            traits: .isStaticText,
            children: .ignore
        )
    }

    internal var resolvedAccessibilityLabel: String {
        if let accessibilityLabel { return accessibilityLabel }
        if let text { return text }
        return "Notification indicator"
    }

    internal static func backgroundColor(for tone: Tone, theme: DSTheme) -> Color {
        DSBadgeStyleResolver.filledBackgroundColor(for: tone, theme: theme)
    }

    @MainActor
    internal static func foregroundColor(
        for tone: Tone,
        theme: DSTheme,
        colorScheme: ColorScheme
    ) -> Color {
        DSBadgeStyleResolver.resolve(
            tone: tone,
            appearance: .filled,
            theme: theme,
            colorScheme: colorScheme
        ).foregroundColor
    }
}
