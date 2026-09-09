import SwiftUI
import DaVinciTokens

// MARK: - DSRowAccessory

/// A small trailing indicator that communicates what a row does or what state it is in.
///
/// These are the accessories a list row needs often enough to be worth standardising.
/// Anything richer belongs in the row's `trailing` slot as arbitrary content.
public struct DSRowAccessory: View {

    public enum Kind: Sendable, Equatable {
        /// Chevron pointing in the reading direction — the row navigates somewhere.
        case chevron
        /// Checkmark shown when `isSelected` — the row is one of several choices.
        case selection(isSelected: Bool)
        /// Indeterminate spinner — the row is doing work.
        case activity
    }

    @Environment(\.dsTheme) private var theme

    private let kind: Kind

    public init(_ kind: Kind) {
        self.kind = kind
    }

    public var body: some View {
        switch kind {
        case .chevron:
            Image(systemName: "chevron.forward")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(theme.colors.semantic.textTertiary)
                .accessibilityHidden(true)

        case .selection(let isSelected):
            // The checkmark keeps its slot when unselected so rows do not reflow
            // as the selection moves between them.
            Image(systemName: "checkmark")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(theme.colors.accent.strokeAccent)
                .opacity(isSelected ? 1 : 0)
                .accessibilityHidden(true)

        case .activity:
            DSActivityIndicator(size: .small)
        }
    }
}

// MARK: - DSListRow

/// A list row laid out as leading / content / trailing slots.
///
/// The slots are generic, so a row can carry an icon, a colour swatch, an image or
/// nothing at all in its leading position without the type having to enumerate every
/// possibility. Presets cover the common title/subtitle and title/value shapes.
///
/// `DSListRow` is **layout only** — it does not respond to taps. Wrap it in
/// ``DSActionRow`` for a tappable row, or ``DSSelectableRow`` for one that is part of a
/// set of choices. Keeping interaction separate is what lets the same row layout serve
/// an informational row, a navigation row, a toggle row and a selection row.
///
/// ```swift
/// DSListRow(
///     leading: { Image(systemName: "globe") },
///     trailing: { DSRowAccessory(.chevron) }
/// ) {
///     DSText("Language", role: .body)
/// }
///
/// DSListRow(title: "Language", value: "English")
/// ```
///
/// ## Accessibility
///
/// The row combines its children into a single element so VoiceOver reads it as one
/// row rather than three fragments, and reserves at least
/// ``ControlHeightTokens/minimumHitTarget`` of height.
public struct DSListRow<Leading: View, Content: View, Trailing: View>: View {

    @Environment(\.dsTheme) private var theme

    private let leading: Leading
    private let content: Content
    private let trailing: Trailing
    private let accessibilityLabel: String?
    private let accessibilityValue: String?

    public init(
        accessibilityLabel: String? = nil,
        accessibilityValue: String? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing,
        @ViewBuilder content: () -> Content
    ) {
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityValue = accessibilityValue
        self.leading = leading()
        self.trailing = trailing()
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: SpacingTokens.space3) {
            leading
            content
                .frame(maxWidth: .infinity, alignment: .leading)
            trailing
        }
        .padding(.vertical, SpacingTokens.space2)
        .frame(minHeight: ControlHeightTokens.minimumHitTarget)
        .contentShape(Rectangle())
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: accessibilityLabel,
            value: accessibilityValue,
            children: .combine
        )
    }
}

// MARK: - Presets

public extension DSListRow where Leading == EmptyView, Trailing == EmptyView {

    /// A row showing a title with an optional subtitle beneath it.
    init(
        title: String,
        subtitle: String? = nil
    ) where Content == DSRowLabel {
        self.init(
            leading: { EmptyView() },
            trailing: { EmptyView() },
            content: { DSRowLabel(title: title, subtitle: subtitle) }
        )
    }
}

public extension DSListRow where Leading == EmptyView, Trailing == DSText {

    /// A row showing a title on the leading side and a value on the trailing side.
    init(
        title: String,
        value: String
    ) where Content == DSRowLabel {
        self.init(
            accessibilityLabel: title,
            accessibilityValue: value,
            leading: { EmptyView() },
            trailing: { DSText(value, role: .callout) },
            content: { DSRowLabel(title: title, subtitle: nil) }
        )
    }
}

// MARK: - DSRowLabel

/// The title and optional subtitle stack used by the row presets.
///
/// Exposed so custom rows can reuse the same title/subtitle typography and spacing
/// instead of approximating it.
public struct DSRowLabel: View {

    private let title: String
    private let subtitle: String?

    public init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space1) {
            DSText(title, role: .body)

            if let subtitle {
                DSText(subtitle, role: .footnote, color: subtitleColor)
            }
        }
    }

    @Environment(\.dsTheme) private var theme

    private var subtitleColor: Color {
        theme.colors.semantic.textSecondary
    }
}
