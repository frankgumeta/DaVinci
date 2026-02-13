import SwiftUI
import DaVinciTokens

// MARK: - DSText

/// A themed text component that maps semantic roles to typography tokens.
///
/// `DSText` provides a type-safe way to apply typography styles from your theme.
/// Instead of manually setting font sizes and weights, use semantic roles that
/// automatically adapt to your theme's typography scale.
///
/// ## Usage
///
/// ```swift
/// DSText("Welcome to DaVinci", role: .title)
/// DSText("A modern design system", role: .body)
/// ```
///
/// ## Typography Roles
///
/// - **Display**: Largest text, for hero sections (34pt, bold)
/// - **Title**: Page titles and major headings (24pt, bold)
/// - **Headline**: Section headers (20pt, semibold)
/// - **Body**: Default body text (16pt, regular)
/// - **Callout**: Emphasized body text (14pt, regular)
/// - **Caption**: Small supporting text (12pt, regular)
/// - **Overline**: All-caps labels (11pt, semibold)
///
/// ## Custom Colors
///
/// By default, text uses `theme.colors.semantic.textPrimary`. Override with a custom color:
///
/// ```swift
/// DSText("Error message", role: .body, color: theme.colors.feedback.error)
/// DSText("Success!", role: .headline, color: theme.colors.feedback.success)
/// ```
///
/// ## Accessibility
///
/// Text automatically supports Dynamic Type and scales with user preferences.
/// The semantic roles ensure proper visual hierarchy for screen readers.
///
/// ## Topics
///
/// ### Creating Text
/// - ``init(_:role:color:)``
///
/// ### Text Roles
/// - ``Role``
public struct DSText: View {

    /// Semantic role that determines typography style.
    public enum Role: Sendable {
        /// Largest text for hero sections (34pt, bold).
        case display
        /// Page titles and major headings (24pt, bold).
        case title
        /// Section headers (20pt, semibold).
        case headline
        /// Default body text (16pt, regular).
        case body
        /// Emphasized body text (14pt, regular).
        case callout
        /// Small supporting text (12pt, regular).
        case caption
        /// All-caps labels (11pt, semibold).
        case overline
    }

    @Environment(\.dsTheme) private var theme

    private let content: String
    private let role: Role
    private let color: Color?
    private let accessibilityLabel: String?
    private let accessibilityTraits: AccessibilityTraits?

    public init(
        _ content: String,
        role: Role = .body,
        color: Color? = nil,
        accessibilityLabel: String? = nil,
        accessibilityTraits: AccessibilityTraits? = nil
    ) {
        self.content = content
        self.role = role
        self.color = color
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityTraits = accessibilityTraits
    }

    public var body: some View {
        Text(content)
            .font(resolvedFont)
            .foregroundStyle(color ?? theme.colors.semantic.textPrimary)
            .modifier(AccessibilityLabelModifier(label: accessibilityLabel))
            .modifier(AccessibilityTraitsModifier(traits: resolvedAccessibilityTraits))
    }
    
    // MARK: - Accessibility
    
    private var resolvedAccessibilityTraits: AccessibilityTraits? {
        if let accessibilityTraits = accessibilityTraits {
            return accessibilityTraits
        }
        
        // Auto-apply header trait for title and headline roles
        switch role {
        case .display, .title, .headline:
            return .isHeader
        default:
            return nil
        }
    }

    // MARK: - Private

    private var textStyle: DSTextStyle {
        switch role {
        case .display:  theme.typography.display
        case .title:    theme.typography.title
        case .headline: theme.typography.headline
        case .body:     theme.typography.body
        case .callout:  theme.typography.callout
        case .caption:  theme.typography.caption
        case .overline: theme.typography.overline
        }
    }

    private var resolvedFont: Font {
        textStyle.font(family: theme.typography.family)
    }
}

// MARK: - Previews

#Preview("DSText — All Roles") {
    VStack(alignment: .leading, spacing: 8) {
        DSText("Display", role: .display)
        DSText("Title", role: .title)
        DSText("Headline", role: .headline)
        DSText("Body text", role: .body)
        DSText("Callout text", role: .callout)
        DSText("Caption text", role: .caption)
        DSText("OVERLINE", role: .overline)
    }
    .padding()
}

#Preview("DSText — Accessibility") {
    VStack(alignment: .leading, spacing: 16) {
        DSText("Page Title", role: .title)
        // Automatically marked as .isHeader
        
        DSText("Section Heading", role: .headline)
        // Automatically marked as .isHeader
        
        DSText(
            "Important Notice",
            role: .body,
            color: .red,
            accessibilityLabel: "Alert: Important Notice",
            accessibilityTraits: .isStaticText
        )
        
        DSText("Regular body text", role: .body)
        // Default static text, no special traits
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
