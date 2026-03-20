import SwiftUI
import DaVinciTokens

// MARK: - DSBadge

/// A themed badge component for displaying counts or status labels.
///
/// `DSBadge` provides a consistent badge interface that automatically adapts to
/// your theme. It supports different variants and can display text, numbers, or a dot indicator.
///
/// ## Basic Usage
///
/// ```swift
/// DSBadge("New")
/// DSBadge("5")
/// ```
///
/// ## Variants
///
/// - **Brand**: Brand primary color background (default)
/// - **Success**: Success color background
/// - **Warning**: Warning color background
/// - **Error**: Error color background
/// - **Neutral**: Neutral/subtle background
///
/// ```swift
/// DSBadge("New", variant: .brand)
/// DSBadge("Active", variant: .success)
/// DSBadge("Pending", variant: .warning)
/// DSBadge("Failed", variant: .error)
/// DSBadge("Info", variant: .neutral)
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
/// DSBadge(variant: .error) // Shows just a dot indicator
/// ```
public struct DSBadge: View, Sendable {
    @Environment(\.dsTheme) private var theme

    private let text: String?
    private let variant: Variant
    private let size: Size
    private let accessibilityLabel: String?

    /// Visual variant of the badge.
    public enum Variant: Sendable {
        /// Brand primary color background.
        case brand
        case success
        case warning
        case error
        case neutral
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

    /// Creates a themed badge.
    ///
    /// - Parameters:
    ///   - text: Text to display in the badge (nil for dot badge)
    ///   - variant: Visual variant of the badge
    ///   - size: Semantic size of the badge
    ///   - accessibilityLabel: Optional override for the accessibility label
    public init(
        _ text: String? = nil,
        variant: Variant = .brand,
        size: Size = .medium,
        accessibilityLabel: String? = nil
    ) {
        self.text = text
        self.variant = variant
        self.size = size
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        Group {
            if let text {
                let textStyle = theme.typography[keyPath: size.textStyle]
                Text(text)
                    .lineLimit(1)
                    .font(textStyle.font(family: theme.typography.family))
                    .foregroundStyle(foregroundColor)
                    .padding(.horizontal, size.horizontalPadding)
                    .padding(.vertical, size.verticalPadding)
                    .background(backgroundColor)
                    .clipShape(Capsule())
            } else {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: size.dotSize, height: size.dotSize)
            }
        }
        .accessibilityElement()
        .accessibilityLabel(resolvedAccessibilityLabel)
        .accessibilityAddTraits(.isStaticText)
    }

    internal var resolvedAccessibilityLabel: String {
        if let accessibilityLabel { return accessibilityLabel }
        if let text { return text }
        return "Notification indicator"
    }

    internal var backgroundColor: Color {
        Self.backgroundColor(for: variant, theme: theme)
    }

    internal static func backgroundColor(for variant: Variant, theme: DSTheme) -> Color {
        switch variant {
        case .brand:   return theme.colors.brand.primary
        case .success: return theme.colors.feedback.success
        case .warning: return theme.colors.feedback.warning
        case .error:   return theme.colors.feedback.error
        case .neutral: return theme.colors.semantic.bgTertiary
        }
    }

    internal var foregroundColor: Color {
        Self.foregroundColor(for: variant, theme: theme)
    }

    internal static func foregroundColor(for variant: Variant, theme: DSTheme) -> Color {
        switch variant {
        case .brand, .error:
            return theme.colors.semantic.textOnBrand
        case .success, .warning, .neutral:
            return theme.colors.semantic.textPrimary
        }
    }
}

// MARK: - Previews

#Preview("DSBadge - Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: SpacingTokens.space5) {

            DSText("Variants — readability check", role: .headline)
            HStack(spacing: SpacingTokens.space3) {
                DSBadge("Brand", variant: .brand)
                DSBadge("Success", variant: .success)
                DSBadge("Warning", variant: .warning)
                DSBadge("Error", variant: .error)
                DSBadge("Neutral", variant: .neutral)
            }

            DSText("Sizes — all variants", role: .headline)
            ForEach([DSBadge.Variant.brand, .success, .warning, .error, .neutral], id: \.self) { variant in
                HStack(spacing: SpacingTokens.space3) {
                    DSBadge("Small", variant: variant, size: .small)
                    DSBadge("Medium", variant: variant, size: .medium)
                    DSBadge("Large", variant: variant, size: .large)
                }
            }

            DSText("Numbers", role: .headline)
            HStack(spacing: SpacingTokens.space3) {
                DSBadge("1")
                DSBadge("5")
                DSBadge("99")
                DSBadge("999+")
                DSBadge("1", variant: .error)
                DSBadge("99+", variant: .error)
            }

            DSText("Dot indicators — graduated sizes", role: .headline)
            HStack(alignment: .center, spacing: SpacingTokens.space4) {
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(variant: .error, size: .small)
                    DSText("small", role: .caption)
                }
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(variant: .error, size: .medium)
                    DSText("medium", role: .caption)
                }
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(variant: .error, size: .large)
                    DSText("large", role: .caption)
                }
            }
            HStack(spacing: SpacingTokens.space3) {
                DSBadge(variant: .brand)
                DSBadge(variant: .success)
                DSBadge(variant: .warning)
                DSBadge(variant: .error)
                DSBadge(variant: .neutral)
            }
        }
        .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSBadge - Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: SpacingTokens.space5) {

            DSText("Variants — dark mode readability", role: .headline)
            HStack(spacing: SpacingTokens.space3) {
                DSBadge("Brand", variant: .brand)
                DSBadge("Success", variant: .success)
                DSBadge("Warning", variant: .warning)
                DSBadge("Error", variant: .error)
                DSBadge("Neutral", variant: .neutral)
            }

            DSText("Sizes — all variants", role: .headline)
            ForEach([DSBadge.Variant.brand, .success, .warning, .error, .neutral], id: \.self) { variant in
                HStack(spacing: SpacingTokens.space3) {
                    DSBadge("Small", variant: variant, size: .small)
                    DSBadge("Medium", variant: variant, size: .medium)
                    DSBadge("Large", variant: variant, size: .large)
                }
            }

            DSText("Numbers", role: .headline)
            HStack(spacing: SpacingTokens.space3) {
                DSBadge("1")
                DSBadge("99")
                DSBadge("999+")
                DSBadge("1", variant: .error)
                DSBadge("99+", variant: .error)
            }

            DSText("Dot indicators — graduated sizes", role: .headline)
            HStack(alignment: .center, spacing: SpacingTokens.space4) {
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(variant: .error, size: .small)
                    DSText("small", role: .caption)
                }
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(variant: .error, size: .medium)
                    DSText("medium", role: .caption)
                }
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(variant: .error, size: .large)
                    DSText("large", role: .caption)
                }
            }
        }
        .padding()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSBadge - Accessibility") {
    VStack(spacing: SpacingTokens.space4) {
        DSText("Custom a11y label on dot", role: .caption)
        DSBadge(variant: .error, accessibilityLabel: "3 unread messages")

        DSText("All sizes", role: .caption)
        HStack(spacing: SpacingTokens.space3) {
            DSBadge("S", size: .small)
            DSBadge("M", size: .medium)
            DSBadge("L", size: .large)
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
}
