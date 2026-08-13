import SwiftUI
import DaVinciTokens

// MARK: - DSCard

/// A themed card container with configurable styling.
///
/// `DSCard` provides a flexible container for grouping related content with
/// automatic surface styling, padding, corner radius, and elevation shadows.
///
/// ## Usage
///
/// ```swift
/// DSCard {
///     VStack(alignment: .leading) {
///         DSText("Card Title", role: .headline)
///         DSText("Card content", role: .body)
///     }
/// }
/// ```
///
/// ## Styles
///
/// Four preset styles are available via `DSCardStyle`:
///
/// - **Compact**: Tight padding (12pt), no shadow, small radius (10pt)
/// - **Standard**: Default padding (16pt), small shadow, medium radius (14pt)
/// - **Prominent**: Generous padding (20pt), medium shadow, large radius (20pt)
/// - **Outlined**: Standard padding, no shadow, semantic border
///
/// ```swift
/// DSCard(style: .compact) { /* content */ }
/// DSCard(style: .standard) { /* content */ }  // default
/// DSCard(style: .prominent) { /* content */ }
/// DSCard(style: .outlined) { /* content */ }
/// ```
///
/// ## Topics
///
/// ### Creating Cards
/// - ``init(style:accessibilityLabel:accessibilityHint:accessibilityTraits:content:)``
public struct DSCard<Content: View>: View {

    @Environment(\.dsTheme) private var theme

    private let style: DSCardStyle
    private let content: Content
    private let accessibilityLabel: String?
    private let accessibilityHint: String?
    private let accessibilityTraits: AccessibilityTraits?

    public init(
        style: DSCardStyle = .standard,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityTraits: AccessibilityTraits? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityTraits = accessibilityTraits
        self.content = content()
    }

    @ViewBuilder
    public var body: some View {
        let elevation = style.elevation

        switch style {
        case .compact, .standard, .prominent:
            content
                .padding(style.padding)
                .background(theme.colors.semantic.surfacePrimary)
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
                .shadow(color: elevation.color, radius: elevation.radius, x: elevation.x, y: elevation.y)
                .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))

        case .outlined:
            content
                .padding(style.padding)
                .background(theme.colors.semantic.surfacePrimary)
                .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .strokeBorder(theme.colors.semantic.stroke, lineWidth: style.borderWidth)
                }
            .shadow(color: elevation.color, radius: elevation.radius, x: elevation.x, y: elevation.y)
            .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
        }
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: accessibilityLabel,
            hint: accessibilityHint,
            traits: accessibilityTraits ?? [],
            children: .combine
        )
    }
}
