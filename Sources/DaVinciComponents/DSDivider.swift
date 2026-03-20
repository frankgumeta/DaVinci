import SwiftUI
import DaVinciTokens

// MARK: - DSDivider

/// A themed divider component for separating content.
///
/// `DSDivider` provides a consistent separator that automatically adapts to
/// your theme. It supports both horizontal and vertical orientations and two
/// semantic thickness styles.
///
/// ## Basic Usage
///
/// ```swift
/// VStack {
///     Text("Section 1")
///     DSDivider()
///     Text("Section 2")
/// }
/// ```
///
/// ## Prominent Style
///
/// ```swift
/// DSDivider(style: .regular)
/// ```
///
/// ## Vertical Divider
///
/// ```swift
/// HStack {
///     Text("Left")
///     DSDivider(orientation: .vertical)
///         .frame(height: 40)
///     Text("Right")
/// }
/// ```
///
/// ## Accessibility
///
/// The divider is a decorative element and is always hidden from accessibility tools.
public struct DSDivider: View, Sendable {
    @Environment(\.dsTheme) private var theme

    private let orientation: Orientation
    private let style: Style

    /// Orientation of the divider.
    public enum Orientation: Sendable {
        case horizontal
        case vertical
    }

    /// Semantic thickness style of the divider.
    public enum Style: Sendable {
        /// 0.5pt — pixel-thin separator for dense lists and tight layouts.
        ///
        /// On 2× and 3× displays this renders as a true single-pixel line.
        /// On 1× (rare) it maps to a half-pixel, which SwiftUI rounds to 1px.
        /// No platform-specific branching is applied; the tradeoff is accepted
        /// in favour of API simplicity.
        case hairline
        /// 1pt — standard separator for most content sections.
        case regular

        var thickness: CGFloat {
            switch self {
            case .hairline: return 0.5
            case .regular:  return 1
            }
        }
    }

    /// Creates a themed divider.
    ///
    /// - Parameters:
    ///   - orientation: Orientation of the divider (default: `.horizontal`)
    ///   - style: Semantic thickness of the divider (default: `.regular`)
    public init(
        orientation: Orientation = .horizontal,
        style: Style = .regular
    ) {
        self.orientation = orientation
        self.style = style
    }

    public var body: some View {
        Rectangle()
            .fill(theme.colors.semantic.divider)
            .frame(
                width: orientation == .horizontal ? nil : style.thickness,
                height: orientation == .horizontal ? style.thickness : nil
            )
            .accessibilityHidden(true)
    }
}

// MARK: - Previews

#Preview("DSDivider - Light") {
    VStack(spacing: SpacingTokens.space4) {
        DSText("Horizontal", role: .headline)

        DSText("Hairline", role: .caption)
        DSDivider(style: .hairline)

        DSText("Regular", role: .caption)
        DSDivider(style: .regular)

        DSText("Vertical", role: .headline)
        HStack(spacing: SpacingTokens.space4) {
            DSText("Left", role: .body)
            DSDivider(orientation: .vertical, style: .regular)
                .frame(height: 40)
            DSText("Middle", role: .body)
            DSDivider(orientation: .vertical, style: .hairline)
                .frame(height: 40)
            DSText("Right", role: .body)
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSDivider - Dark") {
    VStack(spacing: SpacingTokens.space4) {
        DSText("Hairline", role: .caption)
        DSDivider(style: .hairline)

        DSText("Regular", role: .caption)
        DSDivider(style: .regular)

        HStack(spacing: SpacingTokens.space4) {
            DSText("Left", role: .body)
            DSDivider(orientation: .vertical)
                .frame(height: 40)
            DSText("Right", role: .body)
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
