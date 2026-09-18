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
/// DSText("Welcome to DaVinci", role: .titleMedium)
/// DSText("A modern design system", role: .body)
/// ```
///
/// ## Typography Roles
///
/// The scale has five families:
///
/// - **Display**: `display` — largest text, for hero sections (34pt, bold)
/// - **Title**: `titleLarge` / `titleMedium` / `titleSmall` — document hierarchy (28/24/20pt, bold)
/// - **Heading**: `headline` / `subheadline` — headers within content (20pt semibold / 15pt regular)
/// - **Body**: `body` / `callout` / `footnote` / `caption` — reading text (16/14/13/12pt, regular)
/// - **Label**: `labelLarge` / `labelMedium` / `labelSmall` — control text (16/14/12pt, medium)
///
/// `overline` is a utility role for all-caps eyebrow labels (11pt, semibold).
///
/// Use a **label** role for text inside a control — buttons, chips, badges, form labels.
/// Labels are single-line, tightly leaded and slightly heavier, which keeps them legible
/// at small sizes and on coloured backgrounds where body text reads too thin.
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
/// - ``init(_:role:color:accessibilityLabel:accessibilityTraits:)-(String,_,_,_,_)``
/// - ``init(_:role:color:accessibilityLabel:accessibilityTraits:)-(AttributedString,_,_,_,_)``
///
/// ### Text Roles
/// - ``Role``
public struct DSText: View {

    /// Semantic role that determines typography style.
    public enum Role: String, CaseIterable, Sendable {
        // Display
        /// Largest text for hero sections (34pt, bold).
        case display

        // Title
        /// Highest title level (28pt, bold).
        case titleLarge
        /// Page titles and major headings (24pt, bold).
        case titleMedium
        /// Subsection titles (20pt, bold).
        case titleSmall

        // Heading
        /// Section headers inside flowing content (20pt, semibold).
        case headline
        /// Secondary header, supporting a `headline` (15pt, regular).
        case subheadline

        // Body
        /// Default body text (16pt, regular).
        case body
        /// Emphasized body text (14pt, regular).
        case callout
        /// Ancillary body text, such as disclaimers (13pt, regular).
        case footnote
        /// Small supporting text (12pt, regular).
        case caption

        // Label
        /// Control text for large controls (16pt, medium).
        case labelLarge
        /// Control text for default controls (14pt, medium).
        case labelMedium
        /// Control text for compact controls and badges (12pt, medium).
        case labelSmall

        // Utility
        /// All-caps eyebrow labels (11pt, semibold).
        case overline
    }

    @Environment(\.dsTheme) private var theme

    /// What the text renders: either a plain string or an attributed one.
    internal enum Content: Equatable, Sendable {
        case plain(String)
        case attributed(AttributedString)
    }

    private let content: Content
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
        self.content = .plain(content)
        self.role = role
        self.color = color
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityTraits = accessibilityTraits
    }

    /// Creates text from an `AttributedString`, preserving its inline attributes.
    ///
    /// The role's font and the resolved colour are merged in as a *baseline* only:
    /// any attribute the string already carries wins. Inline bold and italic, explicit
    /// colours, and links therefore survive, while unstyled runs pick up the semantic
    /// typography of the role.
    ///
    /// ```swift
    /// var text = AttributedString("Audio by Kenneth. See the license.")
    /// if let range = text.range(of: "license") {
    ///     text[range].link = URL(string: "https://example.com/license")
    /// }
    /// DSText(text, role: .footnote)
    /// ```
    public init(
        _ content: AttributedString,
        role: Role = .body,
        color: Color? = nil,
        accessibilityLabel: String? = nil,
        accessibilityTraits: AccessibilityTraits? = nil
    ) {
        self.content = .attributed(content)
        self.role = role
        self.color = color
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityTraits = accessibilityTraits
    }

    public var body: some View {
        let style = textStyle
        let resolvedColor = color ?? theme.colors.semantic.textPrimary

        return Group {
            switch content {
            case .plain(let string):
                Text(string)
                    .dsTextStyle(style, family: theme.typography.family)
                    .foregroundStyle(resolvedColor)

            case .attributed(let attributed):
                // The font and colour are merged into the string rather than applied to the
                // view, because `.font()` and `.foregroundStyle()` would override the
                // per-run attributes the caller set.
                Text(
                    Self.styled(
                        attributed,
                        style: style,
                        family: theme.typography.family,
                        color: resolvedColor
                    )
                )
                .dsLineSpacing(style)
            }
        }
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    /// Merges the role's typography and colour into `attributed` as a baseline.
    ///
    /// Uses `.keepCurrent`, so attributes already present on a run are never replaced.
    /// Link runs without an explicit colour are left uncoloured: SwiftUI only applies
    /// its link tint to runs with no foreground colour of their own.
    nonisolated internal static func styled(
        _ attributed: AttributedString,
        style: DSTextStyle,
        family: FontFamily,
        color: Color
    ) -> AttributedString {
        var result = attributed
        var fontBaseline = AttributeContainer()
        fontBaseline.font = style.font(family: family)
        result.mergeAttributes(fontBaseline, mergePolicy: .keepCurrent)

        var colorBaseline = AttributeContainer()
        colorBaseline.foregroundColor = color
        let plainRanges = result.runs.filter { $0.link == nil }.map(\.range)
        for range in plainRanges {
            result[range].mergeAttributes(colorBaseline, mergePolicy: .keepCurrent)
        }
        return result
    }

    // MARK: - Accessibility

    internal var resolvedAccessibilityTraits: AccessibilityTraits? {
        if let accessibilityTraits = accessibilityTraits {
            return accessibilityTraits
        }

        // Auto-apply header trait for title and headline roles
        switch role {
        case .display, .titleLarge, .titleMedium, .titleSmall, .headline:
            return .isHeader
        default:
            return nil
        }
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: accessibilityLabel,
            traits: resolvedAccessibilityTraits ?? []
        )
    }

    // MARK: - Private

    internal var textStyle: DSTextStyle {
        Self.textStyle(for: role, theme: theme)
    }

    nonisolated internal static func textStyle(for role: Role, theme: DSTheme) -> DSTextStyle {
        switch role {
        case .display:     theme.typography.display
        case .titleLarge:  theme.typography.titleLarge
        case .titleMedium: theme.typography.titleMedium
        case .titleSmall:  theme.typography.titleSmall
        case .headline:    theme.typography.headline
        case .subheadline: theme.typography.subheadline
        case .body:        theme.typography.body
        case .callout:     theme.typography.callout
        case .footnote:    theme.typography.footnote
        case .caption:     theme.typography.caption
        case .labelLarge:  theme.typography.labelLarge
        case .labelMedium: theme.typography.labelMedium
        case .labelSmall:  theme.typography.labelSmall
        case .overline:    theme.typography.overline
        }
    }

}
