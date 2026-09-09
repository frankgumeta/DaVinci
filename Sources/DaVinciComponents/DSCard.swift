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
/// ## Relationship to `dsSurface`
///
/// `DSCard` is padding composed over ``DSSurfaceStyle``. When a view needs the surface
/// treatment without the card's padding — a swatch, a selection ring, a floating
/// control — apply ``SwiftUI/View/dsSurface(_:)`` directly instead of bending a card
/// into shape.
///
/// ## Topics
///
/// ### Creating Cards
/// - ``init(style:accessibilityLabel:accessibilityHint:accessibilityTraits:content:)``
public struct DSCard<Content: View>: View {

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

    public var body: some View {
        content
            .padding(style.padding)
            .dsSurface(surfaceStyle)
            .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    /// The card preset expressed as a surface.
    ///
    /// `DSCard` is layout (padding) composed over a surface; the surface itself owns
    /// shape, fill, stroke and elevation.
    internal var surfaceStyle: DSSurfaceStyle {
        DSSurfaceStyle(
            shape: .roundedRectangle(cornerRadius: style.cornerRadius),
            fill: .primary,
            stroke: style.borderWidth > 0
                ? DSSurfaceStroke(fill: .semantic, width: style.borderWidth)
                : nil,
            elevation: style.elevation
        )
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
