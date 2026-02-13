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
/// Three preset styles are available via `DSCardStyle`:
///
/// - **Compact**: Tight padding (12pt), no shadow, small radius (10pt)
/// - **Standard**: Default padding (16pt), small shadow, medium radius (14pt)
/// - **Prominent**: Generous padding (20pt), medium shadow, large radius (20pt)
///
/// ```swift
/// DSCard(style: .compact) { /* content */ }
/// DSCard(style: .standard) { /* content */ }  // default
/// DSCard(style: .prominent) { /* content */ }
/// ```
///
/// ## Topics
///
/// ### Creating Cards
/// - ``init(style:content:)``
///
/// ### Card Styles
/// - ``DSCardStyle``
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

    public var body: some View {
        let elevation = style.elevation
        content
            .padding(style.padding)
            .background(theme.colors.semantic.surfacePrimary)
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            .shadow(color: elevation.color, radius: elevation.radius, x: elevation.x, y: elevation.y)
            .accessibilityElement(children: .combine)
            .modifier(AccessibilityLabelModifier(label: accessibilityLabel))
            .modifier(AccessibilityHintModifier(hint: accessibilityHint))
            .modifier(AccessibilityTraitsModifier(traits: accessibilityTraits))
    }
}

// MARK: - Previews

#Preview("DSCard — Styles") {
    VStack(spacing: 16) {
        DSCard(style: .compact) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Compact").font(.headline)
                Text("Tighter padding, no shadow.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Standard").font(.headline)
                Text("Default card style.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .prominent) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Prominent").font(.headline)
                Text("Generous padding, medium shadow.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    .padding()
}

#Preview("DSCard — Dark") {
    VStack(spacing: 16) {
        DSCard(style: .compact) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Compact").font(.headline)
                Text("Tighter padding, no shadow.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .standard) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Standard").font(.headline)
                Text("Default card style.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        DSCard(style: .prominent) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Prominent").font(.headline)
                Text("Generous padding, medium shadow.").font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSCard — Accessibility") {
    VStack(spacing: 16) {
        DSCard(
            style: .standard,
            accessibilityLabel: "Product card",
            accessibilityHint: "Double tap to view product details"
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Premium Headphones").font(.headline)
                Text("$299.99").font(.body).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        DSCard(
            style: .standard,
            accessibilityLabel: "Settings card",
            accessibilityTraits: .isButton
        ) {
            HStack {
                Image(systemName: "gear")
                Text("Account Settings").font(.body)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
        }
    }
    .padding()
}

// MARK: - Accessibility Modifiers

private struct AccessibilityLabelModifier: ViewModifier {
    let label: String?
    
    func body(content: Content) -> some View {
        if let label = label {
            content.accessibilityLabel(label)
        } else {
            content
        }
    }
}

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

private struct AccessibilityTraitsModifier: ViewModifier {
    let traits: AccessibilityTraits?
    
    func body(content: Content) -> some View {
        if let traits = traits {
            content.accessibilityAddTraits(traits)
        } else {
            content
        }
    }
}
